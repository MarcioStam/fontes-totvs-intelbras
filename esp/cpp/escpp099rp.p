/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP099RP 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: ESCPP099RP
**  Objetivo: <comment>
**  Autor...: Francisco Almeida Fran»a    
**  Data....: 30.11.2013 16:11
*******************************************************************************/
{include/i-rpvar.i}
{include/i-freeac.i}

{esp/cpp/escpp099.i}

def temp-table tt-raw-digita
    field raw-digita       as raw.

DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.

FIND LAST param-global NO-LOCK NO-ERROR.

create tt-param.
raw-transfer raw-param to tt-param.

assign c-programa     = "ESCPP099"
       c-sistema      = "ESP"
       c-titulo-relat = "Relat¢rio de Cliente Rastreabilidade"
       c-versao       = "2.00.00"
       c-revisao      = "000"
       c-empresa      = "Intelbras".

{include/i-rpout.i}
{include/i-rpcab.i}



FORM cliente-rast.cod-emitente
     emitente.nome-emit            FORMAT "X(41)"
     cliente-rast.data-ini         FORMAT "99/99/9999"
     cliente-rast.data-fim         FORMAT "99/99/9999"
     cliente-rast.usuario          FORMAT "X(10)"
     usuar_mestre.nom_usuario      FORMAT "X(30)"
     cliente-rast.data-inclusao    FORMAT "99/99/99 HH:MM"
    WITH FRAME f-dados STREAM-IO DOWN WIDTH 132.     


/* para nÊo visualizar cabe¯alho/rodapý em saðda RTF */
IF tt-param.destino <> 4 THEN DO:
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
END.

/* executando de forma persistente o utilit˜rio de acompanhamento */
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Listando_Nœmeros_de_S²rie *}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).



FOR EACH cliente-rast NO-LOCK
    WHERE cliente-rast.cod-emitente >= tt-param.cod-emitente-ini
    AND   cliente-rast.cod-emitente <= tt-param.cod-emitente-fim:

    FOR FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = cliente-rast.cod-emitente:

        FOR FIRST usuar_mestre NO-LOCK
            WHERE usuar_mestre.cod_usuario = cliente-rast.usuario:

            DISP cliente-rast.cod-emitente
                 emitente.nome-emit
                 cliente-rast.data-ini
                 cliente-rast.data-fim
                 cliente-rast.usuario
                 usuar_mestre.nom_usuario
                 cliente-rast.data-inclusao
                WITH FRAME f-dados WIDTH 132.
            DOWN WITH FRAME f-dados.

        END.

    END.

END.


PAGE.


disp skip(1)
     "SELE€ÇO" NO-LABEL
     SKIP(1)
     tt-param.cod-emitente-ini LABEL "Item"                      AT 04    "|<    >|" AT 22  tt-param.cod-emitente-fim NO-LABEL                     AT 32
     with frame f-selec width 132 stream-io side-labels.


disp skip(3)
     "IMPRESSÇO"
     SKIP(1)
     "Destino:" at 4
     " - " tt-param.arquivo FORMAT "X(60)" 
     skip
     "Usuÿrio:" at 4
     tt-param.usuario 
     with frame f-impressao width 132 stream-io no-labels.




/*fechamento do output do relat«rio*/
{include/i-rpclo.i}
RUN pi-finalizar IN h-acomp.
RETURN "OK":U.


