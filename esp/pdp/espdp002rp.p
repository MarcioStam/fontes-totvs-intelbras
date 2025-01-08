/***********************************************************************
**  Programa..: ESP\PDP\ESPDP002RP.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Relat¢rio Saldos do Item do Pedido
**                      (es0254) - Claudiney
**  VersÆo....: 001 26/11/2004
**                  Desenvolvimento Programa
**              002 04/12/2007 - Giovane - Developer
**                  Acrescentada a op‡Æo de classifica‡Æo

compile \\tsclient\c\fontes\esp\pdp\espdp002rp.p save into c:\temp\pdp.

************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESPDP002 2.04.00.001}

/****************************  Definitions  ****************************/
{esp/pdp/espdp002tt.i}
{include/i-rpvar.i}
    
{include/tt-edit.i}
{include/pi-edit.i}


FIND FIRST param-global NO-LOCK.
FIND FIRST empresa NO-LOCK
   WHERE empresa.ep-codigo = param-global.empresa-pri.
/* FIND FIRST estabelec NO-LOCK */
/*    WHERE estabelec.ep-codigo = empresa.ep-codigo. */
/*    */

/****************************  Temp-Tables  ****************************/
def temp-table tt-saldo-item
    FIELD cod-emitente  LIKE ped-venda.cod-emitente
    FIELD nome-abrev    LIKE emitente.nome-emit
    FIELD nr-pedcli     LIKE ped-venda.nr-pedcli
    FIELD nr-pedido     AS INTEGER FORMAT ">>>,>>9"
    field dt-implant    like nota-fiscal.dt-emis-nota
    FIELD cod-sit-aval  LIKE ped-venda.cod-sit-aval
    field nome-transp   like ped-venda.nome-transp
    field cidade-cif    like ped-venda.cidade-cif    
    field i-seq         as int format ">>9"
    FIELD grupo-cli     LIKE emitente.cod-gr-cli
    FIELD observacoes   LIKE ped-venda.observacoes 
    field it-codigo     AS CHAR  FORMAT "X(10)"
    field desc-item     AS CHAR  FORMAT "X(60)"
    field qt-a-atender  as INT FORMAT '>>>9'
    field cod-depos     as DEC EXTENT 14
    field reservas      as dec
    field log-bloq      as log
    INDEX Id nr-pedido i-seq
    INDEX ITEM it-codigo.
    
    
def temp-table tt-tot
    field it-codigo     AS CHAR  FORMAT "X(10)"
    field desc-item     AS CHAR  FORMAT "X(60)"
    field qt-a-atender  as INT FORMAT '>>>9'.
    

    
    

    
/****************************  Variaveis    ****************************/
def var i-cont as int.
def var c-local    as char format "X(13)".
def var cObs as char no-undo.
DEFINE VARIABLE i-cont-copia AS INTEGER     NO-UNDO.

def var c-nr-nota-fis  like nota-fiscal.nr-nota-fis.
def var d-dt-emis-nota like nota-fiscal.dt-emis-nota.
       




    /*def var i-reg as recid.
    def var i-req as int.
    def var i-sequencia as int.
    def var c-arquivo as char format "x(40)".
    def var i-quantidade like ped-item.qt-requisitada.
****************************  Frames       ****************************/
/*
FORM tt-saldo-item.cod-emitente   AT 01
     tt-saldo-item.nome-abrev     AT 30
     tt-saldo-item.nr-pedcli      AT 60
     tt-saldo-item.nr-pedido      AT 95
     WITH FRAME fCabec SIDE-LABELS NO-ATTR-SPACE STREAM-IO WIDTH 132 DOWN.
*/

FORM tt-saldo-item.i-seq         COLUMN-LABEL "Seq"
     tt-saldo-item.it-codigo     COLUMN-LABEL "Item" FORMAT "X(7)"
     tt-saldo-item.desc-item     COLUMN-LABEL "Descri‡Æo" FORMAT "X(80)" 
     tt-saldo-item.qt-a-atender  COLUMN-LABEL "Qtde" FORMAT ">>>>9"
     "---------------------------------------------------------------------------------------------------" 
     WITH FRAME fDetalhe-301 NO-ATTR-SPACE STREAM-IO WIDTH 134 DOWN.
     
FORM tt-tot.it-codigo     COLUMN-LABEL "Item" FORMAT "X(7)"
     tt-tot.desc-item     COLUMN-LABEL "Descri‡Æo" FORMAT "X(80)" 
     tt-tot.qt-a-atender  COLUMN-LABEL "Qtde" FORMAT ">>>>9"
     "---------------------------------------------------------------------------------------------------" 
     WITH FRAME ftot-102 NO-ATTR-SPACE STREAM-IO WIDTH 134 DOWN.
     
     
     
     

FORM tt-saldo-item.i-seq         COLUMN-LABEL "Seq"
     tt-saldo-item.it-codigo     COLUMN-LABEL "Item" FORMAT "X(7)"
     tt-saldo-item.desc-item     COLUMN-LABEL "Descri‡Æo" FORMAT "X(80)" 
     tt-saldo-item.qt-a-atender  COLUMN-LABEL "Qtde" FORMAT ">>>>9" 
     tt-saldo-item.cod-depos[01] COLUMN-LABEL "ALM"  FORMAT ">>>>>>9" 
     tt-saldo-item.cod-depos[02] COLUMN-LABEL "LAB"  FORMAT ">>>>>>9"  
     /*tt-saldo-item.reservas                         FORMAT ">>>>>>>9" 
     when tt-saldo-item.reservas > 0 "** > 5%"
     when tt-saldo-item.reservas > 0 AND (tt-saldo-item.qt-a-atender > tt-saldo-item.reservas * 0.05)*/
     WITH FRAME fDetalhe-102 NO-ATTR-SPACE STREAM-IO WIDTH 134 DOWN.

FORM tt-saldo-item.i-seq         COLUMN-LABEL "Seq"
     tt-saldo-item.it-codigo     COLUMN-LABEL "Item" FORMAT "X(7)"
     tt-saldo-item.desc-item     COLUMN-LABEL "Descri‡Æo" FORMAT "X(56)" 
     tt-saldo-item.qt-a-atender  COLUMN-LABEL "Qtde" FORMAT ">>>>9" 
     tt-saldo-item.cod-depos[01] COLUMN-LABEL "TEL"  FORMAT ">>>>9" 
     tt-saldo-item.cod-depos[02] COLUMN-LABEL "CNT"  FORMAT ">>>>9"  
     tt-saldo-item.cod-depos[03] COLUMN-LABEL "PCI"  FORMAT ">>>>9"  
     tt-saldo-item.cod-depos[04] COLUMN-LABEL "INJ"  FORMAT ">>>>9"  
     tt-saldo-item.cod-depos[05] COLUMN-LABEL "PLC"  FORMAT ">>>>9"  
     tt-saldo-item.cod-depos[06] COLUMN-LABEL "ISF"  FORMAT ">>>>>9"  
     tt-saldo-item.cod-depos[08] COLUMN-LABEL "AST"  FORMAT ">>>>>9"  
     tt-saldo-item.cod-depos[09] COLUMN-LABEL "PDO"  FORMAT ">>>>>9"  
     tt-saldo-item.cod-depos[14] COLUMN-LABEL "OUT"  FORMAT ">>>>>>9" 
     /*tt-saldo-item.reservas                         FORMAT ">>>>>>>9" 
     when tt-saldo-item.reservas > 0 "** > 5%"
     when tt-saldo-item.reservas > 0 AND (tt-saldo-item.qt-a-atender > tt-saldo-item.reservas * 0.05)*/
     WITH FRAME fDetalhe-101 NO-ATTR-SPACE STREAM-IO WIDTH 134 DOWN.

form header
    "Ped Cli      Cliente         C¢digo      Pedido Seq  Qtde     ALM     LAB Observa‡äes" at 1 skip
    "------------ ------------ --------- ----------- --- ----- ------- ------- --------------------------------------------------------" at 1 skip    with frame fCabec-2 no-labels no-attr-space stream-io page-top width 132.  
    
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/*
 * for each tt-raw-digita:
 *     create tt-digita.
 *     raw-transfer tt-raw-digita.raw-digita to tt-digita.
 * end. 
 */

def var h-acomp      as handle no-undo.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relat¢rio Saldo dos Itens do Pedido"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESPDP002"
       c-versao       = "2.04"
       c-revisao      = "002".

if tt-param.cod-estabel = "102" then do:
   find first atendente where
              atendente.cd-oper = int(tt-param.tp-pedido-ini) no-lock no-error.
              
   assign c-empresa = string(tt-param.tp-pedido-ini) +  " - " + string(atendente.nm-oper).
   
   end.
   



/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i}
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

   run utp/ut-acomp.p persistent set h-acomp.  

   run pi-inicializar in h-acomp (input "Montando Relat¢rio...").
   run piMontaRelat.
   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.
   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
end.

/* **********************  Internal Procedures  *********************** */
PROCEDURE piMontaRelat:
    EMPTY TEMP-TABLE tt-saldo-item.
    IF tt-param.nr-nota-fisc = "" THEN
        FOR EACH  ped-venda NO-LOCK 
            WHERE ped-venda.cod-sit-ped < 3
            AND   ped-venda.nr-pedido   >= tt-param.nr-pedido-ini
            AND   ped-venda.nr-pedido   <= tt-param.nr-pedido-fim
            AND   ped-venda.dt-implant  >= tt-param.dt-implant-ini
            AND   ped-venda.dt-implant  <= tt-param.dt-implant-fim
            AND   ped-venda.tp-pedido   >= tt-param.tp-pedido-ini
            AND   ped-venda.tp-pedido   <= tt-param.tp-pedido-fim
            AND   ped-venda.cod-priori  >= tt-param.prioridade-ini
            AND   ped-venda.cod-priori  <= tt-param.prioridade-fim
             use-index ch-implant,
            first emitente no-lock
            where emitente.nome-abrev = ped-venda.nome-abrev:
            
            if ped-venda.cod-estabel ne tt-param.cod-estabel then next.
            
            RUN pi-acompanhar IN h-acomp (INPUT "Pedido.: " + ped-venda.nr-pedcli).
            /* agrupamento de itens iguais */
            
            
                                 
                   
    
            ASSIGN i-cont = 0.
            FOR EACH  ped-item FIELDS(ped-item.it-codigo ped-item.qt-pedida ped-item.qt-alocada) OF ped-venda 
                WHERE (ped-item.qt-pedida - 
                       ped-item.qt-alocada) > 0 
                AND ped-item.cod-sit-item < 3 NO-LOCK:

                IF tt-param.consolidado = 1 THEN DO:
                    FIND FIRST tt-saldo-item 
                         WHERE tt-saldo-item.nr-pedido = ped-venda.nr-pedido 
                         AND   tt-saldo-item.it-codigo = ped-item.it-codigo NO-ERROR.
                    IF NOT AVAIL tt-saldo-item THEN DO:
                        ASSIGN i-cont = i-cont + 1.
                        CREATE tt-saldo-item.
                    END.
                END.
                ELSE DO:
                    ASSIGN i-cont = i-cont + 1.
                    CREATE tt-saldo-item.
                END.

                ASSIGN tt-saldo-item.i-seq          = i-cont
                       tt-saldo-item.cod-emitente   = ped-venda.cod-emitente
                       tt-saldo-item.nome-abrev     = emitente.nome-emit
                       tt-saldo-item.nr-pedcli      = ped-venda.nr-pedcli
                       tt-saldo-item.nr-pedido      = ped-venda.nr-pedido 
                       tt-saldo-item.dt-implant     = ped-venda.dt-implant
                       tt-saldo-item.cidade-cif     = ped-venda.cidade-cif
                       tt-saldo-item.cod-sit-aval   = ped-venda.cod-sit-aval
                       tt-saldo-item.nome-transp    = ped-venda.nome-transp 
                       tt-saldo-item.observacoes    = ped-venda.observacoes
                       tt-saldo-item.grupo-cli      = emitente.cod-gr-cli
                       tt-saldo-item.it-codigo      = ped-item.it-codigo
                       tt-saldo-item.qt-a-atender   = tt-saldo-item.qt-a-atender + (ped-item.qt-pedida - 
                                                                                    ped-item.qt-alocada).
           
            END.
        END.
    ELSE DO:
        FOR EACH ped-venda NO-LOCK
            WHERE ped-venda.nr-pedido     = tt-param.nr-pedido-ini,
            EACH nota-fiscal 
            WHERE nota-fiscal.nome-ab-cli = ped-venda.nome-abrev
              AND nota-fiscal.nr-pedcli   = ped-venda.nr-pedcli
              AND nota-fiscal.nr-nota-fis = tt-param.nr-nota-fisc NO-LOCK,
            first emitente no-lock
            where emitente.nome-abrev = ped-venda.nome-abrev,
            EACH it-nota-fisc OF nota-fiscal NO-LOCK:

                IF tt-param.consolidado = 1 THEN DO:

                    FIND FIRST tt-saldo-item 
                         WHERE tt-saldo-item.nr-pedido = ped-venda.nr-pedido 
                         AND   tt-saldo-item.it-codigo = it-nota-fisc.it-codigo NO-ERROR.

                    IF NOT AVAIL tt-saldo-item THEN DO:
                        ASSIGN i-cont = i-cont + 1.
                        CREATE tt-saldo-item.
                    END.
                END.
                ELSE DO:
                    ASSIGN i-cont = i-cont + 1.
                    CREATE tt-saldo-item.
                END.
    
                ASSIGN tt-saldo-item.i-seq          = i-cont
                       tt-saldo-item.cod-emitente   = ped-venda.cod-emitente
                       tt-saldo-item.nome-abrev     = emitente.nome-emit
                       tt-saldo-item.nr-pedcli      = ped-venda.nr-pedcli
                       tt-saldo-item.nr-pedido      = ped-venda.nr-pedido 
                       tt-saldo-item.dt-implant     = ped-venda.dt-implant
                       tt-saldo-item.cidade-cif     = ped-venda.cidade-cif
                       tt-saldo-item.cod-sit-aval   = ped-venda.cod-sit-aval
                       tt-saldo-item.nome-transp    = ped-venda.nome-transp 
                       tt-saldo-item.observacoes    = ped-venda.observacoes
                       tt-saldo-item.grupo-cli      = emitente.cod-gr-cli
                       tt-saldo-item.it-codigo      = it-nota-fisc.it-codigo
                       tt-saldo-item.qt-a-atender   = tt-saldo-item.qt-a-atender + it-nota-fisc.qt-faturada[1].
        END.
    END.
    FOR EACH tt-saldo-item:
        FOR EACH  saldo-estoq fields(saldo-estoq.cod-estabel saldo-estoq.cod-depos saldo-estoq.cod-localiz 
                                     saldo-estoq.lote saldo-estoq.it-codigo saldo-estoq.cod-refer saldo-estoq.qtidade-atu) NO-LOCK 
            WHERE saldo-estoq.cod-estabel = tt-param.cod-estabel
            AND   saldo-estoq.it-codigo = tt-saldo-item.it-codigo:
            
            FOR FIRST int-saldo-estoq NO-LOCK
                WHERE int-saldo-estoq.cod-estabel  = saldo-estoq.cod-estabel  
                AND   int-saldo-estoq.cod-depos    = saldo-estoq.cod-depos    
                AND   int-saldo-estoq.cod-localiz  = saldo-estoq.cod-localiz  
                AND   int-saldo-estoq.lote         = saldo-estoq.lote         
                AND   int-saldo-estoq.it-codigo    = saldo-estoq.it-codigo    
                AND   int-saldo-estoq.cod-refer    = saldo-estoq.cod-refer:            
/*                {dbini/es322.i1 int-saldo-estoq saldo-estoq}: Comentado devido a problema de compila‡Æo no unix. Giovane ir  verificar. */
            
                ASSIGN tt-saldo-item.log-bloq = int-saldo-estoq.log-congelado.
            END.
            IF  NOT AVAIL tt-saldo-item THEN
                ASSIGN tt-saldo-item.log-bloq = NO.
            
            RUN pi-acompanhar IN h-acomp (INPUT "Saldo do Item.: " + saldo-estoq.it-codigo).


            if tt-param.cod-estabel = "101" OR
               tt-param.cod-estabel = "104" then do:
                CASE saldo-estoq.cod-depos:
                     WHEN "tel" then assign tt-saldo-item.cod-depos[01] = tt-saldo-item.cod-depos[01] + saldo-estoq.qtidade-atu.
                     WHEN "cnt" then assign tt-saldo-item.cod-depos[02] = tt-saldo-item.cod-depos[02] + saldo-estoq.qtidade-atu.
                     WHEN "pci" then assign tt-saldo-item.cod-depos[03] = tt-saldo-item.cod-depos[03] + saldo-estoq.qtidade-atu.
                     WHEN "inj" then assign tt-saldo-item.cod-depos[04] = tt-saldo-item.cod-depos[04] + saldo-estoq.qtidade-atu.       
                     WHEN "win" then assign tt-saldo-item.cod-depos[04] = tt-saldo-item.cod-depos[04] + saldo-estoq.qtidade-atu.
                     WHEN "plc" then assign tt-saldo-item.cod-depos[05] = tt-saldo-item.cod-depos[05] + saldo-estoq.qtidade-atu.
                     WHEN "isf" then assign tt-saldo-item.cod-depos[06] = tt-saldo-item.cod-depos[06] + saldo-estoq.qtidade-atu.
                     
                     WHEN "ast" then do:
                          IF saldo-estoq.cod-localiz <> "kanbam" then
                             ASSIGN tt-saldo-item.cod-depos[08] = tt-saldo-item.cod-depos[08] + saldo-estoq.qtidade-atu.
                     END.
                     WHEN "PDO" then assign tt-saldo-item.cod-depos[09] = tt-saldo-item.cod-depos[09] + saldo-estoq.qtidade-atu.
                     
                     OTHERWISE ASSIGN tt-saldo-item.cod-depos[14] = tt-saldo-item.cod-depos[14] + saldo-estoq.qtidade-atu.
                end.
    
            end.
            else if tt-param.cod-estabel = "102" then do:
                CASE saldo-estoq.cod-depos:
                   WHEN "alm" then assign tt-saldo-item.cod-depos[01] = tt-saldo-item.cod-depos[01] + saldo-estoq.qtidade-atu.
                   WHEN "wal" then assign tt-saldo-item.cod-depos[01] = tt-saldo-item.cod-depos[01] + saldo-estoq.qtidade-atu.
                   WHEN "lab" then assign tt-saldo-item.cod-depos[02] = tt-saldo-item.cod-depos[02] + saldo-estoq.qtidade-atu.
                END.
            end.    
        END.
    END.
    
    for each tt-saldo-item:
    find first tt-tot where 
               tt-tot.it-codigo = tt-saldo-item.it-codigo no-error.
               if not avail tt-tot then do:
                  find first item where  
                             item.it-codigo = tt-saldo-item.it-codigo no-lock no-error.
                             
                  create tt-tot.
                  assign tt-tot.it-codigo    = tt-saldo-item.it-codigo
                         tt-tot.desc-item    = item.desc-item
                         tt-tot.qt-a-atender = tt-saldo-item.qt-a-atender.
               end.
               else assign tt-tot.qt-a-atender = tt-tot.qt-a-atender + tt-saldo-item.qt-a-atender.
               
    end.
               

    
    

END PROCEDURE.



PROCEDURE piImprimeRelat:
    DEFINE VARIABLE l-obs AS LOGICAL NO-UNDO.


    DO i-cont-copia = 1 TO tt-param.nr-copias:
        FOR EACH tt-saldo-item,
            FIRST ITEM FIELDS(it-codigo desc-item cod-localiz) NO-LOCK
            WHERE ITEM.it-codigo = tt-saldo-item.it-codigo
            BREAK by (if tt-param.classifica = 1 then string(tt-saldo-item.nr-pedido) else tt-saldo-item.nome-abrev)
                  BY tt-saldo-item.nr-pedido:
    
            RUN pi-acompanhar IN h-acomp (INPUT "Item.: " + ITEM.it-codigo).
            IF FIRST-OF(tt-saldo-item.nr-pedido) THEN DO:
                /*
                DISP tt-saldo-item.cod-emitente LABEL "Cod. Cliente"
                     tt-saldo-item.nome-abrev   LABEL "" 
                     tt-saldo-item.nr-pedcli 
                     tt-saldo-item.nr-pedido
                     WITH FRAME fCabec.
                */
    
                PUT "Cliente:" tt-saldo-item.cod-emitente
                    " - " 
                    tt-saldo-item.nome-abrev.  
                    
                IF  tt-saldo-item.cod-sit-aval = 3 THEN PUT " ** APROVADO ** ".
                                                   ELSE PUT " ** NAO APROVADO ** ".
                                                   
                    /* "Pedido Cliente: " tt-saldo-item.nr-pedcli */ 

                FIND gr-cli
                    WHERE gr-cli.cod-gr-cli = tt-saldo-item.grupo-cli
                    NO-LOCK NO-ERROR.
                put " Pedido: " tt-saldo-item.nr-pedido
                    " Transp: " tt-saldo-item.nome-transp
                    " C.CIF: " tt-saldo-item.cidade-cif skip            
                    "Data Pedido: " tt-saldo-item.dt-implant SKIP.
                IF AVAIL gr-cli THEN
                   PUT
                    "Grp Cliente: " tt-saldo-item.grupo-cli " - " gr-cli.descricao.
                   
                     
    
                run pi-print-editor(INPUT replace(replace(tt-saldo-item.observacoes, chr(13), " "), chr(10), " ") ,
                        INPUT 80).
    
                ASSIGN l-obs = NO.
                IF CAN-FIND (FIRST tt-editor) THEN DO:
                   PUT " " SKIP(1).
                   FOR EACH tt-editor NO-LOCK:
                      IF NOT (l-obs) THEN DO:
                         PUT "Observa‡äes: " tt-editor.conteudo SKIP.
                         ASSIGN l-obs = YES.
                      END.
                      ELSE
                         PUT "             " tt-editor.conteudo SKIP.
                   END.
                   PUT " " SKIP(1).
                END.
    
    /*            ASSIGN cObs = TRIM(REPLACE(tt-saldo-item.observacoes, CHR(13), CHR(10))).
                DO i = 1 TO NUM-ENTRIES(cObs,CHR(10)):
                    RUN pi-print-editor(INPUT ENTRY(i, cObs, CHR(10)), INPUT 120).
                    FOR EACH tt-editor:
                    END.
                END. */
    
            END.
    
    /*        FIND FIRST ae-item NO-LOCK USE-INDEX fifo 
                 WHERE ae-item.it-codigo = tt-saldo-item.it-codigo 
                 AND   ae-item.situacao  = NO NO-ERROR.
            IF   AVAIL ae-item AND ae-item.localizacao <> "" THEN 
                 ASSIGN c-local = ae-item.localizacao.
            ELSE ASSIGN c-local = item.cod-localiz.
      
            IF tt-saldo-item.log-bloq then
               ASSIGN c-local = "(*)" + c-local.
      */
            ASSIGN tt-saldo-item.desc-item = item.desc-item.
    
            if tt-param.cod-estabel = "101" then do:
                DISP tt-saldo-item.i-seq
                     tt-saldo-item.it-codigo    FORMAT 'x(7)'
                     tt-saldo-item.desc-item    FORMAT 'x(56)'
                     tt-saldo-item.qt-a-atender FORMAT '>>>9'
                     tt-saldo-item.cod-depos[01]
                     tt-saldo-item.cod-depos[02]
                     tt-saldo-item.cod-depos[03]
                     tt-saldo-item.cod-depos[04]
                     tt-saldo-item.cod-depos[05]
                     tt-saldo-item.cod-depos[06]
                     
                     tt-saldo-item.cod-depos[08]
                     tt-saldo-item.cod-depos[09]
                     tt-saldo-item.cod-depos[14] 
                     WITH FRAME fDetalhe-101.
                DOWN WITH FRAME fDetalhe-101.
            
            end.        
            else if tt-param.cod-estabel = "102" then do:    
    
                DISP tt-saldo-item.i-seq
                     tt-saldo-item.it-codigo    FORMAT 'x(7)'
                     tt-saldo-item.desc-item    FORMAT 'x(80)'
                     tt-saldo-item.qt-a-atender FORMAT '>>>9'
                     tt-saldo-item.cod-depos[01]
                     tt-saldo-item.cod-depos[02]
                     WITH FRAME fDetalhe-102.
                DOWN WITH FRAME fDetalhe-102.
            end.
            else if tt-param.cod-estabel = "103" OR
                    tt-param.cod-estabel = "301" then do:
                DISP tt-saldo-item.i-seq
                     tt-saldo-item.it-codigo    FORMAT 'x(7)'
                     tt-saldo-item.desc-item    FORMAT 'x(80)'
                     tt-saldo-item.qt-a-atender FORMAT '>>>9'
                     WITH FRAME fDetalhe-301.
                DOWN WITH FRAME fDetalhe-301.
            end.
            
            
              IF LAST-OF(tt-saldo-item.nr-pedido) THEN DO:
                 PUT " " SKIP
                     "Atendente:_______________________________________  Conferente:_______________________________________   Data: _____/_____/_________" SKIP(4)
                     "(  ) SEDEX "         SKIP
                     "(  ) MALOTE "        SKIP
                     "(  ) TRANSPORTADORA" SKIP.
              end.
                     
            
        END.
        if tt-param.cod-estabel = "102" then do:
        
                page.
                
                for each tt-tot by tt-tot.desc-item:
                
                    disp tt-tot.it-codigo
                         tt-tot.desc-item
                         tt-tot.qt-a-atender with frame fTot-102.
                         down with frame fTot-102.
                         
                end.
        
        end.
        PAGE.
    END.     
    
    

    
    
END PROCEDURE.





