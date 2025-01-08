
{include/i-prgvrs.i esofp0005rp 2.00.00.001} 

/* Definiá∆o das temp-tables para recebimento de parÉmetros */

/* Parameters Definitions ---                                           */
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    FIELD c-periodo        AS CHAR
    field banco            as integer
    field agencia          as integer
    field conta            as char
    FIELD cArquivoLog      AS CHAR.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.

DEFINE TEMP-TABLE ttRowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

define temp-table tt-raw-digita no-undo
    FIELD raw-digita AS RAW.

/* Recebimento dos parÉmetros */
DEFINE INPUT  PARAMETER raw-param AS RAW      NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

/* Outras includes */
{include/i-rpvar.i}

/* Vari†veis Locais */
DEFINE VARIABLE h-acomp   AS HANDLE     NO-UNDO.

{include/i-rpout.i}

/*******Gera Arquivo de Log da Impress∆o dos CTRCs e geraá∆o das NFS *******/
DEFINE STREAM s-log.

OUTPUT STREAM s-log TO VALUE(tt-param.cArquivoLog) CONVERT TARGET "iso8859-1".

/*************** GERAÄ«O/IMPRESS«O DOS CONHECIMENTOS DE FRTE****************/
FIND FIRST estabelec
    WHERE estabelec.estado = "AM" NO-LOCK NO-ERROR.

DEF VAR c-aux AS CHAR NO-UNDO.

/**  Registro: 00 - "Dados do Header da Mensal"  **/
ASSIGN c-aux = "00DCI/ZFM202.002" +
               SUBSTR(tt-param.c-periodo, 3,4)   +
               SUBSTR(tt-param.c-periodo, 1,2) +
               "00000000000000     000000"     +
               estabelec.cgc.

PUT STREAM s-log UNFORMATTED c-aux SKIP.

/** Registro: 01 - "Dados da DCI Mensal"  **/
ASSIGN c-aux =  "0122" +                                            
                SUBSTR(tt-param.c-periodo, 3,4) +                  
                SUBSTR(tt-param.c-periodo, 1,2) +                  
                estabelec.cgc +                                    
                "00000000000000     000000000000000000000000000                 " +  
                string(tt-param.banco, "999") +
                string(tt-param.agencia, "9999") +
                tt-param.conta.                              
PUT STREAM s-log UNFORMATTED c-aux SKIP.



/** Registro: 02 - "Dados Mandado Judicial" **/
PUT STREAM s-log "02NN000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000N000000000000000"
                 SKIP.



/** Registro: 03 - "Dados Retificaá∆o" **/
PUT STREAM s-log "03000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
                 SKIP.


/****************************** Registro: 11 - "Dados do produto-local da DCI Mensal - PE" ******************************/
DEF VAR da-ini          AS DATE NO-UNDO.
DEF VAR da-fim          AS DATE NO-UNDO.
DEF VAR de-quantidade   AS DEC DECIMALS 4 FORMAT "99999999999999".
DEF VAR c-local-destino AS CHAR NO-UNDO.

ASSIGN da-ini = DATE("01/" + SUBSTR(tt-param.c-periodo,1,2) + "/" + SUBSTR(tt-param.c-periodo,3,4)).

ASSIGN da-fim  = da-ini + 33
       da-fim  = DATE("01/" + string(MONTH(da-fim)) + "/" + string(YEAR(da-fim)))
       da-fim  = da-fim - 1.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp ("Gerando <Dados do produto-local da DCI Mensal - PE>").

FOR EACH nota-fiscal NO-LOCK
    WHERE nota-fiscal.dt-emis-nota >= da-ini
      AND nota-fiscal.dt-emis-nota <= da-fim
      AND nota-fiscal.cod-estabel = estabelec.cod-estabel
      AND substr(nota-fiscal.nat-operacao, 1, 1) = "6"
    ,EACH it-nota-fisc NO-LOCK 
        OF nota-fiscal
    ,FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = it-nota-fisc.it-codigo
          AND ITEM.codigo-orig > 0
    BREAK BY item.it-codigo:

    RUN pi-acompanhar IN h-acomp ("Registro 11, gerando SÇrie: " + nota-fiscal.serie + " Nota:" + nota-fiscal.nr-nota-fis).

    IF  FIRST-OF (ITEM.it-codigo) THEN
        ASSIGN de-quantidade = 0.
    
    ASSIGN de-quantidade = de-quantidade + it-nota-fisc.qt-faturada [1].

    IF  LAST-OF (ITEM.it-codigo) THEN
        RUN pi-cria-registro-11.

END.

RUN pi-acompanhar IN h-acomp ("< Produto-local da DCI Mensal / PI Com PPB > ").
/****************************** Registro: 21 - "Produto-local da DCI Mensal / PI Com PPB" ******************************/
FOR EACH nota-fiscal NO-LOCK
    WHERE nota-fiscal.dt-emis-nota >= da-ini
      AND nota-fiscal.dt-emis-nota <= da-fim
      AND nota-fiscal.cod-estabel = estabelec.cod-estabel
      AND substr(nota-fiscal.nat-operacao, 1, 1) = "6"
    ,EACH it-nota-fisc NO-LOCK 
        OF nota-fiscal
    ,FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = it-nota-fisc.it-codigo
          AND ITEM.codigo-orig = 0 /* Produto Fabricado */
    BREAK BY item.it-codigo:

    RUN pi-acompanhar IN h-acomp ("Registro 21, gerando SÇrie: " + nota-fiscal.serie + " Nota:" + nota-fiscal.nr-nota-fis).

    IF  FIRST-OF (ITEM.it-codigo) THEN
        ASSIGN de-quantidade = 0.
    
    ASSIGN de-quantidade = de-quantidade + it-nota-fisc.qt-faturada [1].

    IF  LAST-OF (ITEM.it-codigo) THEN
        RUN pi-cria-registro-21.

END.

IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.


PROCEDURE pi-cria-registro-21:

    /* Verifica o local a que se destina o produto. */
    RUN pi-local-destino (OUTPUT c-local-destino).  
    
    ASSIGN c-aux = "21000" + 
                    c-local-destino + 
                    item.cod-dcr-item +
                    string(ITEM.it-codigo, "x(15)") +
                    fill("0",9) +
                    string(ITEM.desc-item, "x(45)") +
                    fill("0",20) +
                    fill("0",5) +
                    fill("0",14) +
                    STRING(de-quantidade * 100000, "99999999999999") +
                    "UNIDADE             " +
                    fill("0",20) +
                    fill("0",20) .
                    
    PUT STREAM S-LOG UNFORMATTED c-aux SKIP.

END.

PROCEDURE pi-cria-registro-11:

    /* Verifica o local a que se destina o produto. */
    RUN pi-local-destino (OUTPUT c-local-destino).  
    
    ASSIGN c-aux = "11000" + 
                    STRING(ITEM.class-fiscal, "x(08)") + 
                    string(ITEM.it-codigo, "x(15)") +
                    c-local-destino + 
                    string(ITEM.desc-item, "x(45)") +
                    string("", "x(253)") +
                    "00000" +
                    string("", "x(253)") +
                    "00000" +
                    string("", "x(20)") +
                    fill("0",14) +
                    STRING(de-quantidade * 100000, "99999999999999") +
                    fill("0",20) +
                    fill("0",15) +
                    STRING(de-quantidade * 100000, "99999999999999") +
                    "UNIDADE             ".
    PUT STREAM S-LOG UNFORMATTED c-aux SKIP.

END.

/*Fechar aquivo de LOG*/
OUTPUT STREAM s-log CLOSE.

PROCEDURE pi-local-destino:
    DEF OUTPUT PARAM p-destino AS CHAR NO-UNDO.

    DEF VAR c-cidades-fora-zf      AS CHAR NO-UNDO.
    DEF VAR c-estados-am-ocidental AS CHAR NO-UNDO.
    DEF VAR i                      AS INTEGER NO-UNDO.
    DEF VAR l-fora-AM-Ocidental    AS LOGICAL NO-UNDO.
    DEF VAR l-UF-AM-Ocidental      AS LOGICAL NO-UNDO.
    
    FOR EACH ponto-programa NO-LOCK
         WHERE ponto-programa.cod-programa = 202
           AND ponto-programa.ponto = 1:
             
         /* Cidades fora Amazìnia Ocidental */
         FOR EACH conteudo-programa NO-LOCK
             WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
             IF  c-cidades-fora-zf <> "" THEN
                 ASSIGN c-cidades-fora-zf = c-cidades-fora-zf + ";" + conteudo-programa.conteudo.
             ELSE
                 ASSIGN c-cidades-fora-zf = conteudo-programa.conteudo.
         END.
    END.
    
    FOR EACH ponto-programa NO-LOCK
         WHERE ponto-programa.cod-programa = 203
           AND ponto-programa.ponto = 2:
    
         FOR EACH conteudo-programa NO-LOCK
             WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
             IF  c-estados-am-ocidental <> "" THEN
                 ASSIGN c-estados-am-ocidental = c-estados-am-ocidental + ";" + conteudo-programa.conteudo.
             ELSE
                 ASSIGN c-estados-am-ocidental = conteudo-programa.conteudo.
         END.
    END.

    /* Cidades fora Amazìnia Ocidental */
    DO  i = 1 TO NUM-ENTRIES(c-cidades-fora-zf, ";"):
        IF  ENTRY(i,c-cidades-fora-zf, ";") = nota-fiscal.cidade THEN
            ASSIGN l-fora-AM-Ocidental = YES.
    END.

    DO  i = 1 TO NUM-ENTRIES(c-estados-am-ocidental, ";"):
         IF  ENTRY(i, c-estados-am-ocidental, ";") = nota-fiscal.estado THEN
            ASSIGN l-UF-AM-Ocidental = YES.
    END.

    /************************* DETERMINA O LOCA DE DESTINO DO PRODUTO ******************/
    IF  l-UF-AM-Ocidental THEN DO:
        ASSIGN p-destino = "1". /* Amazìnia Ocidental */

        /* Verifica se Ç ZONA FRANCA/µREA DE LIVRE COMêRCIO */
        FOR FIRST cidade-zf NO-LOCK
            WHERE cidade-zf.cidade = nota-fiscal.cidade
              AND cidade-zf.estado = nota-fiscal.estado:

            IF  l-fora-AM-Ocidental THEN
                ASSIGN p-destino = "4". /* ALC situada FORA da Amaz Ocidental*/
            ELSE
                ASSIGN p-destino = "3". /* ALC situada na Amaz. Ocidental */

        END.
    END.
    ELSE
        ASSIGN p-destino = "2". /* Demais Regi‰es */

END.

{include/i-rpclo.i}

RETURN "OK":U.

