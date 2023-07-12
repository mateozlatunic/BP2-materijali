DROP DATABASE trgovina;
CREATE DATABASE trgovina;
USE trgovina;

CREATE TABLE kupac (
 id INTEGER NOT NULL,
 ime VARCHAR(10) NOT NULL,
 prezime VARCHAR(15) NOT NULL,
 PRIMARY KEY (id)
);
CREATE TABLE zaposlenik (
 id INTEGER NOT NULL,
 ime VARCHAR(10) NOT NULL,
 prezime VARCHAR(15) NOT NULL,
 oib CHAR(11) NOT NULL,
 datum_zaposlenja DATETIME NOT NULL,
 PRIMARY KEY (id)
);
CREATE TABLE artikl (
 id INTEGER NOT NULL,
 naziv VARCHAR(20) NOT NULL,
 cijena NUMERIC(10,2) NOT NULL,
 PRIMARY KEY (id)
);
/*Unos podataka*/
CREATE TABLE racun (
 id INTEGER NOT NULL,
 id_zaposlenik INTEGER NOT NULL,
 id_kupac INTEGER NOT NULL,
 broj VARCHAR(100) NOT NULL,
 datum_izdavanja DATETIME NOT NULL,
 PRIMARY KEY (id),
 FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik (id),
 FOREIGN KEY (id_kupac) REFERENCES kupac (id)
);
CREATE TABLE stavka_racun (
 id INTEGER NOT NULL,
 id_racun INTEGER NOT NULL,
 id_artikl INTEGER NOT NULL,
 kolicina INTEGER NOT NULL,
 PRIMARY KEY (id),
 FOREIGN KEY (id_racun) REFERENCES racun (id) ON DELETE CASCADE,
 FOREIGN KEY (id_artikl) REFERENCES artikl (id),
 UNIQUE (id_racun, id_artikl)
);

INSERT INTO kupac VALUES (1, 'Lea', 'Fabris'),
 (2, 'David', 'Sirotić'),
 (3, 'Tea', 'Bibić');
INSERT INTO zaposlenik VALUES
 (11, 'Marko', 'Marić', '123451', STR_TO_DATE('01.10.2020.', '%d.%m.%Y.')),
 (12, 'Toni', 'Milovan', '123452', STR_TO_DATE('02.10.2020.', '%d.%m.%Y.')),
 (13, 'Tea', 'Marić', '123453', STR_TO_DATE('02.10.2020.', '%d.%m.%Y.'));
INSERT INTO artikl VALUES (21, 'Puding', 5.99),
 (22, 'Milka čokolada', 30.00),
 (23, 'Čips', 9);
INSERT INTO racun VALUES
 (31, 11, 1, '00001', STR_TO_DATE('05.10.2020.', '%d.%m.%Y.')),
 (32, 12, 2, '00002', STR_TO_DATE('06.10.2020.', '%d.%m.%Y.')),
 (33, 12, 1, '00003', STR_TO_DATE('06.10.2020.', '%d.%m.%Y.'));
INSERT INTO stavka_racun VALUES (41, 31, 21, 2),
 (42, 31, 22, 5),
 (43, 32, 22, 1),
 (44, 32, 23, 1);
 
 # Definiranje funkcije
DELIMITER //
CREATE FUNCTION demo() RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
 RETURN "It works";
END//
DELIMITER ;
# Korištenje funkcije
SELECT demo() FROM DUAL;

/* ------------------------------ FUNKCIJE ---------------------------------------*/

# Definiranje funkcije
/*Funkcija koja zbraja dva broja: Napiši funkciju koja će za dva broja (definirane parametrima a i
  b) vratiti njihov zbroj: */
  
DELIMITER //
CREATE FUNCTION zbroji(a INTEGER, b INTEGER) RETURNS INTEGER
DETERMINISTIC
BEGIN
 RETURN a + b;
END//
DELIMITER ;
# Primjer korištenja funkcije
SELECT zbroji(1, 3) FROM DUAL;



/* ------------------------------- 1 --------------------------------------*/

/*Definiranje varijabli: Napiši funkciju koja će za dva broja (definirane parametrima a i b) vratiti
njihov zbroj:*/
 
 DELIMITER //
CREATE FUNCTION zbroji(a INTEGER, b INTEGER) RETURNS INTEGER
DETERMINISTIC
BEGIN
 DECLARE rezultat INTEGER DEFAULT 0;
 SET rezultat=a + b;
 RETURN rezultat;
END//
DELIMITER ;
SELECT zbroji(3,4) FROM DUAL;
 
 
 
 /* ----------------------------- 2 ----------------------------------------*/
 
/*Spremanje rezultata izvođenja upita u varijablu: Napiši funkciju koja će vratiti broj artikala
zapisanih u bazu podataka:*/

 DELIMITER //
CREATE FUNCTION br_art() RETURNS INTEGER
DETERMINISTIC
BEGIN
 DECLARE broj INTEGER DEFAULT 0;
 SELECT COUNT(id) INTO broj FROM artikl;
 RETURN broj;
END//
DELIMITER ;
 SELECT br_art() FROM DUAL;
 


 /* ------------------------------- 3 --------------------------------------*/
 
 /*Više varijabli: Napiši funkciju koja će vratiti izraz sa informacijama o cijeni artikala (npr. 'AVG: 15,
MAX: 30, MIN: 6'):*/
 
DELIMITER //
	CREATE FUNCTION info_art() RETURNS VARCHAR(50)
	DETERMINISTIC
		BEGIN
			DECLARE min_cj, avg_cj, max_cj INTEGER DEFAULT 0;
			DECLARE info VARCHAR(50);

            SELECT MIN(cijena),AVG(cijena),MAX(cijena) 
            INTO min_cj,avg_cj,max_cj
            FROM artikl;
            
            SET info=CONCAT("MIN: ",min_cj,", AVG: ",avg_cj," MAX: ",max_cj);
            RETURN info;
		END//
DELIMITER ;
DROP FUNCTION info_art;
SELECT info_art() FROM artikl;
 
 
 
 /* ---------------------------------- 4 -----------------------------------*/
 
/* Zadatak: Napiši funkciju koja će za određeni artikl (definiran sa parametrom p_id_artikl) izračunati
ukupnu prodanu količinu. Zatim napiši upit koji će prikazati sve artikle i njihovu prodanu količinu
koristeći prethodno napisanu funkciju: */

DELIMITER //
CREATE FUNCTION prodana_kolicina(p_id_artikl INTEGER) RETURNS INTEGER
DETERMINISTIC
BEGIN
 DECLARE kol INTEGER;

 SELECT SUM(kolicina) INTO kol
 FROM stavka_racun
 WHERE id_artikl = p_id_artikl;

 RETURN kol;
END//
DELIMITER ;
SELECT *, prodana_kolicina(id) AS prodana_kolicina
 FROM artikl;
 
 
 
 /* ------------------------------ 5 ---------------------------------------*/
 
/* Zadatak: Napiši funkciju koja će za određeni račun (definiran sa parametrom p_id_racun)
izračunati ukupan iznos. Zatim napiši upit koji će prikazati sve račune i njihov iznos koristeći
prethodno napisanu funkciju: */

DELIMITER //
CREATE FUNCTION sum_rac(p_id_racun INTEGER) RETURNS INTEGER
DETERMINISTIC
BEGIN
 DECLARE sum INTEGER;

 SELECT SUM(kolicina*cijena) INTO sum
 FROM stavka_racun
 INNER JOIN artikl ON stavka_racun.id_artikl = artikl.id
 WHERE stavka_racun.id_racun=p_id_racun;
 RETURN sum;
END//
DELIMITER ;
SELECT *, sum_rac(id) FROM racun;



 /* -------------------------------- 6 -------------------------------------*/

/* Grananja: Napiši funkciju koja će za određeni cijenu (definiran sa parametrom p_cijena) vratiti
vrijednost "Jeftino" ako je cijena manja od 10, u suprotnom će vratiti vrijednost "Skupo". U slučaju
da je p_cijena manja ili jednaka 0, vraća se vrijednost "Došlo je do greške": */

DELIMITER //
CREATE FUNCTION jef_cj(p_cijena INTEGER) RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
 DECLARE txt VARCHAR(50);
 
 IF p_cijena<=0 THEN
	SET txt="Greska";
 ELSEIF p_cijena<10 THEN
	SET txt="Jeftino";
ELSE
	SET txt="Skupo";
END IF;
RETURN txt;
 
END//
DELIMITER ;
SELECT *, jef_cj(cijena) FROM artikl;



 /* -------------------------------- 7 -------------------------------------*/

/* Zadatak: Napiši funkciju koja će za određeni artikl (definiran sa parametrom p_id_artikl) odrediti
njegovu popularnost, odnosno nije nikada prodan će se vratiti vrijednost "Artikl nije nikada izdan",
ako je prodan u količini manjoj od 5 će vratiti vrijednost "Nije popularan", inače će vratiti vrijednost
"Popularan": */

DELIMITER //
CREATE FUNCTION popularnost_artikla(p_id_artikl INTEGER) RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
DECLARE kol INTEGER;
 DECLARE rez VARCHAR(50);

 SELECT SUM(kolicina) INTO kol
 FROM stavka_racun
 WHERE id_artikl = p_id_artikl;

 IF kol = 0 THEN
 SET rez = "Artikl nije nikada izdan";
 ELSEIF kol < 5 THEN
 SET rez = "Nije popularan";
 ELSE
 SET rez = "Popularan";
 END IF;

 RETURN rez;
        
END//
DELIMITER ;
SELECT *, popularnost_artikla(id) FROM artikl;



 /* --------------------------------- 8 ------------------------------------*/
