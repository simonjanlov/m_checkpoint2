-- re-runnable script for checkpointdb

DROP VIEW IF EXISTS view_contacts;

DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS contacts;
DROP TABLE IF EXISTS contact_types;
DROP TABLE IF EXISTS contact_categories;


CREATE TABLE IF NOT EXISTS contact_categories (
	id SERIAL PRIMARY KEY,
	contact_category VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS contact_types (
	id SERIAL PRIMARY KEY,
	contact_type VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS contacts (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(60) NOT NULL,
	last_name VARCHAR(60) NOT NULL,
	title VARCHAR (30),
	organization VARCHAR(60)
);

CREATE TABLE IF NOT EXISTS items (
	contact VARCHAR(150) NOT NULL, -- so that there is space to, for example, contain a full address
	contact_id INTEGER NOT NULL REFERENCES contacts(id),
	contact_type_id INTEGER NOT NULL REFERENCES contact_types(id),
	contact_category_id INTEGER NOT NULL REFERENCES contact_categories(id),
	UNIQUE (contact, contact_id, contact_type_id, contact_category_id) -- we shouldn't be able to have identical entries
);

INSERT INTO contacts (first_name, last_name, title, organization) VALUES
	('Erik','Eriksson','Teacher','Utbildning AB'),
	('Anna','Sundh',null,null),
	('Goran','Bregovic','Coach','Dalens IK'),
	('Ann-Marie','Bergqvist','Cousin',null),
	('Herman','Appelkvist',null,null)
;
	
INSERT INTO contact_types (contact_type) VALUES
	('Email'),('Phone'),('Skype'),('Instagram')
;
	
INSERT INTO contact_categories (contact_category) VALUES
	('Home'),('Work'),('Fax')
;	

INSERT INTO items (contact, contact_id, contact_type_id, contact_category_id) VALUES
	('011-12 33 45',3,2,1),
	('goran@infoab.se',3,1,2),
	('010-88 55 44',4,2,2),
	('erik57@hotmail.com',1,1,1),
	('@annapanna99',2,4,1),
	('077-563578',2,2,1),
	('070-156 22 78',3,2,2)
;

-- 1.5 add two more rows to the contacts table 
INSERT INTO contacts (first_name, last_name, title, organization) VALUES
	('Simon','Janlöv','Student','Brights'),
	('Karl','Karlsson','Unemployed',null)
;


-- 1.6 Check for unused contact types

SELECT DISTINCT ct.contact_type AS "unused contact type(s)"
FROM contact_types ct
LEFT JOIN items i ON i.contact_type_id = ct.id
WHERE i.contact_type_id IS NULL;

-- 1.6 alternativ lösning med subquery

/*
SELECT contact_type AS "unused contact type(s)"
FROM contact_types
WHERE id NOT IN (
	SELECT contact_type_id
	FROM items
);
*/

-- 1.7 CREATE VIEW

CREATE VIEW view_contacts AS
	SELECT co.first_name, co.last_name, i.contact, ct.contact_type, cc.contact_category
	FROM contacts co
	JOIN items i ON i.contact_id = co.id
	JOIN contact_types ct ON ct.id = i.contact_type_id
	JOIN contact_categories cc ON cc.id = i.contact_category_id;

-- 1.8 SELECT all information except the ID columns

SELECT co.first_name, co.last_name, co.title, co.organization, i.contact, ct.contact_type, cc.contact_category
FROM contacts co
FULL JOIN items i ON i.contact_id = co.id
FULL JOIN contact_types ct ON ct.id = i.contact_type_id
FULL JOIN contact_categories cc ON cc.id = i.contact_category_id
ORDER BY co.first_name, co.last_name, ct.contact_type;





