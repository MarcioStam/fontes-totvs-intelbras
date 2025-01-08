/***********************************************************************
**  Programa..: UPC\CP0311-UPC.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: DEZEMBRO/2004 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 29/12/2004
**                  Desenvolvimento Programa
**              002 31/10/2007
**                  Implementaá∆o do controle de CDB para Nova
**                  Giovane Alves - Gestech 
**              002 31/10/2007
**                  Implementaá∆o do controle de CDB para Nova
**                  Giovane Alves - Gestech 
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.
 
DEF VAR c-objeto  AS CHAR    NO-UNDO.
DEF VAR h-frame   AS HANDLE  NO-UNDO.
DEF VAR h-acomp   AS HANDLE  NO-UNDO.

{utp/utapi019.i}
 
assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").

/*MESSAGE "event" p-ind-event SKIP
        "obj type" p-ind-object SKIP
        "obj" c-objeto SKIP
        "table" p-cod-table VIEW-AS ALERT-BOX.*/

/****************************  Variaveis    ****************************/
DEF NEW GLOBAL SHARED VAR vNomProg            AS   CHAR             NO-UNDO.
DEF NEW GLOBAL SHARED VAR whCodLocalizAcabado AS   WIDGET-HANDLE    NO-UNDO.
DEF NEW GLOBAL SHARED VAR vCodLocalizAcabado  LIKE ITEM.cod-localiz NO-UNDO.
DEF NEW GLOBAL SHARED VAR vQuatidadeReportecp0311  AS   WIDGET-HANDLE  NO-UNDO.
DEF NEW GLOBAL SHARED VAR vNumeroVolumescp0311  AS   WIDGET-HANDLE  NO-UNDO.
DEF NEW GLOBAL SHARED VAR vVolm3cp0311  AS   WIDGET-HANDLE  NO-UNDO.
DEF NEW GLOBAL SHARED VAR c-seg-usuario AS   CHAR                  NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-nr-volume      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-vol-m3      AS WIDGET-HANDLE NO-UNDO.
 
def new global shared var gr-documento  as rowid no-undo.

/* temp table para estorno de OP */
def temp-table tt-rep-prod no-undo like rep-prod use-index item-rep
     field l-emite-rel      as logical
     field rw-rep-prod      as rowid
     field prog-seg         as char
     field time-out         as integer init 30
     field tentativas       as integer init 10
     field cod-versao-integracao as integer format "999".
    
 def temp-table tt-relatorio no-undo
     field es-codigo     like reservas.it-codigo
     field qt-item       like reservas.quant-orig
     field qt-estoq      like reservas.quant-orig
     field qt-saldo      like reservas.quant-orig
     field un            like item.un
     field descricao     like item.desc-item.    

 def temp-table tt-ae
     field numero as rowid
     index tt-ae1 is primary numero. 

 DEF TEMP-TABLE tt-etiquetas-ae
     FIELD num-etiq  AS INT
     FIELD qtde      AS INT 
     INDEX idx IS PRIMARY num-etiq. 


DEFINE VARIABLE l-cancela AS LOGICAL   INITIAL NO   NO-UNDO.
DEFINE VARIABLE c-estab   AS CHARACTER              NO-UNDO.
DEFINE BUTTON    btGoToOK     AUTO-GO LABEL "&OK" SIZE 10 BY 1 BGCOLOR 8.
DEFINE BUTTON    btGoToCancel AUTO-GO LABEL "&Cancela" SIZE 10 BY 1 BGCOLOR 8.
DEFINE RECTANGLE rtGoToFields  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 65 BY 5.3 BGCOLOR 8.
DEFINE RECTANGLE rtGoToFields2 EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 65 BY 8.3 BGCOLOR 8.
DEFINE RECTANGLE rtGoToButton  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 65 BY 1.5 BGCOLOR 7.
 
DEFINE VARIABLE i-cod-emitente LIKE ficha-cq.cod-emitente LABEL "Emitente"      VIEW-AS FILL-IN  SIZE 10 BY .88 NO-UNDO.
DEFINE VARIABLE c-nro-docto    LIKE ficha-cq.nro-docto    LABEL "Nro Docto"     VIEW-AS FILL-IN  SIZE 10 BY .88 NO-UNDO.
DEFINE VARIABLE c-serie        LIKE ficha-cq.serie        LABEL "Serie"         VIEW-AS FILL-IN  SIZE 05 BY .88 NO-UNDO.
DEFINE VARIABLE c-nat-operacao LIKE ficha-cq.nat-operacao LABEL "Nat. Operaá∆o" VIEW-AS FILL-IN  SIZE 06 BY .88 NO-UNDO.
DEFINE VARIABLE i-seq          LIKE movto-estoq.sequen-nf LABEL "Sequencia"     VIEW-AS FILL-IN  SIZE 05 BY .88 NO-UNDO.
 
DEFINE VARIABLE cestrado1     LIKE ae-entrada.estrado[1]  
                                             FORMAT "x(3)"   LABEL "Volumes"       VIEW-AS FILL-IN  SIZE 05 BY .88 NO-UNDO.

DEFINE VARIABLE cmaterial     LIKE ae-entrada.material       LABEL "Material"      VIEW-AS FILL-IN  SIZE 10 BY .88 NO-UNDO.
DEFINE VARIABLE csolicitante  LIKE ae-entrada.solicitante    LABEL "Solicitante"   VIEW-AS FILL-IN  SIZE 12 BY .88 NO-UNDO.
DEFINE VARIABLE clocalizacao1 LIKE ae-entrada.localizacao[1] LABEL "Localizaá∆o"  VIEW-AS FILL-IN  SIZE 10 BY .88 NO-UNDO.
DEFINE VARIABLE clocalizacao2 LIKE ae-entrada.localizacao[2] LABEL "Localizaá∆o"  VIEW-AS FILL-IN  SIZE 10 BY .88 NO-UNDO.
DEFINE VARIABLE clocalizacao3 LIKE ae-entrada.localizacao[3] LABEL "Localizaá∆o"  VIEW-AS FILL-IN  SIZE 10 BY .88 NO-UNDO.
DEFINE VARIABLE clocalizacao4 LIKE ae-entrada.localizacao[4] LABEL "Localizaá∆o"  VIEW-AS FILL-IN  SIZE 10 BY .88 NO-UNDO.
DEFINE VARIABLE clocalizacao5 LIKE ae-entrada.localizacao[5] LABEL "Localizaá∆o"  VIEW-AS FILL-IN  SIZE 10 BY .88 NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_estab_usuar AS CHAR NO-UNDO.

DEF VAR c-depos-ent AS CHAR NO-UNDO.            
DEF VAR c-depos-sai AS CHAR NO-UNDO.            
DEF VAR cReturn     AS CHAR NO-UNDO.

 
{cdp/cd0666.i}
{esp/es0018.i}

def var i-sequen as int no-undo.
def var i-num-cdb as int no-undo.
 
DEFINE BUFFER bficha-cq FOR ficha-cq.
 
DEF VAR i-ultimo-ae AS INT.

 
ASSIGN vNomProg = "CP0311". 
/* Vari†vel utilizada na CEAPI001-upc.p */

/*
MESSAGE p-ind-event
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/
 
/* Medeiros  */
CASE p-ind-event:

    WHEN "VALIDATE" THEN DO:
        IF p-ind-object  = "VIEWER" AND
           c-objeto      = "v43in271.w" THEN DO:
            
            FIND FIRST ord-prod WHERE ROWID(ord-prod) = p-row-table no-lock NO-ERROR.
            IF AVAIL ord-prod THEN DO:
                FIND lin-prod WHERE
                     lin-prod.nr-linha = ord-prod.nr-linha NO-LOCK NO-ERROR.
                IF AVAIL lin-prod AND 
                         lin-prod.sum-requis = 1 AND
                   ord-prod.tipo <> 2 AND
                   ord-prod.tipo <> 4 AND
                   ord-prod.tipo <> 5 THEN DO:
                    FIND FIRST oper-ord WHERE oper-ord.nr-ord-prod = ord-prod.nr-ord-prod NO-ERROR.
                    IF NOT AVAIL oper-ord THEN DO:
                        MESSAGE "Ordem de produá∆o sem Operaá∆o. N∆o pode ser reportada."
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        
                        return "NOK".
                    END.
                END.

                /**/

                EMPTY TEMP-TABLE tt-prog-ponto.
    
                RUN esp/es0018p.p (INPUT "bloq-rep", /* Nome do programa */
                                   INPUT 1,          /* Ponto do programa */
                                   INPUT 0,
                                   INPUT "",
                                   OUTPUT TABLE tt-prog-ponto).    
            
                IF CAN-FIND(FIRST tt-prog-ponto NO-LOCK 
                            WHERE entry(1, tt-prog-ponto.conteudo, ";") = ord-prod.cod-estabel
                            AND   ENTRY(2, tt-prog-ponto.conteudo, ";") = "bloqueia") THEN DO:
    
                    RUN utp/ut-msgs.p (INPUT "show":U, 
                                       INPUT 17006, 
                                       INPUT "Reportes est∆o bloqueados para realizaá∆o do Planejamento. Aguarde liberaá∆o.").
                    RETURN "NOK".
        
                END.

            END.

        END.
    END.
    
    WHEN "ANTES-FINALIZA-ORDEM" THEN DO TRANSACTION:

        DEFINE VARIABLE i-nr-ae     AS INTEGER NO-UNDO.
        DEFINE VARIABLE i-qtd-cont  AS INTEGER NO-UNDO.

        FIND FIRST ord-prod WHERE ROWID(ord-prod) = p-row-table no-LOCK NO-ERROR.
        IF AVAIL ord-prod THEN DO:

            EMPTY TEMP-TABLE tt-erro.
            
            FIND FIRST ficha-cq NO-LOCK
                WHERE ficha-cq.cod-estabel  = ord-prod.cod-estabel
                and   ficha-cq.nr-ord-produ = ord-prod.nr-ord-produ 
                AND   ficha-cq.serie        = ""
                AND   ficha-cq.nro-docto    = STRING(ord-prod.nr-ord-produ)
                AND   ficha-cq.cod-emitente = 0
                AND   ficha-cq.nat-operacao = ""
                AND   ficha-cq.nr-ord-cq    = 0
                AND   ficha-cq.situacao     = 1 NO-ERROR.
    
            IF AVAIL ficha-cq THEN do:
                EMPTY TEMP-TABLE tt-prog-ponto.

                ASSIGN c-estab = "".

                RUN esp/es0018p.p (INPUT "cp0311-upc", /* Nome do programa */
                                   INPUT 2,            /* Ponto do programa */
                                   INPUT 0,
                                   INPUT "",
                                   OUTPUT TABLE tt-prog-ponto).    
            
                FOR FIRST tt-prog-ponto:
                    ASSIGN c-estab = tt-prog-ponto.conteudo.
                END.

                RUN pi-fichacq.
            END.
            ELSE DO:
                
                FIND FIRST ITEM WHERE ITEM.it-codigo = ord-prod.it-codigo NO-LOCK NO-ERROR.
                FIND FIRST item-uni-estab WHERE item-uni-estab.cod-estabel = ord-prod.cod-estabel AND
                                                item-uni-estab.it-codigo = ITEM.it-codigo NO-LOCK NO-ERROR.
                
            END.
            

            FIND FIRST tt-erro NO-ERROR.

            IF NOT AVAIL tt-erro THEN DO:
               RUN piCriaAE. 
            END.        

            RUN pi-mail.
            
        END. 
        
    END.

    WHEN "BEFORE-INITIALIZE" THEN DO:
        IF  p-ind-object  = "VIEWER" AND
            c-objeto      = "v38in271.w"        THEN DO:
            ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.
            ASSIGN h-frame = h-frame:FIRST-CHILD.
            DO  WHILE VALID-HANDLE(h-frame):
                IF  h-frame:TYPE <> "field-group" THEN DO:
                    CASE h-frame:NAME:
                        WHEN "fi-cod-localiz-acabado" THEN 
                            ASSIGN whCodLocalizAcabado = h-frame.
                        
                    END.
                    ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
                END.
                ELSE LEAVE.
            END.

        END.
        ELSE IF p-ind-event   = "VALIDATE"        AND 
                VALID-HANDLE(whCodLocalizAcabado) AND 
                c-objeto      = "v43in271.w"      THEN DO:
                ASSIGN vCodLocalizAcabado = whCodLocalizAcabado:SCREEN-VALUE.
        END.
        ELSE IF p-ind-object = "VIEWER" 
            AND c-objeto     = "v44in271.w" THEN DO:
            ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.
            ASSIGN h-frame = h-frame:FIRST-CHILD.
            DO  WHILE VALID-HANDLE(h-frame):
                IF  h-frame:TYPE <> "field-group" THEN DO:
                    CASE h-frame:NAME:
                        WHEN "fi-quantidade-reporte" THEN 
                            ASSIGN vQuatidadeReportecp0311 = h-frame.
                        
                    END.
                    ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
                END.
                ELSE LEAVE.
            END.

            IF VALID-HANDLE (vQuatidadeReportecp0311) THEN DO:
                CREATE TEXT tx-nr-volume
                ASSIGN FRAME        = p-wgh-frame
                       FORMAT       = "x(12)"
                       WIDTH        = 12
                       SCREEN-VALUE = "Nr. Volumes:"
                       ROW          = vQuatidadeReportecp0311:ROW + 0.1
                       COL          = vQuatidadeReportecp0311:COL + 18
                       VISIBLE      = YES.

                CREATE FILL-IN vNumeroVolumescp0311
                ASSIGN FRAME             = p-wgh-frame
                       DATA-TYPE         = "INTEGER"
                       FORMAT            = ">>>>9"
                       SIDE-LABEL-HANDLE = tx-nr-volume:HANDLE
                       WIDTH             = 7
                       HEIGHT            = .88
                       ROW               = vQuatidadeReportecp0311:ROW
                       COL               = vQuatidadeReportecp0311:COL + 27
                       VISIBLE           = YES
                       SENSITIVE         = NO.

                CREATE TEXT tx-vol-m3
                ASSIGN FRAME        = p-wgh-frame
                       FORMAT       = "x(12)"
                       WIDTH        = 12
                       SCREEN-VALUE = "Volume m3:"
                       ROW          = vQuatidadeReportecp0311:ROW + 1.1
                       COL          = vQuatidadeReportecp0311:COL + 18.7
                       VISIBLE      = YES.

                CREATE FILL-IN vVolm3cp0311
                ASSIGN FRAME             = p-wgh-frame
                       DATA-TYPE         = "DECIMAL"
                       FORMAT            = ">>>>9.999"
                       SIDE-LABEL-HANDLE = tx-vol-m3:HANDLE
                       WIDTH             = 7
                       HEIGHT            = .88
                       ROW               = vQuatidadeReportecp0311:ROW + 1
                       COL               = vQuatidadeReportecp0311:COL + 27
                       VISIBLE           = YES
                       SENSITIVE         = NO.
            END.
        END.
    END.
    WHEN "ENABLE" THEN DO:
        IF  p-ind-object = "VIEWER" 
        AND c-objeto     = "v44in271.w" THEN DO:
            CREATE TEXT tx-nr-volume
            ASSIGN FRAME        = p-wgh-frame
                   FORMAT       = "x(12)"
                   WIDTH        = 9
                   SCREEN-VALUE = "Nr. Volumes:"
                   ROW          = vQuatidadeReportecp0311:ROW + 0.1
                   COL          = vQuatidadeReportecp0311:COL + 18
                   VISIBLE      = YES.

            CREATE TEXT tx-vol-m3
            ASSIGN FRAME        = p-wgh-frame
                   FORMAT       = "x(12)"
                   WIDTH        = 8
                   SCREEN-VALUE = "Volume m3:"
                   ROW          = vQuatidadeReportecp0311:ROW + 1.1
                   COL          = vQuatidadeReportecp0311:COL + 18.7
                   VISIBLE      = YES.

            FIND FIRST ord-prod NO-LOCK 
                 WHERE ROWID(ord-prod) = p-row-table NO-ERROR.

            FIND FIRST int-ped-venda NO-LOCK
                 WHERE int-ped-venda.nr-pedido = INT(ord-prod.nr-pedido) NO-ERROR.

            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = ord-prod.it-codigo NO-ERROR.

            IF  AVAIL int-ped-venda 
            AND item.cod-unid-negoc = "ENS" THEN DO:
                ASSIGN vVolm3cp0311:SENSITIVE = YES
                       vNumeroVolumescp0311:SENSITIVE = YES.
            END.
            ELSE DO:
                ASSIGN vVolm3cp0311:SENSITIVE = NO
                       vNumeroVolumescp0311:SENSITIVE = NO.
            END.
        END.
    END.
    WHEN "DISPLAY" THEN DO:
        IF  p-ind-object = "VIEWER" 
        AND c-objeto     = "v44in271.w" THEN DO:
            CREATE TEXT tx-nr-volume
            ASSIGN FRAME        = p-wgh-frame
                   FORMAT       = "x(12)"
                   WIDTH        = 9
                   SCREEN-VALUE = "Nr. Volumes:"
                   ROW          = vQuatidadeReportecp0311:ROW + 0.1
                   COL          = vQuatidadeReportecp0311:COL + 18
                   VISIBLE      = YES.

            CREATE TEXT tx-vol-m3
            ASSIGN FRAME        = p-wgh-frame
                   FORMAT       = "x(12)"
                   WIDTH        = 8
                   SCREEN-VALUE = "Volume m3:"
                   ROW          = vQuatidadeReportecp0311:ROW + 1.1
                   COL          = vQuatidadeReportecp0311:COL + 18.7
                   VISIBLE      = YES.

            FIND FIRST ord-prod NO-LOCK 
                 WHERE ROWID(ord-prod) = p-row-table NO-ERROR.

            FIND FIRST int-ped-venda NO-LOCK
                 WHERE int-ped-venda.nr-pedido = INT(ord-prod.nr-pedido) NO-ERROR.

            IF AVAIL int-ped-venda THEN
                ASSIGN vNumeroVolumescp0311:SCREEN-VALUE = STRING(int-ped-venda.qt-volumes)
                       vVolm3cp0311:SCREEN-VALUE = STRING(int-ped-venda.vol-m3).
            
        END.
    END.
    WHEN "AFTER-END-UPDATE" THEN DO:
        IF  p-ind-object = "VIEWER" 
        AND c-objeto     = "v44in271.w" THEN DO:
            FIND FIRST ord-prod NO-LOCK 
                 WHERE ROWID(ord-prod) = p-row-table NO-ERROR.

            FIND FIRST int-ped-venda EXCLUSIVE-LOCK
                 WHERE int-ped-venda.nr-pedido = INT(ord-prod.nr-pedido) NO-ERROR.

            IF AVAIL int-ped-venda THEN
                ASSIGN int-ped-venda.qt-volumes = INT(vNumeroVolumescp0311:SCREEN-VALUE)
                       int-ped-venda.vol-m3     = DEC(vVolm3cp0311:SCREEN-VALUE).
            
        END.
    END.
END CASE.
 
return "ok".
 
PROCEDURE pi-mail:
    DEFINE VARIABLE c-mail     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-utapi019 AS HANDLE      NO-UNDO.

    FIND FIRST int-item NO-LOCK
         WHERE int-item.it-codigo = ord-prod.it-codigo NO-ERROR.

    IF  AVAIL int-item
    AND int-item.nr-ped-energia <> "" THEN DO:

        FIND FIRST int-ped-venda NO-LOCK
             WHERE int-ped-venda.nr-pedido = INT(ord-prod.nr-pedido) NO-ERROR.

        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p (INPUT "Solar":U,
                           INPUT 2,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).

        ASSIGN c-mail = "".

        FOR EACH tt-prog-ponto:
            IF c-mail = "" THEN
                ASSIGN c-mail = tt-prog-ponto.conteudo.
            ELSE 
                ASSIGN c-mail = c-mail + ", " + tt-prog-ponto.conteudo.
        END.

        IF c-mail <> "" THEN DO:

            FOR FIRST param-global NO-LOCK:
            END.

            FIND FIRST usuar_mestre NO-LOCK
                 WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-ERROR.
            
            RUN utp/utapi019.p PERSISTENT SET h-utapi019.
      
            FOR EACH tt-envio2.   DELETE tt-envio2.   END.
            FOR EACH tt-mensagem. DELETE tt-mensagem. END.
    
            CREATE tt-envio2.
            ASSIGN tt-envio2.versao-integracao = 1
                   tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
                   tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
                   tt-envio2.destino           = c-mail                   /* Destinatˇrio       */ 
                   tt-envio2.remetente         = usuar_mestre.cod_e_mail_local  /* Remetente          */ 
                   tt-envio2.assunto           = "Pedido: " + int-item.nr-ped-energia + " liberado para faturamento" /* Assunto */
                   tt-envio2.formato           = "TEXTO".

            CREATE tt-mensagem.
            ASSIGN tt-mensagem.seq-mensagem = 1
                   tt-mensagem.mensagem     = "Prezado Colaborador(a)," + CHR(13) + CHR(13) + 
                                              "O pedido de venda de n£mero " + int-item.nr-ped-energia + " est† dispon°vel para faturamento. O item do pedido j† possui saldo em estoque." + CHR(13) + 
                                              "N£mero de volumes: " + IF AVAIL int-ped-venda THEN string(int-ped-venda.qt-volumes) ELSE "0" + CHR(13) +
                                              "Atenciosamente," + CHR(13) +
                                              "Expediá∆o.".


            RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                           INPUT  TABLE tt-mensagem,
                                           OUTPUT TABLE tt-erros).

            FIND CURRENT int-ped-venda EXCLUSIVE-LOCK.
            ASSIGN int-ped-venda.ind-status-solar = 4.
            FIND CURRENT int-ped-venda NO-LOCK.
           
            FIND FIRST tt-erros NO-LOCK NO-ERROR.

/*             IF AVAIL tt-erros THEN DO:       */
/*                 PUT tt-erros.desc-erro SKIP. */
/*             END.                             */
            
            IF VALID-HANDLE(h-utapi019) THEN
                DELETE PROCEDURE h-utapi019.
        END.

    END.
END PROCEDURE.

PROCEDURE pi-fichacq:

    IF LOOKUP(ficha-cq.cod-estabel,c-estab) > 0 THEN DO:
        FOR FIRST movto-estoq NO-LOCK
            WHERE movto-estoq.cod-estabel   = ficha-cq.cod-estabel
            and   movto-estoq.nr-ord-produ  = ficha-cq.nr-ord-produ
            AND   movto-estoq.it-codigo     = ficha-cq.it-codigo
            and   movto-estoq.serie         = ficha-cq.serie          
            and   movto-estoq.nro-docto     = ficha-cq.nro-docto      
            and   movto-estoq.cod-emitente  = ficha-cq.cod-emitente   
            and   movto-estoq.nat-operacao  = ficha-cq.nat-operacao   
            and   movto-estoq.dt-trans      = ficha-cq.dt-ficha       
            AND   movto-estoq.quantidade    = ficha-cq.qt-original    
            AND   movto-estoq.esp-docto     = 1,
            FIRST ord-prod NO-LOCK
            WHERE ord-prod.cod-estabel     = movto-estoq.cod-estabel
            and   ord-prod.nr-ord-produ    = ficha-cq.nr-ord-produ:

                RUN piTrataFicha.
                
        END.

    END.
    ELSE DO:
        FOR FIRST movto-estoq NO-LOCK
            WHERE movto-estoq.cod-estabel   = ficha-cq.cod-estabel
            and   movto-estoq.nr-ord-produ  = ficha-cq.nr-ord-produ
            AND   movto-estoq.it-codigo     = ficha-cq.it-codigo
            and   movto-estoq.serie         = ficha-cq.serie          
            and   movto-estoq.nro-docto     = ficha-cq.nro-docto      
            and   movto-estoq.cod-emitente  = ficha-cq.cod-emitente   
            and   movto-estoq.nat-operacao  = ficha-cq.nat-operacao   
            and   movto-estoq.dt-trans      = ficha-cq.dt-ficha       
            AND   movto-estoq.quantidade    = ficha-cq.qt-original    
            AND   movto-estoq.esp-docto     = 1,
            FIRST ord-prod NO-LOCK
            WHERE ord-prod.cod-estabel     = movto-estoq.cod-estabel
            and   ord-prod.nr-ord-produ    = ficha-cq.nr-ord-produ
            AND   (ord-prod.tipo = 2 OR ord-prod.tipo = 5):
                RUN piTrataFicha.
                

        END.
    END.

    ASSIGN vNomProg = "".
END PROCEDURE.

PROCEDURE piTrataFicha:
    ASSIGN l-cancela = NO.

    RUN piPedeDadosDocto.

    IF l-cancela = NO THEN DO:

        FIND CURRENT ficha-cq EXCLUSIVE-LOCK.
        
        ASSIGN ficha-cq.serie        = c-serie 
               ficha-cq.nro-docto    = c-nro-docto 
               ficha-cq.cod-emitente = i-cod-emitente 
               ficha-cq.nat-operacao = c-nat-operacao
               ficha-cq.nr-ord-cq    = item-doc-est.sequencia.

        /**/

        FIND CURRENT movto-estoq EXCLUSIVE-LOCK.

        ASSIGN movto-estoq.descricao-db = c-serie + ";" + c-nro-docto + ";" + STRING(i-cod-emitente) + ";" + c-nat-operacao + ";" + string(item-doc-est.sequencia).

        FIND CURRENT movto-estoq NO-LOCK.

        /**/
    
        FIND CURRENT ficha-cq NO-LOCK.

        FIND CURRENT item-doc-est EXCLUSIVE-LOCK.
        ASSIGN item-doc-est.nr-ficha = ficha-cq.nr-ficha.
        FIND CURRENT item-doc-est NO-LOCK.
    
        FIND first ae-entrada NO-LOCK
             WHERE ae-entrada.cod-estabel  = movto-estoq.cod-estabel
               and ae-entrada.nro-docto    = INT(movto-estoq.nro-docto)
               AND ae-entrada.cod-emitente = movto-estoq.cod-emitente NO-ERROR.
        IF NOT AVAIL ae-entrada THEN DO:
               CREATE ae-entrada.
               ASSIGN ae-entrada.cod-estabel      = movto-estoq.cod-estabel
                      ae-entrada.nro-docto        = INT(movto-estoq.nro-docto)
                      ae-entrada.cod-emitente     = movto-estoq.cod-emitente
                      ae-entrada.data             = TODAY 
                      ae-entrada.hora             = STRING(TIME,"HH:MM:SS").
               
        END. 
        
        FIND first ae-inspecao NO-LOCK WHERE 
             ae-inspecao.cod-estabel  = movto-estoq.cod-estabel and
             ae-inspecao.nro-docto    = INT(ficha-cq.nro-docto) AND 
             ae-inspecao.serie        = ficha-cq.serie          AND 
             ae-inspecao.cod-emitente = ficha-cq.cod-emitente   AND
             ae-inspecao.nat-operacao = ficha-cq.nat-operacao   AND 
             ae-inspecao.it-codigo    = ficha-cq.it-codigo NO-ERROR.
        
        IF AVAIL ae-inspecao THEN 
            ASSIGN i-ultimo-ae = ae-inspecao.nr-ae.
        ELSE DO:    
            FIND FIRST aviso-entrada EXCLUSIVE-LOCK
                where aviso-entrada.cod-estabel = movto-estoq.cod-estabel NO-ERROR.
            IF AVAIL aviso-entrada THEN
                ASSIGN i-ultimo-ae             = aviso-entrada.ultimo-ae + 1
                       aviso-entrada.ultimo-ae = i-ultimo-ae.                
            ELSE DO:
                CREATE aviso-entrada.
                ASSIGN aviso-entrada.cod-estabel = movto-estoq.cod-estabel
                       aviso-entrada.ultimo-ae   = 1.
            END.
            FIND CURRENT aviso-entrada no-lock no-error.
        END.
        
        FIND first ae-inspecao NO-LOCK WHERE 
             ae-inspecao.cod-estabel  = movto-estoq.cod-estabel and
             ae-inspecao.nro-docto    = INT(ficha-cq.nro-docto) AND 
             ae-inspecao.serie        = ficha-cq.serie          AND 
             ae-inspecao.cod-emitente = ficha-cq.cod-emitente   AND 
             ae-inspecao.nat-operacao = ficha-cq.nat-operacao   AND 
             ae-inspecao.it-codigo    = ficha-cq.it-codigo      AND 
             ae-inspecao.sequencia    = item-doc-est.sequencia NO-ERROR.
             
        IF NOT AVAIL ae-inspecao THEN DO:
           CREATE ae-inspecao.
           ASSIGN ae-inspecao.cod-estabel  = movto-estoq.cod-estabel
                  ae-inspecao.nro-docto    = INT(ficha-cq.nro-docto)
                  ae-inspecao.cod-emitente = ficha-cq.cod-emitente
                  ae-inspecao.it-codigo    = ficha-cq.it-codigo
                  ae-inspecao.nat-operacao = ficha-cq.nat-operacao
                  ae-inspecao.serie        = ficha-cq.serie-docto
                  ae-inspecao.nr-ae        = i-ultimo-ae 
                  ae-inspecao.sequencia    = item-doc-est.sequencia
                  ae-inspecao.quantidade   = movto-estoq.quantidade
                  ae-inspecao.nr-ficha     = ficha-cq.nr-ficha.
        END.

        IF AVAIL docum-est                          AND
           LOOKUP(ficha-cq.cod-estabel,c-estab) > 0 AND
           (docum-est.cod-emitente = 18963 OR
            docum-est.cod-emitente = 175028) THEN DO:
            
            EMPTY TEMP-TABLE tt-prog-ponto.
    
            RUN esp/es0018p.p (INPUT "ALM-WMS":U,
                               INPUT 1,
                               INPUT 0,
                               INPUT "":U,
                               OUTPUT TABLE tt-prog-ponto).
            

            IF NOT CAN-FIND(FIRST tt-prog-ponto
                            WHERE tt-prog-ponto.conteudo = docum-est.cod-estabel) THEN DO:
               ASSIGN gr-documento = ROWID(docum-est).
               RUN esp/cqp/escqp003.w.
               ASSIGN gr-documento = ?.
            END.
        END.
        

        
    END.
END.
 
PROCEDURE piPedeDadosDocto:

    ASSIGN i-cod-emitente = 0
           c-nro-docto = ""
           c-serie = ""
           c-nat-operacao = ""
           i-seq = 0.
    
    DEFINE FRAME fFicha
           i-cod-emitente    AT ROW 1.17 COL 18 COLON-ALIGN 
           c-nro-docto       AT ROW 2.17 COL 18 COLON-ALIGN 
           c-serie           AT ROW 3.17 COL 18 COLON-ALIGN 
           c-nat-operacao    AT ROW 4.17 COL 18 COLON-ALIGN 
           i-seq             AT ROW 5.17 COL 18 COLON-ALIGN 
           rtGoToFields      AT ROW 1    COL 1
           btGoToOK          AT ROW 6.7  COL 2.14
           btGoToCancel      AT ROW 6.7  COL 13.14
           rtGoToButton      AT ROW 6.5  COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Dados do Documento" FONT 1
             DEFAULT-BUTTON btGoToOK.
 
    ON  "CHOOSE":U OF btGoToOK IN FRAME fFicha DO:
        SESSION:SET-WAIT-STATE("general":U).
        SESSION:SET-WAIT-STATE("":U).

        ASSIGN i-cod-emitente 
               c-nro-docto    
               c-serie        
               c-nat-operacao 
               i-seq.

        /* Validaá‰es dos dados digitados */
        FIND FIRST docum-est NO-LOCK WHERE 
             docum-est.serie        = c-serie        AND 
             docum-est.nro-docto    = c-nro-docto    AND 
             docum-est.cod-emitente = i-cod-emitente AND 
             docum-est.nat-operacao = c-nat-operacao and
             docum-est.cod-estabel  = movto-estoq.cod-estabel NO-ERROR.
        IF NOT AVAIL docum-est THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "Documento de entrada inexistente").
            RETURN NO-APPLY.
        END.
        
        /* verifica se a natureza Ç valida para industrializaá∆o */
        RUN esp/es0018p.p (INPUT "cp0311-upc", /* Nome do programa */
                           INPUT 1,          /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto).    
    
        IF NOT CAN-FIND( FIRST tt-prog-ponto NO-LOCK 
                         WHERE tt-prog-ponto.conteudo = docum-est.nat-operacao) THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "Natureza informada n∆o liberada para industrializaá∆o").
            RETURN NO-APPLY.

        END.
                
        IF LOOKUP(ficha-cq.cod-estabel,c-estab) > 0 AND 
           (docum-est.cod-emitente = 18963  OR
            docum-est.cod-emitente = 205166 OR
            docum-est.cod-emitente = 175028) /*tarefa: 8297*/ THEN DO:
            FIND item-doc-est OF docum-est NO-LOCK WHERE 
                 item-doc-est.it-codigo = movto-estoq.it-codigo AND
                 item-doc-est.sequencia   = i-seq NO-ERROR.
            IF NOT AVAIL item-doc-est THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U, 
                                   INPUT 17567, 
                                   INPUT "Sequencia e Item da Nota fiscal nao conferem com item da ficha de inspecao").
                RETURN NO-APPLY.
            END.
        END.
        ELSE DO:
            FIND item-doc-est OF docum-est NO-LOCK WHERE 
                 item-doc-est.nr-ord-prod = movto-estoq.nr-ord-prod AND
                 item-doc-est.sequencia   = i-seq NO-ERROR.
            IF NOT AVAIL item-doc-est THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U, 
                                   INPUT 17567, 
                                   INPUT "Nota fiscal nao relacionada com esta ordem de producao").
                RETURN NO-APPLY.
            END.
        END.

        FIND FIRST bficha-cq NO-LOCK WHERE 
             bficha-cq.cod-estabel  = movto-estoq.cod-estabel and
             bficha-cq.serie        = c-serie AND 
             bficha-cq.nro-docto    = c-nro-docto AND 
             bficha-cq.cod-emitente = i-cod-emitente AND 
             bficha-cq.nat-operacao = c-nat-operacao AND 
             bficha-cq.it-codigo    = movto-estoq.it-codigo AND 
             bficha-cq.nr-ord-produ = movto-estoq.nr-ord-produ AND 
             bficha-cq.nr-ord-cq    = item-doc-est.sequencia AND
             bficha-cq.situacao     <> 5 NO-ERROR.
        IF AVAIL bficha-cq THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17567, 
                               INPUT "Nota fiscal ja digitada para este item. Verifique...").
            RETURN NO-APPLY.
        END.


        APPLY "GO":U TO FRAME fFicha.
    END.
    
    ON  "CHOOSE":U OF btGoToCancel IN FRAME fFicha DO:
        
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 27100, 
                           INPUT "Confirma cancelamento do Roteiro de Inspeá∆o? " + 
                                 "~~Se n∆o for informado nenhuma Nota Fiscal de Entrada, a ordem de produá∆o ser† estornada autom†ticamente.").
        IF RETURN-VALUE = "yes" THEN 
        DO: /* estorno da OP */
            
            EMPTY TEMP-TABLE tt-rep-prod.
            EMPTY TEMP-TABLE tt-relatorio.
            EMPTY TEMP-TABLE tt-erro.

            RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
            RUN pi-inicializar in h-acomp (input "Estornando Ordem de Produá∆o").

            FOR EACH ord-rep NO-LOCK
                WHERE ord-rep.nr-ord-produ = ord-prod.nr-ord-produ
                AND   ord-rep.qt-estorno   = 0:
        
                FOR FIRST rep-prod NO-LOCK
                    WHERE rep-prod.nr-reporte = ord-rep.nr-reporte:

                    RUN pi-acompanhar IN h-acomp (INPUT "Item: " + rep-prod.it-codigo).

                    create tt-rep-prod.
                    buffer-copy rep-prod to tt-rep-prod
            
                    assign tt-rep-prod.cod-versao-integracao = 001
                           tt-rep-prod.data                  = rep-prod.data.

                    RUN cpp/cpapi011.p (input        table tt-rep-prod ,
                                        input-output table tt-erro     ,
                                        input        table tt-relatorio,
                                        input        YES).                 

                    IF CAN-FIND (FIRST tt-erro) THEN DO:
                       RUN cdp/cd0666.w (INPUT TABLE tt-erro).
                       
                    END. 
                END.
            END.

            FOR EACH ficha-cq EXCLUSIVE-LOCK
                WHERE ficha-cq.nr-ficha = ord-prod.nr-ficha:

                for each ae-inspecao EXCLUSIVE-LOCK
                    where ae-inspecao.cod-estabel  = ficha-cq.cod-estabel
                    AND   ae-inspecao.nro-docto    = int(ficha-cq.nro-docto)
                    and   ae-inspecao.serie        = ficha-cq.serie-docto
                    and   ae-inspecao.nat-operacao = ficha-cq.nat-operacao
                    and   ae-inspecao.cod-emitente = ficha-cq.cod-emitente:
        
                    delete ae-inspecao.
        
                end.
    
                for each exam-ficha use-index codigo 
                    where exam-ficha.nr-ficha = ficha-cq.nr-ficha exclusive-lock:  
                    delete exam-ficha. 
                end.
    
                for each rej-ficha use-index ficha-cq 
                    where rej-ficha.nr-ficha = ficha-cq.nr-ficha exclusive-lock: 
                    delete rej-ficha.     
                end.
    
                for each res-fic-cq use-index codigo 
                    where res-fic-cq.nr-ficha = ficha-cq.nr-ficha exclusive-lock:
                    delete res-fic-cq. 
                end.
    
                for each tex-ex-fic use-index codigo 
                    where tex-ex-fic.nr-ficha = ficha-cq.nr-ficha exclusive-lock:
                    delete tex-ex-fic.     
                end. 
    
                delete ficha-cq.
       
            END.
            

            RUN pi-finalizar in h-acomp. 
           
            ASSIGN l-cancela = YES.
        END.
        ELSE 
            RETURN NO-APPLY.

        APPLY "GO":U TO FRAME fFicha.
    END.
    
    ENABLE i-cod-emitente
           c-nro-docto   
           c-serie       
           c-nat-operacao
           i-seq         
           btGoToOK 
           btGoToCancel
           WITH FRAME fFicha.

    WAIT-FOR "GO":U OF FRAME fFicha.
 
END PROCEDURE.
 

PROCEDURE piCriaAE:

    DEFINE VARIABLE i-qt-contenedor AS INTEGER NO-UNDO.
    DEFINE VARIABLE de-qtde-rep     AS DEC     NO-UNDO.
    DEFINE VARIABLE i-qtd-cont-aux  AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-aux           AS INTEGER NO-UNDO.

    EMPTY TEMP-TABLE tt-ae.
    EMPTY TEMP-TABLE tt-etiquetas-ae.

    ASSIGN i-nr-ae    = 0
           i-qtd-cont = 0. 

    FOR EACH ord-rep NO-LOCK
        WHERE ord-rep.nr-ord-produ = ord-prod.nr-ord-produ,
        FIRST rep-prod NO-LOCK
        WHERE rep-prod.nr-reporte = ord-rep.nr-reporte
        BY ord-rep.nr-reporte DESC:

        ASSIGN i-qtd-cont = rep-prod.qt-reporte.
        LEAVE.
    END.

    FOR FIRST contenedor NO-LOCK 
        WHERE contenedor.it-codigo = ord-prod.it-codigo:
        ASSIGN i-qt-contenedor = contenedor.lote-multipl.                
    END.

    /* Busca Qtde Contanedor */
    IF i-qt-contenedor > 0 THEN DO:
       ASSIGN i-qtd-cont-aux = i-qtd-cont.

       IF i-qtd-cont < i-qt-contenedor THEN DO:
          CREATE tt-etiquetas-ae.
          ASSIGN tt-etiquetas-ae.num-etiq = 1
                 tt-etiquetas-ae.qtde     = i-qtd-cont.
       END.
       ELSE DO:
          ASSIGN de-qtde-rep = i-qtd-cont / i-qt-contenedor.
    
           ASSIGN i-qtd-cont = TRUNCATE(de-qtde-rep,0).

           DO i-aux = 1 TO i-qtd-cont:
               CREATE tt-etiquetas-ae.
               ASSIGN tt-etiquetas-ae.num-etiq = i-aux
                      tt-etiquetas-ae.qtde     = i-qt-contenedor.
           END.
    
           IF i-qtd-cont-aux MOD i-qt-contenedor > 0 THEN DO:
               CREATE tt-etiquetas-ae.
               ASSIGN tt-etiquetas-ae.num-etiq = i-aux + 1
                      tt-etiquetas-ae.qtde     = i-qtd-cont-aux MOD i-qt-contenedor.
           END.
       END.
    END.
    ELSE DO:
        CREATE tt-etiquetas-ae.
        ASSIGN tt-etiquetas-ae.num-etiq = 1
               tt-etiquetas-ae.qtde     = i-qtd-cont.
    END.


    FIND FIRST int-lin-prod 
         WHERE int-lin-prod.cod-estabel = ord-prod.cod-estabel AND
               int-lin-prod.nr-linha = ord-prod.nr-linha NO-LOCK NO-ERROR.

    /* Linha cria AE mas n∆o utiliza localizaá∆o automatica*/

    IF AVAIL int-lin-prod THEN DO:
       IF int-lin-prod.cria-ae = YES AND
          int-lin-prod.transf-auto = NO THEN DO:

          FIND FIRST ITEM WHERE ITEM.it-codigo = ord-prod.it-codigo NO-LOCK NO-ERROR.

          FOR EACH tt-ae. DELETE tt-ae. END.


          FIND CURRENT aviso-entrada NO-LOCK NO-ERROR.

          DO: 
              /* Identifica dep¢sitos de Entrada e Sa°da para reporte */
              RUN esapi\esapi005.p (INPUT  ITEM.it-codigo,
                                    INPUT  v_cod_estab_usuar,
                                    OUTPUT c-depos-ent,
                                    OUTPUT c-depos-sai,
                                    OUTPUT cReturn).   

               IF cReturn <> "NOK" THEN DO:
                  
                  FOR EACH tt-etiquetas-ae:

                      FIND FIRST aviso-entrada EXCLUSIVE-LOCK
                           WHERE aviso-entrada.cod-estabel = ord-prod.cod-estabel NO-ERROR.
    
                      IF AVAIL aviso-entrada THEN
                           ASSIGN i-nr-ae                 = aviso-entrada.ultimo-ae + 1
                                  aviso-entrada.ultimo-ae = i-nr-ae.
                      ELSE DO:
                           CREATE aviso-entrada.
                           ASSIGN aviso-entrada.cod-estabel = ord-prod.cod-estabel
                                  aviso-entrada.ultimo-ae   = 1.
                      END.

                      CREATE ae-item.
                      ASSIGN ae-item.cod-estabel = ord-prod.cod-estabel
                             ae-item.it-codigo   = ord-prod.it-codigo
                             ae-item.quantidade  = tt-etiquetas-ae.qtde
                             ae-item.nr-ae       = i-nr-ae
                             ae-item.sequencia   = 1
                             ae-item.nf          = 0
                             ae-item.data        = TODAY
                             ae-item.localizacao = ITEM.cod-localiz
                             ae-item.cod-depos   = c-depos-ent
                             ae-item.impresso    = YES.


                      /* Linha cria AE j† com status baixada */
                      IF int-lin-prod.ae-baixada = YES THEN
                         ASSIGN ae-item.situacao = YES.
    
                      CREATE tt-ae.
                      ASSIGN tt-ae.numero = ROWID(ae-item).
                      
                  END.

               END.

          END. /* do transaction */

          RUN piImprimeRep.
       END.
    END.
END PROCEDURE.



PROCEDURE piImprimeRep: /* Em uso */

    DEFINE VARIABLE cNomeImp   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h_esapi020 AS HANDLE      NO-UNDO.

    IF VALID-HANDLE(h-acomp) THEN run pi-finalizar in h-acomp.

    FOR FIRST imprsor_usuar NO-LOCK
        WHERE imprsor_usuar.cod_usuario = c-seg-usuario
        AND   imprsor_usuar.log_imprsor_princ:

        FOR FIRST layout_impres NO-LOCK
            WHERE layout_impres.nom_impressora = imprsor_usuar.nom_impressora
            AND   layout_impres.log_layout_impres_princ:

            ASSIGN cNomeImp = layout_impres.nom_impressora + ":" +
                              layout_impres.cod_layout_impres.

        END.
    END.       

    /*IF NOT ttRepApi.nao-imprimir THEN DO:*/

        for each tt-ae no-lock,
            each ae-item where rowid(ae-item) = tt-ae.numero no-lock: 
            
            //ASSIGN cNomeImp = 'c:/temp/AE-' + STRING(ae-item.nr-ae) + '.txt'. 

            /* Imprime Etiqueta de AE */
            IF NOT valid-handle(h_esapi020) THEN 
                RUN esapi/esapi020.p PERSISTENT SET h_esapi020.
          
            IF AVAIL ord-prod THEN
               RUN pi-grava-op IN h_esapi020 (INPUT ord-prod.nr-ord-prod) .
    
            RUN pi-imprime-AE IN h_esapi020 (INPUT cNomeImp, /* Nome Impressora */
                                             INPUT ae-item.cod-estabel,
                                             INPUT ae-item.nr-ae,
                                             INPUT ae-item.sequencia,      
                                             INPUT c-seg-usuario).
    
            
        end.

        DELETE PROCEDURE h_esapi020.

    //END.
    
END.

