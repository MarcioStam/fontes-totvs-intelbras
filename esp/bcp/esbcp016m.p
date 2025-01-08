/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESBCP016M 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i esbcp016m MBC}
&ENDIF
{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */

/* Definicao global do nome da transacao ---                */
&global-define ProgramName ESBCP016
/************************************************************/

/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-ressup-wms
{esp/bcp/esbcp016.i " "}
{esp/bcp/esbcp016.i1 " "}

Define  Temp-table ttWork No-Undo like {&TempTable}.

DEFINE INPUT PARAMETER vRowid AS ROWID NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttWork.
    
Find FIRST ttWork NO-ERROR.

FIND FIRST ttwm-box-movto WHERE rowid(ttwm-box-movto) = vRowid NO-ERROR.

DEFINE VARIABLE c-ean-dun AS CHARACTER FORMAT 'X(16)'  NO-UNDO.
DEFINE VARIABLE hbosc148  AS HANDLE     NO-UNDO.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    21 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&GLOBAL-DEFINE Frame01Defs  'Ressuprimento WMS   '                              AT ROW 1 COL 1                           ~
                            '           /        ':U                            AT ROW 2 COL 1                           ~
                            'Ser:                '                              at row 4 col 1                           ~
                            'Box Ent:            '                              at row 6 col 1                           ~
                            'It:                 '                              at row 7 col 1                           ~
                            'Qtd Lida:           '                              at row 8 col 1                           ~
                             ttwork.cod-item                                    at row 2 col 1  No-label Format 'x(8)'   ~
                             ttwork.qtd-item                                    at row 2 col 10 No-label                 ~
                             ttwork.des-endereco                                at row 3 col 1  No-label Format 'x(18)'  ~
                             ttwork.num-serial                                  at row 4 col 5  No-label                 ~
                             ttwork.des-endereco-entrada                        at row 5 col 1  No-label Format 'x(18)'  ~
                             ttwork.num-box-lido                                at row 6 col 9  No-label                 ~
                             c-ean-dun                                          AT ROW 7 COL 4  NO-LABEL                 ~
                             ttwork.qtd-item-digit                              AT ROW 8 COL 10 NO-LABEL                 ~
&global-define Frame01Repeat No

&global-define Frame02Name   Frame02
&GLOBAL-DEFINE Frame02Defs  'Ressuprimento WMS   '                              AT ROW 1 COL 1                           ~
                            '           /        ':U                            AT ROW 2 COL 1                           ~
                            'Ser:                '                              at row 4 col 1                           ~
                            'Box Ent:            '                              at row 6 col 1                           ~
                            'It:                 '                              at row 7 col 1                           ~
                            'Qtd Lida:           '                              at row 8 col 1                           ~
                             ttwork.cod-item                                    at row 2 col 1  No-label Format 'x(8)'   ~
                             ttwork.qtd-item                                    at row 2 col 10 No-label                 ~
                             ttwork.des-endereco                                at row 3 col 1  No-label Format 'x(18)'  ~
                             ttwork.num-serial                                  at row 4 col 5  No-label                 ~
                             ttwork.des-endereco-entrada                        at row 5 col 1  No-label Format 'x(18)'  ~
                             ttwork.num-box-lido                                at row 6 col 9  No-label                 ~
                             c-ean-dun                                          AT ROW 7 COL 4  NO-LABEL                 ~
                             ttwork.qtd-item-digit                              AT ROW 8 COL 10 NO-LABEL                 ~
&global-define Frame02Repeat No

&global-define Frame03Name   Frame03
&GLOBAL-DEFINE Frame03Defs  'Ressuprimento WMS   '                              AT ROW 1 COL 1                           ~
                            '           /        ':U                            AT ROW 2 COL 1                           ~
                            'Ser:                '                              at row 4 col 1                           ~
                            'Box Ent:            '                              at row 6 col 1                           ~
                            'It:                 '                              at row 7 col 1                           ~
                            'Qtd Lida:           '                              at row 8 col 1                           ~
                             ttwork.cod-item                                    at row 2 col 1  No-label Format 'x(8)'   ~
                             ttwork.qtd-item                                    at row 2 col 10 No-label                 ~
                             ttwork.des-endereco                                at row 3 col 1  No-label Format 'x(18)'  ~
                             ttwork.num-serial                                  at row 4 col 5  No-label                 ~
                             ttwork.des-endereco-entrada                        at row 5 col 1  No-label Format 'x(18)'  ~
                             ttwork.num-box-lido                                at row 6 col 9  No-label                 ~
                             c-ean-dun                                          AT ROW 7 COL 4  NO-LABEL                 ~
                             ttwork.qtd-item-digit                              AT ROW 8 COL 10 NO-LABEL                 ~
&global-define Frame03Repeat No

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.num-box-lido
&global-define Update02Fields c-ean-dun
&global-define Update03Fields ttwork.qtd-item-digit
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01.
&global-define TriggerAfterFrame02  Run GravaCamposFrame02.
&global-define TriggerAfterFrame03  Run GravaCamposFrame03.

&global-define TriggersCloseProgram RUN piFinalizaObjetos.

/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/
{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame01:
    
    ASSIGN c-ean-dun = "".

    If  Not Avail ttwm-box-movto Then Do:
        Return 'OK':U.
    End.
    
    FOR FIRST wm-box-movto NO-LOCK
        WHERE wm-box-movto.cod-estabel    = ttwm-box-movto.cod-estabel
          AND wm-box-movto.cod-local      = ttwm-box-movto.cod-local
          AND wm-box-movto.id-movto       = ttwm-box-movto.id-movto
          AND wm-box-movto.ind-tipo-movto = 2:
    END.

    Assign ttWork.cod-item       = wm-box-movto.cod-item
           ttWork.qtd-item       = wm-box-movto.qti-embalagem * wm-box-movto.qtd-item
           ttWork.qtd-item-digit = 0
           ttWork.num-box-orig   = wm-box-movto.id-box
           ttWork.num-serial     = wm-box-movto.dec-2
           ttWork.num-movimento  = wm-box-movto.id-movto
           ttWork.num-box-lido   = 0
           ttWork.r-rowid        = ROWID(wm-box-movto).


    FOR FIRST wm-box NO-LOCK
        WHERE wm-box.cod-estabel = wm-box-movto.cod-estabel
          AND wm-box.cod-local   = wm-box-movto.cod-local
          AND wm-box.id-box      = wm-box-movto.id-box:
    END.

    ASSIGN ttWork.des-endereco = wm-box.cod-bloco            + '/':U + 
                                 wm-box.cod-rua              + '/':U + 
                                 wm-box.cod-nivel            + '/':U + 
                                 wm-box.cod-coluna.

    DISP ttWork.cod-item
         ttWork.qtd-item
          ttWork.des-endereco
          ttWork.qtd-item-digit
          ttWork.num-serial
          ttWork.des-endereco-entrada
          c-ean-dun
        WITH FRAME Frame01.

End Procedure.

Procedure InicializaCamposFrame02:
    
    ASSIGN c-ean-dun = "".
    
    DISP ttWork.cod-item
         ttWork.qtd-item
          ttWork.des-endereco
          ttWork.qtd-item-digit
          ttWork.num-serial
          ttWork.des-endereco-entrada
          ttWork.num-box-lido
        WITH FRAME Frame02.

End Procedure.

Procedure InicializaCamposFrame03:
    
    ASSIGN ttWork.qtd-item-digit = 0.
    
    DISP ttWork.cod-item
         ttWork.qtd-item
          ttWork.des-endereco
          ttWork.qtd-item-digit
          ttWork.num-serial
          ttWork.des-endereco-entrada
          ttWork.num-box-lido
          c-ean-dun
        WITH FRAME Frame03.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 05.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:
    ASSIGN INPUT FRAME frame01 ttWork.num-box-lido.


    If  ttWork.num-box-lido = 0 Then Do:
        {bcp/bc9105.i "505" "Box Invalido. (DC)"}
        Return Error.
    End.
    
    /* Valida Box */
    Run SetConstraintBoxes  In wgbosc030 (Input ttwm-box-movto.cod-estabel,
                                          Input ttwm-box-movto.cod-local,
                                          Input ttWork.num-box-lido,
                                          Input ttWork.num-box-lido).
    
    Run openQueryStatic In wgbosc030 (Input 'Boxes':U).
    
    RUN getBatchRecords IN wgbosc030 (Input   ?,
                                      Input  NO,
                                      Input  ?,
                                      Output vNumCont,
                                      Output Table ttwm-box).
    Find First ttwm-box No-error.
    If  Not Available ttwm-box Then do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "505" "Box Invalido. (WMS)"}
        Return Error.
    End. /* If  Return-value <> 'OK' Then do: */
    
    Run getMovtoIn In wgbosc032 (Input ttwm-box-movto.cod-estabel,
                                 Input ttwm-box-movto.cod-local,
                                 Input ttwm-box-movto.id-movto,
   
                                   Output vNumBoxMovto).
   If  Return-value <> 'OK' Or 
        vNumBoxMovto <> ttWork.num-box-lido Then Do:
         Assign vLogErro = Yes.
        {bcp/bc9105.i "506" "Box Invalido. (DC)"}
        Return Error.
    End.
    
End Procedure.

Procedure GravaCamposFrame02:

    IF c-ean-dun = "" THEN DO:
        {bcp/bc9105.i "201" "Item Invalido. (DC)"}
        Return Error.
    End.
    
    RUN validaEanDun.
    IF RETURN-VALUE <> "OK" THEN
        RETURN ERROR.


    /* Valida Box */
    Run SetConstraintBoxes  In wgbosc030 (Input ttwm-box-movto.cod-estabel,
                                          Input ttwm-box-movto.cod-local,
                                          Input ttWork.num-box-lido,
                                          Input ttWork.num-box-lido).
    
    Run openQueryStatic In wgbosc030 (Input 'Boxes':U).
    
    RUN getBatchRecords IN wgbosc030 (Input   ?,
                                      Input  NO,
                                      Input  ?,
                                      Output vNumCont,
                                      Output Table ttwm-box).
    Find First ttwm-box No-error.
    If  Not Available ttwm-box Then do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "505" "Box Invalido. (WMS)"}
        Return Error.
    End. /* If  Return-value <> 'OK' Then do: */
    
    Run getMovtoIn In wgbosc032 (Input ttwm-box-movto.cod-estabel,
                                 Input ttwm-box-movto.cod-local,
                                 Input ttwm-box-movto.id-movto,
                                 Output vNumBoxMovto).
    
    If  Return-value <> 'OK' Or 
        vNumBoxMovto <> ttWork.num-box-lido Then Do:
         Assign vLogErro = Yes.
        {bcp/bc9105.i "506" "Box Invalido. (DC)"}
        Return Error.
    End.
    
End Procedure.

Procedure GravaCamposFrame03:

    IF ttWork.qtd-item-digit <> ttWork.qtd-item THEN DO:
        {bcp/bc9105.i "301" "Quantidade incorreta. (DC)"}
        Return Error.
    End.
    
    Run GravaTransacao.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaTransacao:
    Def Var vNomeUsuario            As Character                No-undo.

    Assign vTransDetail = ' Usr: ' + String(ttWork.cod-usuario)                      +   
                          ' Col: ' + String(ttWork.cod-coletor)                      +
                          ' Eqp: ' + String(ttWork.cod-equipamento)                  +
                          ' Doc: ' + String(ttWork.num-documento)                    +
                          ' Ser: ' + String(ttWork.num-serial,'999999999999999':U)   +
                          ' Dat: ' + String(Today,'99/99/9999':U)                    +
                          ' Hor: ' + String(time,'hh:mm:ss':U).

    Assign vNomeUsuario = ttWork.cod-usuario.

    Raw-transfer ttWork To vConteudoRaw.

    Run _GenerateDCTransaction (Input vTransaction,            /* Codigo da Transacao                   */
                                Input vConteudoRaw,            /* Conteudo da temp-table ttWork         */
                                Input vTransDetail,            /* Cabecalho de detalhes da transacao    */
                                Input vNomeUsuario).           /* Usuario responsavel pela transacao    */ 
    
    If  Return-value <> 'NOK':U Then Do:
        {bcp/bc9105.i1 "901" "Ressuprimento OK"}
        ASSIGN vLogSai = YES
               vLogFinaliza = YES.
        RETURN 'OK':U.
    END.

    Assign vLogFinaliza = No
           vLogSai      = No.
    Return 'NOK':U.
End Procedure.

Procedure validaEanDun:
    DEFINE VARIABLE iTipoInformacao AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cCodItem        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cCodEmbalagem   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE deQtdInformacao AS DECIMAL    NO-UNDO.

    IF NOT VALID-HANDLE(hbosc148) THEN
        RUN scbo/bosc148.p PERSISTENT SET hbosc148.

    Run EmptyRowErrors In hbosc148.
    RUN readBarCode IN hbosc148 (INPUT ttWork.cod-estabel,
                                 INPUT ttWork.cod-local,
                                 INPUT c-ean-dun,
                                 OUTPUT iTipoInformacao,
                                 OUTPUT cCodItem, 
                                 OUTPUT cCodEmbalagem,
                                 OUTPUT deQtdInformacao,
                                 OUTPUT TABLE RowErrors).

    Run getRowErrors In hbosc148 (Output Table RowErrors) No-error.
    For Each RowErrors:
        Hide All No-pause.
        ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
        Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,10).
        Hide All No-pause.
        RETURN "NOK".
    End. 

    IF cCodItem <> ttWork.cod-item THEN DO:
        {bcp/bc9105.i "202" "Item do codigo ean/dun lido nÆo confere com o item a armazenar"}
        RETURN "NOK".
    END.

    RETURN 'OK'.
END PROCEDURE.

PROCEDURE piFinalizaObjetos:

    IF VALID-HANDLE (hbosc148) THEN 
        RUN destroy IN hbosc148.

    RETURN "OK".
END PROCEDURE.
