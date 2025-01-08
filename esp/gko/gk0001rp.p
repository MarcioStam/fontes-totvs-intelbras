/*****************************************************************************
**
**     Objetivo: Notas Fiscais de Saida do EMS para GKO
** 
**     Versao..: 2.00.00.000
**     Autor: hoepers - 15/03/2012
*****************************************************************************/
{include/i-prgvrs.i gk0001 2.00.00.000}

{esp/es0018.i}
{esp/gko/gk0001tt.i}

   

def temp-table tt-raw-digita
    field raw-digita as raw.

DEF TEMP-TABLE tt-cliente NO-UNDO
    FIELD cod-emitente LIKE emitente.cod-emitente
    FIELD cod-estabel  LIKE estabelec.cod-estabel
    INDEX id-emitente
            cod-emitente.

DEF TEMP-TABLE tt-series NO-UNDO
    FIELD serie LIKE nota-fiscal.serie
    INDEX id-serie
            serie.

DEF TEMP-TABLE tt-naturezas NO-UNDO
    FIELD nat-operacao LIKE nota-fiscal.nat-operacao
    INDEX id-nota
        nat-operacao.

DEF TEMP-TABLE tt-esp-docto NO-UNDO
    FIELD esp-docto LIKE nota-fiscal.esp-docto
    INDEX id-esp-docto
        esp-docto.

DEF TEMP-TABLE tt-transportadora NO-UNDO
    FIELD nome-abrev LIKE transporte.nome-abrev
    INDEX id-transportadora
            nome-abrev.

DEF TEMP-TABLE tt-volume-item-nf NO-UNDO
    FIELD nr-volume      LIKE volume-nf.nr-volume
    FIELD it-codigo      LIKE volume-nf.it-codigo
    FIELD nr-seq-fat     LIKE it-nota-fisc.nr-seq-fat
    FIELD log-fracionado LIKE volume-nf.varios-itens
    FIELD qtd-m3       AS DEC
    INDEX id-volume
            nr-volume
    INDEX id-item
            it-codigo
            nr-seq-fat.

DEF TEMP-TABLE tt-prog-entrada NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

DEF TEMP-TABLE tt-prog-pont5 NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

DEF TEMP-TABLE tt-prog-pont6 NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

DEF TEMP-TABLE tt-prog-pont7 NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

DEF TEMP-TABLE tt-prog-pont8 NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

/****Variaveis de Relatorio******/
DEFINE BUFFER   b-nota-fiscal         FOR  nota-fiscal.
DEFINE VARIABLE v-qtd-volumes         LIKE nota-embal.qt-volumes     NO-UNDO.
DEFINE VARIABLE v-qtd-total-volumes   LIKE nota-embal.qt-volumes     NO-UNDO.
DEFINE VARIABLE v-cod-familia         LIKE ITEM.fm-codigo            NO-UNDO.
DEFINE VARIABLE v-cod-item            LIKE ITEM.it-codigo            NO-UNDO.
DEFINE VARIABLE v-qtd-peso-bruto      LIKE it-nota-fisc.peso-bruto   NO-UNDO.
DEFINE VARIABLE v-qtd-peso-liq        LIKE it-nota-fisc.peso-liq-fat NO-UNDO.
DEFINE VARIABLE h-acomp                 AS HANDLE                    NO-UNDO.
DEFINE VARIABLE v-num-entr-param        AS INTEGER                   NO-UNDO.
DEFINE VARIABLE v-ind-modal-peso-cubado AS INTEGER                   NO-UNDO.
DEFINE VARIABLE v-cod-tipo-operac       AS CHARACTER                 NO-UNDO. 
DEFINE VARIABLE v-cod-arq-destino       AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE v-cod-arq-destino2      AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE v-cod-embalagem         AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE v-cod-conta-contab      AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE v-cod-ccusto            AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE v-des-tipo-carga        AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE v-dat-tmp               AS DATE                      NO-UNDO.
DEFINE VARIABLE v-qtd-peso-cubado       AS DECIMAL                   NO-UNDO.
DEFINE VARIABLE c-conhecimento          AS CHARACTER FORMAT 'x(200)' NO-UNDO.
DEFINE VARIABLE i-nro-itens             AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-via                   AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-transp-redesp         AS CHAR NO-UNDO.
DEFINE VARIABLE v-cod-transp           AS CHAR NO-UNDO.
DEFINE VARIABLE v-cgc-transp            AS CHAR FORMAT 'x(19)' NO-UNDO .


DEFINE BUFFER b-emitente         FOR emitente.
DEFINE BUFFER b-emitente-reg-100 FOR emitente.
DEFINE BUFFER b-it-nota-fisc     FOR it-nota-fisc.
DEFINE BUFFER b-emitente-retirada FOR emitente.
DEFINE BUFFER b-emitente-transp   FOR emitente.

DEFINE VARIABLE c-arquivo-entrada AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-linha           AS CHAR FORMAT "X(200)" NO-UNDO.
DEFINE VARIABLE c-TpStatusDNE     AS CHAR NO-UNDO.

/* 
Valores poss­veis para o campo v-cod-tipo-operac

I - Incluir se nÆo existir ou Rejeitar se existir
A - Incluir se nÆo existir ou Atualizar se existir
M - Alterar se existir ou Rejeitar se nÆo existir
E - Excluir se existir ou Rejeitar se nÆo existir
*/

{include/i-rpvar.i}
{include/i-freeac.i}

/*********************************************************************/

FIND LAST param-global NO-LOCK NO-ERROR.
RUN utp/ut-acomp.p PERSISTEN SET h-acomp.
RUN pi-inicializar IN h-acomp("Extra‡Æo de nota GKO").
DEF STREAM s-arquivo.
create tt-param.
raw-transfer raw-param to tt-param.
assign c-programa     = "GK0001"
       c-sistema      = "Notas Fiscais EMS para GKO"
       c-titulo-relat = "Notas Fiscais EMS para GKO"
       c-versao       = "2.00.00"
       c-revisao      = "000"
       c-empresa      = "Intelbras".
{include/i-rpout.i}
{include/i-rpcab.i}

EMPTY TEMP-TABLE tt-cliente.
EMPTY TEMP-TABLE tt-series.
EMPTY TEMP-TABLE tt-naturezas.
EMPTY TEMP-TABLE tt-esp-docto.
EMPTY TEMP-TABLE tt-transportadora.
EMPTY TEMP-TABLE tt-prog-entrada.
EMPTY TEMP-TABLE tt-prog-pont5.
EMPTY TEMP-TABLE tt-prog-pont6.
EMPTY TEMP-TABLE tt-prog-pont7.
EMPTY TEMP-TABLE tt-prog-pont8.
/* Identificar diret½rio destino dos arquivos */
FOR FIRST ponto-programa
    WHERE ponto-programa.nome-programa = "gk0001"
      AND ponto-programa.ponto         = 1,
     EACH conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
    IF  conteudo-programa.conteudo                  <> "" AND
        NUM-ENTRIES(conteudo-programa.conteudo,";")  > 1
    THEN DO:
        IF  OPSYS = "WIN32"
        THEN DO:
            IF  ENTRY(1,conteudo-programa.conteudo,";") = "ENTRADAGKOWIN32"
            THEN
                ASSIGN v-cod-arq-destino  = ENTRY(2,conteudo-programa.conteudo,";")
                       v-cod-arq-destino2 = ENTRY(2,conteudo-programa.conteudo,";").
        END.
        ELSE DO:
            IF  ENTRY(1,conteudo-programa.conteudo,";") = "ENTRADAGKOUNIX"
            THEN
                ASSIGN v-cod-arq-destino  = ENTRY(2,conteudo-programa.conteudo,";")
                       v-cod-arq-destino2 = ENTRY(2,conteudo-programa.conteudo,";").
        END.
    END.
END.

DEF VAR v-cod-arq-destino-aux AS CHAR.
DEF VAR v-cod-arq-destino-aux2 AS CHAR.

ASSIGN v-cod-arq-destino-aux = v-cod-arq-destino.
ASSIGN v-cod-arq-destino-aux2 = v-cod-arq-destino2.

/* Identificar par³metros para filtro de notas */
FOR FIRST ponto-programa
    WHERE ponto-programa.nome-programa = "gk0001"
      AND ponto-programa.ponto         = 2,
     EACH conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
    IF  conteudo-programa.conteudo                  <> "" AND
        NUM-ENTRIES(conteudo-programa.conteudo,";")  > 1
    THEN DO:
        IF  ENTRY(1,conteudo-programa.conteudo,";") = "CLIENTE"
        THEN DO:
            DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                IF INDEX(ENTRY(v-num-entr-param,conteudo-programa.conteudo,";"),"-") <> 0 THEN DO:
                    CREATE tt-cliente.
                    ASSIGN tt-cliente.cod-estabel  = entry(1,ENTRY(v-num-entr-param,conteudo-programa.conteudo,";"),"-")
                           tt-cliente.cod-emitente = int(entry(2,ENTRY(v-num-entr-param,conteudo-programa.conteudo,";"),"-")).
                END.
                ELSE DO:
                    CREATE tt-cliente.
                    ASSIGN tt-cliente.cod-emitente = INT(ENTRY(v-num-entr-param,conteudo-programa.conteudo,";")).
                END.
            END.
        END.

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "SERIE"
        THEN DO:
            DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                CREATE tt-series.
                ASSIGN tt-series.serie = ENTRY(v-num-entr-param,conteudo-programa.conteudo,";").
            END.
        END.

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "NATUREZA"
        THEN DO:
            DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                CREATE tt-naturezas.
                ASSIGN tt-naturezas.nat-operacao = ENTRY(v-num-entr-param,conteudo-programa.conteudo,";").
            END.
        END.

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "ESPDOCTO"
        THEN DO:
            DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                CREATE tt-esp-docto.
                ASSIGN tt-esp-docto.esp-docto = INT(ENTRY(v-num-entr-param,conteudo-programa.conteudo,";")).
            END.
        END.

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "TRANSPORTADORA"
        THEN DO:
            /* Para transportadoras deve ser cadastrado nos par³metros qual n’o deve integrar */
            DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                CREATE tt-transportadora.
                ASSIGN tt-transportadora.nome-abrev = ENTRY(v-num-entr-param,conteudo-programa.conteudo,";").
            END.
        END.
    END.
END.
    
    IF tt-param.tg-habilita = YES THEN DO:

        ASSIGN tt-param.log-desconsidera = YES
               c-arquivo-entrada = tt-param.c-arquivo-entrada.

        INPUT FROM VALUE(c-arquivo-entrada) CONVERT TARGET SESSION:CHARSET.
        
        RUN esp/es0018p.p (INPUT "gk0001":U,
                           INPUT 4,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-entrada).



        RUN esp/es0018p.p (INPUT "gk0001":U,
                           INPUT 7,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-entrada).

        RUN esp/es0018p.p (INPUT "gk0001":U,             
                           INPUT 8,                      
                           INPUT 0,                      
                           INPUT "":U,                   
                           OUTPUT TABLE tt-prog-entrada).  

        REPEAT:
            IMPORT UNFORMATTED c-linha.

            IF tt-param.log-nota-entrada THEN DO:
                FIND FIRST docum-est NO-LOCK
                     WHERE docum-est.cod-estabel  = ENTRY(1, c-linha, ";")
                       AND docum-est.serie-docto  = ENTRY(2, c-linha, ";")  
                       AND docum-est.nro-docto    = ENTRY(3, c-linha, ";") NO-ERROR.

                IF AVAIL docum-est  THEN DO:

                   RUN imprimi-nf-entrada-arquivo. 
                END.
            END.
            ELSE DO:
                FIND FIRST nota-fiscal NO-LOCK
                    WHERE nota-fiscal.cod-estabel  = ENTRY(1, c-linha, ";")
                      AND nota-fiscal.serie        = ENTRY(2, c-linha, ";")  
                      AND nota-fiscal.nr-nota-fis  = ENTRY(3, c-linha, ";") NO-ERROR.
    
                IF AVAIL nota-fiscal THEN DO:
                    RUN imprimi-nf-arquivo.
                END.
                else do:
                end.
    
                FIND FIRST devol-cli NO-LOCK
                    WHERE devol-cli.cod-estabel = ENTRY(1, c-linha, ";")
                      AND devol-cli.serie       = ENTRY(2, c-linha, ";")
                      AND devol-cli.nr-nota-fis = ENTRY(3, c-linha, ";") NO-ERROR.
    
                IF AVAIL devol-cli THEN DO:
    
                    FOR FIRST nota-fiscal NO-LOCK
                       WHERE nota-fiscal.cod-estabel  = devol-cli.cod-estabel 
                          AND nota-fiscal.serie       = devol-cli.serie       
                          AND nota-fiscal.nr-nota-fis = devol-cli.nr-nota-fis:
    
                        IF AVAIL nota-fiscal THEN DO:
    
                            FIND FIRST int-docum-est
                                  WHERE int-docum-est.serie-docto  = devol-cli.serie
                                    AND int-docum-est.nro-docto    = devol-cli.nro-docto
                                    AND int-docum-est.cod-emitente = devol-cli.cod-emitente
                                    AND int-docum-est.nat-operacao = devol-cli.nat-operacao NO-LOCK NO-ERROR.
    
                            IF AVAIL int-docum-est THEN
                                   RUN imprimi-nf-arquivo.
    
                        END.
    
                    END.
                END.  
            END.
        END.

    END.
    IF tt-param.tg-habilita = NO THEN DO:
        EMPTY TEMP-TABLE tt-prog-entrada.
        RUN esp/es0018p.p (INPUT "gk0001":U,
                           INPUT 4,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).

        RUN esp/es0018p.p (INPUT "gk0001":U,           
                           INPUT 7,                    
                           INPUT 0,                    
                           INPUT "":U,                 
                           OUTPUT TABLE tt-prog-pont5).

        RUN esp/es0018p.p (INPUT "gk0001":U,           
                           INPUT 8,                    
                           INPUT 0,                    
                           INPUT "":U,                 
                           OUTPUT TABLE tt-prog-pont6).

        DO v-dat-tmp = tt-param.dat-emis-ini TO tt-param.dat-emis-fim ON ERROR UNDO, LEAVE:
            IF tt-param.log-nota-entrada  THEN DO:
                FOR EACH docum-est NO-LOCK
                   WHERE docum-est.dt-trans = v-dat-tmp:
                    
                    RUN imprimi-nf-entrada-arquivo.
                END.
            END.
            ELSE DO:
               FOR EACH nota-fiscal USE-INDEX ch-sit-nota NO-LOCK
                  WHERE nota-fiscal.dt-emis-nota = v-dat-tmp
                    AND int(nota-fiscal.ind-tip-nota) <> 8 /*Tipo recebimento*/:
                   RUN imprimi-nf-arquivo.
               END. 
               FOR EACH devol-cli NO-LOCK
                   WHERE devol-cli.dt-devol = v-dat-tmp:
                   FOR FIRST nota-fiscal
                       WHERE nota-fiscal.cod-estabel  = devol-cli.cod-estabel
                         AND nota-fiscal.serie       = devol-cli.serie
                         AND nota-fiscal.nr-nota-fis = devol-cli.nr-nota-fis NO-LOCK:
                       IF AVAIL nota-fiscal THEN DO:
                           FIND FIRST int-docum-est
                               WHERE int-docum-est.serie-docto  = devol-cli.serie
                                 AND int-docum-est.nro-docto    = devol-cli.nro-docto
                                 AND int-docum-est.cod-emitente = devol-cli.cod-emitente
                                 AND int-docum-est.nat-operacao = devol-cli.nat-operacao NO-LOCK NO-ERROR.
    
                                 RUN imprimi-nf-arquivo.
                       END.
                   END.
               END. /*FOR EACH devol-cli USE-INDEX ch-dt-emit NO-LOCK*/

            END.
        END.
    END.
    
    OUTPUT STREAM s-arquivo CLOSE.
    OUTPUT close.
    INPUT CLOSE.
    /* FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE */
    /* FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE */

    IF tt-param.log-correios = YES THEN DO:
        
        DO v-dat-tmp = tt-param.dat-emis-ini TO tt-param.dat-emis-fim ON ERROR UNDO, LEAVE:
             
            FOR EACH nota-fiscal USE-INDEX ch-sit-nota NO-LOCK
                WHERE nota-fiscal.dt-emis-nota = v-dat-tmp:
                IF  nota-fiscal.cod-estabel < tt-param.cod-estab-ini OR
                    nota-fiscal.cod-estabel > tt-param.cod-estab-fim
                THEN NEXT. 

                IF nota-fiscal.nr-nota-fis < tt-param.num-nota-ini OR
                   nota-fiscal.nr-nota-fis > tt-param.num-nota-fim 
                THEN NEXT.
                
                RUN pi-acompanhar IN h-acomp (INPUT "FRGEN Nota Fiscal: " + string(nota-fiscal.nr-nota-fis) + " Transp: " + nota-fiscal.nome-transp).

               IF tt-param.log-desconsidera = NO THEN DO:
                    IF nota-fiscal.dt-saida = ? THEN NEXT.
                    IF  nota-fiscal.idi-sit-nf-eletro < 3 OR
                        nota-fiscal.cod-chave-aces-nf-eletro = "" /* Uso autorizado */ THEN NEXT. 
    
                    IF SUBSTRING(nota-fiscal.nat-operacao, 1,1) <> "5" AND
                       SUBSTRING(nota-fiscal.nat-operacao, 1,1) <> "6" AND
                       SUBSTRING(nota-fiscal.nat-operacao, 1,1) <> "7" THEN DO: 
                       NEXT.
                    END.
                END.
                RUN pi-acompanhar IN h-acomp (INPUT "FRGEN Nota Fiscal: " + string(nota-fiscal.nr-nota-fis) + " Transp: " + nota-fiscal.nome-transp).
                    
                    IF CAN-FIND(FIRST param-correios
                                WHERE param-correios.cod-estabel = nota-fiscal.cod-estabel
                                  AND param-correios.tp-servico  = nota-fiscal.nome-transp) THEN DO:

                        FOR EACH int-nota-conhec
                            WHERE int-nota-conhec.cod-estabel = nota-fiscal.cod-estabel    
                              AND int-nota-conhec.serie       = nota-fiscal.serie          
                              AND int-nota-conhec.nr-nota-fis = nota-fiscal.nr-nota-fis EXCLUSIVE-LOCK:

                            IF tt-param.log-desconsidera = NO THEN DO:
                                IF tt-param.log-reexportar = NO THEN
                                   IF int-nota-conhec.int-1 = 1 THEN NEXT.
                            END.
                            IF  int-nota-conhec.nr-conhec   <> '' THEN DO:

                                ASSIGN c-conhecimento = int-nota-conhec.nr-conhec + '^' + int-nota-conhec.nr-conhec  + '^1^46170602^'.

                                RUN pi-acompanhar IN h-acomp (INPUT "De FRDNE para FRGEN").        
                                                                                                   
                                /* FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN */        
                                /* FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN */        
                                /************************  LAYOUT 000  ***************************/
                                ASSIGN v-cod-arq-destino2 = v-cod-arq-destino-aux2                 
                                                           + "FRGEN"                               
                                                           + string(day(TODAY),"99")               
                                                           + string(month(TODAY),"99")             
                                                           + string(YEAR(TODAY),"9999")            
                                                           + string(TIME)                          
                                                           + nota-fiscal.nr-nota-fis               
                                                           + ".txt".                               
                                                                                                   
                                OUTPUT STREAM s-arquivo  to value(v-cod-arq-destino2) page-size 0. 
                                
                                PUT STREAM s-arquivo                                                                         
                                    '000^INTGEN^5.0aD^EMPRESAUSUµRIA^GKO FRETE^'                                        SKIP 
                                    '001^MEMBTRANSPORTE^CDEMBTRANSPORTEINT^1^004'                                       SKIP 
                                    '002^CDEMBTRANSPORTEINT^C^13^0^1^^^'                                                SKIP 
                                    '002^CDEMBTRANSPORTE^C^13^0^1^^^'                                                   SKIP 
                                    '002^IDEVENTO^C^11^0^1^^^'                                                          SKIP 
                                    '002^IDEMBALA^C^8^0^1^^^'                                                           SKIP
                                    '004^' + TRIM(c-conhecimento)                       FORMAT 'x(200)'                 SKIP.

                                OUTPUT STREAM s-arquivo  close. 
                                INPUT CLOSE.
                                /* FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN */ 
                                /* FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN FRGEN */ 

                                ASSIGN int-nota-conhec.int-1 = 1.                                                                           
                            END. 
                        END. /* FOR EACH int-nota-conhec */

                        FIND CURRENT int-nota-conhec NO-LOCK NO-ERROR.
                        RELEASE int-nota-conhec.

                    END. /* IF CAN-FIND(param-correios */                 
            END. /* FOR EACH nota-fiscal USE-INDEX ch-sit-nota NO-LOCK*/
        END.  /*DO v-dat-tmp = tt-param.dat-emis-ini TO tt-param.dat-emis-fim ON ERROR UNDO, LEAVE: */                  
    END. /* IF tt-param.log-correios = YES THEN DO: */

run pi-finalizar in h-acomp.

{include/i-rpclo.i}



PROCEDURE pi-gera-registro-100:

    DEF INPUT PARAM p-cod-emitente LIKE emitente.cod-emitente.
    DEF INPUT PARAM p-ind-tipo-par   AS INTEGER.

    DEF VAR v-cod-cgc       LIKE emitente.cgc      NO-UNDO.
    DEF VAR v-ind-tp-pessoa LIKE emitente.natureza NO-UNDO.
    DEF VAR v-cod-cep       LIKE emitente.cep      NO-UNDO.

    FIND b-emitente-reg-100 NO-LOCK
        WHERE b-emitente-reg-100.cod-emitente = p-cod-emitente NO-ERROR.

    IF  AVAIL b-emitente-reg-100
    THEN DO:
        ASSIGN v-cod-cgc       = b-emitente-reg-100.cgc
               v-ind-tp-pessoa = b-emitente-reg-100.natureza
               v-cod-cep       = b-emitente-reg-100.cep.

        /* Tratar valores para quando destino ² exporta»’o */
        IF  b-emitente-reg-100.estado = "EX" OR
            b-emitente-reg-100.natureza = 3  OR
            b-emitente-reg-100.natureza = 4
        THEN
            ASSIGN v-cod-cgc       = "000000000000000"
                   v-ind-tp-pessoa = 2 /* Juridica */
                   v-cod-cep       = "00000000".

        put STREAM s-arquivo 
            "100"                                                      format "x(3)"      /*  1 - TpRegistro                       */
            "A"                                                        FORMAT "x(1)"      /*  2 - FiOperacao (I- Inclui se n’o existir ou Rejeita se existir) A- Inclui se n’o existir ou Atualiza se existir  E - Exclui se existir ou Rejeita se n’o existir  */
            v-cod-cgc                                                  format "x(15)"     /*  3 - NoCgcCpf                         */
            p-ind-tipo-par                                             format "9"         /*  4 - TpParceiroComercial (2- Cliente) */
            string(b-emitente-reg-100.cod-emitente)                    format "x(14)"     /*  5 - CdParceiroComercial              */
            fn-free-accent(upper(trim(b-emitente-reg-100.nome-emit)))  format "x(40)"     /*  6 - NmParceiroComercial              */
            fn-free-accent(upper(trim(REPLACE(b-emitente-reg-100.endereco,";","|"))))   format "x(50)"     /*  7 - DsEndereco                       */
            fn-free-accent(upper(trim(b-emitente-reg-100.bairro)))     format "x(40)"     /*  8 - DsBairro                         */
            fn-free-accent(upper(trim(b-emitente-reg-100.cidade)))     format "x(30)"     /*  9 - NomeCidade                       */
            fn-free-accent(upper(trim(b-emitente-reg-100.estado)))     format "x(2)"      /* 10 - UF                               */
            v-cod-cep                                                  format "99999999"  /* 11 - NoCEP                            */
            space(10)                                                                     /* 12 - CdZonaTransporte                 */
            v-ind-tp-pessoa                                            FORMAT "9"         /* 13 - TpPessoa                         */        
            b-emitente-reg-100.ins-municipal                           format "x(15)"     /* 14 - DsInscrMunicipal                 */
            b-emitente-reg-100.ins-estadual                            format "x(15)".    /* 15 - DsInscrEstadual                  */

        if  b-emitente-reg-100.contrib-icms = yes                                            
        then                                                                       
            put STREAM s-arquivo "1"                                                    format "x(1)".     /* 16 - StContribuinteICMS (1- sim)      */ 
        else                                                                                                                       
            put STREAM s-arquivo "0"                                                    format "x(1)".     /* 16 - StContribuinteICMS (0- nao)      */
                                                                                          
        PUT STREAM s-arquivo 
            "0"                                                        format "x(1)"      /* 17 - StRegCredICMS (0- Cliente)       */
            "1"                                                        format "x(1)"      /* 18 - StExcluiRefExtParCom             */
            SKIP. 
    END.
END PROCEDURE.


PROCEDURE pi-calcula-peso-cubado-item:

    DEF INPUT PARAM p-log-ultimo AS LOG NO-UNDO.

    ASSIGN v-qtd-peso-cubado = 0
           v-qtd-volumes     = 0.
           

    FIND FIRST ped-venda NO-LOCK                                                
         WHERE ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli                      
           AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.        

    FIND FIRST int-ped-venda no-lock
         WHERE int-ped-venda.cod-estabel = ped-venda.cod-estabel
           AND int-ped-venda.nr-pedido   = ped-venda.nr-pedido no-error.

    FOR EACH  volume-nf NO-LOCK
        WHERE volume-nf.cod-estabel = it-nota-fisc.cod-estabel
          AND volume-nf.serie       = it-nota-fisc.serie
          AND volume-nf.nr-nota-fis = it-nota-fisc.nr-nota-fis
          AND volume-nf.it-codigo   = it-nota-fisc.it-codigo
        BREAK BY volume-nf.it-codigo:

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = volume-nf.it-codigo NO-ERROR.

        FIND FIRST int-item NO-LOCK
             WHERE int-item.it-codigo = ITEM.it-codigo NO-ERROR.

        FIND FIRST tt-volume-item-nf NO-LOCK
             WHERE tt-volume-item-nf.nr-volume = volume-nf.nr-volume NO-ERROR.

        IF  NOT AVAIL tt-volume-item-nf
        THEN DO:
            CREATE tt-volume-item-nf.
            ASSIGN tt-volume-item-nf.nr-volume      = volume-nf.nr-volume
                   tt-volume-item-nf.it-codigo      = volume-nf.it-codigo
                   tt-volume-item-nf.log-fracionado = volume-nf.varios-itens
                   tt-volume-item-nf.nr-seq-fat     = it-nota-fisc.nr-seq-fat.

            IF  AVAIL int-ped-venda
            AND int-ped-venda.vol-m3 > 0 THEN DO:
                IF FIRST-OF (volume-nf.it-codigo) THEN
                    ASSIGN tt-volume-item-nf.qtd-m3 = IF AVAIL int-ped-venda THEN int-ped-venda.vol-m3 ELSE 0.
            END.
            ELSE DO:
                FIND FIRST embalag NO-LOCK
                     WHERE embalag.sigla-emb = volume-nf.sigla-emb NO-ERROR.
    
                IF AVAIL embalag THEN
                    ASSIGN tt-volume-item-nf.qtd-m3 = tt-volume-item-nf.qtd-m3 + embalag.volume.
            END.
        END.
    END.

    FOR EACH  tt-volume-item-nf NO-LOCK                                    
        WHERE tt-volume-item-nf.it-codigo  = it-nota-fisc.it-codigo    
          AND tt-volume-item-nf.nr-seq-fat = it-nota-fisc.nr-seq-fat:

        ASSIGN v-qtd-peso-cubado = v-qtd-peso-cubado + tt-volume-item-nf.qtd-m3
               v-qtd-volumes     = v-qtd-volumes     + 1.

        IF  tt-volume-item-nf.log-fracionado = NO
        THEN
            ASSIGN v-des-tipo-carga = "Fechada".
    END.

    ASSIGN v-qtd-total-volumes = v-qtd-total-volumes + v-qtd-volumes.

    /* Acumular volumes que n’o est’o lan»ados como item na nota */
    IF  p-log-ultimo
    THEN DO:
        bloco-volume-extra:
        FOR EACH  volume-nf NO-LOCK
            WHERE volume-nf.cod-estabel = it-nota-fisc.cod-estabel
              AND volume-nf.serie       = it-nota-fisc.serie
              AND volume-nf.nr-nota-fis = it-nota-fisc.nr-nota-fis:
    
            FIND FIRST b-it-nota-fisc NO-LOCK
                WHERE  b-it-nota-fisc.cod-estabel = volume-nf.cod-estabel
                  AND  b-it-nota-fisc.serie       = volume-nf.serie      
                  AND  b-it-nota-fisc.nr-nota-fis = volume-nf.nr-nota-fis
                  AND  b-it-nota-fisc.it-codigo   = volume-nf.it-codigo NO-ERROR.

            IF  AVAIL b-it-nota-fisc
            THEN
                NEXT bloco-volume-extra.

            FIND FIRST tt-volume-item-nf NO-LOCK
                WHERE  tt-volume-item-nf.nr-volume = volume-nf.nr-volume NO-ERROR.
    
            IF  NOT AVAIL tt-volume-item-nf
            THEN DO:
                CREATE tt-volume-item-nf.
                ASSIGN tt-volume-item-nf.nr-volume  = volume-nf.nr-volume
                       tt-volume-item-nf.it-codigo  = volume-nf.it-codigo
                       tt-volume-item-nf.nr-seq-fat = 99.
    
                FIND FIRST embalag NO-LOCK
                    WHERE  embalag.sigla-emb = volume-nf.sigla-emb NO-ERROR.
    
                IF  AVAIL embalag
                THEN
                    ASSIGN tt-volume-item-nf.qtd-m3 = tt-volume-item-nf.qtd-m3 + embalag.volume.
            END.
        END. /* FOR EACH  volume-nf NO-LOCK */
    
        FOR EACH tt-volume-item-nf NO-LOCK:
            IF  tt-volume-item-nf.nr-seq-fat = 99
            THEN
                ASSIGN v-qtd-peso-cubado = v-qtd-peso-cubado + tt-volume-item-nf.qtd-m3
                       v-qtd-volumes     = v-qtd-volumes     + 1.
        END.
        ASSIGN v-qtd-total-volumes = v-qtd-total-volumes + v-qtd-volumes.
        IF  v-qtd-total-volumes = 0
        THEN
            ASSIGN v-qtd-volumes = INT(nota-fiscal.nr-volumes).
    END. /* IF  p-log-ultimo */
END PROCEDURE.

PROCEDURE pi-busca-conta-contabil:

    FOR FIRST ped-fiscal FIELDS(ct-codigo sc-codigo)
        WHERE ped-fiscal.cod-estabel = nota-fiscal.cod-estabel
        AND   ped-fiscal.serie       = nota-fiscal.serie
        AND   ped-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK:

        ASSIGN v-cod-ccusto = ped-fiscal.sc-codigo.
    END.

    FIND FIRST gko-param-contab-totvs11
        WHERE  gko-param-contab-totvs11.cod-estabel     = nota-fiscal.cod-estabel
        AND    gko-param-contab-totvs11.nat-operacao    = it-nota-fisc.nat-operacao
        AND    gko-param-contab-totvs11.cod-unid-negoc  = it-nota-fisc.cod-unid-negoc
        AND    gko-param-contab-totvs11.cod-canal-venda = nota-fiscal.cod-canal-venda NO-LOCK NO-ERROR.
    
    IF NOT AVAIL gko-param-contab-totvs11 THEN
        FIND FIRST gko-param-contab-totvs11 
            WHERE  gko-param-contab-totvs11.cod-estabel     = nota-fiscal.cod-estabel
            AND    gko-param-contab-totvs11.nat-operacao    = it-nota-fisc.nat-operacao
            AND    gko-param-contab-totvs11.cod-unid-negoc  = it-nota-fisc.cod-unid-negoc
            AND    gko-param-contab-totvs11.cod-canal-venda = ? NO-LOCK NO-ERROR.
                   
    
    IF NOT AVAIL gko-param-contab-totvs11 THEN
        FIND FIRST gko-param-contab-totvs11 
            WHERE  gko-param-contab-totvs11.cod-estabel     = nota-fiscal.cod-estabel
            AND    gko-param-contab-totvs11.nat-operacao    = it-nota-fisc.nat-operacao
            AND    gko-param-contab-totvs11.cod-unid-negoc  = ?
            AND    gko-param-contab-totvs11.cod-canal-venda = nota-fiscal.cod-canal-venda NO-LOCK NO-ERROR.
    IF NOT AVAIL gko-param-contab-totvs11 THEN
        FIND FIRST gko-param-contab-totvs11 
            WHERE  gko-param-contab-totvs11.cod-estabel     = nota-fiscal.cod-estabel
            AND    gko-param-contab-totvs11.nat-operacao    = it-nota-fisc.nat-operacao
            AND    gko-param-contab-totvs11.cod-unid-negoc  = "?"
            AND    gko-param-contab-totvs11.cod-canal-venda = nota-fiscal.cod-canal-venda NO-LOCK NO-ERROR.
    
    IF NOT AVAIL gko-param-contab-totvs11 THEN
        FIND FIRST gko-param-contab-totvs11 
            WHERE  gko-param-contab-totvs11.cod-estabel     = nota-fiscal.cod-estabel
            AND    gko-param-contab-totvs11.nat-operacao    = it-nota-fisc.nat-operacao
            AND    gko-param-contab-totvs11.cod-unid-negoc  = ?
            AND    gko-param-contab-totvs11.cod-canal-venda = ? NO-LOCK NO-ERROR.
    IF NOT AVAIL gko-param-contab-totvs11 THEN
        FIND FIRST gko-param-contab-totvs11 
            WHERE  gko-param-contab-totvs11.cod-estabel     = nota-fiscal.cod-estabel
            AND    gko-param-contab-totvs11.nat-operacao    = it-nota-fisc.nat-operacao
            AND    gko-param-contab-totvs11.cod-unid-negoc  = "?"
            AND    gko-param-contab-totvs11.cod-canal-venda = ? NO-LOCK NO-ERROR.

    FIND unid_negoc
        WHERE unid_negoc.cod_unid_negoc = it-nota-fisc.cod-unid-negoc NO-LOCK NO-ERROR.
    
    IF  AVAIL gko-param-contab-totvs11 AND AVAIL unid_negoc THEN DO:
        IF v-cod-ccusto <> "" AND gko-param-contab-totvs11.cod-canal-venda = 12 THEN 
            ASSIGN v-cod-ccusto = STRING(unid_negoc.cdn_unid_negoc,"999") + v-cod-ccusto.
        ELSE
            ASSIGN v-cod-ccusto = STRING(unid_negoc.cdn_unid_negoc,"999") + gko-param-contab-totvs11.sc-codigo.

        ASSIGN v-cod-conta-contab = gko-param-contab-totvs11.ct-codigo.
    END.
    
    IF NOT AVAIL gko-param-contab-totvs11 AND AVAIL unid_negoc THEN
        ASSIGN v-cod-conta-contab = "11910160"
               v-cod-ccusto       = "00000001" WHEN v-cod-ccusto = "".
    

END PROCEDURE.


PROCEDURE imprimi-nf-arquivo:

        DEF VAR c-marketplace AS CHAR NO-UNDO.

        IF nota-fiscal.cod-estabel BEGINS "5" OR nota-fiscal.cod-estabel BEGINS "6" THEN NEXT. /*nao extrair notas da Decio e Prediotech*/
    
        IF (nota-fiscal.idi-sit-nf-eletro <> 3 AND nota-fiscal.idi-sit-nf-eletro <> 6) OR 
            nota-fiscal.cod-chave-aces-nf-eletro = "" /* Uso autorizado idi-sit-nf-eletro = 3*/ 
        THEN NEXT. 
        IF tt-param.tg-habilita = NO THEN DO:
            
            IF  nota-fiscal.cod-estabel < tt-param.cod-estab-ini OR
                nota-fiscal.cod-estabel > tt-param.cod-estab-fim
            THEN NEXT. 
            
            IF nota-fiscal.nr-nota-fis < tt-param.num-nota-ini OR
               nota-fiscal.nr-nota-fis > tt-param.num-nota-fim 
            THEN NEXT. 

        END.
        IF tt-param.log-desconsidera = NO THEN DO:
            IF tt-param.log-desc-parametro = NO THEN DO:
                FIND FIRST tt-cliente NO-LOCK
                    WHERE  tt-cliente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
                IF AVAIL tt-cliente
                    AND (tt-cliente.cod-estabel <> ""
                      and tt-cliente.cod-estabel = nota-fiscal.cod-estabel) THEN
                        NEXT.
            END.

            IF SUBSTRING(nota-fiscal.nat-operacao, 1,1) <> "5" AND
               SUBSTRING(nota-fiscal.nat-operacao, 1,1) <> "6" AND
               SUBSTRING(nota-fiscal.nat-operacao, 1,1) <> "7" THEN DO: 
               NEXT.
            END.

            FIND FIRST tt-series NO-LOCK
                WHERE  tt-series.serie = nota-fiscal.serie NO-ERROR.
            IF  NOT AVAIL tt-series THEN NEXT.



            FIND FIRST tt-esp-docto NO-LOCK
                WHERE  tt-esp-docto.esp-docto = nota-fiscal.esp-docto NO-ERROR.
            IF  NOT AVAIL tt-esp-docto THEN NEXT.
             /*Valida‡Æo FOB*/
            IF nota-fiscal.esp-docto <> 23 THEN DO:
                IF tt-param.log-desc-modalidade = NO THEN IF substring(nota-fiscal.CHAR-2,201,8) <> "0" THEN NEXT.
            END.
            IF tt-param.log-correios = NO THEN DO:
                FIND FIRST tt-transportadora NO-LOCK
                     WHERE tt-transportadora.nome-abrev = nota-fiscal.nome-transp NO-ERROR.
                IF  AVAIL tt-transportadora THEN NEXT.
            END. /* IF tt-param.log-correios = NO THEN DO: */

        END. /* IF tt-param.log-desconsidera = NO THEN DO: */
        IF tt-param.log-correios = YES THEN DO:
            FIND FIRST param-correios
                 WHERE param-correios.cod-estabel = nota-fiscal.cod-estabel
                   AND param-correios.tp-servico  = nota-fiscal.nome-transp NO-LOCK NO-ERROR.
            IF NOT AVAIL param-correios THEN NEXT.
            IF nota-fiscal.dt-saida = ? THEN NEXT.

        END. /* IF tt-param.log-correios = YES THEN DO: */
        ELSE DO:
            FIND FIRST param-correios
                 WHERE param-correios.cod-estabel = nota-fiscal.cod-estabel
                   AND param-correios.tp-servico  = nota-fiscal.nome-transp NO-LOCK NO-ERROR.
            IF AVAIL param-correios THEN NEXT.

        END.
  
        FIND FIRST transporte NO-LOCK
            WHERE  transporte.nome-abrev = nota-fiscal.nome-transp NO-ERROR.
        
         IF tt-param.tg-habilita = NO THEN DO:

            IF  NOT AVAIL transporte THEN NEXT.
            
            IF  AVAIL transporte AND 
                     (transporte.cod-transp < tt-param.cod-transp-ini  OR
                      transporte.cod-transp > tt-param.cod-transp-fim) THEN NEXT.
         END.
  
        FIND FIRST volume-nf NO-LOCK
            WHERE  volume-nf.cod-estabel = nota-fiscal.cod-estabel
              AND  volume-nf.serie       = nota-fiscal.serie
              AND  volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
        IF    int(nota-fiscal.nr-volume) = 0 THEN DO:
            FIND b-nota-fiscal
                WHERE ROWID(b-nota-fiscal) = rowid(nota-fiscal)
                EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL b-nota-fiscal THEN DO:
                ASSIGN b-nota-fiscal.dt-saida = nota-fiscal.dt-emis-nota.
            END.
            NEXT.
        END.
        ASSIGN v-cod-tipo-operac = "A"
               c-TpStatusDNE     = "A".

        /*Verificar nota de devolu»’o*/
        FIND FIRST devol-cli 
             WHERE devol-cli.cod-estabel = nota-fiscal.cod-estabel
               AND devol-cli.serie       = nota-fiscal.serie 
               AND devol-cli.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
        IF AVAIL devol-cli THEN
            FIND FIRST int-docum-est
                 WHERE int-docum-est.serie-docto  = devol-cli.serie-docto
                   AND int-docum-est.nro-docto    = devol-cli.nro-docto
                   AND int-docum-est.cod-emitente = devol-cli.cod-emitente
                   AND int-docum-est.nat-operacao = devol-cli.nat-operacao 
                   AND (int-docum-est.cod-msg-devolucao = 500
                    OR  int-docum-est.cod-msg-devolucao = 521) NO-LOCK NO-ERROR.
    
        IF (AVAIL devol-cli AND AVAIL int-docum-est) OR nota-fiscal.dt-cancel <> ? THEN
            ASSIGN c-TpStatusDNE = "E".
    
        IF  nota-fiscal.dt-cancela <> ? THEN ASSIGN v-cod-tipo-operac = "E".
    
        /* Validar nota ja integrada */ 
        // Comentar este trecho para teste
        
        IF tt-param.log-desconsidera = NO THEN DO:
            IF  tt-param.log-reexportar = NO THEN DO:

                IF CAN-FIND(FIRST gko-nfs-integrada                                                                                                               
                            WHERE gko-nfs-integrada.cod-estabel               = nota-fiscal.cod-estabel                                                                        
                              AND gko-nfs-integrada.serie                     = nota-fiscal.serie                                                                              
                              AND gko-nfs-integrada.nr-nota-fis               = nota-fiscal.nr-nota-fis
                              AND gko-nfs-integrada.cod-chave-aces-nf-eletr   = nota-fiscal.cod-chave-aces-nf-eletro  
                              AND gko-nfs-integrada.cod-emitente              = nota-fiscal.cod-emitente           
                              AND gko-nfs-integrada.tipo-operacao             = c-TpStatusDNE) 
                THEN do:
                    NEXT. 
                END.
    
            END.
        END. /* IF tt-param.log-desconsidera = NO THEN DO: */
        
        EMPTY TEMP-TABLE tt-volume-item-nf.
        
        IF  tt-param.dat-emis-ini = 01/01/0001 AND
            tt-param.dat-emis-fim = 12/31/9999 OR
            tt-param.tg-habilita  = YES
        THEN
        ASSIGN tt-param.dat-emis-ini = TODAY - 60
               tt-param.dat-emis-fim = TODAY.
    /* FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE */
    /* FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE */
    /************************  LAYOUT 000  ***************************/
        ASSIGN v-cod-arq-destino = v-cod-arq-destino-aux
                                 + "FRDNE"
                                 + STRING(nota-fiscal.nr-nota-fis)
                                 + string(day(TODAY),"99")
                                 + string(month(TODAY),"99")
                                 + string(YEAR(TODAY),"9999")
                                 + string(TIME)
                                 + ".txt".

        output STREAM s-arquivo to value(v-cod-arq-destino) page-size 0.

        //modificando para gerar um arquivo por nota.
        PUT STREAM s-arquivo 
          "000"       FORMAT "x(03)" /* 1 - TpRegistro   */
          "IntDNE"    FORMAT "x(10)" /* 2 - NmInterface  */
          "6.42a"     FORMAT "x(06)" /* 3 - Versao       */
          "INTELBRAS" FORMAT "x(40)" /* 4 - Remetente    */
          "GKO"       FORMAT "x(40)" /* 5 - Destinatario */
          "EMS"       FORMAT "x(03)" /* 6 - CdAmbiente   */
        SKIP.
    
        RUN pi-acompanhar IN h-acomp (INPUT "FRDNE Nota Fiscal: " + string(nota-fiscal.nr-nota-fis) + " Transp: " + nota-fiscal.nome-transp).

        FIND estabelec NO-LOCK
            WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.
  
        FIND FIRST gko-nfs-integrada NO-LOCK
             WHERE gko-nfs-integrada.cod-estabel              = nota-fiscal.cod-estabel   
               AND gko-nfs-integrada.serie                    = nota-fiscal.serie         
               AND gko-nfs-integrada.nr-nota-fis              = nota-fiscal.nr-nota-fis
               AND gko-nfs-integrada.cod-chave-aces-nf-eletr  = nota-fiscal.cod-chave-aces-nf-eletro
               AND gko-nfs-integrada.cod-emitente             = nota-fiscal.cod-emitente  
               AND gko-nfs-integrada.tipo-operacao            = c-TpStatusDNE  NO-ERROR.
        IF  NOT AVAIL gko-nfs-integrada THEN DO:
            CREATE gko-nfs-integrada.                                                                                                                     
            ASSIGN gko-nfs-integrada.cod-estabel              = nota-fiscal.cod-estabel                                                                               
                   gko-nfs-integrada.serie                    = nota-fiscal.serie                                                                                     
                   gko-nfs-integrada.nr-nota-fis              = nota-fiscal.nr-nota-fis
                   gko-nfs-integrada.cod-chave-aces-nf-eletr  = nota-fiscal.cod-chave-aces-nf-eletro
                   gko-nfs-integrada.cod-emitente             = nota-fiscal.cod-emitente               
                   gko-nfs-integrada.tipo-operacao            = c-TpStatusDNE
                   gko-nfs-integrada.dat-integracao           = TODAY
                   gko-nfs-integrada.hor-integracao           = TIME
                   gko-nfs-integrada.arq-integracao           = v-cod-arq-destino.   
        END.

        FIND FIRST b-emitente NO-LOCK
            WHERE  b-emitente.cgc = transporte.cgc NO-ERROR.
    
        ASSIGN v-ind-modal-peso-cubado = transporte.via-transp.
    
        /*---------------------- Grava os Dados da Nota Fiscal ------------------*/        
    
        find first natur-oper
             where natur-oper.nat-operacao = nota-fiscal.nat-operacao no-lock no-error.
        find first estabelec
             where estabelec.cod-estabel = nota-fiscal.cod-estabel no-lock no-error.
    
        for FIRST nota-embal use-index ch-nota-emb NO-LOCK
            where nota-embal.cod-estabel = nota-fiscal.cod-estabel
              and nota-embal.serie       = nota-fiscal.serie
              and nota-embal.nr-nota-fis = nota-fiscal.nr-nota-fis:
            ASSIGN v-cod-embalagem = nota-embal.sigla-emb.
        END.
        FIND FIRST emitente 
            WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.
   
        /************************  LAYOUT 100  ***************************/ 
        RUN pi-gera-registro-100 (INPUT nota-fiscal.cod-emitente,
                                  INPUT 2).
    
        /* Gerar registro 100 para local de redespacho */
        IF  nota-fiscal.nome-tr-red <> "" THEN DO:
            find first transporte
                 where transporte.nome-abrev = nota-fiscal.nome-tr-red no-lock no-error.
            IF  AVAIL transporte
            THEN DO:
                FIND FIRST emitente NO-LOCK
                    WHERE  emitente.cgc = transporte.cgc NO-ERROR.
    
                IF  AVAIL emitente
                THEN 
                    RUN pi-gera-registro-100 (INPUT emitente.cod-emitente,
                                              INPUT 5).
            END.
        END.

        FIND FIRST emitente 
            WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.
        IF AVAIL emitente THEN DO:

            FIND FIRST gr-cli WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
            IF AVAIL gr-cli THEN DO:
                PUT STREAM s-arquivo 
                    "102"                                        format "x(03)"             /*  1 - Registro Identificador           */
                    "TIPO DE CLIENTE"
                    gr-cli.descricao                             format "x(20)"             /*  3 - Tipo de Cliente                  */
                    SKIP.
            END. /* IF AVAIL gr-cli THEN DO: */

        END. /* IF AVAIL emitente THEN DO: */

        /*********************** LAYOUT - 140 ***********************/    
        put STREAM s-arquivo 
            "140"                                            format "x(03)"             /*  1 - Registro Identificador           */
            fn-free-accent(upper(trim(v-cod-tipo-operac)))   format "x(01)"             /*  2 - FlOperacao                       */
            "1"                                              format "x(01)"             /*  3 - TpDocumento (1-Nota Fiscal )     */
            1                                                format "9"                 /*  4 - TpParceiroComercial              */
            STRING(estabelec.cod-emitente)                   FORMAT "x(14)"             /*  4 - CdParceiroComercial              */
            STRING(INT(nota-fiscal.nr-nota-fis),"9999999")   format "x(12)"             /*  5 - CdNota                           */
            fn-free-accent(upper(trim(nota-fiscal.serie)))   format "x(03)"             /*  6 - CdSerie                          */
            nota-fiscal.dt-emis-nota                         format "99/99/9999"        /*  7 - DtEmissao                        */
            nota-fiscal.dt-saida                             format "99/99/9999"        /*  8 - DtEmbarque                       */
            "2"                                              format "x(01)".            /*  9 - TpEntradaSaida (2- Sa­da)        */
        
        PUT STREAM s-arquivo 2 format "9".                /*  4 - TpParceiroComercial              */

        PUT STREAM s-arquivo string(nota-fiscal.cod-emitente)                 format "x(14)".            /* 10 - ParDestRemet (Destinatÿrio)      */

        IF nota-fiscal.cod-entrega <> "" then do:
            /*IDBA - Bruno Joaquim - 19/03/2024 - Melhoria: M2305-132 Local de entrega Alternativo
             Valida campo endereco-entrega-alternativo tabela int-ped-venda preenchido pelo ESPD106.w conforme chamada na UPC do PD4000
             caso os campos estejam preenchido iremos mandar os dados salvos neles */

            FIND FIRST ped-venda WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli 
                                   AND ped-venda.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.

            IF AVAIL ped-venda THEN DO:
                /*Se existir pedido vamos tentar buscar a int-ped-venda avaliando os campos de endereco-entrega-alternativo */
                FIND FIRST int-ped-venda WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
                IF AVAIL int-ped-venda 
                AND length(int-ped-venda.endereco-entrega-alternativo[1]) > 0 
                 OR length(int-ped-venda.endereco-entrega-alternativo[2]) > 0 THEN DO:
                   /*Se os campos forem preenchidos e a int-ped-venda existir, vamos assumir estes valores no GKO*/
                   PUT STREAM s-arquivo 
                    fn-free-accent(upper(trim(replace(int-ped-venda.endereco-entrega-alternativo[2],";","|")))) format "x(50)" /* 11 - DsEnderecoDestRemet              */
                    fn-free-accent(upper(trim(int-ped-venda.endereco-entrega-alternativo[3])))   format "x(40)"                /* 12 - DsBairroDestRemet                */
                    fn-free-accent(upper(trim(int-ped-venda.endereco-entrega-alternativo[6])))   format "x(30)"                /* 13 - NomeCidade                       */
                    fn-free-accent(upper(trim(int-ped-venda.endereco-entrega-alternativo[4])))   format "x(2)"                 /* 14 - UF                               */
                    integer(string(int-ped-venda.endereco-entrega-alternativo[5]))               format "99999999".            /* 15 - NoCEPDestRemet                   */
                END.
                ELSE DO:
                    /*Caso os campos de endereco de entrega alternativo nÆo estejam preenchidos ou a int-ped-venda nÆo exista assumimos os valores da nota*/
                    PUT STREAM s-arquivo 
                    fn-free-accent(upper(trim(replace(nota-fiscal.endereco,";","|")))) format "x(50)"       /* 11 - DsEnderecoDestRemet */
                    fn-free-accent(upper(trim(nota-fiscal.bairro)))   format "x(40)"                        /* 12 - DsBairroDestRemet   */
                    fn-free-accent(upper(trim(nota-fiscal.cidade)))   format "x(30)"                        /* 13 - NomeCidade          */
                    fn-free-accent(upper(trim(nota-fiscal.estado)))   format "x(2)"                         /* 14 - UF                  */
                    REPLACE(nota-fiscal.cep,"-","")                   format "99999999".                    /* 15 - NoCEPDestRemet      */

                END.
            END.
            ELSE DO:
                /*Caso o pedido nÆo exista, assumimos os valores da nota */
                PUT STREAM s-arquivo 
                    fn-free-accent(upper(trim(replace(nota-fiscal.endereco,";","|")))) format "x(50)"       /* 11 - DsEnderecoDestRemet */
                    fn-free-accent(upper(trim(nota-fiscal.bairro)))   format "x(40)"                        /* 12 - DsBairroDestRemet   */
                    fn-free-accent(upper(trim(nota-fiscal.cidade)))   format "x(30)"                        /* 13 - NomeCidade          */
                    fn-free-accent(upper(trim(nota-fiscal.estado)))   format "x(2)"                         /* 14 - UF                  */
                    REPLACE(nota-fiscal.cep,"-","")                   format "99999999".                    /* 15 - NoCEPDestRemet      */
            END.
        END.                                                                           
        ELSE
            PUT STREAM s-arquivo SPACE(130).                                                            
                                                                                       
        PUT STREAM s-arquivo 
            SPACE(10)                                                                   /* 16 - CdZonaTransporte                 */
            SPACE(12)                                                                   /* 17 - CdDocNegFrete                    */
            nota-fiscal.nat-operacao                         FORMAT "x(6)"              /* 18 - CdTipoNota                       */                
            SPACE(10)                                                                   /* 19 - CdEquipamento                    */ 
            fn-free-accent(upper(trim(v-cod-embalagem)))     FORMAT "x(4)"              /* 20 - Embalagem                        */
            string(int(transporte.via-transp))               FORMAT "x(4)"              /* 21 - CdMeioTransporte                 */
            SPACE(10)                                                                   /* 22 - CdTerritorio                     */
            SPACE(5)                                                                    /* 23 - CdVendedor                       */
            SPACE(10)                                                                   /* 24 - DsSeparadorConhecimento          */
            SPACE(20)                                                                   /* 25 - DsLote                           */
            SPACE(10)                                                                   /* 26 - CdRomaneio                       */
            b-emitente.cgc                                   FORMAT "x(15)".            /* 27 - CdTransportadora                 */
    
        IF substring(nota-fiscal.CHAR-2,201,8) <> "0"
        THEN                                                                       
            put STREAM s-arquivo "2"  /*fob*/                                 FORMAT "x(01)".            /* 28 - TpFrete                          */
        ELSE                                                                                                                     
            put STREAM s-arquivo "1"  /*cif*/                                 FORMAT "x(01)".            /* 28 - TpFrete                          */
                                                                                   
        PUT STREAM s-arquivo 
            nota-fiscal.nr-pedcli                            FORMAT "X(12)"             /* 29 - CdDocumentoVinculado            */
            "1"                                              FORMAT "X(3)"              /* 30 - CdSerieDocumentoVinculado        */

            "1"                                              FORMAT "x(10)"             /* 31 - CdTipoCarga                      */
            nota-fiscal.nat-operacao                         FORMAT "x(06)"             /* 32 - CdNaturezaOperacao               */                      
            "0"                                              FORMAT "x(01)"             /* 33 - StIsentoImposto                  */
            "0"                                              FORMAT "x(01)".            /* 34 - StItemSubTribNaCompra            */      
                                                                                    
        FIND FIRST ped-venda NO-LOCK                                                
            WHERE  ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli                      
              AND  ped-venda.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.         
        IF  AVAIL ped-venda                                                         
        THEN DO:                                                                    
            IF ped-venda.cod-des-merc = 1                                           
            THEN                                                                    
                PUT STREAM s-arquivo "2"                                      FORMAT "x(01)".            /* 35 - TpFinalidadeOperacao            */
            ELSE                                                                                                         
                PUT STREAM s-arquivo "1"                                      FORMAT "x(01)".                                             
        END.                                                                        
        ELSE
            PUT STREAM s-arquivo "3" FORMAT "x(01)".
    
        PUT STREAM s-arquivo 
            SPACE(10)                                                                   /* 36 - CdIndiceFinanceiro              */
            0                                                FORMAT "9"                 /* 37 - StUrgenciaEntrega               */
            0                                                FORMAT "9"                 /* 38 - StFreteDiferenciado             */
            SPACE(10).                                                                  /* 39 - DtEntrega                       */
                                                                                     
        IF substring(nota-fiscal.CHAR-2,201,8) <> "0"
        THEN
            IF nota-fiscal.esp-docto = 23
            THEN
                PUT STREAM s-arquivo 
                1 FORMAT "9"
                STRING(nota-fiscal.cod-emitente)             FORMAT "x(14)".            /* 40 - ChaveRespFrete                  */
            ELSE
                PUT STREAM s-arquivo 
                2 FORMAT "9"
                STRING(nota-fiscal.cod-emitente)             FORMAT "x(14)".            /* 40 - ChaveRespFrete                  */
        ELSE
            PUT STREAM s-arquivo 1 FORMAT "9"
                STRING(estabelec.cod-emitente)               FORMAT "x(14)".            /* 40 - ChaveRespFrete                  */
    
        PUT STREAM s-arquivo 
            SPACE(10)                                                                   /* 41 - DtTabPreco                      */
            SPACE(10)                                                                   /* 42 - DtPrevisaoColeta                */
            SPACE(10)                                                                   /* 43 - DtPrevisaoEntega                */
            0 FORMAT "999999999999999".                                                 /* 44 - VrFretePgCliente                */
                                                                                      

        IF c-TpStatusDNE = "E" THEN
            PUT STREAM s-arquivo "2"                                          FORMAT "9".
        ELSE
            PUT STREAM s-arquivo "1"                                          FORMAT "9".                /* 45 - TpStatusDNE(1- normal, 2- cancelado) */
                                                           
        PUT  STREAM s-arquivo 
             1                                                FORMAT "9"                 /* 97 - StExcluiRegEmbTrans             */
             1                                                FORMAT "9"                 /* 98 - StExcluiItemDNE                 */
             1                                                FORMAT "9"                 /* 99 - StExcluiRefExt                  */
             nota-fiscal.cod-chave-aces-nf-eletro             FORMAT "x(44)"             /* OP - DsChaveAcesso                   */
             SKIP.
    
    
       /*********************** LAYOUT - 142 ***********************/
        put STREAM s-arquivo 
            "142"                                        format "x(03)"             /*  1 - Registro Identificador           */
            "CANAL_VENDA"                                format "x(15)"             /*  2 - CdReferencia1                    */
            STRING(nota-fiscal.cod-canal-venda)          format "x(15)"             /*  3 - DsReferencia1                    */
            SPACE(5)
            "ATENDENTE"                                  FORMAT "X(15)".            /*  4 - Atendente                        */

            FIND FIRST atendente
                WHERE atendente.cd-oper = integer(ped-venda.tp-pedido) NO-LOCK NO-ERROR.
            IF AVAIL atendente THEN
                PUT STREAM s-arquivo atendente.email                      FORMAT "X(20)".
            ELSE
                PUT STREAM s-arquivo SPACE(20).


        IF  AVAIL ped-venda THEN DO:
            PUT STREAM s-arquivo  UNFORMATTED "IMPLANTACAO    "
                              string(ped-venda.dt-implant, "99/99/9999") SPACE(10)
                             "APROV_COMERCIAL".
            
            IF  ped-venda.cod-sit-ped > 3 THEN
                PUT STREAM s-arquivo UNFORMATTED SPACE(20).
            ELSE
                IF  ped-venda.cod-sit-ped < 4  AND ped-venda.dt-reativ <> ? THEN
                    PUT STREAM s-arquivo UNFORMATTED string(ped-venda.dt-reativ, "99/99/9999") SPACE(10).
                ELSE
                    PUT STREAM s-arquivo UNFORMATTED string(ped-venda.dt-implant, "99/99/9999") SPACE(10).

            PUT STREAM s-arquivo UNFORMATTED "ALTER_COMERCIAL". 
                
                IF ped-venda.dt-reativ = ? AND ped-venda.dt-useralt = ? THEN

                 PUT STREAM s-arquivo  UNFORMATTED string(ped-venda.dt-entrega, "99/99/9999") SPACE(10).

                ELSE
                    IF ped-venda.dt-reativ > ped-venda.dt-useralt THEN
                        PUT STREAM s-arquivo UNFORMATTED string(ped-venda.dt-reativ, "99/99/9999") SPACE(10).
                    ELSE
                        PUT STREAM s-arquivo UNFORMATTED string(ped-venda.dt-useralt, "99/99/9999") SPACE(10). 
                
            PUT STREAM s-arquivo UNFORMATTED "CANAL          " FORMAT "x(15)". 

            FOR FIRST int-ped-venda2 NO-LOCK
                 WHERE int-ped-venda2.nr-pedido   = ped-venda.nr-pedido
                   AND int-ped-venda2.cod-estabel = ped-venda.cod-estabel :
            END.
            
            IF  AVAIL int-ped-venda2  THEN DO:
                FIND FIRST grupo-canais NO-LOCK
                    WHERE grupo-canais.cod-gr-canais = int-ped-venda2.int-1 NO-ERROR.
                IF  AVAIL grupo-canais THEN
                    PUT STREAM s-arquivo UNFORMATTED fn-free-accent(grupo-canais.descricao) FORMAT "X(20)".
                ELSE
                    PUT STREAM s-arquivo UNFORMATTED "                    ".
            END.
            ELSE
                PUT STREAM s-arquivo UNFORMATTED "                    " .


            PUT STREAM s-arquivo UNFORMATTED "APROV_CREDITO  ".
                    
            FIND LAST historico-credito NO-LOCK
                WHERE historico-credito.nome-abrev = ped-venda.nome-abrev
                  AND historico-credito.nr-pedcli  = ped-venda.nr-pedcli NO-ERROR.
            IF AVAIL historico-credito AND historico-credito.dt-data-movto <> ? THEN
                PUT STREAM s-arquivo UNFORMATTED string(historico-credito.dt-data-movto, "99/99/9999") SPACE(10).
            ELSE DO:
                IF ped-venda.dt-apr-cred = ? THEN
                    PUT STREAM s-arquivo UNFORMATTED SPACE(20).
                ELSE
                    PUT STREAM s-arquivo UNFORMATTED string(ped-venda.dt-apr-cred, "99/99/9999") SPACE(10).
            END.

            PUT STREAM s-arquivo UNFORMATTED "ALTER_COMERCIA2" .
            FIND FIRST int-ped-venda2 EXCLUSIVE-LOCK 
                 WHERE int-ped-venda2.nr-pedido   = ped-venda.nr-pedido
                   AND int-ped-venda2.cod-estabel = ped-venda.cod-estabel NO-ERROR.
            IF AVAIL int-ped-venda2 THEN
                IF int-ped-venda2.dt-avaliacao = ? THEN
                   PUT STREAM s-arquivo  UNFORMATTED SPACE(20).
                ELSE
                   PUT STREAM s-arquivo UNFORMATTED string(int-ped-venda2.dt-avaliacao, "99/99/9999") SPACE(10) .
            ELSE
                PUT STREAM s-arquivo "          " SPACE(10) .

            PUT STREAM s-arquivo UNFORMATTED "ENTREGA_PEDIDO " 
                string(ped-venda.dt-entrega, "99/99/9999") SPACE(10).

            FIND FIRST int-ped-trans  
                 WHERE int-ped-trans.cod-estabel = ped-venda.cod-estabel 
                   AND int-ped-trans.nome-abrev  = ped-venda.nome-abrev 
                   AND int-ped-trans.nr-pedcli   = ped-venda.nr-pedcli NO-LOCK NO-ERROR.
            IF AVAIL int-ped-trans AND int-ped-trans.lot-transp THEN
                PUT STREAM s-arquivo UNFORMATTED "TIPO AEREO     1".
            ELSE
                PUT STREAM s-arquivo UNFORMATTED "                ".
            /*Leonam Alterado para 20 digitos o codigo vtex 18/05/2020*/
            IF  AVAIL int-ped-venda2 
            AND int-ped-venda2.PedidoeCommerce <> ""
            AND int-ped-venda2.PedidoeCommerce <> ?
            AND int-ped-venda2.PedidoeCommerce <> "?" THEN DO:

                FIND FIRST int-pedido-vtex NO-LOCK
                     WHERE int-pedido-vtex.nr-pedido  = int-ped-venda2.PedidoeCommerce
                       AND int-pedido-vtex.nr-pedcli  = ped-venda.nr-pedcli NO-ERROR.
                IF AVAIL int-pedido-vtex THEN DO:
                    ASSIGN c-marketplace = int-pedido-vtex.marketplace + "-".

                    PUT STREAM s-arquivo "PAR_VTEX".
                    PUT STREAM s-arquivo c-marketplace FORMAT "X(4)".
                    PUT STREAM s-arquivo "PED_VTEX".
                    PUT STREAM s-arquivo REPLACE(int-ped-venda2.PedidoeCommerce,c-marketplace,"") FORMAT "X(20)".
                END.
            END.

            FIND int-ped-venda WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
                                 AND int-ped-venda.cod-estabel = ped-venda.cod-estabel
            NO-LOCK NO-ERROR.

            //Solicitado Leonam - Projeto GOL - IAB - 18/02/21
            IF AVAIL int-ped-venda THEN
               PUT STREAM s-arquivo UNFORMATTED "PEDIDO_CLIENTE" AT 375
                                    SUBSTRING(int-ped-venda.char-1,53,12) FORMAT 'x(12)' AT 389.

            PUT STREAM s-arquivo SKIP.
        END.
        ELSE
            PUT STREAM s-arquivo SKIP.                                                                           
        
       /*********************** LAYOUT - 147 ***********************/
       FIND FIRST nota-fisc-adc NO-LOCK
            WHERE nota-fisc-adc.cod-estab    = nota-fiscal.cod-estabel
              AND nota-fisc-adc.cod-serie    = nota-fiscal.serie
              AND nota-fisc-adc.cod-nota-fis = nota-fiscal.nr-nota-fis 
              AND nota-fisc-adc.idi-tip-dado = 32 NO-ERROR. // 32 = local de retirada
       /* Redespacho */
       IF nota-fiscal.nome-tr-red <> "" OR AVAIL nota-fisc-adc
       THEN DO:
           IF nota-fiscal.nome-tr-red <> "" THEN DO: //tem redespacho
              find first transporte
                   where transporte.nome-abrev = nota-fiscal.nome-tr-red no-lock no-error.
              IF AVAIL transporte THEN DO:
                 FIND FIRST b-emitente NO-LOCK
                      WHERE b-emitente.cgc = transporte.cgc NO-ERROR.
                 ASSIGN i-via           = transporte.via-transp
                        i-transp-redesp = b-emitente.cgc.
              END.
           END.
           ELSE IF AVAIL nota-fisc-adc  THEN DO: //tem local de retirada
               FIND FIRST b-emitente-retirada NO-LOCK
                    WHERE b-emitente-retirada.cod-emitente = int(ENTRY(1,nota-fisc-adc.cod-livre-1,"")) NO-ERROR.

               FIND FIRST b-emitente NO-LOCK
                    WHERE b-emitente.cgc = b-emitente-retirada.cgc NO-ERROR.

               find first transporte
                    where transporte.nome-abrev = nota-fiscal.nome-transp no-lock no-error.
               IF AVAIL transporte THEN DO:
                  FIND FIRST b-emitente-transp NO-LOCK 
                       WHERE b-emitente-transp.cgc = transporte.cgc NO-ERROR.

                  ASSIGN i-via           = transporte.via-transp
                         i-transp-redesp = b-emitente-transp.cgc.
               END.
           END.
     
           PUT STREAM s-arquivo 
               "147"                                          FORMAT "x(3)"             /*  1 - TpRegistro                      */
               "A"                                            FORMAT "x(1)"             /*  2 - FiOperacao                      */
               1                                              format "9"                /*  3 - TpParceiroComercial             */
               STRING(estabelec.cod-emitente)                 FORMAT "x(14)"            /*  3 - ParceiroComercial               */
               STRING(INT(nota-fiscal.nr-nota-fis),"9999999") FORMAT "x(12)"            /*  4 - CdNotaFiscal                    */
               fn-free-accent(upper(trim(nota-fiscal.serie))) FORMAT "x(3)"             /*  5 - CdSerie                         */
               "1"                                            FORMAT "99"               /*  6 - NoOrdem                         */
               "5"                                            FORMAT "9"                /*  7 - TipoParceiro                    */
               string(b-emitente.cod-emitente)                FORMAT "x(14)"            /*  7 - ChaveRedespacho                 */
               /*Alterado para receber codigo transp de redespacho e alterado tipo de frete para CIF - Leonam 16/04*/
               i-transp-redesp                                FORMAT "x(15)"            /*  8 - CdTrpRedespacho                 */
               "1"                                            FORMAT "x(1)"             /*  9 - TpFreteRedespacho               */
               /*Fim altera‡Æo Leonam - 16/04*/
               string(int(transporte.via-transp))             FORMAT "x(4)"             /* 21- CdMeioTransporte                 */
               SPACE(10)                                                                /* 11 - DsSeparadorConhecimento         */
               SPACE(20)                                                                /* 12 - DsLote                          */
               SPACE(10)                                                                /* 13 - CdEquipamento                   */
               0                                              FORMAT "9"                /* 14 - StFreteDiferenciado             */
               1                                              FORMAT "9"                /* 15 - TpStatusTrecho                  */
               SKIP.
       END. /* IF nota-fiscal.nome-tr-red <> "" */
       /*********************** LAYOUT - 148 ***********************/
       /* Correios PAC: 264 / E-SEDEX: 350 / SEDEX: 254*/
       FIND FIRST param-correios
           WHERE param-correios.cod-estabel = nota-fiscal.cod-estabel
             AND param-correios.tp-servico  = nota-fiscal.nome-transp NO-LOCK NO-ERROR.
       IF AVAIL param-correios THEN DO:

           FOR EACH volume-nf NO-LOCK
               WHERE volume-nf.cod-estabel     = nota-fiscal.cod-estabel
                 AND volume-nf.serie           = nota-fiscal.serie
                 AND volume-nf.nr-nota-fis     = nota-fiscal.nr-nota-fis
               BREAK BY volume-nf.nr-volume:

               IF FIRST-OF(volume-nf.nr-volume) THEN DO:

                   FIND FIRST int-nota-conhec
                       WHERE int-nota-conhec.cod-estabel = nota-fiscal.cod-estabel    
                         AND int-nota-conhec.serie       = nota-fiscal.serie          
                         AND int-nota-conhec.nr-nota-fis = nota-fiscal.nr-nota-fis
                         AND int-nota-conhec.nr-volume   = volume-nf.nr-volume NO-LOCK NO-ERROR.
                   IF AVAIL int-nota-conhec THEN
                       PUT STREAM s-arquivo 
                           "148"                                          FORMAT "x(3)"             /*  1 - TpRegistro                      */
                           int-nota-conhec.nr-conhec                      FORMAT "x(20)"            /*  2 - EtiquetaCorreios                */
                           SKIP.

               END.

           END.

       END. /* IF AVAIL param-correios THEN DO: */

       ASSIGN v-qtd-total-volumes = 0.
       ASSIGN i-nro-itens = 0.
       for each it-nota-fisc of nota-fiscal NO-LOCK:
           ASSIGN i-nro-itens = i-nro-itens + 1.
       END.
    
       for each it-nota-fisc of nota-fiscal NO-LOCK,
            FIRST ITEM OF it-nota-fisc NO-LOCK
           BREAK BY it-nota-fisc.cod-estabel
                 BY it-nota-fisc.nr-nota-fis
                 BY it-nota-fisc.serie:
           
           ASSIGN v-cod-familia = fn-free-accent(upper(trim(it-nota-fisc.cod-unid-negoc)))
                  v-cod-item    = fn-free-accent(upper(trim(ITEM.it-codigo ))).
           
           IF  v-cod-item = ""
           THEN
               ASSIGN v-cod-item = "DD". /* Para item d²bito direto branco, enviar DD, pois, o GKO n’o aceita c½digo em branco */
    
            /*********************** LAYOUT - 150 ***********************/
            PUT STREAM s-arquivo 
                "150"                                         FORMAT "x(3)"             /* 1 - TpRegistro                       */
                "A"                                           FORMAT "x(1)"             /* 2 - FlOperacao                       */
                fn-free-accent(upper(trim(ITEM.desc-item )))  FORMAT "x(40)"            /* 3 - DsItem                           */
                v-cod-item                                    FORMAT "x(20)"            /* 4 - CdItem                           */ 
                v-cod-familia                                 FORMAT "x(10)"            /* 5 - CdItemCategoria                  */
                substr(item.fm-cod-com,1,4)                                             /* 6 - Segmento                         */    
                SPACE(10)                                                               /* 7 - CdItemCategoria2                 */
                fn-free-accent(upper(trim(ITEM.un)))          FORMAT "x(3)"             /* 8 - Unidade1                         */
                1                                             FORMAT "9999999"          /* 9 - Qtd referencial                  */
                1                                             FORMAT "9999999"          /* 10- Peso                             */
                SKIP.                                                                   
    
            /*********************** LAYOUT - 160 ***********************/
    
            ASSIGN v-cod-conta-contab = ""
                   v-cod-ccusto       = ""
                   v-des-tipo-carga   = "Fracionada".
    
            IF  LAST-OF(it-nota-fisc.serie)
            THEN
                RUN pi-calcula-peso-cubado-item (YES).
            ELSE
                RUN pi-calcula-peso-cubado-item (NO).
    
            RUN pi-busca-conta-contabil.
    
            FIND FIRST param-correios /* Correios */
                WHERE param-correios.cod-estabel = nota-fiscal.cod-estabel
                  AND param-correios.tp-servico  = nota-fiscal.nome-transp NO-LOCK NO-ERROR.
            IF AVAIL param-correios THEN DO:
                FIND FIRST int-nota-conhec
                    WHERE int-nota-conhec.cod-estabel = nota-fiscal.cod-estabel    
                      AND int-nota-conhec.serie       = nota-fiscal.serie          
                      AND int-nota-conhec.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
                IF AVAIL int-nota-conhec THEN
                    ASSIGN v-qtd-peso-bruto = int-nota-conhec.peso-bruto / i-nro-itens.
                ELSE
                    ASSIGN v-qtd-peso-bruto = it-nota-fisc.peso-bruto / i-nro-itens.

                ASSIGN v-qtd-peso-liq   = it-nota-fisc.peso-liq-fat / i-nro-itens.
            END.
            ELSE DO:
                ASSIGN v-qtd-peso-bruto = it-nota-fisc.peso-bruto  
                       v-qtd-peso-liq   = it-nota-fisc.peso-liq-fat.
            END.

            IF  v-qtd-peso-bruto < 0.0001
            THEN
                ASSIGN v-qtd-peso-bruto = 0.0001.
    
            IF  v-qtd-peso-liq < 0.0001
            THEN
                ASSIGN v-qtd-peso-liq = 0.0001.
    
            IF  v-qtd-peso-cubado < 0.0001
            THEN
                ASSIGN v-qtd-peso-cubado = 0.0001.
            
            put STREAM s-arquivo 
                "160"                                                 format "x(03)"             /*  1 - TpRegistro        */
                "A"                                                   format "x(01)"             /*  2 - FlOperacao        */
                1                                                     format "9"                 /*  3 - TpParceiroComercial             */
                STRING(estabelec.cod-emitente)                        FORMAT "x(14)"             /*  3 - ParceiroComercial               */
                STRING(INT(nota-fiscal.nr-nota-fis),"9999999")        format "x(12)"             /*  4 - CdNota            */
                fn-free-accent(upper(trim(nota-fiscal.serie)))        format "x(03)"             /*  5 - CdSerie           */
                it-nota-fisc.nr-seq-fat * 0.1                         format "999"               /*  6 - NoNtaItem         */
                v-cod-item                                            format "x(20)"             /*  7 - CdItem            */
                round(it-nota-fisc.vl-tot-item,2)  * 100              format "999999999999"      /*  8 - VrNtaItem         */
                round(v-qtd-peso-bruto,4)   * 10000                   format "999999999999999"   /*  9 - QtPesoBruto       */
                0                                                     format "999999999999999"   /* 10 - QtPesoCubado      */
                round(v-qtd-peso-liq,4) * 10000                       format "999999999999999"   /* 11 - QtPesoLiquido     */
                v-qtd-volumes                                         format "9999"              /* 12 - QtVolume          */
                round(v-qtd-peso-cubado,4)         * 10000            format "9999999999"        /* 13 - VrCubagem         */
                v-cod-conta-contab                                    FORMAT "x(16)"             /* 14 - CdContaContabil   */
                v-cod-ccusto                                          format "x(10)"             /* 15 - CdCentroCusto     */
                round(it-nota-fisc.qt-faturada[1],2) * 100            format "999999999999999"   /* 16 - QtItem            */
                fn-free-accent(upper(trim(it-nota-fisc.un-fatur[1]))) FORMAT "x(3)"              /* 17 - DsUnItem          */
                0                                                     format "999999999999999"   /* 18 - VrFretePgCliTab   */
                0                                                     format "999999999999999"   /* 19 - VrFretePgCliente  */
                0                                                     FORMAT "9"                 /* 20 - StCreditoICMS     */
                0                                                     FORMAT "9"                 /* 21 - StCreditoImposto1 */
                0                                                     FORMAT "9"                 /* 22 - StCreditoImposto2 */
                0                                                     FORMAT "9"                 /* 23 - StCreditoImposto3 */
                v-des-tipo-carga                                      FORMAT "x(10)"             /* 24 - TxObservacao - Utilizado para filtrar tipo de carga no relat½rio de embarques, chamado IR87345 */
                it-nota-fisc.nat-operacao                             FORMAT "x(6)"
                skip.

            /*********************** LAYOUT - 162 ***********************/
            PUT STREAM s-arquivo 
                "162"                                         FORMAT "x(3)"             /* 1 - TpRegistro                       */
                "CAT_SOLAR"                                   FORMAT "x(15)"            /* 2 - CDREFERENCIA1                    */
                trim(item.fm-cod-com)                         FORMAT "x(20)"            /* 6 - DSREFERENCIA1                    */    
                SKIP.
                        
      end. /* for each it-nota-fisc of nota-fiscal NO-LOCK, */

END PROCEDURE.

PROCEDURE imprimi-nf-entrada-arquivo:

    
        IF tt-param.tg-habilita = NO THEN DO:
            IF  docum-est.cod-estabel < tt-param.cod-estab-ini OR
                docum-est.cod-estabel > tt-param.cod-estab-fim
            THEN NEXT. 
            IF docum-est.nro-docto < tt-param.num-nota-ini OR
               docum-est.nro-docto > tt-param.num-nota-fim 
            THEN do :
            NEXT. 
            end.  
        END.
        IF tt-param.log-desconsidera = NO THEN DO:
            IF tt-param.log-desc-parametro = NO THEN DO:
                FIND FIRST tt-cliente NO-LOCK
                    WHERE  tt-cliente.cod-emitente = docum-est.cod-emitente NO-ERROR.
                IF AVAIL tt-cliente
                    AND (tt-cliente.cod-estabel <> ""
                      and tt-cliente.cod-estabel = docum-est.cod-estabel) THEN
                        NEXT.
            END.
            
            IF tt-param.log-correios = NO THEN DO:
                FIND FIRST tt-transportadora NO-LOCK
                    WHERE  tt-transportadora.nome-abrev = docum-est.nome-transp NO-ERROR.
                IF  AVAIL tt-transportadora THEN NEXT.
            END. /* IF tt-param.log-correios = NO THEN DO: */
        END. /* IF tt-param.log-desconsidera = NO THEN DO: */
    
        FIND FIRST transporte NO-LOCK
            WHERE  transporte.nome-abrev = docum-est.nome-transp NO-ERROR.

        IF NOT AVAIL transporte THEN

          FIND FIRST transporte
               WHERE transporte.nome-abrev = "GENERICAGKO" NO-LOCK NO-ERROR.
        
         IF tt-param.tg-habilita = NO THEN DO:

            IF  AVAIL transporte AND 
                     (transporte.cod-transp < tt-param.cod-transp-ini  OR
                      transporte.cod-transp > tt-param.cod-transp-fim) THEN NEXT.
         END.
         
        ASSIGN v-cod-tipo-operac = "A"
               c-TpStatusDNE     = "A".

        /*Verificar nota de devolu¯Êo*/
        FIND FIRST devol-cli 
             WHERE devol-cli.cod-estabel = docum-est.cod-estabel
               AND devol-cli.serie       = docum-est.serie-docto 
               AND devol-cli.nr-nota-fis = docum-est.nro-docto NO-LOCK NO-ERROR.
        
        IF AVAIL devol-cli THEN
            FIND FIRST nota-fiscal //tratativa para gerar arquivo entrada para notas de devolucao 
                 WHERE nota-fiscal.cod-estabel = devol-cli.cod-estabel
                   AND nota-fiscal.serie       = devol-cli.serie
                   AND nota-fiscal.nr-nota-fis = devol-cli.nr-nota-fis
                   AND nota-fiscal.dt-saida    <> DATE("") NO-LOCK NO-ERROR.

            IF AVAIL nota-fiscal AND docum-est.nome-transp = "" THEN NEXT.

        /* Validar nota j˜ integrada */ 
        IF tt-param.log-desconsidera = NO THEN DO:
            IF  tt-param.log-reexportar = NO THEN DO:

                IF CAN-FIND(FIRST gko-nfs-integrada                                                                                                               
                            WHERE gko-nfs-integrada.cod-estabel              = docum-est.cod-estabel                                                                        
                              AND gko-nfs-integrada.serie                    = docum-est.serie-docto                                                                              
                              AND gko-nfs-integrada.nr-nota-fis              = docum-est.nro-docto
                              AND gko-nfs-integrada.cod-chave-aces-nf-eletr  = docum-est.cod-chave-aces-nf-eletro
                              AND gko-nfs-integrada.cod-emitente             = docum-est.cod-emitente  
                              AND gko-nfs-integrada.tipo-operacao            = c-TpStatusDNE)
                THEN do:
                    NEXT. 
                END.
    
            END.
        END. /* IF tt-param.log-desconsidera = NO THEN DO: */
        EMPTY TEMP-TABLE tt-volume-item-nf.

        //modificando para gerar um arquivo por nota.

        IF  tt-param.dat-emis-ini = 01/01/0001 AND
            tt-param.dat-emis-fim = 12/31/9999 OR
            tt-param.tg-habilita  = YES
        THEN
        ASSIGN tt-param.dat-emis-ini = TODAY - 60
               tt-param.dat-emis-fim = TODAY.
    /* FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE */
    /* FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE FRDNE */
    /************************  LAYOUT 000  ***************************/
        ASSIGN v-cod-arq-destino = v-cod-arq-destino-aux
                                 + "FRDNE"
                                 + STRING(docum-est.nro-docto)
                                 + string(day(TODAY),"99")
                                 + string(month(TODAY),"99")
                                 + string(YEAR(TODAY),"9999")
                                 + string(TIME)
                                 + ".txt".

        output STREAM s-arquivo to value(v-cod-arq-destino) page-size 0.

        //modificando para gerar um arquivo por nota.
        PUT STREAM s-arquivo 
          "000"       FORMAT "x(03)" /* 1 - TpRegistro   */
          "IntDNE"    FORMAT "x(10)" /* 2 - NmInterface  */
          "6.42a"     FORMAT "x(06)" /* 3 - Versao       */
          "INTELBRAS" FORMAT "x(40)" /* 4 - Remetente    */
          "GKO"       FORMAT "x(40)" /* 5 - Destinatario */
          "EMS"       FORMAT "x(03)" /* 6 - CdAmbiente   */
        SKIP.
        
        RUN pi-acompanhar IN h-acomp (INPUT "FRDNE docum-est: " + string(docum-est.nro-docto) + " Transp: " + docum-est.nome-transp).

        FIND estabelec NO-LOCK
            WHERE estabelec.cod-estabel = docum-est.cod-estabel NO-ERROR.

        FIND FIRST gko-nfs-integrada NO-LOCK
             WHERE gko-nfs-integrada.cod-estabel              = docum-est.cod-estabel   
               AND gko-nfs-integrada.serie                    = docum-est.serie-docto         
               AND gko-nfs-integrada.nr-nota-fis              = docum-est.nro-docto
               AND gko-nfs-integrada.cod-chave-aces-nf-eletr  = docum-est.cod-chave-aces-nf-eletro 
               AND gko-nfs-integrada.cod-emitente             = docum-est.cod-emitente
               AND gko-nfs-integrada.tipo-operacao            = c-TpStatusDNE 
                NO-ERROR.
        IF  NOT AVAIL gko-nfs-integrada THEN DO:
            CREATE gko-nfs-integrada.                                                                                                                     
            ASSIGN gko-nfs-integrada.cod-estabel              = docum-est.cod-estabel                                                                               
                   gko-nfs-integrada.serie                    = docum-est.serie-docto                                                                                     
                   gko-nfs-integrada.nr-nota-fis              = docum-est.nro-docto
                   gko-nfs-integrada.cod-chave-aces-nf-eletr  = docum-est.cod-chave-aces-nf-eletro 
                   gko-nfs-integrada.cod-emitente             = docum-est.cod-emitente 
                   gko-nfs-integrada.tipo-operacao            = c-TpStatusDNE
                   gko-nfs-integrada.dat-integracao           = TODAY
                   gko-nfs-integrada.hor-integracao           = TIME
                   gko-nfs-integrada.arq-integracao           = v-cod-arq-destino.   
        END.
        
         FIND FIRST b-emitente NO-LOCK
              WHERE  b-emitente.cgc = transporte.cgc NO-ERROR.

        ASSIGN v-ind-modal-peso-cubado = transporte.via-transp.

        /*---------------------- Grava os Dados da Nota Fiscal ------------------*/        
    
        find first natur-oper
             where natur-oper.nat-operacao = docum-est.nat-operacao no-lock no-error.
        find first estabelec
             where estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.
    
        for FIRST nota-embal use-index ch-nota-emb NO-LOCK
            where nota-embal.cod-estabel = docum-est.cod-estabel
              and nota-embal.serie       = docum-est.serie-docto
              and nota-embal.nr-nota-fis = docum-est.nro-docto:
            ASSIGN v-cod-embalagem = nota-embal.sigla-emb.
        END.

        FIND FIRST emitente 
            WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.
   
        /************************  LAYOUT 100  ***************************/ 
        RUN pi-gera-registro-100 (INPUT /*estabelec.cod-emitente,*/ docum-est.cod-emitente,
                                  INPUT 2).
    
        FIND FIRST emitente 
            WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.
        IF AVAIL emitente THEN DO:

            FIND FIRST gr-cli WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
            IF AVAIL gr-cli THEN DO:
                PUT STREAM s-arquivo 
                    "102"                                        format "x(03)"             /*  1 - Registro Identificador           */
                    "TIPO DE CLIENTE"
                    gr-cli.descricao                             format "x(20)"             /*  3 - Tipo de Cliente                  */
                    SKIP.
            END. /* IF AVAIL gr-cli THEN DO: */

        END. /* IF AVAIL emitente THEN DO: */

        /*********************** LAYOUT - 140 ***********************/    
        put STREAM s-arquivo 
            "140"                                                format "x(03)"             /*  1 - Registro Identificador           */
            fn-free-accent(upper(trim(v-cod-tipo-operac)))       format "x(01)"             /*  2 - FlOperacao                       */
            "1"                                                  format "x(01)"             /*  3 - TpDocumento (1-Nota Fiscal )     */
            2                                                    format "9"                 /*  4 - TpParceiroComercial              */
            STRING(docum-est.cod-emitente)                       FORMAT "x(14)"             /*  4 - CdParceiroComercial              */
            STRING(INT(docum-est.nro-docto),"999999999999")      format "x(12)"             /*  5 - CdNota                           */
            fn-free-accent(upper(trim(docum-est.serie-docto)))   format "x(03)"             /*  6 - CdSerie                          */
            docum-est.dt-emissao                                 format "99/99/9999"        /*  7 - DtEmissao                        */
            docum-est.dt-emissao                                 format "99/99/9999"        /*  8 - DtEmbarque                       */
            "1"                                                  format "x(01)".            /*  9 - TpEntradaSaida (2- Saðda)        */
                                                                                                                                
     
                                                                                                                           
       PUT STREAM s-arquivo 1                                    format "9".                /*  4 - TpParceiroComercial              */
       PUT STREAM s-arquivo string(estabelec.cod-emitente)       format "x(14)".            /* 10 - ParDestRemet (Destinat˜rio)      */
       
       PUT STREAM s-arquivo SPACE(130).                                                        
                                                                                
       PUT STREAM s-arquivo 
            SPACE(10)                                                                   /* 16 - CdZonaTransporte                 */
            SPACE(12)                                                                   /* 17 - CdDocNegFrete                    */
            docum-est.nat-operacao                           FORMAT "x(6)"              /* 18 - CdTipoNota                       */                
            SPACE(10)                                                                   /* 19 - CdEquipamento                    */ 
            fn-free-accent(upper(trim(v-cod-embalagem)))     FORMAT "x(4)"              /* 20 - Embalagem                        */
            string(int(transporte.via-transp))               FORMAT "x(4)"              /* 21 - CdMeioTransporte                 */
            SPACE(10)                                                                   /* 22 - CdTerritorio                     */
            SPACE(5)                                                                    /* 23 - CdVendedor                       */
            SPACE(10)                                                                   /* 24 - DsSeparadorConhecimento          */
            SPACE(20)                                                                   /* 25 - DsLote                           */
            SPACE(10)                                                                   /* 26 - CdRomaneio                       */
            transporte.cgc FORMAT "x(15)".                                              /* 27 - CdTransportadora                 */
          
       PUT STREAM s-arquivo "2"  /*fob*/                      FORMAT "x(01)".            /* 28 - TpFrete                          */
                                                                                   
       PUT STREAM s-arquivo 
            "            "                                   FORMAT "X(12)"             /* 29 - CdDocumentoVinculado            */
            "1"                                              FORMAT "X(3)"              /* 30 - CdSerieDocumentoVinculado        */

            "1"                                              FORMAT "x(10)"             /* 31 - CdTipoCarga                      */
            docum-est.nat-operacao                           FORMAT "x(06)"             /* 32 - CdNaturezaOperacao               */                      
            "0"                                              FORMAT "x(01)"             /* 33 - StIsentoImposto                  */
            "0"                                              FORMAT "x(01)".            /* 34 - StItemSubTribNaCompra            */      
        
                PUT STREAM s-arquivo "3" FORMAT "x(01)".
 
        PUT STREAM s-arquivo 
            SPACE(10)                                                                   /* 36 - CdIndiceFinanceiro              */
            0                                                FORMAT "9"                 /* 37 - StUrgenciaEntrega               */
            0                                                FORMAT "9"                 /* 38 - StFreteDiferenciado             */
            docum-est.dt-trans.                                                         /* 39 - DtEntrega                       */
                                                                                     
            PUT STREAM s-arquivo 
                1 FORMAT "9"
                STRING(estabelec.cod-emitente)              FORMAT "x(14)".            /* 40 - ChaveRespFrete                  */
        
        PUT STREAM s-arquivo 
            SPACE(10)                                                                   /* 41 - DtTabPreco                      */
            SPACE(10)                                                                   /* 42 - DtPrevisaoColeta                */
            SPACE(10)                                                                   /* 43 - DtPrevisaoEntega                */
            0 FORMAT "999999999999999".                                                 /* 44 - VrFretePgCliente                */
                                                                                      

        IF c-TpStatusDNE = "E" THEN
            PUT STREAM s-arquivo "2"                        FORMAT "9".
        ELSE
            PUT STREAM s-arquivo "1"                        FORMAT "9".                /* 45 - TpStatusDNE(1- normal, 2- cancelado) */
                                                           
        PUT  STREAM s-arquivo 
             1                                              FORMAT "9"                 /* 97 - StExcluiRegEmbTrans             */
             1                                              FORMAT "9"                 /* 98 - StExcluiItemDNE                 */
             1                                              FORMAT "9"                 /* 99 - StExcluiRefExt                  */
             docum-est.cod-chave-aces-nf-eletro             FORMAT "x(44)"             /* OP - DsChaveAcesso                   */
             SKIP.
    
    
       /*********************** LAYOUT - 142 ***********************/
        put STREAM s-arquivo 
            "142"                                        format "x(03)"             /*  1 - Registro Identificador           */
            "CANAL_VENDA"                                format "x(15)"             /*  2 - CdReferencia1                    */
            "CANAL_VENDA"                                format "x(15)"             /*  3 - DsReferencia1                    */
            SPACE(5)
            "ATENDENTE"                                  FORMAT "X(15)".            /*  4 - Atendente                        */

                PUT STREAM s-arquivo SPACE(20).
        IF  AVAIL ordem-compra THEN DO:
            PUT STREAM s-arquivo  UNFORMATTED "IMPLANTACAO    "
                              SPACE(20)
                             "APROV_COMERCIAL".
            
                PUT STREAM s-arquivo UNFORMATTED SPACE(20).
           
            PUT STREAM s-arquivo UNFORMATTED "ALTER_COMERCIAL". 
                
      
            PUT STREAM s-arquivo UNFORMATTED "               " FORMAT "x(15)". 

            
            IF  AVAIL ordem-compra  THEN DO:
                    PUT STREAM s-arquivo UNFORMATTED "                    ".
            END.
            ELSE
                PUT STREAM s-arquivo UNFORMATTED "                    " .


            PUT STREAM s-arquivo UNFORMATTED "APROV_CREDITO  ".
                    
         
                    PUT STREAM s-arquivo UNFORMATTED SPACE(20).
         
            PUT STREAM s-arquivo UNFORMATTED "ALTER_COMERCIA2" .
            
                PUT STREAM s-arquivo "          " SPACE(10) .

            PUT STREAM s-arquivo UNFORMATTED "ENTREGA_PEDIDO " 
                 SPACE(20).

                PUT STREAM s-arquivo UNFORMATTED "                ".
        

            PUT STREAM s-arquivo SKIP.
        END.
        ELSE
            PUT STREAM s-arquivo SKIP.                                                                           
            ASSIGN v-qtd-total-volumes = 0.
       ASSIGN i-nro-itens = 0.
       for each item-doc-est of docum-est NO-LOCK:
           ASSIGN i-nro-itens = i-nro-itens + 1.
       END.
       for each item-doc-est of docum-est NO-LOCK,
            FIRST ITEM OF item-doc-est NO-LOCK
            BREAK BY item-doc-est.nro-docto
                 BY item-doc-est.serie-docto
                 :
                 
   
                 
           ASSIGN v-cod-familia = fn-free-accent(upper(trim(item-doc-est.cod-unid-negoc)))
                  v-cod-item    = fn-free-accent(upper(trim(ITEM.it-codigo ))).
           
           IF  v-cod-item = ""
           THEN
               ASSIGN v-cod-item = "DD". /* Para item dýbito direto branco, enviar DD, pois, o GKO nÊo aceita c«digo em branco */
    
            /*********************** LAYOUT - 150 ***********************/
            PUT STREAM s-arquivo 
                "150"                                         FORMAT "x(3)"             /* 1 - TpRegistro                       */
                "A"                                           FORMAT "x(1)"             /* 2 - FlOperacao                       */
                fn-free-accent(upper(trim(ITEM.desc-item )))  FORMAT "x(40)"            /* 3 - DsItem                           */
                v-cod-item                                    FORMAT "x(20)"            /* 4 - CdItem                           */ 
                trim(v-cod-familia)                           FORMAT "x(10)"            /* 5 - CdItemCategoria                  */
                trim(substr(item.fm-cod-com,1,4))             FORMAT "x(10)"            /* 6 - Segmento                         */    
                fn-free-accent(upper(trim(ITEM.un)))          FORMAT "x(3)"             /* 8 - Unidade1                         */
                1                                             FORMAT "9999999"          /* 9 - Qtd referencial                  */
                1                                             FORMAT "9999999"          /* 10- Peso                             */
                SKIP.                                                                   
    
            /*********************** LAYOUT - 160 ***********************/
    
            ASSIGN v-cod-conta-contab = item-doc-est.conta-contabil
                   v-cod-ccusto       = item-doc-est.sc-codigo
                   v-des-tipo-carga   = "Fracionada".
                ASSIGN v-qtd-peso-bruto = docum-est.peso-bruto-tot  
                       v-qtd-peso-liq   = item-doc-est.peso-liquido.

            IF  v-qtd-peso-bruto < 0.0001 
            THEN
                ASSIGN v-qtd-peso-bruto = 0.0001.
            
            IF  v-qtd-peso-liq < 0.0001 
            THEN
                ASSIGN v-qtd-peso-liq = 0.0001.

            
            IF  v-qtd-peso-cubado < 0.0001 
            THEN
                ASSIGN v-qtd-peso-cubado = 0.0001.
            
            RUN esp/es0018p.p (INPUT "gk0001":U,
                                 INPUT 8,
                                 INPUT 0,
                                 INPUT "":U,
                                 OUTPUT TABLE tt-prog-pont8).

            FOR FIRST tt-prog-pont8 NO-LOCK:
                assign v-cod-conta-contab = ENTRY(1,tt-prog-pont8.conteudo,";")
                       v-cod-ccusto       = ENTRY(2,tt-prog-pont8.conteudo,";").
            END.
            EMPTY TEMP-TABLE tt-prog-pont8.

            put STREAM s-arquivo 
                "160"                                                  format "x(03)"             /*  1 - TpRegistro        */
                "A"                                                    format "x(01)"             /*  2 - FlOperacao        */
                1                                                      format "9"                 /*  3 - TpParceiroComercial             */
                STRING(estabelec.cod-emitente)                         FORMAT "x(14)"             /*  3 - ParceiroComercial               */
                STRING(INT(docum-est.nro-docto),"999999999999")        format "x(12)"             /*  4 - CdNota            */
                upper(trim(docum-est.serie-docto))                     format "x(03)"             /*  5 - CdSerie           */
                item-doc-est.sequencia                                 format "999"               /*  6 - NoNtaItem         */
                v-cod-item                                             format "x(20)"             /*  7 - CdItem            */
                round(item-doc-est.preco-total[1],2)  * 100            format "999999999999"      /*  8 - VrNtaItem         */
                round(v-qtd-peso-bruto /*v-qtd-peso-bruto*/,4) * 10000 format "999999999999999"   /*  9 - QtPesoBruto       */
                round(v-qtd-peso-liq /*v-qtd-peso-bruto*/,4) * 10000   format "999999999999999"   /* 10 - QtPesoCubado      */
                round(v-qtd-peso-liq /*v-qtd-peso-liq*/,4)   * 10000   format "999999999999999"   /* 11 - QtPesoLiquido     */
                i-nro-itens /*v-qtd-volumes */                         format "9999"              /* 12 - QtVolume          */
                round(v-qtd-peso-cubado,4) * 10000                     format "9999999999"        /* 13 - VrCubagem         */
                v-cod-conta-contab                                     FORMAT "9999999999999999"  /* 14 - CdContaContabil   */
                v-cod-ccusto                                           format "9999999999"        /* 15 - CdCentroCusto     */
                round(item-doc-est.quantidade,4) * 100                 format "999999999999999"   /* 16 - QtItem            */
                space(3)                                                                          /* 17 - DsUnItem          */
                0                                                      format "999999999999999"   /* 18 - VrFretePgCliTab   */
                0                                                      format "999999999999999"   /* 19 - VrFretePgCliente  */
                0                                                      FORMAT "9"                 /* 20 - StCreditoICMS     */
                0                                                      FORMAT "9"                 /* 21 - StCreditoImposto1 */
                0                                                      FORMAT "9"                 /* 22 - StCreditoImposto2 */
                0                                                      FORMAT "9"                 /* 23 - StCreditoImposto3 */
                v-des-tipo-carga                                       FORMAT "x(10)"             /* 24 - TxObservacao - Utilizado para filtrar tipo de carga no relat«rio de embarques, chamado IR87345 */
                item-doc-est.nat-operacao                              FORMAT "x(6)"
                skip.
      end. /* for each it-docum-est of docum-est NO-LOCK, */

END PROCEDURE. /*imprimi-nf-entrada-arquivo*/


RETURN "OK".



