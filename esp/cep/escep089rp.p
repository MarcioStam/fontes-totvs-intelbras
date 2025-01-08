/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i escep089brp 3.00.00.000 }

{utp/utapi019.i}
{esp/es0018.i}

define temp-table tt-param NO-UNDO
    field destino       as integer
    field arquivo       as char
    field usuario       as char format "x(12)"
    field data-exec     as date
    field cod-estabel   as char
    FIELD l-emails      AS LOG
    FIELD emails         AS CHAR
    field dir-importacao as char 
    field dir-processado as char 
    field dir-erros      as char. 

def temp-table tt-raw-digita NO-UNDO
    field raw-digita as raw.

def temp-table ttDadosImportacao NO-UNDO
    FIELD arquivo       AS CHAR
    field data-recebto  AS DATE 
    field serie         AS CHAR 
    field num-docto-1   AS CHAR 
    field num-docto-2   AS CHAR 
    field sequencia     AS INTEGER
    field cod-produto   AS CHAR 
    field lote          AS CHAR 
    field dt-valid-lote AS DATE
    field un            AS CHAR 
    field qt-fiscal     AS DECIMAL 
    field qt-fisica     AS DECIMAL 
    field qt-avariada   AS DECIMAL.

DEF TEMP-TABLE tt-nf NO-UNDO
    FIELD arquivo       AS CHAR
    FIELD data-recebto  AS DATE 
    FIELD serie         AS CHAR
    FIELD num-docto-1   AS CHAR
    FIELD num-docto-2   AS CHAR.

DEF TEMP-TABLE tt-item NO-UNDO
    field data-recebto  AS DATE    
    field serie         AS CHAR    
    field num-docto-1   AS CHAR    
    field num-docto-2   AS CHAR    
    field sequencia     AS INTEGER 
    field cod-produto   AS CHAR    
    field lote          AS CHAR    
    field dt-valid-lote AS DATE    
    field un            AS CHAR    
    field qt-fiscal     AS DECIMAL 
    field qt-fisica     AS DECIMAL 
    field qt-avariada   AS DECIMAL.

    
DEFINE TEMP-TABLE tt-arquivos NO-UNDO
    FIELD arquivo           AS CHAR.

DEFINE TEMP-TABLE tt-arq-erro NO-UNDO
    FIELD arquivo           AS CHAR
    FIELD erro              AS CHAR.

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

def var c-impressao     as char     format "x(09)"      no-undo.
def var c-destino       as char     format "x(10)"      no-undo.
def var h-acomp         as handle                       no-undo.
def var cLinha          as char                         no-undo.
def var iCont           as int                          no-undo.

DEFINE VARIABLE c-data-recebto AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-serie        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-num-docto-1  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-num-docto-2  AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-arq-spool    AS CHARACTER   NO-UNDO.

DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO.

DEFINE STREAM stImpNF.

DEFINE STREAM str-rp.
DEFINE STREAM c-lista-arq.
DEFINE STREAM c-arq-impor.

create tt-param.
raw-transfer raw-param to tt-param.

/*
form 
    skip(2)
    c-impressao        no-label colon 45 
    skip(1)
    "Dir.Importacao: "  colon 45
    tt-param.dir-importacao no-label
    skip(1)
    tt-param.usuario            colon 60
    with stream-io down width 132 side-labels frame f-det.*/

FORM tt-arq-erro.arquivo  AT 1 COLUMN-LABEL "Arquivo" FORMAT "x(80)"
     tt-arq-erro.erro     AT 82 COLUMN-LABEL "Erro"   FORMAT "x(110)"
     WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 200 FRAME f-report.

FORM int-it-nota-fisc-alocado.cod-estabel  AT 1 COLUMN-LABEL "Estab"         FORMAT "x(5)"
     int-it-nota-fisc-alocado.serie        AT 7 COLUMN-LABEL "Serie"         FORMAT "x(5)"
     int-it-nota-fisc-alocado.nr-nota-fis  AT 14 COLUMN-LABEL "NF"           FORMAT "x(10)"
     int-it-nota-fisc-alocado.cod-depos    AT 26 COLUMN-LABEL "Depos"        FORMAT 'x(3)'
     int-it-nota-fisc-alocado.cod-localiz  AT 33 COLUMN-LABEL 'Localiz.'     FORMAT 'x(20)'
     int-it-nota-fisc-alocado.it-codigo    AT 55 COLUMN-LABEL 'Item'         FORMAT 'x(16)'
     int-it-nota-fisc-alocado.cod-refer    AT 72 COLUMN-LABEL 'Refer'        FORMAT 'x(8)'  
     int-it-nota-fisc-alocado.qt-faturada[1] AT 85 COLUMN-LABEL 'Qtde Transito' FORMAT '->>>>,>>9.9999'
     it-nota-fisc.qt-faturada[1]           AT 100 COLUMN-LABEL 'Qtde Receb'  FORMAT '->>>>,>>9.9999'
     tt-arq-erro.erro                      AT 115 COLUMN-LABEL "Situaá∆o"    FORMAT "x(50)"
     WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 175 FRAME f-nf.

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

{utp/ut-liter.i "Geraá∆o Dados Analit°cos" * L}
assign c-titulo-relat = trim(return-value).

assign c-programa     = "ESCEP089"
       c-sistema      = c-titulo-relat
       c-versao       = "2.06.00"
       c-revisao      = "000".

{include/i-rpcab.i &STREAM="str-rp"}
{include/i-rpout.i &STREAM="STREAM str-rp"}

VIEW STREAM str-rp FRAME f-cabec.
VIEW STREAM str-rp FRAME f-rodape.

RUN pi-importacao.

IF tt-param.l-emails = YES THEN 
   RUN pi-envia-mail.

FOR EACH tt-arq-erro NO-LOCK.
    DISP STREAM str-rp 
         tt-arq-erro.arquivo 
         tt-arq-erro.erro    
		WITH FRAME f-report.               
        DOWN STREAM str-rp WITH FRAME f-report.
END.


run pi-finalizar in h-acomp.

{include/i-rpclo.i}

RETURN "OK".


/******************************************************************************************/
/******************************************************************************************/
/******************************************************************************************/

/* **********************  Internal Procedures  *********************** */
PROCEDURE pi-importacao:
     
    DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-linhas  AS INTEGER     NO-UNDO.

    EMPTY TEMP-TABLE tt-arquivos.
    EMPTY TEMP-TABLE tt-arq-erro.
    EMPTY TEMP-TABLE ttDadosImportacao.
    EMPTY TEMP-TABLE tt-nf.
    EMPTY TEMP-TABLE tt-item.

    INPUT STREAM c-lista-arq FROM OS-DIR(tt-param.dir-importacao).

    REPEAT:   
        run pi-acompanhar in h-acomp (input 'Verificando diretorio...').
        
        IMPORT STREAM c-lista-arq c-arquivo.
        
        IF c-arquivo = "." 
        OR c-arquivo = ".."
        OR c-arquivo = ".txt"
        OR SEARCH(tt-param.dir-importacao + c-arquivo) = ? THEN 
           NEXT.

        /*
        IF SUBSTRING(c-arquivo,LENGTH(c-arquivo) - 2,3) <> "TXT" THEN DO:
            RUN pi-erro (INPUT tt-param.dir-importacao + c-arquivo,
                         INPUT "Arquivo n∆o tem a extens∆o TXT permitida para importaá∆o").
            NEXT.
        END.*/
    
        FIND FIRST tt-arquivos 
             WHERE tt-arquivos.arquivo = tt-param.dir-importacao + c-arquivo
        NO-LOCK NO-ERROR.
 
        IF NOT AVAIL tt-arquivos THEN DO:
            CREATE tt-arquivos.
            ASSIGN tt-arquivos.arquivo = tt-param.dir-importacao + c-arquivo.
        END.
    END.

    INPUT STREAM c-lista-arq CLOSE. 

    FOR EACH tt-arquivos NO-LOCK.

        EMPTY TEMP-TABLE ttDadosImportacao.
        EMPTY TEMP-TABLE tt-nf.
        EMPTY TEMP-TABLE tt-item.

        RUN pi-acompanhar in h-acomp (INPUT STRING(tt-arquivos.arquivo,'x(200)')). 

        ASSIGN i-linhas = 0.

        INPUT STREAM stImpNF FROM VALUE(tt-arquivos.arquivo) NO-ECHO.
        block1:
        REPEAT:
            
            IMPORT STREAM stImpNF UNFORMATTED cLinha.

            ASSIGN i-linhas = i-linhas + 1.
            
            PUT UNFORMATTED cLinha SKIP.
            //Conforme layout passado, os dados est∆o apenas no segmento 1 e 2
            
            IF  TRIM(SUBSTRING(cLinha, 1,1)) = "1"
            AND TRIM(SUBSTRING(cLinha, 2,3)) = "TR" THEN DO:
                ASSIGN  c-data-recebto  = SUBSTRING(cLinha, 05,08)
                        c-serie         = SUBSTRING(cLinha, 13,03)
                        c-num-docto-1   = SUBSTRING(cLinha, 18,07) //No arquivo vem 9 posiá‰es, ent∆o utilizo apenas 7
                        c-num-docto-2   = SUBSTRING(cLinha, 25,09).
            END.
            
            IF  TRIM(SUBSTRING(cLinha, 1,1)) = "2" THEN DO:
                CREATE  ttDadosImportacao.
                ASSIGN  ttDadosImportacao.arquivo       = tt-arquivos.arquivo
                        ttDadosImportacao.data-recebto  = DATE(c-data-recebto)
                        ttDadosImportacao.serie         = c-serie        
                        ttDadosImportacao.num-docto-1   = c-num-docto-1
                        ttDadosImportacao.num-docto-2   = c-num-docto-2
                        ttDadosImportacao.sequencia     = INT(SUBSTRING(cLinha, 002,06)) * 10 //Multplicado por 10 pq o arquivo vem com sequencia 1..2 e o produto precisa sequencia 10..20
                        ttDadosImportacao.cod-produto   = SUBSTRING(cLinha, 008,25)
                        ttDadosImportacao.lote          = SUBSTRING(cLinha, 063,20)
                        ttDadosImportacao.dt-valid-lote = DATE(SUBSTRING(cLinha, 083,08))
                        ttDadosImportacao.un            = SUBSTRING(cLinha, 091,04)
                        ttDadosImportacao.qt-fiscal     = DEC(SUBSTRING(cLinha, 095,19))
                        ttDadosImportacao.qt-fisica     = DEC(SUBSTRING(cLinha, 114,19))
                        ttDadosImportacao.qt-avariada   = DEC(SUBSTRING(cLinha, 133,19)).
            END.     
        END.

        INPUT STREAM stImpNF CLOSE.

        FOR EACH ttDadosImportacao NO-LOCK:

            CREATE tt-nf.
            ASSIGN tt-nf.data-recebto = ttDadosImportacao.data-recebto
                  tt-nf.serie        = ttDadosImportacao.serie
                  tt-nf.num-docto-1  = ttDadosImportacao.num-docto-1
                  tt-nf.num-docto-2  = ttDadosImportacao.num-docto-2
                  tt-nf.arquivo      = tt-arquivos.arquivo.
                                            
            CREATE tt-item.                                                
            ASSIGN tt-item.data-recebto   = ttDadosImportacao.data-recebto 
                   tt-item.serie          = ttDadosImportacao.serie        
                   tt-item.num-docto-1    = ttDadosImportacao.num-docto-1  
                   tt-item.num-docto-2    = ttDadosImportacao.num-docto-2  
                   tt-item.sequencia      = ttDadosImportacao.sequencia    
                   tt-item.cod-produto    = ttDadosImportacao.cod-produto  
                   tt-item.lote           = ttDadosImportacao.lote         
                   tt-item.dt-valid-lote  = ttDadosImportacao.dt-valid-lote
                   tt-item.un             = ttDadosImportacao.un           
                   tt-item.qt-fiscal      = ttDadosImportacao.qt-fiscal    
                   tt-item.qt-fisica      = ttDadosImportacao.qt-fisica    
                   tt-item.qt-avariada    = ttDadosImportacao.qt-avariada.            
        END.

        //Arquivo deve estar vazio ou sem ENTER na linha
        IF i-linhas = 0 THEN DO:
            RUN pi-erro (INPUT tt-arquivos.arquivo,
                         INPUT "Arquivo fora do formato permitido ou vazio").
        END.
        ELSE DO:
            RUN pi-atualiza-dados.
        END.
    END.    
END PROCEDURE.

PROCEDURE pi-atualiza-dados:

    FOR EACH tt-nf NO-LOCK
        BREAK BY tt-nf.arquivo
              BY tt-nf.num-docto-1:
          
        IF FIRST-OF(tt-nf.num-docto-1) THEN DO:

           RUN pi-acompanhar in h-acomp (INPUT STRING(tt-nf.num-docto-1)).

              FOR EACH tt-item NO-LOCK
                  WHERE tt-item.num-docto-1 = tt-nf.num-docto-1
                  BREAK BY tt-item.cod-produto:

                  IF FIRST-OF(tt-item.cod-produto) THEN DO:

                    RUN pi-acompanhar in h-acomp (INPUT STRING(tt-item.cod-produto)).

                     FOR EACH it-nota-fisc NO-LOCK
                         WHERE it-nota-fisc.cod-estabel = tt-param.cod-estabel
                           AND it-nota-fisc.nr-nota-fis = tt-item.num-docto-1
                           AND it-nota-fisc.serie       = tt-item.serie
                           AND it-nota-fisc.it-codigo   = tt-item.cod-produto:
                           //AND it-nota-fisc.nr-seq-fat  = tt-item.sequencia:
 
                           FIND FIRST int-it-nota-fisc-alocado
                                WHERE int-it-nota-fisc-alocado.cod-estabel    = it-nota-fisc.cod-estabel
                                  AND int-it-nota-fisc-alocado.serie          = it-nota-fisc.serie 
                                  AND int-it-nota-fisc-alocado.nr-nota-fis    = it-nota-fisc.nr-nota-fis
                                  AND int-it-nota-fisc-alocado.nr-seq-fat     = it-nota-fisc.nr-seq-fat
                                  AND int-it-nota-fisc-alocado.it-codigo      = it-nota-fisc.it-codigo                   
                                  AND int-it-nota-fisc-alocado.log-recebida   = NO NO-LOCK NO-ERROR.
                           IF AVAIL int-it-nota-fisc-alocado THEN DO:
                               IF NOT int-it-nota-fisc-alocado.log-recebida THEN DO:
                                    FIND CURRENT int-it-nota-fisc-alocado EXCLUSIVE-LOCK NO-ERROR.

                                       ASSIGN  int-it-nota-fisc-alocado.log-recebida   = YES
                                               int-it-nota-fisc-alocado.data-recebida  = TODAY
                                               int-it-nota-fisc-alocado.qt-recebida    = int-it-nota-fisc-alocado.qt-faturada[1]. //ttDadosImportacao.qt-fisica.
                                      
                                       DISP STREAM str-rp 
                                            int-it-nota-fisc-alocado.cod-estabel
                                            int-it-nota-fisc-alocado.serie      
                                            int-it-nota-fisc-alocado.nr-nota-fis
                                            int-it-nota-fisc-alocado.cod-depos 
                                            int-it-nota-fisc-alocado.cod-localiz 
                                            int-it-nota-fisc-alocado.it-codigo  
                                            int-it-nota-fisc-alocado.cod-refer 
                                            //saldo-estoq.qt-alocada
                                            int-it-nota-fisc-alocado.qt-faturada[1]
                                            int-it-nota-fisc-alocado.qt-recebida  
                                            "Atualizado com sucesso." @ tt-arq-erro.erro    
                                            WITH FRAME f-nf.               
                                            DOWN STREAM str-rp WITH FRAME f-nf.
                               
                                       //IF LAST(ttDadosImportacao.arquivo) THEN DO:
                                       //   OS-COMMAND SILENT VALUE("move " + tt-item.arquivo + " " + tt-param.dir-processado).
                                       
                                   FIND CURRENT int-it-nota-fisc-alocado NO-LOCK NO-ERROR. 
                               END.
                               ELSE DO:
                                   RUN pi-erro (INPUT tt-nf.arquivo,
                                                INPUT "Dados j† Recebidos na data:" + 
                                                      "Data:" + string(int-it-nota-fisc-alocado.data-recebida) + 
                                                      ", Verifique1! ( Estab.:" + tt-param.cod-estabel + 
                                                      ", Serie.:" + tt-item.serie + 
                                                      ", NrNota:" + tt-item.num-docto-1 + 
                                                      ", Sequen:" + string(tt-item.sequencia) + ")" ).
                           
                                   /*
                                   PUT UNFORMATTED "Dados j† Recebidos na data:"
                                       "Data:" int-it-nota-fisc-alocado.data-recebida
                                       ", Verifique1! ( Estab.:" tt-param.cod-estabel 
                                                     ", Serie.:" ttDadosImportacao.serie
                                                     ", NrNota:" ttDadosImportacao.num-docto-1  
                                                     ", Sequen:" ttDadosImportacao.sequencia ")"
                                     SKIP.*/
                               END.
                           END.
                           ELSE DO:
                             RUN pi-erro (INPUT tt-nf.arquivo,
                                          INPUT "Nao encontrada NF informada:" + 
                                                ", Verifique! ( Estab.:" + tt-param.cod-estabel + 
                                                ", Serie.:" + tt-item.serie + 
                                                ", NrNota:" + tt-item.num-docto-1 + 
                                                ", Sequen:" + string(tt-item.sequencia) + ")" ).                            
                           END.
                     END. //it-nota-fisc 
                  END. //FIRST-OF tt-item
              END. //tt-item
          END. //FIRST-OF tt-nf
          IF LAST(tt-nf.arquivo) THEN DO:                                           
                 OS-COMMAND SILENT VALUE("move " + tt-nf.arquivo + " " + tt-param.dir-processado).
          END.
      END. //tt-nf
END PROCEDURE.


PROCEDURE pi-erro:
    DEFINE INPUT PARAMETER c-arq-erro   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER c-grava-erro AS CHARACTER NO-UNDO.
    
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
           tt-envio2.assunto           = "Atualiza Saldo em Transito Entreposto  - IMPORTANTE"    /* Assunto            */
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
END.


