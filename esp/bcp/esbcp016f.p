/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESBCP016F 2.00.00.012 } /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ESBCP016F MBC}
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

DEFINE TEMP-TABLE tt-etiqueta NO-UNDO
        FIELD id-etiqueta LIKE wm-etiqueta.id-etiqueta
        FIELD qtd-item    LIKE wm-etiqueta.qtd-item
        INDEX codigo IS UNIQUE id-etiqueta.

FIND FIRST ttwm-box-movto WHERE rowid(ttwm-box-movto) = vRowid NO-ERROR.
FIND FIRST ttWork NO-ERROR.
Define Variable vQtdTotalItem           As DECIMAL                               No-undo.
Define NEW SHARED Variable vLogControla       As Logical                Init No  No-undo.
DEFINE NEW GLOBAL SHARED VARIABLE vReturn     AS CHAR                   NO-UNDO.
Define New Shared Variable vEsc               As Logical                Init No  No-undo.
DEF VAR retorno LIKE ttwm-box-movto.qtd-item.
DEF VAR lverifica AS LOGICAL NO-UNDO.
DEF VAR lcontinua AS LOGICAL NO-UNDO INITIAL ?.
{bcp/bc9015.i3} /* def variaveis padroes */ 
{utp/utapi009.i} /* login */ 
/* Propriedades globais para frames ---                     */               
&global-define FrameSize    21 By 8 
/************************************************************/
/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&GLOBAL-DEFINE Frame01Defs  'Ressuprimento WMS   '                              AT ROW 1 COL 1                           ~
                            '           /        ':U                            AT ROW 2 COL 1                           ~
                            'Box Sai:            '                              AT ROW 4 COL 1                           ~
                            'Ser:                '                              at row 5 col 1                           ~
                            'Qtd Lida:           '                              at row 6 col 1                           ~
                            'Box Ent:            '                              at row 8 col 1                           ~
                             ttwork.cod-item                                    at row 2 col 1 No-label Format 'x(8)'    ~
                             ttwork.qtd-item                                    at row 2 col 10 No-label                 ~
                             ttwork.des-endereco                                at row 3 col 1 No-label Format 'x(18)'   ~
                             ttwork.num-box-orig                                at row 4 col 9 No-label                  ~
                             ttwork.num-serial                                  at row 5 col 5 No-label                  ~
                             ttwork.qtd-item-digit                              AT ROW 6 COL 10 NO-LABEL                 ~
                             ttwork.des-endereco-entrada                        at row 7 col 1 No-label Format 'x(18)'   ~
                             ttwork.num-box-lido                                at row 8 col 9 No-label                  ~
&global-define Frame01Repeat NO
/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&GLOBAL-DEFINE Frame02Defs  'Ressuprimento WMS   '                              AT ROW 1 COL 1                           ~
                            '           /        ':U                            AT ROW 2 COL 1                           ~
                            'Box Sai:            '                              AT ROW 4 COL 1                           ~
                            'Ser:                '                              at row 5 col 1                           ~
                            'Qtd Lida:           '                              at row 6 col 1                           ~
                            'Box Ent:            '                              at row 7 col 1                           ~
                             ttwork.cod-item                                    at row 2 col 1 No-label Format 'x(8)'    ~
                             ttwork.qtd-item                                    at row 2 col 10 No-label                  ~
                             ttwork.des-endereco                                at row 3 col 1 No-label Format 'x(18)'   ~
                             ttwork.num-box-orig                                at row 4 col 9 No-label                  ~
                             ttwork.num-serial                                  at row 5 col 5 No-label                  ~
                             ttwork.qtd-item-digit                              AT ROW 6 COL 10 NO-LABEL                  ~
                             ttwork.num-box-lido                                at row 7 col 9 No-label                  ~
&global-define Frame02Repeat Yes

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&GLOBAL-DEFINE Frame03Defs  'Ressuprimento WMS   '                              AT ROW 1 COL 1                           ~
                            '           /        ':U                            AT ROW 2 COL 1                           ~
                            'Box Sai:            '                              AT ROW 4 COL 1                           ~
                            'Ser:                '                              at row 5 col 1                           ~
                            'Qtd Lida:           '                              at row 6 col 1                           ~
                            'Box Ent:            '                              at row 7 col 1                           ~
                             ttwork.cod-item                                    at row 2 col 1 No-label Format 'x(8)'    ~
                             ttwork.qtd-item                                    at row 2 col 10 No-label                  ~
                             ttwork.des-endereco                                at row 3 col 1 No-label Format 'x(18)'   ~
                             ttwork.num-box-orig                                at row 4 col 9 No-label                  ~
                             ttwork.num-serial                                  at row 5 col 5 No-label                  ~
                             ttwork.qtd-item-digit                              AT ROW 6 COL 10 NO-LABEL                  ~
                             ttwork.num-box-lido                                at row 7 col 9 No-label                  ~
&global-define Frame03Repeat NO

/************************************************************/
/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.num-box-orig
&global-define Update02Fields ttWork.num-serial
/************************************************************/
/* Definicao das trigger de interacao com a tela ---        */  
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. If vLogFinaliza = YES Then Return 'OK':U.
/* Definicao das trigger de usuario ---                     */  
&global-define UserTriggers ON 'ESC':U OF Frame Frame01 ~
                            DO:                         ~
                                Return 'ESC'.           ~
                            END.                        ~
                            ON 'ESC':U OF Frame Frame02 ~
                            DO:                         ~
                                ASSIGN ttwork.qtd-item-digit:SCREEN-VALUE IN FRAME {&Frame02Name} = "0" ~
                                       ttwork.qtd-item-digit                                      = 0   ~
                                       ttwork.des-seriais                                         = "". ~
                                Return 'ESC'.           ~
                            END. ~
/************************************************************/
/* Definicao dos objetos ativos ---                         */  
/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/
/*****************************************   Frames Fim ******************************************/
/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */ 
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */ 
                                     
/**************************************************************************************************/
/************************************* Codigo do Usuario Inicio ************************************
** Este local ‚ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/
/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame01:
    ASSIGN vQtdTotalItem = 0.
    
    IF vLogControla = YES THEN RETURN ERROR.
    
    Assign vLogErro = NO vLogControla = NO.
    If  Not Avail ttwm-box-movto Then Do:
        Return.
    End.
    
/* Pegar Informacoes Box */     
    Run SetConstraintBoxes  In wgbosc030 (Input ttwm-box-movto.cod-estabel,
                                          Input ttwm-box-movto.cod-local,
                                          Input ttwm-box-movto.id-box,
                                          Input ttwm-box-movto.id-box).
    Run openQueryStatic In wgbosc030 (Input 'Boxes':U).
    Run getBatchRecords IN wgbosc030 (Input   ?,
                                      Input  NO,
                                      Input  ?,
                                      Output vNumCont,
                                      Output Table ttwm-box).
    Find First ttwm-box No-error.
    If  Not Avail ttwm-box Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "101" "Box Invalido. (WMS)"}
        Return Error.
    End.
/* Pegar Item */    
   Run getInfoDoctoItens IN wgbosc096 ( Input ttwm-box-movto.cod-estabel,
                                        Input ttwm-box-movto.cod-local,  
                                        Input ttwm-box-movto.id-docto,
                                        Input ttwm-box-movto.num-seq-item,
                                        Output Table ttwm-docto-itens ).
   Find First ttwm-docto-itens No-lock No-error.
   If  Not Avail ttwm-docto-itens Then Do:
        {bcp/bc9105.i "102" "Movimento sem Item. (WMS)"}
        Return Error.
   End.
   
   IF v-des-endereco-entrada = "" OR AVAIL ttwm-box  THEN
      ASSIGN v-des-endereco-entrada = ttwm-box.cod-bloco            + '/':U + 
                                      ttwm-box.cod-rua              + '/':U + 
                                      ttwm-box.cod-nivel            + '/':U + 
                                      ttwm-box.cod-coluna           + '/':U +
                                   If ttwm-box.ind-posicao-box = 1 Then 'E' Else 'D'.
   ASSIGN vQtdTotalItem = ttwm-box-movto.qtd-item * ttwm-box-movto.qti-embalagem.
   
   Assign ttWork.cod-item       :Screen-value In Frame {&Frame01Name} = ttwm-docto-itens.cod-item
          ttWork.qtd-item       :Screen-value In Frame {&Frame01Name} = String(vQtdTotalItem)
          ttWork.des-endereco   :Screen-value In Frame {&Frame01Name} = v-des-endereco-entrada
          ttWork.num-box-orig   :Screen-value In Frame {&Frame01Name} = '0'
          ttWork.num-serial     :Screen-value In Frame {&Frame01Name} = '0'
          ttWork.qtd-item-digit :Screen-value In Frame {&Frame01Name} = String(ttWork.qtd-item-digit)  
          ttWork.des-endereco-entrada:SCREEN-VALUE IN FRAME {&Frame01Name} = 'End. Entrada'
          ttWork.num-box-lido   :Screen-value In Frame {&Frame01Name} = '0'.
    Assign ttWork.num-box-orig    = 0
           ttWork.qtd-item-digit  = 0.
End Procedure.
/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame02:
    IF vLogControla = YES THEN RETURN ERROR.
    
    Find First ttwm-docto-itens No-lock No-error.
    Assign ttWork.cod-item:Screen-value In Frame {&Frame02Name}       = ttwm-docto-itens.cod-item
           ttWork.qtd-item:Screen-value In Frame {&Frame02Name}       = String(vQtdTotalItem)
           ttWork.des-endereco:Screen-value In Frame {&Frame02Name}   = v-des-endereco-entrada
           ttWork.qtd-item-digit:Screen-value In Frame {&Frame02Name} = String(ttWork.qtd-item-digit)  
           ttWork.num-box-orig:Screen-value In Frame {&Frame02Name}   = String(ttWork.num-box-orig)
           ttWork.num-serial:Screen-value In Frame {&Frame02Name}     = '0'  
           /*ttWork.des-endereco-entrada:SCREEN-VALUE IN FRAME {&Frame02Name} = 'End. Entrada'*/
           ttWork.num-box-lido:Screen-value In Frame {&Frame02Name}   = '0'.                
    Assign ttWork.num-serial = 0.
    IF vEsc = YES THEN DO:
       ASSIGN ttwork.qtd-item-digit:SCREEN-VALUE IN FRAME {&Frame02Name} = "0"
              ttwork.qtd-item-digit                                      = 0
              ttwork.des-seriais                                         = "".
    END.
End Procedure.
  
/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 04.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:
    Assign vLogErro     = No
           vLogIniciado = Yes
           vLogControla = NO.
    Run getMovtoOut In wgbosc032 (Input ttwm-box-movto.cod-estabel, 
                                  Input ttwm-box-movto.cod-local,   
                                  Input ttwm-box-movto.id-movto,
                                  Output vNumBoxMovto).
    If  Return-value <> 'OK':U Or 
        vNumBoxMovto <> ttWork.num-box-orig Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "401" "Box Invalido. (WMS)"}
        Return Error.
    End.
End Procedure.
 
/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 05.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame02:
    DEFINE VARIABLE l-qt-ok AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-id-etiq-nova LIKE wm-etiqueta.id-etiqueta     NO-UNDO.

/* Validacoes Frame 05 Inicio --- */     
    Assign vLogErro = No vLogSai = No vLogFinaliza = NO vLogControla = NO vEsc = NO.
    
    If  ttWork.num-serial = 0 Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "501" "Serial Inv lido. (DC)"}
        Return Error.
    End.
    
    Run getEstabelLocalDocto In wgbosc038 (Input  ttwm-box-movto.id-docto,
                                           Output v-cod-estabel,
                                           Output v-cod-local) No-error.
    
    Run validaEtiquetaMovto In wgbosc074 (Input  ttWork.num-serial,
                                          Input  ttwm-box-movto.id-docto,
                                          Input  ttwm-box-movto.num-seq-item,
                                          Input  ttwm-box-movto.id-movto,
                                          Input  ttwm-box-movto.ind-tipo-movto,
                                          Output vCodItem,
                                          Output vCodEmbalagem).
    If  Return-value <> 'OK':U Then do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "502" "Etiqueta Inv lida. (WMS)"}
        Return Error.
    End. 
    
    If  Index(ttWork.des-seriais,String(ttWork.num-serial)) <> 0 Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "503" "Etiqueta Digitada. (WMS)"}
        Return Error.
    End.
    
    RUN  validaetiquetaressup IN wgbosc074 (INPUT ttWork.num-serial,
                                            OUTPUT retorno,
                                            OUTPUT lverifica).
    
    IF lcontinua = ? THEN
        ASSIGN lcontinua = lverifica.

    IF lcontinua = YES AND lverifica = NO THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "504" "Etiqueta Agrupadora. (WMS)"}
        Return Error.        
    END.
    
    IF retorno < vQtdTotalItem THEN DO:
        ASSIGN vLogErro = YES.
        {bcp/bc9105.i "521" "Etiqueta nÆo possui saldo suficiente para abastecimento."}
        RETURN ERROR.
    END.

    /* valida se o serial est  no box de saida FO 1705.532 */
    Run validaEtiquetaBox In wgbosc098 (Input v-cod-estabel, 
                                      Input v-cod-local,   
                                      Input ttwm-box-movto.id-box,
                                      Output TABLE ttwm-box-saldo-etiqueta).

    If  Return-value <> 'OK':U THEN DO:
        ASSIGN vLogErro = YES.
        {bcp/bc9105.i "522" "Problemas na execu‡Æo do M‚todo getEtiquetasBox para o programa scbo/bosc098. (WMS)"}
        RETURN ERROR.
    End.
    ELSE DO:
         if  NOT can-find(first ttwm-box-saldo-etiqueta
             WHERE ttwm-box-saldo-etiqueta.id-etiqueta =  ttWork.num-serial ) then do:
             ASSIGN vLogErro = YES.
             {bcp/bc9105.i "523" "Etiqueta inexistente para o Box de Sa¡da informado. (WMS)"}
             RETURN ERROR.
         END.
    END.

    Assign ttWork.cod-item       = ttwm-docto-itens.cod-item
           ttWork.qtd-item       = vQtdTotalItem
           ttWork.des-endereco   = v-des-endereco-entrada
           ttWork.qtd-item-digit = 0. /* (ttwm-box-movto.qti-embalagem * ttwm-box-movto.qtd-item) - wm-box-movto.qtd-item-picking. */

    HIDE ALL NO-PAUSE.
    VIEW FRAME Frame03.

    DO WHILE l-qt-ok = NO TRANS ON ERROR UNDO, RETURN ERROR:
        ASSIGN ttWork.qtd-item-digit = 0.
        DISP ttWork.cod-item      
             ttWork.qtd-item      
             ttWork.des-endereco  
             ttWork.qtd-item-digit
             ttwork.num-box-orig
             ttwork.num-serial
            WITH FRAME Frame03.
        UPDATE ttWork.qtd-item-digit WITH FRAME Frame03.
        IF ttWork.qtd-item-digit <> ttWork.qtd-item THEN DO:
            ASSIGN vLogErro = YES.
            {bcp/bc9105.i "601" "Quantidade incorreta."}
        END.
        ELSE
            ASSIGN l-qt-ok = YES.
    END.

    RUN esp/wmp/eswmapi003.p (INPUT ttwm-box-movto.r-rowid,
                              INPUT ttWork.num-serial,
                              OUTPUT i-id-etiq-nova,
                              OUTPUT TABLE RowErrors).

    IF CAN-FIND(FIRST RowErrors) THEN DO:
        For Each RowErrors:
            Hide All.
            Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
            Hide All.
        End.
        Assign vLogErro = Yes.
        RETURN ERROR.
    END.

    FOR FIRST wm-box-movto EXCLUSIVE-LOCK
        WHERE ROWID(wm-box-movto) = ttwm-box-movto.r-rowid:
        ASSIGN wm-box-movto.dec-2 = i-id-etiq-nova.
    END.

    FIND CURRENT wm-box-movto NO-LOCK NO-ERROR.
/*    
    EMPTY TEMP-TABLE tt-etiqueta.

    FOR FIRST wm-etiqueta NO-LOCK
        WHERE wm-etiqueta.id-etiqueta = i-id-etiq-nova:
        CREATE tt-etiqueta.
        ASSIGN tt-etiqueta.id-etiqueta = wm-etiqueta.id-etiqueta
               tt-etiqueta.qtd-item    = wm-etiqueta.qtd-item.
    END.

    /* novo funcionamento WM9061 - atualiza movimentos independentes */
    Run esp/wmp/eswm9061.p (INPUT ROWID(wm-box-movto),
                      INPUT ttWork.cod-usuario,
                      INPUT ttWork.cod-equipamento,
                      INPUT ttWork.cod-coletor,
                      INPUT TIME,
                      INPUT 0, /* id agrupador? */
                      INPUT TABLE tt-etiqueta,
        	          OUTPUT TABLE RowErrors).

    FIND FIRST RowErrors NO-LOCK NO-ERROR.
    If  Return-value <> 'OK':U OR AVAILABLE RowErrors Then do:
        For Each RowErrors:
            Hide All.
            Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
            Hide All.
        End.
        Assign vLogErro = Yes.
        RETURN ERROR.
    End.
*/
    RELEASE wm-box-movto NO-ERROR.

    ASSIGN vLogFinaliza = YES
           vLogSai      = YES.

    RUN bcp/bc9115.p (0,'Separa‡Æo realizada com sucesso!',8,20,2).

    /*

    Assign ttWork.qtd-embal-lidas       = ttWork.qtd-embal-lidas + 1
           ttWork.cod-estabel           = v-cod-estabel
           ttWork.cod-local             = v-cod-local
           ttWork.num-documento         = ttwm-box-movto.id-docto
           ttWork.num-movimento         = ttwm-box-movto.id-movto
           ttWork.num-seq-item          = ttwm-box-movto.num-seq-item
           ttWork.num-box               = ttwm-box-movto.id-box
           ttWork.cod-embalagem         = ttwm-box-movto.cod-embalagem
           ttWork.des-endereco          = ttWork.des-endereco:Screen-value In Frame {&Frame02Name} 
           ttWork.cod-item              = ttwm-docto-itens.cod-item
           ttWork.qtd-item              = vQtdTotalItem
           ttWork.qtd-embalagem         = ttwm-box-movto.qti-embalagem
           ttWork.dat-atualizacao       = ttwm-box-movto.dt-atualizacao
           ttWork.dat-transacao         = ttwm-box-movto.dt-transacao
           ttWork.qtd-item-digit        = ttWork.qtd-item-digit + retorno
           ttWork.r-rowid               = ttwm-box-movto.r-rowid.
    
    IF ttWork.des-seriais = "" 
       THEN ASSIGN ttWork.des-seriais    = string(ttwork.num-serial)
                   ttWork.des-qtdseriais = string(retorno).
       ELSE ASSIGN ttWork.des-seriais    = string(ttWork.des-seriais)    + ";":U + string(ttwork.num-serial)
                   ttWork.des-qtdseriais = string(ttWork.des-qtdseriais) + ";":U + string(retorno).
    
    If  ttWork.qtd-item-digit >= ttWork.qtd-item /*OR lverifica = NO*/ Then Do:
        HIDE ALL NO-PAUSE.
        Run esp/bcp/esbcp016m.p (Input Rowid(ttwm-box),        
                           Input ttwm-box-movto.r-rowid,
                           Input Rowid(ttwm-docto-itens)).
        HIDE ALL NO-PAUSE.
        IF RETURN-VALUE = 'OK':U THEN DO:
            ASSIGN vLogFinaliza = YES.
            RETURN RETURN-VALUE.
        END.
        
    End.
    ELSE do:
        RETURN ERROR.
    End.
*/        
END Procedure.


/*************************************  Codigo do Usuario Fim   **********************************/
