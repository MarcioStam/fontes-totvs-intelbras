DEFINE VARIABLE c-linha AS CHARACTER FORMAT "x(200)".
INPUT FROM "C:\Users\Roger\Desktop\novo.csv".
    
DEF VAR i AS INTEGER NO-UNDO.
DEFINE VARIABLE c-label-cc  AS CHAR  FORMAT "X(350)"  NO-UNDO.
DEFINE VARIABLE c-arq-cc    AS CHAR FORMAT "X(180)"   NO-UNDO.
DEFINE VARIABLE l-erro      AS LOG NO-UNDO.

DEF STREAM s2.
OUTPUT STREAM s2 TO "c:\temp\tempo.txt" APPEND.


FUNCTION fn-retorna-nome-beneficio RETURNS CHAR
    (p-beneficio AS INT) FORWARD.

DEF STREAM exp2.

DEF TEMP-TABLE tt-base
    FIELD canal                AS INTEGER
    FIELD unid-neg              AS CHAR 
    FIELD tipo-beneficio       AS INT
    FIELD guid-class           AS CHAR FORMAT "X(36)"
    FIELD tipo-categoria       AS CHAR FORMAT "X(20)"
    FIELD guid-canal           AS CHAR FORMAT "X(36)"
    FIELD guid-beneficio       AS CHAR FORMAT "X(36)"
    FIELD guid-beneficio-canal AS CHAR FORMAT "X(36)"
    FIELD perc-benef           AS DEC
    FIELD valor-beneficio      AS DEC
    FIELD perc-custo           AS DEC
    FIELD conta-contabil       AS CHAR
    FIELD centro-custo         AS CHAR
    FIELD estabelec            AS CHAR
    FIELD especie              AS CHAR
    FIELD tipo-fluxo           AS CHAR
        INDEX idx-primary  IS PRIMARY UNIQUE canal unid-neg tipo-beneficio .


/* Mesma temp-table utilizada no programa esesb005rp...para c†lculo dos benef°cios */
DEF TEMP-TABLE tt-beneficio  NO-UNDO
    FIELD canal                AS INTEGER
    FIELD guid-canal           AS CHAR FORMAT "X(36)"
    FIELD unid-neg             AS CHAR 
    FIELD guid-categoria       AS CHAR FORMAT "X(36)"
    FIELD guid-beneficio       AS CHAR FORMAT "X(36)"
    FIELD tipo-beneficio       AS INTEGER
    FIELD tipo-categoria       AS CHAR
    FIELD guid-class           AS CHAR FORMAT "X(36)"
    FIELD nome-class           AS CHAR FORMAT "X(50)"
    FIELD exclusividade        AS LOGICAL
    FIELD id-status            AS INT
    FIELD calcula-verba        AS LOGICAL
    /*MSG OBTER_PARAMETROS_GLOBAIS*/
    FIELD perc-global          AS DECIMAL
    /*MSG142*/
    FIELD conta-contab         AS CHAR FORMAT "X(20)" 
    FIELD centro-custo         AS CHAR FORMAT "X(20)" 
    FIELD cod-estabel          AS CHAR FORMAT "X(5)"  
    FIELD cod-especie          AS CHAR                
    FIELD tipo-fluxo           AS CHAR
    FIELD perc-custo           AS DECIMAL              /*MSG0142*/   
    FIELD perc-prov-meta       AS DECIMAL              /*MSG0142*/   
    FIELD guid-beneficio-canal AS CHAR FORMAT "X(36)"
            INDEX IDX-PRIMARY IS UNIQUE PRIMARY
            canal
            unid-neg
            tipo-beneficio.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(250)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

def temp-table tt-erro-aux no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".


DEF TEMP-TABLE tt-erro-apb LIKE tt-erro.
DEF TEMP-TABLE tt-cc-benef LIKE int-cc-benef.

RUN pi-importa-arquivo.

RUN pi-carrega-tt-beneficio.

ASSIGN c-label-cc = "MOVTO;CANAL;UNID NEG;BENEF÷CIO;CATEGORIA;CLASSIFICACAO;PER INI;PER FIM;BASE CµLCULO;% APLICADO;SALDO CALCULADO;% CUSTO;SALDO x %CUSTO;DT TRANS;DT VENCTO;STATUS CC;USUARIO;SALDO VMC TRANSFERIDO;GUID CLASS;GUID CANAL;GUID BENEF÷CIO;GUID BENEF÷CIO CANAL"
       c-arq-cc = SESSION:TEMP-DIRECTORY + "log-import-benef_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
OUTPUT STREAM exp2 TO VALUE(c-arq-cc) CONVERT TARGET "iso8859-1".
PUT STREAM exp2 c-label-CC SKIP.

RUN pi-cria-tt-conta-corrente.

OUTPUT STREAM exp2     CLOSE.

RUN pi-cria-cc-integra-ABP.

IF  RETURN-VALUE <> "OK" THEN l-erro = YES.

FOR EACH tt-erro:

    MESSAGE  "tt-erro.cod: " tt-erro.codigo SKIP
             "tt-erro.mensagem: " tt-erro.mensagem SKIP
             "tt-erro.ajuda: " tt-erro.ajuda SKIP
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.


/* FIM */

PROCEDURE pi-cria-cc-integra-ABP:

    /* ATUALIZAR O CONTAS A PAGAR */
    DEF VAR h-esesb003-apb AS HANDLE NO-UNDO.  
    
    IF  NOT VALID-HANDLE(h-esesb003-apb) THEN
        RUN esp/esb/esesbapi003-apb-import.p PERSISTENT SET h-esesb003-apb.

    IF  VALID-HANDLE(h-esesb003-apb) THEN
        RUN pi-busca-beneficios-canal IN h-esesb003-apb (INPUT TABLE tt-beneficio).

    DEF VAR i AS INTEGER.
    DEF VAR j AS INTEGER.
    FOR EACH tt-cc-benef:
        i = i + 1.
/*         FIND FIRST fornec_financ NO-LOCK                        */
/*             WHERE fornec_financ.cdn_fornec = tt-cc-benef.canal  */
/*               AND fornec_financ.cod_empresa = "1" NO-ERROR.     */
/*         IF  NOT AVAIL fornec_financ THEN                        */
/*             DISP tt-cc-benef.canal.                                  */
    END.

    FOR EACH tt-cc-benef:
        j = j + 1.
        DISP j " / " i.

        IF  tt-cc-benef.tipo-beneficio = 66 THEN
            NEXT.

        /* CRIA A CONTA CORRENTE */
        CREATE int-cc-benef.
        BUFFER-COPY tt-cc-benef TO int-cc-benef.

        FIND CURRENT int-cc-benef NO-LOCK.

        IF  tt-cc-benef.tipo-beneficio = 22 THEN
            NEXT.

        /* INTEGRA APB*/
        PUT STREAM s2 "Ini: " string(TIME, "HH:MM:SS") SKIP.
        RUN pi-Integra-Despesas-APB IN h-esesb003-apb (INPUT ROWID(int-cc-benef),
                                                       INPUT TODAY,
                                                       INPUT int-cc-benef.dt-periodo-fim,
                                                       OUTPUT TABLE tt-erro-apb).
        PUT STREAM s2 "Fim: " string(TIME, "HH:MM:SS") SKIP(2).
         IF  CAN-FIND (FIRST tt-erro-apb)
         OR  RETURN-VALUE <> "OK" THEN DO:
             DEF VAR l-erro AS LOG NO-UNDO.
             FOR EACH tt-erro-apb:
                 RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                     INPUT tt-erro-apb.mensagem,
                                                     INPUT tt-erro-apb.mensagem ).
                 l-erro = YES.
             END.

             IF  NOT l-erro THEN DO:
                 RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                     INPUT "Retorno com erro, mas n∆o retornou descriá∆o do mesmo.",
                                                     INPUT "").

             END.
             IF  VALID-HANDLE(h-esesb003-apb) THEN
                DELETE PROCEDURE h-esesb003-apb.
             RETURN "NOK".
         END.
    END.

    IF  VALID-HANDLE(h-esesb003-apb) THEN
        DELETE PROCEDURE h-esesb003-apb.

    RETURN "OK".

END.

PROCEDURE pi-cria-tt-conta-corrente:

    FOR EACH tt-base:
    
        FIND FIRST tt-cc-benef
            WHERE tt-cc-benef.tp-movto       = 2
              and tt-cc-benef.canal          = tt-base.canal          
              and tt-cc-benef.unid-neg       = tt-base.unid-neg       
              and tt-cc-benef.tipo-beneficio = tt-base.tipo-beneficio NO-ERROR.

        IF  AVAIL tt-cc-benef THEN DO:
            MESSAGE  "tt-cc-benef.tp-movto       : " tt-cc-benef.tp-movto          skip
                     "tt-cc-benef.canal          : " tt-cc-benef.canal             skip
                     "tt-cc-benef.unid-neg       : " tt-cc-benef.unid-neg          skip
                     "tt-cc-benef.tipo-beneficio : " tt-cc-benef.tipo-beneficio    skip
                     "tt-cc-benef.dt-periodo-ini : " tt-cc-benef.dt-periodo-ini    SKIP
                     "tt-cc-benef.dt-periodo-fim : " tt-cc-benef.dt-periodo-fim 
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

            STOP.
        END.

        CREATE tt-cc-benef.
        ASSIGN tt-cc-benef.tp-movto             = 2 /*DESPESA*/
               tt-cc-benef.canal                = tt-base.canal
               tt-cc-benef.unid-neg             = tt-base.unid-neg
               tt-cc-benef.tipo-beneficio       = tt-base.tipo-beneficio
               tt-cc-benef.classificacao        = tt-base.guid-class
               tt-cc-benef.categoria            = tt-base.tipo-categoria
               tt-cc-benef.guid-canal           = tt-base.guid-canal
               tt-cc-benef.guid-beneficio       = tt-base.guid-beneficio
               tt-cc-benef.guid-beneficio-canal = tt-base.guid-beneficio-canal
               tt-cc-benef.dt-periodo-ini       = 07/01/2014
               tt-cc-benef.dt-periodo-fim       = 09/30/2014
               tt-cc-benef.vl-base-calc         = 0                      
               tt-cc-benef.perc-benef           = tt-base.perc-benef
               tt-cc-benef.vl-saldo-ori         = tt-base.valor-beneficio
               tt-cc-benef.vl-saldo             = tt-base.valor-beneficio
               tt-cc-benef.dt-transacao         = 10/06/2014
               tt-cc-benef.dt-vencimento        = 09/30/2014 + 60
               tt-cc-benef.id-status            = 1 /* ATIVA */
               tt-cc-benef.usuario              = "VE888002" 
               tt-cc-benef.perc-custo           = tt-base.perc-custo.

         RUN pi-exporta-tt-cc-benef.
    END.

END.


/* FIM */
PROCEDURE pi-carrega-tt-beneficio:

    RETURN-VALUE = "NOK".

    FOR EACH tt-base
        BREAK BY canal
              BY unid-neg
              BY tipo-beneficio:

        IF  FIRST-OF (tipo-beneficio) THEN DO:
            CREATE tt-beneficio.
            ASSIGN tt-beneficio.canal                   = tt-base.canal
                   tt-beneficio.guid-canal              = tt-base.guid-canal
                   tt-beneficio.unid-neg                = tt-base.unid-neg
                   tt-beneficio.guid-categoria          = ""
                   tt-beneficio.guid-beneficio          = tt-base.guid-beneficio
                   tt-beneficio.tipo-beneficio          = tt-base.tipo-beneficio
                   tt-beneficio.tipo-categoria          = tt-base.tipo-categoria
                   tt-beneficio.guid-class              = tt-base.guid-class
                   tt-beneficio.nome-class              = ""
                   tt-beneficio.exclusividade           = NO
                   tt-beneficio.id-status               = 1
                   tt-beneficio.calcula-verba           = NO
                   tt-beneficio.perc-global             = tt-base.perc-benef
                   tt-beneficio.conta-contab            = tt-base.conta-contabil    
                   tt-beneficio.centro-custo            = tt-base.centro-custo      
                   tt-beneficio.cod-estabel             = tt-base.estabelec         
                   tt-beneficio.cod-especie             = tt-base.especie           
                   tt-beneficio.tipo-fluxo              = tt-base.tipo-fluxo        
                   tt-beneficio.perc-custo              = tt-base.perc-custo
                   tt-beneficio.perc-prov-meta          = 0
                   tt-beneficio.guid-beneficio-canal    = tt-base.guid-beneficio-canal.
                   
        END.
    END.

    RETURN "OK".
END.


PROCEDURE pi-importa-arquivo:

    RETURN-VALUE = "NOK".

    REPEAT: 

        IMPORT UNFORMATTED c-linha.

        i = i + 1.
        
        IF  i = 1 THEN 
            NEXT.

        IF  c-linha = "" THEN
            LEAVE.
        
        CREATE tt-base.
        ASSIGN tt-base.canal                = INT(entry(1, c-linha, ";"))
               tt-base.unid-neg             =     entry(2, c-linha, ";")
               tt-base.tipo-beneficio       = INT(entry(3, c-linha, ";"))
               tt-base.guid-class           =     entry(4, c-linha, ";") 
               tt-base.tipo-categoria       =     entry(5, c-linha, ";")
               tt-base.guid-canal           =     entry(6, c-linha, ";")
               tt-base.guid-beneficio       =     entry(7, c-linha, ";")
               tt-base.guid-beneficio-canal =     entry(8, c-linha, ";")
               tt-base.perc-benef           = DEC(entry(9, c-linha, ";"))     
               tt-base.valor-beneficio      = DEC(entry(10, c-linha, ";"))
               tt-base.perc-custo           = DEC(entry(11, c-linha, ";"))
               tt-base.conta-contabil       =     entry(12, c-linha, ";")
               tt-base.centro-custo         =     entry(13, c-linha, ";")
               tt-base.estabelec            =     entry(14, c-linha, ";")
               tt-base.especie              =     entry(15, c-linha, ";")
               tt-base.tipo-fluxo           =     entry(16, c-linha, ";").

    END.

    INPUT CLOSE.

    RETURN "OK".
END.

PROCEDURE pi-exporta-tt-cc-benef:
    
    EXPORT STREAM exp2 DELIMITER ";" IF tt-cc-benef.tp-movto = 1 THEN "Provis∆o" ELSE "Despesa"
                                     tt-cc-benef.canal         
                                     tt-cc-benef.unid-neg      
                                     fn-retorna-nome-beneficio (tt-cc-benef.tipo-beneficio) 
                                     tt-cc-benef.categoria
                                     tt-beneficio.nome-class
                                     tt-cc-benef.dt-periodo-ini
                                     tt-cc-benef.dt-periodo-fim
                                     tt-cc-benef.vl-base-calc
                                     tt-cc-benef.perc-benef
                                     tt-cc-benef.vl-saldo
                                     tt-cc-benef.perc-custo
                                     ((tt-cc-benef.vl-base-calc * tt-cc-benef.perc-custo / 100) * tt-cc-benef.perc-benef / 100)
                                     tt-cc-benef.dt-transacao  
                                     tt-cc-benef.dt-vencimento 
                                     IF tt-cc-benef.id-status = 1 THEN "ATIVA" ELSE "FINALIZADA"
                                     tt-cc-benef.usuario       
                                     tt-cc-benef.vl-saldo-transp-vmc-ouro
                                     tt-cc-benef.classificacao       
                                     tt-cc-benef.guid-canal              
                                     tt-cc-benef.guid-beneficio          
                                     tt-cc-benef.guid-beneficio-canal.      

END.



PROCEDURE pi-cria-erro:

    DEFINE INPUT PARAM p-erro     AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM p-mensagem AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-ajuda    AS CHAR NO-UNDO.

    CREATE tt-erro.
    ASSIGN tt-erro.codigo   = p-erro
           tt-erro.mensagem = p-mensagem
           tt-erro.ajuda    = p-ajuda.

END.


FUNCTION fn-retorna-nome-beneficio RETURNS CHAR
    (p-beneficio AS INT):
    
    CASE p-beneficio:
        WHEN 21 THEN RETURN "VMC".
        WHEN 22 THEN RETURN "STOCK ROTATION".
        WHEN 37 THEN RETURN "REBATE".
        WHEN 66 THEN RETURN "REBATE P‡S-VENDA".
    END CASE.

    RETURN "".
END FUNCTION.
