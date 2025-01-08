
/* 
===================================================================== 
Programa...: nf001.p
Descricao..: Gera estrutura XML a partir da nota fiscal
Autor......: Tiago Castilho
Data.......: 26/05/2009
===================================================================== 
*/ 


DEF INPUT  PARAM pCodEstabel AS CHARACTER.
DEF INPUT  PARAM pArquivo    AS CHARACTER.

{utp/ut-glob.i}
/*{utp/daut0000.i}*/
{esp/ftp/esft067.i} /* Include de declaracao de variaveis e temp-tables */
{esp/ftp/esft067a.i} /* Include de Geracao do XML */                      
{include/i-freeac.i}
def var iContDest as int no-undo.
DEFINE VARIABLE c-cnae              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE icont               AS INTEGER     NO-UNDO.
DEFINE VARIABLE cNarAux             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iLinha              AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-conv             AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-pis              AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-cofins           AS DECIMAL     NO-UNDO.
DEFINE VARIABLE h-cdapi704          AS HANDLE      NO-UNDO.
DEFINE VARIABLE hXMLGera            AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-endereco          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-rua               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nro               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-comp              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-narrativa-do-item AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-impressora        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-vl-tot-item      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-tot-icms      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-total-icms        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE l-icms-outras-it    AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-nref              AS INTEGER INITIAL 0    NO-UNDO.
DEFINE VARIABLE c-xped              AS CHARACTER   NO-UNDO.
DEF BUFFER b-natur FOR natur-oper.
DEFINE TEMP-TABLE TT_File NO-UNDO 
    FIELD FILENAME AS CHARACTER
    FIELD FullPath AS CHARACTER
    FIELD FILE     AS CHARACTER.

find first nfe-param no-lock 
    where nfe-param.cod-estabel = pCodEstabel no-error.

RUN pi-carregaTabelas.

PROCEDURE pi-carregaTabelas:

    /*{gtp/gtnf001.i1) /* delete temp-table */*/
    
    empty temp-table TT_File.   

    CREATE transp.
    ASSIGN transp.modFrete = "".

    IF AVAIL nfe-param THEN DO:
        IF opsys <> 'WIN32' THEN
            INPUT FROM OS-DIR(nfe-param.end-imp-txt-unix) NO-ECHO.
        else     
            INPUT FROM OS-DIR(nfe-param.end-imp-txt) NO-ECHO.

        REPEAT:
            CREATE TT_File. 
            IMPORT TT_File.FILENAME 
                   TT_File.FullPath
                   TT_File.FILE.  
               
                                               
        END. 
    END.

       FOR EACH TT_File
        WHERE TT_File.FILE = 'F'
          and (if pArquivo <> '' then TT_File.FILENAME MATCHES "*" + pArquivo + "*" else true)
          AND NOT TT_File.FILENAME BEGINS 'log'.

        assign iLinha = 0.        
                              
        INPUT FROM VALUE(TT_File.FullPath) NO-CONVERT.
    
        REPEAT:

            IMPORT DELIMITER '|'
                cCampo1 cCampo2 cCampo3 cCampo4 cCampo5 cCampo6 cCampo7 
                cCampo8 cCampo9 cCampo10 cCampo11 cCampo12 cCampo13 cCampo14
                cCampo15 cCampo16 cCampo17 cCampo18 cCampo19 cCampo20 cCampo21 
                cCampo22 cCampo23 cCampo24 cCampo25.
                
            assign iLinha = iLinha + 1.
            
            CASE cCampo1.
                WHEN 'NOTA FISCAL' THEN DO:
                END.
                WHEN 'A' THEN DO: /* Cabecalho */
                    FIND FIRST ide NO-ERROR.
                    IF  AVAIL ide THEN
                        RUN pi-geraXML.

                    IF cCampo2 MATCHES "*3.10*" THEN DO: /* Desativado para n∆o gerar mais o arquivo xml deixar por conta do padr∆o Gati */
/*                         RUN gtp/gtnf027rp.p (INPUT pCodEstabel, INPUT pArquivo).  */
                        RETURN.
                    END.
                END.
                WHEN 'B' THEN DO: /* Tabela de Identificacao da Nota Fiscal eletronica */ 
                
                    case cCampo7.
                        when '01' then assign cCampo7 = '1'.
                    end case.    
                
                    CREATE ide.                                       
                    ASSIGN ide.cUF       = if cCampo2 = '0' then '42' else cCampo2
                           ide.cNF       = string(int(cCampo3),'99999999')
                           ide.natOp     = cCampo4
                           ide.indPag    = cCampo5
                           ide.mod       = if cCampo6 = '' then '55' else cCampo6
                           ide.serie     = IF cCampo7 = '' THEN '1'  ELSE cCampo7
                           ide.nNF       = cCampo8
                           ide.dEmi      = cCampo9
                           ide.dSaiEnt   = cCampo10
                           ide.hSaiEnt   = IF  cCampo11 <> "" THEN string(int(cCampo11), "HH:MM:SS") ELSE cCampo11
                           ide.tpNF      = cCampo12
                           ide.cMunFG    = string(int(cCampo13),'9999999')
                           ide.tpImp     = IF cCampo14 = "" THEN "1" ELSE cCampo14
                           ide.tpEmis    = cCampo15
                           ide.cDV       = IF cCampo16 = "" THEN "0" ELSE cCampo16
                           ide.tpAmb     = cCampo17
                           ide.finNFe    = cCampo18
                           ide.procEmi   = cCampo19
                           ide.verProc   = cCampo20
                           ide.dhCont    = cCampo21 /* novo */
                           ide.xJust     = cCampo22 /* novo */
                               .
                                                       
                    assign de-conv = 1.       
                    for first nota-fiscal no-lock
                        where nota-fiscal.cod-estabel = nfe-param.cod-estabel
                          and nota-fiscal.serie       = ide.serie
                          and nota-fiscal.nr-nota-fis = string(int(ide.nNF),"9999999"),
                        first natur-oper of nota-fiscal no-lock.
                        ASSIGN ide.natOp = fn-free-accent(natur-oper.denominacao).

                        find first cidade-zf 
                            where cidade-zf.cidade = nota-fiscal.cidade
                              and cidade-zf.estado = nota-fiscal.estado no-lock no-error.                    
                        if  avail cidade-zf and dec(SUBSTRING(natur-oper.char-2,66,5)) > 0 then
                            assign de-conv = (100 - dec(SUBSTRING(natur-oper.char-2,66,5))) / 100.

                    end.
                END.
                WHEN 'B13' THEN DO:

                    ASSIGN i-nref = i-nref + 1.
                
                    create NFref.
                    assign NFref.nItem = i-nref
                           NFref.refNFe = fill('0',44 - length(cCampo2)) + cCampo2.
                                    
                END.
                WHEN 'B14' THEN DO: /* Notas referenciadas */

                    ASSIGN i-nref = i-nref + 1.
                    
                    create NFref.
                    assign NFref.nItem = i-nref
                           NFref.refNFe = ''.                                       
                    
                    create refNF.
                    assign refNF.nItem = i-nref
                        refNF.cUF   = if cCampo2 = '0' then '42' else cCampo2
                        refNF.AAMM  = cCampo3
                        refNF.CNPJ  = cCampo4
                        refNF.mod   = cCampo5
                        refNF.serie = replace(cCampo6,"1.","1")
                        refNF.nNF   = cCampo7.
                END.
                WHEN 'B20a' THEN do: /* novo */

                    ASSIGN i-nref = i-nref + 1.

                    CREATE refNFP.
                    ASSIGN refNFP.nItem = i-nref
                           refNFP.cUF   = cCampo2
                           refNFP.AAMM  = cCampo3
                           refNFP.CPF   = cCampo4
                           refNFP.CNPJ  = cCampo4
                           refNFP.IE    = cCampo5
                           refNFP.MOD   = cCampo6
                           refNFP.serie = cCampo7
                           refNFP.nNF   = cCampo8.
                END.
                WHEN 'B20i' THEN DO: /* novo */
                    ASSIGN i-nref = i-nref + 1.

                    CREATE refCTe.
                    ASSIGN refCTe.nItem  = i-nref
                           refCTe.refCte = cCampo2.
                END.
                WHEN 'B20j' THEN DO: /* novo */
                    ASSIGN i-nref = i-nref + 1.

                    CREATE refECF.
                    ASSIGN refECF.nItem = i-nref
                           refECF.MOD  = cCampo2
                           refECF.nECF = cCampo3
                           refECF.nCOO = cCampo4.
                END.
                WHEN 'C' THEN DO: /* Tabela de Emitente da Nota Fiscal */ 
                    for FIRST estabelec no-lock
                            where estabelec.cod-estabel = nfe-param.cod-estabel:
                    END.
                    for first ponto-programa
                        where ponto-programa.nome-programa = "esft067"
                          AND ponto-programa.ponto         = 1,
                         EACH conteudo-programa NO-LOCK
                        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                          AND conteudo-programa.sequencia    = int(nfe-param.cod-estabel):
                        assign c-cnae = ENTRY(1,conteudo-programa.conteudo).
                    end.                         

                    CREATE emit.
                    ASSIGN emit.xNome    = fn-free-accent(cCampo2)
                           emit.xFant    = "INTELBRAS S/A" /* fn-free-accent(cCampo3)*/
                           emit.IE       = cCampo4
                           emit.IEST     = cCampo5.                                          
                    
                    IF c-cnae <> "" THEN
                       ASSIGN emit.IM       = IF cCampo6 = "" THEN estabelec.ins-municipal ELSE cCampo6
                              emit.cnae     = c-cnae.

                    ASSIGN emit.CNAE     = IF emit.cnae = "" THEN cCampo7 ELSE emit.cnae
                           emit.CRT      = cCampo8 /* novo */.
                END.
                WHEN 'C02' THEN DO: /* CNPJ do emitente */
                    IF AVAIL emit THEN DO:
                        ASSIGN emit.CNPJ = string(dec(cCampo2),'99999999999999').
                    END.
                END.
                WHEN 'C05' THEN DO: /* Tabela de Enderecos dos Emitentes */
                    CREATE enderEmit.
                    ASSIGN enderEmit.xLgr      = cCampo2 
                           enderEmit.nro       = fill('0',2 - length(cCampo3)) + cCampo3 
                           enderEmit.xCpl      = cCampo4
                           enderEmit.xBairro   = cCampo5 
                           enderEmit.cMun      = string(int(cCampo6),'9999999')
                           enderEmit.xMun      = cCampo7
                           enderEmit.UF        = cCampo8
                           enderEmit.CEP       = string(int(REPLACE(cCampo9,'-','')),'99999999')
                           enderEmit.cPais     = cCampo10
                           enderEmit.xPais     = cCampo11
                           enderEmit.fone      = if cCampo12 = '' then '000000000' else cCampo12.
       
                END.
                WHEN 'D' THEN DO: /* novo */
                    CREATE Avulsa.        
                    ASSIGN Avulsa.CNPJ    = cCampo2
                           Avulsa.xOrgao  = cCampo3
                           Avulsa.matr    = cCampo4
                           Avulsa.xAgente = cCampo5
                           Avulsa.fone    = cCampo6
                           Avulsa.UF      = cCampo7
                           Avulsa.nDAR    = cCampo8
                           Avulsa.dEmi    = cCampo9
                           Avulsa.vDAR    = cCampo10
                           Avulsa.repEmi  = cCampo11
                           Avulsa.dPag    = cCampo12.
                END.
                WHEN "E" THEN DO: /* Informacoes do Destinatario */
                    CREATE dest.         
                    ASSIGN iContDest   = iContDest + 1
                           dest.xNome  = fn-free-accent(cCampo2)
                           dest.IE     = IF cCampo3 = '' THEN 'ISENTO' ELSE cCampo3
                           dest.ISUF   = cCampo4 /*novo */
                           dest.email  = cCampo5 /* novo */
                               .
/* ANTES 

                    IF nfe-param.cod-estabel = "102" AND cCampo3 = 'ISENTO' THEN
                       ASSIGN dest.IE     =  "".
                    ELSE
                       ASSIGN dest.IE     =  cCampo3.
                       */
                END.
                WHEN 'E02' THEN DO: /* CNPJ do destinat·rio */
                    find first dest no-error.
                    if avail dest then ASSIGN dest.CNPJ = cCampo2.
                END.
                WHEN 'E03' THEN DO: /* CPF do destinatario */
                    find first dest no-error.
                        if avail dest then assign dest.CPF = cCampo2.        
                END.
                WHEN "E05" THEN DO: /* Endereco do destinatario */
                    FIND nota-fiscal exclusive-lock
                        where nota-fiscal.cod-estabel = nfe-param.cod-estabel
                          and nota-fiscal.serie       = ide.serie
                          and nota-fiscal.nr-nota-fis = string(int(ide.nNF),"9999999")
                        NO-ERROR.
                    FOR FIRST emitente NO-LOCK
                        WHERE emitente.cod-emitente = nota-fiscal.cod-emitente:
                        ASSIGN de-vl-tot-item = 0.
                        FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
                            FIND FIRST b-natur
                                 WHERE b-natur.nat-operacao = it-nota-fisc.nat-operacao NO-LOCK NO-ERROR.
                            if  b-natur.tipo = 3 and
                                it-nota-fisc.vl-iss-it > 0 then do:
                                 assign de-vl-tot-item = de-vl-tot-item + it-nota-fisc.vl-merc-liq.
                            END.
                            IF it-nota-fisc.nat-operacao BEGINS "3" THEN DO:
                                FIND ITEM
                                    WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.
                                IF AVAIL ITEM  THEN DO:
                                    FOR FIRST int-it-nota-fisc exclusive-lock
                                        where int-it-nota-fisc.cod-estabel = it-nota-fisc.cod-estabel
                                          and int-it-nota-fisc.serie       = it-nota-fisc.serie
                                          and int-it-nota-fisc.nr-nota-fis = it-nota-fisc.nr-nota-fis
                                          and int-it-nota-fisc.nr-seq-fat  = it-nota-fisc.nr-seq-fat
                                          AND int-it-nota-fisc.it-codigo   = it-nota-fisc.it-codigo:
                                    end.
                                    IF NOT AVAIL int-it-nota-fisc THEN DO:
                                        CREATE int-it-nota-fisc.
                                        ASSIGN int-it-nota-fisc.cod-estabel = it-nota-fisc.cod-estabel
                                               int-it-nota-fisc.serie       = it-nota-fisc.serie
                                               int-it-nota-fisc.nr-nota-fis = it-nota-fisc.nr-nota-fis
                                               int-it-nota-fisc.nr-seq-fat  = it-nota-fisc.nr-seq-fat
                                               int-it-nota-fisc.it-codigo   = it-nota-fisc.it-codigo.
                                    END.
                                    ASSIGN int-it-nota-fisc.codigo-orig = ITEM.codigo-orig.
                                END.

                            END.

                        END.
                    END.
                    FIND int-loc-entr
                         WHERE int-loc-entr.nome-abrev = nota-fiscal.nome-ab-cli
                           AND int-loc-entr.cod-entrega = nota-fiscal.cod-entrega
                         NO-LOCK NO-ERROR.
                    FIND loc-entr
                         WHERE loc-entr.nome-abrev = nota-fiscal.nome-ab-cli
                           AND loc-entr.cod-entrega = nota-fiscal.cod-entrega
                         NO-LOCK NO-ERROR.                         

                    IF AVAIL emitente and
                       avail loc-entr and                                              
                        (emitente.cgc          <> nota-fiscal.cgc          OR
                         emitente.ins-estadual <> nota-fiscal.ins-estadual OR
                         loc-entr.endereco     <> nota-fiscal.endereco     OR
                         loc-entr.bairro       <> nota-fiscal.bairro       OR
                         loc-entr.cidade       <> nota-fiscal.cidade       OR
                         loc-entr.estado       <> nota-fiscal.estado       OR
                         loc-entr.pais         <> nota-fiscal.pais         OR
                         loc-entr.cep          <> nota-fiscal.cep          OR
                         (AVAIL INT-loc-entr AND
                          int-loc-entr.endereco-completo <> ""))  THEN DO:


                        IF AVAIL INT-loc-entr AND
                          int-loc-entr.endereco-completo <> "" THEN
                            ASSIGN c-endereco = int-loc-entr.endereco-completo.
                        ELSE
                            ASSIGN c-endereco = loc-entr.endereco.

                        ASSIGN c-rua      = ""
                               c-nro      = ""
                               c-comp     = "".
                        IF  INDEX(c-endereco,CHR(ASC("ß"))) > 0 THEN /* Retirar caracter especial */
                            ASSIGN c-endereco = REPLACE(c-endereco,CHR(ASC("ß")),"").
                    
                        RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
                        RUN pi-trata-endereco IN h-cdapi704 (INPUT  c-endereco,
                                                             OUTPUT c-rua, 
                                                             OUTPUT c-nro, 
                                                             OUTPUT c-comp).

                        ASSIGN c-nro = fn-free-accent(c-nro).

                        DELETE PROCEDURE h-cdapi704.
                        CREATE enderDest.
                        ASSIGN enderDest.xLgr      = c-rua
                               enderDest.nro       = fill('0',2 - length(c-nro)) + c-nro
                               enderDest.xCpl      = trim(c-comp)
                               enderDest.xBairro   =  trim(fn-free-accent(loc-entr.bairro)) 
                               
                               enderDest.xMun      = trim(loc-entr.cidade)
                               enderDest.UF        = loc-entr.estado
                               enderDest.CEP       = string(int(REPLACE(loc-entr.cep,'-','')),'99999999')
                               enderDest.cPais     = cCampo10
                               enderDest.xPais     = cCampo11
                               enderDest.fone      = cCampo12.
                               
                        assign nota-fiscal.endereco = loc-entr.endereco  
                               nota-fiscal.bairro   = loc-entr.bairro   
                               nota-fiscal.cidade   = loc-entr.cidade      
                               nota-fiscal.estado   = loc-entr.estado      
                               nota-fiscal.pais     = loc-entr.pais         
                               nota-fiscal.cep      = loc-entr.cep.          
                               
                        
                        for first mgcad.cidade fields(cdn-munpio-ibge) no-lock
                            where mgcad.cidade.cidade = loc-entr.cidade
                              and mgcad.cidade.estado = loc-entr.estado
                              and mgcad.cidade.pais   = cCampo11.
                            assign enderDest.cMun = string(cidade.cdn-munpio-ibge,'9999999').
                        end. 

                    END.
                    ELSE DO:
                        ASSIGN cCampo3 = fn-free-accent(cCampo3).
                        CREATE enderDest.
                        ASSIGN enderDest.xLgr      = (if length(cCampo2) < 2 then 'Rua ' + fn-free-accent(cCampo2) else fn-free-accent(cCampo2)) 
                               enderDest.nro       = fill('0',2 - length(cCampo3)) + cCampo3 
                               enderDest.xCpl      = TRIM(cCampo4)
                               enderDest.xBairro   = trim(fn-free-accent(cCampo5))
                               enderDest.cMun      = string(int(cCampo6),'9999999')
                               
                               enderDest.xMun      = trim(cCampo7)
                               enderDest.UF        = cCampo8 
                               enderDest.CEP       = string(int(REPLACE(cCampo9,'-','')),'99999999')
                               enderDest.cPais     = cCampo10
                               enderDest.xPais     = cCampo11
                               enderDest.fone      = cCampo12.
                        for first mgcad.cidade fields(cdn-munpio-ibge) no-lock
                            where mgcad.cidade.cidade = cCampo7
                              and mgcad.cidade.estado = cCampo8
                              and mgcad.cidade.pais   = cCampo11.
                            assign enderDest.cMun = string(cidade.cdn-munpio-ibge,'9999999').
                        end.          
                        IF LENGTH(cCampo4) = 1 THEN
                            ASSIGN enderDest.nro = enderDest.nro + " " + trim(fn-free-accent(cCampo4)).
                        ELSE
                            ASSIGN enderDest.xCpl      = IF cCampo4 <> "" THEN trim(fn-free-accent(cCampo4)) ELSE "".
                    END.
                END.
                WHEN "F" THEN DO: /* novo */
                    CREATE Retirada.
                    ASSIGN Retirada.CNPJ    = cCampo2
                           Retirada.xLgr    = cCampo3
                           Retirada.nro     = cCampo4
                           Retirada.xCpl    = cCampo5
                           Retirada.xBairro = cCampo6
                           Retirada.cMun    = cCampo7
                           Retirada.xMun    = cCampo8
                           Retirada.UF      = cCampo9.

                END.
                WHEN 'G' THEN DO: /* Endereco de entrega */
                    create entrega.
                    assign entrega.xLgr    = IF LENGTH(cCampo2) < 2 THEN '' ELSE cCampo2
                           entrega.nro     = fill('0',2 - length(cCampo3)) + cCampo3
                           entrega.xCpl    = IF LENGTH(cCampo4) < 2 THEN '' ELSE cCampo4
                           entrega.xBairro = cCampo5
                           entrega.cMun    = cCampo6
                           entrega.xMun    = cCampo7
                           entrega.UF      = cCampo8.
                    for first mgcad.cidade fields(cdn-munpio-ibge) no-lock
                        where mgcad.cidade.cidade = cCampo7
                          and mgcad.cidade.estado = cCampo8
                          and mgcad.cidade.pais   = enderDest.xPais.
                        assign entrega.cMun = string(cidade.cdn-munpio-ibge,'9999999').
                    end.                        

                END.
                WHEN 'G02' THEN DO:
                    ASSIGN entrega.CNPJ    = cCampo2.
                END.
                WHEN 'G03' THEN DO:
                    ASSIGN entrega.cpf     = cCampo2.
                END.
                WHEN "H" THEN DO: /* No de indicacao de quantos itens a NF possui */
                    CREATE det.
                    ASSIGN iCont         = iCont + 1
			               det.nItem     = iCont
                           det.infAdProd = cCampo3
                           cNarAux       = cCampo3.

                    ASSIGN det.infAdProd = REPLACE(det.infAdProd, CHR(10), " ")
                           det.infAdProd = REPLACE(det.infAdProd, CHR(13), " ")
                           det.infAdProd = REPLACE(det.infAdProd, CHR(9), " ").

                    IF  INDEX(det.infAdProd,CHR(ASC("ß"))) > 0 THEN /* Retirar caracter especial */
                        ASSIGN det.infAdProd = REPLACE(det.infAdProd,CHR(ASC("ß")),"").
                END.
                WHEN "I" THEN DO: /* Produtos */        
                    for FIRST estabelec no-lock
                            where estabelec.cgc = emit.cnpj:
                    END.
                    FIND ITEM WHERE ITEM.it-codigo = cCampo2 NO-LOCK NO-ERROR.

                    IF AVAIL item  THEN DO:
                        RUN pi-narrativa-item (INPUT estabelec.cod-estabel,
                                               INPUT ITEM.it-codigo,
                                               OUTPUT c-narrativa-do-item).
    
                        ASSIGN cCampo4 = c-narrativa-do-item.
                    END.
                    IF AVAIL item AND
                        ITEM.ind-imp-desc = 7 THEN DO:
                         assign cCampo4 = cCampo4  + cNarAux.    
                    END.

                    if cCampo4 = '' then 
                       FOR each nar-it-nota fields(narrativa) no-lock
                            where nar-it-nota.cod-estabel = estabelec.cod-estabel
                              and nar-it-nota.serie       = ide.serie
                              and nar-it-nota.nr-nota-fis = string(int(ide.nNF),"9999999")
                              and nar-it-nota.nr-sequencia = iCont * 10.
                            assign cCampo4 = cCampo4 + nar-it-nota.narrativa.
                        end.

                    FOR FIRST int-it-nota-fisc no-lock
                        where int-it-nota-fisc.cod-estabel = estabelec.cod-estabel
                          and int-it-nota-fisc.serie       = ide.serie
                          and int-it-nota-fisc.nr-nota-fis = string(int(ide.nNF),"9999999")
                          and int-it-nota-fisc.nr-seq-fat  = iCont * 10
                          AND int-it-nota-fisc.it-codigo   = ITEM.it-codigo:

                    end.

/*                     IF natur-oper.tipo = 1 THEN                                                                           */
/*                         FOR FIRST it-nota-fisc no-lock                                                                    */
/*                             where it-nota-fisc.cod-estabel = estabelec.cod-estabel                                        */
/*                               and it-nota-fisc.serie       = ide.serie                                                    */
/*                               and it-nota-fisc.nr-nota-fis = string(int(ide.nNF),"9999999")                               */
/*                               and it-nota-fisc.nr-seq-fat  = iCont * 10                                                   */
/*                               AND it-nota-fisc.it-codigo   = ITEM.it-codigo:                                              */
/*                               ASSIGN  cCampo10 = trim(REPLACE(string(it-nota-fisc.vl-preori,">>>>>>>>9.99999"),",","."))  */
/*                                       cCampo15 = trim(REPLACE(string(it-nota-fisc.vl-preori,">>>>>>>>9.99999"),",",".")). */
/*                                                                                                                           */
/*                         end.                                                                                              */

                    IF estabelec.cod-estabel = "102" THEN DO:
                        FIND item-mat
                             WHERE item-mat.it-codigo = cCampo2 NO-LOCK NO-ERROR.
                        IF AVAIL Item-mat AND
                           item-mat.cod-ean <> "" THEN
                           ASSIGN cCampo4 = trim(cCampo4) + " EAN: " + string(item-mat.cod-ean).
                    END.
                
                    ASSIGN cCampo4 = fn-free-accent(LEFT-trim(TRIM(cCampo4))).

                    IF  ccampo20 = ". ." THEN
                        ASSIGN ccampo20 = "1".

                    ASSIGN c-xped = "".
                    /* Pedido de Origem do Cliente - Informaá∆o solicitada no PD4000, campo "PO Cliente" */
                    FIND FIRST nota-fiscal NO-LOCK
                        WHERE  nota-fiscal.cod-estabel = estabelec.cod-estabel
                        AND    nota-fiscal.serie       = ide.serie
                        AND    nota-fiscal.nr-nota-fis = STRING(INT(ide.nNF), "9999999") NO-ERROR.
                    IF  AVAIL  nota-fiscal THEN DO:
                        FIND FIRST ped-venda NO-LOCK
                            WHERE  ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                            AND    ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.
                        IF  AVAIL  ped-venda THEN DO:
                            FIND FIRST int-ped-venda NO-LOCK
                                WHERE  int-ped-venda.cod-estabel = ped-venda.cod-estabel
                                AND    int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-ERROR.
                            IF  AVAIL  int-ped-venda THEN
                                ASSIGN c-xped = TRIM(SUBSTRING(int-ped-venda.char-1,53,12)).
                        END.
                    END.
                    /* Fim - Pedido de Origem do Cliente */
                        

                    CREATE prod.
                    ASSIGN prod.nItem     = iCont
                           prod.cProd     = cCampo2    
                           prod.cEAN      = cCampo3
                           prod.xProd     = if cCampo4 = '' then 'Nao informado' else replace(replace(cCampo4,chr(10),' '),'Ò','')
                           prod.NCM       = cCampo5    
                           prod.EXTIPI    = cCampo6    
                           prod.CFOP      = cCampo7    
                           prod.uCom      = fEditor(cCampo8)
                           prod.qCom      = cCampo9   
                           prod.vUnCom    = cCampo10
                           prod.vProd     = cCampo11
                           prod.cEANTrib  = cCampo12
                           prod.uTrib     = fEditor(cCampo13)
                           prod.qTrib     = cCampo14
                           prod.vUnTrib   = cCampo15
                           prod.vFrete    = cCampo16 /* novo */
                           prod.vSeg      = cCampo17 /* novo */
                           prod.vDesc     = cCampo18 /* novo */ 
                           prod.vOutro    = cCampo19 /* novo */
                           prod.indTot    = cCampo20 /* novo */
                           prod.xPed      = c-xped /* novo */
                           prod.nItemPed  = cCampo22 /* novo */
                           prod.nFCI      = cCampo23 /* Numero de FCI */.
                END.
                WHEN "I18" THEN DO:
                    CREATE DI.
                    ASSIGN
                        DI.nDI         = REPLACE(REPLACE(cCampo2,'/',''),'-','')
                        DI.dDI         = cCampo3
                        DI.xLocDesemb  = cCampo4
                        DI.UFDesemb    = cCampo5
                        DI.dDesemb     = cCampo6
                        DI.cExportador = cCampo7.
                END.
                WHEN 'I25' THEN DO:
                    CREATE adi.
                    ASSIGN
                        adi.nAdicao     = cCampo2
                        adi.nSeqAdic    = cCampo3
                        adi.cFabricante = cCampo4
                        adi.vDescDI     = cCampo5.
                END.
                WHEN "J" THEN DO: /* novo */
                    CREATE veicProd.
                    ASSIGN veicProd.tpOp         = Ccampo2
                           veicProd.chassi       = Ccampo3
                           veicProd.cCor         = Ccampo4
                           veicProd.xCor         = Ccampo5
                           veicProd.pot          = Ccampo6
                           veicProd.cilin        = cCampo7 
                           veicProd.pesoL        = Ccampo8
                           veicProd.pesoB        = Ccampo9
                           veicProd.nSerie       = Ccampo10
                           veicProd.tpComb       = Ccampo11
                           veicProd.nMotor       = Ccampo12
                           veicProd.CMT          = Ccampo13
                           veicProd.dist         = Ccampo14
                           veicProd.anoMod       = Ccampo15
                           veicProd.anoFab       = Ccampo16
                           veicProd.tpPint       = Ccampo17
                           veicProd.tpVeic       = Ccampo18
                           veicProd.espVeic      = Ccampo19
                           veicProd.VIN          = Ccampo20
                           veicProd.condVeic     = Ccampo21
                           veicProd.cMod         = Ccampo22
                           veicProd.cCorDENATRAN = cCampo23 
                           veicProd.lota         = cCampo24 
                           veicProd.tpRest       = cCampo25 .
                END.
                WHEN "K" THEN DO: /* novo */
                    CREATE MED.
                    ASSIGN med.nlote = cCampo2
                           med.qLote = cCampo3
                           med.dFab  = cCampo4
                           med.dVal  = cCampo5
                           med.vPMC  = cCampo6.
                END.
                WHEN "L" THEN DO: /* novo */
                    CREATE Arma.
                    ASSIGN Arma.tpArma = cCampo2
                           Arma.nSerie = cCampo3
                           Arma.nCano  = cCampo4
                           Arma.descr  = cCampo5.
                END.
                WHEN "L1" THEN DO: /* novo - pode existir mais de um registro */
                    CREATE Comb.
                    ASSIGN Comb.cProdANP = cCampo2
                           Comb.CODIF    = cCampo3
                           Comb.qTemp    = cCampo4
                           Comb.UFCOns   = cCampo5.
                END.
                WHEN "L105" THEN DO: /* novo */
                    ASSIGN Comb.qBCProd   = cCampo2
                           Comb.vAliqProd = cCampo3
                           Comb.vCIDE     = cCampo4.
                END.
                WHEN "M" THEN DO: /* Tributos Totais - impostos */
                    CREATE TotalTrib.
                    ASSIGN TotalTrib.nItem = iCont
                           TotalTrib.vTotTrib = IF cCampo2 = "" THEN "0.00" ELSE cCampo2.
                END.
                WHEN 'N' THEN DO: /* ICMS mundou o nome do ICMS */
                END.                
                WHEN "N02" THEN DO:
                    FOR FIRST int-it-nota-fisc no-lock
                        where int-it-nota-fisc.cod-estabel = estabelec.cod-estabel
                          and int-it-nota-fisc.serie       = ide.serie
                          and int-it-nota-fisc.nr-nota-fis = string(int(ide.nNF),"9999999")
                          and int-it-nota-fisc.nr-seq-fat  = iCont * 10:
                    end.
                    CREATE ICMS.
                    ASSIGN ICMS.nItem    = iCont
                           ICMS.orig     = IF AVAIL int-it-nota-fisc THEN string(int-it-nota-fisc.codigo-orig) ELSE cCampo2
                           ICMS.CST      = IF cCampo3 = "" THEN "00" ELSE cCampo3
                           ICMS.modBC    = cCampo4
                           ICMS.vBC      = IF cCampo5 = "" THEN "0.00" ELSE cCampo5
                           ICMS.pICMS    = cCampo6
                           ICMS.vICMS    = IF cCampo7 = "" THEN "0.00" ELSE cCampo7.           
                    RUN piICMS.    
                END.
                WHEN "N03" THEN DO:
                    FOR FIRST int-it-nota-fisc no-lock
                        where int-it-nota-fisc.cod-estabel = estabelec.cod-estabel
                          and int-it-nota-fisc.serie       = ide.serie
                          and int-it-nota-fisc.nr-nota-fis = string(int(ide.nNF),"9999999")
                          and int-it-nota-fisc.nr-seq-fat  = iCont * 10:
                    end.
                    CREATE ICMS.
                    ASSIGN ICMS.nItem      = iCont
                           ICMS.orig       = IF AVAIL int-it-nota-fisc THEN string(int-it-nota-fisc.codigo-orig) ELSE cCampo2
                           ICMS.CST        = IF cCampo3 = "" THEN "00" ELSE cCampo3
                           ICMS.modBC      = cCampo4
                           ICMS.vBC        = IF cCampo5 = "" THEN "0.00" ELSE cCampo5
                           ICMS.pICMS      = cCampo6
                           ICMS.vICMS      = IF cCampo7 = "" THEN "0.00" ELSE cCampo7
                           ICMS.modBCST    = cCampo8
                           ICMS.pMVAST     = cCampo9
                           ICMS.pRedBCST   = IF cCampo10 = '' THEN '0.00' ELSE cCampo10
                           ICMS.vBCST      = cCampo11
                           ICMS.pICMSST    = cCampo12
                           ICMS.vICMSST    = cCampo13.
                    RUN piICMS.        

                END.
                WHEN "N04" THEN DO:
                    FOR FIRST int-it-nota-fisc no-lock
                        where int-it-nota-fisc.cod-estabel = estabelec.cod-estabel
                          and int-it-nota-fisc.serie       = ide.serie
                          and int-it-nota-fisc.nr-nota-fis = string(int(ide.nNF),"9999999")
                          and int-it-nota-fisc.nr-seq-fat  = iCont * 10:
                    end.
                    CREATE ICMS.
                    ASSIGN ICMS.nItem      = iCont
                           ICMS.orig       = IF AVAIL int-it-nota-fisc THEN string(int-it-nota-fisc.codigo-orig) ELSE cCampo2
                           ICMS.CST        = IF cCampo3 = "" THEN "00" ELSE cCampo3
                           ICMS.modBC      = cCampo4
                           ICMS.pRedBC     = cCampo5
                           ICMS.vBC        = IF cCampo6 = "" THEN "0.00" ELSE cCampo6
                           ICMS.pICMS      = cCampo7
                           ICMS.vICMS      = IF cCampo8 = "" THEN "0.00" ELSE cCampo8. 
                    RUN piICMS.        
                END.
                WHEN "N05" THEN DO:
                    FOR FIRST int-it-nota-fisc no-lock
                        where int-it-nota-fisc.cod-estabel = estabelec.cod-estabel
                          and int-it-nota-fisc.serie       = ide.serie
                          and int-it-nota-fisc.nr-nota-fis = string(int(ide.nNF),"9999999")
                          and int-it-nota-fisc.nr-seq-fat  = iCont * 10:
                    end.
                    CREATE ICMS.
                    ASSIGN ICMS.nItem       = iCont
                           ICMS.orig        = IF AVAIL int-it-nota-fisc THEN string(int-it-nota-fisc.codigo-orig) ELSE cCampo2
                           ICMS.CST         = IF cCampo3 = "" THEN "00" ELSE cCampo3
                           ICMS.modBCST     = cCampo4
                           ICMS.pMVAST      = cCampo5
                           ICMS.pRedBCST    = IF cCampo6 = "" THEN "0.00" ELSE cCampo6
                           ICMS.vBCST       = cCampo7
                           ICMS.pICMSST     = cCampo8
                           ICMS.vICMSST     = cCampo9.
                    RUN piICMS. 
                END.
                WHEN "N06" THEN DO:
                    FOR FIRST int-it-nota-fisc no-lock
                        where int-it-nota-fisc.cod-estabel = estabelec.cod-estabel
                          and int-it-nota-fisc.serie       = ide.serie
                          and int-it-nota-fisc.nr-nota-fis = string(int(ide.nNF),"9999999")
                          and int-it-nota-fisc.nr-seq-fat  = iCont * 10:
                    end.
                    CREATE ICMS.
                    ASSIGN ICMS.nItem      = iCont
                           ICMS.orig       = IF AVAIL int-it-nota-fisc THEN string(int-it-nota-fisc.codigo-orig) ELSE cCampo2
                           ICMS.CST        = IF cCampo3 = "" THEN "00" ELSE cCampo3
                           ICMS.vICMS      = cCampo4 /* novo */
                           ICMS.motDesICMS = cCampo5 /* novo */
                               .
                    RUN piICMS.
                END.
                WHEN "N07" THEN DO:
                    FOR FIRST int-it-nota-fisc no-lock
                        where int-it-nota-fisc.cod-estabel = estabelec.cod-estabel
                          and int-it-nota-fisc.serie       = ide.serie
                          and int-it-nota-fisc.nr-nota-fis = string(int(ide.nNF),"9999999")
                          and int-it-nota-fisc.nr-seq-fat  = iCont * 10:
                    end.
                    CREATE ICMS.
                    ASSIGN ICMS.nItem   = iCont
                           ICMS.orig    = IF AVAIL int-it-nota-fisc THEN string(int-it-nota-fisc.codigo-orig) ELSE cCampo2
                           ICMS.CST     = IF cCampo3 = "" THEN "00" ELSE cCampo3
                           ICMS.modBC   = cCampo4
                           ICMS.pRedBC  = cCampo5
                           ICMS.vBC     = IF cCampo6 = "" THEN "0.00" ELSE cCampo6
                           ICMS.pICMS   = cCampo7.
                           ICMS.vICMS   = IF cCampo8 = "" THEN "0.00" ELSE cCampo8.
                    RUN piICMS.           
                END.
                WHEN "N08" THEN DO:
                    FOR FIRST int-it-nota-fisc no-lock
                        where int-it-nota-fisc.cod-estabel = estabelec.cod-estabel
                          and int-it-nota-fisc.serie       = ide.serie
                          and int-it-nota-fisc.nr-nota-fis = string(int(ide.nNF),"9999999")
                          and int-it-nota-fisc.nr-seq-fat  = iCont * 10:
                    end.
                    CREATE ICMS.
                    ASSIGN ICMS.nItem      = iCont
                           ICMS.orig       = IF AVAIL int-it-nota-fisc THEN string(int-it-nota-fisc.codigo-orig) ELSE cCampo2
                           ICMS.CST        = IF cCampo3 = "" THEN "00" ELSE cCampo3
                           ICMS.vBCSTRet   = cCampo12 /* novo -  mudou o nome da TAG */
                           ICMS.vICMSSTRet = cCampo14 /* novo -  mudou o nome da TAG */
                               .
                    RUN piICMS.       
                END.
                WHEN "N09" THEN DO:
                    FOR FIRST int-it-nota-fisc no-lock
                        where int-it-nota-fisc.cod-estabel = estabelec.cod-estabel
                          and int-it-nota-fisc.serie       = ide.serie
                          and int-it-nota-fisc.nr-nota-fis = string(int(ide.nNF),"9999999")
                          and int-it-nota-fisc.nr-seq-fat  = iCont * 10:
                    end.
                    CREATE ICMS.
                    ASSIGN ICMS.nItem     = iCont
                           ICMS.orig      = IF AVAIL int-it-nota-fisc THEN string(int-it-nota-fisc.codigo-orig) ELSE cCampo2
                           ICMS.CST       = IF cCampo3 = "" THEN "00" ELSE cCampo3
                           ICMS.modBC     = cCampo4
                           ICMS.pRedBC    = cCampo5
                           ICMS.vBC       = IF cCampo6 = "" THEN "0.00" ELSE cCampo6
                           ICMS.pICMS     = cCampo7
                           ICMS.vICMS     = IF cCampo8 = "" THEN "0.00" ELSE cCampo8
                           ICMS.modBCST   = cCampo9
                           ICMS.pMVAST    = cCampo10
                           ICMS.pRedBCST  = cCampo11
                           ICMS.vBCST     = cCampo12
                           ICMS.pICMSST   = cCampo13
                           ICMS.vICMSST   = cCampo14.      
                    RUN piICMS.       
                END.
                WHEN "N10" THEN DO:
                    FOR FIRST int-it-nota-fisc no-lock
                        where int-it-nota-fisc.cod-estabel = estabelec.cod-estabel
                          and int-it-nota-fisc.serie       = ide.serie
                          and int-it-nota-fisc.nr-nota-fis = string(int(ide.nNF),"9999999")
                          and int-it-nota-fisc.nr-seq-fat  = iCont * 10:
                    end.
                    CREATE ICMS.
                    ASSIGN ICMS.nItem     = iCont
                           ICMS.orig      = IF AVAIL int-it-nota-fisc THEN string(int-it-nota-fisc.codigo-orig) ELSE cCampo2
                           ICMS.CST       = IF cCampo3 = "" THEN "00" ELSE cCampo3
                           ICMS.modBC     = cCampo4
                           ICMS.vBC       = IF cCampo6 = "" THEN "0.00" ELSE cCampo6
                           ICMS.pRedBC    = cCampo6
                           ICMS.pICMS     = cCampo7
                           ICMS.vICMS     = IF cCampo8 = "" THEN "0.00" ELSE cCampo8
                           ICMS.modBCST   = cCampo9
                           ICMS.pMVAST    = cCampo10
                           ICMS.pRedBCST  = cCampo11
                           ICMS.vBCST     = cCampo12
                           ICMS.pICMSST   = cCampo13
                           ICMS.vICMSST   = cCampo14.
                    RUN piICMS.       
                END.
                WHEN 'N10a' THEN DO: /* novo */
                    FOR FIRST int-it-nota-fisc no-lock
                        where int-it-nota-fisc.cod-estabel = estabelec.cod-estabel
                          and int-it-nota-fisc.serie       = ide.serie
                          and int-it-nota-fisc.nr-nota-fis = string(int(ide.nNF),"9999999")
                          and int-it-nota-fisc.nr-seq-fat  = iCont * 10:
                    end.
                    CREATE ICMS.
                    ASSIGN ICMS.nItem    = iCont
                           ICMS.orig     = IF AVAIL int-it-nota-fisc THEN string(int-it-nota-fisc.codigo-orig) ELSE cCampo2
                           ICMS.CST      = cCampo3
                           ICMS.modBC    = cCampo4
                           ICMS.vBC      = IF cCampo5 = "" THEN "0.00" ELSE cCampo5
                           ICMS.pRedBC   = cCampo6
                           ICMS.pICMS    = cCampo7
                           ICMS.vICMS    = cCampo8
                           ICMS.modBCST  = cCampo9
                           ICMS.pMVAST   = cCampo10
                           ICMS.pRedBCST = cCampo11
                           ICMS.vBCST    = cCampo12
                           ICMS.pICMSST  = cCampo13
                           ICMS.vICMSST  = cCampo14
                           ICMS.pBCOp    = cCampo15
                           ICMS.UFST     = cCampo16
                           ICMS.cTag     = "150".
                END.
                WHEN 'N10b' THEN DO: /* novo */
                    FOR FIRST int-it-nota-fisc no-lock
                        where int-it-nota-fisc.cod-estabel = estabelec.cod-estabel
                          and int-it-nota-fisc.serie       = ide.serie
                          and int-it-nota-fisc.nr-nota-fis = string(int(ide.nNF),"9999999")
                          and int-it-nota-fisc.nr-seq-fat  = iCont * 10:
                    end.
                    CREATE ICMS.
                    ASSIGN ICMS.nItem       = iCont
                           ICMS.orig        = IF AVAIL int-it-nota-fisc THEN string(int-it-nota-fisc.codigo-orig) ELSE cCampo2
                           ICMS.CST         = cCampo3
                           ICMS.vBCSTRet    = cCampo4
                           ICMS.vICMSSTRet  = cCampo5
                           ICMS.vBCSTDest   = cCampo6
                           ICMS.vICMSSTDest = cCampo7
                           ICMS.cTag        = "151".
                END.
                WHEN 'N10c' THEN DO: /* novo */
                    FOR FIRST int-it-nota-fisc no-lock
                        where int-it-nota-fisc.cod-estabel = estabelec.cod-estabel
                          and int-it-nota-fisc.serie       = ide.serie
                          and int-it-nota-fisc.nr-nota-fis = string(int(ide.nNF),"9999999")
                          and int-it-nota-fisc.nr-seq-fat  = iCont * 10:
                    end.
                    CREATE ICMS.
                    ASSIGN ICMS.nItem       = iCont
                           ICMS.Orig        = IF AVAIL int-it-nota-fisc THEN string(int-it-nota-fisc.codigo-orig) ELSE cCampo2
                           ICMS.CSOSN       = cCampo3
                           ICMS.pCredSN     = cCampo4
                           ICMS.vCredICMSSN = cCampo5
                           ICMS.cTag        = "152".

                END.
                WHEN 'N10d' THEN DO: /* novo */
                    FOR FIRST int-it-nota-fisc no-lock
                        where int-it-nota-fisc.cod-estabel = estabelec.cod-estabel
                          and int-it-nota-fisc.serie       = ide.serie
                          and int-it-nota-fisc.nr-nota-fis = string(int(ide.nNF),"9999999")
                          and int-it-nota-fisc.nr-seq-fat  = iCont * 10:
                    end.
                    CREATE ICMS.
                    ASSIGN ICMS.nItem = iCont
                           ICMS.Orig  = IF AVAIL int-it-nota-fisc THEN string(int-it-nota-fisc.codigo-orig) ELSE cCampo2
                           ICMS.CSOSN = cCampo3.
                END.
                WHEN 'N10e' THEN DO: /* novo */
                    FOR FIRST int-it-nota-fisc no-lock
                        where int-it-nota-fisc.cod-estabel = estabelec.cod-estabel
                          and int-it-nota-fisc.serie       = ide.serie
                          and int-it-nota-fisc.nr-nota-fis = string(int(ide.nNF),"9999999")
                          and int-it-nota-fisc.nr-seq-fat  = iCont * 10:
                    end.
                    CREATE ICMS.
                    ASSIGN ICMS.nItem       = iCont
                           ICMS.Orig        = IF AVAIL int-it-nota-fisc THEN string(int-it-nota-fisc.codigo-orig) ELSE cCampo2 
                           ICMS.CSOSN       = cCampo3 
                           ICMS.modBCST     = cCampo4 
                           ICMS.pMVAST      = cCampo5 
                           ICMS.pRedBCST    = cCampo6 
                           ICMS.vBCST       = cCampo7 
                           ICMS.pICMSST     = cCampo8 
                           ICMS.vICMSST     = cCampo9 
                           ICMS.pCredSN     = cCampo10
                           ICMS.vCredICMSSN = cCampo11.
                END.
                WHEN 'N10f' THEN DO: /* novo */
                    FOR FIRST int-it-nota-fisc no-lock
                        where int-it-nota-fisc.cod-estabel = estabelec.cod-estabel
                          and int-it-nota-fisc.serie       = ide.serie
                          and int-it-nota-fisc.nr-nota-fis = string(int(ide.nNF),"9999999")
                          and int-it-nota-fisc.nr-seq-fat  = iCont * 10:
                    end.
                    CREATE ICMS.
                    ASSIGN ICMS.nItem    = iCont
                           ICMS.Orig     = IF AVAIL int-it-nota-fisc THEN string(int-it-nota-fisc.codigo-orig) ELSE cCampo2 
                           ICMS.CSOSN    = cCampo3 
                           ICMS.modBCST  = cCampo4 
                           ICMS.pMVAST   = cCampo5 
                           ICMS.pRedBCST = cCampo6 
                           ICMS.vBCST    = cCampo7 
                           ICMS.pICMSST  = cCampo8 
                           ICMS.vICMSST  = cCampo9.
                END.
                WHEN 'N10g' THEN DO: /* novo */
                    FOR FIRST int-it-nota-fisc no-lock
                        where int-it-nota-fisc.cod-estabel = estabelec.cod-estabel
                          and int-it-nota-fisc.serie       = ide.serie
                          and int-it-nota-fisc.nr-nota-fis = string(int(ide.nNF),"9999999")
                          and int-it-nota-fisc.nr-seq-fat  = iCont * 10:
                    end.
                    CREATE ICMS.
                    ASSIGN ICMS.nItem      = iCont
                           ICMS.Orig       = IF AVAIL int-it-nota-fisc THEN string(int-it-nota-fisc.codigo-orig) ELSE cCampo2
                           ICMS.CSOSN      = cCampo3
                           ICMS.vBCSTRet   = cCampo4
                           ICMS.vICMSSTRet = cCampo5.
                END.
                WHEN 'N10h' THEN DO: /* novo */
                    FOR FIRST int-it-nota-fisc no-lock
                        where int-it-nota-fisc.cod-estabel = estabelec.cod-estabel
                          and int-it-nota-fisc.serie       = ide.serie
                          and int-it-nota-fisc.nr-nota-fis = string(int(ide.nNF),"9999999")
                          and int-it-nota-fisc.nr-seq-fat  = iCont * 10:
                    end.
                    CREATE ICMS.
                    ASSIGN ICMS.nItem       = iCont
                           ICMS.orig        = IF AVAIL int-it-nota-fisc THEN string(int-it-nota-fisc.codigo-orig) ELSE cCampo2 
                           ICMS.CSOSN       = cCampo3 
                           ICMS.modBC       = cCampo4 
                           ICMS.vBC         = IF cCampo5 = "" THEN "0.00" ELSE cCampo5 
                           ICMS.pRedBC      = cCampo6 
                           ICMS.pICMS       = cCampo7 
                           ICMS.vICMS       = cCampo8 
                           ICMS.modBCST     = cCampo9 
                           ICMS.pMVAST      = cCampo10
                           ICMS.pRedBCST    = cCampo11
                           ICMS.vBCST       = cCampo12
                           ICMS.pICMSST     = cCampo13
                           ICMS.vICMSST     = cCampo14
                           ICMS.vBCSTRet    = cCampo15
                           ICMS.vICMSSTRet  = cCampo16
                           ICMS.pCredSN     = cCampo17
                           ICMS.vCredICMSSN = cCampo18.
                END.
                WHEN 'o' THEN DO: /* IPI novo */
                    CREATE IPI.
                    ASSIGN IPI.nItem    = iCont
                           IPI.clEnq    = cCampo2
                           IPI.CNPJProd = cCampo3
                           IPI.cSelo    = cCampo4
                           IPI.qSelo    = cCampo5
                           IPI.cEnq     = cCampo6.
                END.
                WHEN "o07" THEN DO:
                    find first IPI
                         where IPI.nItem = iCont no-error.
                    if  not avail IPI then
                        CREATE IPI.
                    ASSIGN IPI.nItem  = iCont
                           IPI.CST    = IF cCampo2 = "" THEN "00" ELSE cCampo2
                           IPI.vIPI   = cCampo3.
                END.
                WHEN "o08" THEN DO:
                    find first IPI
                         where IPI.nItem = iCont no-error.
                    if  not avail IPI THEN DO:
                        CREATE IPI.
                    END.
                    
                    ASSIGN IPI.CST   = IF cCampo2 = "" THEN "00" ELSE cCampo2.
                END.
                WHEN "o10" THEN DO:
                    find first IPI
                         where IPI.nItem = iCont no-error.
                    if  not avail IPI then
                        CREATE IPI.
                    ASSIGN IPI.nItem   = iCont
                           IPI.vBC     = IF cCampo2 = "" THEN "0.00" ELSE cCampo2
                           IPI.pIPI    = cCampo3.
                END.
                WHEN "o11" THEN DO: /* novo */
                    CREATE IPI.
                    ASSIGN IPI.nItem = iCont
                           IPI.qUnid = cCampo2
                           IPI.vUnid = cCampo3.
                END. 
                WHEN 'P' THEN DO: /* II */
                    CREATE II.
                    ASSIGN
                        II.nItem    = iCont
                        II.vBC      = IF cCampo2 = "" THEN "0.00" ELSE cCampo2
                        II.vDespAdu = cCampo3
                        II.vII      = cCampo4
                        II.vIOF     = cCampo5.
                END.
                WHEN 'Q' THEN DO: /* PIS */
                    CREATE PIS.
                END.
                WHEN "Q02" THEN DO:   
                    ASSIGN PIS.nItem = iCont
                           PIS.CST   = cCampo2
                           PIS.vBC   = IF cCampo3 = "" THEN "0.00" ELSE cCampo3
                           PIS.pPIS  = cCampo4
                           PIS.vPIS  = cCampo5.
                END.
                WHEN "Q03" THEN DO:
                    ASSIGN PIS.nItem      = iCont
                           PIS.CST        = IF cCampo2 = "" THEN "00" ELSE cCampo2
                           PIS.qBCProd    = cCampo3
                           PIS.vAliqProd  = cCampo4
                           PIS.vPIS       = IF cCampo7 = "" THEN "0.00" ELSE cCampo7.
                END.
                WHEN "Q04" THEN DO:
                    ASSIGN PIS.nItem  = iCont
                           PIS.CST    = IF cCampo2 = "" THEN "00" ELSE cCampo2.
                             
                END.
                WHEN "Q05" THEN DO:  
                    ASSIGN PIS.nItem  = iCont
                           PIS.CST    = IF cCampo2 = "" THEN "00" ELSE cCampo2
                           PIS.vPIS   = IF cCampo3 = "" THEN "00" ELSE cCampo3
                           PIS.CST    = "99".
                    /*IF PIS.CST = "05" OR PIS.CST = "49" THEN
                        ASSIGN PIS.CST = "99".*/
                END.
                WHEN "Q07" THEN DO:
                    ASSIGN PIS.nItem  = iCont
                           PIS.vBC    = IF cCampo2 = "" THEN "00" ELSE cCampo2
                           PIS.pPIS   = IF cCampo3 = "" THEN "00" ELSE cCampo3.
                END.
                WHEN "Q10" THEN DO: /* novo */
                    ASSIGN PIS.nItem     = iCont
                           PIS.qBCProd   = cCampo2
                           PIS.vAliqProd = cCampo3.
                END.
                WHEN "R" THEN DO: /* novo */
                    CREATE PISST.
                    ASSIGN PISST.nItem = iCont
                           PISST.vPIS  = cCampo2.
                END.
                WHEN "R02" THEN DO: /* novo */
                    ASSIGN PISST.nItem = iCont
                           PISST.vBC   = IF cCampo2 = "" THEN "0.00" ELSE cCampo2
                           PISST.pPIS  = cCampo3.
                END.
                WHEN "R04" THEN DO: /* novo */
                    ASSIGN PISST.nItem     = iCont
                           PISST.qBCProd   = cCampo2
                           PISST.vAliqProd = cCampo3.
                END.
                WHEN 'S' THEN DO: /* COFINS */
                    CREATE COFINS.
                END.
                WHEN "S02" THEN DO:            
                    ASSIGN COFINS.nItem      = iCont
                           COFINS.CST        = IF cCampo2 = "" THEN "00" ELSE cCampo2
                           COFINS.vBC        = IF cCampo3 = "" THEN "0.00" ELSE cCampo3
                           COFINS.pCOFINS    = cCampo4
                           COFINS.vCOFINS    = IF cCampo5 = "" THEN "0.00" ELSE cCampo5.
                END.
                WHEN "S03" THEN DO:
                    ASSIGN COFINS.nItem      = iCont
                           COFINS.CST        = cCampo2
                           COFINS.qBCProd    = cCampo3
                           COFINS.vAliqPRod  = cCampo4
                           COFINS.vCOFINS    = IF cCampo5 = "" THEN "0.00" ELSE cCampo5.
                END.
                WHEN "S04" THEN DO:
                    ASSIGN COFINS.nItem      = iCont
                           COFINS.CST        = IF cCampo2 = "" THEN "00" ELSE cCampo2.
                END.
                WHEN "S05" THEN DO:
                    ASSIGN COFINS.nItem     = iCont
                           COFINS.CST       = IF cCampo2 = "" THEN "00" ELSE cCampo2
                           COFINS.vCOFINS   = cCampo3
                           COFINS.CST       = "99".
                    /*IF COFINS.CST = "05" OR COFINS.CST = "49" THEN
                        ASSIGN COFINS.CST = "99".*/
                END.
                WHEN "S07" THEN DO:
                    find first COFINS where COFINS.nItem = iCont no-error.
                    ASSIGN COFINS.vBC       = IF cCampo2 = "" THEN "0.00" ELSE cCampo2 
                           COFINS.pCOFINS   = cCampo3.
                END.
                WHEN "S09" THEN DO: /* novo */
                    find first COFINS where COFINS.nItem = iCont no-error.
                    ASSIGN COFINS.qBCProd   = cCampo2
                           COFINS.vAliqProd = cCampo3.
                END.
                WHEN "T" THEN DO: /* novo */
                    CREATE COFINSST.
                    ASSIGN COFINSST.nItem = iCont
                           COFINSST.vCOFINS = cCampo2.
                END.
                WHEN "T02" THEN DO: /* novo */
                    ASSIGN COFINSST.vBC     = IF cCampo2 = "" THEN "0.00" ELSE cCampo2
                           COFINSST.pCOFINS = cCampo3.
                END.
                WHEN "T04" THEN DO: /* novo */
                    ASSIGN COFINSST.qBCProd   = cCampo2
                           COFINSST.vAliqProd = cCampo3.
                END.
                WHEN "U" THEN DO: /* novo */
                    CREATE ISSQN.
                    ASSIGN ISSQN.vBC       = IF cCampo2 = "" THEN "0.00" ELSE cCampo2
                           ISSQN.vAliq     = cCampo3
                           ISSQN.vISSQN    = cCampo4
                           ISSQN.cMunFG    = cCampo5
                           ISSQN.cListServ = cCampo6
                           ISSQN.cSitTrib  = cCampo7
                           ISSQN.nItem     = iCont.
                END.
                WHEN 'W' THEN DO: /* Valores totais da NFE */
                END.
                WHEN "W02" THEN DO:
                    ASSIGN de-vl-tot-icms = 0
                           d-total-icms   = 0.
                    FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
                        FOR FIRST natur-oper
                            WHERE natur-oper.nat-operacao = it-nota-fisc.nat-operacao NO-LOCK:
                            ASSIGN l-icms-outras-it = natur-oper.log-consid-icms-outras.
                        END.
                        FOR FIRST ITEM
                            WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-LOCK:
                            IF  it-nota-fisc.cod-servico = 0 OR
                                ITEM.cod-servico         = 0 THEN DO:
                                ASSIGN de-vl-tot-icms = de-vl-tot-icms + it-nota-fisc.vl-bicms-it.
                                       d-total-icms   = d-total-icms   + (IF  it-nota-fisc.cd-trib-icm = 1                           /*Tributado*/
                                                          OR (it-nota-fisc.cd-trib-icm = 3 AND l-icms-outras-it)     /*Outras e Considera Tributos Outras na NF-e */
                                                          OR  it-nota-fisc.cd-trib-icm = 4                           /*Reduzido  */
                                                          THEN it-nota-fisc.vl-icms-it
                                                          ELSE 0).
                            END.
                        END.
                    END.
                    
                    CREATE TOTAL.    
                    CREATE ICMSTot.
                    ASSIGN ICMSTot.vBC      = IF de-vl-tot-icms = 0 THEN cCampo2 ELSE trim(REPLACE(string(de-vl-tot-icms,">>>>>>>>>>>9.99"),",","."))
                           ICMSTot.vICMS    = IF d-total-icms   = 0 THEN cCampo3 ELSE trim(replace(string(d-total-icms,">>>>>>>>>>>9.99"),",","."))
                           ICMSTot.vBCST    = IF cCampo4  = "" THEN "0.00" ELSE cCampo4
                           ICMSTot.vST      = IF cCampo5  = "" THEN "0.00" ELSE cCampo5
                           ICMSTot.vProd    = IF cCampo6  = "" THEN "0.00" ELSE cCampo6.
                    /* 08-11-2011 - GATI
                    IF AVAIL nota-fiscal THEN
                        ASSIGN ICMSTot.vProd    = replace(trim(string(TRUNCATE(nota-fiscal.vl-mercad / de-conv, 2),'>>>>>>>>>9.99')),',','.') /*cCampo6*/.
                    */
                    ASSIGN ICMSTot.vFrete   = IF cCampo7  = "" THEN "0.00" ELSE cCampo7
                           ICMSTot.vSeg     = IF cCampo8  = '' THEN '0.00' ELSE cCampo8
/*                            ICMSTot.vDesc    = "0.00" /*cCampo9 por solicitaá∆o do Rogerio Controladoria. */  a partir de 1/02/2012 devera ser enviado conforme verificado com Thiago */
                           ICMSTot.vDesc    = IF cCampo9  = '' THEN '0.00' ELSE cCampo9
                           ICMSTot.vII      = IF cCampo10  = '' THEN '0.00' ELSE cCampo10
                           ICMSTot.vIPI     = IF cCampo11  = '' THEN '0.00' ELSE cCampo11
                           ICMSTot.vPIS     = IF cCampo12  = '' THEN '0.00' ELSE cCampo12
                           ICMSTot.vCOFINS  = IF cCampo13  = '' THEN '0.00' ELSE cCampo13
                           ICMSTot.vOutro   = IF cCampo14  = '' THEN '0.00' ELSE cCampo14
                           ICMSTot.vNF      = IF cCampo15  = '' THEN '0.00' ELSE cCampo15
                           iCMSTOT.vTotTrib = IF cCampo16 = "" THEN "0.00" ELSE cCampo16. /* Total Tributo Item */

                    /*if can-find(first II)
                    or can-find(first DI) AND AVAIL NOTA-FISCAL then do:
                        run piImportacao (output ICMSTot.vPIS,
                                          output ICMSTot.vCOFINS).
                    end.*/
                    
/*                     IF AVAIL NOTA-FISCAL AND natur-oper.nat-operacao BEGINS "3" THEN DO: */
/*                         run piOutrasDespesas.                                            */
/*                     END.                                                                 */
        
                END.
                WHEN "W17" THEN DO: /* novo */
                    IF cCampo2 <> '' OR cCampo3 <> '' OR 
                       cCampo4 <> '' OR cCampo5 <> '' OR cCampo6 <> '' THEN DO:

                        IF DEC(cCampo2) <> 0 OR DEC(cCampo3) <> 0 OR DEC(cCampo4) <> 0 OR DEC(cCampo5) <> 0 OR DEC(cCampo6) <> 0 THEN DO:

                            CREATE ISSQNtot.
                            ASSIGN ISSQNtot.vServ   = cCampo2
                                   ISSQNtot.vBC     = cCampo3
                                   ISSQNtot.vISS    = cCampo4
                                   ISSQNtot.vPIS    = cCampo5
                                   ISSQNtot.vCOFINS = cCampo6.
                        END.
                    END.
                END.
                WHEN 'W23' THEN DO: /* Valores totais da NFE - novo */
                    IF cCampo2 <> '' OR cCampo3 <> '' OR 
                       cCampo4 <> '' OR cCampo5 <> '' OR 
                       cCampo6 <> '' OR cCampo7 <> '' or
                       cCampo8 <> '' THEN DO:
                        CREATE RetTrib.
                        ASSIGN RetTrib.vRetPIS    = cCampo2
                               RetTrib.vRetCOFINS = cCampo3
                               RetTrib.vRetCSLL   = cCampo4
                               RetTrib.vBCIRRF    = cCampo5
                               RetTrib.vIRRF      = cCampo6
                               RetTrib.vBCRetPrev = cCampo7
                               RetTrib.vRetPrev   = cCampo8.
                    END.
                END.
                WHEN 'X' THEN DO: /* Transporte */
                    FIND FIRST transp NO-ERROR.
                    IF  NOT AVAIL transp THEN
                        CREATE transp.
                    assign transp.modFrete = cCampo2
                           transp.balsa    = cCampo3 /* novo */
                           transp.vagao    = cCampo4 /* novo */ .
                END.
                WHEN "X03" THEN DO: /* Transportadora */
                    IF cCampo2 = ? or cCampo2 = '' or cCampo2 = 'REMETENTE' or cCampo2 = 'DESTINATARIO' THEN DO:
                        /*for first transporte no-lock
                        where transporte.cod-transp = 0.
                            CREATE transporta.
                            ASSIGN transporta.xNome   = transporte.nome
                                   transporta.IE      = IF transporte.ins-estadual = '' THEN 'ISENTO' ELSE transporte.ins-estadual
                                   transporta.xEnder  = if transporte.endereco = '' then 'Nao informado' else transporte.endereco
                                   transporta.xMun    = transporte.cidade
                                   transporta.UF      = transporte.estado
                                   transporta.cnpj    = if transporte.cgc = '' then '99999999999' else transporte.cgc.
                        END.*/
                    END.
                    ELSE DO:
                        CREATE transporta.
                        ASSIGN transporta.xNome   = cCampo2
                               transporta.IE      = IF cCampo3 = '' THEN 'ISENTO' ELSE cCampo3
                               transporta.xEnder  = if cCampo4 = '' then 'Nao informado' else cCampo4
                               transporta.xMun    = cCampo6
                               transporta.UF      = cCampo5
                               transporta.cnpj    = '99999999999'.
                    END.           
                END.
                WHEN "X04" THEN DO:
                    FIND FIRST transporta no-error.
                        IF AVAIL transporta and cCampo2 <> ? THEN DO:

                            ASSIGN transporta.CNPJ = if cCampo2 = '' then '99999999999999' else cCampo2.
                            FIND transporte
                                 WHERE transporte.cgc = cCampo2 NO-LOCK NO-ERROR.
                            IF AVAIL transporte THEN DO:
                                ASSIGN transporta.IE = replace(replace(transporte.ins-estadual,".",""),"/","").
                            END.

                        END.
                END.
                WHEN "X05" THEN DO:
                    FIND FIRST transporta no-error.
                        IF AVAIL transporta and cCampo2 <> ? THEN
                            ASSIGN transporta.CPF = cCampo2.
                END.
                WHEN "X11" THEN DO: /* novo */
                    CREATE retTransp.
                    ASSIGN retTransp.vServ    = cCampo2
                           retTransp.vBCRet   = cCampo3
                           retTransp.pICMSRet = cCampo4
                           retTransp.vICMSRet = cCampo5
                           retTransp.CFOP     = cCampo6
                           retTransp.cMunFG   = cCampo7.
                END.
                WHEN "X18" THEN DO: /* novo */
                    CREATE veicTransp.
                    ASSIGN veicTransp.placa = cCampo2
                           veicTransp.UF    = cCampo3
                           veicTransp.RNTC  = cCampo4.
                END.
                WHEN "X22" THEN DO: /* novo */
                    CREATE reboque.
                    ASSIGN reboque.placa = cCampo2
                           reboque.UF    = cCampo3
                           reboque.RNTC  = cCampo4.
                END.
                WHEN "X26" THEN DO: /* Volumes transportados */
                    FOR EACH vol.        DELETE vol.         END.
                    for first nota-fiscal no-lock
                        where nota-fiscal.cod-estabel = nfe-param.cod-estabel
                          and nota-fiscal.serie       = ide.serie
                          and nota-fiscal.nr-nota-fis = string(int(ide.nNF),"9999999"):
                    END.
                    ASSIGN cCampo5 = nota-fiscal.nr-volumes
                           cCampo6 = replace(trim(string(TRUNCATE(nota-fiscal.peso-liq-tot,3),'>>>>>9.999')),',','.')
                           cCampo7 = replace(trim(string(TRUNCATE(nota-fiscal.peso-bru-tot,3),'>>>>>9.999')),',','.').

                    CREATE vol.
                    ASSIGN 
                        vol.qVol  = IF cCampo5 = ? OR cCampo5 = '' THEN "00" ELSE cCampo5   /*IF cCampo2 = ? OR cCampo2 = '' THEN "00" ELSE cCampo2*/
                        vol.esp   = "VOLUME" /* IF cCampo3 = ? OR cCampo3 = '' THEN "00" ELSE cCampo3 */
                        vol.marca = "INTELBRAS" /*IF cCampo4 = ? OR cCampo4 = '' THEN "00" ELSE cCampo4**/
                        vol.nVol  = "" /* IF cCampo5 = ? OR cCampo5 = '' THEN "00" ELSE cCampo5 */
                        vol.pesoL = cCampo6
                        vol.pesoB = cCampo7.

                END.       
                WHEN "X33" THEN DO: /* NOVO */
                    CREATE lacres.
                    ASSIGN lacres.nLacre = cCampo2.
                END.
                WHEN 'Y' then do: /* Cobranca */
                    CREATE cobr.
                end.
                WHEN "Y02" THEN DO: /* fat */
                    CREATE fat.                           
                    ASSIGN fat.nFat  = cCampo2            
                           fat.vOrig = cCampo3            
                           fat.vDesc = cCampo4            
                           fat.vLiq  = cCampo5.           
                END.
                WHEN "Y07" THEN DO:
                    IF substring(cCampo2,8,1) = "/" THEN
                        ASSIGN substring(cCampo2,8,1) = "".
                    CREATE dup.
                    ASSIGN dup.nDup  = cCampo2
                           dup.dVenc = cCampo3
                           dup.vDup  = cCampo4.
                END.
                WHEN 'Z' then do: /* Observacao */
                    FOR FIRST estabelec no-lock
                        where estabelec.cgc = emit.cnpj.
                               
                        if not can-find(first nfe
                                        where nfe.cod-estabel = estabelec.cod-estabel
                                          and nfe.serie       = ide.serie
                                          and nfe.nr-nota-fis = string(int(ide.nNF),"9999999")) then do:
                            create nfe.
                            assign 
                                nfe.acao                = 1
                                nfe.cod-estabel         = estabelec.cod-estabel
                                nfe.IDI-SIT-NF-ELETRO   = 1
                                nfe.nr-nota-fis         = string(int(ide.nNF),"9999999")
                                nfe.serie               = ide.serie.
                        end.                  
                    end.
                    for first nota-fiscal exclusive-lock
                        where nota-fiscal.cod-estabel = nfe-param.cod-estabel
                          and nota-fiscal.serie       = ide.serie
                          and nota-fiscal.nr-nota-fis = string(int(ide.nNF),"9999999"),
                        first natur-oper of nota-fiscal no-lock.

                        IF nota-fiscal.nat-operacao begins "3" then do:

                            assign de-pis = 0
                                   de-cofins = 0.
                            
                            FOR EACH item-doc-est NO-LOCK
                                WHERE item-doc-est.serie-docto = nota-fiscal.serie
                                  AND item-doc-est.nro-docto = nota-fiscal.nr-nota-fis
                                  AND item-doc-est.cod-emitente = nota-fiscal.cod-emitente
                                  AND item-doc-est.nat-operacao = nota-fiscal.nat-operacao:
                                ASSIGN de-pis    = de-pis    + item-doc-est.valor-pis
                                       de-cofins = de-cofins + item-doc-est.val-cofins.
                                
                            END.

                            IF de-pis > 0 OR
                               de-cofins > 9 THEN
                               ASSIGN cCampo3                  = cCampo3                + " PIS: " + trim(STRING(de-pis,">>>>,>>9.99")) + " COFINS: " + trim(STRING(de-cofins,">>>>,>>9.99")) 
                                      nota-fiscal.observ-nota = nota-fiscal.observ-nota + " PIS: " + trim(STRING(de-pis,">>>>,>>9.99")) + " COFINS: " + trim(STRING(de-cofins,">>>>,>>9.99")).
                        END.
                        IF natur-oper.tipo = 1 THEN
                            ASSIGN cCampo3                 = cCampo3                 + " Cliente: " + STRING(nota-fiscal.cod-emitente)
                                   nota-fiscal.observ-nota = nota-fiscal.observ-nota + " Cliente: " + STRING(nota-fiscal.cod-emitente).

                    END.        

                    create infAdic.

                    ASSIGN infAdic.infAdFisco = if cCampo2 = ? then '' else fEditor(fn-free-accent(cCampo2)).
                    
                    RUN RetiraAcentos (INPUT-OUTPUT infAdic.infAdFisco).

                  
                    ASSIGN infAdic.infCpl     = if cCampo3 = ? then '' else fEditor(fn-free-accent(replaceEspecialChars(cCampo3))).

                    RUN RetiraAcentos (INPUT-OUTPUT infAdic.infCpl).

                    FIND FIRST nota-fiscal NO-LOCK
                        WHERE  nota-fiscal.cod-estabel = estabelec.cod-estabel
                        AND    nota-fiscal.serie       = ide.serie
                        AND    nota-fiscal.nr-nota-fis = STRING(INT(ide.nNF), "9999999") NO-ERROR.
                    IF  AVAIL  nota-fiscal THEN DO:
                        FIND FIRST fat-comercial
                            WHERE fat-comercial.cod-estabel  = nota-fiscal.cod-estabel  
                              AND fat-comercial.serie        = nota-fiscal.serie       
                              AND fat-comercial.nr-nota-fis  = nota-fiscal.nr-nota-fis 
                            NO-LOCK NO-ERROR.
                        IF AVAIL fat-comercial THEN DO:
                            IF fat-comercial.nr-nota-fis <> '' THEN DO:
                                FIND FIRST ponto-programa
                                    where ponto-programa.nome-programa = "esft067"
                                      AND ponto-programa.ponto         = 2 NO-LOCK NO-ERROR.
                                IF AVAIL ponto-programa THEN DO:
                                    IF CAN-FIND(FIRST conteudo-programa NO-LOCK
                                    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                                      AND conteudo-programa.conteudo     = nota-fiscal.cod-estabel) THEN DO:
                                        CREATE obsCont.
                                        ASSIGN obsCont.xTexto = 'manual'.
                                    END.
                                    ELSE DO:
                                        CREATE obsCont.
                                        ASSIGN obsCont.xTexto = 'auto'.
                                    END.
                                END. /* IF AVAIL pronto-programa THEN DO: */
                                ELSE DO:
                                    CREATE obsCont.
                                    ASSIGN obsCont.xTexto = 'auto'.
                                END.
                            END. /* IF fat-comercial.nr-nota-fis = '' THEN DO: */
                            ELSE DO:
                                CREATE obsCont.
                                ASSIGN obsCont.xTexto = 'auto'.
                            END. /* IF fat-comercial.nr-nota-fis <> '' THEN DO: */
                        END. /* IF AVAIL fat-comercial THEN DO: */
                        ELSE DO:
                            CREATE obsCont.
                            ASSIGN obsCont.xTexto = 'auto'.
                        END. /* IF NOT AVAIL fat-comercial THEN DO: */
                    END. /* IF  AVAIL  nota-fiscal THEN DO: */

                    /* Busca a impressora do usu†rio, ou a impressora padr∆o */
                    FIND FIRST usuario-impressora NO-LOCK
                        WHERE  usuario-impressora.cod-estabel = nota-fiscal.cod-estabel
                        AND    usuario-impressora.serie       = nota-fiscal.serie
                        AND    usuario-impressora.cod-usuario = c-seg-usuario NO-ERROR.
                    IF  AVAIL  usuario-impressora THEN DO:
              
                        CREATE obsCont.
                        ASSIGN obsCont.xTexto = usuario-impressora.impressora.

                    END. /* IF  AVAIL  usuario-impressora THEN DO: */
                    ELSE DO:
                        FIND FIRST impressora-padrao NO-LOCK
                            WHERE  impressora-padrao.cod-estabel = nota-fiscal.cod-estabel
                            AND    impressora-padrao.serie       = nota-fiscal.serie NO-ERROR.
                        IF  AVAIL  impressora-padrao THEN DO:

                            CREATE obsCont.
                            ASSIGN obsCont.xTexto = impressora-padrao.impressora.

                        END. /* IF  AVAIL  usuario-impressora THEN DO: */

                    END. /* IF  AVAIL  usuario-impressora THEN DO: */

/*                     CREATE obsCont.                       */
/*                     ASSIGN obsCont.xTexto = c-impressora. */
          
                    /*
                    FIND infAdic NO-ERROR.
                    IF  NOT AVAIL infAdic THEN
                        create infAdic.
                    assign
                        infAdic.infAdFisco = if cCampo2 = ? then '' else fEditor(cCampo2)
                        infAdic.infCpl     = if cCampo3 = ? then '' else fEditor(cCampo3).
                   */
                end.
                WHEN "Z04" THEN DO: /* novo */
                    CREATE ObsCont.
                    ASSIGN /*ObsCont.xCampo = cCampo2*/
                           ObsCont.xTexto = cCampo3.
                END.
                WHEN "Z10" THEN DO: /* novo */
                    CREATE ProcRef.
                    ASSIGN ProcRef.nProc   = cCampo2
                           ProcRef.indProc = cCampo3.
                END.
                WHEN 'ZA' THEN DO: /* tag de exportacao */
                    CREATE exporta.
                    ASSIGN exporta.UFEmbarq   = cCampo2
                           exporta.xLocEmbarq = cCampo3.
                END.
                WHEN 'ZB' THEN DO: /* tag do grupo de compra */
                    CREATE compra.
                    ASSIGN compra.XNEmp = cCampo2
                           compra.XPed  = c-xped
                           compra.XCont = cCampo4.
                END.
                WHEN 'ZC' THEN DO: /* novo */
                    CREATE Cana.
                    ASSIGN Cana.safra    = cCampo2
                           Cana.ref      = cCampo3
                           Cana.qTotMes  = cCampo4
                           Cana.qTotAnt  = cCampo5
                           Cana.qTotGer  = cCampo6
                           Cana.vFor     = cCampo7
                           Cana.vTotDed  = cCampo8
                           Cana.vLiqFor  = cCampo9.
                END.
                WHEN 'ZC04' THEN DO: /* novo */
                    CREATE ForDia.
                    ASSIGN ForDia.dia  = cCampo2
                           ForDia.qtde = cCampo3.
                END.
                WHEN 'ZC10' THEN DO: /* novo */
                    CREATE Deduc.
                    ASSIGN Deduc.xDed = cCampo2
                           Deduc.vDed = cCampo3.
                END.
                OTHERWISE DO:
                    if AVAIL nfe-param AND cCampo1 <> '' then do:
                        IF opsys <> 'WIN32' then
                            output to value(nfe-param.end-imp-txt-unix + 'log_' + string(today,'99-99-9999') + '.txt') no-convert append.
                        else    
                            output to value(nfe-param.end-imp-txt + 'log_' + string(today,'99-99-9999') + '.txt') no-convert append.
                    
                        put unformatted 'TAG NAO IDENTIFICADA ' cCampo1 ' - ' TT_File.FILENAME + ' - Linha ' iLinha skip.
                        output close.                        
                    END.
                END.
            END CASE.
    
            ASSIGN cCampo1   = ""
                   cCampo2   = ""
                   cCampo3   = ""
                   cCampo4   = ""
                   cCampo5   = ""
                   cCampo6   = ""
                   cCampo7   = ""
                   cCampo8   = ""
                   cCampo9   = ""
                   cCampo10  = ""
                   cCampo11  = ""
                   cCampo12  = ""
                   cCampo13  = ""
                   cCampo14  = ""
                   cCampo15  = ""
                   cCampo16  = ""
                   cCampo17  = ""
                   cCampo18  = ""
                   cCampo19  = "".
        
        END.
     
        RUN pi-geraXML.

        RUN piDelArquivo.
        INPUT CLOSE.
        
    END.
    
    RETURN "OK":U.
              
END PROCEDURE.

PROCEDURE pi-geraXML.
    FOR each estabelec no-lock
        where estabelec.cgc = emit.cnpj,
        first ser-estab no-lock
        where ser-estab.serie              = ide.serie
          and ser-estab.cod-estabel        = estabelec.cod-estabel
          and ser-estab.log-nf-eletro,  /* indica se emite nota fiscal eletronica */
        first nfe-param no-lock
        where nfe-param.cod-estabel = estabelec.cod-estabel.
    
        if not can-find(first nfe
                        where nfe.cod-estabel = estabelec.cod-estabel
                          and nfe.serie       = ide.serie
                          and nfe.nr-nota-fis = string(int(ide.nNF),"9999999")) then do:
            create nfe.
            assign 
                nfe.acao                = 11
                nfe.cod-estabel         = estabelec.cod-estabel
                nfe.IDI-SIT-NF-ELETRO   = 1
                nfe.nr-nota-fis         = string(int(ide.nNF),"9999999")
                nfe.serie               = ide.serie.
        end.                  
    end.
    
    FIND FIRST ide NO-LOCK NO-ERROR.
    IF AVAIL ide THEN DO:

        FOR each estabelec no-lock
            where estabelec.cgc = emit.cnpj,
            first ser-estab no-lock
            where ser-estab.serie              = ide.serie
              and ser-estab.cod-estabel        = estabelec.cod-estabel
              and ser-estab.log-nf-eletro . /* indica se emite nota fiscal eletronica */

/*             MESSAGE 'estabelec.cod-estabel            ' estabelec.cod-estabel           SKIP               */
/*                     'ide.serie                        ' ide.serie                       SKIP               */
/*                     'string(int(ide.nNF),"9999999")   ' string(int(ide.nNF),"9999999")  VIEW-AS ALERT-BOX. */

            FIND FIRST nota-fiscal
                WHERE nota-fiscal.cod-estabel = estabelec.cod-estabel          
                  AND nota-fiscal.serie       = ide.serie                      
                  AND nota-fiscal.nr-nota-fis = string(int(ide.nNF),"9999999") NO-LOCK NO-ERROR.
            IF AVAIL nota-fiscal THEN DO:

/*                 MESSAGE 'Existe Nota' nota-fiscal.cgc  */
/*                     VIEW-AS ALERT-BOX INFO BUTTONS OK. */

                find first dest no-error.
                if avail dest then DO:

/*                     MESSAGE 'Existe dest ' nota-fiscal.cgc  dest.cnpj */
/*                         VIEW-AS ALERT-BOX INFO BUTTONS OK.            */

                    FIND FIRST emitente WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.
                    IF AVAIL emitente THEN DO:
                        IF  dest.CNPJ = '' 
                        AND dest.cpf  = '' THEN DO:
                            RUN XML-Gera.
                        END.
                        ELSE DO:

                            IF dest.CNPJ = ''  THEN DO:
                                IF nota-fiscal.cgc = dest.cpf THEN DO:
                                    RUN XML-Gera.
                                END.
                                ELSE DO:
                                    RUN piDelArquivo.
                                END.
                            END. /* IF dest.CNPJ = ''  THEN DO: */
                            ELSE DO:
                                IF nota-fiscal.cgc = dest.cnpj THEN DO:
                                        RUN XML-Gera.
                                END.
                                ELSE DO:
                                    RUN piDelArquivo.
                                END.
                            END. /* IF dest.CNPJ <> ''  THEN DO: */

                        END. /* IF dest.xNome <> emitente.nome THEN DO: */

                    END. /* IF AVAIL emitente THEN DO: */

                END. /* if avail dest then DO: */

            END. /* IF AVAIL nota-fiscal THEN DO: */

        END. /* FOR each estabelec no-lock */

    END. /* IF AVAIL ide THEN DO: */

    
    /*run gtp/gtnf001b.p persistent set hXMLGera.
    run XML-Gera IN hXMLGera (input table ide,
                              input table nfref,     
                              input table ObsCont,   
                              input table ObsFisco,  
                              input table ProcRef,   
                              input table exporta,   
                              input table imposto,   
                              input table ICMS00,    
                              input table ICMS10,    
                              input table ICMS20,    
                              input table ICMS30,    
                              input table ICMS40,    
                              input table ICMS51,    
                              input table ICMS60,    
                              input table ICMS70,    
                              input table ICMS90,    
                              input table ICMSTot,   
                              input table ICMS,      
                              input table IPI ,      
                              input table PIS,       
                              input table PISAliq,   
                              input table PISNT,     
                              input table PISOutr,   
                              input table PISST,     
                              input table COFINS,    
                              input table COFINSAliq,
                              input table COFINSNT,  
                              input table COFINSOutr,
                              input table COFINSQtde,
                              input table COFINSST,  
                              input table ISS,     
                              input table ISSQNtot,  
                              input table II,        
                              input table med,       
                              input table compra,    
                              input table emit,      
                              input table enderEmit, 
                              input table dest,      
                              input table enderDest, 
                              input table entrega,   
                              input table det,       
                              input table di,        
                              input table adi,       
                              input table prod,      
                              input table cEnq,      
                              input table TOTAL,     
                              input table Transp,    
                              input table transporta,
                              input table retTransp, 
                              input table veicTransp,
                              input table reboque,   
                              input table lacres,    
                              input table veicProd,  
                              input table dup,       
                              input table cobr,      
                              input table fat,       
                              input table ttMsgFISCO,  
                              input table ttMsgCONTR,  
                              input table infAdic,   
                              input table vol,       
                              input table comb,      
                              input table retirada,  
                              input table arma,      
                              input table retTrib,   
                              input table refNF,
                              INPUT TABLE refNFP, /*daniel*/
                              INPUT TABLE refCTe,
                              INPUT TABLE refECF,
                              INPUT TABLE cana,
                              INPUT TABLE ForDia,
                              INPUT TABLE Deduc,
                              INPUT TABLE avulsa ).
                                    
    DELETE OBJECT hXMLGera.*/
    
    {esp/ftp/esft067.i1} /* delete temp-table */
    
    assign iContDest = 0
           iCont     = 0.


END PROCEDURE.

PROCEDURE piICMS.

    if avail ICMS then do:
        case ICMS.CST.
            when '41' then assign icms.ctag = '40'.
            when '50' then assign icms.ctag = '40'.
            otherwise assign icms.cTag = icms.CST.                
        end case.            
    
        if icms.cTag = '' then
            assign icms.cTag = '00'.
        if icms.orig = '' then
            assign icms.orig = '00'.
        if icms.CST = '' then
            assign icms.CST = '00'. 
    END.

END PROCEDURE.

PROCEDURE piDelArquivo. 
    DEFINE VARIABLE iErroStatus AS INTEGER NO-UNDO.

    IF TT_File.FullPath MATCHES('*NFe_*')  THEN
    OS-DELETE VALUE(TT_File.FullPath).
    ASSIGN iErroStatus = OS-ERROR.
    IF iErroStatus <> 0 THEN
        RETURN 'NOK'.
        
    RETURN 'OK'.

END PROCEDURE.

procedure piImportacao.
    DEF OUTPUT PARAM opcPIS     AS CHARACTER.
    DEF OUTPUT PARAM opcCOFINS  AS CHARACTER. 

    assign de-pis = 0 de-cofins = 0.
    FOR FIRST estabelec no-lock
        where estabelec.cgc = emit.cnpj,
        first nota-fiscal no-lock
        where nota-fiscal.cod-estabel = estabelec.cod-estabel
          and nota-fiscal.serie       = ide.serie
          and nota-fiscal.nr-nota-fis = string(int(ide.nNF),"9999999"),
        EACH item-doc-est NO-LOCK
        WHERE item-doc-est.serie-docto  = nota-fiscal.serie
          AND item-doc-est.nro-docto    = nota-fiscal.nr-nota-fis
          AND item-doc-est.cod-emitente = nota-fiscal.cod-emitente
          AND item-doc-est.nat-operacao = nota-fiscal.nat-operacao:         
        
        ASSIGN de-pis    = de-pis    + item-doc-est.valor-pis
               de-cofins = de-cofins + item-doc-est.val-cofins.
        
/*         ASSIGN de-pis    = de-pis    + DECIMAL(SUBSTRING(item-doc-est.char-2, 40,14))  */
/*                de-cofins = de-cofins + DECIMAL(SUBSTRING(item-doc-est.char-2,102,14)). */

    END.
    
    assign 
        opcPIS    = replace(trim(string(de-pis,'>>>>>>>>>>9.99')),',','.')
        opcCOFINS = replace(trim(string(de-cofins,'>>>>>>>>>>9.99')),',','.').
end procedure.

procedure piOutrasDespesas.
    FIND docum-est NO-LOCK
        WHERE docum-est.serie = nota-fiscal.serie
          AND docum-est.nro-docto = nota-fiscal.nr-nota-fis
          AND docum-est.cod-emitente = nota-fiscal.cod-emitente
          AND docum-est.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.                    
    
        IF AVAILABLE docum-est THEN DO:
            FIND docum-est-cex NO-LOCK
                WHERE docum-est-cex.serie = nota-fiscal.serie
                  AND docum-est-cex.nro-docto = string(nota-fiscal.nr-nota-fis)
                  AND docum-est-cex.cod-emitente = nota-fiscal.cod-emitente
                  AND docum-est-cex.nat-operacao = nota-fiscal.nat-operacao 
                  AND docum-est-cex.cod-desp  = 1 /*** IMPOSTO IMPORTACAO ***/
                NO-ERROR.
            IF AVAILABLE docum-est-cex THEN DO:            
               IF docum-est.aliquota-icm <> 0 THEN
                    ASSIGN ICMSTot.vOutro = replace(trim(string(TRUNCATE(docum-est.valor-outras /*- docum-est.icm-deb-cre - docum-est-cex.val-desp - de-pis - de-cofins*/,2),'>>>>>>>>>9.99')),',','.').
               ELSE
                    ASSIGN ICMSTot.vOutro = replace(trim(string(TRUNCATE(docum-est.valor-outras /*- docum-est-cex.val-desp - de-pis - de-cofins*/,2),'>>>>>>>>>9.99')),',','.').
                   
            END.
            ELSE
                ASSIGN ICMSTot.vOutro = replace(trim(string(TRUNCATE(docum-est.valor-outras /*- de-pis - de-cofins*/,2),'>>>>>>>>>9.99')),',','.').
    
            IF docum-est.valor-frete <> 0 then do:
                ASSIGN ICMSTot.vFrete = replace(trim(string(TRUNCATE(docum-est.valor-frete,2),'>>>>>>>>>9.99')),',','.').
            end. 
           
    
            if docum-est.valor-seguro <> 0 then do:
                ASSIGN ICMSTot.vSeg = replace(trim(string(TRUNCATE(docum-est.valor-seguro,2),'>>>>>>>>>9.99')),',','.').
            end.   
    
        END.
      
        FIND despesa-aces NO-LOCK
            WHERE despesa-aces.ser-docto-ac  = nota-fiscal.serie
              AND despesa-aces.nro-docto-ac  = nota-fiscal.nr-nota-fis
              AND despesa-aces.cod-forn-ac   = nota-fiscal.cod-emitente NO-ERROR.
        IF AVAILABLE despesa-aces THEN DO:
            ASSIGN ICMSTot.vOutro = replace(trim(string(TRUNCATE(despesa-aces.valor,2),'>>>>>>>>>9.99')),',','.').
        END.
end procedure.


PROCEDURE pi-narrativa-item:
    DEF INPUT PARAMETER  c-cod-estabel LIKE estabelec.cod-estabel.
    DEF INPUT PARAMETER  c-item        LIKE ITEM.it-codigo.
    DEF OUTPUT PARAMETER c-desc-prod  AS CHARACTER.

    DEFINE VARIABLE c-narrativa AS CHARACTER   NO-UNDO.

    /*---------------------------------------------------------------------------------+
     | Valores poss≠veis para o campos item.ind-imp-desc - Forma de Descriªío do Item: |
     |  1 - Descriªío                                                                  |
     |  2 - Descriªío + Narrativa do Item                                              |
     |  3 - Descriªío + Narrativa do Item X Cliente                                    |
     |  4 - Descriªío + Narrativa Informada                                            |
     |  5 - Narrativa do Item                                                          |
     |  6 - Uma Linha da Narrativa do Item                                             |
     |  7 - Narrativa Informada                                                        |
     |  8 - Descriªío + 24 Caracteres da Narrativa do Item X Cliente                   |
     |  9 - Descriªío + 24 Caracteres da Narrativa Informada                           | 
     | 10 - Descriªío + 24 Caracteres da Narrativa do Item                             |
     +---------------------------------------------------------------------------------*/


    /*------  PESQUISA A DESCRICAO DO PRODUTO  ------ */
              
    if item.ind-imp-desc = 1 then /* Descriªío */
        assign c-desc-prod = item.desc-item.
    
    if  item.ind-imp-desc = 2           /* Descriªío + Narrativa */
    or  item.ind-imp-desc = 5           /* Narrativa Item */
    or  item.ind-imp-desc = 6           /* Uma Linha Narrativa */
    or  item.ind-imp-desc = 10 then do: /* Descriªío + 24 Narrativa Item */
    
        if  item.ind-imp-desc = 2
        or  item.ind-imp-desc = 10 then
            assign c-desc-prod = item.desc-item + " ".
        else 
            assign c-desc-prod = "".
    
        find narrativa of item no-lock no-error.
    
        if avail narrativa then DO:
            IF INDEX(narrativa.descricao,"#MANAUS#") <> 0 THEN DO:
                RUN esp/es0204.p (INPUT c-cod-estabel,
                                  INPUT c-item,
                                  OUTPUT c-narrativa).
            END.
            ELSE
                ASSIGN c-narrativa = narrativa.descricao.

            assign c-desc-prod = c-desc-prod +
                                 if  item.ind-imp-desc = 6 then
                                     trim(entry(1,substring(c-narrativa,1,76),chr(10)))
                                 else if item.ind-imp-desc = 10 then
                                     trim(entry(1,substring(c-narrativa,1,24),chr(10)))
                                 else                        
                                     c-narrativa.

        END.
    end.
    
    if  item.ind-imp-desc = 3          /* Descriªío + Narrativa Item/Cliente */
    or  item.ind-imp-desc = 8 then do: /* Descriªío + 24 Narrativa Item/Cliente */

        find item-cli
             where item-cli.nome-abrev = nota-fiscal.nome-ab-cli
             and   item-cli.it-codigo  = ITEM.it-codigo
             no-lock no-error.
        
        assign c-desc-prod = item.desc-item + " ".
    
        if  avail item-cli then     DO:
        
            assign c-desc-prod = c-desc-prod +
                                 if item.ind-imp-desc = 3 then          
                                    item-cli.narrativa
                                 else
                                    trim(entry(1,substring(item-cli.narrativa,1,24),chr(10))).

        END.
    end.
    
    if  item.ind-imp-desc = 4            /* Descriªío + Narrativa Informada */
    or  item.ind-imp-desc = 7            /* Narrativa Informada */
    or  item.ind-imp-desc = 9 then do:   /* Descriªío + 24 Narrativa Informada */
    
        if  item.ind-imp-desc = 4
        or  item.ind-imp-desc = 9 then
            assign c-desc-prod = item.desc-item + " ".
        else 
            assign c-desc-prod = "".
    
        find nar-it-nota
             where nar-it-nota.cod-estabel  = estabelec.cod-estabel                                     
             and   nar-it-nota.serie        = ide.serie                                                 
             and   nar-it-nota.nr-nota-fis  = string(int(ide.nNF),"9999999")                            
             and   nar-it-nota.nr-sequencia = iCont * 10
             and   nar-it-nota.it-codigo    = ITEM.it-codigo
             no-lock no-error.
    
        if avail nar-it-nota then 
           assign c-desc-prod = c-desc-prod +
                                if item.ind-imp-desc = 9 then
                                   trim(entry(1,substring(nar-it-nota.narrativa,1,24),chr(10)))
                                else
                                   nar-it-nota.narrativa.
    end.

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
