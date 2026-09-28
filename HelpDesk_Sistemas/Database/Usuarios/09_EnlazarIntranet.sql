-- Enlaza cada usuario del HelpDesk con su identidad en la intranet (Id_Intranet = DocEntry),
-- generado a partir de un cruce por nombre y apellido (normalizado, sin tildes) contra los
-- empleados activos de la intranet. Deliberadamente NO incluye:
--   - 18 nombres duplicados en la intranet (misma persona con 2+ DocEntry activos, o dos
--     personas distintas con el mismo nombre) -- revisar y enlazar a mano caso por caso.
--   - manager4 (Luis Manrique / Luis Mariano Quito Hilario, MANAGER7): su cuenta en la
--     intranet figura inactiva, no se pudo confirmar el cruce.
-- Cada UPDATE valida Id + Usuario juntos: si en otra base esos dos datos no corresponden
-- a la misma persona (IDs distintos entre ambientes), simplemente no aplica esa fila.
SET QUOTED_IDENTIFIER ON;
GO
UPDATE Usuarios SET Id_Intranet = 1 WHERE Id = 2 AND Usuario = 'manager1'; -- Maria Mercedes Roman Tello
UPDATE Usuarios SET Id_Intranet = 1099 WHERE Id = 3 AND Usuario = 'manager2'; -- Sandro Cesar Domínguez Albornoz
UPDATE Usuarios SET Id_Intranet = 1244 WHERE Id = 4 AND Usuario = 'manager3'; -- Juan Carlos Benavides Mateo
UPDATE Usuarios SET Id_Intranet = 919 WHERE Id = 6 AND Usuario = 'manager5'; -- Jhon Edwards Risco Rojas
UPDATE Usuarios SET Id_Intranet = 1102 WHERE Id = 7 AND Usuario = 'manager6'; -- Jhonatan Carrasco Pinchi
UPDATE Usuarios SET Id_Intranet = 414 WHERE Id = 119 AND Usuario = 'dirtec1'; -- Fernanda Pamela Collahua Senosain
UPDATE Usuarios SET Id_Intranet = 162 WHERE Id = 120 AND Usuario = 'operac3'; -- Jorge Damian Aldaba
UPDATE Usuarios SET Id_Intranet = 850 WHERE Id = 123 AND Usuario = 'operac5'; -- Robert Jhonatan Rojas Peregrino
UPDATE Usuarios SET Id_Intranet = 423 WHERE Id = 125 AND Usuario = 'comercial1'; -- Reyna Elena Soto Escriba
UPDATE Usuarios SET Id_Intranet = 422 WHERE Id = 126 AND Usuario = 'comercial2'; -- Betsy Yessica Untiveros Crispin
UPDATE Usuarios SET Id_Intranet = 345 WHERE Id = 128 AND Usuario = 'operac7'; -- Wilson Ivan Acho Navarro
UPDATE Usuarios SET Id_Intranet = 685 WHERE Id = 130 AND Usuario = 'operac9'; -- Dusan Ccarampa Leon
UPDATE Usuarios SET Id_Intranet = 1203 WHERE Id = 131 AND Usuario = 'operac10'; -- Jose Robert Chapoñan Pizarro
UPDATE Usuarios SET Id_Intranet = 680 WHERE Id = 133 AND Usuario = 'operac11'; -- Jorge Manrique Cuadros Trillo
UPDATE Usuarios SET Id_Intranet = 436 WHERE Id = 136 AND Usuario = 'comercial3'; -- Smith Hugo Gomez Samaniego
UPDATE Usuarios SET Id_Intranet = 429 WHERE Id = 139 AND Usuario = 'comercial4'; -- Mery Quispe Vega
UPDATE Usuarios SET Id_Intranet = 498 WHERE Id = 141 AND Usuario = 'operac13'; -- Valentin Roque Rojas
UPDATE Usuarios SET Id_Intranet = 161 WHERE Id = 144 AND Usuario = 'operac14'; -- Carmen Condori Saravia
UPDATE Usuarios SET Id_Intranet = 721 WHERE Id = 145 AND Usuario = 'operac15'; -- Wilder Orlando Espinoza Guere
UPDATE Usuarios SET Id_Intranet = 1031 WHERE Id = 154 AND Usuario = 'operac16'; -- Ivette Misolina Jaimes Ceferino
UPDATE Usuarios SET Id_Intranet = 734 WHERE Id = 156 AND Usuario = 'operac17'; -- Chaly Gonzales Torres
UPDATE Usuarios SET Id_Intranet = 448 WHERE Id = 160 AND Usuario = 'comercial5'; -- Wisman Aurelio Chinchay Chasquero
UPDATE Usuarios SET Id_Intranet = 669 WHERE Id = 161 AND Usuario = 'dirtec2'; -- Pamela Susana Ojeda Vilca
UPDATE Usuarios SET Id_Intranet = 388 WHERE Id = 164 AND Usuario = 'operac18'; -- Raul Junior Llanos Yauri
UPDATE Usuarios SET Id_Intranet = 403 WHERE Id = 165 AND Usuario = 'operac19'; -- Marco Antonio Raymundo Miranda
UPDATE Usuarios SET Id_Intranet = 1105 WHERE Id = 166 AND Usuario = 'comercial6'; -- Katty Tatiana Fabian Coronel
UPDATE Usuarios SET Id_Intranet = 797 WHERE Id = 167 AND Usuario = 'finanzas5'; -- Deysi Yudit Osco Mamani
UPDATE Usuarios SET Id_Intranet = 690 WHERE Id = 169 AND Usuario = 'operac20'; -- Antony Lino Salcedo
UPDATE Usuarios SET Id_Intranet = 427 WHERE Id = 171 AND Usuario = 'comercial7'; -- Lizbeth Trujillo Calderon
UPDATE Usuarios SET Id_Intranet = 353 WHERE Id = 178 AND Usuario = 'operac22'; -- Henry Alfonso Rodas Sandoval
UPDATE Usuarios SET Id_Intranet = 560 WHERE Id = 180 AND Usuario = 'operac23'; -- Jorge Orlando Chicchon Valdez
UPDATE Usuarios SET Id_Intranet = 1327 WHERE Id = 183 AND Usuario = 'admin5'; -- Angel Christopher Vargas Lopez
UPDATE Usuarios SET Id_Intranet = 678 WHERE Id = 186 AND Usuario = 'operac25'; -- Ronald Jean Pierre Rojas Ticllas
UPDATE Usuarios SET Id_Intranet = 169 WHERE Id = 187 AND Usuario = 'finanzas7'; -- Jenifer Valery Atanacio Julca
UPDATE Usuarios SET Id_Intranet = 1222 WHERE Id = 189 AND Usuario = 'comercial8'; -- Janeth Evelin Ccorimanya Quispe
UPDATE Usuarios SET Id_Intranet = 350 WHERE Id = 190 AND Usuario = 'operac26'; -- Juan Carlos Oblitas Fernandez
UPDATE Usuarios SET Id_Intranet = 540 WHERE Id = 191 AND Usuario = 'operac27'; -- Kary Esteban Castañeda
UPDATE Usuarios SET Id_Intranet = 543 WHERE Id = 193 AND Usuario = 'operac28'; -- Jose Milton Mamani Pucho
UPDATE Usuarios SET Id_Intranet = 742 WHERE Id = 194 AND Usuario = 'operac29'; -- Veronica Odett Tarazona Capcha
UPDATE Usuarios SET Id_Intranet = 182 WHERE Id = 195 AND Usuario = 'operac30'; -- Javier Yasmani Huarachi Mamani
UPDATE Usuarios SET Id_Intranet = 837 WHERE Id = 196 AND Usuario = 'operac31'; -- Manuel Alberto Lopez Castro
UPDATE Usuarios SET Id_Intranet = 527 WHERE Id = 197 AND Usuario = 'finanzas8'; -- Anibal Mamani Quispe
UPDATE Usuarios SET Id_Intranet = 686 WHERE Id = 198 AND Usuario = 'operac32'; -- Diego Yeme Mamani Quispe
UPDATE Usuarios SET Id_Intranet = 1220 WHERE Id = 199 AND Usuario = 'comercial9'; -- Paul Anderson Mamani Quispe
UPDATE Usuarios SET Id_Intranet = 503 WHERE Id = 202 AND Usuario = 'admin7'; -- Shirley Melanie Castillo Espinoza
UPDATE Usuarios SET Id_Intranet = 171 WHERE Id = 204 AND Usuario = 'finanzas9'; -- Javier Sebastian Burgos Trinidad
UPDATE Usuarios SET Id_Intranet = 420 WHERE Id = 205 AND Usuario = 'comercial10'; -- Sandra Rossana Roman Tello
UPDATE Usuarios SET Id_Intranet = 697 WHERE Id = 207 AND Usuario = 'operac34'; -- Jesus Angel Nunahuanca Cordova
UPDATE Usuarios SET Id_Intranet = 787 WHERE Id = 210 AND Usuario = 'operac35'; -- Richard Franklin Flores Chambilla
UPDATE Usuarios SET Id_Intranet = 227 WHERE Id = 212 AND Usuario = 'finanzas10'; -- Elmer Alberto Espinoza Aldava
UPDATE Usuarios SET Id_Intranet = 399 WHERE Id = 213 AND Usuario = 'operac37'; -- Cesar Ruben Lopez Rivas
UPDATE Usuarios SET Id_Intranet = 713 WHERE Id = 215 AND Usuario = 'operac38'; -- Brayan Antony Quispe Taquila
UPDATE Usuarios SET Id_Intranet = 903 WHERE Id = 216 AND Usuario = 'operac39'; -- Ghelen Celiz Saravia
UPDATE Usuarios SET Id_Intranet = 1219 WHERE Id = 219 AND Usuario = 'comercial12'; -- Jesus Israel Gutierrez Avendaño
UPDATE Usuarios SET Id_Intranet = 672 WHERE Id = 220 AND Usuario = 'operac40'; -- Jhoel Huamani Romero
UPDATE Usuarios SET Id_Intranet = 801 WHERE Id = 221 AND Usuario = 'operac41'; -- Dany Josue Lazo Murrieta
UPDATE Usuarios SET Id_Intranet = 206 WHERE Id = 223 AND Usuario = 'dirtec3'; -- Maria Yogana Aguirre Reyes
UPDATE Usuarios SET Id_Intranet = 694 WHERE Id = 224 AND Usuario = 'operac42'; -- Bryan Hector Cristobal Pariona
UPDATE Usuarios SET Id_Intranet = 684 WHERE Id = 226 AND Usuario = 'operac43'; -- Alfredo Benito Roldan Esparraga
UPDATE Usuarios SET Id_Intranet = 476 WHERE Id = 229 AND Usuario = 'comercial15'; -- Haydee Pfoccori Choyña
UPDATE Usuarios SET Id_Intranet = 1025 WHERE Id = 231 AND Usuario = 'operac44'; -- Juan Leonardo Terreros Tenazoa
UPDATE Usuarios SET Id_Intranet = 1272 WHERE Id = 232 AND Usuario = 'operac45'; -- Jhon Elvis Ttito Calderon
UPDATE Usuarios SET Id_Intranet = 1100 WHERE Id = 235 AND Usuario = 'comercial17'; -- Lizbet Erika Galindo Castañeda
UPDATE Usuarios SET Id_Intranet = 730 WHERE Id = 236 AND Usuario = 'operac46'; -- Gilson Marcelino Quispe Vidal
UPDATE Usuarios SET Id_Intranet = 359 WHERE Id = 237 AND Usuario = 'operac47'; -- Jhander Jhan Berrocal Gomez
UPDATE Usuarios SET Id_Intranet = 554 WHERE Id = 238 AND Usuario = 'operac48'; -- Luis Junnior Damian Villanueva
UPDATE Usuarios SET Id_Intranet = 358 WHERE Id = 239 AND Usuario = 'operac49'; -- David Noe Vidal Rafael
UPDATE Usuarios SET Id_Intranet = 1008 WHERE Id = 240 AND Usuario = 'operac50'; -- Edward Percy Gomez Ludeña
UPDATE Usuarios SET Id_Intranet = 726 WHERE Id = 241 AND Usuario = 'comercial18'; -- Nick Randall Velasquez Rodriguez
UPDATE Usuarios SET Id_Intranet = 674 WHERE Id = 243 AND Usuario = 'operac51'; -- Paul Cesar Ochoa Boado
UPDATE Usuarios SET Id_Intranet = 646 WHERE Id = 244 AND Usuario = 'operac52'; -- Christian Bernardo Caballero Baldeon
UPDATE Usuarios SET Id_Intranet = 479 WHERE Id = 246 AND Usuario = 'comercial20'; -- Fiorella Zacarias Ramon
UPDATE Usuarios SET Id_Intranet = 530 WHERE Id = 247 AND Usuario = 'operac53'; -- Joseph Andrew Morales Barja
UPDATE Usuarios SET Id_Intranet = 488 WHERE Id = 248 AND Usuario = 'comercial21'; -- Celeste Estrella Falcon Valdivia
UPDATE Usuarios SET Id_Intranet = 282 WHERE Id = 249 AND Usuario = 'operac54'; -- Mishell Vanessa Rojas Bueno
UPDATE Usuarios SET Id_Intranet = 537 WHERE Id = 251 AND Usuario = 'operac55'; -- Edwar Alonso Chapoñan Huiman
UPDATE Usuarios SET Id_Intranet = 562 WHERE Id = 254 AND Usuario = 'operac56'; -- Vicente Abel Aguilar Bardales
UPDATE Usuarios SET Id_Intranet = 784 WHERE Id = 255 AND Usuario = 'operac57'; -- Zandalee Karl Farfan Litano
UPDATE Usuarios SET Id_Intranet = 561 WHERE Id = 256 AND Usuario = 'operac58'; -- Alexander Castañeda Aldaba
UPDATE Usuarios SET Id_Intranet = 871 WHERE Id = 257 AND Usuario = 'operac59'; -- Jhordan Carlos Chuquiray Flores
UPDATE Usuarios SET Id_Intranet = 339 WHERE Id = 259 AND Usuario = 'dirtec5'; -- Roly Ronald Gonzales Romero
UPDATE Usuarios SET Id_Intranet = 780 WHERE Id = 260 AND Usuario = 'operac61'; -- Jesus Alberto Illachoque Manzano
UPDATE Usuarios SET Id_Intranet = 445 WHERE Id = 263 AND Usuario = 'comercial23'; -- Jean Paul Ramirez Rodriguez
UPDATE Usuarios SET Id_Intranet = 813 WHERE Id = 265 AND Usuario = 'dirtec6'; -- Clara Cecilia Becerra Sanchez
UPDATE Usuarios SET Id_Intranet = 661 WHERE Id = 266 AND Usuario = 'operac64'; -- Oliber Amerlin Chambilla Mamani
UPDATE Usuarios SET Id_Intranet = 1018 WHERE Id = 267 AND Usuario = 'operac65'; -- Russel Cristaldo Chambilla Mamani
UPDATE Usuarios SET Id_Intranet = 394 WHERE Id = 271 AND Usuario = 'operac66'; -- Eder Sandino Quispe Cunto
UPDATE Usuarios SET Id_Intranet = 874 WHERE Id = 272 AND Usuario = 'operac67'; -- Wilfredo Miranda Asillo
UPDATE Usuarios SET Id_Intranet = 761 WHERE Id = 276 AND Usuario = 'comercial25'; -- Marco Andy Cruz Cuellar
UPDATE Usuarios SET Id_Intranet = 375 WHERE Id = 277 AND Usuario = 'operac69'; -- Renzo Julian Huamancayo Quispe
UPDATE Usuarios SET Id_Intranet = 748 WHERE Id = 280 AND Usuario = 'operac70'; -- David Omar Peralta Espinoza
UPDATE Usuarios SET Id_Intranet = 753 WHERE Id = 281 AND Usuario = 'operac71'; -- Rodolfo Gabriel Gutierrez Sanchez
UPDATE Usuarios SET Id_Intranet = 1052 WHERE Id = 282 AND Usuario = 'dirtec7'; -- Maribel Ramos Jamjachi
UPDATE Usuarios SET Id_Intranet = 752 WHERE Id = 283 AND Usuario = 'operac72'; -- Jhan Edhitson Ticona Quispe
UPDATE Usuarios SET Id_Intranet = 1282 WHERE Id = 285 AND Usuario = 'comercial27'; -- Eduardo Billy Alejandro Sotomayor
UPDATE Usuarios SET Id_Intranet = 857 WHERE Id = 289 AND Usuario = 'operac75'; -- Wilian Melendrez Calvay
UPDATE Usuarios SET Id_Intranet = 916 WHERE Id = 291 AND Usuario = 'comercial28'; -- Maribel Elizabeth Quintana Saldarriaga
UPDATE Usuarios SET Id_Intranet = 1294 WHERE Id = 292 AND Usuario = 'comercial29'; -- Katherine Milusca Vera Valderrama
UPDATE Usuarios SET Id_Intranet = 858 WHERE Id = 293 AND Usuario = 'operac76'; -- Luis Alberto Camacho Benavides
UPDATE Usuarios SET Id_Intranet = 727 WHERE Id = 294 AND Usuario = 'comercial30'; -- Jennyfer Lucero Carrascal Lozada
UPDATE Usuarios SET Id_Intranet = 901 WHERE Id = 296 AND Usuario = 'operac78'; -- Jose Carlos Damian Aldaba
UPDATE Usuarios SET Id_Intranet = 841 WHERE Id = 298 AND Usuario = 'operac79'; -- William Alfredo Muro Dioses
UPDATE Usuarios SET Id_Intranet = 855 WHERE Id = 299 AND Usuario = 'operac80'; -- Cesar Eduardo Vasquez Ascona
UPDATE Usuarios SET Id_Intranet = 876 WHERE Id = 300 AND Usuario = 'operac81'; -- Marcio Elias Bardales Tuanama
UPDATE Usuarios SET Id_Intranet = 1011 WHERE Id = 301 AND Usuario = 'admin9'; -- Yesenia Yerin Ayllon Collahua
UPDATE Usuarios SET Id_Intranet = 993 WHERE Id = 303 AND Usuario = 'comercial31'; -- Claudia Soza Vilchez
UPDATE Usuarios SET Id_Intranet = 915 WHERE Id = 304 AND Usuario = 'comercial32'; -- Richard David Venegas Walhoff
UPDATE Usuarios SET Id_Intranet = 928 WHERE Id = 306 AND Usuario = 'operac82'; -- Pedro Luis Zapata Sosa
UPDATE Usuarios SET Id_Intranet = 924 WHERE Id = 307 AND Usuario = 'operac83'; -- Richard Bryan Martinez Capcha
UPDATE Usuarios SET Id_Intranet = 927 WHERE Id = 308 AND Usuario = 'operac84'; -- Ronald Alexander Poma Ruiz
UPDATE Usuarios SET Id_Intranet = 931 WHERE Id = 309 AND Usuario = 'operac85'; -- Leonardo Miguel Sarmiento Romero
UPDATE Usuarios SET Id_Intranet = 934 WHERE Id = 310 AND Usuario = 'operac86'; -- Ronald Antonio Flores Flores
UPDATE Usuarios SET Id_Intranet = 938 WHERE Id = 311 AND Usuario = 'operac87'; -- Daniel Gerson Auccapoma Hijar
UPDATE Usuarios SET Id_Intranet = 943 WHERE Id = 312 AND Usuario = 'comercial33'; -- Kelly Victoria Murayari Pacaya
UPDATE Usuarios SET Id_Intranet = 942 WHERE Id = 313 AND Usuario = 'operac88'; -- Diego Eduardo Flores Cardenas
UPDATE Usuarios SET Id_Intranet = 1017 WHERE Id = 314 AND Usuario = 'operac89'; -- Jorge Luis Pezo Mozombite
UPDATE Usuarios SET Id_Intranet = 950 WHERE Id = 317 AND Usuario = 'operac90'; -- Alex Shupingahua Sangama
UPDATE Usuarios SET Id_Intranet = 956 WHERE Id = 318 AND Usuario = 'operac91'; -- Bryan Rogger Mamani Palacios
UPDATE Usuarios SET Id_Intranet = 965 WHERE Id = 319 AND Usuario = 'comercial34'; -- Susel Geraldine Castillo Ventocilla
UPDATE Usuarios SET Id_Intranet = 967 WHERE Id = 320 AND Usuario = 'operac92'; -- Jair Mateus Egoavil Torres
UPDATE Usuarios SET Id_Intranet = 970 WHERE Id = 322 AND Usuario = 'operac93'; -- Gerson Alexis Robledo Mamani
UPDATE Usuarios SET Id_Intranet = 972 WHERE Id = 323 AND Usuario = 'operac94'; -- Luis Angel Canchumanta Macavilca
UPDATE Usuarios SET Id_Intranet = 973 WHERE Id = 324 AND Usuario = 'operac95'; -- Jack Michael Minaya Calderon
UPDATE Usuarios SET Id_Intranet = 975 WHERE Id = 325 AND Usuario = 'operac96'; -- Jean Marcos Cirilo Achaya Solorzano
UPDATE Usuarios SET Id_Intranet = 980 WHERE Id = 326 AND Usuario = 'operac97'; -- Jose Alberto Rojas Toledo
UPDATE Usuarios SET Id_Intranet = 1246 WHERE Id = 327 AND Usuario = 'dirtec8'; -- Mariela Escurra Ayala
UPDATE Usuarios SET Id_Intranet = 990 WHERE Id = 328 AND Usuario = 'operac98'; -- Gin Al Jhonatan Caso Castro
UPDATE Usuarios SET Id_Intranet = 996 WHERE Id = 332 AND Usuario = 'operac100'; -- Marvin Carlos Gonzales Ruiz
UPDATE Usuarios SET Id_Intranet = 997 WHERE Id = 333 AND Usuario = 'operac101'; -- Sebastian Oliveros Mitma
UPDATE Usuarios SET Id_Intranet = 1000 WHERE Id = 335 AND Usuario = 'operac103'; -- Daniel Santos Apolinario
UPDATE Usuarios SET Id_Intranet = 1132 WHERE Id = 338 AND Usuario = 'comercial36'; -- Yamilet Blanca Zamudio Gonzales
UPDATE Usuarios SET Id_Intranet = 1013 WHERE Id = 339 AND Usuario = 'operac104'; -- Miguel Angel Fabriccio Villalobos Picon
UPDATE Usuarios SET Id_Intranet = 1014 WHERE Id = 340 AND Usuario = 'operac105'; -- Luis Mayron Serquen Quispe
UPDATE Usuarios SET Id_Intranet = 1028 WHERE Id = 343 AND Usuario = 'operac107'; -- Frank Jhordy Bonzano Bustamante
UPDATE Usuarios SET Id_Intranet = 1036 WHERE Id = 344 AND Usuario = 'operac108'; -- Lenny David Inga Miranda
UPDATE Usuarios SET Id_Intranet = 1046 WHERE Id = 345 AND Usuario = 'operac109'; -- Manuel Siesquen Bances
UPDATE Usuarios SET Id_Intranet = 1199 WHERE Id = 346 AND Usuario = 'comercial37'; -- Natalia Carolina Huayambe Lopez
UPDATE Usuarios SET Id_Intranet = 1104 WHERE Id = 347 AND Usuario = 'operac110'; -- Jose Asuncion Barraza Flores
UPDATE Usuarios SET Id_Intranet = 1111 WHERE Id = 349 AND Usuario = 'operac112'; -- Michael Castañeda Aldaba
UPDATE Usuarios SET Id_Intranet = 1120 WHERE Id = 350 AND Usuario = 'operac113'; -- Gerardo Axl Francisco Vento Morales
UPDATE Usuarios SET Id_Intranet = 1135 WHERE Id = 352 AND Usuario = 'comercial39'; -- Israel Daniel Villanueva Maldonado
UPDATE Usuarios SET Id_Intranet = 1179 WHERE Id = 353 AND Usuario = 'dirtec9'; -- Ketty Jovahana Yañac Soto
UPDATE Usuarios SET Id_Intranet = 1139 WHERE Id = 355 AND Usuario = 'operac114'; -- Isaias Janampa Bañico
UPDATE Usuarios SET Id_Intranet = 1171 WHERE Id = 359 AND Usuario = 'operac115'; -- Daniel Esteban Andia Levano
UPDATE Usuarios SET Id_Intranet = 1173 WHERE Id = 360 AND Usuario = 'operac116'; -- Jairo Joao Curi Ordaya
UPDATE Usuarios SET Id_Intranet = 1189 WHERE Id = 362 AND Usuario = 'comercial42'; -- Luis Omar Davila Rodriguez
UPDATE Usuarios SET Id_Intranet = 1225 WHERE Id = 367 AND Usuario = 'comercial43'; -- Yessica Seleni Gonzales Vallejos
UPDATE Usuarios SET Id_Intranet = 1334 WHERE Id = 368 AND Usuario = 'operac120'; -- Arnold Rojas Amoretti
UPDATE Usuarios SET Id_Intranet = 1217 WHERE Id = 370 AND Usuario = 'operac122'; -- Jhonatan Adrian Chavez Flores
UPDATE Usuarios SET Id_Intranet = 1311 WHERE Id = 371 AND Usuario = 'comercial44'; -- Maely Ismelda Mamani Quispe
UPDATE Usuarios SET Id_Intranet = 1223 WHERE Id = 372 AND Usuario = 'operac123'; -- Saul Antony Mamani Quispe
UPDATE Usuarios SET Id_Intranet = 1243 WHERE Id = 376 AND Usuario = 'operac126'; -- Angelito Durand Prieto
UPDATE Usuarios SET Id_Intranet = 1245 WHERE Id = 377 AND Usuario = 'comercial45'; -- Salvador Manuel Yarleque Martinez
UPDATE Usuarios SET Id_Intranet = 1257 WHERE Id = 378 AND Usuario = 'operac127'; -- Sebastian Castro Humpiri
UPDATE Usuarios SET Id_Intranet = 1271 WHERE Id = 381 AND Usuario = 'operac129'; -- Nicolas Cabrera Fuentes
UPDATE Usuarios SET Id_Intranet = 1278 WHERE Id = 383 AND Usuario = 'comercial46'; -- Jason Luis Huaynamarca Morales
UPDATE Usuarios SET Id_Intranet = 1280 WHERE Id = 384 AND Usuario = 'comercial47'; -- Yashira Sixta Soto Torres
UPDATE Usuarios SET Id_Intranet = 1279 WHERE Id = 385 AND Usuario = 'comercial48'; -- Betty Eliana Pacotaipe Vargas
UPDATE Usuarios SET Id_Intranet = 1252 WHERE Id = 386 AND Usuario = 'operac130'; -- Nicole Adela Rojas Segovia
UPDATE Usuarios SET Id_Intranet = 1260 WHERE Id = 389 AND Usuario = 'operac131'; -- Edgar David Antezana Quilo
UPDATE Usuarios SET Id_Intranet = 1261 WHERE Id = 390 AND Usuario = 'operac132'; -- Jaime Oscar Armas Rioja
UPDATE Usuarios SET Id_Intranet = 1262 WHERE Id = 391 AND Usuario = 'operac133'; -- Karla Rosita Iglesias Paulino
UPDATE Usuarios SET Id_Intranet = 1306 WHERE Id = 392 AND Usuario = 'comercial49'; -- Ruth Esmeralda Llanqui Huarachi
UPDATE Usuarios SET Id_Intranet = 1264 WHERE Id = 393 AND Usuario = 'operac134'; -- Delia Zorayda Llanqui Huarachi
UPDATE Usuarios SET Id_Intranet = 1247 WHERE Id = 394 AND Usuario = 'operac135'; -- Flor Karina Ancalle Javier
UPDATE Usuarios SET Id_Intranet = 1248 WHERE Id = 395 AND Usuario = 'operac136'; -- Shinay Paola Maricela Correa Mamani
UPDATE Usuarios SET Id_Intranet = 1250 WHERE Id = 396 AND Usuario = 'operac137'; -- Alberto Alexander Vergara Panduro
UPDATE Usuarios SET Id_Intranet = 1286 WHERE Id = 398 AND Usuario = 'operac138'; -- Carlos Alberto Reyes Flores
UPDATE Usuarios SET Id_Intranet = 1288 WHERE Id = 399 AND Usuario = 'operac139'; -- Jefferson Fedor Huaman Jimenez
UPDATE Usuarios SET Id_Intranet = 1291 WHERE Id = 400 AND Usuario = 'operac140'; -- Milagros Melanie Cruzado Tafur
UPDATE Usuarios SET Id_Intranet = 1293 WHERE Id = 401 AND Usuario = 'operac141'; -- Robert Daniel Hernandez Cruzado
UPDATE Usuarios SET Id_Intranet = 1290 WHERE Id = 402 AND Usuario = 'operac142'; -- Gianfranco Cubas Armas
UPDATE Usuarios SET Id_Intranet = 1295 WHERE Id = 403 AND Usuario = 'operac143'; -- Edgar Oscco Quispe
UPDATE Usuarios SET Id_Intranet = 782 WHERE Id = 405 AND Usuario = 'comercial52'; -- Lizseth Jessica Paucar Condor
UPDATE Usuarios SET Id_Intranet = 1298 WHERE Id = 407 AND Usuario = 'operac145'; -- Randu Michael Flores Flores
UPDATE Usuarios SET Id_Intranet = 1305 WHERE Id = 408 AND Usuario = 'comercial53'; -- Mayte Fernanda Rojas Pisconte
UPDATE Usuarios SET Id_Intranet = 1318 WHERE Id = 409 AND Usuario = 'comercial54'; -- Cristian Miguel Moreno Tarazona
UPDATE Usuarios SET Id_Intranet = 1303 WHERE Id = 410 AND Usuario = 'operac146'; -- Jhoselyn Belen Gonzalo Flores
UPDATE Usuarios SET Id_Intranet = 1307 WHERE Id = 411 AND Usuario = 'operac147'; -- Gladis Llanqui Huarachi
UPDATE Usuarios SET Id_Intranet = 1310 WHERE Id = 412 AND Usuario = 'operac148'; -- Carlos Felipe Junco Mendivil
UPDATE Usuarios SET Id_Intranet = 1330 WHERE Id = 418 AND Usuario = 'comercial56'; -- Deysi Maria Crespin Ortiz
UPDATE Usuarios SET Id_Intranet = 1323 WHERE Id = 420 AND Usuario = 'operac151'; -- Jorge Felipe Gaspar Gonzales
UPDATE Usuarios SET Id_Intranet = 1322 WHERE Id = 421 AND Usuario = 'operac152'; -- Junior Michael Flores Chahuayo
UPDATE Usuarios SET Id_Intranet = 1325 WHERE Id = 424 AND Usuario = 'operac154'; -- Jair Israel Ricardo Mendoza Huapaya
UPDATE Usuarios SET Id_Intranet = 1336 WHERE Id = 430 AND Usuario = 'comercial58'; -- Kimberly Quintanilla Baca
