{include/i-prgvrs.i ESAPI001 2.04.01.001} 
/***********************************************************************
**  Programa..: ESP\ESAPI001.P
**  Autor.....: Medeiros - Gestech 
**  Data......: MAIO/2005 - Desenvolvimento
**  Descricao.: Reporte Produá∆o - Ch∆o de F†brica - RPC
**  Vers∆o....: 001 - 31/05/2005
    Vers∆o....: 002 - 10/07/2013 Emerson Colla - Multi Estabelecimento.
**                  Desenvolvimento Programa
************************************************************************/
{utp/ut-glob.i} 
{cdp/cd0666.i}
{esapi/esapi001tt.i}
{btb/btb008za.i0}
{cep/ceapi001k.i}
{cdp/cd9590.i}
{esp/es0478-rpc.i}

/****************************  Definitions  ************************** */
DEF BUFFER bitem FOR ITEM.

def temp-table tt-rep
    field serie like movto-estoq.serie-docto
    field it-codigo like movto-estoq.it-codigo
    field quantidade as dec format ">>>>9" label "QTD"
    field tipo as logical format "N/S"  /* normal/seletivo */
    field hora as char format "x(5)"
    field nr-ae AS INT /* like ae-item.nr-ae*/
    field cod-depos-ent   like movto-estoq.cod-depos
    field sequencia AS INT /*like ae-item.sequencia*/
    FIELD desc-item         LIKE ITEM.desc-item
    FIELD nr-ord-prod LIKE ord-prod.nr-ord-prod
    FIELD cEtiqueta AS CHAR
    index codigo is primary it-codigo.
    
def temp-table tt-ae
    field numero as rowid
    index tt-ae1 is primary numero. 

def input param pCodEstabel as char no-undo.
DEFINE INPUT        PARAM TABLE FOR ttRepApi.
DEFINE INPUT        PARAM pTipoReporte AS CHAR NO-UNDO. /*Seletivo/Normal*/
DEFINE OUTPUT       PARAM TABLE FOR tt-erro.
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-rep.

DEFINE VARIABLE lReportaChao    AS LOGICAL    NO-UNDO.
def new shared var i-barra as int format 9 init 1 .

DEFINE VARIABLE i-qtd-cont      AS INTEGER    NO-UNDO.
DEFINE VARIABLE da-data         AS DATE       NO-UNDO.
DEF VAR c-livre AS CHAR.

def var i-contenedor    as   int.
def var i-qtd-lote      as   int.
def var i-qtd-resto     as   int.
def var l-segue         as   log  format "Zim/Nao".
def var c-msg-erro      as   char format "x(70)".
def var c-historico as char.

def new shared var l-deu-erro as logical no-undo.

def var h-acomp         as handle  no-undo.
def var i-nr-ae         like ae-item.nr-ae.

DEFINE VARIABLE vArquivo    AS CHARACTER  NO-UNDO.
DEF VAR v_nom_disposit_so AS CHAR NO-UNDO.
DEFINE VARIABLE cPrinter AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h_esapi020 AS HANDLE NO-UNDO.
DEF STREAM LOG.
DEF STREAM sGodoex.
DEF STREAM sZebra.

DEFINE VARIABLE h-reporte AS HANDLE     NO-UNDO.
DEFINE VARIABLE rOrd-prod AS ROWID      NO-UNDO.
DEFINE VARIABLE h-ceapi001k AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-cdapi024 AS HANDLE      NO-UNDO.

DEFINE VARIABLE p-msg-erro AS CHARACTER   NO-UNDO.

{btb/btb008za.i1 esapi/esapi001a.p}

{btb/btb008za.i2 esapi/esapi001a.p '' h-reporte}

RUN piInicializaReporte IN h-reporte (INPUT TABLE ttRepApi,
                                      INPUT pTipoReporte).

DEFINE TEMP-TABLE tt-proces-item NO-UNDO LIKE proces-item.

find first param-cp no-lock no-error.
find first param-sfc no-lock no-error.

def var i-cont          as   int.
def var c-serie         as   char format "x(3)". 

DEFINE VARIABLE cTituloInicializa AS CHARACTER  FORMAT 'x(60)' NO-UNDO.
run utp/ut-acomp.p persistent set h-acomp.  
ASSIGN cTituloInicializa = "Efetuando validaá‰es...".
IF VALID-HANDLE(h-acomp) THEN
   run pi-inicializar in h-acomp (input cTituloInicializa).
run pi-desabilita-cancela in h-acomp.

RUN PiDefineSerie IN h-reporte.
BLOCO:
DO  TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO:

    FOR FIRST ttRepApi:

        FOR FIRST ord-prod NO-LOCK 
            WHERE ord-prod.nr-ord-produ = ttRepApi.nr-ord-produ,
            FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = ord-prod.it-codigo:
        END.

        IF NOT AVAIL ord-prod THEN 
        DO:
            RUN piCriaErro IN h-reporte (INPUT "Ordem Produá∆o Informada n∆o cadastrada.").
            RUN pi-elimina-handles.
            RETURN "NOK".
        END.

        /* Comentado por Emerson - Sempre ser† reporte de Produá∆o
        FOR EACH  oper-ord NO-LOCK
            WHERE oper-ord.nr-ord-produ = ord-prod.nr-ord-produ,
            FIRST grup-maquina OF oper-ord NO-LOCK:
            FIND FIRST ctrab NO-LOCK
                 WHERE ctrab.gm-codigo = grup-maquina.gm-codigo NO-ERROR.
            FIND FIRST split-operac NO-LOCK
                 WHERE split-operac.nr-ord-produ = ord-prod.nr-ord-produ NO-ERROR.

            ASSIGN lReportaChao = AVAIL ctrab AND AVAIL split-operac.
            IF lReportaChao = NO THEN LEAVE.
        END.
        */

        ASSIGN lReportaChao = NO. /* reporte de Produá∆o */

        IF lReportaChao = NO THEN 
        DO:
            ASSIGN cTituloInicializa = "Reportando Produá∆o...".
            IF VALID-HANDLE(h-acomp) THEN
               run pi-inicializar in h-acomp (input cTituloInicializa).
            ASSIGN rOrd-prod = ROWID(ord-prod).
            RUN piReportaProducao IN h-reporte (INPUT pCodEstabel,
                                                INPUT 1,
                                                INPUT ROWID(ord-prod)).  /* CPP */
            RUN piRetornaErro IN h-reporte (OUTPUT TABLE tt-erro).
            IF CAN-FIND(FIRST tt-erro) THEN
            DO:
                IF VALID-HANDLE(h-acomp) THEN run pi-finalizar in h-acomp.
                UNDO, LEAVE BLOCO.
            END.
        END.
        ELSE DO: /* N∆o estamos utilizando */
            ASSIGN cTituloInicializa = "Reportando Ch∆o de F†brica...".
            IF VALID-HANDLE(h-acomp) THEN
               run pi-inicializar in h-acomp (input cTituloInicializa).
            ASSIGN rOrd-prod = ROWID(ord-prod).
            RUN piReportaChaoFabrica IN h-reporte (INPUT ROWID(ord-prod)).
            RUN piRetornaErro IN h-reporte (OUTPUT TABLE tt-erro).
            IF CAN-FIND(FIRST tt-erro) THEN
            DO:
                IF VALID-HANDLE(h-acomp) THEN run pi-finalizar in h-acomp.
                UNDO, LEAVE BLOCO.
            END.
        END.

        FOR FIRST ord-prod NO-LOCK
            WHERE ROWID(ord-prod) = rOrd-prod:
        END.

        FOR FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = ord-prod.it-codigo:
        END.
        
        RUN piRetornaErro IN h-reporte (OUTPUT TABLE tt-erro).
        IF  NOT CAN-FIND(FIRST tt-erro) THEN
            RUN piCriaAe. 
  
        RUN piRetornaErro IN h-reporte (OUTPUT TABLE tt-erro).
        IF  NOT CAN-FIND(FIRST tt-erro) THEN DO:
            CREATE tt-rep.
            ASSIGN tt-rep.it-codigo  = ord-prod.it-codigo
                   tt-rep.quantidade = ttRepApi.qt-reporte
                   tt-rep.hora       = string(time,"HH:MM")
                   tt-rep.serie      = c-serie
                   tt-rep.tipo       = yes
                   tt-rep.desc-item  = ITEM.desc-item
                   tt-rep.nr-ord-prod = ord-prod.nr-ord-prod
                   tt-rep.cod-depos-ent = ttRepApi.depos-ent
                   tt-rep.cEtiqueta = ttRepApi.cEtiqueta.
    
            FOR FIRST ae-item NO-LOCK
                WHERE ae-item.cod-estabel = pCodEstabel
                and   ae-item.nr-ae = i-nr-ae:
            END.
        
            if AVAIL ae-item then 
               assign tt-rep.nr-ae      = ae-item.nr-ae
                      tt-rep.sequencia  = ae-item.sequencia.
    
            
            /* Transferencia automatica para linhas parametrizadas no programa escdp023 */
            
            IF CAN-FIND (FIRST int-lin-prod WHERE int-lin-prod.cod-estabel = ord-prod.cod-estabel AND
                                                  int-lin-prod.nr-linha = ord-prod.nr-linha AND
                                                  int-lin-prod.transf-auto = YES) THEN DO:

                FIND FIRST item-uni-estab 
                     WHERE item-uni-estab.it-codigo   = ITEM.it-codigo AND
                           item-uni-estab.cod-estabel = pCodEstabel NO-LOCK NO-ERROR.

                assign i-contenedor = i-qtd-cont.
                IF VALID-HANDLE(h-acomp) THEN run pi-finalizar in h-acomp.
                RUN piPedeContenedor. 
                IF i-contenedor = 0 THEN 
                   UNDO, LEAVE BLOCO.
                
                ASSIGN c-historico = string(today) + " - " + 
                                     string(time,"HH:MM:SS") + 
                                     " - transferencia automatica no reporte ".
    
                /* revisar este trecho ap¢s reformulaá∆o do es0478-n.p (impress∆o com esapi020.p) */
                /* busca dispositivo de impress∆o */
/*                 ASSIGN v_nom_disposit_so = "".                                                                                                                                */
/*                 IF NUM-ENTRIES(ttRepApi.c-nome-imp, ":":U) = 2 THEN DO:                                                                                                       */
/*                                                                                                                                                                               */
/*                     ASSIGN cPrinter = SUBSTRING(ttRepApi.c-nome-imp, 1, INDEX(ttRepApi.c-nome-imp, ":":U) - 1)                                                                */
/*                            cLayout  = SUBSTRING(ttRepApi.c-nome-imp, INDEX(ttRepApi.c-nome-imp, ":":U) + 1, LENGTH(ttRepApi.c-nome-imp) - INDEX(ttRepApi.c-nome-imp, ":":U)). */
/*                                                                                                                                                                               */
/*                     FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id                                                                                                            */
/*                          WHERE imprsor_usuar.nom_impressora = cPrinter                                                                                                        */
/*                            AND imprsor_usuar.cod_usuario    = c-seg-usuario NO-LOCK NO-ERROR.                                                                                 */
/*                                                                                                                                                                               */
/*                     IF AVAIL imprsor_usuar THEN                                                                                                                               */
/*                         ASSIGN v_nom_disposit_so = imprsor_usuar.nom_disposit_so.                                                                                             */
/*                                                                                                                                                                               */
/*                 END.                                                                                                                                                          */
/*                 ELSE                                                                                                                                                          */
/*                     ASSIGN v_nom_disposit_so = "".                                                                                                                            */
                /* fim */
                
                
/*                 IF v_nom_disposit_so <> "" THEN                       */
/*                     ASSIGN i-barra = 1                                */
/*                            c-livre = "ESSFC001," + v_nom_disposit_so. */

                /* passa impressora para o es0478-n */
                ASSIGN c-livre = "ESSFC001," + ttRepApi.c-nome-imp.
                
                IF NOT VALID-HANDLE(h-acomp) THEN
                   run utp/ut-acomp.p persistent set h-acomp.  
                run pi-desabilita-cancela in h-acomp.
    
                run pi-inicializar in h-acomp (input "Transferindo Material...").
                run pi-acompanhar in h-acomp (input "De.: " + ttRepApi.depos-ent /*tt-rep-prod.cod-depos*/ + 
                                                    "  Para.: " + item-uni-estab.deposito-pad).
    
                run pi-desabilita-cancela in h-acomp.
                
                run esp/es0478-n.p (input ord-prod.it-codigo,    /* item */                            
                                  input ttRepApi.depos-ent,       /* tt-rep-prod.cod-depos - deposito de saida */               
                                  input "",                       /* local de saida */                  
                                  input ttRepApi.qt-reporte,      /* tt-rep-prod.qt-reporte - quantidade total */                
                                  input item-uni-estab.deposito-pad,        /* deposito de entrada */             
                                  input ord-prod.nr-ord-prod,     /* numero docto */                    
                                  input "TRA",                    /* serie */                           
                                  input c-historico,              /* historico */                       
                                  input 0,                        /* numero do AE */                    
                                  input 0,                        /* sequencia do AE */                 
                                  input 0,                        /* roteiro */                         
                                  input 0,                        /* nota */                            
                                  input no,                       /* baixa parcial */                   
                                  input no,                       /* devolucao ou transferencia */      
                                  input i-contenedor,             /* contenedor */                      
                                  input 0,                        /* fornecedor */                      
                                  input 1,                        /* sequencia inicial */               
                                  input no,                       /* usa local informado */             
                                  input "",                       /* local informado */                 
                                  input today,                    /* data movto-estoq */                
                                  input DATE("31/12/9999"),       /* Validade da AE */                  
                                  input c-livre,                  /* Campo Caracter livre */
                                  input pCodEstabel,
                                  OUTPUT table tt-etiqueta,
                                  OUTPUT p-msg-erro).
                                            
                
                IF l-deu-erro THEN DO:
                    IF VALID-HANDLE(h-acomp) THEN run pi-finalizar in h-acomp.
                    ASSIGN c-msg-erro = "Ocorreu um erro na transferencia" .
                    RUN trata-erro.
                    IF VALID-HANDLE(h-acomp) THEN run pi-finalizar in h-acomp.
                    UNDO, LEAVE BLOCO.
                END.
            END.

            /**** Devoluá∆o dos Produtos Compostos ****/

            FOR EACH prod-composto WHERE prod-composto.it-codigo-pai = ord-prod.it-codigo AND
                                         prod-composto.it-codigo-filho <> ord-prod.it-codigo NO-LOCK:
                FIND FIRST reservas WHERE reservas.nr-ord-produ = ord-prod.nr-ord-produ AND
                                          reservas.it-codigo = prod-composto.it-codigo-filho NO-LOCK NO-ERROR.
                IF AVAIL reservas THEN DO:
                    FIND FIRST bitem WHERE bitem.it-codigo = reservas.it-codigo NO-LOCK NO-ERROR.
                    
                    FIND FIRST estrutura WHERE estrutura.it-codigo = prod-composto.it-codigo-pai AND
                                               estrutura.es-codigo = prod-composto.it-codigo-filho NO-LOCK NO-ERROR.
                    IF NOT AVAIL estrutura THEN UNDO, LEAVE BLOCO.

                    FOR EACH tt-movto:
                        DELETE tt-movto.
                    END.
                    
                    create tt-movto.
                    assign tt-movto.cod-versao-integracao    = 1
                           tt-movto.cod-prog-orig            = "essfc001"
                           tt-movto.dt-trans                 = ttRepApi.da-data-reporte
                           tt-movto.nro-docto                = string(reservas.nr-ord-prod)
                           tt-movto.serie-docto              = ""
                           tt-movto.cod-depos                = ttRepApi.depos-ent
                           tt-movto.cod-estabel              = ord-prod.cod-estabel
                           tt-movto.it-codigo                = reservas.it-codigo
                           tt-movto.cod-refer                = ""
                           tt-movto.cod-localiz              = ""
                           tt-movto.lote                     = ""
                           tt-movto.quantidade               = ttRepApi.qt-reporte * estrutura.quant-usada
                           tt-movto.tipo-trans               = 1
                           tt-movto.esp-docto                = 5
                           tt-movto.nr-ord-prod              = reservas.nr-ord-produ
                           tt-movto.numero-ordem             = reservas.op-codigo
                           tt-movto.usuario                  = "Datasul"
                           tt-movto.referencia               = ""
                           tt-movto.un                       = bITEM.un
                           .


                    IF  l-unidade-negocio
                        AND l-mat-unid-negoc THEN DO:

                        run cdp/cdapi024.p persistent set h-cdapi024.

                        if  valid-handle(h-cdapi024) then do:
                            run retornaUnidadeNegocio IN h-cdapi024 (input tt-movto.cod-estabel,
                                                                     input tt-movto.it-codigo,
                                                                     input tt-movto.cod-depos,
                                                                     output tt-movto.cod-unid-negoc).
                
                            delete procedure h-cdapi024.
                            assign h-cdapi024 = ?.
                        end.
                
                    end.

            
                    run cep/ceapi001k.p PERSISTENT SET h-ceapi001k.

                    IF VALID-HANDLE(h-ceapi001k) THEN DO:

                        RUN pi-execute IN h-ceapi001k (input-output table tt-movto,
                                                       input-output table tt-erro,
                                                       input yes).
                        DELETE PROCEDURE h-ceapi001k.
                        ASSIGN h-ceapi001k = ?.

                    END.
                    
                    IF CAN-FIND (FIRST tt-erro) THEN UNDO, LEAVE BLOCO.
                    
                END.
            END.



            /*UNDO, LEAVE BLOCO.*/
        END.
    END.
    IF VALID-HANDLE(h-acomp) THEN run pi-finalizar in h-acomp.

END.
RUN pi-elimina-handles.

PROCEDURE pi-elimina-handles:

    IF VALID-HANDLE(h-acomp) THEN run pi-finalizar in h-acomp.
    
    RUN pi-Destroy IN h-reporte.

    {btb/btb008za.i3 esapi/esapi001a.p h-reporte}

END PROCEDURE.

procedure trata-erro.
   disp skip(1) c-msg-erro skip(2)
        with frame f-segue row 08 centered no-labels
        title " A T E N C A O ! ! ! ! ".
   assign l-segue = no.
   update l-segue label "Voce leu a mensagem acima?" help "Sim/Nao"
   validate(l-segue = yes,"A pergunta deve ser respondida")
   with side-labels frame f-segue centered overlay.
   hide frame f-segue no-pause.
end.

/**** Primeiro Cria a AE para depois imprimir ****/

PROCEDURE piCriaAe:

    ASSIGN i-qtd-cont = ttRepApi.qt-reporte. 
    
    
    FIND FIRST int-lin-prod 
        WHERE int-lin-prod.cod-estabel = pCodEstabel AND
              int-lin-prod.nr-linha = ord-prod.nr-linha NO-LOCK NO-ERROR.
    
    /* Linha cria AE mas n∆o utiliza localizaá∆o automatica*/
    IF int-lin-prod.cria-ae = YES AND
       int-lin-prod.transf-auto = NO THEN DO:
       
       for each tt-ae.
           delete tt-ae.
       end.
       
       FIND FIRST aviso-entrada EXCLUSIVE-LOCK
            WHERE aviso-entrada.cod-estabel = pCodEstabel NO-ERROR.
       IF AVAIL aviso-entrada THEN
            ASSIGN i-nr-ae                 = aviso-entrada.ultimo-ae + 1
                   aviso-entrada.ultimo-ae = i-nr-ae.
       ELSE DO:
            CREATE aviso-entrada.
            ASSIGN aviso-entrada.cod-estabel = pCodEstabel
                   aviso-entrada.ultimo-ae   = 1.

       END.
       
       FIND CURRENT aviso-entrada no-lock no-error.
       
       DO:
            create ae-item.
            assign ae-item.cod-estabel = pCodEstabel
                   ae-item.it-codigo  = ord-prod.it-codigo
                   ae-item.quantidade = i-qtd-cont
                   ae-item.nr-ae      = i-nr-ae
                   ae-item.sequencia  = 1
                   ae-item.nf         = 0
                   ae-item.data       = today
                   ae-item.localizacao = item.cod-localiz
                   ae-item.cod-depos = ttRepApi.depos-ent
                   ae-item.impresso = yes.
        
            /* Linha cria AE j† com status baixada */
            IF int-lin-prod.ae-baixada = YES THEN
                assign ae-item.situacao = yes.
                       
            create tt-ae.
            assign tt-ae.numero = rowid(ae-item).
                                   
       END. /* do transaction */
       
       run piImprimeRep.
    
    end.
END.

PROCEDURE piImprimeRep: /* Em uso */
    IF VALID-HANDLE(h-acomp) THEN run pi-finalizar in h-acomp.

    IF NOT ttRepApi.nao-imprimir THEN DO:

        for each tt-ae no-lock,
            each ae-item where rowid(ae-item) = tt-ae.numero no-lock: 
            
            
            /* Imprime Etiqueta de AE */
    
            IF NOT valid-handle(h_esapi020) THEN 
                RUN esapi/esapi020.p PERSISTENT SET h_esapi020.
    
            RUN pi-imprime-AE IN h_esapi020 (INPUT ttRepApi.c-nome-imp,
                                             INPUT ae-item.cod-estabel,
                                             INPUT ae-item.nr-ae,
                                             INPUT ae-item.sequencia,      
                                             INPUT c-seg-usuario).
    
            
        end.

    END.

END.

PROCEDURE piPedeContenedor: /* Em uso */
    DEFINE BUTTON    btGoToOK       AUTO-GO LABEL "&OK" SIZE 10 BY 1 BGCOLOR 8.
    DEFINE BUTTON    btGoToCancel   AUTO-GO LABEL "&Cancela" SIZE 10 BY 1 BGCOLOR 8.
    DEFINE RECTANGLE rtGoToFields   EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 65 BY 1.3 BGCOLOR 8.
    DEFINE RECTANGLE rtGoToButton   EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 65 BY 1.5 BGCOLOR 7.
    DEFINE VARIABLE  fiNrContenedor AS INTEGER LABEL "Tamanho Contenedor" VIEW-AS FILL-IN  SIZE 10 BY .88 NO-UNDO.

    DEFINE FRAME fPedeContenedor
           fiNrContenedor            AT ROW 1.17 COL 18 COLON-ALIGN 
           rtGoToFields      AT ROW 1    COL 1
           btGoToOK          AT ROW 2.7  COL 2.14
           btGoToCancel      AT ROW 2.7  COL 13.14
           rtGoToButton      AT ROW 2.5  COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Tamanho Contenedor" FONT 1
             DEFAULT-BUTTON btGoToOK.

    ON  "CHOOSE":U OF btGoToOK IN FRAME fPedeContenedor DO:
        ASSIGN i-contenedor = INPUT fiNrContenedor.
        APPLY "GO":U TO FRAME fPedeContenedor.
    END.
    ON  "CHOOSE":U OF btGoToCancel IN FRAME fPedeContenedor DO:
        ASSIGN i-contenedor = 0.
        APPLY "GO":U TO FRAME fPedeContenedor.
    END.
    DISP i-contenedor @ fiNrContenedor WITH FRAME fPedeContenedor.
    ENABLE fiNrContenedor
           btGoToOK 
           btGoToCancel
           WITH FRAME fPedeContenedor.

    WAIT-FOR "GO":U OF FRAME fPedeContenedor.

END PROCEDURE.


