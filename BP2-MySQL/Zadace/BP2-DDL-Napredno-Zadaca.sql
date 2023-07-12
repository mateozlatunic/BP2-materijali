DROP DATABASE IF EXISTS trgovina;
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
                                
                                
# Prikaži sve zaposlenike sa dodatnim stupcem (sa nazivom 'uljepsani_datum') koji će prikazivati datum zaposlenja u obliku sljedećeg
# primjera: zaposlen u 10:30 sati, datuma: 01.10.2020.

SELECT *, DATE_FORMAT(datum_zaposlenja, "Zaposlen u %h:%i sati, datuma: %d.%m.%Y") AS uljepsani_datum
	FROM zaposlenik;



# Prikaži sve zaposlenike koji su zaposleni u posljednjih godinu i pol dana

SELECT *
	FROM zaposlenik
    WHERE datum_zaposlenja > (NOW() - INTERVAL 18 MONTH);



# Napiši naredbu koje će tablici 'zaposlenik' dodati stupac sa nazivom 'placa' sa zadanom vrijednosti od 5000

ALTER TABLE zaposlenik
	ADD placa NUMERIC(8, 2) DEFAULT 5000.00;



# Napiši naredbu koja će u tablicu 'zaposlenik' dodati ograničenje sa pripadnim nazivom, koji će provjeravati da plaća zaposlenika
# mora biti iznad 3000

ALTER TABLE zaposlenik
	ADD CONSTRAINT zaposlenik_placa_ck CHECK (placa > 3000);



# Napravi privremenu tablicu sa nazivom 'najskuplji_artikl' koja će imati iste stupce kao i tablica 'artikl', dok je u nju potrebno
# spremiti artikl sa najvećom cijenom (rezultat: privremena tablica treba sadržavati redak: 22, 'Milka čokolada', 30.00 )

CREATE TEMPORARY TABLE najskuplji_artikl AS (SELECT *
												FROM artikl
												ORDER BY cijena DESC
												LIMIT 1);

SELECT *
	FROM najskuplji_artikl;
