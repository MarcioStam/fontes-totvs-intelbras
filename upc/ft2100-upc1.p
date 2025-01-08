/*  Desativado */

/* DEF NEW GLOBAL SHARED VAR vAtualizaNfSeparada   AS LOG NO-UNDO.                 */
/*                                                                                 */
/* RUN piPedeTela.                                                                 */
/*                                                                                 */
/* PROCEDURE piPedeTela:                                                           */
/*     DEFINE VARIABLE tgAtualizaNfSeparada AS LOGICAL                             */
/*          LABEL "Atualiza Nf Separadas"                                          */
/*          VIEW-AS TOGGLE-BOX                                                     */
/*          SIZE 40 BY .88 NO-UNDO.                                                */
/*                                                                                 */
/*     DEFINE BUTTON btGoToOK AUTO-GO /*AUTO-END-KEY */                            */
/*          LABEL "&OK"                                                            */
/*          SIZE 10 BY 1                                                           */
/*          BGCOLOR 8.                                                             */
/*                                                                                 */
/*     DEFINE BUTTON btGoToCancel AUTO-END-KEY                                     */
/*          LABEL "&Cancela"                                                       */
/*          SIZE 10 BY 1                                                           */
/*          BGCOLOR 8.                                                             */
/*                                                                                 */
/*     DEFINE RECTANGLE rtGoToButton                                               */
/*          EDGE-PIXELS 2 GRAPHIC-EDGE                                             */
/*          SIZE 65 BY 1.5                                                         */
/*          BGCOLOR 7.                                                             */
/*                                                                                 */
/*     DEFINE RECTANGLE rtGoToFields                                               */
/*          EDGE-PIXELS 2 GRAPHIC-EDGE                                             */
/*          SIZE 65 BY 1.3                                                         */
/*          BGCOLOR 8.                                                             */
/*                                                                                 */
/*     DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.                                     */
/*                                                                                 */
/*     DEFINE FRAME fParam                                                         */
/*            tgAtualizaNfSeparada       AT ROW 1.27 COL 5 COLON-ALIGN             */
/*            rtGoToFields      AT ROW 1    COL 1                                  */
/*            btGoToOK          AT ROW 2.7  COL 2.14                               */
/*            btGoToCancel      AT ROW 2.7  COL 12.14                              */
/*            rtGoToButton      AT ROW 2.5  COL 1                                  */
/*         SPACE(0.28)                                                             */
/*         WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE         */
/*              THREE-D SCROLLABLE TITLE "Parƒmetros Atualiza‡Æo Intelbras" FONT 1 */
/*              DEFAULT-BUTTON btGoToOK.                                           */
/*                                                                                 */
/*     ON  "CHOOSE":U OF btGoToOK IN FRAME fParam DO:                              */
/*         ASSIGN tgAtualizaNfSeparada.                                            */
/*         ASSIGN vAtualizaNfSeparada = tgAtualizaNfSeparada.                      */
/*         APPLY "GO":U TO FRAME fParam.                                           */
/*     END.                                                                        */
/*                                                                                 */
/*     ASSIGN tgAtualizaNfSeparada:CHECKED IN FRAME fParam = vAtualizaNfSeparada.  */
/*                                                                                 */
/*                                                                                 */
/*     ENABLE tgAtualizaNfSeparada btGoToOK btGoToCancel                           */
/*            WITH FRAME fParam.                                                   */
/*                                                                                 */
/*     WAIT-FOR "GO":U OF FRAME fParam.                                            */
/*                                                                                 */
/*                                                                                 */
/* END PROCEDURE.                                                                  */
