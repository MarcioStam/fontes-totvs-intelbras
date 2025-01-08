/***********************************************************************
**  Programa..: ESP\PDP\ESPDP015RP.P
**  Autor.....: Clayton Antunes
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESPDP015 2.04.00.002}

/****************************  Definitions  ****************************/
{esp/pdp/espdp015tt.i}
{include/i-rpvar.i}


/****************************  Temp-Tables  ****************************/
                                                             



/****************************  Variaveis    ****************************/
DEF VAR i-cont          AS INT                         NO-UNDO.
DEF VAR c-local         AS CHAR FORMAT "X(13)"         NO-UNDO.
DEF VAR c-cd-unid-negoc AS CHAR                        NO-UNDO.
DEF VAR i-posicao       AS INT                         NO-UNDO.
DEF VAR c-nat           AS CHAR INIT "Fis,Jur,Est,Tra" NO-UNDO.
DEF VAR i-seq           AS INT                         NO-UNDO.
DEF VAR c-cgc           LIKE emitente.cgc              NO-UNDO.
DEF VAR v_email_cob     AS CHAR FORMAT "x(80)"         NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar AS CHAR FORMAT "x(3)":U LABEL "Empresa" COLUMN-LABEL "Empresa" NO-UNDO.

DEF TEMP-TABLE tt-unid-comerc
    FIELD seq AS INTEGER
    FIELD cd-unid-comerc LIKE unid-comerc.cd-unid-comerc
    FIELD ds-unid-comerc LIKE unid-comerc.ds-unid-comerc
    INDEX ch_princ cd-unid-comerc.

DEF BUFFER b-crm-relacionamento-cliente FOR crm-relacionamento-cliente.

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

DEFINE BUFFER b-emitente FOR emitente.

/* ************************  Function Implementations ***************** */

FUNCTION fn-retira-char-espec RETURNS CHARACTER
  ( p-string AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.

    ASSIGN p-string = REPLACE(p-string, ";":U, ",":U).

    DO i-cont = 1 TO 32:
        ASSIGN p-string = REPLACE(p-string, CHR(i-cont), " ":U).
    END.
    RUN RetiraAcentos (INPUT-OUTPUT p-string).

    RETURN p-string.

END FUNCTION.

FUNCTION fnRetornaDescForm RETURNS CHARACTER
    (INPUT i-tipo AS INTEGER):

    CASE i-tipo:
        WHEN 1 THEN RETURN "Nao Cumulativo".
        WHEN 2 THEN RETURN "Cumulativo todo ou em parte".
        WHEN 3 THEN RETURN "Simples".
        WHEN 4 THEN RETURN "Nenhum".
        WHEN 5 THEN RETURN "Isento".
        OTHERWISE RETURN "".
    END CASE.

    RETURN "".
END FUNCTION.

function get_cgc returns char:
    def var i as int no-undo.
    def var c-aux as char no-undo.
    def var c-result as char no-undo.
    c-aux = c-cgc.
    do i = 1 to length(c-cgc):
        if substring(c-cgc, i, 1) >= "0" and substring(c-cgc, i, 1) <= "9" then
            c-result = c-result + substring(c-cgc, i, 1).
    end.

    return c-result.
end function.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

DEF VAR h-acomp      AS HANDLE NO-UNDO.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.


ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relat¢rio Emitente"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESPDP015"
       c-versao       = "2.04"
       c-revisao      = "002".


/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
/*     {include/i-rpcab.i}  */
    
    {include/i-rpout.i &pagesize="0"}
/*    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
  */
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar IN h-acomp (INPUT "Montando Relat¢rio...").
    RUN piMontaRelat.

    RUN pi-finalizar IN h-acomp.

    {include/i-rpclo.i}

    RETURN "OK".
END.



/* **********************  Internal Procedures  *********************** */
PROCEDURE piMontaRelat:
    
    DEF VAR c-mail AS CHAR FORMAT "X(40)".
    DEF VAR c-transporte AS CHAR FORMAT "x(20)".
    DEF VAR c-nat  AS CHAR INIT "Fis,Jur,Est,Tra".

  PUT   "   Codigo; Nome Abrev;Nome                                    ; Endereco                               ;  Bairro                        ; Cidade                    ;UF  ;CEP         ;CGC      ;           Ins.Estadual  ;      E-mail     ;      E-Mail Cobran‡a   ;                              Telefone[1] ;     Telefone[2] ;   Gr ;  Nat; Dt implant; Cd Matriz;Abreviado Matriz;Nome Matriz;Ativo;Sit.Credito;Forma Trib.Cli.;Ramo Atividade;Contrib. Icms; Data Implantacao;".
   ASSIGN i-seq = 0.
   FOR EACH unid-comerc
      BY unid-comerc.cd-unid-comerc:
       PUT STRING(unid-comerc.cd-unid-comerc, ">>9":U) +  " - ":U + fn-retira-char-espec(unid-comerc.ds-unid-comerc) FORMAT "x(30)":U ";;;;;;":U.
       CREATE tt-unid-comerc.
       
       ASSIGN tt-unid-comerc.seq = i-seq
              tt-unid-comerc.cd-unid-comerc = unid-comerc.cd-unid-comerc
              tt-unid-comerc.ds-unid-comerc = unid-comerc.ds-unid-comerc.
       ASSIGN i-seq = i-seq + 50.
   END.
   PUT "" SKIP.
   FOR EACH emitente  NO-LOCK  
       WHERE  emitente.cod-emitente >= tt-param.cod-emitente-ini
       AND    emitente.cod-emitente <= tt-param.cod-emitente-fim
       AND    emitente.cod-gr-cli   >= tt-param.cod-grc-ini
       AND    emitente.cod-gr-cli   <= tt-param.cod-grc-fim:

      FIND int-emitente
          WHERE int-emitente.cod-emitente = emitente.cod-emitente
          NO-LOCK NO-ERROR.

      find first dist-emitente no-lock
          where dist-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

      IF tt-param.ident = 1 AND emitente.identific = 2      /*** fornecedor **/ THEN
          NEXT.
      ELSE IF tt-param.ident = 2 AND emitente.identific = 1 /*** clienten ***/ THEN
              NEXT.

      RUN pi-acompanhar IN h-acomp (INPUT "Emitente:" + string(emitente.cod-emitente) + " - " + emitente.nome-abrev).

      FIND FIRST repres NO-LOCK WHERE  
            repres.cod-rep = emitente.cod-rep NO-ERROR.
      
      FIND FIRST cont-emit OF emitente NO-LOCK WHERE
                 cont-emit.e-mail <> "" NO-ERROR.
      IF NOT AVAIL cont-emit THEN
         ASSIGN c-mail = emitente.e-mail.
      ELSE
         ASSIGN c-mail = cont-emit.e-mail.

      FIND FIRST b-emitente NO-LOCK
           WHERE b-emitente.nome-abrev    = emitente.nome-matriz NO-ERROR.

      FIND FIRST emscad.cliente
          WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
          AND   emscad.cliente.cdn_cliente = emitente.cod-emitente NO-LOCK NO-ERROR.

      IF  AVAIL emscad.cliente THEN
          RUN esp/acr/esacr003b.p (INPUT emscad.cliente.num_pessoa,
                                   OUTPUT v_email_cob).


      put  emitente.cod-emitente                                            ";":U
           fn-retira-char-espec(emitente.nome-abrev)       FORMAT "x(12)":U ";":U
           fn-retira-char-espec(emitente.nome-emit)        FORMAT "x(40)":U ";":U
           fn-retira-char-espec(emitente.endereco)         FORMAT "x(40)":U ";":U
           fn-retira-char-espec(emitente.bairro)           FORMAT "x(30)":U ";":U
           fn-retira-char-espec(emitente.cidade)           FORMAT "x(25)":U ";":U
           fn-retira-char-espec(emitente.estado)           FORMAT "x(4)":U  ";":U
           fn-retira-char-espec(emitente.cep)              FORMAT "x(12)":U ";":U.
      
      ASSIGN c-cgc = emitente.cgc.
      ASSIGN c-cgc = get_cgc().

      IF emitente.natureza = 1 THEN
         PUT  dec(fn-retira-char-espec(c-cgc)) FORMAT "zzzzzz99999999999" ";":U.
      ELSE
         PUT  dec(fn-retira-char-espec(c-cgc)) FORMAT "zzzzzz99999999999999" ";":U.

      PUT  trim(fn-retira-char-espec(emitente.ins-estadual))     FORMAT "x(19)":U ";":U
           trim(fn-retira-char-espec(c-mail))                    FORMAT "x(40)":U ";":U
           trim(fn-retira-char-espec(v_email_cob))               FORMAT "x(80)":U ";":U
           trim(fn-retira-char-espec(emitente.telefone[1]))      FORMAT "x(40)":U ";":U
           trim(fn-retira-char-espec(emitente.telefone[2]))      FORMAT "x(40)":U ";":U
           trim(string(emitente.cod-gr-cli))                                      ";":U
           ENTRY(INTEGER(emitente.natureza), c-nat, ",":U) FORMAT "x(3)":U  ";":U
           emitente.data-implant                                            ";":U.

      IF AVAIL b-emitente THEN
          PUT b-emitente.cod-emit ";":U
              b-emitente.nome-abrev ";":U
              fn-retira-char-espec(b-emitente.nome-emit) FORMAT "x(40)":U ";":U.
      ELSE
         PUT "; ;".
         
      IF emitente.identific = 2 THEN DO:
          IF AVAIL dist-emitente AND dist-emitente.idi-sit-fornec = 1 then PUT "Sim" ";":U.
          else PUT "NÆo" ";":U.
      END.   

      IF AVAIL int-emitente AND 
         emitente.identific <> 2 THEN
         PUT int-emitente.id-ativo FORMAT "Sim/Nao" ";":U.

      IF emitente.ind-cre-cli = 1 THEN
          PUT "Normal ".
      ELSE
          IF emitente.ind-cre-cli = 2 THEN
              PUT "Automatico".
          ELSE
              IF emitente.ind-cre-cli = 3 THEN
                 PUT "S¢ Imp Ped".
              ELSE
                  IF emitente.ind-cre-cli = 4 THEN
                     PUT "Suspenso".
                  ELSE
                      IF emitente.ind-cre-cli = 5 THEN
                          PUT "Pg a Vista".
                      
      PUT ";".

      IF AVAIL int-emitente THEN
      PUT fnRetornaDescForm(int-emitente.ind-forma-tributo) ";".

      PUT UNFORMATTED emitente.atividade ";" 
                      (IF emitente.contrib-icms THEN "SIM" ELSE "NÇO")  ";".

      FIND FIRST emscad.cliente NO-LOCK
           WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
             AND emscad.cliente.cdn_cliente = emitente.cod-emitente NO-ERROR.

      PUT UNFORMATTED (IF AVAIL emscad.cliente THEN STRING(emscad.cliente.dat_impl_clien) ELSE "") ";".

      ASSIGN i-posicao = 628
             c-cd-unid-negoc = "".
      FOR EACH crm-relacionamento-cliente
          WHERE crm-relacionamento-cliente.cod-emitente = emitente.cod-emitente 
            AND  (crm-relacionamento-cliente.dt-vigencia-ini <= TODAY AND
               (crm-relacionamento-cliente.dt-vigencia-fim >= TODAY OR  
                crm-relacionamento-cliente.dt-vigencia-fim = ?)) NO-LOCK
          BY crm-relacionamento-cliente.cd-unid-negoc:

          FOR EACH unid-comerc
              WHERE unid-comerc.cd-unid-comerc > int(c-cd-unid-negoc)
                AND unid-comerc.cd-unid-comerc < int(crm-relacionamento-cliente.cd-unid-negoc)
              BY unid-comerc.cd-unid-comerc:
              PUT ";;;;;;".
          END.
          ASSIGN c-cd-unid-negoc = crm-relacionamento-cliente.cd-unid-negoc.

          FIND tt-unid-comerc
               WHERE tt-unid-comerc.cd-unid-comerc = int(crm-relacionamento-cliente.cd-unid-negoc)
               NO-LOCK NO-ERROR.

          IF AVAIL tt-unid-comerc THEN
             ASSIGN i-posicao = i-posicao + tt-unid-comerc.seq.


          IF crm-relacionamento-cliente.cod-rep <> ? THEN DO:

              PUT TRIM(STRING(crm-relacionamento-cliente.cod-rep)) ";":U.

              FIND FIRST repres
                  WHERE repres.cod-rep = crm-relacionamento-cliente.cod-rep NO-LOCK NO-ERROR.

              IF AVAILABLE repres THEN
                  PUT fn-retira-char-espec(repres.nome-abrev) FORMAT "x(12)":U ";":U.
              ELSE
                  PUT ";":U .
          END.
          ELSE
               PUT "; ;":U .

          FIND FIRST gerente
              WHERE gerente.cod-gerente = crm-relacionamento-cliente.cod-gerente NO-LOCK NO-ERROR.

          IF AVAILABLE gerente THEN
              PUT gerente.cod-gerente                                 ";":U
                  fn-retira-char-espec(gerente.nome) FORMAT "x(30)":U ";":U.
          ELSE
              PUT ";;":U.

          FIND FIRST crm-categoria NO-LOCK
               WHERE  crm-categoria.cd-categoria = crm-relacionamento-cliente.cd-categoria NO-ERROR.
          IF  AVAIL  crm-categoria THEN
              PUT crm-categoria.cd-categoria                                        ";":U
                  fn-retira-char-espec(crm-categoria.ds-categoria) FORMAT "x(30)":U ";":U.
          ELSE
              PUT ";;".
      END.

      PUT "" skip.
   END.

END PROCEDURE.

PROCEDURE RetiraAcentos:

    DEF INPUT-OUTPUT PARAMETER c-texto AS CHAR.
    DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-caracter AS CHARACTER   NO-UNDO.
    

    DO i-cont = 1 TO LENGTH(c-texto):
        ASSIGN c-caracter = SUBSTRING(c-texto,i-cont,1).
        CASE trim(c-caracter):
           when "a" THEN next.
           when "b" THEN next.
           when "c" THEN next.
           when "d" THEN next.
           when "e" THEN next.
           when "f" THEN next.
           when "g" THEN next.
           when "h" THEN next.
           when "i" THEN next.
           when "j" THEN next.
           when "k" THEN next.
           when "l" THEN next.
           when "m" THEN next.
           when "n" THEN next.
           when "o" THEN next.
           when "p" THEN next.
           when "q" THEN next.
           when "r" THEN next.
           when "s" THEN next.
           when "t" THEN next.
           when "u" THEN next.
           when "v" THEN next.
           when "w" THEN next.
           when "x" THEN next.
           when "y" THEN next.
           when "z" THEN next.
           when " " THEN next.
           when "0" THEN next.
           when "1" THEN next.
           when "2" THEN next.
           when "3" THEN next.
           when "4" THEN next.
           when "5" THEN next.
           when "6" THEN next.
           when "7" THEN next.
           when "8" THEN next.
           when '9' THEN next.
           when '"' THEN next.
           when "'" THEN next.
           when "!" THEN next.
           when "[" THEN next.
           when "]" THEN next.
           when "@" THEN next.
           when "#" THEN next.
           when "$" THEN next.
           when "%" THEN next.
           when "&" THEN next.
           when "*" THEN next.
           when "(" THEN next.
           when ")" THEN next.
           when "-" THEN next.
           when "_" THEN next.
           when "=" THEN next.
           when "+" THEN next.
           when "<" THEN next.
           when ">" THEN next.
           when "," THEN next.
           when "." THEN next.
           when ":" THEN next.
           when ";" THEN next.
           when "?" THEN next.
           when "/" THEN next.
           when "~\" THEN next.
           OTHERWISE ASSIGN OVERLAY(c-texto,i-cont,1) = "".
       END.
    END.



END PROCEDURE.
