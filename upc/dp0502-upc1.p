{utp/ut-glob.i}
{esp/es0018.i}

DEFINE INPUT PARAMETER p-handle-browse AS HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-handle-bexecuta AS HANDLE NO-UNDO. 

DEFINE TEMP-TABLE tt-dados NO-UNDO
    FIELD marcado   AS LOG
    FIELD it-codigo AS CHAR
    FIELD versao    AS INTEGER
    INDEX ITEM it-codigo versao
    INDEX sel marcado.

define temp-table ttDpProcesItem-aux like dp-proces-item
        field r-rowid        as   rowid
        field c-marca        as   character initial "" column-label ""
        field it-codigo      as   character initial "" column-label "Item Destino"
        field fat-conv       like dp-item.val-fat-conv-un initial 1 column-label "Fator Conv."
        field un             like dp-item.un initial ""
        field un-destino     like dp-item.un-destino initial ""
        field elim-dp        as   logical initial no
        field relac-inativo  as   logical initial yes
        field renum-estrut   as   logical initial no
        field var-estrut     as   integer 
        field oper-inativo   as   integer
        field nmb            as   integer
        field renum-oper     as   logical
        field var-oper       as   integer
        field tp-altera-rot  as   integer   initial 0  /** 0 - Roteiro Novo 
                                                           1 - Roteiro Existente Igual, nao precisa exportar para Engenharia 
                                                           2 - Roteiro Existente Diferente e usuario deseja alterar na Engenharia
                                                           3 - Roteiro Existente Diferente e usuario nao quer alterar na Engenharia
                                                           9 - Roteiro Existente Diferente e precisa questionar o usuario: Alterar ou Nao na Engenharia? **/
        field c-altera-rot   as   character initial "" column-label "Altera Rot.Eng."
        field tp-altera-lc   as   integer   initial 0  /** 0 - Lista Nova
                                                           1 - Lista Existente Igual, nao precisa exportar para Engenharia
                                                           2 - Lista Existente Diferente e usuario deseja alterar na Engenharia
                                                           3 - Lista Existente Diferente e usuario nao quer alterar na Engenharia
                                                           9 - Lista Existente Diferente e precisa questionar o usuario: Alterar ou Nao na Engenharia? **/
        field i-sequen       as   integer
        field existe-item    as   logical   initial no
        field erro           as   character initial "" format 'x(60)'
        /*&IF defined(bf_man_206b) &THEN*/
            FIELD cod-unid-negoc LIKE unid-negoc.cod-unid-negoc INITIAL ""
        /*&ENDIF*/
        index nivel is primary nmb it-codigo
        index exporta nmb descending.

DEFINE VARIABLE h-marcado   AS HANDLE                   NO-UNDO.
DEFINE VARIABLE h-item      AS HANDLE                   NO-UNDO.
DEFINE VARIABLE h-versao    AS HANDLE                   NO-UNDO.
DEFINE VARIABLE i-linha     AS INTEGER                  NO-UNDO.
DEFINE VARIABLE p-itemob    AS CHAR                     NO-UNDO.
DEFINE VARIABLE p-ativo     AS LOGICAL  INITIAL YES     NO-UNDO.
DEFINE VARIABLE h-dpapi001  AS HANDLE                   NO-UNDO.
DEFINE VARIABLE wh-tt       AS WIDGET-HANDLE            NO-UNDO.
DEFINE VARIABLE l-libera-1  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-libera-2  AS LOGICAL     NO-UNDO.

def new global shared var wh-query           as widget-handle no-undo.
def new global shared var wh-buffer          as widget-handle no-undo.

{cdp/cd0666.i}

ASSIGN wh-query  = p-handle-browse:QUERY
       wh-buffer = wh-query:GET-BUFFER-HANDLE(1)
       h-marcado = wh-buffer:BUFFER-FIELD("c-marca")
       h-item    = wh-buffer:BUFFER-FIELD("item-dp")
       h-versao  = wh-buffer:BUFFER-FIELD("num-proces-item").

IF h-marcado:BUFFER-VALUE = ? THEN
    RETURN "NOK".

wh-query:GET-FIRST().

FOR EACH tt-dados:
    DELETE tt-dados.
END.

/**/
FOR EACH ttDpProcesItem-aux:
    DELETE ttDpProcesItem-aux.
END.


ASSIGN wh-tt = BUFFER ttDpProcesItem-aux:HANDLE. /**/

REPEAT:
    
    CREATE tt-dados.
    ASSIGN tt-dados.marcado   = IF h-marcado:BUFFER-VALUE = "" THEN NO ELSE YES
           tt-dados.it-codigo = h-item:BUFFER-VALUE
           tt-dados.versao    = INT(h-versao:BUFFER-VALUE).

    /**/
    wh-tt:BUFFER-CREATE.
    wh-tt:BUFFER-COPY(wh-buffer).
      /**/

                                 /*
    ASSIGN wh-tt:BUFFER-FIELD(1) = wh-buffer:BUFFER-FIELD(1)
           wh-tt:BUFFER-FIELD(2) = wh-buffer:BUFFER-FIELD(2)
           wh-tt:BUFFER-FIELD(3) = wh-buffer:BUFFER-FIELD(3)
           wh-tt:BUFFER-FIELD(4) = wh-buffer:BUFFER-FIELD(4).
           */

    
    wh-query:GET-NEXT().

    IF wh-query:QUERY-OFF-END THEN LEAVE.

END.

/*
FOR EACH ttDpProcesItem-aux /*WHERE ttDpProcesItem-aux.c-marca <> ""*/:
    MESSAGE ttDpProcesItem-aux.it-codigo
        VIEW-AS ALERT-BOX.
END. 

FOR EACH tt-dados:
    MESSAGE tt-dados.marcado SKIP
         tt-dados.it-codigo SKIP
         tt-dados.versao VIEW-AS ALERT-BOX.
END.

RETURN "NOK".
*/

FOR EACH tt-dados 
   WHERE tt-dados.marcado = YES:

   IF tt-dados.versao = 1 THEN DO:

      EMPTY TEMP-TABLE tt-prog-ponto.

      RUN esp/es0018p.p (INPUT "dp0502", /* Nome do programa */
                         INPUT 1,        /* Ponto do programa */
                         INPUT 0,
                         INPUT "",
                         OUTPUT TABLE tt-prog-ponto).  

      ASSIGN l-libera-1 = NO.

      FOR EACH tt-prog-ponto
         WHERE tt-prog-ponto.nome-programa = "dp0502"
           AND tt-prog-ponto.ponto         = 1:
         IF CAN-FIND(first usuar_grp_usuar
                     where usuar_grp_usuar.cod_grp_usuar = tt-prog-ponto.conteudo
                       and usuar_grp_usuar.cod_usuario   = c-seg-usuario) THEN
            ASSIGN l-libera-1 = YES.
      END.

      IF l-libera-1 = NO THEN DO:
         MESSAGE "Usu†rio sem permiss∆o para liberaá∆o de vers∆o 1."
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN "NOK".
      END.
   END.

   IF tt-dados.versao > 1 THEN DO:

      EMPTY TEMP-TABLE tt-prog-ponto.

      RUN esp/es0018p.p (INPUT "dp0502", /* Nome do programa */
                         INPUT 2,        /* Ponto do programa */
                         INPUT 0,
                         INPUT "",
                         OUTPUT TABLE tt-prog-ponto).  

      ASSIGN l-libera-2 = NO.

      FOR EACH tt-prog-ponto
         WHERE tt-prog-ponto.nome-programa = "dp0502"
           AND tt-prog-ponto.ponto         = 2:
         IF CAN-FIND(first usuar_grp_usuar
                     where usuar_grp_usuar.cod_grp_usuar = tt-prog-ponto.conteudo
                       and usuar_grp_usuar.cod_usuario   = c-seg-usuario) THEN
            ASSIGN l-libera-2 = YES.
      END.

      IF l-libera-2 = NO THEN DO:
         MESSAGE "Usu†rio sem permiss∆o para liberaá∆o de vers∆o maiores do que 1."
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN "NOK".
      END.
   END.
END.
     

FOR EACH tt-dados WHERE tt-dados.marcado = YES:
    RUN esp/verifica-dp-estrut.p (INPUT tt-dados.it-codigo,
                                  INPUT tt-dados.versao,
                                  OUTPUT p-ativo,
                                  OUTPUT p-itemob).
            
    IF p-ativo = NO THEN DO:
        MESSAGE "Item " p-itemob " esta Obsoleto. N∆o pode ser usado."
                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        
        RETURN "NOK".
    END.

END.

IF p-ativo = YES THEN DO:

    APPLY "CHOOSE" TO p-handle-bexecuta.

    for each tt-erro:
       delete tt-erro.
    end.

    /**/
    RUN dpp/dpapi001.p PERSISTENT SET h-dpapi001.

    run valida-pre-exportacao in h-dpapi001 (input-output table ttDpProcesItem-aux,
                                             input-output table tt-erro).
                                             

    IF NOT CAN-FIND(FIRST tt-erro) THEN DO:  /**/

        FOR EACH tt-dados WHERE tt-dados.marcado = YES:
            FOR FIRST dp-proces-item EXCLUSIVE-LOCK
                WHERE dp-proces-item.item-dp         = tt-dados.it-codigo
                AND   dp-proces-item.num-proces-item = tt-dados.versao:
    
                IF dp-proces-item.ind-aprov = 3 /* ESTRUTURA APROVADA */ THEN 
                    ASSIGN dp-proces-item.ind-aprov = 6 /* LIBERADA */.
    
            END. /* FOR FIRST dp-proces-item */
        END. /* FOR EACH tt-dados */

    /**/ END.

    DELETE PROCEDURE h-dpapi001. /**/

END.
    
