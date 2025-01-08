/****************************************************************************************
**  Programa...: ESCRM001b.P
**  Objetivo...: Retornar um, ou todos os registro de uma tabela do EMS 5
**  Parametros.: p-nome-tabela  = Nome da tabela no EMS 5 que ser  buscada
                 p-chave-tabela = Chave da tabela no EMS 5. Se for "", busca todos os registros
                 tt-raw-param   = Tabela do EMS 5, dentro de um registro RAW
**  Autor......: SQLWORKS - Setembro 2010 
*****************************************************************************************/

/*--- Defini‡Æo das Temp-Tables ---*/
{esp/crm/escrm001b.i}


/*--- Defini‡Æo dos Parƒmetros ---*/
DEFINE INPUT  PARAMETER p-nome-tabela  AS CHARACTER            NO-UNDO.
DEFINE INPUT  PARAMETER p-chave-tabela AS CHARACTER EXTENT 10  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-raw-param.


/*--- Defini‡Æo das Vari veis Locais ---*/
DEFINE VARIABLE c-cod-unid-negoc AS CHARACTER   NO-UNDO.

/*--- Bloco Principal ---*/
CASE p-nome-tabela:   

    /* verificar tratamento unid_negoc para 2.06 */

    WHEN "unid_negoc" THEN DO:
        ASSIGN c-cod-unid-negoc = p-chave-tabela[1].

        EMPTY TEMP-TABLE tt-raw-param.
        EMPTY TEMP-TABLE tt-unid-negoc.

        IF  c-cod-unid-negoc = ""  OR
            c-cod-unid-negoc = "0" THEN DO:
            FOR EACH unid_negoc NO-LOCK:
                EMPTY TEMP-TABLE tt-unid-negoc.
                CREATE tt-unid-negoc.
                ASSIGN tt-unid-negoc.cod-unid-negoc = unid_negoc.cod_unid_negoc
                       tt-unid-negoc.des-unid-negoc = unid_negoc.des_unid_negoc.

                IF  tt-unid-negoc.cod-unid-negoc = "ADM" THEN
                    ASSIGN tt-unid-negoc.des-unid-negoc = "IADM".

                CREATE tt-raw-param.
                RAW-TRANSFER tt-unid-negoc TO tt-raw-param.raw-trans.
            END.
        END.
        ELSE DO:
            FIND FIRST unid_negoc NO-LOCK
                WHERE  unid_negoc.cod_unid_negoc = c-cod-unid-negoc NO-ERROR.

            IF NOT AVAIL unid_negoc
            THEN DO:

               FIND FIRST unid_negoc NO-LOCK WHERE
                          unid_negoc.des_unid_negoc = c-cod-unid-negoc NO-ERROR.
            END.

            IF  AVAIL  unid_negoc
            THEN DO:

                CREATE tt-unid-negoc.

                ASSIGN tt-unid-negoc.cod-unid-negoc = unid_negoc.cod_unid_negoc
                       tt-unid-negoc.des-unid-negoc = unid_negoc.des_unid_negoc.

                IF  tt-unid-negoc.cod-unid-negoc = "ADM" THEN
                    ASSIGN tt-unid-negoc.des-unid-negoc = "IADM".

                CREATE tt-raw-param.
                RAW-TRANSFER tt-unid-negoc TO tt-raw-param.raw-trans.
            END.
        END.
    END.
    WHEN "ccusto" THEN DO:                 
                  
            FIND FIRST emscad.ccusto NO-LOCK
                WHERE  emscad.ccusto.cod_ccusto = p-chave-tabela[1] NO-ERROR.
            
            IF  AVAIL emscad.ccusto 
            THEN DO:
            
                CREATE tt-ccusto.

                ASSIGN tt-ccusto.cod-ccusto = emscad.ccusto.cod_ccusto
                       tt-ccusto.descricao  = emscad.ccusto.des_tit_ctbl.

                CREATE tt-raw-param.
                RAW-TRANSFER tt-ccusto TO tt-raw-param.raw-trans.
            END.
    END.
    OTHERWISE .
END CASE.

