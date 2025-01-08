/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9025O 2.00.00.023 } /*** 010023 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9025o MBC}
&ENDIF

{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9025o.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - Agosto/2009 - Lilian   - Criaá∆o do programa                **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Transferància WMS                **
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
DEFINE INPUT PARAM pcod-coletor     AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAM pcod-equipamento AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAM pcod-estabel     AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAM pcod-local       AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAM pcod-usuario     AS CHARACTER  NO-UNDO.

/* Definicao global do nome da transacao */
&global-define ProgramName esbcp008

/* Definicao da temp-table de integracao */
&global-define TempTable tt-transf-wms
{bcp/bc9025.i " "}
{method/dbotterr.i}

DEFINE TEMP-TABLE ttWork  NO-UNDO LIKE {&TempTable}. 
CREATE ttWork.
ASSIGN ttWork.cod-coletor        = pcod-coletor                
       ttWork.cod-equipamento    = pcod-equipamento
       ttWork.cod-estabel        = pcod-estabel
       ttWork.cod-local          = pcod-local
       ttWork.cod-usuario        = pcod-usuario.

DEFINE TEMP-TABLE ttwm-etiqueta    NO-UNDO LIKE wm-etiqueta.
DEFINE TEMP-TABLE ttMovto-Etiqueta NO-UNDO LIKE wm-movto-etiqueta
    FIELD RowNum AS INTEGER INIT 1
    FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE ttWm-box-movto-idx NO-UNDO LIKE wm-box-movto
    FIELD val-prioridade    AS INTEGER
    FIELD r-rowid           AS ROWID
    INDEX idx-prioridade val-prioridade DESC
    INDEX idx-movto      id-movto       ASC.

DEF TEMP-TABLE tt-etiqueta NO-UNDO
    FIELD id-etiqueta LIKE wm-etiqueta.id-etiqueta
    FIELD qtd-item    LIKE wm-etiqueta.qtd-item
    INDEX codigo IS UNIQUE id-etiqueta.                         

/* Variaveis de trabalho */              
DEFINE VARIABLE vLogOk             AS LOGICAL      INIT NO     NO-UNDO.
DEFINE VARIABLE vEndereco          AS CHAR FORMAT 'x(17)':U    NO-UNDO.
DEFINE VARIABLE vCodBloco          AS CHAR                     NO-UNDO.
DEFINE VARIABLE vCodRua            AS CHAR                     NO-UNDO.
DEFINE VARIABLE vCodNivel          AS CHAR                     NO-UNDO.
DEFINE VARIABLE vCodColuna         AS CHAR                     NO-UNDO. 
DEFINE VARIABLE v-pos-box          AS CHAR                     NO-UNDO.
DEFINE VARIABLE l-box-bloq-armaz   AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE vNumLidos          AS INT                      NO-UNDO.
DEFINE VARIABLE c-mensagem-box-ent AS CHARACTER FORMAT 'x(16)' NO-UNDO.
DEFINE VARIABLE c-mensagem         AS CHARACTER FORMAT 'x(6)'  NO-UNDO.
DEFINE VARIABLE num-box-orig-aux   AS DECIMAL  FORMAT '>>>>>>>>>9':U INITIAL 0 NO-UNDO. 

DEFINE VARIABLE o-ind-status-saldo-origem       LIKE wm-box-saldo.ind-status-saldo    NO-UNDO.
DEFINE VARIABLE o-id-movto-box-saldo            LIKE wm-box-saldo.id-movto            NO-UNDO.
DEFINE VARIABLE idBox                           LIKE wm-box-movto.id-box              NO-UNDO.

DEFINE NEW SHARED VARIABLE wgbosc096    AS WIDGET-HANDLE NO-UNDO.       
DEFINE NEW SHARED VARIABLE wgbosc030    AS WIDGET-HANDLE NO-UNDO.       
DEFINE NEW SHARED VARIABLE wgbosc074    AS WIDGET-HANDLE NO-UNDO.       
DEFINE NEW SHARED VARIABLE wgbosc112    AS WIDGET-HANDLE NO-UNDO.       

/* Propriedades globais para frames */              
&global-define FrameSize    20 By 8 

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Transferància WMS'                                At Row 01  Col 01          ~
                             '--------------------':U                           At Row 02  Col 01          ~
                             'Box Ent:'                                         At Row 03  Col 01          ~
                             ttwork.num-box-orig                                At Row 03  Col 09 No-label ~
                             vEndereco                                          At Row 04  Col 01 NO-LABEL ~
                             'Ser:'                                             at row 05  col 01          ~
                             ttWork.num-serial                                  at row 05  col 05 no-label ~
                             'Lidos:'                                           At Row 06  Col 01          ~
                             vNumLidos                                          At Row 06  Col 07 NO-LABEL ~
                             c-mensagem-box-ent                                 At Row 07  Col 01 NO-LABEL ~
                             'Cancelar: '                                       At Row 08  Col 01          ~
                             c-mensagem                                         At Row 08  Col 11 NO-LABEL 

&global-define Frame01Repeat YES

&global-define Update01Fields                                  ~

                                 /* Definicao das trigger de interacao com a tela */ 
&global-define TriggerBeforeFrame01 RUN InicializaCamposFrame01. 
&global-define TriggerAfterFrame01  RUN GravaCamposFrame01. IF vLogFinaliza = YES THEN DO: ~
                                                               ASSIGN vLogFinaliza        = YES    ~
                                                                      vLogSai             = YES    ~
                                                                      ttWork.num-box-orig = 0      ~
                                                                      ttWork.num-serial   = 0      ~
                                                                      ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 = '0'  ~
                                                                      ttWork.num-serial:SCREEN-VALUE   IN FRAME Frame01 = '0'  ~
                                                                      vNumLidos           = 0.     ~
                                                               EMPTY TEMP-TABLE ttwm-etiqueta.     ~
                                                            END. 
/* Definicao das trigger de usuario  */ 
&global-define UserTriggers                                                                                ~
                                ON 'ESC':U OF Frame Frame01                                                ~
                                DO:                                                                        ~
                                    ASSIGN vlogerro     = YES                                              ~
                                           vLogSai      = YES                                              ~
                                           vLogFinaliza = YES                                              ~
                                           ttWork.num-box-orig = 999999                                    ~
                                           ttWork.num-serial   = 0                                         ~
                                           ttWork.num-box-orig:SCREEN-VALUE  IN FRAME Frame01  = '999999'  ~
                                           ttWork.num-serial:SCREEN-VALUE  IN FRAME Frame01    = '0'.      ~
                                    HIDE ALL.                                                              ~
                                END.                                                                       ~
                                ON 'enter':U OF ttwork.num-box-orig IN Frame Frame01                       ~
                                DO:                                                                     ~
                                END.                                                                       ~
                                ON 'leave':U OF ttwork.num-box-orig IN Frame Frame01     ~
                                DO:                                                      ~
                                    ASSIGN INPUT FRAME Frame01 ttwork.num-box-orig.      ~
                                    IF ttWork.num-box-orig = 999999 THEN DO:             ~
                                         APPLY 'go':U TO FRAME Frame01.                  ~
                                    END.                                                 ~
                                    FIND FIRST wm-box NO-LOCK                                       ~
                                        WHERE wm-box.cod-estabel = ttWork.cod-estabel               ~
                                        AND   wm-box.cod-local   = ttWork.cod-local                 ~
                                        AND   wm-box.id-box      = ttWork.num-box-orig NO-ERROR.    ~
                                    IF AVAIL wm-box THEN DO:                                        ~
                                       IF wm-box.ind-posicao-box = 1 THEN                           ~
                                           ASSIGN v-pos-box = "E".                                  ~
                                       ELSE                                                         ~
                                           ASSIGN v-pos-box = "D".                                  ~
                                       ASSIGN vEndereco = wm-box.cod-bloco  + "/":U +               ~
                                                          wm-box.cod-rua    + "/":U +               ~
                                                          wm-box.cod-nivel  + "/":U +               ~
                                                          wm-box.cod-coluna + "/":U +               ~
                                                          v-pos-box.                                ~
                                    END.                                                            ~
                                    ELSE DO:                                                        ~
                                        ASSIGN vEndereco = ''.                                      ~
                                    END.                                                            ~
                                    DISP vEndereco WITH FRAME frame01.                              ~
                                END.                                                                ~
                                ON 'entry':U OF ttwork.num-serial IN FRAME Frame01                         ~
                                DO:                                                                        ~
                                    ASSIGN c-mensagem = 'ESC'.                                             ~
                                    DISABLE ttWork.num-box-orig WITH FRAME Frame01.                        ~
                                    DISP c-mensagem WITH FRAME frame01.                                    ~
                                END.                                                                       ~
                                ON 'ESC':U OF ttwork.num-serial IN Frame Frame01 OR END-ERROR OF FRAME {&Frame01Name}              ~
                                DO:                                                                           ~
                                    ASSIGN ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 = "0".           ~
                                    ENABLE ttWork.num-box-orig WITH FRAME Frame01.                            ~
                                    ASSIGN c-mensagem = '999999'.                                             ~
                                    DISP c-mensagem WITH FRAME frame01.                                       ~
                                    APPLY 'entry':U TO ttwork.num-box-orig IN FRAME Frame01.                  ~
                                    RETURN NO-APPLY.                                                          ~
                                END.                                                                          ~
                                ON 'entry':U OF ttwork.num-box-orig IN Frame Frame01                          ~
                                DO:                                                                           ~
                                    IF ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 = "0" OR             ~
                                       ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 = "" THEN            ~
                                        ASSIGN vEndereco = "".                                                ~
                                    DISP vEndereco WITH FRAME frame01.                                        ~
                                END.
                                
                                                                                                     
/* Definicao dos objetos ativos  */ 
&GLOBAL-DEFINE ActiveObject1 wgbosc030
&GLOBAL-DEFINE ActiveObject2 wgbosc074
&GLOBAL-DEFINE ActiveObject3 wgbosc096
&GLOBAL-DEFINE ActiveObject4 wgbosc112

/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela */
&global-define ErrorDisplaySeconds 3

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao e necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */


/************************************* Codigo do Usuario Inicio ************************************
** Este local ≤ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame01 com valores em branco              **
** Esta procedure e executada pelo pre-processador {&TriggerBeforeFrame01}.                       **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:   
    IF vLogFinaliza = YES THEN DO:
        ASSIGN vlogerro     = YES     
               vLogSai      = YES      
               vLogFinaliza = YES.
        HIDE ALL NO-PAUSE.
        RETURN RETURN-VALUE.
    END.

    IF NOT VALID-HANDLE(wgbosc030)  THEN DO:
       RUN scbo/bosc030.p PERSISTENT SET wgbosc030.
       RUN openQueryStatic IN wgbosc030 (INPUT "Main":U) NO-ERROR. 
    END.                                 

    IF NOT VALID-HANDLE(wgbosc074)  THEN DO:
       RUN scbo/bosc074.p PERSISTENT SET wgbosc074.
       RUN openQueryStatic IN wgbosc074 (Input "Main":U) No-error. 
    END.       

    IF NOT VALID-HANDLE(wgbosc096)  THEN DO:
        RUN scbo/bosc096.p PERSISTENT SET wgbosc096.
        RUN openQueryStatic IN wgbosc096 (Input "Main":U) No-error. 
    END.      

    IF NOT VALID-HANDLE(wgbosc112)  THEN DO:
        RUN scbo/bosc112.p PERSISTENT SET wgbosc112.
        RUN openQueryStatic IN wgbosc112 (Input "Main":U) No-error. 
    END.                           
    
    EMPTY TEMP-TABLE ttwm-etiqueta.

    ASSIGN vEndereco  = ''
           c-mensagem = '999999'.

    IF vLogOk = YES THEN DO:
       ASSIGN ttWork.num-box-orig  = num-box-orig-aux /* 999999 */
              ttWork.num-serial    = 0
              ttWork.num-box-orig:SCREEN-VALUE  IN FRAME Frame01  = '999999' 
              ttWork.num-serial:SCREEN-VALUE  IN FRAME Frame01    = '0'.     
       APPLY 'go':U TO FRAME Frame01.
    END.
    
    DISP ttWork.num-box-orig vEndereco ttWork.num-serial vNumLidos c-mensagem WITH FRAME Frame01. 
    UPDATE ttWork.num-box-orig ttWork.num-serial WITH FRAME Frame01.

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame03}.                        **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
    DEFINE VARIABLE l-capacidade AS LOGICAL     NO-UNDO INITIAL YES.
    DEFINE VARIABLE l-continua   AS LOGICAL     NO-UNDO INITIAL YES.

    ASSIGN vLogErro     = NO
           vLogOk       = NO
           vLogFinaliza = NO
           INPUT FRAME frame01 vEndereco
                               ttWork.num-serial
                               ttWork.num-box-orig
                               c-mensagem.
    
    IF  ttWork.num-box-orig <> 999999 THEN DO:
        /*Valida ID Box*/
        ASSIGN num-box-orig-aux = ttWork.num-box-orig.
        RUN retornaEnderecoBox IN wgbosc030(INPUT ttWork.cod-estabel, 
                                            INPUT ttWork.cod-local,   
                                            INPUT ttWork.num-box-orig,
                                            OUTPUT vCodBloco, 
                                            OUTPUT vCodRua,   
                                            OUTPUT vCodNivel, 
                                            OUTPUT vCodColuna).
        IF vCodBloco = '' AND vCodRua = '' THEN DO:
            ASSIGN vLogErro = YES.
            {bcp/bc9105.i "401" "Box Inv†lido. (WMS)"}
            RETURN ERROR.
        END.

        RUN openquerystatic IN wgbosc030(INPUT "main"). 
        RUN gotokey         IN wgbosc030(INPUT ttWork.cod-estabel,
                                         INPUT ttWork.cod-local,
                                         INPUT ttWork.num-box-orig).        
        RUN getLogField     IN wgbosc030(INPUT "log-bloq-armaz",
                                         OUTPUT l-box-bloq-armaz).
        IF l-box-bloq-armaz THEN DO:
            ASSIGN vLogErro = YES.
            {bcp/bc9105.i "401" "Box Bloqueado para Armazenamento. (WMS)"}
            RETURN ERROR.
        END.

        /*Valida Etiqueta*/
        EMPTY TEMP-TABLE ttwm-etiqueta.
        RUN getInfoEtiqueta IN wgbosc074(INPUT ttwork.num-serial,
                                         OUTPUT TABLE ttWm-etiqueta).
        If RETURN-VALUE <> 'OK':U THEN DO:
            RUN getrowErrors IN wgbosc074 (OUTPUT TABLE RowErrors).
            ASSIGN vLogErro = YES
                   ttWork.num-serial = 0.
            FOR EACH RowErrors:
                ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
            END.
            RETURN ERROR.
        END.

        FIND FIRST ttwm-etiqueta NO-ERROR.
        IF NOT AVAILABLE ttwm-etiqueta THEN DO:
            ASSIGN vLogErro = YES
                   ttWork.num-serial = 0.
            {bcp/bc9105.i "402" "Serial Invalido ou Usuario Nao Utiliza Coletor (DC)"}
            RETURN ERROR.
        END.

        IF  ttwm-etiqueta.ind-sit-agrupador = 1 THEN DO:
            ASSIGN vLogErro = YES.
            {bcp/bc9105.i "403" "Etiqueta deve ser do tipo Agrupadora. (WMS)"}
            RETURN ERROR.
        END.

        FIND FIRST wm-equipamento NO-LOCK
            WHERE wm-equipamento.cod-equipamento = ttWork.cod-equipamento NO-ERROR.

        EMPTY TEMP-TABLE ttWm-box-movto-idx.
        RUN getMovtoTransfIniciado IN wgbosc096(INPUT ttWork.cod-estabel,
                                                INPUT ttWork.cod-local,
                                                INPUT 3, /*Transferencia*/
                                                INPUT wm-equipamento.cdn-tipo-equipamento,
                                                INPUT ttWork.num-serial,
                                                OUTPUT TABLE ttWm-box-movto-idx).
        FIND FIRST ttWm-box-movto-idx NO-LOCK NO-ERROR.
        IF AVAIL ttWm-box-movto-idx THEN DO:

            EMPTY TEMP-TABLE RowErrors.
            EMPTY TEMP-TABLE tt-etiqueta.
            EMPTY TEMP-TABLE ttMovto-Etiqueta. 
            CREATE tt-etiqueta.
            ASSIGN tt-etiqueta.id-etiqueta = ttwork.num-serial
                   tt-etiqueta.qtd-item    = ttWm-box-movto-idx.qtd-item * ttWm-box-movto-idx.qti-embalagem.

            RUN getMovtoEtiqueta IN wgbosc112(INPUT ttWork.cod-estabel, 
                                              INPUT ttWork.cod-local,   
                                              INPUT ttWm-box-movto-idx.id-movto,
                                              OUTPUT TABLE ttMovto-Etiqueta).
            If RETURN-VALUE = 'OK':U THEN DO:
                FOR EACH ttMovto-Etiqueta NO-LOCK
                    WHERE ttMovto-Etiqueta.id-etiqueta <> ttWork.num-serial:
                    CREATE tt-etiqueta.
                    ASSIGN tt-etiqueta.id-etiqueta = ttMovto-Etiqueta.id-etiqueta
                        &IF '{&mgscm_version}' < '2.08'  &THEN
                           tt-etiqueta.qtd-item    = ttMovto-Etiqueta.dec-1
                        &ELSE
                           tt-etiqueta.qtd-item    = ttMovto-Etiqueta.qtd-item
                        &ENDIF.
                END.
            END.

            IF ttWm-box-movto-idx.char-1 <> "" THEN
                ASSIGN o-ind-status-saldo-origem = INT(SUBSTRING(ttWm-box-movto-idx.char-1,1,2))
                       o-id-movto-box-saldo      = DEC(SUBSTRING(ttWm-box-movto-idx.char-1,3,10)).
           
            /* Validaá∆o para realizar pergunta sobre a capacidade do endereáo. */
            IF NOT VALID-HANDLE(wgbosc030)  THEN DO:
                RUN scbo/bosc030.p PERSISTENT SET wgbosc030.
                RUN openQueryStatic IN wgbosc030 (INPUT "Main":U) NO-ERROR. 
            END.

            /* Validando se o ID-BOX de Entrada Ç diferente do ID-BOX de Sa°da */
            RUN getIdBoxIniciado IN wgbosc096(INPUT ttWork.cod-estabel,
                                                    INPUT ttWork.cod-local,
                                                    INPUT 3, /*Transferencia*/
                                                    INPUT wm-equipamento.cdn-tipo-equipamento,
                                                    INPUT ttWork.num-serial,
                                                    OUTPUT idBox ).

            IF idBox = ttwork.num-box-orig  THEN DO:
                ASSIGN vLogErro = YES.
                {bcp/bc9105.i "55371" "BOX Origem e Destino devem ser diferentes."}
                RETURN ERROR.

            END.

            RUN retornaCapacidadeEnd IN wgbosc030(INPUT ttWork.cod-estabel,
                                                  INPUT ttWork.cod-local,
                                                  INPUT ttwork.num-box-orig,
                                                  INPUT ttwm-etiqueta.cod-item,
                                                  INPUT ttwm-etiqueta.cod-embalagem,
                                                  INPUT NO,
                                                  INPUT tt-etiqueta.qtd-item,
                                                  OUTPUT l-capacidade).
            IF NOT l-capacidade THEN DO:
                DISP 'Capacidade do' AT ROW 01 COL 01 ~ 
                     'endereáo excedida.' AT ROW 02 COL 01   ~
                     'Deseja Continuar?'  AT ROW 03 COL 01   ~
                     '1=Sim 2=Nío' AT ROW 04 COL 01 WITH FRAME f-conf FONT 2 SIZE 20 BY 8 NO-BOX. ~
                UPDATE l-continua AT ROW 04 COL 13 NO-LABEL FORMAT '1/2':U WITH FRAME f-conf FONT 2 SIZE 20 BY 8. ~
                IF NOT l-continua THEN
                    UNDO,LEAVE.
            END.
            /*------------------------------------------------------------------*/

            DO TRANS:
                /*Efetivaá∆o da ENTRADA*/
                RUN wmp/wm9091.p (INPUT ttWm-box-movto-idx.r-rowid, /* pRwMovto       */   
                                  INPUT ttWork.num-box-orig,        /* pIdBoxDestino  */   
                                  INPUT ttWork.cod-usuario,         /* pCodUsuario    */   
                                  INPUT ttWork.cod-equipamento,     /* pCodEqpto      */   
                                  INPUT ttWork.cod-coletor,         /* pCodColetor    */   
                                  INPUT TIME,                       /* pHoraInicio    */   
                                  INPUT YES,                        /* pSobreporBox   */   
                                  INPUT 0,                          /* pIdAgrupador   */
                                  INPUT o-ind-status-saldo-origem, 
                                  OUTPUT o-ind-status-saldo-origem,
                                  INPUT o-id-movto-box-saldo,      
                                  OUTPUT o-id-movto-box-saldo,  
                                  INPUT TABLE tt-etiqueta,          /* tt-etiqueta    */   
                                  OUTPUT TABLE RowErrors).          /* rowerrors      */   
                IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN DO:
                    ASSIGN vLogErro = YES
                           ttWork.num-serial = 0.
                    FOR EACH RowErrors:
                        ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                        {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
                    END.
                    UNDO, RETURN ERROR.
                END.
                ELSE DO:
                    FIND FIRST wm-box-saldo-etiqueta NO-LOCK
                         WHERE wm-box-saldo-etiqueta.cod-estabel = ttWm-box-movto-idx.cod-estabel 
                           AND wm-box-saldo-etiqueta.cod-local   = ttWm-box-movto-idx.cod-local 
                           AND wm-box-saldo-etiqueta.id-box      = ttWork.num-box-orig
                           AND wm-box-saldo-etiqueta.id-etiqueta = ttWork.num-serial no-error.
                    IF AVAIL wm-box-saldo-etiqueta THEN DO:
                        FIND FIRST wm-etiqueta EXCLUSIVE-LOCK
                             WHERE wm-etiqueta.id-etiqueta = wm-box-saldo-etiqueta.id-etiqueta
                               AND wm-etiqueta.log-2       = YES NO-ERROR.
                        IF AVAIL wm-etiqueta THEN DO:
                            FIND FIRST wm-box-saldo WHERE
                                       wm-box-saldo.cod-estabel = wm-box-saldo-etiqueta.cod-estabel AND
                                       wm-box-saldo.cod-local   = wm-box-saldo-etiqueta.cod-local   AND
                                       wm-box-saldo.id-saldo    = wm-box-saldo-etiqueta.id-saldo    EXCLUSIVE-LOCK NO-ERROR.
                            IF AVAIL wm-box-saldo THEN
                                ASSIGN wm-box-saldo.ind-status-saldo = 7
                                       wm-etiqueta.log-2             = NO.
                        END.
                    END.
                    
                    {bcp/bc9105.i "405" "Entrada efetivada com sucesso."}
                END.
            END.
        END.
        ELSE DO:
            ASSIGN vLogErro = YES
                   ttWork.num-serial = 0.
            
            {bcp/bc9105.i "404" "N∆o h† transferància pendente para a etiqueta informada."}
            RETURN ERROR.
        END.
        ASSIGN vLogOk = YES
               vNumLidos = vNumLidos + 1.
        DISP vNumLidos WITH FRAME frame01.
        HIDE ALL NO-PAUSE.
    END.
    ELSE DO:
        HIDE ALL NO-PAUSE.
        ASSIGN vLogFinaliza = YES.
    END.
END PROCEDURE.

PROCEDURE piSolicitaCordenada:

    DEFINE FRAME FrameNavegIDWMS
        'Transferància WMS'                                At Row 01 Col 01
        '------------------':U                             At Row 02 Col 01
        'Bloco:'                                           At Row 03 Col 01
        vCodBloco                                          At Row 03 Col 10 NO-LABEL
        'Rua:'                                             At Row 04 Col 01
        vCodRua                                            At Row 04 COL 10 NO-LABEL
        'N°vel:'                                           At Row 05 Col 01
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
           {bcp/bc9105.i "159" "BOX n∆o encontrado para a coordenada informada.(bc9025f)"}
        END.                                
    ELSE
        ASSIGN ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 = string(ttWork.num-box-orig).

END PROCEDURE.
&else 
    RUN utp/ut-msgs.p (INPUT "show", 
                       INPUT 28036,
                       INPUT "").
&endif


