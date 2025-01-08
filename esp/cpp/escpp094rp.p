
/***********************************************************************
**  Programa..: ESCPP094
**  Autor.....: Alexandre de Freitas.Campos.Gon‡alves
**  Data......: Maio/2015 - Desenvolvimento
**  Descricao.: Relat¢rio prototipo 
**  Versao....: 001 11/05/2015
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.
{include/i-prgvrs.i escpp094rp 1.00.00.000}

/****************************  Definitions  ****************************/
    
{esp/cpp/escpp094tt.i}

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita AS RAW.

DEFINE STREAM str-excel.

{utp/ut-glob.i}
{include/i-rpvar.i}
{esp/es0018.i}
{utp/utapi019.i}


/****************************  Temp-Tables  ****************************/

DEFINE TEMP-TABLE tt-itens
    FIELD tt-it-codigo LIKE ITEM.it-codigo
    INDEX id tt-it-codigo.

DEF TEMP-TABLE tt-saida NO-UNDO
    FIELD it-codigo  LIKE num-serie.it-codigo
    FIELD num-serie  LIKE num-serie.n-serie
    FIELD data       LIKE num-serie.data
    FIELD descricao  AS CHAR
    FIELD i-cont     AS INT
    INDEX id it-codigo.

/****************************  Frames  ****************************/

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

/* include padrÆo para output de relat¢rios */
{include/i-rpout.i}

/* include com a defini‡Æo da frame de cabe‡alho e rodap‚ */
{include/i-rpcab.i}

FOR FIRST tt-param:
END.

ASSIGN c-programa 	  = "ESCPP094"
	   c-versao	      = "1.00"
	   c-revisao	  = "1.00.000"
	   c-empresa      = param-global.grupo
       c-titulo-relat = "Envia e-mail numero de serie".

/* para nÆo visualizar cabe‡alho/rodap‚ em sa¡da RTF */

IF tt-param.destino <> 4 THEN DO:
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
END.

/********************* Defini‡Æo de variaveis ****************************/

DEFINE VARIABLE h-acomp     AS HANDLE       NO-UNDO.
DEFINE VARIABLE c-aux       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-mensagem  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE i-status    AS INTEGER      NO-UNDO.
DEFINE VARIABLE c-impressao AS CHARACTER    NO-UNDO.

DEFINE VARIABLE c-excel       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE chExcel       AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chArquivo     AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chPlanilhaMod AS COM-HANDLE NO-UNDO.

DEFINE VARIABLE dt-ini      AS DATETIME    NO-UNDO.
DEFINE VARIABLE dt-fim      AS DATETIME    NO-UNDO.
DEFINE VARIABLE c-desc-item AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-endereco  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-remetente AS CHARACTER   NO-UNDO.  
DEFINE VARIABLE c-titulo    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-caminho   AS CHARACTER   NO-UNDO.

DEFINE VARIABLE i-contador  AS INT.

FORM num-serie.it-codigo 
     c-desc-item            COLUMN-LABEL "Descri‡Æo" FORMAT "x(33)"
     num-serie.data
     WITH FRAME f-ns STREAM-IO DOWN WIDTH 132.

FIND FIRST usuar_mestre NO-LOCK
    WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-ERROR.

EMPTY TEMP-TABLE tt-prog-ponto.

IF OPSYS = "UNIX" THEN DO:
    RUN esp/es0018p.p (INPUT "spool-unix", /* Nome do programa */
                       INPUT 1,           /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    FOR FIRST tt-prog-ponto NO-LOCK:

        ASSIGN c-excel   = tt-prog-ponto.conteudo + "~/" + v_cod_usuar_corren + "~/"
               c-caminho = tt-prog-ponto.conteudo + "~/" + v_cod_usuar_corren + "~/".

        OS-CREATE-DIR VALUE(c-excel).
        
       ASSIGN c-excel = c-excel + "ESCPP094" + "-" + STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + STRING(TIME) + ".csv".

    END.

END.
ELSE DO:
    RUN esp/es0018p.p (INPUT "spool-win", /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    FOR FIRST tt-prog-ponto NO-LOCK:

        ASSIGN c-excel   = tt-prog-ponto.conteudo + "~\" + v_cod_usuar_corren + "~\"
               c-caminho = tt-prog-ponto.conteudo + "~\" + v_cod_usuar_corren + "~\".

        OS-CREATE-DIR VALUE(c-excel).

        ASSIGN c-excel = c-excel + "ESCPP094" + "-" + STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + STRING(TIME) + ".csv".
    END.

END.

OUTPUT STREAM str-excel TO VALUE(c-excel) CONVERT TARGET "iso8859-1".
PUT STREAM str-excel "ITEM;Descri‡Æo;Num.Serie;Data.Gera‡Æo" SKIP.

/* ***************************  Main Block  *************************** */

DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    {utp/ut-liter.i Coletando_Numeros_de_serie *}
    RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

    ASSIGN dt-ini = DATETIME(month(tt-param.data-ini), 
                         day(tt-param.data-ini),
                         year(tt-param.data-ini),
                         0,  /* hora */
                         0,  /* minutos */
                         0,  /* segundos */
                         0)  /* milisegundos */

           dt-fim = DATETIME(month(tt-param.data-fim), 
                         day(tt-param.data-fim),
                         year(tt-param.data-fim),
                         23,  /* hora */
                         59,  /* minutos */
                         59,  /* segundos */
                         999) /* milisegundos */.

     
     IF tt-param.semanal = YES THEN DO:
        ASSIGN dt-ini = TODAY - 7
               dt-fim = TODAY.
    END.

    RUN piMontaRelat.
    
END.

PROCEDURE piMontaRelat:
    
    IF CAN-FIND(FIRST tt-digita) THEN DO:
         
        FOR EACH tt-digita:
            FOR EACH num-serie USE-INDEX data NO-LOCK
                WHERE num-serie.data >= dt-ini  
                  AND num-serie.data <= dt-fim 
                  AND num-serie.it-codigo = tt-digita.it-codigo
                  BREAK BY date(num-serie.data)
                        BY num-serie.it-codigo:
                
                RUN pi-acompanhar IN h-acomp (INPUT num-serie.data).
                
                ASSIGN c-desc-item = ""
                       i-contador = i-contador + 1.
                
                FOR FIRST ITEM NO-LOCK
                    WHERE ITEM.it-codigo = num-serie.it-codigo:
                
                    ASSIGN c-desc-item = ITEM.desc-item.
                
                END.
                
                CREATE tt-saida.
                ASSIGN tt-saida.it-codigo = ITEM.it-codigo
                       tt-saida.descricao = c-desc-item
                       tt-saida.i-cont    = i-contador
                       tt-saida.num-serie = num-serie.n-serie
                       tt-saida.data      = num-serie.data.
            
                PUT STREAM str-excel UNFORMATTED
                    TRIM(num-serie.it-codigo)   ";"  
                    TRIM(c-desc-item)           ";"  
                        TRIM(num-serie.n-serie) ";"  
                        DATE(num-serie.data)       SKIP.
                    
                    DISPLAY num-serie.it-codigo
                            c-desc-item
                            num-serie.n-serie
                            num-serie.data
                            WITH FRAME f-ns.
                    DOWN WITH FRAME f-ns.
                    
                    
            END.
        END.
    END.   
    
    ELSE DO:
        
        FOR EACH num-serie USE-INDEX data NO-LOCK
            WHERE num-serie.data >= dt-ini  
              AND num-serie.data <= dt-fim 
              AND num-serie.it-codigo >= tt-param.item-ini
              AND num-serie.it-codigo <= tt-param.item-fim
              BREAK BY date(num-serie.data)
                    BY num-serie.it-codigo:
            
            RUN pi-acompanhar IN h-acomp (INPUT num-serie.data).
            
            ASSIGN c-desc-item = ""
                   i-contador = i-contador + 1.
        
            FOR FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = num-serie.it-codigo:
        
                ASSIGN c-desc-item = ITEM.desc-item.
            
            END.
             
            CREATE tt-saida.
            ASSIGN tt-saida.it-codigo = ITEM.it-codigo
                   tt-saida.descricao = c-desc-item
                   tt-saida.i-cont    = i-contador
                   tt-saida.num-serie = num-serie.n-serie
                   tt-saida.data      = num-serie.data.
           
            PUT STREAM str-excel UNFORMATTED
                TRIM(num-serie.it-codigo)  ";"  
                TRIM(c-desc-item)          ";"  
                TRIM(num-serie.n-serie)    ";"  
                DATE(num-serie.data)       SKIP.
            
            DISPLAY num-serie.it-codigo
                    c-desc-item
                    num-serie.n-serie
                    num-serie.data
                    WITH FRAME f-ns.
            DOWN WITH FRAME f-ns.
          
        END.
    END.

    PUT UNFORMATTED "" SKIP(3).
    PUT UNFORMATTED "Arquivo gerado em: "c-excel SKIP(1).
    
    IF tt-param.habilita-email = YES THEN DO:
        RUN piTrataEmail.
        PUT UNFORMATTED "Enviado e-mail para: "tt-param.email.
    END.
    
    RUN pi-finalizar IN h-acomp.
    OUTPUT STREAM str-excel CLOSE.

END PROCEDURE.

PROCEDURE piTrataEmail:
    
    DEFINE VARIABLE varquivo AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-arq    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-aux    AS INTEGER   NO-UNDO.
    
    FOR EACH tt-saida NO-LOCK
        BREAK BY tt-saida.it-codigo:

        IF FIRST-OF(tt-saida.it-codigo) THEN DO:    
            
            ASSIGN varquivo    = c-caminho + "ESCPP094" + "-" + STRING(tt-saida.it-codigo) + "-" + STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + STRING(TIME) + ".csv"
                   c-remetente = usuar_mestre.cod_e_mail_local
                   c-endereco  = tt-param.email
                   c-titulo    = "N£meros de serie " + " de " + STRING(DATE(dt-ini)) + "   " + STRING(DATE(dt-fim))
                   c-mensagem  = "Segue anexo referente ao programa ESCPP094, entre o periodo " + STRING(DATE(dt-ini)) + "   " + STRING(DATE(dt-fim)).
    
            OUTPUT TO VALUE(varquivo) .
            
            ASSIGN c-arq = varquivo.
        END.
        
        PUT UNFORMATTED TRIM(tt-saida.num-serie) SKIP.

        IF  LAST-OF(tt-saida.it-codigo) THEN DO:

            OUTPUT CLOSE.
            
            IF  c-arquivo = "" THEN
                ASSIGN c-arquivo = varquivo.
            ELSE
                ASSIGN c-arquivo = c-arquivo + ',' + varquivo.
           
        END.
        
    END.
    
    RUN pi-envia-email(INPUT c-remetente,
                       INPUT c-endereco,
                       INPUT c-titulo,
                       INPUT c-mensagem,
                       INPUT c-arquivo). 
    
    DO i-aux = 1 TO NUM-ENTRIES(c-arquivo,","):
        OS-DELETE value(ENTRY(i-aux, c-arquivo , ",")). 
    END. 

END PROCEDURE.

PROCEDURE pi-envia-email:
    
    RUN pi-acompanhar in h-acomp (input "Enviando Email: " + c-endereco).
    
    DEFINE INPUT  PARAM premetente AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE VARIABLE icont          AS INTEGER NO-UNDO. 
    
    FOR FIRST param-global NO-LOCK: END.
    
    CREATE tt-envio.
    ASSIGN tt-envio.Remetente     = pRemetente
           tt-envio.destino       = pdestino
           tt-envio.Assunto       = pAssunto
           tt-envio.arq-anexo     = pArquivo
           tt-envio.Mensagem      = pDescEmail.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR FIRST tt-envio:

        EMPTY TEMP-TABLE tt-envio2 NO-ERROR.
        EMPTY TEMP-TABLE tt-mensagem NO-ERROR.

        CREATE tt-envio2.
        ASSIGN tt-envio2.versao-integracao = 1
               tt-envio2.servidor          = param-global.serv-mail  /* Servidor de E-Mail */ 
               tt-envio2.porta             = param-global.porta-mail /* Porta do Servidor  */ 
               tt-envio2.destino           = tt-envio.Destino        /* Destinat rio       */ 
               tt-envio2.remetente         = tt-envio.Remetente      /* Remetente          */ 
               tt-envio2.assunto           = tt-envio.Assunto        /* Assunto            */
               tt-envio2.arq-anexo         = tt-envio.arq-anexo      /* Arquivo Tempor rio */
               tt-envio2.formato           = "CSV".

        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 1
               tt-mensagem.mensagem     = tt-envio.Mensagem. /* Mensagem           */
                
        RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                       INPUT  TABLE tt-mensagem,
                                       OUTPUT TABLE tt-erros).

        FIND FIRST tt-erros NO-LOCK NO-ERROR.
        IF  AVAIL tt-erros THEN DO:
            OUTPUT TO erros-comerc.LOG APPEND.

            FOR EACH tt-erros:
                DISP tt-erros.cod-erro
                     tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
            END.
            OUTPUT CLOSE.
        END. /* IF  AVAIL tt-erros THEN DO: */
    END. /* FOR FIRST tt-mail: */
    
    DELETE PROCEDURE h-utapi019.

END PROCEDURE.



















