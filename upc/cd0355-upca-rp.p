{include/i-prgvrs.i CD0355-UPCARP 1.00.00.000}
/* defini‡Æo das temp-tables para recebimento de parƒmetros */
{upc/cd0355-upca-tt.i}

/* recebimento de parƒmetros */
def input parameter raw-param as raw no-undo.
def input parameter TABLE for tt-raw-digita.

create tt-param.
RAW-TRANSFER raw-param to tt-param NO-ERROR.

/* include padrÆo para vari veis para o log  */
{include/i-rpvar.i}
{include/i-freeac.i}

/* defini‡Æo de vari veis e streams */
def var h-acomp     as handle  no-undo.
def var c-linha     as char    no-undo.
DEFINE VARIABLE i-cont          AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-idi-tip-docto AS INTEGER     NO-UNDO.

DEF VAR c-arq-entrada-unix    AS CHAR NO-UNDO.
DEF VAR c-arq-entrada-windows AS CHAR NO-UNDO.
{esp/es0018.i}

define temp-table tt-erro
    field i-linha    as int
    field i-emitente as int 
    field c-erro     as char format "x(40)"
    field l-erro     as log.
                                               
form
    tt-erro.i-emitente            at 15 column-label "Fornecedor"
    tt-erro.c-erro                      column-label "Motivo"
    with frame f-erro-fornec no-box down no-attr-space width 132 stream-io. 

form 
    tt-erro.i-emitente            at 15 column-label "Fornecedor"
    with frame f-importado no-box down no-attr-space width 132 stream-io.

FIND FIRST tt-param EXCLUSIVE-LOCK NO-ERROR.

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U,
                   INPUT  1,
                   INPUT  0,
                   INPUT  "":U,
                   OUTPUT TABLE tt-prog-ponto).

FOR FIRST tt-prog-ponto:
    ASSIGN c-arq-entrada-unix = tt-prog-ponto.conteudo. 
END.

RUN esp/es0018p.p (INPUT  "SPOOL-WIN":U,
                   INPUT  1,
                   INPUT  0,
                   INPUT  "":U,
                   OUTPUT TABLE tt-prog-ponto).
FOR FIRST tt-prog-ponto:
    ASSIGN c-arq-entrada-windows = tt-prog-ponto.conteudo.
END.

IF OPSYS = "unix" THEN
    IF INDEX(tt-param.arq-entrada,c-arq-entrada-windows) <> 0 THEN
        ASSIGN tt-param.arq-entrada = REPLACE(tt-param.arq-entrada,c-arq-entrada-windows,c-arq-entrada-unix)
               tt-param.arq-entrada = REPLACE(tt-param.arq-entrada,"\","/").

/* defini‡Æo de frames do log */

/* include padrÆo para output de log */
{include/i-rpout.i}

/* include com a defini‡Æo da frame de cabe‡alho e rodap‚ */
{include/i-rpcab.i} 

find first param-global no-lock no-error. 

/* bloco principal do programa */
assign	c-programa 	= "CD0355-UPCARP"
        c-versao	= "1.00"
        c-revisao	= ".00.000"
        c-empresa	= param-global.grupo
        c-titulo-relat = "Importa‡Æo Relacionamento Enquadramento".

view frame f-cabec.
view frame f-rodape.
run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Importando *}

run pi-inicializar in h-acomp (input RETURN-VALUE).

/* define o arquivo de entrada informando na p gina de parƒmetros */
    DO ON ERROR UNDO, RETURN ERROR
       ON STOP  UNDO, RETURN ERROR:

        INPUT FROM VALUE(tt-param.arq-entrada) CONVERT SOURCE "iso8859-1".

        ASSIGN i-cont = 0.

        REPEAT:

           IMPORT UNFORMATTED c-linha.
           ASSIGN i-cont = i-cont + 1.

           RUN pi-acompanhar in h-acomp (input "Codigo "  + string(ENTRY(2, c-linha, ";") ) ).

               FIND sit-tribut
                   WHERE sit-tribut.cdn-tribut                  = 12                                                               
                     AND sit-tribut.cdn-sit-tribut              = int(string(ENTRY(1, c-linha, ";") ))
                   NO-LOCK NO-ERROR.
               IF NOT AVAIL sit-tribut THEN DO:
                   PUT i-cont " Codigo de Tributo informado nÆo existe "   string(ENTRY(1, c-linha, ";") ) SKIP.
                  NEXT.

               END.
               IF string(ENTRY(2, c-linha, ";") ) <> "E" AND
                  string(ENTRY(2, c-linha, ";") ) <> "S" THEN DO:
                   PUT i-cont " Segunda coluna devera ter a informacao E ou S para Entrada ou Saida , e foi informado "   string(ENTRY(2, c-linha, ";") ) SKIP.
                  NEXT.
               END.
               IF string(ENTRY(4, c-linha, ";") )  <> "*" THEN DO:
                   FIND estabelec
                       WHERE estabelec.cod-estabel  = string(ENTRY(4, c-linha, ";") )  
                       NO-LOCK NO-ERROR.
                   IF NOT AVAIL estabelec THEN DO:
                       PUT i-cont " Estabelecimento NÆo Cadastrado "   string(ENTRY(4, c-linha, ";") ) SKIP.
                       NEXT.
                   END.
               END.
               IF string(ENTRY(5, c-linha, ";") )  <> "*" THEN DO:
                   FIND natur-oper
                       WHERE natur-oper.nat-operacao = string(ENTRY(5, c-linha, ";") )  
                       NO-LOCK NO-ERROR.
                   IF NOT AVAIL natur-oper THEN DO:
                       PUT i-cont " Natureza de Opera‡Æo NÆo Cadastrada "   string(ENTRY(5, c-linha, ";") ) SKIP.
                       NEXT.
                   END.
               END.

               IF string(ENTRY(6, c-linha, ";") )  <> "*" THEN DO:
                   FIND classif-fisc
                       WHERE classif-fisc.class-fiscal = string(ENTRY(6, c-linha, ";") )  
                       NO-LOCK NO-ERROR.
                   IF NOT AVAIL classif-fisc THEN DO:
                       PUT i-cont " Classifica‡Æo Fiscal NÆo Cadastrada "   string(ENTRY(6, c-linha, ";") ) SKIP.
                       NEXT.
                   END.
               END.


               IF string(ENTRY(7, c-linha, ";") )  <> "*" THEN DO:
                   FIND ITEM NO-LOCK 
                       WHERE ITEM.it-codigo =  string(ENTRY(7, c-linha, ";") ) NO-ERROR.
                   IF NOT AVAIL ITEM THEN DO:
                        PUT i-cont " Item NÆo Encontrado "   string(ENTRY(7, c-linha, ";") ) SKIP.

                       NEXT.
                   END.
               END.

               IF int(string(ENTRY(8, c-linha, ";") ))  <> 0 THEN DO:
                   FIND gr-cli NO-LOCK 
                       WHERE gr-cli.cod-gr-cli =  int(string(ENTRY(8, c-linha, ";") )) NO-ERROR.
                   IF NOT AVAIL gr-cli THEN DO:
                        PUT i-cont " Grupo de Cliente NÆo Encontrado "   string(ENTRY(8, c-linha, ";") ) SKIP.

                       NEXT.
                   END.
               END.

               IF int(string(ENTRY(9, c-linha, ";") ))  <> 0 THEN DO:
                   FIND emitente NO-LOCK 
                       WHERE emitente.cod-emitente =  int(string(ENTRY(9, c-linha, ";") )) NO-ERROR.
                   IF NOT AVAIL emitente THEN DO:
                        PUT i-cont "  Cliente NÆo Encontrado "   string(ENTRY(9, c-linha, ";") ) SKIP.

                       NEXT.
                   END.
               END.
               ASSIGN i-idi-tip-docto = IF  string(ENTRY(2, c-linha, ";") ) = "E" THEN 1 ELSE 2   .
               FIND sit-tribut-relacto
                   WHERE sit-tribut-relacto.cdn-tribut                  = 12                                                               
                     AND sit-tribut-relacto.cdn-sit-tribut              = int(string(ENTRY(1, c-linha, ";") ))
                     AND sit-tribut-relacto.idi-tip-docto               = i-idi-tip-docto
                     AND sit-tribut-relacto.dat-valid-inic              = date(string(ENTRY(3, c-linha, ";") ))                            
                     AND sit-tribut-relacto.cod-estab                   = string(ENTRY(4, c-linha, ";") )                                  
                     AND sit-tribut-relacto.cod-natur-operac            = string(ENTRY(5, c-linha, ";") )                                  
                     AND sit-tribut-relacto.cod-ncm                     = string(ENTRY(6, c-linha, ";") )                                  
                     AND sit-tribut-relacto.cod-item                    = string(ENTRY(7, c-linha, ";") )                                  
                     AND sit-tribut-relacto.cdn-grp-emit                = int(string(ENTRY(8, c-linha, ";") ))                             
                     AND sit-tribut-relacto.cdn-emitente                = int(string(ENTRY(9, c-linha, ";") ))                            NO-LOCK NO-ERROR.
               IF AVAIL sit-tribut-relacto THEN DO:
               
                   PUT i-cont " Registro ja Existe na base, registro desconsiderado" 
                      string(ENTRY(1, c-linha, ";") ) ";"
                      string(ENTRY(2, c-linha, ";") )                              ";"
                      date(string(ENTRY(3, c-linha, ";") ))                        ";"
                      string(ENTRY(4, c-linha, ";") )                              ";"
                      string(ENTRY(5, c-linha, ";") )                              ";"
                      string(ENTRY(6, c-linha, ";") )                              ";"
                      string(ENTRY(7, c-linha, ";") )                              ";"
                      int(string(ENTRY(8, c-linha, ";") ))                         ";" 
                      int(string(ENTRY(9, c-linha, ";") ))                         ";" SKIP.
                   NEXT.
                END.



               CREATE sit-tribut-relacto.
               ASSIGN sit-tribut-relacto.cdn-tribut                  = 12
                      sit-tribut-relacto.cdn-sit-tribut              = int(string(ENTRY(1, c-linha, ";") ))
                      sit-tribut-relacto.idi-tip-docto               = i-idi-tip-docto
                      sit-tribut-relacto.dat-valid-inic              = date(string(ENTRY(3, c-linha, ";") ))
                      sit-tribut-relacto.cod-estab                   = string(ENTRY(4, c-linha, ";") )      
                      sit-tribut-relacto.cod-natur-operac            = string(ENTRY(5, c-linha, ";") )      
                      sit-tribut-relacto.cod-ncm                     = string(ENTRY(6, c-linha, ";") )      
                      sit-tribut-relacto.cod-item                    = string(ENTRY(7, c-linha, ";") )      
                      sit-tribut-relacto.cdn-grp-emit                = int(string(ENTRY(8, c-linha, ";") ))      
                      sit-tribut-relacto.cdn-emitente                = int(string(ENTRY(9, c-linha, ";") )).      

        END.
        /*INPUT CLOSE.*/
        
    END.
    run pi-finalizar in h-acomp.
    /*OUTPUT CLOSE.*/


/* fechamento do output do log */
return "Ok":U.


