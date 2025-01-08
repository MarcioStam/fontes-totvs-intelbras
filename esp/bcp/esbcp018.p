/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESBCP018 2.00.00.015 } /*** 010015 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESBCP018 MBC}
&ENDIF

/* Alterado por Amarildo Gambeta
Substitu¡da a chamada do m‚todo "getLocalizacaoEtiqueta" da BO "bosc112.p" 
pelo m‚todo "getSerialAdrress" da BO "BOSC074" (conforme orientado pela  rea 
de neg¢cio na FO 1.363.764) para busca do endere‡o correto de armazenamento 
da etiqueta. 
** FOI ALTERADA A DOCUMENTA€ÇO DO PRODUTO PARA CONTEMPLAR A NOVA FORMA DE CONSULTA (SEM STATUS E SOMENTE AS ETIQUETAS ARMAZENADAS) - 
Definido em conjunto com a equipe de servi‡os e Desenvolviemnto.
*/

{include/i_dbinst.i}  /* versao das bases e bases instaladas */

/* Definicao global do nome da transacao ---                */
&global-define ProgramName ESBCP018
/************************************************************/

{utp/utapi009.i} /* login */
/* Definicao da temp-table de integracao ---                */
{esp/bcp/esbcp018.i}
{bcp/bc9048.i1} /* definicao variaveis menu padrao */
&global-define TempTable tt-consulta

DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.

Define Temp-table ttWork No-Undo like {&TempTable}.
Create ttWork.
Define Temp-table RowErrors No-undo 
    Field ErrorSequence    As Integer 
    Field ErrorNumber      As Integer 
    Field ErrorDescription As Character 
    Field ErrorParameters  As Character 
    Field ErrorType        As Character 
    Field ErrorHelp        As Character 
    Field ErrorSubType     As Character.

DEF TEMP-TABLE tt-ord-prod
    FIELD nr-ord-prod LIKE ord-prod.nr-ord-prod
    FIELD it-codigo   LIKE ord-prod.it-codigo
    INDEX ordem nr-ord-prod.

Define Query qry-ord-prod For tt-ord-prod.

Define Browse brw-ord-prod Query qry-ord-prod No-lock
    DISPLAY tt-ord-prod.nr-ord-prod
        With No-box No-labels Size 20 By 5 No-scrollbar-vertical.

DEFINE TEMP-TABLE tt-item
    FIELD it-codigo AS CHAR FORMAT "x(16)"
    FIELD seq-item  AS INT FORMAT "99"
    FIELD log-lido  AS LOG.

Define Variable vItCodigo       As Character Format 'x(16)':U   Init ''  No-undo.
Define Variable vDesItem        As Character Format 'x(18)':U   Init ''  No-undo.
DEFINE VARIABLE l-voltar        AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-cont-item     AS INTEGER FORMAT "99"    NO-UNDO.
DEFINE VARIABLE l-continua      AS LOGICAL     NO-UNDO INITIAL YES.

/************************************************************/

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Rastreabilidade     '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Linha:              '                             At Row 03 Col 01          ~
                             ttWork.nr-linha                                    At Row 03 Col 08 NO-LABEL 
&global-define Frame01Repeat NO

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Rastreabilidade     '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Linha:              '                             At Row 03 Col 01          ~
                             ttWork.nr-linha                                    At Row 03 Col 08 NO-LABEL ~
                             'OP:                 '                             At Row 04 Col 01          ~
                             ttWork.nr-ord-prod                                 At Row 04 Col 04 NO-LABEL
&global-define Frame02Repeat NO

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Rastreabilidade     '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Linha:              '                             At Row 03 Col 01          ~
                             ttWork.nr-linha                                    At Row 03 Col 08 NO-LABEL ~
                             'OP:                 '                             At Row 04 Col 01          ~
                             ttWork.nr-ord-prod                                 At Row 04 Col 04 NO-LABEL ~
                             'Item:'                                            At Row 05 Col 01          ~
                             tt-item.it-codigo                                  At Row 05 Col 06 No-Label VIEW-AS FILL-IN SIZE 8 BY 0.88 ~
                             'ID:                 '                             At Row 06 Col 01          ~
                             ttWork.num-serial                                  At Row 06 Col 04 NO-LABEL VIEW-AS FILL-IN SIZE 16 BY 0.88 ~
                             'Item '                                            At Row 08 Col 01          ~
                              tt-item.seq-item                                  At Row 08 Col 06 NO-LABEL ~
                             ' de '                                             At Row 08 Col 09          ~
                             i-cont-item                                        At Row 08 Col 13 NO-LABEL VIEW-AS FILL-IN SIZE 3 BY 0.88 ~
&global-define Frame03Repeat YES

/* Definicao da Frame05 ---                                 */
&global-define Frame05Name   Frame05
&global-define Frame05Defs   'Rastreabilidade    '                              At Row 01 Col 01          ~
                             brw-ord-prod                                       At Row 02 Col 01          ~
                             vItCodigo                                          At Row 07 Col 01 No-label ~
                             vDesItem                                           At Row 08 Col 01 No-label ~
&global-define Frame05Repeat NO
/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.nr-linha
&global-define Update02Fields ttWork.nr-ord-prod
&global-define Update03Fields ttWork.num-serial

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. IF l-voltar THEN LEAVE _Frame02. 
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03. IF l-voltar THEN LEAVE _Frame03. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. IF l-voltar THEN LEAVE _Frame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. IF l-voltar THEN LEAVE _Frame02. 
&global-define TriggerAfterFrame03  Run GravaCamposFrame03. IF l-voltar THEN LEAVE _Frame03. 

/* Definicao das trigger de usuario ---                     */
&global-define UserTriggers ON 'Return':U        OF brw-ord-prod In Frame {&Frame05Name}                   ~
                            DO:                                                                            ~
                               Apply 'Go':U To This-procedure.                                             ~
                            END.                                                                           ~
                            ON 'ESC':U OF Frame Frame05                                                    ~
                            DO:                                                                            ~
                                Return 'ESC'.                                                              ~
                            END.                                                                           ~
                            ON 'value-changed':U OF brw-ord-prod In Frame {&Frame05Name}                   ~
                            DO:                                                                            ~
                                ASSIGN vItCodigo:SCREEN-VALUE IN FRAME Frame05 = tt-ord-prod.it-codigo.    ~
                                FIND FIRST ITEM NO-LOCK                                                    ~
                                     WHERE ITEM.it-codigo = tt-ord-prod.it-codigo NO-ERROR.                ~
                                IF AVAIL ITEM THEN                                                         ~
                                    ASSIGN vDesItem:SCREEN-VALUE IN FRAME Frame05 = ITEM.desc-item.        ~
                                ELSE                                                                       ~
                                    ASSIGN vDesItem:SCREEN-VALUE IN FRAME Frame05 = "".                    ~
                            END.                                                                           ~
                            ON 'Return':U OF brw-ord-prod In Frame {&Frame05Name}                          ~
                            DO:                                                                            ~
                               ASSIGN ttWork.nr-ord-prod = tt-ord-prod.nr-ord-prod.                        ~
                               Apply 'Go':U To This-procedure.                                             ~
                            END.                                                                           ~
                            ON 'ESC':U OF Frame Frame03                                                    ~
                            DO:                                                                            ~
                                Return 'ESC'.                                                              ~
                            END.                                                                           ~
                            ON 'ESC':U OF ttWork.num-serial IN FRAME frame03                               ~
                            DO:                                                                            ~
                                RETURN 'ESC'.                                                              ~
                            END.                                                                           ~

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgBOSC092
&global-define ActiveObject2 wgBOSC079

/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

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
** Esta procedure esta inicializando o campo tipo-trans da tela Frame01 com o valor 1             **
** Os outros campos nao estao sendo inicializados pois os mesmos devem apresentar valor           **
** caso seja retornado a proxima tela para esta.                                                  **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame05 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame05}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame01:   

    ASSIGN vLogErro          = NO
           vLogsai           = NO
           vLogfinaliza      = NO
           l-voltar          = NO.

    Assign ttWork.nr-linha    = 0
           ttWork.nr-ord-prod = 0.

    Disp ttWork.nr-linha
         With Frame Frame01.
End Procedure.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame05 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame05}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame02:  

    EMPTY TEMP-TABLE tt-item.

    ASSIGN vLogErro          = NO
           vLogsai           = NO
           vLogfinaliza      = NO.

    Assign ttWork.nr-ord-prod   = 0.

    Disp ttWork.nr-linha
         ttWork.nr-ord-prod
         With Frame Frame02.
End Procedure.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame05 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame05}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame03:

    ASSIGN vLogErro          = NO
           vLogsai           = NO
           vLogfinaliza      = NO
           ttWork.num-serial = ''.

    IF NOT AVAIL tt-item THEN DO:
        RUN piCarregaItensReserva.
    END.

    DISP ttWork.nr-linha
         ttWork.nr-ord-prod
         ttWork.num-serial
        With Frame Frame03.

    FOR FIRST tt-item
        WHERE tt-item.log-lido = NO
           BY tt-item.seq-item:

        DISP tt-item.it-codigo
             tt-item.seq-item
             i-cont-item
            With Frame Frame03.
    END.

    RETURN "OK".

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:

    ASSIGN vLogErro     = NO
           vLogsai      = NO
           vLogfinaliza = NO.

    If  ttWork.nr-linha = 0 Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "208" "Linha Inv lida (DC)"}
        Return Error.
    End.

    FIND FIRST lin-prod
         WHERE lin-prod.nr-linha = ttWork.nr-linha NO-LOCK NO-ERROR.
    IF NOT AVAIL lin-prod THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "209" "Linha de Produ‡Æo inexistente"}
        Return Error.
    END.
    
    RETURN 'OK':U.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame02:

    ASSIGN vLogErro     = NO
           vLogsai      = NO
           vLogfinaliza = NO.

    If  ttWork.nr-ord-prod <> 0 Then Do:
        FIND FIRST ord-prod
             WHERE ord-prod.nr-ord-prod = ttWork.nr-ord-prod
               AND ord-prod.nr-linha    = ttWork.nr-linha
               AND ord-prod.estado      < 7 /* Iniciada */ NO-LOCK NO-ERROR.
        IF NOT AVAIL ord-prod THEN DO:
            Assign vLogErro = Yes.
            {bcp/bc9105.i "210" "Ordem de Produ‡Æo Inv lida"}
            Return Error.
        END.
    END.
    ELSE DO:

        ON 'End-Error':U OF brw-ord-prod In Frame {&Frame05Name}
        DO:
            Assign vLogErro = Yes.
            UNDO,RETRY.
        END.

        RUN piBuscaOrdens.
    
        FIND FIRST tt-ord-prod NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-ord-prod THEN DO:
           CREATE tt-ord-prod.
           ASSIGN tt-ord-prod.nr-ord-prod = 0
                  tt-ord-prod.it-codigo   = 'Sem Ordens.'.
           IF NOT AVAIL ord-prod THEN DO:
                Assign vLogErro = Yes.
                {bcp/bc9105.i "210" "Sem ordens para listar"}
                Return Error.
            END.
        END.
    
        VIEW FRAME Frame05.
        Open Query qry-ord-prod For Each tt-ord-prod
                                      By tt-ord-prod.nr-ord-prod.
        BROWSE brw-ord-prod:REFRESH() NO-ERROR.
        UPDATE brw-ord-prod WITH FRAME {&Frame05Name}.
        ASSIGN ttWork.nr-ord-prod = tt-ord-prod.nr-ord-prod.
        Apply 'value-changed':U To brw-ord-prod In Frame {&Frame05Name}.

    END.
    
    RETURN 'OK':U.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame03:

    if return-value = "ESC" then return return-value.  /* Realizando tratamento do ESC */

    ASSIGN vLogErro     = NO
           vLogsai      = NO
           vLogfinaliza = NO
           l-voltar     = NO.

    FIND FIRST wm-etiqueta NO-LOCK
         WHERE wm-etiqueta.id-etiqueta = DECIMAL(ttWork.num-serial) NO-ERROR.
    IF AVAIL wm-etiqueta THEN DO:
        IF wm-etiqueta.cod-item <> tt-item.it-codigo:SCREEN-VALUE IN FRAME Frame03 THEN DO:
            ASSIGN vLogErro = Yes.
            {bcp/bc9105.i "211" "Item diferente da etiqueta informada"}
            RETURN ERROR.
        END.
    END.
    ELSE DO:
        // Atualiza pelo valor informado
        DISP 'Deseja atualizar ' AT ROW 01 COL 01 ~ 
             'o lote com       ' AT ROW 02 COL 01   ~
             STRING(ttWork.num-serial)  AT ROW 03 COL 01 NO-LABEL VIEW-AS FILL-IN SIZE 16 BY 0.88 ~
             '1=Sim 2=NÆo' AT ROW 04 COL 01 WITH FRAME f-conf FONT 2 SIZE 20 BY 8 NO-BOX. ~
        UPDATE l-continua AT ROW 04 COL 13 NO-LABEL FORMAT '1/2':U WITH FRAME f-conf FONT 2 SIZE 20 BY 8. ~
        IF NOT l-continua THEN
            Return Error.
    END.

    FIND FIRST reservas EXCLUSIVE-LOCK
         WHERE reservas.nr-ord-produ = ttWork.nr-ord-prod
           AND reservas.it-codigo    = tt-item.it-codigo:SCREEN-VALUE IN FRAME frame03 NO-ERROR.
    IF NOT AVAIL reservas THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "212" "Item nÆo encontrado na reserva"}
        Return Error.
    END.

    // Verifica se lote existe
    IF NOT AVAIL wm-etiqueta THEN DO:
        FIND FIRST saldo-estoq NO-LOCK
             WHERE saldo-estoq.cod-estabel = "111"
               AND saldo-estoq.cod-depos   = "PRO"
               AND saldo-estoq.it-codigo   = reservas.it-codigo
               AND saldo-estoq.lote        = string(ttWork.num-serial) NO-ERROR.
        IF NOT AVAIL saldo-estoq THEN DO:
            Assign vLogErro = Yes.
            {bcp/bc9105.i "213" "Lote nÆo existente"}
            Return Error.

        END.
    END.

    ASSIGN reserva.lote = IF AVAIL wm-etiqueta THEN wm-etiqueta.cod-lote ELSE string(ttWork.num-serial).

    FOR FIRST tt-item
        WHERE tt-item.it-codigo = reservas.it-codigo
          AND tt-item.log-lido  = NO
           BY tt-item.seq-item:

        ASSIGN tt-item.log-lido = YES.

    END.

    RELEASE reserva NO-ERROR.

    RUN bcp/bc9115.p ("0", "Lote atualizado com sucesso.",8,20,3).

    IF INPUT FRAME Frame03 tt-item.seq-item = i-cont-item THEN DO:

        ASSIGN l-voltar  = YES.

    END.
    
    RETURN 'OK':U.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame05}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame05:

    ASSIGN vLogErro     = NO
           vLogsai      = NO
           vLogfinaliza = NO.
    
    RETURN 'OK':U.

END PROCEDURE.

PROCEDURE piBuscaOrdens:

    FOR EACH tt-ord-prod:
        DELETE tt-ord-prod.
    END.

    FOR EACH ord-prod USE-INDEX linha NO-LOCK
       WHERE ord-prod.nr-linha = ttWork.nr-linha 
         AND ord-prod.estado   < 7 :
    
        FIND FIRST tt-ord-prod
             WHERE tt-ord-prod.nr-ord-prod = ord-prod.nr-ord-prod NO-ERROR.
        IF NOT AVAIL tt-ord-prod THEN DO:
            CREATE tt-ord-prod.
            ASSIGN tt-ord-prod.nr-ord-prod = ord-prod.nr-ord-prod
                   tt-ord-prod.it-codigo   = ord-prod.it-codigo.
        END.
    END.

    RETURN "OK".

END PROCEDURE.

PROCEDURE piCarregaItensReserva:

    ASSIGN i-cont-item = 0.

    FOR EACH reservas NO-LOCK
       WHERE reservas.nr-ord-prod = ttWork.nr-ord-prod:

        ASSIGN i-cont-item = i-cont-item + 1.

        CREATE tt-item.
        ASSIGN tt-item.it-codigo = reservas.it-codigo
               tt-item.seq-item  = i-cont-item.
        
    END.

    RETURN "OK".
END.
