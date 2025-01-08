&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOES520 2.00.00.000}                               
/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */
 
/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName  BOES520
&GLOBAL-DEFINE DBOVersion  2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  resgate-premios
&GLOBAL-DEFINE TableLabel  resgate-premios                 
&GLOBAL-DEFINE QueryName qr{&TableName} 
 
/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */
 
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */
 
/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{esbo/boes520.i RowObject}
 
 
/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
 
 
/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
/* ************************* Definiá∆o de vari†veis *********************** */
define variable v-serie-docto as character no-undo.
define variable v-nro-docto as character no-undo.
define variable v-cod-estabel as character no-undo.
define variable v-nome-abrev as character no-undo.
define variable v-nr-pedcli as character no-undo.
define variable v-cpf-cnpj as character no-undo.
define variable v-data-movto as date no-undo.
define variable v-sequencia as integer no-undo.
 
define variable v-cpf-cnpj-ini   as character no-undo.
define variable v-cpf-cnpj-fim   as character no-undo.
define variable v-data-movto-ini as date no-undo.
define variable v-data-movto-fim as date no-undo.
define variable v-sequencia-ini  as integer no-undo.
define variable v-sequencia-fim  as integer no-undo.

DEFINE TEMP-TABLE tt-saldo NO-UNDO
    FIELD data-movto  LIKE pontos-fidelidade.data-movto
    FIELD id-movto    LIKE pontos-fidelidade.id-movto
    FIELD pontos      LIKE pontos-fidelidade.pontos
    FIELD descricao   LIKE ITEM.desc-nacional
    FIELD dealer      LIKE pontos-fidelidade.dealer
    FIELD ptos-disp   AS DECIMAL
    FIELD expirado    AS LOGICAL
    FIELD tabela      AS CHARACTER
    FIELD r-rowid     AS ROWID
    INDEX ch-pri IS PRIMARY 
          data-movto.

DEFINE VARIABLE de-resgate     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-saldo       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-consumo-pto AS DECIMAL     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram Template
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 17.67
         WIDTH              = 39.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */
 
{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    for each unid-neg-resgate exclusive-lock
        where unid-neg-resgate.cpf-cnpj   = RowObject.cpf-cnpj
          and unid-neg-resgate.data-movto = RowObject.data-movto
          and unid-neg-resgate.sequencia  = RowObject.sequencia:
        delete unid-neg-resgate.
    end.

    ASSIGN de-resgate = (RowObject.pontos * RowObject.quantidade).

    bk-int-reser-pto:
    FOR EACH int-reserva-pontos EXCLUSIVE-LOCK
        WHERE int-reserva-pontos.cpf-cnpj        = RowObject.cpf-cnpj
          AND int-reserva-pontos.data-movto-resg = RowObject.data-movto
          AND int-reserva-pontos.seq-resgate     = RowObject.sequencia
        BY int-reserva-pontos.data-movto-pto DESC:

        IF de-resgate <= 0 THEN NEXT bk-int-reser-pto.

        IF int-reserva-pontos.ind-tp-pto = 1 THEN DO: /* pontos-fidelidade */
            FIND FIRST pontos-fidelidade
                WHERE pontos-fidelidade.cpf-cnpj   = int-reserva-pontos.cpf-cnpj
                  AND pontos-fidelidade.data-movto = int-reserva-pontos.data-movto-pto
                  AND pontos-fidelidade.n-serie    = int-reserva-pontos.n-serie
                  AND pontos-fidelidade.ns-keycode = int-reserva-pontos.ns-keycode EXCLUSIVE-LOCK NO-ERROR.

            IF AVAILABLE pontos-fidelidade THEN DO:
                IF de-resgate >= int-reserva-pontos.pto-resg THEN
                    ASSIGN pontos-fidelidade.ptos-disp = pontos-fidelidade.ptos-disp + int-reserva-pontos.pto-resg
                           de-resgate                  = de-resgate - int-reserva-pontos.pto-resg
                           int-reserva-pontos.pto-resg = 0.
                ELSE
                    ASSIGN pontos-fidelidade.ptos-disp = pontos-fidelidade.ptos-disp + de-resgate
                           int-reserva-pontos.pto-resg = int-reserva-pontos.pto-resg - de-resgate
                           de-resgate                  = 0.
            END.
        END.
        ELSE IF int-reserva-pontos.ind-tp-pto = 2 THEN DO: /* ponto-extra */
            FIND FIRST ponto-extra
                WHERE ponto-extra.cpf-cnpj   = int-reserva-pontos.cpf-cnpj
                  AND ponto-extra.data-movto = int-reserva-pontos.data-movto-pto
                  AND ponto-extra.sequencia  = int-reserva-pontos.seq-pto-extra EXCLUSIVE-LOCK NO-ERROR.

            IF AVAILABLE ponto-extra THEN DO:
                IF de-resgate >= int-reserva-pontos.pto-resg THEN
                    ASSIGN ponto-extra.ptos-disp       = ponto-extra.ptos-disp + int-reserva-pontos.pto-resg
                           de-resgate                  = de-resgate - int-reserva-pontos.pto-resg
                           int-reserva-pontos.pto-resg = 0.
                ELSE
                    ASSIGN ponto-extra.ptos-disp       = ponto-extra.ptos-disp + de-resgate
                           int-reserva-pontos.pto-resg = int-reserva-pontos.pto-resg - de-resgate
                           de-resgate                  = 0.
            END.
        END.

        IF int-reserva-pontos.pto-resg = 0 THEN
            DELETE int-reserva-pontos.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH int-reserva-pontos EXCLUSIVE-LOCK
        WHERE int-reserva-pontos.cpf-cnpj        = RowObject.cpf-cnpj
          AND int-reserva-pontos.data-movto-resg = RowObject.data-movto
          AND int-reserva-pontos.seq-resgate     = RowObject.sequencia:
        ASSIGN int-reserva-pontos.concluido = RowObject.concluido.
    END.

    /* Continua, somente quando saldo disponivel */
    IF NOT CAN-FIND(FIRST int-reserva-pontos NO-LOCK
                    WHERE int-reserva-pontos.cpf-cnpj        = RowObject.cpf-cnpj
                      AND int-reserva-pontos.data-movto-resg = RowObject.data-movto
                      AND int-reserva-pontos.seq-resgate     = RowObject.sequencia) THEN DO:

        IF de-saldo >= de-resgate THEN DO:

            /* tt-saldo = pontos-fidelidade e ponto-extra */
            FOR EACH  tt-saldo EXCLUSIVE-LOCK
                BY tt-saldo.data-movto:

                IF de-resgate         = 0 THEN NEXT.
                IF tt-saldo.ptos-disp = 0 THEN NEXT.
                IF tt-saldo.expirado      THEN NEXT.

                IF (de-resgate - tt-saldo.ptos-disp) >= 0 THEN
                    ASSIGN de-resgate         = de-resgate - tt-saldo.ptos-disp
                           tt-saldo.ptos-disp = 0.
                ELSE
                    ASSIGN tt-saldo.ptos-disp = tt-saldo.ptos-disp - de-resgate
                           de-resgate         = 0.

                /* Atualiza registros */
                IF tt-saldo.tabela = 'ponto-extra' THEN DO:
                    FIND FIRST ponto-extra
                        WHERE ROWID(ponto-extra) = tt-saldo.r-rowid EXCLUSIVE-LOCK NO-ERROR.

                    ASSIGN ponto-extra.ptos-disp = tt-saldo.ptos-disp.
                END.
                ELSE DO:
                    FIND FIRST pontos-fidelidade
                        WHERE ROWID(pontos-fidelidade) = tt-saldo.r-rowid EXCLUSIVE-LOCK NO-ERROR.

                    ASSIGN pontos-fidelidade.ptos-disp = tt-saldo.ptos-disp.
                END.
            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST bf{&TableName}
         WHERE bf{&TableName}.cpf-cnpj   = RowObject.cpf-cnpj                     
           AND bf{&TableName}.data-movto = RowObject.data-movto                   
           AND bf{&TableName}.sequencia  = RowObject.sequencia  NO-LOCK NO-ERROR.

    IF CAN-FIND(FIRST int-reserva-pontos NO-LOCK
                WHERE int-reserva-pontos.cpf-cnpj        = RowObject.cpf-cnpj
                  AND int-reserva-pontos.data-movto-resg = RowObject.data-movto
                  AND int-reserva-pontos.seq-resgate     = RowObject.sequencia) THEN DO:

        IF RowObject.quantidade <> bf{&TableName}.quantidade THEN DO:
            IF RowObject.quantidade > bf{&TableName}.quantidade THEN DO:
                EMPTY TEMP-TABLE tt-saldo.

                RUN verificaSaldo (INPUT RowObject.cpf-cnpj,
                                   OUTPUT TABLE tt-saldo).

                /* Valor total do resgate */
                ASSIGN de-resgate = (RowObject.pontos * (RowObject.quantidade - bf{&TableName}.quantidade)).

                /* Pontos disponiveis */
                ASSIGN de-saldo = 0.

                FOR EACH tt-saldo NO-LOCK:
                    ASSIGN de-saldo = de-saldo + tt-saldo.ptos-disp.
                END.

                /* Se n∆o houver saldo retorna erro */
                IF de-saldo < de-resgate THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="17006"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="'Saldo insuficiente para concluir o Resgate.'"}

                    RETURN "NOK":U.
                END.

                bk-tt-saldo:
                FOR EACH  tt-saldo USE-INDEX ch-pri EXCLUSIVE-LOCK:
                    IF de-resgate         <= 0 THEN LEAVE bk-tt-saldo.
                    IF tt-saldo.ptos-disp  = 0 THEN NEXT  bk-tt-saldo.
                    IF tt-saldo.expirado       THEN NEXT  bk-tt-saldo.

                    IF (de-resgate - tt-saldo.ptos-disp) >= 0 THEN
                        ASSIGN de-consumo-pto     = tt-saldo.ptos-disp
                               de-resgate         = de-resgate - tt-saldo.ptos-disp
                               tt-saldo.ptos-disp = 0.
                    ELSE
                        ASSIGN de-consumo-pto     = de-resgate
                               tt-saldo.ptos-disp = tt-saldo.ptos-disp - de-resgate
                               de-resgate         = 0.

                    IF tt-saldo.tabela = "ponto-extra":U THEN DO:
                        FIND FIRST ponto-extra
                            WHERE ROWID(ponto-extra) = tt-saldo.r-rowid EXCLUSIVE-LOCK NO-ERROR.

                        IF AVAILABLE ponto-extra THEN DO:
                            CREATE int-reserva-pontos.
                            ASSIGN int-reserva-pontos.cpf-cnpj        = resgate-premios.cpf-cnpj
                                   int-reserva-pontos.data-movto-pto  = ponto-extra.data-movto
                                   int-reserva-pontos.data-movto-resg = resgate-premios.data-movto
                                   int-reserva-pontos.n-serie         = ""
                                   int-reserva-pontos.ns-keycode      = "":U
                                   int-reserva-pontos.seq-pto-extra   = ponto-extra.sequencia
                                   int-reserva-pontos.seq-resgate     = resgate-premios.sequencia
                                   int-reserva-pontos.ind-tp-pto      = 2 /* ponto-extra */
                                   int-reserva-pontos.pto-fidel-extr  = ponto-extra.pontos
                                   int-reserva-pontos.pto-resg        = de-consumo-pto
                                   int-reserva-pontos.concluido       = NO.

                            ASSIGN ponto-extra.ptos-disp = tt-saldo.ptos-disp.
                        END.
                    END.
                    ELSE DO:
                        FIND FIRST pontos-fidelidade
                            WHERE ROWID(pontos-fidelidade) = tt-saldo.r-rowid EXCLUSIVE-LOCK NO-ERROR.

                        IF AVAILABLE pontos-fidelidade THEN DO:
                            CREATE int-reserva-pontos.
                            ASSIGN int-reserva-pontos.cpf-cnpj        = resgate-premios.cpf-cnpj
                                   int-reserva-pontos.data-movto-pto  = pontos-fidelidade.data-movto
                                   int-reserva-pontos.data-movto-resg = resgate-premios.data-movto
                                   int-reserva-pontos.n-serie         = pontos-fidelidade.n-serie
                                   int-reserva-pontos.ns-keycode      = pontos-fidelidade.ns-keycode
                                   int-reserva-pontos.seq-pto-extra   = 0
                                   int-reserva-pontos.seq-resgate     = resgate-premios.sequencia
                                   int-reserva-pontos.ind-tp-pto      = 1 /* pontos-fidelidade */
                                   int-reserva-pontos.pto-fidel-extr  = pontos-fidelidade.pontos
                                   int-reserva-pontos.pto-resg        = de-consumo-pto
                                   int-reserva-pontos.concluido       = NO.

                            ASSIGN pontos-fidelidade.ptos-disp = tt-saldo.ptos-disp.
                        END.
                    END.
                END.
            END.
            ELSE DO:
                ASSIGN de-resgate = RowObject.pontos * (bf{&TableName}.quantidade - RowObject.quantidade).

                bk-int-reserv-pto:
                FOR EACH int-reserva-pontos EXCLUSIVE-LOCK
                    WHERE int-reserva-pontos.cpf-cnpj        = RowObject.cpf-cnpj
                      AND int-reserva-pontos.data-movto-resg = RowObject.data-movto
                      AND int-reserva-pontos.seq-resgate     = RowObject.sequencia
                    BY int-reserva-pontos.data-movto-pto DESC:

                    IF de-resgate <= 0 THEN NEXT bk-int-reserv-pto.

                    IF int-reserva-pontos.ind-tp-pto = 1 THEN DO: /* pontos-fidelidade */
                        FIND FIRST pontos-fidelidade
                            WHERE pontos-fidelidade.cpf-cnpj   = int-reserva-pontos.cpf-cnpj
                              AND pontos-fidelidade.data-movto = int-reserva-pontos.data-movto-pto
                              AND pontos-fidelidade.n-serie    = int-reserva-pontos.n-serie
                              AND pontos-fidelidade.ns-keycode = int-reserva-pontos.ns-keycode EXCLUSIVE-LOCK NO-ERROR.

                        IF AVAILABLE pontos-fidelidade THEN DO:
                            IF de-resgate >= int-reserva-pontos.pto-resg THEN
                                ASSIGN pontos-fidelidade.ptos-disp = pontos-fidelidade.ptos-disp + int-reserva-pontos.pto-resg
                                       de-resgate                  = de-resgate - int-reserva-pontos.pto-resg
                                       int-reserva-pontos.pto-resg = 0.
                            ELSE
                                ASSIGN pontos-fidelidade.ptos-disp = pontos-fidelidade.ptos-disp + de-resgate
                                       int-reserva-pontos.pto-resg = int-reserva-pontos.pto-resg - de-resgate
                                       de-resgate                  = 0.
                        END.
                    END.
                    ELSE IF int-reserva-pontos.ind-tp-pto = 2 THEN DO: /* ponto-extra */
                        FIND FIRST ponto-extra
                            WHERE ponto-extra.cpf-cnpj   = int-reserva-pontos.cpf-cnpj
                              AND ponto-extra.data-movto = int-reserva-pontos.data-movto-pto
                              AND ponto-extra.sequencia  = int-reserva-pontos.seq-pto-extra EXCLUSIVE-LOCK NO-ERROR.

                        IF AVAILABLE ponto-extra THEN DO:
                            IF de-resgate >= int-reserva-pontos.pto-resg THEN
                                ASSIGN ponto-extra.ptos-disp       = ponto-extra.ptos-disp + int-reserva-pontos.pto-resg
                                       de-resgate                  = de-resgate - int-reserva-pontos.pto-resg
                                       int-reserva-pontos.pto-resg = 0.
                            ELSE
                                ASSIGN ponto-extra.ptos-disp       = ponto-extra.ptos-disp + de-resgate
                                       int-reserva-pontos.pto-resg = int-reserva-pontos.pto-resg - de-resgate
                                       de-resgate                  = 0.
                        END.
                    END.

                    IF int-reserva-pontos.pto-resg = 0 THEN
                        DELETE int-reserva-pontos.
                END.
            END.

            ASSIGN de-saldo       = 0
                   de-resgate     = 0
                   de-consumo-pto = 0.

            EMPTY TEMP-TABLE tt-saldo.
        END.
    END.
    ELSE DO: /* Trecho mantido para tratar casos que n∆o existam o registro "int-reserva-pontos",
                porÇm solicito que executem o programa "baca-cria-reser-resg-n-concl.p" para
                realizar este acerto nos registro "resgate-premios" que n∆o foram conclu°dos.
                (Fabiano Sakae Ribeiro - Exponencial TI / SQL Works) */

        /* Verifica se Resgate foi conclu°do */
        IF RowObject.concluido <> bf{&TableName}.concluido THEN DO:
            EMPTY TEMP-TABLE tt-saldo.

            RUN verificaSaldo (INPUT RowObject.cpf-cnpj,
                               OUTPUT TABLE tt-saldo).

            /* Valor total do resgate */
            ASSIGN de-resgate = (RowObject.pontos * RowObject.quantidade).

            /* Pontos disponiveis */
            ASSIGN de-saldo = 0.
            FOR EACH tt-saldo NO-LOCK:
                ASSIGN de-saldo = de-saldo + tt-saldo.ptos-disp.
            END.

            /* Se n∆o houver saldo retorna erro */
            IF de-saldo < de-resgate THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'Saldo insuficiente para concluir o Resgate.'"}

                RETURN "NOK":U.
            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.                                                                       

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cpf-cnpj":U THEN ASSIGN pFieldValue = RowObject.cpf-cnpj.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nr-pedcli":U THEN ASSIGN pFieldValue = RowObject.nr-pedcli.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.                                                                            

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-movto":U THEN ASSIGN pFieldValue = RowObject.data-movto.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.                                                                         

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "vl-liquido":U THEN ASSIGN pFieldValue = RowObject.vl-liquido.
        WHEN "vl-total":U THEN ASSIGN pFieldValue = RowObject.vl-total.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.                                                                         

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-premio":U THEN ASSIGN pFieldValue = RowObject.cod-premio.
        WHEN "forma-pagto":U THEN ASSIGN pFieldValue = RowObject.forma-pagto.
        WHEN "pontos":U THEN ASSIGN pFieldValue = RowObject.pontos.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
DEFINE INPUT PARAMETER p-cpf-cnpj AS character NO-UNDO.                                                                         
    DEFINE INPUT PARAMETER p-data-movto AS date NO-UNDO.                                                                            
    DEFINE INPUT PARAMETER p-sequencia AS integer NO-UNDO.                                                                          

    FIND bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cpf-cnpj = p-cpf-cnpj                    
        AND bf{&TableName}.data-movto = p-data-movto                  
        AND bf{&TableName}.sequencia = p-sequencia                    
        NO-ERROR.
    IF NOT AVAILABLE bf{&TableName} THEN RETURN "NOK":U.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
DEFINE INPUT PARAMETER iAbertura AS INTEGER NO-UNDO.

    CASE iAbertura:
        WHEN 1 THEN
            RUN openQueryStatic ("Main":U).
        WHEN 2 THEN           
            RUN openQueryStatic ("Ch-nota":U).                        
        WHEN 3 THEN           
            RUN openQueryStatic ("Ch-pedido":U).                      
        WHEN 4 THEN           
            RUN openQueryStatic ("Ch-sequencia":U).                   
        WHEN 5 THEN           
            RUN openQueryStatic ("Zoom1":U).                   
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-nota DBOProgram 
PROCEDURE openQueryCh-nota :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.serie-docto = v-serie-docto                
        AND {&TableName}.nro-docto = v-nro-docto                      
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-pedido DBOProgram 
PROCEDURE openQueryCh-pedido :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-estabel = v-cod-estabel                
        AND {&TableName}.nome-abrev = v-nome-abrev                    
        AND {&TableName}.nr-pedcli = v-nr-pedcli                      
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCh-sequencia DBOProgram 
PROCEDURE openQueryCh-sequencia :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cpf-cnpj = v-cpf-cnpj                      
        AND {&TableName}.data-movto = v-data-movto                    
        AND {&TableName}.sequencia = v-sequencia                      
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoom1 DBOProgram 
PROCEDURE openQueryZoom1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   open query {&queryName} 
       for each {&TableName} no-lock
          where {&TableName}.cpf-cnpj   >= v-cpf-cnpj-ini
            and {&TableName}.cpf-cnpj   <= v-cpf-cnpj-fim
            and {&TableName}.data-movto >= v-data-movto-ini
            and {&TableName}.data-movto <= v-data-movto-fim
            and {&TableName}.sequencia  >= v-sequencia-ini
            and {&TableName}.sequencia  <= v-sequencia-fim.
            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-nota DBOProgram 
PROCEDURE setConstraintCh-nota :
DEFINE INPUT PARAMETER p-serie-docto AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-nro-docto AS character NO-UNDO.                                                                        

    ASSIGN 
    v-serie-docto = p-serie-docto                                     
    v-nro-docto = p-nro-docto                                         
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-pedido DBOProgram 
PROCEDURE setConstraintCh-pedido :
DEFINE INPUT PARAMETER p-cod-estabel AS character NO-UNDO.                                                                      
    DEFINE INPUT PARAMETER p-nome-abrev AS character NO-UNDO.                                                                       
    DEFINE INPUT PARAMETER p-nr-pedcli AS character NO-UNDO.                                                                        

    ASSIGN 
    v-cod-estabel = p-cod-estabel                                     
    v-nome-abrev = p-nome-abrev                                       
    v-nr-pedcli = p-nr-pedcli                                         
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCh-sequencia DBOProgram 
PROCEDURE setConstraintCh-sequencia :
DEFINE INPUT PARAMETER p-cpf-cnpj AS character NO-UNDO.                                                                         
    DEFINE INPUT PARAMETER p-data-movto AS date NO-UNDO.                                                                            
    DEFINE INPUT PARAMETER p-sequencia AS integer NO-UNDO.                                                                          

    ASSIGN 
    v-cpf-cnpj = p-cpf-cnpj                                           
    v-data-movto = p-data-movto                                       
    v-sequencia = p-sequencia                                         
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintZoom1 DBOProgram 
PROCEDURE setConstraintZoom1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   define input parameter p-cpf-cnpj-ini     as character no-undo.
   define input parameter p-cpf-cnpj-fim     as character no-undo.
   define input parameter p-data-movto-ini   as date no-undo.
   define input parameter p-data-movto-fim   as date no-undo.    
   define input parameter p-sequencia-ini    as integer no-undo.
   define input parameter p-sequencia-fim    as integer no-undo.

   assign
      v-cpf-cnpj-ini   = p-cpf-cnpj-ini
      v-cpf-cnpj-fim   = p-cpf-cnpj-fim
      v-data-movto-ini = p-data-movto-ini
      v-data-movto-fim = p-data-movto-fim
      v-sequencia-ini  = p-sequencia-ini
      v-sequencia-fim  = p-sequencia-fim. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    CASE pType:
         WHEN "Create" THEN DO:
             IF CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.cpf-cnpj = RowObject.cpf-cnpj
                 AND bf{&TableName}.data-movto = RowObject.data-movto
                 AND bf{&TableName}.sequencia = RowObject.sequencia) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="1"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.

         END.
         WHEN "Update" THEN DO:
             IF NOT CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.cpf-cnpj = RowObject.cpf-cnpj
                 AND bf{&TableName}.data-movto = RowObject.data-movto
                 AND bf{&TableName}.sequencia = RowObject.sequencia) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.

         END.
         WHEN "Delete" THEN DO:
             IF NOT CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.cpf-cnpj = RowObject.cpf-cnpj
                 AND bf{&TableName}.data-movto = RowObject.data-movto
                 AND bf{&TableName}.sequencia = RowObject.sequencia) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.

         END.
    END CASE.

    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    if (pType = "Create" or pType = "Update") then do:
       if not can-find (first usuario-fidelidade no-lock
                        where usuario-fidelidade.cpf-cnpj = RowObject.cpf-cnpj) then do:
          {method/svc/errors/inserr.i
              &ErrorNumber="17006"
              &ErrorType="EMS"
              &ErrorSubType="ERROR"
              &ErrorParameters="'Usu†rio informado inexistente'"
          }
       end.

       if RowObject.cod-premio = 0 then do:
          {method/svc/errors/inserr.i
              &ErrorNumber="17006"
              &ErrorType="EMS"
              &ErrorSubType="ERROR"
              &ErrorParameters="'C¢digo do pràmio n∆o informado'"
          }
       end.

       if RowObject.concluido = yes and not can-find (first unid-neg-resgate no-lock
                                                     where unid-neg-resgate.cpf-cnpj   = RowObject.cpf-cnpj
                                                       and unid-neg-resgate.data-movto = RowObject.data-movto
                                                       and unid-neg-resgate.sequencia  = RowObject.sequencia) then do:
          {method/svc/errors/inserr.i
              &ErrorNumber="17006"
              &ErrorType="EMS"
              &ErrorSubType="ERROR"
              &ErrorParameters="'O pedido n∆o pode ser conclu°do pois n∆o h† unidade de neg¢cio cadastrada'"
          }
       end.

       if can-find (first premios-fidelidade no-lock
                    where premios-fidelidade.cod-premio = RowObject.cod-premio
                      and premios-fidelidade.it-codigo <> '')
          and (RowObject.cod-estabel = "" or RowObject.nome-abrev = "" or RowObject.nr-pedcli = "") then do:
          {method/svc/errors/inserr.i
              &ErrorNumber="17006"
              &ErrorType="EMS"
              &ErrorSubType="WARNING"
              &ErrorParameters="'O pràmio Ç de um produto Intelbras, mas n∆o foi informado qual o pedido que foi criado'"
          }
       end.
    end.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaSaldo DBOProgram 
PROCEDURE verificaSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cpf-cnpj LIKE resgate-premios.cpf-cnpj NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-saldo.

    DEFINE BUFFER bf-pontos-fidelidade FOR pontos-fidelidade.
    DEFINE BUFFER bf-ponto-extra       FOR ponto-extra.

    FOR EACH pontos-fidelidade NO-LOCK
       WHERE pontos-fidelidade.cpf-cnpj = p-cpf-cnpj
         AND pontos-fidelidade.expirado = NO:

        /* Retirado validaá‰es, pois da problema quando a aprovaá∆o for feita apos expiraá∆o,
           porem resgate foi feito antes de expirar */
/*         /* Verifica se expirou */                                                                                                                      */
/*         IF (DATE(MONTH(pontos-fidelidade.data-movto), DAY(pontos-fidelidade.data-movto), YEAR(pontos-fidelidade.data-movto) + 1) - 1) < TODAY THEN DO: */
/*             /* Atualiza como expirado e zera pontos dispon°veis */                                                                                     */
/*             FIND FIRST bf-pontos-fidelidade                                                                                                            */
/*                 WHERE ROWID(bf-pontos-fidelidade) = ROWID(pontos-fidelidade) EXCLUSIVE-LOCK NO-ERROR.                                                  */
/*                                                                                                                                                        */
/*             ASSIGN bf-pontos-fidelidade.expirado  = YES                                                                                                */
/*                    bf-pontos-fidelidade.ptos-disp = 0.                                                                                                 */
/*                                                                                                                                                        */
/*             NEXT.                                                                                                                                      */
/*         END.                                                                                                                                           */

        CREATE tt-saldo.
        ASSIGN tt-saldo.data-movto = pontos-fidelidade.data-movto
               tt-saldo.id-movto   = pontos-fidelidade.id-movto
               tt-saldo.pontos     = pontos-fidelidade.pontos
               tt-saldo.dealer     = pontos-fidelidade.dealer
               tt-saldo.ptos-disp  = pontos-fidelidade.ptos-disp
               tt-saldo.expirado   = pontos-fidelidade.expirado
               tt-saldo.tabela     = "pontos-fidelidade"
               tt-saldo.r-rowid    = ROWID(pontos-fidelidade).
    END.

    FOR EACH ponto-extra NO-LOCK
       WHERE ponto-extra.cpf-cnpj = p-cpf-cnpj
         AND ponto-extra.expirado = NO:

/*         /* Verifica se expirou */                                                                                                    */
/*         IF (DATE(MONTH(ponto-extra.data-movto), DAY(ponto-extra.data-movto), YEAR(ponto-extra.data-movto) + 1) - 1) < TODAY THEN DO: */
/*             /* Atualiza como expirado e zera pontos dispon°veis */                                                                   */
/*             FIND FIRST bf-ponto-extra                                                                                                */
/*                 WHERE ROWID(bf-ponto-extra) = ROWID(ponto-extra) EXCLUSIVE-LOCK NO-ERROR.                                            */
/*                                                                                                                                      */
/*             ASSIGN bf-ponto-extra.expirado  = YES                                                                                    */
/*                    bf-ponto-extra.ptos-disp = 0.                                                                                     */
/*                                                                                                                                      */
/*             NEXT.                                                                                                                    */
/*         END.                                                                                                                         */

        CREATE tt-saldo.
        ASSIGN tt-saldo.data-movto = ponto-extra.data-movto
               tt-saldo.id-movto   = YES
               tt-saldo.pontos     = ponto-extra.pontos
               tt-saldo.descricao  = ponto-extra.descricao
               tt-saldo.ptos-disp  = ponto-extra.ptos-disp
               tt-saldo.expirado   = ponto-extra.expirado
               tt-saldo.tabela     = "ponto-extra"
               tt-saldo.r-rowid    = ROWID(ponto-extra).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

