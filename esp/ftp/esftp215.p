DEFINE INPUT PARAM p-r-nota-fiscal AS ROWID.
DEFINE INPUT PARAM p-arquivo-danfe AS CHAR.
/* DEFINE VARIABLE p-r-nota-fiscal AS ROWID       NO-UNDO. */

{include/pdf_inc.i "THIS-PROCEDURE"}
{utp/ut-glob.i}
DEFINE VARIABLE c-arquivo-pdf      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-pdf          AS CHARACTER   NO-UNDO.
//DEFINE VARIABLE c-arq-pdf-aceite   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-pdf-manuseio AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-arquivo-param AS CHARACTER   NO-UNDO.

DEF TEMP-TABLE ttArquivo NO-UNDO
      FIELD sequencia   AS INT
      FIELD nomeArquivo AS CHAR
      INDEX idx1 sequencia.

ASSIGN c-dir-saida = SESSION:TEMP-DIRECTORY
       //c-arq-pdf-aceite   = SEARCH("layout/Termodeaceite.pdf")
       c-arq-pdf-manuseio = SEARCH("layout/ManuseioPlacas.pdf").

FIND FIRST nota-fiscal NO-LOCK
     WHERE rowid(nota-fiscal) = p-r-nota-fiscal NO-ERROR.

/* FIND FIRST nota-fiscal NO-LOCK                 */
/*      WHERE nota-fiscal.cod-estabel = "104"     */
/*        AND nota-fiscal.nr-nota-fis = "1120720" */
/*        AND nota-fiscal.serie = "1" NO-ERROR.   */

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
RUN pi-inicializar IN h-acomp (INPUT "Gerando PDF ...").

RUN pi-gera-pdf.


CREATE ttArquivo.
ASSIGN ttArquivo.sequencia = 0
       ttArquivo.nomeArquivo = p-arquivo-danfe.

CREATE ttArquivo.
ASSIGN ttArquivo.sequencia = 2
       ttArquivo.nomeArquivo = c-arq-pdf.

CREATE ttArquivo.
ASSIGN ttArquivo.sequencia = 3
       ttArquivo.nomeArquivo = c-arq-pdf-manuseio.

/*CREATE ttArquivo.
ASSIGN ttArquivo.sequencia = 4
       ttArquivo.nomeArquivo = c-arq-pdf-aceite.*/

RUN piJuntaArquivos.

RUN pi-finalizar in h-acomp.

PROCEDURE pi-gera-pdf:
    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.

    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.

    ASSIGN c-arquivo-pdf = "ESFTP215_" + STRING(TIME) + "_" + STRING(nota-fiscal.nr-nota-fis) + ".pdf":U.
    ASSIGN c-arq-pdf = c-dir-saida + TRIM(c-arquivo-pdf).

    ASSIGN c-arq-pdf = REPLACE(c-arq-pdf, "/":U, "~\":U).
   
    RUN pdf_new ("Spdf",c-arq-pdf).
    RUN pdf_set_PaperType("Spdf","A4").
   
    /*Carrega imagens para o documento, ap¢s carregadas usa funcao pdf_place_image*/
    RUN pdf_load_image  IN h_PDFinc ("Spdf","marca-intelbras","image/logo-intelbras-grande.jpg").
    RUN pdf_new_page("Spdf"). 
   
    RUN pi-acompanhar  IN h-acomp (INPUT "Imprimindo Romaneio Nota: " + STRING(nota-fiscal.nr-nota-fis)).

    RUN pi-cabecalho.
    RUN pi-item.
    RUN pi-estrutura.
     
    RUN pdf_close ("Spdf").  
    
END PROCEDURE.

PROCEDURE pi-cabecalho:

    /**********Cabeáalho**********/
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               pdf_PageHeight("Spdf") - 70 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               65, /* Height */ 
                               1  /* Weight */).
    
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               170,    /*From Column*/
                               pdf_PageHeight("Spdf") - 70 /*From  Row*/,
                               420 /*Width*/,
                               65, /* Height */
                               1  /* Weight */).

     RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               pdf_PageHeight("Spdf") - 160 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               80, /* Height */ 
                               1  /* Weight */).
    
    
    RUN pdf_place_image IN h_PDFinc ("Spdf",
                                     "marca-intelbras",
                                     pdf_LeftMargin("Spdf"), /*LEFT*/
                                     pdf_PageHeight("Spdf") - 790, /*top*/
                                     pdf_LeftMargin("Spdf") + 145, 
                                     35).
    
    RUN pdf_set_font("Spdf","Courier-bold", 16).
    
    RUN pdf_text_xy IN h_PDFinc ("Spdf","ROMANEIO NOTA FISCAL " + STRING(nota-fiscal.nr-nota-fis) + " - " + nota-fiscal.serie ,  180,  pdf_PageHeight("Spdf") - 40). 

    RUN pdf_set_font("Spdf","Courier-bold", 11). 

    RUN pdf_text_xy IN h_PDFinc ("Spdf","Cliente:",  33,  pdf_PageHeight("Spdf") - 100).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Fone:",  453,  pdf_PageHeight("Spdf") - 100).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Endereáo:",  26,  pdf_PageHeight("Spdf") - 115).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Cidade:",  39,  pdf_PageHeight("Spdf") - 130).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","CNPJ:",  453,  pdf_PageHeight("Spdf") - 115).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Data:",  52,  pdf_PageHeight("Spdf") - 145).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Pedido:",  453,  pdf_PageHeight("Spdf") - 145).                      
    

    RUN pdf_set_font("Spdf","Courier", 10). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(estabelec.nome),  88,  pdf_PageHeight("Spdf") - 100).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(emitente.telefone[1]),  485,  pdf_PageHeight("Spdf") - 100).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(estabelec.endereco),  88,  pdf_PageHeight("Spdf") - 115).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(estabelec.cidade),  88,  pdf_PageHeight("Spdf") - 130).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(estabelec.cgc),  485,  pdf_PageHeight("Spdf") - 115).
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(nota-fiscal.nr-pedcli),  500,  pdf_PageHeight("Spdf") - 145).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(TODAY,"99/99/9999"),  88,  pdf_PageHeight("Spdf") - 145).                      
              

END PROCEDURE.

PROCEDURE pi-item:
    DEFINE VARIABLE d-volume AS DECIMAL     NO-UNDO.
    DEFINE BUFFER b-volume-nf FOR volume-nf.

    FIND FIRST ped-venda NO-LOCK
         WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli NO-ERROR.

    FIND LAST volume-nf NO-LOCK 
        WHERE volume-nf.cod-estabel = nota-fiscal.cod-estabel
          AND volume-nf.serie       = nota-fiscal.serie
          AND volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.     

    FOR FIRST it-nota-fisc OF nota-fiscal NO-LOCK:

        ASSIGN d-volume = 0.
        for each b-volume-nf of nota-fiscal no-lock:
            FIND FIRST embalag NO-LOCK
                 WHERE embalag.sigla-emb = b-volume-nf.sigla-emb NO-ERROR.
            if avail embalag then 
               assign d-volume = d-volume + (embalag.volume) . 
         end. 
 
 /*
        FOR EACH estrutura NO-LOCK
            WHERE estrutura.it-codigo = it-nota-fisc.it-codigo:

            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = estrutura.es-codigo NO-ERROR.
    
            ASSIGN d-volume = d-volume + (((item.altura / 100) * (item.largura / 100) * (item.comprim / 100)) * estrutura.quant-usada).
        END.
*/
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-ERROR.
    
        
        FIND FIRST ord-prod NO-LOCK
             WHERE ord-prod.nr-pedido = string(ped-venda.nr-pedido)
               AND ord-prod.it-codigo = ITEM.it-codigo NO-ERROR.

        RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                                   5,    /*From Column*/
                                   pdf_PageHeight("Spdf") - 235 /*From  Row*/,
                                   pdf_PageWidth("Spdf") - 10 /*Width*/,
                                   65, /* Height */ 
                                   1  /* Weight */).

        RUN pdf_set_font("Spdf","Courier-bold", 11). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf","ITEM:",  99,  pdf_PageHeight("Spdf") - 190).                      
        RUN pdf_text_xy IN h_PDFinc ("Spdf","Ordem Produá∆o:",  33,  pdf_PageHeight("Spdf") - 205).                      
        RUN pdf_text_xy IN h_PDFinc ("Spdf","Volumes:",  70,  pdf_PageHeight("Spdf") - 220).                      
        RUN pdf_text_xy IN h_PDFinc ("Spdf","Cubagem:",  455,  pdf_PageHeight("Spdf") - 220).                      

        RUN pdf_set_font("Spdf","Courier", 10). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf",it-nota-fisc.it-codigo,  135,  pdf_PageHeight("Spdf") - 190).                      
        RUN pdf_text_xy IN h_PDFinc ("Spdf",ITEM.desc-item,  185,  pdf_PageHeight("Spdf") - 190).    

        IF AVAIL ord-prod THEN
            RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(ord-prod.nr-ord-prod),  135,  pdf_PageHeight("Spdf") - 205).                      
        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(volume-nf.nr-volume),  135,  pdf_PageHeight("Spdf") - 220).                      
        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(d-volume),  510,  pdf_PageHeight("Spdf") - 220).             
    END.
END PROCEDURE.

PROCEDURE pi-estrutura:
/*                                    RUN pdf_load_font  ("Spdf", */
/*                                                     "Code 39", */
/*                                                     "",        */
/*                                                     "","").    */
    DEFINE VARIABLE i-linha AS INTEGER     NO-UNDO.

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               pdf_PageHeight("Spdf") - 260 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               15, /* Height */ 
                               1  /* Weight */).

    ASSIGN i-linha = 582.

    RUN pdf_set_font("Spdf","Courier-bold", 11). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Componente",  10,  pdf_PageHeight("Spdf") - 255).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Descriá∆o",  80,  pdf_PageHeight("Spdf") - 255).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Quantidade",  520,  pdf_PageHeight("Spdf") - 255).                      

    /*Solar, somente 1 item*/
    FOR FIRST it-nota-fisc OF nota-fiscal NO-LOCK:
        FOR EACH estrutura NO-LOCK
            WHERE estrutura.it-codigo = it-nota-fisc.it-codigo:

            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = estrutura.es-codigo NO-ERROR.
    
            ASSIGN i-linha = i-linha - 15.
            RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                                        5,    /*From Column*/
                                        i-linha /*From  Row*/,
                                        pdf_PageWidth("Spdf") - 10 /*Width*/,
                                        15, /* Height */ 
                                        1  /* Weight */).
    
            RUN pdf_set_font("Spdf","Courier", 10). 
            RUN pdf_text_xy IN h_PDFinc ("Spdf",estrutura.es-codigo,  10,  i-linha + 4).                      
            RUN pdf_text_xy IN h_PDFinc ("Spdf",ITEM.desc-item,  80,  i-linha + 4).                      
            RUN pdf_text_xy IN h_PDFinc ("Spdf",string(estrutura.quant-usada),  520,  i-linha + 4).                      
    
        END.
    END.
END PROCEDURE.

PROCEDURE piJuntaArquivos:
   DEFINE VARIABLE dt-data        	   AS DATE      NO-UNDO.
   DEFINE VARIABLE c-hora         	   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-arq          	   AS CHARACTER NO-UNDO.   
   DEFINE VARIABLE c-dir-tmp      	   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE v_cod_arq      	   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE v_cod_arq_aux  	   AS CHARACTER NO-UNDO.   
   DEFINE VARIABLE c-fullpath     	   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-command-line 	   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i-numero-copia 	   AS INTEGER   NO-UNDO.  

   DEFINE VARIABLE h-printacrord32        AS HANDLE    NO-UNDO.
   DEFINE VARIABLE c-diretorio-acroRd32   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-arquivo-bat-acroRd32 AS CHARACTER NO-UNDO.
   DEFINE VARIABLE c-comando-acroRd32     AS CHARACTER NO-UNDO.   
   DEFINE VARIABLE c-impressora-padrao    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE h-inst                 AS LONGCHAR  NO-UNDO.

   ASSIGN dt-data   = TODAY
          c-hora    = STRING(TIME,"HH:MM:SS")
          c-arq     = "FT0527" + REPLACE(STRING(dt-data), "/", "") + REPLACE(c-hora, ":", "") + ".pdf"
          c-dir-tmp = SESSION:TEMP-DIRECTORY.

   /* Busca o nome do primeiro Danfe gerado */
    ASSIGN v_cod_arq_aux = p-arquivo-danfe.
/*              c-arq = ttArquivo.nomeArquivo */
          

   ASSIGN v_cod_arq_aux = replace(v_cod_arq_aux, ".pdf", "")    + "-m.pdf"
          c-fullpath    = SEARCH("ftp\pdf-merge.jar":U).

   /* Se n∆o for encontrado o .Jar ou tiver rodando em batch n∆o executa a juná∆o dos arquivos*/
   IF  c-fullpath <> ?  THEN DO:
      FOR EACH ttArquivo:    
         ASSIGN v_cod_arq = v_cod_arq + ttArquivo.nomeArquivo + " ".         
      END.

      /*Imprime os parametros em um arquivo*/
      ASSIGN c-arquivo-param = SESSION:TEMP-DIRECTORY + "junta_arq_param_" + c-seg-usuario + STRING(TIME) + ".txt".

      OS-DELETE VALUE(c-arquivo-param).
      OUTPUT TO VALUE(c-arquivo-param).
      PUT UNFORMATTED v_cod_arq.
      OUTPUT CLOSE.
       
      ASSIGN c-command-line = "java -jar ":U  + c-fullpath + " " + c-arquivo-param.  
      
      IF LENGTH(c-command-line) >= 2000 THEN DO:
          /* Para evitar o erro "** OS escap COMMAND too long. (379)" */
          OUTPUT TO VALUE(c-dir-tmp + "command-line-temp.bat").
              PUT UNFORMATTED c-command-line.
          OUTPUT CLOSE.

          /* Executa o .bat criado */
          OS-COMMAND SILENT VALUE(c-dir-tmp + "command-line-temp.bat").

          /* Elimina o .bat */
          OS-DELETE VALUE(c-dir-tmp + "command-line-temp.bat") NO-ERROR.
      END.
      ELSE DO:
          /* Executa .Jar respons†vel pela juná∆o dos Danfes */   
          OS-COMMAND SILENT VALUE(c-command-line).
      END.

      /* Renomeia o arquivo gerado com todos os Danfes para o padr∆o */
      OS-DELETE VALUE(p-arquivo-danfe) NO-ERROR. 
      OS-RENAME VALUE(v_cod_arq_aux) VALUE(p-arquivo-danfe).
      

/*       /* Apaga Danfes individuais */                                  */
/*       FOR EACH ttArquivo:                                             */
/*          OS-DELETE VALUE(c-dir-tmp + ttArquivo.nomeArquivo) NO-ERROR. */
/*       END.                                                            */
   END.
END.
