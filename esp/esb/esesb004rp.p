{include/i-prgvrs.i esesb004RP 2.00.00.000}  

define temp-table tt-param no-undo
    field destino             AS INTEGER
    field arquivo             AS CHAR format "x(35)"
    field usuario             AS CHAR format "x(12)"
    field data-exec           AS DATE
    field hora-exec           AS INTEGER.

def temp-table tt-raw-digita 
    FIELD raw-digita	as raw.

/* recebimento de parÉmetros */
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.
/*{cdp/cdcfgdis.i}*/

DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.                                                        

/* include padr∆o para vari†veis de relat¢rio  */
{include/i-rpvar.i}

/*{method/dbotterr.i}*/

/* bloco principal do programa */
ASSIGN c-programa     = "esesb004"
       c-versao       = "2.00"
       c-revisao      = ".00.000"
       c-empresa      = "Intelbras"
       c-sistema      = "Obrigaá∆o Fiscal"
       c-titulo-relat = "Agendamento Mensagem Inadimplància".

/*include padr∆o para output de relat¢rios*/
{include/i-rpout.i}

/* include com a definiá∆o da frame de cabeáalho e rodapÇ */
{include/i-rpcab.i}

{include/tt-edit.i}
{include/pi-edit.i}

{include/i-freeac.i}
/** Include com a temp table principal e a temp table de par≥metros **/
{bi/esbi000.i}

define variable c-negativos   as character   no-undo.
define variable c-pais        as character   no-undo.
define variable c-estado      as character   no-undo.
define variable c-cidade      as character   no-undo.
DEFINE VARIABLE i-cont        AS INTEGER     NO-UNDO.


{esp/esb/out/msg0120.i}

/* Temp-table conforme mensagem definiá∆o MSG0098R1 */
{esp/esb/esesbapi001.i}

DEF TEMP-TABLE tt-atraso-emitente
    FIELD cod-emitente AS INTEGER
    FIELD dias-atraso AS INTEGER.


view frame f-cabec.
view frame f-rodape.

IF  NOT VALID-HANDLE(h-acomp) THEN                                  
    RUN utp/ut-acomp.p PERSISTENT set h-acomp.                      
                                                                    
if valid-handle(h-acomp) then                                       
    run pi-inicializar in h-acomp (input "Gerando Mesnsagens"). 
    

PUT SKIP(1) "C¢d. Emitente Dias Maior Atraso" SKIP
    "------------- -----------------" SKIP.

FOR EACH int-emitente NO-LOCK
    WHERE int-emitente.ind-participa-canais = 993520001: /*Participa Programa Canais*/
    
    RUN esp/esb/esesbapi001.p (INPUT int-emitente.cod-emitente,
                               OUTPUT TABLE tt-titulos-canal).

    RUN pi-carrega-tt.

    ASSIGN i-cont = i-cont + 1.
    IF  i-cont = 5 THEN DO:
        run pi-acompanhar in h-acomp (input "Enviando mensagem...Cliente: " + STRING (int-emitente.cod-emitente)). 
        ASSIGN i-cont = 0.

    END.

END.

/* Lista a temp-table */
FOR EACH tt-atraso-emitente:
    PUT tt-atraso-emitente.cod-emitente TO 13 tt-atraso-emitente.dias-atraso TO 31 SKIP.
END.

/* Envia para o Barramento */
IF  CAN-FIND( FIRST tt-atraso-emitente ) THEN DO:

    RUN esp/esb/out/msg0120.p (INPUT  TABLE tt-atraso-emitente,
                               OUTPUT TABLE resultado) NO-ERROR .

    FIND FIRST resultado NO-ERROR.
    IF  AVAIL resultado THEN
        PUT SKIP(2) "    Erro:  " resultado.CodigoErro SKIP
                    "    Detalhe: " resultado.mensagem SKIP.

    DISPLAY SKIP(2) "Processamento Finalizado." SKIP(1) WITH WIDTH 132 NO-BOX SIDE-LABELS COLUMN 5 FRAME fParam STREAM-IO.
END.
ELSE
    DISPLAY SKIP(2) "Nenhum emitente com t°tulos em atraso." SKIP(1) WITH WIDTH 132 NO-BOX SIDE-LABELS COLUMN 5 FRAME fParam STREAM-IO.

{include/i-rpclo.i}

if valid-handle(h-acomp) then    
    RUN pi-finalizar IN h-acomp. 
                                 
RETURN "OK".


PROCEDURE pi-carrega-tt:

    FOR EACH  tt-titulos-canal  USE-INDEX idx-dias-atraso NO-LOCK
        BREAK BY tt-titulos-canal.CodigoCliente
              BY tt-titulos-canal.NumeroDiasAtraso DESC: /* T°tulo com maior atrazo */
        
        /* BUSCAR O T÷TULO COM MAIOR NÈMERO DE DIAS EM ATRAZO */
        IF  FIRST-OF (tt-titulos-canal.NumeroDiasAtraso) THEN DO:
             CREATE tt-atraso-emitente.
             ASSIGN tt-atraso-emitente.cod-emitente = tt-titulos-canal.CodigoCliente
                    tt-atraso-emitente.dias-atraso  = tt-titulos-canal.NumeroDiasAtraso.
             
             LEAVE.
        END.
    END.

END.

