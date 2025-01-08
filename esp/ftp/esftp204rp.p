{include/i-prgvrs.i esftp202RP 2.00.00.000}
{include/i-rpvar.i}
{utp/ut-glob.i}
{esp/es0018.i}

define temp-table tt-param
    field destino           as integer
    field arq-destino       as char
    field arq-entrada       as char
    field todos             as integer
    field usuario           as char
    field data-exec         as date
    field hora-exec         as integer
    FIELD import-excluir    AS INT
    FIELD cod-executivo-ini AS INT
    FIELD cod-executivo-fim AS INT
    FIELD periodo-mes       AS INT
    FIELD periodo-ano       AS INT.

def temp-table tt-raw-digita
   field raw-digita      as raw.

DEF TEMP-TABLE tt-erro
    FIELD mensagem AS CHAR.

DEF TEMP-TABLE tt-sucesso
    FIELD mensagem AS CHAR.

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

DEF STREAM s-imp.
DEF STREAM s-exp.
DEF VAR h-acomp          AS HANDLE NO-UNDO.
DEF VAR c-linha          AS CHAR NO-UNDO.
DEF VAR i-codigo         AS INT. 
DEF VAR c-cod-unid-negoc AS CHAR. 
DEF VAR i-cod-segmento   AS INT. 
DEF VAR i-cod-emitente   AS INT.
DEF VAR c-it-codigo      AS CHAR.
DEF VAR d-dt-venda       AS DATE.
DEF VAR d-qt-vendida     AS DEC.
DEF VAR d-vl-vendida     AS DEC.
DEF VAR c-periodo        AS CHAR.
DEF VAR c-dir-saida      AS CHAR.
DEF VAR c-arq-lst      AS CHAR.
DEF VAR c-arquivo-lst    AS CHAR.

{include/i-rpout.i &STREAM="stream str-rp" &TOFILE=tt-param.arq-destino}
{include/i-rpcab.i &STREAM="str-rp"}

ASSIGN c-programa 	  = "esftp202RP"
       c-titulo-relat = "Importa‡Æo de metas".

VIEW STREAM str-rp FRAME f-cabec.
VIEW STREAM str-rp FRAME f-rodape.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Importando").

/*Importar*/
IF tt-param.import-excluir = 1 THEN DO:
    
    INPUT STREAM s-imp FROM VALUE(tt-param.arq-entrada).

    blk_import:
    REPEAT ON STOP UNDO, LEAVE:
    	IMPORT STREAM s-imp UNFORMATTED c-linha.
    	RUN pi-acompanhar IN h-acomp (INPUT c-linha).

        IF c-linha = "" THEN
            NEXT.
    
        ASSIGN i-codigo          = INT(ENTRY(1,c-linha,";")) 
               c-cod-unid-negoc  = ENTRY(2,c-linha,";")
               i-cod-segmento    = INT(ENTRY(3,c-linha,";"))
               i-cod-emitente    = INT(ENTRY(4,c-linha,";"))    
               c-it-codigo       = ENTRY(5,c-linha,";")         
               d-dt-venda        = DATE(ENTRY(6,c-linha,";"))   
               d-qt-vendida      = DEC(ENTRY(7,c-linha,";"))    
               d-vl-vendida      = DEC(ENTRY(8,c-linha,";")).
    
        FIND FIRST int-param-comis NO-LOCK
             WHERE int-param-comis.dt-periodo-ini <= d-dt-venda
               AND int-param-comis.dt-periodo-fim >= d-dt-venda
               AND int-param-comis.idi-status = 1 NO-ERROR.
    
        IF NOT AVAIL int-param-comis THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "NÆo encontrado parƒmetros de comissÆo para a data: " + STRING(d-dt-venda).
    
            NEXT blk_import.
        END.
    
        IF NOT CAN-FIND (FIRST int-executivo 
                         WHERE int-executivo.cod-executivo = i-codigo)  THEN DO:
    
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "NÆo encontrado executivo: " + STRING(i-codigo).
    
            NEXT blk_import.
        END.
    
        IF NOT CAN-FIND (FIRST unid_negoc
                         WHERE unid_negoc.cod_unid_negoc = c-cod-unid-negoc) THEN DO:
    
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "NÆo encontrada Unidade de Neg¢cio: " + c-cod-unid-negoc.
    
            NEXT blk_import.
        END.
    
        IF NOT CAN-FIND (FIRST fam-comerc
                         WHERE SUBSTRING(fam-comerc.fm-cod-com,1,4) = string(i-cod-segmento))  THEN DO:
            
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "NÆo encontrada familia comercial: " + string(i-cod-segmento).
    
            NEXT blk_import.
        END.
    
        IF NOT CAN-FIND (FIRST emitente
                         WHERE emitente.cod-emitente = i-cod-emitente) THEN DO:
    
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "NÆo encontrado cliente: " + string(i-cod-emitente).
    
            NEXT blk_import.
        END.
    
        IF NOT CAN-FIND (FIRST ITEM
                         WHERE ITEM.it-codigo = c-it-codigo)
        AND c-it-codigo <> "*" THEN DO:
    
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "NÆo encontrado item: " + c-it-codigo.
    
            NEXT blk_import.
        END.
                
        CREATE int-sell-out.
        ASSIGN int-sell-out.codigo         = i-codigo
               int-sell-out.cod-unid-negoc = c-cod-unid-negoc
               int-sell-out.cod-segmento   = i-cod-segmento
               int-sell-out.cod-emitente   = i-cod-emitente
               int-sell-out.it-codigo      = c-it-codigo   
               int-sell-out.dt-venda       = d-dt-venda    
               int-sell-out.qt-vendida     = d-qt-vendida  
               int-sell-out.vl-vendida     = d-vl-vendida  
               int-sell-out.periodo-mes    = int-param-comis.periodo-mes
               int-sell-out.periodo-ano    = int-param-comis.periodo-ano
               int-sell-out.idi-tipo       = 1.
    
        CREATE tt-sucesso.
        ASSIGN tt-sucesso.mensagem = "Importado SellOut Executivo: " + STRING(int-sell-out.codigo) + " Cliente: " + STRING(int-sell-out.cod-emitente) + " Periodo: " + string(int-param-comis.periodo-mes) + "/" +  string(int-param-comis.periodo-ano).
    	
    END.
    
    INPUT STREAM s-imp CLOSE.
    
    FOR EACH tt-sucesso:
        PUT STREAM str-rp UNFORMATTED tt-sucesso.mensagem SKIP.
    END.
    
    PUT STREAM str-rp SKIP(3).
    
    FOR EACH tt-erro:
        PUT STREAM str-rp UNFORMATTED tt-erro.mensagem SKIP.
    END.
END.
/*Excluir*/
ELSE DO:
    ASSIGN c-arquivo-lst = "ESFTP204_" + STRING(TIME) + ".lst":U.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-lst = c-dir-saida + TRIM(c-arquivo-lst).
    END. 
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-lst = c-dir-saida + TRIM(c-arquivo-lst).
    END.

    OUTPUT STREAM s-exp TO value(c-arq-lst) NO-CONVERT.

    FOR EACH int-sell-out EXCLUSIVE-LOCK
       WHERE int-sell-out.periodo-mes = tt-param.periodo-mes
         AND int-sell-out.periodo-ano = tt-param.periodo-ano
         AND int-sell-out.codigo >= tt-param.cod-executivo-ini
         AND int-sell-out.codigo <= tt-param.cod-executivo-fim:

        RUN pi-acompanhar IN h-acomp (INPUT "Excluindo SellOut " + STRING(int-sell-out.codigo)).

        PUT STREAM s-exp UNFORMATTED  STRING(int-sell-out.codigo)       + ";" +
                                      int-sell-out.cod-unid-negoc       + ";" +
                                      STRING(int-sell-out.cod-segmento) + ";" +
                                      STRING(int-sell-out.cod-emitente) + ";" +
                                      int-sell-out.it-codigo            + ";" +
                                      STRING(int-sell-out.dt-venda)     + ";" +
                                      STRING(int-sell-out.qt-vendida)   + ";" +
                                      STRING(int-sell-out.vl-vendida) SKIP. 

        DELETE int-sell-out.
    END.

    OUTPUT STREAM s-exp CLOSE.

    PUT STREAM str-rp UNFORMATTED "Registros exclu¡dos com sucesso!" SKIP.

    RUN utp/ut-msgs.p (INPUT "msg",
                       INPUT 15825,
                       INPUT "Arquivo de backup gerado: " + replace(c-arq-lst,"/", "\")).
    
    PUT STREAM str-rp UNFORMATTED RETURN-VALUE SKIP.
    
END.

{include/i-rpclo.i &STREAM="stream str-rp"}

RUN pi-finalizar IN h-acomp.

RETURN "OK".

