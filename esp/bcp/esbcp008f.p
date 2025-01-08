/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9025F 2.00.00.040 } /*** 010040 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9025f MBC}
&ENDIF

{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9025f.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - fevereiro/2003 - Karen - Cria‡Æo do programa                **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Transferˆncia WMS                **
**                                                                                         **
********************************************************************************************/
&if '{&mgscm_version}' >= '2.04' &then
/***************************************************************************************************
** SECAO DE PRE-PROCESSADORES DA TEMPLATE                                                         **
** Nesta secao sao definidos os pre-processadores que serao usados na montagem da interface.      **
**                                                                                                **
** DESCRICAO DOS PREPROCESSADORES:                                                                **
** ProgramName          - Nome do programa e, tambem, do Codigo da transacao do Data Collection   **
**                        que sera acionada pela interface.                                       **
** TempTable            - Nome da Temp-Table da transacao de negocio para comunicacao com ERP.    **
**                        Ex: tt-transf-wms.                                                       **
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
**                        que executa a procedure _GenerateDCTransaction que e responsavel por   **
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
&global-define ProgramName esbcp008

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-transf-wms
{bcp/bc9025.i " "}
{method/dbotterr.i}
{wmp/wm9000.i}

    /* VERIFICAR A CRIA€ÇO DA TTWORK NA TRANSA€ÇO VIA SERIAL */
Define new SHARED     Temp-table ttWork           No-Undo like {&TempTable}.
create ttWork.

Define NEW SHARED Temp-table ttwm-etiqueta-bkp NO-UNDO Like wm-etiqueta.
Define Temp-table ttwm-etiqueta-met            NO-UNDO Like wm-etiqueta.   /* tt que recebe do metodo o que esta no WMS */
DEFINE TEMP-TABLE ttwm-etiqueta-9000           NO-UNDO LIKE ttwm-etiqueta. /* tt utilizada para execucao wm90000 */

Define SHARED Temp-table tt-transf-wms-bkp     NO-UNDO Like tt-transf-wms.

DEFINE VARIABLE wgbosc092          AS HANDLE                                      NO-UNDO.
DEFINE VARIABLE iCodTipoEquip      AS INTEGER                                     NO-UNDO.
DEFINE VARIABLE vLogAtivo          AS LOGICAL                    INIT NO          NO-UNDO.
DEFINE VARIABLE vLogProcesso       AS LOGICAL                    INIT NO          NO-UNDO.
DEFINE VARIABLE c-date             AS CHARACTER                                   NO-UNDO.
DEFINE VARIABLE c-date-docto       AS CHARACTER                                   NO-UNDO.
DEFINE VARIABLE iTotRegistro       AS INTEGER                                     NO-UNDO. 

DEFINE VARIABLE vTmp_id-docto LIKE wm-docto.id-docto.
DEFINE VARIABLE vTmp_id-movto LIKE wm-box-movto.id-movto.
/*DEFINE VARIABLE hDBOWm-box-movto-idx AS HANDLE                                      NO-UNDO.*/

DEFINE VARIABLE i-ind-status-saldo-origem       LIKE wm-box-saldo.ind-status-saldo    NO-UNDO.
DEFINE VARIABLE o-ind-status-saldo-origem       LIKE wm-box-saldo.ind-status-saldo    NO-UNDO.
DEFINE VARIABLE i-id-movto-box-saldo            LIKE wm-box-saldo.id-movto            NO-UNDO.
DEFINE VARIABLE o-id-movto-box-saldo            LIKE wm-box-saldo.id-movto            NO-UNDO.

&global-define ActiveObject2 wgbosc092

Define Temp-table ttWm-box-movto-idx No-undo Like wm-box-movto
            Field val-prioridade    As Integer
            Field r-rowid           As Rowid
            Index idx-prioridade val-prioridade Desc
            Index idx-movto      id-movto       Asc.

DEF TEMP-TABLE tt-etiqueta NO-UNDO
    FIELD id-etiqueta LIKE wm-etiqueta.id-etiqueta
    FIELD qtd-item    LIKE wm-etiqueta.qtd-item
    INDEX codigo IS UNIQUE id-etiqueta.


def temp-table tt-saldo NO-UNDO
    field cod-lote         like  wm-box-saldo.cod-lote
    field dt-validade-lote like  wm-saldo-estoque.dt-validade-lote
    field dt-transacao     like  wm-box-saldo.dt-transacao
    field id-box           like  wm-box-saldo.id-box
    field ind-status-saldo like  wm-box-saldo.ind-status-saldo
    field cod-embalagem    like  wm-box-saldo.cod-embalagem
    field qtd-original     like  wm-box-saldo.qtd-original
    field qtd-item         like  wm-box-saldo.qtd-item
    field qtd-embalagem    like  wm-box-movto.qti-embalagem
    field qtd-retirar      like  wm-box-saldo.qtd-item
    index w-res01 is unique  cod-lote
                             dt-transacao  
                             id-box       
                             cod-embalagem 
                             qtd-original 
                             qtd-item.

define temp-table tt-docto-itens-emb-manual NO-UNDO
        field cod-embalagem         like wm-box-saldo.cod-embalagem         
        field qtd-item-emb          like wm-box-saldo.qtd-item    
        field qti-embalagem         like wm-box-movto.qti-embalagem                            
        field qtd-volume            like wm-item-embalagem.qtd-volume         
        field qtd-peso              like wm-item-embalagem.qtd-peso
        field id-box                like wm-box.id-box
        field cod-bloco             like wm-box.cod-bloco
        field cod-rua               like wm-box.cod-rua
        field cod-nivel             like wm-box.cod-nivel
        field cod-coluna            like wm-box.cod-coluna.

DEF BUFFER b-tt-transf-wms-bkp FOR tt-transf-wms-bkp.
/************************************************************/

/* Variaveis de trabalho ---                                */              
Define Variable vLogOk         As Logical      Init No  No-undo.
Define Variable vEndereco      AS CHAR FORMAT 'x(15)':U No-undo.
Define Variable vDesLidos      As CHAR                  NO-UNDO.
Define new shared Variable vNumLidos      AS INT                   No-undo.
Define Variable vNumSaidas     AS INT                   No-undo.
Define Variable vLogAnswer     As LOG         Init NO   No-undo.
Define Variable vLogAnswer-esc As Logical     Init NO   No-undo.
DEFINE VARIABLE v-count        AS INT         INIT 0    NO-UNDO.
DEFINE VARIABLE v-tipo         AS CHAR FORMAT 'x(08)':U NO-UNDO.
define variable vDetalhe       as character no-undo.

Define Variable vCodBloco  AS CHAR                  No-undo.
Define Variable vCodRua    AS CHAR                  No-undo.
Define Variable vCodNivel  AS CHAR                  No-undo.
Define Variable vCodColuna AS CHAR                  No-undo. 

Define Variable vQtdPeso   AS DECIMAL FORMAT ">,>>>,>>9.9999" No-undo. 
Define Variable vQtdVolume AS DECIMAL FORMAT ">,>>>,>>9.9999" No-undo. 

DEFINE VARIABLE r-rowid-docto-itens    AS ROWID         NO-UNDO.

/*Gozdecki*/
define variable capacidade As Logical     Init YES   No-undo.
define VARIABLE tipoCapacidade AS INT         INIT 1    NO-UNDO.
DEFINE VARIABLE wgbosc096           AS HANDLE                           NO-UNDO.
DEFINE BUFFER bf_ttWm-box-movto-idx FOR ttWm-box-movto-idx.
Define New Shared Variable wgbosc030    As Widget-handle No-undo.       
Define New Shared Variable wgbosc074    As Widget-handle No-undo.       
Define New Shared Variable wgbosc039    As Widget-handle No-undo.       
Define New Shared Variable wgbosc145    As Widget-handle No-undo.  
define new shared variable wgbosc044    as widget-handle no-undo.
define new shared variable wgbosc051    as widget-handle no-undo.
define new shared variable wgbosc038    as widget-handle no-undo.
Define New Shared Variable wgbcapi001   As Widget-handle No-undo.

Define NEW Shared Variable hbosc035EXI  As Widget-handle No-undo. 
Define NEW Shared Variable hDbosc035sto As Widget-handle No-undo. 
/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Transferˆncia WMS'                                At Row 01  Col 01          ~
                             '--------------------':U                           At Row 02  Col 01          ~
                             'Box Ent:'                                         At Row 03  Col 01          ~
                             ttwork.num-box-orig                                At Row 03  Col 09 No-label ~
                             'En:'                                              At Row 04  Col 01          ~
                             vEndereco                                          At Row 04  Col 04 NO-LABEL ~
                             'Ser:'                                             at row 05  col 01          ~
                             ttWork.num-serial                                  at row 05  col 05 no-label ~
                             'Lidos:'                                           At Row 07  Col 01          ~
                             vDesLidos                                          At Row 07  Col 07 NO-LABEL ~
                             'Cancelar = 999999'                                At Row 7.3 Col 01

&global-define Frame01Repeat YES

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields              ~
         
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 

&global-define TriggerAfterFrame01  Run GravaCamposFrame01. If Return-value = 'OK' AND vLogFinaliza = YES Then RETURN 'OK':U. ~
                                                            else do: ~
                                                                 for each tt-transf-wms-bkp where tt-transf-wms-bkp.ind-tip-movto = 2: ~
                                                                     delete tt-transf-wms-bkp. ~
                                                                 End. ~
                                                                 hide frame _error no-pause. ~
                                                            End. ~
                                                            If Return-value = 'NOK'Then RETURN 'NOK':U. ~
                                                            If Return-value = 'CAN'Then RETURN 'CAN':U. ~

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ~
                            ON 'ESC':U OF Frame Frame01                                                    ~
                            DO:                                                                            ~
                                Define Variable vDesErro As Character View-as Editor Size 19 By 7  No-undo. ~
                                find first tt-transf-wms-bkp no-lock no-error.                             ~
                                If avail tt-transf-wms-bkp Then                                            ~
                                    If tt-transf-wms-bkp.num-serial = 0 Then do:     ~
                                        hide all no-pause.                                                 ~
                                        PAUSE 0.                                                           ~
                                        view frame error.                                                  ~
                                        Disp  'Erro:'         At Row 1 Col 1                               ~
                                              105   format '>>>>>>9'  At Row 1 Col 6 No-label              ~
                                              vDesErro At Row 2 Col 1 No-label                             ~
                                              With Frame Error 1 down font 3 Size 20 By 8 No-box.          ~
                                        If session:display-type = "GUI" Then                               ~
                                           Assign vDesErro:Width  = Frame Error:Width  - 1                 ~
                                                  vDesErro:Height = Frame Error:height - 1.                ~
                                        assign vDesErro:screen-value in frame Error = 'NÆo ‚ poss¡vel sair sem realocar todas embalagens'. ~
                                        Pause No-message.                                                  ~
                                        Hide Frame Error.                                                  ~
                                        PAUSE 0.                                                           ~
                                        disp ttWork.num-box-orig with frame Frame01.                       ~
                                        return no-apply.                                                   ~
                                    End.                                                                   ~
                                    else do:                                                               ~
                                        FIND FIRST tt-transf-wms-bkp WHERE tt-transf-wms-bkp.ind-tip-movto = 2 NO-LOCK NO-ERROR. ~
                                        IF AVAIL tt-transf-wms-bkp THEN DO:                                ~
                                           Disp 'Existem Entradas.' At Row 01 Col 01                       ~
                                                'Deseja Desfazer?'  AT ROW 02 COL 01                       ~
                                                '1=Sim 2=NÆo'       At Row 03 Col 01 With Frame f-conf Font 2 Size 20 By 8 No-box. ~
                                           Update vLogAnswer-esc    At Row 03 Col 13 No-label Format '1/2':U With Frame f-conf Font 2 Size 20 By 8. ~
                                           If  vLogAnswer-esc = YES Then do:                               ~
                                               ASSIGN ttWork.num-box-orig = 0                              ~
                                                      ttWork.num-serial   = 0                              ~
                                                      vNumLidos           = 0.                             ~
                                               EMPTY TEMP-TABLE tt-transf-wms-bkp.                         ~
                                               EMPTY TEMP-TABLE ttwm-etiqueta-met.                         ~
                                               EMPTY TEMP-TABLE ttwm-docto.                                ~
                                               EMPTY TEMP-TABLE ttwm-docto-itens.                          ~
                                           END.                                                            ~
                                           ELSE DO:                                                        ~
                                               RETURN NO-APPLY.                                            ~
                                           END.                                                            ~
                                        END.                                                               ~
                                    End.                                                                   ~
                            END.                                                                           ~
                            ON 'enter':U OF ttwork.num-box-orig IN Frame Frame01     ~
                            DO:                                                      ~
                            END.~
                            ON 'leave':U OF ttwork.num-box-orig IN Frame Frame01                           ~
                            DO:                                                                            ~
                                IF NOT VALID-HANDLE(wgbosc030)  THEN DO:                                   ~
                                   Run scbo/bosc030.p Persistent SET wgbosc030.                            ~
                                   Run openQueryStatic In wgbosc030 (Input "Main":U) No-error.             ~
                                END.                                                                       ~
                                Run retornaEnderecoBox In wgbosc030 (Input ttwork.cod-estabel,             ~
                                                                     Input ttwork.cod-local,               ~
                                                                     Input ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01, ~
                                                                     OUTPUT vCodBloco,                     ~
                                                                     OUTPUT vCodRua,                       ~
                                                                     OUTPUT vCodNivel,                     ~
                                                                     OUTPUT vCodColuna).                   ~
                                assign input Frame Frame01 ttWork.num-box-orig.                            ~
                                IF vCodBloco = '' and vCodRua = ''                                         ~
                                   THEN ASSIGN vEndereco:SCREEN-VALUE IN FRAME Frame01 = ''.               ~
                                ELSE do:                                                                   ~
                                    ASSIGN vEndereco:SCREEN-VALUE IN FRAME Frame01 = vCodBloco  + "/":U +  ~
                                                                                         vCodRua    + "/":U + ~
                                                                                         vCodNivel  + "/":U + ~
                                                                                         vCodColuna.          ~
                                    find first tt-transf-wms-bkp where tt-transf-wms-bkp.ind-tip-movto = 1 no-lock no-error.  ~
                                    If tt-transf-wms-bkp.num-serial = 0 Then do: /* Se for transa‡Æo via embalagens, chamar o zomm */   ~
                                        assign input frame Frame01 ttWork.num-box-orig.                       ~
                                        hide all no-pause.                                                    ~
                                        run bcp/bc9025i.p (input-output table tt-transf-wms-bkp).             ~
                                        hide all no-pause.                                                    ~
                                        assign entry(1,vDesLidos,"/") = String(vNumLidos).                    ~
                                        disp vDesLidos with Frame Frame01.                                    ~
                                        pause 0 before-hide.                                                  ~
                                    End.                                                                      ~
                                End.                                                                          ~
                            END.                                                                              ~

/************************************************************/
/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc030
&global-define ActiveObject2 wgbosc074
&global-define ActiveObject3 wgbosc039
&global-define ActiveObject4 wgbosc145
&global-define ActiveObject5 hbosc035EXI
&global-define ActiveObject6 hDbosc035sto
&global-define ActiveObject8 wgbcapi001
&global-define ActiveObject8 wgbosc044
&global-define ActiveObject10 wgbosc051
/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/
/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao e necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */
/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local ² destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame01 com valores em branco              **
** Esta procedure e executada pelo pre-processador {&TriggerBeforeFrame01}.                       **
****************************************************************************************************/
Procedure InicializaCamposFrame01:   
define variable cTranEmbal as decimal no-undo. /* Deve ser decimal pois caso seja uma etiqueta, o serial ‚ um n£mero maior do que o suportado por um inteiro */

EMPTY TEMP-TABLE ttwm-etiqueta-met. 
EMPTY TEMP-TABLE ttwm-docto.
EMPTY TEMP-TABLE ttwm-docto-itens.

IF NOT VALID-HANDLE(wgbosc030)  THEN DO:
   Run scbo/bosc030.p Persistent SET wgbosc030.
   Run openQueryStatic In wgbosc030 (Input "Main":U) No-error. 
END.                                                           

Assign vEndereco  = ''
       vNumSaidas = 0
       .

FIND FIRST tt-transf-wms-bkp no-lock NO-ERROR.

ASSIGN ttwork.cod-usuario = tt-transf-wms-bkp.cod-usuario
       ttwork.cod-coletor = tt-transf-wms-bkp.cod-coletor
       ttwork.cod-estabel = tt-transf-wms-bkp.cod-estabel
       ttwork.cod-local   = tt-transf-wms-bkp.cod-local
       cTranEmbal         = tt-transf-wms-bkp.num-serial. 

IF vLogOk = YES THEN 
   ASSIGN ttWork.num-box-orig = 0
          ttWork.num-serial   = 0
          .

if tt-transf-wms-bkp.num-serial = 0 or tt-transf-wms-bkp.num-serial = 777777 then 
    assign ttWork.num-serial = 0.

FOR EACH tt-transf-wms-bkp WHERE tt-transf-wms-bkp.ind-tip-movto = 1: 
    ASSIGN vNumSaidas = vNumSaidas + 1.
END.

Assign vDesLidos = trim(String(vNumLidos,'>>9':U)) + '/':U + trim(String(vNumSaidas,'>>9':U)).

Disp ttWork.num-box-orig vEndereco ttWork.num-serial vDesLidos With Frame Frame01. 

if cTranEmbal = 0 then do: /* Transa‡Æo via Embalagem */
    update ttWork.num-box-orig with frame Frame01.
End.
else do: /* Transa‡Æo via Seriais */
    update ttWork.num-box-orig ttWork.num-serial with frame Frame01.
End.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame03}.                        **
****************************************************************************************************/
Procedure GravaCamposFrame01:

    define variable cTotalQtdeMov as integer no-undo.
    define variable cNumBoxOrig   as integer no-undo.
    define variable cTranEmbal    as integer no-undo.

    Assign vLogErro     = No
           vLogOk       = NO
           vLogFinaliza = NO
           INPUT FRAME frame01 vEndereco
                               ttWork.num-serial
                               ttWork.num-box-orig.

    IF NOT VALID-HANDLE(wgbosc030)  THEN DO:
       Run scbo/bosc030.p Persistent SET wgbosc030.
       Run openQueryStatic In wgbosc030 (Input "Main":U) No-error. 
    END.                                                           

    IF NOT VALID-HANDLE(wgbosc074)  THEN DO:
       Run scbo/bosc074.p Persistent SET wgbosc074.
       Run openQueryStatic In wgbosc074 (Input "Main":U) No-error. 
    END.       

    IF NOT VALID-HANDLE(hbosc035EXI) THEN DO:
       Run scbo/bosc035exi.p Persistent SET hbosc035EXI.
       Run openQueryStatic In hbosc035EXI (Input "Main":U) No-error. 
    END.                                                           

    IF NOT VALID-HANDLE(hDbosc035sto) THEN DO:
       Run scbo/bosc035sto.p Persistent SET hDbosc035sto.
       Run openQueryStatic In hDbosc035sto (Input "Main":U) No-error. 
    END.     

    IF NOT VALID-HANDLE(wgbosc039)  THEN DO:
       Run scbo/bosc039.p Persistent SET wgbosc039.
       Run openQueryStatic In wgbosc039 (Input "Main":U) No-error. 
    END.                        

    IF NOT VALID-HANDLE(wgbosc044)  THEN DO:
       Run scbo/bosc044.p Persistent SET wgbosc044.
       Run openQueryStatic In wgbosc044 (Input "Main":U) No-error. 
    END.   
    /*
    IF NOT VALID-HANDLE(wgbosc051)  THEN DO:
       Run scbo/bosc051.p Persistent SET wgbosc051.
       Run openQueryStatic In wgbosc051 (Input "Main":U) No-error. 
    END.   
    */
    Run retornaEnderecoBox In wgbosc030 (INPUT ttwork.cod-estabel, 
                                         INPUT ttwork.cod-local,   
                                         INPUT ttWork.num-box-orig,
                                         OUTPUT vCodBloco,         
                                         OUTPUT vCodRua,           
                                         OUTPUT vCodNivel,         
                                         OUTPUT vCodColuna).       
    IF  ttWork.num-box-orig <> 999999
    THEN DO:
        IF vCodBloco = '' and vCodRua = '' THEN DO:
           Assign vLogErro = Yes.
           {bcp/bc9105.i "101" "Box Inv lido. (WMS)"}
           hide all no-pause.
           Return Error.
        END. 

        FIND FIRST tt-transf-wms-bkp NO-LOCK NO-ERROR.
        /* Se o num-serial estiver em zero, ‚ transa‡Æo via embalagens, caso contr rio, ‚ serial */
        If tt-transf-wms-bkp.num-serial = 0 Then do: 
            If not can-find(first b-tt-transf-wms-bkp where b-tt-transf-wms-bkp.ind-tip-movto = 2 and b-tt-transf-wms-bkp.num-box-orig = ttWork.num-box-orig) THEN DO:
               ASSIGN vLogErro = YES.
               {bcp/bc9105.i "106" "NÆo existe nenhum movimento de entrada neste Box. (DC)"}
               hide all no-pause.
               Return Error.
            END.
        End.
        else do: /* Transa‡Æo vai Serial */
            Run getInfoEtiqueta In wgbosc074 (Input ttWork.num-serial, 
                                              OUTPUT TABLE ttWm-etiqueta-met). 
            If Return-value <> 'OK':U Then Do:
               Assign vLogErro = Yes.
               {bcp/bc9105.i "102" "Etiqueta Inexistente. (WMS)"}
               hide all no-pause.
               Return Error.
            END.

            /* validar os seriais que nÆo foram lidos na entrada e foram lidos na sa¡da */
            FIND FIRST tt-transf-wms-bkp
                 WHERE tt-transf-wms-bkp.cod-local     = ttwork.cod-local
                   AND tt-transf-wms-bkp.num-serial    = ttWork.num-serial
                   AND tt-transf-wms-bkp.ind-tip-movto = 1 
                 NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-transf-wms-bkp THEN DO:
               ASSIGN vLogErro = YES.
               {bcp/bc9105.i "103" "NÆo existe movto Sa¡da para este serial. (DC)"}
               Return Error.
            END.
            ELSE DO:

               FIND FIRST ttwm-etiqueta-met NO-LOCK NO-ERROR. 

               FIND FIRST ttwm-etiqueta-bkp WHERE 
                    ttwm-etiqueta-bkp.id-etiqueta = ttwm-etiqueta-met.id-etiqueta NO-LOCK no-error. 
               IF NOT AVAIL ttwm-etiqueta-bkp THEN DO:
                  CREATE ttwm-etiqueta-bkp.
                  BUFFER-COPY ttwm-etiqueta-met TO ttWm-etiqueta-bkp. 
               END.

               IF ttwork.num-box-orig = tt-transf-wms-bkp.num-box-orig THEN DO:
                  Assign vLogErro = Yes.
                  {bcp/bc9105.i "104" "End Entrada ‚ o mesmo Sa¡da. (DC)"}  
                  Return Error.
               END.
               ELSE DO:
                   FIND FIRST tt-transf-wms-bkp
                        WHERE tt-transf-wms-bkp.cod-estabel   = ttwork.cod-estabel
                          AND tt-transf-wms-bkp.cod-local     = ttwork.cod-local
                          AND tt-transf-wms-bkp.num-serial    = ttWork.num-serial
                          AND tt-transf-wms-bkp.ind-tip-movto = 2 NO-LOCK NO-ERROR.

                   IF NOT AVAIL tt-transf-wms-bkp THEN DO:
                      CREATE tt-transf-wms-bkp.
                      ASSIGN tt-transf-wms-bkp.cod-usuario       = ttWork.cod-usuario
                             tt-transf-wms-bkp.cod-coletor       = ttWork.cod-coletor
                             tt-transf-wms-bkp.cod-equipamento   = ttWork.cod-equipamento
                             tt-transf-wms-bkp.cod-estabel       = ttWork.cod-estabel
                             tt-transf-wms-bkp.cod-local         = ttWork.cod-local
                             tt-transf-wms-bkp.num-box-orig      = ttWork.num-box-orig
                             tt-transf-wms-bkp.num-serial        = ttWork.num-serial
                             tt-transf-wms-bkp.des-endereco      = vEndereco
                             tt-transf-wms-bkp.cod-item          = ttwm-etiqueta-met.cod-item  
                             tt-transf-wms-bkp.qtd-item          = ttwm-etiqueta-met.qtd-item  
                             tt-transf-wms-bkp.cod-lote          = ttwm-etiqueta-met.cod-lote  
                             tt-transf-wms-bkp.cod-refer         = ttwm-etiqueta-met.cod-refer 
                             tt-transf-wms-bkp.cod-embalagem     = ttwm-etiqueta-met.cod-embalagem 
                             tt-transf-wms-bkp.qtd-item-retirado = ttwm-etiqueta-met.qtd-item-retirado
                             tt-transf-wms-bkp.cod-cliente       = ttwm-etiqueta-met.cod-cliente
                             tt-transf-wms-bkp.ind-tip-movto     = 2
                             tt-transf-wms-bkp.dat-transacao     = TODAY.

                      ASSIGN vNumLidos = vNumLidos + 1
                             vLogOk    = YES
                             entry(1,vDesLidos,"/") = string(vNumLidos)
                             vDesLidos:screen-value in frame Frame01 = vDesLidos.
                   END.
                   ELSE DO:
                       Assign vLogErro = Yes.
                       {bcp/bc9105.i "105" "Serial j  lido. (DC)"}
                       Return Error.
                   END.
               END.
            END.
        End. /* End da cria‡Æo das transferˆncia via Serial */
        /* Validar quantidade de itens lidos na sa¡da e quantidade de itens lidos na entrada 
           Possibilidade a transferˆncia parcial das embalagens/itens */
        BLOCO-WMS:
        DO TRANSACTION 
           ON ERROR  UNDO BLOCO-WMS, LEAVE BLOCO-WMS
           ON STOP   UNDO BLOCO-WMS, LEAVE BLOCO-WMS
           ON QUIT   UNDO BLOCO-WMS, LEAVE BLOCO-WMS
           ON ENDKEY UNDO BLOCO-WMS, LEAVE BLOCO-WMS:

            ASSIGN c-date       = STRING(TODAY)     
                   c-date-docto = STRING(ENTRY(1,c-date,"/")) + STRING(ENTRY(2,c-date,"/")).

            IF (vNumLidos > 0) THEN DO:
               CREATE ttwm-docto.
               ASSIGN ttwm-docto.cod-estabel      = ttWork.cod-estabel
                      ttwm-docto.cod-local        = ttWork.cod-local
                      ttwm-docto.dt-implan-docto  = TODAY
                      ttwm-docto.ind-origem-docto = 6 /* Transferencia Interna */
                      ttwm-docto.id-docto         = 0
                      ttwm-docto.ind-sit-docto    = 2 /* Atualizado    */
                      ttwm-docto.ind-tipo-trans   = 4 /* Transferˆncia */
                      ttwm-docto.num-docto        = IF LENGTH(ttWork.cod-usuario) <= 7 THEN 
                                                        ttWork.cod-usuario + "-" + STRING(TODAY)
                                                    ELSE 
                                                        ttWork.cod-usuario + "-" + c-date-docto
                      ttwm-docto.alteracao        = NO.

               assign v-count = 0.
               frBlk:
               FOR EACH tt-transf-wms-bkp WHERE 
                   tt-transf-wms-bkp.ind-tip-movto = 1 use-index idx-tip-movto NO-LOCK:   

                   /* NÆo realizar a efetiva‡Æo de itens pendentes de serem realizadas os movimentos de entrada */
                   If tt-transf-wms-bkp.num-serial = 0 Then do:
                       find first b-tt-transf-wms-bkp where
                                   b-tt-transf-wms-bkp.ind-tip-movto = 2 AND 
                                   b-tt-transf-wms-bkp.num-serial    = 0 and /* Quando for embalagem, o num-serial ‚ igual a zero */
                                   b-tt-transf-wms-bkp.cod-refer     = tt-transf-wms-bkp.cod-refer     and
                                   b-tt-transf-wms-bkp.cod-lote      = tt-transf-wms-bkp.cod-lote      and
                                   b-tt-transf-wms-bkp.cod-item      = tt-transf-wms-bkp.cod-item      and
                                   b-tt-transf-wms-bkp.cod-cliente   = tt-transf-wms-bkp.cod-cliente   and
                                   b-tt-transf-wms-bkp.qtd-item      = tt-transf-wms-bkp.qtd-item      and
                                   b-tt-transf-wms-bkp.cod-embalagem = tt-transf-wms-bkp.cod-embalagem and
                                   b-tt-transf-wms-bkp.cod-livre-2   = "":U no-error.
                   End.
                   else do:
                        FIND FIRST b-tt-transf-wms-bkp WHERE  
                            b-tt-transf-wms-bkp.ind-tip-movto = 2 AND 
                            b-tt-transf-wms-bkp.num-serial    = tt-transf-wms-bkp.num-serial NO-LOCK NO-ERROR.
                   End.
                   If not avail b-tt-transf-wms-bkp Then next.
                   else assign b-tt-transf-wms-bkp.cod-livre-2 = string(rowid(tt-transf-wms-bkp))
                                        v-count = v-count + 1.

                   CREATE ttwm-docto-itens.      
                   ASSIGN ttwm-docto-itens.cod-estabel    = ttwm-docto.cod-estabel
                          ttwm-docto-itens.cod-local      = ttwm-docto.cod-local
                          ttwm-docto-itens.num-docto      = ttwm-docto.num-docto
                          ttwm-docto-itens.id-docto       = ttwm-docto.id-docto
                          ttWm-docto-itens.cod-item       = tt-transf-wms-bkp.cod-item
                          ttWm-docto-itens.cod-refer      = tt-transf-wms-bkp.cod-refer
                          ttWm-docto-itens.cod-lote       = tt-transf-wms-bkp.cod-lote
                          ttWm-docto-itens.cod-cliente    = tt-transf-wms-bkp.cod-cliente
                          ttWm-docto-itens.qtd-item       = (tt-transf-wms-bkp.qtd-item - tt-transf-wms-bkp.qtd-item-retirado) 
                                                                    /* Validando tipo de transa‡Æo item/quantidade x serial */
                          ttWm-docto-itens.dt-atualizacao = TODAY 
                          ttWm-docto-itens.gera-sugestao  = no
                          ttWm-docto-itens.num-seq-item   = if tt-transf-wms-bkp.num-serial = 0 then v-count else 0. /* Agrupar por embalagem */

                   FOR EACH RowErrors:
                       DELETE RowErrors.
                   END.

                   FIND FIRST ttWm-docto NO-ERROR.
                   FIND FIRST ttWm-docto-itens NO-ERROR.

                   ASSIGN tt-transf-wms-bkp.id-docto      = ttwm-docto.id-docto.
                   IF AVAILABLE ttwm-docto-itens  THEN DO:
                      ASSIGN tt-transf-wms-bkp.num-seq-item  = ttwm-docto-itens.num-seq-item
                             b-tt-transf-wms-bkp.num-seq-item = ttwm-docto-itens.num-seq-item.
                   END.
                   ASSIGN ttWm-docto.alteracao = YES.

                   FOR EACH ttWm-docto-itens:
                       DELETE ttWm-docto-itens.
                   END.

               END.                                                       

               FOR EACH tt-transf-wms-bkp WHERE  
                   tt-transf-wms-bkp.ind-tip-movto = 1 USE-INDEX idx-tip-movto NO-LOCK:   

                   /* NÆo pode efetivar registros de sa¡da que nÆo possuam uma entrada. Utilizando a referˆncia do ROWID gerada acima */
                   find first b-tt-transf-wms-bkp where
                           b-tt-transf-wms-bkp.cod-livre-2   = string(rowid(tt-transf-wms-bkp)) and 
                           b-tt-transf-wms-bkp.ind-tip-movto = 2 no-lock no-error.
                   If not avail b-tt-transf-wms-bkp Then next.


                   EMPTY TEMP-TABLE tt-saldo.
                   EMPTY TEMP-TABLE tt-docto-itens-emb-manual.
                   
                      CREATE tt-saldo.
                      ASSIGN tt-saldo.cod-lote       = tt-transf-wms-bkp.cod-lote      
                             tt-saldo.dt-transacao   = TODAY
                             tt-saldo.id-box         = tt-transf-wms-bkp.num-box-orig
                             tt-saldo.cod-embalagem  = tt-transf-wms-bkp.cod-embalagem 
                             tt-saldo.qtd-original   = tt-transf-wms-bkp.qtd-item
                             tt-saldo.qtd-item       = (tt-transf-wms-bkp.qtd-item - tt-transf-wms-bkp.qtd-item-retirado)
                             tt-saldo.qtd-embalagem  = IF tt-transf-wms-bkp.num-serial = 0 
                                                       THEN tt-transf-wms-bkp.qti-embalagem 
                                                       ELSE tt-saldo.qtd-embalagem + 1
                             tt-saldo.qtd-retirar    = tt-transf-wms-bkp.qtd-item-retirado. /* Sempre ser  retirado o todo da embalagem */

                   FIND FIRST ttwm-docto NO-LOCK NO-ERROR.

                   Run GoToKey In wgbosc039 (INPUT ttWm-docto.cod-estabel, 
                                             INPUT ttWm-docto.cod-local, 
                                             INPUT ttWm-docto.id-docto, 
                                             INPUT tt-transf-wms-bkp.num-seq-item).

                   /*RUN pi_trata_erro_bloco_wms( INPUT  "BOSC039",
                                                INPUT  wgbosc039).
                   IF RETURN-VALUE = "NOK"  THEN UNDO BLOCO-WMS, RETURN "NOK".


                   RUN getrowid IN wgbosc039 (OUTPUT r-rowid-docto-itens).
                   RUN pi_trata_erro_bloco_wms( INPUT  "BOSC039",
                                                INPUT  wgbosc039).
                   IF RETURN-VALUE = "NOK"  THEN UNDO BLOCO-WMS, RETURN "NOK".

                   run validateTransfer in hbosc035EXI (INPUT tt-transf-wms-bkp.cod-estabel,
                                                        INPUT tt-transf-wms-bkp.cod-local,
                                                        INPUT tt-transf-wms-bkp.num-box-orig,
                                                        INPUT tt-transf-wms-bkp.num-serial).  

                   RUN pi_trata_erro_bloco_wms( INPUT  "BOSC035EXI",
                                                INPUT  hbosc035EXI).
                   IF RETURN-VALUE = "NOK"  THEN UNDO BLOCO-WMS, RETURN "NOK".*/

                   /*Criação do Documento de transferência*/
                   /****************************************  Processo manual de saída ******************************/
                      RUN pi-getValorParametro ( tt-transf-wms-bkp.cod-item,/*codigo do item*/              
                             "WMOut001":U, /*transacao*/
                             "ALOCACAO-ILIMITADA":U, /*codigo do parametro*/
                             OUTPUT tipoCapacidade).
                       
                        IF tipoCapacidade = 0 THEN
                           ASSIGN capacidade = NO.
                       ELSE 
                          ASSIGN capacidade = YES.
                        
                        /* CQ - ALtera status do Saldo para liberado */
                        FIND FIRST wm-box-saldo-etiqueta
                             WHERE wm-box-saldo-etiqueta.id-etiqueta = tt-transf-wms-bkp.num-serial NO-LOCK NO-ERROR.
                        IF AVAIL wm-box-saldo-etiqueta THEN DO:
                            
                            FIND FIRST wm-box-saldo WHERE
                                wm-box-saldo.cod-estabel = wm-box-saldo-etiqueta.cod-estabel AND
                                wm-box-saldo.cod-local   = wm-box-saldo-etiqueta.cod-local   AND
                                wm-box-saldo.id-saldo    = wm-box-saldo-etiqueta.id-saldo    EXCLUSIVE-LOCK NO-ERROR.
                            IF AVAIL wm-box-saldo AND wm-box-saldo.ind-status-saldo = 7
                            THEN DO:
                                ASSIGN wm-box-saldo.ind-status-saldo = 3.
                            END.
                        END.

                        /*API para validações e geração do Documento de transferência*/
                        RUN wmp/wm9090.p (Input tt-transf-wms-bkp.cod-estabel, /*– Estabelecimento informado pelo usuário*/
                                          Input tt-transf-wms-bkp.cod-local, /*– Local do WMS informado pelo usuário*/
                                          Input ?, /* – Rowid do documento (informar ?).*/
                                          Input ttWork.num-box-orig, /* – Informar “?”, pois o endereço de destino não é conhecido neste momento.   */
                                          Input 0, /* – não necessário, pois é informada a etiqueta – informar “?”. wm-box-saldo.id-saldo */
                                          Input 0, /* – não necessário, pois não juntará embalagem. Informar “?”.*/
                                          Input NO, /* – indica se embalagem será unificada – informar “no”*/   
                                          Input ttWork.cod-usuario, /* – código d o usuário informado no acesso do equipamento*/ 
                                          Input tt-saldo.qtd-item, /* – Quantidade que está sendo transferida – Com base na etiqueta, obter saldo do item (ttWm-etiqueta.qtd-item – ttWm-etiqueta.qtd-item-retirado).*/  /*(tt-etiqueta.qtd-item – tt-transf-wms.qtd-item-retirado)*/
                                          Input tt-transf-wms-bkp.num-serial, /* – identificador da etiqueta lida pelo usuário*/ /****  ttWm-etiqueta.id-etiqueta  *****/
                                          INPUT capacidade, /*valor lógico de capacidade do destino "infinito" : FO: 1896.045    YES/NO  */
                                          OUTPUT TABLE RowErrors). /* Tabela Temporária de Erros (RowErrors)*/

                        /* CQ - VOLTA status do Saldo para CQ-Armazenado */
                        FIND FIRST wm-box-saldo-etiqueta WHERE
                            wm-box-saldo-etiqueta.id-etiqueta = tt-transf-wms-bkp.num-serial NO-LOCK NO-ERROR.
                        IF AVAIL wm-box-saldo-etiqueta THEN DO:
                            
                            FIND FIRST wm-box-saldo WHERE
                                wm-box-saldo.cod-estabel = wm-box-saldo-etiqueta.cod-estabel AND
                                wm-box-saldo.cod-local   = wm-box-saldo-etiqueta.cod-local   AND
                                wm-box-saldo.id-saldo    = wm-box-saldo-etiqueta.id-saldo    EXCLUSIVE-LOCK NO-ERROR.
                            IF AVAIL wm-box-saldo AND wm-box-saldo.ind-status-saldo = 3 THEN DO:
                                ASSIGN wm-box-saldo.ind-status-saldo = 7.
                            END.
                        END.

                        IF CAN-FIND(FIRST RowErrors NO-LOCK)
                        THEN DO:
                            Assign vLogErro = Yes.
                            FIND FIRST RowErrors NO-LOCK NO-ERROR.
                            {bcp/bc9105.i "305" "Erro na API wm9090. (DC)"}
                            RETURN Error.
                        END.
                        ELSE DO: 
                            /**************  Documento criado. Efetivando Saída *****************/

                            DEFINE VARIABLE wgbosc032          AS HANDLE     NO-UNDO.
                            DEFINE VARIABLE r-box-movto         AS ROWID      NO-UNDO.
        
                           IF VALID-HANDLE(wgbosc096) THEN Delete Procedure wgbosc096.
                           IF NOT VALID-HANDLE(wgbosc096) THEN DO:
                              RUN scbo/bosc096.p PERSISTENT SET wgbosc096       NO-ERROR.
                              RUN openQueryStatic IN wgbosc096 (INPUT "Main":U) NO-ERROR.
                           END.
                
                           For Each ttWm-box-movto-idx:
                              Delete ttWm-box-movto-idx.
                           End.

                           RUN getMovtosTarefasAbertas  IN wgbosc096 (INPUT ttwork.cod-estabel,
                                                                      INPUT ttwork.cod-local,  
                                                                      INPUT 2,  /* FO 1.902.463 */
                                                                      INPUT 3,
                                                                      INPUT  "", 
                                                                      OUTPUT TABLE ttWm-box-movto-idx).
                          

                           IF VALID-HANDLE(wgbosc038) THEN Delete Procedure wgbosc038.
                           IF NOT VALID-HANDLE(wgbosc038) THEN DO:
                              RUN scbo/bosc038.p PERSISTENT SET wgbosc038       NO-ERROR.
                           END.
                           /*busca o documento correspondente ao que foi criado no wm9090*/
                           Run setConstraintDtNumIdDocto2 In wgbosc038 (Input tt-transf-wms-bkp.cod-estabel,
                                                                        Input tt-transf-wms-bkp.cod-local,
                                                                        Input ttWork.cod-usuario + "-" + STRING(TODAY),
                                                                        Input ttWork.cod-usuario + "-" + STRING(TODAY),
                                                                        Input 4,
                                                                        Input 4,
                                                                        Input 18,
                                                                        Input 18).

                          
                           RUN openQueryStatic IN wgbosc038 (INPUT "DtNumIdDocto2":U) NO-ERROR.
                           RUN getDecField IN wgbosc038 (INPUT "id-docto":U, OUTPUT vTmp_id-docto).
                            /*Busca a tarefa aberta com o id do documento correspoendente ao que foi gerado no wm9090*/
                            Find LAST ttWm-box-movto-idx
                                     Where ttWm-box-movto-idx.cod-estabel    = tt-transf-wms-bkp.cod-estabel
                                       AND ttWm-box-movto-idx.cod-local      = tt-transf-wms-bkp.cod-local
                                       AND ttWm-box-movto-idx.id-docto       = vTmp_id-docto
                                       AND ttWm-box-movto-idx.id-box         = tt-saldo.id-box 
                                       AND ttWm-box-movto-idx.ind-tipo-movto = 2
                                    No-lock No-error.
                            If AVAIL ttWm-box-movto-idx Then DO:
                                /*armazena chave para localiar documento para efetivar a saída e posteriormente entrada*/
                                 ASSIGN vTmp_id-docto = ttWm-box-movto-idx.id-docto.
                                 ASSIGN vTmp_id-movto = ttWm-box-movto-idx.id-movto.
                
                                IF NOT VALID-HANDLE(wgbosc032) THEN DO:
                                   RUN scbo/bosc032.p PERSISTENT SET wgbosc032.
                                   RUN openQueryStatic IN wgbosc032 (INPUT "Main":U) NO-ERROR.
                                END.
                                RUN goToKey2 IN wgbosc032 ( INPUT ttWm-box-movto-idx.cod-estabel,
                                                            INPUT ttWm-box-movto-idx.cod-local,
                                                            INPUT ttWm-box-movto-idx.id-movto,
                                                            INPUT 2).

                                RUN getRowid IN wgbosc032 (OUTPUT r-box-movto).

                                IF VALID-HANDLE(wgbosc032) THEN RUN destroy IN wgbosc032.
                                
                                /* deleta etiquetas */
                               FOR EACH tt-etiqueta:
                                 DELETE tt-etiqueta.
                               END.
                               
                               Create tt-etiqueta.
                               Assign tt-etiqueta.id-etiqueta = tt-transf-wms-bkp.num-serial
                                   tt-etiqueta.qtd-item = (tt-transf-wms-bkp.qtd-item - tt-transf-wms-bkp.qtd-item-retirado).

                               /*Efetivação da saída*/
                                RUN wmp/wm9091.p (INPUT r-box-movto, /*row da saída*/
                                      INPUT ttWork.num-box-orig, /* box destino  */
                                      INPUT tt-transf-wms-bkp.cod-usuario,
                                      INPUT tt-transf-wms-bkp.cod-equipamento, /* equipto */
                                      INPUT ttWork.cod-coletor, /* coletor */
                                      INPUT TIME, /* hora inicio */
                                      INPUT NO,
                                      INPUT 0,
                                      INPUT  i-ind-status-saldo-origem,
                                      OUTPUT o-ind-status-saldo-origem,
                                      INPUT  i-id-movto-box-saldo, 
                                      OUTPUT o-id-movto-box-saldo,
                                      INPUT TABLE tt-etiqueta,
                                      OUTPUT TABLE RowErrors).
                                IF CAN-FIND(FIRST RowErrors NO-LOCK)
                                THEN DO:
                                    FIND FIRST RowErrors NO-LOCK NO-ERROR.
        
                                     Assign vLogErro = Yes.
                                    {bcp/bc9105.i "305" "Erro no processo de sa¡da API wm9091. (DC)"}
                                    RETURN Error.
                                END.
                            END.
                        END.

                    /*fim da criação de Doc.*/

                   IF NOT VALID-HANDLE(wgbosc145)  THEN DO:
                      Run scbo/bosc145.p Persistent SET wgbosc145.
                      Run openQueryStatic In wgbosc145 (Input "Main":U) No-error. 
                   END.                      

                   run GoToKey in wgbosc145 (input tt-transf-wms-bkp.cod-estabel,
                                             input tt-transf-wms-bkp.cod-local,
                                             INPUT tt-transf-wms-bkp.cod-item,
    							             INPUT tt-transf-wms-bkp.cod-embalagem).

                   IF RETURN-VALUE = 'OK' then do:
                      run getDecField in wgbosc145 (input "qtd-peso":U,
                                                    OUTPUT vQtdPeso).
                      run getDecField in wgbosc145 (input "qtd-volume":U,
                                                    output vQtdVolume).
                   END.

                   /* Permitindo a transferˆncia Parcial das embalagens x seriais */
                   CREATE tt-docto-itens-emb-manual.
                   ASSIGN tt-docto-itens-emb-manual.cod-embalagem = b-tt-transf-wms-bkp.cod-embalagem
                          tt-docto-itens-emb-manual.qtd-volume    = vQtdVolume
                          tt-docto-itens-emb-manual.qtd-peso      = vQtdPeso
                          tt-docto-itens-emb-manual.qtd-item      = (b-tt-transf-wms-bkp.qtd-item - b-tt-transf-wms-bkp.qtd-item-retirado) /* Quantidade a ser retirada do item desta embalagem */
                          tt-docto-itens-emb-manual.qti-embalagem = if tt-transf-wms-bkp.num-serial = 0 then b-tt-transf-wms-bkp.qti-embalagem else tt-docto-itens-emb-manual.qti-embalagem + 1 /* Quantidade de embalagens a ser retirada */
                          tt-docto-itens-emb-manual.id-box        = b-tt-transf-wms-bkp.num-box-orig. 

                   ASSIGN b-tt-transf-wms-bkp.id-docto      = tt-transf-wms-bkp.id-docto
                          .
                   if tt-transf-wms-bkp.num-serial <> 0
                   then 
                       assign b-tt-transf-wms-bkp.num-seq-item  = tt-transf-wms-bkp.num-seq-item.

                   /* Validando Box, se compartilha endere‡os, e capacidade de armazenamento*/
                   run validateItemEmbBox in hDbosc035sto (input tt-docto-itens-emb-manual.cod-embalagem,
                                                           input tt-docto-itens-emb-manual.qtd-item,
                                                           input 0,
                                                           input vQtdVolume,
                                                           input vQtdPeso,
                                                           input tt-transf-wms-bkp.cod-item,
                                                           input tt-transf-wms-bkp.cod-refer,
                                                           input tt-transf-wms-bkp.cod-estabel,
                                                           input tt-transf-wms-bkp.cod-local,
                                                           input ttWork.num-box-orig,
                                                           input vCodBloco, 
                                                           input vCodRua,
                                                           input vCodNivel,
                                                           input vCodColuna,
                                                           input table tt-docto-itens-emb-manual,
                                                           input tt-transf-wms-bkp.cod-lote).

                   RUN pi_trata_erro_bloco_wms( INPUT  "BOSC035STO",
                                                INPUT  hDbosc035STO).

                   IF RETURN-VALUE = "NOK"  THEN DO: 
                       UNDO BLOCO-WMS, RETURN "NOK".
                   END.

                   /****************************************  Processo manual de entrada ******************************/
                    IF NOT VALID-HANDLE(wgbosc092) THEN DO:
                       RUN scbo/bosc092.p PERSISTENT SET wgbosc092 NO-ERROR.
                    END.

                   RUN validaEquipTransportador In wgbosc092 (INPUT  tt-transf-wms-bkp.cod-equipamento,
                                                   OUTPUT iCodTipoEquip,
                                                   OUTPUT vLogAtivo,
                                                   OUTPUT vLogProcesso).

                  /*Busca o movimento de entrada com base no movimento de saída*/
                  Find LAST ttWm-box-movto-idx
                           Where ttWm-box-movto-idx.cod-estabel    = tt-transf-wms-bkp.cod-estabel
                             And ttWm-box-movto-idx.cod-local      = tt-transf-wms-bkp.cod-local
                             AND ttWm-box-movto-idx.id-movto       = vTmp_id-movto  
                             AND ttWm-box-movto-idx.id-docto       = vTmp_id-docto
                             And ttWm-box-movto-idx.ind-tipo-movto = 1 /*Entrada*/
                           No-lock No-error.


                  If AVAIL ttWm-box-movto-idx Then DO:
                        IF NOT VALID-HANDLE(wgbosc032) THEN DO:
                           RUN scbo/bosc032.p PERSISTENT SET wgbosc032.
                           RUN openQueryStatic IN wgbosc032 (INPUT "Main":U) NO-ERROR.
                        END.
                                                   
                        RUN goToKey2 IN wgbosc032 ( INPUT ttWm-box-movto-idx.cod-estabel,
                                                    INPUT ttWm-box-movto-idx.cod-local,
                                                    INPUT ttWm-box-movto-idx.id-movto,
                                                    INPUT 1). /*alterado pra buscar o rowid a entrada*/

                        RUN getRowid IN wgbosc032 (OUTPUT r-box-movto).

                        IF VALID-HANDLE(wgbosc032) THEN RUN destroy IN wgbosc032.

                        /*Efetiva entrada*/
                        RUN wmp/wm9091.p (INPUT r-box-movto, /*Input – Rowid Movimento - ttWm-box-movto-idx.r-rowid*/
                              INPUT ttWork.num-box-orig, /* Input – IdBoxDestino – Endereço de destino. Informar o Box lido.*/
                              INPUT tt-transf-wms-bkp.cod-usuario, /*Input – usuário – Usuário que fez login no equipamento*/
                              INPUT tt-transf-wms-bkp.cod-equipamento, /* Input – equipamento – código do equipamento informado no login */
                              INPUT ttWork.cod-coletor, /* Input – coletor – código do coletor informado no login */
                              INPUT TIME, /* Input – hora de início da movimentação – informar hora atual (time) */
                              INPUT NO, /*Input – sobrepor – indica se deve sobrepor endereço – informa YES.*/
                              INPUT 0, /*Input – id agrupador – informar “0” (zero)*/
                              INPUT  o-ind-status-saldo-origem,
                              OUTPUT o-ind-status-saldo-origem,
                              INPUT  o-id-movto-box-saldo, 
                              OUTPUT o-id-movto-box-saldo,
                              INPUT TABLE tt-etiqueta, /*Input table – tt-etiqueta – gravar a etiqueta lida na tabela temporária e sua respectiva quantidade movimentada (qtd-item – qtd-item-retirado)*/
                              OUTPUT TABLE RowErrors). /*Output table – erros – RowErrors.*/
                        IF CAN-FIND(FIRST RowErrors NO-LOCK)
                        THEN DO:
                            FIND FIRST RowErrors NO-LOCK NO-ERROR. 
                             Assign vLogErro = Yes.
                            {bcp/bc9105.i "305" "Erro no procesos de entrada na API wm9091. (DC)"}
                            RETURN Error.
                        END.
                   END.
               END.

               /* grava na bc-trans e bc-trans-filho */
               FIND FIRST ttwm-docto NO-LOCK NO-ERROR.
               FOR EACH tt-trans-filho:
                   DELETE tt-trans-filho.
               END.
               assign vDetalhe = 'Est:':U + STRING(ttWork.cod-estabel)  + ';':U +
                                 'Loc:':U + STRING(ttWork.cod-local)    + ';':U + 
                                 'Doc:':U + string(ttwm-docto.id-docto).
               find first tt-trans no-error. /* Apenas criar a transa‡Æo na primeira intera‡Æo parcial da transa‡Æo, para facilitar a rastreabilidade e consulta da transa‡Æo pelo DC */
               If not avail tt-trans Then do:
                   CREATE tt-trans.
                   ASSIGN tt-trans.cod-versao-integracao = 1
                          tt-trans.i-sequen = 1
                          tt-trans.cd-trans = 'WMOut001':U
                          tt-trans.detalhe = vDetalhe
                          tt-trans.usuario = ttwork.cod-usuario.
                          tt-trans.etiqueta = NO.
               End.

               assign v-count = 0.
               FOR EACH tt-transf-wms-bkp:
                   If tt-transf-wms-bkp.ind-tip-movto = 1 Then do: /* NÆo gerando registro de transa‡Æo para movimentos de sa¡da que nÆo possuem entrada */
                       find first b-tt-transf-wms-bkp where
                           b-tt-transf-wms-bkp.cod-livre-2   = string(rowid(tt-transf-wms-bkp))and
                           b-tt-transf-wms-bkp.ind-tip-movto = 2 no-error.
                       If not avail b-tt-transf-wms-bkp Then
                            next.
                   End.
                   ASSIGN v-count = v-count + 1.
                   IF tt-transf-wms-bkp.ind-tip-movto = 1
                      THEN ASSIGN v-tipo = "Sa¡da". 
                      ELSE ASSIGN v-tipo = "Entrada".

                   CREATE tt-trans-filho.
                   ASSIGN tt-trans-filho.i-sequen-pai = 1
                          tt-trans-filho.i-sequen     = v-count    
                          tt-trans-filho.num-versao   = 1.
                   If tt-transf-wms-bkp.num-serial <> 0 Then
                       assign tt-trans-filho.conteudo-xml = 'Tip:' + chr(30) + STRING(v-tipo) + chr(30) + 
                                                            'Box:' + chr(30) + STRING(tt-transf-wms-bkp.num-box-orig)  + chr(30) +
                                                            'Ser:' + chr(30) + STRING(tt-transf-wms-bkp.num-serial,'>>>>>>>>>>>>>9':U).
                   else
                       assign tt-trans-filho.conteudo-xml = 
                                'Tip:' + chr(30) + STRING(v-tipo) + chr(30)  
                              + 'Box:' + chr(30) + STRING(tt-transf-wms-bkp.num-box-orig)  + chr(30) 
                              + 'Item'            + CHR(30) + tt-transf-wms-bkp.cod-item              + CHR(30)
                              + 'Embalagem'       + CHR(30) + string(tt-transf-wms-bkp.cod-embalagem) + CHR(30) 
                              + 'Quantidade'      + CHR(30) + String(tt-transf-wms-bkp.qtd-item)      + CHR(30)
                              + 'Lote'            + CHR(30) + tt-transf-wms-bkp.cod-lote              + CHR(30)
                              + 'Referencia'      + CHR(30) + tt-transf-wms-bkp.cod-refer.
               END.
               /*faz validações na bc-trans e volta a transação se não obtiver êxito (manter por compatibilidade)*/
               Run gravaTransacao. 
               ASSIGN vLogFinaliza = YES. 

               Assign entry(2,vDesLidos,"/") = string(integer(entry(2,vDesLidos,"/")) - vNumLidos)
                      vNumLidos = 0.

               disp vDeslidos with frame Frame01.

               If return-value = "NOK":U Then do:
                   If avail tt-transf-wms-bkp Then undo BLOCO-WMS, return "OK".
                       else undo BLOCO-WMS, Return Return-value.
                   /* Verificando retorno com erro e desfazendo toda a transa‡Æo */
               End.
               else do:
                   If entry(2,vDesLidos,"/") = "0" Then
                       For each tt-trans:
                            delete tt-trans.
                       End.
                   return return-value.
               End.
            END.
        END.
    END.
    ELSE DO:
        {bcp/bc9105.i "987" "Transferˆncia Cancelada. (bc9025f)"}
        RETURN "CAN".
    END.
End Procedure.

/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame03}.                       **
***************************************************************************************************/
PROCEDURE gravatransacao:

    IF NOT VALID-HANDLE(wgbcapi001) THEN DO:
        run bcp/bcapi001.p persistent set wgbcapi001 (input-output table tt-trans,
                                                      input-output table tt-erro).
    END.

    RUN cria_reg_wms  in wgbcapi001 (INPUT 1,INPUT-OUTPUT TABLE tt-trans, INPUT-OUTPUT TABLE tt-trans-filho,INPUT-OUTPUT TABLE tt-erro).

    find first tt-erro no-error.
    if avail tt-erro THEN DO: 
       FOR EACH tt-erro:
           Assign tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.

           DO ON ENDKEY UNDO,RETRY:
            {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
           END.
       END.
       RETURN "NOK".
    END.

    find first ttWm-etiqueta-bkp no-lock no-error.

    RUN bcp/bc9025g.p (INPUT-OUTPUT TABLE tt-trans,
                       INPUT-OUTPUT TABLE tt-erro).

    find first tt-erro no-error.

    if  avail tt-erro 
    OR  RETURN-VALUE = 'NOK':U 
    THEN DO ON ENDKEY UNDO,RETRY: 
        {bcp/bc9105.i "903" "Problemas na Efetiva‡Æo. (WMS)"}
        FOR EACH tt-erro:
            {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
        END.
        RETURN "NOK".
    END.
    ELSE DO:
        {bcp/bc9105.i "902" "Transferˆncia OK"}
    END.
    empty temp-table tt-erro.

    RETURN RETURN-VALUE.

END PROCEDURE.

/************************************************************************************************************************************/
/************************************************************************************************************************************/
/************************************************************************************************************************************/
PROCEDURE pi_trata_erro_bloco_wms:
    DEF INPUT PARAM pcPrograma AS CHAR   NO-UNDO.
    DEF INPUT PARAM phPrograma AS HANDLE NO-UNDO.

    DEF VAR cCodErro AS CHAR NO-UNDO.
    DEF VAR cMsgErro AS CHAR NO-UNDO.
    DEF VAR lerror   AS LOG  NO-UNDO.

    IF Return-value = 'NOK' Then Do:

       RUN getRowErrors in phPrograma (OUTPUT TABLE RowErrors).

       For Each RowErrors:
          
           ASSIGN lerror = TRUE.
           DO ON ENDKEY UNDO,RETRY:
               {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)  + "(WMS) (Programa: " + pcPrograma + ")"}
           END.  
       END.

       IF lerror
           THEN do:
               Assign vLogErro = Yes.
               RETURN "NOK":U.       
       END.

       
      ASSIGN cCodErro = "0"
              cMsgErro = "ERRO RETORNADO PELO PROGRAMA: " + pcPrograma + "(DC)".

       DO ON ENDKEY UNDO,RETRY:
          {bcp/bc9015.i2 cCodErro cMsgErro}
       END.

       Assign vLogErro = Yes.
       RETURN "NOK":U.       

    End.
    ELSE DO: 
        run getRowErrors in phPrograma (output table RowErrors).                   

        For Each RowErrors
            BREAK BY RowErrors.ErrorNumber:

            DO ON ENDKEY UNDO,RETRY:
               {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription) + "(WMS) (Programa: " + pcPrograma + ")"}
            END.                                

            IF last(RowErrors.ErrorNumber)
            THEN do:
                Assign vLogErro = Yes.
                RETURN "NOK":U.       
            END.
        END.
    END.
END PROCEDURE.

/*Gozdecki*/
PROCEDURE pi-getValorParametro :
/*------------------------------------------------------------------------------
  Purpose:     Busca o parametro cadastrado na bc-param-ext
  Parameters:  Retorna o valor do parametro
  
  Notes:       Faz tres buscas at² achar o parametro.
                - Busca o parametro para item
                - Busca o parametro para a familia
                - Busca o parametro para a transacao
                - Se n’o achou, retorna 0
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p-cItCodigo    AS CHARACTER  NO-UNDO. /*codigo do item*/
DEFINE INPUT  PARAMETER p-cTransacao   AS CHARACTER  NO-UNDO. /*transacao*/
DEFINE INPUT  PARAMETER p-cCodParamExt AS CHARACTER  NO-UNDO. /*codigo do parametro*/
DEFINE OUTPUT PARAMETER p-iParametro   AS INTEGER    NO-UNDO. 

    /* Procura se existe o item cadastrado para esse parametro */
    FIND FIRST bc-param-ext NO-LOCK
         WHERE bc-param-ext.cod-entidade-param-ext   = "bc-tipo-trans" 
           AND bc-param-ext.cod-chave-param-ext      = p-cItCodigo
           AND bc-param-ext.cod-param-ext            = p-cCodParamExt
        NO-ERROR.

    /* Se n’o achar, busca pela familia */
    IF NOT AVAIL bc-param-ext THEN DO:
        /* Procura o cadastro de item para poder pegar a familia */
        FIND FIRST wm-item NO-LOCK
             WHERE wm-item.cod-item = p-cItCodigo NO-ERROR.

        /* Procura os parametros para a familia */
        FIND FIRST bc-param-ext NO-LOCK
             WHERE bc-param-ext.cod-entidade-param-ext   = "bc-ext-familia" 
               AND bc-param-ext.cod-chave-param-ext      = wm-item.cod-familia
               AND bc-param-ext.cod-param-ext            = p-cCodParamExt
            NO-ERROR.

        /* Se n’o achou, busca pela transacao */
        IF NOT AVAIL bc-param-ext THEN DO:
            FIND FIRST bc-param-ext NO-LOCK
                 WHERE bc-param-ext.cod-entidade-param-ext   = "bc-tipo-trans" 
                   AND bc-param-ext.cod-chave-param-ext      = p-cTransacao
                   AND bc-param-ext.cod-param-ext            = p-cCodParamExt
                NO-ERROR.

            /* Se n’o encontrou, adiciona o valor default */
            IF NOT AVAIL bc-param-ext THEN DO:
                ASSIGN p-iParametro = 0.
            END.
        END.
    END.

    /*  */
    IF AVAIL bc-param-ext THEN DO: 
        IF bc-param-ext.ind-tipo-dado = 5 THEN DO: /* Param Logico */
            ASSIGN p-iParametro = IF bc-param-ext.param-logico THEN 1 ELSE 2.
        END.

    END.
END PROCEDURE.
/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame03}.                        **
****************************************************************************************************/
PROCEDURE piSolicitaCordenada:

    DEFINE FRAME FrameNavegIDWMS
        'Transferˆncia WMS'                                At Row 01 Col 01
        '------------------':U                             At Row 02 Col 01
        'Bloco:'                                           At Row 03 Col 01
        vCodBloco                                          At Row 03 Col 10 NO-LABEL
        'Rua:'                                             At Row 04 Col 01
        vCodRua                                            At Row 04 COL 10 NO-LABEL
        'N¡vel:'                                           At Row 05 Col 01
        vCodNivel                                          At Row 05 Col 10 NO-LABEL
        'Coluna:'                                          At Row 06 Col 01
        vCodColuna                                         At Row 06 Col 10 NO-LABEL
       With 1 down font 3 Size 20 BY 8 No-box.

    UPDATE  vCodBloco
            vCodRua
            vCodNivel
            vCodColuna
    WITH FRAME FrameNavegIDWMS.

    HIDE FRAME FrameNavegIDWMS NO-PAUSE.

    RUN retornaEnderecoBox2 In wgbosc030 (INPUT ttWork.cod-estabel,
                                          INPUT ttWork.cod-local,
                                          INPUT vCodBloco,
                                          INPUT vCodRua,
                                          INPUT vCodNivel,
                                          INPUT vCodColuna,
                                          OUTPUT ttWork.num-box-orig).

    IF  ttWork.num-box-orig = 0
    THEN
        DO ON ENDKEY UNDO,RETRY:
           {bcp/bc9105.i "159" "BOX nÆo encontrado para a coordenada informada.(bc9025f)"}
        END.                                
    ELSE
        ASSIGN ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 = string(ttWork.num-box-orig).

END PROCEDURE.
&else 
    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif


