/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*:T*******************************************************************************
**
**  Objetivo.: Importa‡Æo Arquivo Atualiza‡Æo Custos 
**  Cria‡Æo..: Silvio Ferrari
**
*******************************************************************************/
{include/i-prgvrs.i ESCSP011RP.P 2.00.00.000}

/* Include Definitions ---                                              */
{esp/csp/escsp011.i} /* Defini‡Æo das Temp-Tables tt-param, tt-digita e tt-raw-digita */
{include/i-rpvar.i}

/* Variable Definitions ---                                             */
DEFINE VARIABLE h-acomp         AS HANDLE                            NO-UNDO.
DEFINE VARIABLE c-linha         AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE da-iniper       AS DATE        FORMAT "99/99/9999"   NO-UNDO.
DEFINE VARIABLE da-fimper       AS DATE        FORMAT "99/99/9999"   NO-UNDO.
DEFINE VARIABLE i-per-corrente  AS INT         FORMAT "99"           NO-UNDO.
DEFINE VARIABLE i-ano-corrente  AS INT         FORMAT "9999"         NO-UNDO.
DEFINE VARIABLE da-iniper-fech  AS DATE        FORMAT "99/99/9999"   NO-UNDO.
DEFINE VARIABLE da-fimper-fech  AS DATE        FORMAT "99/99/9999"   NO-UNDO.
DEFINE VARIABLE c-per           LIKE ext-per-custo.periodo           NO-UNDO.

def var i-empresa-prin as CHAR no-undo.
DEF VAR i-aux          AS INTEGER NO-UNDO.

DEFINE STREAM s-imp.

DEFINE TEMP-TABLE tt-import NO-UNDO
    FIELD cc-codigo   LIKE centro-custo.cc-codigo
    FIELD ct-codigo   AS CHAR FORMAT "x(8)"
    FIELD cod-estabel LIKE ext-per-custo-estab.cod-estabel
    FIELD valor       AS DECIMAL DECIMALS 4 format ">>>>,>>>,>>9.99". 

/* Temp-Table Definitions ---                                           */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

/* Transfer Definitions ---                                             */
CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param NO-ERROR.

/* **********************       Main Block      *********************** */

/* Posicionando Tabelas ---                                             */
FIND FIRST tt-param NO-ERROR.
FIND FIRST param-cs     NO-LOCK NO-ERROR.
FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST mgcad.empresa
    WHERE mgcad.empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

assign i-empresa-prin = param-global.empresa-prin.

/* Inicializando Vari veis ---                                          */
ASSIGN c-programa     = "ESCSP011RP":U
       c-versao	      = "2.00":U
       c-revisao	  = ".00.000":U
       c-empresa	  = IF AVAILABLE mgcad.empresa THEN mgcad.empresa.razao-social ELSE "":U
       c-sistema	  = "Espec¡ficos Intelbras":U
       c-titulo-relat = "Import. Arq. Atualiza‡Æo Custos":U.

FORM SKIP(1)
    "PAR¶METRO":U TO 20 SKIP(1)
    tt-param.arq-entrada FORMAT "x(80)":U LABEL "Arquivo de Entrada":U COLON 37 SKIP(1)
    SKIP(1)
    "ARQUIVO":U       TO 20 SKIP(1)
    tt-param.arquivo FORMAT "x(80)":U LABEL "Destino":U            COLON 37 SKIP
    tt-param.usuario     FORMAT "x(12)":U LABEL "Usu rio":U            COLON 37 SKIP(1)
    WITH STREAM-IO SIDE-LABELS NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-impressao.

FIND FIRST param-estoq NO-LOCK NO-ERROR.

IF AVAIL (param-estoq) THEN
   RUN cdp/cdapi005.p (INPUT param-estoq.ult-per-fech,
                       OUTPUT da-iniper,
                       OUTPUT da-fimper,
                       OUTPUT i-per-corrente,
                       OUTPUT i-ano-corrente,
                       OUTPUT da-iniper-fech,
                       OUTPUT da-fimper-fech).

ASSIGN c-per = STRING(i-ano-corrente,"9999")+ STRING(i-per-corrente,"99").

/* Iniciar mensagem de acompanhamento */
IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "":U).

INPUT STREAM s-imp FROM VALUE(tt-param.arq-entrada).

REPEAT ON STOP UNDO, LEAVE:
    IMPORT STREAM s-imp UNFORMATTED c-linha.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT TRIM(ENTRY(1, c-linha, ";":U))).

    IF CAN-FIND(FIRST centro-custo
                WHERE centro-custo.cc-codigo = TRIM(ENTRY(1, c-linha, ";":U)) NO-LOCK) THEN DO:

        CREATE tt-import.
        ASSIGN tt-import.cc-codigo   = TRIM(ENTRY(1, c-linha, ";":U))
               tt-import.ct-codigo   = SUBSTRING(ENTRY(2, c-linha, ";":U),1,8)
               tt-import.cod-estabel = TRIM(ENTRY(3, c-linha, ";":U))
               tt-import.valor       = DEC(ENTRY(4, c-linha, ";":U)).

    END.
END.
INPUT STREAM s-imp CLOSE.

DO ON ERROR UNDO, LEAVE
   ON STOP  UNDO, LEAVE:

    blk-main:
    FOR EACH tt-import NO-LOCK:

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Atualizando: " + tt-import.cc-codigo).

        FIND FIRST ccusto-estab 
             WHERE ccusto-estab.cc-codigo   = tt-import.cc-codigo 
               AND ccusto-estab.cod-estabel = tt-import.cod-estabel 
        NO-LOCK NO-ERROR.

        IF AVAIL ccusto-estab THEN 
        DO:
            //Grava tabela ext-per-custo
            FIND FIRST ext-per-custo
                 WHERE ext-per-custo.cc-codigo = ccusto-estab.cc-codigo
                   AND ext-per-custo.mo-codigo = 0 
                   AND ext-per-custo.periodo   = c-per EXCLUSIVE-LOCK NO-ERROR.
    
            IF NOT AVAIL ext-per-custo THEN DO:

                create ext-per-custo.
                assign ext-per-custo.cc-codigo = ccusto-estab.cc-codigo
                       ext-per-custo.mo-codigo = 0
                       ext-per-custo.periodo   = c-per.
            END.

            DO i-aux = 1 to 6: 

                IF param-cs.ocorrencia[i-aux] <> "" THEN DO:

                    IF ccusto-estab.ct-codigo[i-aux] = tt-import.ct-codigo THEN DO:
                        ASSIGN ext-per-custo.custo-total[i-aux] = tt-import.valor.
                        NEXT.
                    END.
                END.

            END.

            // Grava tabela ext-per-custo-estab
            FIND FIRST ext-per-custo-estab
                 WHERE ext-per-custo-estab.cc-codigo   = ccusto-estab.cc-codigo
                   AND ext-per-custo-estab.mo-codigo   = 0 
                   AND ext-per-custo-estab.periodo     = c-per 
                   AND ext-per-custo-estab.cod-estabel = tt-import.cod-estabel EXCLUSIVE-LOCK NO-ERROR.
    
            IF NOT AVAIL ext-per-custo-estab THEN DO:

                create ext-per-custo-estab.
                assign ext-per-custo-estab.cc-codigo   = ccusto-estab.cc-codigo
                       ext-per-custo-estab.mo-codigo   = 0
                       ext-per-custo-estab.periodo     = c-per
                       ext-per-custo-estab.cod-estabel = tt-import.cod-estabel.
            END.

            DO i-aux = 1 to 6: 

                IF param-cs.ocorrencia[i-aux] <> "" THEN DO:

                    IF ccusto-estab.ct-codigo[i-aux] = tt-import.ct-codigo THEN DO:
                        ASSIGN ext-per-custo-estab.custo-total[i-aux] = tt-import.valor.
                        NEXT.
                    END.
                END.

            END.
        END.
    END.
END.


{include/i-rpout.i &STREAM="stream str-rp" &TOFILE=tt-param.arquivo}
{include/i-rpcab.i &STREAM="str-rp"}

VIEW STREAM str-rp FRAME f-cabec.
VIEW STREAM str-rp FRAME f-rodape.

PAGE STREAM str-rp.

DISPLAY STREAM str-rp
    tt-param.arq-entrada
    tt-param.arquivo
    tt-param.usuario
    WITH FRAME f-impressao.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

{include/i-rpclo.i &STREAM="stream str-rp"}

IF VALID-HANDLE(h-acomp) THEN
    DELETE OBJECT h-acomp.

RETURN "OK":U.
