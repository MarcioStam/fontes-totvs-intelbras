/*****************************************************************************
**     Programa.........: esp/acr/esacr023rp.p
**     Descricao .......: Emissao de etiquetas
**                        Convers∆o ES0505
**     Versao...........: 1.00.000
**     Autor............: Clayton
**     Criado...........: 24/04/2005
**     Desc. Atualizaá∆o: 
**     Autor............: 
*******************************************************************************/

{esp\acr\esacr023tt.i}

/****************** Definiáao de Vari†veis de Processamento do Relat¢rio *********************/

    DEF VAR V_Cod_Empresa           LIKE EmsUni.Empresa.Cod_Empresa NO-UNDO.
    DEF VAR I                       AS INTE NO-UNDO.
    DEF VAR V_Cod_Dwb_File          LIKE Dwb_Set_List_Param.Cod_Dwb_File     NO-UNDO.
    DEF VAR V_Cod_Dwb_Output        LIKE Dwb_Set_List_Param.Cod_Dwb_Output   NO-UNDO.
    DEF VAR C-Impressora            LIKE Ped_Exec_Param.Nom_Dwb_Printer      NO-UNDO.
    DEF VAR C-Layout                LIKE Ped_Exec_Param.Cod_Dwb_Print_Layout NO-UNDO.
    DEF VAR H-Hacr155               AS HANDLE NO-UNDO.
    DEF VAR V-Cod-Destino-Impres    AS CHAR   NO-UNDO.
    DEF VAR V-Num-Reg-Lidos         AS INTE   NO-UNDO.
    DEF VAR V-Num-Point             AS INTE   NO-UNDO.
    DEF VAR V-Num-Set               AS INTE   NO-UNDO.
    DEF VAR V-Cod-Arquivo           AS CHAR.
    DEF VAR V-Num-Tip-Reg           AS INTE FORM "999".
    DEF VAR C-Empresa               AS CHAR FORM "x(40)"  NO-UNDO.
    DEF VAR C-Titulo-Relat          AS CHAR FORM "x(50)"  NO-UNDO.
    DEF VAR C-Sistema               AS CHAR FORM "x(25)"  NO-UNDO.
    DEF VAR C-Rodape                AS CHAR               NO-UNDO.
    DEF VAR C-Programa              AS CHAR FORM "x(08)"  NO-UNDO.
    DEF VAR C-Versao                AS CHAR FORM "x(04)"  NO-UNDO.
    DEF VAR C-Revisao               AS CHAR FORM "999"    NO-UNDO.
    DEF VAR V_Num_Pag               AS INTE INIT 1        NO-UNDO.
    DEF VAR Ch_Linha                AS CHAR FORM "x(215)" NO-UNDO.

    DEF STREAM Stream_1.

    DEF BUFFER B_Ped_Exec_Style     FOR Ped_Exec.
    DEF BUFFER B_Servid_Exec_Style  FOR servid_Exec.

    DEF NEW SHARED VAR V_Rpt_Stream_1_Lines      AS INTE INIT 60.
    DEF NEW SHARED VAR V_Rpt_Stream_1_Columns    AS INTE INIT 132.
    DEF NEW SHARED VAR V_Rpt_Stream_1_Bottom     AS INTE INIT 60.
    DEF NEW SHARED VAR V_Rpt_Stream_1_Page       AS INTE.
    DEF NEW SHARED VAR V_Rpt_Stream_1_Name       AS CHAR INIT "Relat¢rio D°vidas Cliente".


    DEF VAR fi-Cod-Cli-1 AS CHAR FORMAT "x(10)".
    DEF VAR c-nome-emit  AS CHAR FORMAT "x(30)".
    DEF VAR c-endereco   AS CHAR FORMAT "x(30)".
    DEF VAR c-bairro     AS CHAR FORMAT "x(15)".
    DEF VAR i-cep        AS CHAR FORMAT "x(10)".
    DEF VAR c-cidade     AS CHAR FORMAT "x(15)".
    DEF VAR c-estado     AS CHAR FORMAT "x(2)".
    DEF VAR c-text       AS CHAR FORMAT "x(30)".

    ASSIGN c-text = "A/C: Departamento Financeiro".
    



    def input param teste    as char    no-undo.


    MESSAGE "teste rp: " teste
        VIEW-AS ALERT-BOX INFO BUTTONS OK.






    IF V_Cod_Dwb_User = "" THEN
       ASSIGN V_Cod_Dwb_User = V_Cod_Usuar_Corren.

    IF V_Num_Ped_Exec_Corren > 0 THEN DO:
       FIND Ped_Exec_Param NO-LOCK WHERE
            Ped_Exec_Param.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR.
       IF AVAIL Ped_Exec_Param THEN DO:
          FIND Dwb_Set_List_Param NO-LOCK                          WHERE
               Dwb_Set_List_Param.Cod_Dwb_Program = "esacr023"     AND
               Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User NO-ERROR.
          ASSIGN V_Cod_Dwb_File   = Ped_Exec_Param.Cod_Dwb_File
                 V_Cod_Dwb_Output = Ped_Exec_Param.Cod_Dwb_Output
                 C-Impressora     = Ped_Exec_Param.Nom_Dwb_Printer
                 C-Layout         = Ped_Exec_Param.Cod_Dwb_Print_Layout 
                 fi-Cod-Cli-1     = entry(2,dwb_set_list_param.cod_dwb_parameters,chr(10)). 
       END. 
    END. 
    ELSE DO:
       FIND Dwb_Set_List_Param NO-LOCK                          WHERE
            Dwb_Set_List_Param.Cod_Dwb_Program = "esacr023"     AND
            Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Dwb_User NO-ERROR.
       IF AVAIL Dwb_Set_List_Param THEN DO:
          ASSIGN V_Cod_Dwb_File   = Dwb_Set_list_Param.Cod_Dwb_File             
                 V_Cod_Dwb_Output = Dwb_Set_list_Param.Cod_Dwb_Output           
                 C-Impressora     = Dwb_Set_list_Param.nom_Dwb_Printer          
                 C-Layout         = Dwb_Set_list_Param.Cod_Dwb_Print_layout                 
                 fi-Cod-Cli-1     = entry(2,dwb_set_list_param.cod_dwb_parameters,chr(10)). 
       END.
    END.


    FIND Imprsor_Usuar NO-LOCK                         WHERE
         Imprsor_Usuar.Nom_Impressora = C-Impressora   AND
         Imprsor_Usuar.Cod_Usuario    = V_Cod_Dwb_User USE-INDEX imprsrsr_id NO-ERROR.
    FIND layout_impres NO-LOCK                          WHERE
         Layout_Impres.Nom_Impressora    = C-Impressora AND
         Layout_Impres.Cod_Layout_Impres = C-Layout     NO-ERROR.
    ASSIGN V_Rpt_Stream_1_Bottom = Layout_Impres.Num_Lin_Pag 
           V_Rpt_Stream_1_Lines  = Layout_Impres.Num_Lin_Pag.

    IF OPSYS = "UNIX" THEN DO:
       IF V_Num_Ped_Exec_Corren <> 0 THEN DO:
          FIND Ped_Exec NO-LOCK WHERE
               Ped_Exec.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR.
          IF AVAIL Ped_Exec THEN DO:
             FIND Servid_Exec_Imprsor NO-LOCK                                           WHERE
                  Servid_Exec_Imprsor.Cod_Servid_Exec = Ped_Exec.Cod_Servid_Exec AND
                  Servid_Exec_Imprsor.Nom_Impressora  = C-Impressora                    NO-ERROR.
             IF AVAIL Servid_Exec_Imprsor THEN OUTPUT STREAM Stream_1 
                THROUGH VALUE(Servid_Exec_Imprsor.Nom_Disposit_So)
                PAGED 
                PAGE-SIZE 
                VALUE(V_Rpt_Stream_1_Lines) 
                CONVERT TARGET 'iso8859-1'.
             ELSE OUTPUT STREAM Stream_1 
                THROUGH VALUE(Imprsor_Usuar.Nom_Disposit_So)
                PAGED 
                PAGE-SIZE 
                VALUE(V_Rpt_Stream_1_Lines) 
                CONVERT TARGET 'iso8859-1'.
          END.
       END.
       ELSE OUTPUT STREAM Stream_1 
            THROUGH VALUE(Imprsor_Usuar.Nom_Disposit_So)
            PAGED 
            PAGE-SIZE 
            VALUE(V_Rpt_Stream_1_Lines) 
            CONVERT TARGET 'iso8859-1'.
    END.
    ELSE OUTPUT STREAM Stream_1 TO VALUE(Imprsor_Usuar.Nom_Disposit_So)
         PAGED 
         PAGE-SIZE 
         VALUE(V_Rpt_Stream_1_Lines) 
         CONVERT TARGET 'iso8859-1'.

    FOR EACH Configur_Layout_Impres NO-LOCK WHERE
             Configur_Layout_Impres.Num_Id_Layout_Impres = Layout_Impres.Num_Id_Layout_Impres
             BY Configur_Layout_Impres.num_Ord_Funcao_imprsor.
        FIND Configur_Tip_imprsor NO-LOCK                                                                WHERE
             Configur_Tip_Imprsor.Cod_Tip_Imprsor        = Layout_Impres.Cod_Tip_Imprsor                 AND
             Configur_Tip_Imprsor.Cod_Funcao_Imprsor     = Configur_Layout_Impres.Cod_Funcao_Imprsor     AND
             Configur_Tip_Imprsor.Cod_Opc_Funcao_Imprsor = Configur_Layout_Impres.Cod_Opc_Funcao_Imprsor NO-ERROR.
        PUT STREAM Stream_1 CONTROL Configur_Tip_Imprsor.Cod_Comando_Configur.
    END. 


    ASSIGN C-Programa          = "esacr023"
           C-Versao            = "1.00"
           C-Revisao           = "001"
           C-Titulo-Relat      = "Carta de Anuància"
           V_Rpt_Stream_1_Name = C-Titulo-Relat
           C-Sistema           = "ESP"
           Ch_Linha            = FILL("-",132).

    ASSIGN V_Num_Pag = 1.


    RUN Pi_Imprime_Relat.  /* Imprime relat¢rio em formato padr∆o EMS 5 */


    OUTPUT STREAM Stream_1 CLOSE.

    RETURN "ok".



    PROCEDURE Pi-Abre-Edit:
        DEF INPUT PARAM P_Cod_Dwb_File AS CHAR FORM "x(40)" NO-UNDO.
        DEF VAR V_Cod_Key_Value        AS CHAR FORM "x(08)" NO-UNDO.

        GET-KEY-VALUE SECTION 'EMS' KEY 'Show-Report-Program' VALUE V_Cod_Key_Value.
        IF V_Cod_Key_Value = "" OR 
           V_Cod_Key_Value = ?  THEN 
           DO.
              ASSIGN V_Cod_Key_Value = 'start'.
              PUT-KEY-VALUE SECTION 'EMS' KEY 'Show-Report-Program' VALUE V_Cod_Key_Value NO-ERROR.
        END.

        OS-COMMAND SILENT VALUE(V_Cod_Key_Value + CHR(32) + P_Cod_Dwb_File).
    END PROCEDURE.  




    PROCEDURE Pi_Imprime_Relat.
        DEF VAR iNumSeq LIKE histor_clien.num_seq_histor_clien.
        FIND FIRST emitente NO-LOCK WHERE
                   emitente.cod-emitente = int(fi-Cod-Cli-1) NO-ERROR.
        ASSIGN c-nome-emit = emitente.nome-emit.

        IF emitente.endereco-cob <> "" AND
           emitente.cidade-cob   <> "" AND
           emitente.estado-cob   <> "" AND
           INT(emitente.cep-cob) <> 0  THEN DO:
           ASSIGN c-endereco = emitente.endereco-cob
                  c-bairro   = emitente.bairro-cob
                  i-cep      = emitente.cep-cob
                  c-cidade   = emitente.cidade-cob
                  c-estado   = emitente.estado-cob.
        END.
        ELSE DO:
           ASSIGN c-endereco = emitente.endereco
                  c-bairro   = emitente.bairro
                  i-cep      = emitente.cep
                  c-cidade   = emitente.cidade
                  c-estado   = emitente.estado.
        END.




    MESSAGE "Nome: " c-nome-emit
        VIEW-AS ALERT-BOX INFO BUTTONS OK.




        PUT STREAM Stream_1 CHR(027) + CHR(040) + CHR(115) + CHR(051) + CHR(066).
        PUT STREAM Stream_1 c-nome-emit AT 1.
        PUT STREAM Stream_1 CHR(027) + CHR(040) + CHR(115) + CHR(048) + CHR(066).
        PUT STREAM Stream_1 SKIP.
        PUT STREAM Stream_1 c-endereco SKIP.
        PUT STREAM Stream_1 c-bairro SKIP.
        PUT STREAM Stream_1 i-cep.
        PUT STREAM Stream_1 " - " .
        PUT STREAM Stream_1 c-cidade SKIP.
        PUT STREAM Stream_1 " - ".
        PUT STREAM Stream_1 c-estado  SKIP(1).
        PUT STREAM Stream_1 c-text SKIP(1).

    END PROCEDURE. 


    IF I-Num-Ped-Exec-Rpw <> 0 THEN RETURN "OK".
