/*****************************************************************************
** Programa..............: esp/esacr076rp.p
** Descri‡Æo.............: Integra‡Æo batch ACR x DEPS
** Autor.................: Andrey M Oliveira
** Criado em.............: 23/08/2019
*****************************************************************************/
{include/i-prgvrs.i esacr076rp 1.00.00.000}

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def input parameter raw-param as raw no-undo.
def input parameter table     for tt-raw-digita.

DEF TEMP-TABLE tt_categ_cad NO-UNDO
    FIELD cod_categ       AS CHAR FORMAT "x(50)"
    FIELD nome_categoria  AS CHAR FORMAT "x(20)".

DEF TEMP-TABLE tt_tit_acr_deps NO-UNDO
    FIELD cod_estab      LIKE tit_acr_deps.cod_estab
    FIELD num_id_tit_acr LIKE tit_acr_deps.num_id_tit_acr.

{include/i-rpvar.i}
{esp/esb/esesb000.i}

DEF BUFFER b_tit_acr_deps FOR tit_acr_deps.

DEF STREAM s_arqexport.
DEF STREAM s_arqrelat.

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar 
    AS CHARACTER FORMAT "x(3)" LABEL "Empresa" COLUMN-LABEL "Empresa" NO-UNDO.

DEF VAR v_cod_usuar_corren AS CHAR               NO-UNDO.
DEF VAR c-msg              AS CHAR FORMAT "x(7)" NO-UNDO.
DEF VAR h-acomp            AS HANDLE             NO-UNDO.
DEF VAR raw-tit-acr        AS RAW                NO-UNDO.
DEF VAR v_cont             AS INT                NO-UNDO.
DEF VAR v_cont2            AS INT                NO-UNDO.
DEF VAR v_cod_return       AS CHAR               NO-UNDO.

FIND FIRST mgcad.empresa NO-LOCK   
     WHERE empresa.ep-codigo = v_cod_empres_usuar NO-ERROR.  

assign c-versao       = "1.00"
       c-revisao      = "000"
       c-empresa      = mgcad.empresa.razao-social WHEN AVAIL mgcad.empresa
       c-programa     = "esacr076rp"
       c-titulo-relat = "Integracao Titulos DEPS".

EMPTY TEMP-TABLE tt_tit_acr_deps.
EMPTY TEMP-TABLE tt-param.
EMPTY TEMP-TABLE tt_categ_cad.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Inicializando...").

{include/i-rpcab.i}
{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

PUT "Mensagem;Estabelecimento;Especie;Serie;Titulo;Parcela;Cliente" SKIP.

ASSIGN v_cont = 0.

DO TRANS:
    FOR EACH estabelecimento
        WHERE estabelecimento.cod_empresa = v_cod_empres_usuar NO-LOCK:
    
        FOR EACH tit_acr_deps
            WHERE tit_acr_deps.cod_estab   = estabelecimento.cod_estab
            AND   tit_acr_deps.log_integra = NO NO-LOCK:
    
            ASSIGN v_cont  = v_cont  + 1
                   v_cont2 = v_cont2 + 1.
    
            RUN pi-acompanhar IN h-acomp (INPUT "Buscando t¡tulos ... " + STRING(v_cont2)).
    
            FIND FIRST tt_tit_acr_deps
                WHERE tt_tit_acr_deps.cod_estab      = tit_acr_deps.cod_estab      
                AND   tt_tit_acr_deps.num_id_tit_acr = tit_acr_deps.num_id_tit_acr NO-LOCK NO-ERROR.
    
            IF  NOT AVAIL tt_tit_acr_deps THEN DO:
                CREATE tt_tit_acr_deps.
                ASSIGN tt_tit_acr_deps.cod_estab      = tit_acr_deps.cod_estab
                       tt_tit_acr_deps.num_id_tit_acr = tit_acr_deps.num_id_tit_acr.
            END.
    
            IF  CAN-FIND(FIRST tit_acr NO-LOCK
                WHERE tit_acr.cod_estab      = tit_acr_deps.cod_estab
                AND   tit_acr.num_id_tit_acr = tit_acr_deps.num_id_tit_acr) THEN DO:
    
                FOR FIRST tit_acr NO-LOCK
                    WHERE tit_acr.cod_estab      = tit_acr_deps.cod_estab
                    AND   tit_acr.num_id_tit_acr = tit_acr_deps.num_id_tit_acr: 

                    FIND FIRST tt_categ_cad
                        WHERE tt_categ_cad.cod_categ  = tit_acr.cod_estab
                        AND   tt_categ_cad.nome_categ = "Estabelecimento" NO-LOCK NO-ERROR.
            
                    IF  NOT AVAIL tt_categ_cad THEN DO:
                        CREATE tt_categ_cad.
                        ASSIGN tt_categ_cad.cod_categ  = tit_acr.cod_estab
                               tt_categ_cad.nome_categ = "Estabelecimento".
                    END.
            
                    FIND FIRST tt_categ_cad
                        WHERE tt_categ_cad.cod_categ  = tit_acr.cod_espec_docto
                        AND   tt_categ_cad.nome_categ = "Esp‚cie" NO-LOCK NO-ERROR.
            
                    IF  NOT AVAIL tt_categ_cad THEN DO:
                        CREATE tt_categ_cad.
                        ASSIGN tt_categ_cad.cod_categ  = tit_acr.cod_espec_docto
                               tt_categ_cad.nome_categ = "Esp‚cie".
                    END.
                                             
                    FIND FIRST tt_categ_cad
                        WHERE tt_categ_cad.cod_categ  = tit_acr.cod_ser_docto
                        AND   tt_categ_cad.nome_categ = "S‚rie" NO-LOCK NO-ERROR.
            
                    IF  NOT AVAIL tt_categ_cad THEN DO:
                        CREATE tt_categ_cad.
                        ASSIGN tt_categ_cad.cod_categ  = tit_acr.cod_ser_docto
                               tt_categ_cad.nome_categ = "S‚rie".
                    END.
                                             
                    FIND FIRST tt_categ_cad
                        WHERE tt_categ_cad.cod_categ  = tit_acr.cod_portador
                        AND   tt_categ_cad.nome_categ = "Portador" NO-LOCK NO-ERROR.
            
                    IF  NOT AVAIL tt_categ_cad THEN DO:
                        CREATE tt_categ_cad.
                        ASSIGN tt_categ_cad.cod_categ  = tit_acr.cod_portador
                               tt_categ_cad.nome_categ = "Portador".
                    END.
                                             
                    FIND FIRST tt_categ_cad
                        WHERE tt_categ_cad.cod_categ  = tit_acr.cod_cart_bcia
                        AND   tt_categ_cad.nome_categ = "Carteira" NO-LOCK NO-ERROR.
            
                    IF  NOT AVAIL tt_categ_cad THEN DO:
                        CREATE tt_categ_cad.
                        ASSIGN tt_categ_cad.cod_categ  = tit_acr.cod_cart_bcia
                               tt_categ_cad.nome_categ = "Carteira".
                    END.
                END.
            END.
            ELSE DO:
                IF  tit_acr_deps.dados_cancel <> "" 
                AND NUM-ENTRIES(tit_acr_deps.dados_cancel,";") = 14 THEN DO:

                    FIND FIRST tt_categ_cad
                        WHERE tt_categ_cad.cod_categ  = ENTRY(9,tit_acr_deps.dados_cancel,";")
                        AND   tt_categ_cad.nome_categ = "Estabelecimento" NO-LOCK NO-ERROR.
        
                    IF  NOT AVAIL tt_categ_cad THEN DO:
                        CREATE tt_categ_cad.
                        ASSIGN tt_categ_cad.cod_categ  = ENTRY(9,tit_acr_deps.dados_cancel,";")
                               tt_categ_cad.nome_categ = "Estabelecimento".
                    END.
        
                    FIND FIRST tt_categ_cad
                        WHERE tt_categ_cad.cod_categ  = ENTRY(10,tit_acr_deps.dados_cancel,";")
                        AND   tt_categ_cad.nome_categ = "Esp‚cie" NO-LOCK NO-ERROR.
        
                    IF  NOT AVAIL tt_categ_cad THEN DO:
                        CREATE tt_categ_cad.
                        ASSIGN tt_categ_cad.cod_categ  = ENTRY(10,tit_acr_deps.dados_cancel,";")
                               tt_categ_cad.nome_categ = "Esp‚cie".
                    END.
        
                    FIND FIRST tt_categ_cad
                        WHERE tt_categ_cad.cod_categ  = ENTRY(11,tit_acr_deps.dados_cancel,";")
                        AND   tt_categ_cad.nome_categ = "S‚rie" NO-LOCK NO-ERROR.
        
                    IF  NOT AVAIL tt_categ_cad THEN DO:
                        CREATE tt_categ_cad.
                        ASSIGN tt_categ_cad.cod_categ  = ENTRY(11,tit_acr_deps.dados_cancel,";")
                               tt_categ_cad.nome_categ = "S‚rie".
                    END.
        
                    FIND FIRST tt_categ_cad
                        WHERE tt_categ_cad.cod_categ  = ENTRY(12,tit_acr_deps.dados_cancel,";")
                        AND   tt_categ_cad.nome_categ = "Portador" NO-LOCK NO-ERROR.
        
                    IF  NOT AVAIL tt_categ_cad THEN DO:
                        CREATE tt_categ_cad.
                        ASSIGN tt_categ_cad.cod_categ  = ENTRY(12,tit_acr_deps.dados_cancel,";")
                               tt_categ_cad.nome_categ = "Portador".
                    END.
        
                    FIND FIRST tt_categ_cad
                        WHERE tt_categ_cad.cod_categ  = ENTRY(13,tit_acr_deps.dados_cancel,";")
                        AND   tt_categ_cad.nome_categ = "Carteira" NO-LOCK NO-ERROR.
        
                    IF  NOT AVAIL tt_categ_cad THEN DO:
                        CREATE tt_categ_cad.
                        ASSIGN tt_categ_cad.cod_categ  = ENTRY(13,tit_acr_deps.dados_cancel,";")
                               tt_categ_cad.nome_categ = "Carteira".
                    END.
                END.
            END.
    
            IF  v_cont = 250 THEN DO:
                /* envia categorias */
                RUN esp/wso/eswso0016.p (INPUT TABLE tt_categ_cad).
    
                /* envia titulos */
                RUN pi_processa.
    
                IF  v_cod_return = "200" THEN DO:
                    
                    FOR EACH tt_tit_acr_deps EXCLUSIVE-LOCK:
    
                        FIND FIRST b_tit_acr_deps EXCLUSIVE-LOCK
                            WHERE b_tit_acr_deps.cod_estab      = tt_tit_acr_deps.cod_estab      
                            AND   b_tit_acr_deps.num_id_tit_acr = tt_tit_acr_deps.num_id_tit_acr NO-ERROR.
        
                        IF  AVAIL b_tit_acr_deps THEN DO:
                            ASSIGN b_tit_acr_deps.log_integra = YES
                                   c-msg                      = "MSG0097".
    
                            FIND FIRST tit_acr
                                WHERE tit_acr.cod_estab      = b_tit_acr_deps.cod_estab      
                                AND   tit_acr.num_id_tit_acr = b_tit_acr_deps.num_id_tit_acr NO-LOCK NO-ERROR.
                        
                            IF  AVAIL tit_acr THEN DO:
                                PUT c-msg                    ";"
                                    tit_acr.cod_estab        ";"
                                    tit_acr.cod_espec_docto  ";"
                                    tit_acr.cod_ser_docto    ";"
                                    tit_acr.cod_tit_acr      ";"
                                    tit_acr.cod_parcela      ";"
                                    tit_acr.cdn_cliente SKIP.
                            END.
                            ELSE DO:
                                IF  b_tit_acr_deps.dados_cancel <> ""
                                AND NUM-ENTRIES(b_tit_acr_deps.dados_cancel,";") = 14 THEN DO:
                                    PUT c-msg                                     ";"
                                        ENTRY( 9,b_tit_acr_deps.dados_cancel,";") ";"  
                                        ENTRY(10,b_tit_acr_deps.dados_cancel,";") ";"
                                        ENTRY(11,b_tit_acr_deps.dados_cancel,";") ";"
                                        entry( 2,b_tit_acr_deps.dados_cancel,";") ";"  
                                        entry( 6,b_tit_acr_deps.dados_cancel,";") ";"  
                                        entry( 1,b_tit_acr_deps.dados_cancel,";") SKIP.
                                END.
                            END.
                        END.
    
                        VALIDATE b_tit_acr_deps.
                    END.
                END.
    
                ASSIGN v_cont = 0.
    
                EMPTY TEMP-TABLE tt_tit_acr_deps.
                EMPTY TEMP-TABLE tt_categ_cad.
            END.
        END.
    END.
    
    IF  CAN-FIND(FIRST tt_tit_acr_deps) THEN DO:
        /* envia categorias */
        RUN esp/wso/eswso0016.p (INPUT TABLE tt_categ_cad).

        /* normal */
        RUN pi_processa.
    
        IF  v_cod_return = "200" THEN DO:
    
            FOR EACH tt_tit_acr_deps EXCLUSIVE-LOCK:
    
                FIND FIRST b_tit_acr_deps EXCLUSIVE-LOCK
                    WHERE b_tit_acr_deps.cod_estab      = tt_tit_acr_deps.cod_estab      
                    AND   b_tit_acr_deps.num_id_tit_acr = tt_tit_acr_deps.num_id_tit_acr NO-ERROR.
    
                IF  AVAIL b_tit_acr_deps THEN DO:
                    ASSIGN b_tit_acr_deps.log_integra = YES
                           c-msg                      = "MSG0097".
    
                    FIND FIRST tit_acr
                        WHERE tit_acr.cod_estab      = b_tit_acr_deps.cod_estab      
                        AND   tit_acr.num_id_tit_acr = b_tit_acr_deps.num_id_tit_acr NO-LOCK NO-ERROR.
    
                    IF  AVAIL tit_acr THEN DO:
                        PUT c-msg                   ";"
                            tit_acr.cod_estab       ";"
                            tit_acr.cod_espec_docto ";"
                            tit_acr.cod_ser_docto   ";"
                            tit_acr.cod_tit_acr     ";"
                            tit_acr.cod_parcela     ";"
                            tit_acr.cdn_cliente SKIP.
                    END.
                    ELSE DO:
                        IF  b_tit_acr_deps.dados_cancel <> "" 
                        AND NUM-ENTRIES(b_tit_acr_deps.dados_cancel,";") = 14 THEN DO:
                            put c-msg                                     ";"
                                ENTRY( 9,b_tit_acr_deps.dados_cancel,";") ";"
                                ENTRY(10,b_tit_acr_deps.dados_cancel,";") ";"
                                ENTRY(11,b_tit_acr_deps.dados_cancel,";") ";"
                                ENTRY( 2,b_tit_acr_deps.dados_cancel,";") ";"
                                ENTRY( 6,b_tit_acr_deps.dados_cancel,";") ";"
                                ENTRY( 1,b_tit_acr_deps.dados_cancel,";") SKIP.
                        END.
                    END.
                END.
    
                VALIDATE b_tit_acr_deps.
    
                DELETE tt_tit_acr_deps.
            END.
        END.
    
        /* antecipacao */
        FOR EACH tt_tit_acr_deps NO-LOCK:
        
            FIND FIRST tit_acr
                WHERE tit_acr.cod_estab      = tt_tit_acr_deps.cod_estab      
                AND   tit_acr.num_id_tit_acr = tt_tit_acr_deps.num_id_tit_acr NO-LOCK NO-ERROR.
        
            IF  NOT AVAIL tit_acr THEN NEXT.
        
            /*RUN pi-acompanhar IN h-acomp (INPUT "Integrando DEPS ...").*/
        
            RAW-TRANSFER tt_tit_acr_deps TO raw-tit-acr.
        
            IF  tit_acr.ind_tip_espec_docto = "Antecipa‡Æo" THEN DO:
                RUN esp/esb/esesb003.p (INPUT        "msg0311",
                                        INPUT        raw-tit-acr,
                                        OUTPUT TABLE resultado) NO-ERROR.
        
                ASSIGN c-msg = "MSG0311".
        
                PUT c-msg                   ";"
                    tit_acr.cod_estab       ";"
                    tit_acr.cod_espec_docto ";"
                    tit_acr.cod_ser_docto   ";"
                    tit_acr.cod_tit_acr     ";"
                    tit_acr.cod_parcela     ";"
                    tit_acr.cdn_cliente SKIP.

                FIND FIRST tit_acr_deps
                    WHERE tit_acr_deps.cod_estab      = tt_tit_acr_deps.cod_estab      
                    AND   tit_acr_deps.num_id_tit_acr = tt_tit_acr_deps.num_id_tit_acr EXCLUSIVE-LOCK NO-ERROR.

                IF  AVAIL tit_acr_deps THEN
                    ASSIGN tit_acr_deps.log_integra = YES.

                VALIDATE tit_acr_deps.
            END.
        END.
    
        EMPTY TEMP-TABLE tt_tit_acr_deps.
    END.
END.

{include/i-rpclo.i}

RUN pi-finalizar IN h-acomp.

RETURN "OK".


/* envia titulos */
PROCEDURE pi_processa:
    RUN esp/wso/eswso0017.p (INPUT TABLE tt_tit_acr_deps,
                             OUTPUT v_cod_return).
END PROCEDURE.
