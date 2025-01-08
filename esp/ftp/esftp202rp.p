{include/i-prgvrs.i esftp202RP 2.00.00.000}
{include/i-rpvar.i}
{esp/es0018.i}
{utp/ut-glob.i}

define temp-table tt-param
    field destino          as integer
    field arq-destino      as char
    field arq-entrada      as char
    field todos            as integer
    field usuario          as char
    field data-exec        as date
    field hora-exec        as integer
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
DEF VAR h-acomp       AS HANDLE NO-UNDO.
DEF VAR c-linha       AS CHAR NO-UNDO.
DEF VAR i-ano         AS INT.
DEF VAR i-mes         AS INT.
DEF VAR i-executivo   AS INT.
DEF VAR c-unid-negoc  AS CHAR.
DEF VAR i-segmento    AS INT.
DEF VAR i-cliente     AS INT.
DEF VAR c-item        AS CHAR.
DEF VAR d-valor       AS DEC.
DEF VAR c-arquivo-lst AS CHAR.
DEF VAR c-dir-saida   AS CHAR.
DEF VAR c-arq-lst     AS CHAR.

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
    
        ASSIGN i-ano        = int(ENTRY(1,c-linha,";"))   
               i-mes        = int(ENTRY(2,c-linha,";"))   
               i-executivo  = INT(ENTRY(3,c-linha,";"))   
               c-unid-negoc = ENTRY(4,c-linha,";")        
               i-segmento   = INT(ENTRY(5,c-linha,";"))   
               i-cliente    = INT(ENTRY(6,c-linha,";"))   
               c-item       = ENTRY(7,c-linha,";")        
               d-valor      = DEC(ENTRY(8,c-linha,";")).  

        FIND FIRST int-meta-repres NO-LOCK
             WHERE int-meta-repres.periodo-mes    = i-mes 
               AND int-meta-repres.periodo-ano    = i-ano
               AND int-meta-repres.codigo         = i-executivo 
               AND int-meta-repres.idi-tipo       = 1 
               AND int-meta-repres.cod-unid-negoc = c-unid-negoc
               AND int-meta-repres.cod-segmento   = i-segmento
               AND int-meta-repres.cod-emitente   = i-cliente
               AND int-meta-repres.it-codigo      = c-item NO-ERROR.
    
    	IF NOT AVAIL int-meta-repres THEN DO:
    
    /*         IF NOT CAN-FIND (FIRST int-param-comis                                                                                        */
    /*                          WHERE int-param-comis.periodo-mes = i-mes                                                                    */
    /*                            AND int-param-comis.periodo-ano = i-ano ) THEN DO:                                                         */
    /*                                                                                                                                       */
    /*             CREATE tt-erro.                                                                                                           */
    /*             ASSIGN tt-erro.mensagem = "NÆo encontrado parƒmetros de comissÆo para o per¡odo: " + string(i-mes) + "/" + string(i-ano). */
    /*                                                                                                                                       */
    /*             NEXT blk_import.                                                                                                          */
    /*         END.                                                                                                                          */
    
            IF i-executivo < tt-param.cod-executivo-ini 
            OR i-executivo > tt-param.cod-executivo-fim THEN
                NEXT blk_import.
                
            IF NOT CAN-FIND (FIRST int-executivo
                             WHERE int-executivo.cod-executivo = i-executivo) THEN DO:
    
                CREATE tt-erro.
                ASSIGN tt-erro.mensagem = "NÆo encontrado executivo com o c¢digo: " + STRING(i-executivo).
    
                NEXT blk_import.
            END.
    
            IF NOT CAN-FIND (FIRST unid_negoc
                             WHERE unid_negoc.cod_unid_negoc = c-unid-negoc) THEN DO:
    
                CREATE tt-erro.
                ASSIGN tt-erro.mensagem = "NÆo encontrada unidade de neg¢cio com o c¢digo: " + c-unid-negoc.
    
                NEXT blk_import.
            END.
    
            IF NOT CAN-FIND (FIRST emitente
                             WHERE emitente.cod-emitente = i-cliente) THEN DO:
    
                CREATE tt-erro.
                ASSIGN tt-erro.mensagem = "NÆo encontrado emitente com o c¢digo: " + STRING(i-cliente).
    
                NEXT blk_import.
            END.
    
            IF NOT CAN-FIND (FIRST ITEM
                             WHERE ITEM.it-codigo = c-item)
            AND c-item <> "*" THEN DO:
    
                CREATE tt-erro.
                ASSIGN tt-erro.mensagem = "NÆo encontrado item com o c¢digo: " + c-item.
    
                NEXT blk_import.
            END.
    
            IF d-valor <= 0 THEN DO:
                CREATE tt-erro.
                ASSIGN tt-erro.mensagem = "Valor da meta deve ser maior que 0".
    
                NEXT blk_import.
            END.
    
            IF  i-segmento <> 0
            AND NOT CAN-FIND (FIRST fam-comerc 
                              WHERE SUBSTRING(fam-comerc.fm-cod-com,1,4) = STRING(i-segmento)) THEN DO:
    
                CREATE tt-erro.
                ASSIGN tt-erro.mensagem = "NÆo encontrado segmento: " + STRING(i-segmento).
    
                NEXT blk_import.
            END.
            
    		CREATE int-meta-repres.
    		ASSIGN int-meta-repres.periodo-ano      = i-ano
                   int-meta-repres.periodo-mes      = i-mes 
                   int-meta-repres.codigo           = i-executivo
                   int-meta-repres.idi-tipo         = 1
                   int-meta-repres.cod-unid-negoc   = c-unid-negoc
                   int-meta-repres.cod-segmento     = i-segmento  
                   int-meta-repres.cod-emitente     = i-cliente  
                   int-meta-repres.it-codigo        = c-item      
                   int-meta-repres.vl-meta          = d-valor
                   int-meta-repres.log-ativo        = YES
                   int-meta-repres.dt-ult-altera    = TODAY
                   int-meta-repres.usuar-ult-altera = c-seg-usuario.
    
            CREATE tt-sucesso.
            ASSIGN tt-sucesso.mensagem = "Importado meta do per¡odo " + STRING(i-mes) + "/" + STRING(i-ano) + " para o executivo " + STRING(i-executivo).
    		       
    	END.
        ELSE DO:
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = "Meta j  cadstrada para o per¡odo " + STRING(i-mes) + "/" + STRING(i-ano) + " executivo " + STRING(i-executivo) + " Unidade de Neg¢cios " + c-unid-negoc + " Segmento " + STRING(i-segmento) + " Item " + c-item.
    
        END.
    END.

    INPUT STREAM s-imp CLOSE.
END.
/*Excluir*/
ELSE DO:
    ASSIGN c-arquivo-lst = "ESFTP202_" + STRING(TIME) + ".lst":U.

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

    FOR EACH int-meta-repres EXCLUSIVE-LOCK
       WHERE int-meta-repres.periodo-mes = tt-param.periodo-mes
         AND int-meta-repres.periodo-ano = tt-param.periodo-ano
         AND int-meta-repres.codigo     >= tt-param.cod-executivo-ini
         AND int-meta-repres.codigo     <= tt-param.cod-executivo-fim:

        RUN pi-acompanhar IN h-acomp (INPUT "Excluindo Metas " + STRING(int-meta-repres.codigo)).

        PUT STREAM s-exp UNFORMATTED int-meta-repres.periodo-ano    ";" 
                                     int-meta-repres.periodo-mes    ";" 
                                     int-meta-repres.codigo         ";" 
                                     int-meta-repres.cod-unid-negoc ";" 
                                     int-meta-repres.cod-segmento   ";" 
                                     int-meta-repres.cod-emitente   ";" 
                                     int-meta-repres.it-codigo      ";" 
                                     int-meta-repres.vl-meta SKIP. 

        DELETE int-meta-repres.
    END.

    OUTPUT STREAM s-exp CLOSE.

    PUT STREAM str-rp UNFORMATTED "Registros exclu¡dos com sucesso!" SKIP.

    RUN utp/ut-msgs.p (INPUT "msg",
                       INPUT 15825,
                       INPUT "Arquivo de backup gerado: " + replace(c-arq-lst,"/", "\")).
    
    PUT STREAM str-rp UNFORMATTED RETURN-VALUE SKIP.
    
END.

FOR EACH tt-sucesso:
    PUT STREAM str-rp UNFORMATTED tt-sucesso.mensagem SKIP.
END.

PUT STREAM str-rp SKIP(3).

FOR EACH tt-erro:
    PUT STREAM str-rp UNFORMATTED tt-erro.mensagem SKIP.
END.

{include/i-rpclo.i &STREAM="stream str-rp"}
RUN pi-finalizar IN h-acomp.
RETURN "OK".

