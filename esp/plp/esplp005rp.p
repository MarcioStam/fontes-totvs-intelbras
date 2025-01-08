{include/i-prgvrs.i ESPLP005RP}  /*** 010001 ***/

{utp/ut-glob.i}

{esp/plp/esplp005tt.i}

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp            as handle  no-undo.

{cdp/cd0666.i} /* definiá∆o da temp-table de erros */   

form tt-erro.cd-erro "-"   
     tt-erro.mensagem format "x(117)"
     with width 132 frame f-erros stream-io. 

{utp/ut-liter.i Erro *}
assign tt-erro.cd-erro:label in frame f-erros = trim(return-value).

{utp/ut-liter.i Descriá∆o *}
assign tt-erro.mensagem:label in frame f-erros = trim(return-value).     

def stream s-entrada.
def var c-linha          as character.
def var i-cont           as integer.
def var l-cabec          as logical.
def var l-num-automatica as log initial no.
def var l-erro           as log.
def var c-text-aux       as char no-undo.
def var i-seq-aux        as int no-undo init 0.
DEFINE VARIABLE i-itens-plano AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-quantidade-plano AS DECIMAL     NO-UNDO.
def var c-cod-estab  like pl-prod.cod-estabel no-undo.
def var i-cd-plano   like pl-prod.cd-plano no-undo.
def var i-nr-per-ini like pl-prod.nr-per-ini no-undo.
def var i-nr-per-fim like pl-prod.nr-per-fim no-undo.
def var i-cd-tipo    like pl-prod.cd-tipo no-undo.
def var c-it-codigo  like item.it-codigo no-undo.
def var i-ano        like pl-it-prod.ano no-undo.
def var i-periodo    like pl-it-prod.periodo no-undo.
def var i-quantidade like pl-it-prod.quantidade no-undo.
def var i-seq        as int no-undo.
def var l-ok         as logical no-undo.
DEFINE VARIABLE v-tot-total-item AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-total-prod AS DECIMAL     NO-UNDO.

DEFINE TEMP-TABLE tt-totais NO-UNDO
    FIELD r-rowid-digita AS ROWID
    FIELD total-item     AS INT
    FIELD total-prod     AS DEC.                                

DEF BUFFER b-periodo FOR periodo.

DEF STREAM s-dest.
DEF VAR c-arq-csv AS CHAR NO-UNDO.

DEFINE TEMP-TABLE tt-plano NO-UNDO
    FIELD cEstab     AS CHAR   
    FIELD cItem      AS CHAR
    FIELD dData      AS DATE
    FIELD iQtde      AS INT
    INDEX idx-plano IS PRIMARY cEstab cItem dData.


/**** Inicio ****/   
for each tt-erro:
    delete tt-erro.
end.

run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Importaá∆o_de_plano *}
run pi-inicializar in h-acomp (input  Return-value ).

for each tt-raw-digita NO-LOCK:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.

end.

EMPTY TEMP-TABLE tt-plano.

/**********************************************************/
/*        IMPORTAR AS PLANILHAS CRIANDO A TT-PLANO        */
/**********************************************************/
FOR EACH tt-digita:
    /*RUN pi-acompanhar in h-acomp (INPUT tt-digita.exemplo).*/
    RUN pi-acompanhar in h-acomp (INPUT ENTRY(NUM-ENTRIES(tt-digita.exemplo,"/"), tt-digita.exemplo, "/")).
    
    RUN pi-excel (INPUT tt-digita.exemplo).
    
    IF  ERROR-STATUS:ERROR THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro = 17006
               tt-erro.mensagem = "Erro importando " + tt-digita.exemplo + CHR(13) + "Descriá∆o Erro: " + STRING(error-status:get-message(1)).
        LEAVE.
    END.

END.

/*Buscar per°odo do plano*/
 FIND FIRST pl-prod NO-LOCK
      where pl-prod.cd-plano   = tt-param.cod-plano NO-ERROR.

/****************************************************************/
/*        GRAVAR ARQUIVO CSV COM BASE NA TT-PLANO E             */
/*   ATUALIZAR A TABELA PL-IT-PROD COM OS DADOS IMPORTADOS      */
/****************************************************************/
IF  NOT CAN-FIND(FIRST tt-erro) THEN
    RUN pi-atualiza-tabela.

/*
if l-ok then do:
    find programa where programa.programa =  "esplp002"
         exclusive-lock no-error.  
    if not avail programa then do:
        create programa.
        assign programa.programa = "esplp002".
    end.
    if substring(programa.char-2,1,2) = "" then 
          assign programa.char-2 = string(today,"99/99/9999").
    else
          assign substring(programa.car-2,15,10) = string(today,"99/99/9999").

    assign programa.int-1 = programa.int-1 + 1.
end.
*/

{include/i-rpvar.i}
RUN utp/ut-trfrrp.p (input frame f-erros:handle).
{include/i-rpout.i &tofile=tt-param.arq-destino}

ASSIGN c-titulo-relat = "Importaá∆o Schedule Produá∆o"
       c-programa     = 'ESPLP005'.

{include/i-rpcab.i}

view FRAME f-cabec.
view FRAME f-rodape.    

FIND FIRST tt-erro NO-ERROR.
IF  AVAIL tt-erro THEN DO:

    FOR EACH tt-erro:
        PUT UNFORMATTED tt-erro.cd-erro " - " tt-erro.mensagem SKIP(2).
    END.

END.
ELSE DO:
    PUT UNFORMATTED "Importaá∆o executada com sucesso" SKIP (2) "Arquivo .CSV consolidado: "  c-arq-csv SKIP(2).

    PUT UNFORMATTED "Planilha" AT 1.
    PUT UNFORMATTED "Quantidade Itens" AT 92.
    PUT UNFORMATTED "Quantidade Produá∆o" AT 114 SKIP.

    FOR EACH tt-digita:

        PUT UNFORMATTED tt-digita.exemplo AT 1.

        FOR FIRST tt-totais
            WHERE tt-totais.r-rowid-digita = ROWID(tt-digita):
            PUT UNFORMATTED tt-totais.total-item AT 92.
            PUT UNFORMATTED tt-totais.total-prod AT 114.

            ASSIGN v-tot-total-item = v-tot-total-item + tt-totais.total-item
                   v-tot-total-prod = v-tot-total-prod + tt-totais.total-prod.
        END.

        PUT SKIP.
    END.

    PUT UNFORMATTED "TOTAL: " AT 82.
    PUT UNFORMATTED v-tot-total-item AT 92.
    PUT UNFORMATTED v-tot-total-prod AT 114.

    PUT SKIP(2).

    PUT UNFORMATTED "Itens Gravados no Plano: " + string(i-itens-plano) + "     " + "Quantidade Itens Gravada Plano: " + string(i-quantidade-plano) SKIP (1).

    PUT SKIP(2).

    PUT UNFORMATTED "Elimina itens do plano?: " IF tt-param.log-elimina-itens THEN "Sim" ELSE "N∆o".
END.
    
{include/i-rpclo.i}

OS-COMMAND NO-WAIT notepad VALUE(tt-param.arq-destino).


run pi-finalizar in h-acomp.

PROCEDURE pi-atualiza-tabela:
    DEF VAR da-ini AS DATE NO-UNDO.
    DEF VAR da-fim AS DATE NO-UNDO.

    ASSIGN c-arq-csv = tt-param.c-arquivo-csv +
                      (IF SUBSTR(tt-param.c-arquivo-csv,LENGTH(tt-param.c-arquivo-csv),1) = "/" OR SUBSTR(tt-param.c-arquivo-csv,LENGTH(tt-param.c-arquivo-csv),1) = "\" 
                       THEN ""
                       ELSE "/") + "plano_" + c-seg-usuario + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv"
           c-arq-csv = REPLACE(c-arq-csv, "\", "/").
    
    OUTPUT STREAM s-dest TO value(c-arq-csv).

    FIND pl-prod
        WHERE pl-prod.cd-plano = tt-param.cod-plano NO-LOCK NO-ERROR.
    
    RUN pi-retorna-datas (OUTPUT da-ini,
                          OUTPUT da-fim).
    
    /* Eliminaá∆o itens */
    IF tt-param.log-elimina-itens THEN DO:
        FOR EACH pl-it-prod EXCLUSIVE-LOCK
            WHERE pl-it-prod.cd-plano    = tt-param.cod-plano
              AND pl-it-prod.cod-estabel = tt-param.cod-estabel:
              DELETE pl-it-prod.
        END.
    END.

    bloco:
    DO TRANS /*on error undo, leave           
       on stop undo, leave transaction*/:
        
        FOR EACH tt-plano
            WHERE tt-plano.iQtde <> 0
            BREAK BY tt-plano.cItem:

            IF LAST-OF (tt-plano.cItem) THEN
                ASSIGN i-itens-plano = i-itens-plano + 1.
    
            /*Verificar se a data importada Ç valida em relaá∆o ao per°odo do plano*/
            IF  NOT(tt-plano.dData >= da-ini AND tt-plano.dData <= da-fim)
            THEN DO:
                 create tt-erro.
                 assign tt-erro.cd-erro = 15825
                        tt-erro.mensagem = "Informacoes contraditorias." + 
                                           "Verifique:" + 
                                           "- se o plano esta cadastrado;" + 
                                           "- se o periodo inicial e final estao corretos;" + 
                                           "- se o tipo de plano esta correto.".

                UNDO bloco, LEAVE bloco.

            END.
    
            /* Exporta para CSV */
            PUT STREAM s-dest UNFORMATTED tt-plano.cEstab ";"
                                          tt-plano.cItem  ";"
                                          tt-plano.dData  ";"
                                          tt-plano.iQtde  SKIP.
        
        
            FIND ITEM 
                WHERE item.it-codigo = tt-plano.cItem NO-LOCK NO-ERROR.
    
            IF  NOT AVAIL ITEM THEN DO:
                CREATE tt-erro.
                ASSIGN tt-erro.cd-erro = 15825
                       tt-erro.mensagem = "Item " + tt-plano.cItem + " n∆o cadastrado".
                UNDO bloco, LEAVE bloco.                                       
            end.
        
            FIND FIRST periodo
                where periodo.cd-tipo     = pl-prod.cd-tipo
                  and periodo.dt-termino >= tt-plano.dData NO-LOCK no-error.
        
            IF  NOT AVAIL periodo THEN
                FIND LAST periodo
                    WHERE periodo.cd-tipo     = pl-prod.cd-tipo
                      AND periodo.dt-termino <= tt-plano.dData NO-LOCK NO-ERROR.
        
            IF  AVAIL periodo THEN DO:
                FIND pl-it-prod EXCLUSIVE-LOCK
                      WHERE pl-it-prod.cod-estabel = tt-plano.cEstab
                        AND pl-it-prod.cd-plano    = tt-param.cod-plano
                        AND pl-it-prod.it-codigo   = tt-plano.cItem
                        AND pl-it-prod.ano         = periodo.ano        
                        AND pl-it-prod.periodo     = periodo.nr-periodo  NO-ERROR.
    
                IF  NOT AVAIL pl-it-prod THEN DO:
                    CREATE pl-it-prod.
                    ASSIGN pl-it-prod.cod-estabel = tt-plano.cEstab
                           pl-it-prod.cd-plano    = tt-param.cod-plano
                           pl-it-prod.it-codigo   = tt-plano.cItem
                           pl-it-prod.ano         = periodo.ano
                           pl-it-prod.periodo     = periodo.nr-periodo
                           pl-it-prod.dt-termino  = periodo.dt-termino.     
                END.
                    
                ASSIGN pl-it-prod.quantidade = pl-it-prod.quantidade + tt-plano.iQtde
                       i-quantidade-plano    = i-quantidade-plano + tt-plano.iQtde.
    
            END.
            ELSE DO:
                CREATE tt-erro.
                ASSIGN tt-erro.cd-erro = 17006
                       tt-erro.mensagem = "N∆o encontrado per°odo para Item " + tt-plano.cItem + ", Data " + STRING(tt-plano.dData).
                UNDO bloco, LEAVE bloco. 
            END.
    
        END.
    END.
    OUTPUT STREAM s-dest CLOSE.
END.


PROCEDURE pi-excel:

    DEF INPUT PARAM p-arquivo AS CHAR FORMAT "x(60)" NO-UNDO.

    define variable iLinha    as integer         no-undo.
    define variable ExcelAppl as com-handle      no-undo.
    define variable iCodEstab as CHAR            no-undo.
    define variable iCodItem  as CHAR            no-undo.
    DEF VAR c-coluna-valor    AS CHAR EXTENT 256 NO-UNDO.
    DEF VAR c-coluna          AS CHAR EXTENT 256 NO-UNDO
    INITIAL ["A","B","C","D","E","F","G","H","I","J","K","L","M",
    "N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
    "AA","AB","AC","AD","AE","AF","AG","AH","AI","AJ","AK","AL","AM",
    "AN","AO","AP","AQ","AR","AS","AT","AU","AV","AW","AX","AY","AZ",
    "BA","BB","BC","BD","BE","BF","BG","BH","BI","BJ","BK","BL","BM",
    "BN","BO","BP","BQ","BR","BS","BT","BU","BV","BW","BX","BY","BZ",
    "CA","CB","CC","CD","CE","CF","CG","CH","CI","CJ","CK","CL","CM",
    "CN","CO","CP","CQ","CR","CS","CT","CU","CV","CW","CX","CY","CZ",
    "DA","DB","DC","DD","DE","DF","DG","DH","DI","DJ","DK","DL","DM",
    "DN","DO","DP","DQ","DR","DS","DT","DU","DV","DW","DX","DY","DZ",
    "EA","EB","EC","ED","EE","EF","EG","EH","EI","EJ","EK","EL","EM",
    "EN","EO","EP","EQ","ER","ES","ET","EU","EV","EW","EX","EY","EZ",
    "FA","FB","FC","FD","FE","FF","FG","FH","FI","FJ","FK","FL","FM",
    "FN","FO","FP","FQ","FR","FS","FT","FU","FV","FW","FX","FY","FZ",
    "GA","GB","GC","GD","GE","GF","GG","GH","GI","GJ","GK","GL","GM",
    "GN","GO","GP","GQ","GR","GS","GT","GU","GV","GW","GX","GY","GZ",
    "HA","HB","HC","HD","HE","HF","HG","HH","HI","HJ","HK","HL","HM",
    "HN","HO","HP","HQ","HR","HS","HT","HU","HV","HW","HX","HY","HZ",
    "IA","IB","IC","ID","IE","IF","IG","IH","II","IJ","IK","IL","IM",
    "IN","IO","IP","IQ","IR","IS","IT","IU","IV"].
    
    /* Criar bloco para ler vˇrias planilhas, cada planilha lida terˇ o tratamento abaixo */
    
    create "Excel.Application" excelAppl.

    excelAppl:Workbooks:open( p-arquivo ).
    
    excelAppl:visible        = false.
    excelAppl:displayalerts  = false.
    excelAppl:ScreenUpdating = false.
    
    DEFINE VARIABLE i-item AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iFim AS INTEGER     NO-UNDO.
    
    /* Posicionar a Aba "Master Schedule" */
    DO i-item = 1 TO 200:
        excelappl:worksheets:ITEM(i-item):SELECT.
        IF excelappl:worksheets:ITEM(i-item):NAME = "Master Schedule" THEN LEAVE.
    END.
    
    /* Caso nío tenha a Aba abortar a importaªío */
    IF excelappl:worksheets:ITEM(i-item):NAME <> "Master Schedule" 
    THEN DO: 
         CREATE tt-erro.
         ASSIGN tt-erro.cd-erro = 17006
                tt-erro.mensagem = "planilha " + p-arquivo + "  n∆o possui Aba Master Schedule para importaá∆o".

         excelAppl:VISIBLE = FALSE.
         release object excelAppl.
         RETURN.
    END.

    CREATE tt-totais.
    ASSIGN tt-totais.r-rowid-digita = ROWID(tt-digita).
    
    /*Evitar timeout*/
    FIND FIRST estabelec NO-LOCK NO-ERROR.

    iLinha = 0.
    repeat:
    
        iLinha    = iLinha + 1.
        iCodEstab = excelAppl:Range("A" + string(ilinha)):value no-error.
        iCodItem  = excelAppl:Range("B" + string(ilinha)):value no-error.
    
        /* Controle para nío ter que ler o arquivo excel at≤ o final caso nío tenha mais itens para importar */
        IF iCodEstab = "" 
        OR iCodEstab = ? 
        THEN DO:
             ASSIGN iFim = iFim + 1.
             IF iFim = 10 THEN LEAVE. 
             NEXT.
        END.
        ASSIGN iFim = 0.
    
        /* Monta lista com as datas do cabeªalho. Elas podem ser diferentes de planilha para planilha */
        IF iLinha = 1 
        THEN DO:
             DO i-item = 4 TO 256:
                /* Controle para nío precisar ler todas as colunas, parando na última que possua valor */
                excelappl:range(STRING(c-coluna[i-item]) + STRING(iLinha)):numberformat =  "@". /* texto */
                IF excelappl:range(STRING(c-coluna[i-item]) + STRING(iLinha)):VALUE = "" 
                OR excelappl:range(STRING(c-coluna[i-item]) + STRING(iLinha)):VALUE = "0" 
                OR excelappl:range(STRING(c-coluna[i-item]) + STRING(iLinha)):VALUE = ?
                   THEN LEAVE.
                c-coluna-valor[i-item] = excelappl:range(STRING(c-coluna[i-item]) + STRING(iLinha)):VALUE NO-ERROR.
             END.
        END.
        /* lº a matriz para criar a temp-table */
        ELSE DO:
             RUN pi-acompanhar in h-acomp (INPUT SUBSTRING(ENTRY(NUM-ENTRIES(tt-digita.exemplo,"/"), tt-digita.exemplo, "/"),1,30) + " Item: " + string(int(iCodItem))).
             ASSIGN tt-totais.total-item = tt-totais.total-item + 1.
             DO i-item = 4 TO 256:
                /* Controle para nío precisar ler todas as colunas, parando na última que possua valor */
                excelappl:range(STRING(c-coluna[i-item]) + STRING(iLinha)):numberformat =  "@". /* texto */
                IF excelappl:range(STRING(c-coluna[i-item]) + STRING(iLinha)):VALUE = "" 
                OR excelappl:range(STRING(c-coluna[i-item]) + STRING(iLinha)):VALUE = ?
                   THEN LEAVE.
                FIND FIRST tt-plano NO-LOCK
                    WHERE tt-plano.cEstab = string(int(iCodEstab))
                      AND tt-plano.cItem  = string(int(iCodItem))
                      AND tt-plano.dData  = DATE(INT(c-coluna-valor[i-item]) + 2415020) NO-ERROR.
                IF NOT AVAIL tt-plano 
                THEN DO:
                    CREATE tt-plano.
                    ASSIGN tt-plano.cEstab = string(int(iCodEstab))
                           tt-plano.cItem  = string(int(iCodItem))
                           tt-plano.dData  = DATE(INT(c-coluna-valor[i-item]) + 2415020).
                END.
                ASSIGN tt-plano.iQtde = tt-plano.iQtde + INT(excelappl:range(STRING(c-coluna[i-item]) + STRING(iLinha)):VALUE).
                ASSIGN tt-totais.total-prod = tt-totais.total-prod + tt-plano.iQtde.
    
             END.
    
        END.
    
        /* somar na data retornada 2415020, que ≤ o numerico correspondente π 30/12/1899. O excel sΩ reconhece datas a partir de 01/01/1900, e o progress comeªa em 01/01/0001 
        MESSAGE DATE(43313 + 2415020) INT(12/30/1899)
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        */
    
    end.
    excelAppl:ActiveWorkbook:close(true).
    excelAppl:Quit() no-error.
    
    /*excelAppl:VISIBLE = TRUE.*/
    release object excelAppl.
    
END.

PROCEDURE pi-retorna-datas:
    DEF OUTPUT PARAM p-data-ini AS DATE NO-UNDO.
    DEF OUTPUT PARAM p-data-fim AS DATE NO-UNDO.


    FIND periodo NO-LOCK
        WHERE periodo.cd-tipo = 1
          AND periodo.nr-periodo = pl-prod.nr-per-ini
          AND periodo.ano        = pl-prod.ano-per-ini.

    FIND b-periodo NO-LOCK
        WHERE b-periodo.cd-tipo = 1
          AND b-periodo.nr-periodo = pl-prod.nr-per-fim
          AND b-periodo.ano        = pl-prod.ano-per-fim.


   IF  AVAIL periodo THEN
       ASSIGN p-data-ini = periodo.dt-inicio.
   IF  AVAIL b-periodo THEN
       ASSIGN p-data-fim = b-periodo.dt-termino.

END.

return "OK".


