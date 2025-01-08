{include/i-prgvrs.i ESBCP017H 2.00.00.039 } /*** 010039 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ESBCP017Hh MBC}
&ENDIF
/* vers∆o das bases e bases instaladas */ {include/i_dbinst.i}  
/********************************************************************************************
**   Programa..: bc9018h.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - setembro/2002 - karla Klemke - Criaá∆o do programa          **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Picking WMS                      **
**                                                                                         **
********************************************************************************************/
/* Definicao global do nome da transacao ---                */
&global-define ProgramName ESBCP017
/************************************************************/
/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-picking-wms
{esp/bcp/esbcp017.i " "}
{esp/bcp/esbcp017.i1 }
{esp/bcp/esbcp017h.i} /*fk - definicao das procedures utilizadas*/

/*fk - opcao do tipo de leitura. Esse valor vem da bc9018h.p*/
DEFINE NEW GLOBAL SHARED VARIABLE iIndTipoLeitura   AS INTEGER NO-UNDO.
/*mk - Tipo de Visualizaá∆o da quantidade */
DEFINE NEW GLOBAL SHARED VARIABLE iIndTipoVisualiza AS INTEGER NO-UNDO.

/*mk Variaveis utilizadas pela BOSC145 para convers∆o de qtd x emb~\un*/
DEFINE VARIABLE p-qtd-caixas     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE p-qtd-unidades   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE l-movto-pendente AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-cod-emb-movto  AS CHARACTER   NO-UNDO.

DEFINE VARIABLE l-esbc9018g AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-acao-usuario AS LOGICAL     NO-UNDO.

DEFINE TEMP-TABLE ttwm-etiqueta NO-UNDO LIKE wm-etiqueta.

/* login */ {utp/utapi009.i} 
DEFINE INPUT PARAMETER vRowid AS ROWID NO-UNDO.
Define New Shared Variable wgbosc145 As Widget-handle No-undo. 
DEFINE VARIABLE hbosc154        AS HANDLE     NO-UNDO.
DEFINE VARIABLE  v-cod-embalagem LIKE ttWm-box-movto-idx-picking.cod-embalagem NO-UNDO.

&if '{&mgscm_version}' >= '2.07' &then     /* FLAVIO-INI FO 1389.034*/
    DEFINE VARIABLE  c-endereco-entrega AS CHARACTER FORMAT "xxxxxxxxxxxxxxxxx" NO-UNDO.
    DEFINE VARIABLE  i-cod-doca         AS INTEGER         NO-UNDO.
    DEFINE VARIABLE  de-id-box          LIKE wm-box.id-box NO-UNDO.
&endif

FIND FIRST ttWm-box-movto-idx-picking WHERE ROWID(ttWm-box-movto-idx-picking) = vRowid NO-ERROR.
FIND FIRST ttWork no-error.

DEFINE TEMP-TABLE tt-serial NO-UNDO
       FIELD id-etiqueta          LIKE wm-etiqueta.id-etiqueta
       FIELD qtd-item-retirado    LIKE wm-etiqueta.qtd-item-retirado
       FIELD id-movto             LIKE wm-movto.id-movto
       INDEX idx-serial  AS PRIMARY /*UNIQUE*/ id-etiqueta.

/* Propriedades globais para frames ---                     */               
&global-define FrameSize    20 By 8 
/************************************************************/
/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
/************************************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Picking WMS'                                     At Row 01 Col 01                               ~
                             '.................. '                             At Row 02 Col 01                               ~
                             '.................. '                             At Row 03 Col 01                               ~
                             'Doca:....Box:..... '                             AT ROW 04 COL 01                               ~
                             'Lida:...........   '                             At Row 05 Col 01                               ~
                             'Pend:...........   '                             AT ROW 06 COL 01                               ~
                             'Ser:.............. '                             At Row 07 Col 01                               ~
                             'Qtd:.....          '                             At Row 08 Col 01                               ~
                             ttWork.cod-item                                   At Row 02 Col 01 No-label Format 'x(18)'       ~
                             ttWork.des-endereco                               At Row 03 Col 01 No-label Format 'x(18)'       ~
                             ttWork.num-doca                                   At Row 04 Col 06 No-label Format '>>>'         ~
                             ttWork.num-box-lido                               At Row 04 Col 13 No-label FORMAT '>>>>>9'      ~
                             ttWork.cod-livre-3                                At Row 05 Col 06 NO-LABEL FORMAT "x(11)"       ~
                             ttWork.cod-livre-4                                At Row 06 Col 06 NO-LABEL FORMAT "x(11)"       ~
                             ttWork.num-serial                                 At Row 07 Col 05 No-label                      ~
                             ttWork.qtd-item-digit                             At Row 08 Col 05 NO-LABEL                      ~
&global-define Frame01Repeat NO
                             
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Picking WMS'                                     At Row 01 Col 01                               ~
                             '.................. '                             At Row 02 Col 01                               ~
                             '.................. '                             At Row 03 Col 01                               ~
                             'Doca:....Box:..... '                             AT ROW 04 COL 01                               ~
                             'Lida:...........   '                             At Row 05 Col 01                               ~
                             'Pend:...........   '                             AT ROW 06 COL 01                               ~
                             'Ser:.............. '                             At Row 07 Col 01                               ~
                             'Qtd:.....          '                             At Row 08 Col 01                               ~
                             ttWork.cod-item                                   At Row 02 Col 01 No-label Format 'x(18)'       ~
                             ttWork.des-endereco                               At Row 03 Col 01 No-label Format 'x(18)'       ~
                             ttWork.num-doca                                   At Row 04 Col 06 No-label Format '>>>'         ~
                             ttWork.num-box-lido                               At Row 04 Col 13 No-label FORMAT '>>>>>9'      ~
                             ttWork.cod-livre-3                                At Row 05 Col 06 NO-LABEL FORMAT "x(11)"       ~
                             ttWork.cod-livre-4                                At Row 06 Col 06 NO-LABEL FORMAT "x(11)"       ~
                             ttWork.num-serial                                 At Row 07 Col 05 No-label                      ~
&global-define Frame02Repeat YES

/* FK INICIO - projeto parati */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Picking WMS'                                     At Row 01 Col 01                         ~
                             'Tipo leitura?      '                             At Row 02 Col 01                         ~
                             '2 - Por quantidade '                             At Row 03 Col 01                         ~
                             '3 - Por EAN/DUN    '                             At Row 04 Col 01                         ~
                             '4 - Por Emb/Un     '                             AT ROW 05 COL 01                         ~
                             'Opcao              '                             At Row 08 Col 01                         ~
                             iIndTipoLeitura                                   At Row 08 Col 14 No-label Format '9'     ~
                             
&global-define Frame03Repeat NO 
/* FK FIM - projeto parati */

&if '{&mgscm_version}' >= '2.07' &then     /* FLAVIO-INI FO 1389.034*/
    &global-define Frame04Name   Frame04
    &global-define Frame04Defs   'Picking WMS'                                     At Row 01 Col 01                          ~
                                 'Endereco Transito: '                             At Row 03 Col 01                          ~
                                 c-endereco-entrega                                At Row 04 Col 02 No-label                 ~
                                 'Id Transito:       '                             At Row 07 Col 01                          ~
                                 de-id-box                                         At Row 08 Col 02 No-label 
    &global-define Frame04Repeat NO
    
    &global-define Frame05Name   Frame05
    &global-define Frame05Defs   'Picking WMS'                                     At Row 01 Col 01                          ~
                                 'Endereco Doca:     '                             At Row 03 Col 01                          ~
                                 c-endereco-entrega                                At Row 04 Col 02 No-label                 ~
                                 'Cod Doca:'                                       At Row 05 Col 01                          ~
                                 i-cod-doca                                        At Row 05 Col 12 No-label FORMAT '>>>>>9' ~
                                 'Doca:'                                           At Row 07 Col 01                          ~
                                 de-id-box                                         At Row 08 Col 02 No-label
    &global-define Frame05Repeat NO
&endif

/************************************************************/
/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.num-box-lido
&global-define Update02Fields ttWork.num-serial  WHEN ttWork.num-serial = 0 AND l-acao-usuario
/************************************************************/
/* Definicao das trigger de interacao com a tela ---        */  
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. IF l-esbc9018g THEN LEAVE _Frame02.
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. If return-value = "ESC":U then return return-value. IF l-esbc9018g THEN LEAVE _Frame02. ~

/* Definicao das trigger de usuario ---                     */  
&global-define UserTriggers on 'esc' of current-window anywhere do: ~
                                assign vLogFinaliza = yes           ~
                                       vLogSai      = NO.          ~
                                return 'esc':u.                     ~
                            end.
/************************************************************/
/* Definicao dos objetos ativos ---                         */  
/************************************************************/
&global-define ActiveObject1 wgbosc032
&global-define ActiveObject1 wgbosc074
/*****************************************   Frames Fim ******************************************/
/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eÔ necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/
/* Gerador da interface caracter do coleta de dados */ {bcp/bc9100.i} 
/* Procedure de atualizacao da transacao            */ {bcp/bc9101.i} 
/**************************************************************************************************/
/************************************* Codigo do Usuario Inicio ************************************
** Este local Ç destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/
/*************************************************************************************************** 
** Esta procedure eÔ executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame01:

    ASSIGN l-esbc9018g = NO
           l-acao-usuario = NO.

    IF NOT VALID-HANDLE(wgbosc032) THEN DO:
        Run scbo/bosc032.p Persistent Set wgbosc032       No-error.
        Run openQueryStatic In wgbosc032 (Input "Main":U) No-error.
    END.

    If  vLogEmProcesso = No Then Do:
        Run inicializaTarefaMovtoOK In wgbosc096
                                     (Input ttWm-box-movto-idx-picking.id-docto,
                                      Input 07,     
                                      Input ttWork.cod-usuario,              
                                      Input ttWork.cod-equipamento,          
                                      Input ttWork.cod-coletor,              
                                      Input ttWm-box-movto-idx-picking.id-movto,         
                                      Input ttWm-box-movto-idx-picking.num-seq-item).

        If  Return-value <> 'OK' Then Do:
            Assign vLogErro = Yes.
            {bcp/bc9105.i "302" "Movimento Expirado ou Jˇ Alocado (WMS)"}
            Return Error.
        End.
        Assign vLogEmProcesso = Yes.
    End.


    If Not Avail ttWm-box-movto-idx-picking Then Do:
        ASSIGN vLogErro = Yes.
        RETURN ERROR.
    End.

    ASSIGN p-qtd-caixas   = 0
           p-qtd-unidades = 0.

    Assign ttWork.num-tempo-inicio = Time.
    /* Pegar Informacoes do endereco baseado no endereco que foi digitado */     
    Run SetConstraintBoxes  In wgbosc030 (Input ttWm-box-movto-idx-picking.cod-estabel,
                                          Input ttWm-box-movto-idx-picking.cod-local,
                                          Input ttWm-box-movto-idx-picking.id-box,
                                          Input ttWm-box-movto-idx-picking.id-box).
    Run openQueryStatic In wgbosc030 (Input 'Boxes':U).
    Run getBatchRecords IN wgbosc030 (Input ?,
                                      Input NO,
                                      Input ?,
                                      Output vNumCont,
                                      Output Table ttwm-box).
    Find First ttwm-box No-error.
    If  Not Avail ttwm-box Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "002" "Box Inv†lido(WMS)"}
        Return Error.
    End.

    /* Pegar Item */    
    Run getInfoDoctoItens IN wgbosc096 (Input ttWm-box-movto-idx-picking.cod-estabel, 
                                        Input ttWm-box-movto-idx-picking.cod-local,   
                                        Input ttWm-box-movto-idx-picking.id-docto,
                                        Input ttWm-box-movto-idx-picking.num-seq-item,
                                        Output Table ttwm-docto-itens ).

    Find First ttwm-docto-itens No-lock No-error.
    If  Not Avail ttwm-docto-itens Then Do:
        Assign vLogErro = Yes.
        Return Error.
    End.

    RUN emptyRowErrors  IN wgbosc032.
    RUN openQueryStatic IN wgbosc032 (INPUT "Main":U).
    RUN goToKey2        IN wgbosc032 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                      INPUT ttWm-box-movto-idx-picking.cod-local,
                                      INPUT ttWm-box-movto-idx-picking.id-movto,
                                      INPUT ttWm-box-movto-idx-picking.ind-tipo-movto).
    RUN getCharField IN wgbosc032    (INPUT "cod-embalagem":U,
                                      OUTPUT c-cod-emb-movto).

    IF c-cod-emb-movto = "" THEN
        ASSIGN c-cod-emb-movto = ttWm-box-movto-idx-picking.cod-embalagem.
    
    /* mk - Verifica o Tipo de Visualizaá∆o da quantidade - Inicio */
    RUN pi-getIndTipoVisualiza IN THIS-PROCEDURE.
    
    ASSIGN ttWork.qtd-item  = (ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking.
    
    IF iIndTipoVisualiza = 2 THEN DO: /* Quantidade */
        ASSIGN ttWork.cod-livre-4:SCREEN-VALUE IN FRAME {&Frame01Name} = String((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking,">>>>>9.9999"). 
               ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame01Name} = STRING(ttWm-box-movto-idx-picking.qtd-item-picking,">>>>>9.9999").
    END.
    IF iIndTipoVisualiza = 4 THEN DO: /* Emb/Un */
        /* Inicializa BO */
        IF NOT VALID-HANDLE(wgbosc145) THEN DO:
            Run scbo/bosc145.p Persistent Set wgbosc145       No-error.
            Run openQueryStatic In wgbosc145 (Input "Main":U) No-error.
        END.
    
        RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                              INPUT ttWm-box-movto-idx-picking.cod-local,
                                              INPUT ttWm-box-movto-idx-picking.cod-item,
                                              INPUT c-cod-emb-movto,
                                              INPUT ttWork.qtd-item, 
                                              OUTPUT p-qtd-caixas,
                                              OUTPUT p-qtd-unidades).
    
        ASSIGN ttWork.cod-livre-4:SCREEN-VALUE IN FRAME {&Frame01Name} = STRING(p-qtd-caixas,">>>>9") + " |" + STRING(p-qtd-unidades).
    
        RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                              INPUT ttWm-box-movto-idx-picking.cod-local,
                                              INPUT ttWm-box-movto-idx-picking.cod-item,
                                              INPUT c-cod-emb-movto,
                                              INPUT ttWm-box-movto-idx-picking.qtd-item-picking,
                                              OUTPUT p-qtd-caixas,
                                              OUTPUT p-qtd-unidades). 
    
        ASSIGN ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame01Name} = STRING(p-qtd-caixas,">>>>9") + " |" + STRING(p-qtd-unidades).

        IF VALID-HANDLE(wgbosc145) THEN RUN destroy IN wgbosc145.
    END.
    /* mk - Verifica o Tipo de Visualizaá∆o da quantidade - Fim */
    
    Assign ttWork.cod-item       :Screen-value In Frame {&Frame01Name} = ttWm-box-movto-idx-picking.cod-item
           ttWork.num-doca       :Screen-value In Frame {&Frame01Name} = string(ttwm-docto-itens.cod-doca)
           ttWork.des-endereco   :Screen-value In Frame {&Frame01Name} = ttwm-box.cod-bloco            + '/':U + 
                                                                         ttwm-box.cod-rua              + '/':U + 
                                                                         ttwm-box.cod-nivel            + '/':U + 
                                                                         ttwm-box.cod-coluna           + '/':U +
                                                                         IF ttwm-box.ind-posicao-box = 1 Then 'E' Else 'D'
           ttWork.num-serial     :Screen-value In Frame {&Frame01Name} = '0':U  
           ttWork.num-box-lido   :Screen-value In Frame {&Frame01Name} = '0':U.
           ttWork.qtd-item-digit :Screen-value In Frame {&Frame01Name} = '0':U .
    
     Assign ttWork.num-box-lido    = 0
            ttWork.num-serial      = 0
            ttWork.qtd-item-digit  = 0.

End Procedure.
/*************************************************************************************************** 
** Esta procedure eÔ executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame02:

    /* inicializa a leitura dos seriais */     
    If  Not Avail ttWm-box-movto-idx-picking  Then Do:
        ASSIGN vLogErro = Yes.
        RETURN ERROR.
    End.

    ASSIGN p-qtd-caixas   = 0
           p-qtd-unidades = 0.

    RUN emptyRowErrors  IN wgbosc032.
    RUN openQueryStatic IN wgbosc032 (INPUT "Main":U).
    RUN goToKey2        IN wgbosc032 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                      INPUT ttWm-box-movto-idx-picking.cod-local,
                                      INPUT ttWm-box-movto-idx-picking.id-movto,
                                      INPUT ttWm-box-movto-idx-picking.ind-tipo-movto).
    RUN getCharField IN wgbosc032    (INPUT "cod-embalagem":U,
                                      OUTPUT c-cod-emb-movto).

    IF c-cod-emb-movto = "" THEN
        ASSIGN c-cod-emb-movto = ttWm-box-movto-idx-picking.cod-embalagem.

    ASSIGN ttWork.qtd-item = (ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking.

    IF NOT VALID-HANDLE(wgbosc145) THEN DO:
       Run scbo/bosc145.p Persistent Set wgbosc145       No-error.
       Run openQueryStatic In wgbosc145 (Input "Main":U) No-error.
    END.

    /* mk - Verifica o Tipo de Visualizaá∆o da quantidade - Inicio */
    IF iIndTipoVisualiza = 2 THEN DO: /* Quantidade */
        ASSIGN ttWork.cod-livre-4:SCREEN-VALUE IN FRAME {&Frame02Name} = String((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking,">>>>>9.9999") 
               ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame02Name} = STRING(ttWm-box-movto-idx-picking.qtd-item-picking,">>>>>9.9999").
    END.
    IF iIndTipoVisualiza = 4 THEN DO: /* Emb/Un */
        
        RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                              INPUT ttWm-box-movto-idx-picking.cod-local,
                                              INPUT ttWm-box-movto-idx-picking.cod-item,
                                              INPUT c-cod-emb-movto,
                                              INPUT ttWork.qtd-item,
                                              OUTPUT p-qtd-caixas,
                                              OUTPUT p-qtd-unidades).
        
        ASSIGN ttWork.cod-livre-4:SCREEN-VALUE IN FRAME {&Frame02Name} = STRING(p-qtd-caixas,">>>>9") + " |" + STRING(p-qtd-unidades).
    
        RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                              INPUT ttWm-box-movto-idx-picking.cod-local,
                                              INPUT ttWm-box-movto-idx-picking.cod-item,
                                              INPUT c-cod-emb-movto,
                                              INPUT ttWm-box-movto-idx-picking.qtd-item-picking,
                                              OUTPUT p-qtd-caixas,
                                              OUTPUT p-qtd-unidades). 
    
        ASSIGN ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame02Name} = STRING(p-qtd-caixas,">>>>9") + " |" + STRING(p-qtd-unidades).
    END.
    
    Assign ttWork.cod-item       :Screen-value In Frame {&Frame02Name} = ttwm-docto-itens.cod-item
           ttWork.num-doca       :Screen-value In Frame {&Frame02Name} = string(ttwm-docto-itens.cod-doca)
           ttWork.des-endereco   :Screen-value In Frame {&Frame02Name} = ttwm-box.cod-bloco            + '/':U + 
                                                                         ttwm-box.cod-rua              + '/':U + 
                                                                         Ttwm-box.cod-nivel            + '/':U + 
                                                                         ttwm-box.cod-coluna           + '/':U +
                                                                         If ttwm-box.ind-posicao-box = 1 Then 'E' Else 'D'
           ttWork.num-box-lido   :Screen-value In Frame {&Frame02Name} = String(ttWork.num-box-lido)
           ttWork.num-serial     :Screen-value In Frame {&Frame02Name} = string(ttWork.num-serial).
           
    Assign ttWork.qtd-embal-lidas = 0.
    
    /* iniciliza temp-table tt-picking-wms-table baseada na tabela bc-trans */      
    IF NOT VALID-HANDLE(wgbc9018f) THEN DO:
       Run esp/bcp/esbcp017f.p Persistent Set wgbc9018f No-error.
    END.
    
    RUN pi-inicializa-tt-picking-wms-table IN wgbc9018f (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                                         Input ttWm-box-movto-idx-picking.cod-local,
                                                         INPUT ttWm-box-movto-idx-picking.id-movto,
                                                         INPUT ttWm-box-movto-idx-picking.ind-tipo-movto,
                                                         OUTPUT TABLE tt-picking-wms-table).
    If  Return-value <> 'OK':U OR NOT VALID-HANDLE(wgbc9018f) Then Do:
        Assign vLogErro = Yes.
         {bcp/bc9105.i "104" "Problemas na inicializaá∆o (DC)"}
    End.

    /* Verifica se h† alguma separaá∆o com a transaá∆o pendente de atulizaá∆o */
    /* para o movimento que foi selecionado.                                  */
    ASSIGN l-movto-pendente = NO.
    FOR EACH tt-picking-wms-table 
       WHERE tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto
         AND tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto
         AND tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item
         AND tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto:

        ASSIGN ttWork.qtd-embal-lidas = ttWork.qtd-embal-lidas + tt-picking-wms-table.qtd-item-digit
               l-movto-pendente = YES.
    END.
    
    IF l-movto-pendente = YES THEN DO:
        /* mk - Convers∆o emb/un - Inicio */ 
        IF iIndTipoVisualiza = 4 THEN DO:
            RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                                  INPUT ttWm-box-movto-idx-picking.cod-local,
                                                  INPUT ttWm-box-movto-idx-picking.cod-item,
                                                  INPUT ttWm-box-movto-idx-picking.cod-embal,
                                                  INPUT ttWork.qtd-embal-lidas,
                                                  OUTPUT p-qtd-caixas,
                                                  OUTPUT p-qtd-unidades). 
       
            ASSIGN ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame02Name} = STRING(p-qtd-caixas,">>>>9") + " |" + STRING(p-qtd-unidades).
        END.
        ELSE 
            ASSIGN ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame02Name} = STRING(ttWork.qtd-embal-lidas,">>>>>9.9999"). 
    END.

    IF NOT l-acao-usuario THEN DO:
        EMPTY TEMP-TABLE RowErrors.
        RUN esp/wmp/eswmapi005.p (INPUT ttWm-box-movto-idx-picking.cod-estabel, 
                                  INPUT ttWm-box-movto-idx-picking.cod-local,   
                                  INPUT ttWork.num-box-lido,
                                  INPUT ttWm-box-movto-idx-picking.cod-item,
                                  OUTPUT ttWork.num-serial,
                                  OUTPUT TABLE RowErrors).

        IF CAN-FIND(FIRST RowErrors) THEN DO:
            For Each RowErrors:
                Hide All No-pause.
                ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
                Hide All No-pause.
            end. /* Each RowErrors */
            Assign vLogErro = Yes.
            Return ERROR.
        END. /*
        IF ttWork.num-serial = 0 THEN
            ASSIGN l-acao-usuario = YES. */
    END.

    IF VALID-HANDLE(wgbosc145) THEN RUN destroy IN wgbosc145.

    /* mk - Convers∆o emb/un - Fim */
    Pause 0 No-message.
End Procedure.

/*************************************************************************************************** 
** Esta procedure eÔ executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:

    Assign vLogIniciado = Yes.
    Assign vLogErro = No vLogSai = No vLogFinaliza = No.
    If  ttWork.num-box-lido = 0 Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "401" "Box Inv†lido(WMS)"}
        Return Error.
    End.
    Run emptyRowErrors In wgbosc032.
    Run validaBoxOut In wgbosc032 (Input ttWm-box-movto-idx-picking.cod-estabel, 
                                   Input ttWm-box-movto-idx-picking.cod-local,   
                                   Input ttWm-box-movto-idx-picking.id-movto,
                                   INPUT ttWork.num-box-lido).
    If  Return-value <> 'OK':U Then Do:
        Run getRowErrors In wgbosc032(Output Table RowErrors).
        For Each RowErrors:
            Create tt-erro.
            Assign tt-erro.i-sequen = 1011
                   tt-erro.cd-erro  = ErrorNumber
                   tt-erro.mensagem = ErrorDescription + "(WMS)":U.
        End. 
        Assign vLogErro = Yes.
        {bcp/bc9105.i "402" "Box Diferente (WMS)"}
        Return Error.
    end.

    Hide All.
    Assign vLogFinaliza = No
           vLogSai      = No.

    Return 'OK':U.

End Procedure.

/*************************************************************************************************** 
** Esta procedure eÔ executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame02:

    ASSIGN l-esbc9018g       = YES. /* obriga voltar pro endereco */

    DEFINE VARIABLE vqtd-item   AS DECIMAL INIT 0 NO-UNDO.
    
    If return-value = "ESC" Then do:
        assign vLogFinaliza = yes.
        return "ESC".
    End.

    Assign vLogErro     = No 
           vLogSai      = No 
           vLogFinaliza = No.

    If  Not Avail ttWm-box-movto-idx-picking Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "500" "Movimento Vencido (WMS)"}
        Return 'NOK':U.
    End.

    IF NOT VALID-HANDLE(wgbosc074) THEN DO:
        Run scbo/bosc074.p Persistent Set wgbosc074       No-error.
        Run openQueryStatic In wgbosc074 (Input "Main":U) No-error.
    END.

    If  ttWork.num-serial = 0 Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "501" "Serial Inv†lido (DC)"}
        Return 'NOK':U.
    End.

    &if '{&mgscm_version}' >= '2.07' &then     /* FLAVIO-INI FO 1389.034*/
        IF ttWork.num-serial = 999999 THEN DO:
            RUN pi-enderecos-entrega IN THIS-PROCEDURE.
            RETURN "OK":U.
        END.
    &endif
    
    IF ttWork.num-serial = 888888 THEN DO:
        Run gravaTransacao.       

        If  Return-value <> 'OK':U Then Do:
            Assign vLogFinaliza = NO 
                   vLogSai      = NO
                   vlogerro     = NO
                   vlogcancela  = NO.
            Return RETURN-VALUE.
        End.

        Assign vLogFinaliza = YES 
               vLogSai      = YES
               vlogerro     = NO
               vlogcancela  = NO.
        Return 'OK':U.
    END.

    IF NOT VALID-HANDLE(wgbosc038) THEN DO:
        Run scbo/bosc038.p Persistent Set wgbosc038       No-error.
        Run openQueryStatic In wgbosc038 (Input "Main":U) No-error.
    END.

    /* Busca o estabelecimento e o local do documento */
    Run getEstabelLocalDocto In wgbosc038 (Input ttWm-box-movto-idx-picking.id-docto,
                                           Output v-cod-estabel,
                                           Output v-cod-local) No-error .

    IF VALID-HANDLE(wgbosc038) THEN RUN destroy IN wgbosc038.

    /* Busca o saldo do movimento */
    Assign vNumSaldo = ((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking).

    Run EmptyRowErrors In wgbosc074 No-error.
    FOR EACH tt-serial:
        DELETE tt-serial.
    END.
   
    FOR EACH tt-picking-wms-table 
       WHERE tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto
         AND tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto
         AND tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item
         AND tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto:

        CREATE tt-serial.
        ASSIGN tt-serial.id-etiqueta       = tt-picking-wms-table.num-serial
               tt-serial.qtd-item-retirado = tt-picking-wms-table.qtd-item-digit
               tt-serial.id-movto          = tt-picking-wms-table.id-movto.
    END.
        
    Run validaEtiquetaMovtoPicking In wgbosc074 (Input v-cod-estabel,
                                                 Input v-cod-local,
                                                 Input ttWork.num-serial,
                                                 Input ttWm-box-movto-idx-picking.id-docto,
                                                 Input ttWm-box-movto-idx-picking.num-seq-item,
                                                 Input ttWm-box-movto-idx-picking.id-movto,
                                                 Input ttWm-box-movto-idx-picking.ind-tipo-movto,
                                                 Input vNumSaldo,
                                                 INPUT TABLE tt-serial,
                                                 OUTPUT vCodItem,
                                                 Output v-cod-embalagem,
                                                 Output vNumItensSerial).

    Run getRowErrors In wgbosc074 (Output Table RowErrors) No-error.

    For Each RowErrors:
        Hide All No-pause.
        ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
        Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
        Hide All No-pause.
    end. 
    If  Can-find( First rowErrors) Then Do:
        Assign vLogErro = Yes.
        Return ERROR.
    End.
    ASSIGN ttWm-box-movto-idx-picking.cod-embalagem = v-cod-embalagem.
    
    /* Atribuindo o valor direto para o n£mero de itens, pois Ç sem serial. Toma como referància o movimento gerado pelo WMS  */
    /* Se for um item da linha leve nao pode permitir alteracao de quantidade itens*/     
    IF NOT VALID-HANDLE(wgbosc145) THEN DO:
        Run scbo/bosc145.p Persistent Set wgbosc145       No-error.
        Run openQueryStatic In wgbosc145 (Input "Main":U) No-error.
    END.

    /* Busca a etiqueta na BOSC074 para verificar a quantidade de itens retirados.       */
    /* Se a quantidade for diferente de zero, Ç obrigado que seja informada a quantidade */
    /* de retirada. Esta Ç a mesma regra da etiqueta pai.                                */
    RUN getInfoEtiqueta IN wgbosc074 (INPUT ttWork.num-serial,
                                      OUTPUT TABLE ttwm-etiqueta).

    Run getRowErrors In wgbosc074 (Output Table RowErrors) No-error.

        For Each RowErrors:
            Hide All No-pause.
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
            Hide All No-pause.
        end. 
        If  Can-find( First rowErrors) Then Do:
            Assign vLogErro = Yes.
            Return ERROR.
        End.
    
    FIND FIRST ttwm-etiqueta NO-ERROR.
    
    /* Verifica se abre embalagem. O mÇtodo da procedure verifica somente se  */
    /* Ç aberta a embalagem pai.                                              */
    RUN getAbreEmbalagem IN wgbosc145 (INPUT ttwm-docto-itens.cod-estabel,
                                       INPUT ttwm-docto-itens.cod-local,
                                       INPUT ttwm-docto-itens.cod-item,
                                       INPUT ttWm-box-movto-idx-picking.cod-embalagem,
                                       OUTPUT v-log-abre-embalagem).

    /* Valida se a quantidade a ser retirada Ç maior ou igual a quantidade de saldo da etiqueta.*/
    /* Caso seja, retira a quantidade total da etiqueta. Se a quantidade da etiqueta for maior  */
    /* que o saldo a ser retirado, solicitar† que o usu†rio informe a quantidade ou DUN/EAN ou  */
    /* quantidade de embalagens a serem retiradas. Este processo Ç feito no programa BC9018G.   */
    IF v-log-abre-embalagem = YES 
    AND ((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking >= vNumItensSerial
        AND ttwm-etiqueta.qtd-item-retirado = 0) THEN DO:

       ASSIGN v-log-abre-embalagem = NO.
       IF ttWm-box-movto-idx-picking.log-picking = NO THEN
           ASSIGN ttWm-box-movto-idx-picking.log-picking = YES. 
    END.

    /* fk - Busca se o tipo de leitura eh por eah ou por dun */
/*    IF v-log-abre-embalagem = YES THEN */
        RUN pi-getIndTipoLeitura IN THIS-PROCEDURE.

    /* Se abre embalagem e o serial for diferente de zero */
    If  v-log-abre-embalagem and ttWork.num-serial <> 0 Then Do:
        FIND FIRST tt-picking-wms-table 
             WHERE tt-picking-wms-table.num-serial     = ttWork.num-serial
               AND tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto
               AND tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto
               AND tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item
               AND tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto No-error.

        If Available tt-picking-wms-table Then Do:
            /*Nao deixa o usuario ler este serial se a quantidade disponivel dele estiver esgotada*/             
            If  vNumItensSerial <= tt-picking-wms-table.qtd-item-digit Then Do:
                Assign vLogErro = Yes.
                {bcp/bc9105.i "503" "Quantidade Serial Insuficiente ou Completada (WMS)"}
                ASSIGN l-acao-usuario = YES
                       l-esbc9018g    = NO
                       ttWork.num-serial = 0. /* para dar 88888 */
                Return 'NOK':U.
            End.               
            Else Do:
                Assign vNumItensSerial = vNumItensSerial - tt-picking-wms-table.qtd-item-digit.

            End. 
        End. 
    End. 
    Else if ttWork.num-serial <> 0 then Do:

        FIND FIRST tt-picking-wms-table NO-LOCK 
             WHERE tt-picking-wms-table.num-serial     = ttWork.num-serial
               AND tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto
               AND tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto
               AND tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item
               AND tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto NO-ERROR.

        If Avail tt-picking-wms-table and ttWork.num-serial <> 0 Then Do:
            Assign vLogErro = Yes.
            {bcp/bc9105.i "504" "Serial j† Lido (WMS)"}
            Return 'NOK':U.
        End. 
    End. 
    
    ASSIGN l-acao-usuario = NO.

    /* Pega o item e a quantidade do movimento */
    Assign {&TempTable}.num-serial = ttWork.num-serial.

    Assign ttWork.qtd-item = (ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking.

    /* Permite alterar a quantidade quando o serial abre embalgem ou via item n∆o sendo Box de Picking */
    /* O programa BC9018G ser† chamado quando o saldo a ser retirado para o movimento for menor que a  */
    /* quantidade de itens dispon°veis na etiqueta. */
/*    If  (v-log-abre-embalagem and ttWork.num-serial <> 0) or (ttWork.num-serial = 0 and ttWm-box-movto-idx-picking.log-picking = no) Then Do: */
    If  ttWork.num-serial <> 0 Then Do: 

        Hide All No-pause.
        Run esp/bcp/esbcp017g.p (Input Rowid(ttwm-box),        
                                 Input Rowid(ttWm-box-movto-idx-picking),
                                 Input Rowid(bttWm-box-movto-idx-picking),
                                 Input Rowid(ttwm-docto-itens),
                                 INPUT-OUTPUT TABLE tt-picking-wms-table).
        Hide All No-pause.

        If  Return-value <> 'OK':U Then Do:
            Assign vLogFinaliza = No
                   vLogSai      = No
                   vlogerro     = YES.
            RETURN RETURN-VALUE.
        End.

        /* Alterado por Amarildo Gambeta - FO's 1.555.226 e 1.563.831 */
        If  Not Avail ttWm-box-movto-idx-picking Then Do:
            Assign vLogFinaliza = NO 
                   vLogSai      = yes
                   vlogerro     = NO
                   vlogcancela = NO.
        End.
        ELSE DO:
            Assign vLogFinaliza = NO 
                   vLogSai      = NO
                   vlogerro     = NO
                   vlogcancela = NO.
        END.

        Return RETURN-VALUE. 
    End.
    
    ASSIGN vqtd-item = 0.
    FOR EACH tt-picking-wms-table NO-LOCK 
       WHERE tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto 
         AND tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto
         AND tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item    
         AND tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto:

        ASSIGN vqtd-item = vqtd-item + tt-picking-wms-table.qtd-item-digit.
    END.

    ASSIGN vqtd-item = vqtd-item + vNumItensSerial.
    
    IF vqtd-item > ttWork.qtd-item THEN DO:

        Assign vLogErro = Yes.
        {bcp/bc9105.i "603" "Quantidade Inv†lida (WMS)"}
        Return ERROR.
    END.

    FIND FIRST tt-picking-wms-table  
         WHERE tt-picking-wms-table.num-serial     = ttWork.num-serial
           AND tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto
           AND tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto
           AND tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item
           AND tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto No-error.

    IF NOT VALID-HANDLE(wgbc9018f) THEN DO:
        Run esp/bcp/esbc017f.p Persistent Set wgbc9018f No-error.
    END.

    /* Caso encontre algum movimento n∆o atualizado, incrementa a quantidade deste, */
    /* fazendo a separaá∆o com a quantidade dispon°vel da etiqueta.                 */
    If Available tt-picking-wms-table Then Do:

        RUN pi-atualiza-qtd-digitada IN wgbc9018f (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                                   Input ttWm-box-movto-idx-picking.cod-local,
                                                   INPUT ttWm-box-movto-idx-picking.id-movto,
                                                   INPUT ttWm-box-movto-idx-picking.ind-tipo-movto,
                                                   INPUT ttwm-box-movto-idx-picking.id-docto,
                                                   INPUT ttWork.num-serial,
                                                   INPUT ttWm-box-movto-idx-picking.num-seq-item,
                                                   INPUT vNumItensSerial,
                                                   INPUT tt-picking-wms-table.qtd-item-digit,
                                                   input-OUTPUT TABLE tt-erro).

        find first tt-erro no-error.
        if  avail tt-erro THEN DO: 
            FOR EACH tt-erro:
                ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(WMS)":U.
                {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
                Assign vLogSai = Yes.
            END.
            If vLogErro = Yes Then Return Error.
        END.
        ASSIGN tt-picking-wms-table.qtd-item-digit = tt-picking-wms-table.qtd-item-digit + vNumItensSerial.

    End. 

    /* Se n∆o encontrar nenhum movimento pendente, faz a separaá∆o retirando o saldo     */
    /* dispon°vel da etiqueta. Esta ser† a mesma quantidade que incrementa a quantidade  */
    /* de itens j† retirados da wm-box-movto. A atualizaá∆o da wm-box-movto somente ser† */
    /* feita quando passar pela gravaTransacao.                                          */
    Else if ttWork.num-serial <> 0 then Do:         

        RUN pi-cria-tt-picking-ems-table IN wgbc9018f (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                                       INPUT ttWm-box-movto-idx-picking.cod-local,
                                                       INPUT ttWm-box-movto-idx-picking.id-movto,
                                                       INPUT ttWm-box-movto-idx-picking.ind-tipo-movto,
                                                       INPUT ttwm-box-movto-idx-picking.id-docto,
                                                       INPUT ttWork.num-serial,
                                                       INPUT ttWm-box-movto-idx-picking.num-seq-item,
                                                       INPUT vNumItensSerial,
                                                       INPUT vNumItensSerial ,
                                                       INPUT ttWm-box-movto-idx-picking.cod-item,
                                                       INPUT ttWork.num-box-lido,
                                                       INPUT ttWm-box-movto-idx-picking.cod-embalagem,
                                                       INPUT ttWm-box-movto-idx-picking.qti-embalagem,
                                                       INPUT ttWm-box-movto-idx-picking.dt-atualizacao,
                                                       INPUT ttWm-box-movto-idx-picking.dt-transacao,
                                                       INPUT ttWork.num-tempo-inicio,
                                                       INPUT ttWork.cod-coletor,
                                                       INPUT ttWork.cod-equipamento,
                                                       input "", /* Lote em branco, pois se n∆o encontrar Ç porque Ç uma transaá∆o com serial que ir† pegar o lote pela etiqueta na API de efetivaá∆o */
                                                       INPUT-OUTPUT TABLE tt-picking-wms-table,
                                                       OUTPUT TABLE tt-erro).

        find first tt-erro no-error.
        if  avail tt-erro THEN DO: 
            FOR EACH tt-erro:
                ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(WMS)":U.
                {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
                Assign vLogSai = Yes.
            END.
            If vLogErro = Yes Then Return Error.
        END.  
    End. 

    /* Verifica a tabela que foi criada no programa bc9018f pelo mÇtodo pi-atualiza-qtd-digitada */
    /* ou pi-cria-tt-picking-ems-table. A qtd-embal-lidas Ç o que o WMS efetivou na separaá∆o do */
    /* movimento, seja esta conclu°da ou n∆o.                                                    */
    ASSIGN ttWork.qtd-embal-lidas = 0.
    FOR EACH tt-picking-wms-table 
       WHERE tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto 
         AND tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto
         AND tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item    
         AND tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto:

        ASSIGN ttWork.qtd-embal-lidas = ttWork.qtd-embal-lidas + tt-picking-wms-table.qtd-item-digit.
    END.

    Assign ttWork.cod-estabel     = v-cod-estabel
           ttWork.cod-local       = v-cod-local
           ttWork.id-docto        = ttWm-box-movto-idx-picking.id-docto
           ttWork.id-movto        = ttWm-box-movto-idx-picking.id-movto
           ttWork.num-seq-item    = ttWm-box-movto-idx-picking.num-seq-item
           ttWork.num-box         = ttWork.num-box-lido
           ttWork.num-doca        = ttwm-docto-itens.cod-doca
           ttWork.cod-embalagem   = ttWm-box-movto-idx-picking.cod-embalagem
           ttWork.des-endereco    = ttWork.des-endereco:Screen-value In Frame {&Frame02Name} 
           ttWork.cod-item        = ttwm-docto-itens.cod-item
           ttWork.qtd-item        = ttWm-box-movto-idx-picking.qtd-item
           ttWork.qtd-embalagem   = ttWm-box-movto-idx-picking.qti-embalagem
           ttWork.dat-atualizacao = ttWm-box-movto-idx-picking.dt-atualizacao
           ttWork.dat-transacao   = ttWm-box-movto-idx-picking.dt-transacao.

    Pause 0 No-message before-hide.

    /* Esta verificaá∆o pode ser parcial, n∆o necessariamente precisando ser igual a quantidade do movimento         */
    /* Se a quantidade do movimento Ç maior ou igual a quantidade separada para a etiqueta, Ç gravada a transaá∆o    */
    /* e feito o processo de separaá∆o parcial ou total no WMS, acrescentando a qtd-item-picking da wm-box-movto     */
    /* e baixando o saldo da etiqueta. Esta l¢gica somente ser† acessada se a quantidade da etiqueta for menor       */ 
    /* ou igual a quantidade do movimento, caso contr†rio, est† rotina Ç feita no programa BC9018G, onde Ç informada */
    /* a quantidade de itens ou EAN/DUN ou embalagens que est† sendo retirada da etiqueta.                           */
    If  ((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking) >= ttWork.qtd-embal-lidas Then Do:
        Pause 0 No-message.

        Run gravaTransacao.       

        If  Return-value <> 'OK':U Then Do:
            Assign vLogFinaliza = NO 
                   vLogSai      = NO
                   vlogerro     = NO
                   vlogcancela  = NO.
            Return RETURN-VALUE.
        End.

        IF NOT AVAIL ttWm-box-movto-idx-picking THEN DO:
            Assign vLogFinaliza = YES 
                   vLogSai      = YES
                   vlogerro     = NO
                   vlogcancela  = NO.
            Return 'OK':U.
        END.
    End.

    Assign vLogFinaliza = No
           vLogSai      = No
           vlogerro     = NO.

    Return 'NOK':U.

End Procedure.
/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure eã executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaTransacao:
    DEFINE VARIABLE vNomeUsuario AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE v-detalhe    AS CHARACTER  NO-UNDO.
    
    Pause 0 No-message.

    Assign vNomeUsuario = ttWork.cod-usuario.
    Assign ttWork.cod-estabel           = v-cod-estabel
           ttWork.cod-local             = v-cod-local
           ttWork.id-docto              = ttWm-box-movto-idx-picking.id-docto
           ttWork.id-movto              = ttWm-box-movto-idx-picking.id-movto
           ttWork.num-seq-item          = ttWm-box-movto-idx-picking.num-seq-item
           ttWork.num-box               = ttWork.num-box-lido /* ttWm-box-movto-idx-picking.id-box. FO 999.812 */
           ttWork.num-doca              = ttwm-docto-itens.cod-doca
           ttWork.cod-embalagem         = ttWm-box-movto-idx-picking.cod-embalagem
           ttWork.des-endereco          = ttWork.des-endereco:Screen-value In Frame {&Frame02Name} 
           ttWork.cod-item              = ttwm-docto-itens.cod-item
           ttWork.qtd-item              = ttWm-box-movto-idx-picking.qtd-item
           ttWork.qtd-embalagem         = ttWm-box-movto-idx-picking.qti-embalagem
           ttWork.dat-atualizacao       = ttWm-box-movto-idx-picking.dt-atualizacao
           ttWork.dat-transacao         = ttWm-box-movto-idx-picking.dt-transacao.
    FOR EACH tt-erro:
        DELETE tt-erro.
    END.
    FOR EACH tt-trans:
        DELETE tt-trans.
    END.
    ASSIGN v-detalhe = 'Est:':U  + trim(ttWm-box-movto-idx-picking.cod-estabel) + ';':U +
                       'Loc:':U  + trim(ttWm-box-movto-idx-picking.cod-local) + ';':U +
                       'IMo:':U  + trim(string(ttWm-box-movto-idx-picking.id-movto,'>>>>>>>>>9':U)) + ';':U + 
                       'ITM:':U  + trim(string(ttWm-box-movto-idx-picking.ind-tipo-movto,'>9':U)).
    /* criaáao da bc-trans */     
    CREATE tt-trans.
    ASSIGN tt-trans.cod-versao-integracao = 1
           tt-trans.i-sequen = 1
           tt-trans.cd-trans = 'WMSai001':U
           tt-trans.detalhe = v-detalhe.
           tt-trans.usuario = v_cod_usuar_corren.
           tt-trans.etiqueta = NO.

     IF NOT VALID-HANDLE(wgbc9018f) THEN DO:
        Run esp/bcp/esbc017f.p Persistent Set wgbc9018f No-error.
     END.

     RUN finaliza-picking IN wgbc9018f (INPUT TABLE tt-trans, OUTPUT TABLE tt-erro).

     find first tt-erro no-error.
     if  avail tt-erro THEN DO: 
        FOR EACH tt-erro:
            ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
            {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
             Assign vLogFinaliza = Yes
                    vLogSai      = Yes.
         END.
         If vLogErro = Yes Then Return Error.
     END.
     ELSE DO:
         RUN picking-pre-api-wms in wgbc9018f (INPUT-OUTPUT TABLE tt-trans, INPUT-OUTPUT TABLE tt-erro).

         find first tt-erro no-error.
         if  avail tt-erro THEN DO: 
            FOR EACH tt-erro:
                ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
               {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
            END.
         END.
         ELSE DO:
             /* fk parati: nao finaliza a tela enquanto a quantidade lida 
                for menor que a quantidade do movimento */
             DO:
                 /* Incrementa a quantidade de picking */
                 ASSIGN ttWm-box-movto-idx-picking.qtd-item-picking = ttWm-box-movto-idx-picking.qtd-item-picking + ttWork.qtd-embal-lidas.

                 /* Se a quantidade de picking for igual ao movimento, elimina a ttwm-box-movto-idx-picking */
                 /* Isto tambÇm indica que o picking foi conclu°do.                                         */
                 IF (ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking = 0  THEN DO:

                     &if '{&mgscm_version}' >= '2.07' &then     /* FLAVIO-INI FO 1389.034*/
                        RUN pi-enderecos-entrega IN THIS-PROCEDURE.
                     &endif
                 
                     {bcp/bc9105.i "901" "Picking executado com Sucesso (DC)"}
                     Hide All No-pause.
                    DELETE ttWm-box-movto-idx-picking.
                 END.
             END.
             IF NOT VALID-HANDLE(hbosc154) THEN DO:
                 Run scbo/bosc154.p Persistent Set hbosc154       No-error.
                 Run openQueryStatic In hbosc154 (Input "Main":U) No-error.
             END.
             RUN acertacapacidadeendereco IN hbosc154 (INPUT ttWork.cod-estabel,
                                                       INPUT ttWork.cod-local,
                                                       INPUT ttWork.id-docto,
                                                       INPUT ttWork.num-seq-item).
             IF VALID-HANDLE (hbosc154) THEN DELETE OBJECT hbosc154.

             /* fk fim */

             Assign ttWork.qtd-item-digit = 0.
             Assign vLogFinaliza = NO 
                    vLogSai      = NO
                    vlogerro     = NO
                    vlogcancela  = NO.
             Return "OK". 
         END.
     END.

     Assign ttWork.qtd-item-digit                           = 0
           ttWork.qtd-embal-lidas                          = 0
           ttWork.num-serial                               = 0
           ttWork.num-serial:screen-value In Frame Frame02 = '0'.

    Assign vLogEmProcesso = Yes
           vLogSai        = No
           vLogFinaliza   = No.

    Return 'NOK':U.

End Procedure.


&if '{&mgscm_version}' >= '2.07' &then     /* FLAVIO-INI FO 1389.034*/
PROCEDURE pi-enderecos-entrega:
    DEFINE VARIABLE lde-id-transito    AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE lde-id-doca        AS DECIMAL    NO-UNDO.

    IF NOT VALID-HANDLE(wgbc9018f) THEN DO:
        Run esp/bcp/esbc017f.p Persistent Set wgbc9018f No-error.
    END.

    RUN pi-initialize-dbo IN wgbc9018f.

    RUN picking-get-endereco-transito IN wgbc9018f (INPUT  ttWm-box-movto-idx-picking.cod-estabel,
                                                    INPUT  ttWm-box-movto-idx-picking.cod-local,
                                                    INPUT  ttWm-box-movto-idx-picking.id-docto,
                                                    INPUT  ttWm-box-movto-idx-picking.id-movto,
                                                    OUTPUT c-endereco-entrega,
                                                    OUTPUT lde-id-transito,
                                                    INPUT-OUTPUT TABLE tt-erro).
    FIND FIRST tt-erro NO-ERROR.
    IF AVAIL tt-erro THEN DO: 
       FOR EACH tt-erro:
          {bcp/bc9015.i2 STRING(tt-erro.cd-erro) STRING(tt-erro.mensagem)}
       END.
    END.

    IF NOT lde-id-transito > 0 THEN DO:
        RUN picking-get-endereco-doca IN wgbc9018f (INPUT  ttWm-box-movto-idx-picking.cod-estabel,
                                                    INPUT  ttWm-box-movto-idx-picking.cod-local,
                                                    INPUT  ttWm-box-movto-idx-picking.id-docto,
                                                    INPUT  ttWm-box-movto-idx-picking.id-movto,
                                                    OUTPUT c-endereco-entrega,
                                                    OUTPUT i-cod-doca,
                                                    OUTPUT lde-id-doca,
                                                    INPUT-OUTPUT TABLE tt-erro).
        FIND FIRST tt-erro NO-ERROR.
        IF AVAIL tt-erro THEN DO: 
           FOR EACH tt-erro:
              {bcp/bc9015.i2 STRING(tt-erro.cd-erro) STRING(tt-erro.mensagem)}
           END.
        END.
    END.

    IF c-endereco-entrega <> "":U THEN DO:
        IF lde-id-transito > 0 THEN DO:
            RUN pi-ler-endereco-transito IN THIS-PROCEDURE (INPUT c-endereco-entrega,
                                                            INPUT lde-id-transito).
        END.
        ELSE IF lde-id-doca > 0 THEN DO:
            RUN pi-ler-endereco-doca IN THIS-PROCEDURE (INPUT c-endereco-entrega,
                                                        INPUT i-cod-doca,
                                                        INPUT lde-id-doca).
        END.
    END.
    
    ASSIGN c-endereco-entrega = "":U
           i-cod-doca         = 0
           de-id-box          = 0.

END.

PROCEDURE pi-ler-endereco-transito:
    DEFINE INPUT  PARAMETER pc-endereco-entrega  AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pde-id-transito      AS DECIMAL    NO-UNDO.

    ASSIGN c-endereco-entrega:SCREEN-VALUE IN FRAME {&Frame04Name} = pc-endereco-entrega.

    IF NOT VALID-HANDLE(wgbc9018f) THEN DO:
       Run esp/bcp/esbc017f.p Persistent Set wgbc9018f No-error.
    END.

    /* Segurar o usuario nesta frame ate a leitura da etiqueta do endereco correto */
    REPEAT:
        UPDATE de-id-box WITH FRAME {&Frame04Name}.

        RUN pi-verifica-etiqueta-end-transito IN wgbc9018f (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                                            INPUT ttWm-box-movto-idx-picking.cod-local,
                                                            INPUT de-id-box,
                                                            INPUT-OUTPUT TABLE tt-erro).
        FIND FIRST tt-erro NO-ERROR.
        IF AVAIL tt-erro THEN DO:
           FOR EACH tt-erro:
              {bcp/bc9015.i2 STRING(tt-erro.cd-erro) STRING(tt-erro.mensagem)}
           END.
           EMPTY TEMP-TABLE tt-erro.
           NEXT.
        END.

        IF pde-id-transito = de-id-box THEN LEAVE.

        {bcp/bc9105.i "000" "Box incorreto (DC)"}
    END.
END.

PROCEDURE pi-ler-endereco-doca:
    DEFINE INPUT  PARAMETER pc-endereco-entrega AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-doca         AS INTEGER    NO-UNDO.
    DEFINE INPUT  PARAMETER pde-id-doca         AS DECIMAL    NO-UNDO.
    
    ASSIGN c-endereco-entrega:SCREEN-VALUE IN FRAME {&Frame05Name} = pc-endereco-entrega
                   i-cod-doca:SCREEN-VALUE IN FRAME {&Frame05Name} = TRIM(STRING(pi-cod-doca)).

    IF NOT VALID-HANDLE(wgbc9018f) THEN DO:
        Run esp/bcp/esbc017f.p Persistent Set wgbc9018f No-error.
    END.

    /* Segurar o usuario nesta frame ate a leitura da etiqueta do endereco correto */
    REPEAT:
        UPDATE de-id-box WITH FRAME {&Frame05Name}.

        RUN pi-verifica-etiqueta-endereco IN wgbc9018f (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                                        INPUT ttWm-box-movto-idx-picking.cod-local,
                                                        INPUT de-id-box,
                                                        INPUT-OUTPUT TABLE tt-erro).
        FIND FIRST tt-erro NO-ERROR.
        IF AVAIL tt-erro THEN DO:
            FOR EACH tt-erro:
                {bcp/bc9015.i2 STRING(tt-erro.cd-erro) STRING(tt-erro.mensagem)}
            END.
            EMPTY TEMP-TABLE tt-erro.
            NEXT.
        END.

        IF pde-id-doca = de-id-box THEN LEAVE.

        {bcp/bc9105.i "000" "Box incorreto (DC)"}
    END.
END.
&endif


/* fk inicio: verifica o parametro e se pega ou nao  */
PROCEDURE pi-getIndTipoLeitura:
    ASSIGN iIndTipoLeitura = 3. /* por EAN/DUN */

/*     /* Soh faz se abrir embalagem */                                                                                */
/*     IF v-log-abre-embalagem = YES THEN DO:                                                                          */
/*         /* Usado para identificar o tipo de endereco */                                                             */
/*         DEFINE VARIABLE cTipoBox AS CHARACTER  NO-UNDO.                                                             */
/*                                                                                                                     */
/*         /* Busca o tipo de endereco (bc9018h.i) */                                                                  */
/*         RUN pi-getTipoEndereco(ttWm-box-movto-idx-picking.cod-estabel,                                              */
/*                                ttWm-box-movto-idx-picking.cod-local,                                                */
/*                                ttWork.num-box-lido,                                                                 */
/*                                OUTPUT cTipoBox).                                                                    */
/*                                                                                                                     */
/*         /* Busca o parametro da bc-param-ext conforme o tipo de endereco (BC9018h.i) */                             */
/*         RUN pi-getValorParametro (ttWm-box-movto-idx-picking.cod-item,                                              */
/*                                   "wmsai001",                                                                       */
/*                                   (IF cTipoBox = "NORMAL" THEN "LEIT-QTD-AREA-NORMAL" ELSE "LEIT-QTD-AREA-PICKIN"), */
/*                                   OUTPUT iIndTipoLeitura).                                                          */
/*                                                                                                                     */
/*         /* Se n∆o achar o parametro, assume o valor 2 */                                                            */
/*         IF iIndTipoLeitura = 0 THEN DO:                                                                             */
/*             {bcp/bc9105.i "104" "Parametros nao foram inicializados (DC)"}                                          */
/*             ASSIGN iIndTipoLeitura = 2.                                                                             */
/*         END.                                                                                                        */
/*                                                                                                                     */
/*         /* Caso o parametro seja informado incorretamente, informa ao usuario */                                    */
/*         IF iIndTipoLeitura < 0 OR iIndTipoLeitura > 4  THEN DO:                                                     */
/*             {bcp/bc9105.i "104" "Valor do parametro incorreto para o item/familia/transacao (DC)"}                  */
/*             ASSIGN iIndTipoLeitura = 2.                                                                             */
/*         END.                                                                                                        */
/*                                                                                                                     */
/*         /* Se o tipo de leitura for igual a 1, pede em tela */                                                      */
/*         IF iIndTipoLeitura = 1 THEN DO:                                                                             */
/*             REPEAT:                                                                                                 */
/*                 UPDATE iIndTipoLeitura WITH FRAME Frame03.                                                          */
/*                                                                                                                     */
/*                 /* S¢ aceita valores 2 e 3 digitados em tela */                                                     */
/*                 IF iIndTipoLeitura = 2 OR iIndTipoLeitura = 3 OR iIndTipoLeitura = 4 THEN                           */
/*                     LEAVE.                                                                                          */
/*             END.                                                                                                    */
/*         END.                                                                                                        */
/*     END.                                                                                                            */
END PROCEDURE.
/* fk fim */

/* mk - Verifica tipo de visualizaá∆o - Inicio*/
PROCEDURE pi-getIndTipoVisualiza:
    ASSIGN iIndTipoVisualiza = 2.

/*     /* Busca o parametro da bc-param-ext conforme o tipo de endereco (BC9018h.i) */            */
/*     RUN pi-getValorParametro (ttWm-box-movto-idx-picking.cod-item,                             */
/*                               "wmsai001",                                                      */
/*                               "DISP-QTDE",                                                     */
/*                               OUTPUT iIndTipoVisualiza).                                       */
/*                                                                                                */
/*     /* Se n∆o achar o parametro, assume o valor 2 */                                           */
/*     IF iIndTipoVisualiza = 0 THEN DO:                                                          */
/*         {bcp/bc9105.i "104" "Parametros nao foram inicializados (DC)"}                         */
/*         ASSIGN iIndTipoVisualiza = 2.                                                          */
/*     END.                                                                                       */
/*                                                                                                */
/*     /* Caso o parametro seja informado incorretamente, informa ao usuario */                   */
/*     IF iIndTipoVisualiza <> 2 AND iIndTipoVisualiza <> 4  THEN DO:                             */
/*         {bcp/bc9105.i "104" "Valor do parametro incorreto para o item/familia/transacao (DC)"} */
/*         ASSIGN iIndTipoVisualiza = 2.                                                          */
/*     END.                                                                                       */

    
END PROCEDURE.
/* mk - Verifica tipo de visualizaá∆o - Fim */

/*************************************  Codigo do Usuario Fim   ********************************/
