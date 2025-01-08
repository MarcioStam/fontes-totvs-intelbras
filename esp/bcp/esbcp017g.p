{include/i-prgvrs.i ESBCP017G 2.00.00.033 } /*** 010033 ***/
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i esbcp017g MBC}
&ENDIF
{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9018g.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000                                                               **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Picking WMS                      **
**                                                                                         **
**                                                                                         **
********************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramNAME ESBCP017
/************************************************************/

/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-picking-wms
{esp/bcp/esbcp017.i " "}
{esp/bcp/esbcp017.i1 " "}

{esp/bcp/esbcp017h.i} /*mk - definicao das procedures utilizadas*/

Find First ttWork NO-ERROR.

Define Input parameter IDttwm-box          As Rowid No-undo.
Define Input parameter IDttwm-box-movto    As Rowid No-undo.
Define Input parameter IDbttwm-box-movto   As Rowid No-undo.
Define Input parameter IDttwm-docto-itens  As Rowid No-undo.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-picking-wms-table                        .

/*fk - opcao do tipo de leitura. Esse valor vem da bc9018h.p*/
DEFINE NEW GLOBAL SHARED VARIABLE iIndTipoLeitura  AS INTEGER NO-UNDO. 
DEFINE NEW GLOBAL SHARED VARIABLE iIndTipoVisualiza AS INTEGER NO-UNDO.

DEFINE VARIABLE iLogHabilitaUn AS LOGICAL     NO-UNDO.
DEFINE VARIABLE p-qtd-item     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE p-qtd-caixas   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE p-qtd-unidades AS DECIMAL     NO-UNDO.
DEFINE VARIABLE p-qtd-caixas-aux   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE p-qtd-unidades-aux AS DECIMAL     NO-UNDO.

Define New Shared Variable wgbosc145 As Widget-handle No-undo. 
DEFINE VARIABLE hbosc154        AS HANDLE     NO-UNDO.

&if '{&mgscm_version}' >= '2.07' &then     /* FLAVIO-INI FO 1389.034*/
    DEFINE VARIABLE  c-endereco-entrega AS CHARACTER FORMAT "xxxxxxxxxxxxxxxxx" NO-UNDO.
    DEFINE VARIABLE  i-cod-doca         AS INTEGER         NO-UNDO.
    DEFINE VARIABLE  de-id-box          LIKE wm-box.id-box NO-UNDO.
&endif

Find ttwm-box           No-lock Where Rowid(ttwm-box)           = IDttwm-box            No-error.
Find ttWm-box-movto-idx-picking No-lock Where Rowid(ttWm-box-movto-idx-picking)     = IDttwm-box-movto      No-error.
Find bttwm-box-movto    No-lock Where Rowid(bttwm-box-movto)    = IDbttwm-box-movto     No-error.
Find ttwm-docto-itens   No-lock Where Rowid(ttwm-docto-itens)   = IDttwm-docto-itens    No-error.

DEFINE VARIABLE i-qtd-item-digit LIKE ttWork.qtd-item-digit NO-UNDO.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
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
                             /*ttWork.qtd-embal-lidas                         mk At Row 05 Col 06 No-label Format '>>>>>9.9999'*/ ~
                             ttWork.cod-livre-3                                At Row 05 Col 06 NO-LABEL FORMAT "x(11)"       ~
                             /*ttWork.qtd-item                                mk At Row 06 Col 06 No-label Format '>>>>>9.9999'*/ ~
                             ttWork.cod-livre-4                                At Row 06 Col 06 NO-LABEL FORMAT "x(11)"       ~
                             ttWork.num-serial                                 At Row 07 Col 05 No-label                      ~
                             i-qtd-item-digit                                  At Row 08 Col 05 No-label Format '>>>>>9.9999'
&global-define Frame01Repeat Yes
/************************************************************/

/* fk inicio: projeto parati: pega o valor do ean */
/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Picking WMS'                                     At Row 01 Col 01                               ~
                             '.................. '                             At Row 02 Col 01                               ~
                             '.................. '                             At Row 03 Col 01                               ~
                             'Doca:....Box:..... '                             AT ROW 04 COL 01                               ~
                             'Lida:...........   '                             At Row 05 Col 01                               ~
                             'Pend:...........   '                             AT ROW 06 COL 01                               ~
                             'Ser:.............. '                             At Row 07 Col 01                               ~
                             'CB:                '                             At Row 08 Col 01                               ~
                             ttWork.cod-item                                   At Row 02 Col 01 No-label Format 'x(18)'       ~
                             ttWork.des-endereco                               At Row 03 Col 01 No-label Format 'x(18)'       ~
                             ttWork.num-doca                                   At Row 04 Col 06 No-label Format '>>>'         ~
                             ttWork.num-box-lido                               At Row 04 Col 13 No-label FORMAT '>>>>>9'      ~
                             /*ttWork.qtd-embal-lidas                         mk At Row 05 Col 06 No-label Format '>>>>>9.9999'*/ ~
                             ttWork.cod-livre-3                                At Row 05 Col 06 NO-LABEL FORMAT "x(11)"       ~
                             /*ttWork.qtd-item                                mk At Row 06 Col 06 No-label Format '>>>>>9.9999'*/ ~
                             ttWork.cod-livre-4                                At Row 06 Col 06 NO-LABEL FORMAT "x(11)"       ~
                             ttWork.num-serial                                 At Row 07 Col 05 No-label                      ~
                             ttWork.cod-livre-1                                At Row 08 Col 04 No-label Format 'x(14)' /*fk armazena o ean/dun*/
&global-define Frame02Repeat Yes
/* fk fim */

/************************************************************/

/* mk inicio: pede emb/un */
/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Picking WMS'                                     At Row 01 Col 01                               ~
                             '.................. '                             At Row 02 Col 01                               ~
                             '.................. '                             At Row 03 Col 01                               ~
                             'Doca:....Box:..... '                             AT ROW 04 COL 01                               ~
                             'Lida:...........   '                             At Row 05 Col 01                               ~
                             'Pend:...........   '                             AT ROW 06 COL 01                               ~
                             'Ser:.............. '                             At Row 07 Col 01                               ~
                             'Emb:'                                            At Row 08 Col 01                               ~
                             'Un:'                                             AT ROW 08 COL 11                               ~
                             ttWork.cod-item                                   At Row 02 Col 01 No-label Format 'x(18)'       ~
                             ttWork.des-endereco                               At Row 03 Col 01 No-label Format 'x(18)'       ~
                             ttWork.num-doca                                   At Row 04 Col 06 No-label Format '>>>'         ~
                             ttWork.num-box-lido                               At Row 04 Col 13 No-label FORMAT '>>>>>9'      ~
                             /*ttWork.qtd-embal-lidas                         mk At Row 05 Col 06 No-label Format '>>>>>9.9999'*/ ~
                             ttWork.cod-livre-3                                At Row 05 Col 06 NO-LABEL FORMAT "x(11)"       ~
                             /*ttWork.qtd-item                                mk At Row 06 Col 06 No-label Format '>>>>>9.9999'*/ ~
                             ttWork.cod-livre-4                                At Row 06 Col 06 NO-LABEL FORMAT "x(11)"       ~
                             ttWork.num-serial                                 At Row 07 Col 05 No-label                      ~
                             ttWork.cod-livre-1                                At Row 08 Col 05 No-label Format 'x(4)' /*mk armazena a emb*/ ~
                             ttWork.cod-livre-2                                AT ROW 08 COL 15 NO-LABEL FORMAT "x(16)"  VIEW-AS FILL-IN SIZE 5 BY 0.88
&global-define Frame03Repeat Yes
/* mk fim */


&if '{&mgscm_version}' >= '2.07' &then     /* FLAVIO-INI FO 1389.034*/
    
    &global-define Frame04Name   Frame04
    &global-define Frame04Defs   'Picking WMS'                                     At Row 01 Col 01                         ~
                                 'Endereco Doca:     '                             At Row 03 Col 01                         ~
                                 c-endereco-entrega                                At Row 04 Col 02 No-label                ~
                                 'Cod Doca:'                                       At Row 05 Col 01                         ~
                                 i-cod-doca                                        At Row 05 Col 12 No-label FORMAT '>>>>>9' ~
                                 'Doca:'                                            At Row 07 Col 01                         ~
                                 de-id-box                                         At Row 08 Col 02 No-label
    &global-define Frame04Repeat NO
    
    &global-define Frame05Name   Frame05
    &global-define Frame05Defs   'Picking WMS'                                     At Row 01 Col 01                         ~
                                 'Endereco Transito: '                             At Row 03 Col 01                         ~
                                 c-endereco-entrega                                At Row 04 Col 02 No-label                ~
                                 'Id Transito:       '                             At Row 07 Col 01                         ~
                                 de-id-box                                         At Row 08 Col 02 No-label 
    &global-define Frame05Repeat NO

&endif


/* Definicao dos campos a serem recebidos ---               */
/*&global-define Update01Fields ttwork.qtd-item-digit  */ /*fk - comentado*/
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. If  Return-value = 'OK':U Then Return Return-value.

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ON 'ESC':U OF Frame Frame01 ~
                            DO:                         ~
                                Return 'ESC':U          ~
                            END.                        ~
                            ON 'ESC':U OF Frame Frame02 ~
                            DO:                         ~
                                Return 'ESC':U          ~
                            END.
/************************************************************/

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers                            
/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
/************************************************************/

&global-define ActiveObject1 wgbc9018f

/*****************************************   Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eÔ necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/

/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

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
    /* fk: inicializa vlogerro */
    ASSIGN vLogErro = No.

    If   Not Avail ttWm-box-movto-idx-picking Then Do:
        Return.
    End.

    If ttWork.num-serial = 0 Then
        assign vNumItensSerial = (ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking
               ttWork.qtd-item = vNumItensSerial.

     /* Se for um item da linha leve nao pode permitir alteracao de quantidade itens*/     
    IF NOT VALID-HANDLE(wgbosc145) THEN DO:
        Run scbo/bosc145.p Persistent Set wgbosc145       No-error.
        Run openQueryStatic In wgbosc145 (Input "Main":U) No-error.
    END.

    /* Verifica se abre embalagem */
    RUN getAbreEmbalagem In wgbosc145           
                        (Input  ttWm-box-movto-idx-picking.cod-estabel,
                         Input  ttWm-box-movto-idx-picking.cod-local,
                         Input  ttWm-box-movto-idx-picking.cod-item,
                         INPUT  ttWm-box-movto-idx-picking.cod-embalagem,
                         Output v-log-abre-embalagem).

    If  v-log-abre-embalagem Then Do:
        If   vNumItensSerial > (ttWork.qtd-item - ttWork.qtd-embal-lidas) Then Do:
             Assign  ttWork.qtd-item-digit       = ttWork.qtd-item - ttWork.qtd-embal-lidas.
        End.
        Else Assign ttWork.qtd-item-digit       = vNumItensSerial.
    End.
    Else Assign ttWork.qtd-item-digit       = vNumItensSerial.  /* retirado para testes */

    /* mk - Verifica o Tipo de Visualizaá∆o da quantidade - Inicio */
    IF iIndTipoVisualiza = 2 THEN DO:
        ASSIGN ttWork.cod-livre-4:SCREEN-VALUE IN FRAME {&Frame01Name} = String((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking,">>>>>9.9999") 
               ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame01Name} = STRING(ttWm-box-movto-idx-picking.qtd-item-picking,">>>>>9.9999"). 
    END.
    IF iIndTipoVisualiza = 4 THEN DO:
       
       /* Inicializa BO */
       IF NOT VALID-HANDLE(wgbosc145) THEN DO:
           Run scbo/bosc145.p Persistent Set wgbosc145       No-error.
           Run openQueryStatic In wgbosc145 (Input "Main":U) No-error.
       END.

       RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                             INPUT ttWm-box-movto-idx-picking.cod-local,
                                             INPUT ttWm-box-movto-idx-picking.cod-item,
                                             INPUT ttWm-box-movto-idx-picking.cod-embal,
                                             INPUT ttWork.qtd-item, 
                                             OUTPUT p-qtd-caixas,
                                             OUTPUT p-qtd-unidades).

       ASSIGN ttWork.cod-livre-4:SCREEN-VALUE IN FRAME {&Frame01Name} = STRING(p-qtd-caixas,">>>>9") + " |" + STRING(p-qtd-unidades).

       RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                             INPUT ttWm-box-movto-idx-picking.cod-local,
                                             INPUT ttWm-box-movto-idx-picking.cod-item,
                                             INPUT ttWm-box-movto-idx-picking.cod-embal,
                                             INPUT ttWork.qtd-embal-lidas,
                                             OUTPUT p-qtd-caixas-aux,
                                             OUTPUT p-qtd-unidades-aux). 

       ASSIGN ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame02Name} = STRING(p-qtd-caixas-aux,">>>>9") + " |" + STRING(p-qtd-unidades-aux).

    END.

    ASSIGN ttWork.qtd-item        = (ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking
           i-qtd-item-digit       = 0.
    
    /* mk - Verifica o Tipo de Visualizaá∆o da quantidade - Fim */

    Assign ttWork.cod-item       :Screen-value In Frame {&Frame01Name} = ttwm-docto-itens.cod-item
           ttWork.cod-item                                             = ttwm-docto-itens.cod-item
           ttWork.num-doca       :Screen-value In Frame {&Frame01Name} = string(ttwm-docto-itens.cod-doca)
           /* mk ttWork.qtd-item       :Screen-value In Frame {&Frame01Name} = String((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking)*/
           ttWork.des-endereco                                         =  ttwm-box.cod-bloco            + '/':U + 
                                                                          ttwm-box.cod-rua              + '/':U + 
                                                                          ttwm-box.cod-nivel            + '/':U + 
                                                                          ttwm-box.cod-coluna           + '/':U +
                                                                          If ttwm-box.ind-posicao-box = 1 Then 'E' Else 'D'
        ttWork.des-endereco   :Screen-value In Frame {&Frame01Name} = ttWork.des-endereco
           ttWork.num-box-lido   :Screen-value In Frame {&Frame01Name} = String(ttWork.num-box-lido)
           ttWork.num-serial     :Screen-value In Frame {&Frame01Name} = string(ttWork.num-serial)
           /* mk ttWork.qtd-embal-lidas:Screen-value In Frame {&Frame01Name} = String(ttWork.qtd-embal-lidas) */
           i-qtd-item-digit :Screen-value In Frame {&Frame01Name} = "0".

    /* fk inicio */
    DO:
        /* Se o tipo de leitura for por ean, pega o codigo */
        IF iIndTipoLeitura = 3 THEN DO:
            /* Efetiva os campos do buffer */
            ASSIGN ttWork.cod-item /*mk ttWork.qtd-item*/ ttWork.cod-livre-4 ttWork.des-endereco      
                /*mk ttWork.qtd-embal-lidas*/ ttWork.cod-livre-3 ttWork.num-doca ttWork.num-box-lido      
                ttWork.num-serial.

            /* Metodo para pegar as informacoes do eah-dun*/
            RUN getInfoCodigoEanDun.
        END.
        ELSE IF iIndTipoLeitura = 4 THEN DO:
            /* Efetiva os campos do buffer */
            ASSIGN ttWork.cod-item /*mk ttWork.qtd-item*/ ttWork.cod-livre-4 ttWork.des-endereco      
                /*mk ttWork.qtd-embal-lidas*/ ttWork.cod-livre-3 ttWork.num-doca ttWork.num-box-lido      
                ttWork.num-serial.

            /* Metodo para pegar as informacoes do eah-dun*/
            RUN getInfoEmbUn.
        END.
        ELSE DO:
            Hide All No-pause.

            /* fk - Se der esc, retorna ao valor anterior */
            ON END-ERROR OF  i-qtd-item-digit
            DO: 
                ASSIGN i-qtd-item-digit = 0
                    vLogErro = YES.
            END.

            /*  */
            DO ON ENDKEY UNDO, RETURN "ESC":
                UPDATE i-qtd-item-digit WITH FRAME {&Frame01Name} .
            END.
            ASSIGN ttWork.qtd-item-digit = i-qtd-item-digit.
        END.
    END.
    /* fk fim */

End Procedure.

/*************************************************************************************************** 
** Esta procedure eÔ executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:
    /* Validacoes Frame 05 Inicio --- */

    /* fk: comentado vlogerro */
    Assign /*vLogErro = No*/ vLogSai = No vLogFinaliza = No.

    /* fk inicio: se tiver erro, retorna */
    IF vLogErro = YES THEN DO:
        HIDE ALL.
        /*Run bcp/bc9115.p (608, "Processo nao finalizado corretamente (DC)",8,20,5).*/
        /*{bcp/bc9105.i "608" "Processo nao finalizado corretamente (DC)"}*/
        Assign  vLogErro = NO.
            /*vLogFinaliza = Yes
               vLogSai      = Yes.*/
        Return 'ok':U.
    END.
    /* fk fim */

    If  ttWork.qtd-item-digit = 0 Then Do:
        /* fk: Comentado. Se for igual a zero, retorna sem executar nada */
        {bcp/bc9105.i "605" "Quantidade picking igual a zero(DC)"}
        RETURN "OK":U.
        /*Assign vLogErro = Yes.
        {bcp/bc9105.i "601" "Quantidade Inv†lida (WMS)"}
        View Frame {&Frame01Name}.
        Pause 0 No-message.
        Return 'NOK':U.*/

    End.


    If  ttWork.qtd-item-digit > vNumItensSerial Then Do:
        Assign vLogErro = Yes.
        If ttWork.num-serial <> 0 Then do:
            {bcp/bc9105.i "602" "Quantidade serial maior que a quantidade necess†ria (WMS)"}
        End.
        else do:
            {bcp/bc9105.i "602" "Quantidade informada maior que a quantidade necess†ria (WMS)"}
        End.
        View Frame {&Frame01Name}.
        Pause 0 No-message.
        Return 'NOK':U.
    End.

    If  v-log-abre-embalagem  = No And 
        vNumItensSerial   <> ttWork.qtd-item-digit Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "603" "Quantidade Inv†lida (WMS)"}
        View Frame {&Frame01Name}.
        Pause 0 No-message.
        Return 'NOK':U.
    End.

    If  v-log-abre-embalagem  = Yes And 
        ttWork.qtd-item-digit > (ttWork.qtd-item - ttWork.qtd-embal-lidas) Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "604" "Quantidade Inv†lida (WMS)"}
        View Frame {&Frame01Name}.
        Pause 0 No-message.
        Return 'NOK':U.
    End.

    IF CAN-FIND(FIRST tt-picking-wms-table WHERE
        tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto     AND
        tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto     AND
        tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item AND
        tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto) THEN DO:

        For Each ttSerialQtd:
            Delete ttSerialQtd.
        End.

        For Each tt-picking-wms-table NO-LOCK WHERE
            tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto     AND
            tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto     AND
            tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item AND
            tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto:

            Create ttSerialQtd.
            Assign ttSerialQtd.id-etiqueta       = tt-picking-wms-table.num-serial
                   ttSerialQtd.qtd-item-retirado = tt-picking-wms-table.qtd-item-digit.
         End. /*For Each */

    End. /* If */

    If ttWork.num-serial <> 0 Then do: /* Apenas para transaá∆o via seriais */
        Run EmptyRowErrors In wgbosc074.
        IF (ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) <> ttWm-box-movto-idx-picking.qtd-item-picking THEN DO:
            Run validaQtdItemEtiquetaPicking In wgbosc074 (Input ttWm-box-movto-idx-picking.cod-local,
                                                           Input ttWork.num-serial,
                                                           Input ttWork.qtd-item-digit,
                                                           Input Table ttSerialQtd).
    
            Run getRowErrors In wgbosc074 (Output Table RowErrors) No-error.
            For Each RowErrors:
                Hide All No-pause.
                ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,10).
                Hide All No-pause.
            End. /* Each RowErrors */
    
            If  Can-find( First rowErrors) Then Do:
                Assign vLogErro = Yes.
                Return 'NOK':U.
            End.
        END.

    End.

    IF NOT VALID-HANDLE(wgbc9018f) THEN DO:
        Run esp/bcp/esbc017f.p Persistent Set wgbc9018f No-error.
    END.

    Find First tt-picking-wms-table  WHERE
               tt-picking-wms-table.num-serial     = ttWork.num-serial
           And tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto
           And tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto
           And tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item
           And tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto No-error.

    If  Available tt-picking-wms-table Then Do:
       RUN pi-atualiza-qtd-digitada IN wgbc9018f (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                                  Input ttWm-box-movto-idx-picking.cod-local,
                                                  INPUT ttWm-box-movto-idx-picking.id-movto,
                                                  INPUT ttWm-box-movto-idx-picking.ind-tipo-movto,
                                                  INPUT ttwm-box-movto-idx-picking.id-docto,
                                                  INPUT ttWork.num-serial,
                                                  INPUT ttWm-box-movto-idx-picking.num-seq-item,
                                                  INPUT vNumItensSerial,
                                                  INPUT ttwork.qtd-item-digit,
                                                  INPUT-OUTPUT TABLE tt-erro).
        find first tt-erro no-error.
        if  avail tt-erro THEN DO: 
            FOR EACH tt-erro:
                ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(WMS)":U.
                {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
                Assign vLogSai      = Yes.
            END.
            If vLogErro = Yes Then Return Error.
        END.
        ASSIGN tt-picking-wms-table.qtd-item-digit =  tt-picking-wms-table.qtd-item-digit + vNumItensSerial.
    End. /*If  Available */
    Else Do:
        RUN pi-cria-tt-picking-ems-table IN wgbc9018f (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                                       Input ttWm-box-movto-idx-picking.cod-local,
                                                       INPUT ttWm-box-movto-idx-picking.id-movto,
                                                       INPUT ttWm-box-movto-idx-picking.ind-tipo-movto,
                                                       INPUT ttwm-box-movto-idx-picking.id-docto,
                                                       INPUT ttWork.num-serial,
                                                       INPUT ttWm-box-movto-idx-picking.num-seq-item,
                                                       INPUT vNumItensSerial,
                                                       INPUT ttwork.qtd-item-digit,
                                                       INPUT ttWm-box-movto-idx-picking.cod-item,
                                                       INPUT ttwork.num-box-lido,
                                                       INPUT ttWm-box-movto-idx-picking.cod-embalagem,
                                                       INPUT ttWm-box-movto-idx-picking.qti-embalagem,
                                                       INPUT ttWm-box-movto-idx-picking.dt-atualizacao,
                                                       INPUT ttWm-box-movto-idx-picking.dt-transacao,
                                                       INPUT ttWork.num-tempo-inicio,
                                                       INPUT ttWork.cod-coletor,
                                                       INPUT ttWork.cod-equipamento,
                                                       input "",
                                                       INPUT-OUTPUT TABLE tt-picking-wms-table,
                                                       OUTPUT TABLE tt-erro).
        find first tt-erro no-error.
        if  avail tt-erro THEN DO: 
            FOR EACH tt-erro:
                ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
                {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
                Assign vLogSai      = Yes.
            END.
            If vLogErro = Yes Then Return Error.
        END.
    End. /*Else Do:*/

    Assign ttWork.qtd-embal-lidas = 0.
    For Each tt-picking-wms-table NO-LOCK WHERE
             tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto 
       And   tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto
       And   tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item    
       And   tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto:

        Assign ttWork.qtd-embal-lidas = ttWork.qtd-embal-lidas + tt-picking-wms-table.qtd-item-digit.

     End. /*For Each */

     /* mk Assign ttWork.qtd-embal-lidas:Screen-value In Frame {&Frame01Name} = String(ttWork.qtd-embal-lidas). */
     /* mk */ ASSIGN ttWork.cod-livre-3:Screen-value In Frame {&Frame01Name} = String(ttWork.qtd-embal-lidas). 

     Assign ttWork.cod-estabel           = v-cod-estabel
            ttWork.cod-local             = v-cod-local
            ttWork.id-docto              = ttWm-box-movto-idx-picking.id-docto
            ttWork.id-movto              = ttWm-box-movto-idx-picking.id-movto
            ttWork.num-seq-item          = ttWm-box-movto-idx-picking.num-seq-item
            ttWork.num-box               = ttWm-box-movto-idx-picking.id-box
            ttWork.num-doca              = ttwm-docto-itens.cod-doca
            ttWork.cod-embalagem         = ttWm-box-movto-idx-picking.cod-embalagem
            ttWork.des-endereco          = ttWork.des-endereco:Screen-value In Frame {&Frame01Name} 
            ttWork.cod-item              = ttwm-docto-itens.cod-item
            ttWork.qtd-item              = ttWm-box-movto-idx-picking.qtd-item
            ttWork.qtd-embalagem         = ttWm-box-movto-idx-picking.qti-embalagem
            ttWork.dat-atualizacao       = ttWm-box-movto-idx-picking.dt-atualizacao
            ttWork.dat-transacao         = ttWm-box-movto-idx-picking.dt-transacao.

    IF ((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking) >= ttwork.qtd-embal-lidas THEN DO:
        RUN GravaTransacao. /*dumke */

        RETURN RETURN-VALUE.
    END.

    /*Se o movimento ainda estiver esperando itens e se ainda houverem itens                  
      disponiveis no serial informado sugere a quantidade restante no campo 
      que solicita a quantidade */
     If  ttwm-docto-itens.qtd-item                 > ttWork.qtd-embal-lidas And
        (vNumItensSerial - ttWork.qtd-item-digit) > 0 Then Do:
        Assign vNumItensSerial       = vNumItensSerial - ttWork.qtd-item-digit.
    End. /*If  ttwm-docto-itens.cod-item*/ 
    Assign vLogFinaliza = Yes
           vLogSai      = Yes.

    Return 'ESC':U.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure eÔ executada pelo pre-processador {&TriggerAfterFrame01}.                       **
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
             /* fk fim */

             Assign ttWork.qtd-item-digit = 0.
             Assign vLogFinaliza = NO 
                    vLogSai      = NO
                    vlogerro     = NO
                    vlogcancela  = NO.
             Return "OK". 
         END.
         IF NOT VALID-HANDLE(hbosc154) THEN DO:
             Run scbo/bosc154.p Persistent Set hbosc154       No-error.
             Run openQueryStatic In hbosc154 (Input "Main":U) No-error.
         END.
         RUN acertacapacidadeendereco IN hbosc154 (INPUT ttWork.cod-estabel,
                                                   INPUT ttWork.cod-local,
                                                   INPUT ttWork.id-docto,
                                                   INPUT ttWork.num-seq-item).
     END.

    IF VALID-HANDLE (hbosc154) THEN DELETE OBJECT hbosc154.

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

END.

PROCEDURE pi-ler-endereco-transito:
    DEFINE INPUT  PARAMETER pc-endereco-entrega AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pde-id-transito     AS DECIMAL    NO-UNDO.
    
    &if '{&mgscm_version}' >= '2.07' &then 
    	ASSIGN c-endereco-entrega:SCREEN-VALUE IN FRAME {&Frame05Name} = pc-endereco-entrega.
    &endif

    IF NOT VALID-HANDLE(wgbc9018f) THEN DO:
            Run esp/bcp/esbc017f.p Persistent Set wgbc9018f No-error.
    END.

    /* Segurar o usuario nesta frame ate a leitura da etiqueta do endereco correto */
    REPEAT:
    	&if '{&mgscm_version}' >= '2.07' &then 
            UPDATE de-id-box WITH FRAME {&Frame05Name}.
	&endif

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

    ASSIGN c-endereco-entrega:SCREEN-VALUE IN FRAME {&Frame04Name} = pc-endereco-entrega
                   i-cod-doca:SCREEN-VALUE IN FRAME {&Frame04Name} = TRIM(STRING(pi-cod-doca)).

    IF NOT VALID-HANDLE(wgbc9018f) THEN DO:
        Run esp/bcp/esbc017f.p Persistent Set wgbc9018f No-error.
    END.

    /* Segurar o usuario nesta frame ate a leitura da etiqueta do endereco correto */
    REPEAT:
        UPDATE de-id-box WITH FRAME {&Frame04Name}.

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


/*************************************************************************************************** 
** fk inicio: [alteracao parati] Busca as informacoes do codigo ean/dun                           **
****************************************************************************************************/
Procedure getInfoCodigoEanDun:

    /* Variaveis */
    DEFINE VARIABLE iTipoInformacao AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cCodItem        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cCodEmbalagem   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE deQtdInformacao AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE hbosc148        AS HANDLE     NO-UNDO.

    /*  */
    RUN scbo/bosc148.p PERSISTENT SET hbosc148.

    /* Nao deixa sair do campo */
    ON END-ERROR OF   ttwork.cod-livre-1 IN FRAME {&Frame02Name}
    DO:
        ASSIGN ttwork.qtd-item-digit = 0
            vLogErro = YES.
    END.
    /*  */
    ASSIGN ttwork.qtd-item-digit = 0
           i-qtd-item-digit      = 0.

    /* Faz a leitura atÇ a qtd de itens for igual a qtd da etiqueta */
    REPEAT:
        /* Busca o valor do codigo ean/dun da tela */
        DISP ttWork.cod-item /*ttWork.qtd-item*/ ttWork.des-endereco              
            /*ttWork.qtd-embal-lidas*/ ttWork.num-doca ttWork.num-box-lido              
            ttWork.num-serial ttWork.cod-livre-1 WITH  FRAME {&Frame02Name}.

        /* mk - Verifica o Tipo de Visualizaá∆o da quantidade - Inicio */
        IF iIndTipoVisualiza = 2 THEN DO:
            ASSIGN ttWork.cod-livre-4:SCREEN-VALUE IN FRAME {&Frame02Name} = String((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking,">>>>>9.9999")
                   ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame02Name} = STRING(ttWork.qtd-embal-lidas,">>>>>9.9999").
        END.
        IF iIndTipoVisualiza = 4 THEN DO:
           
           /* Inicializa BO */
           IF NOT VALID-HANDLE(wgbosc145) THEN DO:
               Run scbo/bosc145.p Persistent Set wgbosc145       No-error.
               Run openQueryStatic In wgbosc145 (Input "Main":U) No-error.
           END.
    
           RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                                 INPUT ttWm-box-movto-idx-picking.cod-local,
                                                 INPUT ttWm-box-movto-idx-picking.cod-item,
                                                 INPUT ttWm-box-movto-idx-picking.cod-embal,
                                                 INPUT ttWork.qtd-item, 
                                                 OUTPUT p-qtd-caixas,
                                                 OUTPUT p-qtd-unidades).
    
           ASSIGN ttWork.cod-livre-4:SCREEN-VALUE IN FRAME {&Frame02Name} = STRING(p-qtd-caixas,">>>>9") + " |" + STRING(p-qtd-unidades).
    
           RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                                 INPUT ttWm-box-movto-idx-picking.cod-local,
                                                 INPUT ttWm-box-movto-idx-picking.cod-item,
                                                 INPUT ttWm-box-movto-idx-picking.cod-embal,
                                                 INPUT ttWork.qtd-embal-lidas,
                                                 OUTPUT p-qtd-caixas,
                                                 OUTPUT p-qtd-unidades). 
    
           ASSIGN ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame02Name} = STRING(p-qtd-caixas,">>>>9") + " |" + STRING(p-qtd-unidades).
    
        END.

        /* Habilita para digitacao do codigo ean-dun*/
        Hide All No-pause.
        ASSIGN ttwork.cod-livre-1 = "".
        DO ON ENDKEY UNDO, RETURN "ESC":
            UPDATE ttwork.cod-livre-1 WITH FRAME {&Frame02Name}.
        END.

        /* Se for digitado 999999, efetiva o que for lido */
        IF ttwork.cod-livre-1 = "999999" THEN DO:
            LEAVE.
        END.

        /* Busca as informacoes referente ao codigo ean */
        Run EmptyRowErrors In hbosc148.
        RUN readBarCode IN hbosc148 (INPUT v-cod-estabel,
                                     INPUT v-cod-local,
                                     INPUT ttwork.cod-livre-1, /*codigo ean/dun lido*/
                                     OUTPUT iTipoInformacao,
                                     OUTPUT cCodItem, 
                                     OUTPUT cCodEmbalagem,
                                     OUTPUT deQtdInformacao,
                                     OUTPUT TABLE RowErrors).

        /* Tratamento de erro */
        Run getRowErrors In hbosc148 (Output Table RowErrors) No-error.
        For Each RowErrors:
            Hide All No-pause.
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,10).
            Hide All No-pause.
            next.
        End. 

        /* Teste inicio */
        /*ASSIGN cCodItem = 'wms-serie'
            cCodEmbalagem = '10'
            deQtdInformacao = 1.
        MESSAGE 'O metodo getInfoCodigoEanDun nao est† definido pela logistica.' SKIP
            'Est† sendo adicionado uma variavel de teste. Nao esquecer de retirar o comentario' SKIP
            ttwork.cod-item
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.*/
        /* Teste fim */

        /* Verifica se o item do codigo ean/dun eh o mesmo item do serial */
        IF cCodItem <> ttwork.cod-item THEN DO:
            {bcp/bc9105.i "0" "Item do codigo ean/dun lido n∆o confere com o item do c¢digo serial (DC)"}
            NEXT.
        END.

/* -> pede quantidade */
        Hide All No-pause.

        ASSIGN i-qtd-item-digit = 0.
        /* fk - Se der esc, retorna ao valor anterior */
        ON END-ERROR OF  i-qtd-item-digit IN FRAME {&Frame01Name}
        DO: 
            ASSIGN i-qtd-item-digit = 0.
        END.

        /*  */
        DO ON ENDKEY UNDO, NEXT:
            /* mk - Verifica o Tipo de Visualizaá∆o da quantidade - Inicio */
            IF iIndTipoVisualiza = 2 THEN DO:
                ASSIGN ttWork.cod-livre-4:SCREEN-VALUE IN FRAME {&Frame01Name} = String((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking,">>>>>9.9999") 
                       ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame01Name} = STRING(ttWm-box-movto-idx-picking.qtd-item-picking,">>>>>9.9999"). 
            END.
            IF iIndTipoVisualiza = 4 THEN DO:
               ASSIGN ttWork.cod-livre-4:SCREEN-VALUE IN FRAME {&Frame01Name} = STRING(p-qtd-caixas,">>>>9") + " |" + STRING(p-qtd-unidades).
               ASSIGN ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame01Name} = STRING(p-qtd-caixas-aux,">>>>9") + " |" + STRING(p-qtd-unidades-aux).
            END.

            ASSIGN i-qtd-item-digit = ((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking) - ttwork.qtd-item-digit.
            UPDATE i-qtd-item-digit WITH FRAME {&Frame01Name} .
        END.

/* -> fim pede quantidade*/


        IF (ttwork.qtd-item-digit + i-qtd-item-digit) > ((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking) THEN DO:
           {bcp/bc9105.i "0" "Quantidade lida maior que a quantidade necessaria. (DC)"}
           NEXT.
        END.

        /* Verifica se a embalagem do codigo lido eh a mesma do serial*/
        /*IF cCodEmbalagem <> ttwork.cod-embalagem THEN DO:
            {bcp/bc9105.i "0" "Embalagem do codigo ean/dun lido n∆o confere com a embalagem do c¢digo serial (DC)"}
            NEXT.
        END.*/
        If  ttWork.qtd-item-digit + i-qtd-item-digit > vNumItensSerial Then Do:
            {bcp/bc9105.i "602" "Quantidade lida maior que a quantidade do Serial (WMS)"}
            NEXT.
        End.
        /* Incrementa a qtd de item digitado para os dois campos em tela  */
        ASSIGN ttwork.qtd-item-digit = ttwork.qtd-item-digit + i-qtd-item-digit
            ttWork.qtd-embal-lidas = ttWork.qtd-item-digit.

        /* S¢ sai do looping quando a qtd de item lido for igual a qtd no serial */
        IF ttwork.qtd-item-digit = vNumItensSerial THEN DO:
            LEAVE.
        END.
        IF ttwork.qtd-item-digit = ((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking) THEN DO:
            LEAVE.
        END.

    END.

    /* Zera o valor lido em tela, pois eh usado apenas na leitura por qtd */
    ASSIGN ttWork.qtd-embal-lidas = 0.

    /*  */
    IF VALID-HANDLE (hbosc148) THEN DELETE OBJECT hbosc148.

    /*  */
    RETURN 'ok'.

END PROCEDURE.
/* fk fim */

/*************************************************************************************************** 
** mk inicio: [alteracao iquine] Busca as informacoes do codigo emb/un                            **
****************************************************************************************************/
Procedure getInfoEmbUn:

    /* Variaveis */
    DEFINE VARIABLE iTipoInformacao AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cCodItem        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cCodEmbalagem   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE deQtdInformacao AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE hbosc148        AS HANDLE     NO-UNDO.

    /*  */
    IF NOT VALID-HANDLE (wgbosc145) THEN
        RUN scbo/bosc145.p PERSISTENT SET wgbosc145.

    /* Nao deixa sair do campo */
    ON END-ERROR OF   ttwork.cod-livre-1 IN FRAME {&Frame03Name}
    DO:
        ASSIGN ttwork.qtd-item-digit = 0
               vLogErro = YES.
    END.
    /*  */
    ASSIGN ttwork.qtd-item-digit = 0.

    /* Faz a leitura atÇ a qtd de itens for igual a qtd da etiqueta */
    REPEAT:
        /* Busca o valor do codigo emb~\un da tela */
        DISP ttWork.cod-item /*mk ttWork.qtd-item*/ ttWork.cod-livre-3  ttWork.des-endereco              
            /* mk ttWork.qtd-embal-lidas*/ ttWork.cod-livre-4  ttWork.num-doca ttWork.num-box-lido              
            ttWork.num-serial WITH  FRAME {&Frame03Name}.

        /* mk - Verifica o Tipo de Visualizaá∆o da quantidade - Inicio */
        IF iIndTipoVisualiza = 2 THEN DO:
            ASSIGN ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame03Name} = String((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking,">>>>>9.9999")
                   ttWork.cod-livre-4:SCREEN-VALUE IN FRAME {&Frame03Name} = STRING(ttWork.qtd-embal-lidas,">>>>>9.9999").
        END.
        IF iIndTipoVisualiza = 4 THEN DO:
           
           /* Inicializa BO */
           IF NOT VALID-HANDLE(wgbosc145) THEN DO:
               Run scbo/bosc145.p Persistent Set wgbosc145       No-error.
               Run openQueryStatic In wgbosc145 (Input "Main":U) No-error.
           END.
    
           RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                                 INPUT ttWm-box-movto-idx-picking.cod-local,
                                                 INPUT ttWm-box-movto-idx-picking.cod-item,
                                                 INPUT ttWm-box-movto-idx-picking.cod-embal,
                                                 INPUT ttWork.qtd-item, 
                                                 OUTPUT p-qtd-caixas,
                                                 OUTPUT p-qtd-unidades).
    
           ASSIGN ttWork.cod-livre-4:SCREEN-VALUE IN FRAME {&Frame03Name} = STRING(p-qtd-caixas,">>>>9") + " |" + STRING(p-qtd-unidades).
    
           RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                                 INPUT ttWm-box-movto-idx-picking.cod-local,
                                                 INPUT ttWm-box-movto-idx-picking.cod-item,
                                                 INPUT ttWm-box-movto-idx-picking.cod-embal,
                                                 INPUT ttWork.qtd-embal-lidas,
                                                 OUTPUT p-qtd-caixas,
                                                 OUTPUT p-qtd-unidades). 
    
           ASSIGN ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame03Name} = STRING(p-qtd-caixas,">>>>9") + " |" + STRING(p-qtd-unidades).
    
        END.
        /* Habilita para digitacao do codigo emb e un (se parametrizado)*/
        RUN pi-getLogHabilitaUn IN THIS-PROCEDURE.

        Hide All No-pause.
        ASSIGN ttwork.cod-livre-1 = "".
        DO ON ENDKEY UNDO, RETURN "ESC":
        
            IF iLogHabilitaUn THEN DO:
                UPDATE ttwork.cod-livre-1 ttWork.cod-livre-2 WITH FRAME {&Frame03Name}.
            END.
            ELSE
                UPDATE ttwork.cod-livre-1 WITH FRAME {&Frame03Name}.
        END.

        /* mk Metodo para transformar a emb/un em quantidade */
        Run EmptyRowErrors In wgbosc145.
        RUN piConverteCaixaQtde IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel, 
                                              INPUT ttWm-box-movto-idx-picking.cod-local,   
                                              INPUT ttWm-box-movto-idx-picking.cod-item,    
                                              INPUT ttWm-box-movto-idx-picking.cod-embal,
                                              INPUT ttWork.cod-livre-1,  
                                              INPUT ttWork.cod-livre-2,
                                              OUTPUT p-qtd-item).
        IF RETURN-VALUE <> "OK" THEN DO:
            Run getRowErrors In wgbosc145 (Output Table RowErrors) No-error.
            For Each RowErrors:
                Hide All No-pause.
                ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
                Hide All No-pause.
                next.
            End. 
        END.
        ELSE DO:

          

            /* Se for informado quantidade a mais da alerta */
            IF p-qtd-item > vNumItensSerial THEN DO:
                {bcp/bc9105.i "602" "Quantidade lida maior que a quantidade pedida (WMS)"}
                NEXT.
            END.

            /* S¢ sai do looping quando a qtd de item lido for igual a qtd de emb~\un */
            IF p-qtd-item = vNumItensSerial THEN DO:
                ASSIGN ttwork.qtd-item-digit  = p-qtd-item
                       ttWork.qtd-embal-lidas = p-qtd-item.
                LEAVE.
            END.
            ELSE IF p-qtd-item = ((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking) THEN DO:
                ASSIGN ttwork.qtd-item-digit  = p-qtd-item
                       ttWork.qtd-embal-lidas = p-qtd-item.
                LEAVE.
            END.
            ELSE DO:
                {bcp/bc9105.i "602" "Quantidade lida deve ser igual a pedida (WMS)"}
                 NEXT.
            END.
        END.
    END.

    /* Zera o valor lido em tela, pois eh usado apenas na leitura por qtd */
    ASSIGN ttWork.qtd-embal-lidas = 0.

    /*  */
    IF VALID-HANDLE (wgbosc145) THEN DELETE OBJECT wgbosc145.

    /*  */
    RETURN 'ok'.

END PROCEDURE.
/* mk fim */

/* mk - Busca Parametro HABILITA-UNIDADE - Inicio */
PROCEDURE pi-getLogHabilitaUn:
    DEFINE VARIABLE iNumLogHabilitaUn AS INTEGER     NO-UNDO.

    /* Busca o parametro da bc-param-ext conforme o tipo de endereco (BC9018h.i) */
    RUN pi-getValorParametro (ttWm-box-movto-idx-picking.cod-item,
                              "wmsai001",
                              "HABILITA-UNIDADE",
                              OUTPUT iNumLogHabilitaUn).

    /* Se n∆o achar o parametro, assume o valor 1 - Habilita Unidade */
    IF iNumLogHabilitaUn = 0 THEN DO:
        ASSIGN iLogHabilitaUn = NO.
    END.
    
    /* Caso o parametro seja informado incorretamente, informa ao usuario */
    IF iNumLogHabilitaUn <> 1 AND iNumLogHabilitaUn <> 2 AND iNumLogHabilitaUn <> 0 THEN DO:
        {bcp/bc9105.i "104" "Valor do parametro incorreto para o item/familia/transacao (DC)"}
        ASSIGN iLogHabilitaUn = YES.
    END.

    IF iNumLogHabilitaUn = 1 THEN
        ASSIGN iLogHabilitaUn = YES.
    IF iNumLogHabilitaUn = 2 THEN
        ASSIGN iLogHabilitaUn = NO.

END PROCEDURE.
/* mk - Busca Parametro HABILITA-UNIDADE - Fim */
