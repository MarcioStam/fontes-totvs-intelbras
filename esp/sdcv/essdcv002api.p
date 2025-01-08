/*****************************************************************************
**   Programa : essdcv002api.p.p
**   Funcao   : geraá∆o pedido de compra/ordem e relaá‰es SDCV
******************************************************************************/
CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-pedido-compra-sdcv NO-UNDO
    FIELD cod-estabel      LIKE pedido-compr.cod-estabel
    FIELD cod-emitente     LIKE pedido-compr.cod-emitente
    FIELD cod-comprado     LIKE usuar_mestre.cod_usuario
    FIELD cod-transp       LIKE pedido-compr.cod-transp
    FIELD frete            AS   INTEGER 
    FIELD observacao       AS   CHARACTER FORMAT "x(100)":U
    FIELD end-entrega      LIKE pedido-compr.end-entrega
    FIELD cod-cond-pag     LIKE pedido-compr.cod-cond-pag
    FIELD cod-compra       AS   CHARACTER
    FIELD mo-codigo        LIKE moeda.mo-codigo.
 
DEFINE TEMP-TABLE tt-ordem-compra-sdcv NO-UNDO
    FIELD cod-compra       AS   CHARACTER
    FIELD numero-ordem     LIKE ordem-compra.numero-ordem
    FIELD cod-item         LIKE ordem-compra.it-codigo
    FIELD qt-solic         LIKE ordem-compra.qt-solic
    FIELD prazo-entreg     AS   DATE
    FIELD preco-unit       LIKE cotacao-item.preco-unit
    FIELD aliquota-icm     LIKE cotacao-item.aliquota-icm
    FIELD aliquota-ipi     LIKE cotacao-item.aliquota-ipi
    FIELD cod-sdcv         AS   CHARACTER
    FIELD requisitante     LIKE usuar_mestre.cod_usuario
    FIELD ct-codigo        LIKE ordem-compra.ct-codigo
    FIELD sc-codigo        LIKE ordem-compra.sc-codigo
    FIELD desc-sdcv        AS   CHARACTER.
 
DEFINE TEMP-TABLE tt-rateio-ordem-sdcv NO-UNDO
    FIELD cod-sdcv         AS   CHARACTER
    FIELD ct-codigo        LIKE matriz-rat-ordem.ct-codigo
    FIELD sc-codigo        LIKE matriz-rat-ordem.sc-codigo
    FIELD perc             LIKE matriz-rat-ordem.perc-rateio.
 
DEFINE TEMP-TABLE tt-retorno-pedido-sdcv NO-UNDO
    FIELD cod_compra       AS   CHARACTER 
    FIELD num_pedido_compr LIKE pedido-compr.num-pedido
    FIELD num_mensagem     AS   CHARACTER.
 
DEFINE TEMP-TABLE tt-retorno-ordem-sdcv NO-UNDO
    FIELD cod_sdcv         AS   CHARACTER
    FIELD numero_ordem     LIKE ordem-compra.numero-ordem.
 
DEFINE TEMP-TABLE tt-erro-sdcv NO-UNDO
    FIELD cod_erro         AS INTEGER
    FIELD desc_erro        AS CHARACTER.
 
DEFINE TEMP-TABLE tt-ordem-compra-sdcv-aux NO-UNDO LIKE tt-ordem-compra-sdcv.

DEF STREAM s_teste.


DEFINE INPUT  PARAMETER TABLE FOR tt-pedido-compra-sdcv.
DEFINE INPUT  PARAMETER TABLE FOR tt-ordem-compra-sdcv.
DEFINE INPUT  PARAMETER TABLE FOR tt-rateio-ordem-sdcv.
DEFINE OUTPUT PARAMETER TABLE FOR tt-retorno-pedido-sdcv.
DEFINE OUTPUT PARAMETER TABLE FOR tt-retorno-ordem-sdcv.
DEFINE OUTPUT PARAMETER TABLE FOR tt-erro-sdcv.
 
DEFINE VARIABLE c-erro  as char format "x(40)".
DEFINE VARIABLE l-erro as LOGICAL.
 
DEFINE TEMP-TABLE tt-OC NO-UNDO LIKE ordem-compra
    FIELD r-Rowid AS ROWID.
 
DEFINE BUFFER bf-emitente FOR emitente.

{esapi/esapi010tt.i} /****** TEMP-TABLE tt-email *****/
{utp/utapi019.i}
{cdp/cd0666.i}
{esp/es0018.i}

DEFINE TEMP-TABLE tt-erro-aux NO-UNDO LIKE tt-erro.

DEFINE TEMP-TABLE tt-pedido-compr NO-UNDO LIKE pedido-compr
    FIELD r-rowid AS ROWID
    FIELD RowNum AS INTEGER INIT 1
    INDEX iSeq AS PRIMARY RowNum.
 
def temp-table tt-ordem-compra no-undo like ordem-compra
    field l-split           as   logical                    initial no
    field l-gerou           as   logical         
    field r-ordem           as   rowid
    field ind-tipo-movto    as   integer format "99"        initial 1.

def temp-table tt-prazo-compra no-undo like prazo-compra
    field ind-tipo-movto    as   integer format "99"        initial 1.

def temp-table tt-cotacao-item no-undo like cotacao-item
    FIELD r-rowid AS ROWID.
 
DEF TEMP-TABLE rowerrors NO-UNDO    /* Temp-table dos erros */
    FIELD errorsequence    AS INT
    FIELD errornumber      AS INT
    FIELD errordescription AS CHARACTER FORMAT "x(150)"
    FIELD errorparameters  AS CHARACTER 
    FIELD errortype        AS CHARACTER 
    FIELD errorhelp        AS CHARACTER FORMAT "x(150)"
    FIELD errorsubtype     AS CHARACTER.
     
DEF TEMP-TABLE tt-ped NO-UNDO
    FIELD num-pedido       LIKE pedido-compr.num-pedido
    FIELD cod-compra       AS   CHARACTER
    INDEX codigo IS PRIMARY num-pedido cod-compra.
 
DEFINE TEMP-TABLE tt-consiste NO-UNDO
    FIELD chave        AS CHAR 
    FIELD campo-existe AS LOGICAL.

DEFINE VARIABLE i-nr-ordem       like ordem-compra.numero-ordem   NO-UNDO.
DEFINE VARIABLE l-cessao-credito AS   LOGICAL                     NO-UNDO.
DEFINE VARIABLE c-ct-codigo      as   character                   no-undo.
DEFINE VARIABLE c-sc-codigo      as   character                   no-undo.
DEFINE VARIABLE iLockAgain       AS   INTEGER                     NO-UNDO.
DEFINE VARIABLE c-dep-almoxar    LIKE item-uni-estab.deposito-pad NO-UNDO.
DEFINE VARIABLE c-dir            AS   CHARACTER                   NO-UNDO.
DEFINE VARIABLE i-num-pedido     AS   INTEGER                     NO-UNDO.
DEFINE VARIABLE h-boin274        AS   HANDLE                      NO-UNDO.
DEFINE VARIABLE h-boin274vl      AS   HANDLE                      NO-UNDO.
DEFINE VARIABLE h-boin082        AS   HANDLE                      NO-UNDO.
DEFINE VARIABLE h-boin356        AS   HANDLE                      NO-UNDO.
DEFINE VARIABLE h-boin295        AS   HANDLE                      NO-UNDO.
DEFINE VARIABLE h-boin274sd      AS   HANDLE                      NO-UNDO. 
DEFINE VARIABLE v-tot-rat        AS   DECIMAL                     NO-UNDO.
DEFINE VARIABLE de-indice        AS   DECIMAL                     NO-UNDO.

/*
DEFINE VARIABLE h-boin295desc    AS   HANDLE                      NO-UNDO. 
*/

DEFINE VARIABLE c-empresa-pedido AS CHARACTER   NO-UNDO.

EMPTY TEMP-TABLE tt-ped                   NO-ERROR.
EMPTY TEMP-TABLE tt-ordem-compra          NO-ERROR.
EMPTY TEMP-TABLE tt-prazo-compra          NO-ERROR.
EMPTY TEMP-TABLE tt-cotacao-item          NO-ERROR.
EMPTY TEMP-TABLE tt-pedido-compr          NO-ERROR. 
EMPTY TEMP-TABLE tt-retorno-pedido-sdcv   NO-ERROR.
EMPTY TEMP-TABLE tt-retorno-ordem-sdcv    NO-ERROR.
EMPTY TEMP-TABLE tt-erro-sdcv             NO-ERROR.
EMPTY TEMP-TABLE tt-ordem-compra-sdcv-aux NO-ERROR.

{upc/btb910za-upc.i}
{esp/sdcv/essdcv001api.i2}

/*********************************************************************************************************************************************************/
RUN esp/es0018p.p (INPUT "spool-unix":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto NO-ERROR.

OUTPUT STREAM s_teste TO VALUE (tt-prog-ponto.conteudo + "/teste-andre-01.txt") NO-CONVERT APPEND.

    PUT STREAM s_teste UNFORMATTED "andre01: " SKIP
                                   "data: " STRING(TODAY, "99/99/9999") " - " "hora: " STRING(TIME, "HH:MM:SS") SKIP.

    FOR EACH tt-pedido-compra-sdcv:
        PUT STREAM s_teste UNFORMATTED
            'tt-pedido-compra-sdcv.cod-estabel  ' tt-pedido-compra-sdcv.cod-estabel   skip
            'tt-pedido-compra-sdcv.cod-emitente ' tt-pedido-compra-sdcv.cod-emitente  skip
            'tt-pedido-compra-sdcv.cod-comprado ' tt-pedido-compra-sdcv.cod-comprado  skip
            'tt-pedido-compra-sdcv.cod-transp   ' tt-pedido-compra-sdcv.cod-transp    skip
            'tt-pedido-compra-sdcv.frete        ' tt-pedido-compra-sdcv.frete         skip
            'tt-pedido-compra-sdcv.observacao   ' tt-pedido-compra-sdcv.observacao    skip
            'tt-pedido-compra-sdcv.end-entrega  ' tt-pedido-compra-sdcv.end-entrega   skip
            'tt-pedido-compra-sdcv.cod-cond-pag ' tt-pedido-compra-sdcv.cod-cond-pag  skip
            'tt-pedido-compra-sdcv.cod-compra   ' tt-pedido-compra-sdcv.cod-compra    skip
            'tt-pedido-compra-sdcv.mo-codigo    ' tt-pedido-compra-sdcv.mo-codigo     SKIP(1).
    END.
     
    FOR EACH tt-ordem-compra-sdcv:
        PUT STREAM s_teste UNFORMATTED 
            'tt-ordem-compra-sdcv.cod-compra   ' tt-ordem-compra-sdcv.cod-compra         skip
            'tt-ordem-compra-sdcv.numero-ordem ' tt-ordem-compra-sdcv.numero-ordem       skip
            'tt-ordem-compra-sdcv.cod-item     ' tt-ordem-compra-sdcv.cod-item           skip
            'tt-ordem-compra-sdcv.qt-solic     ' tt-ordem-compra-sdcv.qt-solic           skip
            'tt-ordem-compra-sdcv.prazo-entreg ' tt-ordem-compra-sdcv.prazo-entreg       skip
            'tt-ordem-compra-sdcv.preco-unit   ' tt-ordem-compra-sdcv.preco-unit         skip
            'tt-ordem-compra-sdcv.aliquota-icm ' tt-ordem-compra-sdcv.aliquota-icm       skip
            'tt-ordem-compra-sdcv.aliquota-ipi ' tt-ordem-compra-sdcv.aliquota-ipi       skip
            'tt-ordem-compra-sdcv.cod-sdcv     ' tt-ordem-compra-sdcv.cod-sdcv           skip
            'tt-ordem-compra-sdcv.requisitante ' tt-ordem-compra-sdcv.requisitante       skip
            'tt-ordem-compra-sdcv.ct-codigo    ' tt-ordem-compra-sdcv.ct-codigo          skip
            'tt-ordem-compra-sdcv.sc-codigo    ' tt-ordem-compra-sdcv.sc-codigo          skip
            'tt-ordem-compra-sdcv.desc-sdcv    ' tt-ordem-compra-sdcv.desc-sdcv          skip(1).
    END.
    
    FOR EACH tt-rateio-ordem-sdcv :
        PUT STREAM s_teste UNFORMATTED
            'tt-rateio-ordem-sdcv.cod-sdcv  ' tt-rateio-ordem-sdcv.cod-sdcv  skip
            'tt-rateio-ordem-sdcv.ct-codigo ' tt-rateio-ordem-sdcv.ct-codigo skip
            'tt-rateio-ordem-sdcv.sc-codigo ' tt-rateio-ordem-sdcv.sc-codigo skip
            'tt-rateio-ordem-sdcv.perc      ' tt-rateio-ordem-sdcv.perc      skip(1).
    END.

    PUT STREAM s_teste UNFORMATTED "andre02: " SKIP
                                   "data: " STRING(TODAY, "99/99/9999") " - " "hora: " STRING(TIME, "HH:MM:SS") SKIP.
/* OUTPUT CLOSE. */

/*********************************************************************************************************************************************************/
/* run prgint/utb/utb742za.py persistent set h_api_ccusto. */

ASSIGN c-empresa-pedido = v_cod_empres_usuar.

FOR FIRST tt-pedido-compra-sdcv FIELDS(cod-estabel).
    
    FOR FIRST estabelec fields(ep-codigo) NO-LOCK
        WHERE estabelec.cod-estabel = tt-pedido-compra-sdcv.cod-estabel.

        ASSIGN c-empresa-pedido = estabelec.ep-codigo.
    END.
    RELEASE estabelec.
END.
RELEASE tt-pedido-compra-sdcv NO-ERROR.

bloco:
DO  TRANSACTION ON ERROR  UNDO bloco, LEAVE bloco
                ON ENDKEY UNDO bloco, LEAVE bloco:

    run inbo/boin295.p         persistent set h-boin295.
    run inbo/boin274.p         persistent set h-boin274.
    run inbo/boin082.p         persistent set h-boin082.
    run inbo/boin356.p         persistent set h-boin356.
    run inbo/boin274sd.p       persistent set h-boin274sd.

    IF CAN-FIND(FIRST tt-rateio-ordem-sdcv) THEN DO:
        
        EMPTY TEMP-TABLE tt-consiste NO-ERROR.
        
        FOR EACH tt-rateio-ordem-sdcv:
            CREATE tt-consiste.
            ASSIGN tt-consiste.chave = tt-rateio-ordem-sdcv.cod-sdcv + ";" + tt-rateio-ordem-sdcv.ct-codigo + ";" + tt-rateio-ordem-sdcv.sc-codigo.
    
            IF  CAN-FIND(FIRST tt-ordem-compra-sdcv
                         WHERE tt-ordem-compra-sdcv.cod-sdcv  = tt-rateio-ordem-sdcv.cod-sdcv
                         AND   tt-ordem-compra-sdcv.ct-codigo = tt-rateio-ordem-sdcv.ct-codigo
                         AND   tt-ordem-compra-sdcv.sc-codigo = tt-rateio-ordem-sdcv.sc-codigo) THEN 
                 ASSIGN tt-consiste.campo-existe = TRUE.
            ELSE ASSIGN tt-consiste.campo-existe = FALSE.
        END. /* FOR EACH tt-rateio-ordem-sdcv: */
    END.

    FOR EACH tt-consiste:
        /*PUT UNFORMATTED tt-consiste.chave " | " tt-consiste.campo-existe SKIP.*/

        IF  NOT CAN-FIND(FIRST tt-consiste
                         WHERE tt-consiste.campo-existe = TRUE) THEN DO:
            IF  NOT CAN-FIND(FIRST tt-erro-sdcv
                             WHERE tt-erro-sdcv.cod_erro = 230877) THEN DO:
                CREATE tt-erro-sdcv.
                ASSIGN tt-erro-sdcv.cod_erro  = 230877
                       tt-erro-sdcv.desc_erro = "Conta(" + trim(STRING(ENTRY(2, tt-consiste.chave, ";"))) + 
                                                "), Centro Custo(" + trim(STRING(substring(ENTRY(3, tt-consiste.chave, ";"),4,5))) + 
                                                ") ou Unidade Neg¢cio(" + trim(STRING(substring(ENTRY(3, tt-consiste.chave, ";"),1,3))) + 
                                                ") da Matriz de Rateio diferem da Ordem Compra. SDCV nro:":U + 
                                                STRING(ENTRY(1, tt-consiste.chave, ";")).
                ASSIGN l-erro = TRUE.
            END.
        END. /* IF  NOT CAN-FIND(FIRST tt-consiste */
    END. /* FOR EACH tt-consiste: */

    PUT STREAM s_teste UNFORMATTED "andre03: " SKIP
                                   "data: " STRING(TODAY, "99/99/9999") " - " "hora: " STRING(TIME, "HH:MM:SS") SKIP.
    
    IF  l-erro THEN do:
        run pi-destroi-handle.
        UNDO bloco, LEAVE bloco.
    end.    

    /*********************************************************************************************************************************************************/

    IF  CAN-FIND(FIRST tt-rateio-ordem-sdcv) THEN
    FOR EACH tt-rateio-ordem-sdcv:
        
        EMPTY TEMP-TABLE tt_log_erro.        

        IF NOT VALID-HANDLE(h_api_ccusto) THEN 
            RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

        RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  c-empresa-pedido,                               /* EMPRESA EMS 2        */
                                                           INPUT  SUBSTRING(tt-rateio-ordem-sdcv.sc-codigo,10,3), /* ESTABELECIMENTO EMS2 */
                                                           INPUT  p_cod_plano_cta_ctbl,                           /* PLANO CONTAS         */
                                                           INPUT  tt-rateio-ordem-sdcv.ct-codigo,                 /* CONTA                */
                                                           INPUT  TODAY,                                          /* DT TRANSACAO         */
                                                           OUTPUT p_log_ccusto,                                   /* UTILIZA CCUSTO ?     */
                                                           OUTPUT TABLE tt_log_erro).                             /* ERROS                */
        
        IF p_log_ccusto = NO THEN 
           ASSIGN overlay(tt-rateio-ordem-sdcv.sc-codigo,4,5) = "".

        IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN 
            RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

        RUN pi_valida_conta_contabil IN h_api_cta_ctbl (INPUT  c-empresa-pedido,                                /** Codigo da Empresa do EMS2.                   **/
                                                        INPUT  substring(tt-rateio-ordem-sdcv.sc-codigo,10,3) , /** Codigo do Estabelecimento do EMS2.           **/
                                                        INPUT  substring(tt-rateio-ordem-sdcv.sc-codigo,1,3)  , /** UNIDADE NEGÖCIO                              **/
                                                        INPUT  p_cod_plano_cta_ctbl                           , /** Codigo do Plano de Contas                    **/ 
                                                        INPUT  tt-rateio-ordem-sdcv.ct-codigo                 , /** CONTA                                        **/
                                                        INPUT  p_cod_plano_ccusto                             , /** Codigo do Plano de Centro de Custo           **/
                                                        INPUT  substring(tt-rateio-ordem-sdcv.sc-codigo,4,5)  , /** CCUSTO                                       **/
                                                        INPUT  TODAY                                          , /** Data da Transacao                            **/
                                                        OUTPUT TABLE tt_log_erro).                              /** Erros ocorridos durante a execucao do metodo **/
            

        FOR EACH tt_log_erro NO-LOCK:
            CREATE tt-erro-sdcv.
            ASSIGN tt-erro-sdcv.cod_erro  = tt_log_erro.ttv_num_cod_erro
                   tt-erro-sdcv.desc_erro = tt_log_erro.ttv_des_msg_erro.

            ASSIGN l-erro = TRUE.
        END. 

        /*---[ respeitando a nova tabela criada ]-----------------------------*/
/*         IF CAN-FIND(FIRST ext_plano_conta                                                     */
/*                     WHERE ext_plano_conta.cod_cta_ctbl = tt-rateio-ordem-sdcv.ct-codigo) THEN */
/*             ASSIGN overlay(tt-rateio-ordem-sdcv.sc-codigo, 4, 5) = "":U.                      */
    END.

    PUT STREAM s_teste UNFORMATTED "andre04: " SKIP
                                   "data: " STRING(TODAY, "99/99/9999") " - " "hora: " STRING(TIME, "HH:MM:SS") SKIP.

    IF l-erro THEN do:
        run pi-destroi-handle.
        UNDO bloco, LEAVE bloco.
    end.

    /*********************************************************************************************************************************************************/

    IF CAN-FIND(FIRST tt-pedido-compra-sdcv) THEN DO:

        EMPTY TEMP-TABLE tt-ped.
        /*Pedido gravado na base*/
        /* 
        RUN grava-pedido.
        IF RETURN-VALUE NE "OK" THEN do:
            run pi-destroi-handle.
            UNDO bloco, LEAVE bloco.
        end.
        */

        FOR EACH  tt-ordem-compra-sdcv,
            FIRST tt-pedido-compra-sdcv
            WHERE tt-pedido-compra-sdcv.cod-compra = tt-ordem-compra-sdcv.cod-compra /* ,
            FIRST tt-ped
            WHERE tt-ped.cod-compra = tt-pedido-compra-sdcv.cod-compra */ :

            /*PUT UNFORMATTED 
                'tt-pedido-compra-sdcv.cod-compra ' tt-pedido-compra-sdcv.cod-compra  SKIP
                'tt-ordem-compra-sdcv.cod-compra  ' tt-ordem-compra-sdcv.cod-compra   SKIP
                'tt-ordem-compra-sdcv.cod-sdcv    ' tt-ordem-compra-sdcv.cod-sdcv     SKIP(1).*/
            
            /* Ignorando o c¢digo do item enviado para ser sempre branco (DD) */
            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = tt-ordem-compra-sdcv.cod-item NO-ERROR.
            IF NOT AVAIL ITEM THEN
               assign tt-ordem-compra-sdcv.cod-item = "".

            ASSIGN c-erro = "0"
                   l-erro = NO.
        
            /*---[ respeitando a nova tabela criada ]-----------------------------*/
/*             IF CAN-FIND(FIRST ext_plano_conta                                                     */
/*                         WHERE ext_plano_conta.cod_cta_ctbl = tt-ordem-compra-sdcv.ct-codigo) THEN */
/*                 ASSIGN overlay(tt-ordem-compra-sdcv.sc-codigo, 4, 5) = "":U.                      */
    
            IF tt-ordem-compra-sdcv.ct-codigo = "11910015" AND tt-ordem-compra-sdcv.cod-item = "" THEN 
                ASSIGN tt-ordem-compra-sdcv.cod-item  = "INVESTI":U.

            
            FIND FIRST emitente NO-LOCK 
                WHERE emitente.cod-emitente = tt-pedido-compra-sdcv.cod-emitente NO-ERROR  .
            IF NOT AVAIL emitente THEN DO:
                CREATE tt-erro-sdcv.
                ASSIGN tt-erro-sdcv.cod_erro  = 1
                       tt-erro-sdcv.desc_erro = "Fornecedor " + STRING(tt-pedido-compra-sdcv.cod-emitente) + " n∆o cadastrado. SDCV: " + STRING(tt-ordem-compra-sdcv.cod-sdcv).
    
                ASSIGN l-erro = TRUE.
            END. 
        
            IF l-erro THEN DO:
                /*FOR EACH tt-erro-sdcv:
                    PUT UNFORMATTED 
                            "tt-erro-sdcv.cod_erro : " tt-erro-sdcv.cod_erro  SKIP
                            "tt-erro-sdcv.desc_erro: " tt-erro-sdcv.desc_erro SKIP.
                END.*/
                run pi-destroi-handle.
                UNDO bloco, LEAVE bloco.
            END.
    
            ASSIGN l-cessao-credito = NO.
            FIND FIRST int-cond-pagto NO-LOCK 
                 WHERE int-cond-pagto.cod-cond-pag = emitente.cod-cond-pag NO-ERROR.
            IF AVAIL int-cond-pagto THEN DO:
                ASSIGN l-cessao-credito = IF SUBSTRING(int-cond-pagto.char-1,3,1) = "S" THEN YES ELSE NO.
            END.
            
            IF emitente.natureza = 3 AND emitente.cgc = ? THEN DO:
                CREATE tt-erro-sdcv.
                ASSIGN tt-erro-sdcv.cod_erro  = 6
                       tt-erro-sdcv.desc_erro = "Fornecedor " + STRING(emitente.cod-emitente) + " sem CGC informado. SDCV: " + STRING(tt-ordem-compra-sdcv.cod-sdcv).
    
                ASSIGN l-erro = TRUE.
            END.
        
            IF l-erro THEN DO:
                /*FOR EACH tt-erro-sdcv:
                    PUT UNFORMATTED 
                            "tt-erro-sdcv.cod_erro : " tt-erro-sdcv.cod_erro  SKIP
                            "tt-erro-sdcv.desc_erro: " tt-erro-sdcv.desc_erro SKIP.
                END.*/
                run pi-destroi-handle.
                UNDO bloco, LEAVE bloco.
            END.
    
            /*-- conta ---*/
            EMPTY TEMP-TABLE tt_log_erro.
            IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN 
                RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
            RUN pi_valida_conta_contabil IN h_api_cta_ctbl (INPUT  c-empresa-pedido                               , /** Codigo da Empresa do EMS2.                   **/
                                                            INPUT  substring(tt-ordem-compra-sdcv.sc-codigo,10,3) , /** Codigo do Estabelecimento do EMS2.           **/
                                                            INPUT  substring(tt-ordem-compra-sdcv.sc-codigo,1,3)  , /** Codigo da Unidade de Negocio                 **/
                                                            INPUT  p_cod_plano_cta_ctbl                           , /** Codigo do Plano de Contas                    **/ 
                                                            INPUT  tt-ordem-compra-sdcv.ct-codigo                 , /** Codigo da Conta                              **/
                                                            INPUT  p_cod_plano_ccusto                             , /** Codigo do Plano de Centro de Custo           **/
                                                            INPUT  substring(tt-ordem-compra-sdcv.sc-codigo,4,5)  , /** Codigo do Centro de Custo                    **/
                                                            INPUT  TODAY                                          , /** Data da Transacao                            **/
                                                            OUTPUT TABLE tt_log_erro).                              /** Erros ocorridos durante a execucao do metodo **/
    
            FOR EACH tt_log_erro NO-LOCK:
                CREATE tt-erro-sdcv.
                ASSIGN tt-erro-sdcv.cod_erro  = tt_log_erro.ttv_num_cod_erro
                       tt-erro-sdcv.desc_erro = tt_log_erro.ttv_des_msg_erro.   
                ASSIGN l-erro = TRUE.
            END.
        
            IF  NOT CAN-FIND(FIRST tt_log_erro) THEN DO:
                IF NOT VALID-HANDLE(h_api_ccusto) THEN 
                    RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

                RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  c-empresa-pedido,                               /* EMPRESA EMS 2        */
                                                                   INPUT  SUBSTRING(tt-ordem-compra-sdcv.sc-codigo,10,3), /* ESTABELECIMENTO EMS2 */
                                                                   INPUT  p_cod_plano_cta_ctbl,                           /* PLANO CONTAS         */
                                                                   INPUT  tt-ordem-compra-sdcv.ct-codigo,                 /* CONTA                */
                                                                   INPUT  TODAY,                                          /* DT TRANSACAO         */
                                                                   OUTPUT p_log_ccusto,                                   /* UTILIZA CCUSTO ?     */
                                                                   OUTPUT TABLE tt_log_erro).                             /* ERROS                */
        
                IF p_log_ccusto THEN DO:
                    IF SUBSTRING(tt-ordem-compra-sdcv.sc-codigo,4,5) = "" THEN DO:
                        CREATE tt-erro-sdcv.
                        ASSIGN tt-erro-sdcv.cod_erro  = 0
                               tt-erro-sdcv.desc_erro = "ê necess†rio informar o centro de custo.".       
                        ASSIGN l-erro = TRUE.
                    END.
                END.
            END.
        
            /* conta */
            /*---[ respeitando a nova tabela criada ]-----------------------------*/
/*             IF CAN-FIND(FIRST ext_plano_conta WHERE ext_plano_conta.cod_cta_ctbl = tt-ordem-compra-sdcv.ct-codigo) THEN */
/*                 ASSIGN c-ct-codigo = tt-ordem-compra-sdcv.ct-codigo                                                     */
/*                        c-sc-codigo = "":U.                                                                              */
/*             ELSE                                                                                                        */
                ASSIGN c-ct-codigo = tt-ordem-compra-sdcv.ct-codigo
                       c-sc-codigo = substring(tt-ordem-compra-sdcv.sc-codigo,4,5).  

            IF p_log_ccusto = NO THEN
               ASSIGN c-sc-codigo = "".
        
            IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN 
                RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
            RUN pi_valida_conta_contabil IN h_api_cta_ctbl (INPUT  c-empresa-pedido                               , /* EMPRESA EMS2         */
                                                            INPUT  substring(tt-ordem-compra-sdcv.sc-codigo,10,3) , /* ESTABELECIMENTO EMS2 */
                                                            INPUT  substring(tt-ordem-compra-sdcv.sc-codigo,1,3)  , /* UNIDADE NEGπCIO      */
                                                            INPUT  p_cod_plano_cta_ctbl                           , /* PLANO CONTAS         */ 
                                                            INPUT  tt-ordem-compra-sdcv.ct-codigo                 , /* CONTA                */
                                                            INPUT  p_cod_plano_ccusto                             , /* PLANO CCUSTO         */ 
                                                            INPUT  c-sc-codigo                                    , /* CCUSTO               */
                                                            INPUT  TODAY                                          , /* DATA TRANSACAO       */
                                                            OUTPUT TABLE tt_log_erro).                              /* ERROS */
    
            FOR EACH tt_log_erro NO-LOCK:
                CREATE tt-erro-sdcv.
                ASSIGN tt-erro-sdcv.cod_erro  = tt_log_erro.ttv_num_cod_erro
                       tt-erro-sdcv.desc_erro = tt_log_erro.ttv_des_msg_erro.     
                ASSIGN l-erro = TRUE.      
            END.
            
            IF l-erro THEN DO:
                /*FOR EACH tt-erro-sdcv:
                    PUT UNFORMATTED 
                            "tt-erro-sdcv.cod_erro : " tt-erro-sdcv.cod_erro  SKIP
                            "tt-erro-sdcv.desc_erro: " tt-erro-sdcv.desc_erro SKIP.
                END.*/
                run pi-destroi-handle.
                UNDO bloco, LEAVE bloco.
            END. 

            FIND FIRST moeda NO-LOCK  
                 WHERE moeda.mo-codigo = tt-pedido-compra-sdcv.mo-codigo NO-ERROR.

            IF NOT AVAIL moeda THEN DO:
                CREATE tt-erro-sdcv.
                ASSIGN tt-erro-sdcv.cod_erro  = 23
                       tt-erro-sdcv.desc_erro = "Moeda " + STRING(tt-pedido-compra-sdcv.mo-codigo) + " n∆o cadastrada. SDCV: "  + STRING(tt-ordem-compra-sdcv.cod-sdcv) .    
                ASSIGN l-erro = TRUE.
            END.
        
            FIND FIRST comprador NO-LOCK
                 WHERE comprador.cod-comprado = tt-pedido-compra-sdcv.cod-comprado NO-ERROR.
            IF NOT AVAIL comprador THEN DO:
                CREATE tt-erro-sdcv.
                ASSIGN tt-erro-sdcv.cod_erro  = 3
                       tt-erro-sdcv.desc_erro = "Comprador " + STRING(tt-pedido-compra-sdcv.cod-comprado) + " n∆o cadastrado. SDCV: "  + STRING(tt-ordem-compra-sdcv.cod-sdcv) .  
                ASSIGN l-erro = TRUE.
            END.
        
            FIND FIRST cond-pagto NO-LOCK 
                 WHERE cond-pagto.cod-cond-pag = INT(tt-pedido-compra-sdcv.cod-cond-pag) NO-ERROR.
            IF NOT AVAIL cond-pagto THEN DO:
                CREATE tt-erro-sdcv.
                ASSIGN tt-erro-sdcv.cod_erro  = 4
                       tt-erro-sdcv.desc_erro = "Condicao de pagamento " + STRING(tt-pedido-compra-sdcv.cod-cond-pag) + " n∆o cadastrada. SDCV: "  + STRING(tt-ordem-compra-sdcv.cod-sdcv).   
                ASSIGN l-erro = TRUE.
            END.
        
            IF DEC(tt-ordem-compra-sdcv.preco-unit) <= 0 THEN DO:
                CREATE tt-erro-sdcv.
                ASSIGN tt-erro-sdcv.cod_erro  = 8
                       tt-erro-sdcv.desc_erro = "Preáo zero.  SDCV: "  + STRING(tt-ordem-compra-sdcv.cod-sdcv). 
                ASSIGN l-erro = TRUE.
            END.
        
            IF l-erro THEN DO:
                /*
                FOR EACH tt-erro-sdcv:
                    PUT UNFORMATTED 
                            "tt-erro-sdcv.cod_erro : " tt-erro-sdcv.cod_erro  SKIP
                            "tt-erro-sdcv.desc_erro: " tt-erro-sdcv.desc_erro SKIP.
                END.*/
                run pi-destroi-handle.
                UNDO bloco, LEAVE bloco.
            END.
    
            ASSIGN i-nr-ordem = 0.

            /*---[ Verificaá∆o se existe uma ordem j† criada com essa nro de SDCV ]------------------------------------------------------*/
            IF tt-ordem-compra-sdcv.numero-ordem = 0 THEN DO:
                
                FIND FIRST ordem-compra NO-LOCK
                    WHERE  ordem-compra.narrativa BEGINS "SDCV: ":U + tt-ordem-compra-sdcv.cod-sdcv + " " NO-ERROR.
                
                IF  AVAIL  ordem-compra THEN DO:

                    ASSIGN l-erro          = TRUE.
    
                    CREATE tt-retorno-ordem-sdcv.
                    ASSIGN tt-retorno-ordem-sdcv.cod_sdcv     = TRIM(ENTRY(2, ordem-compra.narrativa, ":"))
                           tt-retorno-ordem-sdcv.numero_ordem = ordem-compra.numero-ordem.

                    PUT STREAM s_teste UNFORMATTED "andre05: numero_ordem: " ordem-compra.numero-ordem " - cod_sdcv: "  STRING(tt-ordem-compra-sdcv.cod-sdcv) SKIP.
    
                    /*PUT UNFORMATTED 
                        "trecho da verificaá∆o de j† existir Pedido e Ordem de Compra" SKIP
                        "Informaá∆o gerada Ös "  string(time, "HH:MM:SS":U) ", do dia " string(today, "99/99/9999":U) skip
                        "cod_sdcv    : " tt-retorno-ordem-sdcv.cod_sdcv     SKIP
                        "numero_ordem: " tt-retorno-ordem-sdcv.numero_ordem SKIP(1).*/

                    FOR FIRST pedido-compr OF ordem-compra NO-LOCK:
                        CREATE tt-retorno-pedido-sdcv.
                        ASSIGN tt-retorno-pedido-sdcv.cod_compra       = TRIM(ENTRY(2, pedido-compr.c-observacao[1], ":"))
                               tt-retorno-pedido-sdcv.num_pedido_compr = pedido-compr.num-pedido
                               tt-retorno-pedido-sdcv.num_mensagem     = string(pedido-compr.cod-mensagem).

                        PUT STREAM s_teste UNFORMATTED "andre06: cod_compra: " TRIM(ENTRY(2, pedido-compr.c-observacao[1], ":")) " - num_pedido_compr: "  pedido-compr.num-pedido " - num_mensagem: " string(pedido-compr.cod-mensagem) SKIP.

                        IF tt-retorno-pedido-sdcv.cod_compra <> tt-ordem-compra-sdcv.cod-compra THEN DO:
                            CREATE tt-erro-sdcv.
                            ASSIGN tt-erro-sdcv.cod_erro  = 17006
                                   tt-erro-sdcv.desc_erro = "Pedido e Ordem de Compra j† existe com SDCV: "  + STRING(tt-ordem-compra-sdcv.cod-sdcv).
                        END.
                    
    
                        /*PUT UNFORMATTED
                            "Informaá∆o gerada Ös "  string(time, "HH:MM:SS":U) ", do dia " string(today, "99/99/9999":U) skip
                            "cod_compra      : " tt-retorno-pedido-sdcv.cod_compra       SKIP
                            "num_pedido_compr: " tt-retorno-pedido-sdcv.num_pedido_compr SKIP
                            "num_mensagem    : " tt-retorno-pedido-sdcv.num_mensagem     SKIP 
                            "------------------------------------------------------------" SKIP(1).*/
                    END. /* if  avail  pedido-compr then DO: */
                    

                    IF l-erro THEN DO:
                        /*
                        FOR EACH tt-erro-sdcv:
                            PUT UNFORMATTED 
                                    "tt-erro-sdcv.cod_erro : " tt-erro-sdcv.cod_erro  SKIP
                                    "tt-erro-sdcv.desc_erro: " tt-erro-sdcv.desc_erro SKIP.
                        END.*/

                        
                        RUN pi-destroi-handle.
                        UNDO bloco, LEAVE bloco. 
                    END.
           
                END. /* IF  AVAIL  ordem-compra THEN DO: */
                
            END. /* if  tt-ordem-compra-sdcv.numero-ordem =  0 then do: */
            /*-------------------------------[ Verificaá∆o se existe uma ordem j† criada com essa nro de SDCV ]--------------------------*/

            IF tt-ordem-compra-sdcv.cod-item <> "" AND tt-ordem-compra-sdcv.cod-item <> "INVESTI" THEN DO:
               ASSIGN tt-ordem-compra-sdcv.ct-codigo = ""
                      overlay(tt-ordem-compra-sdcv.sc-codigo,4,5) = "".
               FOR EACH tt-rateio-ordem-sdcv:
/*                    DELETE tt-rateio-ordem-sdcv. */
                   ASSIGN tt-rateio-ordem-sdcv.ct-codigo = ""
                          overlay(tt-rateio-ordem-sdcv.sc-codigo,4,5) = "".
               END.
            END.
            

             CREATE tt-ordem-compra-sdcv-aux.
             BUFFER-COPY tt-ordem-compra-sdcv TO tt-ordem-compra-sdcv-aux.

            /*Ordem de compra gravada na base*/
            /* 
            RUN pi-grava-ordem.
            IF RETURN-VALUE NE "OK" THEN DO:
                IF l-erro THEN DO:
                    FOR EACH tt-erro-sdcv:
                        PUT UNFORMATTED 
                                "tt-erro-sdcv.cod_erro : " tt-erro-sdcv.cod_erro  SKIP
                                "tt-erro-sdcv.desc_erro: " tt-erro-sdcv.desc_erro SKIP.
                    END.
                    run pi-destroi-handle.
                    UNDO bloco, LEAVE bloco.
                END.
            END.                
            */
        
        END. /* FOR EACH tt-ordem-compra-sdcv: */

        PUT STREAM s_teste UNFORMATTED "andre07: " SKIP
                                   "data: " STRING(TODAY, "99/99/9999") " - " "hora: " STRING(TIME, "HH:MM:SS") SKIP.

        RUN grava-pedido.

        PUT STREAM s_teste UNFORMATTED "andre10: " SKIP
                                   "data: " STRING(TODAY, "99/99/9999") " - " "hora: " STRING(TIME, "HH:MM:SS") SKIP.
        
        IF RETURN-VALUE NE "OK" THEN do:
            run pi-destroi-handle.
            UNDO bloco, LEAVE bloco.
        end.
        FOR EACH tt-ordem-compra-sdcv-aux,
            FIRST tt-pedido-compra-sdcv
                WHERE tt-pedido-compra-sdcv.cod-compra = tt-ordem-compra-sdcv-aux.cod-compra,
            FIRST tt-ped
                WHERE tt-ped.cod-compra = tt-pedido-compra-sdcv.cod-compra:
            
            RUN pi-grava-ordem-aux.
            IF RETURN-VALUE NE "OK" THEN DO:
                IF l-erro THEN DO:
                    /*FOR EACH tt-erro-sdcv:
                        PUT UNFORMATTED 
                                "tt-erro-sdcv.cod_erro : " tt-erro-sdcv.cod_erro  SKIP
                                "tt-erro-sdcv.desc_erro: " tt-erro-sdcv.desc_erro SKIP.
                    END.*/
                    run pi-destroi-handle.
                    UNDO bloco, LEAVE bloco.
                END.
            END.
        END.

        PUT STREAM s_teste UNFORMATTED "andre20: " SKIP
                                   "data: " STRING(TODAY, "99/99/9999") " - " "hora: " STRING(TIME, "HH:MM:SS") SKIP.

    END. /* CAN-FIND(FIRST tt-pedido-compra-sdcv) */


    run pi-destroi-handle.
END. /* Bloco */

/* OUTPUT CLOSE. */

OUTPUT STREAM s_teste CLOSE.

procedure pi-destroi-handle:

    if valid-handle(h_api_cta_ctbl) then 
        delete object h_api_cta_ctbl.
    
    if valid-handle(h_api_ccusto)   then
        delete object h_api_ccusto.
    
    if  valid-handle(h-boin274) then do:
        DELETE procedure h-boin274.
        assign h-boin274 = ?.
    END. /* if  valid-handle(h-boin274) */
    
    if  valid-handle(h-boin274vl) then do:
        DELETE procedure h-boin274vl.
        assign h-boin274vl = ?.
    END. /* if  valid-handle(h-boin274vl) */
    
    if  valid-handle(h-boin082) then do:
        DELETE procedure h-boin082.
        assign h-boin082 = ?.
    END. /* if  valid-handle(h-boin082) */
    
    if  valid-handle(h-boin356) then do:
        DELETE procedure h-boin356.
        assign h-boin356 = ?.
    END. /* if  valid-handle(h-boin356) */
    
    if  valid-handle(h-boin295) then do:
        DELETE procedure h-boin295.
        ASSIGN h-boin295 = ?.
    END. /* if  valid-handle(h-boin295) */
    
    if  valid-handle(h-boin274sd) then do:
        DELETE procedure h-boin274sd.
        ASSIGN h-boin274sd = ?.
    END. /* if  valid-handle(h-boin274sd) */
    
    /*
    if  valid-handle(h-boin295desc) then do:
        DELETE procedure h-boin295desc.
        ASSIGN h-boin295desc = ?.
    END. /* if  valid-handle(h-boin295desc) */
    */
end procedure.

/*---[ PROCEDURES ]-----------------------------------------------------------------------------------------------------------------*/

PROCEDURE grava-pedido:

    DEFINE VARIABLE l-erro AS LOGICAL NO-UNDO.

    EMPTY TEMP-TABLE tt-pedido-compr.
    
    FOR EACH tt-pedido-compra-sdcv :

        CREATE tt-pedido-compr.
        ASSIGN tt-pedido-compr.cod-estabel     = tt-pedido-compra-sdcv.cod-estabel
               tt-pedido-compr.natureza        = 1 
               tt-pedido-compr.data-pedido     = TODAY
               tt-pedido-compr.situacao        = 1 
               tt-pedido-compr.cod-emitente    = INT(tt-pedido-compra-sdcv.cod-emitente) 
               tt-pedido-compr.end-entrega     = tt-pedido-compra-sdcv.end-entrega 
               tt-pedido-compr.end-cobranca    = tt-pedido-compra-sdcv.cod-estabel
               tt-pedido-compr.frete           = 2 /* a pagar */
               tt-pedido-compr.cod-transp      = tt-pedido-compra-sdcv.cod-transp
               tt-pedido-compr.via-transp      = 1
               tt-pedido-compr.cod-cond-pag    = IF l-cessao-credito THEN emitente.cod-cond-pag ELSE int(tt-pedido-compra-sdcv.cod-cond-pag)
               tt-pedido-compr.responsavel     = tt-pedido-compra-sdcv.cod-comprado
               tt-pedido-compr.impr-pedido     = YES 
               tt-pedido-compr.c-observacao[1] = "Compra SDCV: " + trim(string(tt-pedido-compra-sdcv.cod-compra))
               tt-pedido-compr.emergencial     = YES.
    
         FIND FIRST bf-emitente NO-LOCK
             WHERE  bf-emitente.cod-emitente = tt-pedido-compr.cod-emitente NO-ERROR.
         IF AVAIL  bf-emitente THEN DO:
             IF  bf-emitente.natureza = 3 /* Estrangeiro */ THEN DO:
                 IF  tt-pedido-compr.end-entrega = "105":U /* Manaus */
                 THEN ASSIGN tt-pedido-compr.cod-mensagem = 998.
                 ELSE ASSIGN tt-pedido-compr.cod-mensagem = 45.
             END.
             ELSE ASSIGN tt-pedido-compr.cod-mensagem = 110.          
         END. 

         log-manager:write-message("tt-pedido-compr.cod-estabel     "  + STRING(tt-pedido-compr.cod-estabel    )).
         log-manager:write-message("tt-pedido-compr.natureza        "  + STRING(tt-pedido-compr.natureza       )).
         log-manager:write-message("tt-pedido-compr.data-pedido     "  + STRING(tt-pedido-compr.data-pedido    )).
         log-manager:write-message("tt-pedido-compr.situacao        "  + STRING(tt-pedido-compr.situacao       )).
         log-manager:write-message("tt-pedido-compr.cod-emitente    "  + STRING(tt-pedido-compr.cod-emitente   )).
         log-manager:write-message("tt-pedido-compr.end-entrega     "  + STRING(tt-pedido-compr.end-entrega    )).
         log-manager:write-message("tt-pedido-compr.end-cobranca    "  + STRING(tt-pedido-compr.end-cobranca   )).
         log-manager:write-message("tt-pedido-compr.frete           "  + STRING(tt-pedido-compr.frete          )).
         log-manager:write-message("tt-pedido-compr.cod-transp      "  + STRING(tt-pedido-compr.cod-transp     )).
         log-manager:write-message("tt-pedido-compr.via-transp      "  + STRING(tt-pedido-compr.via-transp     )).
         log-manager:write-message("tt-pedido-compr.cod-cond-pag    "  + STRING(tt-pedido-compr.cod-cond-pag   )).
         log-manager:write-message("tt-pedido-compr.responsavel     "  + STRING(tt-pedido-compr.responsavel    )).
         log-manager:write-message("tt-pedido-compr.cod-mensagem    "  + STRING(tt-pedido-compr.cod-mensagem   )).
         log-manager:write-message("tt-pedido-compr.impr-pedido     "  + STRING(tt-pedido-compr.impr-pedido    )).
         log-manager:write-message("tt-pedido-compr.c-observacao[1] "  + STRING(tt-pedido-compr.c-observacao[1])).
                   
         /*PUT UNFORMATTED
             'tt-pedido-compr.cod-estabel     ' tt-pedido-compr.cod-estabel     skip
             'tt-pedido-compr.natureza        ' tt-pedido-compr.natureza        skip
             'tt-pedido-compr.data-pedido     ' tt-pedido-compr.data-pedido     skip
             'tt-pedido-compr.situacao        ' tt-pedido-compr.situacao        skip
             'tt-pedido-compr.cod-emitente    ' tt-pedido-compr.cod-emitente    skip
             'tt-pedido-compr.end-entrega     ' tt-pedido-compr.end-entrega     skip
             'tt-pedido-compr.end-cobranca    ' tt-pedido-compr.end-cobranca    skip
             'tt-pedido-compr.frete           ' tt-pedido-compr.frete           skip
             'tt-pedido-compr.cod-transp      ' tt-pedido-compr.cod-transp      skip
             'tt-pedido-compr.via-transp      ' tt-pedido-compr.via-transp      skip
             'tt-pedido-compr.cod-cond-pag    ' tt-pedido-compr.cod-cond-pag    skip
             'tt-pedido-compr.responsavel     ' tt-pedido-compr.responsavel     skip
             'tt-pedido-compr.cod-mensagem    ' tt-pedido-compr.cod-mensagem    skip
             'tt-pedido-compr.impr-pedido     ' tt-pedido-compr.impr-pedido     skip
             'tt-pedido-compr.c-observacao[1] ' tt-pedido-compr.c-observacao[1] SKIP(1).*/
         
         EMPTY TEMP-TABLE RowErrors.
         /*
         IF NOT VALID-HANDLE(h-boin295desc) THEN
             RUN inbo/boin295desc.p PERSISTENT SET h-boin295desc.
         */
         IF NOT VALID-HANDLE(h-boin295) THEN
             RUN inbo/boin295.p PERSISTENT SET h-boin295.

         /*
         RUN openQueryStatic IN h-boin295desc ( INPUT "Main":U ).
         */


         RUN openQueryStatic IN h-boin295     ( INPUT "Main":U ).
    
         ASSIGN l-erro = FALSE.
    
         RUN geraNumeroPedidoCompra IN h-boin295 (OUTPUT i-num-pedido).
         ASSIGN tt-pedido-compr.num-pedido = i-num-pedido.
    
         RUN setRecord      IN h-boin295 (INPUT TABLE tt-pedido-compr).
         RUN emptyRowErrors IN h-boin295.
         RUN createRecord   IN h-boin295.
         RUN getRowErrors IN h-boin295(OUTPUT TABLE RowErrors).

         PUT STREAM s_teste UNFORMATTED "andre07: " SKIP
                                   "data: " STRING(TODAY, "99/99/9999") " - " "hora: " STRING(TIME, "HH:MM:SS") SKIP.
    
         IF CAN-FIND(FIRST RowErrors) THEN DO:
            
             ASSIGN l-erro = TRUE.
            
             /*PUT UNFORMATTED 
                 "Informaá∆o gerada Ös "  string(time, "HH:MM:SS":U) ", do dia " string(today, "99/99/9999":U) skip.*/
    
             FOR EACH RowErrors:
                 CREATE tt-erro-sdcv.
                 ASSIGN tt-erro-sdcv.cod_erro  = RowErrors.ErrorNumber
                        tt-erro-sdcv.desc_erro = RowErrors.ErrorDescription .
                 /*PUT UNFORMATTED 
                     "tt-erro-sdcv.cod_erro : " tt-erro-sdcv.cod_erro  SKIP
                     "tt-erro-sdcv.desc_erro: " tt-erro-sdcv.desc_erro SKIP.*/
             END. 
         END. 
         ELSE DO:
    
             RUN getrecord IN h-boin295(OUTPUT TABLE tt-pedido-compr).   
             FIND FIRST tt-pedido-compr NO-ERROR.
             FIND FIRST pedido-compr EXCLUSIVE-LOCK  
                 WHERE pedido-compr.num-pedido = tt-pedido-compr.num-pedido NO-ERROR.

             PUT STREAM s_teste UNFORMATTED "andre08: " SKIP
                                   "data: " STRING(TODAY, "99/99/9999") " - " "hora: " STRING(TIME, "HH:MM:SS") SKIP.
            
             IF AVAIL pedido-compr THEN DO:
    
                /* Seta como impresso, visto que j† foi enviado email ao fornecedor, pelo OutbuyCenter */
                ASSIGN pedido-compr.impr-pedido = FALSE
                       pedido-compr.situacao    = 1. /* Impresso */
    
                CREATE tt-retorno-pedido-sdcv.
                ASSIGN tt-retorno-pedido-sdcv.cod_compra       = TRIM(ENTRY(2, pedido-compr.c-observacao[1], ":"))
                       tt-retorno-pedido-sdcv.num_pedido_compr = pedido-compr.num-pedido
                       tt-retorno-pedido-sdcv.num_mensagem     = string(pedido-compr.cod-mensagem).
    
                PUT STREAM s_teste UNFORMATTED 
                    "Informaá∆o gerada Ös "  string(time, "HH:MM:SS":U) ", do dia " string(today, "99/99/9999":U) skip
                    "tt-retorno-pedido-sdcv.cod_compra       " tt-retorno-pedido-sdcv.cod_compra       SKIP
                    "tt-retorno-pedido-sdcv.num_pedido_compr " tt-retorno-pedido-sdcv.num_pedido_compr SKIP
                    "tt-retorno-pedido-sdcv.num_mensagem     " tt-retorno-pedido-sdcv.num_mensagem     SKIP.

                PUT STREAM s_teste UNFORMATTED 
                    "NOVO PEDIDO GERADO: " i-num-pedido " Cod-compra: " tt-pedido-compra-sdcv.cod-compra SKIP.

                log-manager:write-message("tt-retorno-pedido-sdcv.cod_compra       " + STRING(tt-retorno-pedido-sdcv.cod_compra      )).
                log-manager:write-message("tt-retorno-pedido-sdcv.num_pedido_compr " + STRING(tt-retorno-pedido-sdcv.num_pedido_compr)).
                log-manager:write-message("tt-retorno-pedido-sdcv.num_mensagem     " + STRING(tt-retorno-pedido-sdcv.num_mensagem    )).
                log-manager:write-message("NOVO PEDIDO GERADO: " + STRING(i-num-pedido) + " Cod-compra: " + STRING(tt-pedido-compra-sdcv.cod-compra)).
        
                CREATE tt-ped.
                ASSIGN tt-ped.num-pedido  = i-num-pedido
                       tt-ped.cod-compra  = tt-pedido-compra-sdcv.cod-compra.
             END.            
         END.
    END.

    IF l-erro THEN
       RETURN "NOK".
    
    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-grava-ordem-aux:

    IF tt-ordem-compra-sdcv-aux.numero-ordem = 0 THEN DO:

        PUT STREAM s_teste UNFORMATTED "andre11: " SKIP
                                   "data: " STRING(TODAY, "99/99/9999") " - " "hora: " STRING(TIME, "HH:MM:SS") SKIP.

        ASSIGN l-erro     = NO
               iLockAgain = 0.

/*         FIND FIRST param-compra EXCLUSIVE-LOCK NO-WAIT NO-ERROR.                          */
/*                                                                                           */
/*         DO  WHILE LOCKED param-compra:                                                    */
/*             IF  LOCKED param-compra THEN DO:                                              */
/*                 PAUSE 10 NO-MESSAGE.  /* Esperar 10 segundos antes de tentar novamente */ */
/*                 FIND CURRENT param-compra EXCLUSIVE-LOCK NO-WAIT NO-ERROR.                */
/*             END.                                                                          */
/*                                                                                           */
/*             IF (NOT LOCKED param-compra AND NOT AVAILABLE param-compra)                   */
/*             OR (AVAILABLE  param-compra AND NOT LOCKED param-compra)                      */
/*             OR (iLockAgain >= 5) THEN LEAVE.                                              */
/*                                                                                           */
/*             ASSIGN iLockAgain = iLockAgain + 1.                                           */
/*         END.                                                                              */
    
        /*Verificar se o rateio totaliza 100%*/
        ASSIGN v-tot-rat = 0.
        FOR EACH tt-rateio-ordem-sdcv
           WHERE tt-rateio-ordem-sdcv.cod-sdcv = tt-ordem-compra-sdcv-aux.cod-sdcv:
            ASSIGN v-tot-rat = v-tot-rat + tt-rateio-ordem-sdcv.perc.
        END.

        PUT STREAM s_teste UNFORMATTED "andre12: " SKIP
                                   "data: " STRING(TODAY, "99/99/9999") " - " "hora: " STRING(TIME, "HH:MM:SS") SKIP.

        IF v-tot-rat <> 100 THEN DO:
             CREATE tt-erro-sdcv.
             ASSIGN tt-erro-sdcv.cod_erro  = 17006
                    tt-erro-sdcv.desc_erro = "Matriz de rateio n∆o totaliza 100%".
             ASSIGN l-erro = TRUE.
        END.

/*         IF  NOT AVAILABLE param-compra THEN DO:                                                                              */
/*             IF  LOCKED param-compra THEN DO:                                                                                 */
/*                 CREATE tt-erro-sdcv.                                                                                         */
/*                 ASSIGN tt-erro-sdcv.cod_erro  = 4                                                                            */
/*                        tt-erro-sdcv.desc_erro = "Registro da tabela ParÉmetros de Compras est† bloqueado por outro usu†rio". */
/*                 ASSIGN l-erro = TRUE.                                                                                        */
/*             END.                                                                                                             */
/*             ELSE DO:                                                                                                         */
/*                 CREATE tt-erro-sdcv.                                                                                         */
/*                 ASSIGN tt-erro-sdcv.cod_erro  = 3                                                                            */
/*                        tt-erro-sdcv.desc_erro = "Tabela ParÉmetros de Compras n∆o dispon°vel".                               */
/*                 ASSIGN l-erro = TRUE.                                                                                        */
/*             END.                                                                                                             */
/*         END.                                                                                                                 */
/*         ELSE IF  CURRENT-CHANGED param-compra THEN DO:                                                                       */
/*                  CREATE tt-erro-sdcv.                                                                                        */
/*                  ASSIGN tt-erro-sdcv.cod_erro  = 12                                                                          */
/*                         tt-erro-sdcv.desc_erro = "Registro corrente foi alterado por outro usu†rio".                         */
/*                  ASSIGN l-erro = TRUE.                                                                                       */
/*         END.                                                                                                                 */

        IF l-erro THEN 
            RETURN 'NOK'.

        PUT STREAM s_teste UNFORMATTED "andre13: " SKIP
                                   "data: " STRING(TODAY, "99/99/9999") " - " "hora: " STRING(TIME, "HH:MM:SS") SKIP.
    
/*         FIND CURRENT param-compra NO-LOCK NO-ERROR. */
        FIND FIRST item NO-LOCK 
            WHERE item.it-codigo = tt-ordem-compra-sdcv-aux.cod-item NO-ERROR.
        
        ASSIGN c-dep-almoxar = "".
    
        IF  AVAIL item THEN DO:
            FIND FIRST item-uni-estab NO-LOCK
                WHERE  item-uni-estab.it-codigo   = item.it-codigo
                AND    item-uni-estab.cod-estabel = substring(tt-ordem-compra-sdcv-aux.sc-codigo,10,3) /*tt-pedido-compra-sdcv.cod-estabel*/ NO-ERROR.
            IF AVAIL item-uni-estab THEN ASSIGN c-dep-almoxar = item-uni-estab.deposito-pad.
        END.
        
        /*PUT UNFORMATTED
            'tt-pedido-compra-sdcv.cod-estabel ' tt-pedido-compra-sdcv.cod-estabel SKIP
            'tt-ordem-compra-sdcv.cod-item     ' tt-ordem-compra-sdcv-aux.cod-item     SKIP
            'tt-ordem-compra-sdcv.cod-sdcv     ' tt-ordem-compra-sdcv-aux.cod-sdcv     SKIP(1).*/
    
        EMPTY TEMP-TABLE tt-ordem-compra NO-ERROR.

/*         IF CAN-FIND(FIRST ext_plano_conta WHERE ext_plano_conta.cod_cta_ctbl = tt-ordem-compra-sdcv-aux.ct-codigo) THEN */
/*             ASSIGN c-ct-codigo = tt-ordem-compra-sdcv-aux.ct-codigo                                                     */
/*                    c-sc-codigo = "":U.                                                                                  */
/*         ELSE                                                                                                            */
            ASSIGN c-ct-codigo = tt-ordem-compra-sdcv-aux.ct-codigo
                   c-sc-codigo = substring(tt-ordem-compra-sdcv-aux.sc-codigo,4,5).  

        IF p_log_ccusto = NO THEN
           ASSIGN c-sc-codigo = "".

        PUT STREAM s_teste UNFORMATTED "andre14: " SKIP
                                   "data: " STRING(TODAY, "99/99/9999") " - " "hora: " STRING(TIME, "HH:MM:SS") SKIP.

        CREATE tt-ordem-compra.
        ASSIGN tt-ordem-compra.numero-ordem   = ?
               tt-ordem-compra.cod-estabel    = tt-pedido-compra-sdcv.end-entrega
               tt-ordem-compra.cod-emitente   = tt-pedido-compra-sdcv.cod-emitente
               tt-ordem-compra.ep-codigo      = c-empresa-pedido
               tt-ordem-compra.it-codigo      = tt-ordem-compra-sdcv-aux.cod-item    
               tt-ordem-compra.origem         = 1
               tt-ordem-compra.data-emissao   = today
               tt-ordem-compra.cod-comprado   = tt-pedido-compra-sdcv.cod-comprado
               tt-ordem-compra.requisitante   = tt-ordem-compra-sdcv-aux.requisitante
               tt-ordem-compra.ct-codigo      = c-ct-codigo
               tt-ordem-compra.sc-codigo      = c-sc-codigo
               tt-ordem-compra.conta-contab   = c-ct-codigo + c-sc-codigo
               tt-ordem-compra.narrativa      = "SDCV: " + string(tt-ordem-compra-sdcv-aux.cod-sdcv) + " - " + string(tt-ordem-compra-sdcv-aux.desc-sdcv) 
               tt-ordem-compra.situacao       = 1 
               tt-ordem-compra.tp-despesa     = 1 /* TIPO DE RECEITA E DESPESA 1 = MERCADO NACIONAL */
               tt-ordem-compra.dep-almoxar    = c-dep-almoxar
               tt-ordem-compra.cod-unid-negoc = substring(tt-ordem-compra-sdcv-aux.sc-codigo,1,3).
        
        FIND FIRST int-desp-cta-ctbl NO-LOCK
             WHERE int-desp-cta-ctbl.cod-cta-ctbl = c-ct-codigo NO-ERROR.

        IF AVAIL int-desp-cta-ctbl THEN
            ASSIGN tt-ordem-compra.tp-despesa = int-desp-cta-ctbl.tp-codigo.

        FIND FIRST item-fornec-estab NO-LOCK
             WHERE item-fornec-estab.it-codigo    = tt-ordem-compra.it-codigo
               AND item-fornec-estab.cod-emitente = tt-ordem-compra.cod-emitente
               AND item-fornec-estab.cod-estabel  = tt-ordem-compra.cod-estabel NO-ERROR.

        find FIRST item-fornec no-lock
             where item-fornec.it-codigo    = tt-ordem-compra.it-codigo
               and item-fornec.cod-emitente = tt-ordem-compra.cod-emitente NO-ERROR.

        IF AVAIL item-fornec THEN DO:
           {cdp/cd9950.i item.un 
                         item-fornec.unid-med-for
                         tt-ordem-compra.cod-emitente}
        END.

        assign de-indice = 1 when (de-indice = 0 or de-indice = ?). 
        
        EMPTY TEMP-TABLE tt-prazo-compra NO-ERROR.
    
        create tt-prazo-compra.
        ASSIGN tt-prazo-compra.numero-ordem = tt-ordem-compra.numero-ordem
               tt-prazo-compra.parcela      = 1
               tt-prazo-compra.situacao     = 2 
               tt-prazo-compra.it-codigo    = tt-ordem-compra-sdcv-aux.cod-item
               tt-prazo-compra.un           = IF AVAIL ITEM THEN item.un ELSE "pc"
               tt-prazo-compra.quantid-orig = tt-ordem-compra-sdcv-aux.qt-solic
               tt-prazo-compra.quantidade   = tt-ordem-compra-sdcv-aux.qt-solic
               tt-prazo-compra.qtd-a-ped-forn = tt-ordem-compra-sdcv-aux.qt-solic * de-indice
               tt-prazo-compra.qtd-do-forn    = tt-ordem-compra-sdcv-aux.qt-solic * de-indice
               tt-prazo-compra.qtd-sal-forn   = tt-ordem-compra-sdcv-aux.qt-solic * de-indice
               tt-prazo-compra.qtd-sal-forn = tt-ordem-compra-sdcv-aux.qt-solic
               tt-prazo-compra.data-orig    = TODAY /* data do pedido */
               tt-prazo-compra.data-entrega = tt-ordem-compra-sdcv-aux.prazo-entreg.

        EMPTY TEMP-TABLE tt-cotacao-item NO-ERROR.
    
        CREATE tt-cotacao-item.
        ASSIGN tt-cotacao-item.numero-ordem  = tt-ordem-compra.numero-ordem
               tt-cotacao-item.it-codigo     = tt-ordem-compra-sdcv-aux.cod-item
               tt-cotacao-item.cod-emitente  = INT(tt-pedido-compra-sdcv.cod-emitente)
               tt-cotacao-item.data-cotacao  = TODAY /* data do pedido */
               tt-cotacao-item.un            = (IF AVAIL item-fornec-estab THEN item-fornec-estab.un ELSE (if avail item-fornec then item-fornec.un else item.un))
               tt-cotacao-item.codigo-ipi    = if tt-ordem-compra-sdcv-aux.aliquota-ipi > 0 then NO /* corrigido conforme chamado 22077, da Alessandra Kremer */
                                               else YES
               tt-cotacao-item.preco-unit    = dec(tt-ordem-compra-sdcv-aux.preco-unit) + if NOT tt-cotacao-item.codigo-ipi then 
                                               dec(tt-ordem-compra-sdcv-aux.preco-unit) * tt-ordem-compra-sdcv-aux.aliquota-ipi / 100 
                                               else 0
               tt-cotacao-item.pre-unit-for  = dec(tt-ordem-compra-sdcv-aux.preco-unit) + if NOT tt-cotacao-item.codigo-ipi then 
                                               dec(tt-ordem-compra-sdcv-aux.preco-unit) * tt-ordem-compra-sdcv-aux.aliquota-ipi / 100 
                                               else 0
               tt-cotacao-item.preco-fornec  = dec(tt-ordem-compra-sdcv-aux.preco-unit) 
               tt-cotacao-item.mo-codigo     = tt-pedido-compra-sdcv.mo-codigo
               tt-cotacao-item.aliquota-ipi  = tt-ordem-compra-sdcv-aux.aliquota-ipi
               tt-cotacao-item.aliquota-iss  = 0 
               tt-cotacao-item.codigo-icm    = 1
               tt-cotacao-item.aliquota-icm  = tt-ordem-compra-sdcv-aux.aliquota-icm
               tt-cotacao-item.frete         = if tt-pedido-compra-sdcv.frete = 1 /* CIF */ then YES else NO
               tt-cotacao-item.valor-frete   = 0 /* verificar dec(entry(13,c-linha,";"))*/
               tt-cotacao-item.cod-cond-pag  = IF l-cessao-credito THEN emitente.cod-cond-pag ELSE int(tt-pedido-compra-sdcv.cod-cond-pag).  
        
        ASSIGN tt-cotacao-item.prazo-entreg  = (tt-ordem-compra-sdcv-aux.prazo-entreg - TODAY)
               tt-cotacao-item.contato       = "" /* verificar entry(2,c-linha,";")*/
               tt-cotacao-item.cod-comprado  = tt-pedido-compra-sdcv.cod-comprado
               tt-cotacao-item.cot-aprovada  = yes
               tt-cotacao-item.aprovador     = tt-pedido-compra-sdcv.cod-comprado
               tt-cotacao-item.usuario       = tt-pedido-compra-sdcv.cod-comprado
               tt-cotacao-item.data-atualiz  = today
               tt-cotacao-item.hora-atualiz  = string(time,"HH:MM:SS")
               tt-cotacao-item.motivo-apr    = "SDCV"
               tt-cotacao-item.dias-validade = 999.

        ASSIGN tt-cotacao-item.pre-unit-for   = tt-cotacao-item.pre-unit-for / de-indice
               tt-cotacao-item.preco-fornec   = tt-cotacao-item.preco-fornec / de-indice.
        
        assign tt-ordem-compra.preco-orig    = tt-cotacao-item.preco-fornec
               tt-ordem-compra.preco-unit    = tt-cotacao-item.preco-unit
               tt-ordem-compra.pre-unit-for  = tt-cotacao-item.pre-unit-for
               tt-ordem-compra.preco-fornec  = tt-cotacao-item.preco-fornec
               tt-ordem-compra.mo-codigo     = tt-pedido-compra-sdcv.mo-codigo
               tt-ordem-compra.codigo-ipi    = tt-cotacao-item.codigo-ipi
               tt-ordem-compra.aliquota-ipi  = tt-cotacao-item.aliquota-ipi
               tt-ordem-compra.codigo-icm    = tt-cotacao-item.codigo-icm
               tt-ordem-compra.aliquota-icm  = tt-cotacao-item.aliquota-icm
               tt-ordem-compra.aliquota-iss  = tt-cotacao-item.aliquota-iss
               tt-ordem-compra.frete         = tt-cotacao-item.frete
               tt-ordem-compra.valor-frete   = tt-cotacao-item.valor-frete
               tt-ordem-compra.cod-cond-pag  = tt-cotacao-item.cod-cond-pag
               tt-ordem-compra.prazo-entreg  = tt-cotacao-item.prazo-entreg
               tt-ordem-compra.contato       = tt-cotacao-item.contato
               tt-ordem-compra.qt-solic      = tt-ordem-compra-sdcv-aux.qt-solic
               tt-ordem-compra.situacao      = 1 .

        /**Gera as Ordens**/
        EMPTY TEMP-TABLE tt-erro-aux.
        RUN ccp/ccapi012.p(INPUT-OUTPUT TABLE tt-ordem-compra,
                           INPUT-OUTPUT TABLE tt-prazo-compra,
                           OUTPUT TABLE tt-erro-aux,
                           INPUT FALSE). /*divide ordens entre fornecedores*/

        PUT STREAM s_teste UNFORMATTED "andre15: " SKIP
                                   "data: " STRING(TODAY, "99/99/9999") " - " "hora: " STRING(TIME, "HH:MM:SS") SKIP.

        FOR EACH tt-erro-aux:
            CREATE tt-erro-sdcv.
            ASSIGN tt-erro-sdcv.cod_erro  = tt-erro-aux.cd-erro
                   tt-erro-sdcv.desc_erro = tt-erro-aux.mensagem.
            ASSIGN l-erro = TRUE.          
            DELETE tt-erro-aux.           
        END.
        
        IF l-erro THEN 
            RETURN 'NOK'.
                                                                                           
        FIND FIRST tt-ordem-compra NO-ERROR.
        FIND FIRST tt-prazo-compra NO-ERROR.

        ASSIGN tt-cotacao-item.numero-ordem  = tt-ordem-compra.numero-ordem.

        /**Gera a Cotaá∆o**/
        EMPTY TEMP-TABLE RowErrors.
        RUN ocp/ocapi003.p (input table tt-cotacao-item,
                            output table rowErrors).
        IF CAN-FIND (FIRST rowErrors WHERE rowErrors.errorSubType = "error") THEN
           ASSIGN l-erro = TRUE.

        PUT STREAM s_teste UNFORMATTED "andre16: " SKIP
                                   "data: " STRING(TODAY, "99/99/9999") " - " "hora: " STRING(TIME, "HH:MM:SS") SKIP.
    
        RUN pi-transf-rowErrors-tt-erro.
    
        IF l-erro THEN
            RETURN "NOK".

        PUT STREAM s_teste UNFORMATTED 
            "NOVO NUMERO DA ORDEM COMPRA CRIADA: " tt-ordem-compra.numero-ordem SKIP(1).

        /*Vai anexar a Ordem no Pedido*/
        RUN pi-anexa-ordem-pedido(INPUT tt-ped.num-pedido,
                                  INPUT tt-ordem-compra.numero-ordem).

        if  valid-handle(h-boin274vl) then do:
            DELETE procedure h-boin274vl.
            assign h-boin274vl = ?.
        END. /* if  valid-handle(h-boin274vl) */

       IF RETURN-VALUE NE "OK" THEN do:
          ASSIGN l-erro = TRUE.
          RETURN 'NOK'.
       END.
           
        /*---[ respeitando a nova tabela criada ]-----------------------------*/
/*         IF  tt-ordem-compra.it-codigo <> "INVESTI" AND                          */
/*         NOT CAN-FIND(FIRST ext_plano_conta                                      */
/*                      WHERE ext_plano_conta.cod_cta_ctbl = c-ct-codigo) THEN DO: */
        RUN pi-grava-matriz-rat-aux.
/*         END. /* IF  tt-ordem-compra.it-codigo <> "INVESTI" ... */ */
         
        /* Eliminar unid-neg-ordem para ordens que tiverem a unidade de neg¢cio informada na OC*/
        FIND ordem-compra WHERE
             ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem NO-LOCK NO-ERROR.
        IF AVAIL ordem-compra THEN DO:
            IF ordem-compra.cod-unid-negoc <> "" THEN DO:
                FOR EACH unid-neg-ordem
                   WHERE unid-neg-ordem.numero-ordem = ordem-compra.numero-ordem EXCLUSIVE-LOCK:
                    DELETE unid-neg-ordem.
                END.
            END.
        END.

        PUT STREAM s_teste UNFORMATTED "andre17: " SKIP
                                   "data: " STRING(TODAY, "99/99/9999") " - " "hora: " STRING(TIME, "HH:MM:SS") SKIP.

        FOR EACH ordem-compra EXCLUSIVE-LOCK 
            WHERE ordem-compra.num-pedido = tt-ped.num-pedido:

            CREATE tt-retorno-ordem-sdcv.
            ASSIGN tt-retorno-ordem-sdcv.cod_sdcv     = TRIM(ENTRY(2, ordem-compra.narrativa, ":"))
                   tt-retorno-ordem-sdcv.numero_ordem = ordem-compra.numero-ordem.

            /*PUT UNFORMATTED
                "Informaá∆o gerada Ös "  string(time, "HH:MM:SS":U) ", do dia " string(today, "99/99/9999":U) skip
                "tt-retorno-ordem-sdcv.cod_sdcv     " tt-retorno-ordem-sdcv.cod_sdcv     SKIP
                "tt-retorno-ordem-sdcv.numero_ordem " tt-retorno-ordem-sdcv.numero_ordem SKIP.*/
        
            ASSIGN ordem-compra.num-pedido   = tt-ped.num-pedido
                   ordem-compra.data-pedido  = TODAY 
                   ordem-compra.situacao     = 2 /* confirmada */.
         
            FOR EACH  prazo-compra EXCLUSIVE-LOCK
                WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem:
               ASSIGN prazo-compra.situacao     = 2 /* confirmada */.
            END. 
        END. 
    END. 

    RETURN 'OK'.

END PROCEDURE.

/*---[ PROCEDURES ]-----------------------------------------------------------------------------------------------------------------*/
PROCEDURE pi-anexa-ordem-pedido PRIVATE :

    DEFINE INPUT PARAMETER p-num-pedido     AS INTEGER     NO-UNDO.
    DEFINE INPUT PARAMETER p-numero-ordem   AS INTEGER     NO-UNDO.
    
    DEFINE VARIABLE l-aprov-total           AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-retorno-aprov         AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-alterou-impr-pedido   AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-erro                  AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE rRowidOrdem AS ROWID       NO-UNDO.

    IF NOT VALID-HANDLE(h-boin295) THEN
        RUN inbo/boin295.p PERSISTENT SET h-boin295.

    RUN openQueryStatic IN h-boin295 ( INPUT "Main":U ).
    RUN gotoKey         IN h-boin295(INPUT p-num-pedido).
    RUN getRecord       IN h-boin295(OUTPUT TABLE tt-pedido-compr).
    
    FIND FIRST tt-pedido-compr NO-ERROR.

    IF NOT VALID-HANDLE(h-boin274vl) THEN
        RUN inbo/boin274vl.p PERSISTENT SET h-boin274vl.
    
    RUN returnRowidOrdem IN h-boin274vl (INPUT p-numero-ordem,
                                         OUTPUT rRowidOrdem).
    /*PUT UNFORMATTED 
         "VINCULO DA OC AO PEDIDO: " p-num-pedido " OC: " p-numero-ordem SKIP(1).*/

    RUN emptyRowErrors IN h-boin274vl.
    RUN validaModificacaoOrdemCompra IN h-boin274vl(INPUT rRowidOrdem).
    
    EMPTY TEMP-TABLE rowErrors.
    RUN getRowErrors IN h-boin274vl(OUTPUT TABLE rowErrors).  
    ASSIGN l-erro = CAN-FIND(FIRST rowErrors WHERE rowErrors.errorSubType = "error").
    RUN pi-transf-rowErrors-tt-erro.
    IF l-erro THEN
       RETURN "NOK".
   
    IF tt-pedido-compr.situacao = 2 THEN DO:  /* n∆o impresso */
        RUN emptyRowErrors in h-boin295.
        RUN relacionaOrdemCompraPedido IN h-boin295 (rRowidOrdem).
        
        EMPTY TEMP-TABLE rowErrors.
        run getRowErrors IN h-boin295(OUTPUT TABLE rowErrors).  
        ASSIGN l-erro = CAN-FIND(FIRST rowErrors WHERE rowErrors.errorSubType = "error").
        RUN pi-transf-rowErrors-tt-erro.
        IF l-erro THEN
           RETURN "NOK".
    END.
    ELSE DO:
        RUN emptyRowErrors in h-boin274vl.
        RUN retornaErroNaoAprov in h-boin274vl (INPUT  rRowidOrdem,
                                                OUTPUT l-retorno-aprov).
        EMPTY TEMP-TABLE rowErrors.
        RUN getRowErrors IN h-boin274vl(OUTPUT TABLE rowErrors).  
        ASSIGN l-erro = CAN-FIND(FIRST rowErrors WHERE rowErrors.errorSubType = "error").
        RUN pi-transf-rowErrors-tt-erro.
        IF l-erro THEN
           RETURN "NOK".
        
        RUN emptyRowErrors IN h-boin274vl.
        RUN incluiOrdensPedidoOrdemCompra IN h-boin274vl (INPUT  rRowidOrdem,
                                                          INPUT  p-num-pedido,
                                                          INPUT  "":U,
                                                          INPUT  l-retorno-aprov).
        EMPTY TEMP-TABLE rowErrors.
        run getRowErrors IN h-boin274vl(OUTPUT TABLE rowErrors).  
        ASSIGN l-erro = CAN-FIND(FIRST rowErrors WHERE rowErrors.errorSubType = "error").
        RUN pi-transf-rowErrors-tt-erro.
        IF l-erro THEN
           RETURN "NOK".       
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-grava-matriz-rat-aux.

    FOR EACH  tt-rateio-ordem-sdcv
        WHERE tt-rateio-ordem-sdcv.cod-sdcv = tt-ordem-compra-sdcv-aux.cod-sdcv:
   

        FIND FIRST matriz-rat-ordem EXCLUSIVE-LOCK 
            WHERE matriz-rat-ordem.numero-ordem = tt-ordem-compra.numero-ordem 
              AND matriz-rat-ordem.ct-codigo    = tt-rateio-ordem-sdcv.ct-codigo
              AND matriz-rat-ordem.sc-codigo    = SUBSTRING(tt-rateio-ordem-sdcv.sc-codigo,4,5) NO-ERROR.
        IF NOT AVAIL matriz-rat-ordem THEN DO:
            CREATE matriz-rat-ordem.
            ASSIGN matriz-rat-ordem.numero-ordem        = tt-ordem-compra.numero-ordem
                   matriz-rat-ordem.conta-contabil      = tt-rateio-ordem-sdcv.ct-codigo + SUBSTRING(tt-rateio-ordem-sdcv.sc-codigo,4,5)
                   matriz-rat-ordem.ct-codigo           = tt-rateio-ordem-sdcv.ct-codigo
                   matriz-rat-ordem.sc-codigo           = SUBSTRING(tt-rateio-ordem-sdcv.sc-codigo,4,5)
                   OVERLAY(matriz-rat-ordem.char-2,1,3) = SUBSTRING(tt-rateio-ordem-sdcv.sc-codigo,1,3).
        END. /* if not avail matriz-rat-ordem then do: */

        ASSIGN matriz-rat-ordem.perc = matriz-rat-ordem.perc + tt-rateio-ordem-sdcv.perc.

    END. /* FOR EACH tt-rateio-ordem-sdcv */

    RELEASE matriz-rat-ordem.

END PROCEDURE. 

/*---[ PROCEDURES ]-----------------------------------------------------------------------------------------------------------------*/
PROCEDURE pi-transf-rowErrors-tt-erro PRIVATE :

    FOR EACH rowErrors WHERE
             rowErrors.errorSubType = "error":

        CREATE tt-erro-sdcv.
        ASSIGN tt-erro-sdcv.cod_erro  = rowErrors.errorNumber
               tt-erro-sdcv.desc_erro = rowErrors.errorDescription.
        ASSIGN l-erro = TRUE.       
    END.

    RETURN "OK".

END PROCEDURE.
/*---[ PROCEDURES ]-----------------------------------------------------------------------------------------------------------------*/
PROCEDURE pi-mandaTT:

    DEFINE INPUT PARAMETER pnum-pedido   LIKE pedido-compr.num-pedido   NO-UNDO.
    DEFINE INPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

    FOR FIRST pedido-compr EXCLUSIVE-LOCK 
        WHERE  pedido-compr.num-pedido = pnum-pedido:
        CREATE tt-retorno-pedido-sdcv.
        ASSIGN tt-retorno-pedido-sdcv.cod_compra       = TRIM(ENTRY(2, pedido-compr.c-observacao[1], ":"))
               tt-retorno-pedido-sdcv.num_pedido_compr = pedido-compr.num-pedido
               tt-retorno-pedido-sdcv.num_mensagem     = string(pedido-compr.cod-mensagem).
    END. 
    
    FOR FIRST ordem-compra EXCLUSIVE-LOCK 
        WHERE ordem-compra.numero-ordem = pnumero-ordem:
        CREATE tt-retorno-ordem-sdcv.
        ASSIGN tt-retorno-ordem-sdcv.cod_sdcv     = TRIM(ENTRY(2, ordem-compra.narrativa, ":"))
               tt-retorno-ordem-sdcv.numero_ordem = ordem-compra.numero-ordem.
    END.                     

END PROCEDURE. /* PROCEDURE pi-mandaTT: */
