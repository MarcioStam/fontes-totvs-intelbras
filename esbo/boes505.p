&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
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
&GLOBAL-DEFINE DBOName BOES505
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName def-nat-operacao
&GLOBAL-DEFINE TableLabel 
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
/* {esbo/boes505.i RowObject} */


DEFINE TEMP-TABLE RowObject NO-UNDO LIKE def-nat-operacao
    FIELD r-Rowid AS ROWID.


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE v-estado-orig-ini AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-estado-orig-fim AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-estado-dest-ini AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-estado-dest-fim AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-class-fiscal-ini AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-class-fiscal-fim AS CHARACTER   NO-UNDO.
            
DEFINE VARIABLE v-cliente-contrib  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE v-icms-st          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE v-consumidor-final AS LOGICAL   NO-UNDO.
DEFINE VARIABLE v-oem              AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-servico            AS LOGICAL   INITIAL NO  NO-UNDO.

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
   Type: DBOProgram
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
         HEIGHT             = 14.88
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE defineNatOperacao DBOProgram 
PROCEDURE defineNatOperacao :
DEFINE INPUT  PARAMETER c-cod-estabel          AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER i-cod-emitente         AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER c-cod-entrega          AS CHAR        NO-UNDO.
    DEFINE INPUT  PARAMETER c-it-codigo            AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER l-ind-consumidor-final AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT PARAMETER c-nat-operacao         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER l-return               AS LOGICAL     NO-UNDO.

    DEFINE VARIABLE l-insc-estadual-informada AS LOGICAL   INITIAL NO  NO-UNDO.
    DEFINE VARIABLE l-ind-subst-tributaria    AS LOGICAL   INITIAL NO  NO-UNDO.
    DEFINE VARIABLE l-ind-suframa-inf         AS LOGICAL   INITIAL NO  NO-UNDO.
    DEFINE VARIABLE l-ind-pais-brasil         AS LOGICAL   INITIAL NO  NO-UNDO.
    DEFINE VARIABLE l-oem                     AS LOGICAL   INITIAL NO  NO-UNDO.
    DEFINE VARIABLE l-lei-bem                 AS LOGICAL   INITIAL NO  NO-UNDO.
    DEFINE VARIABLE i-ind-forma-tributo       AS INTEGER               NO-UNDO.
    DEFINE VARIABLE i-ind-origem-item         AS INTEGER               NO-UNDO.
    DEFINE VARIABLE i-ind-vendas-alc          AS INTEGER               NO-UNDO.
    DEFINE VARIABLE i-ind-icms-st-antec       AS LOGICAL               NO-UNDO.
    DEFINE VARIABLE c-class-fiscal-item       AS CHARACTER             NO-UNDO.

    FIND estabelec
         WHERE estabelec.cod-estabel = c-cod-estabel NO-LOCK NO-ERROR.

    ASSIGN l-return = no.
    FIND emitente
         WHERE emitente.cod-emitente = i-cod-emitente NO-LOCK NO-ERROR.

    IF c-cod-entrega = "" THEN ASSIGN c-cod-entrega = "Padrao".

    FOR FIRST loc-entr 
        WHERE loc-entr.nome-abrev = emitente.nome-abrev
          AND loc-entr.cod-entr   = c-cod-entrega NO-LOCK USE-INDEX ch-entrega:
    END.

    FIND int-emitente
         WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    IF NOT AVAIL int-emitente THEN 
       RETURN "NOK".

    IF  estabelec.estado = "AM"  
    OR (estabelec.estado = "SC" AND 
        emitente.estado = "SC" AND int-emitente.ind-forma-tributo = 3) THEN
       ASSIGN i-ind-forma-tributo = int-emitente.ind-forma-tributo.
    ELSE
       ASSIGN i-ind-forma-tributo = 4.

    FIND cidade-zf
         WHERE cidade-zf.cidade = loc-entr.cidade
           AND cidade-zf.estado = loc-entr.estado
         NO-LOCK NO-ERROR.
    IF AVAIL cidade-zf THEN 
        ASSIGN i-ind-vendas-alc = int-emitente.ind-vendas-alc.
    ELSE
        ASSIGN i-ind-vendas-alc = 0.

    IF c-it-codigo <> "" THEN DO:
        FIND item
             WHERE item.it-codigo = c-it-codigo NO-LOCK NO-ERROR.

        ASSIGN c-class-fiscal-item = ITEM.class-fiscal.

        FIND FIRST int-familia 
             WHERE int-familia.fm-codigo = item.fm-codigo NO-LOCK NO-ERROR.
        IF AVAIL int-familia THEN
           ASSIGN l-oem = int-familia.oem.
        ELSE
           ASSIGN l-oem = NO.

        IF SUBSTRING(ITEM.char-2,212,1) = "9" THEN
            ASSIGN l-servico = YES.
        ELSE
            ASSIGN l-servico = NO.

        IF ITEM.codigo-orig = 0 or
           ITEM.codigo-orig = 3 or
           ITEM.codigo-orig = 5 or
           ITEM.codigo-orig = 8 THEN
           ASSIGN i-ind-origem-item = 2. /* nacional */
        ELSE
           IF ITEM.codigo-orig = 1 OR
              ITEM.codigo-orig = 6 THEN
              ASSIGN i-ind-origem-item = 3.  /*importado */
           ELSE 
              ASSIGN i-ind-origem-item = 1. /* n∆o informado */

        FIND FIRST int-item NO-LOCK
            WHERE  int-item.it-codigo = c-it-codigo NO-ERROR.
        IF  AVAIL  int-item THEN
            ASSIGN l-lei-bem            = int-item.log2
                   i-ind-icms-st-antec  = IF substring(int-item.char1,4,1) = "S" THEN YES ELSE NO.
        ELSE
             ASSIGN i-ind-icms-st-antec  = NO.
    END.
    ELSE DO:
        ASSIGN l-oem = NO
               i-ind-origem-item = 1
               i-ind-icms-st-antec  = NO.
    END.

    IF emitente.ins-estadual <> "" AND
       emitente.ins-estadual <> "ISENTO" AND
       emitente.ins-estadual <> "ISENTA" THEN
       ASSIGN l-insc-estadual-informada = YES.
    ELSE
       ASSIGN l-insc-estadual-informada = NO.

    IF l-insc-estadual-informada = YES THEN DO:
       FIND FIRST unid-feder NO-LOCK
            WHERE unid-feder.pais   = emitente.pais
              AND unid-feder.estado = emitente.estado NO-ERROR.

        IF emitente.contrib-icms AND AVAILABLE unid-feder AND unid-feder.ind-uf-subs THEN DO:
            /*IF loc-entr.estado = "MT" AND
                estabelec.estado <> "AM" THEN DO:
                /*ASSIGN l-ind-subst-tributaria = NO.
                IF emitente.insc-subs-trib = '' THEN 
                    FOR FIRST ct-clas-item NO-LOCK
                        WHERE (ct-clas-item.cod-clas-fisc = "ICMS ST MT"
                           OR  ct-clas-item.cod-clas-fisc = "FCP ST SC-MG e ICMS ST MT")
                          AND  ct-clas-item.cod-item      = ITEM.it-codigo:
                        ASSIGN l-ind-subst-tributaria = YES.
                    END. */
            END.
            ELSE DO: */
            IF AVAIL ITEM THEN
                FIND FIRST item-uf NO-LOCK
                     WHERE ITEM-uf.it-codigo       = ITEM.it-codigo
                       AND item-uf.cod-estado-orig = estabelec.estado
                       AND item-uf.estado          = loc-entr.estado NO-ERROR.
               IF AVAIL item-uf and emitente.insc-subs-trib = '' THEN 
                     ASSIGN l-ind-subst-tributaria = YES.
               ELSE
                     ASSIGN l-ind-subst-tributaria = NO.

           /* END.*/

        END.
    END.

    IF emitente.cod-suframa = "" THEN
       ASSIGN l-ind-suframa-inf = NO.
    ELSE
       ASSIGN l-ind-suframa-inf = YES.

    IF emitente.pais = "Brasil" THEN 
       ASSIGN l-ind-pais-brasil = YES.
    ELSE
       ASSIGN l-ind-pais-brasil = NO.

/*         MESSAGE "1 ITEM -  "  c-it-codigo SKIP                                                   */
/*             "estabelec.estado            "      estabelec.estado                  SKIP           */
/*                       "emitente.contrib-icms       "      emitente.contrib-icms             SKIP */
/*                       "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP */
/*                       "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP */
/*                       "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP */
/*                       "Cidade "                                                            SKIP  */
/*                       "loc-entr.estado             "      loc-entr.estado                   SKIP */
/*                       "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP */
/*                       "l-oem                       "      l-oem                             SKIP */
/*                       "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP */
/*                       "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP */
/*                       "i-ind-origem-item           "      i-ind-origem-item SKIP                 */
/*                       " i-ind-icms-st-antec        "       i-ind-icms-st-antec                   */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                   */

    /** com cidade e com NCM ***/
    FIND FIRST def-nat-operacao
         WHERE def-nat-operacao.estado-origem         = estabelec.estado
           AND def-nat-operacao.ind-cliente-contrib   = emitente.contrib-icms
           AND def-nat-operacao.ind-insc-estadual-inf = l-insc-estadual-informada
           AND def-nat-operacao.ind-subst-tributaria  = l-ind-subst-tributaria
           AND def-nat-operacao.ind-suframa-inf       = l-ind-suframa-inf
           AND def-nat-operacao.cidade-destino        = loc-entr.cidade
           AND def-nat-operacao.estado-destino        = loc-entr.estado
           AND def-nat-operacao.class-fiscal          = c-class-fiscal-item
           AND def-nat-operacao.ind-pais-brasil       = l-ind-pais-brasil
           AND def-nat-operacao.ind-oem               = l-oem
           AND def-nat-operacao.ind-consumidor-final  = l-ind-consumidor-final
           AND def-nat-operacao.ind-forma-tributo     = i-ind-forma-tributo
           AND def-nat-operacao.ind-origem-item       = i-ind-origem-item
           AND def-nat-operacao.ind-vendas-alc        = i-ind-vendas-alc
           AND IF l-ind-consumidor-final THEN def-nat-operacao.ind-lei-bem = l-lei-bem ELSE YES
           AND def-nat-operacao.ind-icms-st-antec     = i-ind-icms-st-antec
        NO-LOCK NO-ERROR.
    IF AVAIL def-nat-operacao THEN DO:
/*         MESSAGE "2NCM"  "estabelec.estado            "      estabelec.estado                  SKIP                */
/*                       "emitente.contrib-icms       "      emitente.contrib-icms             SKIP                */
/*                       "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP                */
/*                       "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP                */
/*                       "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP                */
/*                       "Cidade "                           loc-entr.cidade                                  SKIP */
/*                       "loc-entr.estado             "      loc-entr.estado                   SKIP                */
/*                       "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP                */
/*                       "l-oem                       "      l-oem                             SKIP                */
/*                       "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP                */
/*                       "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP                */
/*                       "i-ind-origem-item           "      i-ind-origem-item SKIP                                */
/*                " i-ind-icms-st-antec        "       i-ind-icms-st-antec                                         */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                  */

        RUN retornaNatureza (INPUT-OUTPUT c-nat-operacao).
/*         MESSAGE c-nat-operacao                 */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK. */
        ASSIGN l-return = YES.
        RETURN "OK".
    END.

    /** com cidade e SEM NCM ***/
    FIND FIRST def-nat-operacao
         WHERE def-nat-operacao.estado-origem         = estabelec.estado
           AND def-nat-operacao.ind-cliente-contrib   = emitente.contrib-icms
           AND def-nat-operacao.ind-insc-estadual-inf = l-insc-estadual-informada
           AND def-nat-operacao.ind-subst-tributaria  = l-ind-subst-tributaria
           AND def-nat-operacao.ind-suframa-inf       = l-ind-suframa-inf
           AND def-nat-operacao.cidade-destino        = loc-entr.cidade
           AND def-nat-operacao.estado-destino        = loc-entr.estado
           AND def-nat-operacao.class-fiscal          = ''
           AND def-nat-operacao.ind-pais-brasil       = l-ind-pais-brasil
           AND def-nat-operacao.ind-oem               = l-oem
           AND def-nat-operacao.ind-consumidor-final  = l-ind-consumidor-final
           AND def-nat-operacao.ind-forma-tributo     = i-ind-forma-tributo
           AND def-nat-operacao.ind-origem-item       = i-ind-origem-item
           AND def-nat-operacao.ind-vendas-alc        = i-ind-vendas-alc
           AND IF l-ind-consumidor-final THEN def-nat-operacao.ind-lei-bem = l-lei-bem ELSE YES
           AND def-nat-operacao.ind-icms-st-antec     = i-ind-icms-st-antec
        NO-LOCK NO-ERROR.
    IF AVAIL def-nat-operacao THEN DO:
/*         MESSAGE "2 "  "estabelec.estado            "      estabelec.estado                  SKIP                */
/*                       "emitente.contrib-icms       "      emitente.contrib-icms             SKIP                */
/*                       "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP                */
/*                       "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP                */
/*                       "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP                */
/*                       "Cidade "                           loc-entr.cidade                                  SKIP */
/*                       "loc-entr.estado             "      loc-entr.estado                   SKIP                */
/*                       "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP                */
/*                       "l-oem                       "      l-oem                             SKIP                */
/*                       "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP                */
/*                       "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP                */
/*                       "i-ind-origem-item           "      i-ind-origem-item SKIP                                */
/*                " i-ind-icms-st-antec        "       i-ind-icms-st-antec                                         */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                  */

        RUN retornaNatureza (INPUT-OUTPUT c-nat-operacao).
/*         MESSAGE c-nat-operacao                 */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK. */
        ASSIGN l-return = YES.
        RETURN "OK".
    END.

    /*** sem cidade e com NCM ***/
    FIND FIRST def-nat-operacao
         WHERE def-nat-operacao.estado-origem         = estabelec.estado
           AND def-nat-operacao.ind-cliente-contrib   = emitente.contrib-icms
           AND def-nat-operacao.ind-insc-estadual-inf = l-insc-estadual-informada
           AND def-nat-operacao.ind-subst-tributaria  = l-ind-subst-tributaria
           AND def-nat-operacao.ind-suframa-inf       = l-ind-suframa-inf
           AND def-nat-operacao.cidade-destino        = ""
           AND def-nat-operacao.estado-destino        = loc-entr.estado
           AND def-nat-operacao.class-fiscal          = c-class-fiscal-item
           AND def-nat-operacao.ind-pais-brasil       = l-ind-pais-brasil
           AND def-nat-operacao.ind-oem               = l-oem
           AND def-nat-operacao.ind-consumidor-final  = l-ind-consumidor-final
           AND def-nat-operacao.ind-forma-tributo     = i-ind-forma-tributo
           AND def-nat-operacao.ind-origem-item       = i-ind-origem-item
           AND def-nat-operacao.ind-vendas-alc        = i-ind-vendas-alc
           AND IF l-ind-consumidor-final THEN def-nat-operacao.ind-lei-bem = l-lei-bem ELSE YES
           AND def-nat-operacao.ind-icms-st-antec     = i-ind-icms-st-antec
        NO-LOCK NO-ERROR.


/*            MESSAGE "3a "  "estabelec.estado            "      estabelec.estado                  SKIP */
/*                          "emitente.contrib-icms       "      emitente.contrib-icms             SKIP  */
/*                          "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP  */
/*                          "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP  */
/*                          "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP  */
/*                          "Cidade "                                                            SKIP   */
/*                          "loc-entr.estado             "      loc-entr.estado                   SKIP  */
/*                          "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP  */
/*                          "l-oem                       "      l-oem                             SKIP  */
/*                          "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP  */
/*                          "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP  */
/*                          "i-ind-origem-item           "      i-ind-origem-item SKIP                  */
/*                          "i-ind-vendas-alc            "      i-ind-vendas-alc SKIP                   */
/*                   " i-ind-icms-st-antec        "       i-ind-icms-st-antec                           */
/*                VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                    */
    IF AVAIL def-nat-operacao THEN DO:

/*         MESSAGE "3 "  "estabelec.estado            "      estabelec.estado                  SKIP */
/*                       "emitente.contrib-icms       "      emitente.contrib-icms             SKIP */
/*                       "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP */
/*                       "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP */
/*                       "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP */
/*                       "Cidade "                                                            SKIP  */
/*                       "loc-entr.estado             "      loc-entr.estado                   SKIP */
/*                       "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP */
/*                       "l-oem                       "      l-oem                             SKIP */
/*                       "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP */
/*                       "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP */
/*                       "i-ind-origem-item           "      i-ind-origem-item SKIP                 */
/*                " i-ind-icms-st-antec        "       i-ind-icms-st-antec                          */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                   */

        RUN retornaNatureza (INPUT-OUTPUT c-nat-operacao).

/*         MESSAGE c-nat-operacao                 */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK. */

        ASSIGN l-return = YES.
        RETURN "OK".
    END.



    /*** sem cidade e sem NCM ***/
    FIND FIRST def-nat-operacao
         WHERE def-nat-operacao.estado-origem         = estabelec.estado
           AND def-nat-operacao.ind-cliente-contrib   = emitente.contrib-icms
           AND def-nat-operacao.ind-insc-estadual-inf = l-insc-estadual-informada
           AND def-nat-operacao.ind-subst-tributaria  = l-ind-subst-tributaria
           AND def-nat-operacao.ind-suframa-inf       = l-ind-suframa-inf
           AND def-nat-operacao.cidade-destino        = ""
           AND def-nat-operacao.estado-destino        = loc-entr.estado
           AND def-nat-operacao.class-fiscal          = ''
           AND def-nat-operacao.ind-pais-brasil       = l-ind-pais-brasil
           AND def-nat-operacao.ind-oem               = l-oem
           AND def-nat-operacao.ind-consumidor-final  = l-ind-consumidor-final
           AND def-nat-operacao.ind-forma-tributo     = i-ind-forma-tributo
           AND def-nat-operacao.ind-origem-item       = i-ind-origem-item
           AND def-nat-operacao.ind-vendas-alc        = i-ind-vendas-alc
           AND IF l-ind-consumidor-final THEN def-nat-operacao.ind-lei-bem = l-lei-bem ELSE YES
           AND def-nat-operacao.ind-icms-st-antec     = i-ind-icms-st-antec
        NO-LOCK NO-ERROR.


/*            MESSAGE "3a "  "estabelec.estado            "      estabelec.estado                  SKIP */
/*                          "emitente.contrib-icms       "      emitente.contrib-icms             SKIP  */
/*                          "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP  */
/*                          "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP  */
/*                          "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP  */
/*                          "Cidade "                                                            SKIP   */
/*                          "loc-entr.estado             "      loc-entr.estado                   SKIP  */
/*                          "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP  */
/*                          "l-oem                       "      l-oem                             SKIP  */
/*                          "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP  */
/*                          "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP  */
/*                          "i-ind-origem-item           "      i-ind-origem-item SKIP                  */
/*                          "i-ind-vendas-alc            "      i-ind-vendas-alc SKIP                   */
/*                   " i-ind-icms-st-antec        "       i-ind-icms-st-antec                           */
/*                VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                    */
    IF AVAIL def-nat-operacao THEN DO:

/*         MESSAGE "3 "  "estabelec.estado            "      estabelec.estado                  SKIP */
/*                       "emitente.contrib-icms       "      emitente.contrib-icms             SKIP */
/*                       "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP */
/*                       "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP */
/*                       "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP */
/*                       "Cidade "                                                            SKIP  */
/*                       "loc-entr.estado             "      loc-entr.estado                   SKIP */
/*                       "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP */
/*                       "l-oem                       "      l-oem                             SKIP */
/*                       "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP */
/*                       "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP */
/*                       "i-ind-origem-item           "      i-ind-origem-item SKIP                 */
/*                " i-ind-icms-st-antec        "       i-ind-icms-st-antec                          */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                   */

        RUN retornaNatureza (INPUT-OUTPUT c-nat-operacao).

/*         MESSAGE c-nat-operacao                 */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK. */

        ASSIGN l-return = YES.
        RETURN "OK".
    END.

    FIND FIRST def-nat-operacao
         WHERE def-nat-operacao.estado-origem         = estabelec.estado
           AND def-nat-operacao.ind-cliente-contrib   = emitente.contrib-icms
           AND def-nat-operacao.ind-insc-estadual-inf = l-insc-estadual-informada
           AND def-nat-operacao.ind-subst-tributaria  = l-ind-subst-tributaria
           AND def-nat-operacao.ind-suframa-inf       = l-ind-suframa-inf
           AND def-nat-operacao.cidade-destino        = ""
           AND def-nat-operacao.estado-destino        = ""
           AND def-nat-operacao.class-fiscal          = c-class-fiscal-item
           AND def-nat-operacao.ind-pais-brasil       = l-ind-pais-brasil
           AND def-nat-operacao.ind-oem               = l-oem
           AND def-nat-operacao.ind-consumidor-final  = l-ind-consumidor-final
           AND def-nat-operacao.ind-forma-tributo     = i-ind-forma-tributo
           AND def-nat-operacao.ind-origem-item       = i-ind-origem-item
           AND def-nat-operacao.ind-vendas-alc        = i-ind-vendas-alc
           AND IF l-ind-consumidor-final THEN def-nat-operacao.ind-lei-bem = l-lei-bem ELSE YES
           AND def-nat-operacao.ind-icms-st-antec     = i-ind-icms-st-antec
        NO-LOCK NO-ERROR.
/*            MESSAGE "4a "  "estabelec.estado            "      estabelec.estado                  SKIP */
/*                          "emitente.contrib-icms       "      emitente.contrib-icms             SKIP  */
/*                          "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP  */
/*                          "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP  */
/*                          "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP  */
/*                          "Cidade "                                                            SKIP   */
/*                          "loc-entr.estado             "                       SKIP                   */
/*                          "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP  */
/*                          "l-oem                       "      l-oem                             SKIP  */
/*                          "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP  */
/*                          "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP  */
/*                          "i-ind-origem-item           "      i-ind-origem-item SKIP                  */
/*                          "i-ind-vendas-alc            "      i-ind-vendas-alc SKIP                   */
/*                   " i-ind-icms-st-antec        "       i-ind-icms-st-antec                           */
/*                VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                    */

    IF AVAIL def-nat-operacao THEN DO:
/*         MESSAGE "4 "  "estabelec.estado            "      estabelec.estado                  SKIP */
/*                       "emitente.contrib-icms       "      emitente.contrib-icms             SKIP */
/*                       "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP */
/*                       "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP */
/*                       "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP */
/*                       "Cidade "                                                            SKIP  */
/*                       "loc-entr.estado             "                     SKIP                    */
/*                       "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP */
/*                       "l-oem                       "      l-oem                             SKIP */
/*                       "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP */
/*                       "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP */
/*                       "i-ind-origem-item           "      i-ind-origem-item SKIP                 */
/*                " i-ind-icms-st-antec        "       i-ind-icms-st-antec                          */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                   */

        RUN retornaNatureza (INPUT-OUTPUT c-nat-operacao).

/*         MESSAGE c-nat-operacao                 */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK. */

        ASSIGN l-return = YES.
        RETURN "OK".
    END.

    /** 4 sem classificaá∆o */
    FIND FIRST def-nat-operacao
     WHERE def-nat-operacao.estado-origem         = estabelec.estado
       AND def-nat-operacao.ind-cliente-contrib   = emitente.contrib-icms
       AND def-nat-operacao.ind-insc-estadual-inf = l-insc-estadual-informada
       AND def-nat-operacao.ind-subst-tributaria  = l-ind-subst-tributaria
       AND def-nat-operacao.ind-suframa-inf       = l-ind-suframa-inf
       AND def-nat-operacao.cidade-destino        = ""
       AND def-nat-operacao.estado-destino        = ""
       AND def-nat-operacao.class-fiscal          = ""
       AND def-nat-operacao.ind-pais-brasil       = l-ind-pais-brasil
       AND def-nat-operacao.ind-oem               = l-oem
       AND def-nat-operacao.ind-consumidor-final  = l-ind-consumidor-final
       AND def-nat-operacao.ind-forma-tributo     = i-ind-forma-tributo
       AND def-nat-operacao.ind-origem-item       = i-ind-origem-item
       AND def-nat-operacao.ind-vendas-alc        = i-ind-vendas-alc
       AND IF l-ind-consumidor-final THEN def-nat-operacao.ind-lei-bem = l-lei-bem ELSE YES
       AND def-nat-operacao.ind-icms-st-antec     = i-ind-icms-st-antec
        NO-LOCK NO-ERROR.
    /*            MESSAGE "4a "  "estabelec.estado            "      estabelec.estado                  SKIP */
    /*                          "emitente.contrib-icms       "      emitente.contrib-icms             SKIP  */
    /*                          "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP  */
    /*                          "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP  */
    /*                          "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP  */
    /*                          "Cidade "                                                            SKIP   */
    /*                          "loc-entr.estado             "                       SKIP                   */
    /*                          "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP  */
    /*                          "l-oem                       "      l-oem                             SKIP  */
    /*                          "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP  */
    /*                          "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP  */
    /*                          "i-ind-origem-item           "      i-ind-origem-item SKIP                  */
    /*                          "i-ind-vendas-alc            "      i-ind-vendas-alc SKIP                   */
    /*                   " i-ind-icms-st-antec        "       i-ind-icms-st-antec                           */
    /*                VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                    */
    
    IF AVAIL def-nat-operacao THEN DO:
    /*         MESSAGE "4 "  "estabelec.estado            "      estabelec.estado                  SKIP */
    /*                       "emitente.contrib-icms       "      emitente.contrib-icms             SKIP */
    /*                       "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP */
    /*                       "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP */
    /*                       "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP */
    /*                       "Cidade "                                                            SKIP  */
    /*                       "loc-entr.estado             "                     SKIP                    */
    /*                       "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP */
    /*                       "l-oem                       "      l-oem                             SKIP */
    /*                       "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP */
    /*                       "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP */
    /*                       "i-ind-origem-item           "      i-ind-origem-item SKIP                 */
    /*                " i-ind-icms-st-antec        "       i-ind-icms-st-antec                          */
    /*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                   */
    
        RUN retornaNatureza (INPUT-OUTPUT c-nat-operacao).
    
    /*         MESSAGE c-nat-operacao                 */
    /*             VIEW-AS ALERT-BOX INFO BUTTONS OK. */
    
        ASSIGN l-return = YES.
        RETURN "OK".
    END.


    /* RETIRADO CONFORME SOLICITACAO DO ROGERIO DA SILVEIRA ATRAVES DO CHAMADO IR69134 
       BUSAR SEMPRE POR NACIONAL OU IMPORTADO, NUNCA POR NAO INFORMADO 
      */


    FIND FIRST def-nat-operacao
         WHERE def-nat-operacao.estado-origem         = estabelec.estado
           AND def-nat-operacao.ind-cliente-contrib   = emitente.contrib-icms
           AND def-nat-operacao.ind-insc-estadual-inf = l-insc-estadual-informada
           AND def-nat-operacao.ind-subst-tributaria  = l-ind-subst-tributaria
           AND def-nat-operacao.ind-suframa-inf       = l-ind-suframa-inf
           AND def-nat-operacao.cidade-destino        = trim(loc-entr.cidade)
           AND def-nat-operacao.estado-destino        = trim(loc-entr.estado)
           AND def-nat-operacao.class-fiscal          = c-class-fiscal-item
           AND def-nat-operacao.ind-pais-brasil       = l-ind-pais-brasil
           AND def-nat-operacao.ind-oem               = l-oem
           AND def-nat-operacao.ind-consumidor-final  = l-ind-consumidor-final
           AND def-nat-operacao.ind-forma-tributo     = i-ind-forma-tributo
           AND def-nat-operacao.ind-origem-item       = 1
           AND def-nat-operacao.ind-vendas-alc        = i-ind-vendas-alc
           AND IF l-ind-consumidor-final THEN def-nat-operacao.ind-lei-bem = l-lei-bem ELSE YES
           AND def-nat-operacao.ind-icms-st-antec     = i-ind-icms-st-antec
        NO-LOCK NO-ERROR.
/*            MESSAGE "5a "  "estabelec.estado            "      estabelec.estado                  SKIP           */
/*                          "emitente.contrib-icms       "      emitente.contrib-icms             SKIP            */
/*                          "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP            */
/*                          "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP            */
/*                          "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP            */
/*                          "Cidade "                           trim(loc-entr.cidade)                        SKIP */
/*                          "loc-entr.estado             "      trim(loc-entr.estado)        SKIP                 */
/*                          "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP            */
/*                          "l-oem                       "      l-oem                             SKIP            */
/*                          "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP            */
/*                          "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP            */
/*                          "i-ind-origem-item           "      1 SKIP                                            */
/*                          "i-ind-vendas-alc            "      i-ind-vendas-alc SKIP                             */
/*                   " i-ind-icms-st-antec        "       i-ind-icms-st-antec                                     */
/*                VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                              */
    
    IF AVAIL def-nat-operacao THEN DO:
/*         MESSAGE "5 "  "estabelec.estado            "      estabelec.estado                  SKIP */
/*                       "emitente.contrib-icms       "      emitente.contrib-icms             SKIP */
/*                       "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP */
/*                       "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP */
/*                       "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP */
/*                       "Cidade "                           loc-entr.cidade                   SKIP */
/*                       "loc-entr.estado             "      loc-entr.estado                   SKIP */
/*                       "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP */
/*                       "l-oem                       "      l-oem                             SKIP */
/*                       "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP */
/*                       "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP */
/*                       "i-ind-origem-item           "      1 SKIP                                 */
/*                " i-ind-icms-st-antec        "       i-ind-icms-st-antec                          */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                   */

        RUN retornaNatureza (INPUT-OUTPUT c-nat-operacao).

/*         MESSAGE c-nat-operacao                 */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK. */

        ASSIGN l-return = YES.
        RETURN "OK".
    END.

    /** 5 sem classificaá∆o */ 
    FIND FIRST def-nat-operacao
         WHERE def-nat-operacao.estado-origem         = estabelec.estado
           AND def-nat-operacao.ind-cliente-contrib   = emitente.contrib-icms
           AND def-nat-operacao.ind-insc-estadual-inf = l-insc-estadual-informada
           AND def-nat-operacao.ind-subst-tributaria  = l-ind-subst-tributaria
           AND def-nat-operacao.ind-suframa-inf       = l-ind-suframa-inf
           AND def-nat-operacao.cidade-destino        = trim(loc-entr.cidade)
           AND def-nat-operacao.estado-destino        = trim(loc-entr.estado)
           AND def-nat-operacao.class-fiscal          = ''
           AND def-nat-operacao.ind-pais-brasil       = l-ind-pais-brasil
           AND def-nat-operacao.ind-oem               = l-oem
           AND def-nat-operacao.ind-consumidor-final  = l-ind-consumidor-final
           AND def-nat-operacao.ind-forma-tributo     = i-ind-forma-tributo
           AND def-nat-operacao.ind-origem-item       = 1
           AND def-nat-operacao.ind-vendas-alc        = i-ind-vendas-alc
           AND IF l-ind-consumidor-final THEN def-nat-operacao.ind-lei-bem = l-lei-bem ELSE YES
           AND def-nat-operacao.ind-icms-st-antec     = i-ind-icms-st-antec
        NO-LOCK NO-ERROR.
/*            MESSAGE "5a "  "estabelec.estado            "      estabelec.estado                  SKIP           */
/*                          "emitente.contrib-icms       "      emitente.contrib-icms             SKIP            */
/*                          "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP            */
/*                          "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP            */
/*                          "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP            */
/*                          "Cidade "                           trim(loc-entr.cidade)                        SKIP */
/*                          "loc-entr.estado             "      trim(loc-entr.estado)        SKIP                 */
/*                          "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP            */
/*                          "l-oem                       "      l-oem                             SKIP            */
/*                          "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP            */
/*                          "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP            */
/*                          "i-ind-origem-item           "      1 SKIP                                            */
/*                          "i-ind-vendas-alc            "      i-ind-vendas-alc SKIP                             */
/*                   " i-ind-icms-st-antec        "       i-ind-icms-st-antec                                     */
/*                VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                              */
    
    IF AVAIL def-nat-operacao THEN DO:
/*         MESSAGE "5 "  "estabelec.estado            "      estabelec.estado                  SKIP */
/*                       "emitente.contrib-icms       "      emitente.contrib-icms             SKIP */
/*                       "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP */
/*                       "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP */
/*                       "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP */
/*                       "Cidade "                           loc-entr.cidade                   SKIP */
/*                       "loc-entr.estado             "      loc-entr.estado                   SKIP */
/*                       "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP */
/*                       "l-oem                       "      l-oem                             SKIP */
/*                       "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP */
/*                       "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP */
/*                       "i-ind-origem-item           "      1 SKIP                                 */
/*                " i-ind-icms-st-antec        "       i-ind-icms-st-antec                          */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                   */

        RUN retornaNatureza (INPUT-OUTPUT c-nat-operacao).

/*         MESSAGE c-nat-operacao                 */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK. */

        ASSIGN l-return = YES.
        RETURN "OK".
    END.
    
    FIND FIRST def-nat-operacao
         WHERE def-nat-operacao.estado-origem         = estabelec.estado
           AND def-nat-operacao.ind-cliente-contrib   = emitente.contrib-icms
           AND def-nat-operacao.ind-insc-estadual-inf = l-insc-estadual-informada
           AND def-nat-operacao.ind-subst-tributaria  = l-ind-subst-tributaria
           AND def-nat-operacao.ind-suframa-inf       = l-ind-suframa-inf
           AND def-nat-operacao.cidade-destino        = ""
           AND def-nat-operacao.estado-destino        = loc-entr.estado
           AND def-nat-operacao.ind-pais-brasil       = l-ind-pais-brasil
           AND def-nat-operacao.class-fiscal          = c-class-fiscal-item
           AND def-nat-operacao.ind-oem               = l-oem
           AND def-nat-operacao.ind-consumidor-final  = l-ind-consumidor-final
           AND def-nat-operacao.ind-forma-tributo     = i-ind-forma-tributo
           AND def-nat-operacao.ind-origem-item       = 1
           AND def-nat-operacao.ind-vendas-alc        = i-ind-vendas-alc
           AND IF l-ind-consumidor-final THEN def-nat-operacao.ind-lei-bem = l-lei-bem ELSE YES
           AND def-nat-operacao.ind-icms-st-antec     = i-ind-icms-st-antec
        NO-LOCK NO-ERROR.


/*            MESSAGE "6a "  "estabelec.estado            "      estabelec.estado                  SKIP */
/*                          "emitente.contrib-icms       "      emitente.contrib-icms             SKIP  */
/*                          "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP  */
/*                          "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP  */
/*                          "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP  */
/*                          "Cidade "                                                              SKIP */
/*                          "loc-entr.estado             "      loc-entr.estado                   SKIP  */
/*                          "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP  */
/*                          "l-oem                       "      l-oem                             SKIP  */
/*                          "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP  */
/*                          "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP  */
/*                          "i-ind-origem-item           "      1 SKIP                                  */
/*                   " i-ind-icms-st-antec        "       i-ind-icms-st-antec                           */
/*                VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                    */

    IF AVAIL def-nat-operacao THEN DO:
/*         MESSAGE "6 "  "estabelec.estado            "      estabelec.estado                  SKIP  */
/*                       "emitente.contrib-icms       "      emitente.contrib-icms             SKIP  */
/*                       "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP  */
/*                       "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP  */
/*                       "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP  */
/*                       "Cidade "                                                              SKIP */
/*                       "loc-entr.estado             "      loc-entr.estado                   SKIP  */
/*                       "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP  */
/*                       "l-oem                       "      l-oem                             SKIP  */
/*                       "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP  */
/*                       "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP  */
/*                       "i-ind-origem-item           "      1 SKIP                                  */
/*                " i-ind-icms-st-antec        "       i-ind-icms-st-antec                           */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                    */

        RUN retornaNatureza (INPUT-OUTPUT c-nat-operacao).

/*         MESSAGE c-nat-operacao                 */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK. */

        ASSIGN l-return = YES.
        RETURN "OK".
    END.

    /* 6 sem classificaá∆o */
    FIND FIRST def-nat-operacao
         WHERE def-nat-operacao.estado-origem         = estabelec.estado
           AND def-nat-operacao.ind-cliente-contrib   = emitente.contrib-icms
           AND def-nat-operacao.ind-insc-estadual-inf = l-insc-estadual-informada
           AND def-nat-operacao.ind-subst-tributaria  = l-ind-subst-tributaria
           AND def-nat-operacao.ind-suframa-inf       = l-ind-suframa-inf
           AND def-nat-operacao.cidade-destino        = ""
           AND def-nat-operacao.estado-destino        = loc-entr.estado
           AND def-nat-operacao.ind-pais-brasil       = l-ind-pais-brasil
           AND def-nat-operacao.ind-oem               = l-oem
           AND def-nat-operacao.ind-consumidor-final  = l-ind-consumidor-final
           AND def-nat-operacao.ind-forma-tributo     = i-ind-forma-tributo
           AND def-nat-operacao.ind-origem-item       = 1
           AND def-nat-operacao.ind-vendas-alc        = i-ind-vendas-alc
           AND IF l-ind-consumidor-final THEN def-nat-operacao.ind-lei-bem = l-lei-bem ELSE YES
           AND def-nat-operacao.ind-icms-st-antec     = i-ind-icms-st-antec
        NO-LOCK NO-ERROR.


/*            MESSAGE "6a "  "estabelec.estado            "      estabelec.estado                  SKIP */
/*                          "emitente.contrib-icms       "      emitente.contrib-icms             SKIP  */
/*                          "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP  */
/*                          "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP  */
/*                          "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP  */
/*                          "Cidade "                                                              SKIP */
/*                          "loc-entr.estado             "      loc-entr.estado                   SKIP  */
/*                          "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP  */
/*                          "l-oem                       "      l-oem                             SKIP  */
/*                          "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP  */
/*                          "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP  */
/*                          "i-ind-origem-item           "      1 SKIP                                  */
/*                   " i-ind-icms-st-antec        "       i-ind-icms-st-antec                           */
/*                VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                    */

    IF AVAIL def-nat-operacao THEN DO:
/*         MESSAGE "6 "  "estabelec.estado            "      estabelec.estado                  SKIP  */
/*                       "emitente.contrib-icms       "      emitente.contrib-icms             SKIP  */
/*                       "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP  */
/*                       "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP  */
/*                       "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP  */
/*                       "Cidade "                                                              SKIP */
/*                       "loc-entr.estado             "      loc-entr.estado                   SKIP  */
/*                       "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP  */
/*                       "l-oem                       "      l-oem                             SKIP  */
/*                       "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP  */
/*                       "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP  */
/*                       "i-ind-origem-item           "      1 SKIP                                  */
/*                " i-ind-icms-st-antec        "       i-ind-icms-st-antec                           */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                    */

        RUN retornaNatureza (INPUT-OUTPUT c-nat-operacao).

/*         MESSAGE c-nat-operacao                 */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK. */

        ASSIGN l-return = YES.
        RETURN "OK".
    END.
    
    FIND FIRST def-nat-operacao
         WHERE def-nat-operacao.estado-origem         = estabelec.estado
           AND def-nat-operacao.ind-cliente-contrib   = emitente.contrib-icms
           AND def-nat-operacao.ind-insc-estadual-inf = l-insc-estadual-informada
           AND def-nat-operacao.ind-subst-tributaria  = l-ind-subst-tributaria
           AND def-nat-operacao.ind-suframa-inf       = l-ind-suframa-inf
           AND def-nat-operacao.cidade-destino        = ""
           AND def-nat-operacao.estado-destino        = ""
           AND def-nat-operacao.class-fiscal          = c-class-fiscal-item
           AND def-nat-operacao.ind-pais-brasil       = l-ind-pais-brasil
           AND def-nat-operacao.ind-oem               = l-oem
           AND def-nat-operacao.ind-consumidor-final  = l-ind-consumidor-final
           AND def-nat-operacao.ind-forma-tributo     = i-ind-forma-tributo
           AND def-nat-operacao.ind-origem-item       = 1
           AND def-nat-operacao.ind-vendas-alc        = i-ind-vendas-alc
           AND IF l-ind-consumidor-final THEN def-nat-operacao.ind-lei-bem = l-lei-bem ELSE YES
           AND def-nat-operacao.ind-icms-st-antec     = i-ind-icms-st-antec
        NO-LOCK NO-ERROR.

/*            MESSAGE "7 a"  "estabelec.estado            "      estabelec.estado                  SKIP */
/*                          "emitente.contrib-icms       "      emitente.contrib-icms             SKIP  */
/*                          "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP  */
/*                          "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP  */
/*                          "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP  */
/*                          "Cidade "                                                              SKIP */
/*                          "loc-entr.estado             "                      SKIP                    */
/*                          "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP  */
/*                          "l-oem                       "      l-oem                             SKIP  */
/*                          "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP  */
/*                          "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP  */
/*                          "i-ind-origem-item           "      1 SKIP                                  */
/*                   " i-ind-icms-st-antec        "       i-ind-icms-st-antec                           */
/*                VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                    */
    IF AVAIL def-nat-operacao THEN DO:
/*         MESSAGE "7 "  "estabelec.estado            "      estabelec.estado                  SKIP  */
/*                       "emitente.contrib-icms       "      emitente.contrib-icms             SKIP  */
/*                       "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP  */
/*                       "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP  */
/*                       "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP  */
/*                       "Cidade "                                                              SKIP */
/*                       "loc-entr.estado             "                      SKIP                    */
/*                       "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP  */
/*                       "l-oem                       "      l-oem                             SKIP  */
/*                       "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP  */
/*                       "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP  */
/*                       "i-ind-origem-item           "      1 SKIP                                  */
/*                " i-ind-icms-st-antec        "       i-ind-icms-st-antec                           */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                    */

        RUN retornaNatureza (input-output c-nat-operacao).

/*         MESSAGE c-nat-operacao                 */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK. */

        ASSIGN l-return = YES.
        RETURN "OK".
    END.

    /* 7 sem classificaá∆o */ 
    FIND FIRST def-nat-operacao
      WHERE def-nat-operacao.estado-origem         = estabelec.estado
        AND def-nat-operacao.ind-cliente-contrib   = emitente.contrib-icms
        AND def-nat-operacao.ind-insc-estadual-inf = l-insc-estadual-informada
        AND def-nat-operacao.ind-subst-tributaria  = l-ind-subst-tributaria
        AND def-nat-operacao.ind-suframa-inf       = l-ind-suframa-inf
        AND def-nat-operacao.cidade-destino        = ""
        AND def-nat-operacao.estado-destino        = ""
        AND def-nat-operacao.class-fiscal          = c-class-fiscal-item
        AND def-nat-operacao.ind-pais-brasil       = l-ind-pais-brasil
        AND def-nat-operacao.ind-oem               = l-oem
        AND def-nat-operacao.ind-consumidor-final  = l-ind-consumidor-final
        AND def-nat-operacao.ind-forma-tributo     = i-ind-forma-tributo
        AND def-nat-operacao.ind-origem-item       = 1
        AND def-nat-operacao.ind-vendas-alc        = i-ind-vendas-alc
        AND IF l-ind-consumidor-final THEN def-nat-operacao.ind-lei-bem = l-lei-bem ELSE YES
        AND def-nat-operacao.ind-icms-st-antec     = i-ind-icms-st-antec
         NO-LOCK NO-ERROR.
    
    /*            MESSAGE "7 a"  "estabelec.estado            "      estabelec.estado                  SKIP */
    /*                          "emitente.contrib-icms       "      emitente.contrib-icms             SKIP  */
    /*                          "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP  */
    /*                          "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP  */
    /*                          "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP  */
    /*                          "Cidade "                                                              SKIP */
    /*                          "loc-entr.estado             "                      SKIP                    */
    /*                          "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP  */
    /*                          "l-oem                       "      l-oem                             SKIP  */
    /*                          "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP  */
    /*                          "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP  */
    /*                          "i-ind-origem-item           "      1 SKIP                                  */
    /*                   " i-ind-icms-st-antec        "       i-ind-icms-st-antec                           */
    /*                VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                    */
     IF AVAIL def-nat-operacao THEN DO:
    /*         MESSAGE "7 "  "estabelec.estado            "      estabelec.estado                  SKIP  */
    /*                       "emitente.contrib-icms       "      emitente.contrib-icms             SKIP  */
    /*                       "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP  */
    /*                       "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP  */
    /*                       "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP  */
    /*                       "Cidade "                                                              SKIP */
    /*                       "loc-entr.estado             "                      SKIP                    */
    /*                       "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP  */
    /*                       "l-oem                       "      l-oem                             SKIP  */
    /*                       "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP  */
    /*                       "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP  */
    /*                       "i-ind-origem-item           "      1 SKIP                                  */
    /*                " i-ind-icms-st-antec        "       i-ind-icms-st-antec                           */
    /*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                    */
    
         RUN retornaNatureza (input-output c-nat-operacao).
    
    /*         MESSAGE c-nat-operacao                 */
    /*             VIEW-AS ALERT-BOX INFO BUTTONS OK. */
    
         ASSIGN l-return = YES.
         RETURN "OK".
     END.

        /* RETIRADO CONFORME SOLICITACAO DO ROGERIO DA SILVEIRA ATRAVES DO CHAMADO IR69134 
       BUSAR SEMPRE POR NACIONAL OU IMPORTADO, NUNCA POR NAO INFORMADO 
      */
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE defineNatOperacaoSemEmitente DBOProgram 
PROCEDURE defineNatOperacaoSemEmitente :
DEFINE INPUT  PARAMETER c-cod-estabel          AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER c-estado-dest          AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER c-it-codigo            AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER l-ind-consumidor-final AS LOGICAL     NO-UNDO.
    DEFINE OUTPUT PARAMETER c-nat-operacao         AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER l-return               AS LOGICAL     NO-UNDO.

    DEFINE VARIABLE l-insc-estadual-informada AS LOGICAL INITIAL NO  NO-UNDO.
    DEFINE VARIABLE l-ind-subst-tributaria    AS LOGICAL INITIAL NO  NO-UNDO.
    DEFINE VARIABLE l-ind-suframa-inf         AS LOGICAL INITIAL NO  NO-UNDO.
    DEFINE VARIABLE l-ind-pais-brasil         AS LOGICAL INITIAL NO  NO-UNDO.
    DEFINE VARIABLE l-oem                     AS LOGICAL INITIAL NO  NO-UNDO.
    DEFINE VARIABLE l-lei-bem                 AS LOGICAL INITIAL NO  NO-UNDO.
    DEFINE VARIABLE i-ind-forma-tributo       AS INTEGER             NO-UNDO.
    DEFINE VARIABLE i-ind-origem-item         AS INTEGER             NO-UNDO.
    DEFINE VARIABLE i-ind-icms-st-antec       AS LOGICAL               NO-UNDO.
    DEFINE VARIABLE c-class-fiscal-item       AS CHARACTER   NO-UNDO.

    FIND FIRST estabelec NO-LOCK
        WHERE  estabelec.cod-estabel = c-cod-estabel NO-ERROR.

    ASSIGN l-return = NO.

    IF  c-it-codigo <> "" THEN DO:
        FIND ITEM
             WHERE ITEM.it-codigo = c-it-codigo  NO-LOCK NO-ERROR.

        ASSIGN c-class-fiscal-item = ITEM.class-fiscal. 

        ASSIGN c-class-fiscal-item = ''.

        FIND FIRST int-familia 
             WHERE int-familia.fm-codigo = item.fm-codigo no-lock no-error.
        IF  AVAIL int-familia THEN
            ASSIGN l-oem = int-familia.oem.
        ELSE
            ASSIGN l-oem = NO.

        IF  SUBSTRING(ITEM.char-2,212,1) = "9" THEN
            ASSIGN l-servico = YES.
        ELSE
            ASSIGN l-servico = NO.

        IF ITEM.codigo-orig = 0 or
           ITEM.codigo-orig = 3 or
           ITEM.codigo-orig = 5 or
           ITEM.codigo-orig = 8 THEN
           ASSIGN i-ind-origem-item = 2. /* nacional */
        ELSE
           IF ITEM.codigo-orig = 1 OR
              ITEM.codigo-orig = 6 THEN
              ASSIGN i-ind-origem-item = 3.  /*importado */
           ELSE 
              ASSIGN i-ind-origem-item = 1. /* n∆o informado */

        FIND FIRST int-item NO-LOCK
            WHERE  int-item.it-codigo = c-it-codigo NO-ERROR.
        IF  AVAIL  int-item THEN
            ASSIGN l-lei-bem = int-item.log2
                   i-ind-icms-st-antec  = IF substring(int-item.char1,4,1) = "S" THEN YES ELSE NO.
        ELSE
            ASSIGN i-ind-icms-st-antec  = NO.
    END.
    ELSE DO:
        ASSIGN l-oem = NO
               i-ind-origem-item = 1
               i-ind-icms-st-antec  = NO.
    END.

    ASSIGN i-ind-forma-tributo       = 4
           l-insc-estadual-informada = YES
           l-ind-suframa-inf         = NO
           l-ind-pais-brasil         = YES.

    IF estabelec.estado = "AM" THEN
       ASSIGN i-ind-forma-tributo = 1. /* Nao Cumulativo */

    IF  l-insc-estadual-informada = YES THEN DO:
        FIND FIRST unid-feder NO-LOCK
            WHERE unid-feder.pais   = emitente.pais
            AND   unid-feder.estado = emitente.estado NO-ERROR.
        IF  AVAIL unid-feder AND unid-feder.ind-uf-subs THEN DO:
            FIND FIRST item-uf NO-LOCK
                WHERE  item-uf.it-codigo       = ITEM.it-codigo
                AND    item-uf.cod-estado-orig = estabelec.estado
                AND    item-uf.estado          = c-estado-dest NO-ERROR.
            IF  AVAIL  item-uf THEN 
                ASSIGN l-ind-subst-tributaria = YES.
            ELSE
                ASSIGN l-ind-subst-tributaria = NO.
        END.
    END.

    FIND FIRST def-nat-operacao NO-LOCK
         WHERE def-nat-operacao.estado-origem         = estabelec.estado
           AND def-nat-operacao.ind-cliente-contrib   = YES
           AND def-nat-operacao.ind-insc-estadual-inf = l-insc-estadual-informada
           AND def-nat-operacao.ind-subst-tributaria  = l-ind-subst-tributaria
           AND def-nat-operacao.ind-suframa-inf       = l-ind-suframa-inf
           AND def-nat-operacao.cidade-destino        = ""
           AND def-nat-operacao.estado-destino        = c-estado-dest
           AND def-nat-operacao.class-fiscal          = c-class-fiscal-item
           AND def-nat-operacao.ind-pais-brasil       = l-ind-pais-brasil
           AND def-nat-operacao.ind-oem               = l-oem
           AND def-nat-operacao.ind-consumidor-final  = l-ind-consumidor-final
           AND def-nat-operacao.ind-forma-tributo     = i-ind-forma-tributo
           AND def-nat-operacao.ind-origem-item       = i-ind-origem-item
           AND IF l-ind-consumidor-final THEN def-nat-operacao.ind-lei-bem = l-lei-bem ELSE YES 
           AND def-nat-operacao.ind-icms-st-antec     = i-ind-icms-st-antec NO-ERROR.

    IF  AVAIL  def-nat-operacao THEN DO:



        RUN retornaNaturezaSemEmitente (INPUT-OUTPUT c-nat-operacao,
                                        INPUT        c-estado-dest).

         /*MESSAGE c-nat-operacao                 
             VIEW-AS ALERT-BOX INFO BUTTONS OK. */

        ASSIGN l-return = YES.
        RETURN "OK".
    END.


    FIND FIRST def-nat-operacao NO-LOCK
         WHERE def-nat-operacao.estado-origem         = estabelec.estado
           AND def-nat-operacao.ind-cliente-contrib   = YES
           AND def-nat-operacao.ind-insc-estadual-inf = l-insc-estadual-informada
           AND def-nat-operacao.ind-subst-tributaria  = l-ind-subst-tributaria
           AND def-nat-operacao.ind-suframa-inf       = l-ind-suframa-inf
           AND def-nat-operacao.cidade-destino        = ""
           AND def-nat-operacao.estado-destino        = ""
           AND def-nat-operacao.class-fiscal          = c-class-fiscal-item
           AND def-nat-operacao.ind-pais-brasil       = l-ind-pais-brasil
           AND def-nat-operacao.ind-oem               = l-oem
           AND def-nat-operacao.ind-consumidor-final  = l-ind-consumidor-final
           AND def-nat-operacao.ind-forma-tributo     = i-ind-forma-tributo
           AND def-nat-operacao.ind-origem-item       = i-ind-origem-item
           AND IF l-ind-consumidor-final THEN def-nat-operacao.ind-lei-bem = l-lei-bem ELSE YES 
           AND def-nat-operacao.ind-icms-st-antec     = i-ind-icms-st-antec NO-ERROR.
    IF  AVAIL  def-nat-operacao THEN DO:
/*         MESSAGE "4 "  "estabelec.estado            "      estabelec.estado                  SKIP */
/*                       "emitente.contrib-icms       "      emitente.contrib-icms             SKIP */
/*                       "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP */
/*                       "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP */
/*                       "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP */
/*                       "Cidade "                                                            SKIP  */
/*                       "loc-entr.estado             "                     SKIP                    */
/*                       "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP */
/*                       "l-oem                       "      l-oem                             SKIP */
/*                       "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP */
/*                       "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP */
/*                       "i-ind-origem-item           "      i-ind-origem-item                      */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                   */

        RUN retornaNaturezaSemEmitente (INPUT-OUTPUT c-nat-operacao,
                                        INPUT        c-estado-dest).

        /*MESSAGE c-nat-operacao                 
            VIEW-AS ALERT-BOX INFO BUTTONS OK.*/ 

        ASSIGN l-return = YES.
        RETURN "OK".
    END.

/* RETIRADO CONFORME SOLICITACAO DO ROGERIO DA SILVEIRA ATRAVES DO CHAMADO IR69134 
    BUSAR SEMPRE POR NACIONAL OU IMPORTADO, NUNCA POR NAO INFORMADO 
                                           */
    FIND FIRST def-nat-operacao NO-LOCK
         WHERE def-nat-operacao.estado-origem         = estabelec.estado
           AND def-nat-operacao.ind-cliente-contrib   = YES
           AND def-nat-operacao.ind-insc-estadual-inf = l-insc-estadual-informada
           AND def-nat-operacao.ind-subst-tributaria  = l-ind-subst-tributaria
           AND def-nat-operacao.ind-suframa-inf       = l-ind-suframa-inf
           AND def-nat-operacao.cidade-destino        = ""
           AND def-nat-operacao.estado-destino        = c-estado-dest
           AND def-nat-operacao.class-fiscal          = "" //c-class-fiscal-item
           AND def-nat-operacao.ind-pais-brasil       = l-ind-pais-brasil
           AND def-nat-operacao.ind-oem               = l-oem
           AND def-nat-operacao.ind-consumidor-final  = l-ind-consumidor-final
           AND def-nat-operacao.ind-forma-tributo     = i-ind-forma-tributo
           AND def-nat-operacao.ind-origem-item       = 1
           AND IF l-ind-consumidor-final THEN def-nat-operacao.ind-lei-bem = l-lei-bem ELSE YES 
           AND def-nat-operacao.ind-icms-st-antec     = i-ind-icms-st-antec NO-ERROR.
    IF  AVAIL  def-nat-operacao THEN DO:
/*         MESSAGE "6 "  "estabelec.estado            "      estabelec.estado                  SKIP  */
/*                       "emitente.contrib-icms       "      emitente.contrib-icms             SKIP  */
/*                       "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP  */
/*                       "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP  */
/*                       "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP  */
/*                       "Cidade "                                                              SKIP */
/*                       "loc-entr.estado             "      loc-entr.estado                   SKIP  */
/*                       "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP  */
/*                       "l-oem                       "      l-oem                             SKIP  */
/*                       "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP  */
/*                       "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP  */
/*                       "i-ind-origem-item           "      1                                       */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                    */

        RUN retornaNaturezaSemEmitente (INPUT-OUTPUT c-nat-operacao,
                                        INPUT        c-estado-dest).

       /*MESSAGE c-nat-operacao                 
           VIEW-AS ALERT-BOX INFO BUTTONS OK.*/ 

        ASSIGN l-return = YES.
        RETURN "OK".
    END.


    FIND FIRST def-nat-operacao NO-LOCK
         WHERE def-nat-operacao.estado-origem         = estabelec.estado
           AND def-nat-operacao.ind-cliente-contrib   = YES
           AND def-nat-operacao.ind-insc-estadual-inf = l-insc-estadual-informada
           AND def-nat-operacao.ind-subst-tributaria  = l-ind-subst-tributaria
           AND def-nat-operacao.ind-suframa-inf       = l-ind-suframa-inf
           AND def-nat-operacao.cidade-destino        = ""
           AND def-nat-operacao.estado-destino        = ""
           AND def-nat-operacao.class-fiscal          = "" //c-class-fiscal-item
           AND def-nat-operacao.ind-pais-brasil       = l-ind-pais-brasil
           AND def-nat-operacao.ind-oem               = l-oem
           AND def-nat-operacao.ind-consumidor-final  = l-ind-consumidor-final
           AND def-nat-operacao.ind-forma-tributo     = i-ind-forma-tributo
           AND def-nat-operacao.ind-origem-item       = 1
           AND IF l-ind-consumidor-final THEN def-nat-operacao.ind-lei-bem = l-lei-bem ELSE YES 
           AND def-nat-operacao.ind-icms-st-antec     = i-ind-icms-st-antec NO-ERROR.
    IF  AVAIL  def-nat-operacao THEN DO:
/*         MESSAGE "7 "  "estabelec.estado            "      estabelec.estado                  SKIP  */
/*                       "emitente.contrib-icms       "      emitente.contrib-icms             SKIP  */
/*                       "l-insc-estadual-informada   "      l-insc-estadual-informada         SKIP  */
/*                       "l-ind-subst-tributaria      "      l-ind-subst-tributaria            SKIP  */
/*                       "l-ind-suframa-inf           "      l-ind-suframa-inf                 SKIP  */
/*                       "Cidade "                                                              SKIP */
/*                       "loc-entr.estado             "                      SKIP                    */
/*                       "l-ind-pais-brasil           "      l-ind-pais-brasil                 SKIP  */
/*                       "l-oem                       "      l-oem                             SKIP  */
/*                       "l-ind-consumidor-final      "      l-ind-consumidor-final            SKIP  */
/*                       "i-ind-forma-tributo         "      i-ind-forma-tributo               SKIP  */
/*                       "i-ind-origem-item           "      1                                       */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                    */

        RUN retornaNaturezaSemEmitente (INPUT-OUTPUT c-nat-operacao,
                                        INPUT        c-estado-dest).

        /*MESSAGE c-nat-operacao                
            VIEW-AS ALERT-BOX INFO BUTTONS OK.*/

        ASSIGN l-return = YES.
        RETURN "OK".
    END.
    /* RETIRADO CONFORME SOLICITACAO DO ROGERIO DA SILVEIRA ATRAVES DO CHAMADO IR69134 
       BUSAR SEMPRE POR NACIONAL OU IMPORTADO, NUNCA POR NAO INFORMADO 
      */
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "cidade-destino":U THEN ASSIGN pFieldValue = RowObject.cidade-destino.
        WHEN "estado-destino":U THEN ASSIGN pFieldValue = RowObject.estado-destino.
        WHEN "estado-origem":U THEN ASSIGN pFieldValue = RowObject.estado-origem.
        WHEN "nat-oper-revenda-de":U THEN ASSIGN pFieldValue = RowObject.nat-oper-revenda-de.
        WHEN "nat-oper-revenda-fe":U THEN ASSIGN pFieldValue = RowObject.nat-oper-revenda-fe.
        WHEN "nat-oper-serv-de":U THEN ASSIGN pFieldValue = RowObject.nat-oper-serv-de.
        WHEN "nat-oper-serv-fe":U THEN ASSIGN pFieldValue = RowObject.nat-oper-serv-fe.
        WHEN "nat-oper-venda-de":U THEN ASSIGN pFieldValue = RowObject.nat-oper-venda-de.
        WHEN "nat-oper-venda-fe":U THEN ASSIGN pFieldValue = RowObject.nat-oper-venda-fe.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "date-1":U THEN ASSIGN pFieldValue = RowObject.date-1.
        WHEN "date-2":U THEN ASSIGN pFieldValue = RowObject.date-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ch-principal
  Parameters:  
               retorna valor do campo estado-origem
               retorna valor do campo ind-cliente-contrib
               retorna valor do campo ind-insc-estadual-inf
               retorna valor do campo ind-subst-tributaria
               retorna valor do campo ind-suframa-inf
               retorna valor do campo cidade-destino
               retorna valor do campo estado-destino
               retorna valor do campo ind-pais-brasil
               retorna valor do campo ind-oem
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pestado-origem LIKE def-nat-operacao.estado-origem NO-UNDO.
    DEFINE OUTPUT PARAMETER pind-cliente-contrib LIKE def-nat-operacao.ind-cliente-contrib NO-UNDO.
    DEFINE OUTPUT PARAMETER pind-insc-estadual-inf LIKE def-nat-operacao.ind-insc-estadual-inf NO-UNDO.
    DEFINE OUTPUT PARAMETER pind-subst-tributaria LIKE def-nat-operacao.ind-subst-tributaria NO-UNDO.
    DEFINE OUTPUT PARAMETER pind-suframa-inf LIKE def-nat-operacao.ind-suframa-inf NO-UNDO.
    DEFINE OUTPUT PARAMETER pcidade-destino LIKE def-nat-operacao.cidade-destino NO-UNDO.
    DEFINE OUTPUT PARAMETER pestado-destino LIKE def-nat-operacao.estado-destino NO-UNDO.
    DEFINE OUTPUT PARAMETER pind-pais-brasil LIKE def-nat-operacao.ind-pais-brasil NO-UNDO.
    DEFINE OUTPUT PARAMETER pind-oem LIKE def-nat-operacao.ind-oem NO-UNDO.
    DEFINE OUTPUT PARAMETER pind-origem-item LIKE def-nat-operacao.ind-origem-item NO-UNDO.
    DEFINE OUTPUT PARAMETER pind-vendas-alc LIKE def-nat-operacao.ind-vendas-alc NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pestado-origem = RowObject.estado-origem
           pind-cliente-contrib = RowObject.ind-cliente-contrib
           pind-insc-estadual-inf = RowObject.ind-insc-estadual-inf
           pind-subst-tributaria = RowObject.ind-subst-tributaria
           pind-suframa-inf = RowObject.ind-suframa-inf
           pcidade-destino = RowObject.cidade-destino
           pestado-destino = RowObject.estado-destino
           pind-pais-brasil = RowObject.ind-pais-brasil
           pind-oem = RowObject.ind-oem
           pind-origem-item = RowObject.ind-origem-item
           pind-vendas-alc = RowObject.ind-vendas-alc.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "ind-cliente-contrib":U THEN ASSIGN pFieldValue = RowObject.ind-cliente-contrib.
        WHEN "ind-insc-estadual-inf":U THEN ASSIGN pFieldValue = RowObject.ind-insc-estadual-inf.
        WHEN "ind-oem":U THEN ASSIGN pFieldValue = RowObject.ind-oem.
        WHEN "ind-pais-brasil":U THEN ASSIGN pFieldValue = RowObject.ind-pais-brasil.
        WHEN "ind-subst-tributaria":U THEN ASSIGN pFieldValue = RowObject.ind-subst-tributaria.
        WHEN "ind-suframa-inf":U THEN ASSIGN pFieldValue = RowObject.ind-suframa-inf.
        WHEN "ind-consumidor-final":U THEN ASSIGN pFieldValue = RowObject.ind-consumidor-final.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2

            .
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecidField DBOProgram 
PROCEDURE getRecidField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo recid
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RECID NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice ch-principal
  Parameters:  
               recebe valor do campo estado-origem
               recebe valor do campo ind-cliente-contrib
               recebe valor do campo ind-insc-estadual-inf
               recebe valor do campo ind-subst-tributaria
               recebe valor do campo ind-suframa-inf
               recebe valor do campo cidade-destino
               recebe valor do campo estado-destino
               recebe valor do campo ind-pais-brasil
               recebe valor do campo ind-oem
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pestado-origem         LIKE def-nat-operacao.estado-origem         NO-UNDO.
    DEFINE INPUT PARAMETER pind-cliente-contrib   LIKE def-nat-operacao.ind-cliente-contrib   NO-UNDO.
    DEFINE INPUT PARAMETER pind-insc-estadual-inf LIKE def-nat-operacao.ind-insc-estadual-inf NO-UNDO.
    DEFINE INPUT PARAMETER pind-subst-tributaria  LIKE def-nat-operacao.ind-subst-tributaria  NO-UNDO.
    DEFINE INPUT PARAMETER pind-consumidor-final  LIKE def-nat-operacao.ind-consumidor-final  NO-UNDO.
    DEFINE INPUT PARAMETER pind-suframa-inf       LIKE def-nat-operacao.ind-suframa-inf       NO-UNDO.
    DEFINE INPUT PARAMETER pcidade-destino        LIKE def-nat-operacao.cidade-destino        NO-UNDO.
    DEFINE INPUT PARAMETER pestado-destino        LIKE def-nat-operacao.estado-destino        NO-UNDO.
    DEFINE INPUT PARAMETER pind-forma-tributo     LIKE def-nat-operacao.ind-forma-tributo     NO-UNDO.
    DEFINE INPUT PARAMETER pind-pais-brasil       LIKE def-nat-operacao.ind-pais-brasil       NO-UNDO.
    DEFINE INPUT PARAMETER pind-oem               LIKE def-nat-operacao.ind-oem               NO-UNDO.
    DEFINE INPUT PARAMETER pind-origem-item       LIKE def-nat-operacao.ind-origem-item       NO-UNDO.
    DEFINE INPUT PARAMETER pind-vendas-alc        LIKE def-nat-operacao.ind-vendas-alc        NO-UNDO.
    DEFINE INPUT PARAMETER pind-lei-bem           LIKE def-nat-operacao.ind-lei-bem           NO-UNDO.
    DEFINE INPUT PARAMETER picms-st-antec         LIKE def-nat-operacao.ind-icms-st-antec     NO-UNDO.
    DEFINE INPUT PARAMETER pclass-fiscal          LIKE def-nat-operacao.class-fiscal          NO-UNDO.
                 
    FIND FIRST bfdef-nat-operacao WHERE 
        bfdef-nat-operacao.estado-origem = pestado-origem AND 
        bfdef-nat-operacao.ind-cliente-contrib = pind-cliente-contrib AND 
        bfdef-nat-operacao.ind-insc-estadual-inf = pind-insc-estadual-inf AND 
        bfdef-nat-operacao.ind-subst-tributaria = pind-subst-tributaria AND 
        bfdef-nat-operacao.ind-suframa-inf = pind-suframa-inf AND 
        bfdef-nat-operacao.cidade-destino = pcidade-destino AND 
        bfdef-nat-operacao.estado-destino = pestado-destino AND 
        bfdef-nat-operacao.ind-pais-brasil = pind-pais-brasil AND 
        bfdef-nat-operacao.ind-forma-tributo = pind-forma-tributo AND
        bfdef-nat-operacao.ind-oem = pind-oem AND
        bfdef-nat-operacao.ind-consumidor-final = pind-consumidor-final AND
        bfdef-nat-operacao.ind-origem-item = pind-origem-item AND
        bfdef-nat-operacao.ind-vendas-alc = pind-vendas-alc AND
        bfdef-nat-operacao.ind-lei-bem = pind-lei-bem AND
        bfdef-nat-operacao.ind-icms-st-antec = picms-st-antec AND
        bfdef-nat-operacao.class-fiscal = pclass-fiscal
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdef-nat-operacao THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdef-nat-operacao)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                               WHERE {&TableName}.estado-origem       >= v-estado-orig-ini 
                                 AND {&TableName}.estado-origem       <= v-estado-orig-fim
                                 and {&TableName}.estado-destino      >= v-estado-dest-ini 
                                 AND {&TableName}.estado-destino      <= v-estado-dest-fim
                                 and {&TableName}.class-fiscal        >= v-class-fiscal-ini 
                                 AND {&TableName}.class-fiscal        <= v-class-fiscal-fim
                                 AND {&TableName}.ind-cliente-contrib  = v-cliente-contrib 
                                 AND {&TableName}.ind-subst-tributaria = v-icms-st         
                                 AND {&TableName}.ind-consumidor-final = v-consumidor-final
                                 AND {&TableName}.ind-oem              = v-oem.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaNatureza DBOProgram 
PROCEDURE retornaNatureza :
DEF INPUT-OUTPUT PARAMETER c-nat-operacao AS CHARACTER.

    IF loc-entr.estado = def-nat-operacao.estado-origem THEN
       IF l-servico = YES THEN
          ASSIGN c-nat-operacao = def-nat-operacao.nat-oper-serv-de.
       ELSE
           IF def-nat-operacao.ind-oem = YES THEN
              ASSIGN c-nat-operacao = def-nat-operacao.nat-oper-revenda-de.
           ELSE
              ASSIGN c-nat-operacao = def-nat-operacao.nat-oper-venda-de.
    ELSE
        IF l-servico = YES THEN
           ASSIGN c-nat-operacao = def-nat-operacao.nat-oper-serv-fe.
        ELSE
            IF def-nat-operacao.ind-oem = YES THEN
               ASSIGN c-nat-operacao = def-nat-operacao.nat-oper-revenda-fe.
            ELSE
               ASSIGN c-nat-operacao = def-nat-operacao.nat-oper-venda-fe.
                              

/*     MESSAGE                                                                                         */
/*        "def-nat-operacao.estado-origem          "    def-nat-operacao.estado-origem         SKIP    */
/*        "def-nat-operacao.ind-cliente-contrib    "    def-nat-operacao.ind-cliente-contrib   SKIP    */
/*        "def-nat-operacao.ind-insc-estadual-in   "    def-nat-operacao.ind-insc-estadual-in   SKIP   */
/*        "def-nat-operacao.ind-subst-tributaria   "    def-nat-operacao.ind-subst-tributaria    SKIP  */
/*        "def-nat-operacao.ind-suframa-inf        "    def-nat-operacao.ind-suframa-inf         SKIP  */
/*        "def-nat-operacao.cidade-destino         "    def-nat-operacao.cidade-destino          SKIP  */
/*        "def-nat-operacao.estado-destino         "    def-nat-operacao.estado-destino        SKIP    */
/*        "def-nat-operacao.ind-pais-brasil        "    def-nat-operacao.ind-pais-brasil       SKIP    */
/*        "def-nat-operacao.ind-oem                "    def-nat-operacao.ind-oem                SKIP   */
/*        "def-nat-operacao.ind-consumidor-final   "    def-nat-operacao.ind-consumidor-final    SKIP  */
/*        "def-nat-operacao.ind-forma-tributo      "    def-nat-operacao.ind-forma-tributo        SKIP */
/*        "DEF-nat-operacao.ind-origem-item        "    DEF-nat-operacao.ind-origem-item     SKIP      */
/*         c-nat-operacao VIEW-AS ALERT-BOX.                                                           */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaNaturezaSemEmitente DBOProgram 
PROCEDURE retornaNaturezaSemEmitente :
DEFINE INPUT-OUTPUT PARAMETER c-nat-operacao AS CHARACTER   NO-UNDO.
DEFINE INPUT        PARAMETER c-estado-dest  AS CHARACTER   NO-UNDO.

    IF  c-estado-dest = def-nat-operacao.estado-origem THEN
       IF l-servico = YES THEN
          ASSIGN c-nat-operacao = def-nat-operacao.nat-oper-serv-de.
       ELSE
           IF def-nat-operacao.ind-oem = YES THEN
              ASSIGN c-nat-operacao = def-nat-operacao.nat-oper-revenda-de.
           ELSE
              ASSIGN c-nat-operacao = def-nat-operacao.nat-oper-venda-de.
    ELSE
        IF l-servico = YES THEN
           ASSIGN c-nat-operacao = def-nat-operacao.nat-oper-serv-fe.
        ELSE
            IF def-nat-operacao.ind-oem = YES THEN
               ASSIGN c-nat-operacao = def-nat-operacao.nat-oper-revenda-fe.
            ELSE
               ASSIGN c-nat-operacao = def-nat-operacao.nat-oper-venda-fe.
                              /*

    PUT 
       "def-nat-operacao.estado-origem          "    def-nat-operacao.estado-origem         SKIP
       "def-nat-operacao.ind-cliente-contrib    "    def-nat-operacao.ind-cliente-contrib   SKIP  
       "def-nat-operacao.ind-insc-estadual-in   "    def-nat-operacao.ind-insc-estadual-in   SKIP 
       "def-nat-operacao.ind-subst-tributaria   "    def-nat-operacao.ind-subst-tributaria    SKIP
       "def-nat-operacao.ind-suframa-inf        "    def-nat-operacao.ind-suframa-inf         SKIP 
       "def-nat-operacao.cidade-destino         "    def-nat-operacao.cidade-destino          SKIP
       "def-nat-operacao.estado-destino         "    def-nat-operacao.estado-destino        SKIP  
       "def-nat-operacao.ind-pais-brasil        "    def-nat-operacao.ind-pais-brasil       SKIP  
       "def-nat-operacao.ind-oem                "    def-nat-operacao.ind-oem                SKIP 
       "def-nat-operacao.ind-consumidor-final   "    def-nat-operacao.ind-consumidor-final    SKIP
       "def-nat-operacao.ind-forma-tributo      "    def-nat-operacao.ind-forma-tributo        SKIP
       "DEF-nat-operacao.ind-origem-item        "    DEF-nat-operacao.ind-origem-item     SKIP
        c-nat-operacao SKIP.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstrainMain DBOProgram 
PROCEDURE SetConstrainMain :
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
DEFINE INPUT PARAMETER p-estado-orig-ini  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-estado-orig-fim  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-estado-dest-ini  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-estado-dest-fim  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-class-fiscal-ini  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-class-fiscal-fim  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-cliente-contrib  AS LOGICAL NO-UNDO.
DEFINE INPUT PARAMETER p-icms-st          AS LOGICAL NO-UNDO.
DEFINE INPUT PARAMETER p-consumidor-final AS LOGICAL NO-UNDO.
DEFINE INPUT PARAMETER p-oem              AS LOGICAL NO-UNDO.

ASSIGN v-estado-orig-ini  = p-estado-orig-ini 
       v-estado-orig-fim  = p-estado-orig-fim 
       v-estado-dest-ini  = p-estado-dest-ini 
       v-estado-dest-fim  = p-estado-dest-fim 
       v-class-fiscal-ini  = p-class-fiscal-ini 
       v-class-fiscal-fim  = p-class-fiscal-fim 
       v-cliente-contrib  = p-cliente-contrib 
       v-icms-st          = p-icms-st         
       v-consumidor-final = p-consumidor-final
       v-oem              = p-oem             .
     
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
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF  pType = "Create":U THEN DO:
        IF  CAN-FIND(FIRST def-nat-operacao NO-LOCK
                     WHERE def-nat-operacao.estado-origem         = rowObject.estado-origem
                     AND   def-nat-operacao.ind-cliente-contrib   = rowObject.ind-cliente-contrib
                     AND   def-nat-operacao.ind-insc-estadual-inf = rowObject.ind-insc-estadual-inf
                     AND   def-nat-operacao.ind-subst-tributaria  = rowObject.ind-subst-tributaria
                     AND   def-nat-operacao.ind-suframa-inf       = rowObject.ind-suframa-inf
                     AND   def-nat-operacao.cidade-destino        = rowObject.cidade-destino
                     AND   def-nat-operacao.estado-destino        = rowObject.estado-destino
                     AND   def-nat-operacao.ind-pais-brasil       = rowObject.ind-pais-brasil
                     AND   def-nat-operacao.ind-forma-tributo     = rowObject.ind-forma-tributo
                     AND   def-nat-operacao.ind-oem               = rowObject.ind-oem
                     AND   def-nat-operacao.ind-consumidor-final  = rowObject.ind-consumidor-final
                     AND   def-nat-operacao.ind-origem-item       = rowObject.ind-origem-item
                     AND   def-nat-operacao.ind-vendas-alc        = rowObject.ind-vendas-alc
                     AND   def-nat-operacao.ind-lei-bem           = rowObject.ind-lei-bem
                     AND   def-nat-operacao.ind-icms-st-antec     = rowObject.ind-icms-st-antec
                     AND   def-nat-operacao.class-fiscal          = rowObject.class-fiscal) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber     = 7
                                        &ErrorType       = "EMS"
                                        &ErrorParameters = "'Definiá∆o da Natureza de Operaá∆o'"}
         END.
        
         IF rowobject.class-fiscal <> "" THEN DO:
             IF NOT CAN-FIND (FIRST classif-fisc 
                              WHERE classif-fisc.class-fiscal = rowobject.class-fiscal) THEN DO:
                 {method/svc/errors/inserr.i
                        &ErrorNumber="17006"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="'NCM informada n∆o cadastrada.'"}
             END.
         END.
    END.


    IF pType = "Create" OR pType = "Update" THEN DO:
            IF NOT CAN-FIND(FIRST unid-feder
                        WHERE unid-feder.pais = "Brasil"
                          AND unid-feder.estado = rowobject.estado-origem) THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="17006"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="'Estado Origem N∆o encontrado.~~~~Estado Origem N∆o encontrado.'"}
        
            END.
            IF rowobject.estado-origem = "AM" AND
               rowobject.estado-destino <> "EX" THEN DO:
               IF rowobject.ind-consumidor-final = NO THEN DO:
                    IF rowobject.ind-forma-tributo = 0 OR 
                       rowobject.ind-forma-tributo > 3  THEN DO:
                        {method/svc/errors/inserr.i
                            &ErrorNumber="17006"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="'Forma de tributaá∆o invalida para estado origem.~~~~Informe Lucro Real, Lucro Presumido ou Simples.'"}
    
                    END.
               END.
            END.
            ELSE DO:
                IF  rowobject.estado-origem <> "SC"
                AND rowobject.ind-forma-tributo <> 4 THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="17006"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="'Forma de tributaá∆o invalida para estado origem.~~~~Informe Nenhum quando estado Ç diferente de Amazonas'"}

                END.
            END.

            IF rowobject.cidade-destino <> "" THEN 
                IF NOT CAN-FIND(FIRST mgcad.cidade
                            WHERE mgcad.cidade.cidade = rowobject.cidade-destino
                              AND mgcad.cidade.estado = rowobject.estado-destino) THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="17006"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="'Cidade Destino N∆o encontrado.~~~~Estado Destino N∆o encontrado.'"}

                END.

            IF rowobject.estado-destino <> "" AND
               rowobject.estado-destino <> "EX" THEN 
                IF NOT CAN-FIND(FIRST unid-feder
                            WHERE unid-feder.pais = "Brasil"
                              AND unid-feder.estado = rowobject.estado-destino) THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="17006"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="'Estado Destino N∆o encontrado.~~~~Estado Destino N∆o encontrado.'"}

                END.

            IF rowobject.nat-oper-venda-de <> "" and
               NOT CAN-FIND(FIRST natur-oper
                        WHERE natur-oper.nat-operacao = rowobject.nat-oper-venda-de) THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="17006"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="'Natureza Oper.Venda Dentro Estado N∆o Encontrado.~~~~Natureza Oper.Venda Dentro Estado N∆o encontrado.'"}

            END.
            IF rowobject.nat-oper-venda-fe <> "" and
               NOT CAN-FIND(FIRST natur-oper
                        WHERE natur-oper.nat-operacao = rowobject.nat-oper-venda-fe) THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="17006"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="'Natureza Oper.Venda Fora Estado N∆o Encontrado.~~~~Natureza Oper.Venda Fora Estado N∆o encontrado.'"}

            END.
            IF rowobject.nat-oper-revenda-de <> "" and
               NOT CAN-FIND(FIRST natur-oper
                        WHERE natur-oper.nat-operacao = rowobject.nat-oper-revenda-de) THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="17006"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="'Natureza Oper.revenda Dentro Estado N∆o Encontrado.~~~~Natureza Oper.revenda Dentro Estado N∆o encontrado.'"}

            END.
            IF rowobject.nat-oper-revenda-fe <> "" AND
                nOT CAN-FIND(FIRST natur-oper
                        WHERE natur-oper.nat-operacao = rowobject.nat-oper-revenda-fe) THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="17006"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="'Natureza Oper.revenda Fora Estado N∆o Encontrado.~~~~Natureza Oper.revenda Fora Estado N∆o encontrado.'"}

            END.
            IF rowobject.nat-oper-serv-de <> "" and
                NOT CAN-FIND(FIRST natur-oper
                        WHERE natur-oper.nat-operacao = rowobject.nat-oper-serv-de) THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="17006"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="'Natureza Oper.servico Dentro Estado N∆o Encontrado.~~~~Natureza Oper.servico Dentro Estado N∆o encontrado.'"}

            END.
            IF rowobject.nat-oper-serv-fe <> "" AND
               NOT CAN-FIND(FIRST natur-oper
                        WHERE natur-oper.nat-operacao = rowobject.nat-oper-serv-fe) THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="17006"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="'Natureza Oper.servico Fora Estado N∆o Encontrado.~~~~Natureza Oper.servico Fora Estado N∆o encontrado.'"}

            END.

        END.


    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

