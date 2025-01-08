

/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCDP115RP 2.00.00.002}  /*** 010020 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ESCDP115rp MCD}
&ENDIF

{include/i-rpvar.i}

/** Defini‡Æo e Prepara‡Æo dos Parƒmetros **/
define temp-table tt-param
    field destino          as integer
    field arq-destino      as char
    field arq-entrada      as char
    field todos            as integer
    field usuario          as char
    field data-exec        as date
    field hora-exec        as INTEGER
    FIELD rs-operacao      AS INT 
    FIELD segmento-ini     AS INT 
    FIELD segmento-fim     AS INT 
    FIELD item-ini         AS CHAR
    FIELD item-fim         AS CHAR
    FIELD grupo-ini        AS INT
    FIELD grupo-fim        AS INT
    FIELD dt-inativacao    AS DATE 
    FIELD dt-vigencia      AS DATE
/*     FIELD raw-digita       AS RAW */
    .


define temp-table tt-digita no-undo
    field it-codigo         LIKE ITEM.it-codigo
    field descricao         LIKE ITEM.desc-item
    index id it-codigo.


/* Transfer Definitions */

def temp-table tt-raw-digita
   field raw-digita      as raw.


def temp-table tt-cot-est-mast no-undo like cot-est-mast.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

FIND FIRST tt-param NO-ERROR.

/* CREATE tt-digita.                                  */
/* raw-transfer tt-param.raw-digita TO tt-raw-digita. */

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
    FIND CURRENT tt-digita NO-ERROR.
    RELEASE tt-digita.
end. /* for each tt-raw-digita */

def new shared var h-acomp as handle no-undo.

def var l-erro          as logical.
def var c-reg           as char format "x(43)" no-undo.
def var i-linha         as int  format ">>>>9" init 0 no-undo.
def var i-bons          as inte format ">>>>9" init 0 no-undo.
def var i-erros         as inte format ">>>>9" init 0 no-undo.
def var c-msg           as char format "x(80)" .

DEF VAR c-cave          AS CHAR NO-UNDO.
DEF VAR c-grupo         AS CHAR NO-UNDO.
DEF VAR c-segmento      AS CHAR NO-UNDO.
DEF VAR c-item          AS CHAR NO-UNDO.
DEF VAR c-chave         AS CHAR NO-UNDO.
DEF VAR l-error         AS LOG  NO-UNDO.

def stream s-imp.
{include/i-rpout.i &tofile = tt-param.arq-destino}   

/* Temp-table com as mensagens de erros */
DEF TEMP-TABLE tt-int-segmento-item NO-UNDO
    FIELD it-codigo            AS CHAR
    FIELD grupo                AS CHAR 
    FIELD segmento             AS CHAR 
    FIELD Dt_Inicio            AS CHAR 
    FIELD Dt_Fim               AS CHAR
    .

def temp-table tt-erros no-undo
    field chave       as CHAR FORMAT "X(030)" 
    field linha       as integer format ">>>,>>9"
    field msg-erros   as char    format "x(70)"
    index codigo chave linha. 

form tt-erros.linha         
     tt-erros.chave
     tt-erros.msg-erros     
     with centered width 132 64 down no-box attr-space stream-io frame f-erros.


run utp/ut-trfrrp.p (input frame f-erros:handle).    

{utp/ut-liter.i Linha * R }
assign tt-erros.linha :label in frame f-erros = return-value.
{utp/ut-liter.i Chave * R }
assign  tt-erros.chave:label in frame f-erros = return-value. 
{utp/ut-liter.i Erro_Ocorrido * R }
assign tt-erros.msg-erros:label in frame f-erros = return-value. 

form c-msg skip
     with centered width 132 64 down no-box attr-space stream-io frame f-aceitos.

run utp/ut-trfrrp.p (input frame f-aceitos:handle).    

{utp/ut-liter.i Observa‡Æo * R }
assign c-msg:label in frame f-aceitos = return-value.  

form i-linha colon 25
     i-bons  colon 25 
     i-erros colon 25
     with centered width 132 side-labels no-box attr-space stream-io frame f-lin.     

run utp/ut-trfrrp.p (input frame f-lin:handle).    

{utp/ut-liter.i Registros_lidos * L }
assign i-linha:label in frame f-lin = trim(return-value).  
{utp/ut-liter.i Registros_com_erros * L }
assign i-erros:label in frame f-lin = trim(return-value). 
{utp/ut-liter.i Registros_sem_erros * L }
assign i-bons:label in frame f-lin = trim(return-value). 

/********************** Fim das Defini‡äes *******************************/ 

/***  Inicio do Programa  ***/

run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Importando *}
run pi-inicializar in h-acomp (input  Return-value ).

find first param-global no-lock no-error.
find first tt-param no-error.   

assign c-programa     = "ESCDP115C":U
       c-versao       = "1.00":U
       c-revisao      = "000":U.

{utp/ut-liter.i DISTRIBUI€ÇO * L}        
assign c-sistema      = return-value.

CASE tt-param.rs-operacao:
    WHEN 1 THEN DO:
        {utp/ut-liter.i Importa‡Æo_de_Segmentos_por_Item * L}        

    END.
    WHEN 2 THEN DO:
           {utp/ut-liter.i Exporta‡Æo_de_Segmentos_por_Item * L}
    END.
    WHEN 3 THEN DO:
        {utp/ut-liter.i ExclusÆo_de_Segmentos_por_Item * L}

    END.
    WHEN 4 THEN DO:

        {utp/ut-liter.i Inativa‡Æo_de_Segmentos_por_Item * L}

    END.
END CASE.

assign c-titulo-relat = return-value.

{include/i-rpcab.i}

IF tt-param.rs-operacao = 1 THEN DO:

    if search(tt-param.arq-entrada) = ? then do:
       run utp/ut-msgs.p (input "show":U,
                          input 326,
                          input tt-param.arq-entrada).  
    end.

END.

view frame f-cabec.
view frame f-rodape.

CASE tt-param.rs-operacao:
    WHEN 1 THEN RUN pi-importacao.
    WHEN 2 THEN RUN pi-exportar.
  //  WHEN 3 THEN RUN pi-excluir.
    WHEN 4 THEN RUN pi-inativar.
END CASE.

view frame f-cabec.
view frame f-rodape.      

IF tt-param.rs-operacao = 1 THEN DO:
    for each tt-erros
       by tt-erros.linha:
       disp tt-erros.linha
            tt-erros.chave FORMAT "X(30)"
            tt-erros.msg-erros  
            with frame f-erros.
       down with frame f-erros.
    end.      
    
    for each tt-erros:
       delete tt-erros.
    end.   
    
    assign i-erros = i-linha - i-bons.
    disp skip(1).
    disp i-linha
         i-bons 
         i-erros
         with frame f-lin.
END.
run pi-finalizar in h-acomp.            

{include/i-rpclo.i}

PROCEDURE pi-exportar:

DEF VAR i-exp   AS INT NO-UNDO.

ASSIGN i-exp = 0.

OUTPUT stream s-imp TO VALUE(tt-param.arq-entrada) CONVERT TARGET "iso8859-1".

EXPORT stream s-imp DELIMITER ";"
       "Item"
       "Descri‡Æo"
       "Grupo Cliente"
       "Descri‡Æo"
       "Segmenta‡Æo"
       "Descri‡Æo"
       "Dt Inicio"
       "Dt Fim".

    FOR EACH int-segmento-item NO-LOCK 
        WHERE int-segmento-item.it-codigo      >= tt-param.item-ini
          AND int-segmento-item.it-codigo      <= tt-param.item-fim
          AND int-segmento-item.cod-gr-cli     >= tt-param.grupo-ini
          AND int-segmento-item.cod-gr-cli     <= tt-param.grupo-fim
          AND int-segmento-item.cod-segmento   >= tt-param.segmento-ini
          AND int-segmento-item.cod-segmento   <= tt-param.segmento-fim
          AND int-segmento-item.dt-valid-ini   <= tt-param.dt-vigencia 
          AND int-segmento-item.dt-valid-fim   >= tt-param.dt-vigencia:

        run pi-acompanhar in h-acomp ("Item : " + STRING(int-segmento-item.it-codigo)). 

        ASSIGN i-exp = i-exp + 1.

        ASSIGN c-grupo    = ""
               c-segmento = ""
               c-item     = "".

        FOR FIRST ITEM FIELDS(it-codigo desc-item) NO-LOCK 
            WHERE ITEM.it-codigo = int-segmento-item.it-codigo:
        END.
        IF AVAIL ITEM THEN
           ASSIGN c-item = ITEM.desc-item.

        FOR FIRST gr-cli FIELDS(cod-gr-cli descricao) NO-LOCK 
            WHERE gr-cli.cod-gr-cli = int-segmento-item.cod-gr-cli:
        END.
        IF AVAIL gr-cli THEN
           ASSIGN c-grupo = gr-cli.descricao.

        FIND FIRST int-segmento-portifolio NO-LOCK 
             WHERE int-segmento-portifolio.cod-segmento = int-segmento-item.cod-segmento NO-ERROR.
        IF AVAIL int-segmento-portifolio THEN
           ASSIGN c-segmento = int-segmento-portifolio.descricao.

        EXPORT stream s-imp DELIMITER ";"
               int-segmento-item.it-codigo
               c-item
               int-segmento-item.cod-gr-cli
               c-grupo
               int-segmento-item.cod-segmento
               c-segmento
               int-segmento-item.dt-valid-ini FORMAT "99/99/9999" 
               int-segmento-item.dt-valid-fim FORMAT "99/99/9999" 
            .

    END.
    PUT SKIP(3)
        "Total de Registros exportados: " + STRING(i-exp) FORMAT "X(100)" SKIP.

    DOS SILENT START excel.exe VALUE(tt-param.arq-entrada).

END PROCEDURE.

PROCEDURE pi-excluir:

    DEF BUFFER b-int-segmento-item FOR int-segmento-item.

    DEF VAR i-excluidos   AS INT NO-UNDO.

    ASSIGN i-excluidos = 0.

    OUTPUT stream s-imp TO VALUE(tt-param.arq-entrada) CONVERT TARGET "iso8859-1".

    EXPORT stream s-imp DELIMITER ";"
           "Item"
           "Descri‡Æo"
           "Grupo Cliente"
           "Descri‡Æo"
           "Segmenta‡Æo"
           "Descri‡Æo"
           "Dt Inicio"
           "Dt Fim".

        FOR EACH int-segmento-item NO-LOCK 
            WHERE int-segmento-item.it-codigo      >= tt-param.item-ini
              AND int-segmento-item.it-codigo      <= tt-param.item-fim
              AND int-segmento-item.cod-gr-cli     >= tt-param.grupo-ini
              AND int-segmento-item.cod-gr-cli     <= tt-param.grupo-fim
              AND int-segmento-item.cod-segmento   >= tt-param.segmento-ini
              AND int-segmento-item.cod-segmento   <= tt-param.segmento-fim:

            run pi-acompanhar in h-acomp ("Item : " + STRING(int-segmento-item.it-codigo)). 


            ASSIGN i-excluidos = i-excluidos + 1.

            ASSIGN c-grupo    = ""
                   c-segmento = ""
                   c-item     = "".

            FOR FIRST ITEM FIELDS(it-codigo desc-item) NO-LOCK 
                WHERE ITEM.it-codigo = int-segmento-item.it-codigo:
            END.
            IF AVAIL ITEM THEN
               ASSIGN c-item = ITEM.desc-item.

            FOR FIRST gr-cli FIELDS(cod-gr-cli descricao) NO-LOCK 
                WHERE gr-cli.cod-gr-cli = int-segmento-item.cod-gr-cli:
            END.
            IF AVAIL gr-cli THEN
               ASSIGN c-grupo = gr-cli.descricao.

            FIND FIRST int-segmento-portifolio NO-LOCK 
                 WHERE int-segmento-portifolio.cod-segmento = int-segmento-item.cod-segmento NO-ERROR.
            IF AVAIL int-segmento-portifolio THEN
               ASSIGN c-segmento = int-segmento-portifolio.descricao.

            EXPORT stream s-imp DELIMITER ";"
                   int-segmento-item.it-codigo
                   c-item
                   int-segmento-item.cod-gr-cli
                   c-grupo
                   int-segmento-item.cod-segmento
                   c-segmento
                   int-segmento-item.dt-valid-ini FORMAT "99/99/9999" 
                   int-segmento-item.dt-valid-fim FORMAT "99/99/9999" 
                .

            FIND b-int-segmento-item EXCLUSIVE-LOCK 
                WHERE ROWID(b-int-segmento-item) = ROWID(int-segmento-item) NO-ERROR.
            IF AVAIL b-int-segmento-item THEN
               DELETE b-int-segmento-item.
        END.
        PUT SKIP(3)
            "Total de Registros excluidos: " + STRING(i-excluidos) FORMAT "X(100)" SKIP.

        DOS SILENT START excel.exe VALUE(tt-param.arq-entrada).

END PROCEDURE.

PROCEDURE pi-inativar:

    DEF BUFFER b-int-segmento-item FOR int-segmento-item.

    DEF VAR i-inativados   AS INT NO-UNDO.

    ASSIGN i-inativados = 0.

    OUTPUT stream s-imp TO VALUE(tt-param.arq-entrada) CONVERT TARGET "iso8859-1".

    EXPORT stream s-imp DELIMITER ";"
           "Item"
           "Descri‡Æo"
           "Grupo Cliente"
           "Descri‡Æo"
           "Segmenta‡Æo"
           "Descri‡Æo"
           "Dt Inicio"
           "Dt Fim".

    IF NOT CAN-FIND(FIRST tt-digita) THEN DO:


        FOR EACH int-segmento-item NO-LOCK 
            WHERE int-segmento-item.it-codigo      >= tt-param.item-ini
              AND int-segmento-item.it-codigo      <= tt-param.item-fim
              AND int-segmento-item.cod-gr-cli     >= tt-param.grupo-ini
              AND int-segmento-item.cod-gr-cli     <= tt-param.grupo-fim
              AND int-segmento-item.cod-segmento   >= tt-param.segmento-ini
              AND int-segmento-item.cod-segmento   <= tt-param.segmento-fim
              AND int-segmento-item.dt-valid-ini   >= tt-param.dt-vigencia:

            run pi-acompanhar in h-acomp ("Item : " + STRING(int-segmento-item.it-codigo)). 

            ASSIGN i-inativados = i-inativados + 1.

            ASSIGN c-grupo    = ""
                   c-segmento = ""
                   c-item     = "".

            FOR FIRST ITEM FIELDS(it-codigo desc-item) NO-LOCK 
                WHERE ITEM.it-codigo = int-segmento-item.it-codigo:
            END.
            IF AVAIL ITEM THEN
               ASSIGN c-item = ITEM.desc-item.

            FOR FIRST gr-cli FIELDS(cod-gr-cli descricao) NO-LOCK 
                WHERE gr-cli.cod-gr-cli = int-segmento-item.cod-gr-cli:
            END.
            IF AVAIL gr-cli THEN
               ASSIGN c-grupo = gr-cli.descricao.

            FIND FIRST int-segmento-portifolio NO-LOCK 
                 WHERE int-segmento-portifolio.cod-segmento = int-segmento-item.cod-segmento NO-ERROR.
            IF AVAIL int-segmento-portifolio THEN
               ASSIGN c-segmento = int-segmento-portifolio.descricao.

            EXPORT stream s-imp DELIMITER ";"
                   int-segmento-item.it-codigo
                   c-item
                   int-segmento-item.cod-gr-cli
                   c-grupo
                   int-segmento-item.cod-segmento
                   c-segmento
                   int-segmento-item.dt-valid-ini FORMAT "99/99/9999" 
                   int-segmento-item.dt-valid-fim FORMAT "99/99/9999" 
                .

            FIND b-int-segmento-item EXCLUSIVE-LOCK 
                WHERE ROWID(b-int-segmento-item) = ROWID(int-segmento-item) NO-ERROR.
            IF AVAIL b-int-segmento-item THEN
               ASSIGN b-int-segmento-item.dt-valid-fim = tt-param.dt-inativacao.
        END.
    END.
    ELSE DO:
         FOR EACH tt-digita 
             WHERE tt-digita.it-codigo <> "":

             FOR EACH int-segmento-item NO-LOCK 
                 WHERE int-segmento-item.it-codigo      = tt-digita.it-codigo
                   AND int-segmento-item.cod-gr-cli     >= tt-param.grupo-ini
                   AND int-segmento-item.cod-gr-cli     <= tt-param.grupo-fim
                   AND int-segmento-item.cod-segmento   >= tt-param.segmento-ini
                   AND int-segmento-item.cod-segmento   <= tt-param.segmento-fim
                   AND int-segmento-item.dt-valid-ini   >= tt-param.dt-vigencia:

                 run pi-acompanhar in h-acomp ("Item : " + STRING(int-segmento-item.it-codigo)). 

                 ASSIGN i-inativados = i-inativados + 1.

                 ASSIGN c-grupo    = ""
                        c-segmento = ""
                        c-item     = "".

                 FOR FIRST ITEM FIELDS(it-codigo desc-item) NO-LOCK 
                     WHERE ITEM.it-codigo = int-segmento-item.it-codigo:
                 END.
                 IF AVAIL ITEM THEN
                    ASSIGN c-item = ITEM.desc-item.

                 FOR FIRST gr-cli FIELDS(cod-gr-cli descricao) NO-LOCK 
                     WHERE gr-cli.cod-gr-cli = int-segmento-item.cod-gr-cli:
                 END.
                 IF AVAIL gr-cli THEN
                    ASSIGN c-grupo = gr-cli.descricao.

                 FIND FIRST int-segmento-portifolio NO-LOCK 
                      WHERE int-segmento-portifolio.cod-segmento = int-segmento-item.cod-segmento NO-ERROR.
                 IF AVAIL int-segmento-portifolio THEN
                    ASSIGN c-segmento = int-segmento-portifolio.descricao.

                 EXPORT stream s-imp DELIMITER ";"
                        int-segmento-item.it-codigo
                        c-item
                        int-segmento-item.cod-gr-cli
                        c-grupo
                        int-segmento-item.cod-segmento
                        c-segmento
                        int-segmento-item.dt-valid-ini FORMAT "99/99/9999" 
                        int-segmento-item.dt-valid-fim FORMAT "99/99/9999" 
                     .

                 FIND b-int-segmento-item EXCLUSIVE-LOCK 
                     WHERE ROWID(b-int-segmento-item) = ROWID(int-segmento-item) NO-ERROR.
                 IF AVAIL b-int-segmento-item THEN
                    ASSIGN b-int-segmento-item.dt-valid-fim = tt-param.dt-inativacao.
             END.

         END.

    END.
        PUT SKIP(3)
            "Total de Registros inativados: " + STRING(i-inativados) FORMAT "X(100)" SKIP.

        DOS SILENT START excel.exe VALUE(tt-param.arq-entrada).

END PROCEDURE.

PROCEDURE pi-importacao:
DEF VAR c-data     AS DATE NO-UNDO.

EMPTY TEMP-TABLE tt-int-segmento-item.

input stream s-imp from value(tt-param.arq-entrada).
assign i-linha = 0.
repeat on error undo, leave
       on stop  undo, leave transaction:

  assign l-erro  = no.

  CREATE tt-int-segmento-item.
  IMPORT stream s-imp DELIMITER ";" tt-int-segmento-item.
  IF tt-int-segmento-item.it-codigo  = "" AND 
     tt-int-segmento-item.grupo = "" AND 
     tt-int-segmento-item.segmento = "" AND 
     (tt-int-segmento-item.dt_inicio  = "" OR
      tt-int-segmento-item.dt_inicio  = ?  OR
      tt-int-segmento-item.dt_inicio  = "?") THEN DO:

      DELETE tt-int-segmento-item.
      LEAVE.
  END.

  assign i-linha = i-linha + 1.

  IF tt-int-segmento-item.it-codigo = "Item" THEN DO:
     DELETE tt-int-segmento-item.
     assign i-linha = i-linha - 1.
     NEXT.
  END.

  run pi-acompanhar in h-acomp (STRING(tt-int-segmento-item.it-codigo)). 

  ASSIGN c-data = DATE(tt-int-segmento-item.dt_inicio).
  ASSIGN c-chave = STRING(tt-int-segmento-item.it-codigo) + "/" + STRING(tt-int-segmento-item.grupo) + "/" + STRING(tt-int-segmento-item.segmento) +  "/" +  STRING(c-data).
  /*
  find int-segmento-item 
       where int-segmento-item.it-codigo    = tt-int-segmento-item.it-codigo
         AND int-segmento-item.cod-gr-cli   = INT(tt-int-segmento-item.grupo)
         AND int-segmento-item.cod-segmento = INT(tt-int-segmento-item.segmento)
         AND int-segmento-item.dt-valid-ini = c-data no-lock no-error.


  if  avail int-segmento-item  then do:     
      {utp/ut-table.i mgesp int-segmento-item  1}
      run utp/ut-msgs.p (input "msg":U,
                         input 24,
                         input return-value).
      assign c-msg = return-value.   
      RUN pi-cria-erro.
      assign l-erro = yes.   
  end.
  */
  ASSIGN l-error = NO.
  FOR EACH int-segmento-item
      WHERE int-segmento-item.it-codigo    = tt-int-segmento-item.it-codigo
        AND int-segmento-item.cod-gr-cli   = INT(tt-int-segmento-item.grupo)
        AND int-segmento-item.cod-segmento = INT(tt-int-segmento-item.segmento):


     IF int-segmento-item.dt-valid-fim = ? AND 
        int-segmento-item.dt-valid-ini <= TODAY THEN
        ASSIGN l-error = YES.

     ELSE DO:

          IF ( int-segmento-item.dt-valid-fim = ?
              OR int-segmento-item.dt-valid-fim >= c-data) THEN DO:
              ASSIGN l-error = YES.

          END.

          IF int-segmento-item.dt-valid-ini >= c-data  THEN 
             ASSIGN l-error = YES.

          IF int-segmento-item.dt-valid-fim >= c-data  THEN 
             ASSIGN l-error = YES.
     END.

  END.

  if  l-error then do:     
      {utp/ut-table.i mgesp int-segmento-item  1}
      run utp/ut-msgs.p (input "msg":U,
                         input 24,
                         input return-value).
      assign c-msg = return-value.   
      RUN pi-cria-erro.
      assign l-erro = yes.   
  end.
  IF NOT CAN-FIND(FIRST ITEM 
                  WHERE ITEM.it-codigo = tt-int-segmento-item.it-codigo) THEN DO:

      assign c-msg = "Item Invalido!".
      RUN pi-cria-erro.
      assign l-erro = yes.   

  END.
  IF NOT CAN-FIND(FIRST gr-cli
                  WHERE gr-cli.cod-gr-cli = INT(tt-int-segmento-item.grupo)) THEN DO:
    

      assign c-msg = "Grupo de cliente Invalido!".
      RUN pi-cria-erro.
      assign l-erro = yes.   
  END.
    
  IF NOT CAN-FIND(FIRST int-segmento-portifolio
                  WHERE int-segmento-portifolio.cod-segmento = INT(tt-int-segmento-item.segmento)) THEN DO:
    
      assign c-msg = "Segmento portifolio Invalido!".
      RUN pi-cria-erro.
      assign l-erro = yes.   
  END.
    
  IF tt-int-segmento-item.dt_inicio = ? THEN DO:
    
      assign c-msg = "Data inicio deve ser informada!".
      RUN pi-cria-erro.
      assign l-erro = yes.   
  END.
    
  IF DATE(tt-int-segmento-item.dt_fim) < DATE(tt-int-segmento-item.dt_inicio) THEN DO:
    
      assign c-msg = "Data Final ‚ menor que data inicial.".
      RUN pi-cria-erro.
      assign l-erro = yes.   
  END.
  IF NOT l-erro THEN DO:
     CREATE int-segmento-item.
     ASSIGN int-segmento-item.it-codigo       = TRIM(tt-int-segmento-item.it-codigo)
            int-segmento-item.cod-gr-cli      = INT(tt-int-segmento-item.grupo)
            int-segmento-item.cod-segmento    = INT(tt-int-segmento-item.segmento)
            int-segmento-item.dt-valid-ini    = DATE(tt-int-segmento-item.Dt_Inicio)
            int-segmento-item.dt-valid-fim    = DATE(tt-int-segmento-item.Dt_Fim).

        ASSIGN i-bons = i-bons + 1.               
        IF tt-param.todos = 1 THEN DO:
           {utp/ut-liter.i OK * L}. 
           ASSIGN c-msg = trim(return-value). 
           RUN pi-cria-erro.
        end.    

  END.
END. 
input stream s-imp close.

END PROCEDURE.

PROCEDURE pi-cria-erro:

  create tt-erros.
  assign tt-erros.chave        = c-chave
         tt-erros.linha        = i-linha
         tt-erros.msg-erros    = c-msg.
   
/*Fim da Include*/        

END PROCEDURE.

