--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE matiic;
ALTER ROLE matiic WITH SUPERUSER INHERIT NOCREATEROLE CREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:db3FOVC2R/l79ifEqF4ZJA==$yrtRfGib1xLFhAfEtr8FdDxw6yyS0kdrgzieQqtDeaY=:fG450Z1ZjiM44cNuBea7jQOC4O6xTCI+FOn84t70zrc=';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:p23+/wlDBqYc6kaWjoxXBA==$o3cTmpFcOhnGaMxzBRnr0QfppJ+E7rGHKh1mEd629WA=:cziVFn/GP7hl4n40CNLE1OnoQ4/TnDgcB3lhfGRPd7M=';

--
-- User Configurations
--








--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Debian 16.4-3+b1)
-- Dumped by pg_dump version 16.4 (Debian 16.4-3+b1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Debian 16.4-3+b1)
-- Dumped by pg_dump version 16.4 (Debian 16.4-3+b1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

--
-- Database "recruitment" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Debian 16.4-3+b1)
-- Dumped by pg_dump version 16.4 (Debian 16.4-3+b1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: recruitment; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE recruitment WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';


ALTER DATABASE recruitment OWNER TO postgres;

\connect recruitment

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cv; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cv (
    id integer NOT NULL,
    xml_data text NOT NULL
);


ALTER TABLE public.cv OWNER TO postgres;

--
-- Name: cv_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cv_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cv_id_seq OWNER TO postgres;

--
-- Name: cv_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cv_id_seq OWNED BY public.cv.id;


--
-- Name: cvs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cvs (
    id integer NOT NULL,
    data xml
);


ALTER TABLE public.cvs OWNER TO postgres;

--
-- Name: cvs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cvs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cvs_id_seq OWNER TO postgres;

--
-- Name: cvs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cvs_id_seq OWNED BY public.cvs.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(150) NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: cv id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cv ALTER COLUMN id SET DEFAULT nextval('public.cv_id_seq'::regclass);


--
-- Name: cvs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cvs ALTER COLUMN id SET DEFAULT nextval('public.cvs_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: cv; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cv (id, xml_data) FROM stdin;
1	<?xml version='1.0' encoding='UTF-8'?>\n<cv_list>\n  <cv id="1">\n  <entete>\n    <nom>younes</nom>\n    <prenom>hadli</prenom>\n    <dateNaissance>1990-05-15</dateNaissance>\n    <adresse>123 Main Street, City, Country</adresse>\n    <nationalite>American</nationalite>\n    <situationMaritale>Single</situationMaritale>\n    <permis>B</permis>\n    <photo>base64_encoded_image_or_url</photo>\n  </entete>\n  <objectif>Seeking a challenging position in software development</objectif>\n  <situationActuelle>Currently employed as a Junior Developer at XYZ Corp</situationActuelle>\n  <parcours>\n    <formations>\n      <diplome a="2020" de="2018" etablissement="University of Technology" type="Master">Computer Science</diplome>\n      <diplome a="2018" de="2015" etablissement="State College" type="Bachelor">Information Technology</diplome>\n    </formations>\n    <stages>\n      <stage>\n        <intituleStage>Software Development Intern</intituleStage>\n        <date>Summer</date>\n        <annee>2019</annee>\n        <descriptionstage>Worked on web application development using Python and Django</descriptionstage>\n      </stage>\n    </stages>\n    <experiencesProfessionnelles>\n      <experience a="2022" de="2020" etablissement="XYZ Corp" id="exp1" poste="Junior Developer">\n        <description>Full-stack development of web applications</description>\n        <achievement>Developed RESTful APIs using Flask</achievement>\n        <achievement>Implemented front-end components with React</achievement>\n        <achievement>Optimized database queries for better performance</achievement>\n      </experience>\n    </experiencesProfessionnelles>\n  </parcours>\n  <competences>\n    <competence>\n      <titre>Programming Languages</titre>\n      <description>Python, JavaScript, Java</description>\n    </competence>\n    <competence>\n      <titre>Web Development</titre>\n      <description>HTML, CSS, React, Flask, Django</description>\n    </competence>\n  </competences>\n  <langues>\n    <langue>\n      <intitule>English</intitule>\n      <niveau>Fluent</niveau>\n    </langue>\n    <langue>\n      <intitule>French</intitule>\n      <niveau>Intermediate</niveau>\n    </langue>\n  </langues>\n  <loisirs>\n    <loisir>Hiking</loisir>\n    <loisir>Photography</loisir>\n    <loisir>Chess</loisir>\n  </loisirs>\n  <references>\n    <reference>\n      <contact email="ref1@example.com" telephone="1234567890" web="https://www.linkedin.com/in/ref1">\n        <nom>Smith</nom>\n        <relation>Former Manager at XYZ Corp</relation>\n      </contact>\n    </reference>\n  </references>\n</cv>\n<cv id="3">\n  <entete>\n    <nom>alileche</nom>\n    <prenom>rayan</prenom>\n    <dateNaissance>1990-05-15</dateNaissance>\n    <adresse>123 Main Street, City, Country</adresse>\n    <nationalite>American</nationalite>\n    <situationMaritale>Single</situationMaritale>\n    <permis>B</permis>\n    <photo>base64_encoded_image_or_url</photo>\n  </entete>\n  <objectif>Seeking a challenging position in software development</objectif>\n  <situationActuelle>Currently employed as a Junior Developer at XYZ Corp</situationActuelle>\n  <parcours>\n    <formations>\n      <diplome a="2020" de="2018" etablissement="University of Technology" type="Master">Computer Science</diplome>\n      <diplome a="2018" de="2015" etablissement="State College" type="Bachelor">Information Technology</diplome>\n    </formations>\n    <stages>\n      <stage>\n        <intituleStage>Software Development Intern</intituleStage>\n        <date>Summer</date>\n        <annee>2019</annee>\n        <descriptionstage>Worked on web application development using Python and Django</descriptionstage>\n      </stage>\n    </stages>\n    <experiencesProfessionnelles>\n      <experience a="2022" de="2020" etablissement="XYZ Corp" poste="Junior Developer" id="aafb2e7ed21946c090b4b102438b82ed">\n        <description>Full-stack development of web applications</description>\n        <achievement>Developed RESTful APIs using Flask</achievement>\n        <achievement>Implemented front-end components with React</achievement>\n        <achievement>Optimized database queries for better performance</achievement>\n      </experience>\n    </experiencesProfessionnelles>\n  </parcours>\n  <competences>\n    <competence>\n      <titre>Programming Languages</titre>\n      <description>Python, JavaScript, Java</description>\n    </competence>\n    <competence>\n      <titre>Web Development</titre>\n      <description>HTML, CSS, React, Flask, Django</description>\n    </competence>\n  </competences>\n  <langues>\n    <langue>\n      <intitule>English</intitule>\n      <niveau>Fluent</niveau>\n    </langue>\n    <langue>\n      <intitule>French</intitule>\n      <niveau>Intermediate</niveau>\n    </langue>\n  </langues>\n  <loisirs>\n    <loisir>Hiking</loisir>\n    <loisir>Photography</loisir>\n    <loisir>Chess</loisir>\n  </loisirs>\n  <references>\n    <reference>\n      <contact email="ref1@example.com" telephone="1234567890" web="https://www.linkedin.com/in/ref1">\n        <nom>Smith</nom>\n        <relation>Former Manager at XYZ Corp</relation>\n      </contact>\n    </reference>\n  </references>\n</cv><cv id="4">\n  <entete>\n    <nom>younes</nom>\n    <prenom>hadli</prenom>\n    <dateNaissance>1990-05-15</dateNaissance>\n    <adresse>123 Main Street, City, Country</adresse>\n    <nationalite>American</nationalite>\n    <situationMaritale>Single</situationMaritale>\n    <permis>B</permis>\n    <photo>base64_encoded_image_or_url</photo>\n  </entete>\n  <objectif>Seeking a challenging position in software development</objectif>\n  <situationActuelle>Currently employed as a Junior Developer at XYZ Corp</situationActuelle>\n  <parcours>\n    <formations>\n      <diplome a="2020" de="2018" etablissement="University of Technology" type="Master">Computer Science</diplome>\n      <diplome a="2018" de="2015" etablissement="State College" type="Bachelor">Information Technology</diplome>\n    </formations>\n    <stages>\n      <stage>\n        <intituleStage>Software Development Intern</intituleStage>\n        <date>Summer</date>\n        <annee>2019</annee>\n        <descriptionstage>Worked on web application development using Python and Django</descriptionstage>\n      </stage>\n    </stages>\n    <experiencesProfessionnelles>\n      <experience a="2022" de="2020" etablissement="XYZ Corp" poste="Junior Developer" id="bd84a9e2732943119ffb844f78c955f3">\n        <description>Full-stack development of web applications</description>\n        <achievement>Developed RESTful APIs using Flask</achievement>\n        <achievement>Implemented front-end components with React</achievement>\n        <achievement>Optimized database queries for better performance</achievement>\n      </experience>\n    </experiencesProfessionnelles>\n  </parcours>\n  <competences>\n    <competence>\n      <titre>Programming Languages</titre>\n      <description>Python, JavaScript, Java</description>\n    </competence>\n    <competence>\n      <titre>Web Development</titre>\n      <description>HTML, CSS, React, Flask, Django</description>\n    </competence>\n  </competences>\n  <langues>\n    <langue>\n      <intitule>English</intitule>\n      <niveau>Fluent</niveau>\n    </langue>\n    <langue>\n      <intitule>French</intitule>\n      <niveau>Intermediate</niveau>\n    </langue>\n  </langues>\n  <loisirs>\n    <loisir>Hiking</loisir>\n    <loisir>Photography</loisir>\n    <loisir>Chess</loisir>\n  </loisirs>\n  <references>\n    <reference>\n      <contact email="ref1@example.com" telephone="1234567890" web="https://www.linkedin.com/in/ref1">\n        <nom>Smith</nom>\n        <relation>Former Manager at XYZ Corp</relation>\n      </contact>\n    </reference>\n  </references>\n</cv><cv id="5">\n  <entete>\n    <nom>younes</nom>\n    <prenom>hadli</prenom>\n    <dateNaissance>1990-05-15</dateNaissance>\n    <adresse>123 Main Street, City, Country</adresse>\n    <nationalite>American</nationalite>\n    <situationMaritale>Single</situationMaritale>\n    <permis>B</permis>\n    <photo>base64_encoded_image_or_url</photo>\n  </entete>\n  <objectif>Seeking a challenging position in software development</objectif>\n  <situationActuelle>Currently employed as a Junior Developer at XYZ Corp</situationActuelle>\n  <parcours>\n    <formations>\n      <diplome a="2020" de="2018" etablissement="University of Technology" type="Master">Computer Science</diplome>\n      <diplome a="2018" de="2015" etablissement="State College" type="Bachelor">Information Technology</diplome>\n    </formations>\n    <stages>\n      <stage>\n        <intituleStage>Software Development Intern</intituleStage>\n        <date>Summer</date>\n        <annee>2019</annee>\n        <descriptionstage>Worked on web application development using Python and Django</descriptionstage>\n      </stage>\n    </stages>\n    <experiencesProfessionnelles>\n      <experience a="2022" de="2020" etablissement="XYZ Corp" poste="Junior Developer" id="f9128e539f524dafa46b1e285b89fa5b">\n        <description>Full-stack development of web applications</description>\n        <achievement>Developed RESTful APIs using Flask</achievement>\n        <achievement>Implemented front-end components with React</achievement>\n        <achievement>Optimized database queries for better performance</achievement>\n      </experience>\n    </experiencesProfessionnelles>\n  </parcours>\n  <competences>\n    <competence>\n      <titre>Programming Languages</titre>\n      <description>Python, JavaScript, Java</description>\n    </competence>\n    <competence>\n      <titre>Web Development</titre>\n      <description>HTML, CSS, React, Flask, Django</description>\n    </competence>\n  </competences>\n  <langues>\n    <langue>\n      <intitule>English</intitule>\n      <niveau>Fluent</niveau>\n    </langue>\n    <langue>\n      <intitule>French</intitule>\n      <niveau>Intermediate</niveau>\n    </langue>\n  </langues>\n  <loisirs>\n    <loisir>Hiking</loisir>\n    <loisir>Photography</loisir>\n    <loisir>Chess</loisir>\n  </loisirs>\n  <references>\n    <reference>\n      <contact email="ref1@example.com" telephone="1234567890" web="https://www.linkedin.com/in/ref1">\n        <nom>Smith</nom>\n        <relation>Former Manager at XYZ Corp</relation>\n      </contact>\n    </reference>\n  </references>\n</cv><cv id="6">\n  <entete>\n    <nom>islam</nom>\n    <prenom>hadli</prenom>\n    <dateNaissance>1990-05-15</dateNaissance>\n    <adresse>123 Main Street, City, Country</adresse>\n    <nationalite>American</nationalite>\n    <situationMaritale>Single</situationMaritale>\n    <permis>B</permis>\n    <photo>base64_encoded_image_or_url</photo>\n  </entete>\n  <objectif>Seeking a challenging position in software development</objectif>\n  <situationActuelle>Currently employed as a Junior Developer at XYZ Corp</situationActuelle>\n  <parcours>\n    <formations>\n      <diplome a="2020" de="2018" etablissement="University of Technology" type="Master">Computer Science</diplome>\n      <diplome a="2018" de="2015" etablissement="State College" type="Bachelor">Information Technology</diplome>\n    </formations>\n    <stages>\n      <stage>\n        <intituleStage>Software Development Intern</intituleStage>\n        <date>Summer</date>\n        <annee>2019</annee>\n        <descriptionstage>Worked on web application development using Python and Django</descriptionstage>\n      </stage>\n    </stages>\n    <experiencesProfessionnelles>\n      <experience a="2022" de="2020" etablissement="XYZ Corp" poste="Junior Developer" id="fc6973917fa94ec9bb91ec22320d85d3">\n        <description>Full-stack development of web applications</description>\n        <achievement>Developed RESTful APIs using Flask</achievement>\n        <achievement>Implemented front-end components with React</achievement>\n        <achievement>Optimized database queries for better performance</achievement>\n      </experience>\n    </experiencesProfessionnelles>\n  </parcours>\n  <competences>\n    <competence>\n      <titre>Programming Languages</titre>\n      <description>Python, JavaScript, Java</description>\n    </competence>\n    <competence>\n      <titre>Web Development</titre>\n      <description>HTML, CSS, React, Flask, Django</description>\n    </competence>\n  </competences>\n  <langues>\n    <langue>\n      <intitule>English</intitule>\n      <niveau>Fluent</niveau>\n    </langue>\n    <langue>\n      <intitule>French</intitule>\n      <niveau>Intermediate</niveau>\n    </langue>\n  </langues>\n  <loisirs>\n    <loisir>Hiking</loisir>\n    <loisir>Photography</loisir>\n    <loisir>Chess</loisir>\n  </loisirs>\n  <references>\n    <reference>\n      <contact email="ref1@example.com" telephone="1234567890" web="https://www.linkedin.com/in/ref1">\n        <nom>Smith</nom>\n        <relation>Former Manager at XYZ Corp</relation>\n      </contact>\n    </reference>\n  </references>\n</cv><cv id="7">\n  <entete>\n    <nom>youneshadli09</nom>\n    <prenom>youneshadli09</prenom>\n    <dateNaissance>01/11/202</dateNaissance>\n    <adresse>city 90 log batiment A4 n 128</adresse>\n    <nationalite>algerien</nationalite>\n    <situationMaritale>celibataire</situationMaritale>\n    <permis>permis B</permis>\n    <photo/>\n  </entete>\n  <objectif>string</objectif>\n  <situationActuelle>string</situationActuelle>\n  <parcours>\n    <formations>\n      <diplome type="youneshadli09" etablissement="youneshadli09" de="2020" a="2024">youneshadli09</diplome>\n    </formations>\n    <stages>\n      <stage>\n        <intituleStage>youneshadli09</intituleStage>\n        <date>01/11/2020</date>\n        <annee>2020</annee>\n        <descriptionstage>youneshadli09</descriptionstage>\n      </stage>\n    </stages>\n    <experiencesProfessionnelles>\n      <experience poste="youneshadli09" etablissement="youneshadli09" de="2020" a="2020" id="e60a7fa8501b4b899c8be00531c3b995">\n        <description>youneshadli09</description>\n        <achievement>youneshadli09</achievement>\n      </experience>\n    </experiencesProfessionnelles>\n  </parcours>\n  <competences>\n    <competence>\n      <titre>youneshadli09</titre>\n      <description>youneshadli09</description>\n    </competence>\n  </competences>\n  <langues>\n    <langue>\n      <intitule>francais</intitule>\n      <niveau>b2</niveau>\n    </langue>\n  </langues>\n  <loisirs>\n    <loisir>youneshadli09</loisir>\n  </loisirs>\n  <references>\n    <reference>\n      <contact email="youneshadli09@gmail.com" telephone="0770090580" web="https://www.facebook.com/">\n        <nom>youneshadli09</nom>\n        <relation>youneshadli09</relation>\n      </contact>\n    </reference>\n  </references>\n</cv></cv_list>\n
\.


--
-- Data for Name: cvs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cvs (id, data) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email) FROM stdin;
\.


--
-- Name: cv_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cv_id_seq', 1, true);


--
-- Name: cvs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cvs_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: cv cv_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cv
    ADD CONSTRAINT cv_pkey PRIMARY KEY (id);


--
-- Name: cvs cvs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cvs
    ADD CONSTRAINT cvs_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

--
-- Database "testdb" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Debian 16.4-3+b1)
-- Dumped by pg_dump version 16.4 (Debian 16.4-3+b1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: testdb; Type: DATABASE; Schema: -; Owner: matiic
--

CREATE DATABASE testdb WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';


ALTER DATABASE testdb OWNER TO matiic;

\connect testdb

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: test1; Type: TABLE; Schema: public; Owner: matiic
--

CREATE TABLE public.test1 (
    id integer NOT NULL,
    name character varying(255),
    email character varying(255),
    password character varying(255)
);


ALTER TABLE public.test1 OWNER TO matiic;

--
-- Name: test1_id_seq; Type: SEQUENCE; Schema: public; Owner: matiic
--

CREATE SEQUENCE public.test1_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.test1_id_seq OWNER TO matiic;

--
-- Name: test1_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: matiic
--

ALTER SEQUENCE public.test1_id_seq OWNED BY public.test1.id;


--
-- Name: test1 id; Type: DEFAULT; Schema: public; Owner: matiic
--

ALTER TABLE ONLY public.test1 ALTER COLUMN id SET DEFAULT nextval('public.test1_id_seq'::regclass);


--
-- Data for Name: test1; Type: TABLE DATA; Schema: public; Owner: matiic
--

COPY public.test1 (id, name, email, password) FROM stdin;
\.


--
-- Name: test1_id_seq; Type: SEQUENCE SET; Schema: public; Owner: matiic
--

SELECT pg_catalog.setval('public.test1_id_seq', 1, false);


--
-- Name: test1 test1_pkey; Type: CONSTRAINT; Schema: public; Owner: matiic
--

ALTER TABLE ONLY public.test1
    ADD CONSTRAINT test1_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

