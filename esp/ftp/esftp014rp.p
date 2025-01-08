/***********************************************************************
**  Programa..: ESP/FTP/ESFTP014RP.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Relatorio Regime Especial 016/2000-2 01
**              ConversÆo do ES0606 (Claudiney)
**  VersÆo....: 001 20/01/2005
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESFTP014 2.04.00.001}

/****************************  Definitions  ****************************/
{esp/ftp/esftp014tt.i}
{include/i-rpvar.i}
/****************************  Temp-Tables  ****************************/
/****************************  Variaveis    ****************************/
/****************************  Frames       ****************************/
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
DEF VAR de-conv AS DECIMAL.
DEF VAR de-desc AS DECIMAL.
DEFINE VARIABLE de-vl-ipi-it  AS DECIMAL     NO-UNDO.
create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end. 


def var h-acomp      as handle no-undo.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
FOR FIRST estabelec NO-LOCK
    WHERE estabelec.ep-codigo = empresa.ep-codigo: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relatorio Regime Especial 016/2000-2 01"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESFTP014"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpc255.i}
    {include/i-rpout.i}

   run utp/ut-acomp.p persistent set h-acomp.  

   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.

   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
end.

/* **********************  Internal Procedures  *********************** */
PROCEDURE piImprimeRelat:
    if tt-param.excel = "yes" then 
        put "Nota Fiscal     ;Estab.;Serie;Data Emis.;Vlr Tot.Nt.Fiscal;N.Op. ;Nome Cliente                            ;Cod.Clie.;Cod.Suframa         ;Endereco                                ;Cidade                   ;UF  ;CNPJ do Destinat rio ;CNPJ da Transportadora               ;Ins.Estadual          ;Vlr.IPI;PIN;Desc.ICMS        " skip.
    else do:
        VIEW FRAME f-cabec-255.
        VIEW FRAME f-rodape-255.    
    end.
    
    for each tt-digita,        
        each nota-fiscal no-lock use-index ch-distancia where
             /*nota-fiscal.cod-estabel = tt-param.cod-estabel and*/
             nota-fiscal.cod-estabel >= tt-param.cod-estabel-ini AND
             nota-fiscal.cod-estabel <= tt-param.cod-estabel-fin AND
             nota-fiscal.dt-emis-nota >= tt-param.dt-emis-ini and
             nota-fiscal.dt-emis-nota <= tt-param.dt-emis-fim and
             nota-fiscal.nat-operacao = tt-digita.nat-operacao and
             nota-fiscal.dt-cancela = ?,
       first emitente no-lock where
             emitente.cod-emitente = nota-fiscal.cod-emitente:
        RUN pi-acompanhar IN h-acomp (INPUT "NF.: " + nota-fiscal.nr-nota-fis).

        IF tt-digita.estado-ini <> "" AND
           tt-digita.estado-fim <> "" THEN
           IF nota-fiscal.estado < tt-digita.estado-ini OR
              nota-fiscal.estado > tt-digita.estado-fim THEN NEXT.

        FIND cidade-zf
             WHERE cidade-zf.cidade = nota-fiscal.cidade
               AND cidade-zf.estado = nota-fiscal.estado
             NO-LOCK NO-ERROR.
        IF NOT AVAIL cidade-zf THEN NEXT.

        FIND natur-oper
             WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao 
             NO-LOCK NO-ERROR.

        ASSIGN de-conv = (100 - dec(SUBSTRING(natur-oper.char-2,66,5))) / 100
               de-desc = TRUNCATE(nota-fiscal.vl-mercad / de-conv , 2) - nota-fiscal.vl-mercad. 

        FIND INT-NOTA-FISCAL
             WHERE INT-NOTA-FISCAL.cod-estabel = nota-fiscal.cod-estabel
               AND int-nota-fiscal.serie       = nota-fiscal.serie
               AND int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis
            NO-LOCK NO-ERROR.
        ASSIGN de-vl-ipi-it = 0.
        FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
            ASSIGN de-vl-ipi-it = de-vl-ipi-it + it-nota-fisc.vl-ipi-it.
        END.

        FIND transporte
            WHERE transporte.nome-abrev = nota-fiscal.nome-transp NO-LOCK NO-ERROR.
        
        if tt-param.excel = "yes" then DO:
            put  nota-fiscal.nr-nota-fis ";"
                 nota-fiscal.cod-estabel ";"
                 nota-fiscal.serie ";"
                 nota-fiscal.dt-emis-nota ";"
                 nota-fiscal.vl-tot-nota ";"
                 nota-fiscal.nat-operacao ";"
                 emitente.nome-emit ";"
                 emitente.cod-emitente ";"
                 emitente.cod-suframa ";"
                 nota-fiscal.endereco ";"
                 nota-fiscal.cidade ";"
                 nota-fiscal.estado ";"
                 nota-fiscal.cgc ";"
                 transporte.cgc ";"
                 nota-fiscal.ins-estadual ";"
                 de-vl-ipi-it ";".
            IF AVAIL int-nota-fiscal THEN
                PUT  int-nota-fiscal.nr-pin ";"
                     de-desc ";".
            ELSE
                PUT  ";"
                     de-desc ";".
            FIND ped-venda
                WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli
                NO-LOCK NO-ERROR.
            IF nota-fiscal.nr-pedcli <> "" AND
               AVAIL ped-venda THEN DO:
                IF ped-venda.user-impl <> "adm" and
                   ped-venda.user-impl <> "super" THEN
                   put ped-venda.user-impl SKIP.
                ELSE DO:
                    FIND atendente
                         WHERE atendente.cd-oper = int(ped-venda.tp-pedido)
                        NO-LOCK NO-ERROR.
                    IF AVAIL ATendente THEN DO:
                        put atendente.user_magnus SKIP.
                    END.
                END.
            END.
            ELSE
                PUT nota-fiscal.user-calc SKIP.

        END.
        ELSE DO:
            FIND ped-venda
                WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli
                NO-LOCK NO-ERROR.
            disp nota-fiscal.nr-nota-fis
                 nota-fiscal.cod-estabel
                 nota-fiscal.serie
                 nota-fiscal.dt-emis-nota
                 nota-fiscal.vl-tot-nota
                 nota-fiscal.nat-operacao
                 emitente.nome-emit
                 emitente.cod-emitente
                 emitente.cod-suframa
                 nota-fiscal.endereco
                 nota-fiscal.cidade
                 nota-fiscal.estado
                 nota-fiscal.cgc
                 transporte.cgc
                 nota-fiscal.ins-estadual 
                 de-vl-ipi-it 
                int-nota-fiscal.nr-pin ";"
                de-desc 
            with width 350 STREAM-IO DOWN.
            IF AVAIL int-nota-fiscal THEN
                DISP int-nota-fiscal.nr-pin ";"
                     de-desc 
                with width 350 STREAM-IO.
            ELSE
                DISP ";"
                     de-desc 
                with width 350 STREAM-IO.

            IF nota-fiscal.nr-pedcli <> "" AND
               AVAIL ped-venda THEN DO:
                IF ped-venda.user-impl <> "adm" and
                   ped-venda.user-impl <> "super" THEN
                   disp ped-venda.user-impl 
                    with width 350 STREAM-IO DOWN.
                ELSE DO:
                    FIND atendente
                         WHERE atendente.cd-oper = int(ped-venda.tp-pedido)
                        NO-LOCK NO-ERROR.
                    IF AVAIL ATendente THEN DO:
                        disp atendente.user_magnus 
                            with width 350 STREAM-IO DOWN.
                    END.
                END.
            END.
            ELSE
                DISP nota-fiscal.user-calc 
                    with width 350 STREAM-IO DOWN.
       END.
    end.

END PROCEDURE.

