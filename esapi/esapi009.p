{include/i-prgvrs.i ESAPI009 2.04.00.001}
/***********************************************************************
**  Programa..: esapi\esapi009.p
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Efetua a Desmontagem de Itens da Ordem
**  Vers∆o....: 001 22/11/2004 - Marcio Chaves
**                  Desenvolvimento Programa
************************************************************************/
DEF TEMP-TABLE rowerrors   NO-UNDO    /* Temp-table dos erros */
    FIELD errorsequence    AS INT
    FIELD errornumber      AS INT
    FIELD errordescription AS CHAR FORMAT "x(150)"
    FIELD errorparameters  AS CHAR
    FIELD errortype        AS CHAR
    FIELD errorhelp        AS CHAR FORMAT "x(150)"
    FIELD errorsubtype     AS CHAR.
 
{cdp/cdcfgman.i}
{utp/ut-glob.i}
{cdp/cd0666.i}
{cep/ceapi001k.i}
DEFINE VARIABLE hShowMsg AS HANDLE     NO-UNDO.
 
def temp-table tt-raw-transfere
    field raw-registro as raw.
 
def temp-table tt-depos
  field cod-depos  like deposito.cod-depos     
  field nome       like deposito.nome          
  field quantidade like movto-estoq.quantidade
  index dep cod-depos.   
 
def temp-table tt-work NO-UNDO
  field sequencia      as int  form ">>9"               
  field it-codigo      like movto-estoq.it-codigo
  field descricao      as char form "x(60)"             
  field cod-estabel    like movto-estoq.cod-estabel
  field cod-depos      like movto-estoq.cod-depos
  field cod-localiz    like movto-estoq.cod-localiz
  field lote           like movto-estoq.lote
  field dt-vali-lote   like saldo-estoq.dt-vali-lote
  field cod-refer      like movto-estoq.cod-refer
  field ct-codigo      like movto-estoq.ct-codigo
  field sc-codigo      like movto-estoq.sc-codigo  
  field quantidade     like movto-estoq.quantidade    
 &IF DEFINED(bf_man_204) &THEN
  FIELD quant-fixa     LIKE movto-estoq.quantidade
  FIELD l-usa-movto    AS LOGICAL
  FIELD quant-movto    like movto-estoq.quantidade    
  FIELD num-ord-des    LIKE movto-estoq.num-ord-des
  FIELD num-seq-des    LIKE movto-estoq.num-seq-des
 &ENDIF
  field unidade        like movto-estoq.un
  field valor-mat-m    as dec  extent 3  form ">>>>>>,>>>,>>9.99" 
  field valor-ggf-m    as dec  extent 3  form ">>>>>>,>>>,>>9.99" 
  field valor-mob-m    as dec  extent 3  form ">>>>>>,>>>,>>9.99" 
  index seq sequencia
  INDEX geral it-codigo cod-refer cod-estabel cod-depos lote cod-localiz
  INDEX lifo it-codigo cod-refer dt-vali-lote DESCEND lote DESCEND
  INDEX fifo it-codigo cod-refer dt-vali-lote lote.
 
def var de-qtidade-atu              as dec      no-undo.
def var de-qt-alocada               as dec      no-undo.
def var de-qt-aloc-prod             as dec      no-undo.
def var de-qt-aloc-ped              as dec      no-undo.
def var l-cancelou                  as logical  no-undo.
 
def var h-boin172                   as handle   no-undo.
def var h-boin403                   as handle   no-undo.
def var h-boin084                   as handle   no-undo.
 
/* Item */
run inbo/boin172.p  persistent set h-boin172.
run openQueryStatic in h-boin172 (input "Main":U).
 
/* Saldo-estoq */
run inbo/boin403.p  persistent set h-boin403.
run openQuery       in h-boin403 (input 18).
 
/* Dep¢sito */
run inbo/boin084.p persistent set h-boin084.
run openQueryStatic in h-boin084 (input "Main":U).
 
def input param pCodEstabel as char no-undo.
DEFINE INPUT  PARAM pItCodigo   LIKE ITEM.it-codigo                      NO-UNDO.
DEFINE INPUT  PARAM pCodDepos   LIKE ITEM.deposito-pad                   NO-UNDO.
DEFINE INPUT  PARAM pCodLocaliz LIKE ITEM.cod-localiz                    NO-UNDO.
DEFINE INPUT  PARAM pQtDesmonta AS   DECIMAL FORMAT "->>>,>>>,>>9.9999"  NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR tt-erro.
 
/* {esinc/es0005.i pCodEstabel} /* Busca Data Ultimo Faturamento - vDtFatur */  */
    DEFINE VARIABLE vDtFatur AS DATE       NO-UNDO.
   DEFINE BUFFER b-estabelec FOR estabelec.

   FOR FIRST b-estabelec NO-LOCK 
      WHERE b-estabelec.cod-estabel = pCodEstabel,
      FIRST ser-estab NO-LOCK
         WHERE ser-estab.cod-estabel = b-estabelec.cod-estabel
           AND ser-estab.serie       = b-estabelec.serie:
      ASSIGN vDtFatur = ser-estab.dt-ult-fat.
   END.

/*
IF c-seg-usuario = 'adm' THEN
    MESSAGE 'pItCodigo    '  pItCodigo   SKIP
            'pCodDepos    '  pCodDepos   SKIP
            'pCodLocaliz  '  pCodLocaliz SKIP
            'pQtDesmonta  '  pQtDesmonta
            VIEW-AS ALERT-BOX INFO BUTTONS OK.*/
DEF VAR c-conta AS CHAR.
DEF VAR c-ccusto AS CHAR.
 
FOR FIRST param-global NO-LOCK. END.
FOR FIRST param-estoq NO-LOCK. END.
 
session:set-wait-state ("general").
 
DEFINE VARIABLE c-return AS CHARACTER  NO-UNDO.
BLOCO:
DO  TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO:
    run goToKey in h-boin172 (input pItCodigo).
    if  return-value = "NOK":U then 
    DO:
        RUN piCriaErro(INPUT "Item informado n∆o cadastrado.").
        UNDO, LEAVE BLOCO.
    END.
 
    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = pItCodigo:
        FOR FIRST item-uni-estab NO-LOCK
            WHERE item-uni-estab.cod-estabel = pCodEstabel
            AND   item-uni-estab.it-codigo   = ITEM.it-codigo:
            FOR FIRST lin-prod NO-LOCK
                WHERE lin-prod.nr-linha = item-uni-estab.nr-linha:
                ASSIGN c-conta  = lin-prod.ct-ordem
                       c-ccusto = lin-prod.sc-ordem.
            END.
        END.
    END.
 
    IF c-conta = "" THEN
    DO:
        RUN piCriaErro(INPUT "Conta da Ordem n∆o cadastrado para a Linha do Item.").
        UNDO, LEAVE BLOCO.
    END.
    run findEstabel_dep in h-boin403 (input pCodEstabel            ,    /*pCodEstabel, */
                                      input pCodDepos,                  /*fi-cod-depos,   */
                                      input pCodLocaliz,                /*fi-cod-localiz, */
                                      input "",                         /*"",        */
                                      input pItCodigo,                  /*fi-it-codigo,   */
                                      input "",                         /*item.cod-refer,       */
                                      output c-return).
    if  c-return <> "" then do:
        RUN piCriaErro(INPUT c-return).
        UNDO, LEAVE BLOCO.
        /*
        if  item.perm-saldo-neg = 2 then do:
            /* "Item ficara com saldo negativo. Confirma?".*/
            run utp/ut-msgs.p (input "show",
                               input 1794,
                               input "").
            if  return-value = "no" then do:
                UNDO, LEAVE BLOCO.
            end.
        end.*/
    end.      
    else do:
        run getDecField in h-boin403 (input "qtidade-atu":U,  output de-qtidade-atu).
        run getDecField in h-boin403 (input "qt-alocada":U,   output de-qt-alocada).
        run getDecField in h-boin403 (input "qt-aloc-prod":U, output de-qt-aloc-prod).
        run getDecField in h-boin403 (input "qt-aloc-ped":U,  output de-qt-aloc-ped).
        if  pQtDesmonta > (de-qtidade-atu - de-qt-alocada - de-qt-aloc-prod - de-qt-aloc-ped) then do:
            RUN piCriaErro(INPUT "Quantidade para ser desmontada Ç maior que o saldo em estoque. Saldo.: " + 
                           STRING((de-qtidade-atu - de-qt-alocada - de-qt-aloc-prod - de-qt-aloc-ped))).
            UNDO, LEAVE BLOCO.
 
            /*
            if  item.perm-saldo-neg = 2 then do:
                /* "Item ficara com saldo negativo. Confirma?".*/
                run utp/ut-msgs.p (input "show",
                                   input 1794,
                                   input "").
                if  return-value = "no" then
                    UNDO, LEAVE BLOCO.
            end.*/
        end.
    end.
 
    run emptyRowErrors in h-boin172.   
    
    run validaDesmontagem in h-boin172 (input vDtFatur,
                                        input pItCodigo,
                                        input pCodEstabel,
                                        input c-conta ,
                                        input param-global.empresa-prin,
                                        input c-ccusto,
                                        input pCodDepos,
                                        input pCodLocaliz,
                                        input ITEM.un,
                                        input pQtDesmonta,
                                        input "",                   /*Lote */
                                        input ITEM.cod-refer,
                                        input "",                   /*fi-conta-contabil-aplicacao*/ 
                                        input "").                  /*fi-reduzida-aplicacao*/ 
    
    
    RUN getRowErrors IN h-boin172 (OUTPUT TABLE RowErrors).
    
    if  can-find (first RowErrors) then do:
        FOR EACH RowErrors:
            RUN piCriaErro(INPUT RowErrors.errordescription).
            UNDO, LEAVE BLOCO.
        END.
    end.
    else
    DO:
        /*
        def var c-return as char no-undo.
        def var c-nome   as char no-undo.
        */
        assign l-cancelou = yes.
    
        for each tt-raw-transfere:
            delete tt-raw-transfere.
        end.    
    
        /*
        run findDeposito in h-boin084 (input pCodDepos,
                                       output c-return).
        run getCharField in h-boin084 (input "nome":U, output c-nome).*/
    
        create tt-depos.
        assign tt-depos.cod-depos  = pCodDepos
               /*tt-depos.nome       = c-nome*/
               tt-depos.quantidade = pQtDesmonta.
    
        create tt-raw-transfere.          
        raw-transfer tt-depos to tt-raw-transfere.raw-registro.            
        
        ASSIGN l-cancelou = NO.
        /*
        l-cancelou = YES.
        run "cpp/cp0318a.w" (input        pQtDesmonta,
                             input-output table tt-raw-transfere,
                             input-output l-cancelou).
        MESSAGE l-cancelou
            VIEW-AS ALERT-BOX INFO BUTTONS OK.*/
        if  l-cancelou = NO then 
        do:
            run inicializaDesmontagem in h-boin172 (input pItCodigo,
                                                    input vDtFatur,
                                                    input pCodEstabel,
                                                    input "",
                                                    input item.cod-refer,
                                                    input NO,                       /*l-consiste-valor-retorno*/
                                                    input 0,                        /*fi-percentual-acrescimo*/
                                                    input "",                       /*fi-conta-contabil-aplicacao*/
                                                    input "",                       /*centro custo*/
                                                    input-output table tt-depos,
                                                    input-output table tt-work,
                                                    input-output table tt-raw-transfere).
            FOR EACH tt-work:
                ASSIGN tt-work.cod-depos   = pCodDepos
                       tt-work.cod-localiz = pCodLocaliz.
            END.
            find first tt-work no-lock no-error.
            if  avail(tt-work) then do:      
                for each tt-raw-transfere :
                    delete tt-raw-transfere.
                end.
    
                for each tt-work:
                    create tt-raw-transfere.
                    raw-transfer tt-work to tt-raw-transfere.raw-registro.        
                end.
    
                assign l-cancelou = NO.
                
                /*
                assign l-cancelou = yes.
                run "cpp/cp0318c.w" (input-output table tt-raw-transfere,
                                     input        NO,
                                     input-output l-cancelou,
                                     input        pItCodigo).
                                     */
            end.                              
            else do: 
                assign l-cancelou = no.
                for each tt-raw-transfere:
                    delete tt-raw-transfere.
                end.
            end.      
    
            /*
            if  l-cancelou = NO then do:
    
                /* Confirma desmonte ? */
                run utp/ut-msgs.p (input "show",
                                   input 2869,
                                   input "").
                if  return-value = "NO" then 
                    assign l-cancelou = YES.
            end.                      
    
            if  l-cancelou = NO then */
            do: /** Se confirma o desmonte **/                           
    
                session:set-wait-state ("general").
    
                for each tt-movto:  delete tt-movto.   end.   
                for each tt-work:   delete tt-work.    end.
    
                for each tt-raw-transfere:
                    create tt-work.
                    raw-transfer tt-raw-transfere.raw-registro to tt-work.
                end.   
    
                run efetivaDesmontagem in h-boin172 (input param-global.empresa-prin,
                                                     input c-conta,
                                                     input c-ccusto,
                                                     input vDtFatur,
                                                     input "MPE",   /*fi-serie-docto*/
                                                     input STRING(vDtFatur,'999999') + STRING(TIME), /*fi-nro-docto*/
                                                     input pItCodigo,
                                                     input pCodEstabel,
                                                     input pCodDepos,
                                                     input "",
                                                     input item.cod-refer,
                                                     input pCodLocaliz,
                                                     input pQtDesmonta,
                                                     input ITEM.un,
                                                     input "",                  /*fi-conta-contabil-aplicacao*/
                                                     input "",                  /*c-ccusto-aplic*/
                                                     input NO,                  /*tb-atualiza-ultima-entrada*/
                                                     input NO,                  /*l-consiste-valor-retorno*/
                                                     input-output table tt-work,
                                                     output table tt-erro).
 
                if  return-value = "adm-error" then do:
                    if  can-find(FIRST tt-erro) then do :
                        for each tt-movto:
                            delete tt-movto.
                        end.
                        UNDO, LEAVE BLOCO.
                    end.
                end.
            end. 
        end.
    END. /* if  NOT can-find (first RowErrors) then do: */
END. /* DO TRANSACTION */
 
if  valid-handle (h-boin172) then
    run destroy in h-boin172.
 
if  valid-handle (h-boin403) then
    delete procedure h-boin403.
 
if  valid-handle (h-boin084) then
    delete procedure h-boin084.
 
/*
    if  valid-handle (h-boin287) then
        run destroy in h-boin287.       
 
    if  valid-handle (h-boad049) then
        delete procedure h-boad049.
 
    if  valid-handle (h-boad107) then
        delete procedure h-boad107.
 
    if  valid-handle (h-boin377) then
        delete procedure h-boin377.
*/
session:set-wait-state("").
 
PROCEDURE piCriaErro:
    DEF INPUT PARAM pMsg AS CHAR.
 
    CREATE tt-erro.
    ASSIGN tt-erro.i-sequen = 1
           tt-erro.cd-erro  = 17567
           tt-erro.mensagem = pMsg.
 
END PROCEDURE.
