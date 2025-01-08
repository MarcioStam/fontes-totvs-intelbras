/******************************************************************************
** Programa: 
** Data....: 
** Autor...: 
** Objetivo: 
*******************************************************************************/
{include/i-prgvrs.i "ESFTP071" 2.00.00.001} 

/*-------------------------- Defini»’o temp-table ----------------------------*/
    {utp/utapi019.i}
    {esapi/esapi010tt.i}
    {cdp/cd0666.i}
   
def temp-table tt-raw-digita
    field raw-digita as raw.
      
/*----------------------- Recebimento de parametros --------------------------*/
def input parameter raw-param as raw no-undo. 
def input parameter table for tt-raw-digita.   
DEFINE VARIABLE c-cod-estabelecimento   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-tipo-servico-correios AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-primeira-sequencia    AS DEC         NO-UNDO.
DEFINE VARIABLE i-proxima-sequencia     AS DEC         NO-UNDO.
DEFINE VARIABLE i-ultima-sequencia      AS dec         NO-UNDO.
DEFINE VARIABLE v-val-frete             AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-nro-contrato          AS char        NO-UNDO.
DEFINE VARIABLE i-cod-administrativo    AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-pasta-arquivo         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-ultimo-vol            AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-unid-postagem         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-unid-postagem    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cep-unid-postagem     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-impressora-zebra      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE vArqMail                AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-email-correio         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-sequencia-aviso       AS DEC         NO-UNDO.
DEFINE VARIABLE c-prefixo-codigo        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE r-rowid-int-nota-conhec AS ROWID       NO-UNDO.
define variable hDoc                    as handle no-undo.
define variable hRoot                   as handle no-undo.
define variable hAux1                   as handle no-undo.
define variable hAux2                   as handle no-undo.
define variable hAux3                   as handle no-undo.
define variable xmlParam                as handle no-undo.
define variable xmlText                 as handle no-undo.
DEFINE VARIABLE h-escrm001api           AS HANDLE      NO-UNDO.
DEFINE VARIABLE l-rastreio              AS LOG    NO-UNDO.

DEFINE VARIABLE l-novo-documento AS LOGICAL   NO-UNDO.
DEFINE VARIABLE h-cdapi704       AS HANDLE    NO-UNDO.
DEFINE VARIABLE cMensagem        AS CHARACTER NO-UNDO.

DEF VAR vtexto       AS CHARACTER.
DEF VAR vcodigo128   AS CHARACTER.
DEF VAR c-cod-barras AS CHARACTER.
DEF VAR i-1          AS INTEGER.
DEF VAR i-2          AS INTEGER.
DEF VAR i-3          AS INTEGER.
DEF VAR i-4          AS INTEGER.
DEF VAR i-5          AS INTEGER.
DEF VAR i-6          AS INTEGER.
DEF VAR i-7          AS INTEGER.
DEF VAR i-8          AS INTEGER.
DEF VAR de-dv        AS DECIMAL.
DEF VAR i-resto      AS INTEGER.
DEF VAR i-dv         AS INTEGER.

DEFINE VARIABLE c-endereco  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-rua       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-nro       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-comp      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-obs       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-arq-tmp   AS CHARACTER   NO-UNDO.

DEF BUFFER b-volume-nf            for volume-nf.
DEF BUFFER b-int-ped-venda-conhec FOR int-ped-venda.

DEF STREAM s-arq-email.
DEF STREAM s-relatorio.

DEFINE TEMP-TABLE tt-volume-nf  LIKE volume-nf.
     

DEFINE TEMP-TABLE tt-import NO-UNDO
    FIELD cnpj        AS CHAR
    FIELD serie       AS CHAR
    FIELD nr-nota-fis AS CHAR
    FIELD ds-chave    AS CHAR
    FIELD codigo      AS CHAR
    FIELD indefinido1 AS CHAR FORMAT "x(100)"
    FIELD indefinido2 AS CHAR FORMAT "x(100)"
    FIELD indefinido3 AS CHAR FORMAT "x(100)"
    FIELD iLinha      AS INT
    FIELD FullPath    AS CHAR
    FIELD FILENAME    AS CHAR
    INDEX ch_principal cnpj serie nr-nota-fis.

define temp-table tt-param no-undo                               
    field destino            as integer                                   
    field arquivo            as char format "x(35)"                       
    field usuario            as char format "x(12)"                       
    field data-exec          as date                                      
    field hora-exec          as integer                                   
    field codEstabel         as char                                      
    field cSerie             as char                                      
    field cNrNotaFis-ini     as char                                  
    field cNrNotaFis-fim     as CHAR     
    field Nr-embarque-ini   as INTEGER
    field Nr-embarque-fim   AS INTEGER                                   
    FIELD da-dt-emissao-ini  AS DATE                                  
    FIELD da-dt-emissao-fim  AS DATE                                  
    FIELD reimprime-etiqueta AS LOGICAL
    field nr-cartao-sedex    as char
    field nr-cartao-pac      as char.

FORM nota-fiscal.cep
     int-nota-conhec.nr-conhec FORMAT "x(13)" COLUMN-LABEL "N.Objeto"
     nota-fiscal.nr-nota-fis
     emitente.nome-emit COLUMN-LABEL "Destinatario" 
WITH FRAME f-detalhe WIDTH 170 64 DOWN STREAM-IO.

create tt-param.
raw-transfer raw-param to tt-param.    
   
/*-------------- include padrÊo para variÿveis de relat«rio ------------------*/
{include/i-rpvar.i}

{include/tt-edit.i}
{include/i-freeac.i} /* Retira os acentos */

def var h-acomp         as handle no-undo. 

DEFINE VARIABLE i-cont            AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-cont2           AS INTEGER    NO-UNDO.

/*-------------------------- Definicao de variaveis --------------------------*/
{utp/ut-glob.i}

DEFINE VARIABLE entrou    AS LOGICAL INITIAL NO         NO-UNDO.

/*--------- include com a defini»’o da frame de cabe»alho e rodap² -----------*/
{include/i-rpcab.i} 
    FIND estabelec
         WHERE estabelec.cod-estabel = tt-param.codestabel NO-LOCK NO-ERROR.

/*---------------- include padrÊo para output de relat«rios ------------------*/
{include/i-rpout.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

ASSIGN c-arq-tmp = c-dir-arquivo-session + "rel.txt".

OUTPUT STREAM s-relatorio TO VALUE(c-arq-tmp).

/*------------------- bloco principal do programa ----------------------------*/
FIND FIRST tt-param NO-LOCK NO-ERROR.

ASSIGN c-empresa      = "INTELBRAS"
       c-programa     = "ESFTP071"
       c-titulo-relat = "Etiqueta Correios"
       c-sistema      = "Faturamento"
       c-versao       = "2.04"
       c-revisao      = "00.001".

run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Imprimindo *}
run pi-inicializar in h-acomp (input "Processando...").
VIEW STREAM s-relatorio FRAME f-cabec.
VIEW STREAM s-relatorio FRAME f-rodape.
VIEW STREAM s-relatorio FRAME f-rodape-2.


RUN pi-acompanhar in h-acomp ("Carregando...").

FIND FIRST param-correios
    WHERE param-correios.cod-estabel = tt-param.codEstabel
      AND param-correios.tp-servico  = "PAC":U NO-LOCK NO-ERROR.

IF AVAILABLE param-correios THEN
    RUN PI-GERA-ETIQUETA.

FIND FIRST param-correios
    WHERE param-correios.cod-estabel = tt-param.codEstabel
      AND param-correios.tp-servico  = "SEDEX":U NO-LOCK NO-ERROR.

IF AVAILABLE param-correios THEN
    RUN PI-GERA-ETIQUETA.

FIND FIRST param-correios
    WHERE param-correios.cod-estabel = tt-param.codEstabel
      AND param-correios.tp-servico  = "E-SEDEX":U NO-LOCK NO-ERROR.

IF AVAILABLE param-correios THEN
    RUN PI-GERA-ETIQUETA.

FIND FIRST param-correios
    WHERE param-correios.cod-estabel = tt-param.codEstabel
      AND param-correios.tp-servico  = "SEDEX MG":U NO-LOCK NO-ERROR.

IF AVAILABLE param-correios THEN
    RUN PI-GERA-ETIQUETA.

FIND FIRST param-correios
    WHERE param-correios.cod-estabel = tt-param.codEstabel
      AND param-correios.tp-servico  = "SEDEX 10":U NO-LOCK NO-ERROR.

IF AVAILABLE param-correios THEN
    RUN PI-GERA-ETIQUETA.

FIND FIRST param-correios
    WHERE param-correios.cod-estabel = tt-param.codEstabel
      AND param-correios.tp-servico  = "SEDEX 12":U NO-LOCK NO-ERROR.

IF AVAILABLE param-correios THEN
    RUN PI-GERA-ETIQUETA.

OUTPUT STREAM s-relatorio CLOSE.


RUN pi-finalizar in h-acomp.


{include/i-rpclo.i}
DOS SILENT  notepad c:\temp\rel.txt.

RETURN "OK":U.


PROCEDURE PI-GERA-ETIQUETA:
   define variable c-conhec as character no-undo.
   define variable iPedidoCodigo as integer no-undo.
   define buffer b-nota-fiscal for nota-fiscal.
   define buffer b-ped-venda for ped-venda.
   define buffer b-int-nota-conhec for int-nota-conhec.

    ASSIGN c-cod-estabelecimento   = param-correios.cod-estabel
           c-tipo-servico-correios = param-correios.tp-servico
           i-primeira-sequencia    = param-correios.seq-inicial
           i-proxima-sequencia     = param-correios.seq-proxima
           i-ultima-sequencia      = param-correios.seq-final
           c-nro-contrato          = param-correios.nr-contrato 
           i-cod-administrativo    = param-correios.cod-admin
           c-pasta-arquivo         = param-correios.dir-grav-xml
           c-unid-postagem         = param-correios.cod-un-postagem
           c-desc-unid-postagem    = param-correios.des-un-postagem
           c-cep-unid-postagem     = param-correios.cep-un-postagem
           c-impressora-zebra      = param-correios.imp-etiqueta
           c-email-correio         = param-correios.e-mail-env-xml
           i-sequencia-aviso       = param-correios.seq-aviso
           c-prefixo-codigo        = param-correios.prefix-tp-servico.

    RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.

/*     OUTPUT STREAM s-etiqueta TO value(c-impressora-zebra).  */
       
    IF (i-ultima-sequencia - i-proxima-sequencia) <= i-sequencia-aviso THEN DO:
        RUN pi-envia-email-Estouro.
        PUT STREAM s-relatorio "********** ATENCAO *********** " SKIP
            "FALTAM " TRIM(STRING(i-ultima-sequencia - i-proxima-sequencia))
            " SEQUENCIAS PARA ESTOURAR A NUMERACAO DE AUTORIZACAO DE POSTAGEM ELETRONICA, ENTRE EM CONTATO COM O CORREIO " SKIP
            "PARA SOLICITAR UMA NOVA SEQUENCIA" SKIP
            "PROXIMA SEQUENCIA : " STRING(i-proxima-sequencia) SKIP
            "SEQUENCIA FINAL   : " STRING(i-ultima-sequencia)  SKIP(1).
    END.

    FOR EACH  nota-fiscal no-LOCK
        WHERE nota-fiscal.cod-estabel   = tt-param.codestabel
          AND nota-fiscal.serie         = tt-param.cSerie
          AND nota-fiscal.nr-nota-fis  >= tt-param.cNrNotaFis-ini
          AND nota-fiscal.nr-nota-fis  <= tt-param.cNrNotaFis-fim
          AND nota-fiscal.dt-emis-nota >= tt-param.da-dt-emissao-ini
          AND nota-fiscal.dt-emis-nota <= tt-param.da-dt-emissao-fim
          AND nota-fiscal.cdd-embarq  >= tt-param.nr-embarque-ini
          AND nota-fiscal.cdd-embarq  <= tt-param.nr-embarque-fim
          AND nota-fiscal.nome-transp   = c-tipo-servico-correios
          AND nota-fiscal.dt-cancela    = ?:
        FOR EACH tt-volume-nf:
            DELETE tt-volume-nf.
        END.

        IF CAN-FIND(FIRST volume-nf
                          WHERE volume-nf.cod-estabel     = nota-fiscal.cod-estabel
                            AND volume-nf.serie           = nota-fiscal.serie
                            AND volume-nf.nr-nota-fis     = nota-fiscal.nr-nota-fis) THEN DO:
            FOR EACH volume-nf NO-LOCK
                WHERE volume-nf.cod-estabel     = nota-fiscal.cod-estabel
                  AND volume-nf.serie           = nota-fiscal.serie
                  AND volume-nf.nr-nota-fis     = nota-fiscal.nr-nota-fis
                BREAK BY volume-nf.nr-volume:
                IF FIRST-OF(volume-nf.nr-volume) THEN DO:
                    CREATE tt-volume-nf.
                    BUFFER-COPY volume-nf TO tt-volume-nf.
                END.
            END.
        END.
        ELSE DO:
            CREATE tt-volume-nf.
            ASSIGN tt-volume-nf.cod-estabel     = nota-fiscal.cod-estabel 
                   tt-volume-nf.serie           = nota-fiscal.serie       
                   tt-volume-nf.nr-nota-fis     = nota-fiscal.nr-nota-fis
                   tt-volume-nf.nr-volume       = 1.
        END.

        FOR EACH tt-volume-nf NO-LOCK
            WHERE tt-volume-nf.cod-estabel     = nota-fiscal.cod-estabel
              AND tt-volume-nf.serie           = nota-fiscal.serie
              AND tt-volume-nf.nr-nota-fis     = nota-fiscal.nr-nota-fis:

            RUN pi-acompanhar IN h-acomp (INPUT 'Gerando Integra»’o com Correios ' + nota-fiscal.nr-nota-fis).
    
            FIND LAST b-volume-nf USE-INDEX volume-nf
                WHERE b-volume-nf.cod-estabel = nota-fiscal.cod-estabel
                  AND b-volume-nf.serie       = nota-fiscal.serie
                  AND b-volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
            IF AVAIL b-volume-nf THEN
                ASSIGN i-ultimo-vol = b-volume-nf.nr-volume.
            ELSE
                ASSIGN i-ultimo-vol = 1.
    
            FIND FIRST int-nota-conhec
                 WHERE int-nota-conhec.cod-estabel = nota-fiscal.cod-estabel    
                   AND int-nota-conhec.serie       = nota-fiscal.serie          
                   AND int-nota-conhec.nr-nota-fis = nota-fiscal.nr-nota-fis
                   AND int-nota-conhec.nr-volume   = tt-volume-nf.nr-volume NO-LOCK NO-ERROR.
     
            ASSIGN l-novo-documento        = NO
                   r-rowid-int-nota-conhec = ?.

            IF  AVAIL int-nota-conhec
            THEN
                ASSIGN r-rowid-int-nota-conhec = ROWID(int-nota-conhec).
    
            IF  tt-param.reimprime-etiqueta = NO
            THEN DO:
                IF NOT AVAIL int-nota-conhec                            OR 
                      (AVAIL int-nota-conhec                           AND
                             int-nota-conhec.nr-conhec           = ""  AND 
/*                              int-nota-conhec.centro-custo-frete <> ""  AND */
                             int-nota-conhec.peso-bruto         <>  0)
                THEN DO:
                    ASSIGN i-proxima-sequencia = i-proxima-sequencia + 1.
    
                    IF i-proxima-sequencia > i-ultima-sequencia THEN DO:
                       PUT STREAM s-relatorio  "********** ATENCAO *********** " SKIP
                            "ESTOUROU A NUMERACAO DE AUTORIZACAO DE POSTAGEM ELETRONICA, ENTRE EM CONTATO COM O CORREIO " SKIP
                            "SEQUENCIA INICIAL : " STRING(i-primeira-sequencia) SKIP
                            "SEQUENCIA FINAL   : " STRING(i-ultima-sequencia)   SKIP.
                        
                        
                        RETURN.
                    END.
    
                    ASSIGN l-novo-documento = YES.
    
                    IF NOT AVAIL int-nota-conhec THEN DO:
                        CREATE int-nota-conhec.
                    END.
                    FIND CURRENT int-nota-conhec EXCLUSIVE-LOCK NO-ERROR.

                    ASSIGN c-cod-barras = string(i-proxima-sequencia,"99999999")
                          i-1          = int(substring(c-cod-barras,1,1)) * 8
                          i-2          = int(substring(c-cod-barras,2,1)) * 6
                          i-3          = int(substring(c-cod-barras,3,1)) * 4
                          i-4          = int(substring(c-cod-barras,4,1)) * 2
                          i-5          = int(substring(c-cod-barras,5,1)) * 3
                          i-6          = int(substring(c-cod-barras,6,1)) * 5
                          i-7          = int(substring(c-cod-barras,7,1)) * 9
                          i-8          = int(substring(c-cod-barras,8,1)) * 7.
    
                    ASSIGN de-dv         = (i-1 + i-2 + i-3 + i-4 + i-5 + i-6 + i-7 + i-8)
                           i-resto      = de-dv MOD 11.
    
                    IF i-resto = 0 THEN
                       ASSIGN i-dv = 5.
                    ELSE
                        IF i-resto = 1 THEN
                           ASSIGN i-dv = 0.
                        ELSE
                           ASSIGN i-dv = 11 - i-resto.
    
                    ASSIGN c-cod-barras                         = c-prefixo-codigo + TRIM(c-cod-barras + STRING(i-dv,"9")) + "BR"
                           int-nota-conhec.nr-conhec            = c-cod-barras
                           int-nota-conhec.dat-1                = TODAY. /* Data Gera»’o Etiqueta */
                           overlay(int-nota-conhec.char-1,1,10) = c-seg-usuario.

                    IF  NEW(int-nota-conhec) 
                    THEN DO:
                        ASSIGN int-nota-conhec.cod-estabel = nota-fiscal.cod-estabel      
                               int-nota-conhec.serie       = nota-fiscal.serie            
                               int-nota-conhec.nr-nota-fis = nota-fiscal.nr-nota-fis 
                               int-nota-conhec.nr-volume   = tt-volume-nf.nr-volume
                               int-nota-conhec.nr-conhec   = c-cod-barras.
                        IF c-tipo-servico-correios = "SEDEX"    OR 
                           c-tipo-servico-correios = "SEDEX MG" OR 
                           c-tipo-servico-correios = "E-SEDEX"  OR
                           c-tipo-servico-correios = "SEDEX 10" OR
                           c-tipo-servico-correios = "SEDEX 12" 
                        THEN
                           ASSIGN int-nota-conhec.nr-cartao = tt-param.nr-cartao-sedex.
                        ELSE
                            IF c-tipo-servico-correios = "PAC" THEN
                               ASSIGN int-nota-conhec.nr-cartao = tt-param.nr-cartao-pac.
                    END.

                    /** Tarefa 37208: copiar rotina do esftp053, para atualizar os pedidos na Ikeda **/
                    assign iPedidoCodigo = 0
                           c-conhec      = ''.

                    find ped-venda no-lock
                       where ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                         and ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli no-error.
                    if available ped-venda then do:
                       find int-ped-venda EXCLUSIVE-LOCK
                          where int-ped-venda.cod-estabel = ped-venda.cod-estabel
                            and int-ped-venda.nr-pedido   = ped-venda.nr-pedido no-error.
                       if available int-ped-venda then
                          assign iPedidoCodigo = int-ped-venda.PedidoCodigo.
                       ELSE DO:
                           FIND int-ped-venda
                                WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido EXCLUSIVE-LOCK NO-ERROR.
                           if available int-ped-venda then
                              assign iPedidoCodigo = int-ped-venda.PedidoCodigo.
                       END.
                       IF AVAIL int-ped-venda THEN DO:
                           assign int-ped-venda.atualizaIkeda = yes.
                       END.

                       
                       if iPedidoCodigo > 0 then do:
                          for each int-ped-venda no-lock
                             where int-ped-venda.PedidoCodigo = iPedidoCodigo,
                             first b-ped-venda no-lock
                                where b-ped-venda.cod-estabel = int-ped-venda.cod-estabel
                                  and b-ped-venda.nr-pedido   = int-ped-venda.nr-pedido:

                             for each b-nota-fiscal no-lock
                                where b-nota-fiscal.nome-ab-cli = b-ped-venda.nome-abrev
                                  and b-nota-fiscal.nr-pedcli   = b-ped-venda.nr-pedcli,
                                each b-int-nota-conhec of b-nota-fiscal no-lock:
                             
                                if c-conhec = '' then
                                   assign c-conhec = b-int-nota-conhec.nr-conhec.
                                else
                                   assign c-conhec = c-conhec + ', ' + b-int-nota-conhec.nr-conhec.
                             end.
                          end.

                          for each int-ped-venda NO-LOCK
                             where int-ped-venda.PedidoCodigo = iPedidoCodigo:

                              FIND b-int-ped-venda-conhec EXCLUSIVE-LOCK
                                  WHERE ROWID(b-int-ped-venda-conhec) = ROWID(int-ped-venda) NO-ERROR.

                              IF  AVAIL b-int-ped-venda-conhec
                              THEN DO:
                                  ASSIGN  b-int-ped-venda-conhec.Sedex = c-conhec.
                                  RELEASE b-int-ped-venda-conhec.
                              END.
                          end.
                       end.
                    end.
                    RELEASE int-ped-venda.
                    RELEASE b-int-ped-venda-conhec.
                    release ped-venda.

                    ASSIGN r-rowid-int-nota-conhec = ROWID(int-nota-conhec).
                    RELEASE int-nota-conhec.
                END.
            END.
            
            FIND int-nota-conhec NO-LOCK
                 WHERE rowid(int-nota-conhec) = r-rowid-int-nota-conhec NO-ERROR.

            IF AVAIL int-nota-conhec 
            THEN DO:
                FIND FIRST emitente WHERE 
                           emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.
    
                IF l-novo-documento THEN DO:
                    /* Reatualiza parametros */
                    FIND FIRST param-correios
                        WHERE param-correios.cod-estabel = c-cod-estabelecimento
                          AND param-correios.tp-servico  = c-tipo-servico-correios exclusive-LOCK NO-ERROR.
    
                    IF AVAILABLE param-correios THEN
                        ASSIGN param-correios.seq-proxima = i-proxima-sequencia.
                END.
    
                /**** Imprime Etiqueta *******************************************************************************************/
                IF  tt-param.reimprime-etiqueta = YES AND
                    l-novo-documento            = NO  AND
                    int-nota-conhec.nr-conhec  <> ""
                THEN
                    RUN pi-imprime-etiqueta.

                IF  tt-param.reimprime-etiqueta = NO
                THEN DO:
                    IF  l-novo-documento = YES 
                    THEN
                        RUN pi-imprime-etiqueta.

                    /* Apenas para imprimir alerta da falta de peso */
                    IF  l-novo-documento          = NO AND
                        int-nota-conhec.nr-conhec = ""
                    THEN
                        RUN pi-imprime-etiqueta.
                END.

/*                 IF l-novo-documento THEN DO:                   */
/*                    IF NOT tt-param.reimprime-etiqueta THEN DO: */
/*                        RUN pi-imprime-etiqueta.                */
/*                    END.                                        */
/*                 END.                                           */
/*                 ELSE DO:                                       */
/*                     IF tt-param.reimprime-etiqueta THEN DO:    */
/*                         RUN pi-imprime-etiqueta.               */
/*                     END.                                       */
/*                 END.                                           */

                ASSIGN l-rastreio = NO.
                FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK
                   WHERE it-nota-fisc.it-codigo = "9890001":
                    ASSIGN l-rastreio = YES.
                    LEAVE.
                END.
                IF l-rastreio THEN
                   RUN pi-envia-rastreio.
            END.
        END.
    END.

    DELETE PROCEDURE h-cdapi704.

/*------------------------ fechamento do output do relat®rio -----------------------*/ 
    
    

END PROCEDURE.


PROCEDURE pi-imprime-etiqueta:

    /* N’o imprimir a etiqueta se n’o for informado o nœmero do cart’o e o peso */
    IF  int-nota-conhec.nr-cartao  <> "" AND
        int-nota-conhec.peso-bruto <> 0
    THEN DO:
        /* Calcular frete previsto */
        FIND estabelec NO-LOCK
            WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.

        
        IF  AVAIL estabelec AND
                  int-nota-conhec.log-frete-conciliado = NO
        THEN DO:

            FIND ped-venda
                WHERE ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli 
                  AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                NO-LOCK NO-ERROR.
        
            IF AVAIL ped-venda AND
               (INDEX(ped-venda.observacoes,"Extrato:")         <> 0  OR
                INDEX(ped-venda.cond-espec,"Extrato:")          <> 0  OR
                INDEX(ped-venda.cond-espec,"pecas em garantia") <> 0) THEN DO:
                RUN esp/crm/escrm001api.p PERSISTENT SET h-escrm001api.
                RUN IntegraRastreamentoASTEC IN h-escrm001api (INPUT nota-fiscal.cod-estabel,
                                                               INPUT nota-fiscal.serie,
                                                               INPUT nota-fiscal.nr-nota-fis,
                                                               INPUT int-nota-conhec.nr-conhec).
                DELETE PROCEDURE h-escrm001api.
            END.
        END. /* IF  AVAIL estabelec */

        ASSIGN c-obs = "".

        FIND FIRST int-loc-entr
             WHERE int-loc-entr.nome-abrev  = nota-fiscal.nome-ab-cli
               AND int-loc-entr.cod-entrega = nota-fiscal.cod-entrega NO-LOCK NO-ERROR.

        IF AVAIL int-loc-entr AND
          int-loc-entr.endereco-completo <> "" THEN
            ASSIGN c-endereco = int-loc-entr.endereco-completo.
        ELSE
            ASSIGN c-endereco = IF nota-fiscal.endereco <> "" THEN nota-fiscal.endereco ELSE emitente.endereco.

        
        RUN piCargaImagem("Sedex").
        RUN piCargaImagem("E-Sedex").
        RUN piCargaImagem("Pac").
        RUN piCargaImagem("local-logo").
        RUN piCargaImagem("Sedex 10").
        RUN piCargaImagem("Sedex 12").

        PUT  "^XA"         SKIP.   /* Inicio Label */
        PUT  "^PW832"      SKIP.   /* Novo comando para zebra 600 */
        PUT  "^JUS"        SKIP.   /* Novo comando para zebra 600 */
        PUT  "^PON"        SKIP.   /* Orientacao impressora N = Normal */
        PUT  "^FWN"        SKIP.   /* Orientacao dos Campos N = Normal */
        PUT  "^LL296"      SKIP.   /* 824 ? o numero de DotÁs que formam nr colunas da etiqueta */
        PUT  "^MNY"        SKIP.    /* Papel de etiquetas contðnuo */
        PUT  "^XZ"         SKIP.  

        PUT "^XA" SKIP.
        
        PUT UNFORMATTED "^FO040,54^XGlocal-logo.GRF^FS" SKIP.
        
        PUT UNFORMATTED "^FO595,145^A0N,12,18^FD9912292295/2012/DR/SC ^FS" SKIP.  
        PUT UNFORMATTED "^FO620,160^A0N,12,18^FDINTELBRAS S.A^FS" SKIP. 
        
        IF param-correios.tp-servico = "SEDEX" OR 
           param-correios.tp-servico = "SEDEX MG" THEN
            
            PUT UNFORMATTED "^FO550,50^XGSedex.GRF^FS" SKIP.
        
        ELSE
            IF  param-correios.tp-servico = "PAC" THEN
            
                PUT UNFORMATTED "^FO555,54^XGPac.GRF^FS"  SKIP.

            ELSE
                IF  param-correios.tp-servico = "SEDEX 10" THEN
                    PUT UNFORMATTED "^FO550,50^XGSedex10.GRF^FS" SKIP.

                ELSE
                    IF  param-correios.tp-servico = "SEDEX 12" THEN
                        PUT UNFORMATTED "^FO550,50^XGSedex12.GRF^FS" SKIP.
                    
                ELSE
                    IF  param-correios.tp-servico = "E-SEDEX" THEN DO:
                        PUT UNFORMATTED "^FO550,50^XGE-Sedex.GRF^FS" SKIP.
                        
                        MESSAGE param-correios.tp-servico
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
                    END.
                

        PUT UNFORMATTED "^FO40,142^A0N,24,24^FD"  "NF.....: " nota-fiscal.nr-nota-fis + " - " + nota-fiscal.serie                                    "^FS" SKIP.
        PUT UNFORMATTED "^FO40,174^A0N,24,24^FD" "Vol....: " TRIM(string(tt-volume-nf.nr-volume,"99999")) + "/" + TRIM(string(i-ultimo-vol,"99999")) "^FS" SKIP.
        PUT UNFORMATTED "^FO40,206^A0N,30,30^FD" "Objeto.: "  TRIM(int-nota-conhec.nr-conhec)         "^FS" SKIP.
        PUT UNFORMATTED "^FO40,238^BY2.7^BCN,160,N,N,N,N^SN"  TRIM(int-nota-conhec.nr-conhec)  ",1,Y" "^FS" SKIP.  /* Codigo de Barras EAN 128 */

        PUT UNFORMATTED "^FO40,428^A0N,30,30^FD" "Destinatario"     "^FS" SKIP.
        PUT UNFORMATTED "^FO40,460^A0N,24,24^FD" emitente.nome-emit "^FS" SKIP.
        PUT UNFORMATTED "^FO40,486^A0N,24,24^FD" c-endereco         "^FS" SKIP.
        PUT UNFORMATTED "^FO40,512^A0N,24,24^FD" nota-fiscal.bairro "^FS" SKIP.
            
        PUT UNFORMATTED "^FO40,538^A0N,24,24^FD" string(nota-fiscal.cep) + " - " + trim(nota-fiscal.cidade) + "/" + nota-fiscal.estado "^FS" SKIP.
        PUT UNFORMATTED "^FO40,583^BY2.7^BCN,150,N,N,N,N^SN" nota-fiscal.cep ",1,Y" "^FS" SKIP.  /* Codigo de Barras EAN 128 */

        PUT UNFORMATTED "^FO40,753^A0N,30,30^FD" "Peso (Kg): " TRIM(STRING(int-nota-conhec.peso-bruto,">>9.999")) "^FS" SKIP. 
        PUT UNFORMATTED "^FO40,785^BY2.7^BCN,70,N,N,N,N^FD"    TRIM(STRING(int-nota-conhec.peso-bruto,">>9.999")) "^FS" SKIP.  /* Codigo de Barras EAN 128 */
            
        PUT UNFORMATTED "^FO40,875^A0N,30,30^FD" "Cartao: "  TRIM(int-nota-conhec.nr-cartao)         "^FS" SKIP.
        PUT UNFORMATTED "^FO40,950^A0N,30,30^FD"  "Remetente: "      "^FS" SKIP.
        PUT UNFORMATTED "^FO40,982^A0N,24,24^FD"  estabelec.nome     "^FS" SKIP.
        PUT UNFORMATTED "^FO40,1008^A0N,24,24^FD" estabelec.endereco "^FS" SKIP.
        PUT UNFORMATTED "^FO40,1034^A0N,24,24^FD" estabelec.bairro   "^FS" SKIP.
        PUT UNFORMATTED "^FO40,1060^A0N,24,24^FD" string(estabelec.cep) + " - " + trim(estabelec.cidade) + "/" + estabelec.estado  "^FS" SKIP. 
        PUT UNFORMATTED "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */ 
        PUT UNFORMATTED "^CD," SKIP.
        PUT UNFORMATTED "^XZ".  
        
        /**** Fim Imprime Etiqueta *******************************************************************************************/
    END. /* IF  int-nota-conhec.nr-cartao  <> "" AND */
    
    ELSE
        ASSIGN c-obs = "Nota sem peso ou nr cartao, etiqueta nao sera impressa".

    /*Limpa a imagem da impressora   */
    PUT UNFORMATTED "^XA^IDE-Sedex.GRF^FS^XZ"
                    "^XA^IDPac.GRF^FS^XZ"
                    "^XA^IDSedex.GRF^FS^XZ"
                    "^XA^IDSedex10.GRF^FS^XZ"
                    "^XA^IDlocal-logo.GRF^FS^XZ".
                    "^XA^IDSedex12.GRF^FS^XZ".
    
    /**** Imprime Relatorio *********************************************************************************************/

    DISP STREAM s-relatorio nota-fiscal.cep
         int-nota-conhec.nr-conhec COLUMN-LABEL "N.Objeto"
         nota-fiscal.nr-nota-fis
         string(tt-volume-nf.nr-volume,"99999") + "/" + string(i-ultimo-vol,"99999") FORMAT "x(11)" COLUMN-LABEL "Volumes"
         emitente.nome-emit COLUMN-LABEL "Destinatario" 
         c-obs FORMAT "x(54)" COLUMN-LABEL "Observacao"
        WITH FRAME f-detalhe.
    DOWN STREAM s-relatorio  WITH FRAME f-detalhe.

    /**** Fim Imprime Relatorio *********************************************************************************************/

END PROCEDURE.

PROCEDURE pi-envia-email-Estouro:

    CREATE tt-mail.
    ASSIGN tt-mail.Destinatario  = "anderson.cenci@intelbras.com.br,osnir.ribeiro@intelbras.com.br"
           tt-mail.Assunto       = "Postagem Correios"
           tt-mail.Mensagem      = "********** ATENCAO *********** " + CHR(10) +
                                   "FALTAM " + TRIM(STRING(i-ultima-sequencia - i-proxima-sequencia)) +
            " SEQUENCIAS PARA ESTOURAR A NUMERACAO DE AUTORIZACAO DE POSTAGEM ELETRONICA, ENTRE EM CONTATO COM OS CORREIOS (Flavio Cardoso - flavioc@correios.com.br)"  +
            " PARA SOLICITAR UMA NOVA SEQUENCIA." + CHR(10) +
            " PROXIMA SEQUENCIA : " + STRING(i-proxima-sequencia) + CHR(10) +
            " SEQUENCIA FINAL   : " + STRING(i-ultima-sequencia).
    FOR FIRST usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = c-seg-usuario:
        ASSIGN tt-mail.Remetente = usuar_mestre.cod_e_mail_local.
    END.
    IF tt-mail.Remetente = "" THEN
        ASSIGN tt-mail.Remetente = "ems@intelbras.com.br".

    RUN esapi/esapi010.p (INPUT-OUTPUT TABLE tt-mail,
                          OUTPUT TABLE tt-erro).

    FOR EACH tt-mail:
        DELETE tt-mail.
    END.

END PROCEDURE.


PROCEDURE piCargaImagem:
    
    DEFINE INPUT PARAMETER p-nome AS CHAR NO-UNDO.
    
    CASE p-nome:
        
        WHEN "E-Sedex" THEN
            PUT UNFORMATTED
                "~~DGE-Sedex.GRF,06144,032,,::::::::::::::::gP01015H5,gP0MBA80,gN07FPF40,gM0IEAEAJAEAEAA,gK01FUFC0,gK0WBA8,gJ07FXF40,gI02EAYA0,gH01FgGFC,gH0MBHAL02BMB80,gG07FKFD0O05FLF0,gG0EAIAEA0Q02AAEAEA8,g07FJFD0S01FKF,g0JBA80V0IBAB80,Y07FIFC0W01FJF0,Y0IAEA0Y02AEAA8,X07FIF80Y01FJF,X0JB80gH0JB80,W07FHFE0gI07FIF0,W06AAE80gJ0EAEA0,V01FIFgL07FHFC,V02BHB80gL0JB,V0JFgN07FHF80,V0HAE80gN0JA0,U07FHFgO017FHF0,U0IB80gP0IB8,T01FHFgR07FFC,T02AHAgR02AHA,S01FHF80gQ01FHF80,S01BBA0gS03FB80,S03FFE0gS01FFE0,S02AA80gT0EAE0,R01FHFgR010H07FFC,S0FBA0gU02FB8,R03FFC0gU01FFE,R02EA0N02A0gL02AA,Q01FFE0M07FFC03FIF0FHFC007FIF1FC07F803FFC0,Q01BB80M03BB803BIB0BBAA003BHBA1B803B801BB80,Q03FF80M0JF03FIF0FIFH07FHFE1FC0FF0H0HFE0,Q02AA0N0IAE02AHAE0EAHA80AAEAE0EE0AA0H02EE0,Q0HFC0M01F93F87FIF0FIFC0FIFC07F3FC0H01FF8,Q0HB80M03B83B83A0I0B83B80BA0I03A3B80H01BB8,P01FF80050J03F81F87F0I0FC0FE0FE0I07F7F0J0HFC,P02EE002EA0I02A80H02E0I0A80AA0AA0I02EAE0J06AA,P07FF00FHFJ03FF0H07F0H01FC0FE1FC0I03FHFK07FF,P03BA01BAA80I0HB800BA8H80B80BA0BA8H8H0HB80J01AB,P0HFC03FDFC0H01FHFH0JFC1FC07E1FIF801FF80J01FF80,P0HA802A0E80I0IA80AIA80A80AA0AIA800AA0L0EA80,O01FF007F07C0H017FFD0FIFC1F80FF1FIF801FF0L07FC0,O03BA00BA03A2A803BBA0BIB81B80BA1BHBA801BA0L03AA0,O07FC00FD57E7FC007FE1FC5403F80FE3FC54007FF0L01FF0,O02A800AEAJA80H0EA0A80H02A00A82A80I02AE80L0EA0,O07FC00FIFCFF80H0HF1FC0H03F01FC3F80I0IF80K01FF0,O0HB800BBAB8BB8B803A1A80H03B01B83B80I0HBA80L0HB8,N01FF0H0FC0H0H50FC07E1FC0H07F07FC7F0I01FDFC0L07FC,O0AE0H0A80K0HA0AE0AHA202A0EA82AHA202A8EA0L02A8,N01FF0H0FC1D0I0HF1FE1FIFC7FIF17FIF07F8FE0L03FC,N03B80H03A3A80H0BABA83BHBA83BHBA03BHBA0BB0BA0M0BA,N07FC0H07FHFJ07FHFC3FIF87FHFE07FIF1FF07F0L01FF,N02E80H02AHAJ02AAE82AEAE82AHA806AEAE0EA02E0M0HA,N07F80H01FFD0I01FHF03FIF87FHFH07FIF3FC03F80L0HF,N0HBK02A0K02A80gQ03A80,N0HFhN07FC0,N0HAhN02A80,M01FE0Q010T010X03FC0,M01BA0hM03B80,M03FC0hM01FE0,M02A80hN0HA0,M03FC0hM01FF0,M03B80hN0BA0,M07F80hN0HF0,M02A80hN0HA0,M07F0hO07F0,M0HBhP03B8,M07F0hO07F0,M0HAhP02A8,M0HFhP07F8,M0BA0hO03B8,M0FE0hO03F8,M0HAhP02A8,L01FE0hO03FC,M0BA0hO03B8,L01FE0hO03FC,M0EA0hO02A8,L01FC0hO01FC,M0B80hO01B8,L01FC0hO01FC,M0AC0hP0A8,L01FC0hO01FC,M0B80hO01B8,L01FC0hO01FC,M0EA0hO02A8,L01FE0hO03FC,M0BA0hO03B8,L01FE0hO03FC,M0HAhP02A8,L01FE0hO03FC,M0FA0hO03B8,M0FE0hO07F8,M0HAhP02A8,M0HFhP07F8,M0HBhP03B8,M07F0hO07F0,M02A0hO02A0,M07F80hN0HF0,M03B80hN0BA0,M07FC0hM01FE0,M02A80hN0EA0,M03FC0hM01FE0,M01B80hM01B80,M01FE0hM03FC0,N0HAhN02A80,M01FF0hM07FC0,N0BA0hM03B80,N07F0hM07F,N02A80hL0HE,N07FC0hK01FF,N03B80hK01BA,N03FE0hK03FE,N02AA0hK02EA,N01FF0P010gR017FC,O0HBP01BB880gP0HB8,O0HF80N01FFC40gP0HF8,O02A80O0HEH8gQ0EA0,O07FC0O07F9F0gO01FF0,O03BA0O03B3B0gO03BE0,O03FF0O03F7F0gO07FE0,P0EA0P0A2A80gN02A80,O01FF80N01CFFC0gM01FF80,P0HB80P0HBA0gM01BB80,P07FE0O01FFE0gM03FF,P02EE0K02AA82EAA00280gI02AA,P01FF80I01FHF87FFC01FF0gI0HFC,Q0HB80I01BHB03BB802BB80gH0BE8,Q0HFC0I01FHF0FHF807F70gH01FF8,Q02AA0I02AHA0AHAH0E0H02A002020280I0A00A0I02AA0,Q03FF0I07FFC1FHFH0F0107F81F1F1FF0707F81FC0H0IF0,Q03BB80H0IB83BBA00A0H0HB81B1B1BA830BB83B80H0HBA0,Q01FFC0H0IF87FFC01C001F5C3F3E3C7C71F7E7DC0H0HFC0,R0EAA0H0IA0EAA80080H080A282828082280E20J06E80,R07FC003FHF1FHFH01C0038073070701E7380770J07F,R03B8003BAA08H8H0180038023830200E33802280I03A,R01FC003FFC0K01C00380770707FFE770073F80H01C,S0A80H0HAH8L0800280220202AHAH2H020A80I08,S070I0HF3C0J01C00390770717FHF7301701F0H010,S020I0HB380K0A003803383020H02380200A0,X07E7E0K0F003C0F707070H073C0F00E0,X02CEE0K02820A0A2020280060A0E20A0,X01DFF0K07D71F5C70703D7071F7C3DE0,X019BB80J02BB8BB838301BB830BB82B80,Y09FFC0K0HF07F0707007F0707F01FC0,,:::::::::::::::::::::::".
    
        WHEN "Pac" THEN
            PUT UNFORMATTED
            "~~DGPac.GRF,05120,032,,::::::::::::::::::::M080BFhJF8,N01DhKD5,N03FhLF80,N050hK0140,M01E0hL0F0,M01C0hL050,M0380hL038,M050hM014,M0F0hM01C,M050hN0C,M0E0hN0E,M040hN04,M0E0hN0E,M040gQ050U04,M0E0S07FFE0J0380K07FFA0S0E,M040S075H540I010K015I5T04,M0E0S0KF80H07C0J03FIF80R0E,M0C0S05DIDC0H05C0J05DIDT0C,M0E0S07FIFE0H0FE0J0KFT0E,M040S0575H570H0740I01570140S04,M0E0S0FE00FF800FE0I03FE80E0S0E,M040S05C005D001DD0I05D0W04,M0E0S07E003F801FF0I07F0W0E,M040S0540015001550I0560W04,M0E0S0FE003F803FF80H0FE0W0E,M0C0S05C001D001DDC001DC0W0C,M0E0S07E003F803EFC001FC0W0E,M040S0540017005454001740W04,M0E0S0FE003F80FE7E003F80W0E,M040S05C005D005C5C001580W04,M0E0S07E00FF00F83F003F80W0E,M040S0H5055401501500150X04,M0E0S0KFE01F83F803F80W0E,M0C0S05DIDC01D81D801D80W0C,M0E0S07FIF803F83F803F80W0E,M040S057554003501740150X04,M0E0S0IFE8007F01FC03F80W0E,M040S05C0J05C00DC01DC0W04,M0E0S07E0J0FEAAFE01FC0W0E,M040S0540J0K5601540W04,M0E0S0FE0J0KFE00FE0W0E,M0C0S05C0I01DKDH0DC0W0C,M0E0S07E0I01FKF80FE0H020S0E,M040S0540I0170H01500550H030S04,M0E0S0FE0I03F8003F807F800F80R0E,M040S05C0I0150H01DC01D501D80R04,M0E0S07E0I07F0H01FC03FJF80R0E,M040S0740I0H5I01740075I540R04,M0E0S0FE0I0FE0I0FE00FJF80R0E,M0C0S05C0I0DC0I0DC001DHDC0S0C,M0E0S07E0I0FE0I0HFI0IF80S0E,M040gQ010U04,M0E0hN0E,M040hN04,M0E0hN0E,M040hN04,M0E0hN0E,M0C0hN0C,M0E0hN0E,M040hN04,M0E0hN0E,M040hN04,M0E0hN0E,M040hN04,M0E0gL080g0E,M0C0hN0C,M0E0hN0E,M040hN04,M0E0hN0E,M040hN04,M0E0hN0E,M040hN04,M0E0hN0E,M0C0hN0C,M0E0hN0E,M040hN04,M0E0hN0E,M040hN04,M0E0hN0E,M040hN04,M0E0hN0E,M0C0hN0C,M0E0hN0E,M040hN04,M0E0hN0E,M040hN04,M0E0hN0E,M040hN04,M0E0hN0E,M0C0hN0C,M0E0hN0E,M040hN04,M0E0hN0E,M040hN04,M0E0hN0E,M040hN04,M0E0hN0E,M0C0hN0C,M0E0hN0E,M040hN04,M0E0hN0E,M040hN04,M0E0hN0E,M040hN04,M0E0hN0E,M0C0hN0C,M0E0hN0E,M040hN04,M0E0hN0E,M040hN04,M0E0hN0E,M040hN04,M0E0hN0E,M0C0hN0C,M0E0hN0E,M040hN04,M0E0hN0E,M040hN04,M0E0U0HAgQ0E,M040U0540gP04,M0E0U07EC0gO0E,M0C0U01DC0gO0C,M0E0U03BF0gO0E,M060U01350gO06,M0E0S02887F80gN0E,M040S05D85D01D0gL04,M0E0R01FF1FF03B80gK0E,M050R0154154060050144141050140Q014,M0F0R03FE3FE8E00FE39EFF19FCFE0Q01C,M050R0H5C5DC0C01C4410C1H10440R01C,M0380Q0HF8FF80C0382638819306E0R038,M0140Q0750J040103411551602540Q050,M01E0Q07EE0I0C0303638FF92023E80P0F0,N0540P01C40I040105410C01104040P05C0,N03FPF83DF0I070986630E2138E063FPF80,N0175O501170I0150544107411545415P5,O0BFOF80BFC0I0F8F86383E10F8383FOF8,,:".
    
        WHEN "Sedex" THEN
            PUT UNFORMATTED
            "~~DGSedex.GRF,06144,032,,:::::::::::::::gP01015H5H010,gP0MBHA0,gN07FPFD0,gM0AEAKAIEAEAE80,gK017FUF0,gK0JBHA80J02ABIBA,gJ07FIF40N017FIF0,gI02EAE80R02EAHA,gH07FHFC0T01FHFD0,gH0IBA0V03BBA0,gG07FFC0X07FFE,g02EAA0g02EA80,Y01FHFgH01FHF0,Y01BB80gH03BB8,Y07FE0gJ07FF,X02AA0gL0EA80,X0HFD0gL03FF0,W03BA0gN0HB8,W07FC0gN07FC,W0HAgQ0AE,V07FC0gP07FC0,V0HBgS0HB0,U01FF0gR07F8,U02E80gR02AA,T01FF0gT0HF,T03B80gT03B80,T07F0gV0FE0,T0HAgW02A0,S01FC0I010gQ03F8,S02A0I03FFC00FJFE3FHFE0H0NFC00FF80A8,S07E0H01FIF01FJFE3FIFC00FMFC01FF007F,S0A80H01FIF80FJFE3FIFE00FJFE7EE01FF002A,P0101F80H07FIFC1FJFE3FJF81FKF7FE03FE001F80,R03A0I0KFC1FJFE3FJFC1FJFE3FE07FC0H0B80,R07C0I0HFDFFE3FJFC7FJFC1FJFE3FF0FFC0H07F0,R0A80H01FE07FE3FIFEC7FJFE1FFEFFE3FF0FF80I0A8,Q01F80H01FE07FE3FE0I07FDFHFE1FF0I01FF1FF0I01FC,Q03A0I01FE03FE3FE0I07FC0FFE3FE0I01FFBFE0J0HA,Q07E0I03FE01407FC0I07FC07FE3FE0I01FIFC0J07F,Q0A80I03FF80H03FC0I07FC03FE3FE0J0JF80J02A,P01F80I03FHFI07FC0I0HFC03FF3FE0J0JF80J01F80,P03B0J03FHFE007FFAAB0FF803FE3FFAHA807FHFM0B80,P07E0J01FIFC07FJF0FF803FE7FJFH07FHFM07C0,P0280K0JFE07FJF0FF803FE7FJFH03FFE0L02A0,O01F80K0KF07FJF1FF807FE7FJFH03FFC0L01F0,P0B80K07FIF8FJFE0FF803FE7FJFH03FFC0M0B8,O01F0L01FIF8FJFE1FF007FC7FJFH07FFC0M078,O02E0M03EFF8FFAIA0FF007EC7FAIAH0IFE0M028,N017D0L0107FFCFF80H01FF007FCFF80H0H1JFN03E,O0380N01FF8FF80H01FF00FFCFF80I03FHFE0M03A,O0780K01700FFDFF0I01FF00FFCFF80I07FIFN01F,O0E0K03FE00FF8FF0I03FE00FF8FF80I07FDFF0N0E,N01F0K01FF00FF9FF0I03FF01FF9FF0I01FFDFF80M0F80,O0A0K03FF00FF9FF0I03FE03FF0FF0I01FF8FF80M0B80,N03E0K01FF01FF1FF7H763FJFE1FHFI73FF0FFC0M07C0,N0280L0HFC3FE1FJFE3FJFC1FKF3FE0FFC0M02C0,N07C0K01FJFE3FJFE7FJFC1FKF7FC07FC0M03F0,N0380L0KFC3FJFE7FJF01FJFEFF807FE0N0A0,N0780L07FIFC3FJFE7FJF01FMF807FE0M01F0,N0A0M07FHFE03FJFE7FIFC03FMFH03FE0N0A0,M01F0M01FHFC03FJFC7FIFH03FMFH03FF0N0F0,N0A0O0F80gX0B8,M01E0hP078,N0A0hP028,M03C0hP07C,M0380hP038,M07C0hP03C,M0280hP028,M07C0hP01C,M0380hP01A,M0780hP01E,M0280hQ0A,M070hQ01F,M0B0hR0A,M0F0hR0F,M0E0hR0A,M0F0hR0F,M0B0hR0B,M0F0hR0F,M0A0hR0A,L01F0hR0F,M0A0hR0B,M0F0hR07,M0E0hR0E,L01F0hR0F,M0A0hR0B,M0F0hR0F,M0A0hR0A,M0F0hR0F,M0B0hR0B,M0F0hR0F,M0E0hR0E,M0F0hQ01F,M0B80hQ0A,M0780hP01F,M0280hQ0A,M0780V010gR01E,M0380hP01A,M07C0hP01E,M0280hP02C,M03C0hP03C,M03A0hP038,M01E0hP07C,N0E0hP028,M01F0hP078,N0B0hP0B0,N0F0hO01F0,N0A80hO0A0,N0780hN01F0,N0380hN03A0,N07C0hN03C0,N02E0hN0280,N01E0hN07C0,N01A0hN0B80,O0F0hM01F,O0A80hM0A,O07C0O0I1gT01F,O0380O01BB880gQ03A,O03E0P07FC40gQ07C,P0E0P02ACE0gQ0A8,O01F0P07FDF0gQ0F8,P0B80O03B9B0gP01B0,P07C0O01F3F80gO03F0,P02A0P0E2E80gO02A0,P03F0P04FFE0gO0FC0,Q0B80P0FBA0gO0B80,P01FC0L04041FHFgO01F,Q0HAL0IA82AAE002E0gJ02A,Q07F0J01FHF97FFC01FFC0S010N0FC,Q03B0K0IB82BB801BB80gI0B8,Q01FC0I03FFE0FHFC03C18050L040J040040I01F0,R0EC0I02EAC0EAE00280H0E802E2A0E80A0AE02E80H02E0,R07F0I07FFC1FHFH070H07FF07C7C7FF0E1FF87FC0H07C0,R01B80H0ABB83BBA00A0H038B8F8A8F8B8A3A383980H0B80,R01FC001FHF07FFC00E0H07078E0F0F078E7C1C70J07,S0HAH02AAE02AE800E0H0E028A0E0E028A200E20J02,S07C003FFE15H5I0C001C01DD0E1D01CE700F7C0,T08003BB80L0A001801880A0BHB8A20023B8,S018001FFD80K0E001C01CC0E1FHFCE60073FC,X0AE880K0A0H08008C0E0AEACA60020AC,X0HF3C0K07001C01DC0E1C0H0E700F01C,X03A2A0K03800A03880A0A0H0A200A00A,X03CFF0K07C107070C0E0F040E7C1C31C,X028AA80J02E2868E8C0E068A0A2A2C288,X019FFC0J01FFC7FF1C0F07FF0E1FF87FC,Y08BB80K03A80A8080A01AA0A0BA02B8,Y045540L04004004040040040J040,,::::::::::::::::::::::::::::".
        
        WHEN "Sedex 10" THEN
            PUT UNFORMATTED
            "~~DGSedex10.GRF,06144,032,,::::::::::::::::::gR08AHA8080H080,gP05DMD4,gN0BFQF8,gL015H57575757575H540,gK0BFMFEFMFE80,gK05DD5DD40J015DJD40,gJ0KFA0O03FIFE,gI0H57540S05755,gH0JF80U0BFHF8,gG01DHDY01DHD,gG0IFA0Y0IFA0,g057740g015H50,Y03FFE0gI0HFE,Y05DD0gJ01DDC0,X03FF80gK03FF0,X07540gL01550,W03FF8080gJ087FE80,W05DC0gO0HD80,V03FF0gP03FE0,V05740gQ0H70,V0HF80gQ0BFC,U01DC0gR0155,U0HF80gS03F80,T01740gT01540,T0HF80gU07F8,T05D0gV01F4,S03FE0gW0FE,S0370gX0H5,S0FE0gX03FC0,R01D40gY0540,R03F80gY03E0,R0H5hG0150,R0FC0H0BE802AIA0AA8002AIA2A00AA0I03E002E880FE80,Q01D0H01DFC01FDFC1DHDH07DFDC5F01DC0I07C005DC005C,Q03F0H07FFE03FHFE3FHF807FHFC3F83F80I0FE00FFE003F80,Q0540H0757507I743775407I74170770I0176017H7H015,Q0F80H0FE3F87FHFC3FHFE07FHFC1F8FE0I0HFE03FBF0H0FC0,P01F0I0DC1D07C0H01F05C05C0H01DHDC0H01DDC05E0D0H05C0,P03E0H01FC2A07E0H03F07E0FE0I0IF80H01FFE07E0F8003F0,P0540H01770H0740H0H70770740I0I7J01574074070H0170,P0FC0I0HF808FE8807F83F0FC8H807FF80H03EFC0FC0F80H0FC,O01D80I0HDC00DID05C05F0FDHDH01DC0I010D80DC0D80H05C,O03F0J07FF80FIF07E03F0FIFH03FE0I020F80F80F80H03E,O0160J0177417I707607717I7H03740K070170170I017,O0FE0K0HFE1FEAA0FE07E1FAHAH0HFC0K0F81F83F80I0F80,O0540K01DE1D80H05C05C1D80I05DC0J01F01D81D0J0D40,O0F80L0FE1F80H0FE0FE1F80H03FFE0J01F81F83F0J03C0,N0170J074056170I074074170I015760J0170170370J0140,N03E80I07E0FE3F80H0FC1FC3F88007FBF0J03F00F87E0J01E0,N0140J05D07C1DID1FD7FC1FDHD05F1D0J01D00F87C0J01D0,N03C0J03FAFE3FIF1FIF83FIF0FE3F80I03F00FAFC0K0F8,N070K01577437F7717H75037I7174170J036007H7M054,N0F80J01FHF83FHFE1FHFE07FHFE3F81FC0I07E007FF80K07C,M0150L05DC05DHDC1DHDH05DHDC5D005C0I05E001DC0L01C,M03E0M020gR020M03E,M0140hP015,M03E0hP01F80M05C0hQ0D,M07C0hQ0F80M050hR05,M0F80hQ0F80M0D0hR0140M0F0hR03E0L0150hR0140L01E0hR01E0L01C0hR01C0L03E0hR01E0L0140hS070L03C0hS0F0L01C0hS0D0L03C0hS0F0L0140hS050L0780hS0F8L0580hS050L0780hS078L050hT050L0780hS078L050hT058L0780hS078L050hT050L0F80hS078L050hT058L0780hS038L050hT070L0F80hS078L050hT058L0780hS078L050hT050L0780hS078L0580hS050L0780hS078L050hT050L03C0hS0F8L01C0hS050L03C0hS0F0L0140hS050L0BE0hS0F0L01C0hR01C0L01E0hR01E0L0150hR0160M0F0hR03E0M0D0hR01C0M0F80hQ03C0M050hR05,M07C0hQ0F80M05C0hQ0D80M03E0hQ0F80M0160hP015,M03E0hP03E,M01D0hP01C,N0F80hO03E,N050hP054,N0FC80hN0F8,N01C0hO0D0,N03E0Q020gU01F0,N0150P015510gS0160,O0F80O03FFC80gR03E0,O0F40O01DHDC0gR05C0,O07E0P0HFBE0gR0F80,O0140P0H5150gQ015,O03E0P03E3F80gP03F80,O01D0P0145D80gP054,P0F80O01CFFC0gP0FE,P0740P017540gP050,P03E0L0J83FFE0H080gK03F8,P01D0L0I501DDC00140gK0150,P01F80J03FHF07FFE00FFA0gJ03E0,Q0740J0I5405H54017540gI01540,Q07E0J0IFE9FHF803E880280L080I0280080I03F80,Q01D0J0IDC1DHDH070H015C0150505D0101DC05D0I05D,Q01F80H01FHF83FHFH0F0H03FF03E3F8FF8383FE0FF80H0FE,R0740H01755075540060H0H57014341574107550550I054,R07F0H03FFE0FHFC00E0H0F83C7838381E38F8F8E80I078,R0150H05DDC1DHD800C0H0401C5050500C19C01CC0J040,S0F0H0IF82AHAI0E0H0E00E7070700739E01CF8,S050H07550M040H040045050711511401454,S020H07FFA0H080H0E0H0E00E7070FIF39C00CFF80,W01DD50L0C0H0C00C50505DHD19C01C1580,W03FEF80K0E0H0E00E707070H039E01C03C0,W0154740K070H06014705050H0H140140140,X0F8FE0K07808F03C7070380038E03801C0,X0517D0K01D10545850501C1018545851C0,X0H3HFL01FFE3FF870701FF8387FF0FF80,X013550L0H5015405050075010174055,X0K8M080H080H080H0800800808H80,,:::::::::::::::::::::::::::".
        
        /* Logo trocado conforme chamado 125790 */
        WHEN "local-logo" THEN
            PUT UNFORMATTED
                "~~DGlocal-logo.GRF,02304,024,,::::::::::::::::::::::::::::::::::::::K01E0J0F0K03C780,K01F0J0F0K03EF80,K01F0J0F0K03CF80,K01F0J0F0K03EF80,L040J0F0K03CF80,L0200A00FA802803EF8A0I080080H0HA0,K01F03FC0FF01FF03CFHFC007F8FF007FF0,K01F0FFE0FF03FF83EFIF01FF3FFC0FHF0,K01F1FHF0FF07FFC3CFIF83FE7FFE0FHF0,K01F1FHF8FF0FHFE3EFIF83FEFIF1FHF0,K01F3F0FCF01FC7F3CFF0FC7E0FC1F9F0,K01F3E07CF01F0FE3EFC07E7C1F80F9F0,K01F3C07CF03E1FC3CFC03E781F00F9F0,K01F3C07CF03E3F83EF803EF81F0078FFE0,K01F7C07CF03EFE03CF803EF81F007CFHF0,K01F3C07CF03FFC03EF803EF81F007C7FF8,K01F7C07CF03FF0E3C7803EF81F007C1FF8,K01F3C07CF81FE1F3E7C03EF81F80FC007C,K01F7C07CF81FC3F3C7E0FCF80FC1FC007C,K01F3C07CFFCFHFE3E3FHFCF80FIFCFHFA,K01F7C07C7FCFHFC3C1FHF8F807FHFCFHF8,K01F3C07C3FE7FFC3E0FHF0F803FHFCFHF8,K01F7C07C1FF1FF03C07FE0F801FHFCFHF0,K01F3C07C0FE0FE03E03F80F8007E7DFFE0,,::::::::::::::::::::::::::::::::".
/*
        WHEN "local-logo" THEN
            PUT UNFORMATTED
                "~~DGlocal-logo.GRF,01536,024,,:1F80U0HF9FE,3FC0U0HF9FE,::3FC0J03FE0M0HF9FE,:1F80J03FE0M0HF9FE,N03FE0M0HF9FE,3FC00F803FE0H03F800FF9FE7C0H03FE007F80J07F80,3FC07FF03FHF01FFE00FF9FE7F8007FF81FHFJ01FF80,3FC1FHF83FHF03FHF80FF9FEFFC00FHFC7FHF80H07FF80,3FC3FHFC3FHF0FIFC0FF9FJF01FHFCFIFC0H0IF80,3FC3FHFE3FHF0FIFE0FF9FJF83FHFCFIFE001FHF80,3FC7FHFE3FHF1FJF0FF9FJF83FHF9FJFH01FHF80,3FC7FIF3FHF3FJF8FF9FJFC7FHF3FJFH01FHF80,3FCFJF3FE03FJF8FF9FJFC7FFE3FJF803FHF80,3FCFFDFF3FE07FE0FF8FF9FJFE7FC07FE1FF803FF8,3FCFF8FF3FE07FC07FCFF9FF87FE7F807FC0FF803FF0,3FCFF0FF3FE07FJFCFF9FF03FE7F807FC0FF803FE0,3FCFF0FF3FE07FJFCFF9FE01FE7F807FC0FF807FC0,:3FCFF0FF3FE07F80I0HF9FE01FE7F807FC0FF80FF80,3FCFF0FF3FE07FC0I0HF9FF03FE7F807FE1FF80FF80,3FCFF0FF3FF07FE0I0HF9FF87FC7F803FJF87FF80,3FCFF0FF3FHF3FHFE00FF8FJFC7F803FJF9FHF80,3FCFF0FF3FHF3FIF80FF8FJFC7F801FJF9FHF,3FCFF0FF3FHF1FIFE0FF87FIF87F801FJF9FHF,3FCFF0FF1FHF1FIFE0FF87FIF87F800FJF9FHF,3FCFF0FF1FHF0FIFE0FF83FIF07F8007FIF9FFE,3FCFF0FF0FHF07FHFC0FF81FHFE07F8003FIF9FFC,3FCFF0FF07FF03FHFH0HF80FHF807F80H0FEFF9FF8,3FCFF0FF01FF00FFC00FF801FE007F80H07E7F9FC0,,:::::::::::::::::::::::::::::".
*/
        WHEN "Sedex 12" THEN
            PUT UNFORMATTED
            "~~DGSedex12.GRF,05120,032,,:::::::::::::::::gJ010J01015H510,gO02BLBA80,gM07FQFC0,gL0IAEAHAEAHAEAEAA,gJ01FWFC,gJ0gB80,gH01FgGFC,gH0gIAE80,gG07FOFD5H5PFD0,g03BLBA80N0ABLB8,Y01FLF40Q01FLF,Y02AEAEAA0U02AIAEA0,X01FJFD0W07FJFC,X0JBHAg03BIBA,W07FIFE0gG07FIFC0,W0KAgJ0KA8,V01FIFC0gI07FIFC,V0JBA0gK03BHBA,U01FIFgM01FIFC0,U0HAEA80gM02EAEA0,T01FIFgP07FHFC,T03BHB80gO01BHBA,S01FHFE0gQ07FHF,S02AHA80gR0IA80,R017FHFgT07FHF0,S0IB80gS03BHB8,R03FHFgV0IFC,R02AHAgV02EAE,Q01FHFgW01FHF,Q03ABA0gW03BB80,Q07FFC0gW01FFE0,Q0HAE0gY0HAE8,P03FFC0O010gL0107FFC,P03BB80gY03BB8,P07FF0H07FC03FHFE0FHFH03FIF1FC07F0J0F801FFC1FFE,P0EAE002AEA02EAHA0AHAE02AEAA0E80AE0J0A802EHE02AA,O01FFC007FHF07FHFE1FIF03FIF1FC1FC0I07F00FIF03FF80,O03BA800BABA03BHBA1BIB83BHBA0BA3B80I0HBH0BABA00EB80,O07FF001FC1F07F0H03FDFF87F0I07E7F0I07FF01FC7F007FE0,O0IAI0A80A02A0H02E82A82E0I02A2A0I0EAA00A82A002AA0,N01FFC001FD0107E0H03F01F87F0I07FFC0H01FHFH0107E001FFC,N03BB8001BB800BA0H03B01B83A0I03BB80I0ABA0I03A001BB8,N07FF0H01FHFH0JF87F01F87FHFC03FF0I01E7E0I0FC0H07FE,N02EA0I0EAA80EEAA82A02A8EAHA800AE0J082A0I0A80H02AE,M01FFC0I07FFE0FIF07F03F8FIF801FF0K07E0H07F80H03FF,M01AB80J0HBA0BIB03A02B8BABB803BB0K03A0H0FA0J0HB80,M01FF0K01FF1FC0H07E03F0FC0I07FF0K07C003FC0J0HFC0,M02AA0L02A0A80H02A02A0A80I0IA80J0A8002A0K02A80,M07FC0I07E17F1F8001FE07F1FD0101FDFD0J0FC11FC0K07FF0,M03B80I0BA03A1B80H0BA0BA0B80H01B9B80J0B800F80K03BA0,M0HFC0I07E0FE1FD550FF7FC1FD5507F1FC0J0FC07F5540I01FF0,M0HA80I02AAE80AEAA0EAEE80EAEA02E0AA0J0A802AHA80J0EA0,L01FF0J07FHF83FIF1FIF01FIF1FC0FE0I01F80FIF80J07FC,L03BA0J02BFB03BBAB0BHBA03BHBA1B80BA0I01B80BIB80J03B8,L07FC0J017FC07FIF1FHFH03FIF3F807F0I01F01FIFL07FC,L02A80hO02AA,L07F80hO01FF,L0HB80hO01BB,L0HFhQ01FF,L0AE0hQ0HA,K01FF0hQ07F80K01BA0hQ03B80K01FE0hQ07FC0K02A80hQ02A80K03FC0gU010T03FC0K03B80hQ03B80K07FC0hQ01FC0K02A80hR0EA0K07F80hQ01FE0K03B80hR0BA0K07F0hR01FF0K0HAhT0HA0K0HFhS01FF0K0HBhT0HB0K0HFhT0HF0K0EA0hS0EA0K0HFhT0HF0K0BA0hS0HB0K0HFhT07F0K0HAhT02A0J01FF0h010P017F0K0BA0hS0HB0K0HFhT07F0K0EA0hS02A0K0HFhT07F0K0BA0hS0HB0K0HFhT0HF0K0HAhT0AE0K0HFhT0HF0K0HBhT0HB0K07F0hS0HF0K02A0hS0HA0K07F80hQ01FF0K03B80hQ01BA0K07F80hQ01FE0K02A80hQ02AE0J013FC0hQ03FC0K03B80hQ03B80K03FC0hQ07FC0K02AA0hQ02A80K01FF0hQ07F80L0BA0hQ0AB80K01FF0hQ0HF,L0HAhR0AE,L07F80hO01FF,L03B80hO03BA,L07FC0hO03FE,L02A80hO02AC,L03FE0hO07FC,L01BA0hO0HB8,M0HF80hM01FF0,M0HA80P0HA80gS02AE0,M07FC0O01FFE50gR03FF0,M02BA0P0FBA20gR03B80,M03FF0P07FCF0gR0HFC0,N0HAQ02A8A0gR0AE80,M01FF80O01F1F80gP01FF80,N0HB80P0A3B80gP03BA,N07FE0P067FE0gP07FE,N02AA0Q0IAgQ0AEC,N01FF80K0I101FHF80H010gJ01FFC,O0HB80K0IB83BBA003B80gJ03BB8,O07FE0J01FHF07FHFH07FF0gJ07FF0,O02EE0J02AEA06EA800AHAgK0AEA0,O03FF80I07FFE0FHFC01F040140Q010H040I01FFC0,O01BB80I0IB80BHB80280H0BA80B8A83B8080BA02B80H03BB80,P0HFE0H01FHFC1FHFH078001FFC1F1F8FFE1C1FF07FC0H07FF,P02AE80H0IA82AAE0060H02A2A2A2E0A0A082A282880H02EA,P03FFC003FHF17FFD00F0H0791F383D1D0F1D701D70J07FC,P01AB8003BBA0BHB800A0H030023838380298E00A30J03B8,Q07F0H07FFC0L0F0H06007783C7D579CE00F7F0I01F0,Q02A0H02AA880K0E0H0E00628282AHAH8E00A2E80I080,Q01E0H03FF980K070H0E007783C7FHF9CE00F1FC0I0C0,R080I0BA380K03800A00238383AHA98A00A03A,W0FE7E0K078007007783C3C001C700E00E,W02CAA0K02C00280E2828280H08200800A,W03DFF0K01F5C3F7C783C1F1D1C7D7C75E,W019BB80K0HBA1BB838380BAC183BB83B8,W0H1HFC0K07FC07F0783C03FC1C0FE03FC,,::".

    END CASE.

END PROCEDURE.


PROCEDURE pi-envia-rastreio:

    CREATE tt-mail.
    ASSIGN tt-mail.Destinatario  = emitente.e-mail
           tt-mail.Assunto       = "Codigo de Rastreio da NF: " + string(nota-fiscal.nr-nota-fis)
           tt-mail.Mensagem      = "     Nota fiscal: " + nota-fiscal.nr-nota-fis + CHR(10) +
                                   "           Serie: " + nota-fiscal.serie + CHR(10) +
                                   " Codigo Rastreio: " + int-nota-conhec.nr-conhec + CHR(10) +
                                   " Qualquer duvida entrar em contato: eduarda.camilo@intelbras.com.br".
    FOR FIRST usuar_mestre NO-LOCK                                                           
        WHERE usuar_mestre.cod_usuario = c-seg-usuario:
        ASSIGN tt-mail.Remetente = usuar_mestre.cod_e_mail_local.
    END.
    IF tt-mail.Remetente = "" THEN
        ASSIGN tt-mail.Remetente = "ems@intelbras.com.br".

    RUN esapi/esapi010.p (INPUT-OUTPUT TABLE tt-mail,
                          OUTPUT TABLE tt-erro).

    FOR EACH tt-erro:
        DISP tt-erro WITH WIDTH 300.
    END.

    FOR EACH tt-mail:
        DELETE tt-mail.
    END.

END PROCEDURE.
