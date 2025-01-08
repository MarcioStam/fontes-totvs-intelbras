/********************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
define buffer empresa for mgcad.empresa.
{include/i-prgvrs.i ESBC9030 2.00.00.000 } /*** 010013 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BC9029 MBC}
&ENDIF

{include/i_dbvers.i}  /* versao das bases e bases instaladas */

/********************************************************************************************
**   Programa..: ESBC9030.p                                                                **
**                                                                                         **
**   Versao....: 2.00.00.000 - Maio/2021 - Nicol s Mart¡nez - Cria‡Æo do programa          **
**                                                                                         **
**                                                                                         **
********************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramName ESBC9030
/************************************************************/

{utp/utapi009.i} /* login */
{utp/ut-glob.i}

/* Definicao da temp-table de integracao ---                */

&global-define TEMPTABLE tt-storage-serial-wms
{bcp/bc9029.i}
{bcp/bc9048.i1} /* definicao variaveis menu padrao */
{esp/wmp/eswmpapi002.i}

DEFINE TEMP-TABLE ttwm-etiqueta NO-UNDO LIKE wm-etiqueta.
{method/dbotterr.i}

DEFINE TEMP-TABLE tt-etiqueta-lida NO-UNDO
    FIELD id-etiqueta LIKE wm-etiqueta.id-etiqueta
    FIELD qtd-item    LIKE wm-etiqueta.qtd-item.

DEFINE TEMP-TABLE tt-docto-itens-emb-manual NO-UNDO
    FIELD cod-embalagem         LIKE wm-box-saldo.cod-embalagem
    FIELD qtd-item-emb          LIKE wm-box-saldo.qtd-item
    FIELD qti-embalagem         LIKE wm-box-movto.qti-embalagem
    FIELD qtd-volume            LIKE wm-item-embalagem.qtd-volume
    FIELD qtd-peso              LIKE wm-item-embalagem.qtd-peso
    FIELD id-box                LIKE wm-box.id-box
    FIELD cod-bloco             LIKE wm-box.cod-bloco
    FIELD cod-rua               LIKE wm-box.cod-rua
    FIELD cod-nivel             LIKE wm-box.cod-nivel
    FIELD cod-coluna            LIKE wm-box.cod-coluna.

Define Temp-table ttWork NO-UNDO like {&TempTable}.
Create ttWork.
ASSIGN ttWork.cod-estabel = gCodEstab
       ttWork.cod-local   = gCodLocal.

/* Definicao da Temp-table de Tarefas do Resumo Pedido */
DEFINE NEW SHARED TEMP-TABLE tt-dados NO-UNDO 
       FIELD it-codigo     LIKE ITEM.it-codigo
       FIELD cod-localiz   AS   CHAR
       FIELD dt-transacao  AS   DATE
       FIELD nro-docto     AS   CHAR
       FIELD cod-embalagem AS   CHAR
       FIELD qtd-item      AS   DECI.

/************************************************************/

Define Query qry-tt-dados For tt-dados.

Define Browse brw-tt-dados Query qry-tt-dados No-lock
             Display 
             it-codigo     Format 'x(7)'
             cod-localiz   Format 'x(9)'
             With No-box No-labels Size 20 By 4 SCROLLBAR-VERTICAL.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/


/* ************************** Definitions ******************************** */
DEFINE VARIABLE vcod-senha              AS CHARACTER FORMAT 'x(14)':U              NO-UNDO.
DEFINE VARIABLE vNomeUsuario        AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE vLogControlaLogin   AS LOGICAL INITIAL NO           NO-UNDO.
DEFINE VARIABLE vProcesso           AS LOGICAL INITIAL NO           NO-UNDO.
DEFINE VARIABLE l-menu-padrao       AS LOGICAL INITIAL YES          NO-UNDO.
DEFINE VARIABLE vOpcao              AS INTEGER                      NO-UNDO.
Define Variable vDocto              AS CHAR                         No-undo.
Define Variable vEmb                AS CHAR                         No-undo.
Define Variable vQtd                AS DEC                          No-undo.
DEFINE VARIABLE idEtiquetaArm       LIKE wm-etiqueta.id-etiqueta    NO-UNDO.
DEFINE VARIABLE l-etiqueta-1  AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE l-primeiro AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE l-sucesso AS LOGICAL INITIAL NO NO-UNDO.

DEFINE VARIABLE Hbosc038   AS HANDLE.
DEFINE VARIABLE Hbosc109   AS HANDLE.
DEFINE VARIABLE Hbcapiwms  AS HANDLE.
DEFINE VARIABLE Hbcapi9029 AS HANDLE.
DEFINE VARIABLE Hbosc074   AS HANDLE.
DEFINE VARIABLE h-bosc035sto AS HANDLE.

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Saldos Destin. WMS'                               At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                             ttWork.cod-usuario                                 At Row 03 Col 05 No-label ~
                             'Sen:'                                             AT ROW 04 COL 01          ~
                             vcod-senha                                         AT ROW 04 COL 05 NO-LABEL ~
                             'Estab:'                                           At Row 05 Col 01          ~
                             ttWork.cod-estabel                                 At Row 05 Col 07 No-label ~
                             'Local:'                                           At Row 06 Col 01          ~
                             ttWork.cod-local                                   At Row 06 Col 07 No-label 
                             
&global-define Frame01Repeat NO 

/* Definicao da Frame02 ---                             */
&global-define Frame02Name   Frame02
&global-define Frame02Defs  'Armazena Lista '                               At Row 01 Col 01          ~
                            '--------------------'                          At Row 02 Col 01          ~
                            brw-tt-dados                                    At Row 03 Col 01          ~
                            vDocto          FORMAT "x(18)"                  At Row 07 Col 01 NO-LABEL ~
                            vEmb            FORMAT "x(18)"                  At Row 08 Col 01 NO-LABEL
&global-define Frame02Repeat NO

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Detalhe Saldo Dest'                               At Row 01 Col 01          ~
                             '--------------------':U                           At Row 02 Col 01          ~
                             'Docto:'                                           At Row 03 Col 01          ~
                             tt-dados.nro-docto                                 At Row 03 Col 05 No-label ~
                             'Emb:'                                             At Row 04 Col 01          ~
                             tt-dados.cod-embalagem                             At Row 04 Col 05 No-label ~
                             'Qtd:'                                             At Row 05 Col 01          ~
                             tt-dados.qtd-item                                  At Row 05 Col 05 No-label 
&global-define Frame03Repeat NO


/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = '' ~
                              vcod-senha WHEN ttWork.cod-usuario = '' ~
                              ttWork.cod-estabel ~
                              ttWork.cod-local
&global-define Update02Fields brw-tt-dados 

&global-define Update03Fields tt-dados.nro-docto
/* &global-define Update03Fields ttWork.num-box-lido  */
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01.  
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03.

&global-define TriggerAfterFrame01  Run GravaCamposFrame01.      
&global-define TriggerAfterFrame02  Run GravaCamposFrame02.
&global-define TriggerAfterFrame03  Run GravaCamposFrame03.


/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ~
                            ON 'value-changed':U OF brw-tt-dados In Frame {&Frame02Name}     ~
                            DO:                                                              ~
                                IF AVAIL tt-dados THEN                                       ~
                                    Assign vDocto:screen-value In Frame frame02 = "Docto:" + string(tt-dados.nro-docto).  ~
                                           vEmb:screen-value In Frame frame02 = "Emb:" + string(tt-dados.cod-embalagem,"x(5)") + " Qtd:" + string(tt-dados.qtd-item).  ~
                            END.

/* Definicao dos objetos ativos ---                         */ 
//&global-define ActiveObject1 Hbcapiwms
//&global-define ActiveObject2 Hbcapi9029
/* &global-define ActiveObject4 wgbosc095.  */
/* &global-define ActiveObject5 wgbosc092.  */
/* &global-define ActiveObject6 wgbcapi001. */
/* &global-define ActiveObject7 Hbosc038.  */
/* &global-define ActiveObject5 Hbosc109.  */

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
Procedure InicializaCamposFrame01:

   If  RETURN-VALUE = 'NOK':U Then Do:
        ASSIGN vlogerro = YES     
               vLogSai  = YES      
               vLogFinaliza = YES
               vLogCancela = YES. 
        HIDE ALL NO-PAUSE.
        RETURN ERROR.
    End.
    ASSIGN vLogErro     = NO
           vLogsai      = NO
           vLogfinaliza = NO.
    FOR EACH ttWork:
        DELETE ttWork.
    END.
    Create ttWork.
    IF v_cod_usuar_corren <> '' THEN DO: 
        assign vcod-senha:blank in frame frame01 = NO.
        ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = v_cod_usuar_corren
               ttWork.cod-usuario                               = v_cod_usuar_corren
               vcod-senha                                       = '****************':U /* login autom tico */
               vcod-senha:SCREEN-VALUE IN FRAME frame01         = '****************':U /* login autom tico */
               ttWork.cod-estabel = gCodEstab
               //ttWork.cod-local   = gCodLocal
               .
    END.
    ELSE DO:
        assign vcod-senha:blank in frame frame01 = YES.
        ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = '' 
               ttWork.cod-usuario = ''
               vcod-senha = ''  
               vcod-senha:SCREEN-VALUE IN FRAME Frame01 = ''.
    END.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame02 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame02:

    Open Query qry-tt-dados For Each tt-dados
          BY  tt-dados.dt-transacao.
    BROWSE brw-tt-dados:REFRESH() NO-ERROR.

    APPLY 'value-changed':U TO brw-tt-dados  In Frame {&Frame02Name}.

End Procedure.

Procedure InicializaCamposFrame03:

END PROCEDURE.

Procedure GravaCamposFrame01:
     
     Assign vLogErro           = NO 
            vLogControlaLogin  = NO.

     FOR EACH tt-erro:
         DELETE tt-erro.
     END.

    Assign  {&TempTable}.cod-usuario      = ttWork.cod-usuario 
            {&TempTable}.cod-coletor      = ttWork.cod-coletor
            {&TempTable}.cod-equipamento  = ttWork.cod-equipamento
            {&TempTable}.tipo-equipamento = ttWork.tipo-equipamento.

    EMPTY TEMP-TABLE tt-dados.
    
    FOR EACH wm-box-saldo WHERE
             wm-box-saldo.cod-estabel      = ttWork.cod-estabel AND
             wm-box-saldo.cod-local        = ttWork.cod-local   AND
             wm-box-saldo.ind-status-saldo = 2     AND /* Destinado */
             wm-box-saldo.cod-cliente      = 0
             NO-LOCK
             BREAK BY wm-box-saldo.dt-transacao.
    
        FIND FIRST ITEM 
             WHERE ITEM.it-codigo = wm-box-saldo.cod-item
                   NO-LOCK NO-ERROR.
    
        FIND FIRST Wm-box
             WHERE Wm-box.cod-estabel = wm-box-saldo.cod-estabel AND
                   Wm-box.cod-local   = wm-box-saldo.cod-local   AND
                   Wm-box.id-box      = wm-box-saldo.id-box      
                   NO-LOCK NO-ERROR.
    
        FIND FIRST wm-docto 
             WHERE wm-docto.cod-estabel  = wm-box-saldo.cod-estabel AND
                   wm-docto.cod-local    = wm-box-saldo.cod-local   AND
                   wm-docto.id-docto     = wm-box-saldo.id-docto 
                   NO-LOCK NO-ERROR.
    
        IF AVAIL wm-docto 
        THEN FIND FIRST ficha-cq 
                  WHERE ficha-cq.nr-ficha = int(wm-docto.num-docto)
                        NO-LOCK NO-ERROR.
    
        IF AVAIL ficha-cq 
        THEN FIND FIRST ae-entrada WHERE
                        ae-entrada.cod-estabel  = ficha-cq.cod-estabel and
                        ae-entrada.cod-emitente = ficha-cq.cod-emitente AND
                        ae-entrada.nro-docto    = int(ficha-cq.nro-docto) NO-LOCK NO-ERROR.

        CREATE tt-dados.
        ASSIGN tt-dados.it-codigo     = wm-box-saldo.cod-item
               tt-dados.cod-localiz   = IF AVAIL ae-entrada AND AVAIL ficha-cq THEN ae-entrada.localizacao[1] ELSE ""
               tt-dados.dt-transacao  = wm-box-saldo.dt-transacao
               tt-dados.nro-docto     = IF AVAIL wm-docto THEN STRING(wm-docto.num-docto) ELSE ""
               tt-dados.cod-embalagem = wm-box-saldo.cod-embalagem
               tt-dados.qtd-item      = wm-box-saldo.qtd-item.
    
    END.
End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame02:

End Procedure.

Procedure GravaCamposFrame03:

End Procedure.

PROCEDURE pi-executa-grava-frame2:


END PROCEDURE.
