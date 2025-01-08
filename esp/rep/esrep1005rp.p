/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i SPRE026RP 2.00.00.001}  /*** 010001 ***/

/******************************************************************************
**
**       Programa: SPRE026RP
**
**       Objetivo: Desatualizacao/Atualiza‡Æo de Notas Fiscais
**
**       Versao..: 1.00.000
**
******************************************************************************/

{include/i_fnctrad.i}
{cdp/cd0666.i}
{cdp/cdcfgdis.i}
{utp/ut-glob.i}

/*--- temp-tables usadas na atualizacao do documento ---*/
define temp-table tt-param2
    field destino            as integer
    field arquivo            as char
    field usuario            as char
    field data-exec          as date
    field hora-exec          as integer
    field classifica         as integer
    field c-cod-estabel-ini  as char
    field c-cod-estabel-fim  as char
    field i-cod-emitente-ini as integer
    field i-cod-emitente-fim as integer
    field c-nro-docto-ini    as char
    field c-nro-docto-fim    as char
    field c-serie-docto-ini  as char
    field c-serie-docto-fim  as char
    field c-nat-operacao-ini as char
    field c-nat-operacao-fim as char
    field da-dt-trans-ini    as date
    field da-dt-trans-fim    as date.

DEFINE TEMP-TABLE tt-digita
    FIELD serie-docto   LIKE docum-est.serie-docto
    FIELD nro-docto     LIKE docum-est.nro-docto
    FIELD cod-emitente  LIKE docum-est.cod-emitente
    FIELD nat-operacao  LIKE docum-est.nat-operacao.

define temp-table tt-digita2
    field r-docum-est as rowid.

def var raw-param2  as raw no-undo.
DEF BUFFER b-docum-est FOR docum-est.
def temp-table tt-raw-digita2
   field raw-digita   as raw.

def temp-table tt-raw-digita 
    field raw-digita as raw.

/* Defini‡Æo Temp-Table */
define temp-table tt-param
      field destino            as integer
      field arquivo            as char
      field usuario            as char format "x(12)"
      field data-exec          as date
      field hora-exec          as integer
      FIELD c-cod-estab        AS CHAR
      field da-dt-trans-ini     as date format "99/99/9999"
      field da-dt-trans-fim     as date format "99/99/9999"
      field c-esp-ini          as char
      field c-esp-fim          as char
      field c-ser-ini          as char
      field c-ser-fim          as char
      field c-num-ini          as char
      field c-num-fim          as char
      field i-emit-ini         as integer
      field i-emit-fim         as integer
      field c-nat-ini          as char
      field c-nat-fim          as char
      FIELD c-usuar-ini        AS CHAR
      FIELD c-usuar-fim        AS CHAR.
    DEFINE TEMP-TABLE tt-ft0910 NO-UNDO
        FIELD destino           AS INTEGER
        FIELD arquivo           AS CHAR FORMAT "x(35)":U
        FIELD usuario           AS CHAR FORMAT "x(12)":U
        FIELD data-exec         AS DATE
        FIELD hora-exec         AS INTEGER
        FIELD cod-estabel       LIKE nota-fiscal.cod-estabel
        FIELD serie             LIKE nota-fiscal.serie
        FIELD nr-nota-fis-ini   LIKE nota-fiscal.nr-nota-fis
        FIELD nr-nota-fis-fim   LIKE nota-fiscal.nr-nota-fis
        FIELD nome-ab-cli-ini   LIKE nota-fiscal.nome-ab-cli
        FIELD nome-ab-cli-fim   LIKE nota-fiscal.nome-ab-cli
        FIELD dt-emis-nota-ini  LIKE nota-fiscal.dt-emis-nota
        FIELD dt-emis-nota-fim  LIKE nota-fiscal.dt-emis-nota
        FIELD gera-nfe-n-gerada AS LOGICAL
        FIELD gera-nfe-gerada   AS LOGICAL
        FIELD exporta-est-txt   AS LOGICAL
        FIELD gera-nfe-cancel   AS LOGICAL
        FIELD gera-nfe-inut     AS LOGICAL
        FIELD c-motivo          AS CHARACTER.

    DEFINE TEMP-TABLE tt-raw-ft0910 NO-UNDO
        FIELD raw-digita AS RAW.
def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

def var h-acomp as handle no-undo.
def var l-erro  as log    no-undo.

def var i-empresa like param-global.empresa-prin no-undo.

find first param-global no-lock no-error.
find first param-estoq  no-lock no-error.

{include/i-rpvar.i}
run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp ("Atualiza‡Æo de Documentos").

assign i-empresa = param-global.empresa-prin.

&if defined (bf_dis_consiste_conta) &then

    find estabelec where
         estabelec.cod-estabel = param-estoq.estabel-pad no-lock no-error.

    run cdp/cd9970.p (input rowid(estabelec),
                      output i-empresa).
&endif

find empresa where
     empresa.ep-codigo = i-empresa no-lock no-error.

create tt-param.
raw-transfer raw-param to tt-param.

assign c-empresa  = (if avail param-global then param-global.grupo else "")
       c-programa = "ESREP/1005"
       c-versao   = "1.00"
       c-revisao  = "000".

def frame f-docto
    docum-est.nro-docto
    docum-est.serie-docto
    docum-est.cod-emitente
    docum-est.nat-operacao
    tt-erro.cd-erro                  column-label "Erro"
    tt-erro.mensagem format "x(77)"  column-label "Mensagem"
    with stream-io width 132 down frame f-docto.

run utp/ut-trfrrp.p (input frame f-docto:handle).
{include/i-rpcab.i}

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

create tt-param2.
assign tt-param2.usuario         = c-seg-usuario
       tt-param2.destino         = 3
       tt-param2.data-exec       = today
       tt-param2.hora-exec       = TIME.

IF OPSYS <> "UNIX" AND i-num-ped-exec-rpw = 0 THEN
    ASSIGN tt-param2.arquivo         = session:temp-directory + "ESREP1005_":U + c-seg-usuario + "_" +
                                   SUBstring(STRING(today,"99/99/99"),1,2) +
                                   SUBstring(STRING(today,"99/99/99"),4,2) +
                                   SUBstring(STRING(today,"99/99/99"),7,2) +
                                   substring(string(time,"hh:mm:ss"),1,2) + 
                                   substring(string(time,"hh:mm:ss"),4,2) + 
                                   substring(string(time,"hh:mm:ss"),7,2) + 
                                   ".lst":U.
ELSE
    ASSIGN tt-param2.arquivo         = "ESREP1005_":U + c-seg-usuario + "_" +
                                   SUBstring(STRING(today,"99/99/99"),1,2) +
                                   SUBstring(STRING(today,"99/99/99"),4,2) +
                                   SUBstring(STRING(today,"99/99/99"),7,2) +
                                   substring(string(time,"hh:mm:ss"),1,2) + 
                                   substring(string(time,"hh:mm:ss"),4,2) + 
                                   substring(string(time,"hh:mm:ss"),7,2) + 
                                   ".lst":U.

raw-transfer tt-param2  to raw-param2.

/* Leitura dos documentos */
do with frame f-docto:

    IF CAN-FIND(FIRST tt-raw-digita) THEN DO:

        bloco:
        FOR EACH tt-raw-digita:

            CREATE tt-digita.
            RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
            
            FOR FIRST docum-est NO-LOCK
                WHERE docum-est.serie-docto     = tt-digita.serie-docto
                AND   docum-est.nro-docto       = tt-digita.nro-docto
                AND   docum-est.cod-emitente    = tt-digita.cod-emitente
                AND   docum-est.nat-operacao    = tt-digita.nat-operacao:

                FIND FIRST int-docum-est NO-LOCK
                     WHERE int-docum-est.serie-docto  = docum-est.serie-docto
                       AND int-docum-est.nro-docto    = docum-est.nro-docto
                       AND int-docum-est.cod-emitente = docum-est.cod-emitente
                       AND int-docum-est.nat-operacao = docum-est.nat-operacao  NO-ERROR.

                IF NOT AVAIL int-docum-est
                OR NOT int-docum-est.nota-completa THEN
                    NEXT.

                assign l-erro = no.
    
                run pi-valida-medio.
                if  l-erro then  do:
                    run pi-lista-erros.
                    next bloco.
                end.   
    
                run pi-acompanhar in h-acomp (input docum-est.nro-docto).

                create tt-digita2.
                assign tt-digita2.r-docum-est = rowid(docum-est).

            END.

        END.

    END.
    ELSE DO:

        bloco:
        for each docum-est 
           where docum-est.ce-atual = NO NO-LOCK:
    
            IF docum-est.cod-estabel <> tt-param.c-cod-estab THEN NEXT.
            IF docum-est.dt-trans < tt-param.da-dt-trans-ini THEN NEXT.
            IF docum-est.dt-trans > tt-param.da-dt-trans-fim THEN NEXT.
            IF docum-est.serie-docto  >= tt-param.c-ser-ini AND 
               docum-est.serie-docto  <= tt-param.c-ser-fim AND
               docum-est.nro-docto    >= tt-param.c-num-ini AND
               docum-est.nro-docto    <= tt-param.c-num-fim AND
               docum-est.cod-emitente >= tt-param.i-emit-ini AND
               docum-est.cod-emitente <= tt-param.i-emit-fim AND
               docum-est.nat-operacao >= tt-param.c-nat-ini  AND
               docum-est.nat-operacao <= tt-param.c-nat-fim  AND 
               docum-est.usuario      >= tt-param.c-usuar-ini and
               docum-est.usuario      <= tt-param.c-usuar-fim THEN DO:
                assign l-erro = no.

                FIND FIRST int-docum-est NO-LOCK
                     WHERE int-docum-est.serie-docto  = docum-est.serie-docto
                       AND int-docum-est.nro-docto    = docum-est.nro-docto
                       AND int-docum-est.cod-emitente = docum-est.cod-emitente
                       AND int-docum-est.nat-operacao = docum-est.nat-operacao  NO-ERROR.

                IF NOT AVAIL int-docum-est
                OR NOT int-docum-est.nota-completa THEN
                    NEXT.
    
                run pi-valida-medio.
                if  l-erro then  do:
                    run pi-lista-erros.
                    next bloco.
                end.   
    
                run pi-acompanhar in h-acomp (input docum-est.nro-docto).
    
                create tt-digita2.
                assign tt-digita2.r-docum-est = rowid(docum-est).
            END.
        end.

    END.

end.

if can-find(first tt-digita2) then do:
    PUT "Veja o arquivo gerado em " tt-param2.arquivo FORMAT "x(100)" SKIP(2).
END.
ELSE DO:
    PUT "NÆo foram encontradas notas para a sele‡Æo informada." SKIP(2).
END.

PUT "SELECAO"               at 1 SKIP
    "Serie"                 at 8  format "x(5)"      
    ":"                     at 23
    tt-param.c-ser-ini      at 25  
    " |<  >|"               at 42
    tt-param.c-ser-fim      at 52 skip
    "Documento"             at 8 format "x(9)"
    ":"                     at 23
    tt-param.c-num-ini      at 25 format "x(16)"
    " |<  >|"               at 42 
    tt-param.c-num-fim      at 52 format "x(16)" SKIP
    "Emitente "             at 8 format "x(8)"
    ":"                     at 23
    tt-param.i-emit-ini     at 25 format ">>>>>>>>9"
    " |<  >|"               at 42 
    tt-param.i-emit-fim     at 52 format ">>>>>>>>9" SKIP
    "Natureza"              at 8 format "x(8)"
    ":"                    at 23
    tt-param.c-nat-ini     at 25 format "x(5)"
    " |<  >|"              at 42 
    tt-param.c-nat-fim     at 52 format "x(5)" SKIP
    "Data Transacao"       at 8 format "x(14)"
    ":"                    at 23
    tt-param.da-dt-trans-ini  at 25 format "99/99/9999"
    " |<  >|"              at 42 
    tt-param.da-dt-trans-fim  at 52 format "99/99/9999" SKIP
    "Usuario"              at 8 format "x(7)"
    ":"                    at 23
    tt-param.c-usuar-ini   at 25 format "x(10)"
    " |<  >|"              at 42 
    tt-param.c-usuar-fim   at 52 format "x(10)" SKIP
    "Estabelecimento"       at 8 format "x(15)"
    ":"                     at 23
    tt-param.c-cod-estab    at 25 format "x(3)".

run pi-finalizar in h-acomp.

{include/i-rpclo.i}

/* Atualiza‡Æo do Documento no Estoque */
if can-find(first tt-digita2) then do:
    for each tt-raw-digita2:
        delete tt-raw-digita2.
    end.
    for each tt-digita2:
        create tt-raw-digita2.
        raw-transfer tt-digita2 to tt-raw-digita2.raw-digita.
    end.
    run rep/re1005rp.p (input raw-param2, input table tt-raw-digita2).    
    FOR EACH tt-digita2,
        first docum-est WHERE
             ROWID(docum-est) = tt-digita2.r-docum-est NO-LOCK
        BREAK BY docum-est.nro-docto:

        if  docum-est.ce-atual then DO:
            FIND natur-oper
                WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR.

            /*             /* Deixer esta integra‡Æo antes desse envio de e-mail, para evitar problemas com a api de e-mail */                                                                                                  */
            IF AVAIL natur-oper
                 AND natur-oper.imp-nota THEN DO:

                /* Regra para integra‡Æo NFE - GATI */
                for first nota-fiscal exclusive-lock
                    where nota-fiscal.cod-estabel = docum-est.cod-estabel
                      and nota-fiscal.serie       = docum-est.serie-docto
                      and nota-fiscal.nr-nota-fis = docum-est.nro-docto.

                    IF nota-fiscal.cod-emitente <> docum-est.cod-emitente THEN NEXT.

                       IF docum-est.CE-atual = YES THEN DO:
                            FIND FIRST b-docum-est EXCLUSIVE-LOCK WHERE
                                 ROWID(b-docum-est) = tt-digita2.r-docum-est NO-ERROR.     

                            ASSIGN b-docum-est.ce-atual = NO.

                            CREATE tt-ft0910.
                            ASSIGN tt-ft0910.usuario           = ""
                                   tt-ft0910.arquivo           = "esrep1005rp-epc-" + trim(STRING(c-seg-usuario)) + ".txt"
                                   tt-ft0910.destino           = 2
                                   tt-ft0910.data-exec         = TODAY
                                   tt-ft0910.hora-exec         = TIME
                                   tt-ft0910.cod-estabel       = nota-fiscal.cod-estabel
                                   tt-ft0910.serie             = nota-fiscal.serie
                                   tt-ft0910.nr-nota-fis-ini   = nota-fiscal.nr-nota-fis
                                   tt-ft0910.nr-nota-fis-fim   = nota-fiscal.nr-nota-fis
                                   tt-ft0910.nome-ab-cli-ini   = ""
                                   tt-ft0910.nome-ab-cli-fim   = "ZZZZZZZZZZZZZ"
                                   tt-ft0910.dt-emis-nota-ini  = 01/01/1900
                                   tt-ft0910.dt-emis-nota-fim  = 12/31/2099
                                   tt-ft0910.gera-nfe-n-gerada = YES
                                   tt-ft0910.gera-nfe-gerada   = YES
                                   tt-ft0910.exporta-est-txt   = YES
                                   tt-ft0910.gera-nfe-cancel   = YES
                                   tt-ft0910.gera-nfe-inut     = YES
                                   tt-ft0910.c-motivo          = "".

                            raw-transfer tt-ft0910 to raw-param.

                            RUN ftp/ft0910rp.p (INPUT raw-param, INPUT TABLE tt-raw-ft0910).

                            ASSIGN b-docum-est.ce-atual = YES.

                            run esp/ftp/esft067rp.p (input nota-fiscal.cod-estabel,
                                                 input 'NFe_' + nota-fiscal.nr-nota-fis + '_' + nota-fiscal.cod-estabel + '_' + nota-fiscal.serie + '_' + replace(string(today,'99/99/9999'),'/','_') + '.txt').

                            ASSIGN nota-fiscal.dt-confirma = TODAY.
                        END.

                end.
            END.
        END.
    END.
end.

return "OK".

/* --------------------------  Procedure Interna ----------------------------- */

procedure pi-valida-medio:
    
    if  param-estoq.log-1 then do: /*Usa c lculo pre‡o m‚dio Batch*/
        if  param-estoq.tp-fech = 2 then do: /*Por Estabelecimento*/
            find estab-mat
                where estab-mat.cod-estabel = docum-est.cod-estabel no-lock no-error.
            if  avail estab-mat 
            and docum-est.dt-trans <= estab-mat.mensal-ate then do:
                run utp/ut-msgs.p (input "msg",
                                   input 1586,
                                   input "").
                create tt-erro.
                assign tt-erro.cd-erro  = 1586
                       tt-erro.mensagem = return-value
                       l-erro           = yes.
            end.
       end.
       else /*énico*/
          if  docum-est.dt-trans <= param-estoq.mensal-ate then do:
              run utp/ut-msgs.p (input "msg",
                                 input 1586,
                                 input "").
              create tt-erro.
              assign tt-erro.cd-erro  = 1586
                     tt-erro.mensagem = return-value
                     l-erro           = yes.
          end.
    end.

end procedure.


procedure pi-lista-erros:

    disp docum-est.nro-docto
        docum-est.serie-docto
        docum-est.cod-emitente
        docum-est.nat-operacao
        with frame f-docto.

    for each tt-erro:
        disp tt-erro.cd-erro
             tt-erro.mensagem with frame f-docto.
        down with frame f-docto.
        delete tt-erro.
    end.

    down with frame f-docto.
    put " " skip.

end.


