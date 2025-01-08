
DEF INPUT PARAM  pModProdcomMAC AS CHAR NO-UNDO.
DEF OUTPUT PARAM pSenhaWIFI     AS CHAR NO-UNDO.
DEF OUTPUT PARAM pSenhaADM      AS CHAR NO-UNDO.

/* Variaveis */
DEFINE VARIABLE lcSha1         AS LONGCHAR  NO-UNDO.
DEFINE VARIABLE cSha1          AS CHAR      NO-UNDO.
DEFINE VARIABLE cBase64        AS CHARACTER NO-UNDO.
DEFINE VARIABLE mptValorBase64 AS MEMPTR    NO-UNDO.

DEFINE VARIABLE iNumIniSenhas AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont         AS INTEGER     NO-UNDO.

DEFINE VARIABLE senhacalculada AS RAW NO-UNDO.

DEFINE VARIABLE cSenhaADM       AS CHAR NO-UNDO.
DEFINE VARIABLE cSenhaWIFI      AS CHAR NO-UNDO.
DEFINE VARIABLE cType           AS CHAR NO-UNDO.
DEFINE VARIABLE cTipoRepetido   AS CHAR NO-UNDO.
DEFINE VARIABLE cPrimeiroTipo   AS CHAR NO-UNDO.
DEFINE VARIABLE cSimbolo        AS CHAR NO-UNDO.

DEFINE VARIABLE cCaracterSubs   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE senhaIncompleta AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-tp-repetido   AS LOGICAL     NO-UNDO.

DEFINE VARIABLE iContAux    AS INTEGER NO-UNDO.
DEFINE VARIABLE i-asc-carac AS INTEGER NO-UNDO.
DEFINE VARIABLE i-diff      AS INTEGER NO-UNDO.
DEFINE VARIABLE i-simbolo   AS INTEGER NO-UNDO.

DEFINE VARIABLE algoritmo           as character no-undo initial "SHA-1".
DEFINE VARIABLE mensagem            as character no-undo.


DEFINE VARIABLE c-arquivo-log1 AS CHARACTER     NO-UNDO.

DEF TEMP-TABLE tt-obrigatorio-senha
    FIELD tipo             AS CHAR
    FIELD posi-repete-tipo AS INT
    FIELD prim-tp-repetido AS LOG
    INDEX idx tipo prim-tp-repetido.



/* Funcao */
FUNCTION fnSubsCaracter RETURN CHARACTER (INPUT c-senha AS CHAR):

    DEFINE VARIABLE i-asc  AS INTEGER    NO-UNDO.
    DEFINE VARIABLE i-cont AS INTEGER    NO-UNDO.
    DEFINE VARIABLE c-var  AS CHARACTER  NO-UNDO.

   /*
    ASSIGN c-senha = REPLACE(c-senha,CHR(112),CHR(114)) 
           c-senha = REPLACE(c-senha,CHR(43),CHR(64))   
           c-senha = REPLACE(c-senha,CHR(44),CHR(36))   
           c-senha = REPLACE(c-senha,CHR(45),CHR(38))   
           c-senha = REPLACE(c-senha,CHR(47),CHR(35))   
           c-senha = REPLACE(c-senha,CHR(48),CHR(57))   
           c-senha = REPLACE(c-senha,CHR(71),CHR(70))   
           c-senha = REPLACE(c-senha,CHR(73),CHR(72))   
           c-senha = REPLACE(c-senha,CHR(79),CHR(78))   
           c-senha = REPLACE(c-senha,CHR(81),CHR(80))   
           c-senha = REPLACE(c-senha,CHR(95),CHR(64))   
           c-senha = REPLACE(c-senha,CHR(103),CHR(102)) 
           c-senha = REPLACE(c-senha,CHR(105),CHR(104)) 
           c-senha = REPLACE(c-senha,CHR(106),CHR(107)) 
           c-senha = REPLACE(c-senha,CHR(108),CHR(109)) 
           c-senha = REPLACE(c-senha,CHR(111),CHR(110)) 
           c-senha = REPLACE(c-senha,CHR(113),CHR(115)) 
           //c-senha = REPLACE(c-senha,CHR(121),CHR(119)) 
           c-senha = REPLACE(c-senha,CHR(95),CHR(64)).*/

    DO i-cont = 1 TO LENGTH(c-senha):
    
        /*MESSAGE ASC(SUBSTRING(c-senha,i-cont,1))
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/
        
        CASE ASC(SUBSTRING(c-senha,i-cont,1)):
           WHEN 112 THEN // p
              ASSIGN OVERLAY(c-senha,i-cont,1) = CHR(114).                            
           WHEN 43  THEN // +
              ASSIGN OVERLAY(c-senha,i-cont,1) = CHR(64).                            
           WHEN 44  THEN // ,
              ASSIGN OVERLAY(c-senha,i-cont,1) = CHR(36).                            
           WHEN 45  THEN // -
              ASSIGN OVERLAY(c-senha,i-cont,1) = CHR(38).                            
           WHEN 47  THEN /* / */
              ASSIGN OVERLAY(c-senha,i-cont,1) = CHR(35).                            
           WHEN 48  THEN // 0
              ASSIGN OVERLAY(c-senha,i-cont,1) = CHR(57).                            
           WHEN 71  THEN // G
              ASSIGN OVERLAY(c-senha,i-cont,1) = CHR(70).                            
           WHEN 73  THEN // |
               ASSIGN OVERLAY(c-senha,i-cont,1) = CHR(72).                            
           WHEN 79  THEN // O
               ASSIGN OVERLAY(c-senha,i-cont,1) = CHR(78).                            
           WHEN 81  THEN // Q
               ASSIGN OVERLAY(c-senha,i-cont,1) = CHR(80).                            
           WHEN 95  THEN // _
               ASSIGN OVERLAY(c-senha,i-cont,1) = CHR(64).                            
           WHEN 103 THEN // g
               ASSIGN OVERLAY(c-senha,i-cont,1) = CHR(102).                            
           WHEN 105 THEN // i
               ASSIGN OVERLAY(c-senha,i-cont,1) = CHR(104).                            
           WHEN 106 THEN  // j
               ASSIGN OVERLAY(c-senha,i-cont,1) = CHR(107).                            
           WHEN 108 THEN // l
               ASSIGN OVERLAY(c-senha,i-cont,1) = CHR(109).                            
           WHEN 111 THEN // o
               ASSIGN OVERLAY(c-senha,i-cont,1) = CHR(110).                            
           WHEN 113 THEN // q
               ASSIGN OVERLAY(c-senha,i-cont,1) = CHR(115).                            
           WHEN 121 THEN // y
               ASSIGN OVERLAY(c-senha,i-cont,1) = CHR(119).                            
           WHEN 95  THEN // _
               ASSIGN OVERLAY(c-senha,i-cont,1) = CHR(64).                            
           WHEN 177 THEN // ñ => w
              ASSIGN OVERLAY(c-senha,i-cont,1) = CHR(119). 
        END.
    
        /*
        MESSAGE ASC(SUBSTRING(c-senha,i-cont,1)) SKIP 
                chr(ASC(SUBSTRING(c-senha,i-cont,1)))
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/
    
    END.
    
    RETURN c-senha.

/*
  MESSAGE ASC("+")  /*43 */  "  " CHR(43)  "  "  ASC("@") /*64 */ "   " CHR(64)   SKIP 
          ASC(",")  /*44 */  "  " CHR(44)  "  "  ASC("$") /*36 */ "   " CHR(36)   SKIP 
          ASC("-")  /*45 */  "  " CHR(45)  "  "  ASC("&") /*38 */ "   " CHR(38)   SKIP 
          ASC("/")  /*47 */  "  " CHR(47)  "  "  ASC("#") /*35 */ "   " CHR(35)   SKIP  
          ASC("0")  /*48 */  "  " CHR(48)  "  "  ASC("9") /*57 */ "   " CHR(57)   SKIP 
          ASC("G")  /*71 */  "  " CHR(71)  "  "  ASC("F") /*70 */ "   " CHR(70)   SKIP 
          ASC("I")  /*73 */  "  " CHR(73)  "  "  ASC("H") /*72 */ "   " CHR(72)   SKIP 
          ASC("O")  /*79 */  "  " CHR(79)  "  "  ASC("N") /*78 */ "   " CHR(78)   SKIP 
          ASC("Q")  /*81 */  "  " CHR(81)  "  "  ASC("P") /*80 */ "   " CHR(80)   SKIP 
          ASC("_")  /*95 */  "  " CHR(95)  "  "  ASC("@") /*64 */ "   " CHR(64)   SKIP 
          ASC("g")  /*103*/  "  " CHR(103) "  "  ASC("f") /*102*/ "   " CHR(102)  SKIP 
          ASC("i")  /*105*/  "  " CHR(105) "  "  ASC("h") /*104*/ "   " CHR(104)  SKIP 
          ASC("j")  /*106*/  "  " CHR(106) "  "  ASC("k") /*107*/ "   " CHR(107)  SKIP 
          ASC("l")  /*108*/  "  " CHR(108) "  "  ASC("m") /*109*/ "   " CHR(109)  SKIP 
          ASC("o")  /*111*/  "  " CHR(111) "  "  ASC("n") /*110*/ "   " CHR(110)  SKIP 
          ASC("p")  /*112*/  "  " CHR(112) "  "  ASC("r") /*114*/ "   " CHR(114)  SKIP 
          ASC("q")  /*113*/  "  " CHR(113) "  "  ASC("s") /*115*/ "   " CHR(115)  SKIP 
          ASC("y")  /*121*/  "  " CHR(121) "  "  ASC("w") /*119*/ "   " CHR(119)  SKIP 
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
*/    

END.      



/* Inicio */

IF OPSYS = "unix":U THEN
   ASSIGN c-arquivo-log1 = '/mnt/spool/is055792/esapi016x.txt'.
ELSE
   ASSIGN c-arquivo-log1 = '\\erpapp\spool\is055792\esapi016x.txt'.

RUN pi-gerar-dados-extrato (" INICIO gera senha" + CHR(13) + CHR(13)).

RUN pi-gerar-dados-extrato (" pModelo + MAC: " + pModProdcomMAC).

ASSIGN mensagem = pModProdcomMAC.

//ASSIGN senhacalculada = SHA1-DIGEST(string(teste)). //SHA1-DIGEST('wom5amimo||001a3f010203').

ASSIGN senhacalculada   = MESSAGE-DIGEST(algoritmo, mensagem ).

ASSIGN lcSha1         = UPPER(STRING(HEX-ENCODE(senhacalculada))) /*Calcula SHA1*/
       cSha1          = STRING(lcSha1).

/*RUN pi-gerar-dados-extrato("senhacalculada: " + string(senhacalculada)).
RUN pi-gerar-dados-extrato("lcSha1: "         + string(lcSha1)).
RUN pi-gerar-dados-extrato("cSha1 : "         + string(cSha1 )).*/

COPY-LOB FROM lcSha1 TO mptValorBase64 NO-CONVERT.
ASSIGN cBase64 = BASE64-ENCODE(mptValorBase64). /*Calcula BASE64*/
SET-SIZE(mptValorBase64) = 0.

/* Pegar primeiro numero da base64 para iniciar senhas */
loopSenha:
DO iCont = 1 TO LENGTH(cSha1):
   IF STRING(ASC(SUBSTRING(cSha1,iCont,1))) >= STRING(ASC('0')) AND 
      STRING(ASC(SUBSTRING(cSha1,iCont,1))) <= STRING(ASC('9')) THEN DO:
      ASSIGN iNumIniSenhas = INT(SUBSTRING(cSha1,iCont,1)).
      
      RUN pi-gerar-dados-extrato("iNumIniSenhas : " + string(iNumIniSenhas)).

      LEAVE loopSenha.
   END.
END.

/* Outras linguagens o caracter 0 ï¿½ uma posicao por isso soma-se 1*/
ASSIGN iNumIniSenhas = iNumIniSenhas + 1. 

ASSIGN cSenhaADM  = SUBSTRING(cBase64,iNumIniSenhas,8)
       cSenhaWIFI = SUBSTRING(cBase64,iNumIniSenhas + 8,12).

RUN pi-gerar-dados-extrato("cSenhaWIFI: " + string(cSenhaWIFI)).
RUN pi-gerar-dados-extrato("cSenhaADM : " + string(cSenhaADM)).   

/*
MESSAGE 'SHA-1  : ' string(lcSha1)  SKIP(2) 
        'BASE64 : ' string(cBase64)
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/

/*
MESSAGE "cSenhaADM  : "  cSenhaADM  SKIP 
        "cSenhaWIFI : "  cSenhaWIFI 
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/
  



/* Verifica se a senha ADM atende aos requisitos minimos desejados */
/* 1ï¿½ Maiusculo, 2ï¿½ Minusculo, 3ï¿½ Numero, 4 ï¿½ Simbolo              */

ASSIGN senhaIncompleta = YES.

/*
cBase64 = 'RTVERkREODIHQUZBQkEwMEU0ODlCQUZBMzVDMkZFRUQxR'.
ASSIGN cSenhaADM = 'ODIHQUZB'.*/

validaSenha:
DO WHILE (senhaIncompleta):

    ASSIGN cPrimeiroTipo = ''
           cTipoRepetido = ''.

    FOR EACH tt-obrigatorio-senha: DELETE tt-obrigatorio-senha. END.

    RUN pi-gerar-dados-extrato("DO WHILE cSenhaADM : " + string(cSenhaADM)).    

    ASSIGN l-tp-repetido = NO.

    loopSenha:
    DO iCont = 1 TO LENGTH(cSenhaADM):
    
       /* Simbolo */
       IF (ASC(SUBSTRING(cSenhaADM,iCont,1)) >= 33 AND ASC(SUBSTRING(cSenhaADM,iCont,1)) <= 47) /* !.../ */ OR 
          (ASC(SUBSTRING(cSenhaADM,iCont,1)) >= 60 AND ASC(SUBSTRING(cSenhaADM,iCont,1)) <= 64) /* <...@ */ OR 
          (ASC(SUBSTRING(cSenhaADM,iCont,1)) >= 91 AND ASC(SUBSTRING(cSenhaADM,iCont,1)) <= 96) /* [...` */ THEN DO:
    
          FIND FIRST tt-obrigatorio-senha WHERE tt-obrigatorio-senha.tipo = 'simbolo' NO-ERROR.
    
          IF NOT AVAIL tt-obrigatorio-senha THEN DO:
             CREATE tt-obrigatorio-senha.
             ASSIGN tt-obrigatorio-senha.tipo = 'simbolo'.
          END.
          
          IF NOT l-tp-repetido  THEN
             RUN piTipoRepetido (INPUT iCont + 1,INPUT cSenhaADM).
       END.
    
       /* Numero */
       IF ASC(SUBSTRING(cSenhaADM,iCont,1)) >= 48 AND 
          ASC(SUBSTRING(cSenhaADM,iCont,1)) <= 57 /* 0...9*/ THEN DO:
    
          FIND FIRST tt-obrigatorio-senha WHERE tt-obrigatorio-senha.tipo = 'numero' NO-ERROR.
    
          IF NOT AVAIL tt-obrigatorio-senha THEN DO:
              CREATE tt-obrigatorio-senha.
              ASSIGN tt-obrigatorio-senha.tipo = 'numero'.
          END.
          
          IF NOT l-tp-repetido  THEN
             RUN piTipoRepetido (INPUT iCont + 1,INPUT cSenhaADM).
       END.
    
       /*Maiusculo*/
       IF ASC(SUBSTRING(cSenhaADM,iCont,1)) >= 65 AND 
          ASC(SUBSTRING(cSenhaADM,iCont,1)) <= 90 /* A...Z */ THEN DO:
          
          FIND FIRST tt-obrigatorio-senha WHERE tt-obrigatorio-senha.tipo = 'maiusculo' NO-ERROR.
    
          IF NOT AVAIL tt-obrigatorio-senha THEN DO:
             CREATE tt-obrigatorio-senha.
             ASSIGN tt-obrigatorio-senha.tipo = 'maiusculo'.
          END.
          
          IF NOT l-tp-repetido  THEN
             RUN piTipoRepetido (INPUT iCont + 1,INPUT cSenhaADM).
       END.
    
       /*Minusculo*/
       IF ASC(SUBSTRING(cSenhaADM,iCont,1)) >= 97  AND 
          ASC(SUBSTRING(cSenhaADM,iCont,1)) <= 122 /* a...z */ THEN DO:
    
          FIND FIRST tt-obrigatorio-senha WHERE tt-obrigatorio-senha.tipo = 'minusculo' NO-ERROR.
          
          IF NOT AVAIL tt-obrigatorio-senha THEN DO:
             CREATE tt-obrigatorio-senha.
             ASSIGN tt-obrigatorio-senha.tipo = 'minusculo'.
          END.
          
          IF NOT l-tp-repetido  THEN
             RUN piTipoRepetido (INPUT iCont + 1,INPUT cSenhaADM).
       END.
    END.

    FOR EACH tt-obrigatorio-senha:
        RUN pi-gerar-dados-extrato("111 tt-obrigatorio-senha.tipo : " + string(tt-obrigatorio-senha.tipo)).   
    END.
    //LEAVE.

    /* Tratamento para quando nao existir requisitos minimos de senha */
    
    /* Tratar senha sem Maiusculo */
    FIND FIRST tt-obrigatorio-senha WHERE tt-obrigatorio-senha.tipo = 'maiusculo' NO-ERROR.
    
    IF NOT AVAIL tt-obrigatorio-senha THEN DO:

       RUN pi-gerar-dados-extrato(" Nao achou maiscula").    
       
       ASSIGN cCaracterSubs = ''.
       DO iCont = 1 TO LENGTH(cBase64):   
           /*Maiusculo*/
           IF ASC(SUBSTRING(cBase64,iCont,1)) >= 65 AND 
              ASC(SUBSTRING(cBase64,iCont,1)) <= 90 /* A...Z */ THEN DO:
    
               IF cCaracterSubs = '' THEN DO:
                  ASSIGN cCaracterSubs = SUBSTRING(cBase64,iCont,1).
               END.
           END.    
       END.
    
       IF cCaracterSubs = '' THEN DO:
          DO iCont = 1 TO LENGTH(cBase64):   
             /*Minusculo*/
             IF ASC(SUBSTRING(cBase64,iCont,1)) >= 97  AND 
                ASC(SUBSTRING(cBase64,iCont,1)) <= 122 /* a...z */ THEN DO:
    
                 IF cCaracterSubs = '' THEN DO:
                    ASSIGN cCaracterSubs = UPPER(SUBSTRING(cBase64,iCont,1)).
                 END.     
             END.
          END.
       END.

       FIND FIRST tt-obrigatorio-senha 
            WHERE tt-obrigatorio-senha.prim-tp-repetido
       NO-ERROR.

       IF AVAIL tt-obrigatorio-senha  THEN DO:
          ASSIGN OVERLAY(cSenhaADM,tt-obrigatorio-senha.posi-repete-tipo,1) = cCaracterSubs.

          CREATE tt-obrigatorio-senha.
          ASSIGN tt-obrigatorio-senha.tipo = 'maiusculo'
                 tt-obrigatorio-senha.prim-tp-repetido = YES.

          RUN pi-gerar-dados-extrato(" Criou Maiuscula : NEW CARAC : " +  cCaracterSubs).   
          RUN pi-gerar-dados-extrato(" POSICAO : " +  STRING(tt-obrigatorio-senha.posi-repete-tipo)).    
          RUN pi-gerar-dados-extrato(" NEW SENHA : " +  cSenhaADM).    

          NEXT validaSenha.
       END.
    END.
    
    /* Tratar senha sem Minusculo */
    FIND FIRST tt-obrigatorio-senha WHERE tt-obrigatorio-senha.tipo = 'minusculo' NO-ERROR.
    
    IF NOT AVAIL tt-obrigatorio-senha THEN DO:

      RUN pi-gerar-dados-extrato(" Nao achou minuscula").   

       ASSIGN cCaracterSubs = ''.
       DO iCont = 1 TO LENGTH(cBase64):   
          /*Minusculo*/
          IF ASC(SUBSTRING(cBase64,iCont,1)) >= 97  AND 
             ASC(SUBSTRING(cBase64,iCont,1)) <= 122 /* a...z */ THEN DO:
    
              IF cCaracterSubs = '' THEN DO:
                 ASSIGN cCaracterSubs = SUBSTRING(cBase64,iCont,1).
              END.     
          END.
       END.
    
       IF cCaracterSubs = '' THEN DO:
          DO iCont = 1 TO LENGTH(cBase64): 
             /*Maiusculo*/
             IF ASC(SUBSTRING(cBase64,iCont,1)) >= 65 AND 
                ASC(SUBSTRING(cBase64,iCont,1)) <= 90 /* A...Z */ THEN DO:
            
                 IF cCaracterSubs = '' THEN DO:
                    ASSIGN cCaracterSubs = LOWER(SUBSTRING(cBase64,iCont,1)).
                 END.
             END.    
          END.
       END.

       FIND FIRST tt-obrigatorio-senha 
            WHERE tt-obrigatorio-senha.prim-tp-repetido
       NO-ERROR.

       IF AVAIL tt-obrigatorio-senha  THEN DO:
          ASSIGN OVERLAY(cSenhaADM,tt-obrigatorio-senha.posi-repete-tipo,1) = cCaracterSubs.

          CREATE tt-obrigatorio-senha.
          ASSIGN tt-obrigatorio-senha.tipo = 'minusculo'
                 tt-obrigatorio-senha.prim-tp-repetido = YES.

          RUN pi-gerar-dados-extrato(" Criou MINUSCULA : NEW CARAC : " +  cCaracterSubs).  
          RUN pi-gerar-dados-extrato(" POSICAO : " +  STRING(tt-obrigatorio-senha.posi-repete-tipo)).    
          RUN pi-gerar-dados-extrato(" NEW SENHA : " +  cSenhaADM).    

          NEXT validaSenha.
       END.
    END.
    
    /* Tratar senha sem Numero */
    FIND FIRST tt-obrigatorio-senha WHERE tt-obrigatorio-senha.tipo = 'numero' NO-ERROR.
    
    IF NOT AVAIL tt-obrigatorio-senha THEN DO:

       RUN pi-gerar-dados-extrato(" Nao achou numero").   

       ASSIGN cCaracterSubs = ''.
       DO iCont = 1 TO LENGTH(cSha1):   
          /* Numero */
          IF ASC(SUBSTRING(cSha1,iCont,1)) >= 48 AND 
             ASC(SUBSTRING(cSha1,iCont,1)) <= 57 /* 0...9*/ THEN DO:
    
             IF cCaracterSubs = '' THEN DO:
                ASSIGN cCaracterSubs = LOWER(SUBSTRING(cSha1,iCont,1)).
             END.
          END.
       END.

       FIND FIRST tt-obrigatorio-senha 
            WHERE tt-obrigatorio-senha.prim-tp-repetido
       NO-ERROR.

       IF AVAIL tt-obrigatorio-senha  THEN DO:
          ASSIGN OVERLAY(cSenhaADM,tt-obrigatorio-senha.posi-repete-tipo,1) = cCaracterSubs.

          CREATE tt-obrigatorio-senha.
          ASSIGN tt-obrigatorio-senha.tipo = 'numero'
                 tt-obrigatorio-senha.prim-tp-repetido = YES.

          RUN pi-gerar-dados-extrato(" Criou NUMERO : NEW CARAC : " +  cCaracterSubs).  
          RUN pi-gerar-dados-extrato(" POSICAO : " +  STRING(tt-obrigatorio-senha.posi-repete-tipo)).    
          RUN pi-gerar-dados-extrato(" NEW SENHA : " +  cSenhaADM).    

          NEXT validaSenha.
       END.
    END.
    
    /* Tratar senha sem Simbolo */
    FIND FIRST tt-obrigatorio-senha WHERE tt-obrigatorio-senha.tipo = 'simbolo' NO-ERROR.
    
    IF NOT AVAIL tt-obrigatorio-senha THEN DO:

       RUN pi-gerar-dados-extrato(" Nao achou simbolo").   

       ASSIGN cCaracterSubs = ''
              i-simbolo     = 0
              i-diff        = 0.

       FIND FIRST tt-obrigatorio-senha 
            WHERE tt-obrigatorio-senha.prim-tp-repetido
       NO-ERROR.

       IF AVAIL tt-obrigatorio-senha THEN DO:

          ASSIGN cCaracterSubs = SUBSTRING(cSenhaADM,tt-obrigatorio-senha.posi-repete-tipo,1).

          ASSIGN i-asc-carac = asc(cCaracterSubs).

          IF i-asc-carac > ASC('k') THEN
             ASSIGN cSimbolo = '&'.
          ELSE IF i-asc-carac > ASC('V') THEN
                  ASSIGN cSimbolo = '$'.
               ELSE IF i-asc-carac > ASC('F') THEN
                       ASSIGN cSimbolo = '#'.
                    ELSE 
                       ASSIGN cSimbolo = '@'.

          ASSIGN OVERLAY(cSenhaADM,tt-obrigatorio-senha.posi-repete-tipo,1) = cSimbolo. //cCaracterSubs.
          
          CREATE tt-obrigatorio-senha.
          ASSIGN tt-obrigatorio-senha.tipo = 'simbolo'
                 tt-obrigatorio-senha.prim-tp-repetido = YES.

          RUN pi-gerar-dados-extrato(" Criou simbolo : NEW CARAC : " +  cCaracterSubs).    
          RUN pi-gerar-dados-extrato(" POSICAO : " +  STRING(tt-obrigatorio-senha.posi-repete-tipo)).    
          RUN pi-gerar-dados-extrato(" NEW SENHA : " +  cSenhaADM).    
         
          NEXT validaSenha.
       END.
    END.

    ASSIGN senhaIncompleta = NO.

END. /* DO WHILE */


FOR EACH tt-obrigatorio-senha:
    RUN pi-gerar-dados-extrato("111 tt-obrigatorio-senha.tipo : " + string(tt-obrigatorio-senha.tipo)).   
END.


RUN pi-gerar-dados-extrato("cSenhaWIFI ANTES REPLACE: " + string(cSenhaWIFI)).   
RUN pi-gerar-dados-extrato("cSenhaADM  ANTES REPLACE: " + string(cSenhaADM)).   

ASSIGN pSenhaWIFI = fnSubsCaracter(cSenhaWIFI)
       pSenhaADM  = fnSubsCaracter(cSenhaADM).

RUN pi-gerar-dados-extrato("cSenhaWIFI DEPOIS REPLACE: " + string(pSenhaWIFI)).   
RUN pi-gerar-dados-extrato("cSenhaADM  DEPOIS REPLACE: " + string(pSenhaADM )).   


/********************* Fim do Programa *********************/

/*********************** PROCEDURES ************************/

PROCEDURE piTipoRepetido :

    DEF INPUT PARAM iPosicao AS INT.
    DEF INPUT PARAM cSenha   AS CHAR.

    DO iContAux = iPosicao TO LENGTH(cSenha):
       /*Maiusculo*/
       IF ASC(SUBSTRING(cSenha,iContAux,1)) >= 65 AND 
          ASC(SUBSTRING(cSenha,iContAux,1)) <= 90 /* A...Z */ THEN DO:

           IF NOT l-tp-repetido THEN DO:
              FIND FIRST tt-obrigatorio-senha WHERE tt-obrigatorio-senha.tipo = 'Maiusculo' NO-ERROR.
    
              IF AVAIL tt-obrigatorio-senha THEN
                  ASSIGN tt-obrigatorio-senha.posi-repete-tipo = iContAux
                         tt-obrigatorio-senha.prim-tp-repetido = YES
                         l-tp-repetido = YES. 
           END.
       END.

       /*Minusculo*/
       IF ASC(SUBSTRING(cSenha,iContAux ,1)) >= 97  AND 
          ASC(SUBSTRING(cSenha,iContAux ,1)) <= 122 /* a...z */ THEN DO:

           IF NOT l-tp-repetido THEN DO:
              FIND FIRST tt-obrigatorio-senha WHERE tt-obrigatorio-senha.tipo = 'Minusculo' NO-ERROR.
              
              IF AVAIL tt-obrigatorio-senha THEN
                 ASSIGN tt-obrigatorio-senha.posi-repete-tipo = iContAux
                        tt-obrigatorio-senha.prim-tp-repetido = YES
                        l-tp-repetido = YES. 
           END.
       END.

       /* Numero */
       IF ASC(SUBSTRING(cSenha,iContAux,1)) >= 48 AND 
          ASC(SUBSTRING(cSenha,iContAux,1)) <= 57 /* 0...9*/ THEN DO:
        
           IF NOT l-tp-repetido THEN DO:
              FIND FIRST tt-obrigatorio-senha WHERE tt-obrigatorio-senha.tipo = 'Numero' NO-ERROR.
    
              IF AVAIL tt-obrigatorio-senha THEN
                 ASSIGN tt-obrigatorio-senha.posi-repete-tipo = iContAux
                        tt-obrigatorio-senha.prim-tp-repetido = YES
                        l-tp-repetido = YES. 
           END.
       END.

       /* Simbolo */
       IF (ASC(SUBSTRING(cSenha,iContAux,1)) >= 33 AND ASC(SUBSTRING(cSenha,iContAux,1)) <= 47) /* !.../ */ OR 
          (ASC(SUBSTRING(cSenha,iContAux,1)) >= 60 AND ASC(SUBSTRING(cSenha,iContAux,1)) <= 64) /* <...@ */ OR 
          (ASC(SUBSTRING(cSenha,iContAux,1)) >= 91 AND ASC(SUBSTRING(cSenha,iContAux,1)) <= 96) /* [...` */ THEN DO:
        
           IF NOT l-tp-repetido THEN DO:
              FIND FIRST tt-obrigatorio-senha WHERE tt-obrigatorio-senha.tipo = 'Simbolo' NO-ERROR.
    
              IF AVAIL tt-obrigatorio-senha THEN 
                 ASSIGN tt-obrigatorio-senha.posi-repete-tipo = iContAux
                        tt-obrigatorio-senha.prim-tp-repetido = YES
                        l-tp-repetido = YES. 
           END.
       END.
    END.   
END.




PROCEDURE pi-gerar-dados-extrato:
    DEF INPUT PARAM p-string AS CHAR NO-UNDO.
    /*        
    IF c-arquivo-log1 <> "" AND c-arquivo-log1 <> ? THEN DO:
       OUTPUT TO VALUE(c-arquivo-log1) APPEND.
            PUT p-string + " - " + STRING(DATETIME(TODAY, MTIME))  FORMAT "x(500)" SKIP.
       OUTPUT CLOSE. 
    END.*/
END PROCEDURE.












