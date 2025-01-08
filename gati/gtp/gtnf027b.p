
/* 
===================================================================== 
Programa...: nf001Gera.i
Descricao..: 
Autor......: Tiago Castilho 
Data.......: 28/05/2009
===================================================================== 
*/
{gtp/gati0005.i}
{gtp/gtnf027.i} /* Include de declaracao de variaveis e temp-tables */

/*-------------------------------------------------------------------*/

DEFINE VARIABLE l-ICMS              AS LOGICAL    EXTENT 30 NO-UNDO.
DEFINE VARIABLE cLegenda            AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cMsgFISCO           AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cMsgCONTR           AS CHARACTER            NO-UNDO.
DEFINE VARIABLE v-vl-mercadoria     AS DECIMAL    EXTENT 5. 
DEFINE VARIABLE v-vl-bicms          AS DECIMAL    EXTENT 5. 
DEFINE VARIABLE v-vl-icms           AS DECIMAL    EXTENT 5. 
DEFINE VARIABLE v-vl-bicmsst        AS DECIMAL    EXTENT 5. 
DEFINE VARIABLE v-vl-icmsst         AS DECIMAL    EXTENT 5. 
DEFINE VARIABLE v-vl-contabil       AS DECIMAL    EXTENT 5. 
DEFINE VARIABLE cDescricaoItem      AS CHARACTER            NO-UNDO.
DEFINE VARIABLE c-trib              AS CHARACTER            NO-UNDO.
DEFINE VARIABLE lTemBoleto          AS LOGICAL              NO-UNDO.
DEFINE VARIABLE l-PIS               AS LOGICAL    EXTENT 7  NO-UNDO.
DEFINE VARIABLE l-COFINS            AS LOGICAL    EXTENT 7  NO-UNDO.
DEFINE VARIABLE c-cofins            AS CHARACTER            NO-UNDO.
DEFINE VARIABLE i-cont-obs          AS INTEGER     NO-UNDO.

def var l-gera-xml                  as logical no-undo.
def var nr-fisc                     as int.

/**/ 
define variable hXML            as handle no-undo. 
define variable hRoot           as handle no-undo. 
DEFINE VARIABLE hVersao         AS HANDLE NO-UNDO.
define variable hFieldName      as handle no-undo. 
define variable hFieldValue     as handle no-undo. 
define variable hRecord         as handle no-undo. 
define variable hRecordAux      as handle NO-UNDO.
DEFINE VARIABLE hRecordAux2     AS HANDLE NO-UNDO.
DEFINE VARIABLE hRecordAux3     AS HANDLE NO-UNDO.
DEFINE VARIABLE hRecordAux4     AS HANDLE NO-UNDO.
define variable hText           as handle no-undo.
define variable hRecordAux8     as handle no-undo.
define variable hRecordAux23     as handle no-undo.
define variable hRecordAux17     as handle no-undo.
define variable hRecordAux18     as handle no-undo.
define variable hFieldName8     as handle no-undo. 
DEFINE VARIABLE hFIELDValue8    as handle NO-UNDO.
define variable hFieldAux8      as handle no-undo.     
define variable hRecordAux9     as handle no-undo.
DEFINE VARIABLE hRecordAux29    AS HANDLE NO-UNDO.
define variable hRecordAux10    as handle no-undo.
define variable hRecordAux13     as handle no-undo.
define variable hField          as handle no-undo.     
define variable hBuffer         as handle no-undo.
define variable hBufferAux      as handle no-undo.
define variable hBufferAux2     as handle no-undo.
define variable hBufferAux3     as handle no-undo.
define variable hBufferAux4     as handle no-undo.
define variable hBufferAux5     as handle no-undo.
define variable hBufferAux6     as handle no-undo.
define variable hBufferAux7     as handle no-undo.
define variable hBufferAux8     as handle no-undo.
define variable hBufferAux9     as handle no-undo.
define variable hBufferAux10    as handle no-undo.
define variable hBufferAux11    as handle no-undo.
define variable hBufferAux12    as handle no-undo.
define variable hBufferAux13    as handle no-undo.
define variable hBufferAux14    as handle no-undo.
define variable hBufferAux15    as handle no-undo.
define variable hBufferAux16    as handle no-undo.
define variable hBufferAux17    as handle no-undo.
define variable hBufferAux18    as handle no-undo.
define variable hBufferAux19    as handle no-undo.
define variable hBufferAux20    as handle no-undo.
define variable hBufferAux21    as handle no-undo.
DEFINE VARIABLE hBufferAux22    AS HANDLE NO-UNDO.
DEFINE VARIABLE hBufferAux23    AS HANDLE NO-UNDO.
DEFINE VARIABLE hBufferAux24    AS HANDLE NO-UNDO.
DEFINE VARIABLE hBufferAux25    AS HANDLE NO-UNDO.
DEFINE VARIABLE hBufferAux26    AS HANDLE NO-UNDO.
DEFINE VARIABLE hBufferAux27    AS HANDLE NO-UNDO.
DEFINE VARIABLE hBufferAux28    AS HANDLE NO-UNDO.
DEFINE VARIABLE hBufferAux29    AS HANDLE NO-UNDO.

define variable hQuery          as handle no-undo.
define variable hQueryAux       as handle no-undo.
define variable hQueryAux2      as handle no-undo.
define variable hQueryAux3      as handle no-undo.
define variable hQueryAux4      as handle no-undo.
define variable hQueryAux5      as handle no-undo.
define variable hQueryAux6      as handle no-undo.
define variable hQueryAux7      as handle no-undo.
define variable hQueryAux8      as handle no-undo.
DEFINE VARIABLE hQueryAux9      AS HANDLE NO-UNDO.
DEFINE VARIABLE hQueryAux10     AS HANDLE NO-UNDO.
DEFINE VARIABLE hQueryAux11     AS HANDLE NO-UNDO.
DEFINE VARIABLE hQueryAux12     AS HANDLE NO-UNDO.
DEFINE VARIABLE hQueryAux13     AS HANDLE NO-UNDO.
DEFINE VARIABLE hQueryAux14     AS HANDLE NO-UNDO.
DEFINE VARIABLE hQueryAux15     AS HANDLE NO-UNDO.
DEFINE VARIABLE hQueryAux16     AS HANDLE NO-UNDO.
DEFINE VARIABLE hQueryAux17     AS HANDLE NO-UNDO.
DEFINE VARIABLE hQueryAux18     AS HANDLE NO-UNDO.
DEFINE VARIABLE hQueryAux19     AS HANDLE NO-UNDO.
DEFINE VARIABLE hQueryAux20     AS HANDLE NO-UNDO.
DEFINE VARIABLE hQueryAux21     AS HANDLE NO-UNDO.
DEFINE VARIABLE hQueryAux22     AS HANDLE NO-UNDO.
DEFINE VARIABLE hQueryAux23     AS HANDLE NO-UNDO.
DEFINE VARIABLE hQueryAux24     AS HANDLE NO-UNDO.
DEFINE VARIABLE hQueryAux25     AS HANDLE NO-UNDO.
DEFINE VARIABLE hQueryAux26     AS HANDLE NO-UNDO.
DEFINE VARIABLE hQueryAux27     AS HANDLE NO-UNDO.
DEFINE VARIABLE hQueryAux28     AS HANDLE NO-UNDO.
DEFINE VARIABLE hQueryAux29     AS HANDLE NO-UNDO.

/**/ 
define variable iNumFields      as integer no-undo . 
define variable iNumFields2      as integer no-undo . 
define variable iNumFieldsAux   as integer no-undo .
define variable iNumFieldsAux2  as integer no-undo .

DEFINE VARIABLE c-pis AS CHARACTER  NO-UNDO.
     
/**/
DEFINE VARIABLE hAcomp  AS HANDLE     NO-UNDO.
DEFINE VARIABLE iItem   AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-cont  AS INTEGER    NO-UNDO.
DEFINE VARIABLE lSalvo  AS LOGICAL    NO-UNDO.



PROCEDURE piLimparTT:


   /* --------------------------------------------------------------------------------------
      Purpose: Esvaziar todas as tables
      Notes: Ao adicionar uma table nova, nao esquecer de adicionar ela nessa procedure 
      -------------------------------------------------------------------------------------- */
   
    {gtp/gtnf027.i1} /* delete temp-table */

   DELETE OBJECT hXML         NO-ERROR.
   DELETE OBJECT hRoot        NO-ERROR.
   DELETE OBJECT hVersao      NO-ERROR.
   DELETE OBJECT hFieldName   NO-ERROR.
   DELETE OBJECT hFieldValue  NO-ERROR.
   DELETE OBJECT hRecord      NO-ERROR.
   DELETE OBJECT hRecordAux   NO-ERROR.
   DELETE OBJECT hRecordAux2  NO-ERROR.
   DELETE OBJECT hRecordAux3  NO-ERROR.
   DELETE OBJECT hRecordAux4  NO-ERROR.
   DELETE OBJECT hText        NO-ERROR.
   DELETE OBJECT hRecordAux8  NO-ERROR.
   DELETE OBJECT hRecordAux23 NO-ERROR.
   DELETE OBJECT hRecordAux17 NO-ERROR.
   DELETE OBJECT hFieldName8  NO-ERROR.
   DELETE OBJECT hFIELDValue8 NO-ERROR.
   DELETE OBJECT hFieldAux8   NO-ERROR.
   DELETE OBJECT hRecordAux9  NO-ERROR.
   DELETE OBJECT hRecordAux29 NO-ERROR.
   DELETE OBJECT hRecordAux13 NO-ERROR.
   DELETE OBJECT hRecordAux10 NO-ERROR.
   DELETE OBJECT hField       NO-ERROR.
   DELETE OBJECT hBuffer      NO-ERROR.
   DELETE OBJECT hBufferAux   NO-ERROR.
   DELETE OBJECT hBufferAux2  NO-ERROR.
   DELETE OBJECT hBufferAux3  NO-ERROR.
   DELETE OBJECT hBufferAux4  NO-ERROR.
   DELETE OBJECT hBufferAux5  NO-ERROR.
   DELETE OBJECT hBufferAux6  NO-ERROR.
   DELETE OBJECT hBufferAux7  NO-ERROR.
   DELETE OBJECT hBufferAux8  NO-ERROR.
   DELETE OBJECT hBufferAux9  NO-ERROR.
   DELETE OBJECT hBufferAux10 NO-ERROR.
   DELETE OBJECT hBufferAux11 NO-ERROR.
   DELETE OBJECT hBufferAux13 NO-ERROR.
   DELETE OBJECT hBufferAux14 NO-ERROR.
   DELETE OBJECT hBufferAux15 NO-ERROR.
   DELETE OBJECT hBufferAux16 NO-ERROR.
   DELETE OBJECT hBufferAux17 NO-ERROR.
   DELETE OBJECT hBufferAux18 NO-ERROR.
   DELETE OBJECT hBufferAux19 NO-ERROR.
   DELETE OBJECT hBufferAux20 NO-ERROR.
   DELETE OBJECT hBufferAux21 NO-ERROR.
   DELETE OBJECT hBufferAux22 NO-ERROR.
   DELETE OBJECT hBufferAux23 NO-ERROR.
   DELETE OBJECT hBufferAux24 NO-ERROR.
   DELETE OBJECT hQuery       NO-ERROR.
   DELETE OBJECT hQueryAux    NO-ERROR.
   DELETE OBJECT hQueryAux2   NO-ERROR.
   DELETE OBJECT hQueryAux3   NO-ERROR.
   DELETE OBJECT hQueryAux4   NO-ERROR.
   DELETE OBJECT hQueryAux5   NO-ERROR.
   DELETE OBJECT hQueryAux6   NO-ERROR.
   DELETE OBJECT hQueryAux7   NO-ERROR.
   DELETE OBJECT hQueryAux8   NO-ERROR.
   DELETE OBJECT hQueryAux9   NO-ERROR.
   DELETE OBJECT hQueryAux10  NO-ERROR.
   DELETE OBJECT hQueryAux11  NO-ERROR.
   DELETE OBJECT hQueryAux12  NO-ERROR.
   DELETE OBJECT hQueryAux13  NO-ERROR.
   DELETE OBJECT hQueryAux14  NO-ERROR.
   DELETE OBJECT hQueryAux15  NO-ERROR.
   DELETE OBJECT hQueryAux16  NO-ERROR.
   DELETE OBJECT hQueryAux17  NO-ERROR.
   DELETE OBJECT hQueryAux18  NO-ERROR.
   DELETE OBJECT hQueryAux19  NO-ERROR.
   DELETE OBJECT hQueryAux20  NO-ERROR.
   DELETE OBJECT hQueryAux21  NO-ERROR.
   DELETE OBJECT hQueryAux23  NO-ERROR.
   DELETE OBJECT hQueryAux24  NO-ERROR.

   IF VALID-HANDLE(hXML        )    THEN    DELETE OBJECT hXML        .
   IF VALID-HANDLE(hRoot       )    THEN    DELETE OBJECT hRoot       .
   IF VALID-HANDLE(hVersao     )    THEN    DELETE OBJECT hVersao     .
   IF VALID-HANDLE(hFieldName  )    THEN    DELETE OBJECT hFieldName  .
   IF VALID-HANDLE(hFieldValue )    THEN    DELETE OBJECT hFieldValue .
   IF VALID-HANDLE(hRecord     )    THEN    DELETE OBJECT hRecord     .
   IF VALID-HANDLE(hRecordAux  )    THEN    DELETE OBJECT hRecordAux  .
   IF VALID-HANDLE(hRecordAux2 )    THEN    DELETE OBJECT hRecordAux2 .
   IF VALID-HANDLE(hRecordAux3 )    THEN    DELETE OBJECT hRecordAux3 .
   IF VALID-HANDLE(hRecordAux4 )    THEN    DELETE OBJECT hRecordAux4 .
   IF VALID-HANDLE(hText       )    THEN    DELETE OBJECT hText       .
   IF VALID-HANDLE(hRecordAux8 )    THEN    DELETE OBJECT hRecordAux8 .
   IF VALID-HANDLE(hRecordAux23)    THEN    DELETE OBJECT hRecordAux23.
   IF VALID-HANDLE(hRecordAux17)    THEN    DELETE OBJECT hRecordAux17.
   IF VALID-HANDLE(hFieldName8 )    THEN    DELETE OBJECT hFieldName8 .
   IF VALID-HANDLE(hFIELDValue8)    THEN    DELETE OBJECT hFIELDValue8.
   IF VALID-HANDLE(hFieldAux8  )    THEN    DELETE OBJECT hFieldAux8  .
   IF VALID-HANDLE(hRecordAux9 )    THEN    DELETE OBJECT hRecordAux9 .
   IF VALID-HANDLE(hRecordAux29)     THEN    DELETE OBJECT hRecordAux29.
   IF VALID-HANDLE(hRecordAux13 )   THEN    DELETE OBJECT hRecordAux13 .
   IF VALID-HANDLE(hRecordAux10)    THEN    DELETE OBJECT hRecordAux10.
   IF VALID-HANDLE(hField      )    THEN    DELETE OBJECT hField      .
   IF VALID-HANDLE(hBuffer     )    THEN    DELETE OBJECT hBuffer     .
   IF VALID-HANDLE(hBufferAux  )    THEN    DELETE OBJECT hBufferAux  .
   IF VALID-HANDLE(hBufferAux2 )    THEN    DELETE OBJECT hBufferAux2 .
   IF VALID-HANDLE(hBufferAux3 )    THEN    DELETE OBJECT hBufferAux3 .
   IF VALID-HANDLE(hBufferAux4 )    THEN    DELETE OBJECT hBufferAux4 .
   IF VALID-HANDLE(hBufferAux5 )    THEN    DELETE OBJECT hBufferAux5 .
   IF VALID-HANDLE(hBufferAux6 )    THEN    DELETE OBJECT hBufferAux6 .
   IF VALID-HANDLE(hBufferAux7 )    THEN    DELETE OBJECT hBufferAux7 .
   IF VALID-HANDLE(hBufferAux8 )    THEN    DELETE OBJECT hBufferAux8 .
   IF VALID-HANDLE(hBufferAux9 )    THEN    DELETE OBJECT hBufferAux9 .
   IF VALID-HANDLE(hBufferAux10)    THEN    DELETE OBJECT hBufferAux10.
   IF VALID-HANDLE(hBufferAux11)    THEN    DELETE OBJECT hBufferAux11.
   IF VALID-HANDLE(hBufferAux13)    THEN    DELETE OBJECT hBufferAux13.
   IF VALID-HANDLE(hBufferAux14)    THEN    DELETE OBJECT hBufferAux14.
   IF VALID-HANDLE(hBufferAux15)    THEN    DELETE OBJECT hBufferAux15.
   IF VALID-HANDLE(hBufferAux16)    THEN    DELETE OBJECT hBufferAux16.
   IF VALID-HANDLE(hBufferAux17)    THEN    DELETE OBJECT hBufferAux17.
   IF VALID-HANDLE(hBufferAux18)    THEN    DELETE OBJECT hBufferAux18.
   IF VALID-HANDLE(hBufferAux19)    THEN    DELETE OBJECT hBufferAux19.
   IF VALID-HANDLE(hBufferAux20)    THEN    DELETE OBJECT hBufferAux20.
   IF VALID-HANDLE(hBufferAux21)    THEN    DELETE OBJECT hBufferAux21.
   IF VALID-HANDLE(hBufferAux22)    THEN    DELETE OBJECT hBufferAux22.
   IF VALID-HANDLE(hBufferAux23)    THEN    DELETE OBJECT hBufferAux23.
   IF VALID-HANDLE(hBufferAux24)    THEN    DELETE OBJECT hBufferAux24.
   IF VALID-HANDLE(hQuery      )    THEN    DELETE OBJECT hQuery      .
   IF VALID-HANDLE(hQueryAux   )    THEN    DELETE OBJECT hQueryAux   .
   IF VALID-HANDLE(hQueryAux2  )    THEN    DELETE OBJECT hQueryAux2  .
   IF VALID-HANDLE(hQueryAux3  )    THEN    DELETE OBJECT hQueryAux3  .
   IF VALID-HANDLE(hQueryAux4  )    THEN    DELETE OBJECT hQueryAux4  .
   IF VALID-HANDLE(hQueryAux5  )    THEN    DELETE OBJECT hQueryAux5  .
   IF VALID-HANDLE(hQueryAux6  )    THEN    DELETE OBJECT hQueryAux6  .
   IF VALID-HANDLE(hQueryAux7  )    THEN    DELETE OBJECT hQueryAux7  .
   IF VALID-HANDLE(hQueryAux8  )    THEN    DELETE OBJECT hQueryAux8  .
   IF VALID-HANDLE(hQueryAux9  )    THEN    DELETE OBJECT hQueryAux9  .
   IF VALID-HANDLE(hQueryAux10 )    THEN    DELETE OBJECT hQueryAux10 .
   IF VALID-HANDLE(hQueryAux11 )    THEN    DELETE OBJECT hQueryAux11 .
   IF VALID-HANDLE(hQueryAux12 )    THEN    DELETE OBJECT hQueryAux12 .
   IF VALID-HANDLE(hQueryAux13 )    THEN    DELETE OBJECT hQueryAux13 .
   IF VALID-HANDLE(hQueryAux14 )    THEN    DELETE OBJECT hQueryAux14 .
   IF VALID-HANDLE(hQueryAux15 )    THEN    DELETE OBJECT hQueryAux15 .
   IF VALID-HANDLE(hQueryAux16 )    THEN    DELETE OBJECT hQueryAux16 .
   IF VALID-HANDLE(hQueryAux17 )    THEN    DELETE OBJECT hQueryAux17 .
   IF VALID-HANDLE(hQueryAux18 )    THEN    DELETE OBJECT hQueryAux18 .
   IF VALID-HANDLE(hQueryAux19 )    THEN    DELETE OBJECT hQueryAux19 .
   IF VALID-HANDLE(hQueryAux20 )    THEN    DELETE OBJECT hQueryAux20 .
   IF VALID-HANDLE(hQueryAux21 )    THEN    DELETE OBJECT hQueryAux21 .
   IF VALID-HANDLE(hQueryAux23 )    THEN    DELETE OBJECT hQueryAux23 .
   IF VALID-HANDLE(hQueryAux24 )    THEN    DELETE OBJECT hQueryAux24 .

END PROCEDURE.   

procedure XML-Gera:
    /* -----------------------------------------------------------------------------------
    - Purpose: Gerar o XML principal(a estrutura - NFe(raiz)
    -                                              .infNFe
                                                   (a partir desse nivel E gerada pela procedure gerarTabelaXML)
    -                                              ..ide
    -                                              ..emit
    -                                              ..(restante das tables)...
    --------------------------------------------------------------------------------------*/
     
    DEFINE INPUT PARAMETER TABLE FOR ide.
    DEFINE INPUT PARAMETER TABLE FOR nfref.     
    DEFINE INPUT PARAMETER TABLE FOR ObsCont.   
    DEFINE INPUT PARAMETER TABLE FOR ObsFisco.  
    DEFINE INPUT PARAMETER TABLE FOR ProcRef.   
    DEFINE INPUT PARAMETER TABLE FOR exporta.   
    DEFINE INPUT PARAMETER TABLE FOR imposto.   
    DEFINE INPUT PARAMETER TABLE FOR ICMS00.    
    DEFINE INPUT PARAMETER TABLE FOR ICMS10.    
    DEFINE INPUT PARAMETER TABLE FOR ICMS20.    
    DEFINE INPUT PARAMETER TABLE FOR ICMS30.    
    DEFINE INPUT PARAMETER TABLE FOR ICMS40.    
    DEFINE INPUT PARAMETER TABLE FOR ICMS51.    
    DEFINE INPUT PARAMETER TABLE FOR ICMS60.    
    DEFINE INPUT PARAMETER TABLE FOR ICMS70.    
    DEFINE INPUT PARAMETER TABLE FOR ICMS90.    
    DEFINE INPUT PARAMETER TABLE FOR ICMSTot.   
    DEFINE INPUT PARAMETER TABLE FOR ICMS.      
    DEFINE INPUT PARAMETER TABLE FOR IPI .      
    DEFINE INPUT PARAMETER TABLE FOR PIS.       
    DEFINE INPUT PARAMETER TABLE FOR PISAliq.   
    DEFINE INPUT PARAMETER TABLE FOR PISNT.     
    DEFINE INPUT PARAMETER TABLE FOR PISOutr.   
    DEFINE INPUT PARAMETER TABLE FOR PISST.     
    DEFINE INPUT PARAMETER TABLE FOR COFINS.    
    DEFINE INPUT PARAMETER TABLE FOR COFINSAliq.
    DEFINE INPUT PARAMETER TABLE FOR COFINSNT.  
    DEFINE INPUT PARAMETER TABLE FOR COFINSOutr.
    DEFINE INPUT PARAMETER TABLE FOR COFINSQtde.
    DEFINE INPUT PARAMETER TABLE FOR COFINSST.  
    DEFINE INPUT PARAMETER TABLE FOR ISSQN.     
    DEFINE INPUT PARAMETER TABLE FOR ISSQNtot.  
    DEFINE INPUT PARAMETER TABLE FOR II.        
    DEFINE INPUT PARAMETER TABLE FOR med.       
    DEFINE INPUT PARAMETER TABLE FOR compra.    
    DEFINE INPUT PARAMETER TABLE FOR emit.      
    DEFINE INPUT PARAMETER TABLE FOR enderEmit. 
    DEFINE INPUT PARAMETER TABLE FOR dest.      
    DEFINE INPUT PARAMETER TABLE FOR enderDest. 
    DEFINE INPUT PARAMETER TABLE FOR entrega.   
    DEFINE INPUT PARAMETER TABLE FOR autXML. /* novo nf 3.10*/
    DEFINE INPUT PARAMETER TABLE FOR det.       
    DEFINE INPUT PARAMETER TABLE FOR di.        
    DEFINE INPUT PARAMETER TABLE FOR adi.
    DEFINE INPUT PARAMETER TABLE FOR detExport. /* novo nf 3.10*/
    DEFINE INPUT PARAMETER TABLE FOR exportInd. /* novo nf 3.10*/
    DEFINE INPUT PARAMETER TABLE FOR prod.      
    DEFINE INPUT PARAMETER TABLE FOR cEnq.      
    DEFINE INPUT PARAMETER TABLE FOR TOTAL.     
    DEFINE INPUT PARAMETER TABLE FOR Transp.    
    DEFINE INPUT PARAMETER TABLE FOR transporta.
    DEFINE INPUT PARAMETER TABLE FOR retTransp. 
    DEFINE INPUT PARAMETER TABLE FOR veicTransp.
    DEFINE INPUT PARAMETER TABLE FOR reboque.   
    DEFINE INPUT PARAMETER TABLE FOR lacres.    
    DEFINE INPUT PARAMETER TABLE FOR veicProd.  
    DEFINE INPUT PARAMETER TABLE FOR dup.       
    DEFINE INPUT PARAMETER TABLE FOR pag.
    DEFINE INPUT PARAMETER TABLE FOR card.
    DEFINE INPUT PARAMETER TABLE FOR cobr.      
    DEFINE INPUT PARAMETER TABLE FOR fat.       
    DEFINE INPUT PARAMETER TABLE FOR ttMsgFISCO.  
    DEFINE INPUT PARAMETER TABLE FOR ttMsgCONTR.  
    DEFINE INPUT PARAMETER TABLE FOR infAdic.   
    DEFINE INPUT PARAMETER TABLE FOR vol.       
    DEFINE INPUT PARAMETER TABLE FOR comb.      
    DEFINE INPUT PARAMETER TABLE FOR nRECOPI.
    DEFINE INPUT PARAMETER TABLE FOR retirada.  
    DEFINE INPUT PARAMETER TABLE FOR arma.      
    DEFINE INPUT PARAMETER TABLE FOR retTrib.   
    DEFINE INPUT PARAMETER TABLE FOR refNF.
    DEFINE INPUT PARAMETER TABLE FOR refNFP.
    DEFINE INPUT PARAMETER TABLE FOR refCTe.
    DEFINE INPUT PARAMETER TABLE FOR refECF.
    DEFINE INPUT PARAMETER TABLE FOR cana.
    DEFINE INPUT PARAMETER TABLE FOR ForDia.
    DEFINE INPUT PARAMETER TABLE FOR Deduc.
    DEFINE INPUT PARAMETER TABLE FOR avulsa.
    DEFINE INPUT PARAMETER TABLE FOR TotalTrib.
    DEFINE INPUT PARAMETER TABLE FOR ICMSUFDest.

    /* Cria handles para arquivo/estrutura XML */ 
    CREATE X-DOCUMENT hXML. 

    CREATE X-NODEREF hRoot. 
    CREATE X-NODEREF hVersao.
    CREATE X-NODEREF hRecord.
    CREATE X-NODEREF hRecordAux.
    CREATE X-NODEREF hRecordAux2.
    CREATE X-NODEREF hRecordAux3.
    CREATE X-NODEREF hRecordAux4.
    CREATE X-NODEREF hFieldName. 
    CREATE X-NODEREF hFieldValue. 
    CREATE X-NODEREF hText.    

    CREATE X-NODEREF hRecordAux8.
    CREATE X-NODEREF hRecordAux23.
    CREATE X-NODEREF hRecordAux17.
    CREATE X-NODEREF hRecordAux9.
    CREATE X-NODEREF hRecordAux29.
    /*CREATE X-NODEREF hFIELDName8.
    CREATE X-NODEREF hFIELDValue8.

    
    CREATE X-NODEREF hFIELDName9.
    CREATE X-NODEREF hFIELDValue9.*/

    /* Create de Root element with table name as element name */
    hXML:create-node(hRoot, "NFe" , "ELEMENT").
    hXML:append-child(hRoot).
    
    /*In°cio PROGRESS 10.2B*/
    if proversion = "10.2B" then do:
        hRoot:SET-ATTRIBUTE("xmlns:abc", "http://www.portalfiscal.inf.br/nfe").
    end.
    /*Fim PROGRESS 10.2B*/
    /*In°cio Padr∆o*/
    else do:    
        hRoot:SET-ATTRIBUTE("xmlns", "http://www.portalfiscal.inf.br/nfe").
    end.    
    /*Fim Padr∆o*/

    /* Create sub-root versao */
    hXML:CREATE-NODE(hVersao, "infNFe", "ELEMENT").
    /*hVersao:SET-ATTRIBUTE("Id","ID_1").*/
    hVersao:SET-ATTRIBUTE("versao","3.10").
    hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */ 
    hText:NODE-VALUE = "~n ".
    hRoot:append-child(hText).
    hRoot:APPEND-CHILD(hVersao).
            
    find first ide no-lock no-error.
    find first NFref no-lock no-error.         
            
    IF avail ide and avail NFref THEN do:
        RUN gerarTabelaXML_NFREF ("ide", "NFref", 24). /* (Estrutura, subestrutura, qual linha comeca) */

    END.    
    else DO:
        RUN gerarTabelaXML ("ide", "", 0). /* (Estrutura, subestrutura, qual linha comeca) */
    END.       
    
    IF CAN-FIND(FIRST emit) THEN
        RUN gerarTabelaXML ("emit", "enderEmit", 3).

    IF CAN-FIND(FIRST dest) THEN
        RUN gerarTabelaXML ("dest", "enderDest", 4). 

    

    IF CAN-FIND(FIRST entrega) THEN
        RUN gerarTabelaXML ('entrega','',0). 
    
    IF CAN-FIND(FIRST autXML) THEN DO:        
        RUN gerarTabelaXML ('autXML','',0).
    END.
    RUN gerarDetXML. /* Estrutura det, sub-estruturas: prod e imposto */

   /* IF CAN-FIND(FIRST arma) THEN 
        RUN gerarTabelaDentroDeOutraXML ("arma", hRecord). /*daniel*/

    IF CAN-FIND(FIRST comb) THEN 
        RUN gerarTabelaDentroDeOutraXML ("comb", hRecord). /*daniel*/
    IF CAN-FIND(FIRST veicProd) THEN /* daniel */
        RUN gerarTabelaXML ("prod", "veicProd", 0).*/
   
    

    IF CAN-FIND(FIRST TOTAL) THEN
        RUN gerarTabelaXML ("total", "ICMSTot", 1). 

    IF CAN-FIND(FIRST ISSQNtot) THEN 
        RUN gerarTabelaDentroDeOutraXML ("ISSQNtot", hRecord). /*daniel*/
    
    IF CAN-FIND(FIRST RetTrib) THEN 
        RUN gerarTabelaDentroDeOutraXML ("RetTrib", hRecord). /*daniel*/
    
    IF CAN-FIND(FIRST transp) and can-find(first transporta) THEN DO:
        RUN gerarTabelaXML ("transp", "transporta", 1).
    END.
    ELSE DO:
        IF CAN-FIND (FIRST transp) THEN        
        RUN gerarTabelaXML ("transp", "", 0).
    END.      

    IF CAN-FIND(FIRST retTransp) THEN 
        RUN gerarTabelaDentroDeOutraXML ("retTransp", hRecord). 

    IF CAN-FIND(FIRST veicTransp) THEN 
        RUN gerarTabelaDentroDeOutraXML ("veicTransp", hRecord). 

    IF CAN-FIND(FIRST reboque) THEN 
        RUN gerarTabelaDentroDeOutraXML ("reboque", hRecord). 
    
    IF CAN-FIND(FIRST vol
                WHERE vol.qvol <> "") THEN 
        RUN gerarTabelaDentroDeOutraXML ("vol", hRecord). 

    IF CAN-FIND(FIRST cobr) AND CAN-FIND(first fat) THEN
        RUN gerarTabelaXML ("cobr", "fat", 1).

    IF CAN-FIND(FIRST cobr) AND CAN-FIND(first dup) THEN
        RUN gerarTabelaXML ("cobr", "dup", 1).

    IF CAN-FIND(FIRST pag) AND CAN-FIND(first pag) THEN DO:                
        RUN gerarTabelaXML ("cobr", "pag", 1).
    END.
        

    /*IF CAN-FIND(FIRST dup) THEN 
        RUN gerarTabelaDentroDeOutraXML ("dup", hRecord).*/    

    IF CAN-FIND(FIRST infAdic) THEN DO:
        RUN gerarTabelaXML("infAdic", "", 0).  
    END.

    IF CAN-FIND(FIRST ProcRef) THEN DO:
        RUN gerarTabelaDentroDeOutraXML ("ProcRef", hRecord). /*daniel*/
    END.


    IF CAN-FIND(FIRST obsCont) THEN DO:
        RUN gerarTabelaDentroDeOutraXMLobscont ("obsCont", hRecord). /*daniel*/
    END.
   
    IF CAN-FIND(FIRST exporta) THEN DO:
        RUN gerarTabelaXML("exporta", "", 0).
    END.

    IF CAN-FIND(FIRST compra) THEN
        RUN gerarTabelaXML("compra", "", 0).    


    IF CAN-FIND(FIRST cana) and can-find(ForDia) THEN /*daniel*/
        RUN gerarTabelaXML ("cana", "ForDia", 1).
    ELSE DO:
        IF CAN-FIND(FIRST cana) THEN /*daniel*/
        RUN gerarTabelaXML ("cana", "", 1).
    END.    

    IF CAN-FIND(FIRST deduc) THEN 
        RUN gerarTabelaDentroDeOutraXML ("deduc", hRecord). /*daniel*/

    IF CAN-FIND(FIRST Retirada) THEN do: /* daniel */
        RUN gerarTabelaXML ("Retirada", "", 0). 
    END.
   
    IF CAN-FIND(FIRST Avulsa) THEN do: /* daniel */
        RUN gerarTabelaXML ("Avulsa", "", 0).
    END.

    hXML:create-node(hText, "", "TEXT").
    hText:NODE-VALUE = "~n".
    hRoot:append-child(hText).

    FIND FIRST ide  NO-ERROR.
    FIND FIRST emit NO-ERROR.

    if avail ide and avail emit then do:
        for each estabelec fields(cod-estabel) no-lock
            where estabelec.cgc = emit.cnpj,
            first nfe-param no-lock
            where nfe-param.cod-estabel = estabelec.cod-estabel.
            
            
            /*** por default sempre gera xml ***/
            assign l-gera-xml = YES.            
            
            assign nr-fisc = int(ide.nNf) no-error.
            find first nota-fiscal
                where nota-fiscal.cod-estabel = estabelec.cod-estabel
                  and nota-fiscal.serie       = ide.serie
                  and nota-fiscal.nr-nota-fis = string(nr-fisc,"9999999") no-lock no-error.
                  
            /*** Catia Schmauch - Gati - 03/12/2009
             *** verifica se a natureza de operacao da nota fiscal 'e uma natureza vinculada a uma natureza
             *** de operacao de nota fiscal triangular. Se for, nao emitira'  o xml ***/
            
            if avail nota-fiscal then DO:
               find first natur-oper
                    where natur-oper.nat-vinculada = nota-fiscal.nat-operacao no-lock no-error.
            END.
          /*  if avail natur-oper then do:
               /** se for operacao triangular, gera xml somente pelo gtnf003 especifico Danica **/
               assign l-gera-xml = NO.
               
               do i-cont = 1 to 15: 
                                 
                  if PROGRAM-NAME(i-cont) matches 'GTP/GTNF003RP.P' then do:
                     assign l-gera-xml = yes. 
                     leave.
                  end.
               end.
            end. */                       
            
            /*In°cio do tratamento espec°fico para PROGRESS 10.2B quando houver problema
              na geraá∆o do XML no endereáo http://www.portalfiscal.inf.br/nfe da TAG NFe. 
              TambÇm verificar o coment†rio "PROGRESS 10.2B" onde Ç criada a tag NFe*/
            if proversion = "10.2B" then do:
                define variable c-arquivo-long as longchar no-undo.
                define variable c-arquivo as character no-undo.
                  
                if l-gera-xml = yes then do:

                    IF opsys <> 'WIN32' THEN
                        assign c-arquivo      = nfe-param.end-exp-nfe-unix + '/' + ide.nNf + '_' + ide.serie + ".xml"
                               c-arquivo-long = nfe-param.end-exp-nfe-unix + '/' + ide.nNf + '_' + ide.serie + ".xml".
                        
                    else     
                         assign c-arquivo      = nfe-param.end-exp-nfe + '/' + ide.nNf + '_' + ide.serie + ".xml"
                                c-arquivo-long = nfe-param.end-exp-nfe + '/' + ide.nNf + '_' + ide.serie + ".xml".

                   
                end.
                ELSE DO:                               
                    assign c-arquivo      = 'c:/temp/bruno' + '/' + ide.nNf + '_' + ide.serie + ".xml"
                           c-arquivo-long = 'c:/temp/bruno' + '/' + ide.nNf + '_' + ide.serie + ".xml".
                END.
                
                hXML:save("LONGCHAR", c-arquivo-long).
                assign c-arquivo-long = replace(c-arquivo-long,"xmlns:abc=","xmlns=").
                COPY-LOB c-arquivo-long TO FILE c-arquivo.
            end.
            /*Fim do tratamento espec°fico para PROGRESS 10.2B*/
            /*In°cio Padr∆o*/
            else do:
                if l-gera-xml = yes then do:
                    IF opsys <> 'WIN32' THEN
                        hXML:save("FILE", nfe-param.end-exp-nfe-unix + '/' + ide.nNf + '_' + ide.serie + ".xml").
                    ELSE
                        hXML:save("FILE", nfe-param.end-exp-nfe + '/' + ide.nNf + '_' + ide.serie + ".xml").
                end.
                ELSE DO:
                    hXML:save("FILE", 'c:/temp' + '/' + ide.nNf + '_' + ide.serie + ".xml").                                
                END.
            end.
            /*Fim Padr∆o*/

        end.
        IF NOT AVAIL estabelec THEN
            hXML:save("FILE", session:temp-directory + string(TIME) + '_' + '1' + ".xml").
    end.
    else do:
        
        ASSIGN lSalvo = NO. 
        hXML:save("FILE", 'c:/temp/' + string(TIME) + '_' + '1' + ".xml").
        ASSIGN lSalvo = YES.
            
    end.    

    /*.hXML:save("FILE", 'c:/temp/' + ide.nNf + '_' + ide.serie + ".xml").*/    
    
    RUN piLimparTT.
    
END PROCEDURE.

PROCEDURE gerarTabelaXML_NFREF:

    /*estrutura*/
    DEFINE INPUT PARAM cTable     AS CHAR NO-UNDO. /* Tabela da estrutura a ser criada */
    /*subestutura */
    DEFINE INPUT PARAM cTableAux  AS CHAR NO-UNDO. /* Tabela da sub-estrutura a ser criada */    
    DEFINE INPUT PARAM iCampo     AS INT  NO-UNDO. /* a partir de qual campo vai imprimir a sub-estrutura */

    DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.

    IF VALID-HANDLE(hQuery)     THEN    DELETE OBJECT hQuery.
    IF VALID-HANDLE(hBuffer)    THEN    DELETE OBJECT hBuffer.
    IF VALID-HANDLE(hQueryAux)  THEN    DELETE OBJECT hQueryAux.
    IF VALID-HANDLE(hBufferAux) THEN    DELETE OBJECT hBufferAux.

    create query hQuery.
    create buffer hBuffer for table cTable.    

    hquery:set-buffers(hBuffer).
    hQuery:query-prepare("FOR EACH " + hBuffer:TABLE). 
    hQuery:query-open(). 
    hQuery:get-first(). 

    /* Condicao para saber se tem sub-estrutura */
    IF cTableAux <> "" THEN DO:
        create query hQueryAux.
        create buffer hBufferAux for table cTableAux.

        hQueryAux:set-buffers(hBufferAux).
        hQueryAux:query-prepare("FOR EACH " + hBufferAux:TABLE). 
        hQueryAux:query-open(). 
        hQueryAux:get-first().                        
    END.    

    REPEAT:        
        /* criacao do no da estrutura principal a tabela CTable */
        hXML:CREATE-NODE(hRecord, hBuffer:TABLE, "ELEMENT"). /* cria a estrutura do no(tabela) como um elemento */
        hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
        hText:NODE-VALUE = "~n ".
        hVersao:append-child(hText).
        hVersao:append-child(hRecord).
        
        /* Criacao dos campos da tabela */
        bloco_campos_principal:
        do iNumFields = 1 to hBuffer:NUM-FIELDS + 1 /* numeraá∆o par aconsiderar referencia das notas */ :
           

            /* foi mudada a posiá∆o do bloco para gerar na posiá∆o absoluta independente da tag/posiá∆o n∆o for gerada */
            IF VALID-HANDLE(hQueryAux8)     THEN DELETE OBJECT hQueryAux8.
            IF VALID-HANDLE(hBufferAux8)    THEN DELETE OBJECT hBufferAux8.
            IF iCampo = iNumFields THEN DO:                
                REPEAT:                                        

                    hXML:CREATE-NODE(hRecordAux, hBufferAux:TABLE, "ELEMENT").
                    hXML:CREATE-NODE(hText, "", "TEXT").
                    hText:NODE-VALUE = "~n ". 
                    hRecord:APPEND-CHILD(hText).
                    hRecord:APPEND-CHILD(hRecordAux).
                    
                    bloco_campos:
                    DO iNumFieldsAux = 2 TO hBufferAux:NUM-FIELDS:                        
                        
                        assign hField = hBufferAux:buffer-field(iNumFieldsAux).
                        
                        IF hField:BUFFER-VALUE = "" THEN NEXT.

                        /* The hText element is used just for create a new line after each element... */ 
                        hXML:create-node(hText, "", "TEXT").
                        hText:NODE-VALUE = "~n ".
                        hRecordAux:append-child(hText).
                        
                        /* create the field name as element */ 
                        hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
                        hRecordAux:append-child(hFieldName). 
                        
                        /* create the field value as text */ 
                        hXML:create-node(hFieldValue, "text", 'TEXT'). 
                        hFieldName:append-child(hFieldValue).
                        hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
                        
                    END.

                    ASSIGN i-seq = i-seq + 1.                    
                    
                    IF cTableAux = "nfref" and can-find(first refNF) THEN DO:
                        
                        create query hQueryAux8.
                        create buffer hBufferAux8 for table 'refNF'.
                            
                        hQueryAux8:set-buffers(hBufferAux8).
                        hQueryAux8:query-prepare("FOR EACH " + hBufferAux8:TABLE + " where refNF.nItem = " + string(i-seq)).
                        hQueryAux8:query-open().
                        hQueryAux8:get-first().                        
                        
                        IF hQueryAux8:NUM-RESULTS > 0 THEN DO:
                            hXML:CREATE-NODE(hRecordAux8, hBufferAux8:TABLE, "ELEMENT").
                            hXML:CREATE-NODE(hText, "", "TEXT").
                            hText:NODE-VALUE = "~n ". 
                            
                            hRecordAux:APPEND-CHILD(hText).
                            hRecordAux:APPEND-CHILD(hRecordAux8).                                                                       
                                                    
                            DO iNumFieldsAux2 = 2 TO hBufferAux8:NUM-FIELDS:
                            
                                assign hField = hBufferAux8:buffer-field(iNumFieldsAux2).
                            
                                /* In order to improve performance, decrease the .xml file size the fields 
                                with a "" value will be not added as element */
                               
                                      
                                /* The hText element is used just for create a new line after each element... */ 
                                hXML:create-node(hText, "", "TEXT").
                                hText:NODE-VALUE = "~n ".
                                hRecordAux8:append-child(hText).
                                
                                /* create the field name as element */ 
                                hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
                                hRecordAux8:append-child(hFieldName). 
                                
                                /* create the field value as text */ 
                                hXML:create-node(hFieldValue, "text", 'TEXT'). 
                                hFieldName:append-child(hFieldValue).
                                hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.                            
                            END.                        
                        END.                                             
                    END.
                                                                                   
                    if cTableAux = 'NFref' and can-find(first refNFP) then do:  /*daniel*/  
                    
                        create query hQueryAux8.
                        create buffer hBufferAux8 for table 'refNFP'.
                    
                        hQueryAux8:set-buffers(hBufferAux8).
                        hQueryAux8:query-prepare("FOR EACH " + hBufferAux8:TABLE + " where refNFP.nItem = " + STRING(i-seq)). 
                        hQueryAux8:query-open(). 
                        hQueryAux8:get-first().
                    
                        hXML:CREATE-NODE(hRecordAux8, hBufferAux8:TABLE, "ELEMENT").
                        hXML:CREATE-NODE(hText, "", "TEXT").
                        hText:NODE-VALUE = "~n ". 
                        hRecordAux:APPEND-CHILD(hText).
                        hRecordAux:APPEND-CHILD(hRecordAux8).
                        
                        bloco_NFref:
                        DO iNumFieldsAux2 = 2 TO hBufferAux8:NUM-FIELDS:                               
                    
							IF hBufferAux8:buffer-field(iNumFieldsAux2):NAME = 'CNPJ' AND hBufferAux8:buffer-field(iNumFieldsAux2):BUFFER-VALUE = "" THEN NEXT bloco_NFref.
							IF hBufferAux8:buffer-field(iNumFieldsAux2):NAME = 'CPF' AND hBufferAux8:buffer-field(iNumFieldsAux2):BUFFER-VALUE = "" THEN NEXT bloco_NFref.
							
                            assign hField = hBufferAux8:buffer-field(iNumFieldsAux2).
                    
                            /* In order to improve performance, decrease the .xml file size the fields 
                            with a "" value will be not added as element */
                           
                                  
                            /* The hText element is used just for create a new line after each element... */ 
                            hXML:create-node(hText, "", "TEXT").
                            hText:NODE-VALUE = "~n ".
                            hRecordAux8:append-child(hText).
                            
                            /* create the field name as element */ 
                            hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
                            hRecordAux8:append-child(hFieldName). 
                            
                            /* create the field value as text */ 
                            hXML:create-node(hFieldValue, "text", 'TEXT'). 
                            hFieldName:append-child(hFieldValue).
                            hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
                        END.
                    end.
                            
                    IF cTableAux = 'NFref' and can-find(first refCTe) then do:  /*daniel*/  
                    
                        create query hQueryAux8.
                        create buffer hBufferAux8 for table 'refCTe'.
                    
                        hQueryAux8:set-buffers(hBufferAux8).
                        hQueryAux8:query-prepare("FOR EACH " + hBufferAux8:TABLE + " where refCTe.nItem = " + STRING(i-seq)). 
                        hQueryAux8:query-open(). 
                        hQueryAux8:get-first().
                    
                        hXML:CREATE-NODE(hRecordAux8, hBufferAux8:TABLE, "ELEMENT").
                        hXML:CREATE-NODE(hText, "", "TEXT").
                        hText:NODE-VALUE = "~n ". 
                        hRecordAux:APPEND-CHILD(hText).
                        hRecordAux:APPEND-CHILD(hRecordAux8).
                        
                        bloco_NFref:
                        DO iNumFieldsAux2 = 2 TO hBufferAux8:NUM-FIELDS:                               
                    
                            assign hField = hBufferAux8:buffer-field(iNumFieldsAux2).
                    
                            /* In order to improve performance, decrease the .xml file size the fields 
                            with a "" value will be not added as element */
                           
                                  
                            /* The hText element is used just for create a new line after each element... */ 
                            hXML:create-node(hText, "", "TEXT").
                            hText:NODE-VALUE = "~n ".
                            hRecordAux8:append-child(hText).
                            
                            /* create the field name as element */ 
                            hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
                            hRecordAux8:append-child(hFieldName). 
                            
                            /* create the field value as text */ 
                            hXML:create-node(hFieldValue, "text", 'TEXT'). 
                            hFieldName:append-child(hFieldValue).
                            hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
                        END.
                    end.
                            
                    if cTableAux = 'NFref' and can-find(first refECF) then do:  /*daniel*/  
                    
                        create query hQueryAux8.
                        create buffer hBufferAux8 for table 'refECF'.
                    
                        hQueryAux8:set-buffers(hBufferAux8).
                        hQueryAux8:query-prepare("FOR EACH " + hBufferAux8:TABLE + " where refECF.nItem = " + STRING(i-seq)). 
                        hQueryAux8:query-open(). 
                        hQueryAux8:get-first().
                    
                        hXML:CREATE-NODE(hRecordAux8, hBufferAux8:TABLE, "ELEMENT").
                        hXML:CREATE-NODE(hText, "", "TEXT").
                        hText:NODE-VALUE = "~n ". 
                        hRecordAux:APPEND-CHILD(hText).
                        hRecordAux:APPEND-CHILD(hRecordAux8).
                        
                        bloco_NFref:
                        DO iNumFieldsAux2 = 2 TO hBufferAux8:NUM-FIELDS:                               
                    
                            assign hField = hBufferAux8:buffer-field(iNumFieldsAux2).
                    
                            /* In order to improve performance, decrease the .xml file size the fields 
                            with a "" value will be not added as element */
                           
                                  
                            /* The hText element is used just for create a new line after each element... */ 
                            hXML:create-node(hText, "", "TEXT").
                            hText:NODE-VALUE = "~n ".
                            hRecordAux8:append-child(hText).
                            
                            /* create the field name as element */ 
                            hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
                            hRecordAux8:append-child(hFieldName). 
                            
                            /* create the field value as text */ 
                            hXML:create-node(hFieldValue, "text", 'TEXT'). 
                            hFieldName:append-child(hFieldValue).
                            hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
                        END.
                    end.
                    /* Fim do DO da impressao dos campos da sub-estrutura */                    
                    hQueryAux:get-next(). 
                    if hQueryAux:query-off-end then leave.                    
                END.
                /* Fim do REPEAT da sub-estrura */
            END.
            /* Fim do IF tiver sub-estrutura */

            IF iNumFields = 24 THEN NEXT. /* IGNORA RESTO DA EXECUÄ«O PARA EVITAR ERRO */

            IF cTable = 'ide' AND hBuffer:buffer-field(iNumFields):BUFFER-VALUE = '' THEN NEXT bloco_campos_principal.

            assign hField = hBuffer:buffer-field(iNumFields).            

            /* The hText element is used just for create a new line after each element... */ 
            hXML:create-node(hText, "", "TEXT").
            hText:NODE-VALUE = "~n ".
            hRecord:append-child(hText).
                           
            /* create the field name as element */ 
            hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
            hRecord:append-child(hFieldName). 
                    
            /* create the field value as text */ 
            hXML:create-node(hFieldValue, "text", 'TEXT'). 
            hFieldName:append-child(hFieldValue). 
            hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.

            
        END. 
        /* Fim do DO da impressao dos campos da estrutura */

        hXML:create-node(hText, "", "TEXT"). 
        hText:NODE-VALUE = "~n ". 
        hRecord:append-child(hText).

        hQuery:get-next(). 
        if hQuery:query-off-end then leave.
    END.

    /* Fim do REPEAT da estrutura */

    hQuery:QUERY-CLOSE().
    DELETE OBJECT hQuery.
    DELETE WIDGET hBuffer.

    IF cTableAux <> "" THEN DO:
        hQueryAux:QUERY-CLOSE().
        DELETE OBJECT hQueryAux.
        DELETE WIDGET hBufferAux.
    END.                   

END PROCEDURE.

PROCEDURE gerarTabelaXML:
    /* ------------------------------------------------------------------------------------------------------------------------
    Purpose: Gerar a estrutura tabela(enviada por parametro) dentro da estrutura infNFe, podendo gerar uma sub-estrutura dessa tabela.
    Example: RUN gerarTabelaXML ("ide", "", 0). 
    Notes: E chamada na procedure XML-Gera
       ------------------------------------------------------------------------------------------------------------------------*/    

    /*estrutura*/
    DEFINE INPUT PARAM cTable     AS CHAR NO-UNDO. /* Tabela da estrutura a ser criada */
    /*subestutura */
    DEFINE INPUT PARAM cTableAux  AS CHAR NO-UNDO. /* Tabela da sub-estrutura a ser criada */    
    DEFINE INPUT PARAM iCampo     AS INT  NO-UNDO. /* a partir de qual campo vai imprimir a sub-estrutura */

    IF VALID-HANDLE(hQuery)     THEN    DELETE OBJECT hQuery.
    IF VALID-HANDLE(hBuffer)    THEN    DELETE OBJECT hBuffer.
    IF VALID-HANDLE(hQueryAux)  THEN    DELETE OBJECT hQueryAux.
    IF VALID-HANDLE(hBufferAux) THEN    DELETE OBJECT hBufferAux.

    create query hQuery.
    create buffer hBuffer for table cTable.    

    hquery:set-buffers(hBuffer).
    hQuery:query-prepare("FOR EACH " + hBuffer:TABLE). 
    hQuery:query-open(). 
    hQuery:get-first(). 

    /* Condicao para saber se tem sub-estrutura */
    IF cTableAux <> "" THEN DO:
        create query hQueryAux.
        create buffer hBufferAux for table cTableAux.

        hQueryAux:set-buffers(hBufferAux).
        hQueryAux:query-prepare("FOR EACH " + hBufferAux:TABLE). 
        hQueryAux:query-open(). 
        hQueryAux:get-first().
    END.

    /* Condicao para saber se tem sub-estrutura */

    REPEAT:        
        /* criacao do no da estrutura principal a tabela CTable */
        hXML:create-node(hRecord, hBuffer:TABLE, "ELEMENT"). /* cria a estrutura do no(tabela) como um elemento */
        hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
        hText:NODE-VALUE = "~n ".
        hVersao:append-child(hText).
        hVersao:append-child(hRecord).
        
        /* Criacao dos campos da tabela */
        bloco_campos_principal:
        do iNumFields = 1 to hBuffer:num-fields:
		
            IF cTable = 'dest'    AND hBuffer:buffer-field(iNumFields):NAME = 'CPF'   AND hBuffer:buffer-field(iNumFields):BUFFER-VALUE = "" THEN NEXT bloco_campos_principal.
            IF cTable = 'dest'    AND hBuffer:buffer-field(iNumFields):NAME = 'CNPJ'  AND hBuffer:buffer-field(iNumFields):BUFFER-VALUE = "" THEN NEXT bloco_campos_principal.
            
			IF cTable = 'dest'    AND hBuffer:buffer-field(iNumFields):NAME = 'ISUF'  AND hBuffer:buffer-field(iNumFields):BUFFER-VALUE = "" THEN NEXT bloco_campos_principal.
            IF cTable = 'dest'    AND hBuffer:buffer-field(iNumFields):NAME = 'email' AND hBuffer:buffer-field(iNumFields):BUFFER-VALUE = "" THEN NEXT bloco_campos_principal.
            IF cTable = 'dest'    AND hBuffer:buffer-field(iNumFields):NAME = 'IE'    AND hBuffer:buffer-field(iNumFields):BUFFER-VALUE = "" THEN NEXT bloco_campos_principal. /* novo */
            IF cTable = 'dest'    AND hBuffer:buffer-field(iNumFields):NAME = 'IM'    AND hBuffer:buffer-field(iNumFields):BUFFER-VALUE = "" THEN NEXT bloco_campos_principal. /* novo */
            IF cTable = 'transp'  AND hBuffer:buffer-field(iNumFields):NAME = 'vagao' AND hBuffer:buffer-field(iNumFields):BUFFER-VALUE = "" THEN NEXT bloco_campos_principal.
            IF cTable = 'transp'  AND hBuffer:buffer-field(iNumFields):NAME = 'balsa' AND hBuffer:buffer-field(iNumFields):BUFFER-VALUE = "" THEN NEXT bloco_campos_principal.
            IF cTable = 'infAdic' AND hBuffer:buffer-field(iNumFields):BUFFER-VALUE = '' THEN NEXT bloco_campos_principal.
            IF cTable = 'exporta' AND hBuffer:buffer-field(iNumFields):BUFFER-VALUE = '' THEN do: NEXT bloco_campos_principal. END.
            IF cTable = 'compra'  AND hBuffer:buffer-field(iNumFields):BUFFER-VALUE = '' THEN NEXT bloco_campos_principal.
            IF cTable = 'ide'     AND hBuffer:buffer-field(iNumFields):BUFFER-VALUE = '' THEN NEXT bloco_campos_principal.
            IF cTable = 'emit'    AND hBuffer:buffer-field(iNumFields):BUFFER-VALUE = '' THEN NEXT bloco_campos_principal.
            IF cTable = 'entrega' AND hBuffer:buffer-field(iNumFields):NAME = 'CPF'   AND hBuffer:buffer-field(iNumFields):BUFFER-VALUE = "" AND hBuffer:buffer-field(1):BUFFER-VALUE <> '' THEN NEXT bloco_campos_principal.
            IF cTable = 'entrega' AND hBuffer:buffer-field(iNumFields):NAME = 'CNPJ'  AND hBuffer:buffer-field(iNumFields):BUFFER-VALUE = "" AND hBuffer:buffer-field(2):BUFFER-VALUE <> '' THEN NEXT bloco_campos_principal.
			IF cTable = 'entrega' AND hBuffer:buffer-field(1):BUFFER-VALUE = "" AND hBuffer:buffer-field(2):BUFFER-VALUE = "" AND hBuffer:buffer-field(iNumFields):NAME = 'CPF' THEN NEXT bloco_campos_principal.
            /*gambiarra que funciona */
            IF cTable = 'entrega' AND (hBuffer:buffer-field(iNumFields):NAME <> 'CNPJ' AND hBuffer:buffer-field(iNumFields):NAME <> 'CPF') AND hBuffer:buffer-field(iNumFields):BUFFER-VALUE = '' THEN NEXT bloco_campos_principal.
            /* geraá∆o idEstrangeiro em branco quando o CNPJ e CPF tambÇm nulos */
            IF cTable = 'dest'    AND hBuffer:buffer-field(iNumFields):NAME = "idEstrangeiro" AND hBuffer:buffer-field(iNumFields):BUFFER-VALUE = "" AND (hBuffer:buffer-field(1):BUFFER-VALUE <> "" OR hBuffer:buffer-field(2):BUFFER-VALUE <> "") THEN NEXT bloco_campos_principal.
            
            

            assign hField = hBuffer:buffer-field(iNumFields).

            /* The hText element is used just for create a new line after each element... */ 
            hXML:create-node(hText, "", "TEXT").
            hText:NODE-VALUE = "~n ".
            hRecord:append-child(hText).

            CASE cTable:
                WHEN "total" THEN DO:
                END.
                WHEN "cobr" THEN DO:
                END.
                OTHERWISE DO:
                    /* create the field name as element */ 
                    hXML:CREATE-NODE(hFieldName, hField:name, 'ELEMENT'). 
                    hRecord:APPEND-CHILD(hFieldName). 
                    
                    /* create the field value as text */ 
                    hXML:CREATE-NODE(hFieldValue, "text", 'TEXT'). 
                    hFieldName:APPEND-CHILD(hFieldValue). 
                    hFieldValue:NODE-VALUE = hField:BUFFER-VALUE. 
                END.
            END CASE.                       

            /* sub-estrutura */
            /* Condicao para saber se tem sub-estrutura, iCampo <> 0 */
            IF VALID-HANDLE(hQueryAux8)     THEN DELETE OBJECT hQueryAux8.
            IF VALID-HANDLE(hBufferAux8)    THEN DELETE OBJECT hBufferAux8.
            IF iCampo = iNumFields THEN DO:
                
                REPEAT:                                        

                    hXML:CREATE-NODE(hRecordAux, hBufferAux:TABLE, "ELEMENT").
                    hXML:CREATE-NODE(hText, "", "TEXT").
                    hText:NODE-VALUE = "~n ". 
                    hRecord:APPEND-CHILD(hText).
                    hRecord:APPEND-CHILD(hRecordAux).
                    
                    bloco_campos:
                    DO iNumFieldsAux = 1 TO hBufferAux:NUM-FIELDS:				
                        IF cTableAux = 'ICMSTot'    AND hBufferAux:buffer-field(iNumFieldsAux):NAME = 'vFCPUFDest'   AND hBufferAux:buffer-field(iNumFieldsAux):BUFFER-VALUE = "" THEN NEXT bloco_campos.
                        IF cTableAux = 'ICMSTot'    AND hBufferAux:buffer-field(iNumFieldsAux):NAME = 'vICMSUFDest'  AND hBufferAux:buffer-field(iNumFieldsAux):BUFFER-VALUE = "" THEN NEXT bloco_campos.
                        IF cTableAux = 'ICMSTot'    AND hBufferAux:buffer-field(iNumFieldsAux):NAME = 'vICMSUFRemet' AND hBufferAux:buffer-field(iNumFieldsAux):BUFFER-VALUE = "" THEN NEXT bloco_campos.
                        IF cTableAux = 'transporta' AND hBufferAux:buffer-field(iNumFieldsAux):NAME = 'CPF'    AND hBufferAux:buffer-field(iNumFieldsAux):BUFFER-VALUE = "" THEN NEXT bloco_campos.
                        IF cTableAux = 'transporta' AND hBufferAux:buffer-field(iNumFieldsAux):NAME = 'CNPJ'   AND hBufferAux:buffer-field(iNumFieldsAux):BUFFER-VALUE = "" THEN NEXT bloco_campos.
                        IF cTableAux = 'transporta' AND hBufferAux:buffer-field(iNumFieldsAux):NAME = 'xNome'  AND hBufferAux:buffer-field(iNumFieldsAux):BUFFER-VALUE = "" THEN NEXT bloco_campos.
                        IF cTableAux = 'transporta' AND hBufferAux:buffer-field(iNumFieldsAux):NAME = 'IE'     AND hBufferAux:buffer-field(iNumFieldsAux):BUFFER-VALUE = "" THEN NEXT bloco_campos.
                        IF cTableAux = 'transporta' AND hBufferAux:buffer-field(iNumFieldsAux):NAME = 'xEnder' AND hBufferAux:buffer-field(iNumFieldsAux):BUFFER-VALUE = "" THEN NEXT bloco_campos.
                        IF cTableAux = 'transporta' AND hBufferAux:buffer-field(iNumFieldsAux):NAME = 'xMun'   AND hBufferAux:buffer-field(iNumFieldsAux):BUFFER-VALUE = "" THEN NEXT bloco_campos.
                        IF cTableAux = 'transporta' AND hBufferAux:buffer-field(iNumFieldsAux):NAME = 'xUF'    AND hBufferAux:buffer-field(iNumFieldsAux):BUFFER-VALUE = "" THEN NEXT bloco_campos.

						IF cTableAux = 'fat' AND INT(hBufferAux:buffer-field(iNumFieldsAux):buffer-value) = 0 THEN NEXT bloco_campos.
                        IF cTableAux = 'enderDest' AND hBufferAux:buffer-field(iNumFieldsAux):NAME = 'fone' AND hBufferAux:buffer-field(iNumFieldsAux):BUFFER-VALUE = "" THEN NEXT bloco_campos.
                        IF hBufferAux:buffer-field(iNumFieldsAux):NAME = 'xCpl' AND hBufferAux:buffer-field(iNumFieldsAux):BUFFER-VALUE = '' THEN NEXT bloco_campos.
                     
                        IF (cTableAux = 'enderEmit' OR cTableAux = 'enderDest') AND hBufferAux:buffer-field(iNumFieldsAux):NAME = 'cPais' AND hBufferAux:BUFFER-FIELD(iNumFieldsAux):BUFFER-VALUE = "" THEN NEXT bloco_campos.
                        IF (cTableAux = 'enderEmit' OR cTableAux = 'enderDest') AND hBufferAux:buffer-field(iNumFieldsAux):NAME = 'xPais' AND hBufferAux:BUFFER-FIELD(iNumFieldsAux):BUFFER-VALUE = "" THEN NEXT bloco_campos.
                        IF (cTableAux = 'enderEmit' OR cTableAux = 'enderDest') AND hBufferAux:buffer-field(iNumFieldsAux):NAME = 'fone'  AND hBufferAux:BUFFER-FIELD(iNumFieldsAux):BUFFER-VALUE = "" THEN NEXT bloco_campos.
			
                        assign hField = hBufferAux:buffer-field(iNumFieldsAux).

                        IF not (cTableAux = 'nfRef' and hField:NAME = 'refNfe' AND hField:BUFFER-VALUE = '') THEN DO:

                            /* The hText element is used just for create a new line after each element... */ 
                            hXML:create-node(hText, "", "TEXT").
                            hText:NODE-VALUE = "~n ".
                            hRecordAux:append-child(hText).
                            
                            /* create the field name as element */ 
                            hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
                            hRecordAux:append-child(hFieldName). 
                            
                            /* create the field value as text */ 
                            hXML:create-node(hFieldValue, "text", 'TEXT'). 
                            hFieldName:append-child(hFieldValue).
                            hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
                        END.
                    END.

                    IF cTableAux = "pag" AND CAN-FIND(FIRST card) THEN DO:

                        CREATE QUERY hQueryAux28.
                        CREATE BUFFER hBufferAux28 FOR TABLE "card".

                        hQueryAux28:set-buffers(hBufferAux28).
                        hQueryAux28:query-prepare("FOR EACH " + hBufferAux28:TABLE). 
                        hQueryAux28:query-open(). 
                        hQueryAux28:get-first().


                        hXML:CREATE-NODE(hRecordAux8, hBufferAux28:TABLE, "ELEMENT").
                        hXML:CREATE-NODE(hText, "", "TEXT").
                        hText:NODE-VALUE = "~n ". 
                        hRecordAux:APPEND-CHILD(hText).
                        hRecordAux:APPEND-CHILD(hRecordAux8).

                        bloco_card:
                        DO iNumFieldsAux2 = 1 TO hBufferAux28:NUM-FIELDS:                               
              
                            assign hField = hBufferAux28:buffer-field(iNumFieldsAux2).
    
                            /* In order to improve performance, decrease the .xml file size the fields 
                            with a "" value will be not added as element */
                           
                                  
                            /* The hText element is used just for create a new line after each element... */ 
                            hXML:create-node(hText, "", "TEXT").
                            hText:NODE-VALUE = "~n ".
                            hRecordAux8:append-child(hText).
                            
                            /* create the field name as element */ 
                            hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
                            hRecordAux8:append-child(hFieldName). 
                            
                            /* create the field value as text */ 
                            hXML:create-node(hFieldValue, "text", 'TEXT'). 
                            hFieldName:append-child(hFieldValue).
                            /*MESSAGE 44444
                                VIEW-AS ALERT-BOX INFO BUTTONS OK.*/
                            hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
                        END.
                    END.
                    
                    if cTableAux = 'NFref' and can-find(first refNF) then do:                        
                        
                        create query hQueryAux8.
                        create buffer hBufferAux8 for table 'refNF'.
                
                        hQueryAux8:set-buffers(hBufferAux8).
                        hQueryAux8:query-prepare("FOR EACH " + hBufferAux8:TABLE). 
                        hQueryAux8:query-open(). 
                        hQueryAux8:get-first().
                    
                        hXML:CREATE-NODE(hRecordAux8, hBufferAux8:TABLE, "ELEMENT").
                        hXML:CREATE-NODE(hText, "", "TEXT").
                        hText:NODE-VALUE = "~n ". 
                        hRecordAux:APPEND-CHILD(hText).
                        hRecordAux:APPEND-CHILD(hRecordAux8).
                        
                        bloco_NFref:
                        DO iNumFieldsAux2 = 1 TO hBufferAux8:NUM-FIELDS:                               
              
                            assign hField = hBufferAux8:buffer-field(iNumFieldsAux2).
    
                            /* In order to improve performance, decrease the .xml file size the fields 
                            with a "" value will be not added as element */
                           
                                  
                            /* The hText element is used just for create a new line after each element... */ 
                            hXML:create-node(hText, "", "TEXT").
                            hText:NODE-VALUE = "~n ".
                            hRecordAux8:append-child(hText).
                            
                            /* create the field name as element */ 
                            hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
                            hRecordAux8:append-child(hFieldName). 
                            
                            /* create the field value as text */ 
                            hXML:create-node(hFieldValue, "text", 'TEXT'). 
                            hFieldName:append-child(hFieldValue).
                            /*MESSAGE 44444
                                VIEW-AS ALERT-BOX INFO BUTTONS OK.*/
                            hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
                        END.
                    end.

                    if cTableAux = 'NFref' and can-find(first refNFP) then do:  /*daniel*/  
                    
                        create query hQueryAux8.
                        create buffer hBufferAux8 for table 'refNFP'.
                
                        hQueryAux8:set-buffers(hBufferAux8).
                        hQueryAux8:query-prepare("FOR EACH " + hBufferAux8:TABLE). 
                        hQueryAux8:query-open(). 
                        hQueryAux8:get-first().
                    
                        hXML:CREATE-NODE(hRecordAux8, hBufferAux8:TABLE, "ELEMENT").
                        hXML:CREATE-NODE(hText, "", "TEXT").
                        hText:NODE-VALUE = "~n ". 
                        hRecordAux:APPEND-CHILD(hText).
                        hRecordAux:APPEND-CHILD(hRecordAux8).
                        
                        bloco_NFref:
                        DO iNumFieldsAux2 = 1 TO hBufferAux8:NUM-FIELDS:     
						
							assign hField = hBufferAux8:buffer-field(iNumFieldsAux2).
    
                            /* In order to improve performance, decrease the .xml file size the fields 
                            with a "" value will be not added as element */
							
                            /* The hText element is used just for create a new line after each element... */ 
                            hXML:create-node(hText, "", "TEXT").
                            hText:NODE-VALUE = "~n ".
                            hRecordAux8:append-child(hText).
                            
                            /* create the field name as element */ 
                            hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
                            hRecordAux8:append-child(hFieldName). 
                            
                            /* create the field value as text */ 
                            hXML:create-node(hFieldValue, "text", 'TEXT'). 
                            hFieldName:append-child(hFieldValue).
                            hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
                        END.
                    end.
                            
                    IF cTableAux = 'NFref' and can-find(first refCTe) then do:  /*daniel*/  
                    
                        create query hQueryAux8.
                        create buffer hBufferAux8 for table 'refCTe'.
                    
                        hQueryAux8:set-buffers(hBufferAux8).
                        hQueryAux8:query-prepare("FOR EACH " + hBufferAux8:TABLE). 
                        hQueryAux8:query-open(). 
                        hQueryAux8:get-first().
                    
                        hXML:CREATE-NODE(hRecordAux8, hBufferAux8:TABLE, "ELEMENT").
                        hXML:CREATE-NODE(hText, "", "TEXT").
                        hText:NODE-VALUE = "~n ". 
                        hRecordAux:APPEND-CHILD(hText).
                        hRecordAux:APPEND-CHILD(hRecordAux8).
                        
                        bloco_NFref:
                        DO iNumFieldsAux2 = 1 TO hBufferAux8:NUM-FIELDS:                               
                    
                            assign hField = hBufferAux8:buffer-field(iNumFieldsAux2).
                    
                            /* In order to improve performance, decrease the .xml file size the fields 
                            with a "" value will be not added as element */
                           
                                  
                            /* The hText element is used just for create a new line after each element... */ 
                            hXML:create-node(hText, "", "TEXT").
                            hText:NODE-VALUE = "~n ".
                            hRecordAux8:append-child(hText).
                            
                            /* create the field name as element */ 
                            hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
                            hRecordAux8:append-child(hFieldName). 
                            
                            /* create the field value as text */ 
                            hXML:create-node(hFieldValue, "text", 'TEXT'). 
                            hFieldName:append-child(hFieldValue).
                            hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
                        END.
                    end.
                            
                    if cTableAux = 'NFref' and can-find(first refECF) then do:  /*daniel*/  
                    
                        create query hQueryAux8.
                        create buffer hBufferAux8 for table 'refECF'.
                    
                        hQueryAux8:set-buffers(hBufferAux8).
                        hQueryAux8:query-prepare("FOR EACH " + hBufferAux8:TABLE). 
                        hQueryAux8:query-open(). 
                        hQueryAux8:get-first().
                    
                        hXML:CREATE-NODE(hRecordAux8, hBufferAux8:TABLE, "ELEMENT").
                        hXML:CREATE-NODE(hText, "", "TEXT").
                        hText:NODE-VALUE = "~n ". 
                        hRecordAux:APPEND-CHILD(hText).
                        hRecordAux:APPEND-CHILD(hRecordAux8).
                        
                        bloco_NFref:
                        DO iNumFieldsAux2 = 1 TO hBufferAux8:NUM-FIELDS:                               
                    
                            assign hField = hBufferAux8:buffer-field(iNumFieldsAux2).
                    
                            /* In order to improve performance, decrease the .xml file size the fields 
                            with a "" value will be not added as element */
                           
                                  
                            /* The hText element is used just for create a new line after each element... */ 
                            hXML:create-node(hText, "", "TEXT").
                            hText:NODE-VALUE = "~n ".
                            hRecordAux8:append-child(hText).
                            
                            /* create the field name as element */ 
                            hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
                            hRecordAux8:append-child(hFieldName). 
                            
                            /* create the field value as text */ 
                            hXML:create-node(hFieldValue, "text", 'TEXT'). 
                            hFieldName:append-child(hFieldValue).
                            hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
                        END.
                    end.
                    /* Fim do DO da impressao dos campos da sub-estrutura */                    
                    hQueryAux:get-next(). 
                    if hQueryAux:query-off-end then leave.                    
                END.
                /* Fim do REPEAT da sub-estrura */
            END.
            /* Fim do IF tiver sub-estrutura */
        END. 
        /* Fim do DO da impressao dos campos da estrutura */

        hXML:create-node(hText, "", "TEXT"). 
        hText:NODE-VALUE = "~n ". 
        hRecord:append-child(hText).

        hQuery:get-next(). 
        if hQuery:query-off-end then leave.
    END.

    /* Fim do REPEAT da estrutura */

    hQuery:QUERY-CLOSE().
    DELETE OBJECT hQuery.
    DELETE WIDGET hBuffer.

    IF cTableAux <> "" THEN DO:
        hQueryAux:QUERY-CLOSE().
        DELETE OBJECT hQueryAux.
        DELETE WIDGET hBufferAux.
    END.

END PROCEDURE.

PROCEDURE gerarDetXML:
    /* ------------------------------------------------------------------------------------------------------------------------
    Purpose: Gerar a estrutura det com suas sub-estruturas, prod e imposto
    
    Notes: E chamada na procedure XML-Gera
       ------------------------------------------------------------------------------------------------------------------------*/        

    DEFINE VARIABLE c-valor AS CHARACTER  NO-UNDO.

    IF VALID-HANDLE(hQuery)         THEN DELETE OBJECT hQuery.
    IF VALID-HANDLE(hBuffer)        THEN DELETE OBJECT hBuffer.
    IF VALID-HANDLE(hQueryAux)      THEN DELETE OBJECT hQueryAux.
    IF VALID-HANDLE(hBufferAux)     THEN DELETE OBJECT hBufferAux.
    IF VALID-HANDLE(hQueryAux2)     THEN DELETE OBJECT hQueryAux2.
    IF VALID-HANDLE(hBufferAux2)    THEN DELETE OBJECT hBufferAux2.
    IF VALID-HANDLE(hQueryAux9)     THEN DELETE OBJECT hQueryAux9.
    IF VALID-HANDLE(hBufferAux9)    THEN DELETE OBJECT hBufferAux9.
    IF VALID-HANDLE(hQueryAux10)    THEN DELETE OBJECT hQueryAux10.
    IF VALID-HANDLE(hBufferAux10)   THEN DELETE OBJECT hBufferAux10.
    IF VALID-HANDLE(hBufferAux13)   THEN DELETE OBJECT hBufferAux13.
    IF VALID-HANDLE(hBufferAux14)   THEN DELETE OBJECT hBufferAux14.
    IF VALID-HANDLE(hBufferAux15)   THEN DELETE OBJECT hBufferAux15.
    IF VALID-HANDLE(hBufferAux16)   THEN DELETE OBJECT hBufferAux16.
    IF VALID-HANDLE(hBufferAux17)   THEN DELETE OBJECT hBufferAux17.
    IF VALID-HANDLE(hBufferAux23)   THEN DELETE OBJECT hBufferAux23.
    IF VALID-HANDLE(hBufferAux18)   THEN DELETE OBJECT hBufferAux18.
    IF VALID-HANDLE(hBufferAux25)   THEN DELETE OBJECT hBufferAux25.
    IF VALID-HANDLE(hBufferAux26)   THEN DELETE OBJECT hBufferAux26.
    IF VALID-HANDLE(hBufferAux27)   THEN DELETE OBJECT hBufferAux27.
    IF VALID-HANDLE(hQueryAux3)     THEN DELETE OBJECT hQueryAux3.
    IF VALID-HANDLE(hBufferAux3)    THEN DELETE OBJECT hBufferAux3.
    IF VALID-HANDLE(hBufferAux24)    THEN DELETE OBJECT hBufferAux24.
    IF VALID-HANDLE(hQueryAux6)     THEN DELETE OBJECT hQueryAux6.
    IF VALID-HANDLE(hBufferAux6)    THEN DELETE OBJECT hBufferAux6.
    IF VALID-HANDLE(hQueryAux7)     THEN DELETE OBJECT hQueryAux7.
    IF VALID-HANDLE(hBufferAux7)    THEN DELETE OBJECT hBufferAux7.
    IF VALID-HANDLE(hQueryAux11)    THEN DELETE OBJECT hQueryAux11.
    IF VALID-HANDLE(hQueryAux19)    THEN DELETE OBJECT hQueryAux19.
    IF VALID-HANDLE(hQueryAux20)    THEN DELETE OBJECT hQueryAux20.
    IF VALID-HANDLE(hQueryAux21)    THEN DELETE OBJECT hQueryAux21.
    IF VALID-HANDLE(hBufferAux11)   THEN DELETE OBJECT hBufferAux11.
    IF VALID-HANDLE(hBufferAux12)   THEN DELETE OBJECT hBufferAux12.
    IF VALID-HANDLE(hQueryAux13)     THEN DELETE OBJECT hQueryAux13.
    IF VALID-HANDLE(hQueryAux14)     THEN DELETE OBJECT hQueryAux14.
    IF VALID-HANDLE(hQueryAux15)     THEN DELETE OBJECT hQueryAux15.
    IF VALID-HANDLE(hQueryAux16)     THEN DELETE OBJECT hQueryAux16.
    IF VALID-HANDLE(hQueryAux17)     THEN DELETE OBJECT hQueryAux17.
    IF VALID-HANDLE(hQueryAux23)     THEN DELETE OBJECT hQueryAux23.
    IF VALID-HANDLE(hQueryAux18)     THEN DELETE OBJECT hQueryAux18.
    IF VALID-HANDLE(hQueryAux4)     THEN DELETE OBJECT hQueryAux4.
    IF VALID-HANDLE(hBufferAux4)    THEN DELETE OBJECT hBufferAux4.
    IF VALID-HANDLE(hQueryAux5)     THEN DELETE OBJECT hQueryAux5.
    IF VALID-HANDLE(hBufferAux5)    THEN DELETE OBJECT hBufferAux5.
    IF VALID-HANDLE(hQueryAux24)     THEN DELETE OBJECT hQueryAux24.
    IF VALID-HANDLE(hQueryAux25)     THEN DELETE OBJECT hQueryAux25.
    IF VALID-HANDLE(hQueryAux26)     THEN DELETE OBJECT hQueryAux26.
    IF VALID-HANDLE(hQueryAux27)     THEN DELETE OBJECT hQueryAux27.

    create query hQuery.
    create buffer hBuffer for table "det".
    
    hquery:set-buffers(hBuffer).
    hQuery:query-prepare("FOR EACH " + hBuffer:TABLE).
    hQuery:query-open().
    hQuery:get-first().
    
    create query hQueryAux.
    create buffer hBufferAux for table "prod".
    
    CREATE QUERY hQueryAux2.
    create buffer hBufferAux2 for table "imposto".

    CREATE QUERY hQueryAux9.
    create buffer hBufferAux9 for table "DI".

    CREATE QUERY hQueryAux13.
    create buffer hBufferAux13 for table "arma".

    CREATE QUERY hQueryAux14.
    create buffer hBufferAux14 for table "comb".

    CREATE QUERY hQueryAux27.
    create buffer hBufferAux27 for table "nRECOPI".

    CREATE QUERY hQueryAux15.
    create buffer hBufferAux15 for table "med".

    CREATE QUERY hQueryAux16.
    create buffer hBufferAux16 for table "veicProd".

    CREATE QUERY hQueryAux10.
    create buffer hBufferAux10 for table "adi".

    CREATE QUERY hQueryAux25.
    CREATE BUFFER hBufferAux25 FOR TABLE "detExport".

    CREATE QUERY hQueryAux26.
    CREATE BUFFER hBufferAux26 FOR TABLE "exportInd".

    CREATE QUERY hQueryAux3.
    create buffer hBufferAux3 for table "ICMS".

    CREATE QUERY hQueryAux6.
    create buffer hBufferAux6 for table "cEnq".

    CREATE QUERY hQueryAux7.
    create buffer hBufferAux7 for table "IPI".

    

    CREATE QUERY hQueryAux11.
    create buffer hBufferAux11 for table "II".

    CREATE QUERY hQueryAux19.
    create buffer hBufferAux19 for table "PISST".

    CREATE QUERY hQueryAux20.
    create buffer hBufferAux20 for table "COFINSST".

    CREATE QUERY hQueryAux21.
    create buffer hBufferAux21 for table "ICMS90".

    CREATE QUERY hQueryAux22.
    create buffer hBufferAux22 for table "CIDE".

    CREATE QUERY hQueryAux4.
    create buffer hBufferAux4 for table "PIS".

    CREATE QUERY hQueryAux5.
    create buffer hBufferAux5 for table "COFINS".

    CREATE QUERY hQueryAux12.
    create buffer hBufferAux12 for table "ISSQN".

    CREATE QUERY hQueryAux24.
    create buffer hBufferAux24 for table "TotalTrib".

    CREATE QUERY hQueryAux29.
    CREATE BUFFER hBufferAux29 FOR TABLE "ICMSUFDest".

    i-cont = 0.

    REPEAT:
        i-cont = i-cont + 1.

        /* criacao do numero det */
        hXML:create-node(hRecord, hBuffer:TABLE, "ELEMENT"). /* cria a estrutura det como um elemento */
        hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
        hText:NODE-VALUE = "~n ".
        hVersao:append-child(hText).
        hVersao:append-child(hRecord).

        hRecord:SET-ATTRIBUTE("nItem", STRING(i-cont)).

        hXML:CREATE-NODE(hText, "", "TEXT").
        hText:NODE-VALUE = "~n ".
        hRecord:APPEND-CHILD(hText).

        /* criaØ?o da sub-estrutura prod que pertence a estrutura det*/
        hQueryAux:SET-BUFFERS(hBufferAux).
        hQueryAux:QUERY-PREPARE("FOR EACH prod where prod.nItem = " + string(i-cont)).
        hQueryAux:query-open().
        hQueryAux:GET-FIRST().
        
        hXML:CREATE-NODE(hRecordAux, hBufferAux:TABLE, "ELEMENT"). /* cria a estrutura prod como um elemento */
        hXML:CREATE-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
        hText:NODE-VALUE = "~n ".
        hRecord:APPEND-CHILD(hText).
        hRecord:APPEND-CHILD(hRecordAux). /* encaixa o o prod dentro do det */

        /* impress?o dos campos do prod */
        bloco_campos_prod:

        DO iNumFields = 2 TO hBufferAux:NUM-FIELDS:

           IF hBufferAux:buffer-field(iNumFields):NAME = 'vDesc'    AND DEC(hBufferAux:buffer-field(iNumFields):buffer-value) = 0.00 THEN NEXT bloco_campos_prod.
           IF hBufferAux:buffer-field(iNumFields):NAME = 'vFrete'   AND DEC(hBufferAux:buffer-field(iNumFields):buffer-value) = 0.00 THEN NEXT bloco_campos_prod.
           IF hBufferAux:buffer-field(iNumFields):NAME = 'vSeg'     AND DEC(hBufferAux:buffer-field(iNumFields):buffer-value) = 0.00 THEN NEXT bloco_campos_prod.
           IF hBufferAux:buffer-field(iNumFields):NAME = 'vOutro'   AND DEC(hBufferAux:buffer-field(iNumFields):buffer-value) = 0.00 THEN NEXT bloco_campos_prod.           
           IF hBufferAux:buffer-field(iNumFields):NAME = 'EXTIPI'   AND DEC(hBufferAux:buffer-field(iNumFields):buffer-value) = 0.00 THEN NEXT bloco_campos_prod.
           IF hBufferAux:buffer-field(iNumFields):NAME = 'genero'   AND DEC(hBufferAux:buffer-field(iNumFields):buffer-value) = 0.00 THEN NEXT bloco_campos_prod.
           IF hBufferAux:buffer-field(iNumFields):NAME = 'xPed'     AND     hBufferAux:buffer-field(iNumFields):buffer-value  = ""   THEN NEXT bloco_campos_prod.
           IF hBufferAux:buffer-field(iNumFields):NAME = 'nItemPed' AND DEC(hBufferAux:buffer-field(iNumFields):buffer-value) = 0.00 THEN NEXT bloco_campos_prod.
           IF hBufferAux:buffer-field(iNumFields):NAME = 'nFCI'     AND     hBufferAux:buffer-field(iNumFields):buffer-value  = ""   THEN NEXT bloco_campos_prod.
           IF hBufferAux:buffer-field(iNumFields):NAME = 'NVE'      AND     hBufferAux:buffer-field(iNumFields):BUFFER-VALUE  = ""   THEN NEXT bloco_campos_prod.
           IF hBufferAux:buffer-field(iNumFields):NAME = 'CEST'     AND     hBufferAux:buffer-field(iNumFields):BUFFER-VALUE  = ""   THEN NEXT bloco_campos_prod.

           assign hField = hBufferAux:buffer-field(iNumFields).            

           /* The hText element is used just for create a new line after each element... */
           hXML:create-node(hText, "", "TEXT").
           hText:NODE-VALUE = "~n ".
           hRecordAux:append-child(hText).

           /* create the field name as element */ 
           hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
           hRecordAux:append-child(hFieldName).

           /* create the field value as text */
           hXML:create-node(hFieldValue, "text", 'TEXT').
           hFieldName:append-child(hFieldValue).
           hFieldValue:NODE-VALUE = hField:BUFFER-VALUE. 


           IF hBufferAux:buffer-field(iNumFields):NAME = 'indTot'THEN DO:

               hXML:create-node(hText, "", "TEXT").
               hText:NODE-VALUE = "~n ".
               hRecord:append-child(hText). 
        
                /* DI - Detalhamento de importacao */
                IF CAN-FIND(FIRST di) THEN DO:
                    hXML:create-node(hRecordAux2, hBufferAux9:TABLE, "ELEMENT"). /* cria a estrutura DI como um elemento */
                    hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
                    hText:node-value = "~n ".
                    hRecordAux2:append-child(hText).
                    hRecordAux:append-child(hRecordAux2). /* Encaixa o elemento imposto dentro da estrutura prod */
            
                    hQueryAux9:SET-BUFFERS(hBufferAux9).
                    hQueryAux9:query-prepare("FOR EACH DI").
                    hQueryAux9:query-open().
                    hQueryAux9:GET-FIRST().
            
                    /* impressao dos campos do DI*/
                    DO iNumFields2 = 1 TO hBufferAux9:NUM-FIELDS: 
                        
                        
                        assign hField = hBufferAux9:buffer-field(iNumFields2).
            
                        /* The hText element is used just for create a new line after each element... */ 
        
                        /*ignora campos caso estejam vazios */
                        IF hField:NAME = "vAFRMM"     AND hField:BUFFER-VALUE = "" THEN NEXT.
                        IF hField:NAME = "CNPJ"       AND hField:BUFFER-VALUE = "" THEN NEXT.
                        IF hField:NAME = "UFTerceiro" AND hField:BUFFER-VALUE = "" THEN NEXT.
        
                        hXML:CREATE-NODE(hText, "", "TEXT").
                        hText:NODE-VALUE = "~n ".
                        hRecordAux2:APPEND-CHILD(hText).
            
                        /* create the field name as element */ 
                        hXML:CREATE-NODE(hFieldName, hField:name, 'ELEMENT'). 
                        hRecordAux2:APPEND-CHILD(hFieldName). 
            
                        /* create the field value as text */ 
                        hXML:CREATE-NODE(hFieldValue, "text", 'TEXT'). 
                        hFieldName:APPEND-CHILD(hFieldValue).
                        hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
            
                        IF iNumFields2 = hBufferAux9:NUM-FIELDS THEN LEAVE.
                       
                    END.
            
                   IF CAN-FIND(FIRST adi) THEN DO:
                    
                       hXML:create-node(hRecordAux9, hBufferAux10:TABLE, "ELEMENT").
                       hXML:create-NODE(hText, "", "TEXT").
                       hText:node-value = "~n ".
                       hRecordAux9:append-child(hText).
                       hRecordAux2:append-child(hRecordAux9).
                 
                       hQueryAux10:set-buffers(hBufferAux10).
                       hQueryAux10:query-prepare("FOR EACH adi"). 
                       hQueryAux10:query-open(). 
                       hQueryAux10:get-first().
                       
                       campos_adi:
                       DO iNumFields2 = 1 TO hBufferAux10:NUM-FIELDS: 
                          
                           assign hField = hBufferAux10:buffer-field(iNumFields2).
                           IF hField:BUFFER-VALUE = "" OR hField:BUFFER-VALUE = ? THEN NEXT.
                 
                           hXML:CREATE-NODE(hText, "", "TEXT").
                           hText:NODE-VALUE = "~n ".
                           hRecordAux9:APPEND-CHILD(hText).
                 
                           hXML:CREATE-NODE(hFieldName, hField:name, 'ELEMENT'). 
                           hRecordAux9:APPEND-CHILD(hFieldName). 
                           hXML:CREATE-NODE(hFieldValue, "text", 'TEXT'). 
                           hFieldName:APPEND-CHILD(hFieldValue).
                           hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
                           
                           IF iNumFields2 = hBufferAux10:NUM-FIELDS THEN LEAVE.
               
                       END.
                   END.
                    /* Fim do DI */
                END.
            END.
        END.

        /* Fim do prod */   
        
        

        IF CAN-FIND(FIRST detExport) THEN DO:
                    
            /*CREATE QUERY hQueryAux25.
            CREATE BUFFER hBufferAux25 FOR TABLE "detExport".*/

            hQueryAux25:SET-BUFFERS(hBufferAux25).
            hQueryAux25:query-prepare("FOR EACH detExport").
            hQueryAux25:query-open().
            hQueryAux25:GET-FIRST().

            REPEAT:
                /*cria tag detExport de acordo com os registros da tt detExport*/
                hXML:create-node(hRecordAux2, hBufferAux25:TABLE, "ELEMENT"). /* cria a estrutura DI como um elemento */
                hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
                hText:node-value = "~n ".
                hRecordAux2:append-child(hText).
                hRecordAux:append-child(hRecordAux2). /* Encaixa o elemento imposto dentro da estrutura det */

                campos_detExport:
                DO iNumFields = 1 TO hBufferAux25:NUM-FIELDS: 
                    
                    assign hField = hBufferAux25:buffer-field(iNumFields).

                    IF hField:BUFFER-VALUE = "" OR hField:BUFFER-VALUE = ? THEN NEXT.

                    hXML:CREATE-NODE(hText, "", "TEXT").
                    hText:NODE-VALUE = "~n ".
                    hRecordAux2:APPEND-CHILD(hText).
                
                    hXML:CREATE-NODE(hFieldName, hField:name, 'ELEMENT'). 
                    hRecordAux2:APPEND-CHILD(hFieldName). 
                    hXML:CREATE-NODE(hFieldValue, "text", 'TEXT'). 
                    hFieldName:APPEND-CHILD(hFieldValue).
                    hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
                    
                    IF iNumFields = hBufferAux25:NUM-FIELDS THEN LEAVE.
                END.

                IF CAN-FIND(FIRST exportInd
                            WHERE exportInd.nDraw = hBufferAux25:BUFFER-FIELD("nDraw"):BUFFER-VALUE) THEN DO:
                    
                    /*cria tag detExport de acordo com os registros da tt exportInd*/

                    hQueryAux26:SET-BUFFERS(hBufferAux26).
                    hQueryAux26:QUERY-PREPARE("FOR EACH exportInd WHERE exportInd.nDraw = '" + hBufferAux25:BUFFER-FIELD("nDraw"):BUFFER-VALUE + "'").
                    hQueryAux26:QUERY-OPEN().
                    hQueryAux26:GET-FIRST().

                    hXML:CREATE-NODE(hRecordAux9, hBufferAux26:TABLE, "ELEMENT"). /* cria a estrutura DI como um elemento */
                    hXML:CREATE-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
                    hText:NODE-VALUE = "~n ".
                    hRecordAux9:APPEND-CHILD(hText).
                    hRecordAux2:APPEND-CHILD(hRecordAux9). /* Encaixa o elemento imposto dentro da estrutura det */

                    campos_exportInd:
                    DO iNumFields = 2 TO hBufferAux26:NUM-FIELDS: 
                        
                        assign hField = hBufferAux26:BUFFER-FIELD(iNumFields).
                        
                        hXML:CREATE-NODE(hText, "", "TEXT").
                        hText:NODE-VALUE = "~n ".
                        hRecordAux9:APPEND-CHILD(hText).
                    
                        hXML:CREATE-NODE(hFieldName, hField:name, 'ELEMENT'). 
                        hRecordAux9:APPEND-CHILD(hFieldName). 
                        hXML:CREATE-NODE(hFieldValue, "text", 'TEXT'). 
                        hFieldName:APPEND-CHILD(hFieldValue).
                        hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
                        
                        IF iNumFields = hBufferAux26:NUM-FIELDS THEN LEAVE.
                    END.
                END.

                hQueryAux25:GET-NEXT().                 
                if hQueryAux25:QUERY-OFF-END THEN LEAVE. 
            END.
        END.


        /* veicProd */
        IF CAN-FIND(FIRST veicProd
                    WHERE veicProd.nitem = i-cont) THEN DO:

            hXML:create-node(hRecordAux2, hBufferAux16:TABLE, "ELEMENT"). /* cria a estrutura DI como um elemento */
            hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
            hText:node-value = "~n ".
            hRecordAux2:append-child(hText).
            hRecordAux:append-child(hRecordAux2). /* Encaixa o elemento imposto dentro da estrutura det */
    
            hQueryAux16:SET-BUFFERS(hBufferAux16).
            hQueryAux16:query-prepare("FOR EACH veicProd where veicProd.nItem = " + string(i-cont)).
            hQueryAux16:query-open().
            hQueryAux16:GET-FIRST().

            /* impressao dos campos do MED*/
            DO iNumFields = 2 TO hBufferAux16:NUM-FIELDS: 
                
                assign hField = hBufferAux16:buffer-field(iNumFields).

                /* The hText element is used just for create a new line after each element... */ 
                hXML:CREATE-NODE(hText, "", "TEXT").
                hText:NODE-VALUE = "~n ".
                hRecordAux2:APPEND-CHILD(hText).
    
                /* create the field name as element */ 
                hXML:CREATE-NODE(hFieldName, hField:name, 'ELEMENT'). 
                hRecordAux2:APPEND-CHILD(hFieldName). 
    
                /* create the field value as text */ 
                hXML:CREATE-NODE(hFieldValue, "text", 'TEXT'). 
                hFieldName:APPEND-CHILD(hFieldValue).
                hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.

                IF iNumFields = hBufferAux16:NUM-FIELDS THEN LEAVE.
            END.
         END.

         /* med */
        IF CAN-FIND(FIRST med) THEN DO:
            hXML:create-node(hRecordAux2, hBufferAux15:TABLE, "ELEMENT"). 
            hXML:create-NODE(hText, "", "TEXT").
            hText:node-value = "~n ".
            hRecordAux2:append-child(hText).
            hRecordAux:append-child(hRecordAux2). /* Encaixa o elemento imposto dentro da estrutura det */
    
            hQueryAux15:SET-BUFFERS(hBufferAux15).
            hQueryAux15:query-prepare("FOR EACH med" ).
            hQueryAux15:query-open().
            hQueryAux15:GET-FIRST().
    
            /* impressao dos campos do MED*/
            DO iNumFields = 2 TO hBufferAux15:NUM-FIELDS: 
                
                assign hField = hBufferAux15:buffer-field(iNumFields).
    
                /* The hText element is used just for create a new line after each element... */ 
                hXML:CREATE-NODE(hText, "", "TEXT").
                hText:NODE-VALUE = "~n ".
                hRecordAux2:APPEND-CHILD(hText).
    
                /* create the field name as element */ 
                hXML:CREATE-NODE(hFieldName, hField:name, 'ELEMENT'). 
                hRecordAux2:APPEND-CHILD(hFieldName). 
    
                /* create the field value as text */ 
                hXML:CREATE-NODE(hFieldValue, "text", 'TEXT'). 
                hFieldName:APPEND-CHILD(hFieldValue).
                hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
    
                IF iNumFields = hBufferAux15:NUM-FIELDS THEN LEAVE.
            END.
         END.

         /* arma */
        IF CAN-FIND(FIRST arma) THEN DO:
            hXML:create-node(hRecordAux2, hBufferAux13:TABLE, "ELEMENT"). 
            hXML:create-NODE(hText, "", "TEXT").
            hText:node-value = "~n ".
            hRecordAux2:append-child(hText).
            hRecordAux:append-child(hRecordAux2). /* Encaixa o elemento imposto dentro da estrutura det */
    
            hQueryAux13:SET-BUFFERS(hBufferAux13).
            hQueryAux13:query-prepare("FOR EACH arma" ).
            hQueryAux13:query-open().
            hQueryAux13:GET-FIRST().
    
            /* impressao dos campos do DI*/
            DO iNumFields = 2 TO hBufferAux13:NUM-FIELDS: 
                
                assign hField = hBufferAux13:buffer-field(iNumFields).
    
                /* The hText element is used just for create a new line after each element... */ 
                hXML:CREATE-NODE(hText, "", "TEXT").
                hText:NODE-VALUE = "~n ".
                hRecordAux2:APPEND-CHILD(hText).
    
                /* create the field name as element */ 
                hXML:CREATE-NODE(hFieldName, hField:name, 'ELEMENT'). 
                hRecordAux2:APPEND-CHILD(hFieldName). 
    
                /* create the field value as text */ 
                hXML:CREATE-NODE(hFieldValue, "text", 'TEXT'). 
                hFieldName:APPEND-CHILD(hFieldValue).
                hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
    
                IF iNumFields = hBufferAux13:NUM-FIELDS THEN LEAVE.
            END.
         END.


        /* comb */
        IF CAN-FIND(FIRST comb) THEN DO:
            hXML:create-node(hRecordAux2, hBufferAux14:TABLE, "ELEMENT"). 
            hXML:create-NODE(hText, "", "TEXT").
            hText:node-value = "~n ".
            hRecordAux2:append-child(hText).
            hRecordAux:append-child(hRecordAux2). /* Encaixa o elemento imposto dentro da estrutura det */
    
            hQueryAux14:SET-BUFFERS(hBufferAux14).
            hQueryAux14:query-prepare("FOR EACH comb where comb.nItem = " + string(i-cont)).
            hQueryAux14:query-open().
            hQueryAux14:GET-FIRST().
    
            /* impressao dos campos do DI*/
            DO iNumFields = 2 TO hBufferAux14:NUM-FIELDS: 
                IF   hBufferAux14:buffer-field(iNumFields):NAME = 'CODIF'    
                AND (hBufferAux14:buffer-field(iNumFields):BUFFER-VALUE = ""
                OR   hBufferAux14:buffer-field(iNumFields):BUFFER-VALUE = ?) THEN NEXT.

                IF   hBufferAux14:buffer-field(iNumFields):NAME = 'pMixGN'    
                AND (hBufferAux14:buffer-field(iNumFields):BUFFER-VALUE = ""
                OR   hBufferAux14:buffer-field(iNumFields):BUFFER-VALUE = ?) THEN NEXT.

                IF   hBufferAux14:buffer-field(iNumFields):NAME = 'qTemp'    
                AND (hBufferAux14:buffer-field(iNumFields):BUFFER-VALUE = ""
                OR   hBufferAux14:buffer-field(iNumFields):BUFFER-VALUE = ?) THEN NEXT.

                assign hField = hBufferAux14:buffer-field(iNumFields).
    
                /* The hText element is used just for create a new line after each element... */ 
                hXML:CREATE-NODE(hText, "", "TEXT").
                hText:NODE-VALUE = "~n ".
                hRecordAux2:APPEND-CHILD(hText).
    
                /* create the field name as element */ 
                hXML:CREATE-NODE(hFieldName, hField:name, 'ELEMENT'). 
                hRecordAux2:APPEND-CHILD(hFieldName). 
    
                /* create the field value as text */ 
                hXML:CREATE-NODE(hFieldValue, "text", 'TEXT'). 
                hFieldName:APPEND-CHILD(hFieldValue).
                hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
    
                IF iNumFields = hBufferAux14:NUM-FIELDS THEN LEAVE.
            END.
         END.
       
         IF CAN-FIND(FIRST cide where cide.nItem = i-cont) THEN DO:
            hXML:create-node(hRecordAux2, hBufferAux22:TABLE, "ELEMENT"). 
            hXML:create-NODE(hText, "", "TEXT").
            hText:node-value = "~n ".
            hRecordAux2:append-child(hText).
            hRecordAux:append-child(hRecordAux2). /* Encaixa o elemento imposto dentro da estrutura det */
    
            hQueryAux22:SET-BUFFERS(hBufferAux22).
            hQueryAux22:query-prepare("FOR EACH cide where cide.nItem = " + string(i-cont)).
            hQueryAux22:query-open().
            hQueryAux22:GET-FIRST().
    
            /* impressao dos campos do DI*/
            DO iNumFields = 2 TO hBufferAux22:NUM-FIELDS: 
                
                assign hField = hBufferAux22:buffer-field(iNumFields).
    
                /* The hText element is used just for create a new line after each element... */ 
                hXML:CREATE-NODE(hText, "", "TEXT").
                hText:NODE-VALUE = "~n ".
                hRecordAux2:APPEND-CHILD(hText).
    
                /* create the field name as element */ 
                hXML:CREATE-NODE(hFieldName, hField:name, 'ELEMENT'). 
                hRecordAux2:APPEND-CHILD(hFieldName). 
    
                /* create the field value as text */ 
                hXML:CREATE-NODE(hFieldValue, "text", 'TEXT'). 
                hFieldName:APPEND-CHILD(hFieldValue).
                hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
    
                IF iNumFields = hBufferAux22:NUM-FIELDS THEN LEAVE.
            END.
         END.



        IF can-find(FIRST nRECOPI) THEN DO:

            FIND FIRST nRECOPI NO-ERROR.
            hXML:CREATE-NODE(hRecordAux2, hBufferAux27:TABLE, "ELEMENT"). 
            hXML:CREATE-NODE(hText, "", "TEXT").
            hText:NODE-VALUE = nRECOPI.nRECOPI.
            hRecordAux2:APPEND-CHILD(hText).
            hRecordAux:APPEND-CHILD(hRecordAux2). /* Encaixa o elemento imposto dentro da estrutura det */
    
            /*
            CREATE QUERY hQueryAux27.
            create buffer hBufferAux27 for table "nRECOPI".
            */
        END.

        /*CREATE QUERY hQueryAux2.
        create buffer hBufferAux2 for table "imposto".*/
        
      
        /* imposto */
        hXML:create-node(hRecordAux, hBufferAux2:TABLE, "ELEMENT"). /* cria a estrutura imposto como um elemento */
        hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
        hText:NODE-VALUE = "~n ".
        hRecordAux:append-child(hText).
        hRecord:append-child(hRecordAux). /* Encaixa o elemento imposto dentro da estrutura det */

        /* imposto Total Tributos */
/*         IF CAN-FIND(FIRST TotalTrib where TotalTrib.nItem = i-cont) THEN DO: */
/*             hXML:create-node(hRecordAux2, hBufferAux24:TABLE, "ELEMENT").                                  */
/*             hXML:create-NODE(hText, "", "TEXT").                                                           */
/*             hText:node-value = "~n ".                                                                      */
/*             hRecordAux2:append-child(hText).                                                               */
/*             hRecordAux:append-child(hRecordAux2). /* Encaixa o elemento imposto dentro da estrutura det */ */
    
            hQueryAux24:SET-BUFFERS(hBufferAux24).
            hQueryAux24:query-prepare("FOR EACH TotalTrib where TotalTrib.nItem = " + string(i-cont)).
            hQueryAux24:query-open().
            hQueryAux24:GET-FIRST().
    
            /* impressao dos campos de Total Tributos */
            DO iNumFields = 2 TO hBufferAux24:NUM-FIELDS: 
                
                assign hField = hBufferAux24:buffer-field(iNumFields).
    
                /* The hText element is used just for create a new line after each element... */ 
                hXML:CREATE-NODE(hText, "", "TEXT").
                hText:NODE-VALUE = "~n ".
                hRecordAux:APPEND-CHILD(hText).
    
                /* create the field name as element */ 
                hXML:CREATE-NODE(hFieldName, hField:name, 'ELEMENT'). 
                hRecordAux:APPEND-CHILD(hFieldName). 
    
                /* create the field value as text */ 
                hXML:CREATE-NODE(hFieldValue, "text", 'TEXT'). 
                hFieldName:APPEND-CHILD(hFieldValue).
                hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
    
                IF iNumFields = hBufferAux24:NUM-FIELDS THEN LEAVE.
            END.
/*         END. */

        /* ISSQN(sub-estrutura de imposto) */
        IF CAN-FIND(FIRST ISSQN WHERE ISSQN.nItem = i-cont) THEN DO:
        hXML:create-node(hRecordAux2, "ISSQN" , "ELEMENT"). /* cria a estrutura ISS como um elemento */
        hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
        hText:NODE-VALUE = "~n ".
        hRecordAux:append-child(hText).
        hRecordAux:append-child(hRecordAux2). /* encaixa a estrutura ISS dentro do imposto */

        hQueryAux12:SET-BUFFERS(hBufferAux12).
        hQueryAux12:query-prepare("FOR EACH ISSQN where ISSQN.nItem = " + string(i-cont)). /* */
        hQueryAux12:query-open().
        hQueryAux12:GET-FIRST().
        
            DO iNumFields = 2 TO hBufferAux12:NUM-FIELDS: 
                assign hField = hBufferAux12:BUFFER-FIELD(iNumFields).
    
                /*campos n∆o obrigat¢rios */
                IF   (hBufferAux12:buffer-field(iNumFields):NAME = 'vDeducao'    
                OR    hBufferAux12:buffer-field(iNumFields):NAME = 'vOutros'
                OR    hBufferAux12:buffer-field(iNumFields):NAME = 'vDescIncond'
                OR    hBufferAux12:buffer-field(iNumFields):NAME = 'vDescCond'
                OR    hBufferAux12:buffer-field(iNumFields):NAME = 'vDescCond'
                OR    hBufferAux12:buffer-field(iNumFields):NAME = 'vISSRet'      
                OR    hBufferAux12:buffer-field(iNumFields):NAME = 'cServico'       
                OR    hBufferAux12:buffer-field(iNumFields):NAME = 'cMun'      
                OR    hBufferAux12:buffer-field(iNumFields):NAME = 'cPais'      
                OR    hBufferAux12:buffer-field(iNumFields):NAME = 'nProcesso')
                AND  (hBufferAux12:buffer-field(iNumFields):BUFFER-VALUE = ""
                OR    hBufferAux12:buffer-field(iNumFields):BUFFER-VALUE = ?) THEN NEXT.

                /* The hText element is used just for create a new line after each element... */ 
                hXML:create-node(hText, "", "TEXT").
                hText:NODE-VALUE = "~n ".
                hRecordAux2:append-child(hText).
                
                /* create the field name as element */ 
                hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
                hRecordAux2:append-child(hFieldName).
                
                /* create the field value as text */ 
                hXML:create-node(hFieldValue, "text", 'TEXT').  
                hFieldName:append-child(hFieldValue).
                hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
            END.
        END.

        

        IF NOT CAN-FIND(FIRST ISSQN WHERE ISSQN.nItem = i-cont) THEN DO:
    
            IF NOT CAN-FIND(FIRST ICMS90 WHERE ICMS90.nItem = i-cont) THEN DO:
                /* ICMS(sub-estrutura de imposto */        
                hXML:create-node(hRecordAux2, "ICMS" , "ELEMENT"). /* cria a estrutura ICMS como um elemento */
                hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
                hText:NODE-VALUE = "~n ".
                hRecordAux:append-child(hText).
                hRecordAux:append-child(hRecordAux2). /* Encaixa o elemento ICMS dentro da estrutura imposto */
                
                hQueryAux3:SET-BUFFERS(hBufferAux3).
                hQueryAux3:query-prepare("FOR EACH ICMS where ICMS.nItem = " + string(i-cont)).
                hQueryAux3:query-open().
                hQueryAux3:GET-FIRST().
                
                /* ICMS00(sub-estrutura de ICMS) */
                hXML:create-node(hRecordAux3, "ICMS" + hBufferAux3:buffer-field(17):BUFFER-VALUE , "ELEMENT"). /* cria a estrutura imposto como um elemento */
                hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
                hText:NODE-VALUE = "~n ".
                hRecordAux3:append-child(hText).
                hRecordAux2:append-child(hRecordAux3).
        
                assign hField = hBufferAux3:BUFFER-FIELD(17).
        
                ASSIGN c-valor = hField:BUFFER-VALUE.
                
                CASE c-valor:
                    WHEN "00" THEN DO:
                    
                        ASSIGN l-ICMS[1]  = NO   /* nItem        */  
                               l-ICMS[2]  = YES  /* orig         */  
                               l-ICMS[3]  = YES  /* CST          */  
                               l-ICMS[4]  = YES  /* modBC        */  
                               l-ICMS[5]  = NO   /* pRedBC       */  
                               l-ICMS[6]  = YES  /* vBC          */  
                               l-ICMS[7]  = YES  /* pICMS        */  
                               l-ICMS[8]  = YES  /* vICMS        */  
                               l-ICMS[9]  = NO   /* modBCST      */                                 
                               l-ICMS[10] = NO   /* pMVAST       */  
                               l-ICMS[11] = NO   /* pRedBCST     */  
                               l-ICMS[12] = NO   /* vBCST        */  
                               l-ICMS[13] = NO   /* pICMSST      */  
                               l-ICMS[14] = NO   /* vICMSST      */  
                               l-ICMS[15] = NO   /* vBCSTRet     */  
                               l-ICMS[16] = NO   /* vICMSSTRet   */  
                               l-ICMS[17] = NO   /* cTag         */  
                               l-ICMS[18] = NO   /* pBCOp        */  
                               l-ICMS[19] = NO   /* UFST         */  
                               l-ICMS[20] = NO   /* vBCSTDest    */  
                               l-ICMS[21] = NO   /* vICMSSTDest  */  
                               l-ICMS[22] = NO   /* CSOSN        */  
                               l-ICMS[23] = NO   /* pCredSN      */  
                               l-ICMS[24] = NO   /* vCredICMSSN  */  
                               l-ICMS[25] = NO   /* vICMSDeson   */
                               l-ICMS[26] = NO   /* MotDesICMS   */  
                               l-ICMS[27] = NO   /* vICMSOp      */
                               l-ICMS[28] = NO   /* pDif         */
                               l-ICMS[29] = NO.  /* vICMSDif     */
                    END.          
                    WHEN "10" THEN DO:
                        ASSIGN l-ICMS[1]  = NO    /* nItem        */  
                               l-ICMS[2]  = YES   /* orig         */  
                               l-ICMS[3]  = YES   /* CST          */  
                               l-ICMS[4]  = YES   /* modBC        */  
                               l-ICMS[5]  = NO    /* pRedBC       */  
                               l-ICMS[6]  = YES   /* vBC          */  
                               l-ICMS[7]  = YES   /* pICMS        */  
                               l-ICMS[8]  = YES   /* vICMS        */  
                               l-ICMS[9]  = YES   /* modBCST      */                                  
                               l-ICMS[10] = YES   /* pMVAST       */  
                               l-ICMS[11] = YES   /* pRedBCST     */  
                               l-ICMS[12] = YES   /* vBCST        */  
                               l-ICMS[13] = YES   /* pICMSST      */  
                               l-ICMS[14] = YES   /* vICMSST      */  
                               l-ICMS[15] = NO    /* vBCSTRet     */  
                               l-ICMS[16] = NO    /* vICMSSTRet   */  
                               l-ICMS[17] = NO    /* cTag         */  
                               l-ICMS[18] = NO    /* pBCOp        */  
                               l-ICMS[19] = NO    /* UFST         */  
                               l-ICMS[20] = NO    /* vBCSTDest    */  
                               l-ICMS[21] = NO    /* vICMSSTDest  */  
                               l-ICMS[22] = NO    /* CSOSN        */  
                               l-ICMS[23] = NO    /* pCredSN      */  
                               l-ICMS[24] = NO    /* vCredICMSSN  */  
                               l-ICMS[25] = NO    /* vICMSDeson   */
                               l-ICMS[26] = NO    /* MotDesICMS   */ 
                               l-ICMS[27] = NO    /* vICMSOp      */
                               l-ICMS[28] = NO    /* pDif         */
                               l-ICMS[29] = NO.   /* vICMSDif     */
        
                        /* pMVAST e pRedVBCST nao devem ser omitidos se for zero */


                        ASSIGN hField = hBufferAux3:BUFFER-FIELD(9).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN
                            ASSIGN l-ICMS[9]  = NO.

                        assign hField = hBufferAux3:buffer-field(10).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN
                            ASSIGN l-ICMS[10]  = NO.
                        
                        assign hField = hBufferAux3:buffer-field(11).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN                            
                            ASSIGN l-ICMS[11]  = NO.

                    END.
                    WHEN "20" THEN DO:
                    
                        ASSIGN l-ICMS[1]  = NO      /* nItem        */  
                               l-ICMS[2]  = YES     /* orig         */  
                               l-ICMS[3]  = YES     /* CST          */  
                               l-ICMS[4]  = YES     /* modBC        */  
                               l-ICMS[5]  = YES     /* pRedBC       */  
                               l-ICMS[6]  = YES     /* vBC          */  
                               l-ICMS[7]  = YES     /* pICMS        */  
                               l-ICMS[8]  = YES     /* vICMS        */  
                               l-ICMS[9]  = NO      /* modBCST      */                                   
                               l-ICMS[10] = NO      /* pMVAST       */  
                               l-ICMS[11] = NO      /* pRedBCST     */  
                               l-ICMS[12] = NO      /* vBCST        */  
                               l-ICMS[13] = NO      /* pICMSST      */  
                               l-ICMS[14] = NO      /* vICMSST      */  
                               l-ICMS[15] = NO      /* vBCSTRet     */  
                               l-ICMS[16] = NO      /* vICMSSTRet   */  
                               l-ICMS[17] = NO      /* cTag         */  
                               l-ICMS[18] = NO      /* pBCOp        */  
                               l-ICMS[19] = NO      /* UFST         */  
                               l-ICMS[20] = NO      /* vBCSTDest    */  
                               l-ICMS[21] = NO      /* vICMSSTDest  */  
                               l-ICMS[22] = NO      /* CSOSN        */  
                               l-ICMS[23] = NO      /* pCredSN      */  
                               l-ICMS[24] = NO      /* vCredICMSSN  */  
                               l-ICMS[25] = YES     /* vICMSDeson   */                               
                               l-ICMS[26] = YES     /* MotDesICMS   */
                               l-ICMS[27] = NO      /* vICMSOp      */
                               l-ICMS[28] = NO      /* pDif         */
                               l-ICMS[29] = NO.     /* vICMSDif     */
        
                    END.
                    WHEN "30" THEN DO:
                    
                        ASSIGN l-ICMS[1]  = NO    /* nItem        */  
                               l-ICMS[2]  = YES   /* orig         */  
                               l-ICMS[3]  = YES   /* CST          */  
                               l-ICMS[4]  = NO    /* modBC        */  
                               l-ICMS[5]  = NO    /* pRedBC       */  
                               l-ICMS[6]  = NO    /* vBC          */  
                               l-ICMS[7]  = NO    /* pICMS        */  
                               l-ICMS[8]  = NO    /* vICMS        */  
                               l-ICMS[9]  = YES   /* modBCST      */                                   
                               l-ICMS[10] = YES   /* pMVAST       */  
                               l-ICMS[11] = YES   /* pRedBCST     */  
                               l-ICMS[12] = YES   /* vBCST        */  
                               l-ICMS[13] = YES   /* pICMSST      */  
                               l-ICMS[14] = YES   /* vICMSST      */  
                               l-ICMS[15] = NO    /* vBCSTRet     */  
                               l-ICMS[16] = NO    /* vICMSSTRet   */  
                               l-ICMS[17] = NO    /* cTag         */  
                               l-ICMS[18] = NO    /* pBCOp        */  
                               l-ICMS[19] = NO    /* UFST         */  
                               l-ICMS[20] = NO    /* vBCSTDest    */  
                               l-ICMS[21] = NO    /* vICMSSTDest  */  
                               l-ICMS[22] = NO    /* CSOSN        */  
                               l-ICMS[23] = NO    /* pCredSN      */  
                               l-ICMS[24] = NO    /* vCredICMSSN  */  
                               l-ICMS[25] = YES   /* vICMSDeson   */                               
                               l-ICMS[26] = YES   /* MotDesICMS   */
                               l-ICMS[27] = NO    /* vICMSOp      */
                               l-ICMS[28] = NO    /* pDif         */
                               l-ICMS[29] = NO.   /* vICMSDif     */
        
                        assign hField = hBufferAux3:buffer-field(10).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN
                            ASSIGN l-ICMS[10]  = NO.

                        assign hField = hBufferAux3:buffer-field(11).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN
                            ASSIGN l-ICMS[11]  = NO.
        
                    END.
                    WHEN "40" THEN DO:
                    
                        ASSIGN l-ICMS[1]  = NO    /* nItem        */  
                               l-ICMS[2]  = YES   /* orig         */  
                               l-ICMS[3]  = YES   /* CST          */  
                               l-ICMS[4]  = NO    /* modBC        */  
                               l-ICMS[5]  = NO    /* pRedBC       */  
                               l-ICMS[6]  = NO    /* vBC          */  
                               l-ICMS[7]  = NO    /* pICMS        */  
                               l-ICMS[8]  = NO    /* vICMS        */  
                               l-ICMS[9]  = NO    /* modBCST      */                                 
                               l-ICMS[10] = NO    /* pMVAST       */  
                               l-ICMS[11] = NO    /* pRedBCST     */  
                               l-ICMS[12] = NO    /* vBCST        */  
                               l-ICMS[13] = NO    /* pICMSST      */  
                               l-ICMS[14] = NO    /* vICMSST      */  
                               l-ICMS[15] = NO    /* vBCSTRet     */  
                               l-ICMS[16] = NO    /* vICMSSTRet   */  
                               l-ICMS[17] = NO    /* cTag         */  
                               l-ICMS[18] = NO    /* pBCOp        */  
                               l-ICMS[19] = NO    /* UFST         */  
                               l-ICMS[20] = NO    /* vBCSTDest    */  
                               l-ICMS[21] = NO    /* vICMSSTDest  */  
                               l-ICMS[22] = NO    /* CSOSN        */  
                               l-ICMS[23] = NO    /* pCredSN      */  
                               l-ICMS[24] = NO    /* vCredICMSSN  */  
                               l-ICMS[25] = YES   /* vICMSDeson   */                               
                               l-ICMS[26] = YES   /* MotDesICMS   */  
                               l-ICMS[27] = NO    /* vICMSOp      */
                               l-ICMS[28] = NO    /* pDif         */
                               l-ICMS[29] = NO.   /* vICMSDif     */

                    END.
                    WHEN "41" THEN DO:
                    
                         ASSIGN l-ICMS[1]  = NO    /* nItem        */  
                                l-ICMS[2]  = YES   /* orig         */  
                                l-ICMS[3]  = YES   /* CST          */  
                                l-ICMS[4]  = NO    /* modBC        */  
                                l-ICMS[5]  = NO    /* pRedBC       */  
                                l-ICMS[6]  = NO    /* vBC          */  
                                l-ICMS[7]  = NO    /* pICMS        */  
                                l-ICMS[8]  = NO    /* vICMS        */  
                                l-ICMS[9]  = NO    /* modBCST      */                                  
                                l-ICMS[10] = NO    /* pMVAST       */  
                                l-ICMS[11] = NO    /* pRedBCST     */  
                                l-ICMS[12] = NO    /* vBCST        */  
                                l-ICMS[13] = NO    /* pICMSST      */  
                                l-ICMS[14] = NO    /* vICMSST      */  
                                l-ICMS[15] = NO    /* vBCSTRet     */  
                                l-ICMS[16] = NO    /* vICMSSTRet   */  
                                l-ICMS[17] = NO    /* cTag         */  
                                l-ICMS[18] = NO    /* pBCOp        */  
                                l-ICMS[19] = NO    /* UFST         */  
                                l-ICMS[20] = NO    /* vBCSTDest    */  
                                l-ICMS[21] = NO    /* vICMSSTDest  */  
                                l-ICMS[22] = NO    /* CSOSN        */  
                                l-ICMS[23] = NO    /* pCredSN      */  
                                l-ICMS[24] = NO    /* vCredICMSSN  */  
                                l-ICMS[25] = YES   /* vICMSDeson   */                                
                                l-ICMS[26] = YES   /* MotDesICMS   */  
                                l-ICMS[27] = NO    /* vICMSOp      */
                                l-ICMS[28] = NO    /* pDif         */
                                l-ICMS[29] = NO.   /* vICMSDif     */
        
                        /* vICMS e MotDesICMS nao devem ser omitidos se for zero */
                        assign hField = hBufferAux3:buffer-field(8).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN
                            ASSIGN l-ICMS[8]  = NO.
                        
                        assign hField = hBufferAux3:buffer-field(10).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN
                            ASSIGN l-ICMS[10]  = NO.
                    END.
                    WHEN "50" THEN DO:
                    
                         ASSIGN l-ICMS[1]  = NO    /* nItem        */  
                                l-ICMS[2]  = YES   /* orig         */  
                                l-ICMS[3]  = YES   /* CST          */  
                                l-ICMS[4]  = NO    /* modBC        */  
                                l-ICMS[5]  = NO    /* pRedBC       */  
                                l-ICMS[6]  = NO    /* vBC          */  
                                l-ICMS[7]  = NO    /* pICMS        */  
                                l-ICMS[8]  = YES   /* vICMS        */  
                                l-ICMS[9]  = NO    /* modBCST      */                                  
                                l-ICMS[10] = NO    /* pMVAST       */  
                                l-ICMS[11] = NO    /* pRedBCST     */  
                                l-ICMS[12] = NO    /* vBCST        */  
                                l-ICMS[13] = NO    /* pICMSST      */  
                                l-ICMS[14] = NO    /* vICMSST      */  
                                l-ICMS[15] = NO    /* vBCSTRet     */  
                                l-ICMS[16] = NO    /* vICMSSTRet   */  
                                l-ICMS[17] = NO    /* cTag         */  
                                l-ICMS[18] = NO    /* pBCOp        */  
                                l-ICMS[19] = NO    /* UFST         */  
                                l-ICMS[20] = NO    /* vBCSTDest    */  
                                l-ICMS[21] = NO    /* vICMSSTDest  */  
                                l-ICMS[22] = NO    /* CSOSN        */  
                                l-ICMS[23] = NO    /* pCredSN      */  
                                l-ICMS[24] = NO    /* vCredICMSSN  */
                                l-ICMS[25] = NO    /* vICMSDeson   */
                                l-ICMS[26] = NO    /* MotDesICMS   */  
                                l-ICMS[27] = NO    /* vICMSOp      */
                                l-ICMS[28] = NO    /* pDif         */
                                l-ICMS[29] = NO.   /* vICMSDif     */
        
                        /* vICMS e MotDesICMS nao devem ser omitidos se for zero */
                        assign hField = hBufferAux3:buffer-field(8).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN
                            ASSIGN l-ICMS[8]  = NO.
                        
                        assign hField = hBufferAux3:buffer-field(10).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN
                            ASSIGN l-ICMS[10]  = NO.
                    END.
                    WHEN "51" THEN DO:
                    
                        ASSIGN l-ICMS[1]  = NO    /* nItem        */  
                               l-ICMS[2]  = YES   /* orig         */  
                               l-ICMS[3]  = YES   /* CST          */  
                               l-ICMS[4]  = YES   /* modBC        */  
                               l-ICMS[5]  = YES   /* pRedBC       */  
                               l-ICMS[6]  = YES   /* vBC          */  
                               l-ICMS[7]  = YES   /* pICMS        */  
                               l-ICMS[8]  = NO    /* vICMS        */  /* N∆o imprimir vICMS por conta de sequencia errada */
                               l-ICMS[9]  = NO    /* modBCST      */                                 
                               l-ICMS[10] = NO    /* pMVAST       */  
                               l-ICMS[11] = NO    /* pRedBCST     */  
                               l-ICMS[12] = NO    /* vBCST        */  
                               l-ICMS[13] = NO    /* pICMSST      */  
                               l-ICMS[14] = NO    /* vICMSST      */  
                               l-ICMS[15] = NO    /* vBCSTRet     */  
                               l-ICMS[16] = NO    /* vICMSSTRet   */  
                               l-ICMS[17] = NO    /* cTag         */  
                               l-ICMS[18] = NO    /* pBCOp        */  
                               l-ICMS[19] = NO    /* UFST         */  
                               l-ICMS[20] = NO    /* vBCSTDest    */  
                               l-ICMS[21] = NO    /* vICMSSTDest  */  
                               l-ICMS[22] = NO    /* CSOSN        */  
                               l-ICMS[23] = NO    /* pCredSN      */  
                               l-ICMS[24] = NO    /* vCredICMSSN  */  
                               l-ICMS[25] = NO    /* vICMSDeson   */
                               l-ICMS[26] = NO    /* MotDesICMS   */  
                               l-ICMS[27] = YES   /* vICMSOp      */
                               l-ICMS[28] = YES   /* pDif         */
                               l-ICMS[29] = YES.  /* vICMSDif     */

                        /* Campos opcionais: 4-modBC, 5-pRedBC, 6-vBC, 13-pICMS, 14-vICMS */
                        assign hField = hBufferAux3:buffer-field(4).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN
                            ASSIGN l-ICMS[4]  = NO.
        
                        assign hField = hBufferAux3:buffer-field(5).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN
                            ASSIGN l-ICMS[5]  = NO.
        
                        assign hField = hBufferAux3:buffer-field(6).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN
                            ASSIGN l-ICMS[6]  = NO.
        
                        assign hField = hBufferAux3:buffer-field(7).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN
                            ASSIGN l-ICMS[7]  = NO.
        
                        assign hField = hBufferAux3:buffer-field(8).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN
                            ASSIGN l-ICMS[8]  = NO.

                        assign hField = hBufferAux3:buffer-field(27).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN
                            ASSIGN l-ICMS[27]  = NO.

                        assign hField = hBufferAux3:buffer-field(28).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN
                            ASSIGN l-ICMS[28]  = NO.

                        assign hField = hBufferAux3:buffer-field(29).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN
                            ASSIGN l-ICMS[29]  = NO.
        
                    END.
                    WHEN "60" THEN DO:
                        ASSIGN l-ICMS[1]  = NO      /* nItem        */
                               l-ICMS[2]  = YES     /* orig         */
                               l-ICMS[3]  = YES     /* CST          */
                               l-ICMS[4]  = NO      /* modBC        */
                               l-ICMS[5]  = NO      /* pRedBC       */
                               l-ICMS[6]  = NO      /* vBC          */
                               l-ICMS[7]  = NO      /* pICMS        */
                               l-ICMS[8]  = NO      /* vICMS        */
                               l-ICMS[9]  = NO      /* modBCST      */
                               l-ICMS[10] = NO      /* pMVAST       */
                               l-ICMS[11] = NO      /* pRedBCST     */
                               l-ICMS[12] = NO      /* vBCST        */
                               l-ICMS[13] = NO      /* pICMSST      */
                               l-ICMS[14] = NO      /* vICMSST      */
                               l-ICMS[15] = YES     /* vBCSTRet     */
                               l-ICMS[16] = YES     /* vICMSSTRet   */
                               l-ICMS[17] = NO      /* cTag         */
                               l-ICMS[18] = NO      /* pBCOp        */
                               l-ICMS[19] = NO      /* UFST         */
                               l-ICMS[20] = NO      /* vBCSTDest    */
                               l-ICMS[21] = NO      /* vICMSSTDest  */
                               l-ICMS[22] = NO      /* CSOSN        */
                               l-ICMS[23] = NO      /* pCredSN      */
                               l-ICMS[24] = NO      /* vCredICMSSN  */
                               l-ICMS[25] = NO      /* vICMSDeson   */
                               l-ICMS[26] = NO      /* MotDesICMS   */
                               l-ICMS[27] = NO      /* vICMSOp      */
                               l-ICMS[28] = NO      /* pDif         */
                               l-ICMS[29] = NO.     /* vICMSDif     */
                      /*  assign hField = hBufferAux3:buffer-field(16).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN
                            ASSIGN l-ICMS[16]  = NO.
                        assign hField = hBufferAux3:buffer-field(17).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN
                            ASSIGN l-ICMS[17]  = NO.*/
                    END.
                    WHEN "70" THEN DO:
                    
                        ASSIGN l-ICMS[1]  = NO    /* nItem        */  
                               l-ICMS[2]  = YES   /* orig         */  
                               l-ICMS[3]  = YES   /* CST          */  
                               l-ICMS[4]  = YES   /* modBC        */  
                               l-ICMS[5]  = YES   /* pRedBC       */  
                               l-ICMS[6]  = YES   /* vBC          */  
                               l-ICMS[7]  = YES   /* pICMS        */  
                               l-ICMS[8]  = YES   /* vICMS        */  
                               l-ICMS[9]  = YES   /* modBCST      */  
                               l-ICMS[10] = YES   /* pMVAST       */  
                               l-ICMS[11] = YES   /* pRedBCST     */  
                               l-ICMS[12] = YES   /* vBCST        */  
                               l-ICMS[13] = YES   /* pICMSST      */  
                               l-ICMS[14] = YES   /* vICMSST      */  
                               l-ICMS[15] = NO    /* vBCSTRet     */  
                               l-ICMS[16] = NO    /* vICMSSTRet   */  
                               l-ICMS[17] = NO    /* cTag         */  
                               l-ICMS[18] = NO    /* pBCOp        */  
                               l-ICMS[19] = NO    /* UFST         */  
                               l-ICMS[20] = NO    /* vBCSTDest    */  
                               l-ICMS[21] = NO    /* vICMSSTDest  */  
                               l-ICMS[22] = NO    /* CSOSN        */  
                               l-ICMS[23] = NO    /* pCredSN      */  
                               l-ICMS[24] = NO    /* vCredICMSSN  */  
                               l-ICMS[25] = YES   /* vICMSDeson   */
                               l-ICMS[26] = YES   /* MotDesICMS   */  
                               l-ICMS[27] = NO    /* vICMSOp      */
                               l-ICMS[28] = NO    /* pDif         */
                               l-ICMS[29] = NO.   /* vICMSDif     */
        
                        /* pMVAST e pRedVBCST nao devem ser omitidos se for zero */
                        assign hField = hBufferAux3:buffer-field(12).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN
                            ASSIGN l-ICMS[12]  = NO.
                        
                        assign hField = hBufferAux3:buffer-field(11).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN
                            ASSIGN l-ICMS[11]  = NO.
                    END.
                    WHEN "150" THEN DO:
                        ASSIGN l-ICMS[1]  = NO      /* nItem        */
                               l-ICMS[2]  = YES     /* orig         */
                               l-ICMS[3]  = YES     /* CST          */
                               l-ICMS[4]  = YES     /* modBC        */
                               l-ICMS[5]  = YES     /* pRedBC       */
                               l-ICMS[6]  = YES     /* vBC          */
                               l-ICMS[7]  = YES     /* pICMS        */
                               l-ICMS[8]  = YES     /* vICMS        */
                               l-ICMS[9]  = YES     /* modBCST      */
                               l-ICMS[10] = NO      /* MotDesICMS   */
                               l-ICMS[11] = YES     /* pMVAST       */
                               l-ICMS[12] = YES     /* pRedBCST     */
                               l-ICMS[13] = YES     /* vBCST        */
                               l-ICMS[14] = YES     /* pICMSST      */
                               l-ICMS[15] = YES     /* vICMSST      */
                               l-ICMS[16] = NO      /* vBCSTRet     */
                               l-ICMS[17] = NO      /* vICMSSTRet   */
                               l-ICMS[18] = NO      /* cTag         */
                               l-ICMS[19] = YES     /* pBCOp        */
                               l-ICMS[20] = YES     /* UFST         */
                               l-ICMS[21] = NO      /* vBCSTDest    */
                               l-ICMS[22] = NO      /* vICMSSTDest  */
                               l-ICMS[23] = NO      /* CSOSN        */
                               l-ICMS[24] = NO      /* pCredSN      */
                               l-ICMS[25] = NO.     /* vCredICMSSN  */
                        
                        /* pRedBC, pMVAST e pRedVBCST nao devem ser omitidos se for zero */
                        assign hField = hBufferAux3:buffer-field(5).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN
                            ASSIGN l-ICMS[5]  = NO.
        
                        assign hField = hBufferAux3:buffer-field(12).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN
                            ASSIGN l-ICMS[12]  = NO.
                        
                        assign hField = hBufferAux3:buffer-field(11).
                        ASSIGN c-valor = hField:BUFFER-VALUE.
                        IF c-valor = '' OR c-valor = '0.00' OR INT(c-valor) = 0 THEN
                            ASSIGN l-ICMS[11]  = NO.
                    END.
                    WHEN "151" THEN DO:
                        ASSIGN l-ICMS[1]  = NO      /* nItem        */
                               l-ICMS[2]  = YES     /* orig         */
                               l-ICMS[3]  = YES     /* CST          */
                               l-ICMS[4]  = NO      /* modBC        */
                               l-ICMS[5]  = NO      /* pRedBC       */
                               l-ICMS[6]  = NO      /* vBC          */
                               l-ICMS[7]  = NO      /* pICMS        */
                               l-ICMS[8]  = NO      /* vICMS        */
                               l-ICMS[9]  = NO      /* modBCST      */
                               l-ICMS[10] = NO      /* MotDesICMS   */
                               l-ICMS[11] = NO      /* pMVAST       */
                               l-ICMS[12] = NO      /* pRedBCST     */
                               l-ICMS[13] = NO      /* vBCST        */
                               l-ICMS[14] = NO      /* pICMSST      */
                               l-ICMS[15] = NO      /* vICMSST      */
                               l-ICMS[16] = YES     /* vBCSTRet     */
                               l-ICMS[17] = YES     /* vICMSSTRet   */
                               l-ICMS[18] = NO      /* cTag         */
                               l-ICMS[19] = NO      /* pBCOp        */
                               l-ICMS[20] = NO      /* UFST         */
                               l-ICMS[21] = YES     /* vBCSTDest    */
                               l-ICMS[22] = YES     /* vICMSSTDest  */
                               l-ICMS[23] = NO      /* CSOSN        */
                               l-ICMS[24] = NO      /* pCredSN      */
                               l-ICMS[25] = NO.     /* vCredICMSSN  */
                    END.
                    WHEN "SN101" THEN DO:
                        ASSIGN l-ICMS[1]  = NO      /* nItem        */
                               l-ICMS[2]  = YES     /* orig         */
                               l-ICMS[3]  = NO      /* CST          */
                               l-ICMS[4]  = NO      /* modBC        */
                               l-ICMS[5]  = NO      /* pRedBC       */
                               l-ICMS[6]  = NO      /* vBC          */
                               l-ICMS[7]  = NO      /* pICMS        */
                               l-ICMS[8]  = NO      /* vICMS        */
                               l-ICMS[9]  = NO      /* modBCST      */
                               l-ICMS[10] = NO      /* MotDesICMS   */
                               l-ICMS[11] = NO      /* pMVAST       */
                               l-ICMS[12] = NO      /* pRedBCST     */
                               l-ICMS[13] = NO      /* vBCST        */
                               l-ICMS[14] = NO      /* pICMSST      */
                               l-ICMS[15] = NO      /* vICMSST      */
                               l-ICMS[16] = NO      /* vBCSTRet     */
                               l-ICMS[17] = NO      /* vICMSSTRet   */
                               l-ICMS[18] = NO      /* cTag         */
                               l-ICMS[19] = NO      /* pBCOp        */
                               l-ICMS[20] = NO      /* UFST         */
                               l-ICMS[21] = NO      /* vBCSTDest    */
                               l-ICMS[22] = NO      /* vICMSSTDest  */
                               l-ICMS[23] = YES     /* CSOSN        */
                               l-ICMS[24] = YES     /* pCredSN      */
                               l-ICMS[25] = YES.    /* vCredICMSSN  */
                    END.
                    OTHERWISE DO:
                    
                        ASSIGN l-ICMS[1]  = NO     /* nItem        */  
                               l-ICMS[2]  = YES    /* orig         */  
                               l-ICMS[3]  = YES    /* CST          */  
                               l-ICMS[4]  = YES    /* modBC        */  
                               l-ICMS[5]  = NO     /* pRedBC       */  
                               l-ICMS[6]  = YES    /* vBC          */  
                               l-ICMS[7]  = YES    /* pICMS        */  
                               l-ICMS[8]  = YES    /* vICMS        */  
                               l-ICMS[9]  = NO     /* modBCST      */  
                               l-ICMS[10] = NO     /* MotDesICMS   */  
                               l-ICMS[11] = NO     /* pMVAST       */  
                               l-ICMS[12] = NO     /* pRedBCST     */  
                               l-ICMS[13] = NO     /* vBCST        */  
                               l-ICMS[14] = NO     /* pICMSST      */  
                               l-ICMS[15] = NO     /* vICMSST      */  
                               l-ICMS[16] = NO     /* vBCSTRet     */  
                               l-ICMS[17] = NO     /* vICMSSTRet   */  
                               l-ICMS[18] = NO     /* cTag         */  
                               l-ICMS[19] = NO     /* pBCOp        */  
                               l-ICMS[20] = NO     /* UFST         */  
                               l-ICMS[21] = NO     /* vBCSTDest    */  
                               l-ICMS[22] = NO     /* vICMSSTDest  */  
                               l-ICMS[23] = NO     /* CSOSN        */  
                               l-ICMS[24] = NO     /* pCredSN      */  
                               l-ICMS[25] = NO.    /* vCredICMSSN  */  
                    END.            
                END CASE.
        
                /* impressao dos campos do ICMS00/ICMS10... */
                loop_gera_tags:
                DO iNumFields = 2 TO hBufferAux3:NUM-FIELDS: 
                           
                    assign hField = hBufferAux3:buffer-field(iNumFields).
        
                    IF l-ICMS[iNumFields] THEN DO:

                        /*campos n∆o obrigat¢rios pra todos as tags */
                        IF (iNumFields = 10
                        OR  iNumFields = 25
                        OR  iNumFields = 26)
                        AND hField:BUFFER-VALUE = "" THEN
                            NEXT loop_gera_tags.

                        /* ICMS 51 - ACERTO DE POSIÄ«O DOS CAMPOS */
                        
                        /*FIM*/

                        /* The hText element is used just for create a new line after each element... */ 
                        hXML:CREATE-NODE(hText, "", "TEXT").
                        hText:NODE-VALUE = "~n ".
                        hRecordAux3:APPEND-CHILD(hText).
                        
                        /* create the field name as element */ 
                        hXML:CREATE-NODE(hFieldName, hField:name, 'ELEMENT'). 
                        hRecordAux3:APPEND-CHILD(hFieldName). 
        
                        /* create the field value as text */ 
                        hXML:CREATE-NODE(hFieldValue, "text", 'TEXT'). 
                        hFieldName:APPEND-CHILD(hFieldValue).
                        hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.                        
															
                    END.

                    /*QUANDO FOR ICMS 51 IMPRIME vICMS NO FINAL DAS TAGS - alteraá∆o realizada para n∆o conflitar com outras tags */
                    IF hBufferAux3:BUFFER-FIELD(17):BUFFER-VALUE = "51"
                    AND iNumFields = 29 THEN DO:

                        ASSIGN hField = hBufferAux3:BUFFER-FIELD(8).

                        IF hField:BUFFER-VALUE = "" OR hField:BUFFER-VALUE = "0.00" THEN NEXT loop_gera_tags.
                        /* The hText element is used just for create a new line after each element... */ 
                        hXML:CREATE-NODE(hText, "", "TEXT").
                        hText:NODE-VALUE = "~n ".
                        hRecordAux3:APPEND-CHILD(hText).
                        
                        /* create the field name as element */ 
                        hXML:CREATE-NODE(hFieldName, hField:name, 'ELEMENT'). 
                        hRecordAux3:APPEND-CHILD(hFieldName). 
        
                        /* create the field value as text */ 
                        hXML:CREATE-NODE(hFieldValue, "text", 'TEXT'). 
                        hFieldName:APPEND-CHILD(hFieldValue).
                        hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.

                    END.
					
					IF iNumFields = hBufferAux3:NUM-FIELDS THEN
                        LEAVE.
                END.
            END.

            /*ICMS 90*/
            IF CAN-FIND(FIRST ICMS90 WHERE ICMS90.nItem = i-cont) THEN DO:
            /* ICMS(sub-estrutura de imposto */        
            hXML:create-node(hRecordAux2, "ICMS" , "ELEMENT"). /* cria a estrutura ICMS como um elemento */
            hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
            hText:NODE-VALUE = "~n ".
            hRecordAux:append-child(hText).
            hRecordAux:append-child(hRecordAux2). /* Encaixa o elemento ICMS dentro da estrutura imposto */   

            hXML:create-node(hRecordAux3, "ICMS90" , "ELEMENT"). /* cria a estrutura II como um elemento */
            hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
            hText:NODE-VALUE = "~n ".
            hRecordAux3:append-child(hText).
            hRecordAux2:append-child(hRecordAux3). /* encaixa a estrutura ICMS90 dentro do ICMS */
    
            hQueryAux21:SET-BUFFERS(hBufferAux21).
            hQueryAux21:query-prepare("FOR EACH ICMS90 where ICMS90.nItem = " + string(i-cont)). /* */
            hQueryAux21:query-open().
            hQueryAux21:GET-FIRST().
            
                DO iNumFields = 1 TO hBufferAux21:NUM-FIELDS: 
                    assign hField = hBufferAux21:BUFFER-FIELD(iNumFields).
        
                    IF hBufferAux21:buffer-field(iNumFields):NAME = 'nItem' THEN NEXT.  
                    IF hBufferAux21:buffer-field(iNumFields):NAME = 'cTag' THEN NEXT.

                    IF hBufferAux21:buffer-field(iNumFields):NAME = 'pRedBC'     AND hBufferAux21:buffer-field(iNumFields):BUFFER-VALUE = '' THEN NEXT.
                    IF hBufferAux21:buffer-field(iNumFields):NAME = 'pRedBC'     AND hBufferAux21:buffer-field(iNumFields):BUFFER-VALUE = '0.00' THEN NEXT.
                    IF hBufferAux21:buffer-field(iNumFields):NAME = 'pMVAST'     AND hBufferAux21:buffer-field(iNumFields):BUFFER-VALUE = '' THEN NEXT.
                    IF hBufferAux21:buffer-field(iNumFields):NAME = 'pRedBCST'   AND hBufferAux21:buffer-field(iNumFields):BUFFER-VALUE = '' THEN NEXT.
                    IF hBufferAux21:buffer-field(iNumFields):NAME = 'vICMSDeson' AND hBufferAux21:buffer-field(iNumFields):BUFFER-VALUE = '' THEN NEXT.
                    IF hBufferAux21:buffer-field(iNumFields):NAME = 'motDesICMS' AND hBufferAux21:buffer-field(iNumFields):BUFFER-VALUE = '' THEN NEXT.
                    
                    /* The hText element is used just for create a new line after each element... */ 
                    hXML:create-node(hText, "", "TEXT").
                    hText:NODE-VALUE = "~n ".
                    hRecordAux3:append-child(hText).
                    
                    /* create the field name as element */ 
                    hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
                    hRecordAux3:append-child(hFieldName).
                    
                    /* create the field value as text */ 
                    hXML:CREATE-NODE(hFieldValue, "TEXT", 'TEXT').  
                    hFieldName:APPEND-CHILD(hFieldValue).
                    hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
                END.
            END.
    
            
            IF CAN-FIND(FIRST IPI
                        WHERE IPI.nItem = i-cont) THEN DO:

            
                /* IPI(sub-estrutura de imposto) */
                hXML:create-node(hRecordAux9, "IPI" , "ELEMENT"). /* cria a estrutura IPI como um elemento */
                hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
                hText:node-value = "~n ".
                hRecordAux:append-child(hText).
                hRecordAux:append-child(hRecordAux9). /* Encaixa o elemento IPI dentro da estrutura imposto */
            
                hQueryAux7:SET-BUFFERS(hBufferAux7).
                hQueryAux7:query-prepare("FOR EACH IPI where IPI.nItem = " + string(i-cont)).
                hQueryAux7:query-open().
                hQueryAux7:GET-FIRST().
        
                DO iNumFields = 2 TO 6:
                           
                    IF hBufferAux7:buffer-field(iNumFields):buffer-value = '' THEN NEXT.
                
                    assign hField = hBufferAux7:buffer-field(iNumFields).
            
                    /* The hText element is used just for create a new line after each element... */
                    hXML:create-node(hText, "", "TEXT").
                    hText:node-value = "~n ".
                    hRecordAux9:append-child(hText).
          
                    /* create the field name as element */
                    hXML:create-node(hFieldName, hField:name, 'ELEMENT').
                    hRecordAux9:append-child(hFieldName). 
          
                    /* create the field value as text */
                    hXML:create-node(hFieldValue, "text", 'TEXT').
                    hFieldName:append-child(hFieldValue).
                    hFieldValue:node-value = hField:BUFFER-VALUE.
          
                END. 
            END.

            find first IPI where IPI.nItem = i-cont no-error.
            IF  avail ipi 
            and (ipi.cst = '01'
             or ipi.cst = '02'
             or ipi.cst = '03'
             or ipi.cst = '04'
             or ipi.cst = '05'
             or ipi.cst = '51'
             or ipi.cst = '52'
             or ipi.cst = '53'
             or ipi.cst = '54'
             or ipi.cst = '55') then do:
                hXML:create-node(hRecordAux4, "IPINT" , "ELEMENT"). /* cria a estrutura IPINT como um elemento */
                hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
                hText:node-value = "~n ".
                hRecordAux4:append-child(hText).
                hRecordAux9:append-child(hRecordAux4). /* Encaixa o elemento IPINT dentro da estrutura IPI */               
				
            end.
            else do:
                hXML:create-node(hRecordAux4, "IPITrib" , "ELEMENT"). /* cria a estrutura IPITrib como um elemento */
                hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
                hText:node-value = "~n ".
                hRecordAux4:append-child(hText).
                hRecordAux9:append-child(hRecordAux4). /* Encaixa o elemento IPITrib dentro da estrutura IPI */       
            END.    
    
            DO iNumFields = 7 TO hBufferAux7:NUM-FIELDS:
                
                IF hBufferAux7:buffer-field(iNumFields):buffer-value = '' THEN NEXT.
				
                assign hField = hBufferAux7:buffer-field(iNumFields).
        
                /* The hText element is used just for create a new line after each element... */
                hXML:create-node(hText, "", "TEXT").
                hText:node-value = "~n ".
                hRecordAux4:append-child(hText).
      
                /* create the field name as element */
                hXML:create-node(hFieldName, hField:name, 'ELEMENT').
                hRecordAux4:append-child(hFieldName). 
      
                /* create the field value as text */
                hXML:create-node(hFieldValue, "text", 'TEXT').
                hFieldName:append-child(hFieldValue).
                hFieldValue:node-value = hField:BUFFER-VALUE.
      
            END. 
            
            /* II(sub-estrutura de imposto) */
            IF CAN-FIND(FIRST II) THEN DO:
            hXML:create-node(hRecordAux2, "II" , "ELEMENT"). /* cria a estrutura II como um elemento */
            hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
            hText:NODE-VALUE = "~n ".
            hRecordAux:append-child(hText).
            hRecordAux:append-child(hRecordAux2). /* encaixa a estrutura II dentro do imposto */
    
            hQueryAux11:SET-BUFFERS(hBufferAux11).
            hQueryAux11:query-prepare("FOR EACH II where II.nItem = " + string(i-cont)). /* */
            hQueryAux11:query-open().
            hQueryAux11:GET-FIRST().
            
                DO iNumFields = 2 TO hBufferAux11:NUM-FIELDS: 
                    assign hField = hBufferAux11:BUFFER-FIELD(iNumFields).
        
                    /* The hText element is used just for create a new line after each element... */ 
                    hXML:create-node(hText, "", "TEXT").
                    hText:NODE-VALUE = "~n ".
                    hRecordAux2:append-child(hText).
                    
                    /* create the field name as element */ 
                    hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
                    hRecordAux2:append-child(hFieldName).
                    
                    /* create the field value as text */ 
                    hXML:create-node(hFieldValue, "text", 'TEXT').  
                    hFieldName:append-child(hFieldValue).
                    hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
                END.
            END.

        END.

        FOR EACH PIS 
            WHERE PIS.nItem = i-cont.
            CASE PIS.cst.
                WHEN '01' OR
                WHEN '02' THEN
                    ASSIGN c-pis = "Aliq".
                WHEN '03' THEN
                    ASSIGN c-pis = "Qtde".
                WHEN '04' OR
                WHEN '06' OR                
                WHEN '07' OR
                WHEN '08' OR
                WHEN '09' THEN
                    ASSIGN c-pis = "NT".
                OTHERWISE
                    ASSIGN c-pis = "Outr". 
            END CASE.
        end.
        
        /* PIS(sub-estrutura de imposto) */
        hXML:create-node(hRecordAux2, "PIS" , "ELEMENT"). /* cria a estrutura PIS como um elemento */
        hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
        hText:NODE-VALUE = "~n ".
        hRecordAux:append-child(hText).
        hRecordAux:append-child(hRecordAux2). /* encaixa a estrutura PIS dentro do imposto */

        hQueryAux4:SET-BUFFERS(hBufferAux4).
        hQueryAux4:query-prepare("FOR EACH PIS where PIS.nItem = " + string(i-cont)).
        hQueryAux4:query-open().
        hQueryAux4:GET-FIRST().

        /*IF hBufferAux4:buffer-field(2):BUFFER-VALUE = "01" OR
           hBufferAux4:buffer-field(2):BUFFER-VALUE = "02" THEN DO:
            ASSIGN c-pis = "Aliq".
        END.

        IF hBufferAux4:buffer-field(2):BUFFER-VALUE = "03" THEN DO:
            ASSIGN c-pis = "Qtde".
        END.
                    
        IF hBufferAux4:buffer-field(2):BUFFER-VALUE = "04" OR 
           hBufferAux4:buffer-field(2):BUFFER-VALUE = "06" OR
           hBufferAux4:buffer-field(2):BUFFER-VALUE = "07" OR
           hBufferAux4:buffer-field(2):BUFFER-VALUE = "08" OR
           hBufferAux4:buffer-field(2):BUFFER-VALUE = "09" THEN DO:
            ASSIGN c-pis = "NT".
        END.
         
        IF hBufferAux4:buffer-field(2):BUFFER-VALUE = "99" THEN DO:
            ASSIGN c-pis = "Outr".
        END.*/
        
        /* PISAliq(sub-estrutura de PIS) */
        hXML:create-node(hRecordAux3, "PIS" + c-pis , "ELEMENT"). /* cria a estrutura imposto como um elemento */
        hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
        hText:NODE-VALUE = "~n ".
        hRecordAux3:append-child(hText).
        hRecordAux2:append-child(hRecordAux3). /* encaixa a estrutura PISAliq dentro da estrutura PIS */

        ASSIGN iNumFields = 1.

        /* case pra saber quais campos imprimir */
        CASE c-pis:
            WHEN "Aliq" THEN
                ASSIGN l-PIS[1] = NO
                       l-PIS[2] = YES
                       l-PIS[3] = YES
                       l-PIS[4] = YES
                       l-PIS[5] = NO
                       l-PIS[6] = NO
                       l-PIS[7] = YES.
            WHEN "Qtde" THEN
                ASSIGN l-PIS[1] = NO
                       l-PIS[2] = YES
                       l-PIS[3] = NO
                       l-PIS[4] = NO
                       l-PIS[5] = YES
                       l-PIS[6] = YES
                       l-PIS[7] = YES.
            WHEN "NT" THEN
                ASSIGN l-PIS[1] = NO
                       l-PIS[2] = YES
                       l-PIS[3] = NO
                       l-PIS[4] = NO
                       l-PIS[5] = NO
                       l-PIS[6] = NO
                       l-PIS[7] = NO.
            WHEN "Outr" THEN
                ASSIGN l-PIS[1] = NO
                       l-PIS[2] = YES
                       l-PIS[3] = YES
                       l-PIS[4] = YES
                       l-PIS[5] = YES
                       l-PIS[6] = YES
                       l-PIS[7] = YES.
        END CASE.        
         
        DO iNumFields = 2 TO hBufferAux4:NUM-FIELDS: 
            assign hField = hBufferAux4:BUFFER-FIELD(iNumFields).

             
            IF l-PIS[iNumFields] THEN DO:
            
                IF hBufferAux4:buffer-field(iNumFields):BUFFER-VALUE = '' THEN NEXT.

                /* The hText element is used just for create a new line after each element... */ 
                hXML:create-node(hText, "", "TEXT").
                hText:NODE-VALUE = "~n ".
                hRecordAux3:append-child(hText).
                
                /* create the field name as element */ 
                hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
                hRecordAux3:append-child(hFieldName).
                
                /* create the field value as text */ 
                hXML:create-node(hFieldValue, "text", 'TEXT').  
                hFieldName:append-child(hFieldValue).
                hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
                
            END.         
        END. 
        /* Fim do PIS */

        /*PISST*/
        IF CAN-FIND(FIRST PISST) THEN DO:
        hXML:create-node(hRecordAux2, "PISST" , "ELEMENT"). /* cria a estrutura II como um elemento */
        hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
        hText:NODE-VALUE = "~n ".
        hRecordAux:append-child(hText).
        hRecordAux:append-child(hRecordAux2). /* encaixa a estrutura II dentro do imposto */

        hQueryAux19:SET-BUFFERS(hBufferAux19).
        hQueryAux19:query-prepare("FOR EACH PISST"). /* */
        hQueryAux19:query-open().
        hQueryAux19:GET-FIRST().
        
            DO iNumFields = 1 TO hBufferAux19:NUM-FIELDS: 
                assign hField = hBufferAux19:BUFFER-FIELD(iNumFields).
    
                IF hBufferAux19:buffer-field(iNumFields):NAME = 'nItem' THEN NEXT.
                IF hBufferAux19:buffer-field(iNumFields):BUFFER-VALUE = '' THEN NEXT.

                /* The hText element is used just for create a new line after each element... */ 
                hXML:create-node(hText, "", "TEXT").
                hText:NODE-VALUE = "~n ".
                hRecordAux2:append-child(hText).
                
                /* create the field name as element */ 
                hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
                hRecordAux2:append-child(hFieldName).
                
                /* create the field value as text */ 
                hXML:create-node(hFieldValue, "text", 'TEXT').  
                hFieldName:append-child(hFieldValue).
                hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
            END.
        END.

        FOR EACH COFINS 
            WHERE COFINS.nItem = i-cont.
            CASE COFINS.cst.
                WHEN '01' OR
                WHEN '02' THEN
                    ASSIGN c-cofins = "Aliq".
                WHEN '03' THEN
                    ASSIGN c-cofins = "Qtde".
                WHEN '04' OR
                WHEN '06' OR                
                WHEN '07' OR
                WHEN '08' OR
                WHEN '09' THEN
                    ASSIGN c-cofins = "NT".
                OTHERWISE
                    ASSIGN c-cofins = "Outr". 
            END CASE.
        end.
               
        /* Inicio do COFINS(sub-estrutura de imposto) */
        hXML:create-node(hRecordAux2, "COFINS" , "ELEMENT"). /* cria a estrutura PIS como um elemento */
        hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
        hText:NODE-VALUE = "~n ".
        hRecordAux:append-child(hText).
        hRecordAux:append-child(hRecordAux2). /* encaixa a estrutura COFINS dentro do imposto */

        hQueryAux5:SET-BUFFERS(hBufferAux5).
        hQueryAux5:query-prepare("FOR EACH COFINS where COFINS.nItem = " + string(i-cont)).
        hQueryAux5:query-open().
        hQueryAux5:GET-FIRST().

        /*IF hBufferAux4:buffer-field(2):BUFFER-VALUE = "01" OR
           hBufferAux4:buffer-field(2):BUFFER-VALUE = "02" THEN DO:
            ASSIGN c-cofins = "Aliq".
        END.

        IF hBufferAux4:buffer-field(2):BUFFER-VALUE = "03" THEN DO:
            ASSIGN c-cofins = "Qtde".
        END.
                    
        IF hBufferAux4:buffer-field(2):BUFFER-VALUE = "04" OR 
           hBufferAux4:buffer-field(2):BUFFER-VALUE = "06" OR
           hBufferAux4:buffer-field(2):BUFFER-VALUE = "07" OR
           hBufferAux4:buffer-field(2):BUFFER-VALUE = "08" OR
           hBufferAux4:buffer-field(2):BUFFER-VALUE = "09" THEN DO:
            ASSIGN c-cofins = "NT".
        END.
         
        IF hBufferAux4:buffer-field(2):BUFFER-VALUE = "99" THEN DO:
            ASSIGN c-cofins = "Outr".
        END.*/
        
        /* COFINSAliq(sub-estrutura de COFINS) */
        hXML:create-node(hRecordAux3, "COFINS" + c-cofins , "ELEMENT"). /* cria a estrutura COFINSAliq como um elemento */
        hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
        hText:NODE-VALUE = "~n ".
        hRecordAux3:append-child(hText).
        hRecordAux2:append-child(hRecordAux3). /* encaixa a estrutura COFINSAliq dentro da estrutura COFINS */

        ASSIGN iNumFields = 1.

        /* case pra saber quais campos imprimir */
        CASE c-cofins:
            WHEN "Aliq" THEN
                ASSIGN l-cofins[1] = NO
                       l-cofins[2] = YES
                       l-cofins[3] = YES
                       l-cofins[4] = YES
                       l-cofins[5] = NO
                       l-cofins[6] = NO
                       l-cofins[7] = YES.
            WHEN "Qtde" THEN
                ASSIGN l-cofins[1] = NO
                       l-cofins[2] = YES
                       l-cofins[3] = NO
                       l-cofins[4] = NO
                       l-cofins[5] = YES
                       l-cofins[6] = YES
                       l-cofins[7] = YES.
            WHEN "NT" THEN
                ASSIGN l-cofins[1] = NO
                       l-cofins[2] = YES
                       l-cofins[3] = NO
                       l-cofins[4] = NO
                       l-cofins[5] = NO
                       l-cofins[6] = NO
                       l-cofins[7] = NO.
            WHEN "Outr" THEN
                ASSIGN l-cofins[1] = NO
                       l-cofins[2] = YES
                       l-cofins[3] = YES
                       l-cofins[4] = YES
                       l-cofins[5] = YES
                       l-cofins[6] = YES
                       l-cofins[7] = YES.
        END CASE.

        DO iNumFields = 2 TO hBufferAux5:NUM-FIELDS: 
            assign hField = hBufferAux5:buffer-field(iNumFields).  

            IF l-COFINS[iNumFields] THEN DO:
            
            IF hBufferAux5:buffer-field(iNumFields):BUFFER-VALUE = '' THEN NEXT.

            /* The hText element is used just for create a new line after each element... */ 
                hXML:create-node(hText, "", "TEXT").
                hText:NODE-VALUE = "~n ".
                hRecordAux3:append-child(hText).
                
                /* create the field name as element */ 
                hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
                hRecordAux3:append-child(hFieldName). 
                
                if hField:BUFFER-VALUE = ?  then do:
                    assign hField:BUFFER-VALUE = 0.
                    leave.
                end.    
                
                /* create the field value as text */ 
                hXML:create-node(hFieldValue, "text", 'TEXT'). 
                hFieldName:append-child(hFieldValue).
                hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.            
            
            END.  
        END. 
        /* Fim do COFINS */

        /*COFINSST*/
        IF CAN-FIND(FIRST COFINSST) THEN DO:
        hXML:create-node(hRecordAux2, "COFINSST" , "ELEMENT"). /* cria a estrutura II como um elemento */
        hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
        hText:NODE-VALUE = "~n ".
        hRecordAux:append-child(hText).
        hRecordAux:append-child(hRecordAux2). /* encaixa a estrutura II dentro do imposto */

        hQueryAux20:SET-BUFFERS(hBufferAux20).
        hQueryAux20:query-prepare("FOR EACH COFINSST"). /* */
        hQueryAux20:query-open().
        hQueryAux20:GET-FIRST().
        
            DO iNumFields = 1 TO hBufferAux20:NUM-FIELDS: 
                assign hField = hBufferAux20:BUFFER-FIELD(iNumFields).
    
                IF hBufferAux20:buffer-field(iNumFields):NAME = 'nItem' THEN NEXT.
                IF hBufferAux19:buffer-field(iNumFields):BUFFER-VALUE = '' THEN NEXT.

                /* The hText element is used just for create a new line after each element... */ 
                hXML:create-node(hText, "", "TEXT").
                hText:NODE-VALUE = "~n ".
                hRecordAux2:append-child(hText).
                
                /* create the field name as element */ 
                hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
                hRecordAux2:append-child(hFieldName).
                
                /* create the field value as text */ 
                hXML:create-node(hFieldValue, "text", 'TEXT').  
                hFieldName:append-child(hFieldValue).
                hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
            END.
        END.

         hXML:create-node(hText, "", "TEXT").
         hText:NODE-VALUE = "~n ". 
         hRecord:append-child(hText). 
                                        
         find first det where det.nItem = i-cont no-lock no-error.
         if avail det then do:
             if det.infAdProd <> '' then do:

                 DO iNumFields = 1 TO hBuffer:NUM-FIELDS: 
    
                    assign hField = hBuffer:BUFFER-FIELD(iNumFields).
    
                    IF hField:NAME <> 'infAdProd' THEN DO:
    
                        IF hBuffer:buffer-field(iNumFields):NAME = 'infAdProd' THEN DO:
                            /* The hText element is used just for create a new line after each element... */ 
                            hXML:create-node(hText, "", "TEXT").
                            hText:NODE-VALUE = "~n ".
                            hRecord:append-child(hText).
    
                            /* create the field name as element */ 
                            hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
                            hRecord:append-child(hFieldName).
    
                            /* create the field value as text */ 
                            hXML:create-node(hFieldValue, "text", 'TEXT').  
                            hFieldName:append-child(hFieldValue).
                            hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
                        END.
    
                    END.
                    ELSE DO:
                        /* The hText element is used just for create a new line after each element... */ 
                        hXML:create-node(hText, "", "TEXT").
                        hText:NODE-VALUE = "~n ".
                        hRecord:append-child(hText).
    
                        /* create the field name as element */ 
                        hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
                        hRecord:append-child(hFieldName).
    
                        /* create the field value as text */ 
                        hXML:create-node(hFieldValue, "text", 'TEXT').  
                        hFieldName:append-child(hFieldValue).
                        hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
                    END.
    
                END.

             end. /* if det.infAdProd <> '' then do: */
         end. /* if avail det then do: */

         /*ICMSUFDest*/
         IF CAN-FIND(FIRST ICMSUFDest
                     WHERE ICMSUFDest.nItem = i-cont) THEN DO:
    
             /* IPI(sub-estrutura de imposto) */
             hXML:CREATE-NODE(hRecordAux29, "ICMSUFDest" , "ELEMENT"). /* cria a estrutura IPI como um elemento */
             hXML:CREATE-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
             hText:NODE-VALUE = "~n ".
             hRecordAux:APPEND-CHILD(hText).
             hRecordAux:APPEND-CHILD(hRecordAux29). /* Encaixa o elemento IPI dentro da estrutura imposto */
         
             hQueryAux29:SET-BUFFERS(hBufferAux29).
             hQueryAux29:query-prepare("FOR EACH ICMSUFDest where ICMSUFDest.nItem = " + string(i-cont)).
             hQueryAux29:query-open().
             hQueryAux29:GET-FIRST().
     
             DO iNumFields = 2 TO 9:
                        
                 IF hBufferAux29:buffer-field(iNumFields):buffer-value = '' THEN NEXT.
             
                 assign hField = hBufferAux29:buffer-field(iNumFields).
         
                 /* The hText element is used just for create a new line after each element... */
                 hXML:create-node(hText, "", "TEXT").
                 hText:node-value = "~n ".
                 hRecordAux29:append-child(hText).
       
                 /* create the field name as element */
                 hXML:create-node(hFieldName, hField:name, 'ELEMENT').
                 hRecordAux29:append-child(hFieldName). 
       
                 /* create the field value as text */
                 hXML:create-node(hFieldValue, "text", 'TEXT').
                 hFieldName:append-child(hFieldValue).
                 hFieldValue:node-value = hField:BUFFER-VALUE.
       
             END. 
         END.
     
     
          
         hQuery:get-next(). 
         IF i-cont = iItem THEN LEAVE.

        if hQuery:query-off-end then leave. 
        
    END.   
    
    hQuery:QUERY-CLOSE().
    DELETE OBJECT hQuery.
    DELETE WIDGET hBuffer.
    
    hQueryAux:QUERY-CLOSE().
    DELETE OBJECT hQueryAux.
    DELETE WIDGET hBufferAux.

    hQueryAux2:QUERY-CLOSE().
    DELETE OBJECT hQueryAux2.
    DELETE WIDGET hBufferAux2.

    hQueryAux3:QUERY-CLOSE().
    DELETE OBJECT hQueryAux3.
    DELETE WIDGET hBufferAux3.

    hQueryAux4:QUERY-CLOSE().
    DELETE OBJECT hQueryAux4.
    DELETE WIDGET hBufferAux4.

    hQueryAux5:QUERY-CLOSE().
    DELETE OBJECT hQueryAux5.
    DELETE WIDGET hBufferAux5.

    hQueryAux6:QUERY-CLOSE().
    DELETE OBJECT hQueryAux6.
    DELETE WIDGET hBufferAux6.

    hQueryAux7:QUERY-CLOSE().
    DELETE OBJECT hQueryAux7.
    DELETE WIDGET hBufferAux7.

    hQueryAux9:QUERY-CLOSE().
    DELETE OBJECT hQueryAux9.
    DELETE WIDGET hBufferAux9.

    hQueryAux10:QUERY-CLOSE().
    DELETE OBJECT hQueryAux10.
    DELETE WIDGET hBufferAux10.
    
    hQueryAux11:QUERY-CLOSE().
    DELETE OBJECT hQueryAux11.
    DELETE WIDGET hBufferAux11.

    hQueryAux13:QUERY-CLOSE().
    DELETE OBJECT hQueryAux13.
    DELETE WIDGET hBufferAux13.

    hQueryAux14:QUERY-CLOSE().
    DELETE OBJECT hQueryAux14.
    DELETE WIDGET hBufferAux14.

    hQueryAux15:QUERY-CLOSE().
    DELETE OBJECT hQueryAux15.
    DELETE WIDGET hBufferAux15.

    hQueryAux24:QUERY-CLOSE().
    DELETE OBJECT hQueryAux24.
    DELETE WIDGET hBufferAux24.

END PROCEDURE.


PROCEDURE gerarTabelaDentroDeOutraXMLobscont:
    
    DEFINE INPUT PARAM cTable     AS CHAR NO-UNDO. /* Tabela da estrutura a ser criada */
    DEFINE INPUT PARAM hParam     AS HANDLE NO-UNDO. /* Em qual estrutura ela vai entrar */                      

    create query hQueryAux23.
    create buffer hBufferAux23 for table 'obsCont'.
    
    hQueryAux23:set-buffers(hBufferAux23).
    hQueryAux23:query-prepare("FOR EACH " + hBufferAux23:TABLE).
    hQueryAux23:query-open(). 
    hQueryAux23:get-first().

    REPEAT:
    
        ASSIGN i-cont-obs = i-cont-obs + 1.
        IF i-cont-obs > 10 THEN LEAVE.


        hXML:CREATE-NODE(hRecordAux23, hBufferAux23:TABLE, "ELEMENT").

        If hBufferAux23:buffer-field(1):Buffer-value = 'maildest' 
        Or hBufferAux23:buffer-field(1):Buffer-value = 'mailTransp' Then
            hRecordAux23:SET-ATTRIBUTE("xCampo","E_MAIL").
        Else
            hRecordAux23:SET-ATTRIBUTE("xCampo",hBufferAux23:buffer-field(1):Buffer-value).

        hXML:CREATE-NODE(hText, "", "TEXT").
        hText:NODE-VALUE = "~n ".             
        hParam:APPEND-CHILD(hText).
        hParam:APPEND-CHILD(hRecordAux23).
        
        bloco_NFref:
        DO iNumFieldsAux2 = 2 TO hBufferAux23:NUM-FIELDS:                               
        
            assign hField = hBufferAux23:buffer-field(iNumFieldsAux2).
        
            /* In order to improve performance, decrease the .xml file size the fields 
            with a "" value will be not added as element */
           
                  
            /* The hText element is used just for create a new line after each element... */ 
            hXML:create-node(hText, "", "TEXT").
            hText:NODE-VALUE = "~n ".
            hRecordAux23:append-child(hText).
            
            /* create the field name as element */ 
            hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
            hRecordAux23:append-child(hFieldName). 
            
            /* create the field value as text */ 
            hXML:create-node(hFieldValue, "text", 'TEXT'). 
            hFieldName:append-child(hFieldValue).
            hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
        END.
        
       /* hXML:create-node(hText, "", "TEXT"). 
        hText:NODE-VALUE = "~n ". 
        hRecordAux23:append-child(hText).   */     
        
        hQueryAux23:get-next(). 
        if hQueryAux23:query-off-end then leave.
    END.

    /* Fim do REPEAT da estrutura */

    hQueryAux23:QUERY-CLOSE().
    DELETE OBJECT hQueryAux23.
    DELETE WIDGET hBufferAux23.     
    
END PROCEDURE.

PROCEDURE gerarTabelaDentroDeOutraXML:

    /* Purpose: Gerar uma estrutura a partir de uma tabela, podendo escolher em qual estrutura ela vai entrar.
                Porque se nao ela entra no no da hVersao
       Notes: E chamada na procedure XML-Gera*/

    /*estrutura*/
    DEFINE INPUT PARAM cTable     AS CHAR NO-UNDO. /* Tabela da estrutura a ser criada */
    DEFINE INPUT PARAM hParam     AS HANDLE NO-UNDO. /* Em qual estrutura ela vai entrar */    
    
    create query hQuery.
    create buffer hBuffer for table cTable.
    
    hquery:set-buffers(hBuffer).
    hQuery:query-prepare("FOR EACH " + hBuffer:table).
    hQuery:query-open().
    hQuery:get-first().

    REPEAT:
        /* criacao do no da estrutura principal a tabela */               

        hXML:create-node(hRecordAux, hBuffer:TABLE, "ELEMENT"). /* create a 'Record' element... */
        hXML:create-NODE(hText, "", "TEXT"). /* The hText element is used just for create a new line after each element... */
        hText:NODE-VALUE = "~n ".
        hParam:append-child(hText).
        hParam:append-child(hRecordAux).         

        /* Criacao dos campos da tabela */  
        bloco_campos_dup:
        do iNumFields = 1 to hBuffer:num-fields: 

            IF cTable = 'dup' AND hBuffer:buffer-field(iNumFields):NAME <> "dVenc" THEN DO:
                IF INT(hBuffer:buffer-field(iNumFields):buffer-value) = 0 THEN
                    NEXT bloco_campos_dup.
            END.

            IF cTable = 'veicTransp' AND 
                hBuffer:buffer-field(iNumFields):NAME  = "RNTC" THEN DO:

                IF hBuffer:buffer-field(iNumFields):BUFFER-VALUE = "" THEN
                    NEXT bloco_campos_dup.

            END.

            IF cTable = 'reboque' AND 
                hBuffer:buffer-field(iNumFields):NAME  = "RNTC" THEN DO:

                IF hBuffer:buffer-field(iNumFields):BUFFER-VALUE = "" THEN
                    NEXT bloco_campos_dup.

            END.

            IF cTable = 'ISSQNtot' AND trim(hBuffer:buffer-field(iNumFields):BUFFER-VALUE) = "" AND
            (   hBuffer:buffer-field(iNumFields):NAME <> "dCompet"
             OR hBuffer:buffer-field(iNumFields):NAME <> "indISSRet"
             OR hBuffer:buffer-field(iNumFields):NAME <> "indISS") THEN NEXT bloco_campos_dup.
            
            IF cTable = 'retTrib' AND trim(hBuffer:buffer-field(iNumFields):BUFFER-VALUE) = "" THEN NEXT bloco_campos_dup.

            IF cTable = 'vol' THEN DO:

                IF hBuffer:buffer-field(iNumFields):BUFFER-VALUE = "" THEN
                    NEXT bloco_campos_dup.

            END.
            
            assign hField = hBuffer:buffer-field(iNumFields).

            /* In order to improve performance, decrease the .xml file size the fields 
            with a "" value will be not added as element */             
        
            /* The hText element is used just for create a new line after each element... */ 
            hXML:create-node(hText, "", "TEXT").
            hText:NODE-VALUE = "~n ".
            hRecordAux:append-child(hText).            

            /* create the field name as element */ 
            hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
            hRecordAux:append-child(hFieldName). 

            /* create the field value as text */ 
            hXML:create-node(hFieldValue, "text", 'TEXT') NO-ERROR. 
            hFieldName:append-child(hFieldValue) NO-ERROR. 
            hFieldValue:NODE-VALUE = hField:BUFFER-VALUE NO-ERROR. 
            
        END. 

        if cTable = 'vol' and can-find(first lacres) then do:  /* Daniel */
                            
            create query hQueryAux17.
            create buffer hBufferAux17 for table 'lacres'.
    
            hQueryAux17:set-buffers(hBufferAux17).
            hQueryAux17:query-prepare("FOR EACH " + hBufferAux17:TABLE). 
            hQueryAux17:query-open(). 
            hQueryAux17:get-first().
        
            hXML:CREATE-NODE(hRecordAux17, hBufferAux17:TABLE, "ELEMENT").
            hXML:CREATE-NODE(hText, "", "TEXT").
            hText:NODE-VALUE = "~n ". 
            hRecordAux:APPEND-CHILD(hText).
            hRecordAux:APPEND-CHILD(hRecordAux17).
            
            bloco_Vol:
            DO iNumFieldsAux2 = 1 TO hBufferAux17:NUM-FIELDS:                               
  
                assign hField = hBufferAux17:buffer-field(1).

                /* In order to improve performance, decrease the .xml file size the fields 
                with a "" value will be not added as element */
               
                      
                /* The hText element is used just for create a new line after each element... */ 
                hXML:create-node(hText, "", "TEXT").
                hText:NODE-VALUE = "~n ".
                hRecordAux17:append-child(hText).
                
                /* create the field name as element */ 
                hXML:create-node(hFieldName, hField:name, 'ELEMENT'). 
                hRecordAux17:append-child(hFieldName). 
                
                /* create the field value as text */ 
                hXML:create-node(hFieldValue, "text", 'TEXT'). 
                hFieldName:append-child(hFieldValue).
                hFieldValue:NODE-VALUE = hField:BUFFER-VALUE.
            END.
        end.
      
        /* Fim do DO da impressao dos campos da estrutura */

        hXML:create-node(hText, "", "TEXT"). 
        hText:NODE-VALUE = "~n ". 
        hRecordAux:append-child(hText).        

        hQuery:get-next(). 
        if hQuery:query-off-end then leave.
    END.

    /* Fim do REPEAT da estrutura */

    hQuery:QUERY-CLOSE().
    DELETE OBJECT hQuery.
    DELETE WIDGET hBuffer.     

END PROCEDURE.

PROCEDURE piMsgFISCO.
    DEFINE INPUT  PARAMETER pCdMensagem AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pDsMensagem AS CHARACTER  NO-UNDO.

    IF pCdMensagem = '' THEN DO:
        CREATE ttMsgFISCO.
        ASSIGN 
            ttMsgFISCO.cd-mensagem = pCdMensagem
            ttMsgFISCO.ds-mensagem = pDsMensagem.
    END.
    ELSE
        IF NOT CAN-FIND(FIRST ttMsgFISCO
                        WHERE ttMsgFISCO.cd-mensagem = pCdMensagem) THEN DO:
            CREATE ttMsgFISCO.
            ASSIGN 
                ttMsgFISCO.cd-mensagem = pCdMensagem
                ttMsgFISCO.ds-mensagem = pDsMensagem.
        END.

END PROCEDURE.

PROCEDURE piMsgCONTR.
    DEFINE INPUT  PARAMETER pCdMensagem AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pDsMensagem AS CHARACTER  NO-UNDO.

    IF pCdMensagem = '' THEN DO:
        CREATE ttMsgCONTR.
        ASSIGN 
            ttMsgCONTR.cd-mensagem = pCdMensagem
            ttMsgCONTR.ds-mensagem = pDsMensagem.
    END.
    ELSE
        IF NOT CAN-FIND(FIRST ttMsgCONTR
                        WHERE ttMsgCONTR.cd-mensagem = pCdMensagem) THEN DO:
            CREATE ttMsgCONTR.
            ASSIGN 
                ttMsgCONTR.cd-mensagem = pCdMensagem
                ttMsgCONTR.ds-mensagem = pDsMensagem.
        END.

END PROCEDURE.






