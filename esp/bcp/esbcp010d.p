/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9030D 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9030d MBC}
&ENDIF


{include/i_dbinst.i}  /* versao das bases e bases instaladas */
{cdp/cdcfgmat.i}
&if '{&mgscm_version}' >= '2.04' &then
/* ************************************************************************** */
/*     Programa...: bc9030d.p                                                 */
/*                                                                            */
/*     Criado em..: Abril 2005                                                */
/*                                                                            */
/*     Versao.....: 2.00.00.000 Marcelo Dumke                                 */
/* ************************************************************************** */

/* ************************** Includes ***************************************** */

{bcp/bc9102.i}   /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9107.i}   /* Definicao dos campos de comunicacao com o adapter            */
{method/dbotterr.i}
{wmp/wm9700.i}

Define Input        Parameter pNumTrans    as integer No-undo.
Define Input        Parameter Table For ttIntegracao.
Define Input-Output Parameter Table For tt-erro.

    Find First ttIntegracao No-lock No-error.

    If  Not Avail ttIntegracao Then Do:
        Run utp/ut-msgs.p ( input "msg",
                            input 25346,
                            input "bc9003d").
        Create  tt-erro.
        Assign  tt-erro.cd-erro  = 25346
                tt-erro.mensagem = trim(return-value) + "(DC)":U.
        Return 'NOK'.
    End.
    
    Find First tt-erro No-lock No-error.
    If  Avail tt-erro
    Then
        Return "NOK":U.

/**************************** Definitions ****************************************/
DEFINE VARIABLE wgwm9700 AS HANDLE.
DEFINE VARIABLE wgwm9701 AS HANDLE.
DEFINE VARIABLE wgbosc070 AS HANDLE.

DEF VAR c-depos AS CHAR.

/*********************************************************************************/
EMPTY TEMP-TABLE TT-DOCTO-TRANSF-DEPOS.
EMPTY TEMP-TABLE tt-etiqueta-transf.


CREATE tt-docto-transf-depos.
ASSIGN tt-docto-transf-depos.num-docto-transf = _RetornaValInte("num-docto-transf").

IF _RetornaValDeci("cod-serial") <> 888888 THEN DO:
    RUN scbo/bosc070.p PERSISTENT SET wgbosc070 NO-ERROR.
    RUN OpenQueryStatic IN wgbosc070 (INPUT "Main":U) NO-ERROR.

    RUN gotoKey IN wgbosc070(INPUT _RetornaValinte("num-docto-transf")).

    IF RETURN-VALUE <> "OK":U THEN DO:
       ASSIGN tt-docto-transf-depos.log-alteracao = NO. 
    END.
    ELSE DO:
       ASSIGN tt-docto-transf-depos.log-alteracao = YES.
    END.

    RUN Destroy IN wgbosc070.
    /* DELETE OBJECT wgbosc070. */

    ASSIGN  tt-docto-transf-depos.cod-estab            = _RetornaValChar("cod-estabel")   .
            tt-docto-transf-depos.cod-depos-saida      = _RetornaValChar("cod-depos-orig") .
            tt-docto-transf-depos.cod-depos-entr       = _RetornaValChar("cod-depos-dest")  .
            tt-docto-transf-depos.cod-usuar            = _RetornaValChar("cod-usuario")    .
            tt-docto-transf-depos.log-confirma-picking = YES                                .
            tt-docto-transf-depos.num-docto-transf     = _retornavalinte("num-docto-transf")
        .   tt-docto-transf-depos.idi-sit-docto        = 1.
            tt-docto-transf-depos.log-transfere-auto   = YES.

    CREATE tt-etiqueta-transf.
    ASSIGN tt-etiqueta-transf.id-etiqueta       = _RetornaValDeci("cod-serial") .
           tt-etiqueta-transf.qtd-retirada      = _RetornaValDeci("qtd-item")  .
           tt-etiqueta-transf.cod-localiz-saida = _RetornaValChar("cod-local-orig").
           tt-etiqueta-transf.cod-localiz-entr  = _RetornaValChar("cod-local-dest").



    FIND FIRST wm-etiqueta
         WHERE wm-etiqueta.id-etiqueta = tt-etiqueta-transf.id-etiqueta NO-LOCK NO-ERROR.

    FIND FIRST wm-box-saldo-etiqueta
         WHERE wm-box-saldo-etiqueta.id-etiqueta = wm-etiqueta.id-etiqueta
        NO-LOCK NO-ERROR.
    FIND FIRST wm-box
         WHERE wm-box.cod-estabel = wm-box-saldo-etiqueta.cod-estabel AND
               wm-box.cod-local   = wm-box-saldo-etiqueta.cod-local   AND
               wm-box.id-box      = wm-box-saldo-etiqueta.id-box      NO-LOCK NO-ERROR.
    FOR  EACH wm-box-saldo EXCLUSIVE-LOCK
         WHERE wm-box-saldo.cod-estabel      = wm-box.cod-estabel    AND
               wm-box-saldo.cod-local        = wm-box.cod-local      AND
               wm-box-saldo.id-box           = wm-box.id-box         AND
               wm-box-saldo.cod-item         = wm-etiqueta.cod-item  AND
               wm-box-saldo.cod-refer        = wm-etiqueta.cod-refer AND
               wm-box-saldo.cod-lote         = wm-etiqueta.cod-lote  AND
               wm-box-saldo.ind-status-saldo = 5 /* Rejeitado */      
        :
        ASSIGN wm-box-saldo.ind-status-saldo = 3.
    END.

    RUN wmp/wm9700.p PERSISTENT SET wgwm9700 NO-ERROR.

    RUN CriaDoctoTransf IN wgwm9700 (INPUT-OUTPUT  TABLE tt-docto-transf-depos,
                                     INPUT-OUTPUT  TABLE tt-item-docto-transf-depos,
                                     INPUT  TABLE tt-etiqueta-transf,
                                     OUTPUT TABLE RowErrors).


    IF RETURN-VALUE <> "OK":U THEN DO:
       FOR EACH RowErrors:
           IF RowErrors.ErrorNumber = 27607 //- Dep¢sito wex ‚ de WMS.
           THEN DO:
               DELETE RowErrors.
               NEXT.
           END.
           CREATE tt-erro.
           ASSIGN tt-erro.cd-erro  = RowErrors.ErrorNumber
                  tt-erro.mensagem = RowErrors.ErrorDescription.
       END.
       IF CAN-FIND(FIRST tt-erro) THEN
            RETURN "NOK":U.
    END.
    delete OBJECT wgwm9700 NO-ERROR.

    /* API para criação do historico da etiqueta */
    RUN bcp/bcapi9000.p (INPUT pNumTrans,
                         INPUT string(tt-etiqueta-transf.id-etiqueta),
                         INPUT '').

END.
ELSE DO:
    ASSIGN c-depos = trim(_RetornaValChar("cod-depos-orig")).
    FIND FIRST deposito WHERE deposito.cod-depos = c-depos NO-LOCK NO-ERROR.
    
    IF AVAIL deposito AND &IF "{&bf_mat_versao_ems}" >= "2.05" &THEN 
             deposito.log-gera-wms = YES 
        &ELSE 
                deposito.log-2 = YES 
        &ENDIF 
        THEN DO:

        RUN wmp/wm9701.p PERSISTENT SET wgwm9701 NO-ERROR.

        RUN piLiberaDocto IN  wgwm9701  ( INPUT _retornavalinte("num-docto-transf"),
                                          OUTPUT TABLE rowerrors
                                           ).
        IF RETURN-VALUE <> "OK":U THEN DO:
           FOR EACH RowErrors:
               IF RowErrors.ErrorNumber = 27607 //- Dep¢sito wex ‚ de WMS.
               THEN DO:
                   DELETE RowErrors.
                   NEXT.
               END.
               CREATE tt-erro.
               ASSIGN tt-erro.cd-erro  = RowErrors.ErrorNumber
                      tt-erro.mensagem = RowErrors.ErrorDescription.
           END.
           IF CAN-FIND(FIRST tt-erro) THEN
                RETURN "NOK":U.
        END.
        delete OBJECT wgwm9701 NO-ERROR.

    END.
END.
    
RETURN "OK":U.


&else 

    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif

