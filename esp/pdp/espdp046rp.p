 /**********************************************************************************
** Programa: esp/pdp/espdp046rp.p
** Vers∆o..: 1.00
** Data....: 16/12/2013
** Autor...: Roger
** Obs.....: Importaá∆o tabela de preáos             
**********************************************************************************/

{include/i-prgvrs.i espdp046rp 2.00.00.000}

//{esp/es0018.i} .

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
    field raw-digita       as raw.

define temp-table tt-param no-undo
    field destino               as integer
    field arquivo               as char format "x(35)"
    field usuario               as char format "x(12)"
    field data-exec             as date
    field hora-exec             as integer
    field classifica            as integer
    field desc-classifica       as char format "x(40)"
    field modelo-rtf            as char format "x(35)"
    field l-habilitaRtf         as LOG
    FIELD tp-execucao           AS INTEGER
    FIELD c-arq-import          AS CHARACTER
    FIELD l-inativa-listas      AS LOG
    FIELD nr-dias-inativa-lista AS INT.
                                         
DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

DEFINE TEMP-TABLE tt-erro-local NO-UNDO
    FIELD mensagem  AS CHARACTER FORMAT "x(250)".

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem  AS CHARACTER FORMAT "x(250)".

DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD errorSequence     AS INT
    FIELD errorNumber       AS INT
    FIELD errorDescription  AS CHAR FORMAT "x(150)"
    FIELD errorParameters   AS CHAR
    FIELD errorType         AS CHAR
    FIELD errorHelp         AS CHAR FORMAT "x(150)"
    FIELD errorSubtype      AS CHAR.

DEF TEMP-TABLE tt-linha
    FIELD linha      AS CHAR
    FIELD seq        AS INT
    FIELD it-codigo  like preco-item.it-codigo
    FIELD cod-refer  like preco-item.cod-refer
    FIELD nr-tabpre  like preco-item.nr-tabpre
    FIELD dt-inival  like preco-item.dt-inival
    FIELD quant-min  like preco-item.quant-min
    FIELD dt-val-ini AS DATE
    FIELD desc-qt    AS DECIMAL
    INDEX idx seq.

define temp-table tt-param-espdp096 no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    field fi-tab-ini       AS CHAR
    field fi-tab-fim       AS CHAR
    field fi-item-ini      AS CHAR
    field fi-item-fim      AS CHAR.

DEFINE TEMP-TABLE tt-lista-inativacao NO-UNDO
    FIELD it-codigo   LIKE ITEM.it-codigo
    FIELD descricao   LIKE ITEM.descricao-1
    FIELD nr-tabpre   LIKE preco-item.nr-tabpre
    FIELD dt-inival   LIKE preco-item.dt-inival . 

DEFINE TEMP-TABLE tt-itens-inativados NO-UNDO
    FIELD it-codigo   LIKE ITEM.it-codigo
    FIELD descricao-1 LIKE ITEM.descricao-1
    FIELD nr-tabpre   LIKE preco-item.nr-tabpre 
    FIELD dt-inival   LIKE preco-item.dt-inival 
    FIELD cd-inativa  AS INT.

/*--- Definiá∆o das Vari†veis ---*/

DEFINE VARIABLE l-erro  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE h-acomp AS HANDLE    NO-UNDO.
DEFINE VARIABLE c-linha AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-ecommerce AS LOG   NO-UNDO.
DEFINE VARIABLE c-refer AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont  AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cont-aux AS INTEGER NO-UNDO.
DEFINE VARIABLE i-linha AS INTEGER NO-UNDO.
DEFINE VARIABLE l-estabel AS LOGICAL NO-UNDO.
/*------------------------*/
/*     I N C L U D E S    */
/*------------------------*/
/* include padr∆o para vari†veis de relat¢rio  */
{include/i-rpvar.i}
{include/i-rpout.i}
{include/i-rpcab.i}
{utp/ut-glob.i}
{esp/es0018.i}  
{btb/btb912zb.i}

/* bloco principal do programa */
ASSIGN c-programa     = "espdp046"
       c-versao       = "2.00"
       c-revisao      = ".00.000"
       c-empresa      = "Intelbras"
       c-sistema      = "importaá∆o tabela de preáos"
       c-titulo-relat = "Importaá∆o tabela de preáos".

/*--- Processamento Principal ---*/
IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Importando Tabela").
                                               
EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "Vtex-preco":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).


ASSIGN i-linha = 0.

INPUT FROM VALUE(tt-param.c-arq-import).

view frame f-cabec.
view frame f-rodape.    


PUT sKIP(2) "                             Importaá∆o de Preáos                                   " skip.
PUT         "                     -----------------------------------                            " SKIP(2).

PUT "Tabela      Item             Data In°cio Quant. Min    Preáo CIF          Preáo FOB               Refer " SKIP
    "----------- ---------------- ----------- ------------- ------------------ ------------------    --------" SKIP.


REPEAT:
    ASSIGN l-erro = NO.
    ASSIGN l-estabel = NO.
    IMPORT UNFORMATTED c-linha.

    ASSIGN i-linha = i-linha + 1.

    RUN pi-acompanhar IN h-acomp (INPUT "Codigo "  + STRING(ENTRY(1, c-linha, ";")) + " " + STRING(ENTRY(2, c-linha, ";")) + " " + STRING(ENTRY(3, c-linha, ";")) ).
    
    FIND FIRST ITEM WHERE
               ITEM.it-codigo = ENTRY(2,c-linha,";") NO-LOCK NO-ERROR.
   
    IF NOT AVAIL ITEM THEN DO:
        CREATE tt-erro-local.
            ASSIGN tt-erro-local.mensagem = "Linha: " + string(i-linha) + " " + "Item nao cadastrado. " + string(ENTRY(2,c-linha,";"))
                   l-erro =  YES.
            NEXT.
    END.
        
    IF AVAIL ITEM AND ITEM.ind-item-fat = NO THEN DO:
        CREATE tt-erro-local.
            ASSIGN tt-erro-local.mensagem = "Linha: " + string(i-linha) + " " + "Item nao esta disponivel para faturamento. " + string(ENTRY(2,c-linha,";"))
                   l-erro =  YES.
    END.

    /*IDBA Bruno 11/09/2023 - Cria temp-table que ser† usada para inativar listas obsoletas mais tarde*/

    CREATE tt-lista-inativacao.
    ASSIGN tt-lista-inativacao.it-codigo = ITEM.it-codigo
           tt-lista-inativacao.descricao = ITEM.descricao-1
           tt-lista-inativacao.nr-tabpre = STRING(ENTRY(1, c-linha, ";"))
           tt-lista-inativacao.dt-inival = DATE(ENTRY(10,c-linha,";")).

    /*PREÄO ECOMMERCE*/
    IF  CAN-FIND (FIRST tt-prog-ponto
                  WHERE entry(1, tt-prog-ponto.conteudo, ";") = ENTRY(1,c-linha,";")) THEN
        ASSIGN l-ecommerce = YES.
   
    ASSIGN c-refer = ''.
   
    DO i-cont = 1 TO NUM-ENTRIES(c-linha,';'):
       IF i-cont = 9 THEN ASSIGN c-refer = ENTRY(i-cont,c-linha,";").
    END.
    
    IF c-refer <> "" THEN DO:
        FIND FIRST estabelec USE-INDEX codigo
            WHERE estabelec.cod-estabel = c-refer NO-LOCK NO-ERROR.

        IF NOT AVAIL estabelec THEN DO:
            CREATE tt-erro-local.
                   ASSIGN tt-erro-local.mensagem = "Linha: " + string(i-linha) + " " + "Estabelecimento inexistente. " + string(c-refer)
                          l-erro =  YES.
        END.

        FIND FIRST ITEm-uni-estab
             WHERE ITEM-uni-estab.it-codigo = ENTRY(2,c-linha,";")
             AND   item-uni-estab.cod-estabel = c-refer NO-LOCK NO-ERROR.

        IF AVAIL item-uni-estab AND item-uni-estab.ind-item-fat = NO THEN DO:
            CREATE tt-erro-local.
                   ASSIGN tt-erro-local.mensagem = "Linha: " + string(i-linha) + " " + "Item nao esta disponivel para faturamento no estabelecimento " + string(c-refer)
                          l-erro =  YES.

        END.
    END.
   
    /* Desativa todos os itens ativos para a tabela de preco informada. 
    FOR EACH  preco-item 
        WHERE preco-item.it-codigo = ITEM.it-codigo 
          AND preco-item.nr-tabpre = ENTRY(1,c-linha,";")
          AND preco-item.cod-refer = c-refer
          AND preco-item.situacao  = 1 EXCLUSIVE-LOCK:
        
       ASSIGN preco-item.situacao  = 2.
    END.*/

    
    
    FIND FIRST tb-preco
        WHERE tb-preco.nr-tabpre = ENTRY(1,c-linha,";") NO-LOCK NO-ERROR.

    IF NOT AVAIL tb-preco THEN DO:
         CREATE tt-erro-local.
         ASSIGN tt-erro-local.mensagem = "Linha: " + string(i-linha) + " " + "Tabela preco nao encontrada. " + string(ENTRY(1,c-linha,";"))
                l-erro =  YES.  
    END.
    ELSE 
        IF tb-preco.situacao = 2 THEN DO:
              CREATE tt-erro-local.
              ASSIGN tt-erro-local.mensagem = "Linha: " + string(i-linha) + " " + "Tabela preco inativa. " + string(ENTRY(1,c-linha,";"))
                     l-erro =  YES.  
    END.

    IF DEC(ENTRY(3,c-linha,";")) = 0 THEN DO:
        CREATE tt-erro-local.
              ASSIGN tt-erro-local.mensagem = "Linha: " + string(i-linha) + " " + "Preco fob zerado. " + STRING(ENTRY(3,c-linha,";"))
                     l-erro =  YES.
    END.
    
    IF ENTRY(10,c-linha,";") BEGINS "00" THEN DO:
        CREATE tt-erro-local.
              ASSIGN tt-erro-local.mensagem = "Linha: " + string(i-linha) + " " + "Data invalida. " + STRING(ENTRY(10,c-linha,";"))
                     l-erro =  YES.

              NEXT.
    END.
    
    IF DATE(ENTRY(10,c-linha,";")) < TODAY  THEN DO:
        CREATE tt-erro-local.
              ASSIGN tt-erro-local.mensagem = "Linha: " + string(i-linha) + " " + "Data inicial nao pode ser menor data vigente. " + STRING(ENTRY(10,c-linha,";"))
                     l-erro =  YES.
    END.
    
    IF DATE(ENTRY(10,c-linha,";")) = ?  THEN DO:
        CREATE tt-erro-local.
              ASSIGN tt-erro-local.mensagem = "Linha: " + string(i-linha) + " " + "Data nao pode ser branco. " + STRING(ENTRY(10,c-linha,";"))
                     l-erro =  YES.

              NEXT.
    END.
    
    IF DEC(ENTRY(7,c-linha,";")) = 0 THEN DO:
        CREATE tt-erro-local.
              ASSIGN tt-erro-local.mensagem = "Linha: " + string(i-linha) + " " + "Quantidade zero. " + STRING(ENTRY(7,c-linha,";"))
                     l-erro =  YES.
    END.

    IF DEC(ENTRY(4,c-linha,";")) <> 0 THEN DO:
        FIND FIRST preco-item 
             WHERE preco-item.it-codigo = ITEM.it-codigo 
               AND preco-item.cod-refer = c-refer
               AND preco-item.nr-tabpre = ENTRY(1,c-linha,";")
               AND preco-item.dt-inival = DATE(ENTRY(10,c-linha,";"))
               AND preco-item.quant-min = DEC(ENTRY(7,c-linha,";")) EXCLUSIVE-LOCK NO-ERROR.
        
        IF NOT AVAIL preco-item THEN DO:
            CREATE preco-item.
            ASSIGN preco-item.it-codigo = ITEM.it-codigo
                   preco-item.cod-refer = c-refer
                   preco-item.nr-tabpre = ENTRY(1,c-linha,";")
                   preco-item.dt-inival = DATE(ENTRY(10,c-linha,";"))
                   preco-item.quant-min = DEC(ENTRY(7,c-linha,";"))
                   preco-item.desco-quant = DEC(ENTRY(11,c-linha,";")).
        END.
        /*ELSE
            FIND CURRENT preco-item EXCLUSIVE-LOCK NO-ERROR.*/
   
        IF AVAIL preco-item THEN DO:
          ASSIGN preco-item.dt-useralt   = TODAY
                 preco-item.preco-venda  = truncate(DEC(ENTRY(4,c-linha,";")),4)
                 preco-item.preco-fob    = truncate(DEC(ENTRY(3,c-linha,";")),4)
                 preco-item.quant-min    = DEC(ENTRY(7,c-linha,";"))
                 preco-item.cod-refer    = c-refer
                 preco-item.situacao     = 1
                 preco-item.user-alter   = USERID("mgadm")
                 preco-item.dt-useralt   = TODAY
                 preco-item.cod-unid-med = ITEM.un.

          IF l-erro = YES THEN NEXT.

             PUT preco-item.nr-tabpre AT 1
                 preco-item.it-codigo AT 13 
                 preco-item.dt-inival AT 31
                 /*preco-item.quant-min AT 43
                 preco-item.preco-venda AT 57
                 preco-item.preco-fob AT 78*/
                 preco-item.quant-min AT 43
                 preco-item.preco-venda AT 57
                 preco-item.preco-fob AT 76
                 preco-item.cod-refer AT 97 SKIP.
        END.
   
        
        FIND CURRENT preco-item NO-LOCK NO-ERROR.
   
        IF AVAIL preco-item THEN DO:
           FIND FIRST int-preco-item EXCLUSIVE-LOCK
               WHERE  int-preco-item.it-codigo = preco-item.it-codigo
               AND    int-preco-item.cod-refer = preco-item.cod-refer
               AND    int-preco-item.nr-tabpre = preco-item.nr-tabpre
               AND    int-preco-item.dt-inival = preco-item.dt-inival
               AND    int-preco-item.quant-min = preco-item.quant-min NO-ERROR.
           IF  NOT AVAIL int-preco-item THEN DO:
               CREATE int-preco-item.
               ASSIGN int-preco-item.it-codigo = preco-item.it-codigo
                      int-preco-item.cod-refer = preco-item.cod-refer
                      int-preco-item.nr-tabpre = preco-item.nr-tabpre
                      int-preco-item.dt-inival = preco-item.dt-inival
                      int-preco-item.quant-min = preco-item.quant-min.
           END.
   
           IF AVAIL int-preco-item THEN
              ASSIGN int-preco-item.pma = DEC(ENTRY(5,c-linha,";"))
                     int-preco-item.pmd = DEC(ENTRY(6,c-linha,";")).
        END.
    END.
      ELSE DO:
          CREATE tt-erro-local.
          ASSIGN tt-erro-local.mensagem = "Linha: " + string(i-linha) + " " + "preco venda zerado. " + STRING(ENTRY(4,c-linha,";"))
                 l-erro =  YES.
      END.
   END.


IF CAN-FIND(FIRST tt-erro-local) THEN DO:
    PUT SKIP(2).
    PUT "Planilha contem seguintes Erros: " /*CAN-FIND( FIRST tt-erro-local)*/ SKIP.
        
    FOR EACH tt-erro-local:
        PUT UNFORMATTED tt-erro-local.mensagem /*FORMAT "x(100)"*/ CHR(10).
    END.
END.

INPUT CLOSE.


/**********************************/

/* IDBA - Bruno J -> 04/09/2023 Parte do programa que realiza a inativacao das listas obsoletas */

DEFINE VAR n AS INT.
DEFINE VAR l-continua AS LOG.

DEFINE TEMP-TABLE tt-listas-permitidas
    FIELD nr-tabpre LIKE preco-item.nr-tabpre .

EMPTY TEMP-TABLE tt-listas-permitidas.

DO WHILE l-continua <> TRUE :
    EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p (INPUT  "espdp046":U,
                           INPUT  1,
                           INPUT  n,
                           INPUT  "":U,
                           OUTPUT TABLE tt-prog-ponto).
        FIND FIRST tt-prog-ponto  NO-ERROR.
        IF AVAIL tt-prog-ponto THEN DO:
            CREATE tt-listas-permitidas.
            ASSIGN tt-listas-permitidas.nr-tabpre = conteudo .

            ASSIGN n = n + 1 .

        END.
        ELSE DO:
            ASSIGN l-continua = TRUE.
        END.
END.

IF l-inativa-listas = YES THEN DO:
    DEF VAR i AS INT.

    FOR EACH tt-lista-inativacao BREAK BY tt-lista-inativacao.nr-tabpre:
        IF FIRST-OF(tt-lista-inativacao.nr-tabpre) THEN DO:
            FOR EACH preco-item WHERE preco-item.situacao  = 1 
                                  AND preco-item.nr-tabpre = tt-lista-inativacao.nr-tabpre 
                                  AND preco-item.dt-inival < TODAY EXCLUSIVE-LOCK:
            // validamos a data de inicio do mesmo, caso seja superior ao informado no parameto inativamos o item na lista 

                RUN pi-acompanhar IN h-acomp (INPUT "Inativando obsoletos lista "  + STRING(tt-lista-inativacao.nr-tabpre) + " ID: " + string(i) ) .

                CREATE tt-itens-inativados.
                ASSIGN tt-itens-inativados.it-codigo   = tt-lista-inativacao.it-codigo
                       tt-itens-inativados.descricao-1 = tt-lista-inativacao.descricao
                       tt-itens-inativados.nr-tabpre   = preco-item.nr-tabpre 
                       tt-itens-inativados.dt-inival   = preco-item.dt-inival 
                       tt-itens-inativados.cd-inativa  = 1 . 

                ASSIGN preco-item.situacao  = 2 .

                 i = i + 1 .
            END.
            i = 0 .
        END.
    END.
END. //l-inativa-listas = YES
ELSE DO: 

    FOR EACH tt-lista-inativacao :
        FOR EACH preco-item WHERE preco-item.situacao  =  1 
                              AND preco-item.it-codigo =  tt-lista-inativacao.it-codigo
                              AND preco-item.nr-tabpre =  tt-lista-inativacao.nr-tabpre 
                              AND preco-item.dt-inival <> tt-lista-inativacao.dt-inival EXCLUSIVE-LOCK:
        // validamos a data de inicio do mesmo, caso seja superior ao informado no parameto inativamos o item na lista 

            RUN pi-acompanhar IN h-acomp (INPUT "Inativando obsoletos lista "  + STRING(tt-lista-inativacao.nr-tabpre) + " ID: " + string(i) ) .

            CREATE tt-itens-inativados.
            ASSIGN tt-itens-inativados.it-codigo   = tt-lista-inativacao.it-codigo
                   tt-itens-inativados.descricao-1 = tt-lista-inativacao.descricao
                   tt-itens-inativados.nr-tabpre   = preco-item.nr-tabpre 
                   tt-itens-inativados.dt-inival   = preco-item.dt-inival 
                   tt-itens-inativados.cd-inativa  = 1 . 

            ASSIGN preco-item.situacao  = 2 .

             i = i + 1 .
        END.
        i = 0 .
    END.

END.
        
PUT UNFORMATTED "Itens inativados durante a importacao:" SKIP.
PUT "LISTA" AT 1
    "ITEM"  AT 10
    "DESC"  AT 30
    "DATA"  AT 50 SKIP.
FOR EACH tt-itens-inativados :
    PUT tt-itens-inativados.nr-tabpre   AT 1
        tt-itens-inativados.it-codigo   AT 10
        tt-itens-inativados.descricao-1 AT 30
        tt-itens-inativados.dt-inival   AT 50 SKIP.
END.
        


/*********************************/

IF l-ecommerce THEN
    RUN pi-processa-rpw-espdp096.

RUN pi-finalizar in h-acomp.


PROCEDURE pi-processa-rpw-espdp096:

    DEFINE VARIABLE p_cod_prog_dtsul_w                          AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_cod_prog_dtsul_rp                         AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_cod_release                               AS Character format "x(9)"       no-undo.
    DEFINE VARIABLE p_cdn_estil_dwb                             AS Integer   format ">>9"        no-undo.
    DEFINE VARIABLE p_arquivo                                   AS Character format "x(50)"      no-undo.
    DEFINE VARIABLE p_destino                                   AS integer   format "9"          no-undo.
    DEFINE VARIABLE p_raw_param                                 AS Raw                           no-undo.
    DEFINE VARIABLE c-servidor                                  AS CHARACTER                     NO-UNDO.
    DEFINE VARIABLE p_num_ped_exec                              AS integer   FORMAT ">>>>9"      no-undo.
    DEFINE VARIABLE raw-param                                   AS RAW.
    
    ASSIGN i-cont-aux = i-cont-aux + 1.

    FOR FIRST mgesp.ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "wso0003"
          AND ponto-programa.ponto         = 9,  
        FIRST mgesp.conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

       ASSIGN c-servidor = conteudo-programa.conteudo.

    END. /* FOR EACH mgesp.ponto-programa NO-LOCK */

    FOR EACH tt-param-espdp096:
        DELETE tt-param-espdp096.
    END.
    FOR EACH tt_param_segur:
        DELETE tt_param_segur.
    END.
    FOR EACH tt_ped_exec:
        DELETE tt_ped_exec.
    END.
    FOR EACH tt_ped_exec_param:
        DELETE tt_ped_exec_param.
    END.
    FOR EACH tt_ped_exec_param_aux:
        DELETE tt_ped_exec_param_aux.
    END.
    FOR EACH tt_ped_exec_sel:
        DELETE tt_ped_exec_sel.
    END.

    create tt-param-espdp096.
    assign tt-param-espdp096.usuario         = c-seg-usuario
           tt-param-espdp096.destino         = 2
           tt-param-espdp096.data-exec       = TODAY 
           tt-param-espdp096.hora-exec       = TIME
           tt-param-espdp096.fi-tab-ini      = ""
           tt-param-espdp096.fi-tab-fim      = "ZZZZZ"
           tt-param-espdp096.fi-item-ini     = ""
           tt-param-espdp096.fi-item-fim     = "ZZZZZ".

    ASSIGN tt-param-espdp096.arquivo = "espdp096_UNIX.tmp".

    RAW-TRANSFER tt-param-espdp096 TO raw-param.
    
    ASSIGN p_cod_prog_dtsul_w    = "espdp096"           
           p_cod_prog_dtsul_rp   = "esp/pdp/espdp096rp.p"
           p_cod_release         = '2.00.00.000'                    
           p_cdn_estil_dwb       = 97                   
           p_arquivo             = "espdp096.tmp" 
           p_destino             = 2                    
           p_raw_param           = raw-param.  

    create tt_param_segur.
    assign tt_param_segur.tta_num_vers_integr_api      = 3
           tt_param_segur.tta_cod_aplicat_dtsul_corren = "MFT"
           tt_param_segur.tta_cod_empres_usuar         = "1"
           tt_param_segur.tta_cod_grp_usuar_lst        = v_cod_grp_usuar_lst
           tt_param_segur.tta_cod_idiom_usuar          = "POR":U
           tt_param_segur.tta_cod_modul_dtsul_corren   = "MFT"
           tt_param_segur.tta_cod_pais_empres_usuar    = "BRA"
           tt_param_segur.tta_cod_usuar_corren         = v_cod_usuar_corren
           tt_param_segur.tta_cod_usuar_corren_criptog = v_cod_usuar_corren_criptog.

    create tt_ped_exec.
    assign tt_ped_exec.tta_num_seq                = i-cont-aux
           tt_ped_exec.tta_cod_usuario            = tt-param-espdp096.usuario
           tt_ped_exec.tta_cod_prog_dtsul         = p_cod_prog_dtsul_w 
           tt_ped_exec.tta_cod_prog_dtsul_rp      = p_cod_prog_dtsul_rp
           tt_ped_exec.tta_cod_release_prog_dtsul = p_cod_release      
           tt_ped_exec.tta_dat_exec_ped_exec      = today
           tt_ped_exec.tta_hra_exec_ped_exec      = replace(string(TIME,"HH:MM:SS"), ":", "")
           tt_ped_exec.tta_cod_servid_exec        = c-servidor
           tt_ped_exec.tta_cdn_estil_dwb          = 97.

    create tt_ped_exec_param.
    assign tt_ped_exec_param.tta_num_seq              = i-cont-aux
           tt_ped_exec_param.tta_cod_dwb_file         = "esp/pdp/espdp096rp.p"
           tt_ped_exec_param.tta_cod_dwb_output       = 'Arquivo'
           tt_ped_exec_param.tta_nom_dwb_printer      = p_arquivo.

    raw-transfer tt-param-espdp096       to tt_ped_exec_param.tta_raw_param_ped_exec.

    run btb/btb912zb.p (input-output table tt_param_segur,
                        input-output table tt_ped_exec,
                        input table tt_ped_exec_param,
                        input table tt_ped_exec_param_aux,
                        input table tt_ped_exec_sel).
    
END PROCEDURE.

RETURN "OK":U.
