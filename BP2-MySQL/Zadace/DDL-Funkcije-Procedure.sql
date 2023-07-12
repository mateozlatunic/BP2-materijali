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
	cijena NUMERIC(10,2) NOT NULL CHECK (cijena > 0),
	PRIMARY KEY (id)
);

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

INSERT INTO zaposlenik VALUES (11, 'Marko', 'Marić', '123451', STR_TO_DATE('01.10.2020.', '%d.%m.%Y.')),
							  (12, 'Toni', 'Milovan', '123452', STR_TO_DATE('02.10.2020.', '%d.%m.%Y.')),
							  (13, 'Tea', 'Marić', '123453', STR_TO_DATE('02.10.2020.', '%d.%m.%Y.'));

INSERT INTO artikl VALUES (21, 'Puding', 5.99),
                          (22, 'Milka čokolada', 30.00),
                          (23, 'Čips', 9);

INSERT INTO racun VALUES (31, 11, 1, '00001', STR_TO_DATE('05.10.2020.', '%d.%m.%Y.')),
						 (32, 12, 2, '00002', STR_TO_DATE('06.10.2020.', '%d.%m.%Y.')),
						 (33, 12, 1, '00003', STR_TO_DATE('06.10.2020.', '%d.%m.%Y.'));

INSERT INTO stavka_racun VALUES (41, 31, 21, 2),
                                (42, 31, 22, 5),
                                (43, 32, 22, 1),
                                (44, 32, 23, 1);
 
 
 
 
 /* =================== FUNKCIJE ========================= */
 
# 1. Napiši funkciju koja će vratiti trenutni datum u obliku sljedećeg primjera 31.10.20. 

DELIMITER //
CREATE FUNCTION npr () RETURNS VARCHAR(30)
DETERMINISTIC
	BEGIN
		RETURN "31.10.20.";
	END//
DELIMITER ;

SELECT npr() FROM DUAL;


# 2. Napiši funkciju koja će za dva broja (definirane sa parametrima a i b) izračunati i vratiti njihov umnožak

DELIMITER //
	CREATE FUNCTION umn(prvi INTEGER, drugi INTEGER) RETURNS INTEGER
	DETERMINISTIC
		BEGIN
			RETURN prvi * drugi;
		END//
DELIMITER ;
# Primjer korištenja funkcije
SELECT umn(3, 3) FROM DUAL;


 /* =================== FUNKCIJE I PROCEDURE ========================= */

/* Napiši funkciju koja će za određeni račun (definiran sa parametrom p_id_racun) vratiti 'DA' ako račun ima
   barem jednu stavku, u suprotnom će vratiti vrijednost 'NE'. Isprobaj funkciju na nekom računu. */
   
DELIMITER //
	CREATE FUNCTION stavka (p_id_racun INTEGER) RETURNS CHAR(2)
	DETERMINISTIC
BEGIN
	DECLARE br_stavka INTEGER;
    
    SELECT COUNT(*) INTO br_stavka
		FROM stavka_racun
		WHERE id_racun = p_id_racun;
        
    IF br_stavka > 0 THEN
		RETURN "DA";
	ELSE
		RETURN "NE";
	END IF;
END //
DELIMITER ;
	SELECT *, stavka(id) AS jedna_stavka
	FROM racun;



/* Napiši funkciju koja će za određeno ime (definiran sa parametrom p_ime) prebrojati koliko puta se ono
   pojavljuje u tablicama zaposlenika i kupca (npr. ime 'Tea' se pojavljuje dva puta). Zatim napiši upit koji će prikazati
   sve kupce zajedno sa brojem pojavljivanja imena pojedinog kupca koristeći prethodno napisanu funkciju. */
   
DELIMITER //
	CREATE FUNCTION ime (p_ime VARCHAR(50)) RETURNS INTEGER
	DETERMINISTIC
	BEGIN
		DECLARE broj INTEGER;

		SELECT COUNT(*) INTO broj
		FROM (SELECT ime FROM kupac 
			UNION 
			SELECT ime FROM zaposlenik)
		AS imena WHERE imena.ime = p_ime; 
    
		RETURN broj;
	END //
DELIMITER ;
	SELECT *, ime(ime) AS ime_brojac
	FROM kupac;

/* Napiši proceduru koja će za dva broja (definirane sa parametrima a i b) izračunati i vratiti njihov umnožak. Primjer 
   pozivanja procedure: CALL umnozak(10, 3, @rezultat); */

DROP PROCEDURE IF EXISTS pomnozi;

DELIMITER //
CREATE PROCEDURE pomn (IN a INTEGER, IN b INTEGER, OUT rez INTEGER)
	BEGIN
		SET rez = a * b;
	END //
DELIMITER ;
	DROP PROCEDURE pomn;
	CALL pomn(5, 5, @rez);
	SELECT @rez FROM DUAL;

/* Napiši proceduru koja će provjeriti jesu li svi brojevi računa dužine 5 znakova ili više. Ako svi brojevi računa
   imaju minimalno 5 znakova će se u varijablu rezultat spremiti vrijednost 'DA', inače će se spremiti vrijednost 'NE'. 
   Primjer pozivanja procedure: CALL provjeri_brojeve_racuna(@rezultat); */

 #  X   X  X   X  X   X  X   X  X   X  X   X  X   X  X   X  X   X  X   X  X   X  X   X  X   X  X   X  X   X  X   X  X   X  X   X 

