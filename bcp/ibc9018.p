/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9018 2.00.00.016 } /*** 010016 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BC9018 MBC}
&ENDIF

{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */

/********************************************************************************************
**   Programa..: bc9018.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - setembro/2002 - karla Klemke - Cria‡Æo do programa          **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Picking WMS                      **
**                                                                                         **
********************************************************************************************/
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
**                        Ex: &global-define ActiveObject wgBOSC074                               **
***************************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9018
/************************************************************/

/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-picking-wms
{bcp/bc9018.i " "}
{bcp/bc9018.i1 "New"}
{utp/utapi009.i} /* login */
{bcp/bc9048.i1} /* definicao variaveis menu padrao */

Create ttWork.

DEFINE VARIABLE vnr-pedcli              AS CHARACTER FORMAT 'x(12)':U     INIT ''  NO-UNDO.
DEFINE VARIABLE vnome-abrev             AS CHARACTER FORMAT 'x(12)':U     INIT ''  NO-UNDO.
DEFINE VARIABLE vcod-item               AS CHARACTER FORMAT 'x(16)':U     INIT ''  NO-UNDO.
DEFINE VARIABLE vdes-item               AS CHARACTER FORMAT 'x(18)':U     INIT ''  NO-UNDO. 
DEFINE VARIABLE c-desc-item             AS CHARACTER                               NO-UNDO.
DEFINE VARIABLE vcod-senha              AS CHARACTER FORMAT 'x(14)':U              NO-UNDO.
DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE cod-estab-roteiriz LIKE ttWm-box-movto-idx-picking.cod-estabel  NO-UNDO.
DEFINE VARIABLE cod-local-roteiriz LIKE ttWm-box-movto-idx-picking.cod-local    NO-UNDO.
DEFINE VARIABLE id-movto-roteiriz  LIKE ttWm-box-movto-idx-picking.id-movto     NO-UNDO.
DEFINE VARIABLE v-rowid-tt-dep-hora AS ROWID NO-UNDO.


Define Temp-table tt-mostra-locais NO-UNDO
    Field num-seq           As Integer
    Field des-local         As Character Format 'X(19)':U
    FIELD it-codigo         AS CHAR
    FIELD is-ckd            AS LOGICAL
    Field rowid-box-movto   As Rowid
        Index ID num-seq.

Define Temp-table tt-locais-filhos-ckd NO-UNDO LIKE tt-mostra-locais.

DEFINE TEMP-TABLE tt-serial NO-UNDO
       FIELD id-etiqueta          LIKE wm-etiqueta.id-etiqueta
       FIELD qtd-item-retirado    LIKE wm-etiqueta.qtd-item-retirado
       FIELD id-movto             LIKE wm-movto.id-movto
       INDEX idx-serial  AS PRIMARY /*UNIQUE*/ id-etiqueta.

DEFINE TEMP-TABLE tt-dep-hora NO-UNDO 
  FIELD cod-depos   AS CHAR
  FIELD cod-localiz AS CHAR
  FIELD hora-depos  AS CHAR
  FIELD cod-usuario AS CHAR
  FIELD r-rowid     AS ROWID.

Define Query qry-wm-box-movto For tt-mostra-locais.

Define Browse brw-wm-box-movto Query qry-wm-box-movto No-lock
      Display tt-mostra-locais.des-local
              With No-box No-labels Size 20 By 2.5 No-scrollbar-vertical.

Define Query qry-wm-dep-movto For tt-dep-hora.

DEFINE BROWSE brw-wm-dep-movto QUERY qry-wm-dep-movto NO-LOCK NO-WAIT
      Display tt-dep-hora.cod-depos FORMAT "x(10)"
              tt-dep-hora.cod-localiz FORMAT "x(3)"
              tt-dep-hora.hora      FORMAT "x(5)"
              With No-box No-labels Size 20 By 7 NO-SCROLLBAR-VERTICAL.
                                
/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Picking WMS'                                      At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                             ttWork.cod-usuario                                 At Row 03 Col 05 No-label ~
                             'Sen:'                                             AT ROW 04 COL 01          ~
                             vcod-senha                                         AT ROW 04 COL 05 NO-LABEL ~
                             'Col:'                                             At Row 05 Col 01          ~
                             ttWork.cod-coletor                                 At Row 05 Col 05 No-label ~
                             'Equ:'                                             At Row 06 Col 01          ~
                             ttWork.cod-equipamento                             At Row 06 Col 05 No-label ~
&global-define Frame01Repeat No

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Picking WMS'                                      At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             '1 - Tarefas P£blicas'                             At Row 03 Col 01          ~
                             '2 - Minhas Tarefas'                               At Row 04 Col 01          ~
                             '3 - Tarefas Equipto'                              At Row 05 Col 01          ~
                             '4 - Meus Processos'                               At Row 06 Col 01          ~
                             'Op‡Æo:'                                           At Row 07 Col 01          ~
                              ttWork.opcao                                      At Row 07 Col 08 NO-LABEL ~

&global-define Frame02Repeat No
/************************************************************/

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Picking WMS'                                      At Row 01 Col 01          ~
                             brw-wm-dep-movto                                   At Row 02 Col 01          ~
                                                                               
&global-define Frame03Repeat NO
/************************************************************/


/* Definicao da Frame04 ---                                 */
&global-define Frame04Name   Frame04
&global-define Frame04Defs   'Picking WMS'                                      At Row 01 Col 01          ~
                             brw-wm-box-movto                                   At Row 02 Col 01          ~
                             'Ped:'                                             AT ROW 05 COL 01          ~
                             vnr-pedcli                                         At Row 05 Col 06 No-label ~
                             'Cli:'                                             AT ROW 06 COL 01          ~
                             vnome-abrev                                        AT ROW 06 COL 06 NO-LABEL ~
                             'It:'                                              AT ROW 07 COL 01          ~
                             vcod-item                                          AT ROW 07 COL 03 NO-LABEL ~
                             vdes-item                                          AT ROW 08 COL 01 NO-LABEL ~
                             
&global-define Frame04Repeat YES
/************************************************************/

/************************************************************/



/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = '' ~
                              vcod-senha WHEN ttWork.cod-usuario = '' ~
                              ttWork.cod-coletor ~
                              ttWork.cod-equipamento

&global-define Update02Fields ttwork.opcao

&global-define Update03Fields brw-wm-dep-movto

&global-define Update04Fields brw-wm-box-movto


/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03.
&global-define TriggerBeforeFrame04 Run InicializaCamposFrame04. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02.
&global-define TriggerAfterFrame03  Run GravaCamposFrame03. 
&global-define TriggerAfterFrame04  Run GravaCamposFrame04. 

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ~
                            ON ENTRY OF ttWork.cod-coletor IN FRAME {&Frame01Name} ~
                            DO:                                                    ~
                                IF v_cod-coletor_corren     <> '' AND              ~
                                   v_cod-equipamento_corren <> '' THEN DO:         ~
                                    IF l-menu-padrao = YES THEN DO:                ~
                                        ASSIGN l-menu-padrao = NO.                 ~
                                        APPLY "Enter":U TO ttWork.cod-equipamento IN FRAME {&Frame01Name}. ~
                                    END.                                           ~
                                    ELSE DO:                                       ~
                                        APPLY "ESC":U TO ttWork.cod-coletor IN FRAME {&Frame01Name}. ~
                                    END.                                           ~
                                    RETURN NO-APPLY.                                   ~
                                END.                                               ~
                            END.                                                   ~
                            ON 'Return':U  OF brw-wm-dep-movto In Frame {&Frame03Name}              ~
                            DO:                                                                     ~
                                Apply 'Go' To This-procedure.                                     ~
                            END.                                                                    ~
                            ON 'Return':U        OF brw-wm-box-movto In Frame {&Frame04Name}        ~
                            DO:                                                                     ~
                                  Apply 'Go' To This-procedure.                                     ~
                            END.                                                                    ~
                            ON 'value-changed':U OF brw-wm-box-movto In Frame {&Frame04Name}        ~
                            DO:                                                                     ~
                                Find ttWm-box-movto-idx-picking                                                  ~
                                    Where Rowid(ttWm-box-movto-idx-picking) = tt-mostra-locais.rowid-box-movto   ~
                                           No-error.                                                             ~
                                If  Not Available ttWm-box-movto-idx-picking Then Return No-apply.               ~
                                Run getInfoDoctoItens IN wgbosc096 (Input ttWm-box-movto-idx-picking.cod-estabel,  ~
                                                                    Input ttWm-box-movto-idx-picking.cod-local,    ~
                                                                    Input ttWm-box-movto-idx-picking.id-docto,     ~
                                                                    Input ttWm-box-movto-idx-picking.num-seq-item, ~
                                                                    Output Table ttwm-docto-itens ).               ~
                                Find First ttwm-docto-itens.                                                                             ~
                                RUN goToKey IN wgbosc044 (INPUT tt-mostra-locais.it-codigo). /* Vari vel ou Campo com o c¢digo do Item */ ~
                                IF RETURN-VALUE = "OK":U THEN DO:                                                                        ~
	                                RUN getCharField IN wgbosc044 (INPUT "des-item":U,                                                   ~
                                                                   OUTPUT c-desc-item). /* Vari vel ou Campo com a descri‡Æo do Item */  ~
                                    ASSIGN vdes-item:SCREEN-VALUE   IN FRAME Frame04 = TRIM(SUBSTRING(c-desc-item,1,18)).                ~
                                END.                                                                                                     ~
                                ELSE DO:                                                                                                 ~
	                                ASSIGN vdes-item:SCREEN-VALUE   IN FRAME Frame04 = ''.                                               ~
                                END.   ~
                                FIND FIRST wm-docto WHERE wm-docto.id-docto = ttWm-box-movto-idx-picking.id-docto NO-LOCK NO-ERROR.				 ~
                                ASSIGN vcod-item:SCREEN-VALUE   IN FRAME Frame04 = TRIM(tt-mostra-locais.it-codigo)                      ~
                                       vnr-pedcli:screen-value  In Frame Frame04 = trim(IF AVAIL wm-docto THEN wm-docto.num-docto ELSE '')            ~
                                       vnome-abrev:screen-value In Frame Frame04 = trim(ttWm-box-movto-idx-picking.nome-abrev).          ~
                            END.                                                                                                         ~
                            ON 'value-changed':U  OF brw-wm-dep-movto In Frame {&Frame03Name}       ~
                            DO:                                                                     ~
                                ASSIGN v-rowid-tt-dep-hora = rowid(tt-dep-hora).                    ~
                            END.                                                                    ~
                            
                            
/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1  wgbosc030
&global-define ActiveObject2  wgbosc032
&global-define ActiveObject3  wgbosc044
&global-define ActiveObject4  wgbosc079
&global-define ActiveObject5  wgbc9018f
&global-define ActiveObject6  wgbosc092
&global-define ActiveObject7  wgbosc096
&global-define ActiveObject8  wgbosc135

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
FUNCTION isCKD RETURNS LOGICAL ( pCodItem AS CHAR ) FORWARD.
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
    ASSIGN vLogErro = NO
           vLogCancela = NO.
    /* caso tenha sido startado login autom tico */
    IF v_cod_usuar_corren <> '' THEN DO: 
        assign vcod-senha:blank in frame frame01 = NO.
        ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = v_cod_usuar_corren
               ttWork.cod-usuario                               = v_cod_usuar_corren
               vcod-senha                                       = '****************':U /* login autom tico */
               vcod-senha:SCREEN-VALUE IN FRAME frame01         = '****************':U. /* login autom tico */
        IF v_cod-coletor_corren     <> '' AND 
           v_cod-equipamento_corren <> '' THEN DO:
            ASSIGN ttWork.cod-coletor:SCREEN-VALUE IN FRAME {&Frame01Name}     = v_cod-coletor_corren
                   ttWork.cod-coletor     = v_cod-coletor_corren
                   ttWork.cod-equipamento:SCREEN-VALUE IN FRAME {&Frame01Name} = v_cod-equipamento_corren
                   ttWork.cod-equipamento = v_cod-equipamento_corren.
       END.
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

    ASSIGN vLogErro = NO
           vLogCancela = NO
           vLogSai = NO.

    IF v_cod_usuar_corren = '' THEN RETURN ERROR.
End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame03:

    ASSIGN vLogErro        = NO
           vLogCancela     = NO
           vLogEmProcesso  = NO.

    FIND FIRST tt-dep-hora NO-LOCK NO-ERROR.
    IF RECID(tt-dep-hora) = ? THEN DO:
        CREATE tt-dep-hora.
        ASSIGN tt-dep-hora.cod-depos   = "Tarefa Ine"
               tt-dep-hora.cod-localiz = "xis"
               tt-dep-hora.hora        = "tente".
    END. 

    Open Query qry-wm-dep-movto For Each tt-dep-hora By tt-dep-hora.cod-depos BY tt-dep-hora.cod-localiz By tt-dep-hora.hora.

    Apply 'value-changed':U To brw-wm-dep-movto In Frame {&Frame03Name}.
    

End Procedure.                    

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame04}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame04:

    DEF VAR i-hora-ini AS INT NO-UNDO.
    DEF VAR i-hora-fim AS INT NO-UNDO.
    DEF VAR c-item-ckd AS CHAR NO-UNDO.

    ASSIGN vLogErro        = NO
           vLogCancela     = NO
           vLogEmProcesso  = NO.

    FIND FIRST tt-dep-hora
         WHERE rowid(tt-dep-hora) = v-rowid-tt-dep-hora NO-ERROR.

    IF AVAIL tt-dep-hora THEN DO:

        IF vLogerro = YES THEN RETURN ERROR. 

        IF NOT VALID-HANDLE(wgbosc044) THEN DO:
            Run scbo/bosc044.p Persistent Set wgbosc044       No-error.
            Run openQueryStatic In wgbosc044 (Input "Main":U) No-error.
        END.
    
        Empty Temp-table tt-mostra-locais.
        EMPTY TEMP-TABLE tt-locais-filhos-ckd.
    
        Assign vNumSeq = 0.
    
        RUN pi-converte-hora-ini-fim(INPUT tt-dep-hora.hora,
                                     OUTPUT i-hora-ini,
                                     OUTPUT i-hora-fim).

        wm-boxm:
        FOR EACH in-wm-tarefa-docto NO-LOCK
           WHERE in-wm-tarefa-docto.cod-local = tt-dep-hora.cod-depos
             AND in-wm-tarefa-docto.cod-localiz = tt-dep-hora.cod-localiz
             AND in-wm-tarefa-docto.hora     >= i-hora-ini
             AND in-wm-tarefa-docto.hora     <= i-hora-fim,
           EACH wm-tarefa-docto NO-LOCK
          WHERE wm-tarefa-docto.id-tarefa = in-wm-tarefa-docto.id-tarefa,
           Each ttWm-box-movto-idx-picking
          Where ttWm-box-movto-idx-picking.id-docto = wm-tarefa-docto.id-docto
            AND ttWm-box-movto-idx-picking.ind-tipo-movto = 2
                BREAK By ttWm-box-movto-idx-picking.nr-pedcli
                By ttWm-box-movto-idx-picking.nome-abrev
                By ttWm-box-movto-idx-picking.val-prioridade:

            /* Pegar Informacoes Box */
            Run SetConstraintBoxes  In wgbosc030 (Input ttWm-box-movto-idx-picking.cod-estabel,
                                                  Input ttWm-box-movto-idx-picking.cod-local,
                                                  Input ttWm-box-movto-idx-picking.id-box,
                                                  Input ttWm-box-movto-idx-picking.id-box).
    
            Run openQueryStatic In wgbosc030 (Input 'Boxes':U).
    
            Run getBatchRecords IN wgbosc030 (Input   ?,
                                              Input  NO,
                                              Input  ?,
                                              Output vNumCont,
                                              Output Table ttwm-box).
    
            Find First ttwm-box No-error.
    
            If Not Avail ttwm-box Then Next wm-boxm.
    
            Assign vNumSeq = vNumSeq + 1.

            IF in-wm-tarefa-docto.log-solicitado-kit-ckd THEN DO:
                
                FIND FIRST int-pedido-compr no-lock
                     WHERE int-pedido-compr.num-pedido = int(REPLACE(ttWm-box-movto-idx-picking.cod-lote,"PO","")) NO-ERROR.
                ASSIGN c-item-ckd = IF AVAIL int-pedido-compr THEN int-pedido-compr.cod-produto-ckd ELSE "".

                IF NOT CAN-FIND(FIRST tt-mostra-locais
                                WHERE tt-mostra-locais.it-codigo = c-item-ckd) THEN DO:
                    Create tt-mostra-locais.
                    Assign tt-mostra-locais.num-seq           = vNumSeq
                           tt-mostra-locais.it-codigo         = c-item-ckd
                           tt-mostra-locais.is-ckd            = YES
                           tt-mostra-locais.des-local         = ttwm-box.cod-bloco            + '/':U +
                                                                ttwm-box.cod-rua              + '/':U +
                                                                ttwm-box.cod-nivel            + '/':U +
                                                                ttwm-box.cod-coluna           + '/':U +
                                                                If ttwm-box.ind-posicao-box = 1 Then 'E' Else 'D'.
                           tt-mostra-locais.rowid-box-movto   = Rowid(ttWm-box-movto-idx-picking).                                                                                   
            
            
                    IF ttWm-box-movto-idx-picking.log-pend-ressup AND ttWork.opcao = 4 THEN
                        ASSIGN tt-mostra-locais.des-local = tt-mostra-locais.des-local + '  R'.
                END.

                Create tt-locais-filhos-ckd.
                Assign tt-locais-filhos-ckd.num-seq       = vNumSeq
                       tt-locais-filhos-ckd.it-codigo     = ttWm-box-movto-idx-picking.cod-item
                       tt-locais-filhos-ckd.is-ckd        = NO
                       tt-locais-filhos-ckd.des-local     = ttwm-box.cod-bloco            + '/':U +
                                                            ttwm-box.cod-rua              + '/':U +
                                                            ttwm-box.cod-nivel            + '/':U +
                                                            ttwm-box.cod-coluna           + '/':U +
                                                            If ttwm-box.ind-posicao-box = 1 Then 'E' Else 'D'.
                       tt-locais-filhos-ckd.rowid-box-movto  = Rowid(ttWm-box-movto-idx-picking).                                                                                   
        
        
                IF ttWm-box-movto-idx-picking.log-pend-ressup AND ttWork.opcao = 4 THEN
                    ASSIGN tt-locais-filhos-ckd.des-local = tt-mostra-locais.des-local + '  R'.
            END.
            ELSE DO:
                Create tt-mostra-locais.
                Assign tt-mostra-locais.num-seq           = vNumSeq
                       tt-mostra-locais.it-codigo         = ttWm-box-movto-idx-picking.cod-item
                       tt-mostra-locais.is-ckd            = NO
                       tt-mostra-locais.des-local         = ttwm-box.cod-bloco            + '/':U +
                                                            ttwm-box.cod-rua              + '/':U +
                                                            ttwm-box.cod-nivel            + '/':U +
                                                            ttwm-box.cod-coluna           + '/':U +
                                                            If ttwm-box.ind-posicao-box = 1 Then 'E' Else 'D'.
                       tt-mostra-locais.rowid-box-movto   = Rowid(ttWm-box-movto-idx-picking).                                                                                   
        
        
                IF ttWm-box-movto-idx-picking.log-pend-ressup AND ttWork.opcao = 4 THEN
                    ASSIGN tt-mostra-locais.des-local = tt-mostra-locais.des-local + '  R'.
            END.
    
        End. /*For Each ttWm-box-movto-idx-picking:*/
        
    END.

    FIND FIRST tt-mostra-locais NO-LOCK NO-ERROR.
    IF RECID(tt-mostra-locais) = ? THEN DO:
        CREATE tt-mostra-locais.
        ASSIGN tt-mostra-locais.num-seq   = 999
               tt-mostra-locais.des-local = 'NÆo existem tarefas (WMS)'.
    END.
    Open Query qry-wm-box-movto For Each tt-mostra-locais By tt-mostra-locais.des-local By tt-mostra-locais.num-seq.

    Apply 'value-changed':U To brw-wm-box-movto In Frame {&Frame04Name}.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:


    Assign vLogErro          = No
           vLogControlaLogin = NO.

    /* valida usuario mestre contra mguni do EMS */
    IF ttWork.cod-usuario = ''  THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "101" "Usu rio Inv lido (DC)"}
    END.

    IF v2_cod_usuar_corren = ''  THEN DO:
       FOR each tt-erros:
           DELETE tt-erros.
       END.
       login:
       do on error  undo login, leave login
       on quit   undo login, leave login
       on stop   undo login, leave login
       on endkey undo login, leave login: 
          run btb/btapi910za.p (input INPUT FRAME frame01 ttWork.cod-usuario, 
                                INPUT INPUT FRAME frame01 vCod-Senha, 
                                output table tt-erros) NO-ERROR.        
       end. 
       IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4753) THEN DO:
          {bcp/bc9105.i "4753" "Usu rio nÆo encontrado!(DC)"}
          Assign vLogErro           = Yes
                 v_cod_usuar_corren = ''.
          RETURN ERROR.
       END.
       ELSE DO:
          IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4758) THEN DO:
             {bcp/bc9105.i "4758" "Senha para o usu rio nÆo est  correta!(DC)"} 
              Assign vLogErro           = Yes
                     v_cod_usuar_corren = ''.
              RETURN ERROR.
          END.
       END.
       ASSIGN vLogControlaLogin = YES.
    END.

    /* executa-se neste ponto devido ao login */
    IF NOT VALID-HANDLE(wgbosc030) THEN DO:
        Run scbo/bosc030.p Persistent Set wgbosc030       No-error.
        Run openQueryStatic In wgbosc030 (Input "Main":U) No-error.
    END.

    IF NOT VALID-HANDLE(wgbosc096) THEN DO:
        Run scbo/bosc096.p Persistent Set wgbosc096       No-error.
        Run openQueryStatic In wgbosc096 (Input "Main":U) No-error.
    END.

    IF NOT VALID-HANDLE(wgbosc032) THEN DO:
        Run scbo/bosc032.p Persistent Set wgbosc032       No-error.
        Run openQueryStatic In wgbosc032 (Input "Main":U) No-error.
    END.

    IF NOT VALID-HANDLE(wgbosc044) THEN DO:
        Run scbo/bosc044.p Persistent Set wgbosc044       No-error.
        Run openQueryStatic In wgbosc044 (Input "Main":U) No-error.
    END.

    IF NOT VALID-HANDLE(wgbosc079)  THEN DO:
        Run scbo/bosc079.p Persistent Set wgbosc079.
        Run openQueryStatic In wgbosc079 (Input "Main":U) No-error.
    END.

    IF NOT VALID-HANDLE(wgbosc135)  THEN DO:
        Run scbo/bosc135.p Persistent Set wgbosc135.
        Run openQueryStatic In wgbosc135 (Input "Main":U) No-error.
    END.

    /* Valida se usu rio tem permissÆo para executar a tarefa. */
    RUN validaUsuarioTarefa In wgbosc135 (Input ttWork.cod-usuario,
                                          INPUT 07).
    If  Return-value <> 'OK':U Then Do:
        Assign vLogErro = YES.
        IF vLogControlaLogin = YES THEN
           ASSIGN v_cod_usuar_corren  = ''
                  v2_cod_usuar_corren = ''.
        {bcp/bc9105.i "100" "Usu rio sem permissÆo para executar Picking (WMS)"}
        Return Error.
    END.

    Run validaUsuario In wgbosc079 (Input input Frame Frame01 ttWork.cod-usuario,
                                    OUTPUT vLogUtilizaColetor,
                                    OUTPUT vLogAprovaFatura).
    If Return-value <> 'OK':U Then Do:
       Assign vLogErro = YES.
       IF vLogControlaLogin = YES THEN
          ASSIGN v_cod_usuar_corren  = ''
                 v2_cod_usuar_corren = ''.
       Run getrowErrors In wgbosc079 (output Table RowErrors).
       For Each RowErrors:
           ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
           {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
       END.                                           
    End.

    IF  vLogUtilizaColetor = NO THEN DO:
        Assign vLogErro = Yes.
        IF vLogControlaLogin = YES THEN
           ASSIGN v_cod_usuar_corren  = ''
                  v2_cod_usuar_corren = ''.
        {bcp/bc9105.i "101" "Usu rio sem permissÆo para utilizar Coletor (WMS)"}
        Return Error.
    END.


    IF ttWork.cod-coletor = ''  THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "102" "Coletor Inv lido (WMS)"}
    END.

    If  ttWork.cod-equipamento = '' Then Do:
       Assign vLogErro = Yes.
       {bcp/bc9105.i "103" "Equipamento Inv lido (WMS)"}
    End.

    If vLogErro = Yes Then Return Error.

    IF NOT VALID-HANDLE(wgbosc092) THEN DO:
       Run scbo/bosc092.p Persistent Set wgbosc092 No-error.
       Run EmptyRowErrors In wgbosc092.
    END.

    Run validaEquipColetor In wgbosc092  (Input  ttWork.cod-coletor,
                                          Output vCodTipoEquip,
                                          Output vLogAtivo,
                                          Output vLogProcesso).
    If  Return-value <> 'OK':U Then Do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "103" "Coletor Inv lido (WMS)"}
    End.

    If   vLogAtivo = No Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "103" "Coletor Inativo (WMS)"}
    End.

    If vLogErro = Yes Then Return Error.

    Run validaEquipTransportador In wgbosc092  (Input  ttWork.cod-equipamento,
                                                Output vCodTipoEquip,
                                                Output vLogAtivo,
                                                Output vLogProcesso).
    If  Return-value <> 'OK':U Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "104" "Equipamento Inv lido (WMS)"}
    End.

    If   vLogAtivo = No Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "105" "Equipamento Inativo (WMS)"}
    End.
    If vLogErro = Yes Then Return Error.

    Assign  {&TempTable}.cod-usuario     = ttWork.cod-usuario 
            {&TempTable}.cod-coletor     = ttWork.cod-coletor
            {&TempTable}.cod-equipamento = ttWork.cod-equipamento.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame02:

    DEF VAR i-hora-ini AS INT NO-UNDO.
    DEF VAR i-hora-fim AS INT NO-UNDO.
    DEFINE VARIABLE v-log-achou AS LOGICAL     NO-UNDO.

    ASSIGN vLogErro = NO.
    IF input Frame Frame02 ttWork.opcao <> 1 AND
       input Frame Frame02 ttWork.opcao <> 2 AND
       input Frame Frame02 ttWork.opcao <> 3 AND
       input Frame Frame02 ttWork.opcao <> 4 THEN do:
       {bcp/bc9105.i "100" "Op‡Æo Inv lida (DC)"}
       Hide All.
       RETURN ERROR. 
    END.

    ASSIGN {&TempTable}.opcao  = input Frame Frame02 ttWork.opcao.

    Assign vLogIniciado = No.

    Assign ttWork.qtd-embal-lidas  = 0
           ttWork.des-seriais      = ''
           ttWork.num-box-lido     = 0
           ttWork.num-doca         = 0
           ttWork.qtd-embal-lidas  = 0
           ttWork.qtd-item-digit   = 0.

    ASSIGN vLogErro        = NO
           vLogCancela     = NO
           vLogEmProcesso  = NO.

    Empty Temp-table tt-mostra-locais. 
    EMPTY TEMP-TABLE tt-locais-filhos-ckd.
    Empty Temp-table tt-dep-hora.

 /* trocado for each para melhorar performance  
    FOR EACH in-wm-tarefa-docto NO-LOCK,
        EACH wm-tarefa-docto NO-LOCK
       WHERE wm-tarefa-docto.id-tarefa = in-wm-tarefa-docto.id-tarefa
         AND wm-tarefa-docto.ind-status-tarefa-docto < 3,
       FIRST wm-docto NO-LOCK
       WHERE wm-docto.cod-estabel = wm-tarefa-docto.cod-estabel
         AND wm-docto.cod-local   = wm-tarefa-docto.cod-local
         AND wm-docto.id-docto    = wm-tarefa-docto.id-docto
       BREAK BY in-wm-tarefa-docto.cod-local
             BY in-wm-tarefa-docto.cod-localiz
             BY in-wm-tarefa-docto.hora: */

    FOR EACH wm-tarefa-docto NO-LOCK
       WHERE wm-tarefa-docto.ind-status-tarefa-docto < 3,
        EACH in-wm-tarefa-docto  NO-LOCK
       WHERE in-wm-tarefa-docto.id-tarefa = wm-tarefa-docto.id-tarefa,
       FIRST wm-docto NO-LOCK
       WHERE wm-docto.cod-estabel = wm-tarefa-docto.cod-estabel
         AND wm-docto.cod-local   = wm-tarefa-docto.cod-local
         AND wm-docto.id-docto    = wm-tarefa-docto.id-docto
       BREAK BY in-wm-tarefa-docto.cod-local
             BY in-wm-tarefa-docto.cod-localiz
             BY in-wm-tarefa-docto.hora:

        IF FIRST-OF(in-wm-tarefa-docto.cod-localiz) or
           FIRST-OF(in-wm-tarefa-docto.cod-local) or
           FIRST-OF(in-wm-tarefa-docto.hora) THEN DO:
            
            IF NOT CAN-FIND(FIRST tt-dep-hora
                            WHERE tt-dep-hora.cod-localiz = in-wm-tarefa-docto.cod-localiz
                              AND tt-dep-hora.cod-depos   = in-wm-tarefa-docto.cod-local
                              AND tt-dep-hora.hora        = string(in-wm-tarefa-docto.hora-tarefa, "HH:MM")) THEN DO:
        
                CREATE tt-dep-hora.
                ASSIGN tt-dep-hora.cod-depos   = in-wm-tarefa-docto.cod-local
                       tt-dep-hora.cod-localiz = in-wm-tarefa-docto.cod-localiz
                       tt-dep-hora.hora        = string(in-wm-tarefa-docto.hora-tarefa,"HH:MM")
                       tt-dep-hora.r-rowid     = ROWID(in-wm-tarefa-docto).
            END.
        END.
    END.

    RUN GetTasks.

    IF NOT CAN-FIND (FIRST ttWm-box-movto-idx-picking) 
    THEN DO:
         FOR EACH tt-dep-hora:
             DELETE tt-dep-hora.
         END.
    END.

    FOR EACH tt-dep-hora:

        ASSIGN v-log-achou = NO.

        RUN pi-converte-hora-ini-fim(INPUT tt-dep-hora.hora,
                                 OUTPUT i-hora-ini,
                                 OUTPUT i-hora-fim).

        FOR EACH in-wm-tarefa-docto NO-LOCK
           WHERE in-wm-tarefa-docto.cod-local   = tt-dep-hora.cod-depos
             AND in-wm-tarefa-docto.cod-localiz = tt-dep-hora.cod-localiz
             AND in-wm-tarefa-docto.hora     >= i-hora-ini
             AND in-wm-tarefa-docto.hora     <= i-hora-fim,
           FIRST wm-tarefa-docto NO-LOCK
          WHERE wm-tarefa-docto.id-tarefa = in-wm-tarefa-docto.id-tarefa,
           FIRST ttWm-box-movto-idx-picking
          Where ttWm-box-movto-idx-picking.id-docto = wm-tarefa-docto.id-docto
            AND ttWm-box-movto-idx-picking.ind-tipo-movto = 2:

            ASSIGN v-log-achou = YES.
            LEAVE.

        END.

        IF NOT v-log-achou 
           THEN DELETE tt-dep-hora.

    END.

End Procedure.


/*************************************************************************************************** 
**                                                                                                **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame03:

    Assign vLogErro = NO
           vLogSai = No 
           vLogFinaliza = NO.

    Hide All No-pause.

    FIND FIRST ttWork NO-ERROR.
    RETURN RETURN-VALUE.

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame04}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame04:

    Assign vLogErro = NO
           vLogSai = No 
           vLogFinaliza = NO.

    If Not Avail ttWm-box-movto-idx-picking Then Do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "301" "Movimento Inv lido. (WMS)"}
         Return Error.
    End.                     

    If  ttWork.opcao = 4 Then Do:
        Assign vLogEmProcesso = Yes.
    End.

    Assign vLogErro = No.
    If Not Avail ttWm-box-movto-idx-picking Then Do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "301" "Movimento Inv lido (WMS)"}
         Return Error.
    End.

    Hide All.

    Assign vLogFinaliza = No
           vLogSai      = No.

    find first ttWork no-error.

    ASSIGN ttWork.qtd-embal-lidas = 0. 

    Hide All No-pause.
    ASSIGN cod-estab-roteiriz = ttWm-box-movto-idx-picking.cod-estabel
           cod-local-roteiriz = ttWm-box-movto-idx-picking.cod-local
           id-movto-roteiriz  = ttWm-box-movto-idx-picking.id-movto.
    IF tt-mostra-locais.is-ckd THEN
        RUN bcp/ibc9018h.p (INPUT ROWID(ttWm-box-movto-idx-picking),
                            INPUT TABLE tt-locais-filhos-ckd).
    ELSE
        RUN bcp/bc9018h.p (INPUT ROWID(ttWm-box-movto-idx-picking)).

    Hide All No-pause.
    IF ttWork.opcao = 2 THEN DO:
        RUN wmp/wm9043.p (INPUT cod-estab-roteiriz,
                          INPUT cod-local-roteiriz,
                          INPUT id-movto-roteiriz).
    END.

    FIND FIRST ttWork NO-ERROR.
    RETURN RETURN-VALUE.

End Procedure.

/*************************************************************************************************** 
** Esta procedure ir  obter a lista das tarefas para a transa‡Æo de picking                       **
****************************************************************************************************/
PROCEDURE GetTasks:

    Assign vLogCancela  = NO
           vLogErro = NO.
    Empty Temp-table ttWm-box-movto-idx-picking.
    Case ttWork.opcao:
        When  1 Then Do:
            Run getMovtoTarefasPublicasPicking  In wgbosc096 ( Input  ttWork.cod-equipamento,
                                                               Input  vCodTipoEquip,
                                                               Input  07,           
                                                               Input  No,
                                                               Input  Yes,
                                                               Output Table ttWm-box-movto-idx-picking).
        End. /*When  '1' Then Do:*/ 
        When  2 Then Do:
            Run getMovtoTarefasUsuarioPicking	In wgbosc096 (Input  ttWork.cod-usuario,
                                                              Input  ttWork.cod-equipamento,
                                                              Input  vCodTipoEquip,
                                                              Input  07,           
                                                              Input  No,
                                                              Input  Yes,
                                                              Output Table ttWm-box-movto-idx-picking).
        End. /*When  '2' Then Do:*/  
        When  3 Then Do:
            Run getMovtoTarefasEquipPicking	In wgbosc096 (Input  ttWork.cod-usuario,
                                                          Input  ttWork.cod-equipamento,
                                                          Input  vCodTipoEquip,
                                                          Input  07,           
                                                          Input  No,
                                                          Input  Yes,
                                                          Output TABLE ttWm-box-movto-idx-picking).
        end. /*When  '3' Then Do:*/ 
        When  4 Then Do:
             Run getMovtoTarefasIniciadasPicking In wgbosc096 (Input  ttWork.cod-usuario,
                                                               Input  ttWork.cod-equipamento,
                                                               Input  vCodTipoEquip,
                                                               Input  07,           
                                                               Input  No,
                                                               Input  Yes,
                                                               Output Table ttWm-box-movto-idx-picking).
          end. /*When  '4' Then Do:*/  
    End Case.
    RETURN 'OK':U.

END PROCEDURE.

PROCEDURE pi-converte-hora-ini-fim:
    DEF INPUT PARAM p-hora AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-hora-ini AS INT NO-UNDO.
    DEF OUTPUT PARAM p-hora-fim AS INT NO-UNDO.
    
    DEF VAR i-hora AS INT NO-UNDO.
    DEF VAR i-minuto AS INT NO-UNDO.

    ASSIGN i-hora = int(SUBSTR(p-hora,1,2))
           i-minuto = int(SUBSTR(p-hora,4,2))
           p-hora-ini = (i-hora * 3600) + (i-minuto * 60)
           p-hora-fim = p-hora-ini + 59 NO-ERROR.

    
END PROCEDURE.

FUNCTION isCKD RETURNS LOGICAL ( pCodItem AS CHAR ) :
    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = pCodItem NO-ERROR.

    RETURN CAN-FIND (FIRST in-grup-estoq NO-LOCK
                     WHERE in-grup-estoq.ge-codigo = item.ge-codigo 
                       AND in-grup-estoq.log-ckd).
    

END FUNCTION.
