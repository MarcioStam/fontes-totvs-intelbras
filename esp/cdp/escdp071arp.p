 /*********************************************************************************
** Programa: esp/cdp/escdp071arp.p
** Vers∆o..: 1.00
** Data....: 25/09/2014
** Autor...: Francisco Alemida Franáa - TIC
** Obs.....: Programa de importaá∆o de supervisores.             
*********************************************************************************/
{include/i-prgvrs.i escdp071arp 2.00.00.000}  
{include/i-rpvar.i}
{include/i-freeac.i}


define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
    field raw-digita       as raw.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD tp-execucao      AS INTEGER
    FIELD c-arq-import     AS CHARACTER
    .
    
DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

    FIND LAST param-global NO-LOCK NO-ERROR.

create tt-param.
raw-transfer raw-param to tt-param.


DEFINE TEMP-TABLE tt-supervisor LIKE supervisor.

DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-linha AS CHARACTER   NO-UNDO.

{include/i-rpcab.i}    
{include/i-rpout.i}

RUN utp/ut-acomp.p PERSISTEN SET h-acomp.
RUN pi-inicializar IN h-acomp("Importando dados do arquivo...":U).

INPUT FROM VALUE(tt-param.c-arq-import) CONVERT SOURCE "iso8859-1".
REPEAT:
    IMPORT UNFORMATTED c-linha.
    
    IF c-linha = "" THEN
           LEAVE.

    CREATE tt-supervisor.
    ASSIGN tt-supervisor.cod-usuario   = ENTRY(1, c-linha, ";")
           tt-supervisor.unidade-negoc = ENTRY(2, c-linha, ";").

    RUN pi-acompanhar IN h-acomp (INPUT "Importando do arquivo, usu†rio: " + tt-supervisor.cod-usuario).

END. /*REPEAT*/
INPUT CLOSE.


FOR EACH tt-supervisor NO-LOCK:
    FIND FIRST supervisor
        WHERE supervisor.cod-usuario = tt-supervisor.cod-usuario NO-LOCK NO-ERROR.
    IF NOT AVAIL supervisor THEN DO:
        FIND FIRST usuar_mestre
            WHERE usuar_mestre.cod_usuario = tt-supervisor.cod-usuario NO-LOCK NO-ERROR.
        IF AVAIL usuar_mestre THEN DO:
            ASSIGN tt-supervisor.nome = usuar_mestre.nom_usuario.
        
            FIND FIRST unid_negoc
                WHERE unid_negoc.cod_unid_negoc = tt-supervisor.unidade-negoc NO-LOCK NO-ERROR.

            IF AVAIL unid_negoc THEN DO:
                CREATE supervisor.
                ASSIGN supervisor.cod-usuario = tt-supervisor.cod-usuario
                       supervisor.nome        = tt-supervisor.nome
                       supervisor.unidade-negoc  = tt-supervisor.unidade-negoc.
                
                RUN pi-acompanhar IN h-acomp (INPUT "Salvando dados na tabela, usu†rio: " + usuar_mestre.cod_usuario).
            END.
            ELSE DO:
                PUT UNFORMATTED "Supervisor " tt-supervisor.cod-usuario " unidade de neg¢cio n∆o encontrada ou inv†lida." SKIP.
            END.
        END.
        ELSE DO:
           PUT UNFORMATTED "Supervisor " tt-supervisor.cod-usuario " n∆o encontrado ou inv†lido." SKIP.
        END.
    END.
    ELSE DO:
        PUT UNFORMATTED "Supervisor " tt-supervisor.cod-usuario " ja cadastrado." SKIP. 
    END.
END. /*FOR EACH tt-supervisor*/

EMPTY TEMP-TABLE tt-supervisor.

PUT "Escrever".

run pi-finalizar in h-acomp.

{include/i-rpclo.i}

MESSAGE "Importaá∆o conclu°da."
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
