/* Include de procedures HTML 
   Flavio Schoenell
   18-11-2002 

   Observaá∆o: fonte reutilizado para a rotina de comiss∆o 
               Robson Jeorge Moser - 31/01/2005
   
   O texto do corpo do e-mail deve ser gravado na variavel c-texto-html
           (76 x 10).
   O endereco deve ser colocado na variavel c-endereco.
   Deve ser definido o nome do arquivo em c-arquivo e do corpo em c-arquivo-2.
   
   Estrutura Basica:
   
   output to value(c-arquivo).
   
   run html-inicio("titulo").      - Informar o titulo da tela.
   run html-ini-tab.               - Inicio da tabela
   
   run html-ini-lin-tab.           - Inicio de uma linha 
   run html-cab-tab("titulo").     - Titulo da Coluna * repetir para todas
   run html-fim-lin-tab.           - Fim de uma linha
  
   for each tabela:
       run html-ini-lin-tab.           - Inicio de uma linha
       run html-con-tab(tabela.campo). - Conteudo da celula * repetir para todas
       run html-fim-lin-tab.           - Fim de uma linha 
   end.
   
   run html-fim-tab.               - Fim da tabela

   run html-fim.                   - Fim do html.
   output close.
  
   run html-manda-mail("Assunto","Reply").  - Informar o assunto e o endereco 
                                              de reply.
   
     
   
   */




def var html-i-cont as int.

procedure html-link-destino.
    def input parameter c-dest as char.

    put unformatted '<a name="' c-dest '">' '</a>'.

end.
procedure html-link-origem.
    def input parameter c-dest as char.

    put unformatted '<a href="#' c-dest '">'  c-dest '</a>' .

end.


procedure html-inicio.
def input parameter c-titulo as char.

put unformatted "<HTML>" skip
    "<HEAD><META HTTP-EQUIV=~"CONTENT-TYPE~" CONTENT=~"text/html; charset=iso8859-1~">" skip
    "<SCRIPT>" skip
    "function popWindow(mypage,myname,w,h,scroll,resize,status)" chr(123) skip
    "var win2= null;" skip
    "var winl = (screen.width-w)/2;" skip
    "var wint = (screen.height-h)/2;" skip
    "var settings  =" chr(39) "height=" chr(39) "+h+" chr(39) "," chr(39) ";" skip
    "settings +=" chr(39) "width=" chr(39) "+w+" chr(39) "," chr(39) ";" skip
    "settings +=" chr(39) "top=" chr(39) "+wint+" chr(39) "," chr(39) ";" skip
    "settings +=" chr(39) "left=" chr(39) "+winl+" chr(39) "," chr(39) ";" skip
    "settings +=" chr(39) "scrollbars=" chr(39) "+scroll+" chr(39) "," chr(39) ";" skip
    "settings +=" chr(39) "resizable=" chr(39) "+resize+" chr(39) "," chr(39) ";" skip
    "settings +=" chr(39) "status=" chr(39) "+status;" skip
    "//mypage+=" chr(39) "?id=" chr(39) "+id+" chr(39) "&" chr(39) "+" chr(39) "txt=" chr(39) "+txtPath+" chr(39) "&" chr(39) "+" chr(39) "img=" chr(39) "+imgPath;" skip
    "win2=window.open(mypage,myname,settings);" skip
    "if(parseInt(navigator.appVersion) >= 4)" skip
    "  win2.window.focus();"       skip
    chr(125) skip
                                    
    "</SCRIPT>" skip
    
    "<TITLE>" c-titulo "</TITLE>" skip
    "<style type=" '"text/css"' ">" skip
    "table" CHR(123) "border-collapse:collapse; border: 1px solid black;" chr(125)  skip
    ".cor01" chr(123) "background-color:" '"' "#FFFFFF"  '"'  ";" chr(125) skip
    ".cor02" chr(123) "background-color:" '"' "#FFFFCC"  '"'  ";" chr(125) skip
    ".cor03" chr(123) "background-color:" '"' "#FFCC99"  '"'  ";" chr(125) skip
    ".cor04" chr(123) "background-color:" '"' "#CCFFFF"  '"'  ";" chr(125) skip
    ".cor05" chr(123) "background-color:" '"' "#99FF99"  '"'  ";" chr(125) skip
    ".cor06" chr(123) "background-color:" '"' "#FFCCCC"  '"'  ";" chr(125) skip
    ".cor07" chr(123) "background-color:" '"' "#FFCCFF"  '"'  ";" chr(125) skip
    ".cor08" chr(123) "background-color:" '"' "#FFFF99"  '"'  ";" chr(125) skip
    ".cor09" chr(123) "background-color:" '"' "#FFCC33"  '"'  ";" chr(125) skip
    ".cor10" chr(123) "background-color:" '"' "#66FFFF"  '"'  ";" chr(125) skip
    ".cor11" chr(123) "background-color:" '"' "#66FF99"  '"'  ";" chr(125) skip
    ".cor12" chr(123) "background-color:" '"' "#FF6666"  '"'  ";" chr(125) skip
    ".cor13" chr(123) "background-color:" '"' "#FFFFFF"  '"'  ";" chr(125) skip
    ".cor14" chr(123) "background-color:" '"' "#FFFFCC"  '"'  ";" chr(125) skip
    ".cor15" chr(123) "background-color:" '"' "#FFCC99"  '"'  ";" chr(125) skip
    ".cor16" chr(123) "background-color:" '"' "#CCFFFF"  '"'  ";" chr(125) skip
    ".cor17" chr(123) "background-color:" '"' "#99FF99"  '"'  ";" chr(125) skip
    ".cor18" chr(123) "background-color:" '"' "#FFCCCC"  '"'  ";" chr(125) skip
    ".cor19" chr(123) "background-color:" '"' "#FFCCFF"  '"'  ";" chr(125) skip
    ".cor20" chr(123) "background-color:" '"' "#FFFF99"  '"'  ";" chr(125) skip
    "th " chr(123) "font-family = Arial; font-size = 11; font-style = bold; border: 1px solid black; padding:0px 5px 0px 5px;"        chr(125)  skip
    "td " chr(123) "font-family = Arial; font-size = 11; border: 1px solid black; padding:0px 5px 0px 5px;" chr(125) skip
    "</style> "
    "</HEAD>" skip
/*    "<BODY BGCOLOR=#FFFFCC>" skip */
    "<BODY BGCOLOR=#FFFFFF>" skip
    "<FONT SIZE =" '"1"' " FACE=" '"' "Arial" '"' ">" skip .
end.
procedure html-fim.
    put unformatted skip
    "</FONT>" skip
    "</BODY>" skip 
    "</HTML>" .
end.                               
procedure html-titulo.
    def input parameter c-titulo as char format "x(200)".
    put unformatted "<H4>" c-titulo  "</H4>" skip.
end.

procedure html-tit-tab.
    def input parameter c-titulo as char format "x(200)".
    def input parameter c-tam as char format "x(1)". /* de 1 (>) a 6 (<)  */
    def input parameter c-alin as char format "x(10)". /*left - right - center*/ 
    put unformatted "<TABLE BORDER=0 WIDTH= " '"100%"' " >" skip .
    put unformatted "<TR><TD ALIGN= " c-alin " > " c-titulo "</TD></TR></TABLE>"     skip.

end.

procedure html-ini-tab.
    put unformatted "<TABLE BORDER ALIGN = CENTER " "BGCOLOR = " "#FFFFFF"                 ~    " WIDTH= " c-tam-tab " >" skip .
end.

procedure html-tot-tab.
    def input parameter c-col as char.
    def input parameter c-titulo as char.
    def input parameter c-valor as char.
    put unformatted "<TD COLSPAN=" c-col " ALIGN= " '"left"' ">" 
        c-titulo "</TD> " skip
        "<TD ALIGN = " '"right"' " > " c-valor " </TD>".
end.

procedure html-fim-tab.
    put unformatted "</TABLE>" skip.       
end.

procedure html-ini-lin-tab.
     put unformatted "<TR>" skip.
end.

procedure html-fim-lin-tab.
     put unformatted "</TR>" skip .
end.
procedure html-cab-tab.
    def input parameter c-cab as char.
    put unformatted "<TH>" c-cab "</TH>" skip. 
end.

procedure html-cab-tab-cor.
    def input parameter c-cab as char.
    DEF INPUT PARAMETER c-cor AS CHAR.
    put unformatted "<TH>" + c-cor + c-cab "</TH>" skip. 
end.

procedure html-cab-tab-colspan.
    def input parameter c-cab as char.
    def input parameter c-col as char.
    put unformatted "<TH COLSPAN=" c-col ">" c-cab "</TH>" skip. 
end.

procedure html-con-tab.
    def input parameter c-con as char.
    def input parameter c-alin as char.
    put unformatted "<TD ALIGN=" '"' + c-alin + '"' ">" c-con  "</TD>" skip . 
end.

procedure html-con-tab-colspan.
    def input parameter c-con as char.
    def input parameter c-alin as char.
    def input parameter c-col as char.
    put unformatted "<TD COLSPAN=" c-col " ALIGN=" '"' + c-alin + '"' ">" c-con  "</TD>" skip . 
end.


procedure html-con-w-tab.
    def input parameter c-con as char.
    def input parameter c-alin as char.
    def input parameter c-width as char.
    put unformatted "<TD ALIGN=" '"'  c-alin + '"' 
            " WIDTH=" '"'  c-width  '"' 
            ">" c-con "</TD>" skip. 
end.

procedure html-con-tab-cor.
    def input parameter c-con as char.
    def input parameter c-alin as char.
    DEF INPUT PARAMETER c-cor AS CHAR.
    put unformatted "<TD class=" + '"cor' + c-cor + '"' +  " ALIGN=" '"' + c-alin + '"' ">" c-con  "</TD>" skip . 
end.

procedure html-con-w-tab-cor.
    def input parameter c-con as char.
    def input parameter c-alin as char.
    def input parameter c-width as char.
    DEF INPUT PARAMETER c-cor AS CHAR.
    put unformatted "<TD class=" + '"cor' + c-cor + '"' +  " ALIGN=" '"'  c-alin + '"' 
            " WIDTH=" '"'  c-width  '"' 
            ">" c-con "</TD>" skip. 
end.
          
procedure html-manda-mail.
    def input parameter c-assunto as char.
    def input parameter c-reply as char.

    output to value(c-arquivo-2).
    if c-reply <> "" then do:
        put unformatted  "~~R" c-reply skip.
    end.

    do html-i-cont = 1 to 10:
        put unformatted c-texto-html[html-i-cont] skip.
    end.
    put skip(2).
    output close.

   assign c-arquivo-1 = c-arquivo + ".html  ".
               
    unix silent uuencode value(c-arquivo) value(c-arquivo-1) >>                          value(c-arquivo-2)  .

    assign c-mail = "mailx -m -s " + '"' + c-assunto + '"' + " " + c-endereco + 
             " < " + c-arquivo-2 + " 2> /dev/null".

    unix silent value(c-mail).  

end.



