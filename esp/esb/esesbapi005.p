/*-------------------------------------------------------------------------------------------------------------------------------------------------*/
/*  Programa..: esp/esb/esesb005rp.i1                                                                                                              */
/*  Objetivo..: Validaá∆o do canal e Criar a temp-table com a relaá∆o dos canais que apuram benef°cios centralizados ou por filial                 */
/*              essa relaá∆o est† gravada na tabela int-emitente-canal, e n∆o mais tem relaá∆o com a estrutura de matriz/filial do EMS.            */
/*-------------------------------------------------------------------------------------------------------------------------------------------------*/
                                                                                                                                                 
/* Definiá∆o da tt-central */                       
{esp/esb/esesbapi005.i}

DEF TEMP-TABLE tt-central-lista LIKE tt-central.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

DEF INPUT  PARAM p-emitente AS CHAR NO-UNDO.
DEF OUTPUT PARAM TABLE FOR tt-central.
DEF OUTPUT PARAM TABLE FOR tt-erro.

DEF BUFFER b-int-emitente-aux FOR int-emitente.
DEF BUFFER b-matriz           FOR emitente.
DEF BUFFER b-emitente-aux FOR emitente.

/* procedure prin*/
RUN pi-carrega-tt-central (INPUT p-emitente).

IF  RETURN-VALUE <> "OK" THEN
    RETURN "NOK".

RETURN "OK".
/* FIM */


DEF VAR i-canal AS INTEGER NO-UNDO.

PROCEDURE pi-carrega-tt-central: /*Canais*/
         
    DEF INPUT PARAM p-emitente AS CHAR NO-UNDO.
    
    /* VALIDA PARTICIPAÄ«O CLIENTE NO PROGRAMA DE CANAIS. */
    IF  TRIM(p-emitente) <> "0" 
    AND trim(p-emitente) <> "" THEN DO:

        RUN pi-valida-emitente (INPUT  p-emitente,
                                OUTPUT i-canal).
        IF  RETURN-VALUE <> "OK" THEN
            RETURN "NOK".
    END.

    EMPTY TEMP-TABLE tt-central-lista.
    
    IF  i-canal <> 0 THEN DO:

        FOR EACH int-emitente-canal NO-LOCK
            WHERE int-emitente-canal.cod-emitente-matriz = i-canal:

            FIND FIRST int-emitente NO-LOCK
                WHERE int-emitente.cod-emitente = int-emitente-canal.cod-emitente /*Filial*/
                  AND int-emitente.ind-participa-canais = 993520001
                  AND int-emitente.ind-apuracao-beneficio = 993520000 NO-ERROR. /*filial apura centralizada*/ 

            IF AVAIL int-emitente THEN DO:
                CREATE tt-central-lista.
                ASSIGN tt-central-lista.canal-central = int-emitente-canal.cod-emitente-matriz
                       tt-central-lista.canal-filial  = int-emitente-canal.cod-emitente.

            END.
        END.

   END.

   IF  CAN-FIND (FIRST tt-central-lista) THEN DO:
       FOR EACH tt-central-lista:
           i-canal = tt-central-lista.canal-filial.
           RUN pi-cria-tt-central.
       END.
   END.
   ELSE
       RUN pi-cria-tt-central.

    IF  NOT CAN-FIND (FIRST tt-central) THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT (IF i-canal <> 0 THEN 
                                                   "Cliente " + STRING(i-canal) + " n∆o Ç participante do Programa de Canais"
                                                  ELSE
                                                   "N∆o encontrado cliente(s) participante(s) do Programa de Canais"),
                                            INPUT ""). 
        RETURN "NOK".

    END.


    /* elimina os descredenciados */
    FOR EACH tt-central
        WHERE tt-central.centralizada :
        FIND int-emitente
            WHERE int-emitente.cod-emitente = tt-central.canal-central NO-LOCK NO-ERROR.
        IF  AVAIL int-emitente AND int-emitente.ind-participa-canais <> 993520001 THEN
            DELETE tt-central.
    END.

    IF  CAN-FIND (FIRST tt-erro)  THEN
        RETURN "NOK".
    
    RETURN "OK".
END.

PROCEDURE pi-cria-tt-central:
    
    FOR EACH int-emitente NO-LOCK
        WHERE int-emitente.ind-participa-canais = 993520001 /* Participa canais */
          AND  (IF  i-canal <> 0 THEN 
                   int-emitente.cod-emitente = i-canal 
               ELSE 
                   YES)
          , FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = int-emitente.cod-emitente:
          
        /* VALIDA DATA DE ADES«O */
        IF  int-emitente.dt-adesao = ?  THEN 
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                INPUT "Emitente: " + STRING(int-emitente.cod-emitente) + " n∆o possui data de ades∆o.",
                                                INPUT "O Cliente n∆o possui o campo data de ades∆o ao programa de canais"). 

        /* VALIDA INFORMAÄ«O SOBRE APURAÄ«O DE BENEF÷CIOS (CENTRALIZADA OU POR FILIAIS */
        IF  int-emitente.ind-apuracao-beneficio <> 993520000
        AND int-emitente.ind-apuracao-beneficio <> 993520001 THEN
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                INPUT "Canal: " + STRING(emitente.cod-emitente) + " - " + emitente.nome-emit + ". Campo Apuraá∆o Benef°cio inv†lido",
                                                INPUT "O qualificadar de apuraá∆o de benef°cios centralizada n∆o est† corretamente informado para o emitente" ).
        
        /* VALIDA C‡DIGO DE CLASSIFICAÄ«O DO EMITENTE */
        IF  int-emitente.guid-class = "" 
        OR NOT CAN-FIND (FIRST int-class-canal
                            WHERE int-class-canal.codigo-classificacao = int-emitente.guid-class) THEN
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                INPUT "Classifiá∆o para o canal " + STRING(int-emitente.cod-emitente) +  " n∆o Ç v†lida",
                                                INPUT "O Canal n∆o pode ser movimentado pois n∆o possui a classificaá∆o no programa de canais.").

         /* SE FOR APURAÄ«O DE BENEF÷CIOS DECENTRALIZADA - POR FILIAL */
        IF  int-emitente.ind-apuracao-beneficio = 993520001 THEN DO: 

            CREATE tt-central.
                   
                   /*Dados Central*/
            ASSIGN tt-central.canal-central        = emitente.cod-emitente           /* Filial */           
                   tt-central.guid-canal-central   = int-emitente.cod-guid           /* Filial */           
                   tt-central.dt-adesao-central    = int-emitente.dt-adesao          /* Filial */           
                   tt-central.guid-class-central   = int-emitente.guid-class         /* Filial */           
                   tt-central.nome-abrev-central   = emitente.nome-abrev             /* Filial */           
                   tt-central.nome-emit-central    = emitente.nome-emit              /* Filial */           
                   tt-central.cgc-central          = emitente.cgc                    /* Filial */           
                   tt-central.nome-emit-central    = emitente.nome-matriz            /* Filial */ 
                   tt-central.r-row-central        = ROWID(emitente)                 /* Filail */
                   
                   /*Dados Filial*/                                                                                                          
                   tt-central.canal-filial         = emitente.cod-emitente           /* Filial */                      
                   tt-central.nome-abrev-filial    = emitente.nome-abrev             /* Filial */                      
                   tt-central.nome-emit-filial     = emitente.nome-emit              /* Filial */                      
                   tt-central.cgc-filial           = emitente.cgc                    /* Filial */                      
                   tt-central.nome-matriz-filial   = emitente.nome-matriz            /* Filial */                      
                   tt-central.guid-canal-filial    = int-emitente.cod-guid           /* Filial */                      
                   tt-central.dt-adesao-filial     = int-emitente.dt-adesao          /* Filial */                      
                   tt-central.guid-class-filial    = int-emitente.guid-class         /* Filial */   
                   tt-central.r-row-filial         = ROWID(emitente)
                   tt-central.centralizada         = NO                              /* IGUAL PARA FILIAL E CENTRAL*/ 
                   tt-central.exclusividade        = int-emitente.exclusividade.     /* Centralizador */              

        END.
        ELSE
            /* SE FOR APURAÄ«O DE BENEF÷CIOS CENTRALIZADA NA MATRIZ*/
            IF  int-emitente.ind-apuracao-beneficio = 993520000 THEN DO:
                /* Busca o Emitente Matriz */
                FOR FIRST int-emitente-canal NO-LOCK 
                    WHERE int-emitente-canal.cod-emitente = int-emitente.cod-emitente:
                END.

                IF  NOT AVAIL int-emitente-canal THEN DO:
                    RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                        INPUT "Canal: " + STRING(int-emitente.cod-emitente) + " - " + emitente.nome-emit + " sem matriz informada",
                                                        INPUT "O Canal n∆o possui o nome da matriz informada em seu cadastro." ).
                    RETURN "NOK".
                END.
                /* Extens∆o do Emitente Matriz */
                FOR FIRST b-int-emitente-aux NO-LOCK
                    WHERE b-int-emitente-aux.cod-emitente = int-emitente-canal.cod-emitente-matriz:
                END.

                IF  NOT AVAIL b-int-emitente-aux 
                OR  (AVAIL b-int-emitente-aux AND b-int-emitente-aux.dt-adesao = ?) THEN
                    RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                        INPUT "Canal: " + STRING(int-emitente-canal.cod-emitente-matriz)  + " n∆o posssui data de Ades∆o",
                                                        INPUT "Data de adesao n∆o informada para o emitente. C¢digo CRM: " +  STRING(int-emitente.cod-guid)). 
    
                /* VALIDA C‡DIGO DE CLASSIFICAÄ«O DO EMITENTE */
                IF  AVAIL b-int-emitente-aux THEN DO:
                    IF  b-int-emitente-aux.guid-class = "" 
                    OR NOT CAN-FIND (FIRST int-class-canal
                                        WHERE int-class-canal.codigo-classificacao = b-int-emitente-aux.guid-class) THEN 
                        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                            INPUT "Classifiá∆o para o canal " + STRING(b-int-emitente-aux.cod-emitente) +  " n∆o Ç v†lida",
                                                            INPUT "").
                END.

                FIND FIRST b-matriz NO-LOCK
                    WHERE b-matriz.cod-emitente = int-emitente-canal.cod-emitente-matriz NO-ERROR.
                IF  NOT AVAIL b-matriz THEN
                    RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                        INPUT "Matriz n∆o cadastrada no EMS: " + STRING(int-emitente-canal.cod-emitente),
                                                        INPUT "").

                IF  CAN-FIND (FIRST tt-erro)  THEN
                    RETURN "NOK".

                CREATE tt-central.
                
                       /*Dados Central*/
                ASSIGN tt-central.canal-central        = int-emitente-canal.cod-emitente-matriz /* Centralizador*/
                       tt-central.guid-canal-central   = int-emitente-canal.guid-matriz         /* Centralizador*/
                       tt-central.dt-adesao-central    = b-int-emitente-aux.dt-adesao           /* Centralizador*/
                       tt-central.guid-class-central   = b-int-emitente-aux.guid-class          /* Centralizador*/ 
                       tt-central.nome-abrev-central   = b-matriz.nome-abrev                    /* Centralizador*/
                       tt-central.nome-emit-central    = b-matriz.nome-emit                     /* Centralizador*/
                       tt-central.cgc-central          = b-matriz.cgc                           /* Centralizador*/
                       tt-central.nome-emit-central    = b-matriz.nome-matriz                   /* Centralizador*/
                       tt-central.r-row-central        = rowid(b-matriz)                        /* Centralizador*/ 
                       
                       /*Dados Filial*/                                                                               
                       tt-central.canal-filial         = emitente.cod-emitente                  /* Filial*/
                       tt-central.nome-abrev-filial    = emitente.nome-abrev                    /* Filial*/
                       tt-central.nome-emit-filial     = emitente.nome-emit                     /* Filial*/
                       tt-central.cgc-filial           = emitente.cgc                           /* Filial*/
                       tt-central.nome-matriz-filial   = emitente.nome-matriz                   /* Filial*/ 
                       tt-central.guid-canal-filial    = int-emitente.cod-guid                  /* Filial*/ 
                       tt-central.dt-adesao-filial     = int-emitente.dt-adesao                 /* Filial*/ 
                       tt-central.guid-class-filial    = int-emitente.guid-class                /* Filial*/ 
                       tt-central.r-row-filial         = rowid(emitente)
    
                       tt-central.centralizada         = YES                                    /* IGUAL PARA FILIAL E CENTRAL*/
                       tt-central.exclusividade        = b-int-emitente-aux.exclusividade.      /* Centralizador */ 
    
            END.
            ELSE DO: /*N∆o possui a informaá∆o de tipo de apuraá∆o centralizada ou filial */
                RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                    INPUT (IF i-canal <> 0 THEN 
                                                           "Cliente " + STRING(i-canal) + " n∆o possui indicaá∆o de Tipo de Apuraá∆o de Benef°cio"
                                                          ELSE
                                                           "N∆o foi poss°vel determinar se o cliente apura benef°cios de forma centralizada ou por filiais"),
                                                    INPUT ""). 
                RETURN "NOK".
            END.

    END.

    RETURN "OK".
END.

/*-----------------------*/
/*  PROCEDURES INTERNAS  */
/*-----------------------*/
PROCEDURE pi-valida-emitente:

    DEF INPUT  PARAM p-emitente AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-canal    AS INTEGER NO-UNDO.
 
    FIND FIRST emitente 
        WHERE emitente.cod-emitente = int(p-emitente) NO-LOCK NO-ERROR.

    IF  NOT AVAIL emitente THEN DO:
        FIND FIRST emitente
            WHERE emitente.nome-abrev = p-emitente NO-LOCK NO-ERROR.
        IF  NOT AVAIL emitente THEN DO:
            FIND FIRST emitente
                WHERE emitente.cgc = p-emitente NO-LOCK NO-ERROR.
            IF  NOT AVAIL emitente  THEN DO:
                RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                    INPUT "Emitente: " + STRING(p-emitente) + " inexistente.",
                                                    INPUT ""). 
                RETURN "NOK".
            END.
        END.
    END.
 
    ASSIGN p-canal = emitente.cod-emitente.
    
    RETURN "OK".

END.


PROCEDURE pi-cria-erro:

    DEFINE INPUT PARAM p-erro     AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM p-mensagem AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-ajuda    AS CHAR NO-UNDO.

    CREATE tt-erro.
    ASSIGN tt-erro.codigo   = p-erro
           tt-erro.mensagem = p-mensagem
           tt-erro.ajuda    = p-ajuda.

END.

