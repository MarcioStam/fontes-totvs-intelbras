/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i eswmp024rp 3.00.00.000 }

define temp-table tt-param NO-UNDO
    field destino       as integer
    field arquivo       as char
    field usuario       as char format "x(12)"
    field data-exec     as DATE
    field cod-estabel   as char.

def temp-table tt-raw-digita NO-UNDO
    field raw-digita as raw.

define temp-table ttPedidosPendentes NO-UNDO
    field cod-estab     LIKE ped-venda.cod-estabel
    field nome-abrev    LIKE ped-venda.nome-abrev
    field dt-emissao    LIKE ped-venda.dt-emissao
    field dt-entrega    LIKE ped-venda.dt-entrega
    field nr-pedcli     LIKE ped-venda.nr-pedcli
    field it-codigo     LIKE ped-item.it-codigo.


{utp/utapi019.i}

//{cdp/cd0666.i}

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

def var c-impressao     as char     format "x(09)"      no-undo.
def var c-destino       as char     format "x(10)"      no-undo.
def var c-erro          as char                         no-undo.
def var c-erro1         as char                         no-undo.
def var h-acomp         as handle                       no-undo.
def var cLinha          as char                         no-undo.
def var cEstab          as char                         no-undo.
def var cDepos          as char                         no-undo.
def var cItem           as char                         no-undo.
def var i-aux           as int                          no-undo.

DEFINE VARIABLE cAcomp                      AS CHARACTER   NO-UNDO.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FORM 
    skip(2)
    c-impressao        no-label colon 45 
    skip(1)
    tt-param.usuario            colon 60
    with stream-io down width 132 side-labels frame f-det.

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

{include/i-rpcab.i}
{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

RUN pi-envia-email.

{utp/ut-liter.i IMPRESS«O * r}
assign c-impressao = trim(return-value).
{utp/ut-liter.i Usu†rio * r}
assign tt-param.usuario:label in frame f-det = trim(return-value).

disp c-impressao
     tt-param.usuario
     with frame f-det.

run pi-finalizar in h-acomp.

{include/i-rpclo.i}

RETURN "OK".


/******************************************************************************************/
/******************************************************************************************/
/******************************************************************************************/
PROCEDURE pi-envia-email:
    DEFINE VARIABLE numDiasAlerta AS INTEGER     NO-UNDO.

    FIND FIRST in-wm-param NO-LOCK NO-ERROR.
    IF AVAIL in-wm-param THEN DO:
        ASSIGN numDiasAlerta = in-wm-param.num-dias-alerta.
    END.

    FOR  EACH ped-venda NO-LOCK
        WHERE ped-venda.cod-estabel = tt-param.cod-estabel
          AND ped-venda.cod-sit-ped <= 2 //Aberto e parcialmente
          AND ped-venda.nr-pedcli   = "2552703"
          AND ped-venda.nome-abrev  = "GrupoSevipar".

        IF  (TODAY + numDiasAlerta) >= ped-venda.dt-entrega
        THEN DO:
            FOR EACH ped-item OF ped-venda NO-LOCK:
    
                FOR FIRST item-uni-estab NO-LOCK
                    WHERE item-uni-estab.cod-estabel = ped-venda.cod-estabel
                      AND item-uni-estab.it-codigo   = ped-item.it-codigo:
                END.
                //wm0113
                IF CAN-FIND(FIRST wms-item-estab-local
                            WHERE wms-item-estab-local.cod-estab    = item-uni-estab.cod-estabel
                              AND wms-item-estab-local.cod-local    = item-uni-estab.deposito-pad
                              AND wms-item-estab-local.cod-item     = item-uni-estab.it-codigo)
                THEN DO:
                    FOR FIRST wms-item-estab-local
                        WHERE wms-item-estab-local.cod-estab    = item-uni-estab.cod-estabel
                          AND wms-item-estab-local.cod-local    = item-uni-estab.deposito-pad
                          AND wms-item-estab-local.cod-item     = item-uni-estab.it-codigo:
    
                        IF NOT wms-item-estab-local.log-exclusivo-picking
                        THEN DO:
                            CREATE  ttPedidosPendentes.
                            ASSIGN  ttPedidosPendentes.cod-estab    = ped-venda.cod-estabel
                                    ttPedidosPendentes.nome-abrev   = ped-venda.nome-abrev
                                    ttPedidosPendentes.dt-emissao   = ped-venda.dt-emissao
                                    ttPedidosPendentes.dt-entrega   = ped-venda.dt-entrega
                                    ttPedidosPendentes.nr-pedcli    = ped-venda.nr-pedcli
                                    ttPedidosPendentes.it-codigo    = ped-item.it-codigo.
                        END.
    
                    END.
                END.
                ELSE DO:
                    //WM0108 - wm-item 
                    FOR FIRST wm-item 
                        //WHERE wm-item.cod-item = 
                        .
                    END.
                END.
            END.
        END.
    END.
    IF CAN-FIND(FIRST ttPedidosPendentes)
    THEN DO:
        //Verifica os usu†rios que devem receber o email..
        DEFINE VARIABLE cEmails AS CHARACTER   NO-UNDO.
    
        
        ASSIGN cEmails = "".
        FOR EACH usuario-scm NO-LOCK:
            IF ENTRY(1,usuario-scm.char-1,";") = "YES"
            THEN DO:
                FOR FIRST usuar_mestre NO-LOCK
                    WHERE usuar_mestre.cod_usuario = usuario-scm.usuario:
                    IF usuar_mestre.cod_e_mail_local <> ""
                    THEN DO:
                        ASSIGN cEmails = cEmails + "," + usuar_mestre.cod_e_mail_local.
                    END.
                END.
            END.
        END.
        ASSIGN cEmails = SUBSTRING(cEmails,2).
        FIND FIRST param_email NO-LOCK NO-ERROR.
        for each tt-mensagem:
            delete tt-mensagem.
        end.
        for each tt-envio2:
            delete tt-envio2.
        end.
        for each tt-erros:
            delete tt-erros.
        end.
    
        CREATE tt-envio2.
        ASSIGN tt-envio2.versao-integracao = 1
               tt-envio2.remetente         = "ederson.dias@scmconcept.com.br"
               tt-envio2.assunto           = "Pedidos Pendentes Entrega"
               tt-envio2.destino           = cEmails
               tt-envio2.importancia       = 1
               tt-envio2.log-enviada       = NO
               tt-envio2.exchange          = YES //param_email.log_servid_exchange 
               tt-envio2.log-lida          = NO
               tt-envio2.servidor          = param_email.cod_servid_e_mail
               tt-envio2.porta             = param_email.num_porta 
               tt-envio2.formato = "HTML"
               tt-envio2.acomp             = NO
                NO-ERROR.
    

        FOR EACH  ttPedidosPendentes.
            CREATE tt-mensagem.
            ASSIGN tt-mensagem.mensagem = "Avaliar Pedido:" 
                    + CHR(10)
                    + " Est:" + STRING(ttPedidosPendentes.cod-estab)
                    + CHR(10)
                    + " Cliente:" + STRING(ttPedidosPendentes.nome-abrev)
                    + CHR(10)
                    + " DtEmiss∆o:" + STRING(ttPedidosPendentes.dt-emissao, "99/99/9999")
                    + CHR(10)
                    + " DtEntrega:" + STRING(ttPedidosPendentes.dt-entrega, "99/99/9999")
                    + CHR(10)
                    + " NrPedCli:" + STRING(ttPedidosPendentes.nr-pedcli)
                    + CHR(10)
                    + " Item:" + STRING(ttPedidosPendentes.it-codigo).

            MESSAGE "Dias:" numDiasAlerta
                SKIP
                "cEmails:" cEmails
                SKIP
                "-------------"
                SKIP
                "1." param_email.log_servid_exchange 
                SKIP
                "2." param_email.cod_servid_e_mail
                SKIP
                "3." param_email.num_porta 
                SKIP
                "tt-mensagem.mensagem:" tt-mensagem.mensagem

            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

        END.
    
        run utp/utapi019.p persistent set h-utapi019.
        run pi-execute2 in h-utapi019 (input table tt-envio2,
                                       input table tt-mensagem,
                                       output table tt-erros).

        FOR EACH tt-erros:
            MESSAGE "Erros:" tt-erros.desc-erro
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        END.

        DELETE OBJECT h-utapi019.
    END.

END PROCEDURE.
