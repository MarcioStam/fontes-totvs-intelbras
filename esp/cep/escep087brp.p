/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i escep087brp 3.00.00.000 }

define temp-table tt-param
    field destino          as integer
    field arq-destino      as char
    field arq-entrada      as char
    field todos            as integer
    field usuario          as char
    field data-exec        as date
    field hora-exec        as integer
    field rs-tipo          as integer
    field rs-tabela        as integer.

def temp-table tt-raw-digita NO-UNDO
    field raw-digita as raw.

DEFINE TEMP-TABLE ttPV NO-UNDO
    FIELD dtData        AS CHARACTER
    FIELD codItem       LIKE int-item-estab-depos-pv.it-codigo 
    FIELD quantidade    LIKE int-item-estab-depos-pv.quant-previsao-venda[1]
    FIELD cOrigem       AS CHARACTER
    FIELD vlPrecoMedio  AS DECIMAL
    FIELD codEstabel    LIKE int-item-estab-depos-pv.cod-estabel
    FIELD codDepos      LIKE int-item-estab-depos-pv.cod-depos
    INDEX idx dtData coditem.

{cdp/cd0666.i}

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

def var c-impressao     as char     format "x(09)"      no-undo.
def var c-destino       as char     format "x(10)"      no-undo.
def var c-erro          as char                         no-undo.
def var c-erro1         as char                         no-undo.
def var h-acomp         as handle                       no-undo.
def var cLinha          as char                         no-undo.
def var cEstab          as char                         no-undo.
def var cDepos          as char                         no-undo.
def var cItem           as char                         no-undo.
def var i-aux           as int                          no-undo.


DEF STREAM stExp.
DEF STREAM stImp.

create tt-param.
raw-transfer raw-param to tt-param.

form 
    skip(2)
    c-impressao        no-label colon 45 
    skip(1)
    "Arquivo Exportado/Importado"  colon 45
    "-" tt-param.arq-entrada    format "X(50)"   no-label
    skip(1)
    tt-param.usuario            colon 60
    with stream-io down width 132 side-labels frame f-det.

run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Processando * r}
run pi-inicializar in h-acomp (input trim(return-value)).

{include/i-rpvar.i}
DEFINE NEW GLOBAL SHARED VARIABLE v_cdn_empres_usuar            AS CHARACTER    NO-UNDO.

find first mguni.empresa
     where empresa.ep-codigo = v_cdn_empres_usuar no-lock no-error.
if avail empresa then
    assign c-empresa = empresa.razao-social.
else
    assign c-empresa = "".

{utp/ut-liter.i "Exportaá∆o/Importaá∆o de Itens" * L}
assign c-titulo-relat = trim(return-value).

{include/i-rpcab.i}
{include/i-rpout.i &tofile=tt-param.arq-destino}

view frame f-cabec.
view frame f-rodape.

IF  tt-param.rs-tipo = 1
THEN DO:
    RUN piExporta.
END.
ELSE DO:
    RUN piImporta.
END.

{utp/ut-liter.i IMPRESS«O * r}
assign c-impressao = trim(return-value).
{utp/ut-liter.i Usu†rio * r}
assign tt-param.usuario:label in frame f-det = trim(return-value).


disp c-impressao
     tt-param.arq-entrada
     tt-param.usuario
     with frame f-det.

run pi-finalizar in h-acomp.

{include/i-rpclo.i}

return "OK".

/*=======================================================================================================================================*/
PROCEDURE piExporta:
    DEFINE VARIABLE iCont   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cData   AS CHARACTER   NO-UNDO.

    OUTPUT STREAM stExp TO VALUE(tt-param.arq-entrada).

    IF tt-param.rs-tabela = 1   //itens
    THEN DO:
        PUT STREAM stExp UNFORMATTED
            "Item_CD_Item;Estabelecimento_CD_Estabelecimento_Origem;Estabelecimento_CD_Estabelecimento;Politica_Estoque_TX_ABC;Politica_Estoque_QT_Seguranca;Politica_Estoque_QT_Politica;"
            "Deposito_Ressuprimento;Log_Estoque_minimo;QT_Estoque_Minimo;Politica_Tipo_Estoque_Seguranca;Politica_Tempo_Seguranca"
            SKIP.

        FOR EACH int-item-estab-depos NO-LOCK:
            FOR FIRST int-estabel-origem-ressup 
                WHERE int-estabel-origem-ressup.cod-estabel-ressup = int-item-estab-depos.cod-estabel.
                PUT STREAM stExp UNFORMATTED
                    int-item-estab-depos.it-codigo 
                    ";"
                    int-estabel-origem-ressup.cod-estabel-origem
                    ";"
                    int-estabel-origem-ressup.cod-estabel-ressup
                    ";"
                    int-item-estab-depos.classif-abc 
                    ";"
                    int-item-estab-depos.quant-segur
                    ";"
                    int-item-estab-depos.politica 
                    ";"
                    int-item-estab-depos.cod-depos
                    ";"
                    int-item-estab-depos.log-estoq-minimo
                    ";"
                    int-item-estab-depos.estoque-minimo
                    ";"
                    int-item-estab-depos.tipo-est-seg
                    ";"
                    int-item-estab-depos.tempo-segur 
                    SKIP.
            END.
        END.
    END.




    IF tt-param.rs-tabela = 2   //Previsao de Vendas
    THEN DO:
        FOR EACH int-item-estab-depos-pv NO-LOCK:
            DO iCont = 1 TO 12:
                ASSIGN cData = "01/" + STRING(iCont,"99") + "/" + STRING(int-item-estab-depos-pv.ano, "9999").
                CREATE  ttPV.
                ASSIGN  ttPV.dtData         = cData
                        ttPV.codItem        = int-item-estab-depos-pv.it-codigo
                        ttPV.quantidade     = int-item-estab-depos-pv.quant-previsao-venda[iCont] 
                        ttPV.cOrigem        = ""
                        ttPV.vlPrecoMedio   = 0
                        ttPV.codEstabel     = int-item-estab-depos-pv.cod-estabel
                        ttPV.codDepos       = int-item-estab-depos-pv.cod-depos.
            END.
        END.
        PUT STREAM stExp UNFORMATTED
            "Referencia;Mes;Item;Qtd PV;Origem;Preáo mÇdio;Estabelecimento_Ressuprimento;Deposito_Ressuprimento"
            SKIP.

        FOR EACH ttPV.
            PUT STREAM stExp UNFORMATTED
                ttPV.dtData
                ";"
                ttPV.dtData
                ";"
                ttPV.codItem 
                ";"
                ttPV.quantidade
                ";"
                ttPV.cOrigem
                ";"
                ttPV.vlPrecoMedio
                ";"
                ttPV.codEstabel
                ";"
                ttPV.codDepos
                SKIP.
        END.
    END.
    OUTPUT STREAM stExp CLOSE.
END PROCEDURE.

PROCEDURE piImporta:
    DEFINE VARIABLE dtData AS DATE        NO-UNDO.

    IF tt-param.rs-tabela = 1   //itens
    THEN DO:
        INPUT STREAM stImp FROM VALUE(tt-param.arq-entrada).
        REPEAT:
            IMPORT STREAM stImp UNFORMATTED cLinha.
    
            IF cLinha = "" THEN NEXT.
            IF INDEX(cLinha,"Item_CD_Item") > 0 THEN NEXT.

            PUT UNFORMATTED "Linha:" cLinha SKIP.

            blk_import:
            DO  ON ERROR    undo blk_import, leave blk_import
                ON QUIT     undo blk_import, leave blk_import
                ON STOP     undo blk_import, leave blk_import
                ON ENDKEY   undo blk_import, leave blk_import:
    
                ASSIGN i-aux = i-aux + 1.
                run pi-acompanhar in h-acomp (input string(i-aux)).
    
                //Importando Item
                ASSIGN  cItem   = TRIM(ENTRY(01,cLinha,";"))    //Item_CD_Item
                        cEstab  = TRIM(ENTRY(03,cLinha,";"))    //Estabelecimento_CD_Estabelecimento
                        cDepos  = TRIM(ENTRY(07,cLinha,";"))    //Deposito_Ressuprimento
                    .
                FIND FIRST int-item-estab-depos
                     WHERE int-item-estab-depos.cod-estabel = cEstab
                       AND int-item-estab-depos.cod-depos   = cDepos
                       AND int-item-estab-depos.it-codigo   = cItem
                    EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAIL int-item-estab-depos
                THEN DO:
                    CREATE  int-item-estab-depos.
                    ASSIGN  int-item-estab-depos.cod-estabel        = cEstab
                            int-item-estab-depos.cod-depos          = cDepos
                            int-item-estab-depos.it-codigo          = cItem.
                END.
                ASSIGN  int-item-estab-depos.politica           = TRIM(ENTRY(06,cLinha,";"))
                        int-item-estab-depos.classif-abc        = TRIM(ENTRY(04,cLinha,";"))
                        int-item-estab-depos.log-estoq-minimo   = IF TRIM(ENTRY(08,cLinha,";")) = "NO" THEN NO ELSE TRUE
                        int-item-estab-depos.estoque-minimo     = DEC(TRIM(ENTRY(09,cLinha,";")))
                        int-item-estab-depos.tipo-est-seg       = INT(TRIM(ENTRY(10,cLinha,";")))
                        int-item-estab-depos.quant-segur        = DEC(TRIM(ENTRY(05,cLinha,";")))
                        int-item-estab-depos.tempo-segur        = INT(TRIM(ENTRY(11,cLinha,";"))).
            END.
        END.
        INPUT STREAM stImp CLOSE.
    END.
    IF tt-param.rs-tabela = 2   //Previsao de Vendas
    THEN DO:
        INPUT STREAM stImp FROM VALUE(tt-param.arq-entrada).
        REPEAT:
            IMPORT STREAM stImp UNFORMATTED cLinha.
    
            IF cLinha = "" THEN NEXT.
            IF INDEX(cLinha,"Referencia") > 0 THEN NEXT.
    
            PUT UNFORMATTED "Linha:" cLinha SKIP.
    
            blk_import:
            DO  ON ERROR    undo blk_import, leave blk_import
                ON QUIT     undo blk_import, leave blk_import
                ON STOP     undo blk_import, leave blk_import
                ON ENDKEY   undo blk_import, leave blk_import:
    
                assign i-aux = i-aux + 1.
                run pi-acompanhar in h-acomp (input string(i-aux)).
    
                //Importando Previs∆o Vendas
                ASSIGN  cEstab  = TRIM(ENTRY(07,cLinha,";"))
                        cDepos  = TRIM(ENTRY(08,cLinha,";"))
                        cItem   = TRIM(ENTRY(03,cLinha,";"))
                        dtData  = DATE(ENTRY(02,cLinha,";"))
                    .
                IF NOT CAN-FIND(FIRST int-item-estab-depos
                                WHERE int-item-estab-depos.cod-estabel = cEstab
                                  AND int-item-estab-depos.cod-depos   = cDepos
                                  AND int-item-estab-depos.it-codigo   = cItem)
                THEN DO:
                    PUT UNFORMATTED "N∆o encontrado cadastro do Estab/Dep/Item :" cItem "/" cDepos "/" cItem  "  (" cLinha " )" SKIP(1).
                    NEXT.
                END.
                FIND FIRST int-item-estab-depos-pv
                     WHERE int-item-estab-depos-pv.cod-estabel = cEstab
                       AND int-item-estab-depos-pv.cod-depos   = cDepos
                       AND int-item-estab-depos-pv.it-codigo   = cItem
                       AND int-item-estab-depos-pv.ano         = YEAR(dtData)
                    EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAIL int-item-estab-depos-pv
                THEN DO:
                    CREATE  int-item-estab-depos-pv.
                    ASSIGN  int-item-estab-depos-pv.cod-estabel                 = cEstab
                            int-item-estab-depos-pv.cod-depos                   = cDepos
                            int-item-estab-depos-pv.it-codigo                   = cItem
                            int-item-estab-depos-pv.ano                         = YEAR(dtData).
                END.
                ASSIGN int-item-estab-depos-pv.quant-previsao-venda[MONTH(dtData)] = DEC(TRIM(ENTRY(04,cLinha,";"))).
            END.
        END.
        INPUT STREAM stImp CLOSE.
    END.
    
END PROCEDURE.



