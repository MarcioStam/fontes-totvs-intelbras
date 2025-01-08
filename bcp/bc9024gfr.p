{include/i-prgvrs.i BC9024GFR 2.00.00.023 } /*** 010023 ***/
{include/i-license-manager.i bc9024 MBC}
{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9024
/************************************************************/
/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-inventario-wms
{bcp/bc9024.i }

DEF VAR tempoespera AS INTEGER.
Define Temp-table ttWork NO-UNDO Like {&TempTable}.

DEFINE TEMP-TABLE ttWm-etiqueta NO-UNDO LIKE wm-etiqueta.
DEFINE TEMP-TABLE ttSerial NO-UNDO
    FIELD de-serial AS DECIMAL.

Define Input  Parameter TABLE FOR ttWork.
DEFINE OUTPUT PARAMETER pNumSerial LIKE ttWork.num-serial NO-UNDO.
DEFINE OUTPUT PARAMETER pLogOk     AS LOGICAL     NO-UNDO.

DEFINE VARIABLE c-cod-ean AS CHARACTER FORMAT 'X(18)'  NO-UNDO.
DEFINE VARIABLE h-bosc148 AS HANDLE      NO-UNDO.

Find First ttWork NO-ERROR.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Inventario Flow Rack'   At Row 01 Col 01          ~
                             'Confirme Item:  '       AT ROW 02 COL 01          ~
                             c-cod-ean                AT ROW 03 COL 01 No-label ~
&global-define Frame01Repeat NO

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields c-cod-ean
/************************************************************/

&global-define TriggersCloseProgram RUN piFinalizaObjetos.

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01.

 {bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
 {bcp/bc9101.i} /* Procedure de atualizacao da transacao            */
 
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 2
/****************************************************************************************/
Procedure InicializaCamposFrame01:
    Assign vLogErro = No vLogSai = No vLogFinaliza = No.
        
    ASSIGN c-cod-ean = "".

End Procedure.

/*************************************************************************************************** 
** Esta procedure eÔ executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:
    ASSIGN vLogErro     = NO
           vLogsai      = NO
           vLogfinaliza = NO
           pNumSerial   = 0.

    DEFINE VARIABLE iTipoInformacao AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cCodEmbalagem   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE deQtdInformacao AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE cCodItem        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-bosc074       AS HANDLE      NO-UNDO.

    IF NOT VALID-HANDLE(h-bosc148) THEN
        RUN scbo/bosc148.p PERSISTENT SET h-bosc148.

    Run EmptyRowErrors In h-bosc148.
    RUN readBarCode IN h-bosc148 (INPUT ttWork.cod-estabel,
                                  INPUT ttWork.cod-local,
                                  INPUT c-cod-ean,
                                  OUTPUT iTipoInformacao,
                                  OUTPUT cCodItem, 
                                  OUTPUT cCodEmbalagem,
                                  OUTPUT deQtdInformacao,
                                  OUTPUT TABLE RowErrors).

    IF CAN-FIND(FIRST RowErrors) THEN DO:
        Assign vLogErro = Yes.
        For Each RowErrors:
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
        End.
        RETURN Error.
    END.

    FOR FIRST wm-box-saldo NO-LOCK
        WHERE wm-box-saldo.cod-estabel = ttWork.cod-estabel
          AND wm-box-saldo.cod-local   = ttWork.cod-local
          AND wm-box-saldo.id-box      = ttWork.num-box
          AND wm-box-saldo.cod-item    = cCodItem:
    END.

    IF AVAIL wm-box-saldo THEN DO:
        FOR FIRST wm-box-saldo-etiqueta NO-LOCK
            WHERE wm-box-saldo-etiqueta.cod-estabel = wm-box-saldo.cod-estabel
              AND wm-box-saldo-etiqueta.cod-local   = wm-box-saldo.cod-local  
              AND wm-box-saldo-etiqueta.id-saldo    = wm-box-saldo.id-saldo:
            ASSIGN pNumSerial = wm-box-saldo-etiqueta.id-etiqueta.
        END.
    END.

    IF pNumSerial = 0 THEN DO:
        /* cria etiqueta se n∆o tem saldo ou saldo sem etiqueta */
        FOR FIRST wm-item-embalagem-local NO-LOCK
            WHERE wm-item-embalagem-local.cod-estabel = ttWork.cod-estabel
              AND wm-item-embalagem-local.cod-local   = ttWork.cod-local
              AND wm-item-embalagem-local.cod-item    = cCodItem
              AND wm-item-embalagem-local.log-padrao  = YES:
        END.

        IF NOT AVAIL wm-item-embalagem-local THEN DO:
            {bcp/bc9105.i "102" "Item informado n∆o possui embalagem cadastrada."}
            Assign vLogErro = Yes.
            RETURN ERROR.
        END.

        FOR FIRST wm-item NO-LOCK
            WHERE wm-item.cod-item = cCodItem:
        END.

        CREATE ttWm-etiqueta.
        ASSIGN ttWm-etiqueta.cod-estabel         = ttWork.cod-estabel
               ttWm-etiqueta.cod-item            = cCodItem
               ttWm-etiqueta.cod-lote            = "" /* lote */
               ttWm-etiqueta.qtd-item            = wm-item-embalagem-local.qtd-item-emb
               ttWm-etiqueta.cod-embalagem       = wm-item-embalagem-local.cod-embalagem
               ttWm-etiqueta.cod-usuario         = ttWork.cod-usuario
               ttWm-etiqueta.dt-validade-lote    = ?
               ttWm-etiqueta.nr-ord-prod         = 999999999
               ttWm-etiqueta.dt-geracao          = TODAY
               ttWm-etiqueta.hr-geracao          = TIME
               ttWm-etiqueta.ind-sit-agrupador   = 3 /* proprio */
               ttWm-etiqueta.log-impressa        = YES
               ttwm-etiqueta.id-carga            = 0
               ttwm-etiqueta.qtd-peso            = ttWm-etiqueta.qtd-item * wm-item.qtd-peso
               .
    
        IF NOT VALID-HANDLE(h-bosc074) THEN DO:
            RUN scbo/bosc074.p PERSISTENT SET h-bosc074.
            RUN openQueryStatic IN h-bosc074 (INPUT "Main").
        END.
    
        RUN emptyRowErrors IN h-bosc074.
        RUN geraEtiquetas IN h-bosc074 (INPUT TABLE ttWm-etiqueta,
                                        INPUT 1,
                                        OUTPUT TABLE ttSerial).
    
        IF RETURN-VALUE <> "OK":U THEN
            RUN getRowErrors IN h-bosc074 (OUTPUT TABLE RowErrors).
    
        RUN destroy IN h-bosc074.

        IF CAN-FIND(FIRST RowErrors) THEN DO:
            Assign vLogErro = Yes.
            For Each RowErrors:
                ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
            End.
            RETURN Error.
        END.
    
        FIND FIRST ttSerial NO-LOCK NO-ERROR.
        FIND FIRST wm-etiqueta EXCLUSIVE-LOCK
            WHERE wm-etiqueta.id-etiqueta = ttSerial.de-serial NO-ERROR.
    
        IF NOT AVAIL wm-etiqueta THEN DO:
            {bcp/bc9105.i "101" "N∆o foi poss°vel gerar etiqueta WMS."}
            Assign vLogErro = Yes.
            RETURN ERROR.
        END.
    
        ASSIGN wm-etiqueta.log-reportada = YES
               wm-etiqueta.ind-leitura-etiqueta = 2.
        FIND CURRENT wm-etiqueta NO-LOCK NO-ERROR.
    
        ASSIGN pNumSerial = wm-etiqueta.id-etiqueta.
    END.

    ASSIGN vLogSai = (pNumSerial <> 0)
           pLogOk  = vLogSai.
       
End Procedure.

PROCEDURE piFinalizaObjetos:
 
    IF VALID-HANDLE(h-bosc148) THEN
        RUN destroy IN h-bosc148.

    RETURN "OK".
END PROCEDURE.

