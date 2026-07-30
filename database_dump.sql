--
-- PostgreSQL database dump
--

\restrict e8PFRpldnOXNhTb4APldxiBP2oozDDaDyiB0bfk2EdXlIol0HrrwMs0WybldSQb

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: user_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role AS ENUM (
    'student',
    'admin',
    'content_moderator'
);


ALTER TYPE public.user_role OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: balances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.balances (
    user_id uuid NOT NULL,
    token_balance bigint DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.balances OWNER TO postgres;

--
-- Name: papers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.papers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    subject text NOT NULL,
    paper_payload jsonb,
    download_url text,
    tokens_spent bigint DEFAULT 5 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.papers OWNER TO postgres;

--
-- Name: quizzes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quizzes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    subject text NOT NULL,
    questions jsonb NOT NULL,
    answers jsonb,
    score numeric(5,2),
    tokens_spent bigint DEFAULT 5 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.quizzes OWNER TO postgres;

--
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refresh_tokens (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    token_hash text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    revoked boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.refresh_tokens OWNER TO postgres;

--
-- Name: token_transfers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.token_transfers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    sender_user_id uuid NOT NULL,
    recipient_user_id uuid NOT NULL,
    amount bigint NOT NULL,
    transaction_id uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.token_transfers OWNER TO postgres;

--
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    from_user_id uuid,
    to_user_id uuid,
    amount bigint NOT NULL,
    tx_type text NOT NULL,
    reference_id uuid,
    note text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- Name: uploads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.uploads (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    filename text NOT NULL,
    storage_path text NOT NULL,
    status text DEFAULT 'processing'::text NOT NULL,
    ai_score numeric(5,2),
    reward_tokens bigint DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.uploads OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    wallet_address text,
    email text,
    signup_bonus_granted boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    role public.user_role DEFAULT 'student'::public.user_role NOT NULL,
    password_hash text,
    username text
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Data for Name: balances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.balances (user_id, token_balance, updated_at) FROM stdin;
9477dc4f-743d-45d2-b236-6bcc35508be8	38	2026-07-15 14:44:24.511+05
463035c3-cb7a-49fc-9d27-b707d33c20bb	0	2026-07-18 17:27:19.467+05
1fafa569-03dd-4e95-bfc0-69d3d87835bb	178	2026-07-20 20:25:31.583+05
\.


--
-- Data for Name: papers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.papers (id, user_id, subject, paper_payload, download_url, tokens_spent, created_at) FROM stdin;
154e09b6-d33d-47ee-b6bc-8b518b6e00c6	9477dc4f-743d-45d2-b236-6bcc35508be8	Chemistry	\N	/api/paper/download/ea768a27-f121-4e36-929a-d437b62c8708	5	2026-07-14 20:31:23.74+05
2acc3e13-de6a-44f2-8528-472435c48dd6	9477dc4f-743d-45d2-b236-6bcc35508be8	Physics	\N	/api/paper/download/32c518f5-8040-48d1-bec7-76bad7ddfa0c	2	2026-07-15 14:44:24.539+05
124fcc7a-395c-4278-a726-51a63ef46fe3	1fafa569-03dd-4e95-bfc0-69d3d87835bb	English	{"mcqs": [], "long_questions": [], "short_questions": []}	/api/paper/download/36a3635a-d13e-4502-8d3f-69f24f9e01a4	5	2026-07-20 16:29:56.736+05
eb93a944-ff3a-4843-b2ac-84a0c36d903c	1fafa569-03dd-4e95-bfc0-69d3d87835bb	English	{"mcqs": [{"id": 1, "answer": "C", "prompt": "Which of the following is a noun?", "options": [{"id": "A", "label": "Run"}, {"id": "B", "label": "Beautiful"}, {"id": "C", "label": "Happiness"}, {"id": "D", "label": "Quickly"}]}, {"id": 2, "answer": "B", "prompt": "The plural of 'child' is:", "options": [{"id": "A", "label": "Childs"}, {"id": "B", "label": "Children"}, {"id": "C", "label": "Childes"}, {"id": "D", "label": "Childrens"}]}, {"id": 3, "answer": "B", "prompt": "Which sentence is in the passive voice?", "options": [{"id": "A", "label": "She wrote the letter"}, {"id": "B", "label": "The letter was written by her"}, {"id": "C", "label": "She is writing the letter"}, {"id": "D", "label": "She will write the letter"}]}, {"id": 4, "answer": "B", "prompt": "A word that modifies a verb is called:", "options": [{"id": "A", "label": "Adjective"}, {"id": "B", "label": "Adverb"}, {"id": "C", "label": "Noun"}, {"id": "D", "label": "Preposition"}]}, {"id": 5, "answer": "B", "prompt": "Choose the correct article: ___ apple a day keeps the doctor away.", "options": [{"id": "A", "label": "A"}, {"id": "B", "label": "An"}, {"id": "C", "label": "The"}, {"id": "D", "label": "No article"}]}, {"id": 6, "answer": "A", "prompt": "A sentence that expresses a question is called:", "options": [{"id": "A", "label": "Interrogative"}, {"id": "B", "label": "Declarative"}, {"id": "C", "label": "Imperative"}, {"id": "D", "label": "Exclamatory"}]}, {"id": 7, "answer": "A", "prompt": "The word 'benevolent' means:", "options": [{"id": "A", "label": "Kind and generous"}, {"id": "B", "label": "Cruel and harsh"}, {"id": "C", "label": "Shy and quiet"}, {"id": "D", "label": "Strong and fearless"}]}, {"id": 8, "answer": "A", "prompt": "Which literary device involves giving human qualities to non-human things?", "options": [{"id": "A", "label": "Personification"}, {"id": "B", "label": "Metaphor"}, {"id": "C", "label": "Simile"}, {"id": "D", "label": "Alliteration"}]}], "long_questions": [{"id": 1, "question": "Write an essay of about 250 words on 'Science and Technology in Modern Life'. Include an introduction, body paragraphs, and a conclusion."}, {"id": 2, "question": "Write an argumentative essay of 300 words on: 'Social media has a negative impact on youth'. Present both sides and give your opinion."}, {"id": 3, "question": "Write a letter to the editor of a newspaper complaining about the lack of public parks in your city. Suggest solutions."}], "short_questions": [{"id": 1, "question": "Write a paragraph of 80–100 words on 'The Importance of Education'."}, {"id": 2, "question": "Use the following words in your own sentences: perseverance, diligent, benevolent."}, {"id": 3, "question": "Change the following sentences from active to passive voice: (a) The teacher taught the lesson. (b) She is reading a book."}, {"id": 4, "question": "What is a metaphor? Give two examples from literature."}, {"id": 5, "question": "Correct the following sentences: (a) She don't know the answer. (b) He is more taller than me."}]}	/api/paper/download/0d150e1a-27bb-43f3-850d-62e2235f7ffc	5	2026-07-20 16:31:53.23+05
1d5d2281-df8c-498a-9323-995d670a9cba	1fafa569-03dd-4e95-bfc0-69d3d87835bb	Mathematics	\N	/api/paper/download/954fdecc-396c-4d48-9224-df4c87730a7a	2	2026-07-20 16:35:31.193+05
0f405fe7-f63c-44e8-b231-8c1cd4775f83	1fafa569-03dd-4e95-bfc0-69d3d87835bb	Chemistry	\N	/api/paper/download/6fa14b8f-455e-40ce-a10e-b8662420e4bd	5	2026-07-20 18:05:01.962+05
0ca663e8-94e2-4642-8a26-b6265b807424	1fafa569-03dd-4e95-bfc0-69d3d87835bb	Chemistry	{"mcqs": [{"id": 1, "answer": "A", "prompt": "Which of the following is a sign of a chemical reaction?", "options": [{"id": "A", "label": "Colour change"}, {"id": "B", "label": "No change in mass"}, {"id": "C", "label": "Same properties"}, {"id": "D", "label": "Reversible mixing"}]}, {"id": 2, "answer": "A", "prompt": "The molar mass of CO₂ is:", "options": [{"id": "A", "label": "44 g/mol"}, {"id": "B", "label": "28 g/mol"}, {"id": "C", "label": "12 g/mol"}, {"id": "D", "label": "32 g/mol"}]}], "long_questions": [{"id": 1, "question": "Describe the properties and uses of acids and bases. Explain neutralization. Describe the pH scale and its significance."}], "short_questions": [{"id": 1, "question": "Balance the equation: Fe + HCl → FeCl₂ + H₂. Calculate the mass of H₂ produced from 5.6 g of Fe."}, {"id": 2, "question": "Define alloys. Give two examples and their uses."}]}	/api/paper/download/8dee5aaf-977c-49b5-b99d-27795d4be6c1	2	2026-07-20 20:11:27.878+05
f90d6fc5-5371-4c7e-9b3e-00d8b8c7c983	1fafa569-03dd-4e95-bfc0-69d3d87835bb	Pakistan Studies	{"mcqs": [{"id": 1, "answer": "A", "prompt": "The Internet is an example of:", "options": [{"id": "A", "label": "WAN"}, {"id": "B", "label": "LAN"}, {"id": "C", "label": "MAN"}, {"id": "D", "label": "PAN"}]}, {"id": 2, "answer": "A", "prompt": "Rusting of iron is an example of:", "options": [{"id": "A", "label": "Oxidation"}, {"id": "B", "label": "Reduction"}, {"id": "C", "label": "Sublimation"}, {"id": "D", "label": "Neutralization"}]}, {"id": 4, "answer": "A", "prompt": "The genetic material present in chromosomes is:", "options": [{"id": "A", "label": "DNA"}, {"id": "B", "label": "RNA"}, {"id": "C", "label": "Protein"}, {"id": "D", "label": "Lipid"}]}, {"id": 5, "answer": "A", "prompt": "Which of the following is a high-level language?", "options": [{"id": "A", "label": "Python"}, {"id": "B", "label": "Assembly"}, {"id": "C", "label": "Machine language"}, {"id": "D", "label": "Binary"}]}, {"id": 9, "answer": "A", "prompt": "Which acid is present in gastric juice?", "options": [{"id": "A", "label": "Hydrochloric acid"}, {"id": "B", "label": "Sulphuric acid"}, {"id": "C", "label": "Nitric acid"}, {"id": "D", "label": "Acetic acid"}]}, {"id": 11, "answer": "A", "prompt": "Which type of radiation has the highest penetrating power?", "options": [{"id": "A", "label": "Gamma rays"}, {"id": "B", "label": "Alpha particles"}, {"id": "C", "label": "Beta particles"}, {"id": "D", "label": "X-rays"}]}, {"id": 12, "answer": "A", "prompt": "Which gas is produced when zinc reacts with dilute H₂SO₄?", "options": [{"id": "A", "label": "H₂"}, {"id": "B", "label": "O₂"}, {"id": "C", "label": "CO₂"}, {"id": "D", "label": "SO₂"}]}, {"id": 14, "answer": "A", "prompt": "HTML stands for:", "options": [{"id": "A", "label": "HyperText Markup Language"}, {"id": "B", "label": "High Text Markup Language"}, {"id": "C", "label": "HyperText Making Language"}, {"id": "D", "label": "High Transfer Markup Language"}]}, {"id": 15, "answer": "A", "prompt": "Which part of the brain controls balance and coordination?", "options": [{"id": "A", "label": "Cerebellum"}, {"id": "B", "label": "Cerebrum"}, {"id": "C", "label": "Medulla"}, {"id": "D", "label": "Hypothalamus"}]}, {"id": 17, "answer": "A", "prompt": "Blood flows from the heart to the lungs via the:", "options": [{"id": "A", "label": "Pulmonary artery"}, {"id": "B", "label": "Pulmonary vein"}, {"id": "C", "label": "Aorta"}, {"id": "D", "label": "Vena cava"}]}], "long_questions": [{"id": 2, "question": "What is genetics? Explain Mendel's laws of inheritance with examples. Describe a monohybrid cross using a Punnett square."}, {"id": 5, "question": "Describe the human excretory system. Explain how the kidney filters blood and produces urine. Mention the role of the ureter, bladder, and urethra."}, {"id": 7, "question": "Explain the human eye. Describe the defects of vision (myopia, hyperopia) and how they are corrected using lenses."}], "short_questions": [{"id": 2, "question": "What is radioactivity? Name three types of radiation and their properties."}, {"id": 3, "question": "Define oxidation and reduction. Give one example of each."}, {"id": 8, "question": "What is the role of the placenta in human development?"}, {"id": 11, "question": "Define similar triangles. State the conditions for two triangles to be similar."}, {"id": 14, "question": "What is homeostasis? Why is it important for the survival of organisms?"}]}	/api/paper/download/3970eefc-bf1d-43fa-9c6b-f568488e9cef	5	2026-07-20 20:25:47.742+05
\.


--
-- Data for Name: quizzes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quizzes (id, user_id, subject, questions, answers, score, tokens_spent, created_at) FROM stdin;
2fb332eb-974b-46c9-94aa-53b8d415c8f3	1fafa569-03dd-4e95-bfc0-69d3d87835bb	Generate 10 MCQs on Physics, difficulty: medium, class: Year 11, United Kingdom curriculum.	[{"id": 1, "answer": "A", "prompt": "Sample Generate 10 MCQs on Physics, difficulty: medium, class: Year 11, United Kingdom curriculum. question 1", "options": [{"id": "A", "label": "Option A"}, {"id": "B", "label": "Option B"}, {"id": "C", "label": "Option C"}, {"id": "D", "label": "Option D"}]}, {"id": 2, "answer": "B", "prompt": "Sample Generate 10 MCQs on Physics, difficulty: medium, class: Year 11, United Kingdom curriculum. question 2", "options": [{"id": "A", "label": "Option A"}, {"id": "B", "label": "Option B"}, {"id": "C", "label": "Option C"}, {"id": "D", "label": "Option D"}]}]	{}	0.00	5	2026-07-17 13:57:31.084+05
d0cf8b11-83f1-4f4f-9132-42ce6529c5e9	1fafa569-03dd-4e95-bfc0-69d3d87835bb	Urdu	[]	{"1": "C", "2": "C", "3": "B", "4": "B", "5": "B", "10": "C"}	0.00	5	2026-07-20 20:12:20.823+05
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refresh_tokens (id, user_id, token_hash, expires_at, revoked, created_at) FROM stdin;
75276b5c-a944-478a-a6ab-e27040360159	9477dc4f-743d-45d2-b236-6bcc35508be8	96b16b108c23ab97ab18ac0696da3043b6e9e526da4616820b726807521b0e3e	2026-07-21 20:00:23.516+05	f	2026-07-14 20:00:23.519+05
53ee4b75-9ffe-4e81-9da0-dea5c974465d	9477dc4f-743d-45d2-b236-6bcc35508be8	961b5c87dc7c9bfec25d75aedbe0c90ac1bb5932b61e5b4e212d41a608b772a6	2026-07-21 20:28:41.622+05	t	2026-07-14 20:28:41.624+05
12a5ef5e-bab1-4240-be26-167abd3f328b	9477dc4f-743d-45d2-b236-6bcc35508be8	211ef16aaec8387030c927c2b6ce71eff8294484ff733bc6907801598c90bd54	2026-07-21 22:24:25.104+05	t	2026-07-14 22:24:25.106+05
2eccf01e-6800-4033-880a-b923118d74c9	9477dc4f-743d-45d2-b236-6bcc35508be8	402cca97db409cd237e02f4e99f09be0242c633362927476c5cd5371fb1a5363	2026-07-22 11:26:00.299+05	t	2026-07-15 11:26:00.301+05
8b47c805-7b84-4efa-8786-4cbc1edd7b44	9477dc4f-743d-45d2-b236-6bcc35508be8	113fa2175659d57278f9605a2dcb0afb5a4d460aecac08db79011ed1e1f2cff1	2026-07-22 11:30:04.442+05	t	2026-07-15 11:30:04.444+05
d59abe5d-f708-4456-8247-25edbed18f21	9477dc4f-743d-45d2-b236-6bcc35508be8	6522330e62863bdfb380728f64049af7fcb108a8bf1b74f1e20d844c89fe68f9	2026-07-22 12:03:42.219+05	t	2026-07-15 12:03:42.22+05
fe20fd7e-4061-41d9-8eb0-654c0e370166	9477dc4f-743d-45d2-b236-6bcc35508be8	2db369243c6f1e38ae15e72f69ceab95d727b9ae394fef4e441e3026ffda5586	2026-07-22 14:41:53.831+05	t	2026-07-15 14:41:53.834+05
bd797566-1e83-4f7d-ae52-95cb0d0d83f4	9477dc4f-743d-45d2-b236-6bcc35508be8	ca43c04f030884793edc07892b6a78d521f4d90c9c79b0f1e6ef9fcc5fc06e65	2026-07-22 15:21:58.835+05	t	2026-07-15 15:21:58.836+05
d49f1460-adfc-45d7-ab8f-c22a3668c055	9477dc4f-743d-45d2-b236-6bcc35508be8	12727a43e846fc4357acab1fd5d7bd12e9495089206597931469f53c2248a65d	2026-07-22 16:41:17.474+05	t	2026-07-15 16:41:17.476+05
800530f1-619f-4c6e-b4ff-df239a4af258	9477dc4f-743d-45d2-b236-6bcc35508be8	df986e2a50b11bdae7ab60bc1fd7384abee9fcd3af7015e3e06c76bdb4982d3d	2026-07-22 16:44:02.243+05	t	2026-07-15 16:44:02.246+05
eebd97bd-6251-4eb4-b2c8-967ec09763df	9477dc4f-743d-45d2-b236-6bcc35508be8	2129d9fcfa78209ef3937aae6eb9b47490651c4e294a6e839ec19e153a331214	2026-07-22 16:45:33.523+05	t	2026-07-15 16:45:33.524+05
8adcea46-9ed2-4f14-ba75-0c99b13e3aa5	9477dc4f-743d-45d2-b236-6bcc35508be8	0e1bcfe6975a5d2038cdbd291e001e6f6e8630717182f0c532bcc01cd092781e	2026-07-23 15:03:33.834+05	t	2026-07-16 15:03:33.837+05
c9549296-49bc-453d-a2e2-aa9c986dd277	1fafa569-03dd-4e95-bfc0-69d3d87835bb	fcab74cb1c3cfad83dc5f8a9f023dfbc75d6a27fc2721edadbb7a1ce1cee3ff9	2026-07-23 16:05:36.189+05	t	2026-07-16 16:05:36.191+05
1db5acb8-fc81-4a2a-91b1-e5c2b6c3aad3	9477dc4f-743d-45d2-b236-6bcc35508be8	1727bcdeb1db61cf63fb5fcf9e4a791e5fd2356fb96da66d23d35e1060940f17	2026-07-23 22:28:37.192+05	t	2026-07-16 22:28:37.194+05
01dbc454-95ee-4ced-b04a-473fb0d8b5fb	9477dc4f-743d-45d2-b236-6bcc35508be8	816eb4c57dfc70a89582ce002f0830107a84e16b6fcac0a864903cdeec083ac9	2026-07-23 22:44:18.674+05	t	2026-07-16 22:44:18.676+05
42b298c7-7184-4470-a3a4-41d5cc1aed35	1fafa569-03dd-4e95-bfc0-69d3d87835bb	b8b16c8acad31c1d6d62044d1b9d1b5e6cceaad36bf8277dc6035dd5f8675ff8	2026-07-23 22:43:43.937+05	t	2026-07-16 22:43:43.94+05
4f985247-740e-426a-8c6e-308678677c9b	9477dc4f-743d-45d2-b236-6bcc35508be8	7f8f637dffa9dd66e23e19ea47ae91417386393039cbecdb70f1f68bcb3c669b	2026-07-23 23:00:43.277+05	t	2026-07-16 23:00:43.279+05
34cd84ad-8b87-4531-b1c8-15476c8c274d	1fafa569-03dd-4e95-bfc0-69d3d87835bb	d4e5b076d34f299e32f2f2e694fa534ca09304d5edafe68ba5142139eac1f168	2026-07-23 23:37:41.109+05	t	2026-07-16 23:37:41.112+05
6d8c902b-49cb-4380-99d6-edfe5de6c9bc	9477dc4f-743d-45d2-b236-6bcc35508be8	65e8f31f13f95630451e38ef69c8c0d1c31d9e34feee32e7aff4ad1c1a0351bf	2026-07-23 23:37:59.246+05	t	2026-07-16 23:37:59.248+05
3264c235-8170-44e1-869d-b3e824128436	1fafa569-03dd-4e95-bfc0-69d3d87835bb	faea3b075ef667b3ef31122dbc0452f0c414835b1ae33f347ec888ec1e21a876	2026-07-23 23:52:17.896+05	t	2026-07-16 23:52:17.898+05
c4b63d8b-ff50-4ceb-b532-92002c1f3917	1fafa569-03dd-4e95-bfc0-69d3d87835bb	71f9bc8f28223181002549f154eafe0c7b575291ebc86e411a3b5482cd33c1e1	2026-07-24 11:41:43.394+05	t	2026-07-17 11:41:43.397+05
6b1501cf-418b-4130-80aa-7398240e32cf	9477dc4f-743d-45d2-b236-6bcc35508be8	5fcbe16bd7959998ce8a758469e3198b1945eb35463aee1e5961c3fbb3e0dadf	2026-07-24 11:36:46.393+05	t	2026-07-17 11:36:46.396+05
89328972-700c-4ac7-bfdf-f5980c2db35f	1fafa569-03dd-4e95-bfc0-69d3d87835bb	2a49ec3f2175cf3fd636a664d9821972ff124daeb1da2355305e4265756c1d5c	2026-07-24 12:03:02.571+05	t	2026-07-17 12:03:02.573+05
d3f04f08-9d89-4e7e-99fd-963ceb5a8923	9477dc4f-743d-45d2-b236-6bcc35508be8	8ac5a7da92631853c340677d137ae440426cf6cce0c03a279c9a93c06b169896	2026-07-24 13:45:59.513+05	t	2026-07-17 13:45:59.516+05
db23ad4a-5178-4947-8dc7-706ce3e9dab0	1fafa569-03dd-4e95-bfc0-69d3d87835bb	b7593e4d5a593d697b61ecb3df69ca9d6b8ffad9e27d739d90953815a3152d87	2026-07-24 13:57:13.078+05	t	2026-07-17 13:57:13.08+05
0d90bb98-bafd-4639-83c2-170c5341ac27	9477dc4f-743d-45d2-b236-6bcc35508be8	ad5fc8270d366fd1dda74574887d3a58d494512e0b4c9b14f44b0d520aa802c9	2026-07-24 15:34:12.353+05	t	2026-07-17 15:34:12.355+05
a9b41204-7232-4f23-853a-f0c6a936a148	9477dc4f-743d-45d2-b236-6bcc35508be8	6a7e79939ea68cf462638573437c2b96eabeea49f741cc779b4724c6c6418933	2026-07-25 17:26:48.112+05	f	2026-07-18 17:26:48.116+05
1c809577-0fd1-4de5-a605-dfdf263387ce	463035c3-cb7a-49fc-9d27-b707d33c20bb	3d6a3116657f01c13284ab2354e4002b03382695b87f201bdace3c5ca79fa8e9	2026-07-25 17:28:09.594+05	t	2026-07-18 17:28:09.596+05
caec86d2-91cc-4db7-8fae-b2efe0ed2b05	1fafa569-03dd-4e95-bfc0-69d3d87835bb	a446feddd5575d27fd90fa5062e3fd04ec4408103f72fda481300d299f94a142	2026-07-24 15:34:20.821+05	t	2026-07-17 15:34:20.823+05
479a1b33-6664-44a3-86ef-10402d0221a0	1fafa569-03dd-4e95-bfc0-69d3d87835bb	b93fc852d06a7fcb8926cb399b04029245abe3409e86e1c791b9e1c87d4adcf0	2026-07-25 17:59:37.388+05	t	2026-07-18 17:59:37.39+05
079a8d6d-8716-4658-8a8c-b33e86d9a3de	1fafa569-03dd-4e95-bfc0-69d3d87835bb	a75420e8742ac5bbf9b2219107e2274ed8b427fcbdf6d20f0a10bce40f946d51	2026-07-25 18:03:18.613+05	t	2026-07-18 18:03:18.616+05
130b3fd9-4491-4f80-8d85-1a3018ff4506	463035c3-cb7a-49fc-9d27-b707d33c20bb	249209ca13c798e4e26378f5a257783430d85f136ed8a9e625d6bb10a0fd1970	2026-07-25 17:59:05.038+05	t	2026-07-18 17:59:05.04+05
7fccf9c8-9122-4ef0-a187-825943bcbc9c	1fafa569-03dd-4e95-bfc0-69d3d87835bb	741c6e95e511a1fd4d97d833dd04c3b8840acea7f59e22842f10fa4f39a10c5e	2026-07-26 11:57:53.034+05	t	2026-07-19 11:57:53.037+05
63bce06e-364a-456a-b943-1557d6c6cdb2	463035c3-cb7a-49fc-9d27-b707d33c20bb	ce3ddc72db7002edf249dc35bddcdb139007cd9e38ab354d3bdce957f08cf616	2026-07-27 16:28:54.083+05	t	2026-07-20 16:28:54.085+05
c44786d2-7e5b-4cab-b6d3-cec0b688bd4d	1fafa569-03dd-4e95-bfc0-69d3d87835bb	0dcde0097b733fdd031d3091a8f4addd2c8cc81b266c3ebc7cde824ed9a906ba	2026-07-27 16:29:14.639+05	t	2026-07-20 16:29:14.641+05
8c8aed3a-6a79-46cf-b26c-fb2276808e96	1fafa569-03dd-4e95-bfc0-69d3d87835bb	d87fb1cfd98efeacd5bb3ad58c0afc961e639b5f84005d3afbd083a59bf4ca6c	2026-07-27 17:06:59.316+05	t	2026-07-20 17:06:59.319+05
01751c8b-fcf6-448b-912d-a445a0fc7a49	1fafa569-03dd-4e95-bfc0-69d3d87835bb	67738d6356f2697df2ede16ed1bb8e63686185e659419616289e0283deac6b9d	2026-07-27 17:24:23.647+05	t	2026-07-20 17:24:23.65+05
282d9423-879e-4efa-b41e-ab2452a4c5e7	1fafa569-03dd-4e95-bfc0-69d3d87835bb	2b125942b9e994efc1c31cf6018347e9afbb051b117f635a1e0ced68b0739d4c	2026-07-27 17:44:44.656+05	t	2026-07-20 17:44:44.659+05
1a2867be-0c9f-477f-85bf-55817dc7b972	9477dc4f-743d-45d2-b236-6bcc35508be8	e494dda83c5f703195e231aaa415f6f6c37bc8efa41209ecf80577972c3cbb18	2026-07-27 16:43:21.813+05	t	2026-07-20 16:43:21.815+05
dba37e28-488b-459e-981b-ab3cfefd738b	1fafa569-03dd-4e95-bfc0-69d3d87835bb	9f76950deee08f981c12f1246ab1f8018c9cd6ee1e31df85f3c5c68065486534	2026-07-27 18:01:10.877+05	t	2026-07-20 18:01:10.879+05
add47a16-574e-4598-9d9f-fbe041b25e2f	9477dc4f-743d-45d2-b236-6bcc35508be8	bb97015a2a8607e4eacd1bc5f4318f66dde7d1c688adb13bd3f78342ad1aa71e	2026-07-27 18:02:05.399+05	t	2026-07-20 18:02:05.4+05
7e4c5ffd-57d6-40ab-b7b5-c960c66deea7	1fafa569-03dd-4e95-bfc0-69d3d87835bb	61d595ac06fa89e06d6a0c0abb7c0d42816223048e9a6709a5fef1d9f7587638	2026-07-27 18:16:16.922+05	t	2026-07-20 18:16:16.923+05
9e565f87-669b-4603-a44e-59207eb3d9a6	1fafa569-03dd-4e95-bfc0-69d3d87835bb	7ced6b6aab47f02de3064df32727cf4be595753fa64e2638f88c3280b8fd3f9c	2026-07-27 18:31:19.953+05	t	2026-07-20 18:31:19.955+05
6a601ea9-a5a8-4cc1-80a1-43b4147b83a8	1fafa569-03dd-4e95-bfc0-69d3d87835bb	ef2dc587ea03aa83d7b0958475547886e213412c70f7d2628e468b482c64424d	2026-07-27 18:46:38.808+05	t	2026-07-20 18:46:38.81+05
d14d3a0b-61e3-4191-baa8-0b7486387d4e	1fafa569-03dd-4e95-bfc0-69d3d87835bb	8dd02f25d8b308937ab07520d71ec5c28c0dcb78029ce2ae431cebdb6e343a1f	2026-07-27 18:56:08.118+05	t	2026-07-20 18:56:08.119+05
aa496a9f-3cf1-4e91-b30b-cf3a0050f5f4	9477dc4f-743d-45d2-b236-6bcc35508be8	eb0be65d3f080df2df02295648641c25ee52bddea9f41e267b42f96ce3d540f3	2026-07-27 18:17:05.491+05	t	2026-07-20 18:17:05.493+05
4cb3b2f4-b9a6-40a8-8630-9296a10c63ed	1fafa569-03dd-4e95-bfc0-69d3d87835bb	52ccf072bd75c7b592aaee0866f85524fdfd90e1b349628d1a2f96e1ff8c8aac	2026-07-27 19:57:54.74+05	t	2026-07-20 19:57:54.742+05
0d24d3d4-6e5c-45f5-aafd-ece5df148eb5	9477dc4f-743d-45d2-b236-6bcc35508be8	e6fe2aeae67c01348e8cb9d14e060dfd95bb4b71cafd393b25d0f38ea555c52a	2026-07-27 20:03:52.73+05	t	2026-07-20 20:03:52.732+05
fac6844c-ebf6-431a-ab2b-ecb80d6999a8	9477dc4f-743d-45d2-b236-6bcc35508be8	1985bbeb8b644a211041fdddc8546e088206ea8d77418d3d85fff758699eaa1a	2026-07-27 20:23:43.198+05	t	2026-07-20 20:23:43.2+05
89cba443-56be-4453-b607-8d8dc5d6d7b9	1fafa569-03dd-4e95-bfc0-69d3d87835bb	cb120fdfc866725b49f6c1271c6d4d7b347c22791ea6ffc2d77a9531d3d5716f	2026-07-27 20:13:11.459+05	t	2026-07-20 20:13:11.46+05
2fa859b5-d4a8-4c48-85e0-87f38390acf7	9477dc4f-743d-45d2-b236-6bcc35508be8	7f89c118027200808d24b724e8f4315058fc8021f70b53fc3883158492e0d6da	2026-07-27 21:14:52.005+05	t	2026-07-20 21:14:52.008+05
5128cd11-a65e-4bb2-b685-ab2cd6384331	1fafa569-03dd-4e95-bfc0-69d3d87835bb	0db327bfc5238b0b6d8bedd5e74c5f8ccc6b46f72f5e22399dad5a32043eaa52	2026-07-27 21:15:23.177+05	t	2026-07-20 21:15:23.179+05
a3828869-0417-4f84-a93b-263d68f85113	9477dc4f-743d-45d2-b236-6bcc35508be8	04e3399970ceaa3455d6e222e46ff409e9e7367b427a37c1f51443ca106174d3	2026-07-27 21:30:02.277+05	t	2026-07-20 21:30:02.278+05
da45a812-10fb-43b4-aa1d-1a6ee5b7ffc9	9477dc4f-743d-45d2-b236-6bcc35508be8	5fe2f8d7c0cded6cb016766708cbad7e2e49bbcece1a05d31229db2b2aa30787	2026-07-27 21:54:04.023+05	f	2026-07-20 21:54:04.025+05
07cf30c4-dfc2-4714-96bb-d7932747c8f6	1fafa569-03dd-4e95-bfc0-69d3d87835bb	ff5d31a7d0e04ab2c17766a773e87f3131c2b9b8f9ef6aec8f983cb684f38eb3	2026-07-27 21:30:51.691+05	t	2026-07-20 21:30:51.693+05
e1a41e5d-0192-4efb-9766-8b7b58071e9f	1fafa569-03dd-4e95-bfc0-69d3d87835bb	286dcace119a83d3f07131c85a4a1aa20a3149b87a63b0728ef09476c6fd7890	2026-07-27 21:54:27.609+05	f	2026-07-20 21:54:27.61+05
\.


--
-- Data for Name: token_transfers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.token_transfers (id, sender_user_id, recipient_user_id, amount, transaction_id, created_at) FROM stdin;
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (id, from_user_id, to_user_id, amount, tx_type, reference_id, note, created_at) FROM stdin;
1033c724-d8f9-4bbb-8dcd-1c48cde2a4c6	\N	9477dc4f-743d-45d2-b236-6bcc35508be8	20	signup_bonus	\N	On-chain mint tx: 26jm687764x8auRY4UNbRZHrSCqSyypBkZYsYr29gmBsFr91hJgQjAxvL1Ti7NEiea7kHRK3Du4Kwr6sZqU8xtgW	2026-07-14 20:00:23.472+05
f09499ed-889c-44f0-8610-5cd52bff644b	9477dc4f-743d-45d2-b236-6bcc35508be8	\N	5	paper_spend	\N	On-chain burn tx: 2ikcb3iZ7bep5uwDZz1ckWfQ5EPJrCUrrhNMMk7bzh44N96gvPrq63r4KtMzzsxct7KUoEFj15spBeBdzHxQ3T4J	2026-07-14 20:31:23.72+05
8ff67835-e4a7-4f75-82b8-9d4d5c01fad7	9477dc4f-743d-45d2-b236-6bcc35508be8	\N	2	unverified_paper_spend	\N	On-chain burn tx: 598K6awozzzcufwy7xv3NZYQcMxxAGaRqvmdF2QFz6wqTxL7PYFgA8XiWcfrsz7rSHM8jXCU7eanJYwt978jVzrJ	2026-07-15 14:44:24.518+05
5ea10ce5-0231-440f-8a0c-de4d91e95666	\N	1fafa569-03dd-4e95-bfc0-69d3d87835bb	20	signup_bonus	\N	On-chain mint tx: 3RTaMhmVuTVWYzxpijCyqh4yG9GFtwYdjbpEK8d8w3jGcTkBYqh7totFW3eA7tbLTvnw5Jx2crf6KyCwf85v3KWG	2026-07-16 16:05:36.176+05
384b2bac-ecaf-4267-aaf5-c5c92cf88e48	1fafa569-03dd-4e95-bfc0-69d3d87835bb	\N	5	quiz_spend	2fb332eb-974b-46c9-94aa-53b8d415c8f3	Verified quiz generation (5 COIN)	2026-07-17 13:57:31.108+05
29686f11-df14-40ca-a6c6-493d8447e23d	1fafa569-03dd-4e95-bfc0-69d3d87835bb	\N	5	paper_spend	124fcc7a-395c-4278-a726-51a63ef46fe3	Verified paper generation (5 COIN)	2026-07-20 16:29:56.761+05
af29a61e-f10a-470d-9a47-c75606543e1e	1fafa569-03dd-4e95-bfc0-69d3d87835bb	\N	5	paper_spend	eb93a944-ff3a-4843-b2ac-84a0c36d903c	Verified paper generation (5 COIN)	2026-07-20 16:31:53.243+05
83098a9e-7056-484f-9f03-ca18aea8fe7c	1fafa569-03dd-4e95-bfc0-69d3d87835bb	\N	2	unverified_paper_spend	\N	On-chain burn tx: MwronfMR2iuEib9HJSd8JHSkDDiSQCDZxcWZ4kmP9Epfmmt1QnAC8BQruCz5WDkA6YfyQJtjSyny9cRp9PdKZ1u	2026-07-20 16:35:31.161+05
6e2d2dc5-cbb3-4c72-b4ec-445656d78c37	1fafa569-03dd-4e95-bfc0-69d3d87835bb	\N	5	paper_spend	\N	On-chain burn tx: 4HM68ZF6wsL7gSFwqtMnGoKyfAFwjNH32Vm5o2pyeuKQypQGfL5qYN2rBskPLCkgxeqoaHkgT2ZHaL5KPLE8eGSc	2026-07-20 18:05:01.93+05
64be6d2f-60a2-4f8a-aa0c-f85d5a0a3184	\N	1fafa569-03dd-4e95-bfc0-69d3d87835bb	100	buy	\N	PayPal placeholder + on-chain mint tx: 3APqg2Ktf8jhGipL5dWaSNrARzwdhY8fCiwcSQ3kAMQ8Vbnyad4vTFmdEBSmWt2dturueHTaZmYFxqsz35stDph8	2026-07-20 18:09:29.187+05
b574d84d-db75-479d-88b9-a97066e29afb	1fafa569-03dd-4e95-bfc0-69d3d87835bb	\N	2	unverified_paper_spend	\N	On-chain burn tx: 2BpXA84uPdqTGgMsLUKetqxZSGtWXqwfKyHMcWKCScfwU5TbyLig74wKv9zo5Au43KJR8VcxK87ybyDXKUNVzuKY	2026-07-20 20:11:11.827+05
d37c8911-433b-4433-a918-f3fae120f045	1fafa569-03dd-4e95-bfc0-69d3d87835bb	\N	5	quiz_spend	\N	On-chain burn tx: 24LJyuKUAySGYu3bSsQU5jT2ULnXkGRwrg2XXYfDNasmguTsPC4Fc6rTB7nv364FRJTrmKxHetNYQxM9Ds2J3eZP	2026-07-20 20:12:20.797+05
706dd9b2-cece-4338-8aef-c22f2661357e	1fafa569-03dd-4e95-bfc0-69d3d87835bb	\N	5	paper_spend	\N	On-chain burn tx: 2oFfi4KYAKevchfaVw47p9q79gGcMRTktyzAhEZ5Use8DXCJpnEkg43T77uG5dbxHtzAxxhgXWpDiSu8jS2j4gaS	2026-07-20 20:25:31.591+05
\.


--
-- Data for Name: uploads; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.uploads (id, user_id, filename, storage_path, status, ai_score, reward_tokens, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, wallet_address, email, signup_bonus_granted, created_at, updated_at, role, password_hash, username) FROM stdin;
9477dc4f-743d-45d2-b236-6bcc35508be8	6Ekw4oHaAjSuLM9udwq6RjBA8RXKbRa7DY5gvBNZ9KLB	\N	t	2026-07-14 20:00:20.058+05	2026-07-14 20:00:23.464+05	admin	\N	\N
1fafa569-03dd-4e95-bfc0-69d3d87835bb	C8TMPYmJ8CigUzKWAebGCd2rxHWAskQgA4a8JBuWHjZm	\N	t	2026-07-16 16:05:33.129+05	2026-07-16 16:05:36.172+05	student	\N	\N
463035c3-cb7a-49fc-9d27-b707d33c20bb	\N	\N	t	2026-07-18 17:27:19.458+05	2026-07-18 17:27:19.458+05	content_moderator	$2a$12$OQrQWCdG0GE3nRJTe6/YrO18NC.8VPL6./HY374PWNeIVhvSO/wfi	Ali Hamza
\.


--
-- Name: balances balances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.balances
    ADD CONSTRAINT balances_pkey PRIMARY KEY (user_id);


--
-- Name: papers papers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.papers
    ADD CONSTRAINT papers_pkey PRIMARY KEY (id);


--
-- Name: quizzes quizzes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT quizzes_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: token_transfers token_transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_transfers
    ADD CONSTRAINT token_transfers_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: uploads uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uploads
    ADD CONSTRAINT uploads_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: papers_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX papers_user_id_created_at_idx ON public.papers USING btree (user_id, created_at DESC);


--
-- Name: quizzes_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX quizzes_user_id_created_at_idx ON public.quizzes USING btree (user_id, created_at DESC);


--
-- Name: refresh_tokens_token_hash_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX refresh_tokens_token_hash_idx ON public.refresh_tokens USING btree (token_hash);


--
-- Name: refresh_tokens_token_hash_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX refresh_tokens_token_hash_key ON public.refresh_tokens USING btree (token_hash);


--
-- Name: refresh_tokens_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX refresh_tokens_user_id_idx ON public.refresh_tokens USING btree (user_id);


--
-- Name: token_transfers_recipient_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX token_transfers_recipient_user_id_created_at_idx ON public.token_transfers USING btree (recipient_user_id, created_at DESC);


--
-- Name: token_transfers_sender_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX token_transfers_sender_user_id_created_at_idx ON public.token_transfers USING btree (sender_user_id, created_at DESC);


--
-- Name: transactions_from_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX transactions_from_user_id_created_at_idx ON public.transactions USING btree (from_user_id, created_at DESC);


--
-- Name: transactions_to_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX transactions_to_user_id_created_at_idx ON public.transactions USING btree (to_user_id, created_at DESC);


--
-- Name: uploads_user_id_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX uploads_user_id_created_at_idx ON public.uploads USING btree (user_id, created_at DESC);


--
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- Name: users_username_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_username_key ON public.users USING btree (username);


--
-- Name: users_wallet_address_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_wallet_address_key ON public.users USING btree (wallet_address);


--
-- Name: balances balances_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.balances
    ADD CONSTRAINT balances_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: papers papers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.papers
    ADD CONSTRAINT papers_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: quizzes quizzes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT quizzes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: token_transfers token_transfers_recipient_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_transfers
    ADD CONSTRAINT token_transfers_recipient_user_id_fkey FOREIGN KEY (recipient_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: token_transfers token_transfers_sender_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_transfers
    ADD CONSTRAINT token_transfers_sender_user_id_fkey FOREIGN KEY (sender_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: token_transfers token_transfers_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_transfers
    ADD CONSTRAINT token_transfers_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.transactions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: transactions transactions_from_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_from_user_id_fkey FOREIGN KEY (from_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: transactions transactions_to_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_to_user_id_fkey FOREIGN KEY (to_user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: uploads uploads_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uploads
    ADD CONSTRAINT uploads_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict e8PFRpldnOXNhTb4APldxiBP2oozDDaDyiB0bfk2EdXlIol0HrrwMs0WybldSQb

