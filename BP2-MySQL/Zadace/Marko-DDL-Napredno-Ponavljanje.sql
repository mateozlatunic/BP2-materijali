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
	id INTEGER PRIMARY KEY NOT NULL,
	naziv VARCHAR(20) NOT NULL,
    cijena NUMERIC (10,2),
    CONSTRAINT artikl_cijena_ck CHECK (cijena > 0)
);
INSERT INTO artikl VALUES(25, "Fanta", -1);

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
ALTER TABLE stavka_racun ADD
CONSTRAINT negativna_kolicina CHECK (kolicina>0);
INSERT INTO stavka_racun VALUES (41, 31, 21, -2);




DROP TABLE test_datum_vrijeme;
CREATE TABLE test_datum_vrijeme (
	datum DATE,
	vrijeme TIME,
	vrijeme_p TIME(5)
);
INSERT INTO test_datum_vrijeme VALUES ('2022-10-28', '17:50:24', '17:50:24.00000'),('2000-5-21','18:00','18:00:10.01');
SELECT *
FROM test_datum_vrijeme;




CREATE TABLE datum_vrijeme (
	datum_datetime DATETIME,
    datum_timestamp TIMESTAMP
);
INSERT INTO datum_vrijeme VALUES (NOW(), NOW());
SELECT *
FROM datum_vrijeme;



SELECT MINUTE(datum_timestamp),
 HOUR(datum_timestamp),
 YEAR(datum_datetime)
 FROM datum_vrijeme;

SELECT "Dan:",DAY(datum_datetime),"Mjesec:",MONTH(datum_datetime),"Godina:",YEAR(datum_datetime)
FROM datum_vrijeme;

SELECT *
WHERE 
FROM racun;

INSERT INTO kupac VALUES (1, 'Lea', 'Fabris'),
                         (2, 'David', 'Sirotić'),
                         (3, 'Tea', 'Bibić');

INSERT INTO zaposlenik VALUES (11, 'Marko', 'Marić', '123451', STR_TO_DATE('01.10.2020.', '%d.%m.%Y.')),
							  (12, 'Toni', 'Milovan', '123452', STR_TO_DATE('02.10.2020.', '%d.%m.%Y.')),
							  (13, 'Tea', 'Marić', '123453', STR_TO_DATE('02.10.2020.', '%d.%m.%Y.'));

INSERT INTO artikl VALUES (21, 'Puding', 5.99),
                          (22, 'Milka čokolada', 30.00),
                          (23, 'Čips', 9);

INSERT INTO racun VALUES (31, 11, 1, '00001', STR_TO_DATE('05.10.2021.', '%d.%m.%Y.')),
						 (32, 12, 2, '00002', STR_TO_DATE('06.10.2020.', '%d.%m.%Y.')),
						 (33, 12, 1, '00003', STR_TO_DATE('06.10.2020.', '%d.%m.%Y.'));

INSERT INTO stavka_racun VALUES (41, 31, 21, 2),
                                (42, 31, 22, 5),
                                (43, 32, 22, 1),
                                (44, 32, 23, 1);                                
-- 1.
SELECT *
FROM kupac
WHERE ime='Lea' OR ime='David';
-- 2.
SELECT id, CONCAT(ime, prezime) AS puno_ime
FROM kupac;
-- 3.
SELECT *
FROM artikl
WHERE cijena>=6 AND cijena<=100
ORDER BY cijena DESC;
-- 4.
SELECT UPPER(ime) AS velika_slova, COUNT(ime) AS broj_slova, prezime LIKE '%ić' AS odredeno
FROM kupac;
-- 5.


SELECT *
 FROM racun
 WHERE datum_izdavanja > NOW() - INTERVAL 1 YEAR;
 
SELECT DISTINCT prezime
FROM zaposlenik;
-- 6.
SELECT ime
FROM zaposlenik
UNION
SELECT ime
FROM kupac;
-- 7.
SELECT ime, prezime
FROM zaposlenik
ORDER BY prezime DESC, ime ASC;
-- 8.
SELECT *
FROM kupac
INNER JOIN racun ON racun.id_kupac=kupac.id;
-- 9.
SELECT *
FROM kupac
LEFT OUTER JOIN racun ON racun.id_kupac=kupac.id;
-- 10.
SELECT kupac.*, zaposlenik.*
FROM racun
INNER JOIN kupac ON racun.id_kupac=kupac.id
RIGHT OUTER JOIN zaposlenik ON racun.id_zaposlenik=zaposlenik.id;
-- 11.
SELECT *
FROM zaposlenik
WHERE ime='Lea' OR ime='David' OR ime='Tea';
-- 12.
SELECT MAX(cijena) AS Najveca_cijena, AVG(cijena) AS Srednja_cijena, MIN(cijena) AS Minimalnna_cijena
FROM artikl;
-- 13.
SELECT naziv, MAX(cijena) AS Najveca_cijena
FROM artikl;
-- 14.
SELECT kupac.*, COUNT(racun.id) AS broj_racuna
FROM kupac 
INNER JOIN racun ON racun.id_kupac=kupac.id
GROUP BY kupac.id;
SELECT kupac.*, COUNT(racun.id) AS broj_racuna
 FROM kupac 
 INNER JOIN racun ON kupac.id = racun.id_kupac
 GROUP BY kupac.id;
 -- 15.
 SELECT kupac.*, racun.*
 FROM kupac, racun
 WHERE kupac.id=racun.id_kupac
 GROUP BY kupac.id
 HAVING COUNT(racun.id)>1;
 -- 16.
 SELECT *, SUM(cijena * kolicina) AS Ukupan_iznos
 FROM racun
 INNER JOIN stavka_racun ON stavka_racun.id_racun=racun.id
 INNER JOIN artikl ON artikl.id=stavka_racun.id_artikl
 GROUP BY racun.id;
 -- 17.
 SELECT a.*
 FROM artikl a
 WHERE a.id IN (SELECT id_artikl 
	FROM stavka_racun
    GROUP BY id_artikl
    HAVING SUM(kolicina)>5);
-- 18.
CREATE VIEW racun_sa_iznosom AS
SELECT r.*, SUM(cijena * kolicina) AS iznos
FROM racun r
INNER JOIN stavka_racun s ON s.id_racun=r.id
INNER JOIN artikl a ON a.id=s.id_artikl
GROUP BY r.id;
-- 19.
CREATE VIEW skup_artikl AS
SELECT *
FROM artikl a
WHERE a.cijena>10;
SELECT *
FROM skup_artikl;
-- 20.
DROP VIEW skup_artikl;
CREATE VIEW skup_artikl AS
SELECT *
FROM artikl a
WHERE a.cijena>10
WITH CHECK OPTION;
SELECT *
FROM skup_artikl;
-- 21.
CREATE VIEW kupci_imeprezime AS
SELECT ime, prezime
FROM kupac
WHERE ime=prezime
WITH CHECK OPTION;
SELECT *
FROM kupci_imeprezime;
DROP VIEW kupci_imeprezime;
CREATE VIEW kupci_imeprezime AS SELECT ime,prezime
FROM kupac
WHERE ime LIKE prezime
WITH CHECK OPTION;
SELECT *
FROM kupci_imeprezime;
-- 22.
CREATE VIEW racun_sum_iznos AS
SELECT r.id, SUM(kolicina * cijena) AS ukupna_cijena_racun
FROM racun r, artikl a, stavka_racun sr
WHERE a.id=sr.id_artikl AND r.id=sr.id_racun
GROUP BY r.id;
SELECT *
FROM racun_sum_iznos
ORDER BY ukupna_cijena_racun DESC
LIMIT 1;
SELECT MAX(ukupna_cijena_racun)
FROM racun_sum_iznos;
SELECT *
FROM racun_sum_iznos
WHERE ukupna_cijena_racun IN (
	SELECT MAX(ukupna_cijena_racun)
    FROM racun_sum_iznos);
DROP VIEW racun_sum_iznos;
-- 23. DDL



-- -------------------------------------------------------Napredni DDL 28.10.2022.----------------------------------------------------
-- 1.
*CREATE TABLE artikl (
	id INTEGER PRIMARY KEY NOT NULL,
	naziv VARCHAR(20) NOT NULL,
    cijena NUMERIC (10,2),
    CONSTRAINT artikl_cijena_ck CHECK (cijena > 0)
);

-- 2
ALTER TABLE stavka_racun ADD
CONSTRAINT negativna_kolicina CHECK (kolicina>0);
INSERT INTO stavka_racun VALUES (41, 31, 21, -2);

-- 3.
CREATE TABLE test_datum_vrijeme (
	datum DATE,
	vrijeme TIME,
	vrijeme_p TIME(5)
);
INSERT INTO test_datum_vrijeme VALUES ('2022-10-28', '17:50:24', '17:50:24.00000'),('2000-5-21','18:00','18:00:10.01');
SELECT *
FROM test_datum_vrijeme;

-- 4.
SELECT MINUTE(datum_timestamp),
 HOUR(datum_timestamp),
 YEAR(datum_datetime)
 FROM datum_vrijeme;

-- 5.
SELECT "Dan:",DAY(datum_datetime),"Mjesec:",MONTH(datum_datetime),"Godina:",YEAR(datum_datetime)
FROM datum_vrijeme;

-- 6.
SELECT *
 FROM racun
 WHERE datum_izdavanja > NOW() - INTERVAL 1 YEAR;