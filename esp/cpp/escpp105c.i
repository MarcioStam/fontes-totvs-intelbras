
CASE i-seq:

    WHEN 1 THEN DO: /* Etiqueta 1 */

       ASSIGN i-vert[i-seq] = 0
              i-hori[i-seq] = 0.

       PUT UNFORMATTED "^FO" string(35 + i-hori[i-seq]) "," string(72 + i-vert[i-seq]) "^A0N,25,25^FD" STRING(c-camp1) "^FS" SKIP.
       PUT UNFORMATTED "^FO" string(35 + i-hori[i-seq]) "," string(100 + i-vert[i-seq]) "^A0N,25,25^FD" STRING(c-camp2) "^FS" SKIP.

    END. /* Fim Etiqueta 1 */

    WHEN 2 THEN DO: /* Etiqueta 2 */

       ASSIGN i-vert[i-seq] = 0
              i-hori[i-seq] = 300.

       PUT UNFORMATTED "^FO" string(40 + i-hori[i-seq]) "," string(72 + i-vert[i-seq]) "^A0N,25,25^FD" STRING(c-camp1) "^FS" SKIP.
       PUT UNFORMATTED "^FO" string(40 + i-hori[i-seq]) "," string(100 + i-vert[i-seq]) "^A0N,25,25^FD" STRING(c-camp2) "^FS" SKIP.

    END. /* Fim Etiqueta 2 */

    WHEN 3 THEN DO: /* Etiqueta 3 */

       ASSIGN i-vert[i-seq] = 0
              i-hori[i-seq] = 600.

       PUT UNFORMATTED "^FO" string(45 + i-hori[i-seq]) "," string(73 + i-vert[i-seq]) "^A0N,25,25^FD" STRING(c-camp1) "^FS" SKIP.
       PUT UNFORMATTED "^FO" string(45 + i-hori[i-seq]) "," string(100 + i-vert[i-seq]) "^A0N,25,25^FD" STRING(c-camp2) "^FS" SKIP.

    END. /* Fim Etiqueta 3 */

    WHEN 4 THEN DO: /* Etiqueta 4 */

       ASSIGN i-vert[i-seq] = 0
              i-hori[i-seq] = 900.

       PUT UNFORMATTED "^FO" string(50 + i-hori[i-seq]) "," string(72 + i-vert[i-seq]) "^A0N,25,25^FD" STRING(c-camp1) "^FS" SKIP.
       PUT UNFORMATTED "^FO" string(50 + i-hori[i-seq]) "," string(100 + i-vert[i-seq]) "^A0N,25,25^FD" STRING(c-camp2) "^FS" SKIP.

    END. /* Fim Etiqueta 4 */

    WHEN 5 THEN DO: /* Etiqueta 5 */

       ASSIGN i-vert[i-seq] = 0
              i-hori[i-seq] = 1210.

       PUT UNFORMATTED "^FO" string(50 + i-hori[i-seq]) "," string(72 + i-vert[i-seq]) "^A0N,25,25^FD" STRING(c-camp1) "^FS" SKIP.
       PUT UNFORMATTED "^FO" string(50 + i-hori[i-seq]) "," string(100 + i-vert[i-seq]) "^A0N,25,25^FD" STRING(c-camp2) "^FS" SKIP.

    END. /* Fim Etiqueta 5 */

    WHEN 6 THEN DO: /* Etiqueta 6 */

       ASSIGN i-vert[i-seq] = 0
              i-hori[i-seq] = 1520.

       PUT UNFORMATTED "^FO" string(50 + i-hori[i-seq]) "," string(72 + i-vert[i-seq]) "^A0N,25,25^FD" STRING(c-camp1) "^FS" SKIP.
       PUT UNFORMATTED "^FO" string(50 + i-hori[i-seq]) "," string(100 + i-vert[i-seq]) "^A0N,25,25^FD" STRING(c-camp2) "^FS" SKIP.

    END. /* Fim Etiqueta 6 */

    WHEN 7 THEN DO: /* Etiqueta 7 */

       ASSIGN i-vert[i-seq] = 0
              i-hori[i-seq] = 1830.

       PUT UNFORMATTED "^FO" string(55 + i-hori[i-seq]) "," string(72 + i-vert[i-seq]) "^A0N,25,25^FD" STRING(c-camp1) "^FS" SKIP.
       PUT UNFORMATTED "^FO" string(55 + i-hori[i-seq]) "," string(100 + i-vert[i-seq]) "^A0N,25,25^FD" STRING(c-camp2) "^FS" SKIP.

    END. /* Fim Etiqueta 7 */

    WHEN 8 THEN DO: /* Etiqueta 8 */

       ASSIGN i-vert[i-seq] = 0
              i-hori[i-seq] = 2140.

       PUT UNFORMATTED "^FO" string(60 + i-hori[i-seq]) "," string(72 + i-vert[i-seq]) "^A0N,25,25^FD" STRING(c-camp1) "^FS" SKIP.
       PUT UNFORMATTED "^FO" string(60 + i-hori[i-seq]) "," string(100 + i-vert[i-seq]) "^A0N,25,25^FD" STRING(c-camp2) "^FS" SKIP.

    END. /* Fim Etiqueta 8 */

/*
    WHEN 1 THEN DO: /* Etiqueta 1 */

       ASSIGN i-vert[i-seq] = 0
              i-hori[i-seq] = 0.

       PUT UNFORMATTED "^FO" string(35 + i-hori[i-seq]) "," string(90 + i-vert[i-seq]) "^A0N,40,40^FD" STRING(c-camp1) "^FS" SKIP.
       PUT UNFORMATTED "^FO" string(35 + i-hori[i-seq]) "," string(125 + i-vert[i-seq]) "^A0N,40,40^FD" STRING(c-camp2) "^FS" SKIP.

    END. /* Fim Etiqueta 1 */

    WHEN 2 THEN DO: /* Etiqueta 2 */

       ASSIGN i-vert[i-seq] = 0
              i-hori[i-seq] = 300.

       PUT UNFORMATTED "^FO" string(40 + i-hori[i-seq]) "," string(90 + i-vert[i-seq]) "^A0N,40,40^FD" STRING(c-camp1) "^FS" SKIP.
       PUT UNFORMATTED "^FO" string(40 + i-hori[i-seq]) "," string(125 + i-vert[i-seq]) "^A0N,40,40^FD" STRING(c-camp2) "^FS" SKIP.

    END. /* Fim Etiqueta 2 */

    WHEN 3 THEN DO: /* Etiqueta 3 */

       ASSIGN i-vert[i-seq] = 0
              i-hori[i-seq] = 600.

       PUT UNFORMATTED "^FO" string(45 + i-hori[i-seq]) "," string(90 + i-vert[i-seq]) "^A0N,40,40^FD" STRING(c-camp1) "^FS" SKIP.
       PUT UNFORMATTED "^FO" string(45 + i-hori[i-seq]) "," string(125 + i-vert[i-seq]) "^A0N,40,40^FD" STRING(c-camp2) "^FS" SKIP.

    END. /* Fim Etiqueta 3 */

    WHEN 4 THEN DO: /* Etiqueta 4 */

       ASSIGN i-vert[i-seq] = 0
              i-hori[i-seq] = 900.

       PUT UNFORMATTED "^FO" string(50 + i-hori[i-seq]) "," string(90 + i-vert[i-seq]) "^A0N,40,40^FD" STRING(c-camp1) "^FS" SKIP.
       PUT UNFORMATTED "^FO" string(50 + i-hori[i-seq]) "," string(125 + i-vert[i-seq]) "^A0N,40,40^FD" STRING(c-camp2) "^FS" SKIP.

    END. /* Fim Etiqueta 4 */

    WHEN 5 THEN DO: /* Etiqueta 5 */

       ASSIGN i-vert[i-seq] = 0
              i-hori[i-seq] = 1200.

       PUT UNFORMATTED "^FO" string(50 + i-hori[i-seq]) "," string(90 + i-vert[i-seq]) "^A0N,40,40^FD" STRING(c-camp1) "^FS" SKIP.
       PUT UNFORMATTED "^FO" string(50 + i-hori[i-seq]) "," string(125 + i-vert[i-seq]) "^A0N,40,40^FD" STRING(c-camp2) "^FS" SKIP.

    END. /* Fim Etiqueta 5 */

    WHEN 6 THEN DO: /* Etiqueta 6 */

       ASSIGN i-vert[i-seq] = 0
              i-hori[i-seq] = 1500.

       PUT UNFORMATTED "^FO" string(50 + i-hori[i-seq]) "," string(90 + i-vert[i-seq]) "^A0N,40,40^FD" STRING(c-camp1) "^FS" SKIP.
       PUT UNFORMATTED "^FO" string(50 + i-hori[i-seq]) "," string(125 + i-vert[i-seq]) "^A0N,40,40^FD" STRING(c-camp2) "^FS" SKIP.

    END. /* Fim Etiqueta 6 */

    WHEN 7 THEN DO: /* Etiqueta 7 */

       ASSIGN i-vert[i-seq] = 0
              i-hori[i-seq] = 1800.

       PUT UNFORMATTED "^FO" string(55 + i-hori[i-seq]) "," string(90 + i-vert[i-seq]) "^A0N,40,40^FD" STRING(c-camp1) "^FS" SKIP.
       PUT UNFORMATTED "^FO" string(55 + i-hori[i-seq]) "," string(125 + i-vert[i-seq]) "^A0N,40,40^FD" STRING(c-camp2) "^FS" SKIP.

    END. /* Fim Etiqueta 7 */

    WHEN 8 THEN DO: /* Etiqueta 8 */

       ASSIGN i-vert[i-seq] = 0
              i-hori[i-seq] = 2100.

       PUT UNFORMATTED "^FO" string(60 + i-hori[i-seq]) "," string(90 + i-vert[i-seq]) "^A0N,40,40^FD" STRING(c-camp1) "^FS" SKIP.
       PUT UNFORMATTED "^FO" string(60 + i-hori[i-seq]) "," string(125 + i-vert[i-seq]) "^A0N,40,40^FD" STRING(c-camp2) "^FS" SKIP.

    END. /* Fim Etiqueta 8 */
*/

END CASE.
