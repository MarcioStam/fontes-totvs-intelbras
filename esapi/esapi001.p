{include/i-prgvrs.i ESAPI001 2.04.01.001} 
/***********************************************************************
**  Programa..: ESP\ESAPI001.P
**  Autor.....: Medeiros - Gestech 
**  Data......: MAIO/2005 - Desenvolvimento
**  Descricao.: Reporte Produá∆o - Ch∆o de F†brica - RPC
**  Vers∆o....: 001 - 31/05/2005
**                  Desenvolvimento Programa
************************************************************************/
{utp/ut-glob.i} 
{cdp/cd0666.i}
{esapi/esapi001tt.i}
{btb/btb008za.i0}
{esp/es0018.i}
{esp/es0478-rpc.i}

/****************************  Definitions  ************************** */
def temp-table tt-rep
    field rep-tra as logical format "R/T"
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

def input param pCodEstabel as char no-undo.
DEFINE INPUT        PARAM TABLE FOR ttRepApi.
DEFINE INPUT        PARAM pTipoReporte AS CHAR NO-UNDO. /*Seletivo/Normal*/
DEFINE OUTPUT       PARAM TABLE FOR tt-erro.
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-rep.

DEFINE VARIABLE lReportaChao    AS LOGICAL    NO-UNDO.

DEFINE VARIABLE i-qtd-cont      AS INTEGER    NO-UNDO.
DEFINE VARIABLE c-linha         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE da-data         AS DATE       NO-UNDO.
DEF VAR c-livre AS CHAR.

def var i-it-digito     as   int  format "9".
def var i-contenedor    as   int.
def var i-qtd-lote      as   int.
def var i-qtd-resto     as   int.
def var l-segue         as   log  format "Zim/Nao".
def var c-msg-erro      as   char format "x(70)".
def var c-historico as char.

def new shared var l-deu-erro as logical no-undo.
def new shared var i-barra as int format 9 init 1 .

def var h-acomp         as handle  no-undo.
def var i-nr-ae         like ae-item.nr-ae.

DEFINE VARIABLE vArquivo    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-impressora AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-form       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCont        AS INTEGER    NO-UNDO.

DEFINE VARIABLE p-msg-erro AS CHARACTER   NO-UNDO.

DEF STREAM LOG.
DEF STREAM sGodoex.
DEF STREAM sZebra.

DEFINE VARIABLE h-reporte AS HANDLE     NO-UNDO.
DEFINE VARIABLE rOrd-prod AS ROWID      NO-UNDO.

{btb/btb008za.i1 esapi/esapi001a.p}

{btb/btb008za.i2 esapi/esapi001a.p '' h-reporte}

RUN piInicializaReporte IN h-reporte (INPUT TABLE ttRepApi,
                                      INPUT pTipoReporte).

DEFINE TEMP-TABLE tt-proces-item NO-UNDO LIKE proces-item.

def temp-table tt-log
    field tipo AS CHAR 
    field seletivo as char format "x(8)"
    field hora-ini as char
    field h-ini as int
    field etiqueta AS CHAR
    field nr-itens as int
    field t1 as int 
    field t2 as int
    field t3 as int
    field erro as char format "x(100)".

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
        ASSIGN c-impressora = ttRepApi.c-nome-imp
               c-form       = ttRepApi.cNomeLayout
               iCont        = 0.       

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
        ELSE DO:
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
            RUN piImprimeRep.
  
        RUN piRetornaLog IN h-reporte (OUTPUT TABLE tt-log,
                                       OUTPUT c-serie).

        
        /* registro de log retirado em 10/07/2006 em funcao de nao haver nenhuma consulta 
        aos logs gerados H· mais de um ano.
                                       
        RUN piImprimeLog.

        */
       
        RUN piRetornaErro IN h-reporte (OUTPUT TABLE tt-erro).
        IF  NOT CAN-FIND(FIRST tt-erro) THEN DO:
            CREATE tt-rep.
            ASSIGN tt-rep.it-codigo  = ord-prod.it-codigo
                   tt-rep.quantidade = ttRepApi.qt-reporte
                   tt-rep.hora       = string(time,"HH:MM")
                   tt-rep.serie      = c-serie
                   tt-rep.tipo       = yes
                   tt-rep.rep-tra    = yes
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
    
            /** Neste ponto devem ser inclu°das as chamadas para o es0478 para
                transferància dos reportes do dep¢sito ACA para o EXP */
            /*    
            if item.fm-cod-com begins "5010" /* Gondola */ then do:
                IF VALID-HANDLE(h-acomp) THEN run pi-finalizar in h-acomp.
                FIND FIRST contenedor no-lock 
                    WHERE contenedor.it-codigo = item.it-codigo NO-ERROR.
                if avail contenedor then 
                    i-contenedor = contenedor.lote-multipl.    
                else DO:
                    assign i-contenedor = i-qtd-cont.
                    RUN piPedeContenedor.
                    IF i-contenedor = 0 THEN 
                        undo bloco, leave bloco.
                END.
                
                find first it-altern no-lock
                    where it-altern.it-altern = item.it-codigo no-error.
                
                if c-seg-usuario = "ADM" then
                    message "Contenedor: " i-contenedor skip
                            "Quantidade: " tt-rep.quantidade skip
                            view-as alert-box title "Iniciando a transferància".
                    
                STATUS DEFAULT "Processando a transferància. Por favor aguarde".
                SESSION:SET-WAIT-STATE("GENERAL":U).
                RUN esp/es0973.r.

                ASSIGN c-historico = string(today) + " - " + 
                                     string(time,"HH:MM:SS") + 
                                     " - transferencia automatica no reporte ".
    
                IF ttRepApi.c-nome-imp = "Zebra" THEN
                    ASSIGN i-barra = 1
                           c-livre = "ESSFC001," + ttRepApi.cNomeLayout.
                ELSE
                    ASSIGN i-barra = 3.
                    
                l-deu-erro = NO.
        
                run esp/es0478-n.p (
                      input if avail it-altern then it-altern.it-codigo else item.it-codigo, /* item */
                      input "ACA",                                                           /* deposito de saida */                
                      input "",                                                              /* local de saida */
                      input tt-rep.quantidade,                                               /* quantidade total */
                      input "EXP",                                                           /* deposito de entrada */
                      input 0,                                                               /* numero docto */
                      input "TRA",                                                           /* serie */
                      input string(today) + " - " + string(time,"HH:MM:SS"),                 /* historico */
                      input 0,                                                               /* numero do AE */
                      input 0,                                                               /* sequencia do AE */
                      input 0,                                                               /* roteiro */  
                      input 0,                                                               /* nota */
                      input no,                                                              /* baixa parcial */
                      input no,                                                              /* devolucao ou transferencia */
                      input i-contenedor,                                                    /* contenedor */
                      input 0,                                                               /* fornecedor */
                      input 1,                                                               /* sequencia inicial */
                      input no,                                                              /* usa local informado */
                      input "",                                                              /* local destino */
                      input today,                                                           /* data movto-estoq */
                      input ?,                                                               /* Validade da AE */
                      input c-livre,                                                         /* Campo Caracter livre */
                      input pCodEstabel
                      ).   
                SESSION:SET-WAIT-STATE("":U).
                STATUS DEFAULT.
                IF l-deu-erro THEN RUN trata-erro.
        
            end.
            */
            /* incluir aqui a transferencia para localizacao automatica na injecao */
            IF  ord-prod.nr-linha = 4 THEN DO:
                assign i-contenedor = i-qtd-cont.
                IF VALID-HANDLE(h-acomp) THEN run pi-finalizar in h-acomp.
                RUN piPedeContenedor.
                IF i-contenedor = 0 THEN 
                   UNDO, LEAVE BLOCO.
                
                ASSIGN c-historico = string(today) + " - " + 
                                     string(time,"HH:MM:SS") + 
                                     " - transferencia automatica no reporte ".
    
                IF ttRepApi.c-nome-imp = "Zebra" THEN
                    ASSIGN i-barra = 1
                           c-livre = "ESSFC001," + ttRepApi.cNomeLayout.
                ELSE
                    ASSIGN i-barra = 3.

                IF NOT VALID-HANDLE(h-acomp) THEN
                   run utp/ut-acomp.p persistent set h-acomp.  
                run pi-desabilita-cancela in h-acomp.
    
                run pi-inicializar in h-acomp (input "Transferindo Material...").
                run pi-acompanhar in h-acomp (input "De.: " + ttRepApi.depos-ent /*tt-rep-prod.cod-depos*/ + 
                                                    "  Para.: " + item.deposito-pad).
    
                run pi-desabilita-cancela in h-acomp.
                
                run esp/es0478-n.p (input ord-prod.it-codigo,    /* item */                            
                                  input ttRepApi.depos-ent,       /* tt-rep-prod.cod-depos - deposito de saida */               
                                  input "",                       /* local de saida */                  
                                  input ttRepApi.qt-reporte,      /* tt-rep-prod.qt-reporte - quantidade total */                
                                  input item.deposito-pad,        /* deposito de entrada */             
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
            /*UNDO, LEAVE BLOCO.*/
        END.
    END.
    IF VALID-HANDLE(h-acomp) THEN run pi-finalizar in h-acomp.

END.
RUN pi-elimina-handles.

PROCEDURE pi-elimina-handles:

    IF VALID-HANDLE(h-acomp) THEN run pi-finalizar in h-acomp.
    
    {btb/btb008za.i3 esapi/esapi001a.p h-reporte}

END PROCEDURE.

procedure trata-erro.
   disp skip(1) c-msg-erro skip(2)
        with frame f-segue row 08 centered no-labels
        title " A T E N C A O ! ! ! ! ".
   assign l-segue = no.
   update l-segue label "Voce leu a mensagem acima?" help "Zim/Nao"
   validate(l-segue = yes,"A pergunta deve ser respondida")
   with side-labels frame f-segue centered overlay.
   hide frame f-segue no-pause.
end.

PROCEDURE piImprimeRep:
    IF VALID-HANDLE(h-acomp) THEN run pi-finalizar in h-acomp.
    ASSIGN i-qtd-cont = ttRepApi.qt-reporte.

    /* esp\es0506.i */
    {esapi/esapi001.i}
END.

PROCEDURE piImprimeLog:

    RUN piAtualizaArquivo(INPUT "log-reporte.lst").
    IF vArquivo <> "NOK" THEN
    DO:
        FILE-INFO:FILE-NAME = vArquivo.
        IF FILE-INFO:FILE-TYPE = "FRW" OR FILE-INFO:FILE-TYPE = ? THEN
        DO:
            OUTPUT STREAM LOG TO VALUE(vArquivo) APPEND.
            FOR FIRST tt-log:
                PUT STREAM LOG SKIP 
                    today at 01     " "
                    c-seg-usuario   " "
                    tt-log.tipo     " "
                    tt-log.seletivo " "
                    tt-log.etiqueta " "
                    tt-log.hora-ini " "
                    tt-log.t1 - tt-log.h-ini " "
                    tt-log.t2 - tt-log.t1  " "
                    tt-log.t2 - tt-log.h-ini " "
                    tt-log.nr-itens " "
                    (tt-log.t2 - tt-log.h-ini) / tt-log.nr-itens
                    tt-log.erro SKIP.
            END.
            OUTPUT STREAM LOG CLOSE.
        END.
    END.
END PROCEDURE.

PROCEDURE piAtualizaArquivo:
    DEF INPUT PARAM pArquivo AS CHAR.

    ASSIGN vArquivo = "NOK".

    empty temp-table tt-prog-ponto.
       
    if opsys = "unix":U then do:
        run esp/es0018p.p (input  "SPOOL-UNIX":U,
                           input  1,
                           input  0,
                           input  "":U,
                           output table tt-prog-ponto).

        for first tt-prog-ponto:
            assign varquivo = replace(tt-prog-ponto.conteudo, "~\":U, "/":U).
        end.

        if substring(varquivo, length(varquivo), 1) <> "/":U then
            assign varquivo = varquivo + "/":U.

        assign varquivo = varquivo + "spool/":U + parquivo.
    end.
    else do:
        run esp/es0018p.p (input  "SPOOL-WIN":U,
                           input  1,
                           input  0,
                           input  "":U,
                           output table tt-prog-ponto).

        for first tt-prog-ponto:
            assign varquivo = replace(tt-prog-ponto.conteudo, "/":U, "~\":U).
        end.

        if substring(varquivo, length(varquivo), 1) <> "~\":U then
            assign varquivo = varquivo + "~\":U.

        assign varquivo = varquivo + "spool~\":U + parquivo.
    end.
/*       

    FILE-INFO:FILE-NAME = "spool".
    IF FILE-INFO:FILE-TYPE = "DRW" THEN
    DO:
        ASSIGN vArquivo = FILE-INFO:FULL-PATHNAME + "\" + pArquivo
               vArquivo = REPLACE(vArquivo,"erp\", "erp$\")
               vArquivo = REPLACE(vArquivo,"erp/", "erp$\").
    END.
    
    */
    
END.

PROCEDURE piPedeDataAe:
    DEFINE BUTTON    btGoToOK     AUTO-GO LABEL "&OK" SIZE 10 BY 1 BGCOLOR 8.
    DEFINE BUTTON    btGoToCancel AUTO-GO LABEL "&Cancela" SIZE 10 BY 1 BGCOLOR 8.
    DEFINE RECTANGLE rtGoToFields  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 65 BY 1.3 BGCOLOR 8.
    DEFINE RECTANGLE rtGoToButton  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 65 BY 1.5 BGCOLOR 7.
    DEFINE VARIABLE fiData AS DATE LABEL "Data AE" VIEW-AS FILL-IN  SIZE 10 BY .88 NO-UNDO.


    DEFINE FRAME fPedeData
           fiData            AT ROW 1.17 COL 18 COLON-ALIGN 
           rtGoToFields      AT ROW 1    COL 1
           btGoToOK          AT ROW 2.7  COL 2.14
           btGoToCancel      AT ROW 2.7  COL 13.14
           rtGoToButton      AT ROW 2.5  COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Data AE" FONT 1
             DEFAULT-BUTTON btGoToOK.

    ON  "CHOOSE":U OF btGoToOK IN FRAME fPedeData DO:
        ASSIGN da-data = INPUT fiData.
        APPLY "GO":U TO FRAME fPedeData.
    END.
    ON  "CHOOSE":U OF btGoToCancel IN FRAME fPedeData DO:
        ASSIGN da-data = ?.
        APPLY "GO":U TO FRAME fPedeData.
    END.
    DISP da-data @ fiData WITH FRAME fPedeData.
    ENABLE fiData 
           btGoToOK 
           btGoToCancel
           WITH FRAME fPedeData.

    WAIT-FOR "GO":U OF FRAME fPedeData.

END PROCEDURE.

PROCEDURE piPedeContenedor:
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

PROCEDURE piTrataTransfInjetoras:
    DEFINE BUTTON    btGoToOK       AUTO-GO LABEL "&OK" SIZE 10 BY 1 BGCOLOR 8.
    DEFINE RECTANGLE rtGoToFields   EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 80 BY 1.3 BGCOLOR 8.
    DEFINE RECTANGLE rtGoToButton   EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 80 BY 1.5 BGCOLOR 7.
    DEFINE VARIABLE  fiMensagem     AS CHAR VIEW-AS FILL-IN  SIZE 75 BY .88 NO-UNDO.

    DEFINE FRAME fMensagem
           fiMensagem        AT ROW 1.17 COL 02 NO-LABEL
           rtGoToFields      AT ROW 1    COL 1
           btGoToOK          AT ROW 2.7  COL 2.14
           rtGoToButton      AT ROW 2.5  COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "A V I S O   I M P O R T A N T E" FONT 2
             DEFAULT-BUTTON btGoToOK.

    ON  "CHOOSE":U OF btGoToOK IN FRAME fMensagem DO:
        APPLY "GO":U TO FRAME fMensagem.
    END.

    DISP "Para a transferància das injetoras deve ser utilizado o ES0479 no EMSCAR" @ fiMensagem WITH FRAME fMensagem.

    ENABLE btGoToOK 
           WITH FRAME fMensagem.

    WAIT-FOR "GO":U OF FRAME fMensagem.

END PROCEDURE.
