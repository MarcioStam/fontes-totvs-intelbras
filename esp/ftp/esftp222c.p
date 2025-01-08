/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{include/i-prgvrs.i FT0527RP 2.00.00.040 } /*** 010040 ***/

/*****************************************************************************
**       Programa: FT0527rp.p
**       Data....: 14/03/07
**       Autor...: DATASUL S.A.
**       Objetivo: Emissor DANFE - NF-e
**       Vers∆o..: 1.00.000 - super
**       OBS.....: Este fonte foi gerado pelo Data Viewer 3.00
*******************************************************************************/

/****************** Definiá∆o de Tabelas Tempor†rias do Relat¢rio **********************/
{esp/ftp/esftp222.i}
{include/pdf_inc.i "THIS-PROCEDURE"}
DEF TEMP-TABLE ttArquivo NO-UNDO
      FIELD sequencia   AS INT
      FIELD nomeArquivo AS CHAR
      INDEX idx1 sequencia.

DEFINE BUFFER bf-ttArquivo FOR ttArquivo.


/******************* Busca XML **********************/

DEFINE INPUT PARAMETER rw-nota-fiscal       AS ROWID NO-UNDO.
DEFINE INPUT PARAMETER log-imp-Estrutura    AS LOGICAL NO-UNDO.
DEFINE INPUT PARAMETER log-imp-folhaRosto   AS LOGICAL NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-digita.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttArquivo.

DEFINE VAR i-cont-estr AS INT NO-UNDO.

FIND FIRST tt-digita
     WHERE tt-digita.rw-nota-fiscal = rw-nota-fiscal
    NO-LOCK NO-ERROR.

//FIND nota-fiscal WHERE ROWID(nota-fiscal) = tt-digita.rw-nota-fiscal NO-LOCK NO-ERROR.

/**Batch**/
IF log-imp-folhaRosto
THEN DO:
    FOR LAST bf-ttArquivo: END.
    CREATE ttArquivo.
    ASSIGN ttArquivo.sequencia   = IF AVAIL bf-ttArquivo THEN bf-ttArquivo.sequencia + 1 ELSE 1
           ttArquivo.nomeArquivo = "fr-" + TRIM(tt-digita.cod-estabel) + "-" + TRIM(tt-digita.serie) + "-" + TRIM(tt-digita.nr-nota-fis) + "-" + REPLACE(STRING(TODAY,"99/99/99"),"/","") + REPLACE(STRING(TIME,"HH:MM:SS"),":","") + ".pdf".
    
    RUN piImprimirFolhaRosto.
END.		 
IF log-imp-Estrutura
THEN DO:

    DO i-cont-estr = 1 TO 2:
       FOR LAST bf-ttArquivo: END.
       CREATE ttArquivo.
       ASSIGN ttArquivo.sequencia   = IF AVAIL bf-ttArquivo THEN bf-ttArquivo.sequencia + 1 ELSE 1
              ttArquivo.nomeArquivo = "es-" + TRIM(tt-digita.cod-estabel) + "-" + TRIM(tt-digita.serie) + "-" + TRIM(tt-digita.nr-nota-fis) + "-" + REPLACE(STRING(TODAY,"99/99/99"),"/","") + REPLACE(STRING(TIME,"HH:MM:SS"),":","") + ".pdf".
       RUN piImprimirEstrutura.

    END.
END.

RETURN 'OK'.

PROCEDURE piImprimirFolhaRosto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-bcapi016    AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-bar-code    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-gerador     AS CHAR        NO-UNDO.

    ASSIGN c-gerador = "".

    FIND LAST volume-nf  
        WHERE volume-nf.cod-estabel = tt-digita.cod-estabel
          AND volume-nf.serie       = tt-digita.serie
          AND volume-nf.nr-nota-fis = tt-digita.nr-nota-fis NO-LOCK NO-ERROR.

    IF AVAIL volume-nf THEN DO:
        FIND FIRST nota-fiscal NO-LOCK
             WHERE nota-fiscal.cod-estabel = volume-nf.cod-estabel
               AND nota-fiscal.serie       = volume-nf.serie
               AND nota-fiscal.nr-nota-fis = volume-nf.nr-nota-fis NO-ERROR.
        IF AVAIL nota-fiscal THEN
            FIND FIRST int-ped-venda NO-LOCK
                 WHERE int-ped-venda.nr-pedido = int(nota-fiscal.nr-pedcli) NO-ERROR.
            IF AVAIL int-ped-venda AND int-ped-venda.num-serie-solar <> "" THEN
               ASSIGN c-gerador = int-ped-venda.num-serie-solar.
    END.
        

    RUN bcp/bcapi016.p PERSISTENT SET h-bcapi016.
    RUN generateCODE128C IN h-bcapi016 (TRIM(STRING(tt-digita.nr-ord-prod)),OUTPUT c-bar-code).
    DELETE PROCEDURE h-bcapi016.

    RUN pdf_new ("Spdf",SESSION:TEMP-DIRECTORY + ttArquivo.nomeArquivo).
    RUN pdf_set_PaperType("Spdf","A4").
    RUN pdf_new_page("Spdf").
    RUN pdf_load_font ("Spdf","IQsCode128","c:\windows\fonts\dc-code128.ttf", "PDFinclude/dc-code128.afm","").

    RUN pdf_set_font("Spdf","Courier-bold", 50).
    RUN pdf_text_align("Spdf", "ORDEM: " + STRING(tt-digita.nr-ord-prod),"CENTER",300,750).

    RUN pdf_set_font ("Spdf", "IQsCode128",100).
    RUN pdf_text_align("Spdf", c-bar-code,"CENTER",190,600).
    
    RUN pdf_set_font("Spdf","Courier-bold", 40).
    RUN pdf_text_align("Spdf", "(Pedido Venda: " + tt-digita.nr-pedcli + ")","CENTER",320,500).

    RUN pdf_text_align("Spdf", "ITEM: " + tt-digita.it-codigo,"CENTER",300,350).

    IF c-gerador <> "" THEN DO:
        //RUN pdf_set_font ("Spdf", "IQsCode128",50).
        RUN pdf_text_align("Spdf", "NS Gerador:" + c-gerador ,"CENTER",305,130).
        //RUN pdf_text_align("Spdf", c-bar-gerador,"CENTER",100,600).
    END.

    IF AVAIL volume-nf
    THEN DO: 
        RUN pdf_text_align("Spdf", STRING(volume-nf.nr-volume) + " VOLUMES","CENTER",300,200).
    END.

    RUN pdf_text_align("Spdf", tt-digita.nome-transp,"CENTER",300,50).
    
    RUN pdf_close ("Spdf").
    
    //OS-COMMAND NO-WAIT VALUE(cArquivo) NO-ERROR.

END PROCEDURE.

PROCEDURE piImprimirEstrutura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-linha AS INTEGER       NO-UNDO.
    DEFINE VARIABLE cArquivo AS CHARACTER   NO-UNDO.


    RUN pdf_new ("Spdf",SESSION:TEMP-DIRECTORY + ttArquivo.nomeArquivo).
    RUN pdf_set_PaperType("Spdf","A4").
         
    /*Carrega imagens para o documento, ap¢s carregadas usa funcao pdf_place_image*/
    RUN pdf_load_image  IN h_PDFinc ("Spdf","marca-intelbras","image/logo-intelbras-grande.jpg").
    RUN pdf_new_page("Spdf"). 
    
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
                                pdf_PageHeight("Spdf") - 140 /*From  Row*/,
                                pdf_PageWidth("Spdf") - 10 /*Width*/,
                                65, /* Height */ 
                                1  /* Weight */).

    RUN pdf_place_image IN h_PDFinc ("Spdf",
                                     "marca-intelbras",
                                     pdf_LeftMargin("Spdf"), /*LEFT*/
                                     pdf_PageHeight("Spdf") - 790, /*top*/
                                     pdf_LeftMargin("Spdf") + 145, 
                                     35).


    RUN pdf_set_font("Spdf","Courier-bold", 16).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","ESTRUTURA DO ITEM: " + STRING(tt-digita.it-codigo),  180,  pdf_PageHeight("Spdf") - 40). 
   
    RUN pdf_set_font("Spdf","Courier-bold", 11). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","ITEM:",  99,  pdf_PageHeight("Spdf") - 100).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Ordem Produá∆o:",  33,  pdf_PageHeight("Spdf") - 115).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Pedido:",  86,  pdf_PageHeight("Spdf") - 130).

    FIND FIRST ITEM WHERE ITEM.it-codigo = tt-digita.it-codigo NO-LOCK NO-ERROR.
    RUN pdf_set_font("Spdf","Courier", 13). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",tt-digita.it-codigo,  135,  pdf_PageHeight("Spdf") - 100).
    RUN pdf_text_xy IN h_PDFinc ("Spdf",ITEM.desc-item,  195,  pdf_PageHeight("Spdf") - 100).

    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(tt-digita.nr-ord-prod),  135,  pdf_PageHeight("Spdf") - 115).
    RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(tt-digita.nr-pedido),  135,  pdf_PageHeight("Spdf") - 130).

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               pdf_PageHeight("Spdf") - 160 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               15, /* Height */ 
                               1  /* Weight */).

    ASSIGN i-linha = 680.

    RUN pdf_set_font("Spdf","Courier-bold", 11). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Componente",  10,  pdf_PageHeight("Spdf") - 155).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Descriá∆o",   80,  pdf_PageHeight("Spdf") - 155).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Quantidade", 520,  pdf_PageHeight("Spdf") - 155).

    /*Solar, somente 1 item*/
    FOR EACH estrutura NO-LOCK
        WHERE estrutura.it-codigo = tt-digita.it-codigo:

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = estrutura.es-codigo NO-ERROR.

        ASSIGN i-linha = i-linha - 15.
        RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                                    5,    /*From Column*/
                                    i-linha /*From  Row*/,
                                    pdf_PageWidth("Spdf") - 10 /*Width*/,
                                    15, /* Height */ 
                                    1  /* Weight */).

        RUN pdf_set_font("Spdf","Courier", 13).
        RUN pdf_text_xy IN h_PDFinc ("Spdf",estrutura.es-codigo,  10,  i-linha + 4).                      
        RUN pdf_text_xy IN h_PDFinc ("Spdf",ITEM.desc-item,  80,  i-linha + 4).                      
        RUN pdf_text_xy IN h_PDFinc ("Spdf",string(estrutura.quant-usada),  520,  i-linha + 4).                      

    END.

    RUN pdf_close ("Spdf").  

    //OS-COMMAND NO-WAIT VALUE(SESSION:TEMP-DIRECTORY + ttArquivo.nomeArquivo) NO-ERROR.

END PROCEDURE.
