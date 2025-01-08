def input param p_cod-serie  AS char.
DEFINE VARIABLE d-maior-data LIKE num-serie-rast.data NO-UNDO.


def temp-table tt-item NO-UNDO XML-NODE-NAME 'ProdutoSerie'
    FIELD CodigoProduto            LIKE ITEM.it-codigo
    FIELD Nome                     LIKE item.desc-item
    FIELD DataFabricacao           LIKE num-serie.data
    FIELD NumeroNotaFiscal         LIKE nota-fiscal.nr-nota-fis   
    FIELD CodigoCliente            LIKE nota-fiscal.cod-emitente        
    FIELD NomeRazaoSocial          LIKE emitente.nome-emit        
    FIELD DataEmissao              LIKE nota-fiscal.dt-emis-nota  
    FIELD NumeroPedido             LIKE nota-fiscal.nr-pedcli     
    FIELD NumeroSerie              LIKE nota-fiscal.serie        
    FIELD CpfCnpjCodEstrangeiro    LIKE nota-fiscal.cgc          
    FIELD PrecoUnitario            LIKE it-nota-fisc.vl-preuni
    FIELD AliquotaIPI              LIKE it-nota-fisc.aliquota-ipi 
    FIELD ValorIPI                 LIKE it-nota-fisc.vl-ipi-it    
    FIELD AliquotaICMS             LIKE it-nota-fisc.aliquota-icm 
    FIELD ValorICMS                LIKE it-nota-fisc.vl-icms-it
    FIELD ID                       AS CHAR
    FIELD Chave                    AS CHAR.    

def input-output parameter table for tt-item.

FIND FIRST num-serie NO-LOCK
     WHERE num-serie.n-serie = p_cod-serie NO-ERROR.
IF AVAIL num-serie THEN DO:

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = num-serie.it-codigo NO-ERROR.

    FOR EACH num-serie-rast NO-LOCK 
       WHERE num-serie-rast.n-serie = num-serie.n-serie:

        IF d-maior-data = ?
        OR d-maior-data < num-serie-rast.data THEN DO:
            ASSIGN d-maior-data = num-serie-rast.data.

            FIND FIRST nota-fiscal NO-LOCK
                 WHERE nota-fiscal.cod-estabel = num-serie-rast.cod-estabel 
                   AND nota-fiscal.serie       = num-serie-rast.serie
                   AND nota-fiscal.nr-nota-fis = num-serie-rast.nr-nota-fis NO-ERROR.
        END.
    END.

    FIND FIRST it-nota-fisc OF nota-fiscal NO-LOCK
         WHERE it-nota-fisc.it-codigo = num-serie.it-codigo NO-ERROR.

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.

    CREATE tt-item.
    ASSIGN tt-item.CodigoProduto         = num-serie.it-codigo
           tt-item.Nome                  = IF AVAIL ITEM THEN ITEM.desc-item ELSE ?
           tt-item.DataFabricacao        = DATE(num-serie.data)
           tt-item.NumeroNotaFiscal      = IF AVAIL nota-fiscal  THEN nota-fiscal.nr-nota-fis   ELSE ?  
           tt-item.CodigoCliente         = IF AVAIL nota-fiscal  THEN nota-fiscal.cod-emitente  ELSE ?      
           tt-item.NomeRazaoSocial       = IF AVAIL emitente     THEN emitente.nome-emit        ELSE ?
           tt-item.DataEmissao           = IF AVAIL nota-fiscal  THEN nota-fiscal.dt-emis-nota  ELSE ?
           tt-item.NumeroPedido          = IF AVAIL nota-fiscal  THEN nota-fiscal.nr-pedcli     ELSE ?
           tt-item.NumeroSerie           = IF AVAIL nota-fiscal  THEN nota-fiscal.serie         ELSE ?
           tt-item.CpfCnpjCodEstrangeiro = IF AVAIL nota-fiscal  THEN nota-fiscal.cgc           ELSE ?
           tt-item.PrecoUnitario         = IF AVAIL it-nota-fisc THEN dec(string(it-nota-fisc.vl-preuni,"zzzzzzzz9.9999"))    ELSE ?
           tt-item.AliquotaIPI           = IF AVAIL it-nota-fisc THEN it-nota-fisc.aliquota-ipi ELSE ?
           tt-item.ValorIPI              = IF AVAIL it-nota-fisc THEN it-nota-fisc.vl-ipi-it    ELSE ?
           tt-item.AliquotaICMS          = IF AVAIL it-nota-fisc THEN it-nota-fisc.aliquota-icm ELSE ?
           tt-item.ValorICMS             = IF AVAIL it-nota-fisc THEN it-nota-fisc.vl-icms-it   ELSE ?
           tt-item.ID                    = num-serie.ID
           tt-item.Chave                 = num-serie.Ch-acesso.
END.
