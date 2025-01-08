/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9018G 2.00.00.022 } /*** 010022 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9018g MBC}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9018g.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000                                                               **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Picking WMS                      **
**                                                                                         **
**                                                                                         **
********************************************************************************************/
&if '{&mgscm_version}' >= '2.04':U &THEN
/***************************************************************************************************
** SECAO DE PRE-PROCESSADORES DA TEMPLATE                                                         **
** Nesta secao sao definidos os pre-processadores que serao usados na montagem da interface.      **
**                                                                                                **
** DESCRICAO DOS PREPROCESSADORES:                                                                **
** ProgramName          - Nome do programa e, tambem, do Codigo da transacao do Data Collection   **
**                        que sera acionada pela interface.                                       **
** TempTable            - Nome da Temp-Table da transacao de negocio para comunicacao com ERP.    **
**                        Ex: tt-picking-wms.                                                     **
** FrameSize            - Tamanho da tela da interface. Deve-se observar este parametro quando da **
**                        definicao das telas, o espaco utilizado nao pode ultrapassar o limite   **
**                        estabelecido por este pre-processador.                                  **
** Frame99Name          - Nome da Tela. Sugestao "Frame" mais sequencia.                          **
**                        Ex. Frame01, Frame02, Frame03, etc.                                     **
** Frame99Defs          - Definicoes da tela onde a mesma deve conter:                            **
**                        .Titulo da Tela quando necessario.                                      **
**                        .Campos com a opcao no-label e sua localizacao Ex. At Row x Col y.      **
**                        .Literais que substituem os labels dos campos e sua localizacao.        **
**                        .Instrucoes de Navegacao quando houver espaco livre para o mesmo.       **
**                        Ex. "F4=Sair","ESC=Voltar","F2=Gravar" etc.                             **
** Frame99Repeat        - Indica se a tela tem caracteristica de repeticao. O Valor YES indica    **
**                        que ha repeticao e o valor NO indica que nao ha repeticao.              **
** Update99Fields       - Relaciona os campos que serao solicitados na tela.                      **
**                        OBS. Nao deve conter formatacao. Ex. ttWork.it-codigo no-label.         **
** TriggerBeforeFrame99 - Gatilho para ser executado antes da execucao da tela. Neste gatilho     **
**                        devem ser colocadas chamadas as procedures de inicializacao dos campos  **
**                        da tela.                                                                **
** TriggerAfterFrame99  - Gatilho para ser executado apos a execucao da tela. Neste gatilho       **
**                        dever ser colocada a chamada a procedures que devera armazenar  na      **
**                        temp-table {&TempTable} os campos da ttWork, que sao os campos          **
**                        solicitados em tela. Neste gatilho tambem, quando o mesmo se referir a  **
**                        ultima tela de entrada de dados, devera existir uma chamada a procedure **
**                        que executa a procedure _GenerateDCTransaction que eï responsavel por   **
**                        gerar a transacao no Coleta de Dados.                                   **
** UserTriggers         - Este pro-processador destina-se as triggers customizadas do usuario.    **
**                        Ex: Alimentar um campo da dela conforme o informado em outro campo.     **
**                            On Leave of ttWork.cod-depos in Frame Frame02                       **
**                            Do:                                                                 **
**                                Case ttWork.cod-depos:                                          **
**                                  When 'Pro' Then Assign ttWork.cod-local = 'Pro01'.            **
**                                  When 'Alm' Then Assign ttWork.cod-local = 'Alm01'.            **
**                                  When 'Exp' Then Assign ttWork.cod-local = 'Exp01'.            **
**                            End.                                                                **
** AtiveObject1         - Este pro-processador permite que se destruam os objetos persistentes    **
**                        no final da sessao progress.                                            **
**                        Ex: &global-define ActiveObject wgbosc074                               **
***************************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramNAME BC9018
/************************************************************/

/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-picking-wms
{bcp/bc9018.i " "}
{bcp/bc9018.i1 " "}

{bcp/bc9018h.i} /*mk - definicao das procedures utilizadas*/

Find First ttWork.

Define Input parameter IDttwm-box          As Rowid No-undo.
Define Input parameter IDttwm-box-movto    As Rowid No-undo.
Define Input parameter IDbttwm-box-movto   As Rowid No-undo.
Define Input parameter IDttwm-docto-itens  As Rowid No-undo.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-picking-wms-table                        .
DEFINE OUTPUT PARAM    p-completo          AS LOG   NO-UNDO.

/*fk - opcao do tipo de leitura. Esse valor vem da bc9018h.p*/
DEFINE NEW GLOBAL SHARED VARIABLE iIndTipoLeitura   AS INTEGER NO-UNDO. 
DEFINE NEW GLOBAL SHARED VARIABLE iIndTipoVisualiza AS INTEGER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gIdEtiquetaUni    LIKE wms-etiq-packing.val-etiq-packing  NO-UNDO.

DEFINE VARIABLE iLogHabilitaUn AS LOGICAL     NO-UNDO.
DEFINE VARIABLE p-qtd-item     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE p-qtd-caixas   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE p-qtd-unidades AS DECIMAL     NO-UNDO.

Define New Shared Variable wgbosc145 As Widget-handle No-undo. 

DEFINE VARIABLE  c-endereco-entrega AS CHARACTER FORMAT "xxxxxxxxxxxxxxxxx" NO-UNDO.
DEFINE VARIABLE  i-cod-doca         AS INTEGER         NO-UNDO.
DEFINE VARIABLE  de-id-box          LIKE wm-box.id-box NO-UNDO.
DEFINE VARIABLE  de-id-packing      AS INT NO-UNDO.
DEFINE VARIABLE vLogOpcao           AS LOGICAL     NO-UNDO.

DEF VAR i-cont AS INTEGER.

DEFINE BUFFER bfttWm-box-movto-idx-picking FOR ttWm-box-movto-idx-picking.

Find ttwm-box           No-lock Where Rowid(ttwm-box)           = IDttwm-box            No-error.
Find ttWm-box-movto-idx-picking No-lock Where Rowid(ttWm-box-movto-idx-picking)     = IDttwm-box-movto      No-error.
Find bttwm-box-movto    No-lock Where Rowid(bttwm-box-movto)    = IDbttwm-box-movto     No-error.
Find ttwm-docto-itens   No-lock Where Rowid(ttwm-docto-itens)   = IDttwm-docto-itens    No-error.


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
                             ttWork.qtd-item-digit                             At Row 08 Col 05 No-label Format '>>>>>9.9999'
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
                             ttWork.cod-livre-2                                AT ROW 08 COL 15 NO-LABEL FORMAT 'x(4)'
&global-define Frame03Repeat Yes
/* mk fim */


&global-define Frame04Name   Frame04
&global-define Frame04Defs   'Picking WMS'                                     At Row 01 Col 01                         ~
                             'Endereco Doca:     '                             At Row 03 Col 01                         ~
                             c-endereco-entrega                                At Row 04 Col 02 No-label                ~
                             'Area Pack:'                                      At Row 05 Col 01                         ~
                             de-id-packing                                     At Row 05 Col 11 No-label FORMAT '>>>>>9' ~
                             'Doca:'                                           At Row 07 Col 01                         ~
                             de-id-box                                         At Row 08 Col 02 No-label
&global-define Frame04Repeat NO

&global-define Frame05Name   Frame05
&global-define Frame05Defs   'Picking WMS'                                     At Row 01 Col 01                         ~
                             'Endereco Transito: '                             At Row 03 Col 01                         ~
                             c-endereco-entrega                                At Row 04 Col 02 No-label                ~
                             'Id Transito:       '                             At Row 07 Col 01                         ~
                             de-id-box                                         At Row 08 Col 02 No-label 
&global-define Frame05Repeat NO



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
                            ON 'ESC':U OF Frame Frame04 ~
                            DO:                         ~
                                Return 'ESC':U          ~
                            END.                        ~
                            ON 'ESC':U OF Frame Frame05 ~
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

/*****************************************   Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/

/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

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

    /* mk - Verifica o Tipo de Visualiza‡Æo da quantidade - Inicio */
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
                                             INPUT ttWm-box-movto-idx-picking.qtd-item-picking, /*ttWork.qtd-embal-lidas,*/
                                             OUTPUT p-qtd-caixas,
                                             OUTPUT p-qtd-unidades). 

       ASSIGN ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame01Name} = STRING(p-qtd-caixas,">>>>9") + " |" + STRING(p-qtd-unidades).

    END.

    ASSIGN ttWork.qtd-item        = (ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking.
    
    /* mk - Verifica o Tipo de Visualiza‡Æo da quantidade - Fim */

    Assign ttWork.cod-item       :Screen-value In Frame {&Frame01Name} = ttwm-docto-itens.cod-item
           ttWork.num-doca       :Screen-value In Frame {&Frame01Name} = string(ttwm-docto-itens.cod-doca)
           /* mk ttWork.qtd-item       :Screen-value In Frame {&Frame01Name} = String((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking)*/
           ttWork.des-endereco   :Screen-value In Frame {&Frame01Name} =  ttwm-box.cod-bloco            + '/':U + 
                                                                          ttwm-box.cod-rua              + '/':U + 
                                                                          ttwm-box.cod-nivel            + '/':U + 
                                                                          ttwm-box.cod-coluna           + '/':U +
                                                                          If ttwm-box.ind-posicao-box = 1 Then 'E' Else 'D'
           ttWork.num-box-lido   :Screen-value In Frame {&Frame01Name} = String(ttWork.num-box-lido)
           ttWork.num-serial     :Screen-value In Frame {&Frame01Name} = string(ttWork.num-serial)
           /* mk ttWork.qtd-embal-lidas:Screen-value In Frame {&Frame01Name} = String(ttWork.qtd-embal-lidas) */
           ttWork.qtd-item-digit :Screen-value In Frame {&Frame01Name} = String(ttWork.qtd-item-digit)  .

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
            ON END-ERROR OF  ttWork.qtd-item-digit
            DO: 
                ASSIGN ttWork.qtd-item-digit = 0
                    vLogErro = YES.
            END.

            /*  */
            DO ON ENDKEY UNDO, RETURN "ESC":
            UPDATE ttWork.qtd-item-digit WITH FRAME {&Frame01Name} .
            END.
        END.
    END.
    /* fk fim */

End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
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
        {bcp/bc9105.i "601" "Quantidade Inv lida (WMS)"}
        View Frame {&Frame01Name}.
        Pause 0 No-message.
        Return 'NOK':U.*/

    End.


    If  ttWork.qtd-item-digit > vNumItensSerial Then Do:
        Assign vLogErro = Yes.
        If ttWork.num-serial <> 0 Then do:
            {bcp/bc9105.i "602" "Quantidade serial maior que a quantidade necess ria (WMS)"}
        End.
        else do:
            {bcp/bc9105.i "602" "Quantidade informada maior que a quantidade necess ria (WMS)"}
        End.
        View Frame {&Frame01Name}.
        Pause 0 No-message.
        Return 'NOK':U.
    End.

    If  v-log-abre-embalagem  = No And 
        vNumItensSerial   <> ttWork.qtd-item-digit Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "603" "Quantidade Inv lida (WMS)"}
        View Frame {&Frame01Name}.
        Pause 0 No-message.
        Return 'NOK':U.
    End.

    If  v-log-abre-embalagem  = Yes And 
        ttWork.qtd-item-digit > (ttWork.qtd-item - ttWork.qtd-embal-lidas) Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "604" "Quantidade Inv lida (WMS)"}
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

    If ttWork.num-serial <> 0 Then do: /* Apenas para transa‡Æo via seriais */
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
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaTransacao:
    Def Var vNomeUsuario            As Character                No-undo.
    DEF VAR v-detalhe               AS CHARACTER                NO-UNDO.

    DEF VAR l-ult-tar            AS LOGICAL    NO-UNDO.
    DEF BUFFER bfWm-item-embalagem-local    FOR wm-item-embalagem-local.

    Assign vNomeUsuario = ttWork.cod-usuario.
    Assign vLogFinaliza = NO
           vLogSai      = NO.

    FOR EACH tt-erro:
          DELETE tt-erro.
    END.
    FOR EACH tt-trans:
        DELETE tt-trans.
    END.
    ASSIGN v-detalhe = 'Est:':U  + trim(ttWm-box-movto-idx-picking.cod-estabel) + ';':U +
                       'Loc:':U  + trim(ttWm-box-movto-idx-picking.cod-local) + ';':U +
                       'IMo:':U  + trim(string(ttWm-box-movto-idx-picking.id-movto,'>>>>>>>>>9':U)) + ';':U + 
                       'ITM:':U  + trim(string(ttWm-box-movto-idx-picking.ind-tipo-movto, '>9':U)).

    /* cria‡ao da bc-trans */
    CREATE tt-trans.
    ASSIGN tt-trans.cod-versao-integracao = 1
           tt-trans.i-sequen = 1
           tt-trans.cd-trans = 'WMSai001':U
           tt-trans.detalhe = v-detalhe.
           tt-trans.usuario = v_cod_usuar_corren.
           tt-trans.etiqueta = NO.

     HIDE ALL.
     GravaTrans:
     DO TRANSACTION:
         RUN finaliza-picking IN wgbc9018f (INPUT TABLE tt-trans, OUTPUT TABLE tt-erro).
         find first tt-erro no-error.
         if  avail tt-erro THEN DO: 
            FOR EACH tt-erro:
                ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
                {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
                 Assign vLogFinaliza = Yes
                        vLogSai      = Yes.
             END.
             If vLogSai = Yes THEN UNDO GravaTrans, LEAVE GravaTrans.
         END.
         ELSE DO:
             RUN picking-pre-api-wms in wgbc9018f (INPUT-OUTPUT TABLE tt-trans, INPUT-OUTPUT TABLE tt-erro).
             find first tt-erro no-error.
             if  avail tt-erro THEN DO: 
                FOR EACH tt-erro:
                    ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
                   {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
                    Assign vLogFinaliza = Yes
                            vLogSai      = Yes.
                END.
                If vLogSai = Yes THEN UNDO GravaTrans, LEAVE GravaTrans.
             END.
             ELSE DO:
                 Find First tt-picking-wms-table  WHERE
                    tt-picking-wms-table.num-serial     = ttWork.num-serial
                    And tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto
                    And tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto
                    And tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item
                    AND tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto 
                    AND tt-picking-wms-table.num-serial     = ttwork.num-serial No-error.

                 /* fk parati: Se ainda tiver pendencias na embalagem, nao elimina a ttWm-box-movto-idx-picking
                    Isso faz com que possibilite ler as etiquetas at‚ preencher a quantidade do movimento */
                 DO:
                     /* Pega a quantidade do que jah foi lido */
                     DEFINE VARIABLE deAuxiliar AS DECIMAL    NO-UNDO.
                     ASSIGN deAuxiliar = (ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking.

                     /* Se a quantidade da etiqueta for menor que a quantidade do movimento, nao elimina a tabela */
                     IF (deAuxiliar - ttWork.qtd-item-digit) = 0 THEN DO:
                         
                         IF AVAILABLE tt-picking-wms-table THEN DO:
                             
                             FIND FIRST wm-item-embalagem-local
                                  WHERE wm-item-embalagem-local.cod-estabel = ttWm-box-movto-idx-picking.cod-estabel
                                    AND wm-item-embalagem-local.cod-local   = ttWm-box-movto-idx-picking.cod-local
                                    AND wm-item-embalagem-local.cod-item    = ttWm-box-movto-idx-picking.cod-item
                                    AND wm-item-embalagem-local.log-padrao  = YES NO-ERROR.
                             IF AVAIL wm-item-embalagem-local AND 
                                CAN-FIND(FIRST wm-docto WHERE
                                         wm-docto.cod-estabel      = ttWm-box-movto-idx-picking.cod-estabel AND
                                         wm-docto.cod-local        = ttWm-box-movto-idx-picking.cod-local   AND
                                         wm-docto.id-docto         = ttWm-box-movto-idx-picking.id-docto    AND
                                         wm-docto.ind-origem-docto = 5                                      NO-LOCK) THEN DO:
                                 RUN pi-cria-etiq-unitizadora IN THIS-PROCEDURE.
                                 /* Se for retirada de pallet completo sera solicitada a leitura da doca / Area de Packing*/
                                 IF wm-item-embalagem-local.qtd-item-emb = ttWm-box-movto-idx-picking.qtd-item-picking THEN DO:
                                    RUN pi-valida-doca(INPUT "P"). /* PALLET */
                                 END.
                                 ELSE DO:
                                     ASSIGN l-ult-tar = YES.
                                     FOR EACH wm-box-movto WHERE
                                             wm-box-movto.cod-estabel      =  ttWm-box-movto-idx-picking.cod-estabel AND
                                             wm-box-movto.cod-local        =  ttWm-box-movto-idx-picking.cod-local   AND
                                             wm-box-movto.id-docto         =  ttWm-box-movto-idx-picking.id-docto    AND
                                             wm-box-movto.ind-status-movto <> 3                                      AND 
                                             wm-box-movto.id-movto         <> ttWm-box-movto-idx-picking.id-movto    NO-LOCK:
                                         IF CAN-FIND(FIRST bfWm-item-embalagem-local
                                              WHERE bfWm-item-embalagem-local.cod-estabel  = wm-box-movto.cod-estabel
                                                AND bfWm-item-embalagem-local.cod-local    = wm-box-movto.cod-local
                                                AND bfWm-item-embalagem-local.cod-item     = wm-box-movto.cod-item
                                                AND bfWm-item-embalagem-local.log-padrao   = YES 
                                                AND bfWm-item-embalagem-local.qtd-item-emb > (wm-box-movto.qtd-item * wm-box-movto.qti-embalagem) NO-LOCK) THEN DO:
                                             ASSIGN l-ult-tar = NO.
                                             LEAVE.
                                         END.
                                     END.
                                     IF l-ult-tar = NO THEN DO:
                                         DO ON ENDKEY UNDO, RETRY:
                                             /* Pergunta se o pallet esta completo, se estiver, solicita leitura da doca / Area de Packing */
                                             DISP 'Pallet est  Cheio?'            At ROW 01 COL 01 
                                                  '1=Sim 2=Nao'                   AT ROW 05 COL 01 WITH FRAME f-conf FONT 2 SIZE 20 BY 8 NO-BOX. 
                                             UPDATE vLogOpcao                     AT ROW 05 COL 13 NO-LABEL FORMAT '1/2':U WITH FRAME f-conf FONT 2 SIZE 20 BY 8. 
                                         END.
                                     END.
                                     ELSE DO:
                                        ASSIGN vLogOpcao = YES.
                                     END.
                                     IF vLogOpcao = YES THEN DO:
                                         IF ((TRUNCATE(ttWm-box-movto-idx-picking.qtd-item-picking,0)) * Wm-item-embalagem-local.qtd-emb-item) = 0 THEN
                                             RUN pi-valida-doca (INPUT "C"). /* Caixas */
                                         ELSE 
                                             RUN pi-valida-doca (INPUT "F"). /* Fracionados */
                                     END.
                                 END.
                                 
                             END.

                             DELETE ttWm-box-movto-idx-picking.
                             {bcp/bc9105.i "901" "Picking executado com Sucesso (DC)"}

                             ASSIGN p-completo = vLogOpcao.
                         END.
                     END.
                     ELSE DO:
                         /* Incrementa a quantidade retirada */
                         ASSIGN ttWm-box-movto-idx-picking.qtd-item-picking = ttWm-box-movto-idx-picking.qtd-item-picking + ttWork.qtd-item-digit.
                     END.
                 END.
                 /* fk fim */

                 /*IF AVAILABLE tt-picking-wms-table THEN  DELETE ttWm-box-movto-idx-picking.*/ /*fk comentado*/
                 HIDE ALL NO-PAUSE.
                 ASSIGN ttWork.qtd-item-digit = 0.
                 ASSIGN vLogEmProcesso = NO
                        vLogSai        = YES
                        vLogFinaliza   = YES.
                 RETURN 'OK':U.
             END.
         END.
     END.

    ASSIGN ttWork.qtd-item-digit                           = 0
           ttWork.qtd-embal-lidas                          = 0
           ttWork.num-serial                               = 0
           ttWork.num-serial:screen-value In Frame Frame01 = '0':U.

    Assign vLogEmProcesso = Yes
           vLogSai        = No
           vLogFinaliza   = No.
    HIDE ALL.
    RETURN 'OK':U.

END PROCEDURE.

PROCEDURE pi-ler-endereco-transito:
    DEFINE INPUT  PARAMETER pc-endereco-entrega AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pde-id-transito     AS DECIMAL    NO-UNDO.
    
    &if '{&mgscm_version}' >= '2.07' &then 
    	ASSIGN c-endereco-entrega:SCREEN-VALUE IN FRAME {&Frame05Name} = pc-endereco-entrega.
    &endif

    /* Segurar o usuario nesta frame ate a leitura da etiqueta do endereco correto */
    REPEAT:
    	&if '{&mgscm_version}' >= '2.07' &then 
            UPDATE de-id-box WITH FRAME {&Frame03Name}.
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

PROCEDURE pi-valida-doca:

    DEFINE INPUT PARAM p-tipo-emb AS CHAR NO-UNDO. /* P = Pallet / C = Caixas / F = Fracionados */

    DEF VAR c-cod-doca      LIKE wm-doca.cod-doca   NO-UNDO.
    DEF VAR i-id-doca       LIKE wm-doca.id-box     NO-UNDO.

    FIND FIRST es-wm-bloco NO-LOCK
         WHERE es-wm-bloco.cod-bloco = ttwm-box.cod-bloco NO-ERROR.

    FIND FIRST wm-docto NO-LOCK
         WHERE wm-docto.cod-estabel = ttWm-box-movto-idx-picking.cod-estabel
           AND wm-docto.cod-local   = ttWm-box-movto-idx-picking.cod-local
           AND wm-docto.id-docto    = ttWm-box-movto-idx-picking.id-docto NO-ERROR.

    IF wm-docto.ind-origem-docto <> 5 THEN LEAVE.

    IF AVAIL wm-docto THEN DO:
        FIND FIRST wm-doca WHERE
            wm-doca.cod-doca = wm-docto.cod-doca NO-LOCK NO-ERROR.
        ASSIGN c-cod-doca = IF AVAIL wm-doca THEN wm-doca.cod-doca ELSE 0
               i-id-doca  = IF AVAIL wm-doca THEN wm-doca.id-box   ELSE 0.
    END.


    IF wm-docto.num-docto MATCHES "*-FRAC" THEN DO:
        REPEAT ON ENDKEY UNDO, RETRY:
            UPDATE de-id-packing WITH FRAME {&Frame04Name}.
            FIND FIRST es-wm-area-packing NO-LOCK
                 WHERE es-wm-area-packing.cod-area-packing = de-id-packing NO-ERROR.
            IF AVAIL es-wm-area-packing THEN DO:
                LEAVE.
            END.
            ELSE DO:
                /* dumke - Validade se nao foi lido um endereco de transito */

                FIND FIRST wm-box WHERE wm-box.id-box = de-id-packing
                    NO-LOCK NO-ERROR.

                IF NOT AVAIL wm-box THEN DO:
                   {bcp/bc9105.i "000" "Area de Packing incorreta (DC)"}
                END.
                ELSE DO:
                   IF wm-box.cdn-tipo-box = 7 THEN DO:
                       FIND FIRST wms-etiq-packing WHERE wms-etiq-packing.val-etiq-packing = gIdEtiquetaUni
                            NO-LOCK NO-ERROR.
                       CREATE wms-box-packing.
                       ASSIGN wms-box-packing.cod-local        = wms-etiq-packing.cod-local
                              wms-box-packing.cod-estabel      = wms-etiq-packing.cod-estabel
                              wms-box-packing.cdd-embarq       = wms-etiq-packing.cdd-embarq
                              wms-box-packing.dat-armaz        = TODAY
                              wms-box-packing.cod-usuar-armaz  = c-seg-usuario
                              wms-box-packing.num-hora-armaz   = TIME
                              wms-box-packing.nr-pedcli        = wms-etiq-packing.nr-pedcli
                              wms-box-packing.nr-resumo        = wms-etiq-packing.nr-resumo
                              wms-box-packing.nr-embarque      = wms-etiq-packing.nr-embarque
                              wms-box-packing.nome-abrev       = wms-etiq-packing.nome-abrev
                              wms-box-packing.id-box           = de-id-packing
                              wms-box-packing.val-etiq-packing = wms-etiq-packing.val-etiq-packing
                              wms-box-packing.cod-livre-1      = p-tipo-emb
                              wms-box-packing.cod-livre-2      = "Area Packing"
                              wms-box-packing.val-livre-1      = 0
                              wms-box-packing.val-livre-2      = ttWm-box-movto-idx-picking.id-movto
                              .

                       RUN wmp/wm9040.p (INPUT  wms-box-packing.cod-estabel,
                                         INPUT  wms-box-packing.cod-local,
                                         INPUT  ttWm-box-movto-idx-picking.id-movto,
                                         INPUT  2, /* sa­da */
                                         INPUT  101,
                                         OUTPUT TABLE RowErrors).  

                       IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                           {bcp/bc9105.i "000" "Area de Packing incorreta (DC)"}
                       END.
                       ELSE DO:
                           LEAVE.
                       END.
                   END.
                   ELSE DO:
                      {bcp/bc9105.i "000" "Area de Packing incorreta (DC)"}
                   END.
                END.
            END.
        END.
    END.
    ELSE DO:    
        /* Segurar o usuario nesta frame ate a leitura da etiqueta do endereco correto */
        REPEAT ON ENDKEY UNDO, RETRY:
            
            IF es-wm-bloco.pallet-fechado = 1 THEN DO:
                FIND FIRST wm-doca WHERE wm-doca.cod-doca = c-cod-doca NO-LOCK NO-ERROR.
                c-endereco-entrega = trim(string(wm-doca.cod-doca)) + " " + trim(wm-doca.des-doca).
                DISP c-endereco-entrega WITH FRAME {&Frame04Name}.

                /*DISP c-cod-doca @ c-endereco-entrega WITH FRAME {&Frame04Name}.*/
                UPDATE de-id-box WITH FRAME {&Frame04Name}.
                IF i-id-doca = de-id-box THEN DO:
                    LEAVE.
                END.
                ELSE DO:
                    /* dumke - Validade se nao foi lido um endereco de transito */

                    FIND FIRST wm-box WHERE wm-box.id-box = de-id-box
                        NO-LOCK NO-ERROR.

                    IF NOT AVAIL wm-box THEN DO:
                       {bcp/bc9105.i "000" "Doca incorreta (DC)"}
                    END.
                    ELSE DO:
                       IF wm-box.cdn-tipo-box = 7 THEN DO:
                           FIND FIRST wms-etiq-packing WHERE wms-etiq-packing.val-etiq-packing = gIdEtiquetaUni
                                NO-LOCK NO-ERROR.
                           CREATE wms-box-packing.
                           ASSIGN wms-box-packing.cod-local        = wms-etiq-packing.cod-local
                                  wms-box-packing.cod-estabel      = wms-etiq-packing.cod-estabel
                                  wms-box-packing.cdd-embarq       = wms-etiq-packing.cdd-embarq
                                  wms-box-packing.dat-armaz        = TODAY
                                  wms-box-packing.cod-usuar-armaz  = c-seg-usuario
                                  wms-box-packing.num-hora-armaz   = TIME
                                  wms-box-packing.nr-pedcli        = wms-etiq-packing.nr-pedcli
                                  wms-box-packing.nr-resumo        = wms-etiq-packing.nr-resumo
                                  wms-box-packing.nr-embarque      = wms-etiq-packing.nr-embarque
                                  wms-box-packing.nome-abrev       = wms-etiq-packing.nome-abrev
                                  wms-box-packing.id-box           = de-id-box
                                  wms-box-packing.val-etiq-packing = wms-etiq-packing.val-etiq-packing
                                  wms-box-packing.cod-livre-1      = p-tipo-emb
                                  wms-box-packing.cod-livre-2      = "Doca"
                                  wms-box-packing.val-livre-1      = i-id-doca
                                  wms-box-packing.val-livre-2      = ttWm-box-movto-idx-picking.id-movto
                               .

                           RUN wmp/wm9040.p (INPUT  wms-box-packing.cod-estabel,
                                             INPUT  wms-box-packing.cod-local,
                                             INPUT  ttWm-box-movto-idx-picking.id-movto,
                                             INPUT  2, /* sa­da */
                                             INPUT  101,
                                             OUTPUT TABLE RowErrors).  

                           IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                               {bcp/bc9105.i "000" "Doca incorreta (DC)"}
                           END.
                           ELSE DO:
                               LEAVE.
                           END.
                       END.
                       ELSE DO:
                          {bcp/bc9105.i "000" "Doca incorreta (DC)"}
                       END.
                    END.
                END.
            END.
            ELSE DO:
                UPDATE de-id-packing WITH FRAME {&Frame04Name}.
                FIND FIRST es-wm-area-packing NO-LOCK
                     WHERE es-wm-area-packing.cod-area-packing = de-id-packing NO-ERROR.
                IF AVAIL es-wm-area-packing THEN DO:
                    LEAVE.
                END.
                ELSE DO:
                    /* dumke - Validade se nao foi lido um endereco de transito */

                    FIND FIRST wm-box WHERE wm-box.id-box = de-id-packing
                        NO-LOCK NO-ERROR.

                    IF NOT AVAIL wm-box THEN DO:
                       {bcp/bc9105.i "000" "Area de Packing incorreta (DC)"}
                    END.
                    ELSE DO:
                       IF wm-box.cdn-tipo-box = 7 THEN DO:
                           FIND FIRST wms-etiq-packing WHERE wms-etiq-packing.val-etiq-packing = gIdEtiquetaUni
                                NO-LOCK NO-ERROR.
                           CREATE wms-box-packing.
                           ASSIGN wms-box-packing.cod-local        = wms-etiq-packing.cod-local
                                  wms-box-packing.cod-estabel      = wms-etiq-packing.cod-estabel
                                  wms-box-packing.cdd-embarq       = wms-etiq-packing.cdd-embarq
                                  wms-box-packing.dat-armaz        = TODAY
                                  wms-box-packing.cod-usuar-armaz  = c-seg-usuario
                                  wms-box-packing.num-hora-armaz   = TIME
                                  wms-box-packing.nr-pedcli        = wms-etiq-packing.nr-pedcli
                                  wms-box-packing.nr-resumo        = wms-etiq-packing.nr-resumo
                                  wms-box-packing.nr-embarque      = wms-etiq-packing.nr-embarque
                                  wms-box-packing.nome-abrev       = wms-etiq-packing.nome-abrev
                                  wms-box-packing.id-box           = de-id-packing
                                  wms-box-packing.val-etiq-packing = wms-etiq-packing.val-etiq-packing
                                  wms-box-packing.cod-livre-1      = p-tipo-emb
                                  wms-box-packing.cod-livre-2      = "Area Packing"
                                  wms-box-packing.val-livre-1      = 0
                                  wms-box-packing.val-livre-2      = ttWm-box-movto-idx-picking.id-movto
                                  .

                           RUN wmp/wm9040.p (INPUT  wms-box-packing.cod-estabel,
                                             INPUT  wms-box-packing.cod-local,
                                             INPUT  ttWm-box-movto-idx-picking.id-movto,
                                             INPUT  2, /* sa­da */
                                             INPUT  101,
                                             OUTPUT TABLE RowErrors).  

                           IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                               {bcp/bc9105.i "000" "Area de Packing incorreta (DC)"}
                           END.
                           ELSE DO:
                               LEAVE.
                           END.
                       END.
                       ELSE DO:
                          {bcp/bc9105.i "000" "Area de Packing incorreta (DC)"}
                       END.
                    END.
                END.
            END.
       END.
    END.
END PROCEDURE.

PROCEDURE pi-valida-area-packing:

    /* Segurar o usuario nesta frame ate a leitura da etiqueta do endereco correto */
    REPEAT:
        UPDATE de-id-box WITH FRAME {&Frame04Name}.

        FIND FIRST wm-docto NO-LOCK
             WHERE wm-docto.cod-estabel = ttWm-box-movto-idx-picking.cod-estabel
               AND wm-docto.cod-local   = ttWm-box-movto-idx-picking.cod-local
               AND wm-docto.id-docto    = ttWm-box-movto-idx-picking.id-docto NO-ERROR.
        IF AVAIL wm-docto AND wm-docto.cod-doca = de-id-box THEN DO:
            LEAVE.
        END.
        ELSE DO:
            {bcp/bc9105.i "000" "µrea de Packing incorreta (DC)"}
        END.
    END.
END.

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
    ASSIGN ttwork.qtd-item-digit = 0.

    /* Faz a leitura at‚ a qtd de itens for igual a qtd da etiqueta */
    REPEAT:
        /* Busca o valor do codigo ean/dun da tela */
        DISP ttWork.cod-item /*ttWork.qtd-item*/ ttWork.des-endereco              
            /*ttWork.qtd-embal-lidas*/ ttWork.num-doca ttWork.num-box-lido              
            ttWork.num-serial ttWork.cod-livre-1 WITH  FRAME {&Frame02Name}.

        /* mk - Verifica o Tipo de Visualiza‡Æo da quantidade - Inicio */
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

        /* Verifica se o item do codigo ean/dun eh o mesmo item do serial */
        IF cCodItem <> ttwork.cod-item THEN DO:
            {bcp/bc9105.i "0" "Item do codigo ean/dun lido nÆo confere com o item do c¢digo serial (DC)"}
            NEXT.
        END.

        IF (ttwork.qtd-item-digit + deQtdInformacao) > ((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking) THEN DO:
           {bcp/bc9105.i "0" "Quantidade lida maior que a quantidade necessaria. (DC)"}
           NEXT.
        END.

        /* Verifica se a embalagem do codigo lido eh a mesma do serial*/
        /*IF cCodEmbalagem <> ttwork.cod-embalagem THEN DO:
            {bcp/bc9105.i "0" "Embalagem do codigo ean/dun lido nÆo confere com a embalagem do c¢digo serial (DC)"}
            NEXT.
        END.*/
        If  ttWork.qtd-item-digit + deQtdInformacao > vNumItensSerial Then Do:
            {bcp/bc9105.i "602" "Quantidade lida maior que a quantidade do Serial (WMS)"}
            NEXT.
        End.
        /* Incrementa a qtd de item digitado para os dois campos em tela  */
        ASSIGN ttwork.qtd-item-digit = ttwork.qtd-item-digit + deQtdInformacao
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

    /* Faz a leitura at‚ a qtd de itens for igual a qtd da etiqueta */
    DO ON ENDKEY UNDO, RETURN "ESC":
    REPEAT:
        /* Busca o valor do codigo emb~\un da tela */
        DISP ttWork.cod-item /*mk ttWork.qtd-item*/ ttWork.cod-livre-3  ttWork.des-endereco              
            /* mk ttWork.qtd-embal-lidas*/ ttWork.cod-livre-4  ttWork.num-doca ttWork.num-box-lido              
            ttWork.num-serial WITH  FRAME {&Frame03Name}.

        /* mk - Verifica o Tipo de Visualiza‡Æo da quantidade - Inicio */
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

    /* Se nÆo achar o parametro, assume o valor 1 - Habilita Unidade */
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

PROCEDURE pi-cria-etiq-unitizadora:

    DEF VAR d-cdd-embarq       LIKE embarque.cdd-embarq    NO-UNDO.

    FIND FIRST wm-tarefa-docto-itens NO-LOCK
         WHERE wm-tarefa-docto-itens.cod-estabel = ttWm-box-movto-idx-picking.cod-estabel
           AND wm-tarefa-docto-itens.cod-local   = ttWm-box-movto-idx-picking.cod-local     
           AND wm-tarefa-docto-itens.id-movto    = ttWm-box-movto-idx-picking.id-movto  NO-ERROR.
    IF AVAIL wm-tarefa-docto-itens THEN DO:
        FIND FIRST wm-docto NO-LOCK
             WHERE wm-docto.id-docto = ttWm-box-movto-idx-picking.id-docto NO-ERROR.
        FIND FIRST es-wm-box-movto-etiq EXCLUSIVE-LOCK
             WHERE es-wm-box-movto-etiq.val-etiq-separacao = gIdEtiquetaUni
               AND es-wm-box-movto-etiq.cod-estabel        = ttWm-box-movto-idx-picking.cod-estabel
               AND es-wm-box-movto-etiq.cod-local          = ttWm-box-movto-idx-picking.cod-local
               AND es-wm-box-movto-etiq.id-movto           = ttWm-box-movto-idx-picking.id-movto
               AND es-wm-box-movto-etiq.id-tarefa          = wm-tarefa-docto-itens.id-tarefa NO-ERROR.
        IF NOT AVAIL es-wm-box-movto-etiq THEN DO:
            /* tabela filha */
            CREATE es-wm-box-movto-etiq.
            ASSIGN es-wm-box-movto-etiq.val-etiq-separacao = gIdEtiquetaUni
                   es-wm-box-movto-etiq.cod-estabel        = ttWm-box-movto-idx-picking.cod-estabel
                   es-wm-box-movto-etiq.cod-local          = ttWm-box-movto-idx-picking.cod-local
                   es-wm-box-movto-etiq.id-movto           = ttWm-box-movto-idx-picking.id-movto
                   es-wm-box-movto-etiq.id-tarefa          = wm-tarefa-docto-itens.id-tarefa
                   es-wm-box-movto-etiq.id-docto           = ttWm-box-movto-idx-picking.id-docto
                   es-wm-box-movto-etiq.id-box             = ttWm-box-movto-idx-picking.id-box.
    
            FIND FIRST wms-etiq-packing NO-LOCK
                 WHERE wms-etiq-packing.val-etiq-packing = gIdEtiquetaUni NO-ERROR.
            IF NOT AVAIL wms-etiq-packing OR 
               wms-etiq-packing.nr-pedcli = "" THEN DO:

                FIND FIRST wm-docto-itens-ped WHERE
                    wm-docto-itens-ped.cod-estabel  = ttWm-box-movto-idx-picking.cod-estabel  AND
                    wm-docto-itens-ped.cod-local    = ttWm-box-movto-idx-picking.cod-local    AND
                    wm-docto-itens-ped.id-docto     = ttWm-box-movto-idx-picking.id-docto     AND
                    wm-docto-itens-ped.num-seq-item = ttWm-box-movto-idx-picking.num-seq-item NO-LOCK NO-ERROR.

                ASSIGN d-cdd-embarq = IF AVAIL wm-docto AND wm-docto.ind-origem-docto = 5 THEN DEC(ENTRY(1,ENTRY(1,wm-docto.num-docto-origem,"|"),"-")) ELSE 0.

                /* Criar tabela wms-etiq-packing */
                IF NOT AVAIL wms-etiq-packing THEN
                    CREATE wms-etiq-packing.
                ELSE FIND CURRENT wms-etiq-packing EXCLUSIVE-LOCK NO-ERROR.
                ASSIGN wms-etiq-packing.cod-embalagem          = ttWm-box-movto-idx-picking.cod-embalagem
                       wms-etiq-packing.cod-estabel            = ttWm-box-movto-idx-picking.cod-estabel
                       wms-etiq-packing.cod-local              = ttWm-box-movto-idx-picking.cod-local
                       wms-etiq-packing.cod-usuar-leitura      = ttWork.cod-usuario
                       wms-etiq-packing.cod-usuario            = ttWork.cod-usuario
                       wms-etiq-packing.cod-usuario-ult-acesso = ttWork.cod-usuario
                       wms-etiq-packing.dt-geracao             = TODAY
                       wms-etiq-packing.dt-leitura             = TODAY
                       wms-etiq-packing.dt-ult-acesso          = TODAY
                       wms-etiq-packing.hra-gerac              = REPLACE(STRING(TIME,"hh:mm:ss"),":","")
                       wms-etiq-packing.hra-ult-aces           = ""
                       wms-etiq-packing.idi-tip-gerac          = 2 /* 1 Manual | 2 Sistema */
                       wms-etiq-packing.log-bloqdo             = NO
                       wms-etiq-packing.log-confer             = NO
                       wms-etiq-packing.log-efetua-packing     = NO
                       wms-etiq-packing.log-embcado            = NO
                       wms-etiq-packing.log-impressa           = NO
                       wms-etiq-packing.log-inutzado           = NO
                       wms-etiq-packing.nome-abrev             = IF AVAIL wm-docto-itens-ped THEN wm-docto-itens-ped.nome-abrev  ELSE (IF AVAIL wm-docto AND wm-docto.ind-origem-docto = 5 THEN ENTRY(2,wm-docto.num-docto-origem,"|") ELSE "")
                       wms-etiq-packing.cdd-embarq             = IF AVAIL wm-docto-itens-ped THEN wm-docto-itens-ped.cdd-embarq  ELSE d-cdd-embarq
                       wms-etiq-packing.nr-embarque            = IF AVAIL wm-docto-itens-ped THEN wm-docto-itens-ped.nr-embarque ELSE INT(d-cdd-embarq)
                       wms-etiq-packing.nr-pedcli              = IF AVAIL wm-docto-itens-ped THEN wm-docto-itens-ped.nr-pedcli   ELSE (IF AVAIL wm-docto THEN wm-docto.num-docto ELSE "")
                       wms-etiq-packing.nr-pedido              = IF AVAIL wm-docto-itens-ped THEN wm-docto-itens-ped.nr-pedido   ELSE 0
                       wms-etiq-packing.nr-resumo              = IF AVAIL wm-docto-itens-ped THEN wm-docto-itens-ped.nr-resumo   ELSE 0
                       wms-etiq-packing.num-volume             = 0
                       wms-etiq-packing.val-etiq-packing       = gIdEtiquetaUni.
            END.
        END.
    END.
    ELSE DO:
        {bcp/bc9105.i "901" "Tarefa nao Encontrada. (DC)"}
    END.
    
END PROCEDURE.

/*************************************  Codigo do Usuario Fim   **********************************/

&else 
    run utp/ut-msgs.p (input "show":U, 
                       input 28036,
                       INPUT "").
&endif
                             
