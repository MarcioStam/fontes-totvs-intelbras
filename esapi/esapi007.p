/***********************************************************************
**  Programa..: ESAPI\ESAPI007.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Gera Ordem Produá∆o
**  Vers∆o....: 001 16/11/2004
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESAPI007 2.04.00.001}

{cdp/cdcfgman.i}   
/****************************  Temp-Tables  ****************************/
{esapi/esapi002tt.i}   /* Definicao da temp-table de origem */
{esapi/esapi006tt.i}
{esapi/esapi007tt.i}
{cpp/cpapi001.i}       /* Definiá∆o das temp-tables     */
{cpp/cpapi001.i1}      /* Temp-tables adicionais        */
{cpp/cpapi301.i}       /* Definiá∆o das temp-tables     */
/* {cpp/cpapi018.i}       /* Definiá∆o das temp-tables     */  */
    {cdp/cdcfgman.i}

define temp-table tt-dados no-undo 
    field c-estab-ini              as char
    field c-estab-fim              as char
    field i-linha-ini              as integer
    field i-linha-fim              as integer
    field i-ordem-ini              as integer
    field i-ordem-fim              as integer
    field d-data-ini               as date
    field d-data-fim               as date
    field requis-por-ordem         as log init no  /* Cria uma sumarizaá∆o para cada ordem */
    field estado                   as int          /* 1- Inclui, 2- Elimina */
    field cod-versao-integracao    as INT
    field c-camp-ini               as char
    field c-camp-fim               as char
    &if defined(bf_man_206b) &then
    FIELD c-unid-negoc-ini         AS CHARACTER
    FIELD c-unid-negoc-fim         AS CHARACTER
    &ENDIF
    .

define temp-table tt-ord-prod-2 NO-UNDO
   field nr-ord-produ like ord-prod.nr-ord-produ
   field it-codigo    like ord-prod.it-codigo
   field cod-estabel  like ord-prod.cod-estabel
   field nr-linha     like ord-prod.nr-linha
   field qt-ordem     like ord-prod.qt-ordem
   index id is primary unique nr-ord-produ.

define temp-table tt-req-sum NO-UNDO
    field nr-req-sum like req-sum.nr-req-sum
    field it-codigo  like req-sum.it-codigo
  &IF DEFINED (bf_man_sfc_lc) &THEN    
    field cod-refer  like req-sum.cod-refer
  &ENDIF
  &IF DEFINED (bf_man_per_ppm) &THEN
    field per-ppm    like req-sum.per-ppm
  &ENDIF  
    field r-rowid    as rowid
    index id is primary unique nr-req-sum 
                               it-codigo
                             &IF DEFINED (bf_man_sfc_lc) &THEN
                               cod-refer
                             &ENDIF
                             &IF DEFINED (bf_man_per_ppm) &THEN
                               per-ppm
                             &ENDIF
                              .


/* fim {cpp/cpapi018.i}       /* Definiá∆o das temp-tables     */  */

{cdp/cd0666.i}         /* Definicao da temp-table de erros */
DEFINE TEMP-TABLE tt-AtuErro LIKE tt-erro.

DEF VAR vQtAlocar      LIKE ped-item.qt-pedida         NO-UNDO.
DEF VAR vQtTransferida LIKE ped-item.qt-pedida         NO-UNDO.              

DEFINE TEMP-TABLE ttReservas NO-UNDO LIKE reservas
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE tt-erro-BO NO-UNDO
       FIELD descricao     AS CHAR format "x(132)".

/****************************  Variaveis    ****************************/
{utp/ut-glob.i}
DEFINE VARIABLE h-cpapi001  AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-cpapi301  AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-cpapi018  AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-acomp     AS HANDLE       NO-UNDO.
DEFINE VARIABLE c-retorno   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCont       AS INTEGER      NO-UNDO.
DEFINE VARIABLE l-erro      AS LOGICAL      NO-UNDO.
DEFINE VARIABLE lAchouAE    AS LOGICAL      NO-UNDO.

DEFINE VARIABLE c-erro  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-texto AS CHARACTER  NO-UNDO.

DEFINE BUFFER breservas FOR reservas.

if  not valid-handle (h-cpapi301) then
    run cpp/cpapi301.p persistent set h-cpapi301 (input-output table tt-ord-prod,
                                                  input-output table tt-reapro,
                                                  input-output table tt-erro,
                                                  input yes).  
                                                  

if  not valid-handle (h-cpapi018) then
    run cpp/cpapi018.p persistent set h-cpapi018 (input        table tt-dados,
                                                  input        table tt-ord-prod-2,
                                                  input-output table tt-req-sum,
                                                  input-output table tt-erro,
                                                  input        yes).

if  not valid-handle (h-cpapi001) then
    run cpp/cpapi001.p persistent set h-cpapi001 (input-output table tt-rep-prod,
                                                  input        table tt-refugo,
                                                  input        table tt-res-neg,
                                                  input        table tt-apont-mob,
                                                  input-output table tt-erro,
                                                  input no).

FOR EACH tt-ord-prod. DELETE tt-ord-prod. END.
FOR EACH tt-reapro.   DELETE tt-reapro.   END.

DEFINE INPUT        PARAM pProgOrigem AS CHAR.
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-ordem.
DEFINE OUTPUT       PARAM pReturn     AS CHAR NO-UNDO.

find first tt-ordem no-error.

{esinc/es0005.i tt-ordem.cod-estabel} /* Busca Data Ultimo Faturamento - vDtFatur */


FOR FIRST param-cp NO-LOCK:
END.

BLOCO:
DO  TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO:

    FOR FIRST tt-ordem:
        FOR FIRST ITEM FIELDS(it-codigo un nr-linha deposito-pad) NO-LOCK
            WHERE ITEM.it-codigo = tt-ordem.it-codigo:
        END.
        IF NOT AVAIL ITEM THEN
        DO:
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = 1
                   tt-erro.cd-erro  = 17567
                   tt-erro.mensagem = "Item informado n∆o cadastrado: " + tt-ordem.it-codigo
                   pReturn          = "NOK".
            LEAVE.
        END.
        ELSE DO:
            RUN esapi/esapi006.p ( INPUT ROWID(ITEM),  /* Rowid */
                                   INPUT "",           /* Refer */
                                   INPUT 1,            /* Quantidade */
                                   INPUT 0,            /* Quantidade Liq */
                                   INPUT 0,            /* N°vel */
                                   INPUT-OUTPUT TABLE tt-estrutura,
                                   INPUT TODAY,        /* Data Corte */
                                   INPUT YES,          /* Recursivo */
                                   INPUT 19,           /* N°veis */
                                   INPUT tt-ordem.cod-estabel).       /* Estabel */
            FOR EACH tt-estrutura
                WHERE tt-estrutura.log-fantasma = NO:
                FOR FIRST item-uni-estab FIELDS(it-codigo tipo-requis) NO-LOCK
                    WHERE item-uni-estab.cod-estabel = tt-ordem.cod-estabel
                    AND   item-uni-estab.it-codigo   = tt-estrutura.es-codigo:
                    IF  item-uni-estab.tipo-requis <> 2 THEN 
                        /*CREATE tt-erro.*/
                        ASSIGN /*tt-erro.i-sequen = 1
                               tt-erro.cd-erro  = 17567
                               tt-erro.mensagem = "O Componente " + tt-estrutura.es-codigo + " n∆o Ç do tipo de TRANSFER“NCIA, favor verificar."*/
                               pReturn          = "O Componente " + tt-estrutura.es-codigo + " n∆o Ç do tipo de TRANSFER“NCIA, favor verificar.".
                END.
            END.
            IF pReturn <> "" THEN LEAVE.
        END.
        IF tt-ordem.nr-linha = 0 THEN
        DO:
            FOR FIRST item-uni-estab NO-LOCK
                WHERE item-uni-estab.it-codigo   = tt-ordem.it-codigo
                AND   item-uni-estab.cod-estabel = tt-ordem.cod-estabel,
                FIRST lin-prod NO-LOCK
                WHERE lin-prod.nr-linha = item-uni-estab.nr-linha: 
            END.
        END.
        ELSE DO:
            FOR FIRST lin-prod NO-LOCK
                WHERE lin-prod.nr-linha = tt-ordem.nr-linha: 
            END.
        END.
        IF NOT AVAIL lin-prod THEN NEXT.        
    
        
        CREATE tt-ord-prod.
        ASSIGN tt-ord-prod.cod-versao-integracao = 003
               tt-ord-prod.prog-seg              = pProgOrigem 
               tt-ord-prod.nr-ord-produ          = tt-ordem.nr-ord-produ
               tt-ord-prod.it-codigo             = tt-ordem.it-codigo
               tt-ord-prod.qt-ordem              = tt-ordem.qt-ordem 
               tt-ord-prod.nr-linha              = lin-prod.nr-linha
               tt-ord-prod.cd-planejado          = IF tt-ordem.cd-planejado = "" THEN 
                                                   lin-prod.cd-planejado ELSE tt-ordem.cd-planejado 
               tt-ord-prod.aloca-reserva         = NO
               tt-ord-prod.ind-tipo-movto        = 1
               tt-ord-prod.un                    = ITEM.un
               tt-ord-prod.tipo                  = tt-ordem.tipo  
               /*tt-ord-prod.estado                = tt-ordem.estado*/
               tt-ord-prod.cod-refer             = tt-ordem.cod-refer
               tt-ord-prod.rep-prod              = tt-ordem.rep-prod 
               tt-ord-prod.sit-aloc              = tt-ordem.sit-aloc 
               tt-ord-prod.cod-estabel           = tt-ordem.cod-estabel
               tt-ord-prod.cod-depos             = tt-ordem.cod-depos
               /*tt-ord-prod.conta-ordem           = conta-contab.conta-contabil*/
               tt-ord-prod.ct-codigo             = lin-prod.ct-ordem 
               tt-ord-prod.sc-codigo             = lin-prod.sc-ordem  
               tt-ord-prod.dt-inicio             = vDtFatur
               tt-ord-prod.dt-termino            = vDtFatur
               tt-ord-prod.dt-orig               = vDtFatur
               tt-ord-prod.dt-emissao            = vDtFatur
               tt-ord-prod.ep-codigo-usuario     = i-ep-codigo-usuario
               tt-ord-prod.seg-usuario           = c-seg-usuario
               tt-ord-prod.nr-pedido             = tt-ordem.nr-pedido
               tt-ord-prod.nome-abrev            = tt-ordem.nome-abrev
               tt-ord-prod.nr-sequencia          = tt-ordem.nr-sequencia
               tt-ord-prod.reporte-mob           = ?
               tt-ord-prod.reporte-ggf           = ?
               tt-ord-prod.origem                = "CP":U.
    
               /*
               tt-ord-prod.cod-gr-cli            = 
               tt-ord-prod.lote-serie            = 
               tt-ord-prod.prioridade            = 
               tt-ord-prod.narrativa             = 
               tt-ord-prod.emite-ordem           = 
               tt-ord-prod.emite-requis          = 
               */
                   
        /*
        run pi-valida-ord-prod (input tt-ord-prod.ind-tipo-movto,
                                input yes,
                                input tt-ord-prod.nr-ord-produ,
                                output c-erro,
                                output c-texto).
        */      
        
        run utp/ut-acomp.p persistent set h-acomp.
        run pi-inicializar in h-acomp (input "Criando Ordem de Produá∆o").
        run pi-desabilita-cancela in h-acomp.
        run pi-acompanhar in h-acomp (input "Gerando Reservas, Operaá‰es e Rede_PERT").

        run pi-processa-ordens in h-cpapi301 (input-output table tt-ord-prod,
                                              input-output table tt-reapro,
                                              input-output table tt-erro,
                                              input yes).

        assign c-retorno = return-value
               pReturn   = c-retorno.

        run pi-finalizar in h-acomp.
    
        find first tt-erro no-lock no-error.
        if  avail tt-erro THEN DO:
            run cdp/cd0666.w (input table tt-erro).
            ASSIGN pReturn = "NOK".
            LEAVE.
        END.
        if  c-retorno = "ok" then do:
            FIND FIRST tt-ord-prod.
            IF tt-ordem.log-altera-dep-reservas THEN
            DO: 
                /**************************************
                  Altera Dep¢sito das reservas da Ordem 
                 **************************************/
                FOR FIRST ord-prod NO-LOCK  
                    WHERE ROWID(ord-prod) = tt-ord-prod.rw-ord-prod,
                    EACH  breservas NO-LOCK
                    WHERE breservas.nr-ord-produ = ord-prod.nr-ord-produ:
                    FOR EACH ttReservas. DELETE ttReservas. END.
                    CREATE ttReservas.
                    BUFFER-COPY breservas TO ttReservas.

                    ASSIGN ttReservas.r-rowid     = ROWID(breservas)
                           ttReservas.cod-depos   = tt-ordem.dep-reservas
                           ttReservas.cod-localiz = tt-ordem.local-reservas.
                    RUN esbo/esboin390.p (INPUT "MOD",
                                          INPUT TABLE ttReservas,
                                          INPUT-OUTPUT TABLE tt-erro-BO,
                                          OUTPUT l-erro).
                    IF l-erro THEN 
                    DO:
                        FOR EACH tt-erro-bo:
                            CREATE tt-erro.
                            ASSIGN tt-erro.i-sequen = 1
                                   tt-erro.cd-erro  = 17567
                                   tt-erro.mensagem = tt-erro-bo.descricao
                                   c-retorno        = "NOK"
                                   pReturn          = "NOK".
                        END.
                    END.
                END.
            END.

            IF  CAN-FIND(FIRST tt-erro) THEN
            DO:
                RUN cdp/cd0666.w (INPUT TABLE tt-erro).
                ASSIGN pReturn = "NOK".
                LEAVE.
            END.
            ELSE 
            DO:
                FOR FIRST  ord-prod NO-LOCK  
                    WHERE ROWID(ord-prod) = tt-ord-prod.rw-ord-prod:
                    ASSIGN tt-ordem.nr-ord-produ = ord-prod.nr-ord-produ.
                    IF tt-ordem.log-reporta THEN
                    DO:
                        IF lin-prod.sum-requis = 1 THEN
                            RUN piSumariaOrdem.
                        IF CAN-FIND(FIRST tt-erro) THEN
                        DO:
                            ASSIGN pReturn = "NOK".
                            LEAVE.
                        END.
                        run utp/ut-acomp.p persistent set h-acomp.
                        run pi-inicializar in h-acomp (input "Reportando Ordem de Produá∆o").
                        run pi-desabilita-cancela in h-acomp.
                        run pi-acompanhar in h-acomp (input "Reportando Ordem " + STRING(tt-ordem.nr-ord-produ)).
                        RUN piVerificaItemOrdem.
                        RUN piReportaOrdem.
                        run pi-finalizar in h-acomp.
                    END.
                END.
            END.
            IF  CAN-FIND(FIRST tt-erro) THEN DO:
                RUN cdp/cd0666.w (INPUT TABLE tt-erro).
                ASSIGN pReturn = "NOK".
                UNDO BLOCO, LEAVE BLOCO.
            END.
        END.
    END.
   
    IF pReturn = "NOK" THEN
        UNDO BLOCO, LEAVE BLOCO.
END.

if  valid-handle(h-cpapi301) 
then
    DELETE PROCEDURE h-cpapi301.

if  valid-handle(h-cpapi018) 
then
    DELETE PROCEDURE h-cpapi018.

if  valid-handle(h-cpapi001) 
then
    DELETE PROCEDURE h-cpapi001.

ASSIGN h-cpapi301 = ?
       h-cpapi018 = ?
       h-cpapi001 = ?.

PROCEDURE piSumariaOrdem:
    IF ord-prod.nr-req-sum = 0 THEN 
    DO:
        CREATE tt-ord-prod-2.
        BUFFER-COPY ord-prod TO tt-ord-prod-2.
    END.

    IF  CAN-FIND (FIRST tt-ord-prod-2) THEN DO:
        FOR EACH tt-dados. DELETE tt-dados. END.

        CREATE tt-dados.
        ASSIGN tt-dados.requis-por-ordem      = YES
               tt-dados.cod-versao-integracao = 001
               tt-dados.estado                = 1 /* Inclus∆o */.
        run pi-processa-sumaris in h-cpapi018 (input        table tt-dados,
                                               input        table tt-ord-prod-2,
                                               input-output table tt-req-sum,
                                               input-output table tt-erro,
                                               input        no).
    END.
END.

PROCEDURE piReportaOrdem:
    FOR EACH tt-rep-prod.
        DELETE tt-rep-prod.
    END.
      
    /*verificar deposito saida componentes 
    */

    CREATE tt-rep-prod.
    ASSIGN tt-rep-prod.Tipo              = 1
           tt-rep-prod.Nr-reporte        = ord-prod.nr-ord-prod
           tt-rep-prod.Nr-ord-produ      = ord-prod.nr-ord-prod
           tt-rep-prod.it-codigo         = ord-prod.it-codigo
           tt-rep-prod.un                = ord-prod.un
           tt-rep-prod.data              = vDtFatur
           tt-rep-prod.qt-reporte        = ord-prod.qt-ordem
           tt-rep-prod.qt-refugo         = 0
           tt-rep-prod.cod-depos-sai     = ord-prod.cod-depos 
                                            /*IF param-cp.dep-fab-unico = YES THEN 
                                              param-cp.dep-fabrica ELSE ITEM-uni-estab.deposito-pad*/

           tt-rep-prod.cod-local-sai     = ""
           tt-rep-prod.baixa-reservas    = 1
           tt-rep-prod.prog-seg          = pProgOrigem
           tt-rep-prod.nro-docto         = string(ord-prod.nr-ord-prod)
           tt-rep-prod.serie-docto       = "MPE"
           tt-rep-prod.carrega-reservas  = NO  /* YES para carregar tt-reservas da tt-res-neg*/
           tt-rep-prod.reserva           = YES /* YES [Reservas] NO [tt-res-neg] */
           tt-rep-prod.procura-saldos    = NO
           /*tt-rep-prod.requis-automatica = YES*/
           tt-rep-prod.linha             = 20 
           tt-rep-prod.finaliza-ordem    = YES.
    RUN pi-recebe-tt-rep-prod  IN h-cpapi001 (INPUT  TABLE tt-rep-prod).

    RUN pi-carrega-tt-reservas IN h-cpapi001 (INPUT YES,
					                          INPUT 1,
					                          INPUT ?).

    RUN pi-verifica-saldo IN h-cpapi001 (INPUT ord-prod.cod-estabel).

    RUN pi-retorna-tt-reservas IN h-cpapi001 (OUTPUT TABLE tt-reservas).


    FOR EACH tt-erro. DELETE tt-erro. END.
    FOR EACH tt-reservas:
        IF tt-reservas.log-sem-saldo THEN
        DO:
            /*
              Caso n∆o tenha saldo em estoque transfere material via FIFO
            
            MESSAGE 'it-codigo     ' tt-reservas.it-codigo       SKIP
                    'cod-depos     ' tt-reservas.cod-depos       SKIP
                    'log-sem-saldo ' tt-reservas.log-sem-saldo   SKIP
                    'cod-localiz   ' tt-reservas.cod-localiz     SKIP
                    'lote-serie    ' tt-reservas.lote-serie      SKIP
                    'quant-requis  ' tt-reservas.quant-requis    SKIP
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.*/
            
            ASSIGN vQtAlocar = tt-reservas.quant-requis.
            DO WHILE vQtAlocar > 0:
                FIND FIRST saldo-estoq NO-LOCK 
                     WHERE saldo-estoq.cod-estabel = ord-prod.cod-estabel
                     AND   saldo-estoq.it-codigo   = tt-reservas.it-codigo
                     AND   saldo-estoq.cod-refer   = tt-reservas.cod-refer
                     AND   saldo-estoq.cod-depos   = ord-prod.cod-depos 
                     AND   saldo-estoq.cod-localiz = ""
                     AND  (saldo-estoq.qtidade-atu - 
                           (saldo-estoq.qt-alocada  + 
                            saldo-estoq.qt-aloc-ped +  
                            saldo-estoq.qt-aloc-prod)) >= vQtAlocar NO-ERROR.
                IF  NOT AVAIL saldo-estoq THEN 
                    RUN piTransfereMaterial (input ord-prod.cod-estabel,
                                             INPUT tt-reservas.it-codigo,
                                             INPUT tt-reservas.cod-depos,
                                             INPUT tt-reservas.cod-localiz,
                                             INPUT vQtAlocar).
                ELSE ASSIGN vQtAlocar = 0.             

                IF NOT CAN-FIND(FIRST tt-erro) THEN
                     ASSIGN vQtAlocar = vQtAlocar - vQtTransferida.
                ELSE ASSIGN vQtAlocar = 0.

            END.            
        END.
    END.
    FOR EACH tt-erro. DELETE tt-erro. END.
    FOR EACH tt-AtuErro.
        CREATE tt-Erro.
        BUFFER-COPY tt-AtuErro TO tt-Erro.
    END.

    IF NOT CAN-FIND(FIRST tt-erro) THEN
    DO:
        RUN pi-carrega-tt-reservas IN h-cpapi001 (INPUT YES,
                                                  INPUT 1,
                                                  INPUT ?).

        RUN pi-verifica-saldo IN h-cpapi001 (INPUT ord-prod.cod-estabel).

        RUN pi-retorna-tt-reservas IN h-cpapi001 (OUTPUT TABLE tt-reservas).
        FOR EACH  tt-reservas
            WHERE tt-reservas.log-sem-saldo:
            RUN piCriaErro(INPUT "N∆o encontrado saldo para o componente: " + tt-reservas.it-codigo + 
                           " no depos.: " + tt-reservas.cod-depos +
                           " Localiz.: " + tt-reservas.cod-localiz).
        END.

        /*
        FOR EACH tt-reservas:
            CREATE tt-res-neg.
            ASSIGN tt-res-neg.nr-ord-produ  = ord-prod.nr-ord-prod
                   tt-res-neg.quantidade    = tt-reservas.quant-requis
                   tt-res-neg.it-codigo     = tt-reservas.it-codigo
                   tt-res-neg.quantidade    = tt-reservas.quant-requis
                   tt-res-neg.cod-depos     = tt-reservas.cod-depos
                   tt-res-neg.cod-localiz   = tt-reservas.cod-localiz 
                   tt-res-neg.lote-serie    = tt-reservas.lote-serie  
                   tt-res-neg.cod-refer     = tt-reservas.cod-refer   
                   tt-res-neg.dt-vali-lote  = tt-reservas.dt-vali-lote
                   tt-res-neg.positivo      = YES .
        END.*/
    END.

    IF NOT CAN-FIND(FIRST tt-erro) THEN DO:
        IF c-retorno = "nok" THEN 
            RUN piTrataTTerro.
        ELSE DO:
            RUN pi-valida-rep-prod IN h-cpapi001 (INPUT  NO,
                                                  INPUT  ord-prod.nr-ord-prod,
                                                  OUTPUT c-erro,
                                                  OUTPUT c-texto).
            IF  c-retorno = "nok" 
            OR  c-erro <> "" THEN 
                RUN piTrataTTerro.
            ELSE DO:
                RUN pi-valida-ordem	IN h-cpapi001 (INPUT  NO,
                                                   INPUT  ord-prod.nr-ord-prod,
                                                   INPUT  1,
                                                   OUTPUT c-erro,
                                                   OUTPUT c-texto).
                IF c-retorno = "nok" 
                OR c-erro <> "" THEN 
                    RUN piTrataTTerro.
                ELSE DO:
                    RUN pi-valida-reserva IN h-cpapi001 (INPUT  ord-prod.nr-ord-prod,
                                                         INPUT  1,
                                                         INPUT  NO,
                                                         OUTPUT c-erro,
                                                         OUTPUT c-texto).
                    IF c-retorno = "nok" 
                    OR c-erro <> "" THEN 
                        RUN piTrataTTerro.
                    ELSE DO:
                        /*pi-verifica-saldo (input c-cod-estabel)*/
                        RUN pi-processa-reportes IN h-cpapi001 (INPUT-OUTPUT TABLE tt-rep-prod,
                                                                INPUT        TABLE tt-refugo,
                                                                INPUT        TABLE tt-res-neg,
                                                                INPUT-OUTPUT TABLE tt-erro,
                                                                INPUT YES,  /* l-deleta-erros */
                                                                INPUT YES). /* l-gera-reqs    */
                    END.
                END.
            END.
        END.
        ASSIGN c-retorno = RETURN-VALUE.
    END.
    IF CAN-FIND(FIRST tt-erro) THEN
         ASSIGN pReturn = "NOK".
    ELSE ASSIGN pReturn = c-retorno.
    RETURN "".
END.
        
PROCEDURE piCriaErro:
    DEF INPUT PARAM pMsg AS CHAR.

    CREATE tt-erro.
    ASSIGN tt-erro.i-sequen = 1
           tt-erro.cd-erro  = 17567
           tt-erro.mensagem = pMsg.

END PROCEDURE.

PROCEDURE piTrataTTerro:
    DO iCont = 1 TO NUM-ENTRIES(c-erro):
        RUN utp/ut-msgs.p (input "msg",
                           input int (entry (iCont, c-erro)),
                           input entry (iCont, c-texto)).
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = iCont
               tt-erro.cd-erro  = INT(ENTRY(iCont, c-erro))
               tt-erro.mensagem = TRIM(RETURN-VALUE).
    END.
END.


PROCEDURE piTransfereMaterial:
    def input param pCodEstabel as char no-undo.
    DEFINE INPUT PARAM pItCodigo    LIKE reservas.it-codigo    NO-UNDO.
    DEFINE INPUT PARAM pCodDepos    LIKE reservas.cod-depos    NO-UNDO.
    DEFINE INPUT PARAM pCodLocaliz  LIKE reservas.cod-localiz  NO-UNDO.
    DEFINE INPUT PARAM pQuantRequis LIKE reservas.quant-requis NO-UNDO.

    FOR EACH tt-erro: DELETE tt-erro. END.
    FOR EACH tt-item: DELETE tt-item. END.

    FOR FIRST param-estoq NO-LOCK.
    END.

    ASSIGN c-retorno = "".

    FIND FIRST deposito NO-LOCK
         WHERE deposito.cod-depos = pCodDepos NO-ERROR.

    /*Depositos de WMS n∆o possuem saldo AE para transferir*/
    
    IF  AVAIL deposito
    AND deposito.log-gera-wms THEN  DO:
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = 1
               tt-erro.cd-erro  = 17006
               tt-erro.mensagem = "N∆o existe saldo suficiente do item " + pItCodigo + " para montagem da central!"
               c-retorno        = "NOK".
        FOR EACH tt-erro.
            CREATE tt-AtuErro.
            BUFFER-COPY tt-erro TO tt-AtuErro.
        END.

        RETURN.
    END.
        

    ASSIGN lAchouAE = NO.
    FOR EACH  ae-item USE-INDEX fifo 
        WHERE ae-item.cod-estabel = pCodEstabel
        and   ae-item.it-codigo   = pItCodigo
        AND   ae-item.cod-depos   = pCodDepos
        AND   NOT ae-item.situacao 
        AND   ae-item.localizacao <> "":
        ASSIGN lAchouAE = YES.
        FOR FIRST int-saldo-estoq NO-LOCK 
            WHERE int-saldo-estoq.cod-estabel  = pCodEstabel
            AND   int-saldo-estoq.cod-depos    = ae-item.cod-depos    
            AND   int-saldo-estoq.cod-localiz  = ae-item.localizacao
            AND   int-saldo-estoq.it-codigo    = ae-item.it-codigo:
        END.
        IF AVAIL int-saldo-estoq AND int-saldo-estoq.log-bloqueado THEN NEXT.

        /*
        ,FIRST saldo-estoq NO-LOCK 
        WHERE saldo-estoq.it-codigo   = pItCodigo  
        AND   saldo-estoq.cod-estabel = ord-prod.cod-estabel
        AND   saldo-estoq.cod-depos   = ae-item.cod-depos
        AND   saldo-estoq.cod-localiz = ae-item.localizacao:
        */
        CREATE tt-item.
        ASSIGN tt-item.TipoTrans    = 2 /* 2 - Saida */
               tt-item.cod-estabel  = pCodEstabel
               tt-item.it-codigo    = pItCodigo
               tt-item.cod-depos    = ae-item.cod-depos
               tt-item.quantidade   = ae-item.quantidade
               tt-item.serie        = string(ae-item.sequencia)
               tt-item.nro-docto    = string(ae-item.nr-ae)
               tt-item.cod-localiz  = ae-item.localizacao
               tt-item.lote         = ""
               tt-item.dt-vali-lote = ?
               tt-item.cod-refer    = "".
        LEAVE.
    END.
    IF  CAN-FIND(FIRST tt-item) THEN
    DO:
        CREATE tt-item.
        ASSIGN tt-item.TipoTrans    = 1 /* 1 - Entrada*/
               tt-item.cod-estabel  = pCodEstabel
               tt-item.it-codigo    = pItCodigo
               tt-item.cod-depos    = pCodDepos
               tt-item.quantidade   = ae-item.quantidade
               tt-item.serie        = string(ae-item.sequencia) 
               tt-item.nro-docto    = string(ae-item.nr-ae)     
               tt-item.cod-localiz  = pCodLocaliz
               tt-item.lote         = ""
               tt-item.dt-vali-lote = ?
               tt-item.cod-refer    = "".

        /*FOR EACH  saldo-estoq NO-LOCK 
            WHERE saldo-estoq.it-codigo   = pItCodigo  
            AND   saldo-estoq.cod-estabel = pCodEstabel
            AND   saldo-estoq.cod-depos   = ae-item.cod-depos
            AND   saldo-estoq.cod-localiz = ae-item.localizacao:
            MESSAGE pItCodigo  SKIP
                    'qtidade-atu  ' saldo-estoq.qtidade-atu  SKIP
                    'qt-alocada   ' saldo-estoq.qt-alocada   SKIP
                    'qt-aloc-prod ' saldo-estoq.qt-aloc-prod SKIP
                    'qt-aloc-ped  ' saldo-estoq.qt-aloc-ped  SKIP
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.

        END.*/

        RUN esapi/esapi002.p (INPUT 2, /* Transferància Dep¢sitos e Cria Int-Saldo-Estoq */
                              INPUT "ESAPI007",
                              INPUT  TABLE tt-item,
                              OUTPUT TABLE tt-erro).

        FOR EACH tt-erro.
            CREATE tt-AtuErro.
            BUFFER-COPY tt-erro TO tt-AtuErro.
        END.

        IF  NOT AVAIL tt-erro THEN DO:
            RUN PiCriaBaixa (input pCodEstabel).
        /******** CLAUDINEY - 06/12/2005  N«O ESTAVA ATUALIZANDO AS AEÔs *******/
            ASSIGN ae-item.situacao = YES.
        END.
        ELSE 
        /*
        ASSIGN c-retorno = "NOK".

        /*
        IF c-retorno <> "NOK" THEN
        */
        IF c-retorno <> "NOK" AND c-retorno <> "" THEN*/
        DO:
            FOR FIRST saldo-estoq NO-LOCK 
                WHERE saldo-estoq.it-codigo   = pItCodigo
                AND   saldo-estoq.cod-estabel = ord-prod.cod-estabel    
                AND   saldo-estoq.cod-depos   = pCodDepos
                AND   saldo-estoq.cod-localiz = ae-item.localizacao:

                IF (saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada
                                            - saldo-estoq.qt-aloc-prod
                                            - saldo-estoq.qt-aloc-ped) <> ae-item.quantidade THEN
                DO:
                    
                    /*
                    MESSAGE 'item ' pItCodigo SKIP
                        'saldo '(saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada
                                            - saldo-estoq.qt-aloc-prod
                                            - saldo-estoq.qt-aloc-ped) SKIP
                        'qtidade-atu  ' saldo-estoq.qtidade-atu  SKIP 
                        'qt-alocada   ' saldo-estoq.qt-alocada   SKIP
                        'qt-aloc-prod ' saldo-estoq.qt-aloc-prod SKIP
                        'qt-aloc-ped  ' saldo-estoq.qt-aloc-ped  SKIP

                        'Dep / locali' pCodDepos ' / ' ae-item.localizacao SKIP
                        'qtd ' ae-item.quantidade
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    */    
                    FOR EACH  tt-erro
                        WHERE tt-erro.cd-erro  = 19360:
                        DELETE tt-erro.
                        FOR EACH tt-AtuErro
                            WHERE tt-AtuErro.cd-erro  = tt-erro.cd-erro:
                            DELETE tt-AtuErro.
                        END.
                    END.

                    CREATE tt-erro.
                    ASSIGN tt-erro.i-sequen = 1
                           tt-erro.cd-erro  = 17567
                           tt-erro.mensagem = "Saldo da AE.: " + ae-item.localizacao + " para o item.: " + pItCodigo + 
                                              ", diferente do Saldo dispon°vel em estoque."
                           c-retorno        = "NOK".
                    FOR EACH tt-erro.
                        CREATE tt-AtuErro.
                        BUFFER-COPY tt-erro TO tt-AtuErro.
                    END.
                END.
            END.
            FIND FIRST tt-erro
                 WHERE tt-erro.cd-erro  = 17567
                 AND   SUBSTRING(tt-erro.mensagem,1,5) = "Saldo" NO-ERROR.
            IF NOT AVAIL tt-erro THEN
            DO:
                FOR FIRST saldo-estoq NO-LOCK 
                    WHERE saldo-estoq.it-codigo   = pItCodigo
                    AND   saldo-estoq.cod-estabel = ord-prod.cod-estabel    
                    AND   saldo-estoq.cod-depos   = pCodDepos
                    AND   saldo-estoq.cod-localiz = pCodLocaliz:
                    IF (saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada
                                                - saldo-estoq.qt-aloc-prod
                                                - saldo-estoq.qt-aloc-ped) < pQuantRequis THEN
                    DO:
                        CREATE tt-erro.
                        ASSIGN tt-erro.i-sequen = 1
                               tt-erro.cd-erro  = 17567
                               tt-erro.mensagem = "N∆o foi poss°vel fazer FIFO de AE para o item: " + pItCodigo
                               c-retorno        = "NOK".
                        FOR EACH tt-erro.
                            CREATE tt-AtuErro.
                            BUFFER-COPY tt-erro TO tt-AtuErro.
                        END.

                    END.
                END.
            END.
        END.
    END.
    ELSE DO:
        IF NOT lAchouAE THEN
        DO:
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = 1
                   tt-erro.cd-erro  = 17006
                   tt-erro.mensagem = "AE n∆o encontrado para o item " + pItCodigo + "! Favor entrar em contato com Expediá∆o."
                   c-retorno        = "NOK".
            FOR EACH tt-erro.
                CREATE tt-AtuErro.
                BUFFER-COPY tt-erro TO tt-AtuErro.
            END.

        END.
        ELSE IF AVAIL int-saldo-estoq AND int-saldo-estoq.log-bloqueado THEN 
        DO:
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = 1
                   tt-erro.cd-erro  = 17006
                   tt-erro.mensagem = "Item sem Saldo em estoque ou bloqueado para o item " + 
                                       pItCodigo + "! Favor entrar em contato com Expediá∆o."
                   c-retorno        = "NOK".
            FOR EACH tt-erro.
                CREATE tt-AtuErro.
                BUFFER-COPY tt-erro TO tt-AtuErro.
            END.
        END.
    END.
END.


PROCEDURE PiCriaBaixa:
   def input param pCodEstabel as char no-undo.
   
   FIND FIRST ae-baixa NO-LOCK 
        WHERE ae-baixa.cod-estabel = pCodEstabel
        and   ae-baixa.nr-ae     = ae-item.nr-ae 
        AND   ae-baixa.sequencia = ae-item.sequencia NO-ERROR.

   IF NOT AVAIL ae-baixa THEN DO:
      CREATE ae-baixa.
      ASSIGN ae-baixa.cod-estabel = pCodEstabel
             ae-baixa.nr-ae       = ae-item.nr-ae 
             ae-baixa.sequencia   = ae-item.sequencia
             ae-baixa.localizacao = ae-item.localizacao.
   END.
   ASSIGN ae-item.situacao  = YES.
END PROCEDURE.


PROCEDURE piVerificaItemOrdem:
    FOR EACH  reservas NO-LOCK
        WHERE reservas.nr-ord-produ = ord-prod.nr-ord-produ:
        FOR FIRST ITEM FIELDS(it-codigo tipo-requis) EXCLUSIVE-LOCK
            WHERE item.it-codigo = reservas.it-codigo:
            ASSIGN item.tipo-requis = 2.
        END.
    END.
END.
