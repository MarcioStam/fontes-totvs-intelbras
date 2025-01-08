/***********************************************************************************
 ** Programa....: din046.p - delete para tabelas ncm-origem e ncm-origem-sem-prot **
 ** Data........: Setembro/2015                                                   **
 ***********************************************************************************/
define param buffer b-classif-fisc for classif-fisc.
/***** foi substituida pela trigger de assign ***/

FOR EACH ncm-origem EXCLUSIVE-LOCK 
    WHERE ncm-origem.cod-ncm = b-classif-fisc.class-fiscal:

    FOR EACH ncm-origem-sem-prot EXCLUSIVE-LOCK
        WHERE ncm-origem-sem-prot.cod-ncm       = ncm-origem.cod-ncm 
          AND ncm-origem-sem-prot.codigo-orig   = ncm-origem.codigo-orig:
        DELETE ncm-origem-sem-prot.
    END.

    DELETE ncm-origem.

END.

