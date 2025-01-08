{include/i-prgvrs.i esesb013RP 2.00.00.000}  


/*-------------------------------------------------*/
/*    D E F I N I Ä « O   T E M P - T A B L E S    */
/*-------------------------------------------------*/
define temp-table tt-param no-undo
    FIELD destino     AS INTEGER
    FIELD arquivo     AS CHAR format "x(35)"
    FIELD usuario     AS CHAR format "x(12)"
    FIELD data-exec   AS DATE
    FIELD hora-exec   AS INTEGER
    FIELD c-arq-DW    AS CHAR
    FIELD c-arq-fat   AS CHAR
    FIELD c-arq-benef AS CHAR
    FIELD rs-opcao    AS INTEGER
    FIELD rs-apuracao AS INTEGER
    FIELD c-arq-saida AS CHAR FORMAT "X(200)".

def temp-table tt-raw-digita 
    FIELD raw-digita	as raw.

DEF TEMP-TABLE tt-DW
    FIELD canal-central AS INTEGER
    FIELD canal         AS INTEGER
    FIELD unidade       AS CHAR
    FIELD vl-fat        AS DEC FORMAT "->>>>>,>>9.99"
    FIELD vl-dev        AS DEC FORMAT "->>>>>,>>9.99"
        INDEX idx-canal IS PRIMARY canal 
                                   unidade.

DEF TEMP-TABLE tt-fat
    FIELD canal-central AS INTEGER
    FIELD canal         AS INTEGER
    FIELD unidade       AS CHAR 
    FIELD emite-duplic  AS LOGICAL
    FIELD vl-fat        AS DEC FORMAT "->>>>>,>>9.99"
    FIELD vl-dev        AS DEC FORMAT "->>>>>,>>9.99"
    FIELD vl-frete      AS DEC
        INDEX idx-canal IS PRIMARY  canal 
                                    unidade.

DEF TEMP-TABLE tt-benef
    FIELD canal-central AS INTEGER
    FIELD canal         AS INTEGER
    FIELD unidade       AS CHAR 
    FIELD vl-fat        AS DEC FORMAT "->>>>>,>>9.99"
    FIELD vl-dev        AS DEC FORMAT "->>>>>,>>9.99"
        INDEX idx-canal IS PRIMARY canal 
                                   unidade.

DEF TEMP-TABLE tt-dados NO-UNDO
    FIELD canal-central AS INTEGER
    FIELD canal         AS INTEGER
    FIELD unidade       AS CHAR 
    FIELD tem-beneficio AS CHAR INIT "N«O"
    FIELD nome-abrev    AS CHAR FORMAT "X(12)"
    FIELD nome-emit     AS CHAR FORMAT "X(12)"
    FIELD vl-fat-DW     AS DEC  FORMAT "->>>>>,>>9.99"
    FIELD vl-dev-DW     AS DEC  FORMAT "->>>>>,>>9.99" 
    FIELD vl-fat-fatur  AS DEC  FORMAT "->>>>>,>>9.99"
    FIELD vl-dev-fatur  AS DEC  FORMAT "->>>>>,>>9.99"
    FIELD vl-fat-benef  AS DEC  FORMAT "->>>>>,>>9.99"
    FIELD vl-dev-benef  AS DEC  FORMAT "->>>>>,>>9.99"
    FIELD vl-frete      AS DEC   
    FIELD diverg-fat    AS LOG  
    FIELD diverg-dev    AS LOG  
        INDEX idx-canal IS UNIQUE PRIMARY canal unidade 
        INDEX idx-central IS UNIQUE canal-central canal unidade.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

DEF TEMP-TABLE tt-erro-benef NO-UNDO LIKE tt-erro.

{esp/esb/esesbapi005.i}
/* Carregada no .w, caso o usu†rio tenha optado por digitar os canais individualmente */
define temp-table tt-digita 
    FIELD canal-central     AS INTEGER
        INDEX idx-canal IS PRIMARY UNIQUE canal-central.

/*************** PAR∂METROS ***************/
DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE for tt-raw-digita.
 
CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

DEF VAR h-acomp AS HANDLE NO-UNDO.
IF  NOT VALID-HANDLE(h-acomp) THEN                                  
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.                      


/*------------------------*/
/*     I N C L U D E S    */
/*------------------------*/
/* include padr∆o para vari†veis de relat¢rio  */
{include/i-rpvar.i}
{include/i-freeac.i}
{include/i-rpout.i}
{include/i-rpcab.i}
{include/tt-edit.i}
{include/pi-edit.i}
{utp/ut-glob.i}

/* bloco principal do programa */
ASSIGN c-programa     = "esesb013"
       c-versao       = "2.00"
       c-revisao      = ".00.000"
       c-empresa      = "Intelbras"
       c-sistema      = "Canais Intelbras"
       c-titulo-relat = "Conciliaá∆o Base C†lculo Beneficios".

/*-------------------*/
/*   F U N Ä Â E S   */
/*-------------------*/

FUNCTION fn-retorna-nome-beneficio RETURNS CHAR
    (p-beneficio AS INT) FORWARD.

/*------------------------------------------------------*/
/*    I N ÷ C I O  -   B L O C O   P R I N C I P A L    */
/*------------------------------------------------------*/
VIEW FRAME f-cabec.
VIEW FRAME f-rodape.


IF  NOT VALID-HANDLE(h-acomp) THEN                                  
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.                      
                                                                    
IF  VALID-HANDLE(h-acomp) THEN                                      
    RUN pi-inicializar IN h-acomp (INPUT "Gerando Apuraá∆o").
    
DEF VAR c-labels AS CHAR FORMAT "X(300)" NO-UNDO.
DEF STREAM exp-saida.

                                                                                                                                                                                                                                                                                                   
/* Essa Ç a PROCEDURE PRINCIPAL do programa, a qual contro a transaá∆o */                                                                                                                                                                     
RUN PI-PRINCIPAL.                                                                                                                                                                                                                             

/* Retornou erro */
IF  CAN-FIND (FIRST tt-erro) OR RETURN-VALUE <> "OK" THEN DO:
    PUT "Erro       Mensagem" SKIP
        "---------- -------------------------------------------------------------------------------------------------------------------------" SKIP(1).

    FOR EACH tt-erro:
        PUT tt-erro.codigo TO 10
            tt-erro.mensagem  AT 12 SKIP
            tt-erro.ajuda AT 12 SKIP(1).
    END.

    PUT SKIP(3)"    ATENÄ«O: N∆o foi poss°vel concluir a apuraá∆o para o per°odo. Entre em contato com a TIC Intelbras.".
END.
ELSE 
    DISP SKIP(2) "    Conciliaá∆o executada com sucesso!".


PUT SKIP(2).
PUT "    Gerado arquivo de acompanhamento de Conciliaá∆o em .......: " tt-param.c-arq-saida  SKIP(1).
                                                                         

{include/i-rpclo.i}

if valid-handle(h-acomp) then    
    RUN pi-finalizar IN h-acomp. 
                                 
RETURN "OK".             


PROCEDURE PI-PRINCIPAL:

    RUN pi-inicializar IN h-acomp ("Processando").
    RUN pi-inicializar IN h-acomp ("Buscando canais Centras X Filiais").
    /* TODOS OS CANAIS DENTRO DA ESTRUTURA CENTRAL - FILIAL*/
    RUN esp/esb/esesbapi005.p (INPUT "",
                               OUTPUT TABLE tt-central,
                               OUTPUT TABLE tt-erro).

    IF  RETURN-VALUE <> "OK" 
    OR  CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK".

    RUN pi-importa-benef.
    IF  RETURN-VALUE <> "OK" THEN 
        RETURN "NOK".

/*     RUN pi-importa-DW.             */
/*     IF  RETURN-VALUE <> "OK" THEN  */
/*         RETURN "NOK".              */
    
    RUN pi-importa-fat.
    IF  RETURN-VALUE <> "OK" THEN
        RETURN "NOK".

    RUN pi-gera-conciliacao.
    IF  RETURN-VALUE <> "OK" THEN 
        RETURN "NOK".

    ASSIGN c-labels   = "CENTRAL;CANAL;NMABREV;NOME;UNIDADE;POSSUI BENEF.;ARQ BENEF;ARQ FATUR; F - G;ARQ DW; FAT - DEVOL;FRETE;DW - (Fat - Dev) - Frete;DEV ARQ BENEF;DEV ARQ FATUR; N - O".    

    OUTPUT STREAM exp-saida TO VALUE(tt-param.c-arq-saida) CONVERT TARGET "iso8859-1".
    PUT STREAM exp-saida c-labels SKIP.

    DEF VAR de-dif AS DEC NO-UNDO.
    DEF VAR de-dw AS DEC NO-UNDO.
    FOR EACH tt-dados
        BY tt-dados.canal
        BY tt-dados.unidade:
        
        ASSIGN de-dif = tt-dados.vl-fat-benef - tt-dados.vl-dev-benef.
               de-dw  = tt-dados.vl-fat-DW.  
/*         IF  de-dif < 0 THEN         */
/*             de-dif = de-dif  * -1.  */
/*                                     */
/*         IF  de-dw < 0 THEN          */
/*             de-dw = de-dw  * -1.    */
        
        PUT STREAM EXP-SAIDA UNFORMATTED  /* A */     tt-dados.canal-central  ";"
                                          /* B */     tt-dados.canal          ";"
                                          /* C */     tt-dados.nome-abrev     ";"
                                          /* D */     tt-dados.nome-emit      ";"
                                          /* E */     tt-dados.unidade        ";"
                                          /* F */     tt-dados.tem-beneficio  ";"
                                          /* G */     tt-dados.vl-fat-benef   ";"
                                          /* H */     tt-dados.vl-fat-fatur   ";"
                                          /* I */     (tt-dados.vl-fat-benef - tt-dados.vl-fat-fatur) ";"
                                          /* J */     de-dw /*tt-dados.vl-fat-DW */     ";"
                                          /* K */     de-dif ";"
                                          /* L */     tt-dados.vl-frete ";"
                                          /* M */     (de-dw - de-dif - tt-dados.vl-frete ) ";"     
                                          /* N */     tt-dados.vl-dev-benef   ";"
                                          /* O */     tt-dados.vl-dev-fatur   ";"
                                          /* P */    (tt-dados.vl-dev-benef - tt-dados.vl-dev-fatur )  ";" SKIP.

    END.

    OUTPUT STREAM exp-saida CLOSE.

    RETURN "OK".

END.


PROCEDURE pi-gera-conciliacao:

    DEF VAR de-tot-fat   AS DEC NO-UNDO.
    DEF VAR de-tot-dev   AS DEC NO-UNDO.
    DEF VAR de-tot-frete AS DEC NO-UNDO.
    DEF VAR c-nome-abrev AS CHAR FORMAT "X(12)".
    DEF VAR c-nome-emit  AS CHAR FORMAT "X(60)".

    RUN pi-inicializar IN h-acomp ("Processando Conciliaá∆o").
    /* Cria o arquivo TT-DADOS primeiro com base no arquivo de beneficio */
    FOR EACH tt-benef
        BREAK BY tt-benef.canal
              BY tt-benef.unidade:

        IF  FIRST-OF (tt-benef.canal) THEN
            FOR FIRST emitente FIELDS (nome-abrev nome-emit) NO-LOCK
                 WHERE emitente.cod-emitente = tt-benef.canal:
                 ASSIGN c-nome-abrev = emitente.nome-abrev
                        c-nome-emit  = emitente.nome-emit.
            END.

        IF  FIRST-OF (tt-benef.unidade) THEN
            ASSIGN de-tot-fat = 0
                   de-tot-dev = 0.

        ASSIGN de-tot-fat =  de-tot-fat + tt-benef.vl-fat
               de-tot-dev =  de-tot-dev + tt-benef.vl-dev.

        IF  LAST-OF (tt-benef.unidade) THEN DO:

            RUN pi-acompanhar IN h-acomp ("Arq. Benef°cios - Canal " + string(tt-benef.canal)).
        
            CREATE tt-dados.
            ASSIGN tt-dados.canal-central = tt-benef.canal-central
                   tt-dados.canal         = tt-benef.canal
                   tt-dados.unidade       = tt-benef.unidade
                   tt-dados.nome-abrev    = c-nome-abrev
                   tt-dados.nome-emit     = c-nome-emit
                   tt-dados.vl-fat-benef  = de-tot-fat
                   tt-dados.vl-dev-benef  = de-tot-dev
                   tt-dados.tem-beneficio = "SIM".

        END.
    END.

    RELEASE tt-dados.

/*     /* LER ARQUIVO DO DW E COMPARAR */                                                */
/*     FOR EACH tt-DW                                                                    */
/*         BREAK BY tt-DW.canal                                                          */
/*               BY tt-DW.unidade:                                                       */
/*                                                                                       */
/*         IF  FIRST-OF (tt-DW.canal) THEN                                               */
/*             FOR FIRST emitente FIELDS (nome-abrev nome-emit) NO-LOCK                  */
/*                  WHERE emitente.cod-emitente = tt-DW.canal:                           */
/*                  ASSIGN c-nome-abrev = emitente.nome-abrev                            */
/*                         c-nome-emit  = emitente.nome-emit.                            */
/*             END.                                                                      */
/*                                                                                       */
/*         IF  FIRST-OF (tt-DW.unidade) THEN                                             */
/*             ASSIGN de-tot-fat = 0                                                     */
/*                    de-tot-dev = 0.                                                    */
/*                                                                                       */
/*         ASSIGN de-tot-fat =  de-tot-fat + tt-DW.vl-fat                                */
/*                de-tot-dev =  de-tot-dev + tt-DW.vl-dev.                               */
/*                                                                                       */
/*         IF  LAST-OF (tt-DW.unidade) THEN DO:                                          */
/*             RUN pi-acompanhar IN h-acomp ("Arq. DW - Canal " + string(tt-DW.canal)).  */
/*                                                                                       */
/*                                                                                       */
/*             FIND FIRST tt-dados                                                       */
/*                  WHERE tt-dados.canal     = tt-DW.canal                               */
/*                    AND tt-dados.unidade   = tt-DW.unidade NO-ERROR.                   */
/*                                                                                       */
/*             IF  AVAIL tt-dados THEN DO:                                               */
/*                 ASSIGN tt-dados.vl-fat-DW  = de-tot-fat                               */
/*                        tt-dados.vl-dev-DW  = de-tot-dev.                              */
/*             END.                                                                      */
/*             ELSE DO:                                                                  */
/*                                                                                       */
/*                 CREATE tt-dados.                                                      */
/*                 ASSIGN tt-dados.canal-central = tt-DW.canal-central                   */
/*                        tt-dados.canal         = tt-DW.canal                           */
/*                        tt-dados.unidade       = tt-DW.unidade                         */
/*                        tt-dados.nome-abrev    = c-nome-abrev                          */
/*                        tt-dados.nome-emit     = c-nome-emit                           */
/*                        tt-dados.vl-fat-DW     = de-tot-fat                            */
/*                        tt-dados.vl-dev-DW     = de-tot-dev.                           */
/*                                                                                       */
/*             END.                                                                      */
/*                                                                                       */
/*         END.                                                                          */
/*     END.                                                                              */

    /* LER ARQUIVO DO DW E COMPARAR */
    FOR EACH tt-fat
        BREAK BY tt-fat.canal
              BY tt-fat.unidade:

        IF  FIRST-OF (tt-fat.canal) THEN
            FOR FIRST emitente FIELDS (nome-abrev nome-emit) NO-LOCK
                 WHERE emitente.cod-emitente = tt-fat.canal:
                 ASSIGN c-nome-abrev = emitente.nome-abrev
                        c-nome-emit  = emitente.nome-emit.
            END.

        IF  FIRST-OF (tt-fat.unidade) THEN
            ASSIGN de-tot-fat   = 0
                   de-tot-dev   = 0
                   de-tot-frete = 0.

        ASSIGN de-tot-fat   =  de-tot-fat   + tt-fat.vl-fat
               de-tot-dev   =  de-tot-dev   + tt-fat.vl-dev
               de-tot-frete =  de-tot-frete + tt-fat.vl-frete.

        IF  LAST-OF (tt-fat.unidade) THEN DO:
            RUN pi-acompanhar IN h-acomp ("Arq. DW - Canal " + string(tt-fat.canal)).

            FIND FIRST tt-dados
                 WHERE tt-dados.canal     = tt-fat.canal
                   AND tt-dados.unidade   = tt-fat.unidade NO-ERROR.

            IF  AVAIL tt-dados THEN DO:

                ASSIGN tt-dados.vl-fat-fatur  = de-tot-fat
                       tt-dados.vl-dev-fatur  = de-tot-dev
                       tt-dados.vl-frete      = de-tot-frete.
            END.
            ELSE DO:
                CREATE tt-dados.
                ASSIGN tt-dados.canal-central = tt-fat.canal-central
                       tt-dados.canal         = tt-fat.canal
                       tt-dados.nome-abrev    = c-nome-abrev
                       tt-dados.nome-emit     = c-nome-emit
                       tt-dados.unidade       = tt-fat.unidade
                       tt-dados.vl-fat-fatur  = de-tot-fat
                       tt-dados.vl-dev-fatur  = de-tot-dev
                       tt-dados.vl-frete      = de-tot-frete.

            END.

        END.

    END.

    RETURN "OK".
END.


PROCEDURE pi-importa-fat:

    DEF VAR c-linha AS CHAR FORMAT "X(100)".
    DEF VAR i AS INTEGER NO-UNDO.
    DEF VAR c-canal AS INT NO-UNDO.
    DEF VAR c-item AS CHAR NO-UNDO.
    DEF VAR c-unidade AS CHAR.
    DEF VAR de-valor AS DEC.

    RUN pi-inicializar IN h-acomp ("Importaá∆o Arquivo Faturamento").

    INPUT FROM value(tt-param.c-arq-fat).
    
    REPEAT:
        IMPORT UNFORMATTED c-linha.

        RUN pi-acompanhar IN h-acomp ("linha: " + STRING(i)).
        IF  i <> 0 THEN DO:
        
            FIND FIRST tt-central
                 WHERE tt-central.canal-filial = INT(entry(06, c-linha, ";")) NO-ERROR.

            IF  AVAIL tt-central THEN DO:
            
                CREATE tt-fat.
                ASSIGN tt-fat.canal-central = tt-central.canal-central
                       tt-fat.canal         = INT(entry(06, c-linha, ";"))
                       tt-fat.unidade       =     entry(42, c-linha, ";")
                       tt-fat.emite-duplic  = IF  entry(03, c-linha, ";") = "SIM" THEN YES ELSE NO.

                IF  tt-fat.unidade = "" THEN
                    ASSIGN tt-fat.unidade =  entry(33, c-linha, ";").
    
                IF  dec(entry(26, c-linha, ";")) < 0 AND entry(45, c-linha, ";") <> "" THEN
                    ASSIGN tt-fat.vl-dev   = dec(entry(26, c-linha, ";")) * (-1).
                ELSE                                                                                                                                       
                    ASSIGN tt-fat.vl-fat   = IF  tt-fat.emite-duplic THEN    
                                                 DEC(entry(26, c-linha, ";"))
                                             ELSE                            
                                                 0
                           tt-fat.vl-frete = IF  tt-fat.emite-duplic THEN
                                                 DEC(entry(61, c-linha, ";")) 
                                             ELSE
                                                 0 .                          
            END.
        END.

        ASSIGN i = i + 1.
    
        IF  c-linha = "" THEN
            LEAVE.

    END.

    MESSAGE "i: " i
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN "OK".

END.

PROCEDURE pi-importa-benef:

    DEF VAR c-linha AS CHAR FORMAT "X(100)".
    DEF VAR i AS INTEGER NO-UNDO INIT 0.
    
    RUN pi-inicializar IN h-acomp ("Importaá∆o Arquivo Beneficios").
    INPUT FROM value(tt-param.c-arq-benef).
    
    REPEAT:
        IMPORT UNFORMATTED c-linha.

        RUN pi-acompanhar IN h-acomp ("linha: " + STRING(i)).
        IF  i <> 0 THEN DO:

            FIND FIRST tt-central
                 WHERE tt-central.canal-filial = INT(entry(04, c-linha, ";")) NO-ERROR.

            IF  AVAIL tt-central THEN DO:
                
                CREATE tt-benef.
                ASSIGN tt-benef.canal-central = tt-central.canal-central
                       tt-benef.canal         = INT(entry(04, c-linha, ";"))
                       tt-benef.unidade       =     replace(entry(05, c-linha, ";"), '"', '')
                       tt-benef.vl-fat        = dec(entry(13, c-linha, ";"))
                       tt-benef.vl-dev        = /*DEC(entry(20, c-linha, ";"))*/ DEC(entry(21, c-linha, ";")).
            END.
                                     
        END.

        ASSIGN i = i + 1.
    
        IF  c-linha = "" THEN
            LEAVE.

    END.

    RETURN "OK".
END.

PROCEDURE pi-importa-DW:

    DEF VAR c-linha AS CHAR FORMAT "X(100)".
    DEF VAR i AS INTEGER NO-UNDO.
    
    RUN pi-inicializar IN h-acomp ("Importaá∆o Arquivo DW").

    INPUT FROM value(tt-param.c-arq-DW).
    
    REPEAT:
        IMPORT UNFORMATTED c-linha.

        RUN pi-acompanhar IN h-acomp ("linha: " + STRING(i)).
        IF  i <> 0 THEN DO:

            FIND FIRST tt-central
                 WHERE tt-central.canal-filial = int(entry(2, c-linha, ";")) NO-ERROR.

            IF AVAIL tt-central THEN DO:        
                CREATE tt-DW.
                ASSIGN tt-DW.canal-central = tt-central.canal-central
                       tt-DW.canal         = int(entry(2, c-linha, ";"))
                       tt-DW.unidade       =     entry(7, c-linha, ";")
                       tt-DW.vl-fat        =  dec(entry(17, c-linha, ";")).
            END.
        END.

        ASSIGN i = i + 1.
    
        IF  c-linha = "" THEN
            LEAVE.

    END.


    RETURN "OK".

END.


/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*                                                          F U N Ä Â E S   I N T E R N A S                                                                                */
/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION fn-retorna-nome-beneficio RETURNS CHAR
    (p-beneficio AS INT):
    
    CASE p-beneficio:
        WHEN 21 THEN RETURN "VMC".
        WHEN 22 THEN RETURN "STOCK ROTATION".
        WHEN 37 THEN RETURN "REBATE".
        WHEN 66 THEN RETURN "REBATE P‡S-VENDA".
    END CASE.

    RETURN "".
END FUNCTION.

