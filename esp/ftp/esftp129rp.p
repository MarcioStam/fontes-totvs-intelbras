/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESFTP129RP 2.06.00.000}

/*------------------------------------------------------------------------
    File        : ESFTP129RP.P
    Description : Importador de vinculos entre NF e NS (numero sÇrie)

    Author(s)   : Nicol†s Mart°nez
    Created     : 14/06/2021
    Notes       : 
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Preprocessor Definitions ---                                         */

&GLOBAL-DEFINE PRINT-PARAM  YES

/* Include Definitions ---                                              */

/* Definiá∆o das temp-tables tt-param, tt-digita e tt-raw-digita */

{utp/utapi019.i}
{utp/ut-glob.i} 

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
    field raw-digita       as raw.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    field l-habilitaRtf    as LOG
    FIELD tipo-data        AS INTEGER
    FIELD l-emails         AS LOG
    FIELD emails           AS CHAR
    FIELD cod-estabel      AS CHAR
    FIELD dir-importacao   AS CHAR
    FIELD dir-processado   AS CHAR
    FIELD dir-erros        AS CHAR.
{include/i-rpvar.i}

/* Local Temp-Table Definitions ---                                     */
DEFINE TEMP-TABLE tt-arquivos NO-UNDO
    FIELD arquivo           AS CHAR.

DEFINE TEMP-TABLE tt-arq-erro NO-UNDO
    FIELD arquivo           AS CHAR
    FIELD erro              AS CHAR.

DEFINE TEMP-TABLE tt-num-serie-rast NO-UNDO LIKE num-serie-rast.

DEFINE VARIABLE h-acomp     AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-destino   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo   AS CHARACTER FORMAT "x(30)" NO-UNDO.

DEFINE VARIABLE c-data      AS CHAR        NO-UNDO.
DEFINE VARIABLE c-nf        AS CHAR        NO-UNDO.
DEFINE VARIABLE c-serie     AS CHAR        NO-UNDO.
DEFINE VARIABLE c-it-codigo AS CHAR        NO-UNDO.
DEFINE VARIABLE c-n-serie   AS CHAR        NO-UNDO.
DEFINE VARIABLE i-linhas    AS INTE        NO-UNDO.
DEFINE VARIABLE i-conta     AS INTE        NO-UNDO.
DEFINE VARIABLE i-conta-pipe AS INTE       NO-UNDO.
DEFINE VARIABLE c-linha     AS CHAR        NO-UNDO.
DEFINE VARIABLE l-pula      AS LOG         NO-UNDO.

/* Stream Definitions ---                                               */

DEFINE STREAM str-rp.
DEFINE STREAM c-lista-arq.
DEFINE STREAM c-arq-impor.

/* Form Definitions ---                                                 */
FORM tt-arq-erro.arquivo  AT 1 COLUMN-LABEL "Arquivo" FORMAT "x(80)"
     tt-arq-erro.erro     AT 82 COLUMN-LABEL "Erro"   FORMAT "x(70)"
     WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 152 FRAME f-report.

FORM tt-num-serie-rast.n-serie  AT 1 COLUMN-LABEL "NS"   FORMAT "x(15)"
     tt-arq-erro.erro           AT 17 COLUMN-LABEL "Situaá∆o" FORMAT "x(70)"
     WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 152 FRAME f-ns.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.

/* ************************  Function Prototypes ********************** */

/* ***************************  Main Block  *************************** */

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

FIND FIRST param-global NO-LOCK NO-ERROR.

assign c-programa     = "ESFTP129"
       c-sistema      = "Importador NF x NS"
       c-titulo-relat = "Importador NF x NS"
       c-versao       = "2.06.00"
       c-revisao      = "000"
       c-empresa      = "Intelbras".

FIND FIRST tt-param NO-LOCK NO-ERROR.

ASSIGN c-destino = {varinc/var00002.i 04 tt-param.destino}.

DO ON ERROR UNDO, RETURN ERROR
   ON STOP  UNDO, RETURN ERROR:
    {include/i-rpcab.i &STREAM="str-rp"}
    {include/i-rpout.i &STREAM="STREAM str-rp"}

    VIEW STREAM str-rp FRAME f-cabec.
    VIEW STREAM str-rp FRAME f-rodape.

    IF NOT VALID-HANDLE(h-acomp)               OR
       h-acomp:TYPE      <> "PROCEDURE":U      OR
       h-acomp:FILE-NAME <> "utp/ut-acomp.p":U THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "":U).

    RUN pi-importacao.

    IF tt-param.l-emails = YES 
    THEN RUN pi-envia-mail.

    FOR EACH tt-arq-erro NO-LOCK.
        DISP STREAM str-rp 
             tt-arq-erro.arquivo 
             tt-arq-erro.erro    
    		WITH FRAME f-report.               
            DOWN STREAM str-rp WITH FRAME f-report.

    END.
    
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    {include/i-rpclo.i &STREAM="STREAM str-rp"}

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    ASSIGN h-acomp = ?.
END.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */
PROCEDURE pi-importacao:

    INPUT STREAM c-lista-arq FROM OS-DIR(tt-param.dir-importacao).
    
    EMPTY TEMP-TABLE tt-arquivos.
    EMPTY TEMP-TABLE tt-arq-erro.
    EMPTY TEMP-TABLE tt-num-serie-rast.

    REPEAT:   

        run pi-acompanhar in h-acomp (input 'Verificando diretorio...').

        IMPORT STREAM c-lista-arq c-arquivo.

        IF c-arquivo = "." 
        OR c-arquivo = ".." 
        OR SEARCH(tt-param.dir-importacao + c-arquivo) = ?
           THEN NEXT.

        IF SUBSTRING(c-arquivo,LENGTH(c-arquivo) - 2,3) <> "TXT" 
        THEN DO:
            RUN pi-erro (INPUT tt-param.dir-importacao + c-arquivo,
                         INPUT "Arquivo n∆o tem a extens∆o TXT permitida para importaá∆o").
            NEXT.
        END.
    
        FIND FIRST tt-arquivos WHERE
                   tt-arquivos.arquivo = tt-param.dir-importacao + c-arquivo
                   NO-LOCK NO-ERROR.

        IF NOT AVAIL tt-arquivos 
        THEN DO:
            CREATE tt-arquivos.
            ASSIGN tt-arquivos.arquivo = tt-param.dir-importacao + c-arquivo.
        END.
    END.
    
    INPUT STREAM c-lista-arq CLOSE.    

    FOR EACH tt-arquivos NO-LOCK.

        run pi-acompanhar in h-acomp (input 'Imp ' + tt-arquivos.arquivo).       

        //Inicio teste layout do arquivo
        ASSIGN l-pula   = NO
               c-linha  = ""
               i-linhas = 0.

        INPUT STREAM c-arq-impor FROM VALUE(tt-arquivos.arquivo) NO-ECHO.
        blocklayout:
        REPEAT:
            ASSIGN i-conta-pipe = 0.

            IMPORT STREAM c-arq-impor c-linha.

            ASSIGN i-linhas = i-linhas + 1.

            DO i-conta =  1 TO LENGTH(c-linha):
            
                IF SUBSTRING(c-linha,i-conta,1) = "|" THEN ASSIGN i-conta-pipe = i-conta-pipe + 1.
        
            END.

            IF i-conta-pipe <> 4 
            THEN DO:
                RUN pi-erro (INPUT tt-arquivos.arquivo,
                             INPUT "Arquivo fora do formato permitido").
                ASSIGN l-pula = YES.
                LEAVE blocklayout.
            END.       
        END.

        //Arquivo deve estar vazio ou sem ENTER na linha
        IF i-linhas = 0 
        THEN DO:
            RUN pi-erro (INPUT tt-arquivos.arquivo,
                         INPUT "Arquivo fora do formato permitido ou vazio").
            ASSIGN l-pula = YES.            
        END.

        IF l-pula = YES THEN NEXT.

        INPUT STREAM c-arq-impor CLOSE.
        //Fim teste de layout

        ASSIGN i-linhas = 0.

        //Validaá‰es e criaá∆o de temp-table de rastreio
        INPUT STREAM c-arq-impor FROM VALUE(tt-arquivos.arquivo) NO-ECHO.              

        block1:
        REPEAT:
        
            ASSIGN c-data      = ""
                   c-nf        = ""
                   c-serie     = ""
                   c-it-codigo = ""
                   c-n-serie   = "".
        
            IMPORT STREAM c-arq-impor DELIMITER "|"
                   c-data      //Data
                   c-nf        //Numero NF
                   c-serie     //Serie NF
                   c-it-codigo //Codigo Item
                   c-n-serie.  //Numero de Serie
                                                      
            ASSIGN i-linhas = i-linhas + 1.

            ASSIGN c-nf = SUBSTRING(c-nf,3,7).

            run pi-acompanhar in h-acomp (input 'Imp ' + tt-param.cod-estabel + "/" + c-serie + "/" + c-nf + "/" + c-it-codigo).

            FIND FIRST ITEM WHERE
                       ITEM.it-codigo = c-it-codigo
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL ITEM
            THEN DO:
                RUN pi-erro (INPUT tt-arquivos.arquivo,
                             INPUT "Item n∆o cadastrado no sistema - " + c-it-codigo).

                LEAVE block1.
            END.

            //Validaá∆o arquivo
            FIND FIRST nota-fiscal WHERE
                       nota-fiscal.cod-estabel = tt-param.cod-estabel AND
                       nota-fiscal.serie       = c-serie              AND
                       nota-fiscal.nr-nota-fis = c-nf 
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL nota-fiscal 
            THEN DO:
                RUN pi-erro (INPUT tt-arquivos.arquivo,
                             INPUT "Nota Fiscal n∆o foi encontrada no sistema - " + tt-param.cod-estabel + "/" + c-serie + "/" + c-nf).

                LEAVE block1.
            END.
            ELSE DO:
                FIND FIRST it-nota-fisc
                     WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
                     AND   it-nota-fisc.serie       = nota-fiscal.serie      
                     AND   it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
                     AND   it-nota-fisc.it-codigo   = c-it-codigo 
                           NO-LOCK NO-ERROR.

                IF NOT AVAIL it-nota-fisc 
                THEN DO:
                    RUN pi-erro (INPUT tt-arquivos.arquivo,
                                 INPUT "Item informado n∆o foi encontrado na Nota Fiscal - " + tt-param.cod-estabel + "/" + c-serie + "/" + c-nf + "/" + c-it-codigo).
                    
                    LEAVE block1.
                END.
            END.

            IF SUBSTRING(c-n-serie,1,3) <> "ECO" 
            THEN DO:
               FIND FIRST num-serie WHERE
                          num-serie.n-serie = c-n-serie
                          NO-LOCK NO-ERROR.
               
               IF NOT AVAIL num-serie 
               THEN DO:
                   RUN pi-erro (INPUT tt-arquivos.arquivo,
                                INPUT "Numero de Serie n∆o foi encontrado no sistema - " + c-n-serie).
               
                   LEAVE block1.
               END.
               ELSE DO:
                   IF num-serie.it-codigo <> c-it-codigo 
                   THEN DO:
                       RUN pi-erro (INPUT tt-arquivos.arquivo,
                                    INPUT "Item informado diferente do item do NS - " + c-it-codigo + "/" + num-serie.it-codigo).
                       
                       LEAVE block1.
                   END.
               END.
               
               FIND FIRST num-serie-rast WHERE
                          num-serie-rast.cod-estabel = tt-param.cod-estabel AND
                          num-serie-rast.serie       = c-serie              AND
                          num-serie-rast.nr-nota-fis = c-nf                 AND
                          num-serie-rast.n-serie     = c-n-serie
                          NO-LOCK NO-ERROR.
               
               IF AVAIL num-serie-rast 
               THEN DO:
                   RUN pi-erro (INPUT tt-arquivos.arquivo,
                                INPUT "Relacionamento NF X NS j† cadastrado - " + tt-param.cod-estabel + "/" + c-serie + "/" + c-nf + "/" + c-n-serie).
               
                   LEAVE block1.
               END.
               ELSE DO:
                   FIND FIRST tt-num-serie-rast WHERE
                              tt-num-serie-rast.cod-estabel = tt-param.cod-estabel AND
                              tt-num-serie-rast.serie       = c-serie              AND
                              tt-num-serie-rast.nr-nota-fis = c-nf                 AND
                              tt-num-serie-rast.n-serie     = c-n-serie
                              NO-LOCK NO-ERROR.
               
                   IF NOT AVAIL tt-num-serie-rast 
                   THEN DO:
                       CREATE tt-num-serie-rast.
                       ASSIGN tt-num-serie-rast.cod-estabel = tt-param.cod-estabel
                              tt-num-serie-rast.serie       = c-serie             
                              tt-num-serie-rast.nr-nota-fis = c-nf
                              tt-num-serie-rast.it-codigo   = c-it-codigo
                              tt-num-serie-rast.n-serie     = c-n-serie
                              tt-num-serie-rast.data        = DATETIME(DATE(SUBSTRING(c-data,1,2) + "/" + SUBSTRING(c-data,3,2) + "/" + SUBSTRING(c-data,5,4))).
                              tt-num-serie-rast.usuario     = c-seg-usuario
                              .
                   END.
               END.
            END.
            ELSE DO:
                FIND FIRST ns-volume WHERE
                           ns-volume.volume-pai = c-n-serie //ECO
                           NO-LOCK NO-ERROR.

                IF NOT AVAIL ns-volume
                THEN DO:
                
                   RUN pi-erro (INPUT tt-arquivos.arquivo,
                                INPUT "Etiqueta ECO n∆o encontrada no sistema - " + c-n-serie).
               
                   LEAVE block1.
                END.
                ELSE DO:
                    FOR EACH ns-volume WHERE
                             ns-volume.volume-pai = c-n-serie //ECO
                             NO-LOCK.

                       FIND FIRST num-serie-rast WHERE
                                  num-serie-rast.cod-estabel = tt-param.cod-estabel AND
                                  num-serie-rast.serie       = c-serie              AND
                                  num-serie-rast.nr-nota-fis = c-nf                 AND
                                  num-serie-rast.n-serie     = ns-volume.volume-filho
                                  NO-LOCK NO-ERROR.
                       
                       IF AVAIL num-serie-rast 
                       THEN DO:
                           RUN pi-erro (INPUT tt-arquivos.arquivo,
                                        INPUT "Relacionamento NF X NS j† cadastrado - " + tt-param.cod-estabel + "/" + c-serie + "/" + c-nf + "/" + num-serie-rast.n-serie).
                       
                           LEAVE block1.
                       END.
                       ELSE DO:
                           FIND FIRST tt-num-serie-rast WHERE
                                      tt-num-serie-rast.cod-estabel = tt-param.cod-estabel AND
                                      tt-num-serie-rast.serie       = c-serie              AND
                                      tt-num-serie-rast.nr-nota-fis = c-nf                 AND
                                      tt-num-serie-rast.n-serie     = ns-volume.volume-filho
                                      NO-LOCK NO-ERROR.
                           
                           IF NOT AVAIL tt-num-serie-rast 
                           THEN DO:
                               CREATE tt-num-serie-rast.
                               ASSIGN tt-num-serie-rast.cod-estabel = tt-param.cod-estabel
                                      tt-num-serie-rast.serie       = c-serie             
                                      tt-num-serie-rast.nr-nota-fis = c-nf
                                      tt-num-serie-rast.it-codigo   = c-it-codigo
                                      tt-num-serie-rast.n-serie     = ns-volume.volume-filho
                                      tt-num-serie-rast.data        = DATETIME(DATE(SUBSTRING(c-data,1,2) + "/" + SUBSTRING(c-data,3,2) + "/" + SUBSTRING(c-data,5,4))).
                                      tt-num-serie-rast.usuario     = c-seg-usuario
                                      .
                           END.
                       END.
                    END.
                END.
            END.
        END.
        
        INPUT STREAM c-arq-impor CLOSE.
        //Fim validaá‰es e temp-table

        FOR EACH tt-num-serie-rast NO-LOCK.

            FIND FIRST num-serie-rast WHERE        
                       num-serie-rast.cod-estabel = tt-num-serie-rast.cod-estabel AND
                       num-serie-rast.serie       = tt-num-serie-rast.serie       AND
                       num-serie-rast.nr-nota-fis = tt-num-serie-rast.nr-nota-fis AND
                       num-serie-rast.n-serie     = tt-num-serie-rast.n-serie 
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL num-serie-rast 
            THEN DO:
                CREATE num-serie-rast.
                BUFFER-COPY tt-num-serie-rast TO num-serie-rast.

                RELEASE num-serie-rast.

                DISP STREAM str-rp 
                     tt-num-serie-rast.n-serie 
                     "Importado com sucesso." @ tt-arq-erro.erro    
    	        	 WITH FRAME f-ns.               
                     DOWN STREAM str-rp WITH FRAME f-ns.
            END.

        END.

        OS-COMMAND SILENT VALUE("move " + tt-arquivos.arquivo + " " + tt-param.dir-processado).
    END.

END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAMETER c-arq-erro   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER c-grava-erro AS CHARACTER NO-UNDO.
    /*
    MESSAGE c-grava-erro SKIP
            c-arq-erro   SKIP
            tt-param.dir-erros
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    */
    CREATE tt-arq-erro.
    ASSIGN tt-arq-erro.arquivo = c-arq-erro
           tt-arq-erro.erro    = c-grava-erro.

    INPUT STREAM c-arq-impor CLOSE.
    //Move o arquivo para o diretorio importado para a pasta de arquivos com erros
    OS-COMMAND SILENT VALUE("move " + c-arq-erro + " " + tt-param.dir-erros).

END PROCEDURE.

PROCEDURE pi-envia-mail:

    IF NOT CAN-FIND(FIRST tt-arq-erro) THEN NEXT.

    run pi-acompanhar in h-acomp (input "Gerando e-mail.").

    DEF VAR c-corpo-email AS CHAR FORMAT "x(2000)" NO-UNDO.

    FOR FIRST param-global NO-LOCK: END.    

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-envio2.   DELETE tt-envio2.   END.
    FOR EACH tt-mensagem. DELETE tt-mensagem. END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail               /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail              /* Porta do Servidor  */ 
           tt-envio2.destino           = tt-param.emails                      /* Destinatòrio       */ 
           tt-envio2.remetente         = "ems@intelbras.com.br"               /* Remetente          */ 
           tt-envio2.assunto           = "Importador NF x NS - IMPORTANTE"    /* Assunto            */
           tt-envio2.formato           = "TEXTO".

    ASSIGN c-corpo-email = "Os arquivos abaixo foram importados com erros, verifique na pasta de ERROS " + tt-param.dir-erros + "." + CHR(10) + CHR(10).

    FOR EACH tt-arq-erro NO-LOCK 
        BREAK BY tt-arq-erro.arquivo:

        IF FIRST-OF(tt-arq-erro.arquivo) 
        THEN DO:
             ASSIGN c-corpo-email = c-corpo-email + tt-arq-erro.arquivo + ":" + CHR(10).
        END.

        ASSIGN c-corpo-email = c-corpo-email + "  " + tt-arq-erro.erro + CHR(10) + CHR(10).
    END.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = c-corpo-email.          /* Mensagem           */

    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).
    
    /*FIND FIRST tt-erros NO-LOCK NO-ERROR.
    IF AVAIL tt-erros 
    THEN run cdp/cd0666.w (input table tt-erros).*/

END.

