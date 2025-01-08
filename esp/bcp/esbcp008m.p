/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9025M 2.00.00.028 } /*** 010028 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bc9025m MBC}
&ENDIF

{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9025.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - fevereiro/2003 - Karen - Criaá∆o do programa                **
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
**                        Ex: tt-transf-wms.                                                      **
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
**                        que executa a procedure _GenerateDCTransaction que e responsavel por    **
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
DEFINE OUTPUT PARAM i-retorno-bc9025m AS DECIMAL  NO-UNDO.
DEFINE VARIABLE i-ind-status-saldo-origem       LIKE wm-box-saldo.ind-status-saldo    NO-UNDO.
DEFINE VARIABLE o-ind-status-saldo-origem       LIKE wm-box-saldo.ind-status-saldo    NO-UNDO.
DEFINE VARIABLE i-id-movto-box-saldo            LIKE wm-box-saldo.id-movto            NO-UNDO.
DEFINE VARIABLE o-id-movto-box-saldo            LIKE wm-box-saldo.id-movto            NO-UNDO.

DEFINE BUFFER bf-wm-box-movto FOR wm-box-movto.

/* Definicao global do nome da transacao */
&global-define ProgramName esbcp008

/* Definicao da temp-table de integracao */
&global-define TempTable tt-transf-wms
{bcp/bc9025.i " "}
{utp/utapi009.i} /* login */
{utp/ut-glob.i}              
{bcp/bc9015.i3}  /* def variaveis padroes */
{method/dbotterr.i}

DEFINE TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.
CREATE ttWork.
ASSIGN ttWork.cod-coletor        = pcod-coletor
       ttWork.cod-equipamento    = pcod-equipamento
       ttWork.cod-estabel        = pcod-estabel
       ttWork.cod-local          = pcod-local
       ttWork.cod-usuario        = v_cod_usuar_corren.

DEFINE TEMP-TABLE ttwm-etiqueta   NO-UNDO  LIKE wm-etiqueta.
DEFINE TEMP-TABLE ttWm-etiqueta2  NO-UNDO  LIKE wm-etiqueta
    FIELD RowNum AS INTEGER INIT 1
    FIELD r-Rowid AS ROWID.

DEF TEMP-TABLE tt-etiqueta NO-UNDO
    FIELD id-etiqueta LIKE wm-etiqueta.id-etiqueta
    FIELD qtd-item    LIKE wm-etiqueta.qtd-item
    INDEX codigo IS UNIQUE id-etiqueta.

/* Variaveis de trabalho */              
DEFINE VARIABLE vLogOk       AS LOGICAL      INIT NO  NO-UNDO.
DEFINE VARIABLE d-qtd-item LIKE wm-etiqueta.qtd-item   NO-UNDO.
DEFINE VARIABLE vEndereco  AS CHAR FORMAT 'x(17)':U    NO-UNDO.
DEFINE VARIABLE vNumLidos  AS INT                      NO-UNDO.
DEFINE VARIABLE vCodBloco  AS CHAR                     NO-UNDO.
DEFINE VARIABLE vCodRua    AS CHAR                     NO-UNDO. 
DEFINE VARIABLE vCodNivel  AS CHAR                     NO-UNDO.
DEFINE VARIABLE vCodColuna AS CHAR                     NO-UNDO. 
DEFINE VARIABLE v-pos-box  AS CHAR                     NO-UNDO.
DEFINE VARIABLE num-box-orig-aux   AS DECIMAL  FORMAT '>>>>>>>>>9':U INITIAL 0 NO-UNDO.  
DEFINE VARIABLE c-mensagem         AS CHARACTER FORMAT 'x(6)' NO-UNDO.
DEFINE VARIABLE c-msg-erro         AS CHARACTER FORMAT 'x(16)' NO-UNDO.
Define Variable vLogEtiqueta-aux   As Logical Init No          No-undo.
DEFINE VARIABLE c-mensagem-box-ent AS CHARACTER FORMAT 'x(16)' NO-UNDO.

DEFINE NEW SHARED VARIABLE wgbosc030 AS WIDGET-HANDLE NO-UNDO.       
DEFINE NEW SHARED VARIABLE wgbosc074 AS WIDGET-HANDLE NO-UNDO.       
DEFINE NEW SHARED VARIABLE wgbosc098 AS WIDGET-HANDLE NO-UNDO.       


/* Propriedades globais para frames */              
&global-define FrameSize    20 By 8

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Transferància WMS'                                At Row 01  Col 01          ~
                             '-------------------':U                            At Row 02  Col 01          ~
                             'Box Sai:'                                         At Row 03  Col 01          ~
                             ttwork.num-box-orig                                At Row 03  Col 09 No-label ~
                             vEndereco                                          At Row 04  Col 01 NO-LABEL ~
                             'Ser:'                                             At Row 05  Col 01          ~
                             ttWork.num-serial                                  At Row 05  Col 05 NO-LABEL ~
                             'Lidos:'                                           At Row 06  Col 01          ~
                             vNumLidos                                          At Row 06  Col 07 NO-LABEL ~
                             c-mensagem-box-ent                                 At Row 07  Col 01 NO-LABEL ~
                             'Cancelar: '                                       At Row 08  Col 01          ~
                             c-mensagem                                         At Row 08  Col 11 NO-LABEL

&global-define Frame01Repeat YES

&global-define Update01Fields                                  ~
               ttWork.num-box-orig                             ~
               ttWork.num-serial

/* Definicao das trigger de interacao com a tela */ 
&global-define TriggerBeforeFrame01 RUN InicializaCamposFrame01. 
&global-define TriggerAfterFrame01  RUN GravaCamposFrame01. IF vLogfinaliza = YES THEN DO: LEAVE _frame01. END.

/* Definicao das trigger de usuario  */ 
&global-define UserTriggers                                                                               ~
                            ON 'ESC':U OF Frame Frame01 OR END-ERROR OF FRAME {&Frame01Name}              ~
                            DO:                                                                           ~
                                ASSIGN vlogerro          = YES                                            ~
                                       i-retorno-bc9025m = ttWork.num-box-orig.                           ~
                                Return 'ESC':U.                                                           ~
                            END.                                                                          ~
                            ON 'F4':U OF ttwork.num-box-orig IN Frame Frame01                             ~
                             DO:                                                                          ~
                                 ASSIGN vlogerro          = YES                                           ~
                                        i-retorno-bc9025m = ttWork.num-box-orig.                          ~
                                 APPLY 'ESC':U TO FRAME Frame01.                                          ~
                             END.                                                                         ~
                            ON 'enter':U OF ttwork.num-box-orig IN Frame Frame01                          ~
                            DO:                            ~
                                IF ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 = "888888" OR    ~
                                   ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 = "999999" THEN  ~
                                    APPLY 'go':U TO FRAME Frame01.                                    ~
                                ELSE DO:                                                              ~
                                    APPLY 'leave':U TO ttwork.num-box-orig IN FRAME Frame01.          ~
                                    DISABLE ttWork.num-box-orig WITH FRAME Frame01.                   ~
                                    APPLY 'entry':U TO ttwork.num-serial IN FRAME Frame01.            ~
                                    RETURN NO-APPLY.                                                  ~
                                END.                                                                  ~
                            END.                                                                          ~
                            ON 'entry':U OF ttwork.num-box-orig IN Frame Frame01                          ~
                            DO:                                                                           ~
                                ASSIGN c-mensagem-box-ent = "Box Ent: 888888"                             ~
                                       c-mensagem         = '999999'.                                     ~
                                DISP c-mensagem WITH FRAME frame01.                                       ~
                                DISP c-mensagem-box-ent WITH FRAME frame01.                               ~
                                IF ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 <> "0" AND           ~
                                   ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 <> "999999" AND      ~
                                   ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 <> "888888" THEN DO: ~
                                     DISABLE ttWork.num-box-orig WITH FRAME Frame01.                      ~
                                     APPLY "entry" TO ttWork.num-serial IN FRAME Frame01.                 ~
                                END.                                                                      ~
                            END.                                                                          ~
                            ON 'leave':U OF ttwork.num-box-orig IN Frame Frame01                          ~
                            DO:                                                                           ~
                                ASSIGN INPUT FRAME Frame01 ttwork.num-box-orig.                           ~
                                FIND FIRST wm-box NO-LOCK                                                 ~
                                    WHERE wm-box.cod-estabel = ttWork.cod-estabel                         ~
                                    AND   wm-box.cod-local   = ttWork.cod-local                           ~
                                    AND   wm-box.id-box      = ttWork.num-box-orig NO-ERROR.              ~
                                IF AVAIL wm-box THEN DO:                                                  ~
                                   IF wm-box.ind-posicao-box = 1 THEN                                     ~
                                       ASSIGN v-pos-box = "E".                                            ~
                                   ELSE                                                                   ~
                                       ASSIGN v-pos-box = "D".                                            ~
                                   ASSIGN vEndereco = wm-box.cod-bloco  + "/":U +                         ~
                                                      wm-box.cod-rua    + "/":U +                         ~
                                                      wm-box.cod-nivel  + "/":U +                         ~
                                                      wm-box.cod-coluna + "/":U +                         ~
                                                      v-pos-box.                                          ~
                                END.                                                                      ~
                                ELSE DO:                                                                  ~
                                    ASSIGN vEndereco = ''.                                                ~
                                END.                                                                      ~
                                DISP vEndereco WITH FRAME frame01.                                        ~
                                ASSIGN c-mensagem-box-ent = "Box Ent: 888888"                             ~
                                       c-mensagem         = '999999'.                                     ~
                                DISP c-mensagem WITH FRAME frame01.                                       ~
                                DISP c-mensagem-box-ent WITH FRAME frame01.                               ~
                            END.                                                                          ~
                            ON 'entry':U OF ttwork.num-serial IN FRAME Frame01                            ~
                            DO:                                                                           ~
                                ASSIGN c-mensagem = 'ESC'                                                 ~
                                       c-mensagem-box-ent = "               ".                            ~
                                DISP c-mensagem-box-ent WITH FRAME frame01.                               ~
                                DISP c-mensagem WITH FRAME frame01.                                       ~
                            END.                                                                          ~
                            ON 'F4':U OF ttwork.num-serial IN Frame Frame01                               ~
                            DO:                                                                           ~
                                ASSIGN ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 = "0".           ~
                                ENABLE ttWork.num-box-orig WITH FRAME Frame01.                            ~
                                ASSIGN c-mensagem-box-ent = "Box Ent: 888888"                             ~
                                       c-mensagem         = '999999'.                                     ~
                                DISP c-mensagem WITH FRAME frame01.                                       ~
                                DISP c-mensagem-box-ent WITH FRAME frame01.                               ~
                                APPLY 'entry':U TO ttwork.num-box-orig IN FRAME Frame01.                  ~
                                RETURN NO-APPLY.                                                          ~
                            END.                                                                          ~
                            ON 'ESC':U OF ttwork.num-serial IN Frame Frame01 OR END-ERROR OF FRAME {&Frame01Name}     ~
                            DO:                                                                           ~
                                ASSIGN ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 = "0".           ~
                                ENABLE ttWork.num-box-orig WITH FRAME Frame01.                            ~
                                ASSIGN c-mensagem-box-ent = "Box Ent: 888888"                             ~
                                       c-mensagem         = '999999'.                                     ~
                                DISP c-mensagem WITH FRAME frame01.                                       ~
                                DISP c-mensagem-box-ent WITH FRAME frame01.                               ~
                                APPLY 'entry':U TO ttwork.num-box-orig IN FRAME Frame01.                  ~
                                RETURN NO-APPLY.                                                          ~
                            END.

/* Definicao dos objetos ativos */ 
&global-define ActiveObject1 wgbosc030
&global-define ActiveObject2 wgbosc074
&global-define ActiveObject2 wgbosc098

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
** Esta procedure esta inicializando os campos da tela Frame03 com valores em branco              **
** Esta procedure e executada pelo pre-processador {&TriggerBeforeFrame03}.                       **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:

   IF vLogEtiqueta-aux = YES THEN DO:
        ASSIGN vlogerro     = YES     
               vLogSai      = YES      
               vLogFinaliza = YES
               vLogEtiqueta-aux = YES.
        HIDE ALL NO-PAUSE.
        RETURN RETURN-VALUE.
    END.

    ASSIGN vLogErro = NO 
           vLogOk   = NO 
           vLogFinaliza = NO
           vLogEtiqueta-aux = NO.

    IF NOT VALID-HANDLE(wgbosc030)  THEN DO:
       Run scbo/bosc030.p Persistent SET wgbosc030.
       Run openQueryStatic In wgbosc030 (Input "Main":U) No-error. 
    END.                                                           
    IF NOT VALID-HANDLE(wgbosc074)  THEN DO:
       Run scbo/bosc074.p Persistent SET wgbosc074.
       Run openQueryStatic In wgbosc074 (Input "Main":U) No-error. 
    END.                
    IF NOT VALID-HANDLE(wgbosc098)  THEN DO:
       Run scbo/bosc098.p Persistent SET wgbosc098.
       Run openQueryStatic In wgbosc098 (Input "Main":U) No-error. 
    END.               
    
    EMPTY TEMP-TABLE ttwm-etiqueta.
    
    ASSIGN ttWork.des-endereco   = ''
           vEndereco             = ''
           c-mensagem            = '999999'
           c-mensagem-box-ent    = "Box Ent: 888888" 
           i-retorno-bc9025m     = 0.
           
    IF vLogOk = YES THEN DO:
       ASSIGN ttWork.num-box-orig = num-box-orig-aux /*999999*/
              ttWork.num-serial   = 0
              ttWork.num-serial:SCREEN-VALUE IN FRAME Frame01 = '0'.
       APPLY 'go':U TO FRAME Frame01.
    END.
    
    DISP ttWork.num-box-orig vEndereco ttWork.num-serial vNumLidos c-mensagem-box-ent c-mensagem WITH FRAME Frame01. 
    APPLY 'leave':U TO ttWork.num-box-orig IN FRAME Frame01. 

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame01}.                        **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
    ASSIGN INPUT FRAME Frame01 vEndereco
                               ttWork.num-box-orig
                               ttWork.num-serial
                               c-mensagem-box-ent
                               c-mensagem.

    IF ttWork.num-box-orig <> 999999 AND
       ttWork.num-box-orig <> 888888 THEN DO:

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
            {bcp/bc9105.i "301" "Box Inv†lido. (WMS)"}
            RETURN ERROR.
        END.

        /*Valida Etiqueta*/
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
            {bcp/bc9105.i "302" "Serial Invalido ou Usuario Nao Utiliza Coletor (DC)"}
            RETURN ERROR.
        END.
                                                
        If AVAILABLE ttWm-etiqueta AND ttWm-etiqueta.ind-sit-agrupador = 1 THEN DO:
            ASSIGN vLogErro = Yes
                   ttWork.num-serial = 0.
            {bcp/bc9105.i "303" "Etiqueta n∆o Ç um agrupador"}
            RETURN ERROR.
        END.

        RUN openquerystatic IN wgbosc098(INPUT "main"). 
        RUN gotokey         IN wgbosc098(INPUT ttWork.cod-estabel,
                                         INPUT ttWork.cod-local,
                                         INPUT ttWork.num-box-orig,
                                         INPUT ttWork.num-serial).        
        IF RETURN-VALUE = 'NOK':U THEN DO:
            ASSIGN vLogErro = Yes
                   ttWork.num-serial = 0.
            {bcp/bc9105.i "303" "Etiqueta n∆o esta armazenada no endereáo informado"}
            RETURN ERROR.
        END.

        DO TRANS:
            ASSIGN d-qtd-item = (ttwm-etiqueta.qtd-item - ttwm-etiqueta.qtd-item-retirado).
            EMPTY TEMP-TABLE RowErrors.   

            /* CQ - ALtera status do Saldo para liberado */
            FIND FIRST wm-box-saldo-etiqueta 
                 WHERE wm-box-saldo-etiqueta.id-etiqueta = ttwork.num-serial 
                 NO-LOCK NO-ERROR.
            IF AVAIL wm-box-saldo-etiqueta THEN DO:
                FIND FIRST wm-box-saldo WHERE
                           wm-box-saldo.cod-estabel = wm-box-saldo-etiqueta.cod-estabel AND
                           wm-box-saldo.cod-local   = wm-box-saldo-etiqueta.cod-local   AND
                           wm-box-saldo.id-saldo    = wm-box-saldo-etiqueta.id-saldo    EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL wm-box-saldo AND wm-box-saldo.ind-status-saldo = 7
                THEN DO:
                    FIND FIRST wm-etiqueta EXCLUSIVE-LOCK
                         WHERE wm-etiqueta.id-etiqueta = wm-box-saldo-etiqueta.id-etiqueta NO-ERROR.
                    IF AVAIL wm-etiqueta THEN
                        ASSIGN wm-box-saldo.ind-status-saldo = 3 /* Passa para liberado */
                               wm-etiqueta.log-2             = YES. /* LOG para controle de etiqueta Armazenada em CQ */
                END.
                ELSE DO:
                    IF AVAIL wm-box-saldo AND wm-box-saldo.ind-status-saldo = 5 //Rejeitado, n∆o deve permitir movimentaá∆o
                    THEN DO:
                        ASSIGN vLogErro = Yes
                               ttWork.num-serial = 0.
                        {bcp/bc9105.i "306" "Saldo Rejeitado, n∆o permite transferància."}
                        UNDO, RETURN ERROR.
                    END.
                END.
            END.

            RUN wmp/wm9090.p(INPUT ttWork.cod-estabel, /*pCodEstabel         */
                             INPUT ttWork.cod-local,   /*pCodLocal           */
                             INPUT ?,                  /*pRowDocto           */
                             INPUT ttwork.num-box-orig,/*pIdBoxDestino       */
                             INPUT 0,                  /*pIdSaldoOrigem      */
                             INPUT 0,                  /*pIdSaldoDestino     */
                             INPUT NO,                 /*pJuntaEmbalagem     */
                             INPUT ttWork.cod-usuario, /*pCodUsuario         */
                             INPUT d-qtd-item,         /*pQtdItem            */
                             INPUT ttwork.num-serial,  /*pIdEtiqueta         */
                             INPUT NO,                 /*pl-verifica-capacidade AS LOGICAL                 */
                             OUTPUT TABLE RowErrors).
            
            IF  CAN-FIND(FIRST RowErrors) THEN DO:
                ASSIGN vLogErro = YES
                       ttWork.num-serial = 0.
                FOR EACH RowErrors:
                    ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                    {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
                END.
                UNDO, RETURN ERROR.
            END.
            
            EMPTY TEMP-TABLE RowErrors.
            EMPTY TEMP-TABLE tt-etiqueta.
            EMPTY TEMP-TABLE ttWm-etiqueta2.  
            
            CREATE tt-etiqueta.
            ASSIGN tt-etiqueta.id-etiqueta = ttwork.num-serial
                   tt-etiqueta.qtd-item    = d-qtd-item. 
            
            RUN getInfoAgrupador IN wgbosc074(INPUT ttwork.num-serial,
                                              OUTPUT TABLE ttWm-etiqueta2).
            If RETURN-VALUE = 'OK':U THEN DO:
                FOR EACH ttWm-etiqueta2 NO-LOCK
                    WHERE ttWM-etiqueta2.qtd-item > ttWm-etiqueta2.qtd-item-retirado:
                    CREATE tt-etiqueta.
                    ASSIGN tt-etiqueta.id-etiqueta = ttWm-etiqueta2.id-etiqueta
                           tt-etiqueta.qtd-item    = (ttWm-etiqueta2.qtd-item - ttWm-etiqueta2.qtd-item-retirado).
                END.
            END.
            
            FIND FIRST wm-docto NO-LOCK
                WHERE wm-docto.cod-estabel      = ttWork.cod-estabel
                AND   wm-docto.cod-local        = ttWork.cod-local                        
                AND   wm-docto.dt-implan-docto  = TODAY                             
                AND   wm-docto.ind-origem-docto = 18                                 
                AND   wm-docto.num-docto        = ttWork.cod-usuario + "-" + STRING(TODAY) NO-ERROR.
            IF AVAIL wm-docto THEN DO:
                FIND FIRST wm-box-movto NO-LOCK
                    WHERE wm-box-movto.cod-estabel      = ttWork.cod-estabel
                    AND   wm-box-movto.cod-local        = ttWork.cod-local
                    AND   wm-box-movto.id-docto         = wm-docto.id-docto
                    AND   wm-box-movto.cod-item         = ttwm-etiqueta.cod-item
                    AND   wm-box-movto.cod-lote         = ttwm-etiqueta.cod-lote
                    AND   wm-box-movto.cod-refer        = ttwm-etiqueta.cod-refer
                    AND   wm-box-movto.qtd-item         = d-qtd-item
                    AND   wm-box-movto.ind-tipo-movto   = 2 /*Saida*/
                    AND   wm-box-movto.ind-status-movto = 1 /*N∆o Iniciado*/ NO-ERROR.
                IF AVAIL wm-box-movto THEN DO:

                    RUN wmp/wm9091.p(INPUT ROWID(wm-box-movto),       /* pRwMovto       */  
                                     INPUT ?,                         /* pIdBoxDestino  */  
                                     INPUT ttWork.cod-usuario,        /* pCodUsuario    */  
                                     INPUT ttWork.cod-equipamento,    /* pCodEqpto      */  
                                     INPUT ttWork.cod-coletor,        /* pCodColetor    */  
                                     INPUT TIME,                      /* pHoraInicio    */  
                                     INPUT NO,                        /* pSobreporBox   */  
                                     INPUT 0,                         /* pIdAgrupador   */  
                                     INPUT i-ind-status-saldo-origem, 
                                     OUTPUT o-ind-status-saldo-origem,
                                     INPUT  i-id-movto-box-saldo,      
                                     OUTPUT o-id-movto-box-saldo,
                                     INPUT TABLE tt-etiqueta,         /* tt-etiqueta    */
                                     OUTPUT TABLE RowErrors).            /* rowerrors      */
                    IF  CAN-FIND(FIRST RowErrors) THEN DO:
                        ASSIGN vLogErro = YES
                               ttWork.num-serial = 0.
                        FOR EACH RowErrors:
                            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                            {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
                        END.
                        UNDO, RETURN ERROR.
                    END.
                    ELSE DO:
                        {bcp/bc9105.i "305" "Sa°da efetivada com sucesso."}
                    END.

                    IF o-ind-status-saldo-origem = 4 /*analise*/ 
                    OR o-ind-status-saldo-origem = 7 /*cq-armazenado*/ THEN DO:

                        FIND FIRST bf-wm-box-movto EXCLUSIVE-LOCK                                  
                             WHERE bf-wm-box-movto.cod-estabel      = ttWork.cod-estabel            
                             AND   bf-wm-box-movto.cod-local        = ttWork.cod-local   
                             AND   bf-wm-box-movto.id-movto         = wm-box-movto.id-movto
                             AND   bf-wm-box-movto.ind-tipo-movto   = 1 /*Entrada*/                   
                             AND   bf-wm-box-movto.ind-status-movto = 1 /*N∆o Iniciado*/ NO-ERROR.  
                        IF AVAIL bf-wm-box-movto THEN DO:                               

                           ASSIGN OVERLAY(bf-wm-box-movto.char-1,1,2)  = STRING(o-ind-status-saldo-origem, ">>")
                                  OVERLAY(bf-wm-box-movto.char-1,3,10) = STRING(o-id-movto-box-saldo, ">>>>>>>>>>").
                        END.
                    END.
                END.
                ELSE DO:
                    ASSIGN vLogErro = Yes
                           ttWork.num-serial = 0.
                    {bcp/bc9105.i "306" "N∆o existe movimento para confirmaá∆o."}
                    UNDO, RETURN ERROR.
                END.
            END.
            ELSE DO:
                ASSIGN vLogErro = Yes
                       ttWork.num-serial = 0.
                {bcp/bc9105.i "307" "Documento n∆o existe para confirmaá∆o."}
                UNDO, RETURN ERROR.
            END.
        END.

        ASSIGN vLogOk = YES.
        ASSIGN vNumLidos = vNumLidos + 1.
        DISP vNumLidos WITH FRAME frame01.
        HIDE ALL NO-PAUSE.
    END.
    ELSE DO:
        IF ttWork.num-box-orig = 888888 THEN
           ASSIGN i-retorno-bc9025m = ttWork.num-box-orig.
        ASSIGN vLogFinaliza = YES.
        HIDE ALL NO-PAUSE.
    END.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame01}.                        **
****************************************************************************************************/
PROCEDURE piSolicitaCordenada:

    Define Frame FrameNavegIDWMS
        'Transferància WMS'                                At Row 01 Col 01
        '------------------':U                             At Row 02 Col 01
        'Bloco:'                                           At Row 03 Col 01
        vCodBloco                                          At Row 03 Col 10 No-label
        'Rua:'                                             At Row 04 Col 01
        vCodRua                                            At Row 04 COL 10 No-label
        'N°vel:'                                           At Row 05 Col 01
        vCodNivel                                          At Row 05 Col 10 No-label
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
           {bcp/bc9105.i "159" "BOX n∆o encontrado para a coordenada informada.(bc9025)"}
        END.
    ELSE
        ASSIGN ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 = string(ttWork.num-box-orig).

END PROCEDURE.
&else 
    RUN  utp/ut-msgs.p (INPUT "show", 
                        INPUT 28036,
                        INPUT "").
&endif

