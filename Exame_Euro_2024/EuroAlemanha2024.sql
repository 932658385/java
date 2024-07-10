--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.3

-- Started on 2024-06-29 03:43:15

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
-- TOC entry 258 (class 1255 OID 57902)
-- Name: atualizaclassificacao(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.atualizaclassificacao(jogo_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    equipe1 INT;
    equipe2 INT;
    gols_equipe1 INT;
    gols_equipe2 INT;
BEGIN
    -- Obter detalhes do jogo
    SELECT j.equipe1_id, j.equipe2_id, j.gols_equipe1, j.gols_equipe2
    INTO equipe1, equipe2, gols_equipe1, gols_equipe2
    FROM Jogos j
    WHERE j.id = jogo_id;

    -- Atualizar estatísticas da equipe 1
    UPDATE Classificacoes
    SET 
        jogos = jogos + 1,
        gols_pro = gols_pro + gols_equipe1,
        gols_contra = gols_contra + gols_equipe2,
        saldo_gols = saldo_gols + (gols_equipe1 - gols_equipe2)
    WHERE selecao_id = equipe1;

    -- Atualizar estatísticas da equipe 2
    UPDATE Classificacoes
    SET 
        jogos = jogos + 1,
        gols_pro = gols_pro + gols_equipe2,
        gols_contra = gols_contra + gols_equipe1,
        saldo_gols = saldo_gols + (gols_equipe2 - gols_equipe1)
    WHERE selecao_id = equipe2;

    -- Atualizar pontos e resultados
    IF gols_equipe1 > gols_equipe2 THEN
        UPDATE Classificacoes 
        SET vitorias = vitorias + 1, pontos = pontos + 3 
        WHERE selecao_id = equipe1;
        
        UPDATE Classificacoes 
        SET derrotas = derrotas + 1 
        WHERE selecao_id = equipe2;
    ELSIF gols_equipe1 < gols_equipe2 THEN
        UPDATE Classificacoes 
        SET vitorias = vitorias + 1, pontos = pontos + 3 
        WHERE selecao_id = equipe2;
        
        UPDATE Classificacoes 
        SET derrotas = derrotas + 1 
        WHERE selecao_id = equipe1;
    ELSE
        UPDATE Classificacoes 
        SET empates = empates + 1, pontos = pontos + 1 
        WHERE selecao_id = equipe1;
        
        UPDATE Classificacoes 
        SET empates = empates + 1, pontos = pontos + 1 
        WHERE selecao_id = equipe2;
    END IF;
END;
$$;


ALTER FUNCTION public.atualizaclassificacao(jogo_id integer) OWNER TO postgres;

--
-- TOC entry 257 (class 1255 OID 57903)
-- Name: atualizaclassificacaotrigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.atualizaclassificacaotrigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM AtualizaClassificacao(NEW.id);
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.atualizaclassificacaotrigger() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 227 (class 1259 OID 57719)
-- Name: calendario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.calendario (
    id integer NOT NULL,
    data date NOT NULL,
    grupo_id integer,
    estadio_id integer,
    jornada integer
);


ALTER TABLE public.calendario OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 57718)
-- Name: calendario_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.calendario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calendario_id_seq OWNER TO postgres;

--
-- TOC entry 3513 (class 0 OID 0)
-- Dependencies: 226
-- Name: calendario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.calendario_id_seq OWNED BY public.calendario.id;


--
-- TOC entry 237 (class 1259 OID 57815)
-- Name: cartoes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cartoes (
    id integer NOT NULL,
    jogo_id integer,
    jogador_id integer,
    minuto integer,
    tipo character varying(50)
);


ALTER TABLE public.cartoes OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 57814)
-- Name: cartoes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cartoes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cartoes_id_seq OWNER TO postgres;

--
-- TOC entry 3514 (class 0 OID 0)
-- Dependencies: 236
-- Name: cartoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cartoes_id_seq OWNED BY public.cartoes.id;


--
-- TOC entry 217 (class 1259 OID 57664)
-- Name: cidades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cidades (
    id integer NOT NULL,
    nome character varying(100) NOT NULL,
    pais_id integer
);


ALTER TABLE public.cidades OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 57663)
-- Name: cidades_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cidades_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cidades_id_seq OWNER TO postgres;

--
-- TOC entry 3515 (class 0 OID 0)
-- Dependencies: 216
-- Name: cidades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cidades_id_seq OWNED BY public.cidades.id;


--
-- TOC entry 243 (class 1259 OID 57866)
-- Name: classificacoes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classificacoes (
    id integer NOT NULL,
    grupo_id integer,
    selecao_id integer,
    pontos integer DEFAULT 0,
    jogos integer DEFAULT 0,
    vitorias integer DEFAULT 0,
    empates integer DEFAULT 0,
    derrotas integer DEFAULT 0,
    gols_pro integer DEFAULT 0,
    gols_contra integer DEFAULT 0,
    saldo_gols integer DEFAULT 0
);


ALTER TABLE public.classificacoes OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 57865)
-- Name: classificacoes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.classificacoes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.classificacoes_id_seq OWNER TO postgres;

--
-- TOC entry 3516 (class 0 OID 0)
-- Dependencies: 242
-- Name: classificacoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.classificacoes_id_seq OWNED BY public.classificacoes.id;


--
-- TOC entry 231 (class 1259 OID 57759)
-- Name: equipes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.equipes (
    id integer NOT NULL,
    jogo_id integer,
    selecao_id integer
);


ALTER TABLE public.equipes OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 57758)
-- Name: equipes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.equipes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.equipes_id_seq OWNER TO postgres;

--
-- TOC entry 3517 (class 0 OID 0)
-- Dependencies: 230
-- Name: equipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.equipes_id_seq OWNED BY public.equipes.id;


--
-- TOC entry 219 (class 1259 OID 57676)
-- Name: estadios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estadios (
    id integer NOT NULL,
    nome character varying(100) NOT NULL,
    cidade_id integer,
    capacidade integer
);


ALTER TABLE public.estadios OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 57675)
-- Name: estadios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.estadios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.estadios_id_seq OWNER TO postgres;

--
-- TOC entry 3518 (class 0 OID 0)
-- Dependencies: 218
-- Name: estadios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.estadios_id_seq OWNED BY public.estadios.id;


--
-- TOC entry 239 (class 1259 OID 57832)
-- Name: estatisticas_equipe; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estatisticas_equipe (
    id integer NOT NULL,
    jogo_id integer,
    selecao_id integer,
    remates integer,
    livres integer,
    foras_de_jogo integer
);


ALTER TABLE public.estatisticas_equipe OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 57831)
-- Name: estatisticas_equipe_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.estatisticas_equipe_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.estatisticas_equipe_id_seq OWNER TO postgres;

--
-- TOC entry 3519 (class 0 OID 0)
-- Dependencies: 238
-- Name: estatisticas_equipe_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.estatisticas_equipe_id_seq OWNED BY public.estatisticas_equipe.id;


--
-- TOC entry 241 (class 1259 OID 57849)
-- Name: estatisticas_jogador; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estatisticas_jogador (
    id integer NOT NULL,
    jogo_id integer,
    jogador_id integer,
    passes integer,
    assistencias integer,
    remates integer,
    minutos_jogados integer
);


ALTER TABLE public.estatisticas_jogador OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 57848)
-- Name: estatisticas_jogador_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.estatisticas_jogador_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.estatisticas_jogador_id_seq OWNER TO postgres;

--
-- TOC entry 3520 (class 0 OID 0)
-- Dependencies: 240
-- Name: estatisticas_jogador_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.estatisticas_jogador_id_seq OWNED BY public.estatisticas_jogador.id;


--
-- TOC entry 245 (class 1259 OID 57891)
-- Name: fases_eliminatorias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fases_eliminatorias (
    id integer NOT NULL,
    fase character varying(20),
    jogo_id integer
);


ALTER TABLE public.fases_eliminatorias OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 57890)
-- Name: fases_eliminatorias_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fases_eliminatorias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fases_eliminatorias_id_seq OWNER TO postgres;

--
-- TOC entry 3521 (class 0 OID 0)
-- Dependencies: 244
-- Name: fases_eliminatorias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fases_eliminatorias_id_seq OWNED BY public.fases_eliminatorias.id;


--
-- TOC entry 235 (class 1259 OID 57798)
-- Name: gols; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gols (
    id integer NOT NULL,
    jogo_id integer,
    jogador_id integer,
    minuto integer,
    tipo character varying(50)
);


ALTER TABLE public.gols OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 57797)
-- Name: gols_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gols_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gols_id_seq OWNER TO postgres;

--
-- TOC entry 3522 (class 0 OID 0)
-- Dependencies: 234
-- Name: gols_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gols_id_seq OWNED BY public.gols.id;


--
-- TOC entry 225 (class 1259 OID 57712)
-- Name: grupos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grupos (
    id integer NOT NULL,
    nome character varying(2) NOT NULL,
    selecao_id integer
);


ALTER TABLE public.grupos OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 57711)
-- Name: grupos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grupos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grupos_id_seq OWNER TO postgres;

--
-- TOC entry 3523 (class 0 OID 0)
-- Dependencies: 224
-- Name: grupos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grupos_id_seq OWNED BY public.grupos.id;


--
-- TOC entry 223 (class 1259 OID 57700)
-- Name: jogadores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jogadores (
    id integer NOT NULL,
    nome character varying(100) NOT NULL,
    posicao character varying(50),
    selecao_id integer
);


ALTER TABLE public.jogadores OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 57699)
-- Name: jogadores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jogadores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.jogadores_id_seq OWNER TO postgres;

--
-- TOC entry 3524 (class 0 OID 0)
-- Dependencies: 222
-- Name: jogadores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jogadores_id_seq OWNED BY public.jogadores.id;


--
-- TOC entry 229 (class 1259 OID 57736)
-- Name: jogos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jogos (
    id integer NOT NULL,
    calendario_id integer,
    equipe1_id integer,
    equipe2_id integer,
    gols_equipe1 integer,
    gols_equipe2 integer,
    fase character varying(20) DEFAULT 'Grupo'::character varying
);


ALTER TABLE public.jogos OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 57735)
-- Name: jogos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jogos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.jogos_id_seq OWNER TO postgres;

--
-- TOC entry 3525 (class 0 OID 0)
-- Dependencies: 228
-- Name: jogos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jogos_id_seq OWNED BY public.jogos.id;


--
-- TOC entry 215 (class 1259 OID 57657)
-- Name: paises; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paises (
    id integer NOT NULL,
    nome character varying(100) NOT NULL
);


ALTER TABLE public.paises OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 57656)
-- Name: paises_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.paises_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.paises_id_seq OWNER TO postgres;

--
-- TOC entry 3526 (class 0 OID 0)
-- Dependencies: 214
-- Name: paises_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.paises_id_seq OWNED BY public.paises.id;


--
-- TOC entry 221 (class 1259 OID 57688)
-- Name: selecoes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.selecoes (
    id integer NOT NULL,
    nome character varying(100) NOT NULL,
    pais_id integer
);


ALTER TABLE public.selecoes OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 57687)
-- Name: selecoes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.selecoes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.selecoes_id_seq OWNER TO postgres;

--
-- TOC entry 3527 (class 0 OID 0)
-- Dependencies: 220
-- Name: selecoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.selecoes_id_seq OWNED BY public.selecoes.id;


--
-- TOC entry 233 (class 1259 OID 57776)
-- Name: substituicoes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.substituicoes (
    id integer NOT NULL,
    jogo_id integer,
    jogador_saiu_id integer,
    jogador_entrou_id integer,
    minuto integer
);


ALTER TABLE public.substituicoes OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 57775)
-- Name: substituicoes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.substituicoes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.substituicoes_id_seq OWNER TO postgres;

--
-- TOC entry 3528 (class 0 OID 0)
-- Dependencies: 232
-- Name: substituicoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.substituicoes_id_seq OWNED BY public.substituicoes.id;


--
-- TOC entry 3256 (class 2604 OID 57722)
-- Name: calendario id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calendario ALTER COLUMN id SET DEFAULT nextval('public.calendario_id_seq'::regclass);


--
-- TOC entry 3262 (class 2604 OID 57818)
-- Name: cartoes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cartoes ALTER COLUMN id SET DEFAULT nextval('public.cartoes_id_seq'::regclass);


--
-- TOC entry 3251 (class 2604 OID 57667)
-- Name: cidades id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cidades ALTER COLUMN id SET DEFAULT nextval('public.cidades_id_seq'::regclass);


--
-- TOC entry 3265 (class 2604 OID 57869)
-- Name: classificacoes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classificacoes ALTER COLUMN id SET DEFAULT nextval('public.classificacoes_id_seq'::regclass);


--
-- TOC entry 3259 (class 2604 OID 57762)
-- Name: equipes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipes ALTER COLUMN id SET DEFAULT nextval('public.equipes_id_seq'::regclass);


--
-- TOC entry 3252 (class 2604 OID 57679)
-- Name: estadios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estadios ALTER COLUMN id SET DEFAULT nextval('public.estadios_id_seq'::regclass);


--
-- TOC entry 3263 (class 2604 OID 57835)
-- Name: estatisticas_equipe id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estatisticas_equipe ALTER COLUMN id SET DEFAULT nextval('public.estatisticas_equipe_id_seq'::regclass);


--
-- TOC entry 3264 (class 2604 OID 57852)
-- Name: estatisticas_jogador id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estatisticas_jogador ALTER COLUMN id SET DEFAULT nextval('public.estatisticas_jogador_id_seq'::regclass);


--
-- TOC entry 3274 (class 2604 OID 57894)
-- Name: fases_eliminatorias id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fases_eliminatorias ALTER COLUMN id SET DEFAULT nextval('public.fases_eliminatorias_id_seq'::regclass);


--
-- TOC entry 3261 (class 2604 OID 57801)
-- Name: gols id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gols ALTER COLUMN id SET DEFAULT nextval('public.gols_id_seq'::regclass);


--
-- TOC entry 3255 (class 2604 OID 57715)
-- Name: grupos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grupos ALTER COLUMN id SET DEFAULT nextval('public.grupos_id_seq'::regclass);


--
-- TOC entry 3254 (class 2604 OID 57703)
-- Name: jogadores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jogadores ALTER COLUMN id SET DEFAULT nextval('public.jogadores_id_seq'::regclass);


--
-- TOC entry 3257 (class 2604 OID 57739)
-- Name: jogos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jogos ALTER COLUMN id SET DEFAULT nextval('public.jogos_id_seq'::regclass);


--
-- TOC entry 3250 (class 2604 OID 57660)
-- Name: paises id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paises ALTER COLUMN id SET DEFAULT nextval('public.paises_id_seq'::regclass);


--
-- TOC entry 3253 (class 2604 OID 57691)
-- Name: selecoes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.selecoes ALTER COLUMN id SET DEFAULT nextval('public.selecoes_id_seq'::regclass);


--
-- TOC entry 3260 (class 2604 OID 57779)
-- Name: substituicoes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.substituicoes ALTER COLUMN id SET DEFAULT nextval('public.substituicoes_id_seq'::regclass);


--
-- TOC entry 3489 (class 0 OID 57719)
-- Dependencies: 227
-- Data for Name: calendario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.calendario (id, data, grupo_id, estadio_id, jornada) FROM stdin;
5	2024-06-22	5	9	1
6	2024-06-23	6	10	1
7	2024-06-25	7	11	1
8	2024-06-26	8	12	1
\.


--
-- TOC entry 3499 (class 0 OID 57815)
-- Dependencies: 237
-- Data for Name: cartoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cartoes (id, jogo_id, jogador_id, minuto, tipo) FROM stdin;
33249	812	164	32	Amarelo
33250	812	167	12	Amarelo
33251	812	168	5	Amarelo
33252	812	169	2	Amarelo
33253	812	170	66	Amarelo
33254	812	171	77	Amarelo
33255	812	172	85	Amarelo
33256	812	173	14	Amarelo
33257	812	174	52	Amarelo
33258	812	175	3	Amarelo
33259	812	177	86	Amarelo
33260	812	178	73	Amarelo
33261	812	179	53	Amarelo
33262	812	180	31	Amarelo
33263	812	182	27	Amarelo
33264	812	184	52	Amarelo
33265	812	1	83	Amarelo
33266	812	2	70	Amarelo
33267	812	5	3	Amarelo
33268	812	8	77	Amarelo
33269	812	10	30	Amarelo
33270	812	185	56	Amarelo
33271	812	186	27	Amarelo
33272	812	187	17	Amarelo
33273	812	190	32	Amarelo
33274	812	191	44	Amarelo
33275	812	193	13	Amarelo
33276	812	197	23	Amarelo
33277	812	201	36	Amarelo
33278	812	202	9	Amarelo
33279	812	204	81	Amarelo
33280	812	207	22	Amarelo
1587	\N	\N	\N	
33281	813	164	29	Amarelo
33282	813	166	2	Amarelo
33283	813	168	3	Amarelo
33284	813	170	12	Amarelo
33285	813	172	77	Amarelo
33286	813	175	33	Amarelo
33287	813	176	38	Amarelo
33288	813	177	42	Amarelo
33289	813	178	70	Amarelo
33290	813	179	5	Amarelo
33291	813	180	49	Amarelo
33292	813	181	7	Amarelo
33293	813	182	65	Amarelo
33294	813	183	51	Amarelo
33295	813	1	88	Amarelo
33296	813	2	32	Amarelo
33297	813	4	1	Amarelo
33298	813	6	32	Amarelo
33299	813	8	7	Amarelo
33300	813	9	4	Amarelo
33301	813	10	17	Amarelo
33302	813	213	80	Amarelo
33303	813	216	63	Amarelo
33304	813	218	72	Amarelo
33305	813	219	14	Amarelo
33306	813	220	42	Amarelo
33307	813	223	22	Amarelo
33308	813	225	26	Amarelo
33309	813	230	26	Amarelo
33310	814	162	4	Amarelo
33311	814	166	84	Amarelo
33312	814	167	7	Amarelo
33313	814	171	2	Amarelo
33314	814	174	19	Amarelo
33315	814	176	8	Amarelo
33316	814	178	2	Amarelo
33317	814	179	17	Amarelo
33318	814	180	84	Amarelo
33319	814	182	81	Amarelo
33320	814	3	19	Amarelo
33321	814	5	71	Amarelo
33322	814	7	7	Amarelo
33323	814	8	78	Amarelo
33324	814	9	49	Amarelo
33325	814	11	37	Amarelo
33326	814	231	11	Amarelo
33327	814	232	6	Amarelo
33328	814	233	79	Amarelo
33329	814	234	4	Amarelo
33330	814	235	30	Amarelo
33331	814	237	39	Amarelo
33332	814	241	54	Amarelo
33333	814	242	70	Amarelo
33334	814	244	38	Amarelo
33335	814	247	54	Amarelo
33336	814	249	76	Amarelo
33337	814	250	22	Amarelo
33338	814	251	22	Amarelo
33339	815	185	53	Amarelo
33340	815	186	78	Amarelo
33341	815	187	28	Amarelo
33342	815	188	44	Amarelo
33343	815	189	13	Amarelo
33344	815	191	82	Amarelo
33345	815	192	4	Amarelo
33346	815	193	79	Amarelo
33347	815	196	74	Amarelo
33348	815	198	76	Amarelo
33349	815	199	56	Amarelo
33350	815	200	76	Amarelo
33351	815	204	56	Amarelo
33352	815	206	90	Amarelo
33353	815	212	55	Amarelo
33354	815	215	85	Amarelo
33355	815	217	1	Amarelo
33356	815	220	12	Amarelo
33357	815	223	2	Amarelo
33358	815	224	41	Amarelo
33359	815	225	43	Amarelo
33360	815	226	72	Amarelo
33361	815	227	64	Amarelo
33362	815	228	69	Amarelo
33363	815	230	43	Amarelo
1597	\N	\N	\N	
33364	817	164	23	Amarelo
33365	817	167	9	Amarelo
33366	817	174	28	Amarelo
33367	817	176	37	Amarelo
33368	817	177	79	Amarelo
33369	817	179	78	Amarelo
33370	817	181	39	Amarelo
33371	817	184	78	Amarelo
33372	817	1	44	Amarelo
33373	817	2	88	Amarelo
33374	817	5	59	Amarelo
33375	817	6	2	Amarelo
33376	817	9	89	Amarelo
33377	817	11	65	Amarelo
33378	817	185	70	Amarelo
33379	817	187	4	Amarelo
33380	817	189	30	Amarelo
33381	817	190	13	Amarelo
33382	817	193	57	Amarelo
33383	817	194	18	Amarelo
33384	817	195	67	Amarelo
33385	817	196	74	Amarelo
33386	817	199	16	Amarelo
33387	817	200	69	Amarelo
33388	817	201	26	Amarelo
33389	817	202	82	Amarelo
33390	817	204	62	Amarelo
33391	817	206	75	Amarelo
33392	818	163	20	Amarelo
33393	818	165	79	Amarelo
33394	818	167	76	Amarelo
33395	818	169	70	Amarelo
33396	818	174	47	Amarelo
33397	818	176	66	Amarelo
33398	818	177	62	Amarelo
33399	818	179	61	Amarelo
33400	818	180	41	Amarelo
33401	818	181	26	Amarelo
33402	818	182	55	Amarelo
33403	818	183	5	Amarelo
33404	818	3	70	Amarelo
33405	818	5	71	Amarelo
33406	818	6	13	Amarelo
33407	818	8	3	Amarelo
33408	818	10	55	Amarelo
33409	818	11	33	Amarelo
33410	818	185	44	Amarelo
33411	818	188	82	Amarelo
33412	818	189	59	Amarelo
33413	818	190	57	Amarelo
33414	818	192	24	Amarelo
33415	818	193	24	Amarelo
33416	818	195	10	Amarelo
33417	818	197	53	Amarelo
33418	818	198	78	Amarelo
33419	818	199	17	Amarelo
33420	818	202	15	Amarelo
33421	818	206	16	Amarelo
33422	818	207	7	Amarelo
1598	\N	\N	\N	
33423	819	162	60	Amarelo
33424	819	164	55	Amarelo
33425	819	165	4	Amarelo
33426	819	166	13	Amarelo
33427	819	167	47	Amarelo
33428	819	169	60	Amarelo
33429	819	171	22	Amarelo
33430	819	172	64	Amarelo
33431	819	175	84	Amarelo
33432	819	176	31	Amarelo
33433	819	178	33	Amarelo
33434	819	181	10	Amarelo
33435	819	184	30	Amarelo
33436	819	1	25	Amarelo
33437	819	3	84	Amarelo
33438	819	4	10	Amarelo
33439	819	8	61	Amarelo
33440	819	9	48	Amarelo
33441	819	10	47	Amarelo
33442	819	11	59	Amarelo
33443	819	208	84	Amarelo
33444	819	212	51	Amarelo
33445	819	213	12	Amarelo
33446	819	214	43	Amarelo
33447	819	215	30	Amarelo
33448	819	218	40	Amarelo
33449	819	219	22	Amarelo
33450	819	221	25	Amarelo
33451	819	222	11	Amarelo
33452	819	225	2	Amarelo
33453	819	226	42	Amarelo
33454	819	229	53	Amarelo
33455	819	230	82	Amarelo
33456	820	166	72	Amarelo
33457	820	167	24	Amarelo
33458	820	170	65	Amarelo
33459	820	171	29	Amarelo
33460	820	172	35	Amarelo
33461	820	174	34	Amarelo
33462	820	178	48	Amarelo
33463	820	180	32	Amarelo
33464	820	183	9	Amarelo
33465	820	5	1	Amarelo
33466	820	9	33	Amarelo
33467	820	10	76	Amarelo
33468	820	11	73	Amarelo
33469	820	231	45	Amarelo
33470	820	232	68	Amarelo
33471	820	233	75	Amarelo
33472	820	238	87	Amarelo
33473	820	239	20	Amarelo
33474	820	241	39	Amarelo
33475	820	242	26	Amarelo
33476	820	247	70	Amarelo
33477	820	248	38	Amarelo
33478	820	253	59	Amarelo
33479	821	185	33	Amarelo
33480	821	186	39	Amarelo
33481	821	187	20	Amarelo
33482	821	191	60	Amarelo
33483	821	192	42	Amarelo
33484	821	194	30	Amarelo
33485	821	198	40	Amarelo
33486	821	200	78	Amarelo
33487	821	201	22	Amarelo
33488	821	202	18	Amarelo
33489	821	205	83	Amarelo
33490	821	207	45	Amarelo
33491	821	208	85	Amarelo
33492	821	209	41	Amarelo
33493	821	211	23	Amarelo
33494	821	212	8	Amarelo
33495	821	213	44	Amarelo
33496	821	214	12	Amarelo
33497	821	215	12	Amarelo
33498	821	218	88	Amarelo
33499	821	222	76	Amarelo
33500	821	224	59	Amarelo
33501	821	225	69	Amarelo
33502	821	227	8	Amarelo
1599	\N	\N	\N	
33503	822	185	44	Amarelo
33504	822	188	21	Amarelo
33505	822	190	25	Amarelo
33506	822	191	2	Amarelo
33507	822	192	31	Amarelo
33508	822	196	53	Amarelo
33509	822	197	5	Amarelo
33510	822	199	47	Amarelo
33511	822	201	22	Amarelo
33512	822	203	41	Amarelo
33513	822	205	23	Amarelo
33514	822	207	41	Amarelo
33515	822	233	62	Amarelo
33516	822	234	70	Amarelo
33517	822	236	46	Amarelo
33518	822	237	25	Amarelo
33519	822	239	16	Amarelo
33520	822	240	9	Amarelo
33521	822	241	47	Amarelo
33522	822	242	53	Amarelo
33523	822	245	33	Amarelo
33524	822	247	5	Amarelo
33525	822	248	27	Amarelo
33526	822	250	74	Amarelo
33527	823	208	64	Amarelo
33528	823	209	45	Amarelo
33529	823	210	4	Amarelo
33530	823	211	75	Amarelo
33531	823	212	80	Amarelo
33532	823	214	41	Amarelo
33533	823	215	13	Amarelo
33534	823	219	44	Amarelo
33535	823	220	5	Amarelo
33536	823	222	37	Amarelo
33537	823	224	13	Amarelo
33538	823	226	87	Amarelo
33539	823	227	59	Amarelo
33540	823	228	65	Amarelo
33541	823	229	37	Amarelo
33542	823	230	22	Amarelo
33543	823	233	30	Amarelo
33544	823	235	48	Amarelo
33545	823	236	63	Amarelo
33546	823	237	16	Amarelo
33547	823	240	66	Amarelo
33548	823	241	18	Amarelo
33549	823	242	41	Amarelo
33550	823	243	17	Amarelo
33551	823	246	49	Amarelo
33552	823	248	65	Amarelo
33553	824	254	65	Amarelo
33554	824	255	40	Amarelo
33555	824	258	71	Amarelo
33556	824	260	86	Amarelo
33557	824	261	68	Amarelo
33558	824	262	18	Amarelo
33559	824	263	38	Amarelo
33560	824	268	43	Amarelo
33561	824	269	76	Amarelo
33562	824	270	32	Amarelo
33563	824	272	1	Amarelo
33564	824	274	73	Amarelo
33565	824	277	66	Amarelo
33566	824	279	62	Amarelo
33567	824	280	78	Amarelo
33568	824	281	27	Amarelo
33569	824	282	37	Amarelo
33570	824	283	52	Amarelo
33571	824	284	17	Amarelo
33572	824	285	25	Amarelo
33573	824	286	26	Amarelo
33574	824	287	41	Amarelo
33575	824	288	81	Amarelo
33576	824	289	18	Amarelo
33577	824	292	37	Amarelo
33578	824	293	70	Amarelo
33579	824	294	86	Amarelo
33580	824	295	56	Amarelo
1600	\N	\N	\N	
33581	825	256	58	Amarelo
33582	825	257	5	Amarelo
33583	825	258	32	Amarelo
33584	825	261	78	Amarelo
33585	825	263	5	Amarelo
33586	825	265	51	Amarelo
33587	825	269	23	Amarelo
33588	825	270	54	Amarelo
33589	825	275	47	Amarelo
33590	825	300	76	Amarelo
33591	825	301	32	Amarelo
33592	825	304	83	Amarelo
33593	825	305	8	Amarelo
33594	825	306	49	Amarelo
33595	825	310	66	Amarelo
33596	825	312	79	Amarelo
33597	825	313	58	Amarelo
33598	825	315	65	Amarelo
33599	825	316	69	Amarelo
33600	825	320	18	Amarelo
33601	825	322	23	Amarelo
1601	\N	\N	\N	
33602	826	254	64	Amarelo
33603	826	258	83	Amarelo
33604	826	259	28	Amarelo
33605	826	260	33	Amarelo
33606	826	261	67	Amarelo
33607	826	262	63	Amarelo
33608	826	265	5	Amarelo
33609	826	266	76	Amarelo
33610	826	267	82	Amarelo
33611	826	268	46	Amarelo
33612	826	269	17	Amarelo
33613	826	271	70	Amarelo
33614	826	272	34	Amarelo
33615	826	273	52	Amarelo
33616	826	274	57	Amarelo
33617	826	275	86	Amarelo
33618	826	326	34	Amarelo
33619	826	328	86	Amarelo
33620	826	330	56	Amarelo
33621	826	335	5	Amarelo
33622	826	336	20	Amarelo
33623	826	337	57	Amarelo
33624	826	338	33	Amarelo
33625	826	340	35	Amarelo
33626	826	341	39	Amarelo
33627	826	343	66	Amarelo
33628	826	344	44	Amarelo
33629	826	345	89	Amarelo
33630	827	277	69	Amarelo
33631	827	278	27	Amarelo
33632	827	279	84	Amarelo
33633	827	280	18	Amarelo
33634	827	285	34	Amarelo
33635	827	286	17	Amarelo
33636	827	287	67	Amarelo
33637	827	290	6	Amarelo
33638	827	296	31	Amarelo
33639	827	297	51	Amarelo
33640	827	299	88	Amarelo
33641	827	303	69	Amarelo
33642	827	304	82	Amarelo
33643	827	307	50	Amarelo
33644	827	308	50	Amarelo
33645	827	309	71	Amarelo
33646	827	312	19	Amarelo
33647	827	314	11	Amarelo
33648	827	315	60	Amarelo
33649	827	317	65	Amarelo
33650	827	319	57	Amarelo
33651	827	320	56	Amarelo
33652	827	321	33	Amarelo
33653	828	279	42	Amarelo
33654	828	282	71	Amarelo
33655	828	284	27	Amarelo
33656	828	286	40	Amarelo
33657	828	288	46	Amarelo
33658	828	291	67	Amarelo
33659	828	293	84	Amarelo
33660	828	294	7	Amarelo
33661	828	295	9	Amarelo
33662	828	296	28	Amarelo
33663	828	298	60	Amarelo
33664	828	325	80	Amarelo
33665	828	329	13	Amarelo
33666	828	330	8	Amarelo
33667	828	332	32	Amarelo
33668	828	334	7	Amarelo
33669	828	335	55	Amarelo
33670	828	336	75	Amarelo
33671	828	340	24	Amarelo
33672	828	342	72	Amarelo
33673	828	343	73	Amarelo
1602	\N	\N	\N	
33674	829	301	42	Amarelo
33675	829	304	78	Amarelo
33676	829	305	48	Amarelo
33677	829	307	61	Amarelo
33678	829	308	60	Amarelo
33679	829	309	23	Amarelo
33680	829	311	66	Amarelo
33681	829	314	24	Amarelo
33682	829	317	73	Amarelo
33683	829	318	68	Amarelo
33684	829	326	78	Amarelo
33685	829	328	42	Amarelo
33686	829	331	77	Amarelo
33687	829	333	47	Amarelo
33688	829	335	28	Amarelo
33689	829	337	54	Amarelo
33690	829	339	53	Amarelo
33691	829	340	75	Amarelo
33692	829	341	83	Amarelo
33693	829	345	9	Amarelo
1603	\N	\N	\N	
33694	830	346	64	Amarelo
33695	830	347	36	Amarelo
33696	830	348	11	Amarelo
33697	830	349	52	Amarelo
33698	830	350	81	Amarelo
33699	830	353	13	Amarelo
33700	830	355	67	Amarelo
33701	830	356	74	Amarelo
33702	830	358	7	Amarelo
33703	830	359	57	Amarelo
33704	830	360	87	Amarelo
33705	830	362	74	Amarelo
33706	830	364	73	Amarelo
33707	830	366	25	Amarelo
33708	830	367	70	Amarelo
33709	830	371	11	Amarelo
33710	830	372	15	Amarelo
33711	830	373	26	Amarelo
33712	830	374	59	Amarelo
33713	830	377	9	Amarelo
33714	830	378	38	Amarelo
33715	830	379	30	Amarelo
33716	830	383	5	Amarelo
33717	830	386	68	Amarelo
33718	830	388	54	Amarelo
33719	830	390	13	Amarelo
33720	830	391	74	Amarelo
33721	831	348	40	Amarelo
33722	831	350	90	Amarelo
33723	831	351	79	Amarelo
33724	831	352	73	Amarelo
33725	831	355	28	Amarelo
33726	831	356	17	Amarelo
33727	831	358	34	Amarelo
33728	831	359	30	Amarelo
33729	831	364	24	Amarelo
33730	831	368	41	Amarelo
33731	831	397	70	Amarelo
33732	831	399	9	Amarelo
33733	831	405	70	Amarelo
33734	831	406	32	Amarelo
33735	831	408	86	Amarelo
33736	831	410	63	Amarelo
33737	831	411	64	Amarelo
33738	831	413	68	Amarelo
33739	831	414	2	Amarelo
1604	\N	\N	\N	
33740	832	351	85	Amarelo
33741	832	354	18	Amarelo
33742	832	355	42	Amarelo
33743	832	357	23	Amarelo
33744	832	359	9	Amarelo
33745	832	364	90	Amarelo
33746	832	366	25	Amarelo
33747	832	368	72	Amarelo
33748	832	421	81	Amarelo
33749	832	423	47	Amarelo
33750	832	426	16	Amarelo
33751	832	427	90	Amarelo
33752	832	429	30	Amarelo
33753	832	432	6	Amarelo
33754	832	435	4	Amarelo
33755	832	436	53	Amarelo
33756	832	437	85	Amarelo
33757	833	370	17	Amarelo
33758	833	372	21	Amarelo
33759	833	373	62	Amarelo
33760	833	374	37	Amarelo
33761	833	375	37	Amarelo
33762	833	376	39	Amarelo
33763	833	379	13	Amarelo
33764	833	380	64	Amarelo
33765	833	385	17	Amarelo
33766	833	388	49	Amarelo
33767	833	389	52	Amarelo
33768	833	390	18	Amarelo
33769	833	393	85	Amarelo
33770	833	394	78	Amarelo
33771	833	396	20	Amarelo
33772	833	398	14	Amarelo
33773	833	400	1	Amarelo
33774	833	401	4	Amarelo
33775	833	405	83	Amarelo
33776	833	406	60	Amarelo
33777	833	407	51	Amarelo
33778	833	409	53	Amarelo
33779	833	412	29	Amarelo
33780	834	370	65	Amarelo
33781	834	371	42	Amarelo
33782	834	372	77	Amarelo
33783	834	373	2	Amarelo
33784	834	374	55	Amarelo
33785	834	376	22	Amarelo
33786	834	377	75	Amarelo
33787	834	380	3	Amarelo
33788	834	381	46	Amarelo
33789	834	384	81	Amarelo
33790	834	385	64	Amarelo
33791	834	386	9	Amarelo
33792	834	390	89	Amarelo
33793	834	415	69	Amarelo
33794	834	416	59	Amarelo
33795	834	418	89	Amarelo
33796	834	419	78	Amarelo
33797	834	422	44	Amarelo
33798	834	423	52	Amarelo
33799	834	427	67	Amarelo
33800	834	429	83	Amarelo
33801	834	433	37	Amarelo
33802	834	434	89	Amarelo
33803	834	435	83	Amarelo
33804	834	437	56	Amarelo
33805	835	394	47	Amarelo
33806	835	396	81	Amarelo
33807	835	398	86	Amarelo
33808	835	400	24	Amarelo
33809	835	401	89	Amarelo
33810	835	402	9	Amarelo
33811	835	403	77	Amarelo
33812	835	404	1	Amarelo
33813	835	409	78	Amarelo
33814	835	411	47	Amarelo
33815	835	413	31	Amarelo
33816	835	416	51	Amarelo
33817	835	421	60	Amarelo
33818	835	423	80	Amarelo
33819	835	426	22	Amarelo
33820	835	427	19	Amarelo
33821	835	428	58	Amarelo
33822	835	430	21	Amarelo
33823	835	431	52	Amarelo
33824	835	432	83	Amarelo
33825	835	433	39	Amarelo
33826	835	435	2	Amarelo
33827	836	438	71	Amarelo
33828	836	439	79	Amarelo
33829	836	440	5	Amarelo
33830	836	443	5	Amarelo
33831	836	444	68	Amarelo
33832	836	445	50	Amarelo
33833	836	450	22	Amarelo
33834	836	451	30	Amarelo
33835	836	453	81	Amarelo
33836	836	454	31	Amarelo
33837	836	458	43	Amarelo
33838	836	459	39	Amarelo
33839	836	460	42	Amarelo
33840	836	463	78	Amarelo
33841	836	470	83	Amarelo
33842	836	471	26	Amarelo
33843	836	473	18	Amarelo
33844	836	475	71	Amarelo
33845	836	476	79	Amarelo
33846	836	477	58	Amarelo
33847	836	478	2	Amarelo
33848	836	479	34	Amarelo
33849	836	481	46	Amarelo
33850	836	483	47	Amarelo
33851	837	440	47	Amarelo
33852	837	442	28	Amarelo
33853	837	443	2	Amarelo
33854	837	444	52	Amarelo
33855	837	447	78	Amarelo
33856	837	448	70	Amarelo
33857	837	451	11	Amarelo
33858	837	452	7	Amarelo
33859	837	454	3	Amarelo
33860	837	455	82	Amarelo
33861	837	456	83	Amarelo
33862	837	457	34	Amarelo
33863	837	459	80	Amarelo
33864	837	487	81	Amarelo
33865	837	490	59	Amarelo
33866	837	491	78	Amarelo
33867	837	492	77	Amarelo
33868	837	493	82	Amarelo
33869	837	494	40	Amarelo
33870	837	496	17	Amarelo
33871	837	497	10	Amarelo
33872	837	499	53	Amarelo
33873	837	502	90	Amarelo
33874	837	504	61	Amarelo
33875	837	506	71	Amarelo
33876	838	438	57	Amarelo
33877	838	440	40	Amarelo
33878	838	441	65	Amarelo
33879	838	442	74	Amarelo
33880	838	443	23	Amarelo
33881	838	445	74	Amarelo
33882	838	447	66	Amarelo
33883	838	449	70	Amarelo
33884	838	450	83	Amarelo
33885	838	451	14	Amarelo
33886	838	454	70	Amarelo
33887	838	456	49	Amarelo
33888	838	457	20	Amarelo
33889	838	458	90	Amarelo
33890	838	459	58	Amarelo
33891	838	460	90	Amarelo
33892	838	508	76	Amarelo
33893	838	512	52	Amarelo
33894	838	514	16	Amarelo
33895	838	516	6	Amarelo
33896	838	518	47	Amarelo
33897	838	519	58	Amarelo
33898	838	520	43	Amarelo
33899	838	521	9	Amarelo
33900	838	523	58	Amarelo
33901	838	527	71	Amarelo
33902	838	528	56	Amarelo
33903	838	529	17	Amarelo
33904	839	463	45	Amarelo
33905	839	464	16	Amarelo
33906	839	465	88	Amarelo
33907	839	466	48	Amarelo
33908	839	468	57	Amarelo
33909	839	469	41	Amarelo
33910	839	471	67	Amarelo
33911	839	473	30	Amarelo
33912	839	476	18	Amarelo
33913	839	479	7	Amarelo
33914	839	480	32	Amarelo
33915	839	482	51	Amarelo
33916	839	485	14	Amarelo
33917	839	486	88	Amarelo
33918	839	487	6	Amarelo
33919	839	489	20	Amarelo
33920	839	490	5	Amarelo
33921	839	491	42	Amarelo
33922	839	493	22	Amarelo
33923	839	495	48	Amarelo
33924	839	497	21	Amarelo
33925	839	501	34	Amarelo
33926	839	502	78	Amarelo
33927	840	462	6	Amarelo
33928	840	463	25	Amarelo
33929	840	464	52	Amarelo
33930	840	466	73	Amarelo
33931	840	467	23	Amarelo
33932	840	468	18	Amarelo
33933	840	469	29	Amarelo
33934	840	470	52	Amarelo
33935	840	471	18	Amarelo
33936	840	473	3	Amarelo
33937	840	474	71	Amarelo
33938	840	475	81	Amarelo
33939	840	477	87	Amarelo
33940	840	482	31	Amarelo
33941	840	514	70	Amarelo
33942	840	516	61	Amarelo
33943	840	517	37	Amarelo
33944	840	518	34	Amarelo
33945	840	519	26	Amarelo
33946	840	520	83	Amarelo
33947	840	522	45	Amarelo
33948	840	523	17	Amarelo
33949	840	524	81	Amarelo
33950	840	526	43	Amarelo
33951	840	529	64	Amarelo
33952	841	484	58	Amarelo
33953	841	485	20	Amarelo
33954	841	488	23	Amarelo
33955	841	490	1	Amarelo
33956	841	492	44	Amarelo
33957	841	495	63	Amarelo
33958	841	497	51	Amarelo
33959	841	498	47	Amarelo
33960	841	500	44	Amarelo
33961	841	501	4	Amarelo
33962	841	502	83	Amarelo
33963	841	506	51	Amarelo
33964	841	507	65	Amarelo
33965	841	508	78	Amarelo
33966	841	509	41	Amarelo
33967	841	511	74	Amarelo
33968	841	513	40	Amarelo
33969	841	516	7	Amarelo
33970	841	518	62	Amarelo
33971	841	521	3	Amarelo
33972	841	523	56	Amarelo
33973	841	524	69	Amarelo
33974	841	525	53	Amarelo
33975	841	526	22	Amarelo
33976	841	527	70	Amarelo
33977	841	529	59	Amarelo
33978	842	208	87	Amarelo
33979	842	209	50	Amarelo
33980	842	210	72	Amarelo
33981	842	211	17	Amarelo
33982	842	212	46	Amarelo
33983	842	214	18	Amarelo
33984	842	218	12	Amarelo
33985	842	222	42	Amarelo
33986	842	224	82	Amarelo
33987	842	226	50	Amarelo
33988	842	232	48	Amarelo
33989	842	233	22	Amarelo
33990	842	235	37	Amarelo
33991	842	236	37	Amarelo
33992	842	239	83	Amarelo
33993	842	240	78	Amarelo
33994	842	244	65	Amarelo
33995	842	248	70	Amarelo
33996	842	249	74	Amarelo
33997	842	253	9	Amarelo
1605	\N	\N	\N	
33998	843	277	85	Amarelo
33999	843	278	21	Amarelo
34000	843	279	56	Amarelo
34001	843	280	1	Amarelo
34002	843	281	29	Amarelo
34003	843	283	66	Amarelo
34004	843	284	44	Amarelo
34005	843	286	15	Amarelo
34006	843	287	26	Amarelo
34007	843	288	11	Amarelo
34008	843	290	46	Amarelo
34009	843	291	53	Amarelo
34010	843	293	41	Amarelo
34011	843	294	89	Amarelo
34012	843	296	83	Amarelo
34013	843	299	11	Amarelo
34014	843	301	16	Amarelo
34015	843	303	66	Amarelo
34016	843	305	48	Amarelo
34017	843	308	67	Amarelo
34018	843	309	47	Amarelo
34019	843	314	72	Amarelo
1606	\N	\N	\N	
34020	844	415	29	Amarelo
34021	844	416	64	Amarelo
34022	844	418	11	Amarelo
34023	844	419	24	Amarelo
34024	844	421	87	Amarelo
34025	844	424	50	Amarelo
34026	844	425	1	Amarelo
34027	844	428	25	Amarelo
34028	844	429	11	Amarelo
34029	844	430	80	Amarelo
34030	844	431	53	Amarelo
34031	844	434	50	Amarelo
34032	844	435	67	Amarelo
34033	844	436	11	Amarelo
34034	844	371	74	Amarelo
34035	844	372	15	Amarelo
34036	844	375	71	Amarelo
34037	844	379	13	Amarelo
34038	844	380	89	Amarelo
34039	844	381	39	Amarelo
34040	844	382	53	Amarelo
34041	844	386	60	Amarelo
34042	844	389	46	Amarelo
34043	844	391	58	Amarelo
1607	\N	\N	\N	
34044	845	507	43	Amarelo
34045	845	510	40	Amarelo
34046	845	511	89	Amarelo
34047	845	517	37	Amarelo
34048	845	519	57	Amarelo
34049	845	521	17	Amarelo
34050	845	522	61	Amarelo
34051	845	523	44	Amarelo
34052	845	524	50	Amarelo
34053	845	525	60	Amarelo
34054	845	526	78	Amarelo
34055	845	528	71	Amarelo
34056	845	439	90	Amarelo
34057	845	442	41	Amarelo
34058	845	444	52	Amarelo
34059	845	445	76	Amarelo
34060	845	446	83	Amarelo
34061	845	449	80	Amarelo
34062	845	450	41	Amarelo
34063	845	451	22	Amarelo
34064	845	453	24	Amarelo
34065	845	456	77	Amarelo
34066	845	457	57	Amarelo
34067	846	162	29	Amarelo
34068	846	164	41	Amarelo
34069	846	165	30	Amarelo
34070	846	166	53	Amarelo
34071	846	168	89	Amarelo
34072	846	169	24	Amarelo
34073	846	175	23	Amarelo
34074	846	176	34	Amarelo
34075	846	177	48	Amarelo
34076	846	178	36	Amarelo
34077	846	179	67	Amarelo
34078	846	181	48	Amarelo
34079	846	1	55	Amarelo
34080	846	6	49	Amarelo
34081	846	9	27	Amarelo
34082	846	11	81	Amarelo
34083	846	185	77	Amarelo
34084	846	186	55	Amarelo
34085	846	189	70	Amarelo
34086	846	190	53	Amarelo
34087	846	191	89	Amarelo
34088	846	194	25	Amarelo
34089	846	196	61	Amarelo
34090	846	197	39	Amarelo
34091	846	198	87	Amarelo
34092	846	199	42	Amarelo
34093	846	201	61	Amarelo
34094	846	203	18	Amarelo
34095	846	204	73	Amarelo
34096	846	206	58	Amarelo
34097	846	207	22	Amarelo
34098	847	163	25	Amarelo
34099	847	165	65	Amarelo
34100	847	168	72	Amarelo
34101	847	169	24	Amarelo
34102	847	170	25	Amarelo
34103	847	171	16	Amarelo
34104	847	172	78	Amarelo
34105	847	175	40	Amarelo
34106	847	176	70	Amarelo
34107	847	177	34	Amarelo
34108	847	178	65	Amarelo
34109	847	180	28	Amarelo
34110	847	181	51	Amarelo
34111	847	182	19	Amarelo
34112	847	1	79	Amarelo
34113	847	3	68	Amarelo
34114	847	4	61	Amarelo
34115	847	5	76	Amarelo
34116	847	7	38	Amarelo
34117	847	8	89	Amarelo
34118	847	9	82	Amarelo
34119	847	10	55	Amarelo
34120	847	209	64	Amarelo
34121	847	212	37	Amarelo
34122	847	213	12	Amarelo
34123	847	216	50	Amarelo
34124	847	217	57	Amarelo
34125	847	218	25	Amarelo
34126	847	225	6	Amarelo
34127	847	227	4	Amarelo
34128	847	228	86	Amarelo
34129	847	229	34	Amarelo
34130	848	163	58	Amarelo
34131	848	165	71	Amarelo
34132	848	170	30	Amarelo
34133	848	172	16	Amarelo
34134	848	173	15	Amarelo
34135	848	175	75	Amarelo
34136	848	176	41	Amarelo
34137	848	177	82	Amarelo
34138	848	180	33	Amarelo
34139	848	182	88	Amarelo
34140	848	183	48	Amarelo
34141	848	2	20	Amarelo
34142	848	4	16	Amarelo
34143	848	8	7	Amarelo
34144	848	10	38	Amarelo
34145	848	11	15	Amarelo
34146	848	232	22	Amarelo
34147	848	233	40	Amarelo
34148	848	234	28	Amarelo
34149	848	235	86	Amarelo
34150	848	236	16	Amarelo
34151	848	237	15	Amarelo
34152	848	238	87	Amarelo
34153	848	239	61	Amarelo
34154	848	244	2	Amarelo
34155	848	252	5	Amarelo
34156	848	253	11	Amarelo
34157	849	185	52	Amarelo
34158	849	187	38	Amarelo
34159	849	192	26	Amarelo
34160	849	194	1	Amarelo
34161	849	198	35	Amarelo
34162	849	199	82	Amarelo
34163	849	201	59	Amarelo
34164	849	202	48	Amarelo
34165	849	204	72	Amarelo
34166	849	205	27	Amarelo
34167	849	208	63	Amarelo
34168	849	212	6	Amarelo
34169	849	215	22	Amarelo
34170	849	217	2	Amarelo
34171	849	219	13	Amarelo
34172	849	220	34	Amarelo
34173	849	225	60	Amarelo
34174	849	226	20	Amarelo
34175	849	228	52	Amarelo
34176	849	229	17	Amarelo
34177	850	185	3	Amarelo
34178	850	186	1	Amarelo
34179	850	187	64	Amarelo
34180	850	189	54	Amarelo
34181	850	191	4	Amarelo
34182	850	192	38	Amarelo
34183	850	193	30	Amarelo
34184	850	195	5	Amarelo
34185	850	197	6	Amarelo
34186	850	203	65	Amarelo
34187	850	231	5	Amarelo
34188	850	236	43	Amarelo
34189	850	237	33	Amarelo
34190	850	238	43	Amarelo
34191	850	239	62	Amarelo
34192	850	240	89	Amarelo
34193	850	243	53	Amarelo
34194	850	245	29	Amarelo
34195	850	246	31	Amarelo
34196	850	247	15	Amarelo
34197	850	248	70	Amarelo
34198	851	209	59	Amarelo
34199	851	210	36	Amarelo
34200	851	214	81	Amarelo
34201	851	216	39	Amarelo
34202	851	221	24	Amarelo
34203	851	223	10	Amarelo
34204	851	232	31	Amarelo
34205	851	233	1	Amarelo
34206	851	238	71	Amarelo
34207	851	239	60	Amarelo
34208	851	240	85	Amarelo
34209	851	241	14	Amarelo
34210	851	243	29	Amarelo
34211	851	244	42	Amarelo
34212	851	247	5	Amarelo
34213	851	249	17	Amarelo
34214	851	250	16	Amarelo
34215	851	251	23	Amarelo
34216	851	253	61	Amarelo
34217	852	254	22	Amarelo
34218	852	257	90	Amarelo
34219	852	258	64	Amarelo
34220	852	259	29	Amarelo
34221	852	260	72	Amarelo
34222	852	261	61	Amarelo
34223	852	264	59	Amarelo
34224	852	265	53	Amarelo
34225	852	268	32	Amarelo
34226	852	271	27	Amarelo
34227	852	273	72	Amarelo
34228	852	274	82	Amarelo
34229	852	276	46	Amarelo
34230	852	277	23	Amarelo
34231	852	280	85	Amarelo
34232	852	283	86	Amarelo
34233	852	284	52	Amarelo
34234	852	285	71	Amarelo
34235	852	287	63	Amarelo
34236	852	289	29	Amarelo
34237	852	290	87	Amarelo
34238	852	294	64	Amarelo
34239	852	297	47	Amarelo
34240	852	299	29	Amarelo
34241	853	255	35	Amarelo
34242	853	256	21	Amarelo
34243	853	258	82	Amarelo
34244	853	262	38	Amarelo
34245	853	267	10	Amarelo
34246	853	268	15	Amarelo
34247	853	269	20	Amarelo
34248	853	270	59	Amarelo
34249	853	271	30	Amarelo
34250	853	272	50	Amarelo
34251	853	274	55	Amarelo
34252	853	276	65	Amarelo
34253	853	300	18	Amarelo
34254	853	304	77	Amarelo
34255	853	305	79	Amarelo
34256	853	307	58	Amarelo
34257	853	309	4	Amarelo
34258	853	312	35	Amarelo
34259	853	314	83	Amarelo
34260	853	316	3	Amarelo
34261	854	256	36	Amarelo
34262	854	257	56	Amarelo
34263	854	260	27	Amarelo
34264	854	262	86	Amarelo
34265	854	263	85	Amarelo
34266	854	264	49	Amarelo
34267	854	265	32	Amarelo
34268	854	266	51	Amarelo
34269	854	267	50	Amarelo
34270	854	268	28	Amarelo
34271	854	271	53	Amarelo
34272	854	272	59	Amarelo
34273	854	273	37	Amarelo
34274	854	274	12	Amarelo
34275	854	324	11	Amarelo
34276	854	325	44	Amarelo
34277	854	326	65	Amarelo
34278	854	327	77	Amarelo
34279	854	329	87	Amarelo
34280	854	330	15	Amarelo
34281	854	331	50	Amarelo
34282	854	334	17	Amarelo
34283	854	335	46	Amarelo
34284	854	336	47	Amarelo
34285	854	337	79	Amarelo
34286	854	341	31	Amarelo
34287	854	344	14	Amarelo
1608	\N	\N	\N	
1609	\N	\N	\N	
1610	\N	\N	\N	
1611	\N	\N	\N	
1612	\N	\N	\N	
1613	\N	\N	\N	
1614	\N	\N	\N	
1615	\N	\N	\N	
1616	\N	\N	\N	
1617	\N	\N	\N	
1618	\N	\N	\N	
1619	\N	\N	\N	
1620	\N	\N	\N	
1621	\N	\N	\N	
1622	\N	\N	\N	
309	\N	\N	\N	
310	\N	\N	\N	
311	\N	\N	\N	
312	\N	\N	\N	
313	\N	\N	\N	
314	\N	\N	\N	
315	\N	\N	\N	
316	\N	\N	\N	
317	\N	\N	\N	
318	\N	\N	\N	
319	\N	\N	\N	
320	\N	\N	\N	
321	\N	\N	\N	
322	\N	\N	\N	
323	\N	\N	\N	
324	\N	\N	\N	
325	\N	\N	\N	
326	\N	\N	\N	
327	\N	\N	\N	
328	\N	\N	\N	
329	\N	\N	\N	
330	\N	\N	\N	
331	\N	\N	\N	
332	\N	\N	\N	
333	\N	\N	\N	
334	\N	\N	\N	
335	\N	\N	\N	
336	\N	\N	\N	
337	\N	\N	\N	
338	\N	\N	\N	
339	\N	\N	\N	
340	\N	\N	\N	
341	\N	\N	\N	
342	\N	\N	\N	
343	\N	\N	\N	
344	\N	\N	\N	
345	\N	\N	\N	
346	\N	\N	\N	
1588	\N	\N	\N	
1589	\N	\N	\N	
1590	\N	\N	\N	
1591	\N	\N	\N	
1592	\N	\N	\N	
1593	\N	\N	\N	
1594	\N	\N	\N	
1595	\N	\N	\N	
1596	\N	\N	\N	
33113	\N	\N	\N	
33114	\N	\N	\N	
33115	\N	\N	\N	
33116	\N	\N	\N	
33117	\N	\N	\N	
33118	\N	\N	\N	
33119	\N	\N	\N	
33120	\N	\N	\N	
33121	\N	\N	\N	
33122	\N	\N	\N	
33123	\N	\N	\N	
33124	\N	\N	\N	
33125	\N	\N	\N	
33126	\N	\N	\N	
33127	\N	\N	\N	
33128	\N	\N	\N	
33129	\N	\N	\N	
33130	\N	\N	\N	
33131	\N	\N	\N	
33132	\N	\N	\N	
33133	\N	\N	\N	
33134	\N	\N	\N	
33135	\N	\N	\N	
33136	\N	\N	\N	
33137	\N	\N	\N	
33138	\N	\N	\N	
33139	\N	\N	\N	
33140	\N	\N	\N	
33141	\N	\N	\N	
33142	\N	\N	\N	
347	\N	\N	\N	
348	\N	\N	\N	
349	\N	\N	\N	
350	\N	\N	\N	
351	\N	\N	\N	
352	\N	\N	\N	
353	\N	\N	\N	
354	\N	\N	\N	
355	\N	\N	\N	
356	\N	\N	\N	
357	\N	\N	\N	
358	\N	\N	\N	
359	\N	\N	\N	
360	\N	\N	\N	
361	\N	\N	\N	
362	\N	\N	\N	
363	\N	\N	\N	
364	\N	\N	\N	
365	\N	\N	\N	
366	\N	\N	\N	
367	\N	\N	\N	
368	\N	\N	\N	
369	\N	\N	\N	
370	\N	\N	\N	
371	\N	\N	\N	
372	\N	\N	\N	
373	\N	\N	\N	
374	\N	\N	\N	
375	\N	\N	\N	
376	\N	\N	\N	
377	\N	\N	\N	
378	\N	\N	\N	
379	\N	\N	\N	
380	\N	\N	\N	
381	\N	\N	\N	
382	\N	\N	\N	
383	\N	\N	\N	
384	\N	\N	\N	
385	\N	\N	\N	
386	\N	\N	\N	
387	\N	\N	\N	
388	\N	\N	\N	
389	\N	\N	\N	
390	\N	\N	\N	
391	\N	\N	\N	
392	\N	\N	\N	
393	\N	\N	\N	
394	\N	\N	\N	
395	\N	\N	\N	
396	\N	\N	\N	
397	\N	\N	\N	
398	\N	\N	\N	
399	\N	\N	\N	
400	\N	\N	\N	
401	\N	\N	\N	
402	\N	\N	\N	
403	\N	\N	\N	
404	\N	\N	\N	
405	\N	\N	\N	
406	\N	\N	\N	
407	\N	\N	\N	
408	\N	\N	\N	
409	\N	\N	\N	
410	\N	\N	\N	
411	\N	\N	\N	
412	\N	\N	\N	
413	\N	\N	\N	
414	\N	\N	\N	
415	\N	\N	\N	
416	\N	\N	\N	
417	\N	\N	\N	
418	\N	\N	\N	
419	\N	\N	\N	
420	\N	\N	\N	
421	\N	\N	\N	
422	\N	\N	\N	
423	\N	\N	\N	
424	\N	\N	\N	
425	\N	\N	\N	
426	\N	\N	\N	
427	\N	\N	\N	
428	\N	\N	\N	
429	\N	\N	\N	
430	\N	\N	\N	
431	\N	\N	\N	
432	\N	\N	\N	
433	\N	\N	\N	
434	\N	\N	\N	
435	\N	\N	\N	
436	\N	\N	\N	
437	\N	\N	\N	
438	\N	\N	\N	
439	\N	\N	\N	
440	\N	\N	\N	
441	\N	\N	\N	
442	\N	\N	\N	
443	\N	\N	\N	
444	\N	\N	\N	
445	\N	\N	\N	
446	\N	\N	\N	
447	\N	\N	\N	
448	\N	\N	\N	
449	\N	\N	\N	
450	\N	\N	\N	
451	\N	\N	\N	
452	\N	\N	\N	
453	\N	\N	\N	
454	\N	\N	\N	
455	\N	\N	\N	
456	\N	\N	\N	
457	\N	\N	\N	
458	\N	\N	\N	
459	\N	\N	\N	
460	\N	\N	\N	
461	\N	\N	\N	
462	\N	\N	\N	
463	\N	\N	\N	
464	\N	\N	\N	
465	\N	\N	\N	
466	\N	\N	\N	
467	\N	\N	\N	
468	\N	\N	\N	
469	\N	\N	\N	
470	\N	\N	\N	
471	\N	\N	\N	
472	\N	\N	\N	
473	\N	\N	\N	
474	\N	\N	\N	
475	\N	\N	\N	
476	\N	\N	\N	
477	\N	\N	\N	
478	\N	\N	\N	
479	\N	\N	\N	
480	\N	\N	\N	
481	\N	\N	\N	
482	\N	\N	\N	
483	\N	\N	\N	
484	\N	\N	\N	
485	\N	\N	\N	
486	\N	\N	\N	
487	\N	\N	\N	
488	\N	\N	\N	
489	\N	\N	\N	
490	\N	\N	\N	
491	\N	\N	\N	
492	\N	\N	\N	
493	\N	\N	\N	
494	\N	\N	\N	
495	\N	\N	\N	
496	\N	\N	\N	
497	\N	\N	\N	
498	\N	\N	\N	
499	\N	\N	\N	
500	\N	\N	\N	
501	\N	\N	\N	
502	\N	\N	\N	
503	\N	\N	\N	
504	\N	\N	\N	
505	\N	\N	\N	
506	\N	\N	\N	
507	\N	\N	\N	
508	\N	\N	\N	
509	\N	\N	\N	
510	\N	\N	\N	
511	\N	\N	\N	
512	\N	\N	\N	
513	\N	\N	\N	
514	\N	\N	\N	
515	\N	\N	\N	
516	\N	\N	\N	
517	\N	\N	\N	
518	\N	\N	\N	
519	\N	\N	\N	
520	\N	\N	\N	
521	\N	\N	\N	
522	\N	\N	\N	
523	\N	\N	\N	
524	\N	\N	\N	
525	\N	\N	\N	
526	\N	\N	\N	
527	\N	\N	\N	
528	\N	\N	\N	
529	\N	\N	\N	
530	\N	\N	\N	
531	\N	\N	\N	
532	\N	\N	\N	
533	\N	\N	\N	
534	\N	\N	\N	
535	\N	\N	\N	
536	\N	\N	\N	
537	\N	\N	\N	
538	\N	\N	\N	
539	\N	\N	\N	
540	\N	\N	\N	
541	\N	\N	\N	
542	\N	\N	\N	
543	\N	\N	\N	
544	\N	\N	\N	
545	\N	\N	\N	
546	\N	\N	\N	
547	\N	\N	\N	
548	\N	\N	\N	
549	\N	\N	\N	
550	\N	\N	\N	
551	\N	\N	\N	
552	\N	\N	\N	
553	\N	\N	\N	
554	\N	\N	\N	
555	\N	\N	\N	
556	\N	\N	\N	
557	\N	\N	\N	
558	\N	\N	\N	
559	\N	\N	\N	
560	\N	\N	\N	
561	\N	\N	\N	
562	\N	\N	\N	
563	\N	\N	\N	
564	\N	\N	\N	
565	\N	\N	\N	
566	\N	\N	\N	
567	\N	\N	\N	
568	\N	\N	\N	
569	\N	\N	\N	
570	\N	\N	\N	
571	\N	\N	\N	
572	\N	\N	\N	
573	\N	\N	\N	
574	\N	\N	\N	
575	\N	\N	\N	
576	\N	\N	\N	
577	\N	\N	\N	
578	\N	\N	\N	
579	\N	\N	\N	
580	\N	\N	\N	
581	\N	\N	\N	
582	\N	\N	\N	
583	\N	\N	\N	
584	\N	\N	\N	
585	\N	\N	\N	
586	\N	\N	\N	
587	\N	\N	\N	
588	\N	\N	\N	
589	\N	\N	\N	
590	\N	\N	\N	
591	\N	\N	\N	
592	\N	\N	\N	
593	\N	\N	\N	
594	\N	\N	\N	
595	\N	\N	\N	
596	\N	\N	\N	
597	\N	\N	\N	
598	\N	\N	\N	
599	\N	\N	\N	
600	\N	\N	\N	
601	\N	\N	\N	
602	\N	\N	\N	
603	\N	\N	\N	
604	\N	\N	\N	
605	\N	\N	\N	
606	\N	\N	\N	
607	\N	\N	\N	
608	\N	\N	\N	
609	\N	\N	\N	
610	\N	\N	\N	
611	\N	\N	\N	
612	\N	\N	\N	
613	\N	\N	\N	
614	\N	\N	\N	
615	\N	\N	\N	
616	\N	\N	\N	
617	\N	\N	\N	
618	\N	\N	\N	
619	\N	\N	\N	
620	\N	\N	\N	
621	\N	\N	\N	
622	\N	\N	\N	
623	\N	\N	\N	
624	\N	\N	\N	
625	\N	\N	\N	
626	\N	\N	\N	
627	\N	\N	\N	
628	\N	\N	\N	
629	\N	\N	\N	
630	\N	\N	\N	
631	\N	\N	\N	
632	\N	\N	\N	
633	\N	\N	\N	
634	\N	\N	\N	
635	\N	\N	\N	
636	\N	\N	\N	
637	\N	\N	\N	
638	\N	\N	\N	
639	\N	\N	\N	
640	\N	\N	\N	
641	\N	\N	\N	
642	\N	\N	\N	
643	\N	\N	\N	
644	\N	\N	\N	
645	\N	\N	\N	
646	\N	\N	\N	
647	\N	\N	\N	
648	\N	\N	\N	
649	\N	\N	\N	
650	\N	\N	\N	
651	\N	\N	\N	
652	\N	\N	\N	
653	\N	\N	\N	
654	\N	\N	\N	
655	\N	\N	\N	
656	\N	\N	\N	
657	\N	\N	\N	
658	\N	\N	\N	
659	\N	\N	\N	
660	\N	\N	\N	
661	\N	\N	\N	
662	\N	\N	\N	
663	\N	\N	\N	
664	\N	\N	\N	
665	\N	\N	\N	
666	\N	\N	\N	
667	\N	\N	\N	
668	\N	\N	\N	
669	\N	\N	\N	
670	\N	\N	\N	
671	\N	\N	\N	
672	\N	\N	\N	
673	\N	\N	\N	
674	\N	\N	\N	
675	\N	\N	\N	
676	\N	\N	\N	
677	\N	\N	\N	
678	\N	\N	\N	
679	\N	\N	\N	
680	\N	\N	\N	
681	\N	\N	\N	
682	\N	\N	\N	
683	\N	\N	\N	
684	\N	\N	\N	
685	\N	\N	\N	
686	\N	\N	\N	
687	\N	\N	\N	
688	\N	\N	\N	
689	\N	\N	\N	
690	\N	\N	\N	
691	\N	\N	\N	
692	\N	\N	\N	
693	\N	\N	\N	
694	\N	\N	\N	
695	\N	\N	\N	
696	\N	\N	\N	
697	\N	\N	\N	
698	\N	\N	\N	
699	\N	\N	\N	
700	\N	\N	\N	
701	\N	\N	\N	
702	\N	\N	\N	
703	\N	\N	\N	
704	\N	\N	\N	
705	\N	\N	\N	
706	\N	\N	\N	
707	\N	\N	\N	
708	\N	\N	\N	
709	\N	\N	\N	
710	\N	\N	\N	
711	\N	\N	\N	
712	\N	\N	\N	
713	\N	\N	\N	
714	\N	\N	\N	
715	\N	\N	\N	
716	\N	\N	\N	
717	\N	\N	\N	
718	\N	\N	\N	
719	\N	\N	\N	
720	\N	\N	\N	
721	\N	\N	\N	
722	\N	\N	\N	
723	\N	\N	\N	
724	\N	\N	\N	
725	\N	\N	\N	
726	\N	\N	\N	
727	\N	\N	\N	
728	\N	\N	\N	
729	\N	\N	\N	
730	\N	\N	\N	
731	\N	\N	\N	
732	\N	\N	\N	
733	\N	\N	\N	
734	\N	\N	\N	
735	\N	\N	\N	
736	\N	\N	\N	
737	\N	\N	\N	
738	\N	\N	\N	
739	\N	\N	\N	
740	\N	\N	\N	
741	\N	\N	\N	
742	\N	\N	\N	
743	\N	\N	\N	
744	\N	\N	\N	
745	\N	\N	\N	
746	\N	\N	\N	
747	\N	\N	\N	
748	\N	\N	\N	
749	\N	\N	\N	
750	\N	\N	\N	
751	\N	\N	\N	
752	\N	\N	\N	
753	\N	\N	\N	
754	\N	\N	\N	
755	\N	\N	\N	
756	\N	\N	\N	
757	\N	\N	\N	
758	\N	\N	\N	
759	\N	\N	\N	
760	\N	\N	\N	
761	\N	\N	\N	
762	\N	\N	\N	
763	\N	\N	\N	
764	\N	\N	\N	
765	\N	\N	\N	
766	\N	\N	\N	
767	\N	\N	\N	
768	\N	\N	\N	
769	\N	\N	\N	
770	\N	\N	\N	
771	\N	\N	\N	
772	\N	\N	\N	
773	\N	\N	\N	
774	\N	\N	\N	
775	\N	\N	\N	
776	\N	\N	\N	
777	\N	\N	\N	
778	\N	\N	\N	
779	\N	\N	\N	
780	\N	\N	\N	
781	\N	\N	\N	
782	\N	\N	\N	
783	\N	\N	\N	
784	\N	\N	\N	
785	\N	\N	\N	
786	\N	\N	\N	
787	\N	\N	\N	
788	\N	\N	\N	
789	\N	\N	\N	
790	\N	\N	\N	
791	\N	\N	\N	
792	\N	\N	\N	
793	\N	\N	\N	
794	\N	\N	\N	
795	\N	\N	\N	
796	\N	\N	\N	
797	\N	\N	\N	
798	\N	\N	\N	
799	\N	\N	\N	
800	\N	\N	\N	
801	\N	\N	\N	
802	\N	\N	\N	
803	\N	\N	\N	
804	\N	\N	\N	
805	\N	\N	\N	
806	\N	\N	\N	
807	\N	\N	\N	
808	\N	\N	\N	
809	\N	\N	\N	
810	\N	\N	\N	
811	\N	\N	\N	
812	\N	\N	\N	
813	\N	\N	\N	
814	\N	\N	\N	
815	\N	\N	\N	
816	\N	\N	\N	
817	\N	\N	\N	
818	\N	\N	\N	
819	\N	\N	\N	
820	\N	\N	\N	
821	\N	\N	\N	
822	\N	\N	\N	
823	\N	\N	\N	
824	\N	\N	\N	
825	\N	\N	\N	
826	\N	\N	\N	
827	\N	\N	\N	
828	\N	\N	\N	
829	\N	\N	\N	
830	\N	\N	\N	
831	\N	\N	\N	
832	\N	\N	\N	
833	\N	\N	\N	
834	\N	\N	\N	
835	\N	\N	\N	
836	\N	\N	\N	
837	\N	\N	\N	
838	\N	\N	\N	
839	\N	\N	\N	
840	\N	\N	\N	
841	\N	\N	\N	
842	\N	\N	\N	
843	\N	\N	\N	
844	\N	\N	\N	
845	\N	\N	\N	
846	\N	\N	\N	
847	\N	\N	\N	
848	\N	\N	\N	
849	\N	\N	\N	
850	\N	\N	\N	
851	\N	\N	\N	
852	\N	\N	\N	
853	\N	\N	\N	
854	\N	\N	\N	
855	\N	\N	\N	
856	\N	\N	\N	
857	\N	\N	\N	
858	\N	\N	\N	
859	\N	\N	\N	
860	\N	\N	\N	
861	\N	\N	\N	
862	\N	\N	\N	
863	\N	\N	\N	
864	\N	\N	\N	
865	\N	\N	\N	
866	\N	\N	\N	
867	\N	\N	\N	
868	\N	\N	\N	
869	\N	\N	\N	
870	\N	\N	\N	
871	\N	\N	\N	
872	\N	\N	\N	
873	\N	\N	\N	
874	\N	\N	\N	
875	\N	\N	\N	
876	\N	\N	\N	
877	\N	\N	\N	
878	\N	\N	\N	
879	\N	\N	\N	
880	\N	\N	\N	
881	\N	\N	\N	
882	\N	\N	\N	
883	\N	\N	\N	
884	\N	\N	\N	
885	\N	\N	\N	
886	\N	\N	\N	
887	\N	\N	\N	
888	\N	\N	\N	
889	\N	\N	\N	
890	\N	\N	\N	
891	\N	\N	\N	
892	\N	\N	\N	
893	\N	\N	\N	
894	\N	\N	\N	
895	\N	\N	\N	
896	\N	\N	\N	
897	\N	\N	\N	
898	\N	\N	\N	
899	\N	\N	\N	
900	\N	\N	\N	
901	\N	\N	\N	
902	\N	\N	\N	
903	\N	\N	\N	
904	\N	\N	\N	
905	\N	\N	\N	
906	\N	\N	\N	
907	\N	\N	\N	
908	\N	\N	\N	
909	\N	\N	\N	
910	\N	\N	\N	
911	\N	\N	\N	
912	\N	\N	\N	
913	\N	\N	\N	
914	\N	\N	\N	
915	\N	\N	\N	
916	\N	\N	\N	
917	\N	\N	\N	
918	\N	\N	\N	
919	\N	\N	\N	
920	\N	\N	\N	
921	\N	\N	\N	
922	\N	\N	\N	
923	\N	\N	\N	
924	\N	\N	\N	
925	\N	\N	\N	
926	\N	\N	\N	
927	\N	\N	\N	
928	\N	\N	\N	
929	\N	\N	\N	
930	\N	\N	\N	
931	\N	\N	\N	
932	\N	\N	\N	
933	\N	\N	\N	
934	\N	\N	\N	
935	\N	\N	\N	
936	\N	\N	\N	
937	\N	\N	\N	
938	\N	\N	\N	
939	\N	\N	\N	
940	\N	\N	\N	
941	\N	\N	\N	
942	\N	\N	\N	
943	\N	\N	\N	
944	\N	\N	\N	
945	\N	\N	\N	
946	\N	\N	\N	
947	\N	\N	\N	
948	\N	\N	\N	
949	\N	\N	\N	
950	\N	\N	\N	
951	\N	\N	\N	
952	\N	\N	\N	
953	\N	\N	\N	
954	\N	\N	\N	
955	\N	\N	\N	
956	\N	\N	\N	
957	\N	\N	\N	
958	\N	\N	\N	
959	\N	\N	\N	
960	\N	\N	\N	
961	\N	\N	\N	
962	\N	\N	\N	
963	\N	\N	\N	
964	\N	\N	\N	
965	\N	\N	\N	
966	\N	\N	\N	
967	\N	\N	\N	
968	\N	\N	\N	
969	\N	\N	\N	
970	\N	\N	\N	
971	\N	\N	\N	
972	\N	\N	\N	
973	\N	\N	\N	
974	\N	\N	\N	
975	\N	\N	\N	
976	\N	\N	\N	
977	\N	\N	\N	
978	\N	\N	\N	
979	\N	\N	\N	
980	\N	\N	\N	
981	\N	\N	\N	
982	\N	\N	\N	
983	\N	\N	\N	
984	\N	\N	\N	
985	\N	\N	\N	
986	\N	\N	\N	
987	\N	\N	\N	
988	\N	\N	\N	
989	\N	\N	\N	
990	\N	\N	\N	
991	\N	\N	\N	
992	\N	\N	\N	
993	\N	\N	\N	
994	\N	\N	\N	
995	\N	\N	\N	
996	\N	\N	\N	
997	\N	\N	\N	
998	\N	\N	\N	
999	\N	\N	\N	
1000	\N	\N	\N	
1001	\N	\N	\N	
1002	\N	\N	\N	
1003	\N	\N	\N	
1004	\N	\N	\N	
1005	\N	\N	\N	
1006	\N	\N	\N	
1007	\N	\N	\N	
1008	\N	\N	\N	
1009	\N	\N	\N	
1010	\N	\N	\N	
1011	\N	\N	\N	
1012	\N	\N	\N	
1013	\N	\N	\N	
1014	\N	\N	\N	
1015	\N	\N	\N	
1016	\N	\N	\N	
1017	\N	\N	\N	
1018	\N	\N	\N	
1019	\N	\N	\N	
1020	\N	\N	\N	
1021	\N	\N	\N	
1022	\N	\N	\N	
1023	\N	\N	\N	
1024	\N	\N	\N	
1025	\N	\N	\N	
1026	\N	\N	\N	
1027	\N	\N	\N	
1028	\N	\N	\N	
1029	\N	\N	\N	
1030	\N	\N	\N	
1031	\N	\N	\N	
1032	\N	\N	\N	
1033	\N	\N	\N	
1034	\N	\N	\N	
1035	\N	\N	\N	
1036	\N	\N	\N	
1037	\N	\N	\N	
1038	\N	\N	\N	
1039	\N	\N	\N	
1040	\N	\N	\N	
1041	\N	\N	\N	
1042	\N	\N	\N	
1043	\N	\N	\N	
1044	\N	\N	\N	
1045	\N	\N	\N	
1046	\N	\N	\N	
1047	\N	\N	\N	
1048	\N	\N	\N	
1049	\N	\N	\N	
1050	\N	\N	\N	
1051	\N	\N	\N	
1052	\N	\N	\N	
1053	\N	\N	\N	
1054	\N	\N	\N	
1055	\N	\N	\N	
1056	\N	\N	\N	
1057	\N	\N	\N	
1058	\N	\N	\N	
1059	\N	\N	\N	
1060	\N	\N	\N	
1061	\N	\N	\N	
1062	\N	\N	\N	
1063	\N	\N	\N	
1064	\N	\N	\N	
1065	\N	\N	\N	
1066	\N	\N	\N	
1067	\N	\N	\N	
1068	\N	\N	\N	
1069	\N	\N	\N	
1070	\N	\N	\N	
1071	\N	\N	\N	
1072	\N	\N	\N	
1073	\N	\N	\N	
1074	\N	\N	\N	
1075	\N	\N	\N	
1076	\N	\N	\N	
1077	\N	\N	\N	
1078	\N	\N	\N	
1079	\N	\N	\N	
1080	\N	\N	\N	
1081	\N	\N	\N	
1082	\N	\N	\N	
1083	\N	\N	\N	
1084	\N	\N	\N	
1085	\N	\N	\N	
1086	\N	\N	\N	
1087	\N	\N	\N	
1088	\N	\N	\N	
1089	\N	\N	\N	
1090	\N	\N	\N	
1091	\N	\N	\N	
1092	\N	\N	\N	
1093	\N	\N	\N	
1094	\N	\N	\N	
1095	\N	\N	\N	
1096	\N	\N	\N	
1097	\N	\N	\N	
1098	\N	\N	\N	
1099	\N	\N	\N	
1100	\N	\N	\N	
1101	\N	\N	\N	
1102	\N	\N	\N	
1103	\N	\N	\N	
1104	\N	\N	\N	
1105	\N	\N	\N	
1106	\N	\N	\N	
1107	\N	\N	\N	
1108	\N	\N	\N	
1109	\N	\N	\N	
1110	\N	\N	\N	
1111	\N	\N	\N	
1112	\N	\N	\N	
1113	\N	\N	\N	
1114	\N	\N	\N	
1115	\N	\N	\N	
1116	\N	\N	\N	
1117	\N	\N	\N	
1118	\N	\N	\N	
1119	\N	\N	\N	
1120	\N	\N	\N	
1121	\N	\N	\N	
1122	\N	\N	\N	
1123	\N	\N	\N	
1124	\N	\N	\N	
1125	\N	\N	\N	
1126	\N	\N	\N	
1127	\N	\N	\N	
1128	\N	\N	\N	
1129	\N	\N	\N	
1130	\N	\N	\N	
1131	\N	\N	\N	
1132	\N	\N	\N	
1133	\N	\N	\N	
1134	\N	\N	\N	
1135	\N	\N	\N	
1136	\N	\N	\N	
1137	\N	\N	\N	
1138	\N	\N	\N	
1139	\N	\N	\N	
1140	\N	\N	\N	
1141	\N	\N	\N	
1142	\N	\N	\N	
1143	\N	\N	\N	
1144	\N	\N	\N	
1145	\N	\N	\N	
1146	\N	\N	\N	
1147	\N	\N	\N	
1148	\N	\N	\N	
1149	\N	\N	\N	
1150	\N	\N	\N	
1151	\N	\N	\N	
1152	\N	\N	\N	
1153	\N	\N	\N	
1154	\N	\N	\N	
1155	\N	\N	\N	
1156	\N	\N	\N	
1157	\N	\N	\N	
1158	\N	\N	\N	
1159	\N	\N	\N	
1160	\N	\N	\N	
1161	\N	\N	\N	
1162	\N	\N	\N	
1163	\N	\N	\N	
1164	\N	\N	\N	
1165	\N	\N	\N	
1166	\N	\N	\N	
1167	\N	\N	\N	
1168	\N	\N	\N	
1169	\N	\N	\N	
1170	\N	\N	\N	
1171	\N	\N	\N	
1172	\N	\N	\N	
1173	\N	\N	\N	
1174	\N	\N	\N	
1175	\N	\N	\N	
1176	\N	\N	\N	
1177	\N	\N	\N	
1178	\N	\N	\N	
1179	\N	\N	\N	
1180	\N	\N	\N	
1181	\N	\N	\N	
1182	\N	\N	\N	
1183	\N	\N	\N	
1184	\N	\N	\N	
1185	\N	\N	\N	
1186	\N	\N	\N	
1187	\N	\N	\N	
1188	\N	\N	\N	
1189	\N	\N	\N	
1190	\N	\N	\N	
1191	\N	\N	\N	
1192	\N	\N	\N	
1193	\N	\N	\N	
1194	\N	\N	\N	
1195	\N	\N	\N	
1196	\N	\N	\N	
1197	\N	\N	\N	
1198	\N	\N	\N	
1199	\N	\N	\N	
1200	\N	\N	\N	
1201	\N	\N	\N	
1202	\N	\N	\N	
1203	\N	\N	\N	
1204	\N	\N	\N	
1205	\N	\N	\N	
1206	\N	\N	\N	
1207	\N	\N	\N	
1208	\N	\N	\N	
1209	\N	\N	\N	
1210	\N	\N	\N	
1211	\N	\N	\N	
1212	\N	\N	\N	
1213	\N	\N	\N	
1214	\N	\N	\N	
1215	\N	\N	\N	
1216	\N	\N	\N	
1217	\N	\N	\N	
1218	\N	\N	\N	
1219	\N	\N	\N	
1220	\N	\N	\N	
1221	\N	\N	\N	
1222	\N	\N	\N	
1223	\N	\N	\N	
1224	\N	\N	\N	
1225	\N	\N	\N	
1226	\N	\N	\N	
1227	\N	\N	\N	
1228	\N	\N	\N	
1229	\N	\N	\N	
1230	\N	\N	\N	
1231	\N	\N	\N	
1232	\N	\N	\N	
1233	\N	\N	\N	
1234	\N	\N	\N	
1235	\N	\N	\N	
1236	\N	\N	\N	
1237	\N	\N	\N	
1238	\N	\N	\N	
1239	\N	\N	\N	
1240	\N	\N	\N	
1241	\N	\N	\N	
1242	\N	\N	\N	
1243	\N	\N	\N	
1244	\N	\N	\N	
1245	\N	\N	\N	
1246	\N	\N	\N	
1247	\N	\N	\N	
1248	\N	\N	\N	
1249	\N	\N	\N	
1250	\N	\N	\N	
1251	\N	\N	\N	
1252	\N	\N	\N	
1253	\N	\N	\N	
1254	\N	\N	\N	
1255	\N	\N	\N	
1256	\N	\N	\N	
1257	\N	\N	\N	
1258	\N	\N	\N	
1259	\N	\N	\N	
1260	\N	\N	\N	
1261	\N	\N	\N	
1262	\N	\N	\N	
1263	\N	\N	\N	
1264	\N	\N	\N	
1265	\N	\N	\N	
1266	\N	\N	\N	
1267	\N	\N	\N	
1268	\N	\N	\N	
1269	\N	\N	\N	
1270	\N	\N	\N	
1271	\N	\N	\N	
1272	\N	\N	\N	
1273	\N	\N	\N	
1274	\N	\N	\N	
1275	\N	\N	\N	
1276	\N	\N	\N	
1277	\N	\N	\N	
1278	\N	\N	\N	
1279	\N	\N	\N	
1280	\N	\N	\N	
1281	\N	\N	\N	
1282	\N	\N	\N	
1283	\N	\N	\N	
1284	\N	\N	\N	
1285	\N	\N	\N	
1286	\N	\N	\N	
1287	\N	\N	\N	
1288	\N	\N	\N	
1289	\N	\N	\N	
1290	\N	\N	\N	
1291	\N	\N	\N	
1292	\N	\N	\N	
1293	\N	\N	\N	
1294	\N	\N	\N	
1295	\N	\N	\N	
1296	\N	\N	\N	
1297	\N	\N	\N	
1298	\N	\N	\N	
1299	\N	\N	\N	
1300	\N	\N	\N	
1301	\N	\N	\N	
1302	\N	\N	\N	
1303	\N	\N	\N	
1304	\N	\N	\N	
1305	\N	\N	\N	
1306	\N	\N	\N	
1307	\N	\N	\N	
1308	\N	\N	\N	
1309	\N	\N	\N	
1310	\N	\N	\N	
1311	\N	\N	\N	
1312	\N	\N	\N	
1313	\N	\N	\N	
1314	\N	\N	\N	
1315	\N	\N	\N	
1316	\N	\N	\N	
1317	\N	\N	\N	
1318	\N	\N	\N	
1319	\N	\N	\N	
1320	\N	\N	\N	
1321	\N	\N	\N	
1322	\N	\N	\N	
1323	\N	\N	\N	
1324	\N	\N	\N	
1325	\N	\N	\N	
1326	\N	\N	\N	
1327	\N	\N	\N	
1328	\N	\N	\N	
1329	\N	\N	\N	
1330	\N	\N	\N	
1331	\N	\N	\N	
1332	\N	\N	\N	
1333	\N	\N	\N	
1334	\N	\N	\N	
1335	\N	\N	\N	
1336	\N	\N	\N	
1337	\N	\N	\N	
1338	\N	\N	\N	
1339	\N	\N	\N	
1340	\N	\N	\N	
1341	\N	\N	\N	
1342	\N	\N	\N	
1343	\N	\N	\N	
1344	\N	\N	\N	
1345	\N	\N	\N	
1346	\N	\N	\N	
1347	\N	\N	\N	
1348	\N	\N	\N	
1349	\N	\N	\N	
1350	\N	\N	\N	
1351	\N	\N	\N	
1352	\N	\N	\N	
1353	\N	\N	\N	
1354	\N	\N	\N	
1355	\N	\N	\N	
1356	\N	\N	\N	
1357	\N	\N	\N	
1358	\N	\N	\N	
1359	\N	\N	\N	
1360	\N	\N	\N	
1361	\N	\N	\N	
1362	\N	\N	\N	
1363	\N	\N	\N	
1364	\N	\N	\N	
1365	\N	\N	\N	
1366	\N	\N	\N	
1367	\N	\N	\N	
1368	\N	\N	\N	
1369	\N	\N	\N	
1370	\N	\N	\N	
1371	\N	\N	\N	
1372	\N	\N	\N	
1373	\N	\N	\N	
1374	\N	\N	\N	
1375	\N	\N	\N	
1376	\N	\N	\N	
1377	\N	\N	\N	
1378	\N	\N	\N	
1379	\N	\N	\N	
1380	\N	\N	\N	
1381	\N	\N	\N	
1382	\N	\N	\N	
1383	\N	\N	\N	
1384	\N	\N	\N	
1385	\N	\N	\N	
1386	\N	\N	\N	
1387	\N	\N	\N	
1388	\N	\N	\N	
1389	\N	\N	\N	
1390	\N	\N	\N	
1391	\N	\N	\N	
1392	\N	\N	\N	
1393	\N	\N	\N	
1394	\N	\N	\N	
1395	\N	\N	\N	
1396	\N	\N	\N	
1397	\N	\N	\N	
1398	\N	\N	\N	
1399	\N	\N	\N	
1400	\N	\N	\N	
1401	\N	\N	\N	
1402	\N	\N	\N	
1403	\N	\N	\N	
1404	\N	\N	\N	
1405	\N	\N	\N	
1406	\N	\N	\N	
1407	\N	\N	\N	
1408	\N	\N	\N	
1409	\N	\N	\N	
1410	\N	\N	\N	
1411	\N	\N	\N	
1412	\N	\N	\N	
1413	\N	\N	\N	
1414	\N	\N	\N	
1415	\N	\N	\N	
1416	\N	\N	\N	
1417	\N	\N	\N	
1418	\N	\N	\N	
1419	\N	\N	\N	
1420	\N	\N	\N	
1421	\N	\N	\N	
1422	\N	\N	\N	
1423	\N	\N	\N	
1424	\N	\N	\N	
1425	\N	\N	\N	
1426	\N	\N	\N	
1427	\N	\N	\N	
1428	\N	\N	\N	
1429	\N	\N	\N	
1430	\N	\N	\N	
1431	\N	\N	\N	
1432	\N	\N	\N	
1433	\N	\N	\N	
1434	\N	\N	\N	
1435	\N	\N	\N	
1436	\N	\N	\N	
1437	\N	\N	\N	
1438	\N	\N	\N	
1439	\N	\N	\N	
1440	\N	\N	\N	
1441	\N	\N	\N	
1442	\N	\N	\N	
1443	\N	\N	\N	
1444	\N	\N	\N	
1445	\N	\N	\N	
1446	\N	\N	\N	
1447	\N	\N	\N	
1448	\N	\N	\N	
1449	\N	\N	\N	
1450	\N	\N	\N	
1451	\N	\N	\N	
1452	\N	\N	\N	
1453	\N	\N	\N	
1454	\N	\N	\N	
1455	\N	\N	\N	
1456	\N	\N	\N	
1457	\N	\N	\N	
1458	\N	\N	\N	
1459	\N	\N	\N	
1460	\N	\N	\N	
1461	\N	\N	\N	
1462	\N	\N	\N	
1463	\N	\N	\N	
1464	\N	\N	\N	
1465	\N	\N	\N	
1466	\N	\N	\N	
1467	\N	\N	\N	
1468	\N	\N	\N	
1469	\N	\N	\N	
1470	\N	\N	\N	
1471	\N	\N	\N	
1472	\N	\N	\N	
1473	\N	\N	\N	
1474	\N	\N	\N	
1475	\N	\N	\N	
1476	\N	\N	\N	
1477	\N	\N	\N	
1478	\N	\N	\N	
1479	\N	\N	\N	
1480	\N	\N	\N	
1481	\N	\N	\N	
1482	\N	\N	\N	
1483	\N	\N	\N	
1484	\N	\N	\N	
1485	\N	\N	\N	
1486	\N	\N	\N	
1487	\N	\N	\N	
1488	\N	\N	\N	
1489	\N	\N	\N	
1490	\N	\N	\N	
1491	\N	\N	\N	
1492	\N	\N	\N	
1493	\N	\N	\N	
1494	\N	\N	\N	
1495	\N	\N	\N	
1496	\N	\N	\N	
1497	\N	\N	\N	
1498	\N	\N	\N	
1499	\N	\N	\N	
1500	\N	\N	\N	
1501	\N	\N	\N	
1502	\N	\N	\N	
1503	\N	\N	\N	
1504	\N	\N	\N	
1505	\N	\N	\N	
1506	\N	\N	\N	
1507	\N	\N	\N	
1508	\N	\N	\N	
1509	\N	\N	\N	
1510	\N	\N	\N	
1511	\N	\N	\N	
1512	\N	\N	\N	
1513	\N	\N	\N	
1514	\N	\N	\N	
1515	\N	\N	\N	
1516	\N	\N	\N	
1517	\N	\N	\N	
1518	\N	\N	\N	
1519	\N	\N	\N	
1520	\N	\N	\N	
1521	\N	\N	\N	
1522	\N	\N	\N	
1523	\N	\N	\N	
1524	\N	\N	\N	
1525	\N	\N	\N	
1526	\N	\N	\N	
1527	\N	\N	\N	
1528	\N	\N	\N	
1529	\N	\N	\N	
1530	\N	\N	\N	
1531	\N	\N	\N	
1532	\N	\N	\N	
1533	\N	\N	\N	
1534	\N	\N	\N	
1535	\N	\N	\N	
1536	\N	\N	\N	
1537	\N	\N	\N	
1538	\N	\N	\N	
1539	\N	\N	\N	
1540	\N	\N	\N	
1541	\N	\N	\N	
1542	\N	\N	\N	
1543	\N	\N	\N	
1544	\N	\N	\N	
1545	\N	\N	\N	
1546	\N	\N	\N	
1547	\N	\N	\N	
1548	\N	\N	\N	
1549	\N	\N	\N	
1550	\N	\N	\N	
1551	\N	\N	\N	
1552	\N	\N	\N	
1553	\N	\N	\N	
1554	\N	\N	\N	
1555	\N	\N	\N	
1556	\N	\N	\N	
1557	\N	\N	\N	
1558	\N	\N	\N	
1559	\N	\N	\N	
1560	\N	\N	\N	
1561	\N	\N	\N	
1562	\N	\N	\N	
1563	\N	\N	\N	
1564	\N	\N	\N	
1565	\N	\N	\N	
1566	\N	\N	\N	
1567	\N	\N	\N	
1568	\N	\N	\N	
1569	\N	\N	\N	
1570	\N	\N	\N	
1571	\N	\N	\N	
1572	\N	\N	\N	
1573	\N	\N	\N	
1574	\N	\N	\N	
1575	\N	\N	\N	
1576	\N	\N	\N	
1577	\N	\N	\N	
1578	\N	\N	\N	
1579	\N	\N	\N	
1580	\N	\N	\N	
1581	\N	\N	\N	
1582	\N	\N	\N	
1583	\N	\N	\N	
1584	\N	\N	\N	
1585	\N	\N	\N	
1586	\N	\N	\N	
1623	\N	\N	\N	
1624	\N	\N	\N	
1625	\N	\N	\N	
1626	\N	\N	\N	
1627	\N	\N	\N	
1628	\N	\N	\N	
1629	\N	\N	\N	
1630	\N	\N	\N	
1631	\N	\N	\N	
1632	\N	\N	\N	
1633	\N	\N	\N	
1634	\N	\N	\N	
1635	\N	\N	\N	
1636	\N	\N	\N	
1637	\N	\N	\N	
1638	\N	\N	\N	
1639	\N	\N	\N	
1640	\N	\N	\N	
1641	\N	\N	\N	
1642	\N	\N	\N	
1643	\N	\N	\N	
1644	\N	\N	\N	
1645	\N	\N	\N	
1646	\N	\N	\N	
1647	\N	\N	\N	
1648	\N	\N	\N	
1649	\N	\N	\N	
1650	\N	\N	\N	
1651	\N	\N	\N	
1652	\N	\N	\N	
1653	\N	\N	\N	
1654	\N	\N	\N	
1655	\N	\N	\N	
1656	\N	\N	\N	
1657	\N	\N	\N	
1658	\N	\N	\N	
1659	\N	\N	\N	
1660	\N	\N	\N	
1661	\N	\N	\N	
1662	\N	\N	\N	
1663	\N	\N	\N	
1664	\N	\N	\N	
1665	\N	\N	\N	
1666	\N	\N	\N	
1667	\N	\N	\N	
1668	\N	\N	\N	
1669	\N	\N	\N	
1670	\N	\N	\N	
1671	\N	\N	\N	
1672	\N	\N	\N	
1673	\N	\N	\N	
1674	\N	\N	\N	
1675	\N	\N	\N	
1676	\N	\N	\N	
1677	\N	\N	\N	
1678	\N	\N	\N	
1679	\N	\N	\N	
1680	\N	\N	\N	
1681	\N	\N	\N	
1682	\N	\N	\N	
1683	\N	\N	\N	
1684	\N	\N	\N	
1685	\N	\N	\N	
1686	\N	\N	\N	
1687	\N	\N	\N	
1688	\N	\N	\N	
1689	\N	\N	\N	
1690	\N	\N	\N	
1691	\N	\N	\N	
1692	\N	\N	\N	
1693	\N	\N	\N	
1694	\N	\N	\N	
1695	\N	\N	\N	
1696	\N	\N	\N	
1697	\N	\N	\N	
1698	\N	\N	\N	
1699	\N	\N	\N	
1700	\N	\N	\N	
1701	\N	\N	\N	
1702	\N	\N	\N	
1703	\N	\N	\N	
1704	\N	\N	\N	
1705	\N	\N	\N	
1706	\N	\N	\N	
1707	\N	\N	\N	
1708	\N	\N	\N	
1709	\N	\N	\N	
1710	\N	\N	\N	
1711	\N	\N	\N	
1712	\N	\N	\N	
1713	\N	\N	\N	
1714	\N	\N	\N	
1715	\N	\N	\N	
1716	\N	\N	\N	
1717	\N	\N	\N	
1718	\N	\N	\N	
1719	\N	\N	\N	
1720	\N	\N	\N	
1721	\N	\N	\N	
1722	\N	\N	\N	
1723	\N	\N	\N	
1724	\N	\N	\N	
1725	\N	\N	\N	
1726	\N	\N	\N	
1727	\N	\N	\N	
1728	\N	\N	\N	
1729	\N	\N	\N	
1730	\N	\N	\N	
1731	\N	\N	\N	
1732	\N	\N	\N	
1733	\N	\N	\N	
1734	\N	\N	\N	
1735	\N	\N	\N	
1736	\N	\N	\N	
1737	\N	\N	\N	
1738	\N	\N	\N	
1739	\N	\N	\N	
1740	\N	\N	\N	
1741	\N	\N	\N	
1742	\N	\N	\N	
1743	\N	\N	\N	
1744	\N	\N	\N	
1745	\N	\N	\N	
1746	\N	\N	\N	
1747	\N	\N	\N	
1748	\N	\N	\N	
1749	\N	\N	\N	
1750	\N	\N	\N	
1751	\N	\N	\N	
1752	\N	\N	\N	
1753	\N	\N	\N	
1754	\N	\N	\N	
1755	\N	\N	\N	
1756	\N	\N	\N	
1757	\N	\N	\N	
1758	\N	\N	\N	
1759	\N	\N	\N	
1760	\N	\N	\N	
1761	\N	\N	\N	
1762	\N	\N	\N	
1763	\N	\N	\N	
1764	\N	\N	\N	
1765	\N	\N	\N	
1766	\N	\N	\N	
1767	\N	\N	\N	
1768	\N	\N	\N	
1769	\N	\N	\N	
1770	\N	\N	\N	
1771	\N	\N	\N	
1772	\N	\N	\N	
1773	\N	\N	\N	
1774	\N	\N	\N	
1775	\N	\N	\N	
1776	\N	\N	\N	
1777	\N	\N	\N	
1778	\N	\N	\N	
1779	\N	\N	\N	
1780	\N	\N	\N	
1781	\N	\N	\N	
1782	\N	\N	\N	
1783	\N	\N	\N	
1784	\N	\N	\N	
1785	\N	\N	\N	
1786	\N	\N	\N	
1787	\N	\N	\N	
1788	\N	\N	\N	
1789	\N	\N	\N	
1790	\N	\N	\N	
1791	\N	\N	\N	
1792	\N	\N	\N	
1793	\N	\N	\N	
1794	\N	\N	\N	
1795	\N	\N	\N	
1796	\N	\N	\N	
1797	\N	\N	\N	
1798	\N	\N	\N	
1799	\N	\N	\N	
1800	\N	\N	\N	
1801	\N	\N	\N	
1802	\N	\N	\N	
1803	\N	\N	\N	
1804	\N	\N	\N	
1805	\N	\N	\N	
1806	\N	\N	\N	
1807	\N	\N	\N	
1808	\N	\N	\N	
1809	\N	\N	\N	
1810	\N	\N	\N	
1811	\N	\N	\N	
1812	\N	\N	\N	
1813	\N	\N	\N	
1814	\N	\N	\N	
1815	\N	\N	\N	
1816	\N	\N	\N	
1817	\N	\N	\N	
1818	\N	\N	\N	
1819	\N	\N	\N	
1820	\N	\N	\N	
1821	\N	\N	\N	
1822	\N	\N	\N	
1823	\N	\N	\N	
1824	\N	\N	\N	
1825	\N	\N	\N	
1826	\N	\N	\N	
1827	\N	\N	\N	
1828	\N	\N	\N	
1829	\N	\N	\N	
1830	\N	\N	\N	
1831	\N	\N	\N	
1832	\N	\N	\N	
1833	\N	\N	\N	
1834	\N	\N	\N	
1835	\N	\N	\N	
1836	\N	\N	\N	
1837	\N	\N	\N	
1838	\N	\N	\N	
1839	\N	\N	\N	
1840	\N	\N	\N	
1841	\N	\N	\N	
1842	\N	\N	\N	
1843	\N	\N	\N	
1844	\N	\N	\N	
1845	\N	\N	\N	
1846	\N	\N	\N	
1847	\N	\N	\N	
1848	\N	\N	\N	
1849	\N	\N	\N	
1850	\N	\N	\N	
1851	\N	\N	\N	
1852	\N	\N	\N	
1853	\N	\N	\N	
1854	\N	\N	\N	
1855	\N	\N	\N	
1856	\N	\N	\N	
1857	\N	\N	\N	
1858	\N	\N	\N	
1859	\N	\N	\N	
1860	\N	\N	\N	
1861	\N	\N	\N	
1862	\N	\N	\N	
1863	\N	\N	\N	
1864	\N	\N	\N	
1865	\N	\N	\N	
1866	\N	\N	\N	
1867	\N	\N	\N	
1868	\N	\N	\N	
1869	\N	\N	\N	
1870	\N	\N	\N	
1871	\N	\N	\N	
1872	\N	\N	\N	
1873	\N	\N	\N	
1874	\N	\N	\N	
1875	\N	\N	\N	
1876	\N	\N	\N	
1877	\N	\N	\N	
1878	\N	\N	\N	
1879	\N	\N	\N	
1880	\N	\N	\N	
1881	\N	\N	\N	
1882	\N	\N	\N	
1883	\N	\N	\N	
1884	\N	\N	\N	
1885	\N	\N	\N	
1886	\N	\N	\N	
1887	\N	\N	\N	
1888	\N	\N	\N	
1889	\N	\N	\N	
1890	\N	\N	\N	
1891	\N	\N	\N	
1892	\N	\N	\N	
1893	\N	\N	\N	
1894	\N	\N	\N	
1895	\N	\N	\N	
1896	\N	\N	\N	
1897	\N	\N	\N	
1898	\N	\N	\N	
1899	\N	\N	\N	
1900	\N	\N	\N	
1901	\N	\N	\N	
1902	\N	\N	\N	
1903	\N	\N	\N	
1904	\N	\N	\N	
1905	\N	\N	\N	
1906	\N	\N	\N	
1907	\N	\N	\N	
1908	\N	\N	\N	
1909	\N	\N	\N	
1910	\N	\N	\N	
1911	\N	\N	\N	
1912	\N	\N	\N	
1913	\N	\N	\N	
1914	\N	\N	\N	
1915	\N	\N	\N	
1916	\N	\N	\N	
1917	\N	\N	\N	
1918	\N	\N	\N	
1919	\N	\N	\N	
1920	\N	\N	\N	
1921	\N	\N	\N	
1922	\N	\N	\N	
1923	\N	\N	\N	
1924	\N	\N	\N	
1925	\N	\N	\N	
1926	\N	\N	\N	
1927	\N	\N	\N	
1928	\N	\N	\N	
1929	\N	\N	\N	
1930	\N	\N	\N	
1931	\N	\N	\N	
1932	\N	\N	\N	
1933	\N	\N	\N	
1934	\N	\N	\N	
1935	\N	\N	\N	
1936	\N	\N	\N	
1937	\N	\N	\N	
1938	\N	\N	\N	
1939	\N	\N	\N	
1940	\N	\N	\N	
1941	\N	\N	\N	
1942	\N	\N	\N	
1943	\N	\N	\N	
1944	\N	\N	\N	
1945	\N	\N	\N	
1946	\N	\N	\N	
1947	\N	\N	\N	
1948	\N	\N	\N	
1949	\N	\N	\N	
1950	\N	\N	\N	
1951	\N	\N	\N	
1952	\N	\N	\N	
1953	\N	\N	\N	
1954	\N	\N	\N	
1955	\N	\N	\N	
1956	\N	\N	\N	
1957	\N	\N	\N	
1958	\N	\N	\N	
1959	\N	\N	\N	
1960	\N	\N	\N	
1961	\N	\N	\N	
1962	\N	\N	\N	
1963	\N	\N	\N	
1964	\N	\N	\N	
1965	\N	\N	\N	
1966	\N	\N	\N	
1967	\N	\N	\N	
1968	\N	\N	\N	
1969	\N	\N	\N	
1970	\N	\N	\N	
1971	\N	\N	\N	
1972	\N	\N	\N	
1973	\N	\N	\N	
1974	\N	\N	\N	
1975	\N	\N	\N	
1976	\N	\N	\N	
1977	\N	\N	\N	
1978	\N	\N	\N	
1979	\N	\N	\N	
1980	\N	\N	\N	
1981	\N	\N	\N	
1982	\N	\N	\N	
1983	\N	\N	\N	
1984	\N	\N	\N	
1985	\N	\N	\N	
1986	\N	\N	\N	
1987	\N	\N	\N	
1988	\N	\N	\N	
1989	\N	\N	\N	
1990	\N	\N	\N	
1991	\N	\N	\N	
1992	\N	\N	\N	
1993	\N	\N	\N	
1994	\N	\N	\N	
1995	\N	\N	\N	
1996	\N	\N	\N	
1997	\N	\N	\N	
1998	\N	\N	\N	
1999	\N	\N	\N	
2000	\N	\N	\N	
2001	\N	\N	\N	
2002	\N	\N	\N	
2003	\N	\N	\N	
2004	\N	\N	\N	
2005	\N	\N	\N	
2006	\N	\N	\N	
2007	\N	\N	\N	
2008	\N	\N	\N	
2009	\N	\N	\N	
2010	\N	\N	\N	
2011	\N	\N	\N	
2012	\N	\N	\N	
2013	\N	\N	\N	
2014	\N	\N	\N	
2015	\N	\N	\N	
2016	\N	\N	\N	
2017	\N	\N	\N	
2018	\N	\N	\N	
2019	\N	\N	\N	
2020	\N	\N	\N	
2021	\N	\N	\N	
2022	\N	\N	\N	
2023	\N	\N	\N	
2024	\N	\N	\N	
2025	\N	\N	\N	
2026	\N	\N	\N	
2027	\N	\N	\N	
2028	\N	\N	\N	
2029	\N	\N	\N	
2030	\N	\N	\N	
2031	\N	\N	\N	
2032	\N	\N	\N	
2033	\N	\N	\N	
2034	\N	\N	\N	
2035	\N	\N	\N	
2036	\N	\N	\N	
2037	\N	\N	\N	
2038	\N	\N	\N	
2039	\N	\N	\N	
2040	\N	\N	\N	
2041	\N	\N	\N	
2042	\N	\N	\N	
2043	\N	\N	\N	
2044	\N	\N	\N	
2045	\N	\N	\N	
2046	\N	\N	\N	
2047	\N	\N	\N	
2048	\N	\N	\N	
2049	\N	\N	\N	
2050	\N	\N	\N	
2051	\N	\N	\N	
2052	\N	\N	\N	
2053	\N	\N	\N	
2054	\N	\N	\N	
2055	\N	\N	\N	
2056	\N	\N	\N	
2057	\N	\N	\N	
2058	\N	\N	\N	
2059	\N	\N	\N	
2060	\N	\N	\N	
2061	\N	\N	\N	
2062	\N	\N	\N	
2063	\N	\N	\N	
2064	\N	\N	\N	
2065	\N	\N	\N	
2066	\N	\N	\N	
2067	\N	\N	\N	
2068	\N	\N	\N	
2069	\N	\N	\N	
2070	\N	\N	\N	
2071	\N	\N	\N	
2072	\N	\N	\N	
2073	\N	\N	\N	
2074	\N	\N	\N	
2075	\N	\N	\N	
2076	\N	\N	\N	
2077	\N	\N	\N	
2078	\N	\N	\N	
2079	\N	\N	\N	
2080	\N	\N	\N	
2081	\N	\N	\N	
2082	\N	\N	\N	
2083	\N	\N	\N	
2084	\N	\N	\N	
2085	\N	\N	\N	
2086	\N	\N	\N	
2087	\N	\N	\N	
2088	\N	\N	\N	
2089	\N	\N	\N	
2090	\N	\N	\N	
2091	\N	\N	\N	
2092	\N	\N	\N	
2093	\N	\N	\N	
2094	\N	\N	\N	
2095	\N	\N	\N	
2096	\N	\N	\N	
2097	\N	\N	\N	
2098	\N	\N	\N	
2099	\N	\N	\N	
2100	\N	\N	\N	
2101	\N	\N	\N	
2102	\N	\N	\N	
2103	\N	\N	\N	
2104	\N	\N	\N	
2105	\N	\N	\N	
2106	\N	\N	\N	
2107	\N	\N	\N	
2108	\N	\N	\N	
2109	\N	\N	\N	
2110	\N	\N	\N	
2111	\N	\N	\N	
2112	\N	\N	\N	
2113	\N	\N	\N	
2114	\N	\N	\N	
2115	\N	\N	\N	
2116	\N	\N	\N	
2117	\N	\N	\N	
2118	\N	\N	\N	
2119	\N	\N	\N	
2120	\N	\N	\N	
2121	\N	\N	\N	
2122	\N	\N	\N	
2123	\N	\N	\N	
2124	\N	\N	\N	
2125	\N	\N	\N	
2126	\N	\N	\N	
2127	\N	\N	\N	
2128	\N	\N	\N	
2129	\N	\N	\N	
2130	\N	\N	\N	
2131	\N	\N	\N	
2132	\N	\N	\N	
2133	\N	\N	\N	
2134	\N	\N	\N	
2135	\N	\N	\N	
2136	\N	\N	\N	
2137	\N	\N	\N	
2138	\N	\N	\N	
2139	\N	\N	\N	
2140	\N	\N	\N	
2141	\N	\N	\N	
2142	\N	\N	\N	
2143	\N	\N	\N	
2144	\N	\N	\N	
2145	\N	\N	\N	
2146	\N	\N	\N	
2147	\N	\N	\N	
2148	\N	\N	\N	
2149	\N	\N	\N	
2150	\N	\N	\N	
2151	\N	\N	\N	
2152	\N	\N	\N	
2153	\N	\N	\N	
2154	\N	\N	\N	
2155	\N	\N	\N	
2156	\N	\N	\N	
2157	\N	\N	\N	
2158	\N	\N	\N	
2159	\N	\N	\N	
2160	\N	\N	\N	
2161	\N	\N	\N	
2162	\N	\N	\N	
2163	\N	\N	\N	
2164	\N	\N	\N	
2165	\N	\N	\N	
2166	\N	\N	\N	
2167	\N	\N	\N	
2168	\N	\N	\N	
2169	\N	\N	\N	
2170	\N	\N	\N	
2171	\N	\N	\N	
2172	\N	\N	\N	
2173	\N	\N	\N	
2174	\N	\N	\N	
2175	\N	\N	\N	
2176	\N	\N	\N	
2177	\N	\N	\N	
2178	\N	\N	\N	
2179	\N	\N	\N	
2180	\N	\N	\N	
2181	\N	\N	\N	
2182	\N	\N	\N	
2183	\N	\N	\N	
2184	\N	\N	\N	
2185	\N	\N	\N	
2186	\N	\N	\N	
2187	\N	\N	\N	
2188	\N	\N	\N	
2189	\N	\N	\N	
2190	\N	\N	\N	
2191	\N	\N	\N	
2192	\N	\N	\N	
2193	\N	\N	\N	
2194	\N	\N	\N	
2195	\N	\N	\N	
2196	\N	\N	\N	
2197	\N	\N	\N	
2198	\N	\N	\N	
2199	\N	\N	\N	
2200	\N	\N	\N	
2201	\N	\N	\N	
2202	\N	\N	\N	
2203	\N	\N	\N	
2204	\N	\N	\N	
2205	\N	\N	\N	
2206	\N	\N	\N	
2207	\N	\N	\N	
2208	\N	\N	\N	
2209	\N	\N	\N	
2210	\N	\N	\N	
2211	\N	\N	\N	
2212	\N	\N	\N	
2213	\N	\N	\N	
2214	\N	\N	\N	
2215	\N	\N	\N	
2216	\N	\N	\N	
2217	\N	\N	\N	
2218	\N	\N	\N	
2219	\N	\N	\N	
2220	\N	\N	\N	
2221	\N	\N	\N	
2222	\N	\N	\N	
2223	\N	\N	\N	
2224	\N	\N	\N	
2225	\N	\N	\N	
2226	\N	\N	\N	
2227	\N	\N	\N	
2228	\N	\N	\N	
2229	\N	\N	\N	
2230	\N	\N	\N	
2231	\N	\N	\N	
2232	\N	\N	\N	
2233	\N	\N	\N	
2234	\N	\N	\N	
2235	\N	\N	\N	
2236	\N	\N	\N	
2237	\N	\N	\N	
2238	\N	\N	\N	
2239	\N	\N	\N	
2240	\N	\N	\N	
2241	\N	\N	\N	
2242	\N	\N	\N	
2243	\N	\N	\N	
2244	\N	\N	\N	
2245	\N	\N	\N	
2246	\N	\N	\N	
2247	\N	\N	\N	
2248	\N	\N	\N	
2249	\N	\N	\N	
2250	\N	\N	\N	
2251	\N	\N	\N	
2252	\N	\N	\N	
2253	\N	\N	\N	
2254	\N	\N	\N	
2255	\N	\N	\N	
2256	\N	\N	\N	
2257	\N	\N	\N	
2258	\N	\N	\N	
2259	\N	\N	\N	
2260	\N	\N	\N	
2261	\N	\N	\N	
2262	\N	\N	\N	
2263	\N	\N	\N	
2264	\N	\N	\N	
2265	\N	\N	\N	
2266	\N	\N	\N	
2267	\N	\N	\N	
2268	\N	\N	\N	
2269	\N	\N	\N	
2270	\N	\N	\N	
2271	\N	\N	\N	
2272	\N	\N	\N	
2273	\N	\N	\N	
2274	\N	\N	\N	
2275	\N	\N	\N	
2276	\N	\N	\N	
2277	\N	\N	\N	
2278	\N	\N	\N	
2279	\N	\N	\N	
2280	\N	\N	\N	
2281	\N	\N	\N	
2282	\N	\N	\N	
2283	\N	\N	\N	
2284	\N	\N	\N	
2285	\N	\N	\N	
2286	\N	\N	\N	
2287	\N	\N	\N	
2288	\N	\N	\N	
2289	\N	\N	\N	
2290	\N	\N	\N	
2291	\N	\N	\N	
2292	\N	\N	\N	
2293	\N	\N	\N	
2294	\N	\N	\N	
2295	\N	\N	\N	
2296	\N	\N	\N	
2297	\N	\N	\N	
2298	\N	\N	\N	
2299	\N	\N	\N	
2300	\N	\N	\N	
2301	\N	\N	\N	
2302	\N	\N	\N	
2303	\N	\N	\N	
2304	\N	\N	\N	
2305	\N	\N	\N	
2306	\N	\N	\N	
2307	\N	\N	\N	
2308	\N	\N	\N	
2309	\N	\N	\N	
2310	\N	\N	\N	
2311	\N	\N	\N	
2312	\N	\N	\N	
2313	\N	\N	\N	
2314	\N	\N	\N	
2315	\N	\N	\N	
2316	\N	\N	\N	
2317	\N	\N	\N	
2318	\N	\N	\N	
2319	\N	\N	\N	
2320	\N	\N	\N	
2321	\N	\N	\N	
2322	\N	\N	\N	
2323	\N	\N	\N	
2324	\N	\N	\N	
2325	\N	\N	\N	
2326	\N	\N	\N	
2327	\N	\N	\N	
2328	\N	\N	\N	
2329	\N	\N	\N	
2330	\N	\N	\N	
2331	\N	\N	\N	
2332	\N	\N	\N	
2333	\N	\N	\N	
2334	\N	\N	\N	
2335	\N	\N	\N	
2336	\N	\N	\N	
2337	\N	\N	\N	
2338	\N	\N	\N	
2339	\N	\N	\N	
2340	\N	\N	\N	
2341	\N	\N	\N	
2342	\N	\N	\N	
2343	\N	\N	\N	
2344	\N	\N	\N	
2345	\N	\N	\N	
2346	\N	\N	\N	
2347	\N	\N	\N	
2348	\N	\N	\N	
2349	\N	\N	\N	
2350	\N	\N	\N	
2351	\N	\N	\N	
2352	\N	\N	\N	
2353	\N	\N	\N	
2354	\N	\N	\N	
2355	\N	\N	\N	
2356	\N	\N	\N	
2357	\N	\N	\N	
2358	\N	\N	\N	
2359	\N	\N	\N	
2360	\N	\N	\N	
2361	\N	\N	\N	
2362	\N	\N	\N	
2363	\N	\N	\N	
2364	\N	\N	\N	
2365	\N	\N	\N	
2366	\N	\N	\N	
2367	\N	\N	\N	
2368	\N	\N	\N	
2369	\N	\N	\N	
2370	\N	\N	\N	
2371	\N	\N	\N	
2372	\N	\N	\N	
2373	\N	\N	\N	
2374	\N	\N	\N	
2375	\N	\N	\N	
2376	\N	\N	\N	
2377	\N	\N	\N	
2378	\N	\N	\N	
2379	\N	\N	\N	
2380	\N	\N	\N	
2381	\N	\N	\N	
2382	\N	\N	\N	
2383	\N	\N	\N	
2384	\N	\N	\N	
2385	\N	\N	\N	
2386	\N	\N	\N	
2387	\N	\N	\N	
2388	\N	\N	\N	
2389	\N	\N	\N	
2390	\N	\N	\N	
2391	\N	\N	\N	
2392	\N	\N	\N	
2393	\N	\N	\N	
2394	\N	\N	\N	
2395	\N	\N	\N	
2396	\N	\N	\N	
2397	\N	\N	\N	
2398	\N	\N	\N	
2399	\N	\N	\N	
2400	\N	\N	\N	
2401	\N	\N	\N	
2402	\N	\N	\N	
2403	\N	\N	\N	
2404	\N	\N	\N	
2405	\N	\N	\N	
2406	\N	\N	\N	
2407	\N	\N	\N	
2408	\N	\N	\N	
2409	\N	\N	\N	
2410	\N	\N	\N	
2411	\N	\N	\N	
2412	\N	\N	\N	
2413	\N	\N	\N	
2414	\N	\N	\N	
2415	\N	\N	\N	
2416	\N	\N	\N	
2417	\N	\N	\N	
2418	\N	\N	\N	
2419	\N	\N	\N	
2420	\N	\N	\N	
2421	\N	\N	\N	
2422	\N	\N	\N	
2423	\N	\N	\N	
2424	\N	\N	\N	
2425	\N	\N	\N	
2426	\N	\N	\N	
2427	\N	\N	\N	
2428	\N	\N	\N	
2429	\N	\N	\N	
2430	\N	\N	\N	
2431	\N	\N	\N	
2432	\N	\N	\N	
2433	\N	\N	\N	
2434	\N	\N	\N	
2435	\N	\N	\N	
2436	\N	\N	\N	
2437	\N	\N	\N	
2438	\N	\N	\N	
2439	\N	\N	\N	
2440	\N	\N	\N	
2441	\N	\N	\N	
2442	\N	\N	\N	
2443	\N	\N	\N	
2444	\N	\N	\N	
2445	\N	\N	\N	
2446	\N	\N	\N	
2447	\N	\N	\N	
2448	\N	\N	\N	
2449	\N	\N	\N	
2450	\N	\N	\N	
2451	\N	\N	\N	
2452	\N	\N	\N	
2453	\N	\N	\N	
2454	\N	\N	\N	
2455	\N	\N	\N	
2456	\N	\N	\N	
2457	\N	\N	\N	
2458	\N	\N	\N	
2459	\N	\N	\N	
2460	\N	\N	\N	
2461	\N	\N	\N	
2462	\N	\N	\N	
2463	\N	\N	\N	
2464	\N	\N	\N	
2465	\N	\N	\N	
2466	\N	\N	\N	
2467	\N	\N	\N	
2468	\N	\N	\N	
2469	\N	\N	\N	
2470	\N	\N	\N	
2471	\N	\N	\N	
2472	\N	\N	\N	
2473	\N	\N	\N	
2474	\N	\N	\N	
2475	\N	\N	\N	
2476	\N	\N	\N	
2477	\N	\N	\N	
2478	\N	\N	\N	
2479	\N	\N	\N	
2480	\N	\N	\N	
2481	\N	\N	\N	
2482	\N	\N	\N	
2483	\N	\N	\N	
2484	\N	\N	\N	
2485	\N	\N	\N	
2486	\N	\N	\N	
2487	\N	\N	\N	
2488	\N	\N	\N	
2489	\N	\N	\N	
2490	\N	\N	\N	
2491	\N	\N	\N	
2492	\N	\N	\N	
2493	\N	\N	\N	
2494	\N	\N	\N	
2495	\N	\N	\N	
2496	\N	\N	\N	
2497	\N	\N	\N	
2498	\N	\N	\N	
2499	\N	\N	\N	
2500	\N	\N	\N	
2501	\N	\N	\N	
2502	\N	\N	\N	
2503	\N	\N	\N	
2504	\N	\N	\N	
2505	\N	\N	\N	
2506	\N	\N	\N	
2507	\N	\N	\N	
2508	\N	\N	\N	
2509	\N	\N	\N	
2510	\N	\N	\N	
2511	\N	\N	\N	
2512	\N	\N	\N	
2513	\N	\N	\N	
2514	\N	\N	\N	
2515	\N	\N	\N	
2516	\N	\N	\N	
2517	\N	\N	\N	
2518	\N	\N	\N	
2519	\N	\N	\N	
2520	\N	\N	\N	
2521	\N	\N	\N	
2522	\N	\N	\N	
2523	\N	\N	\N	
2524	\N	\N	\N	
2525	\N	\N	\N	
2526	\N	\N	\N	
2527	\N	\N	\N	
2528	\N	\N	\N	
2529	\N	\N	\N	
2530	\N	\N	\N	
2531	\N	\N	\N	
2532	\N	\N	\N	
2533	\N	\N	\N	
2534	\N	\N	\N	
2535	\N	\N	\N	
2536	\N	\N	\N	
2537	\N	\N	\N	
2538	\N	\N	\N	
2539	\N	\N	\N	
2540	\N	\N	\N	
2541	\N	\N	\N	
2542	\N	\N	\N	
2543	\N	\N	\N	
2544	\N	\N	\N	
2545	\N	\N	\N	
2546	\N	\N	\N	
2547	\N	\N	\N	
2548	\N	\N	\N	
2549	\N	\N	\N	
2550	\N	\N	\N	
2551	\N	\N	\N	
2552	\N	\N	\N	
2553	\N	\N	\N	
2554	\N	\N	\N	
2555	\N	\N	\N	
2556	\N	\N	\N	
2557	\N	\N	\N	
2558	\N	\N	\N	
2559	\N	\N	\N	
2560	\N	\N	\N	
2561	\N	\N	\N	
2562	\N	\N	\N	
2563	\N	\N	\N	
2564	\N	\N	\N	
2565	\N	\N	\N	
2566	\N	\N	\N	
2567	\N	\N	\N	
2568	\N	\N	\N	
2569	\N	\N	\N	
2570	\N	\N	\N	
2571	\N	\N	\N	
2572	\N	\N	\N	
2573	\N	\N	\N	
2574	\N	\N	\N	
2575	\N	\N	\N	
2576	\N	\N	\N	
2577	\N	\N	\N	
2578	\N	\N	\N	
2579	\N	\N	\N	
2580	\N	\N	\N	
2581	\N	\N	\N	
2582	\N	\N	\N	
2583	\N	\N	\N	
2584	\N	\N	\N	
2585	\N	\N	\N	
2586	\N	\N	\N	
2587	\N	\N	\N	
2588	\N	\N	\N	
2589	\N	\N	\N	
2590	\N	\N	\N	
2591	\N	\N	\N	
2592	\N	\N	\N	
2593	\N	\N	\N	
2594	\N	\N	\N	
2595	\N	\N	\N	
2596	\N	\N	\N	
2597	\N	\N	\N	
2598	\N	\N	\N	
2599	\N	\N	\N	
2600	\N	\N	\N	
2601	\N	\N	\N	
2602	\N	\N	\N	
2603	\N	\N	\N	
2604	\N	\N	\N	
2605	\N	\N	\N	
2606	\N	\N	\N	
2607	\N	\N	\N	
2608	\N	\N	\N	
2609	\N	\N	\N	
2610	\N	\N	\N	
2611	\N	\N	\N	
2612	\N	\N	\N	
2613	\N	\N	\N	
2614	\N	\N	\N	
2615	\N	\N	\N	
2616	\N	\N	\N	
2617	\N	\N	\N	
2618	\N	\N	\N	
2619	\N	\N	\N	
2620	\N	\N	\N	
2621	\N	\N	\N	
2622	\N	\N	\N	
2623	\N	\N	\N	
2624	\N	\N	\N	
2625	\N	\N	\N	
2626	\N	\N	\N	
2627	\N	\N	\N	
2628	\N	\N	\N	
2629	\N	\N	\N	
2630	\N	\N	\N	
2631	\N	\N	\N	
2632	\N	\N	\N	
2633	\N	\N	\N	
2634	\N	\N	\N	
2635	\N	\N	\N	
2636	\N	\N	\N	
2637	\N	\N	\N	
2638	\N	\N	\N	
2639	\N	\N	\N	
2640	\N	\N	\N	
2641	\N	\N	\N	
2642	\N	\N	\N	
2643	\N	\N	\N	
2644	\N	\N	\N	
2645	\N	\N	\N	
2646	\N	\N	\N	
2647	\N	\N	\N	
2648	\N	\N	\N	
2649	\N	\N	\N	
2650	\N	\N	\N	
2651	\N	\N	\N	
2652	\N	\N	\N	
2653	\N	\N	\N	
2654	\N	\N	\N	
2655	\N	\N	\N	
2656	\N	\N	\N	
2657	\N	\N	\N	
2658	\N	\N	\N	
2659	\N	\N	\N	
2660	\N	\N	\N	
2661	\N	\N	\N	
2662	\N	\N	\N	
2663	\N	\N	\N	
2664	\N	\N	\N	
2665	\N	\N	\N	
2666	\N	\N	\N	
2667	\N	\N	\N	
2668	\N	\N	\N	
2669	\N	\N	\N	
2670	\N	\N	\N	
2671	\N	\N	\N	
2672	\N	\N	\N	
2673	\N	\N	\N	
2674	\N	\N	\N	
2675	\N	\N	\N	
2676	\N	\N	\N	
2677	\N	\N	\N	
2678	\N	\N	\N	
2679	\N	\N	\N	
2680	\N	\N	\N	
2681	\N	\N	\N	
2682	\N	\N	\N	
2683	\N	\N	\N	
2684	\N	\N	\N	
2685	\N	\N	\N	
2686	\N	\N	\N	
2687	\N	\N	\N	
2688	\N	\N	\N	
2689	\N	\N	\N	
2690	\N	\N	\N	
2691	\N	\N	\N	
2692	\N	\N	\N	
2693	\N	\N	\N	
2694	\N	\N	\N	
2695	\N	\N	\N	
2696	\N	\N	\N	
2697	\N	\N	\N	
2698	\N	\N	\N	
2699	\N	\N	\N	
2700	\N	\N	\N	
2701	\N	\N	\N	
2702	\N	\N	\N	
2703	\N	\N	\N	
2704	\N	\N	\N	
2705	\N	\N	\N	
2706	\N	\N	\N	
2707	\N	\N	\N	
2708	\N	\N	\N	
2709	\N	\N	\N	
2710	\N	\N	\N	
2711	\N	\N	\N	
2712	\N	\N	\N	
2713	\N	\N	\N	
2714	\N	\N	\N	
2715	\N	\N	\N	
2716	\N	\N	\N	
2717	\N	\N	\N	
2718	\N	\N	\N	
2719	\N	\N	\N	
2720	\N	\N	\N	
2721	\N	\N	\N	
2722	\N	\N	\N	
2723	\N	\N	\N	
2724	\N	\N	\N	
2725	\N	\N	\N	
2726	\N	\N	\N	
2727	\N	\N	\N	
2728	\N	\N	\N	
2729	\N	\N	\N	
2730	\N	\N	\N	
2731	\N	\N	\N	
2732	\N	\N	\N	
2733	\N	\N	\N	
2734	\N	\N	\N	
2735	\N	\N	\N	
2736	\N	\N	\N	
2737	\N	\N	\N	
2738	\N	\N	\N	
2739	\N	\N	\N	
2740	\N	\N	\N	
2741	\N	\N	\N	
2742	\N	\N	\N	
2743	\N	\N	\N	
2744	\N	\N	\N	
2745	\N	\N	\N	
2746	\N	\N	\N	
2747	\N	\N	\N	
2748	\N	\N	\N	
2749	\N	\N	\N	
2750	\N	\N	\N	
2751	\N	\N	\N	
2752	\N	\N	\N	
2753	\N	\N	\N	
2754	\N	\N	\N	
2755	\N	\N	\N	
2756	\N	\N	\N	
2757	\N	\N	\N	
2758	\N	\N	\N	
2759	\N	\N	\N	
2760	\N	\N	\N	
2761	\N	\N	\N	
2762	\N	\N	\N	
2763	\N	\N	\N	
2764	\N	\N	\N	
2765	\N	\N	\N	
2766	\N	\N	\N	
2767	\N	\N	\N	
2768	\N	\N	\N	
2769	\N	\N	\N	
2770	\N	\N	\N	
2771	\N	\N	\N	
2772	\N	\N	\N	
2773	\N	\N	\N	
2774	\N	\N	\N	
2775	\N	\N	\N	
2776	\N	\N	\N	
2777	\N	\N	\N	
2778	\N	\N	\N	
2779	\N	\N	\N	
2780	\N	\N	\N	
2781	\N	\N	\N	
2782	\N	\N	\N	
2783	\N	\N	\N	
2784	\N	\N	\N	
2785	\N	\N	\N	
2786	\N	\N	\N	
2787	\N	\N	\N	
2788	\N	\N	\N	
2789	\N	\N	\N	
2790	\N	\N	\N	
2791	\N	\N	\N	
2792	\N	\N	\N	
2793	\N	\N	\N	
2794	\N	\N	\N	
2795	\N	\N	\N	
2796	\N	\N	\N	
2797	\N	\N	\N	
2798	\N	\N	\N	
2799	\N	\N	\N	
2800	\N	\N	\N	
2801	\N	\N	\N	
2802	\N	\N	\N	
2803	\N	\N	\N	
2804	\N	\N	\N	
2805	\N	\N	\N	
2806	\N	\N	\N	
2807	\N	\N	\N	
2808	\N	\N	\N	
2809	\N	\N	\N	
2810	\N	\N	\N	
2811	\N	\N	\N	
2812	\N	\N	\N	
2813	\N	\N	\N	
2814	\N	\N	\N	
2815	\N	\N	\N	
2816	\N	\N	\N	
2817	\N	\N	\N	
2818	\N	\N	\N	
2819	\N	\N	\N	
2820	\N	\N	\N	
2821	\N	\N	\N	
2822	\N	\N	\N	
2823	\N	\N	\N	
2824	\N	\N	\N	
2825	\N	\N	\N	
2826	\N	\N	\N	
2827	\N	\N	\N	
2828	\N	\N	\N	
2829	\N	\N	\N	
2830	\N	\N	\N	
2831	\N	\N	\N	
2832	\N	\N	\N	
2833	\N	\N	\N	
2834	\N	\N	\N	
2835	\N	\N	\N	
2836	\N	\N	\N	
2837	\N	\N	\N	
2838	\N	\N	\N	
2839	\N	\N	\N	
2840	\N	\N	\N	
2841	\N	\N	\N	
2842	\N	\N	\N	
2843	\N	\N	\N	
2844	\N	\N	\N	
2845	\N	\N	\N	
2846	\N	\N	\N	
2847	\N	\N	\N	
2848	\N	\N	\N	
2849	\N	\N	\N	
2850	\N	\N	\N	
2851	\N	\N	\N	
2852	\N	\N	\N	
2853	\N	\N	\N	
2854	\N	\N	\N	
2855	\N	\N	\N	
2856	\N	\N	\N	
2857	\N	\N	\N	
2858	\N	\N	\N	
2859	\N	\N	\N	
2860	\N	\N	\N	
2861	\N	\N	\N	
2862	\N	\N	\N	
2863	\N	\N	\N	
2864	\N	\N	\N	
2865	\N	\N	\N	
2866	\N	\N	\N	
2867	\N	\N	\N	
2868	\N	\N	\N	
2869	\N	\N	\N	
2870	\N	\N	\N	
2871	\N	\N	\N	
2872	\N	\N	\N	
2873	\N	\N	\N	
2874	\N	\N	\N	
2875	\N	\N	\N	
2876	\N	\N	\N	
2877	\N	\N	\N	
2878	\N	\N	\N	
2879	\N	\N	\N	
2880	\N	\N	\N	
2881	\N	\N	\N	
2882	\N	\N	\N	
2883	\N	\N	\N	
2884	\N	\N	\N	
2885	\N	\N	\N	
2886	\N	\N	\N	
2887	\N	\N	\N	
2888	\N	\N	\N	
2889	\N	\N	\N	
2890	\N	\N	\N	
2891	\N	\N	\N	
2892	\N	\N	\N	
2893	\N	\N	\N	
2894	\N	\N	\N	
2895	\N	\N	\N	
2896	\N	\N	\N	
2897	\N	\N	\N	
2898	\N	\N	\N	
2899	\N	\N	\N	
2900	\N	\N	\N	
2901	\N	\N	\N	
2902	\N	\N	\N	
2903	\N	\N	\N	
2904	\N	\N	\N	
2905	\N	\N	\N	
2906	\N	\N	\N	
2907	\N	\N	\N	
2908	\N	\N	\N	
2909	\N	\N	\N	
2910	\N	\N	\N	
2911	\N	\N	\N	
2912	\N	\N	\N	
2913	\N	\N	\N	
2914	\N	\N	\N	
2915	\N	\N	\N	
2916	\N	\N	\N	
2917	\N	\N	\N	
2918	\N	\N	\N	
2919	\N	\N	\N	
2920	\N	\N	\N	
2921	\N	\N	\N	
2922	\N	\N	\N	
2923	\N	\N	\N	
2924	\N	\N	\N	
2925	\N	\N	\N	
2926	\N	\N	\N	
2927	\N	\N	\N	
2928	\N	\N	\N	
2929	\N	\N	\N	
2930	\N	\N	\N	
2931	\N	\N	\N	
2932	\N	\N	\N	
2933	\N	\N	\N	
2934	\N	\N	\N	
2935	\N	\N	\N	
2936	\N	\N	\N	
2937	\N	\N	\N	
2938	\N	\N	\N	
2939	\N	\N	\N	
2940	\N	\N	\N	
2941	\N	\N	\N	
2942	\N	\N	\N	
2943	\N	\N	\N	
2944	\N	\N	\N	
2945	\N	\N	\N	
2946	\N	\N	\N	
2947	\N	\N	\N	
2948	\N	\N	\N	
2949	\N	\N	\N	
2950	\N	\N	\N	
2951	\N	\N	\N	
2952	\N	\N	\N	
2953	\N	\N	\N	
2954	\N	\N	\N	
2955	\N	\N	\N	
2956	\N	\N	\N	
2957	\N	\N	\N	
2958	\N	\N	\N	
2959	\N	\N	\N	
2960	\N	\N	\N	
2961	\N	\N	\N	
2962	\N	\N	\N	
2963	\N	\N	\N	
2964	\N	\N	\N	
2965	\N	\N	\N	
2966	\N	\N	\N	
2967	\N	\N	\N	
2968	\N	\N	\N	
2969	\N	\N	\N	
2970	\N	\N	\N	
2971	\N	\N	\N	
2972	\N	\N	\N	
2973	\N	\N	\N	
2974	\N	\N	\N	
2975	\N	\N	\N	
2976	\N	\N	\N	
2977	\N	\N	\N	
2978	\N	\N	\N	
2979	\N	\N	\N	
2980	\N	\N	\N	
2981	\N	\N	\N	
2982	\N	\N	\N	
2983	\N	\N	\N	
2984	\N	\N	\N	
2985	\N	\N	\N	
2986	\N	\N	\N	
2987	\N	\N	\N	
2988	\N	\N	\N	
2989	\N	\N	\N	
2990	\N	\N	\N	
2991	\N	\N	\N	
2992	\N	\N	\N	
2993	\N	\N	\N	
2994	\N	\N	\N	
2995	\N	\N	\N	
2996	\N	\N	\N	
2997	\N	\N	\N	
2998	\N	\N	\N	
2999	\N	\N	\N	
3000	\N	\N	\N	
3001	\N	\N	\N	
3002	\N	\N	\N	
3003	\N	\N	\N	
3004	\N	\N	\N	
3005	\N	\N	\N	
3006	\N	\N	\N	
3007	\N	\N	\N	
3008	\N	\N	\N	
3009	\N	\N	\N	
3010	\N	\N	\N	
3011	\N	\N	\N	
3012	\N	\N	\N	
3013	\N	\N	\N	
3014	\N	\N	\N	
3015	\N	\N	\N	
3016	\N	\N	\N	
3017	\N	\N	\N	
3018	\N	\N	\N	
3019	\N	\N	\N	
3020	\N	\N	\N	
3021	\N	\N	\N	
3022	\N	\N	\N	
3023	\N	\N	\N	
3024	\N	\N	\N	
3025	\N	\N	\N	
3026	\N	\N	\N	
3027	\N	\N	\N	
3028	\N	\N	\N	
3029	\N	\N	\N	
3030	\N	\N	\N	
3031	\N	\N	\N	
3032	\N	\N	\N	
3033	\N	\N	\N	
3034	\N	\N	\N	
3035	\N	\N	\N	
3036	\N	\N	\N	
3037	\N	\N	\N	
3038	\N	\N	\N	
3039	\N	\N	\N	
3040	\N	\N	\N	
3041	\N	\N	\N	
3042	\N	\N	\N	
3043	\N	\N	\N	
3044	\N	\N	\N	
3045	\N	\N	\N	
3046	\N	\N	\N	
3047	\N	\N	\N	
3048	\N	\N	\N	
3049	\N	\N	\N	
3050	\N	\N	\N	
3051	\N	\N	\N	
3052	\N	\N	\N	
3053	\N	\N	\N	
3054	\N	\N	\N	
3055	\N	\N	\N	
3056	\N	\N	\N	
3057	\N	\N	\N	
3058	\N	\N	\N	
3059	\N	\N	\N	
3060	\N	\N	\N	
3061	\N	\N	\N	
3062	\N	\N	\N	
3063	\N	\N	\N	
3064	\N	\N	\N	
3065	\N	\N	\N	
3066	\N	\N	\N	
3067	\N	\N	\N	
3068	\N	\N	\N	
3069	\N	\N	\N	
3070	\N	\N	\N	
3071	\N	\N	\N	
3072	\N	\N	\N	
3073	\N	\N	\N	
3074	\N	\N	\N	
3075	\N	\N	\N	
3076	\N	\N	\N	
3077	\N	\N	\N	
3078	\N	\N	\N	
3079	\N	\N	\N	
3080	\N	\N	\N	
3081	\N	\N	\N	
3082	\N	\N	\N	
3083	\N	\N	\N	
3084	\N	\N	\N	
3085	\N	\N	\N	
3086	\N	\N	\N	
3087	\N	\N	\N	
3088	\N	\N	\N	
3089	\N	\N	\N	
3090	\N	\N	\N	
3091	\N	\N	\N	
3092	\N	\N	\N	
3093	\N	\N	\N	
3094	\N	\N	\N	
3095	\N	\N	\N	
3096	\N	\N	\N	
3097	\N	\N	\N	
3098	\N	\N	\N	
3099	\N	\N	\N	
3100	\N	\N	\N	
3101	\N	\N	\N	
3102	\N	\N	\N	
3103	\N	\N	\N	
3104	\N	\N	\N	
3105	\N	\N	\N	
3106	\N	\N	\N	
3107	\N	\N	\N	
3108	\N	\N	\N	
3109	\N	\N	\N	
3110	\N	\N	\N	
3111	\N	\N	\N	
3112	\N	\N	\N	
3113	\N	\N	\N	
3114	\N	\N	\N	
3115	\N	\N	\N	
3116	\N	\N	\N	
3117	\N	\N	\N	
3118	\N	\N	\N	
3119	\N	\N	\N	
3120	\N	\N	\N	
3121	\N	\N	\N	
3122	\N	\N	\N	
3123	\N	\N	\N	
3124	\N	\N	\N	
3125	\N	\N	\N	
3126	\N	\N	\N	
3127	\N	\N	\N	
3128	\N	\N	\N	
3129	\N	\N	\N	
3130	\N	\N	\N	
3131	\N	\N	\N	
3132	\N	\N	\N	
3133	\N	\N	\N	
3134	\N	\N	\N	
3135	\N	\N	\N	
3136	\N	\N	\N	
3137	\N	\N	\N	
3138	\N	\N	\N	
3139	\N	\N	\N	
3140	\N	\N	\N	
3141	\N	\N	\N	
3142	\N	\N	\N	
3143	\N	\N	\N	
3144	\N	\N	\N	
3145	\N	\N	\N	
3146	\N	\N	\N	
3147	\N	\N	\N	
3148	\N	\N	\N	
3149	\N	\N	\N	
3150	\N	\N	\N	
3151	\N	\N	\N	
3152	\N	\N	\N	
3153	\N	\N	\N	
3154	\N	\N	\N	
3155	\N	\N	\N	
3156	\N	\N	\N	
3157	\N	\N	\N	
3158	\N	\N	\N	
3159	\N	\N	\N	
3160	\N	\N	\N	
3161	\N	\N	\N	
3162	\N	\N	\N	
3163	\N	\N	\N	
3164	\N	\N	\N	
3165	\N	\N	\N	
3166	\N	\N	\N	
3167	\N	\N	\N	
3168	\N	\N	\N	
3169	\N	\N	\N	
3170	\N	\N	\N	
3171	\N	\N	\N	
3172	\N	\N	\N	
3173	\N	\N	\N	
3174	\N	\N	\N	
3175	\N	\N	\N	
3176	\N	\N	\N	
3177	\N	\N	\N	
3178	\N	\N	\N	
3179	\N	\N	\N	
3180	\N	\N	\N	
3181	\N	\N	\N	
3182	\N	\N	\N	
3183	\N	\N	\N	
3184	\N	\N	\N	
3185	\N	\N	\N	
3186	\N	\N	\N	
3187	\N	\N	\N	
3188	\N	\N	\N	
3189	\N	\N	\N	
3190	\N	\N	\N	
3191	\N	\N	\N	
3192	\N	\N	\N	
3193	\N	\N	\N	
3194	\N	\N	\N	
3195	\N	\N	\N	
3196	\N	\N	\N	
3197	\N	\N	\N	
3198	\N	\N	\N	
3199	\N	\N	\N	
3200	\N	\N	\N	
3201	\N	\N	\N	
3202	\N	\N	\N	
3203	\N	\N	\N	
3204	\N	\N	\N	
3205	\N	\N	\N	
3206	\N	\N	\N	
3207	\N	\N	\N	
3208	\N	\N	\N	
3209	\N	\N	\N	
3210	\N	\N	\N	
3211	\N	\N	\N	
3212	\N	\N	\N	
3213	\N	\N	\N	
3214	\N	\N	\N	
3215	\N	\N	\N	
3216	\N	\N	\N	
3217	\N	\N	\N	
3218	\N	\N	\N	
3219	\N	\N	\N	
3220	\N	\N	\N	
3221	\N	\N	\N	
3222	\N	\N	\N	
3223	\N	\N	\N	
3224	\N	\N	\N	
3225	\N	\N	\N	
3226	\N	\N	\N	
3227	\N	\N	\N	
3228	\N	\N	\N	
3229	\N	\N	\N	
3230	\N	\N	\N	
3231	\N	\N	\N	
3232	\N	\N	\N	
3233	\N	\N	\N	
3234	\N	\N	\N	
3235	\N	\N	\N	
3236	\N	\N	\N	
3237	\N	\N	\N	
3238	\N	\N	\N	
3239	\N	\N	\N	
3240	\N	\N	\N	
3241	\N	\N	\N	
3242	\N	\N	\N	
3243	\N	\N	\N	
3244	\N	\N	\N	
3245	\N	\N	\N	
3246	\N	\N	\N	
3247	\N	\N	\N	
3248	\N	\N	\N	
3249	\N	\N	\N	
3250	\N	\N	\N	
3251	\N	\N	\N	
3252	\N	\N	\N	
3253	\N	\N	\N	
3254	\N	\N	\N	
3255	\N	\N	\N	
3256	\N	\N	\N	
3257	\N	\N	\N	
3258	\N	\N	\N	
3259	\N	\N	\N	
3260	\N	\N	\N	
3261	\N	\N	\N	
3262	\N	\N	\N	
3263	\N	\N	\N	
3264	\N	\N	\N	
3265	\N	\N	\N	
3266	\N	\N	\N	
3267	\N	\N	\N	
3268	\N	\N	\N	
3269	\N	\N	\N	
3270	\N	\N	\N	
3271	\N	\N	\N	
3272	\N	\N	\N	
3273	\N	\N	\N	
3274	\N	\N	\N	
3275	\N	\N	\N	
3276	\N	\N	\N	
3277	\N	\N	\N	
3278	\N	\N	\N	
3279	\N	\N	\N	
3280	\N	\N	\N	
3281	\N	\N	\N	
3282	\N	\N	\N	
3283	\N	\N	\N	
3284	\N	\N	\N	
3285	\N	\N	\N	
3286	\N	\N	\N	
3287	\N	\N	\N	
3288	\N	\N	\N	
3289	\N	\N	\N	
3290	\N	\N	\N	
3291	\N	\N	\N	
3292	\N	\N	\N	
3293	\N	\N	\N	
3294	\N	\N	\N	
3295	\N	\N	\N	
3296	\N	\N	\N	
3297	\N	\N	\N	
3298	\N	\N	\N	
3299	\N	\N	\N	
3300	\N	\N	\N	
3301	\N	\N	\N	
3302	\N	\N	\N	
3303	\N	\N	\N	
3304	\N	\N	\N	
3305	\N	\N	\N	
3306	\N	\N	\N	
3307	\N	\N	\N	
3308	\N	\N	\N	
3309	\N	\N	\N	
3310	\N	\N	\N	
3311	\N	\N	\N	
3312	\N	\N	\N	
3313	\N	\N	\N	
3314	\N	\N	\N	
3315	\N	\N	\N	
3316	\N	\N	\N	
3317	\N	\N	\N	
3318	\N	\N	\N	
3319	\N	\N	\N	
3320	\N	\N	\N	
3321	\N	\N	\N	
3322	\N	\N	\N	
3323	\N	\N	\N	
3324	\N	\N	\N	
3325	\N	\N	\N	
3326	\N	\N	\N	
3327	\N	\N	\N	
3328	\N	\N	\N	
3329	\N	\N	\N	
3330	\N	\N	\N	
3331	\N	\N	\N	
3332	\N	\N	\N	
3333	\N	\N	\N	
3334	\N	\N	\N	
3335	\N	\N	\N	
3336	\N	\N	\N	
3337	\N	\N	\N	
3338	\N	\N	\N	
3339	\N	\N	\N	
3340	\N	\N	\N	
3341	\N	\N	\N	
3342	\N	\N	\N	
3343	\N	\N	\N	
3344	\N	\N	\N	
3345	\N	\N	\N	
3346	\N	\N	\N	
3347	\N	\N	\N	
3348	\N	\N	\N	
3349	\N	\N	\N	
3350	\N	\N	\N	
3351	\N	\N	\N	
3352	\N	\N	\N	
3353	\N	\N	\N	
3354	\N	\N	\N	
3355	\N	\N	\N	
3356	\N	\N	\N	
3357	\N	\N	\N	
3358	\N	\N	\N	
3359	\N	\N	\N	
3360	\N	\N	\N	
3361	\N	\N	\N	
3362	\N	\N	\N	
3363	\N	\N	\N	
3364	\N	\N	\N	
3365	\N	\N	\N	
3366	\N	\N	\N	
3367	\N	\N	\N	
3368	\N	\N	\N	
3369	\N	\N	\N	
3370	\N	\N	\N	
3371	\N	\N	\N	
3372	\N	\N	\N	
3373	\N	\N	\N	
3374	\N	\N	\N	
3375	\N	\N	\N	
3376	\N	\N	\N	
3377	\N	\N	\N	
3378	\N	\N	\N	
3379	\N	\N	\N	
3380	\N	\N	\N	
3381	\N	\N	\N	
3382	\N	\N	\N	
3383	\N	\N	\N	
3384	\N	\N	\N	
3385	\N	\N	\N	
3386	\N	\N	\N	
3387	\N	\N	\N	
3388	\N	\N	\N	
3389	\N	\N	\N	
3390	\N	\N	\N	
3391	\N	\N	\N	
3392	\N	\N	\N	
3393	\N	\N	\N	
3394	\N	\N	\N	
3395	\N	\N	\N	
3396	\N	\N	\N	
3397	\N	\N	\N	
3398	\N	\N	\N	
3399	\N	\N	\N	
3400	\N	\N	\N	
3401	\N	\N	\N	
3402	\N	\N	\N	
3403	\N	\N	\N	
3404	\N	\N	\N	
3405	\N	\N	\N	
3406	\N	\N	\N	
3407	\N	\N	\N	
3408	\N	\N	\N	
3409	\N	\N	\N	
3410	\N	\N	\N	
3411	\N	\N	\N	
3412	\N	\N	\N	
3413	\N	\N	\N	
3414	\N	\N	\N	
3415	\N	\N	\N	
3416	\N	\N	\N	
3417	\N	\N	\N	
3418	\N	\N	\N	
3419	\N	\N	\N	
3420	\N	\N	\N	
3421	\N	\N	\N	
3422	\N	\N	\N	
3423	\N	\N	\N	
3424	\N	\N	\N	
3425	\N	\N	\N	
3426	\N	\N	\N	
3427	\N	\N	\N	
3428	\N	\N	\N	
3429	\N	\N	\N	
3430	\N	\N	\N	
3431	\N	\N	\N	
3432	\N	\N	\N	
3433	\N	\N	\N	
3434	\N	\N	\N	
3435	\N	\N	\N	
3436	\N	\N	\N	
3437	\N	\N	\N	
3438	\N	\N	\N	
3439	\N	\N	\N	
3440	\N	\N	\N	
3441	\N	\N	\N	
3442	\N	\N	\N	
3443	\N	\N	\N	
3444	\N	\N	\N	
3445	\N	\N	\N	
3446	\N	\N	\N	
3447	\N	\N	\N	
3448	\N	\N	\N	
3449	\N	\N	\N	
3450	\N	\N	\N	
3451	\N	\N	\N	
3452	\N	\N	\N	
3453	\N	\N	\N	
3454	\N	\N	\N	
3455	\N	\N	\N	
3456	\N	\N	\N	
3457	\N	\N	\N	
3458	\N	\N	\N	
3459	\N	\N	\N	
3460	\N	\N	\N	
3461	\N	\N	\N	
3462	\N	\N	\N	
3463	\N	\N	\N	
3464	\N	\N	\N	
3465	\N	\N	\N	
3466	\N	\N	\N	
3467	\N	\N	\N	
3468	\N	\N	\N	
3469	\N	\N	\N	
3470	\N	\N	\N	
3471	\N	\N	\N	
3472	\N	\N	\N	
3473	\N	\N	\N	
3474	\N	\N	\N	
3475	\N	\N	\N	
3476	\N	\N	\N	
3477	\N	\N	\N	
3478	\N	\N	\N	
3479	\N	\N	\N	
3480	\N	\N	\N	
3481	\N	\N	\N	
3482	\N	\N	\N	
3483	\N	\N	\N	
3484	\N	\N	\N	
3485	\N	\N	\N	
3486	\N	\N	\N	
3487	\N	\N	\N	
3488	\N	\N	\N	
3489	\N	\N	\N	
3490	\N	\N	\N	
3491	\N	\N	\N	
3492	\N	\N	\N	
3493	\N	\N	\N	
3494	\N	\N	\N	
3495	\N	\N	\N	
3496	\N	\N	\N	
3497	\N	\N	\N	
3498	\N	\N	\N	
3499	\N	\N	\N	
3500	\N	\N	\N	
3501	\N	\N	\N	
3502	\N	\N	\N	
3503	\N	\N	\N	
3504	\N	\N	\N	
3505	\N	\N	\N	
3506	\N	\N	\N	
3507	\N	\N	\N	
3508	\N	\N	\N	
3509	\N	\N	\N	
3510	\N	\N	\N	
3511	\N	\N	\N	
3512	\N	\N	\N	
3513	\N	\N	\N	
3514	\N	\N	\N	
3515	\N	\N	\N	
3516	\N	\N	\N	
3517	\N	\N	\N	
3518	\N	\N	\N	
3519	\N	\N	\N	
3520	\N	\N	\N	
3521	\N	\N	\N	
3522	\N	\N	\N	
3523	\N	\N	\N	
3524	\N	\N	\N	
3525	\N	\N	\N	
3526	\N	\N	\N	
3527	\N	\N	\N	
3528	\N	\N	\N	
3529	\N	\N	\N	
3530	\N	\N	\N	
3531	\N	\N	\N	
3532	\N	\N	\N	
3533	\N	\N	\N	
3534	\N	\N	\N	
3535	\N	\N	\N	
3536	\N	\N	\N	
3537	\N	\N	\N	
3538	\N	\N	\N	
3539	\N	\N	\N	
3540	\N	\N	\N	
3541	\N	\N	\N	
3542	\N	\N	\N	
3543	\N	\N	\N	
3544	\N	\N	\N	
3545	\N	\N	\N	
3546	\N	\N	\N	
3547	\N	\N	\N	
3548	\N	\N	\N	
3549	\N	\N	\N	
3550	\N	\N	\N	
3551	\N	\N	\N	
3552	\N	\N	\N	
3553	\N	\N	\N	
3554	\N	\N	\N	
3555	\N	\N	\N	
3556	\N	\N	\N	
3557	\N	\N	\N	
3558	\N	\N	\N	
3559	\N	\N	\N	
3560	\N	\N	\N	
3561	\N	\N	\N	
3562	\N	\N	\N	
3563	\N	\N	\N	
3564	\N	\N	\N	
3565	\N	\N	\N	
3566	\N	\N	\N	
3567	\N	\N	\N	
3568	\N	\N	\N	
3569	\N	\N	\N	
3570	\N	\N	\N	
3571	\N	\N	\N	
3572	\N	\N	\N	
3573	\N	\N	\N	
3574	\N	\N	\N	
3575	\N	\N	\N	
3576	\N	\N	\N	
3577	\N	\N	\N	
3578	\N	\N	\N	
3579	\N	\N	\N	
3580	\N	\N	\N	
3581	\N	\N	\N	
3582	\N	\N	\N	
3583	\N	\N	\N	
3584	\N	\N	\N	
3585	\N	\N	\N	
3586	\N	\N	\N	
3587	\N	\N	\N	
3588	\N	\N	\N	
3589	\N	\N	\N	
3590	\N	\N	\N	
3591	\N	\N	\N	
3592	\N	\N	\N	
3593	\N	\N	\N	
3594	\N	\N	\N	
3595	\N	\N	\N	
3596	\N	\N	\N	
3597	\N	\N	\N	
3598	\N	\N	\N	
3599	\N	\N	\N	
3600	\N	\N	\N	
3601	\N	\N	\N	
3602	\N	\N	\N	
3603	\N	\N	\N	
3604	\N	\N	\N	
3605	\N	\N	\N	
3606	\N	\N	\N	
3607	\N	\N	\N	
3608	\N	\N	\N	
3609	\N	\N	\N	
3610	\N	\N	\N	
3611	\N	\N	\N	
3612	\N	\N	\N	
3613	\N	\N	\N	
3614	\N	\N	\N	
3615	\N	\N	\N	
3616	\N	\N	\N	
3617	\N	\N	\N	
3618	\N	\N	\N	
3619	\N	\N	\N	
3620	\N	\N	\N	
3621	\N	\N	\N	
3622	\N	\N	\N	
3623	\N	\N	\N	
3624	\N	\N	\N	
3625	\N	\N	\N	
3626	\N	\N	\N	
3627	\N	\N	\N	
3628	\N	\N	\N	
3629	\N	\N	\N	
3630	\N	\N	\N	
3631	\N	\N	\N	
3632	\N	\N	\N	
3633	\N	\N	\N	
3634	\N	\N	\N	
3635	\N	\N	\N	
3636	\N	\N	\N	
3637	\N	\N	\N	
3638	\N	\N	\N	
3639	\N	\N	\N	
3640	\N	\N	\N	
3641	\N	\N	\N	
3642	\N	\N	\N	
3643	\N	\N	\N	
3644	\N	\N	\N	
3645	\N	\N	\N	
3646	\N	\N	\N	
3647	\N	\N	\N	
3648	\N	\N	\N	
3649	\N	\N	\N	
3650	\N	\N	\N	
3651	\N	\N	\N	
3652	\N	\N	\N	
3653	\N	\N	\N	
3654	\N	\N	\N	
3655	\N	\N	\N	
3656	\N	\N	\N	
3657	\N	\N	\N	
3658	\N	\N	\N	
3659	\N	\N	\N	
3660	\N	\N	\N	
3661	\N	\N	\N	
3662	\N	\N	\N	
3663	\N	\N	\N	
3664	\N	\N	\N	
3665	\N	\N	\N	
3666	\N	\N	\N	
3667	\N	\N	\N	
3668	\N	\N	\N	
3669	\N	\N	\N	
3670	\N	\N	\N	
3671	\N	\N	\N	
3672	\N	\N	\N	
3673	\N	\N	\N	
3674	\N	\N	\N	
3675	\N	\N	\N	
3676	\N	\N	\N	
3677	\N	\N	\N	
3678	\N	\N	\N	
3679	\N	\N	\N	
3680	\N	\N	\N	
3681	\N	\N	\N	
3682	\N	\N	\N	
3683	\N	\N	\N	
3684	\N	\N	\N	
3685	\N	\N	\N	
3686	\N	\N	\N	
3687	\N	\N	\N	
3688	\N	\N	\N	
3689	\N	\N	\N	
3690	\N	\N	\N	
3691	\N	\N	\N	
3692	\N	\N	\N	
3693	\N	\N	\N	
3694	\N	\N	\N	
3695	\N	\N	\N	
3696	\N	\N	\N	
3697	\N	\N	\N	
3698	\N	\N	\N	
3699	\N	\N	\N	
3700	\N	\N	\N	
3701	\N	\N	\N	
3702	\N	\N	\N	
3703	\N	\N	\N	
3704	\N	\N	\N	
3705	\N	\N	\N	
3706	\N	\N	\N	
3707	\N	\N	\N	
3708	\N	\N	\N	
3709	\N	\N	\N	
3710	\N	\N	\N	
3711	\N	\N	\N	
3712	\N	\N	\N	
3713	\N	\N	\N	
3714	\N	\N	\N	
3715	\N	\N	\N	
3716	\N	\N	\N	
3717	\N	\N	\N	
3718	\N	\N	\N	
3719	\N	\N	\N	
3720	\N	\N	\N	
3721	\N	\N	\N	
3722	\N	\N	\N	
3723	\N	\N	\N	
3724	\N	\N	\N	
3725	\N	\N	\N	
3726	\N	\N	\N	
3727	\N	\N	\N	
3728	\N	\N	\N	
3729	\N	\N	\N	
3730	\N	\N	\N	
3731	\N	\N	\N	
3732	\N	\N	\N	
3733	\N	\N	\N	
3734	\N	\N	\N	
3735	\N	\N	\N	
3736	\N	\N	\N	
3737	\N	\N	\N	
3738	\N	\N	\N	
3739	\N	\N	\N	
3740	\N	\N	\N	
3741	\N	\N	\N	
3742	\N	\N	\N	
3743	\N	\N	\N	
3744	\N	\N	\N	
3745	\N	\N	\N	
3746	\N	\N	\N	
3747	\N	\N	\N	
3748	\N	\N	\N	
3749	\N	\N	\N	
3750	\N	\N	\N	
3751	\N	\N	\N	
3752	\N	\N	\N	
3753	\N	\N	\N	
3754	\N	\N	\N	
3755	\N	\N	\N	
3756	\N	\N	\N	
3757	\N	\N	\N	
3758	\N	\N	\N	
3759	\N	\N	\N	
3760	\N	\N	\N	
3761	\N	\N	\N	
3762	\N	\N	\N	
3763	\N	\N	\N	
3764	\N	\N	\N	
3765	\N	\N	\N	
3766	\N	\N	\N	
3767	\N	\N	\N	
3768	\N	\N	\N	
3769	\N	\N	\N	
3770	\N	\N	\N	
3771	\N	\N	\N	
3772	\N	\N	\N	
3773	\N	\N	\N	
3774	\N	\N	\N	
3775	\N	\N	\N	
3776	\N	\N	\N	
3777	\N	\N	\N	
3778	\N	\N	\N	
3779	\N	\N	\N	
3780	\N	\N	\N	
3781	\N	\N	\N	
3782	\N	\N	\N	
3783	\N	\N	\N	
3784	\N	\N	\N	
3785	\N	\N	\N	
3786	\N	\N	\N	
3787	\N	\N	\N	
3788	\N	\N	\N	
3789	\N	\N	\N	
3790	\N	\N	\N	
3791	\N	\N	\N	
3792	\N	\N	\N	
3793	\N	\N	\N	
3794	\N	\N	\N	
3795	\N	\N	\N	
3796	\N	\N	\N	
3797	\N	\N	\N	
3798	\N	\N	\N	
3799	\N	\N	\N	
3800	\N	\N	\N	
3801	\N	\N	\N	
3802	\N	\N	\N	
3803	\N	\N	\N	
3804	\N	\N	\N	
3805	\N	\N	\N	
3806	\N	\N	\N	
3807	\N	\N	\N	
3808	\N	\N	\N	
3809	\N	\N	\N	
3810	\N	\N	\N	
3811	\N	\N	\N	
3812	\N	\N	\N	
3813	\N	\N	\N	
3814	\N	\N	\N	
3815	\N	\N	\N	
3816	\N	\N	\N	
3817	\N	\N	\N	
3818	\N	\N	\N	
3819	\N	\N	\N	
3820	\N	\N	\N	
3821	\N	\N	\N	
3822	\N	\N	\N	
3823	\N	\N	\N	
3824	\N	\N	\N	
3825	\N	\N	\N	
3826	\N	\N	\N	
3827	\N	\N	\N	
3828	\N	\N	\N	
3829	\N	\N	\N	
3830	\N	\N	\N	
3831	\N	\N	\N	
3832	\N	\N	\N	
3833	\N	\N	\N	
3834	\N	\N	\N	
3835	\N	\N	\N	
3836	\N	\N	\N	
3837	\N	\N	\N	
3838	\N	\N	\N	
3839	\N	\N	\N	
3840	\N	\N	\N	
3841	\N	\N	\N	
3842	\N	\N	\N	
3843	\N	\N	\N	
3844	\N	\N	\N	
3845	\N	\N	\N	
3846	\N	\N	\N	
3847	\N	\N	\N	
3848	\N	\N	\N	
3849	\N	\N	\N	
3850	\N	\N	\N	
3851	\N	\N	\N	
3852	\N	\N	\N	
3853	\N	\N	\N	
3854	\N	\N	\N	
3855	\N	\N	\N	
3856	\N	\N	\N	
3857	\N	\N	\N	
3858	\N	\N	\N	
3859	\N	\N	\N	
3860	\N	\N	\N	
3861	\N	\N	\N	
3862	\N	\N	\N	
3863	\N	\N	\N	
3864	\N	\N	\N	
3865	\N	\N	\N	
3866	\N	\N	\N	
3867	\N	\N	\N	
3868	\N	\N	\N	
3869	\N	\N	\N	
3870	\N	\N	\N	
3871	\N	\N	\N	
3872	\N	\N	\N	
3873	\N	\N	\N	
3874	\N	\N	\N	
3875	\N	\N	\N	
3876	\N	\N	\N	
3877	\N	\N	\N	
3878	\N	\N	\N	
3879	\N	\N	\N	
3880	\N	\N	\N	
3881	\N	\N	\N	
3882	\N	\N	\N	
3883	\N	\N	\N	
3884	\N	\N	\N	
3885	\N	\N	\N	
3886	\N	\N	\N	
3887	\N	\N	\N	
3888	\N	\N	\N	
3889	\N	\N	\N	
3890	\N	\N	\N	
3891	\N	\N	\N	
3892	\N	\N	\N	
3893	\N	\N	\N	
3894	\N	\N	\N	
3895	\N	\N	\N	
3896	\N	\N	\N	
3897	\N	\N	\N	
3898	\N	\N	\N	
3899	\N	\N	\N	
3900	\N	\N	\N	
3901	\N	\N	\N	
3902	\N	\N	\N	
3903	\N	\N	\N	
3904	\N	\N	\N	
3905	\N	\N	\N	
3906	\N	\N	\N	
3907	\N	\N	\N	
3908	\N	\N	\N	
3909	\N	\N	\N	
3910	\N	\N	\N	
3911	\N	\N	\N	
3912	\N	\N	\N	
3913	\N	\N	\N	
3914	\N	\N	\N	
3915	\N	\N	\N	
3916	\N	\N	\N	
3917	\N	\N	\N	
3918	\N	\N	\N	
3919	\N	\N	\N	
3920	\N	\N	\N	
3921	\N	\N	\N	
3922	\N	\N	\N	
3923	\N	\N	\N	
3924	\N	\N	\N	
3925	\N	\N	\N	
3926	\N	\N	\N	
3927	\N	\N	\N	
3928	\N	\N	\N	
3929	\N	\N	\N	
3930	\N	\N	\N	
3931	\N	\N	\N	
3932	\N	\N	\N	
3933	\N	\N	\N	
3934	\N	\N	\N	
3935	\N	\N	\N	
3936	\N	\N	\N	
3937	\N	\N	\N	
3938	\N	\N	\N	
3939	\N	\N	\N	
3940	\N	\N	\N	
3941	\N	\N	\N	
3942	\N	\N	\N	
3943	\N	\N	\N	
3944	\N	\N	\N	
3945	\N	\N	\N	
3946	\N	\N	\N	
3947	\N	\N	\N	
3948	\N	\N	\N	
3949	\N	\N	\N	
3950	\N	\N	\N	
3951	\N	\N	\N	
3952	\N	\N	\N	
3953	\N	\N	\N	
3954	\N	\N	\N	
3955	\N	\N	\N	
3956	\N	\N	\N	
3957	\N	\N	\N	
3958	\N	\N	\N	
3959	\N	\N	\N	
3960	\N	\N	\N	
3961	\N	\N	\N	
3962	\N	\N	\N	
3963	\N	\N	\N	
3964	\N	\N	\N	
3965	\N	\N	\N	
3966	\N	\N	\N	
3967	\N	\N	\N	
3968	\N	\N	\N	
3969	\N	\N	\N	
3970	\N	\N	\N	
3971	\N	\N	\N	
3972	\N	\N	\N	
3973	\N	\N	\N	
3974	\N	\N	\N	
3975	\N	\N	\N	
3976	\N	\N	\N	
3977	\N	\N	\N	
3978	\N	\N	\N	
3979	\N	\N	\N	
3980	\N	\N	\N	
3981	\N	\N	\N	
3982	\N	\N	\N	
3983	\N	\N	\N	
3984	\N	\N	\N	
3985	\N	\N	\N	
3986	\N	\N	\N	
3987	\N	\N	\N	
3988	\N	\N	\N	
3989	\N	\N	\N	
3990	\N	\N	\N	
3991	\N	\N	\N	
3992	\N	\N	\N	
3993	\N	\N	\N	
3994	\N	\N	\N	
3995	\N	\N	\N	
3996	\N	\N	\N	
3997	\N	\N	\N	
3998	\N	\N	\N	
3999	\N	\N	\N	
4000	\N	\N	\N	
4001	\N	\N	\N	
4002	\N	\N	\N	
4003	\N	\N	\N	
4004	\N	\N	\N	
4005	\N	\N	\N	
4006	\N	\N	\N	
4007	\N	\N	\N	
4008	\N	\N	\N	
4009	\N	\N	\N	
4010	\N	\N	\N	
4011	\N	\N	\N	
4012	\N	\N	\N	
4013	\N	\N	\N	
4014	\N	\N	\N	
4015	\N	\N	\N	
4016	\N	\N	\N	
4017	\N	\N	\N	
4018	\N	\N	\N	
4019	\N	\N	\N	
4020	\N	\N	\N	
4021	\N	\N	\N	
4022	\N	\N	\N	
4023	\N	\N	\N	
4024	\N	\N	\N	
4025	\N	\N	\N	
4026	\N	\N	\N	
4027	\N	\N	\N	
4028	\N	\N	\N	
4029	\N	\N	\N	
4030	\N	\N	\N	
4031	\N	\N	\N	
4032	\N	\N	\N	
4033	\N	\N	\N	
4034	\N	\N	\N	
4035	\N	\N	\N	
4036	\N	\N	\N	
4037	\N	\N	\N	
4038	\N	\N	\N	
4039	\N	\N	\N	
4040	\N	\N	\N	
4041	\N	\N	\N	
4042	\N	\N	\N	
4043	\N	\N	\N	
4044	\N	\N	\N	
4045	\N	\N	\N	
4046	\N	\N	\N	
4047	\N	\N	\N	
4048	\N	\N	\N	
4049	\N	\N	\N	
4050	\N	\N	\N	
4051	\N	\N	\N	
4052	\N	\N	\N	
4053	\N	\N	\N	
4054	\N	\N	\N	
4055	\N	\N	\N	
4056	\N	\N	\N	
4057	\N	\N	\N	
4058	\N	\N	\N	
4059	\N	\N	\N	
4060	\N	\N	\N	
4061	\N	\N	\N	
4062	\N	\N	\N	
4063	\N	\N	\N	
4064	\N	\N	\N	
4065	\N	\N	\N	
4066	\N	\N	\N	
4067	\N	\N	\N	
4068	\N	\N	\N	
4069	\N	\N	\N	
4070	\N	\N	\N	
4071	\N	\N	\N	
4072	\N	\N	\N	
4073	\N	\N	\N	
4074	\N	\N	\N	
4075	\N	\N	\N	
4076	\N	\N	\N	
4077	\N	\N	\N	
4078	\N	\N	\N	
4079	\N	\N	\N	
4080	\N	\N	\N	
4081	\N	\N	\N	
4082	\N	\N	\N	
4083	\N	\N	\N	
4084	\N	\N	\N	
4085	\N	\N	\N	
4086	\N	\N	\N	
4087	\N	\N	\N	
4088	\N	\N	\N	
4089	\N	\N	\N	
4090	\N	\N	\N	
4091	\N	\N	\N	
4092	\N	\N	\N	
4093	\N	\N	\N	
4094	\N	\N	\N	
4095	\N	\N	\N	
4096	\N	\N	\N	
4097	\N	\N	\N	
4098	\N	\N	\N	
4099	\N	\N	\N	
4100	\N	\N	\N	
4101	\N	\N	\N	
4102	\N	\N	\N	
4103	\N	\N	\N	
4104	\N	\N	\N	
4105	\N	\N	\N	
4106	\N	\N	\N	
4107	\N	\N	\N	
4108	\N	\N	\N	
4109	\N	\N	\N	
4110	\N	\N	\N	
4111	\N	\N	\N	
4112	\N	\N	\N	
4113	\N	\N	\N	
4114	\N	\N	\N	
4115	\N	\N	\N	
4116	\N	\N	\N	
4117	\N	\N	\N	
4118	\N	\N	\N	
4119	\N	\N	\N	
4120	\N	\N	\N	
4121	\N	\N	\N	
4122	\N	\N	\N	
4123	\N	\N	\N	
4124	\N	\N	\N	
4125	\N	\N	\N	
4126	\N	\N	\N	
4127	\N	\N	\N	
4128	\N	\N	\N	
4129	\N	\N	\N	
4130	\N	\N	\N	
4131	\N	\N	\N	
4132	\N	\N	\N	
4133	\N	\N	\N	
4134	\N	\N	\N	
4135	\N	\N	\N	
4136	\N	\N	\N	
4137	\N	\N	\N	
4138	\N	\N	\N	
4139	\N	\N	\N	
4140	\N	\N	\N	
4141	\N	\N	\N	
4142	\N	\N	\N	
4143	\N	\N	\N	
4144	\N	\N	\N	
4145	\N	\N	\N	
4146	\N	\N	\N	
4147	\N	\N	\N	
4148	\N	\N	\N	
4149	\N	\N	\N	
4150	\N	\N	\N	
4151	\N	\N	\N	
4152	\N	\N	\N	
4153	\N	\N	\N	
4154	\N	\N	\N	
4155	\N	\N	\N	
4156	\N	\N	\N	
4157	\N	\N	\N	
4158	\N	\N	\N	
4159	\N	\N	\N	
4160	\N	\N	\N	
4161	\N	\N	\N	
4162	\N	\N	\N	
4163	\N	\N	\N	
4164	\N	\N	\N	
4165	\N	\N	\N	
4166	\N	\N	\N	
4167	\N	\N	\N	
4168	\N	\N	\N	
4169	\N	\N	\N	
4170	\N	\N	\N	
4171	\N	\N	\N	
4172	\N	\N	\N	
4173	\N	\N	\N	
4174	\N	\N	\N	
4175	\N	\N	\N	
4176	\N	\N	\N	
4177	\N	\N	\N	
4178	\N	\N	\N	
4179	\N	\N	\N	
4180	\N	\N	\N	
4181	\N	\N	\N	
4182	\N	\N	\N	
4183	\N	\N	\N	
4184	\N	\N	\N	
4185	\N	\N	\N	
4186	\N	\N	\N	
4187	\N	\N	\N	
4188	\N	\N	\N	
4189	\N	\N	\N	
4190	\N	\N	\N	
4191	\N	\N	\N	
4192	\N	\N	\N	
4193	\N	\N	\N	
4194	\N	\N	\N	
4195	\N	\N	\N	
4196	\N	\N	\N	
4197	\N	\N	\N	
4198	\N	\N	\N	
4199	\N	\N	\N	
4200	\N	\N	\N	
4201	\N	\N	\N	
4202	\N	\N	\N	
4203	\N	\N	\N	
4204	\N	\N	\N	
4205	\N	\N	\N	
4206	\N	\N	\N	
4207	\N	\N	\N	
4208	\N	\N	\N	
4209	\N	\N	\N	
4210	\N	\N	\N	
4211	\N	\N	\N	
4212	\N	\N	\N	
4213	\N	\N	\N	
4214	\N	\N	\N	
4215	\N	\N	\N	
4216	\N	\N	\N	
4217	\N	\N	\N	
4218	\N	\N	\N	
4219	\N	\N	\N	
4220	\N	\N	\N	
4221	\N	\N	\N	
4222	\N	\N	\N	
4223	\N	\N	\N	
4224	\N	\N	\N	
4225	\N	\N	\N	
4226	\N	\N	\N	
4227	\N	\N	\N	
4228	\N	\N	\N	
4229	\N	\N	\N	
4230	\N	\N	\N	
4231	\N	\N	\N	
4232	\N	\N	\N	
4233	\N	\N	\N	
4234	\N	\N	\N	
4235	\N	\N	\N	
4236	\N	\N	\N	
4237	\N	\N	\N	
4238	\N	\N	\N	
4239	\N	\N	\N	
4240	\N	\N	\N	
4241	\N	\N	\N	
4242	\N	\N	\N	
4243	\N	\N	\N	
4244	\N	\N	\N	
4245	\N	\N	\N	
4246	\N	\N	\N	
4247	\N	\N	\N	
4248	\N	\N	\N	
4249	\N	\N	\N	
4250	\N	\N	\N	
4251	\N	\N	\N	
4252	\N	\N	\N	
4253	\N	\N	\N	
4254	\N	\N	\N	
4255	\N	\N	\N	
4256	\N	\N	\N	
4257	\N	\N	\N	
4258	\N	\N	\N	
4259	\N	\N	\N	
4260	\N	\N	\N	
4261	\N	\N	\N	
4262	\N	\N	\N	
4263	\N	\N	\N	
4264	\N	\N	\N	
4265	\N	\N	\N	
4266	\N	\N	\N	
4267	\N	\N	\N	
4268	\N	\N	\N	
4269	\N	\N	\N	
4270	\N	\N	\N	
4271	\N	\N	\N	
4272	\N	\N	\N	
4273	\N	\N	\N	
4274	\N	\N	\N	
4275	\N	\N	\N	
4276	\N	\N	\N	
4277	\N	\N	\N	
4278	\N	\N	\N	
4279	\N	\N	\N	
4280	\N	\N	\N	
4281	\N	\N	\N	
4282	\N	\N	\N	
4283	\N	\N	\N	
4284	\N	\N	\N	
4285	\N	\N	\N	
4286	\N	\N	\N	
4287	\N	\N	\N	
4288	\N	\N	\N	
4289	\N	\N	\N	
4290	\N	\N	\N	
4291	\N	\N	\N	
4292	\N	\N	\N	
4293	\N	\N	\N	
4294	\N	\N	\N	
4295	\N	\N	\N	
4296	\N	\N	\N	
4297	\N	\N	\N	
4298	\N	\N	\N	
4299	\N	\N	\N	
4300	\N	\N	\N	
4301	\N	\N	\N	
4302	\N	\N	\N	
4303	\N	\N	\N	
4304	\N	\N	\N	
4305	\N	\N	\N	
4306	\N	\N	\N	
4307	\N	\N	\N	
4308	\N	\N	\N	
4309	\N	\N	\N	
4310	\N	\N	\N	
4311	\N	\N	\N	
4312	\N	\N	\N	
4313	\N	\N	\N	
4314	\N	\N	\N	
4315	\N	\N	\N	
4316	\N	\N	\N	
4317	\N	\N	\N	
4318	\N	\N	\N	
4319	\N	\N	\N	
4320	\N	\N	\N	
4321	\N	\N	\N	
4322	\N	\N	\N	
4323	\N	\N	\N	
4324	\N	\N	\N	
4325	\N	\N	\N	
4326	\N	\N	\N	
4327	\N	\N	\N	
4328	\N	\N	\N	
4329	\N	\N	\N	
4330	\N	\N	\N	
4331	\N	\N	\N	
4332	\N	\N	\N	
4333	\N	\N	\N	
4334	\N	\N	\N	
4335	\N	\N	\N	
4336	\N	\N	\N	
4337	\N	\N	\N	
4338	\N	\N	\N	
4339	\N	\N	\N	
4340	\N	\N	\N	
4341	\N	\N	\N	
4342	\N	\N	\N	
4343	\N	\N	\N	
4344	\N	\N	\N	
4345	\N	\N	\N	
4346	\N	\N	\N	
4347	\N	\N	\N	
4348	\N	\N	\N	
4349	\N	\N	\N	
4350	\N	\N	\N	
4351	\N	\N	\N	
4352	\N	\N	\N	
4353	\N	\N	\N	
4354	\N	\N	\N	
4355	\N	\N	\N	
4356	\N	\N	\N	
4357	\N	\N	\N	
4358	\N	\N	\N	
4359	\N	\N	\N	
4360	\N	\N	\N	
4361	\N	\N	\N	
4362	\N	\N	\N	
4363	\N	\N	\N	
4364	\N	\N	\N	
4365	\N	\N	\N	
4366	\N	\N	\N	
4367	\N	\N	\N	
4368	\N	\N	\N	
4369	\N	\N	\N	
4370	\N	\N	\N	
4371	\N	\N	\N	
4372	\N	\N	\N	
4373	\N	\N	\N	
4374	\N	\N	\N	
4375	\N	\N	\N	
4376	\N	\N	\N	
4377	\N	\N	\N	
4378	\N	\N	\N	
4379	\N	\N	\N	
4380	\N	\N	\N	
4381	\N	\N	\N	
4382	\N	\N	\N	
4383	\N	\N	\N	
4384	\N	\N	\N	
4385	\N	\N	\N	
4386	\N	\N	\N	
4387	\N	\N	\N	
4388	\N	\N	\N	
4389	\N	\N	\N	
4390	\N	\N	\N	
4391	\N	\N	\N	
4392	\N	\N	\N	
4393	\N	\N	\N	
4394	\N	\N	\N	
4395	\N	\N	\N	
4396	\N	\N	\N	
4397	\N	\N	\N	
4398	\N	\N	\N	
4399	\N	\N	\N	
4400	\N	\N	\N	
4401	\N	\N	\N	
4402	\N	\N	\N	
4403	\N	\N	\N	
4404	\N	\N	\N	
4405	\N	\N	\N	
4406	\N	\N	\N	
4407	\N	\N	\N	
4408	\N	\N	\N	
4409	\N	\N	\N	
4410	\N	\N	\N	
4411	\N	\N	\N	
4412	\N	\N	\N	
4413	\N	\N	\N	
4414	\N	\N	\N	
4415	\N	\N	\N	
4416	\N	\N	\N	
4417	\N	\N	\N	
4418	\N	\N	\N	
4419	\N	\N	\N	
4420	\N	\N	\N	
4421	\N	\N	\N	
4422	\N	\N	\N	
4423	\N	\N	\N	
4424	\N	\N	\N	
4425	\N	\N	\N	
4426	\N	\N	\N	
4427	\N	\N	\N	
4428	\N	\N	\N	
4429	\N	\N	\N	
4430	\N	\N	\N	
4431	\N	\N	\N	
4432	\N	\N	\N	
4433	\N	\N	\N	
4434	\N	\N	\N	
4435	\N	\N	\N	
4436	\N	\N	\N	
4437	\N	\N	\N	
4438	\N	\N	\N	
4439	\N	\N	\N	
4440	\N	\N	\N	
4441	\N	\N	\N	
4442	\N	\N	\N	
4443	\N	\N	\N	
4444	\N	\N	\N	
4445	\N	\N	\N	
4446	\N	\N	\N	
4447	\N	\N	\N	
4448	\N	\N	\N	
4449	\N	\N	\N	
4450	\N	\N	\N	
4451	\N	\N	\N	
4452	\N	\N	\N	
4453	\N	\N	\N	
4454	\N	\N	\N	
4455	\N	\N	\N	
4456	\N	\N	\N	
4457	\N	\N	\N	
4458	\N	\N	\N	
4459	\N	\N	\N	
4460	\N	\N	\N	
4461	\N	\N	\N	
4462	\N	\N	\N	
4463	\N	\N	\N	
4464	\N	\N	\N	
4465	\N	\N	\N	
4466	\N	\N	\N	
4467	\N	\N	\N	
4468	\N	\N	\N	
4469	\N	\N	\N	
4470	\N	\N	\N	
4471	\N	\N	\N	
4472	\N	\N	\N	
4473	\N	\N	\N	
4474	\N	\N	\N	
4475	\N	\N	\N	
4476	\N	\N	\N	
4477	\N	\N	\N	
4478	\N	\N	\N	
4479	\N	\N	\N	
4480	\N	\N	\N	
4481	\N	\N	\N	
4482	\N	\N	\N	
4483	\N	\N	\N	
4484	\N	\N	\N	
4485	\N	\N	\N	
4486	\N	\N	\N	
4487	\N	\N	\N	
4488	\N	\N	\N	
4489	\N	\N	\N	
4490	\N	\N	\N	
4491	\N	\N	\N	
4492	\N	\N	\N	
4493	\N	\N	\N	
4494	\N	\N	\N	
4495	\N	\N	\N	
4496	\N	\N	\N	
4497	\N	\N	\N	
4498	\N	\N	\N	
4499	\N	\N	\N	
4500	\N	\N	\N	
4501	\N	\N	\N	
4502	\N	\N	\N	
4503	\N	\N	\N	
4504	\N	\N	\N	
4505	\N	\N	\N	
4506	\N	\N	\N	
4507	\N	\N	\N	
4508	\N	\N	\N	
4509	\N	\N	\N	
4510	\N	\N	\N	
4511	\N	\N	\N	
4512	\N	\N	\N	
4513	\N	\N	\N	
4514	\N	\N	\N	
4515	\N	\N	\N	
4516	\N	\N	\N	
4517	\N	\N	\N	
4518	\N	\N	\N	
4519	\N	\N	\N	
4520	\N	\N	\N	
4521	\N	\N	\N	
4522	\N	\N	\N	
4523	\N	\N	\N	
4524	\N	\N	\N	
4525	\N	\N	\N	
4526	\N	\N	\N	
4527	\N	\N	\N	
4528	\N	\N	\N	
4529	\N	\N	\N	
4530	\N	\N	\N	
4531	\N	\N	\N	
4532	\N	\N	\N	
4533	\N	\N	\N	
4534	\N	\N	\N	
4535	\N	\N	\N	
4536	\N	\N	\N	
4537	\N	\N	\N	
4538	\N	\N	\N	
4539	\N	\N	\N	
4540	\N	\N	\N	
4541	\N	\N	\N	
4542	\N	\N	\N	
4543	\N	\N	\N	
4544	\N	\N	\N	
4545	\N	\N	\N	
4546	\N	\N	\N	
4547	\N	\N	\N	
4548	\N	\N	\N	
4549	\N	\N	\N	
4550	\N	\N	\N	
4551	\N	\N	\N	
4552	\N	\N	\N	
4553	\N	\N	\N	
4554	\N	\N	\N	
4555	\N	\N	\N	
4556	\N	\N	\N	
4557	\N	\N	\N	
4558	\N	\N	\N	
4559	\N	\N	\N	
4560	\N	\N	\N	
4561	\N	\N	\N	
4562	\N	\N	\N	
4563	\N	\N	\N	
4564	\N	\N	\N	
4565	\N	\N	\N	
4566	\N	\N	\N	
4567	\N	\N	\N	
4568	\N	\N	\N	
4569	\N	\N	\N	
4570	\N	\N	\N	
4571	\N	\N	\N	
4572	\N	\N	\N	
4573	\N	\N	\N	
4574	\N	\N	\N	
4575	\N	\N	\N	
4576	\N	\N	\N	
4577	\N	\N	\N	
4578	\N	\N	\N	
4579	\N	\N	\N	
4580	\N	\N	\N	
4581	\N	\N	\N	
4582	\N	\N	\N	
4583	\N	\N	\N	
4584	\N	\N	\N	
4585	\N	\N	\N	
4586	\N	\N	\N	
4587	\N	\N	\N	
4588	\N	\N	\N	
4589	\N	\N	\N	
4590	\N	\N	\N	
4591	\N	\N	\N	
4592	\N	\N	\N	
4593	\N	\N	\N	
4594	\N	\N	\N	
4595	\N	\N	\N	
4596	\N	\N	\N	
4597	\N	\N	\N	
4598	\N	\N	\N	
4599	\N	\N	\N	
4600	\N	\N	\N	
4601	\N	\N	\N	
4602	\N	\N	\N	
4603	\N	\N	\N	
4604	\N	\N	\N	
4605	\N	\N	\N	
4606	\N	\N	\N	
4607	\N	\N	\N	
4608	\N	\N	\N	
4609	\N	\N	\N	
4610	\N	\N	\N	
4611	\N	\N	\N	
4612	\N	\N	\N	
4613	\N	\N	\N	
4614	\N	\N	\N	
4615	\N	\N	\N	
4616	\N	\N	\N	
4617	\N	\N	\N	
4618	\N	\N	\N	
4619	\N	\N	\N	
4620	\N	\N	\N	
4621	\N	\N	\N	
4622	\N	\N	\N	
4623	\N	\N	\N	
4624	\N	\N	\N	
4625	\N	\N	\N	
4626	\N	\N	\N	
4627	\N	\N	\N	
4628	\N	\N	\N	
4629	\N	\N	\N	
4630	\N	\N	\N	
4631	\N	\N	\N	
4632	\N	\N	\N	
4633	\N	\N	\N	
4634	\N	\N	\N	
4635	\N	\N	\N	
4636	\N	\N	\N	
4637	\N	\N	\N	
4638	\N	\N	\N	
4639	\N	\N	\N	
4640	\N	\N	\N	
4641	\N	\N	\N	
4642	\N	\N	\N	
4643	\N	\N	\N	
4644	\N	\N	\N	
4645	\N	\N	\N	
4646	\N	\N	\N	
4647	\N	\N	\N	
4648	\N	\N	\N	
4649	\N	\N	\N	
4650	\N	\N	\N	
4651	\N	\N	\N	
4652	\N	\N	\N	
4653	\N	\N	\N	
4654	\N	\N	\N	
4655	\N	\N	\N	
4656	\N	\N	\N	
4657	\N	\N	\N	
4658	\N	\N	\N	
4659	\N	\N	\N	
4660	\N	\N	\N	
4661	\N	\N	\N	
4662	\N	\N	\N	
4663	\N	\N	\N	
4664	\N	\N	\N	
4665	\N	\N	\N	
4666	\N	\N	\N	
4667	\N	\N	\N	
4668	\N	\N	\N	
4669	\N	\N	\N	
4670	\N	\N	\N	
4671	\N	\N	\N	
4672	\N	\N	\N	
4673	\N	\N	\N	
4674	\N	\N	\N	
4675	\N	\N	\N	
4676	\N	\N	\N	
4677	\N	\N	\N	
4678	\N	\N	\N	
4679	\N	\N	\N	
4680	\N	\N	\N	
4681	\N	\N	\N	
4682	\N	\N	\N	
4683	\N	\N	\N	
4684	\N	\N	\N	
4685	\N	\N	\N	
4686	\N	\N	\N	
4687	\N	\N	\N	
4688	\N	\N	\N	
4689	\N	\N	\N	
4690	\N	\N	\N	
4691	\N	\N	\N	
4692	\N	\N	\N	
4693	\N	\N	\N	
4694	\N	\N	\N	
4695	\N	\N	\N	
4696	\N	\N	\N	
4697	\N	\N	\N	
4698	\N	\N	\N	
4699	\N	\N	\N	
4700	\N	\N	\N	
4701	\N	\N	\N	
4702	\N	\N	\N	
4703	\N	\N	\N	
4704	\N	\N	\N	
4705	\N	\N	\N	
4706	\N	\N	\N	
4707	\N	\N	\N	
4708	\N	\N	\N	
4709	\N	\N	\N	
4710	\N	\N	\N	
4711	\N	\N	\N	
4712	\N	\N	\N	
4713	\N	\N	\N	
4714	\N	\N	\N	
4715	\N	\N	\N	
4716	\N	\N	\N	
4717	\N	\N	\N	
4718	\N	\N	\N	
4719	\N	\N	\N	
4720	\N	\N	\N	
4721	\N	\N	\N	
4722	\N	\N	\N	
4723	\N	\N	\N	
4724	\N	\N	\N	
4725	\N	\N	\N	
4726	\N	\N	\N	
4727	\N	\N	\N	
4728	\N	\N	\N	
4729	\N	\N	\N	
4730	\N	\N	\N	
4731	\N	\N	\N	
4732	\N	\N	\N	
4733	\N	\N	\N	
4734	\N	\N	\N	
4735	\N	\N	\N	
4736	\N	\N	\N	
4737	\N	\N	\N	
4738	\N	\N	\N	
4739	\N	\N	\N	
4740	\N	\N	\N	
4741	\N	\N	\N	
4742	\N	\N	\N	
4743	\N	\N	\N	
4744	\N	\N	\N	
4745	\N	\N	\N	
4746	\N	\N	\N	
4747	\N	\N	\N	
4748	\N	\N	\N	
4749	\N	\N	\N	
4750	\N	\N	\N	
4751	\N	\N	\N	
4752	\N	\N	\N	
4753	\N	\N	\N	
4754	\N	\N	\N	
4755	\N	\N	\N	
4756	\N	\N	\N	
4757	\N	\N	\N	
4758	\N	\N	\N	
4759	\N	\N	\N	
4760	\N	\N	\N	
4761	\N	\N	\N	
4762	\N	\N	\N	
4763	\N	\N	\N	
4764	\N	\N	\N	
4765	\N	\N	\N	
4766	\N	\N	\N	
4767	\N	\N	\N	
4768	\N	\N	\N	
4769	\N	\N	\N	
4770	\N	\N	\N	
4771	\N	\N	\N	
4772	\N	\N	\N	
4773	\N	\N	\N	
4774	\N	\N	\N	
4775	\N	\N	\N	
4776	\N	\N	\N	
4777	\N	\N	\N	
4778	\N	\N	\N	
4779	\N	\N	\N	
4780	\N	\N	\N	
4781	\N	\N	\N	
4782	\N	\N	\N	
4783	\N	\N	\N	
4784	\N	\N	\N	
4785	\N	\N	\N	
4786	\N	\N	\N	
4787	\N	\N	\N	
4788	\N	\N	\N	
4789	\N	\N	\N	
4790	\N	\N	\N	
4791	\N	\N	\N	
4792	\N	\N	\N	
4793	\N	\N	\N	
4794	\N	\N	\N	
4795	\N	\N	\N	
4796	\N	\N	\N	
4797	\N	\N	\N	
4798	\N	\N	\N	
4799	\N	\N	\N	
4800	\N	\N	\N	
4801	\N	\N	\N	
4802	\N	\N	\N	
4803	\N	\N	\N	
4804	\N	\N	\N	
4805	\N	\N	\N	
4806	\N	\N	\N	
4807	\N	\N	\N	
4808	\N	\N	\N	
4809	\N	\N	\N	
4810	\N	\N	\N	
4811	\N	\N	\N	
4812	\N	\N	\N	
4813	\N	\N	\N	
4814	\N	\N	\N	
4815	\N	\N	\N	
4816	\N	\N	\N	
4817	\N	\N	\N	
4818	\N	\N	\N	
4819	\N	\N	\N	
4820	\N	\N	\N	
4821	\N	\N	\N	
4822	\N	\N	\N	
4823	\N	\N	\N	
4824	\N	\N	\N	
4825	\N	\N	\N	
4826	\N	\N	\N	
4827	\N	\N	\N	
4828	\N	\N	\N	
4829	\N	\N	\N	
4830	\N	\N	\N	
4831	\N	\N	\N	
4832	\N	\N	\N	
4833	\N	\N	\N	
4834	\N	\N	\N	
4835	\N	\N	\N	
4836	\N	\N	\N	
4837	\N	\N	\N	
4838	\N	\N	\N	
4839	\N	\N	\N	
4840	\N	\N	\N	
4841	\N	\N	\N	
4842	\N	\N	\N	
4843	\N	\N	\N	
4844	\N	\N	\N	
4845	\N	\N	\N	
4846	\N	\N	\N	
4847	\N	\N	\N	
4848	\N	\N	\N	
4849	\N	\N	\N	
4850	\N	\N	\N	
4851	\N	\N	\N	
4852	\N	\N	\N	
4853	\N	\N	\N	
4854	\N	\N	\N	
4855	\N	\N	\N	
4856	\N	\N	\N	
4857	\N	\N	\N	
4858	\N	\N	\N	
4859	\N	\N	\N	
4860	\N	\N	\N	
4861	\N	\N	\N	
4862	\N	\N	\N	
4863	\N	\N	\N	
4864	\N	\N	\N	
4865	\N	\N	\N	
4866	\N	\N	\N	
4867	\N	\N	\N	
4868	\N	\N	\N	
4869	\N	\N	\N	
4870	\N	\N	\N	
4871	\N	\N	\N	
4872	\N	\N	\N	
4873	\N	\N	\N	
4874	\N	\N	\N	
4875	\N	\N	\N	
4876	\N	\N	\N	
4877	\N	\N	\N	
4878	\N	\N	\N	
4879	\N	\N	\N	
4880	\N	\N	\N	
4881	\N	\N	\N	
4882	\N	\N	\N	
4883	\N	\N	\N	
4884	\N	\N	\N	
4885	\N	\N	\N	
4886	\N	\N	\N	
4887	\N	\N	\N	
4888	\N	\N	\N	
4889	\N	\N	\N	
4890	\N	\N	\N	
4891	\N	\N	\N	
4892	\N	\N	\N	
4893	\N	\N	\N	
4894	\N	\N	\N	
4895	\N	\N	\N	
4896	\N	\N	\N	
4897	\N	\N	\N	
4898	\N	\N	\N	
4899	\N	\N	\N	
4900	\N	\N	\N	
4901	\N	\N	\N	
4902	\N	\N	\N	
4903	\N	\N	\N	
4904	\N	\N	\N	
4905	\N	\N	\N	
4906	\N	\N	\N	
4907	\N	\N	\N	
4908	\N	\N	\N	
4909	\N	\N	\N	
4910	\N	\N	\N	
4911	\N	\N	\N	
4912	\N	\N	\N	
4913	\N	\N	\N	
4914	\N	\N	\N	
4915	\N	\N	\N	
4916	\N	\N	\N	
4917	\N	\N	\N	
4918	\N	\N	\N	
4919	\N	\N	\N	
4920	\N	\N	\N	
4921	\N	\N	\N	
4922	\N	\N	\N	
4923	\N	\N	\N	
4924	\N	\N	\N	
4925	\N	\N	\N	
4926	\N	\N	\N	
4927	\N	\N	\N	
4928	\N	\N	\N	
4929	\N	\N	\N	
4930	\N	\N	\N	
4931	\N	\N	\N	
4932	\N	\N	\N	
4933	\N	\N	\N	
4934	\N	\N	\N	
4935	\N	\N	\N	
4936	\N	\N	\N	
4937	\N	\N	\N	
4938	\N	\N	\N	
4939	\N	\N	\N	
4940	\N	\N	\N	
4941	\N	\N	\N	
4942	\N	\N	\N	
4943	\N	\N	\N	
4944	\N	\N	\N	
4945	\N	\N	\N	
4946	\N	\N	\N	
4947	\N	\N	\N	
4948	\N	\N	\N	
4949	\N	\N	\N	
4950	\N	\N	\N	
4951	\N	\N	\N	
4952	\N	\N	\N	
4953	\N	\N	\N	
4954	\N	\N	\N	
4955	\N	\N	\N	
4956	\N	\N	\N	
4957	\N	\N	\N	
4958	\N	\N	\N	
4959	\N	\N	\N	
4960	\N	\N	\N	
4961	\N	\N	\N	
4962	\N	\N	\N	
4963	\N	\N	\N	
4964	\N	\N	\N	
4965	\N	\N	\N	
4966	\N	\N	\N	
4967	\N	\N	\N	
4968	\N	\N	\N	
4969	\N	\N	\N	
4970	\N	\N	\N	
4971	\N	\N	\N	
4972	\N	\N	\N	
4973	\N	\N	\N	
4974	\N	\N	\N	
4975	\N	\N	\N	
4976	\N	\N	\N	
4977	\N	\N	\N	
4978	\N	\N	\N	
4979	\N	\N	\N	
4980	\N	\N	\N	
4981	\N	\N	\N	
4982	\N	\N	\N	
4983	\N	\N	\N	
4984	\N	\N	\N	
4985	\N	\N	\N	
4986	\N	\N	\N	
4987	\N	\N	\N	
4988	\N	\N	\N	
4989	\N	\N	\N	
4990	\N	\N	\N	
4991	\N	\N	\N	
4992	\N	\N	\N	
4993	\N	\N	\N	
4994	\N	\N	\N	
4995	\N	\N	\N	
4996	\N	\N	\N	
4997	\N	\N	\N	
4998	\N	\N	\N	
4999	\N	\N	\N	
5000	\N	\N	\N	
5001	\N	\N	\N	
5002	\N	\N	\N	
5003	\N	\N	\N	
5004	\N	\N	\N	
5005	\N	\N	\N	
5006	\N	\N	\N	
5007	\N	\N	\N	
5008	\N	\N	\N	
5009	\N	\N	\N	
5010	\N	\N	\N	
5011	\N	\N	\N	
5012	\N	\N	\N	
5013	\N	\N	\N	
5014	\N	\N	\N	
5015	\N	\N	\N	
5016	\N	\N	\N	
5017	\N	\N	\N	
5018	\N	\N	\N	
5019	\N	\N	\N	
5020	\N	\N	\N	
5021	\N	\N	\N	
5022	\N	\N	\N	
5023	\N	\N	\N	
5024	\N	\N	\N	
5025	\N	\N	\N	
5026	\N	\N	\N	
5027	\N	\N	\N	
5028	\N	\N	\N	
5029	\N	\N	\N	
5030	\N	\N	\N	
5031	\N	\N	\N	
5032	\N	\N	\N	
5033	\N	\N	\N	
5034	\N	\N	\N	
5035	\N	\N	\N	
5036	\N	\N	\N	
5037	\N	\N	\N	
5038	\N	\N	\N	
5039	\N	\N	\N	
5040	\N	\N	\N	
5041	\N	\N	\N	
5042	\N	\N	\N	
5043	\N	\N	\N	
5044	\N	\N	\N	
5045	\N	\N	\N	
5046	\N	\N	\N	
5047	\N	\N	\N	
5048	\N	\N	\N	
5049	\N	\N	\N	
5050	\N	\N	\N	
5051	\N	\N	\N	
5052	\N	\N	\N	
5053	\N	\N	\N	
5054	\N	\N	\N	
5055	\N	\N	\N	
5056	\N	\N	\N	
5057	\N	\N	\N	
5058	\N	\N	\N	
5059	\N	\N	\N	
5060	\N	\N	\N	
5061	\N	\N	\N	
5062	\N	\N	\N	
5063	\N	\N	\N	
5064	\N	\N	\N	
5065	\N	\N	\N	
5066	\N	\N	\N	
5067	\N	\N	\N	
5068	\N	\N	\N	
5069	\N	\N	\N	
5070	\N	\N	\N	
5071	\N	\N	\N	
5072	\N	\N	\N	
5073	\N	\N	\N	
5074	\N	\N	\N	
5075	\N	\N	\N	
5076	\N	\N	\N	
5077	\N	\N	\N	
5078	\N	\N	\N	
5079	\N	\N	\N	
5080	\N	\N	\N	
5081	\N	\N	\N	
5082	\N	\N	\N	
5083	\N	\N	\N	
5084	\N	\N	\N	
5085	\N	\N	\N	
5086	\N	\N	\N	
5087	\N	\N	\N	
5088	\N	\N	\N	
5089	\N	\N	\N	
5090	\N	\N	\N	
5091	\N	\N	\N	
5092	\N	\N	\N	
5093	\N	\N	\N	
5094	\N	\N	\N	
5095	\N	\N	\N	
5096	\N	\N	\N	
5097	\N	\N	\N	
5098	\N	\N	\N	
5099	\N	\N	\N	
5100	\N	\N	\N	
5101	\N	\N	\N	
5102	\N	\N	\N	
5103	\N	\N	\N	
5104	\N	\N	\N	
5105	\N	\N	\N	
5106	\N	\N	\N	
5107	\N	\N	\N	
5108	\N	\N	\N	
5109	\N	\N	\N	
5110	\N	\N	\N	
5111	\N	\N	\N	
5112	\N	\N	\N	
5113	\N	\N	\N	
5114	\N	\N	\N	
5115	\N	\N	\N	
5116	\N	\N	\N	
5117	\N	\N	\N	
5118	\N	\N	\N	
5119	\N	\N	\N	
5120	\N	\N	\N	
5121	\N	\N	\N	
5122	\N	\N	\N	
5123	\N	\N	\N	
5124	\N	\N	\N	
5125	\N	\N	\N	
5126	\N	\N	\N	
5127	\N	\N	\N	
5128	\N	\N	\N	
5129	\N	\N	\N	
5130	\N	\N	\N	
5131	\N	\N	\N	
5132	\N	\N	\N	
5133	\N	\N	\N	
5134	\N	\N	\N	
5135	\N	\N	\N	
5136	\N	\N	\N	
5137	\N	\N	\N	
5138	\N	\N	\N	
5139	\N	\N	\N	
5140	\N	\N	\N	
5141	\N	\N	\N	
5142	\N	\N	\N	
5143	\N	\N	\N	
5144	\N	\N	\N	
5145	\N	\N	\N	
5146	\N	\N	\N	
5147	\N	\N	\N	
5148	\N	\N	\N	
5149	\N	\N	\N	
5150	\N	\N	\N	
5151	\N	\N	\N	
5152	\N	\N	\N	
5153	\N	\N	\N	
5154	\N	\N	\N	
5155	\N	\N	\N	
5156	\N	\N	\N	
5157	\N	\N	\N	
5158	\N	\N	\N	
5159	\N	\N	\N	
5160	\N	\N	\N	
5161	\N	\N	\N	
5162	\N	\N	\N	
5163	\N	\N	\N	
5164	\N	\N	\N	
5165	\N	\N	\N	
5166	\N	\N	\N	
5167	\N	\N	\N	
5168	\N	\N	\N	
5169	\N	\N	\N	
5170	\N	\N	\N	
5171	\N	\N	\N	
5172	\N	\N	\N	
5173	\N	\N	\N	
5174	\N	\N	\N	
5175	\N	\N	\N	
5176	\N	\N	\N	
5177	\N	\N	\N	
5178	\N	\N	\N	
5179	\N	\N	\N	
5180	\N	\N	\N	
5181	\N	\N	\N	
5182	\N	\N	\N	
5183	\N	\N	\N	
5184	\N	\N	\N	
5185	\N	\N	\N	
5186	\N	\N	\N	
5187	\N	\N	\N	
5188	\N	\N	\N	
5189	\N	\N	\N	
5190	\N	\N	\N	
5191	\N	\N	\N	
5192	\N	\N	\N	
5193	\N	\N	\N	
5194	\N	\N	\N	
5195	\N	\N	\N	
5196	\N	\N	\N	
5197	\N	\N	\N	
5198	\N	\N	\N	
5199	\N	\N	\N	
5200	\N	\N	\N	
5201	\N	\N	\N	
5202	\N	\N	\N	
5203	\N	\N	\N	
5204	\N	\N	\N	
5205	\N	\N	\N	
5206	\N	\N	\N	
5207	\N	\N	\N	
5208	\N	\N	\N	
5209	\N	\N	\N	
5210	\N	\N	\N	
5211	\N	\N	\N	
5212	\N	\N	\N	
5213	\N	\N	\N	
5214	\N	\N	\N	
5215	\N	\N	\N	
5216	\N	\N	\N	
5217	\N	\N	\N	
5218	\N	\N	\N	
5219	\N	\N	\N	
5220	\N	\N	\N	
5221	\N	\N	\N	
5222	\N	\N	\N	
5223	\N	\N	\N	
5224	\N	\N	\N	
5225	\N	\N	\N	
5226	\N	\N	\N	
5227	\N	\N	\N	
5228	\N	\N	\N	
5229	\N	\N	\N	
5230	\N	\N	\N	
5231	\N	\N	\N	
5232	\N	\N	\N	
5233	\N	\N	\N	
5234	\N	\N	\N	
5235	\N	\N	\N	
5236	\N	\N	\N	
5237	\N	\N	\N	
5238	\N	\N	\N	
5239	\N	\N	\N	
5240	\N	\N	\N	
5241	\N	\N	\N	
5242	\N	\N	\N	
5243	\N	\N	\N	
5244	\N	\N	\N	
5245	\N	\N	\N	
5246	\N	\N	\N	
5247	\N	\N	\N	
5248	\N	\N	\N	
5249	\N	\N	\N	
5250	\N	\N	\N	
5251	\N	\N	\N	
5252	\N	\N	\N	
5253	\N	\N	\N	
5254	\N	\N	\N	
5255	\N	\N	\N	
5256	\N	\N	\N	
5257	\N	\N	\N	
5258	\N	\N	\N	
5259	\N	\N	\N	
5260	\N	\N	\N	
5261	\N	\N	\N	
5262	\N	\N	\N	
5263	\N	\N	\N	
5264	\N	\N	\N	
5265	\N	\N	\N	
5266	\N	\N	\N	
5267	\N	\N	\N	
5268	\N	\N	\N	
5269	\N	\N	\N	
5270	\N	\N	\N	
5271	\N	\N	\N	
5272	\N	\N	\N	
5273	\N	\N	\N	
5274	\N	\N	\N	
5275	\N	\N	\N	
5276	\N	\N	\N	
5277	\N	\N	\N	
5278	\N	\N	\N	
5279	\N	\N	\N	
5280	\N	\N	\N	
5281	\N	\N	\N	
5282	\N	\N	\N	
5283	\N	\N	\N	
5284	\N	\N	\N	
5285	\N	\N	\N	
5286	\N	\N	\N	
5287	\N	\N	\N	
5288	\N	\N	\N	
5289	\N	\N	\N	
5290	\N	\N	\N	
5291	\N	\N	\N	
5292	\N	\N	\N	
5293	\N	\N	\N	
5294	\N	\N	\N	
5295	\N	\N	\N	
5296	\N	\N	\N	
5297	\N	\N	\N	
5298	\N	\N	\N	
5299	\N	\N	\N	
5300	\N	\N	\N	
5301	\N	\N	\N	
5302	\N	\N	\N	
5303	\N	\N	\N	
5304	\N	\N	\N	
5305	\N	\N	\N	
5306	\N	\N	\N	
5307	\N	\N	\N	
5308	\N	\N	\N	
5309	\N	\N	\N	
5310	\N	\N	\N	
5311	\N	\N	\N	
5312	\N	\N	\N	
5313	\N	\N	\N	
5314	\N	\N	\N	
5315	\N	\N	\N	
5316	\N	\N	\N	
5317	\N	\N	\N	
5318	\N	\N	\N	
5319	\N	\N	\N	
5320	\N	\N	\N	
5321	\N	\N	\N	
5322	\N	\N	\N	
5323	\N	\N	\N	
5324	\N	\N	\N	
5325	\N	\N	\N	
5326	\N	\N	\N	
5327	\N	\N	\N	
5328	\N	\N	\N	
5329	\N	\N	\N	
5330	\N	\N	\N	
5331	\N	\N	\N	
5332	\N	\N	\N	
5333	\N	\N	\N	
5334	\N	\N	\N	
5335	\N	\N	\N	
5336	\N	\N	\N	
5337	\N	\N	\N	
5338	\N	\N	\N	
5339	\N	\N	\N	
5340	\N	\N	\N	
5341	\N	\N	\N	
5342	\N	\N	\N	
5343	\N	\N	\N	
5344	\N	\N	\N	
5345	\N	\N	\N	
5346	\N	\N	\N	
5347	\N	\N	\N	
5348	\N	\N	\N	
5349	\N	\N	\N	
5350	\N	\N	\N	
5351	\N	\N	\N	
5352	\N	\N	\N	
5353	\N	\N	\N	
5354	\N	\N	\N	
5355	\N	\N	\N	
5356	\N	\N	\N	
5357	\N	\N	\N	
5358	\N	\N	\N	
5359	\N	\N	\N	
5360	\N	\N	\N	
5361	\N	\N	\N	
5362	\N	\N	\N	
5363	\N	\N	\N	
5364	\N	\N	\N	
5365	\N	\N	\N	
5366	\N	\N	\N	
5367	\N	\N	\N	
5368	\N	\N	\N	
5369	\N	\N	\N	
5370	\N	\N	\N	
5371	\N	\N	\N	
5372	\N	\N	\N	
5373	\N	\N	\N	
5374	\N	\N	\N	
5375	\N	\N	\N	
5376	\N	\N	\N	
5377	\N	\N	\N	
5378	\N	\N	\N	
5379	\N	\N	\N	
5380	\N	\N	\N	
5381	\N	\N	\N	
5382	\N	\N	\N	
5383	\N	\N	\N	
5384	\N	\N	\N	
5385	\N	\N	\N	
5386	\N	\N	\N	
5387	\N	\N	\N	
5388	\N	\N	\N	
5389	\N	\N	\N	
5390	\N	\N	\N	
5391	\N	\N	\N	
5392	\N	\N	\N	
5393	\N	\N	\N	
5394	\N	\N	\N	
5395	\N	\N	\N	
5396	\N	\N	\N	
5397	\N	\N	\N	
5398	\N	\N	\N	
5399	\N	\N	\N	
5400	\N	\N	\N	
5401	\N	\N	\N	
5402	\N	\N	\N	
5403	\N	\N	\N	
5404	\N	\N	\N	
5405	\N	\N	\N	
5406	\N	\N	\N	
5407	\N	\N	\N	
5408	\N	\N	\N	
5409	\N	\N	\N	
5410	\N	\N	\N	
5411	\N	\N	\N	
5412	\N	\N	\N	
5413	\N	\N	\N	
5414	\N	\N	\N	
5415	\N	\N	\N	
5416	\N	\N	\N	
5417	\N	\N	\N	
5418	\N	\N	\N	
5419	\N	\N	\N	
5420	\N	\N	\N	
5421	\N	\N	\N	
5422	\N	\N	\N	
5423	\N	\N	\N	
5424	\N	\N	\N	
5425	\N	\N	\N	
5426	\N	\N	\N	
5427	\N	\N	\N	
5428	\N	\N	\N	
5429	\N	\N	\N	
5430	\N	\N	\N	
5431	\N	\N	\N	
5432	\N	\N	\N	
5433	\N	\N	\N	
5434	\N	\N	\N	
5435	\N	\N	\N	
5436	\N	\N	\N	
5437	\N	\N	\N	
5438	\N	\N	\N	
5439	\N	\N	\N	
5440	\N	\N	\N	
5441	\N	\N	\N	
5442	\N	\N	\N	
5443	\N	\N	\N	
5444	\N	\N	\N	
5445	\N	\N	\N	
5446	\N	\N	\N	
5447	\N	\N	\N	
5448	\N	\N	\N	
5449	\N	\N	\N	
5450	\N	\N	\N	
5451	\N	\N	\N	
5452	\N	\N	\N	
5453	\N	\N	\N	
5454	\N	\N	\N	
5455	\N	\N	\N	
5456	\N	\N	\N	
5457	\N	\N	\N	
5458	\N	\N	\N	
5459	\N	\N	\N	
5460	\N	\N	\N	
5461	\N	\N	\N	
5462	\N	\N	\N	
5463	\N	\N	\N	
5464	\N	\N	\N	
5465	\N	\N	\N	
5466	\N	\N	\N	
5467	\N	\N	\N	
5468	\N	\N	\N	
5469	\N	\N	\N	
5470	\N	\N	\N	
5471	\N	\N	\N	
5472	\N	\N	\N	
5473	\N	\N	\N	
5474	\N	\N	\N	
5475	\N	\N	\N	
5476	\N	\N	\N	
5477	\N	\N	\N	
5478	\N	\N	\N	
5479	\N	\N	\N	
5480	\N	\N	\N	
5481	\N	\N	\N	
5482	\N	\N	\N	
5483	\N	\N	\N	
5484	\N	\N	\N	
5485	\N	\N	\N	
5486	\N	\N	\N	
5487	\N	\N	\N	
5488	\N	\N	\N	
5489	\N	\N	\N	
5490	\N	\N	\N	
5491	\N	\N	\N	
5492	\N	\N	\N	
5493	\N	\N	\N	
5494	\N	\N	\N	
5495	\N	\N	\N	
5496	\N	\N	\N	
5497	\N	\N	\N	
5498	\N	\N	\N	
5499	\N	\N	\N	
5500	\N	\N	\N	
5501	\N	\N	\N	
5502	\N	\N	\N	
5503	\N	\N	\N	
5504	\N	\N	\N	
5505	\N	\N	\N	
5506	\N	\N	\N	
5507	\N	\N	\N	
5508	\N	\N	\N	
5509	\N	\N	\N	
5510	\N	\N	\N	
5511	\N	\N	\N	
5512	\N	\N	\N	
5513	\N	\N	\N	
5514	\N	\N	\N	
5515	\N	\N	\N	
5516	\N	\N	\N	
5517	\N	\N	\N	
5518	\N	\N	\N	
5519	\N	\N	\N	
5520	\N	\N	\N	
5521	\N	\N	\N	
5522	\N	\N	\N	
5523	\N	\N	\N	
5524	\N	\N	\N	
5525	\N	\N	\N	
5526	\N	\N	\N	
5527	\N	\N	\N	
5528	\N	\N	\N	
5529	\N	\N	\N	
5530	\N	\N	\N	
5531	\N	\N	\N	
5532	\N	\N	\N	
5533	\N	\N	\N	
5534	\N	\N	\N	
5535	\N	\N	\N	
5536	\N	\N	\N	
5537	\N	\N	\N	
5538	\N	\N	\N	
5539	\N	\N	\N	
5540	\N	\N	\N	
5541	\N	\N	\N	
5542	\N	\N	\N	
5543	\N	\N	\N	
5544	\N	\N	\N	
5545	\N	\N	\N	
5546	\N	\N	\N	
5547	\N	\N	\N	
5548	\N	\N	\N	
5549	\N	\N	\N	
5550	\N	\N	\N	
5551	\N	\N	\N	
5552	\N	\N	\N	
5553	\N	\N	\N	
5554	\N	\N	\N	
5555	\N	\N	\N	
5556	\N	\N	\N	
5557	\N	\N	\N	
5558	\N	\N	\N	
5559	\N	\N	\N	
5560	\N	\N	\N	
5561	\N	\N	\N	
5562	\N	\N	\N	
5563	\N	\N	\N	
5564	\N	\N	\N	
5565	\N	\N	\N	
5566	\N	\N	\N	
5567	\N	\N	\N	
5568	\N	\N	\N	
5569	\N	\N	\N	
5570	\N	\N	\N	
5571	\N	\N	\N	
5572	\N	\N	\N	
5573	\N	\N	\N	
5574	\N	\N	\N	
5575	\N	\N	\N	
5576	\N	\N	\N	
5577	\N	\N	\N	
5578	\N	\N	\N	
5579	\N	\N	\N	
5580	\N	\N	\N	
5581	\N	\N	\N	
5582	\N	\N	\N	
5583	\N	\N	\N	
5584	\N	\N	\N	
5585	\N	\N	\N	
5586	\N	\N	\N	
5587	\N	\N	\N	
5588	\N	\N	\N	
5589	\N	\N	\N	
5590	\N	\N	\N	
5591	\N	\N	\N	
5592	\N	\N	\N	
5593	\N	\N	\N	
5594	\N	\N	\N	
5595	\N	\N	\N	
5596	\N	\N	\N	
5597	\N	\N	\N	
5598	\N	\N	\N	
5599	\N	\N	\N	
5600	\N	\N	\N	
5601	\N	\N	\N	
5602	\N	\N	\N	
5603	\N	\N	\N	
5604	\N	\N	\N	
5605	\N	\N	\N	
5606	\N	\N	\N	
5607	\N	\N	\N	
5608	\N	\N	\N	
5609	\N	\N	\N	
5610	\N	\N	\N	
5611	\N	\N	\N	
5612	\N	\N	\N	
5613	\N	\N	\N	
5614	\N	\N	\N	
5615	\N	\N	\N	
5616	\N	\N	\N	
5617	\N	\N	\N	
5618	\N	\N	\N	
5619	\N	\N	\N	
5620	\N	\N	\N	
5621	\N	\N	\N	
5622	\N	\N	\N	
5623	\N	\N	\N	
5624	\N	\N	\N	
5625	\N	\N	\N	
5626	\N	\N	\N	
5627	\N	\N	\N	
5628	\N	\N	\N	
5629	\N	\N	\N	
5630	\N	\N	\N	
5631	\N	\N	\N	
5632	\N	\N	\N	
5633	\N	\N	\N	
5634	\N	\N	\N	
5635	\N	\N	\N	
5636	\N	\N	\N	
5637	\N	\N	\N	
5638	\N	\N	\N	
5639	\N	\N	\N	
5640	\N	\N	\N	
5641	\N	\N	\N	
5642	\N	\N	\N	
5643	\N	\N	\N	
5644	\N	\N	\N	
5645	\N	\N	\N	
5646	\N	\N	\N	
5647	\N	\N	\N	
5648	\N	\N	\N	
5649	\N	\N	\N	
5650	\N	\N	\N	
5651	\N	\N	\N	
5652	\N	\N	\N	
5653	\N	\N	\N	
5654	\N	\N	\N	
5655	\N	\N	\N	
5656	\N	\N	\N	
5657	\N	\N	\N	
5658	\N	\N	\N	
5659	\N	\N	\N	
5660	\N	\N	\N	
5661	\N	\N	\N	
5662	\N	\N	\N	
5663	\N	\N	\N	
5664	\N	\N	\N	
5665	\N	\N	\N	
5666	\N	\N	\N	
5667	\N	\N	\N	
5668	\N	\N	\N	
5669	\N	\N	\N	
5670	\N	\N	\N	
5671	\N	\N	\N	
5672	\N	\N	\N	
5673	\N	\N	\N	
5674	\N	\N	\N	
5675	\N	\N	\N	
5676	\N	\N	\N	
5677	\N	\N	\N	
5678	\N	\N	\N	
5679	\N	\N	\N	
5680	\N	\N	\N	
5681	\N	\N	\N	
5682	\N	\N	\N	
5683	\N	\N	\N	
5684	\N	\N	\N	
5685	\N	\N	\N	
5686	\N	\N	\N	
5687	\N	\N	\N	
5688	\N	\N	\N	
5689	\N	\N	\N	
5690	\N	\N	\N	
5691	\N	\N	\N	
5692	\N	\N	\N	
5693	\N	\N	\N	
5694	\N	\N	\N	
5695	\N	\N	\N	
5696	\N	\N	\N	
5697	\N	\N	\N	
5698	\N	\N	\N	
5699	\N	\N	\N	
5700	\N	\N	\N	
5701	\N	\N	\N	
5702	\N	\N	\N	
5703	\N	\N	\N	
5704	\N	\N	\N	
5705	\N	\N	\N	
5706	\N	\N	\N	
5707	\N	\N	\N	
5708	\N	\N	\N	
5709	\N	\N	\N	
5710	\N	\N	\N	
5711	\N	\N	\N	
5712	\N	\N	\N	
5713	\N	\N	\N	
5714	\N	\N	\N	
5715	\N	\N	\N	
5716	\N	\N	\N	
5717	\N	\N	\N	
5718	\N	\N	\N	
5719	\N	\N	\N	
5720	\N	\N	\N	
5721	\N	\N	\N	
5722	\N	\N	\N	
5723	\N	\N	\N	
5724	\N	\N	\N	
5725	\N	\N	\N	
5726	\N	\N	\N	
5727	\N	\N	\N	
5728	\N	\N	\N	
5729	\N	\N	\N	
5730	\N	\N	\N	
5731	\N	\N	\N	
5732	\N	\N	\N	
5733	\N	\N	\N	
5734	\N	\N	\N	
5735	\N	\N	\N	
5736	\N	\N	\N	
5737	\N	\N	\N	
5738	\N	\N	\N	
5739	\N	\N	\N	
5740	\N	\N	\N	
5741	\N	\N	\N	
5742	\N	\N	\N	
5743	\N	\N	\N	
5744	\N	\N	\N	
5745	\N	\N	\N	
5746	\N	\N	\N	
5747	\N	\N	\N	
5748	\N	\N	\N	
5749	\N	\N	\N	
5750	\N	\N	\N	
5751	\N	\N	\N	
5752	\N	\N	\N	
5753	\N	\N	\N	
5754	\N	\N	\N	
5755	\N	\N	\N	
5756	\N	\N	\N	
5757	\N	\N	\N	
5758	\N	\N	\N	
5759	\N	\N	\N	
5760	\N	\N	\N	
5761	\N	\N	\N	
5762	\N	\N	\N	
5763	\N	\N	\N	
5764	\N	\N	\N	
5765	\N	\N	\N	
5766	\N	\N	\N	
5767	\N	\N	\N	
5768	\N	\N	\N	
5769	\N	\N	\N	
5770	\N	\N	\N	
5771	\N	\N	\N	
5772	\N	\N	\N	
5773	\N	\N	\N	
5774	\N	\N	\N	
5775	\N	\N	\N	
5776	\N	\N	\N	
5777	\N	\N	\N	
5778	\N	\N	\N	
5779	\N	\N	\N	
5780	\N	\N	\N	
5781	\N	\N	\N	
5782	\N	\N	\N	
5783	\N	\N	\N	
5784	\N	\N	\N	
5785	\N	\N	\N	
5786	\N	\N	\N	
5787	\N	\N	\N	
5788	\N	\N	\N	
5789	\N	\N	\N	
5790	\N	\N	\N	
5791	\N	\N	\N	
5792	\N	\N	\N	
5793	\N	\N	\N	
5794	\N	\N	\N	
5795	\N	\N	\N	
5796	\N	\N	\N	
5797	\N	\N	\N	
5798	\N	\N	\N	
5799	\N	\N	\N	
5800	\N	\N	\N	
5801	\N	\N	\N	
5802	\N	\N	\N	
5803	\N	\N	\N	
5804	\N	\N	\N	
5805	\N	\N	\N	
5806	\N	\N	\N	
5807	\N	\N	\N	
5808	\N	\N	\N	
5809	\N	\N	\N	
5810	\N	\N	\N	
5811	\N	\N	\N	
5812	\N	\N	\N	
5813	\N	\N	\N	
5814	\N	\N	\N	
5815	\N	\N	\N	
5816	\N	\N	\N	
5817	\N	\N	\N	
5818	\N	\N	\N	
5819	\N	\N	\N	
5820	\N	\N	\N	
5821	\N	\N	\N	
5822	\N	\N	\N	
5823	\N	\N	\N	
5824	\N	\N	\N	
5825	\N	\N	\N	
5826	\N	\N	\N	
5827	\N	\N	\N	
5828	\N	\N	\N	
5829	\N	\N	\N	
5830	\N	\N	\N	
5831	\N	\N	\N	
5832	\N	\N	\N	
5833	\N	\N	\N	
5834	\N	\N	\N	
5835	\N	\N	\N	
5836	\N	\N	\N	
5837	\N	\N	\N	
5838	\N	\N	\N	
5839	\N	\N	\N	
5840	\N	\N	\N	
5841	\N	\N	\N	
5842	\N	\N	\N	
5843	\N	\N	\N	
5844	\N	\N	\N	
5845	\N	\N	\N	
5846	\N	\N	\N	
5847	\N	\N	\N	
5848	\N	\N	\N	
5849	\N	\N	\N	
5850	\N	\N	\N	
5851	\N	\N	\N	
5852	\N	\N	\N	
5853	\N	\N	\N	
5854	\N	\N	\N	
5855	\N	\N	\N	
5856	\N	\N	\N	
5857	\N	\N	\N	
5858	\N	\N	\N	
5859	\N	\N	\N	
5860	\N	\N	\N	
5861	\N	\N	\N	
5862	\N	\N	\N	
5863	\N	\N	\N	
5864	\N	\N	\N	
5865	\N	\N	\N	
5866	\N	\N	\N	
5867	\N	\N	\N	
5868	\N	\N	\N	
5869	\N	\N	\N	
5870	\N	\N	\N	
5871	\N	\N	\N	
5872	\N	\N	\N	
5873	\N	\N	\N	
5874	\N	\N	\N	
5875	\N	\N	\N	
5876	\N	\N	\N	
5877	\N	\N	\N	
5878	\N	\N	\N	
5879	\N	\N	\N	
5880	\N	\N	\N	
5881	\N	\N	\N	
5882	\N	\N	\N	
5883	\N	\N	\N	
5884	\N	\N	\N	
5885	\N	\N	\N	
5886	\N	\N	\N	
5887	\N	\N	\N	
5888	\N	\N	\N	
5889	\N	\N	\N	
5890	\N	\N	\N	
5891	\N	\N	\N	
5892	\N	\N	\N	
5893	\N	\N	\N	
5894	\N	\N	\N	
5895	\N	\N	\N	
5896	\N	\N	\N	
5897	\N	\N	\N	
5898	\N	\N	\N	
5899	\N	\N	\N	
5900	\N	\N	\N	
5901	\N	\N	\N	
5902	\N	\N	\N	
5903	\N	\N	\N	
5904	\N	\N	\N	
5905	\N	\N	\N	
5906	\N	\N	\N	
5907	\N	\N	\N	
5908	\N	\N	\N	
5909	\N	\N	\N	
5910	\N	\N	\N	
5911	\N	\N	\N	
5912	\N	\N	\N	
5913	\N	\N	\N	
5914	\N	\N	\N	
5915	\N	\N	\N	
5916	\N	\N	\N	
5917	\N	\N	\N	
5918	\N	\N	\N	
5919	\N	\N	\N	
5920	\N	\N	\N	
5921	\N	\N	\N	
5922	\N	\N	\N	
5923	\N	\N	\N	
5924	\N	\N	\N	
5925	\N	\N	\N	
5926	\N	\N	\N	
5927	\N	\N	\N	
5928	\N	\N	\N	
5929	\N	\N	\N	
5930	\N	\N	\N	
5931	\N	\N	\N	
5932	\N	\N	\N	
5933	\N	\N	\N	
5934	\N	\N	\N	
5935	\N	\N	\N	
5936	\N	\N	\N	
5937	\N	\N	\N	
5938	\N	\N	\N	
5939	\N	\N	\N	
5940	\N	\N	\N	
5941	\N	\N	\N	
5942	\N	\N	\N	
5943	\N	\N	\N	
5944	\N	\N	\N	
5945	\N	\N	\N	
5946	\N	\N	\N	
5947	\N	\N	\N	
5948	\N	\N	\N	
5949	\N	\N	\N	
5950	\N	\N	\N	
5951	\N	\N	\N	
5952	\N	\N	\N	
5953	\N	\N	\N	
5954	\N	\N	\N	
5955	\N	\N	\N	
5956	\N	\N	\N	
5957	\N	\N	\N	
5958	\N	\N	\N	
5959	\N	\N	\N	
5960	\N	\N	\N	
5961	\N	\N	\N	
5962	\N	\N	\N	
5963	\N	\N	\N	
5964	\N	\N	\N	
5965	\N	\N	\N	
5966	\N	\N	\N	
5967	\N	\N	\N	
5968	\N	\N	\N	
5969	\N	\N	\N	
5970	\N	\N	\N	
5971	\N	\N	\N	
5972	\N	\N	\N	
5973	\N	\N	\N	
5974	\N	\N	\N	
5975	\N	\N	\N	
5976	\N	\N	\N	
5977	\N	\N	\N	
5978	\N	\N	\N	
5979	\N	\N	\N	
5980	\N	\N	\N	
5981	\N	\N	\N	
5982	\N	\N	\N	
5983	\N	\N	\N	
5984	\N	\N	\N	
5985	\N	\N	\N	
5986	\N	\N	\N	
5987	\N	\N	\N	
5988	\N	\N	\N	
5989	\N	\N	\N	
5990	\N	\N	\N	
5991	\N	\N	\N	
5992	\N	\N	\N	
5993	\N	\N	\N	
5994	\N	\N	\N	
5995	\N	\N	\N	
5996	\N	\N	\N	
5997	\N	\N	\N	
5998	\N	\N	\N	
5999	\N	\N	\N	
6000	\N	\N	\N	
6001	\N	\N	\N	
6002	\N	\N	\N	
6003	\N	\N	\N	
6004	\N	\N	\N	
6005	\N	\N	\N	
6006	\N	\N	\N	
6007	\N	\N	\N	
6008	\N	\N	\N	
6009	\N	\N	\N	
6010	\N	\N	\N	
6011	\N	\N	\N	
6012	\N	\N	\N	
6013	\N	\N	\N	
6014	\N	\N	\N	
6015	\N	\N	\N	
6016	\N	\N	\N	
6017	\N	\N	\N	
6018	\N	\N	\N	
6019	\N	\N	\N	
6020	\N	\N	\N	
6021	\N	\N	\N	
6022	\N	\N	\N	
6023	\N	\N	\N	
6024	\N	\N	\N	
6025	\N	\N	\N	
6026	\N	\N	\N	
6027	\N	\N	\N	
6028	\N	\N	\N	
6029	\N	\N	\N	
6030	\N	\N	\N	
6031	\N	\N	\N	
6032	\N	\N	\N	
6033	\N	\N	\N	
6034	\N	\N	\N	
6035	\N	\N	\N	
6036	\N	\N	\N	
6037	\N	\N	\N	
6038	\N	\N	\N	
6039	\N	\N	\N	
6040	\N	\N	\N	
6041	\N	\N	\N	
6042	\N	\N	\N	
6043	\N	\N	\N	
6044	\N	\N	\N	
6045	\N	\N	\N	
6046	\N	\N	\N	
6047	\N	\N	\N	
6048	\N	\N	\N	
6049	\N	\N	\N	
6050	\N	\N	\N	
6051	\N	\N	\N	
6052	\N	\N	\N	
6053	\N	\N	\N	
6054	\N	\N	\N	
6055	\N	\N	\N	
6056	\N	\N	\N	
6057	\N	\N	\N	
6058	\N	\N	\N	
6059	\N	\N	\N	
6060	\N	\N	\N	
6061	\N	\N	\N	
6062	\N	\N	\N	
6063	\N	\N	\N	
6064	\N	\N	\N	
6065	\N	\N	\N	
6066	\N	\N	\N	
6067	\N	\N	\N	
6068	\N	\N	\N	
6069	\N	\N	\N	
6070	\N	\N	\N	
6071	\N	\N	\N	
6072	\N	\N	\N	
6073	\N	\N	\N	
6074	\N	\N	\N	
6075	\N	\N	\N	
6076	\N	\N	\N	
6077	\N	\N	\N	
6078	\N	\N	\N	
6079	\N	\N	\N	
6080	\N	\N	\N	
6081	\N	\N	\N	
6082	\N	\N	\N	
6083	\N	\N	\N	
6084	\N	\N	\N	
6085	\N	\N	\N	
6086	\N	\N	\N	
6087	\N	\N	\N	
6088	\N	\N	\N	
6089	\N	\N	\N	
6090	\N	\N	\N	
6091	\N	\N	\N	
6092	\N	\N	\N	
6093	\N	\N	\N	
6094	\N	\N	\N	
6095	\N	\N	\N	
6096	\N	\N	\N	
6097	\N	\N	\N	
6098	\N	\N	\N	
6099	\N	\N	\N	
6100	\N	\N	\N	
6101	\N	\N	\N	
6102	\N	\N	\N	
6103	\N	\N	\N	
6104	\N	\N	\N	
6105	\N	\N	\N	
6106	\N	\N	\N	
6107	\N	\N	\N	
6108	\N	\N	\N	
6109	\N	\N	\N	
6110	\N	\N	\N	
6111	\N	\N	\N	
6112	\N	\N	\N	
6113	\N	\N	\N	
6114	\N	\N	\N	
6115	\N	\N	\N	
6116	\N	\N	\N	
6117	\N	\N	\N	
6118	\N	\N	\N	
6119	\N	\N	\N	
6120	\N	\N	\N	
6121	\N	\N	\N	
6122	\N	\N	\N	
6123	\N	\N	\N	
6124	\N	\N	\N	
6125	\N	\N	\N	
6126	\N	\N	\N	
6127	\N	\N	\N	
6128	\N	\N	\N	
6129	\N	\N	\N	
6130	\N	\N	\N	
6131	\N	\N	\N	
6132	\N	\N	\N	
6133	\N	\N	\N	
6134	\N	\N	\N	
6135	\N	\N	\N	
6136	\N	\N	\N	
6137	\N	\N	\N	
6138	\N	\N	\N	
6139	\N	\N	\N	
6140	\N	\N	\N	
6141	\N	\N	\N	
6142	\N	\N	\N	
6143	\N	\N	\N	
6144	\N	\N	\N	
6145	\N	\N	\N	
6146	\N	\N	\N	
6147	\N	\N	\N	
6148	\N	\N	\N	
6149	\N	\N	\N	
6150	\N	\N	\N	
6151	\N	\N	\N	
6152	\N	\N	\N	
6153	\N	\N	\N	
6154	\N	\N	\N	
6155	\N	\N	\N	
6156	\N	\N	\N	
6157	\N	\N	\N	
6158	\N	\N	\N	
6159	\N	\N	\N	
6160	\N	\N	\N	
6161	\N	\N	\N	
6162	\N	\N	\N	
6163	\N	\N	\N	
6164	\N	\N	\N	
6165	\N	\N	\N	
6166	\N	\N	\N	
6167	\N	\N	\N	
6168	\N	\N	\N	
6169	\N	\N	\N	
6170	\N	\N	\N	
6171	\N	\N	\N	
6172	\N	\N	\N	
6173	\N	\N	\N	
6174	\N	\N	\N	
6175	\N	\N	\N	
6176	\N	\N	\N	
6177	\N	\N	\N	
6178	\N	\N	\N	
6179	\N	\N	\N	
6180	\N	\N	\N	
6181	\N	\N	\N	
6182	\N	\N	\N	
6183	\N	\N	\N	
6184	\N	\N	\N	
6185	\N	\N	\N	
6186	\N	\N	\N	
6187	\N	\N	\N	
6188	\N	\N	\N	
6189	\N	\N	\N	
6190	\N	\N	\N	
6191	\N	\N	\N	
6192	\N	\N	\N	
6193	\N	\N	\N	
6194	\N	\N	\N	
6195	\N	\N	\N	
6196	\N	\N	\N	
6197	\N	\N	\N	
6198	\N	\N	\N	
6199	\N	\N	\N	
6200	\N	\N	\N	
6201	\N	\N	\N	
6202	\N	\N	\N	
6203	\N	\N	\N	
6204	\N	\N	\N	
6205	\N	\N	\N	
6206	\N	\N	\N	
6207	\N	\N	\N	
6208	\N	\N	\N	
6209	\N	\N	\N	
6210	\N	\N	\N	
6211	\N	\N	\N	
6212	\N	\N	\N	
6213	\N	\N	\N	
6214	\N	\N	\N	
6215	\N	\N	\N	
6216	\N	\N	\N	
6217	\N	\N	\N	
6218	\N	\N	\N	
6219	\N	\N	\N	
6220	\N	\N	\N	
6221	\N	\N	\N	
6222	\N	\N	\N	
6223	\N	\N	\N	
6224	\N	\N	\N	
6225	\N	\N	\N	
6226	\N	\N	\N	
6227	\N	\N	\N	
6228	\N	\N	\N	
6229	\N	\N	\N	
6230	\N	\N	\N	
6231	\N	\N	\N	
6232	\N	\N	\N	
6233	\N	\N	\N	
6234	\N	\N	\N	
6235	\N	\N	\N	
6236	\N	\N	\N	
6237	\N	\N	\N	
6238	\N	\N	\N	
6239	\N	\N	\N	
6240	\N	\N	\N	
6241	\N	\N	\N	
6242	\N	\N	\N	
6243	\N	\N	\N	
6244	\N	\N	\N	
6245	\N	\N	\N	
6246	\N	\N	\N	
6247	\N	\N	\N	
6248	\N	\N	\N	
6249	\N	\N	\N	
6250	\N	\N	\N	
6251	\N	\N	\N	
6252	\N	\N	\N	
6253	\N	\N	\N	
6254	\N	\N	\N	
6255	\N	\N	\N	
6256	\N	\N	\N	
6257	\N	\N	\N	
6258	\N	\N	\N	
6259	\N	\N	\N	
6260	\N	\N	\N	
6261	\N	\N	\N	
6262	\N	\N	\N	
6263	\N	\N	\N	
6264	\N	\N	\N	
6265	\N	\N	\N	
6266	\N	\N	\N	
6267	\N	\N	\N	
6268	\N	\N	\N	
6269	\N	\N	\N	
6270	\N	\N	\N	
6271	\N	\N	\N	
6272	\N	\N	\N	
6273	\N	\N	\N	
6274	\N	\N	\N	
6275	\N	\N	\N	
6276	\N	\N	\N	
6277	\N	\N	\N	
6278	\N	\N	\N	
6279	\N	\N	\N	
6280	\N	\N	\N	
6281	\N	\N	\N	
6282	\N	\N	\N	
6283	\N	\N	\N	
6284	\N	\N	\N	
6285	\N	\N	\N	
6286	\N	\N	\N	
6287	\N	\N	\N	
6288	\N	\N	\N	
6289	\N	\N	\N	
6290	\N	\N	\N	
6291	\N	\N	\N	
6292	\N	\N	\N	
6293	\N	\N	\N	
6294	\N	\N	\N	
6295	\N	\N	\N	
6296	\N	\N	\N	
6297	\N	\N	\N	
6298	\N	\N	\N	
6299	\N	\N	\N	
6300	\N	\N	\N	
6301	\N	\N	\N	
6302	\N	\N	\N	
6303	\N	\N	\N	
6304	\N	\N	\N	
6305	\N	\N	\N	
6306	\N	\N	\N	
6307	\N	\N	\N	
6308	\N	\N	\N	
6309	\N	\N	\N	
6310	\N	\N	\N	
6311	\N	\N	\N	
6312	\N	\N	\N	
6313	\N	\N	\N	
6314	\N	\N	\N	
6315	\N	\N	\N	
6316	\N	\N	\N	
6317	\N	\N	\N	
6318	\N	\N	\N	
6319	\N	\N	\N	
6320	\N	\N	\N	
6321	\N	\N	\N	
6322	\N	\N	\N	
6323	\N	\N	\N	
6324	\N	\N	\N	
6325	\N	\N	\N	
6326	\N	\N	\N	
6327	\N	\N	\N	
6328	\N	\N	\N	
6329	\N	\N	\N	
6330	\N	\N	\N	
6331	\N	\N	\N	
6332	\N	\N	\N	
6333	\N	\N	\N	
6334	\N	\N	\N	
6335	\N	\N	\N	
6336	\N	\N	\N	
6337	\N	\N	\N	
6338	\N	\N	\N	
6339	\N	\N	\N	
6340	\N	\N	\N	
6341	\N	\N	\N	
6342	\N	\N	\N	
6343	\N	\N	\N	
6344	\N	\N	\N	
6345	\N	\N	\N	
6346	\N	\N	\N	
6347	\N	\N	\N	
6348	\N	\N	\N	
6349	\N	\N	\N	
6350	\N	\N	\N	
6351	\N	\N	\N	
6352	\N	\N	\N	
6353	\N	\N	\N	
6354	\N	\N	\N	
6355	\N	\N	\N	
6356	\N	\N	\N	
6357	\N	\N	\N	
6358	\N	\N	\N	
6359	\N	\N	\N	
6360	\N	\N	\N	
6361	\N	\N	\N	
6362	\N	\N	\N	
6363	\N	\N	\N	
6364	\N	\N	\N	
6365	\N	\N	\N	
6366	\N	\N	\N	
6367	\N	\N	\N	
6368	\N	\N	\N	
6369	\N	\N	\N	
6370	\N	\N	\N	
6371	\N	\N	\N	
6372	\N	\N	\N	
6373	\N	\N	\N	
6374	\N	\N	\N	
6375	\N	\N	\N	
6376	\N	\N	\N	
6377	\N	\N	\N	
6378	\N	\N	\N	
6379	\N	\N	\N	
6380	\N	\N	\N	
6381	\N	\N	\N	
6382	\N	\N	\N	
6383	\N	\N	\N	
6384	\N	\N	\N	
6385	\N	\N	\N	
6386	\N	\N	\N	
6387	\N	\N	\N	
6388	\N	\N	\N	
6389	\N	\N	\N	
6390	\N	\N	\N	
6391	\N	\N	\N	
6392	\N	\N	\N	
6393	\N	\N	\N	
6394	\N	\N	\N	
6395	\N	\N	\N	
6396	\N	\N	\N	
6397	\N	\N	\N	
6398	\N	\N	\N	
6399	\N	\N	\N	
6400	\N	\N	\N	
6401	\N	\N	\N	
6402	\N	\N	\N	
6403	\N	\N	\N	
6404	\N	\N	\N	
6405	\N	\N	\N	
6406	\N	\N	\N	
6407	\N	\N	\N	
6408	\N	\N	\N	
6409	\N	\N	\N	
6410	\N	\N	\N	
6411	\N	\N	\N	
6412	\N	\N	\N	
6413	\N	\N	\N	
6414	\N	\N	\N	
6415	\N	\N	\N	
6416	\N	\N	\N	
6417	\N	\N	\N	
6418	\N	\N	\N	
6419	\N	\N	\N	
6420	\N	\N	\N	
6421	\N	\N	\N	
6422	\N	\N	\N	
6423	\N	\N	\N	
6424	\N	\N	\N	
6425	\N	\N	\N	
6426	\N	\N	\N	
6427	\N	\N	\N	
6428	\N	\N	\N	
6429	\N	\N	\N	
6430	\N	\N	\N	
6431	\N	\N	\N	
6432	\N	\N	\N	
6433	\N	\N	\N	
6434	\N	\N	\N	
6435	\N	\N	\N	
6436	\N	\N	\N	
6437	\N	\N	\N	
6438	\N	\N	\N	
6439	\N	\N	\N	
6440	\N	\N	\N	
6441	\N	\N	\N	
6442	\N	\N	\N	
6443	\N	\N	\N	
6444	\N	\N	\N	
6445	\N	\N	\N	
6446	\N	\N	\N	
6447	\N	\N	\N	
6448	\N	\N	\N	
6449	\N	\N	\N	
6450	\N	\N	\N	
6451	\N	\N	\N	
6452	\N	\N	\N	
6453	\N	\N	\N	
6454	\N	\N	\N	
6455	\N	\N	\N	
6456	\N	\N	\N	
6457	\N	\N	\N	
6458	\N	\N	\N	
6459	\N	\N	\N	
6460	\N	\N	\N	
6461	\N	\N	\N	
6462	\N	\N	\N	
6463	\N	\N	\N	
6464	\N	\N	\N	
6465	\N	\N	\N	
6466	\N	\N	\N	
6467	\N	\N	\N	
6468	\N	\N	\N	
6469	\N	\N	\N	
6470	\N	\N	\N	
6471	\N	\N	\N	
6472	\N	\N	\N	
6473	\N	\N	\N	
6474	\N	\N	\N	
6475	\N	\N	\N	
6476	\N	\N	\N	
6477	\N	\N	\N	
6478	\N	\N	\N	
6479	\N	\N	\N	
6480	\N	\N	\N	
6481	\N	\N	\N	
6482	\N	\N	\N	
6483	\N	\N	\N	
6484	\N	\N	\N	
6485	\N	\N	\N	
6486	\N	\N	\N	
6487	\N	\N	\N	
6488	\N	\N	\N	
6489	\N	\N	\N	
6490	\N	\N	\N	
6491	\N	\N	\N	
6492	\N	\N	\N	
6493	\N	\N	\N	
6494	\N	\N	\N	
6495	\N	\N	\N	
6496	\N	\N	\N	
6497	\N	\N	\N	
6498	\N	\N	\N	
6499	\N	\N	\N	
6500	\N	\N	\N	
6501	\N	\N	\N	
6502	\N	\N	\N	
6503	\N	\N	\N	
6504	\N	\N	\N	
6505	\N	\N	\N	
6506	\N	\N	\N	
6507	\N	\N	\N	
6508	\N	\N	\N	
6509	\N	\N	\N	
6510	\N	\N	\N	
6511	\N	\N	\N	
6512	\N	\N	\N	
6513	\N	\N	\N	
6514	\N	\N	\N	
6515	\N	\N	\N	
6516	\N	\N	\N	
6517	\N	\N	\N	
6518	\N	\N	\N	
6519	\N	\N	\N	
6520	\N	\N	\N	
6521	\N	\N	\N	
6522	\N	\N	\N	
6523	\N	\N	\N	
6524	\N	\N	\N	
6525	\N	\N	\N	
6526	\N	\N	\N	
6527	\N	\N	\N	
6528	\N	\N	\N	
6529	\N	\N	\N	
6530	\N	\N	\N	
6531	\N	\N	\N	
6532	\N	\N	\N	
6533	\N	\N	\N	
6534	\N	\N	\N	
6535	\N	\N	\N	
6536	\N	\N	\N	
6537	\N	\N	\N	
6538	\N	\N	\N	
6539	\N	\N	\N	
6540	\N	\N	\N	
6541	\N	\N	\N	
6542	\N	\N	\N	
6543	\N	\N	\N	
6544	\N	\N	\N	
6545	\N	\N	\N	
6546	\N	\N	\N	
6547	\N	\N	\N	
6548	\N	\N	\N	
6549	\N	\N	\N	
6550	\N	\N	\N	
6551	\N	\N	\N	
6552	\N	\N	\N	
6553	\N	\N	\N	
6554	\N	\N	\N	
6555	\N	\N	\N	
6556	\N	\N	\N	
6557	\N	\N	\N	
6558	\N	\N	\N	
6559	\N	\N	\N	
6560	\N	\N	\N	
6561	\N	\N	\N	
6562	\N	\N	\N	
6563	\N	\N	\N	
6564	\N	\N	\N	
6565	\N	\N	\N	
6566	\N	\N	\N	
6567	\N	\N	\N	
6568	\N	\N	\N	
6569	\N	\N	\N	
6570	\N	\N	\N	
6571	\N	\N	\N	
6572	\N	\N	\N	
6573	\N	\N	\N	
6574	\N	\N	\N	
6575	\N	\N	\N	
6576	\N	\N	\N	
6577	\N	\N	\N	
6578	\N	\N	\N	
6579	\N	\N	\N	
6580	\N	\N	\N	
6581	\N	\N	\N	
6582	\N	\N	\N	
6583	\N	\N	\N	
6584	\N	\N	\N	
6585	\N	\N	\N	
6586	\N	\N	\N	
6587	\N	\N	\N	
6588	\N	\N	\N	
6589	\N	\N	\N	
6590	\N	\N	\N	
6591	\N	\N	\N	
6592	\N	\N	\N	
6593	\N	\N	\N	
6594	\N	\N	\N	
6595	\N	\N	\N	
6596	\N	\N	\N	
6597	\N	\N	\N	
6598	\N	\N	\N	
6599	\N	\N	\N	
6600	\N	\N	\N	
6601	\N	\N	\N	
6602	\N	\N	\N	
6603	\N	\N	\N	
6604	\N	\N	\N	
6605	\N	\N	\N	
6606	\N	\N	\N	
6607	\N	\N	\N	
6608	\N	\N	\N	
6609	\N	\N	\N	
6610	\N	\N	\N	
6611	\N	\N	\N	
6612	\N	\N	\N	
6613	\N	\N	\N	
6614	\N	\N	\N	
6615	\N	\N	\N	
6616	\N	\N	\N	
6617	\N	\N	\N	
6618	\N	\N	\N	
6619	\N	\N	\N	
6620	\N	\N	\N	
6621	\N	\N	\N	
6622	\N	\N	\N	
6623	\N	\N	\N	
6624	\N	\N	\N	
6625	\N	\N	\N	
6626	\N	\N	\N	
6627	\N	\N	\N	
6628	\N	\N	\N	
6629	\N	\N	\N	
6630	\N	\N	\N	
6631	\N	\N	\N	
6632	\N	\N	\N	
6633	\N	\N	\N	
6634	\N	\N	\N	
6635	\N	\N	\N	
6636	\N	\N	\N	
6637	\N	\N	\N	
6638	\N	\N	\N	
6639	\N	\N	\N	
6640	\N	\N	\N	
6641	\N	\N	\N	
6642	\N	\N	\N	
6643	\N	\N	\N	
6644	\N	\N	\N	
6645	\N	\N	\N	
6646	\N	\N	\N	
6647	\N	\N	\N	
6648	\N	\N	\N	
6649	\N	\N	\N	
6650	\N	\N	\N	
6651	\N	\N	\N	
6652	\N	\N	\N	
6653	\N	\N	\N	
6654	\N	\N	\N	
6655	\N	\N	\N	
6656	\N	\N	\N	
6657	\N	\N	\N	
6658	\N	\N	\N	
6659	\N	\N	\N	
6660	\N	\N	\N	
6661	\N	\N	\N	
6662	\N	\N	\N	
6663	\N	\N	\N	
6664	\N	\N	\N	
6665	\N	\N	\N	
6666	\N	\N	\N	
6667	\N	\N	\N	
6668	\N	\N	\N	
6669	\N	\N	\N	
6670	\N	\N	\N	
6671	\N	\N	\N	
6672	\N	\N	\N	
6673	\N	\N	\N	
6674	\N	\N	\N	
6675	\N	\N	\N	
6676	\N	\N	\N	
6677	\N	\N	\N	
6678	\N	\N	\N	
6679	\N	\N	\N	
6680	\N	\N	\N	
6681	\N	\N	\N	
6682	\N	\N	\N	
6683	\N	\N	\N	
6684	\N	\N	\N	
6685	\N	\N	\N	
6686	\N	\N	\N	
6687	\N	\N	\N	
6688	\N	\N	\N	
6689	\N	\N	\N	
6690	\N	\N	\N	
6691	\N	\N	\N	
6692	\N	\N	\N	
6693	\N	\N	\N	
6694	\N	\N	\N	
6695	\N	\N	\N	
6696	\N	\N	\N	
6697	\N	\N	\N	
6698	\N	\N	\N	
6699	\N	\N	\N	
6700	\N	\N	\N	
6701	\N	\N	\N	
6702	\N	\N	\N	
6703	\N	\N	\N	
6704	\N	\N	\N	
6705	\N	\N	\N	
6706	\N	\N	\N	
6707	\N	\N	\N	
6708	\N	\N	\N	
6709	\N	\N	\N	
6710	\N	\N	\N	
6711	\N	\N	\N	
6712	\N	\N	\N	
6713	\N	\N	\N	
6714	\N	\N	\N	
6715	\N	\N	\N	
6716	\N	\N	\N	
6717	\N	\N	\N	
6718	\N	\N	\N	
6719	\N	\N	\N	
6720	\N	\N	\N	
6721	\N	\N	\N	
6722	\N	\N	\N	
6723	\N	\N	\N	
6724	\N	\N	\N	
6725	\N	\N	\N	
6726	\N	\N	\N	
6727	\N	\N	\N	
6728	\N	\N	\N	
6729	\N	\N	\N	
6730	\N	\N	\N	
6731	\N	\N	\N	
6732	\N	\N	\N	
6733	\N	\N	\N	
6734	\N	\N	\N	
6735	\N	\N	\N	
6736	\N	\N	\N	
6737	\N	\N	\N	
6738	\N	\N	\N	
6739	\N	\N	\N	
6740	\N	\N	\N	
6741	\N	\N	\N	
6742	\N	\N	\N	
6743	\N	\N	\N	
6744	\N	\N	\N	
6745	\N	\N	\N	
6746	\N	\N	\N	
6747	\N	\N	\N	
6748	\N	\N	\N	
6749	\N	\N	\N	
6750	\N	\N	\N	
6751	\N	\N	\N	
6752	\N	\N	\N	
6753	\N	\N	\N	
6754	\N	\N	\N	
6755	\N	\N	\N	
6756	\N	\N	\N	
6757	\N	\N	\N	
6758	\N	\N	\N	
6759	\N	\N	\N	
6760	\N	\N	\N	
6761	\N	\N	\N	
6762	\N	\N	\N	
6763	\N	\N	\N	
6764	\N	\N	\N	
6765	\N	\N	\N	
6766	\N	\N	\N	
6767	\N	\N	\N	
6768	\N	\N	\N	
6769	\N	\N	\N	
6770	\N	\N	\N	
6771	\N	\N	\N	
6772	\N	\N	\N	
6773	\N	\N	\N	
6774	\N	\N	\N	
6775	\N	\N	\N	
6776	\N	\N	\N	
6777	\N	\N	\N	
6778	\N	\N	\N	
6779	\N	\N	\N	
6780	\N	\N	\N	
6781	\N	\N	\N	
6782	\N	\N	\N	
6783	\N	\N	\N	
6784	\N	\N	\N	
6785	\N	\N	\N	
6786	\N	\N	\N	
6787	\N	\N	\N	
6788	\N	\N	\N	
6789	\N	\N	\N	
6790	\N	\N	\N	
6791	\N	\N	\N	
6792	\N	\N	\N	
6793	\N	\N	\N	
6794	\N	\N	\N	
6795	\N	\N	\N	
6796	\N	\N	\N	
6797	\N	\N	\N	
6798	\N	\N	\N	
6799	\N	\N	\N	
6800	\N	\N	\N	
6801	\N	\N	\N	
6802	\N	\N	\N	
6803	\N	\N	\N	
6804	\N	\N	\N	
6805	\N	\N	\N	
6806	\N	\N	\N	
6807	\N	\N	\N	
6808	\N	\N	\N	
6809	\N	\N	\N	
6810	\N	\N	\N	
6811	\N	\N	\N	
6812	\N	\N	\N	
6813	\N	\N	\N	
6814	\N	\N	\N	
6815	\N	\N	\N	
6816	\N	\N	\N	
6817	\N	\N	\N	
6818	\N	\N	\N	
6819	\N	\N	\N	
6820	\N	\N	\N	
6821	\N	\N	\N	
6822	\N	\N	\N	
6823	\N	\N	\N	
6824	\N	\N	\N	
6825	\N	\N	\N	
6826	\N	\N	\N	
6827	\N	\N	\N	
6828	\N	\N	\N	
6829	\N	\N	\N	
6830	\N	\N	\N	
6831	\N	\N	\N	
6832	\N	\N	\N	
6833	\N	\N	\N	
6834	\N	\N	\N	
6835	\N	\N	\N	
6836	\N	\N	\N	
6837	\N	\N	\N	
6838	\N	\N	\N	
6839	\N	\N	\N	
6840	\N	\N	\N	
6841	\N	\N	\N	
6842	\N	\N	\N	
6843	\N	\N	\N	
6844	\N	\N	\N	
6845	\N	\N	\N	
6846	\N	\N	\N	
6847	\N	\N	\N	
6848	\N	\N	\N	
6849	\N	\N	\N	
6850	\N	\N	\N	
6851	\N	\N	\N	
6852	\N	\N	\N	
6853	\N	\N	\N	
6854	\N	\N	\N	
6855	\N	\N	\N	
6856	\N	\N	\N	
6857	\N	\N	\N	
6858	\N	\N	\N	
6859	\N	\N	\N	
6860	\N	\N	\N	
6861	\N	\N	\N	
6862	\N	\N	\N	
6863	\N	\N	\N	
6864	\N	\N	\N	
6865	\N	\N	\N	
6866	\N	\N	\N	
6867	\N	\N	\N	
6868	\N	\N	\N	
6869	\N	\N	\N	
6870	\N	\N	\N	
6871	\N	\N	\N	
6872	\N	\N	\N	
6873	\N	\N	\N	
6874	\N	\N	\N	
6875	\N	\N	\N	
6876	\N	\N	\N	
6877	\N	\N	\N	
6878	\N	\N	\N	
6879	\N	\N	\N	
6880	\N	\N	\N	
6881	\N	\N	\N	
6882	\N	\N	\N	
6883	\N	\N	\N	
6884	\N	\N	\N	
6885	\N	\N	\N	
6886	\N	\N	\N	
6887	\N	\N	\N	
6888	\N	\N	\N	
6889	\N	\N	\N	
6890	\N	\N	\N	
6891	\N	\N	\N	
6892	\N	\N	\N	
6893	\N	\N	\N	
6894	\N	\N	\N	
6895	\N	\N	\N	
6896	\N	\N	\N	
6897	\N	\N	\N	
6898	\N	\N	\N	
6899	\N	\N	\N	
6900	\N	\N	\N	
6901	\N	\N	\N	
6902	\N	\N	\N	
6903	\N	\N	\N	
6904	\N	\N	\N	
6905	\N	\N	\N	
6906	\N	\N	\N	
6907	\N	\N	\N	
6908	\N	\N	\N	
6909	\N	\N	\N	
6910	\N	\N	\N	
6911	\N	\N	\N	
6912	\N	\N	\N	
6913	\N	\N	\N	
6914	\N	\N	\N	
6915	\N	\N	\N	
6916	\N	\N	\N	
6917	\N	\N	\N	
6918	\N	\N	\N	
6919	\N	\N	\N	
6920	\N	\N	\N	
6921	\N	\N	\N	
6922	\N	\N	\N	
6923	\N	\N	\N	
6924	\N	\N	\N	
6925	\N	\N	\N	
6926	\N	\N	\N	
6927	\N	\N	\N	
6928	\N	\N	\N	
6929	\N	\N	\N	
6930	\N	\N	\N	
6931	\N	\N	\N	
6932	\N	\N	\N	
6933	\N	\N	\N	
6934	\N	\N	\N	
6935	\N	\N	\N	
6936	\N	\N	\N	
6937	\N	\N	\N	
6938	\N	\N	\N	
6939	\N	\N	\N	
6940	\N	\N	\N	
6941	\N	\N	\N	
6942	\N	\N	\N	
6943	\N	\N	\N	
6944	\N	\N	\N	
6945	\N	\N	\N	
6946	\N	\N	\N	
6947	\N	\N	\N	
6948	\N	\N	\N	
6949	\N	\N	\N	
6950	\N	\N	\N	
6951	\N	\N	\N	
6952	\N	\N	\N	
6953	\N	\N	\N	
6954	\N	\N	\N	
6955	\N	\N	\N	
6956	\N	\N	\N	
6957	\N	\N	\N	
6958	\N	\N	\N	
6959	\N	\N	\N	
6960	\N	\N	\N	
6961	\N	\N	\N	
6962	\N	\N	\N	
6963	\N	\N	\N	
6964	\N	\N	\N	
6965	\N	\N	\N	
6966	\N	\N	\N	
6967	\N	\N	\N	
6968	\N	\N	\N	
6969	\N	\N	\N	
6970	\N	\N	\N	
6971	\N	\N	\N	
6972	\N	\N	\N	
6973	\N	\N	\N	
6974	\N	\N	\N	
6975	\N	\N	\N	
6976	\N	\N	\N	
6977	\N	\N	\N	
6978	\N	\N	\N	
6979	\N	\N	\N	
6980	\N	\N	\N	
6981	\N	\N	\N	
6982	\N	\N	\N	
6983	\N	\N	\N	
6984	\N	\N	\N	
6985	\N	\N	\N	
6986	\N	\N	\N	
6987	\N	\N	\N	
6988	\N	\N	\N	
6989	\N	\N	\N	
6990	\N	\N	\N	
6991	\N	\N	\N	
6992	\N	\N	\N	
6993	\N	\N	\N	
6994	\N	\N	\N	
6995	\N	\N	\N	
6996	\N	\N	\N	
6997	\N	\N	\N	
6998	\N	\N	\N	
6999	\N	\N	\N	
7000	\N	\N	\N	
7001	\N	\N	\N	
7002	\N	\N	\N	
7003	\N	\N	\N	
7004	\N	\N	\N	
7005	\N	\N	\N	
7006	\N	\N	\N	
7007	\N	\N	\N	
7008	\N	\N	\N	
7009	\N	\N	\N	
7010	\N	\N	\N	
7011	\N	\N	\N	
7012	\N	\N	\N	
7013	\N	\N	\N	
7014	\N	\N	\N	
7015	\N	\N	\N	
7016	\N	\N	\N	
7017	\N	\N	\N	
7018	\N	\N	\N	
7019	\N	\N	\N	
7020	\N	\N	\N	
7021	\N	\N	\N	
7022	\N	\N	\N	
7023	\N	\N	\N	
7024	\N	\N	\N	
7025	\N	\N	\N	
7026	\N	\N	\N	
7027	\N	\N	\N	
7028	\N	\N	\N	
7029	\N	\N	\N	
7030	\N	\N	\N	
7031	\N	\N	\N	
7032	\N	\N	\N	
7033	\N	\N	\N	
7034	\N	\N	\N	
7035	\N	\N	\N	
7036	\N	\N	\N	
7037	\N	\N	\N	
7038	\N	\N	\N	
7039	\N	\N	\N	
7040	\N	\N	\N	
7041	\N	\N	\N	
7042	\N	\N	\N	
7043	\N	\N	\N	
7044	\N	\N	\N	
7045	\N	\N	\N	
7046	\N	\N	\N	
7047	\N	\N	\N	
7048	\N	\N	\N	
7049	\N	\N	\N	
7050	\N	\N	\N	
7051	\N	\N	\N	
7052	\N	\N	\N	
7053	\N	\N	\N	
7054	\N	\N	\N	
7055	\N	\N	\N	
7056	\N	\N	\N	
7057	\N	\N	\N	
7058	\N	\N	\N	
7059	\N	\N	\N	
7060	\N	\N	\N	
7061	\N	\N	\N	
7062	\N	\N	\N	
7063	\N	\N	\N	
7064	\N	\N	\N	
7065	\N	\N	\N	
7066	\N	\N	\N	
7067	\N	\N	\N	
7068	\N	\N	\N	
7069	\N	\N	\N	
7070	\N	\N	\N	
7071	\N	\N	\N	
7072	\N	\N	\N	
7073	\N	\N	\N	
7074	\N	\N	\N	
7075	\N	\N	\N	
7076	\N	\N	\N	
7077	\N	\N	\N	
7078	\N	\N	\N	
7079	\N	\N	\N	
7080	\N	\N	\N	
7081	\N	\N	\N	
7082	\N	\N	\N	
7083	\N	\N	\N	
7084	\N	\N	\N	
7085	\N	\N	\N	
7086	\N	\N	\N	
7087	\N	\N	\N	
7088	\N	\N	\N	
7089	\N	\N	\N	
7090	\N	\N	\N	
7091	\N	\N	\N	
7092	\N	\N	\N	
7093	\N	\N	\N	
7094	\N	\N	\N	
7095	\N	\N	\N	
7096	\N	\N	\N	
7097	\N	\N	\N	
7098	\N	\N	\N	
7099	\N	\N	\N	
7100	\N	\N	\N	
7101	\N	\N	\N	
7102	\N	\N	\N	
7103	\N	\N	\N	
7104	\N	\N	\N	
7105	\N	\N	\N	
7106	\N	\N	\N	
7107	\N	\N	\N	
7108	\N	\N	\N	
7109	\N	\N	\N	
7110	\N	\N	\N	
7111	\N	\N	\N	
7112	\N	\N	\N	
7113	\N	\N	\N	
7114	\N	\N	\N	
7115	\N	\N	\N	
7116	\N	\N	\N	
7117	\N	\N	\N	
7118	\N	\N	\N	
7119	\N	\N	\N	
7120	\N	\N	\N	
7121	\N	\N	\N	
7122	\N	\N	\N	
7123	\N	\N	\N	
7124	\N	\N	\N	
7125	\N	\N	\N	
7126	\N	\N	\N	
7127	\N	\N	\N	
7128	\N	\N	\N	
7129	\N	\N	\N	
7130	\N	\N	\N	
7131	\N	\N	\N	
7132	\N	\N	\N	
7133	\N	\N	\N	
7134	\N	\N	\N	
7135	\N	\N	\N	
7136	\N	\N	\N	
7137	\N	\N	\N	
7138	\N	\N	\N	
7139	\N	\N	\N	
7140	\N	\N	\N	
7141	\N	\N	\N	
7142	\N	\N	\N	
7143	\N	\N	\N	
7144	\N	\N	\N	
7145	\N	\N	\N	
7146	\N	\N	\N	
7147	\N	\N	\N	
7148	\N	\N	\N	
7149	\N	\N	\N	
7150	\N	\N	\N	
7151	\N	\N	\N	
7152	\N	\N	\N	
7153	\N	\N	\N	
7154	\N	\N	\N	
7155	\N	\N	\N	
7156	\N	\N	\N	
7157	\N	\N	\N	
7158	\N	\N	\N	
7159	\N	\N	\N	
7160	\N	\N	\N	
7161	\N	\N	\N	
7162	\N	\N	\N	
7163	\N	\N	\N	
7164	\N	\N	\N	
7165	\N	\N	\N	
7166	\N	\N	\N	
7167	\N	\N	\N	
7168	\N	\N	\N	
7169	\N	\N	\N	
7170	\N	\N	\N	
7171	\N	\N	\N	
7172	\N	\N	\N	
7173	\N	\N	\N	
7174	\N	\N	\N	
7175	\N	\N	\N	
7176	\N	\N	\N	
7177	\N	\N	\N	
7178	\N	\N	\N	
7179	\N	\N	\N	
7180	\N	\N	\N	
7181	\N	\N	\N	
7182	\N	\N	\N	
7183	\N	\N	\N	
7184	\N	\N	\N	
7185	\N	\N	\N	
7186	\N	\N	\N	
7187	\N	\N	\N	
7188	\N	\N	\N	
7189	\N	\N	\N	
7190	\N	\N	\N	
7191	\N	\N	\N	
7192	\N	\N	\N	
7193	\N	\N	\N	
7194	\N	\N	\N	
7195	\N	\N	\N	
7196	\N	\N	\N	
7197	\N	\N	\N	
7198	\N	\N	\N	
7199	\N	\N	\N	
7200	\N	\N	\N	
7201	\N	\N	\N	
7202	\N	\N	\N	
7203	\N	\N	\N	
7204	\N	\N	\N	
7205	\N	\N	\N	
7206	\N	\N	\N	
7207	\N	\N	\N	
7208	\N	\N	\N	
7209	\N	\N	\N	
7210	\N	\N	\N	
7211	\N	\N	\N	
7212	\N	\N	\N	
7213	\N	\N	\N	
7214	\N	\N	\N	
7215	\N	\N	\N	
7216	\N	\N	\N	
7217	\N	\N	\N	
7218	\N	\N	\N	
7219	\N	\N	\N	
7220	\N	\N	\N	
7221	\N	\N	\N	
7222	\N	\N	\N	
7223	\N	\N	\N	
7224	\N	\N	\N	
7225	\N	\N	\N	
7226	\N	\N	\N	
7227	\N	\N	\N	
7228	\N	\N	\N	
7229	\N	\N	\N	
7230	\N	\N	\N	
7231	\N	\N	\N	
7232	\N	\N	\N	
7233	\N	\N	\N	
7234	\N	\N	\N	
7235	\N	\N	\N	
7236	\N	\N	\N	
7237	\N	\N	\N	
7238	\N	\N	\N	
7239	\N	\N	\N	
7240	\N	\N	\N	
7241	\N	\N	\N	
7242	\N	\N	\N	
7243	\N	\N	\N	
7244	\N	\N	\N	
7245	\N	\N	\N	
7246	\N	\N	\N	
7247	\N	\N	\N	
7248	\N	\N	\N	
7249	\N	\N	\N	
7250	\N	\N	\N	
7251	\N	\N	\N	
7252	\N	\N	\N	
7253	\N	\N	\N	
7254	\N	\N	\N	
7255	\N	\N	\N	
7256	\N	\N	\N	
7257	\N	\N	\N	
7258	\N	\N	\N	
7259	\N	\N	\N	
7260	\N	\N	\N	
7261	\N	\N	\N	
7262	\N	\N	\N	
7263	\N	\N	\N	
7264	\N	\N	\N	
7265	\N	\N	\N	
7266	\N	\N	\N	
7267	\N	\N	\N	
7268	\N	\N	\N	
7269	\N	\N	\N	
7270	\N	\N	\N	
7271	\N	\N	\N	
7272	\N	\N	\N	
7273	\N	\N	\N	
7274	\N	\N	\N	
7275	\N	\N	\N	
7276	\N	\N	\N	
7277	\N	\N	\N	
7278	\N	\N	\N	
7279	\N	\N	\N	
7280	\N	\N	\N	
7281	\N	\N	\N	
7282	\N	\N	\N	
7283	\N	\N	\N	
7284	\N	\N	\N	
7285	\N	\N	\N	
7286	\N	\N	\N	
7287	\N	\N	\N	
7288	\N	\N	\N	
7289	\N	\N	\N	
7290	\N	\N	\N	
7291	\N	\N	\N	
7292	\N	\N	\N	
7293	\N	\N	\N	
7294	\N	\N	\N	
7295	\N	\N	\N	
7296	\N	\N	\N	
7297	\N	\N	\N	
7298	\N	\N	\N	
7299	\N	\N	\N	
7300	\N	\N	\N	
7301	\N	\N	\N	
7302	\N	\N	\N	
7303	\N	\N	\N	
7304	\N	\N	\N	
7305	\N	\N	\N	
7306	\N	\N	\N	
7307	\N	\N	\N	
7308	\N	\N	\N	
7309	\N	\N	\N	
7310	\N	\N	\N	
7311	\N	\N	\N	
7312	\N	\N	\N	
7313	\N	\N	\N	
7314	\N	\N	\N	
7315	\N	\N	\N	
7316	\N	\N	\N	
7317	\N	\N	\N	
7318	\N	\N	\N	
7319	\N	\N	\N	
7320	\N	\N	\N	
7321	\N	\N	\N	
7322	\N	\N	\N	
7323	\N	\N	\N	
7324	\N	\N	\N	
7325	\N	\N	\N	
7326	\N	\N	\N	
7327	\N	\N	\N	
7328	\N	\N	\N	
7329	\N	\N	\N	
7330	\N	\N	\N	
7331	\N	\N	\N	
7332	\N	\N	\N	
7333	\N	\N	\N	
7334	\N	\N	\N	
7335	\N	\N	\N	
7336	\N	\N	\N	
7337	\N	\N	\N	
7338	\N	\N	\N	
7339	\N	\N	\N	
7340	\N	\N	\N	
7341	\N	\N	\N	
7342	\N	\N	\N	
7343	\N	\N	\N	
7344	\N	\N	\N	
7345	\N	\N	\N	
7346	\N	\N	\N	
7347	\N	\N	\N	
7348	\N	\N	\N	
7349	\N	\N	\N	
7350	\N	\N	\N	
7351	\N	\N	\N	
7352	\N	\N	\N	
7353	\N	\N	\N	
7354	\N	\N	\N	
7355	\N	\N	\N	
7356	\N	\N	\N	
7357	\N	\N	\N	
7358	\N	\N	\N	
7359	\N	\N	\N	
7360	\N	\N	\N	
7361	\N	\N	\N	
7362	\N	\N	\N	
7363	\N	\N	\N	
7364	\N	\N	\N	
7365	\N	\N	\N	
7366	\N	\N	\N	
7367	\N	\N	\N	
7368	\N	\N	\N	
7369	\N	\N	\N	
7370	\N	\N	\N	
7371	\N	\N	\N	
7372	\N	\N	\N	
7373	\N	\N	\N	
7374	\N	\N	\N	
7375	\N	\N	\N	
7376	\N	\N	\N	
7377	\N	\N	\N	
7378	\N	\N	\N	
7379	\N	\N	\N	
7380	\N	\N	\N	
7381	\N	\N	\N	
7382	\N	\N	\N	
7383	\N	\N	\N	
7384	\N	\N	\N	
7385	\N	\N	\N	
7386	\N	\N	\N	
7387	\N	\N	\N	
7388	\N	\N	\N	
7389	\N	\N	\N	
7390	\N	\N	\N	
7391	\N	\N	\N	
7392	\N	\N	\N	
7393	\N	\N	\N	
7394	\N	\N	\N	
7395	\N	\N	\N	
7396	\N	\N	\N	
7397	\N	\N	\N	
7398	\N	\N	\N	
7399	\N	\N	\N	
7400	\N	\N	\N	
7401	\N	\N	\N	
7402	\N	\N	\N	
7403	\N	\N	\N	
7404	\N	\N	\N	
7405	\N	\N	\N	
7406	\N	\N	\N	
7407	\N	\N	\N	
7408	\N	\N	\N	
7409	\N	\N	\N	
7410	\N	\N	\N	
7411	\N	\N	\N	
7412	\N	\N	\N	
7413	\N	\N	\N	
7414	\N	\N	\N	
7415	\N	\N	\N	
7416	\N	\N	\N	
7417	\N	\N	\N	
7418	\N	\N	\N	
7419	\N	\N	\N	
7420	\N	\N	\N	
7421	\N	\N	\N	
7422	\N	\N	\N	
7423	\N	\N	\N	
7424	\N	\N	\N	
7425	\N	\N	\N	
7426	\N	\N	\N	
7427	\N	\N	\N	
7428	\N	\N	\N	
7429	\N	\N	\N	
7430	\N	\N	\N	
7431	\N	\N	\N	
7432	\N	\N	\N	
7433	\N	\N	\N	
7434	\N	\N	\N	
7435	\N	\N	\N	
7436	\N	\N	\N	
7437	\N	\N	\N	
7438	\N	\N	\N	
7439	\N	\N	\N	
7440	\N	\N	\N	
7441	\N	\N	\N	
7442	\N	\N	\N	
7443	\N	\N	\N	
7444	\N	\N	\N	
7445	\N	\N	\N	
7446	\N	\N	\N	
7447	\N	\N	\N	
7448	\N	\N	\N	
7449	\N	\N	\N	
7450	\N	\N	\N	
7451	\N	\N	\N	
7452	\N	\N	\N	
7453	\N	\N	\N	
7454	\N	\N	\N	
7455	\N	\N	\N	
7456	\N	\N	\N	
7457	\N	\N	\N	
7458	\N	\N	\N	
7459	\N	\N	\N	
7460	\N	\N	\N	
7461	\N	\N	\N	
7462	\N	\N	\N	
7463	\N	\N	\N	
7464	\N	\N	\N	
7465	\N	\N	\N	
7466	\N	\N	\N	
7467	\N	\N	\N	
7468	\N	\N	\N	
7469	\N	\N	\N	
7470	\N	\N	\N	
7471	\N	\N	\N	
7472	\N	\N	\N	
7473	\N	\N	\N	
7474	\N	\N	\N	
7475	\N	\N	\N	
7476	\N	\N	\N	
7477	\N	\N	\N	
7478	\N	\N	\N	
7479	\N	\N	\N	
7480	\N	\N	\N	
7481	\N	\N	\N	
7482	\N	\N	\N	
7483	\N	\N	\N	
7484	\N	\N	\N	
7485	\N	\N	\N	
7486	\N	\N	\N	
7487	\N	\N	\N	
7488	\N	\N	\N	
7489	\N	\N	\N	
7490	\N	\N	\N	
7491	\N	\N	\N	
7492	\N	\N	\N	
7493	\N	\N	\N	
7494	\N	\N	\N	
7495	\N	\N	\N	
7496	\N	\N	\N	
7497	\N	\N	\N	
7498	\N	\N	\N	
7499	\N	\N	\N	
7500	\N	\N	\N	
7501	\N	\N	\N	
7502	\N	\N	\N	
7503	\N	\N	\N	
7504	\N	\N	\N	
7505	\N	\N	\N	
7506	\N	\N	\N	
7507	\N	\N	\N	
7508	\N	\N	\N	
7509	\N	\N	\N	
7510	\N	\N	\N	
7511	\N	\N	\N	
7512	\N	\N	\N	
7513	\N	\N	\N	
7514	\N	\N	\N	
7515	\N	\N	\N	
7516	\N	\N	\N	
7517	\N	\N	\N	
7518	\N	\N	\N	
7519	\N	\N	\N	
7520	\N	\N	\N	
7521	\N	\N	\N	
7522	\N	\N	\N	
7523	\N	\N	\N	
7524	\N	\N	\N	
7525	\N	\N	\N	
7526	\N	\N	\N	
7527	\N	\N	\N	
7528	\N	\N	\N	
7529	\N	\N	\N	
7530	\N	\N	\N	
7531	\N	\N	\N	
7532	\N	\N	\N	
7533	\N	\N	\N	
7534	\N	\N	\N	
7535	\N	\N	\N	
7536	\N	\N	\N	
7537	\N	\N	\N	
7538	\N	\N	\N	
7539	\N	\N	\N	
7540	\N	\N	\N	
7541	\N	\N	\N	
7542	\N	\N	\N	
7543	\N	\N	\N	
7544	\N	\N	\N	
7545	\N	\N	\N	
7546	\N	\N	\N	
7547	\N	\N	\N	
7548	\N	\N	\N	
7549	\N	\N	\N	
7550	\N	\N	\N	
7551	\N	\N	\N	
7552	\N	\N	\N	
7553	\N	\N	\N	
7554	\N	\N	\N	
7555	\N	\N	\N	
7556	\N	\N	\N	
7557	\N	\N	\N	
7558	\N	\N	\N	
7559	\N	\N	\N	
7560	\N	\N	\N	
7561	\N	\N	\N	
7562	\N	\N	\N	
7563	\N	\N	\N	
7564	\N	\N	\N	
7565	\N	\N	\N	
7566	\N	\N	\N	
7567	\N	\N	\N	
7568	\N	\N	\N	
7569	\N	\N	\N	
7570	\N	\N	\N	
7571	\N	\N	\N	
7572	\N	\N	\N	
7573	\N	\N	\N	
7574	\N	\N	\N	
7575	\N	\N	\N	
7576	\N	\N	\N	
7577	\N	\N	\N	
7578	\N	\N	\N	
7579	\N	\N	\N	
7580	\N	\N	\N	
7581	\N	\N	\N	
7582	\N	\N	\N	
7583	\N	\N	\N	
7584	\N	\N	\N	
7585	\N	\N	\N	
7586	\N	\N	\N	
7587	\N	\N	\N	
7588	\N	\N	\N	
7589	\N	\N	\N	
7590	\N	\N	\N	
7591	\N	\N	\N	
7592	\N	\N	\N	
7593	\N	\N	\N	
7594	\N	\N	\N	
7595	\N	\N	\N	
7596	\N	\N	\N	
7597	\N	\N	\N	
7598	\N	\N	\N	
7599	\N	\N	\N	
7600	\N	\N	\N	
7601	\N	\N	\N	
7602	\N	\N	\N	
7603	\N	\N	\N	
7604	\N	\N	\N	
7605	\N	\N	\N	
7606	\N	\N	\N	
7607	\N	\N	\N	
7608	\N	\N	\N	
7609	\N	\N	\N	
7610	\N	\N	\N	
7611	\N	\N	\N	
7612	\N	\N	\N	
7613	\N	\N	\N	
7614	\N	\N	\N	
7615	\N	\N	\N	
7616	\N	\N	\N	
7617	\N	\N	\N	
7618	\N	\N	\N	
7619	\N	\N	\N	
7620	\N	\N	\N	
7621	\N	\N	\N	
7622	\N	\N	\N	
7623	\N	\N	\N	
7624	\N	\N	\N	
7625	\N	\N	\N	
7626	\N	\N	\N	
7627	\N	\N	\N	
7628	\N	\N	\N	
7629	\N	\N	\N	
7630	\N	\N	\N	
7631	\N	\N	\N	
7632	\N	\N	\N	
7633	\N	\N	\N	
7634	\N	\N	\N	
7635	\N	\N	\N	
7636	\N	\N	\N	
7637	\N	\N	\N	
7638	\N	\N	\N	
7639	\N	\N	\N	
7640	\N	\N	\N	
7641	\N	\N	\N	
7642	\N	\N	\N	
7643	\N	\N	\N	
7644	\N	\N	\N	
7645	\N	\N	\N	
7646	\N	\N	\N	
7647	\N	\N	\N	
7648	\N	\N	\N	
7649	\N	\N	\N	
7650	\N	\N	\N	
7651	\N	\N	\N	
7652	\N	\N	\N	
7653	\N	\N	\N	
7654	\N	\N	\N	
7655	\N	\N	\N	
7656	\N	\N	\N	
7657	\N	\N	\N	
7658	\N	\N	\N	
7659	\N	\N	\N	
7660	\N	\N	\N	
7661	\N	\N	\N	
7662	\N	\N	\N	
7663	\N	\N	\N	
7664	\N	\N	\N	
7665	\N	\N	\N	
7666	\N	\N	\N	
7667	\N	\N	\N	
7668	\N	\N	\N	
7669	\N	\N	\N	
7670	\N	\N	\N	
7671	\N	\N	\N	
7672	\N	\N	\N	
7673	\N	\N	\N	
7674	\N	\N	\N	
7675	\N	\N	\N	
7676	\N	\N	\N	
7677	\N	\N	\N	
7678	\N	\N	\N	
7679	\N	\N	\N	
7680	\N	\N	\N	
7681	\N	\N	\N	
7682	\N	\N	\N	
7683	\N	\N	\N	
7684	\N	\N	\N	
7685	\N	\N	\N	
7686	\N	\N	\N	
7687	\N	\N	\N	
7688	\N	\N	\N	
7689	\N	\N	\N	
7690	\N	\N	\N	
7691	\N	\N	\N	
7692	\N	\N	\N	
7693	\N	\N	\N	
7694	\N	\N	\N	
7695	\N	\N	\N	
7696	\N	\N	\N	
7697	\N	\N	\N	
7698	\N	\N	\N	
7699	\N	\N	\N	
7700	\N	\N	\N	
7701	\N	\N	\N	
7702	\N	\N	\N	
7703	\N	\N	\N	
7704	\N	\N	\N	
7705	\N	\N	\N	
7706	\N	\N	\N	
7707	\N	\N	\N	
7708	\N	\N	\N	
7709	\N	\N	\N	
7710	\N	\N	\N	
7711	\N	\N	\N	
7712	\N	\N	\N	
7713	\N	\N	\N	
7714	\N	\N	\N	
7715	\N	\N	\N	
7716	\N	\N	\N	
7717	\N	\N	\N	
7718	\N	\N	\N	
7719	\N	\N	\N	
7720	\N	\N	\N	
7721	\N	\N	\N	
7722	\N	\N	\N	
7723	\N	\N	\N	
7724	\N	\N	\N	
7725	\N	\N	\N	
7726	\N	\N	\N	
7727	\N	\N	\N	
7728	\N	\N	\N	
7729	\N	\N	\N	
7730	\N	\N	\N	
7731	\N	\N	\N	
7732	\N	\N	\N	
7733	\N	\N	\N	
7734	\N	\N	\N	
7735	\N	\N	\N	
7736	\N	\N	\N	
7737	\N	\N	\N	
7738	\N	\N	\N	
7739	\N	\N	\N	
7740	\N	\N	\N	
7741	\N	\N	\N	
7742	\N	\N	\N	
7743	\N	\N	\N	
7744	\N	\N	\N	
7745	\N	\N	\N	
7746	\N	\N	\N	
7747	\N	\N	\N	
7748	\N	\N	\N	
7749	\N	\N	\N	
7750	\N	\N	\N	
7751	\N	\N	\N	
7752	\N	\N	\N	
7753	\N	\N	\N	
7754	\N	\N	\N	
7755	\N	\N	\N	
7756	\N	\N	\N	
7757	\N	\N	\N	
7758	\N	\N	\N	
7759	\N	\N	\N	
7760	\N	\N	\N	
7761	\N	\N	\N	
7762	\N	\N	\N	
7763	\N	\N	\N	
7764	\N	\N	\N	
7765	\N	\N	\N	
7766	\N	\N	\N	
7767	\N	\N	\N	
7768	\N	\N	\N	
7769	\N	\N	\N	
7770	\N	\N	\N	
7771	\N	\N	\N	
7772	\N	\N	\N	
7773	\N	\N	\N	
7774	\N	\N	\N	
7775	\N	\N	\N	
7776	\N	\N	\N	
7777	\N	\N	\N	
7778	\N	\N	\N	
7779	\N	\N	\N	
7780	\N	\N	\N	
7781	\N	\N	\N	
7782	\N	\N	\N	
7783	\N	\N	\N	
7784	\N	\N	\N	
7785	\N	\N	\N	
7786	\N	\N	\N	
7787	\N	\N	\N	
7788	\N	\N	\N	
7789	\N	\N	\N	
7790	\N	\N	\N	
7791	\N	\N	\N	
7792	\N	\N	\N	
7793	\N	\N	\N	
7794	\N	\N	\N	
7795	\N	\N	\N	
7796	\N	\N	\N	
7797	\N	\N	\N	
7798	\N	\N	\N	
7799	\N	\N	\N	
7800	\N	\N	\N	
7801	\N	\N	\N	
7802	\N	\N	\N	
7803	\N	\N	\N	
7804	\N	\N	\N	
7805	\N	\N	\N	
7806	\N	\N	\N	
7807	\N	\N	\N	
7808	\N	\N	\N	
7809	\N	\N	\N	
7810	\N	\N	\N	
7811	\N	\N	\N	
7812	\N	\N	\N	
7813	\N	\N	\N	
7814	\N	\N	\N	
7815	\N	\N	\N	
7816	\N	\N	\N	
7817	\N	\N	\N	
7818	\N	\N	\N	
7819	\N	\N	\N	
7820	\N	\N	\N	
7821	\N	\N	\N	
7822	\N	\N	\N	
7823	\N	\N	\N	
7824	\N	\N	\N	
7825	\N	\N	\N	
7826	\N	\N	\N	
7827	\N	\N	\N	
7828	\N	\N	\N	
7829	\N	\N	\N	
7830	\N	\N	\N	
7831	\N	\N	\N	
7832	\N	\N	\N	
7833	\N	\N	\N	
7834	\N	\N	\N	
7835	\N	\N	\N	
7836	\N	\N	\N	
7837	\N	\N	\N	
7838	\N	\N	\N	
7839	\N	\N	\N	
7840	\N	\N	\N	
7841	\N	\N	\N	
7842	\N	\N	\N	
7843	\N	\N	\N	
7844	\N	\N	\N	
7845	\N	\N	\N	
7846	\N	\N	\N	
7847	\N	\N	\N	
7848	\N	\N	\N	
7849	\N	\N	\N	
7850	\N	\N	\N	
7851	\N	\N	\N	
7852	\N	\N	\N	
7853	\N	\N	\N	
7854	\N	\N	\N	
7855	\N	\N	\N	
7856	\N	\N	\N	
7857	\N	\N	\N	
7858	\N	\N	\N	
7859	\N	\N	\N	
7860	\N	\N	\N	
7861	\N	\N	\N	
7862	\N	\N	\N	
7863	\N	\N	\N	
7864	\N	\N	\N	
7865	\N	\N	\N	
7866	\N	\N	\N	
7867	\N	\N	\N	
7868	\N	\N	\N	
7869	\N	\N	\N	
7870	\N	\N	\N	
7871	\N	\N	\N	
7872	\N	\N	\N	
7873	\N	\N	\N	
7874	\N	\N	\N	
7875	\N	\N	\N	
7876	\N	\N	\N	
7877	\N	\N	\N	
7878	\N	\N	\N	
7879	\N	\N	\N	
7880	\N	\N	\N	
7881	\N	\N	\N	
7882	\N	\N	\N	
7883	\N	\N	\N	
7884	\N	\N	\N	
7885	\N	\N	\N	
7886	\N	\N	\N	
7887	\N	\N	\N	
7888	\N	\N	\N	
7889	\N	\N	\N	
7890	\N	\N	\N	
7891	\N	\N	\N	
7892	\N	\N	\N	
7893	\N	\N	\N	
7894	\N	\N	\N	
7895	\N	\N	\N	
7896	\N	\N	\N	
7897	\N	\N	\N	
7898	\N	\N	\N	
7899	\N	\N	\N	
7900	\N	\N	\N	
7901	\N	\N	\N	
7902	\N	\N	\N	
7903	\N	\N	\N	
7904	\N	\N	\N	
7905	\N	\N	\N	
7906	\N	\N	\N	
7907	\N	\N	\N	
7908	\N	\N	\N	
7909	\N	\N	\N	
7910	\N	\N	\N	
7911	\N	\N	\N	
7912	\N	\N	\N	
7913	\N	\N	\N	
7914	\N	\N	\N	
7915	\N	\N	\N	
7916	\N	\N	\N	
7917	\N	\N	\N	
7918	\N	\N	\N	
7919	\N	\N	\N	
7920	\N	\N	\N	
7921	\N	\N	\N	
7922	\N	\N	\N	
7923	\N	\N	\N	
7924	\N	\N	\N	
7925	\N	\N	\N	
7926	\N	\N	\N	
7927	\N	\N	\N	
7928	\N	\N	\N	
7929	\N	\N	\N	
7930	\N	\N	\N	
7931	\N	\N	\N	
7932	\N	\N	\N	
7933	\N	\N	\N	
7934	\N	\N	\N	
7935	\N	\N	\N	
7936	\N	\N	\N	
7937	\N	\N	\N	
7938	\N	\N	\N	
7939	\N	\N	\N	
7940	\N	\N	\N	
7941	\N	\N	\N	
7942	\N	\N	\N	
7943	\N	\N	\N	
7944	\N	\N	\N	
7945	\N	\N	\N	
7946	\N	\N	\N	
7947	\N	\N	\N	
7948	\N	\N	\N	
7949	\N	\N	\N	
7950	\N	\N	\N	
7951	\N	\N	\N	
7952	\N	\N	\N	
7953	\N	\N	\N	
7954	\N	\N	\N	
7955	\N	\N	\N	
7956	\N	\N	\N	
7957	\N	\N	\N	
7958	\N	\N	\N	
7959	\N	\N	\N	
7960	\N	\N	\N	
7961	\N	\N	\N	
7962	\N	\N	\N	
7963	\N	\N	\N	
7964	\N	\N	\N	
7965	\N	\N	\N	
7966	\N	\N	\N	
7967	\N	\N	\N	
7968	\N	\N	\N	
7969	\N	\N	\N	
7970	\N	\N	\N	
7971	\N	\N	\N	
7972	\N	\N	\N	
7973	\N	\N	\N	
7974	\N	\N	\N	
7975	\N	\N	\N	
7976	\N	\N	\N	
7977	\N	\N	\N	
7978	\N	\N	\N	
7979	\N	\N	\N	
7980	\N	\N	\N	
7981	\N	\N	\N	
7982	\N	\N	\N	
7983	\N	\N	\N	
7984	\N	\N	\N	
7985	\N	\N	\N	
7986	\N	\N	\N	
7987	\N	\N	\N	
7988	\N	\N	\N	
7989	\N	\N	\N	
7990	\N	\N	\N	
7991	\N	\N	\N	
7992	\N	\N	\N	
7993	\N	\N	\N	
7994	\N	\N	\N	
7995	\N	\N	\N	
7996	\N	\N	\N	
7997	\N	\N	\N	
7998	\N	\N	\N	
7999	\N	\N	\N	
8000	\N	\N	\N	
8001	\N	\N	\N	
8002	\N	\N	\N	
8003	\N	\N	\N	
8004	\N	\N	\N	
8005	\N	\N	\N	
8006	\N	\N	\N	
8007	\N	\N	\N	
8008	\N	\N	\N	
8009	\N	\N	\N	
8010	\N	\N	\N	
8011	\N	\N	\N	
8012	\N	\N	\N	
8013	\N	\N	\N	
8014	\N	\N	\N	
8015	\N	\N	\N	
8016	\N	\N	\N	
8017	\N	\N	\N	
8018	\N	\N	\N	
8019	\N	\N	\N	
8020	\N	\N	\N	
8021	\N	\N	\N	
8022	\N	\N	\N	
8023	\N	\N	\N	
8024	\N	\N	\N	
8025	\N	\N	\N	
8026	\N	\N	\N	
8027	\N	\N	\N	
8028	\N	\N	\N	
8029	\N	\N	\N	
8030	\N	\N	\N	
8031	\N	\N	\N	
8032	\N	\N	\N	
8033	\N	\N	\N	
8034	\N	\N	\N	
8035	\N	\N	\N	
8036	\N	\N	\N	
8037	\N	\N	\N	
8038	\N	\N	\N	
8039	\N	\N	\N	
8040	\N	\N	\N	
8041	\N	\N	\N	
8042	\N	\N	\N	
8043	\N	\N	\N	
8044	\N	\N	\N	
8045	\N	\N	\N	
8046	\N	\N	\N	
8047	\N	\N	\N	
8048	\N	\N	\N	
8049	\N	\N	\N	
8050	\N	\N	\N	
8051	\N	\N	\N	
8052	\N	\N	\N	
8053	\N	\N	\N	
8054	\N	\N	\N	
8055	\N	\N	\N	
8056	\N	\N	\N	
8057	\N	\N	\N	
8058	\N	\N	\N	
8059	\N	\N	\N	
8060	\N	\N	\N	
8061	\N	\N	\N	
8062	\N	\N	\N	
8063	\N	\N	\N	
8064	\N	\N	\N	
8065	\N	\N	\N	
8066	\N	\N	\N	
8067	\N	\N	\N	
8068	\N	\N	\N	
8069	\N	\N	\N	
8070	\N	\N	\N	
8071	\N	\N	\N	
8072	\N	\N	\N	
8073	\N	\N	\N	
8074	\N	\N	\N	
8075	\N	\N	\N	
8076	\N	\N	\N	
8077	\N	\N	\N	
8078	\N	\N	\N	
8079	\N	\N	\N	
8080	\N	\N	\N	
8081	\N	\N	\N	
8082	\N	\N	\N	
8083	\N	\N	\N	
8084	\N	\N	\N	
8085	\N	\N	\N	
8086	\N	\N	\N	
8087	\N	\N	\N	
8088	\N	\N	\N	
8089	\N	\N	\N	
8090	\N	\N	\N	
8091	\N	\N	\N	
8092	\N	\N	\N	
8093	\N	\N	\N	
8094	\N	\N	\N	
8095	\N	\N	\N	
8096	\N	\N	\N	
8097	\N	\N	\N	
8098	\N	\N	\N	
8099	\N	\N	\N	
8100	\N	\N	\N	
8101	\N	\N	\N	
8102	\N	\N	\N	
8103	\N	\N	\N	
8104	\N	\N	\N	
8105	\N	\N	\N	
8106	\N	\N	\N	
8107	\N	\N	\N	
8108	\N	\N	\N	
8109	\N	\N	\N	
8110	\N	\N	\N	
8111	\N	\N	\N	
8112	\N	\N	\N	
8113	\N	\N	\N	
8114	\N	\N	\N	
8115	\N	\N	\N	
8116	\N	\N	\N	
8117	\N	\N	\N	
8118	\N	\N	\N	
8119	\N	\N	\N	
8120	\N	\N	\N	
8121	\N	\N	\N	
8122	\N	\N	\N	
8123	\N	\N	\N	
8124	\N	\N	\N	
8125	\N	\N	\N	
8126	\N	\N	\N	
8127	\N	\N	\N	
8128	\N	\N	\N	
8129	\N	\N	\N	
8130	\N	\N	\N	
8131	\N	\N	\N	
8132	\N	\N	\N	
8133	\N	\N	\N	
8134	\N	\N	\N	
8135	\N	\N	\N	
8136	\N	\N	\N	
8137	\N	\N	\N	
8138	\N	\N	\N	
8139	\N	\N	\N	
8140	\N	\N	\N	
8141	\N	\N	\N	
8142	\N	\N	\N	
8143	\N	\N	\N	
8144	\N	\N	\N	
8145	\N	\N	\N	
8146	\N	\N	\N	
8147	\N	\N	\N	
8148	\N	\N	\N	
8149	\N	\N	\N	
8150	\N	\N	\N	
8151	\N	\N	\N	
8152	\N	\N	\N	
8153	\N	\N	\N	
8154	\N	\N	\N	
8155	\N	\N	\N	
8156	\N	\N	\N	
8157	\N	\N	\N	
8158	\N	\N	\N	
8159	\N	\N	\N	
8160	\N	\N	\N	
8161	\N	\N	\N	
8162	\N	\N	\N	
8163	\N	\N	\N	
8164	\N	\N	\N	
8165	\N	\N	\N	
8166	\N	\N	\N	
8167	\N	\N	\N	
8168	\N	\N	\N	
8169	\N	\N	\N	
8170	\N	\N	\N	
8171	\N	\N	\N	
8172	\N	\N	\N	
8173	\N	\N	\N	
8174	\N	\N	\N	
8175	\N	\N	\N	
8176	\N	\N	\N	
8177	\N	\N	\N	
8178	\N	\N	\N	
8179	\N	\N	\N	
8180	\N	\N	\N	
8181	\N	\N	\N	
8182	\N	\N	\N	
8183	\N	\N	\N	
8184	\N	\N	\N	
8185	\N	\N	\N	
8186	\N	\N	\N	
8187	\N	\N	\N	
8188	\N	\N	\N	
8189	\N	\N	\N	
8190	\N	\N	\N	
8191	\N	\N	\N	
8192	\N	\N	\N	
8193	\N	\N	\N	
8194	\N	\N	\N	
8195	\N	\N	\N	
8196	\N	\N	\N	
8197	\N	\N	\N	
8198	\N	\N	\N	
8199	\N	\N	\N	
8200	\N	\N	\N	
8201	\N	\N	\N	
8202	\N	\N	\N	
8203	\N	\N	\N	
8204	\N	\N	\N	
8205	\N	\N	\N	
8206	\N	\N	\N	
8207	\N	\N	\N	
8208	\N	\N	\N	
8209	\N	\N	\N	
8210	\N	\N	\N	
8211	\N	\N	\N	
8212	\N	\N	\N	
8213	\N	\N	\N	
8214	\N	\N	\N	
8215	\N	\N	\N	
8216	\N	\N	\N	
8217	\N	\N	\N	
8218	\N	\N	\N	
8219	\N	\N	\N	
8220	\N	\N	\N	
8221	\N	\N	\N	
8222	\N	\N	\N	
8223	\N	\N	\N	
8224	\N	\N	\N	
8225	\N	\N	\N	
8226	\N	\N	\N	
8227	\N	\N	\N	
8228	\N	\N	\N	
8229	\N	\N	\N	
8230	\N	\N	\N	
8231	\N	\N	\N	
8232	\N	\N	\N	
8233	\N	\N	\N	
8234	\N	\N	\N	
8235	\N	\N	\N	
8236	\N	\N	\N	
8237	\N	\N	\N	
8238	\N	\N	\N	
8239	\N	\N	\N	
8240	\N	\N	\N	
8241	\N	\N	\N	
8242	\N	\N	\N	
8243	\N	\N	\N	
8244	\N	\N	\N	
8245	\N	\N	\N	
8246	\N	\N	\N	
8247	\N	\N	\N	
8248	\N	\N	\N	
8249	\N	\N	\N	
8250	\N	\N	\N	
8251	\N	\N	\N	
8252	\N	\N	\N	
8253	\N	\N	\N	
8254	\N	\N	\N	
8255	\N	\N	\N	
8256	\N	\N	\N	
8257	\N	\N	\N	
8258	\N	\N	\N	
8259	\N	\N	\N	
8260	\N	\N	\N	
8261	\N	\N	\N	
8262	\N	\N	\N	
8263	\N	\N	\N	
8264	\N	\N	\N	
8265	\N	\N	\N	
8266	\N	\N	\N	
8267	\N	\N	\N	
8268	\N	\N	\N	
8269	\N	\N	\N	
8270	\N	\N	\N	
8271	\N	\N	\N	
8272	\N	\N	\N	
8273	\N	\N	\N	
8274	\N	\N	\N	
8275	\N	\N	\N	
8276	\N	\N	\N	
8277	\N	\N	\N	
8278	\N	\N	\N	
8279	\N	\N	\N	
8280	\N	\N	\N	
8281	\N	\N	\N	
8282	\N	\N	\N	
8283	\N	\N	\N	
8284	\N	\N	\N	
8285	\N	\N	\N	
8286	\N	\N	\N	
8287	\N	\N	\N	
8288	\N	\N	\N	
8289	\N	\N	\N	
8290	\N	\N	\N	
8291	\N	\N	\N	
8292	\N	\N	\N	
8293	\N	\N	\N	
8294	\N	\N	\N	
8295	\N	\N	\N	
8296	\N	\N	\N	
8297	\N	\N	\N	
8298	\N	\N	\N	
8299	\N	\N	\N	
8300	\N	\N	\N	
8301	\N	\N	\N	
8302	\N	\N	\N	
8303	\N	\N	\N	
8304	\N	\N	\N	
8305	\N	\N	\N	
8306	\N	\N	\N	
8307	\N	\N	\N	
8308	\N	\N	\N	
8309	\N	\N	\N	
8310	\N	\N	\N	
8311	\N	\N	\N	
8312	\N	\N	\N	
8313	\N	\N	\N	
8314	\N	\N	\N	
8315	\N	\N	\N	
8316	\N	\N	\N	
8317	\N	\N	\N	
8318	\N	\N	\N	
8319	\N	\N	\N	
8320	\N	\N	\N	
8321	\N	\N	\N	
8322	\N	\N	\N	
8323	\N	\N	\N	
8324	\N	\N	\N	
8325	\N	\N	\N	
8326	\N	\N	\N	
8327	\N	\N	\N	
8328	\N	\N	\N	
8329	\N	\N	\N	
8330	\N	\N	\N	
8331	\N	\N	\N	
8332	\N	\N	\N	
8333	\N	\N	\N	
8334	\N	\N	\N	
8335	\N	\N	\N	
8336	\N	\N	\N	
8337	\N	\N	\N	
8338	\N	\N	\N	
8339	\N	\N	\N	
8340	\N	\N	\N	
8341	\N	\N	\N	
8342	\N	\N	\N	
8343	\N	\N	\N	
8344	\N	\N	\N	
8345	\N	\N	\N	
8346	\N	\N	\N	
8347	\N	\N	\N	
8348	\N	\N	\N	
8349	\N	\N	\N	
8350	\N	\N	\N	
8351	\N	\N	\N	
8352	\N	\N	\N	
8353	\N	\N	\N	
8354	\N	\N	\N	
8355	\N	\N	\N	
8356	\N	\N	\N	
8357	\N	\N	\N	
8358	\N	\N	\N	
8359	\N	\N	\N	
8360	\N	\N	\N	
8361	\N	\N	\N	
8362	\N	\N	\N	
8363	\N	\N	\N	
8364	\N	\N	\N	
8365	\N	\N	\N	
8366	\N	\N	\N	
8367	\N	\N	\N	
8368	\N	\N	\N	
8369	\N	\N	\N	
8370	\N	\N	\N	
8371	\N	\N	\N	
8372	\N	\N	\N	
8373	\N	\N	\N	
8374	\N	\N	\N	
8375	\N	\N	\N	
8376	\N	\N	\N	
8377	\N	\N	\N	
8378	\N	\N	\N	
8379	\N	\N	\N	
8380	\N	\N	\N	
8381	\N	\N	\N	
8382	\N	\N	\N	
8383	\N	\N	\N	
8384	\N	\N	\N	
8385	\N	\N	\N	
8386	\N	\N	\N	
8387	\N	\N	\N	
8388	\N	\N	\N	
8389	\N	\N	\N	
8390	\N	\N	\N	
8391	\N	\N	\N	
8392	\N	\N	\N	
8393	\N	\N	\N	
8394	\N	\N	\N	
8395	\N	\N	\N	
8396	\N	\N	\N	
8397	\N	\N	\N	
8398	\N	\N	\N	
8399	\N	\N	\N	
8400	\N	\N	\N	
8401	\N	\N	\N	
8402	\N	\N	\N	
8403	\N	\N	\N	
8404	\N	\N	\N	
8405	\N	\N	\N	
8406	\N	\N	\N	
8407	\N	\N	\N	
8408	\N	\N	\N	
8409	\N	\N	\N	
8410	\N	\N	\N	
8411	\N	\N	\N	
8412	\N	\N	\N	
8413	\N	\N	\N	
8414	\N	\N	\N	
8415	\N	\N	\N	
8416	\N	\N	\N	
8417	\N	\N	\N	
8418	\N	\N	\N	
8419	\N	\N	\N	
8420	\N	\N	\N	
8421	\N	\N	\N	
8422	\N	\N	\N	
8423	\N	\N	\N	
8424	\N	\N	\N	
8425	\N	\N	\N	
8426	\N	\N	\N	
8427	\N	\N	\N	
8428	\N	\N	\N	
8429	\N	\N	\N	
8430	\N	\N	\N	
8431	\N	\N	\N	
8432	\N	\N	\N	
8433	\N	\N	\N	
8434	\N	\N	\N	
8435	\N	\N	\N	
8436	\N	\N	\N	
8437	\N	\N	\N	
8438	\N	\N	\N	
8439	\N	\N	\N	
8440	\N	\N	\N	
8441	\N	\N	\N	
8442	\N	\N	\N	
8443	\N	\N	\N	
8444	\N	\N	\N	
8445	\N	\N	\N	
8446	\N	\N	\N	
8447	\N	\N	\N	
8448	\N	\N	\N	
8449	\N	\N	\N	
8450	\N	\N	\N	
8451	\N	\N	\N	
8452	\N	\N	\N	
8453	\N	\N	\N	
8454	\N	\N	\N	
8455	\N	\N	\N	
8456	\N	\N	\N	
8457	\N	\N	\N	
8458	\N	\N	\N	
8459	\N	\N	\N	
8460	\N	\N	\N	
8461	\N	\N	\N	
8462	\N	\N	\N	
8463	\N	\N	\N	
8464	\N	\N	\N	
8465	\N	\N	\N	
8466	\N	\N	\N	
8467	\N	\N	\N	
8468	\N	\N	\N	
8469	\N	\N	\N	
8470	\N	\N	\N	
8471	\N	\N	\N	
8472	\N	\N	\N	
8473	\N	\N	\N	
8474	\N	\N	\N	
8475	\N	\N	\N	
8476	\N	\N	\N	
8477	\N	\N	\N	
8478	\N	\N	\N	
8479	\N	\N	\N	
8480	\N	\N	\N	
8481	\N	\N	\N	
8482	\N	\N	\N	
8483	\N	\N	\N	
8484	\N	\N	\N	
8485	\N	\N	\N	
8486	\N	\N	\N	
8487	\N	\N	\N	
8488	\N	\N	\N	
8489	\N	\N	\N	
8490	\N	\N	\N	
8491	\N	\N	\N	
8492	\N	\N	\N	
8493	\N	\N	\N	
8494	\N	\N	\N	
8495	\N	\N	\N	
8496	\N	\N	\N	
8497	\N	\N	\N	
8498	\N	\N	\N	
8499	\N	\N	\N	
8500	\N	\N	\N	
8501	\N	\N	\N	
8502	\N	\N	\N	
8503	\N	\N	\N	
8504	\N	\N	\N	
8505	\N	\N	\N	
8506	\N	\N	\N	
8507	\N	\N	\N	
8508	\N	\N	\N	
8509	\N	\N	\N	
8510	\N	\N	\N	
8511	\N	\N	\N	
8512	\N	\N	\N	
8513	\N	\N	\N	
8514	\N	\N	\N	
8515	\N	\N	\N	
8516	\N	\N	\N	
8517	\N	\N	\N	
8518	\N	\N	\N	
8519	\N	\N	\N	
8520	\N	\N	\N	
8521	\N	\N	\N	
8522	\N	\N	\N	
8523	\N	\N	\N	
8524	\N	\N	\N	
8525	\N	\N	\N	
8526	\N	\N	\N	
8527	\N	\N	\N	
8528	\N	\N	\N	
8529	\N	\N	\N	
8530	\N	\N	\N	
8531	\N	\N	\N	
8532	\N	\N	\N	
8533	\N	\N	\N	
8534	\N	\N	\N	
8535	\N	\N	\N	
8536	\N	\N	\N	
8537	\N	\N	\N	
8538	\N	\N	\N	
8539	\N	\N	\N	
8540	\N	\N	\N	
8541	\N	\N	\N	
8542	\N	\N	\N	
8543	\N	\N	\N	
8544	\N	\N	\N	
8545	\N	\N	\N	
8546	\N	\N	\N	
8547	\N	\N	\N	
8548	\N	\N	\N	
8549	\N	\N	\N	
8550	\N	\N	\N	
8551	\N	\N	\N	
8552	\N	\N	\N	
8553	\N	\N	\N	
8554	\N	\N	\N	
8555	\N	\N	\N	
8556	\N	\N	\N	
8557	\N	\N	\N	
8558	\N	\N	\N	
8559	\N	\N	\N	
8560	\N	\N	\N	
8561	\N	\N	\N	
8562	\N	\N	\N	
8563	\N	\N	\N	
8564	\N	\N	\N	
8565	\N	\N	\N	
8566	\N	\N	\N	
8567	\N	\N	\N	
8568	\N	\N	\N	
8569	\N	\N	\N	
8570	\N	\N	\N	
8571	\N	\N	\N	
8572	\N	\N	\N	
8573	\N	\N	\N	
8574	\N	\N	\N	
8575	\N	\N	\N	
8576	\N	\N	\N	
8577	\N	\N	\N	
8578	\N	\N	\N	
8579	\N	\N	\N	
8580	\N	\N	\N	
8581	\N	\N	\N	
8582	\N	\N	\N	
8583	\N	\N	\N	
8584	\N	\N	\N	
8585	\N	\N	\N	
8586	\N	\N	\N	
8587	\N	\N	\N	
8588	\N	\N	\N	
8589	\N	\N	\N	
8590	\N	\N	\N	
8591	\N	\N	\N	
8592	\N	\N	\N	
8593	\N	\N	\N	
8594	\N	\N	\N	
8595	\N	\N	\N	
8596	\N	\N	\N	
8597	\N	\N	\N	
8598	\N	\N	\N	
8599	\N	\N	\N	
8600	\N	\N	\N	
8601	\N	\N	\N	
8602	\N	\N	\N	
8603	\N	\N	\N	
8604	\N	\N	\N	
8605	\N	\N	\N	
8606	\N	\N	\N	
8607	\N	\N	\N	
8608	\N	\N	\N	
8609	\N	\N	\N	
8610	\N	\N	\N	
8611	\N	\N	\N	
8612	\N	\N	\N	
8613	\N	\N	\N	
8614	\N	\N	\N	
8615	\N	\N	\N	
8616	\N	\N	\N	
8617	\N	\N	\N	
8618	\N	\N	\N	
8619	\N	\N	\N	
8620	\N	\N	\N	
8621	\N	\N	\N	
8622	\N	\N	\N	
8623	\N	\N	\N	
8624	\N	\N	\N	
8625	\N	\N	\N	
8626	\N	\N	\N	
8627	\N	\N	\N	
8628	\N	\N	\N	
8629	\N	\N	\N	
8630	\N	\N	\N	
8631	\N	\N	\N	
8632	\N	\N	\N	
8633	\N	\N	\N	
8634	\N	\N	\N	
8635	\N	\N	\N	
8636	\N	\N	\N	
8637	\N	\N	\N	
8638	\N	\N	\N	
8639	\N	\N	\N	
8640	\N	\N	\N	
8641	\N	\N	\N	
8642	\N	\N	\N	
8643	\N	\N	\N	
8644	\N	\N	\N	
8645	\N	\N	\N	
8646	\N	\N	\N	
8647	\N	\N	\N	
8648	\N	\N	\N	
8649	\N	\N	\N	
8650	\N	\N	\N	
8651	\N	\N	\N	
8652	\N	\N	\N	
8653	\N	\N	\N	
8654	\N	\N	\N	
8655	\N	\N	\N	
8656	\N	\N	\N	
8657	\N	\N	\N	
8658	\N	\N	\N	
8659	\N	\N	\N	
8660	\N	\N	\N	
8661	\N	\N	\N	
8662	\N	\N	\N	
8663	\N	\N	\N	
8664	\N	\N	\N	
8665	\N	\N	\N	
8666	\N	\N	\N	
8667	\N	\N	\N	
8668	\N	\N	\N	
8669	\N	\N	\N	
8670	\N	\N	\N	
8671	\N	\N	\N	
8672	\N	\N	\N	
8673	\N	\N	\N	
8674	\N	\N	\N	
8675	\N	\N	\N	
8676	\N	\N	\N	
8677	\N	\N	\N	
8678	\N	\N	\N	
8679	\N	\N	\N	
8680	\N	\N	\N	
8681	\N	\N	\N	
8682	\N	\N	\N	
8683	\N	\N	\N	
8684	\N	\N	\N	
8685	\N	\N	\N	
8686	\N	\N	\N	
8687	\N	\N	\N	
8688	\N	\N	\N	
8689	\N	\N	\N	
8690	\N	\N	\N	
8691	\N	\N	\N	
8692	\N	\N	\N	
8693	\N	\N	\N	
8694	\N	\N	\N	
8695	\N	\N	\N	
8696	\N	\N	\N	
8697	\N	\N	\N	
8698	\N	\N	\N	
8699	\N	\N	\N	
8700	\N	\N	\N	
8701	\N	\N	\N	
8702	\N	\N	\N	
8703	\N	\N	\N	
8704	\N	\N	\N	
8705	\N	\N	\N	
8706	\N	\N	\N	
8707	\N	\N	\N	
8708	\N	\N	\N	
8709	\N	\N	\N	
8710	\N	\N	\N	
8711	\N	\N	\N	
8712	\N	\N	\N	
8713	\N	\N	\N	
8714	\N	\N	\N	
8715	\N	\N	\N	
8716	\N	\N	\N	
8717	\N	\N	\N	
8718	\N	\N	\N	
8719	\N	\N	\N	
8720	\N	\N	\N	
8721	\N	\N	\N	
8722	\N	\N	\N	
8723	\N	\N	\N	
8724	\N	\N	\N	
8725	\N	\N	\N	
8726	\N	\N	\N	
8727	\N	\N	\N	
8728	\N	\N	\N	
8729	\N	\N	\N	
8730	\N	\N	\N	
8731	\N	\N	\N	
8732	\N	\N	\N	
8733	\N	\N	\N	
8734	\N	\N	\N	
8735	\N	\N	\N	
8736	\N	\N	\N	
8737	\N	\N	\N	
8738	\N	\N	\N	
8739	\N	\N	\N	
8740	\N	\N	\N	
8741	\N	\N	\N	
8742	\N	\N	\N	
8743	\N	\N	\N	
8744	\N	\N	\N	
8745	\N	\N	\N	
8746	\N	\N	\N	
8747	\N	\N	\N	
8748	\N	\N	\N	
8749	\N	\N	\N	
8750	\N	\N	\N	
8751	\N	\N	\N	
8752	\N	\N	\N	
8753	\N	\N	\N	
8754	\N	\N	\N	
8755	\N	\N	\N	
8756	\N	\N	\N	
8757	\N	\N	\N	
8758	\N	\N	\N	
8759	\N	\N	\N	
8760	\N	\N	\N	
8761	\N	\N	\N	
8762	\N	\N	\N	
8763	\N	\N	\N	
8764	\N	\N	\N	
8765	\N	\N	\N	
8766	\N	\N	\N	
8767	\N	\N	\N	
8768	\N	\N	\N	
8769	\N	\N	\N	
8770	\N	\N	\N	
8771	\N	\N	\N	
8772	\N	\N	\N	
8773	\N	\N	\N	
8774	\N	\N	\N	
8775	\N	\N	\N	
8776	\N	\N	\N	
8777	\N	\N	\N	
8778	\N	\N	\N	
8779	\N	\N	\N	
8780	\N	\N	\N	
8781	\N	\N	\N	
8782	\N	\N	\N	
8783	\N	\N	\N	
8784	\N	\N	\N	
8785	\N	\N	\N	
8786	\N	\N	\N	
8787	\N	\N	\N	
8788	\N	\N	\N	
8789	\N	\N	\N	
8790	\N	\N	\N	
8791	\N	\N	\N	
8792	\N	\N	\N	
8793	\N	\N	\N	
8794	\N	\N	\N	
8795	\N	\N	\N	
8796	\N	\N	\N	
8797	\N	\N	\N	
8798	\N	\N	\N	
8799	\N	\N	\N	
8800	\N	\N	\N	
8801	\N	\N	\N	
8802	\N	\N	\N	
8803	\N	\N	\N	
8804	\N	\N	\N	
8805	\N	\N	\N	
8806	\N	\N	\N	
8807	\N	\N	\N	
8808	\N	\N	\N	
8809	\N	\N	\N	
8810	\N	\N	\N	
8811	\N	\N	\N	
8812	\N	\N	\N	
8813	\N	\N	\N	
8814	\N	\N	\N	
8815	\N	\N	\N	
8816	\N	\N	\N	
8817	\N	\N	\N	
8818	\N	\N	\N	
8819	\N	\N	\N	
8820	\N	\N	\N	
8821	\N	\N	\N	
8822	\N	\N	\N	
8823	\N	\N	\N	
8824	\N	\N	\N	
8825	\N	\N	\N	
8826	\N	\N	\N	
8827	\N	\N	\N	
8828	\N	\N	\N	
8829	\N	\N	\N	
8830	\N	\N	\N	
8831	\N	\N	\N	
8832	\N	\N	\N	
8833	\N	\N	\N	
8834	\N	\N	\N	
8835	\N	\N	\N	
8836	\N	\N	\N	
8837	\N	\N	\N	
8838	\N	\N	\N	
8839	\N	\N	\N	
8840	\N	\N	\N	
8841	\N	\N	\N	
8842	\N	\N	\N	
8843	\N	\N	\N	
8844	\N	\N	\N	
8845	\N	\N	\N	
8846	\N	\N	\N	
8847	\N	\N	\N	
8848	\N	\N	\N	
8849	\N	\N	\N	
8850	\N	\N	\N	
8851	\N	\N	\N	
8852	\N	\N	\N	
8853	\N	\N	\N	
8854	\N	\N	\N	
8855	\N	\N	\N	
8856	\N	\N	\N	
8857	\N	\N	\N	
8858	\N	\N	\N	
8859	\N	\N	\N	
8860	\N	\N	\N	
8861	\N	\N	\N	
8862	\N	\N	\N	
8863	\N	\N	\N	
8864	\N	\N	\N	
8865	\N	\N	\N	
8866	\N	\N	\N	
8867	\N	\N	\N	
8868	\N	\N	\N	
8869	\N	\N	\N	
8870	\N	\N	\N	
8871	\N	\N	\N	
8872	\N	\N	\N	
8873	\N	\N	\N	
8874	\N	\N	\N	
8875	\N	\N	\N	
8876	\N	\N	\N	
8877	\N	\N	\N	
8878	\N	\N	\N	
8879	\N	\N	\N	
8880	\N	\N	\N	
8881	\N	\N	\N	
8882	\N	\N	\N	
8883	\N	\N	\N	
8884	\N	\N	\N	
8885	\N	\N	\N	
8886	\N	\N	\N	
8887	\N	\N	\N	
8888	\N	\N	\N	
8889	\N	\N	\N	
8890	\N	\N	\N	
8891	\N	\N	\N	
8892	\N	\N	\N	
8893	\N	\N	\N	
8894	\N	\N	\N	
8895	\N	\N	\N	
8896	\N	\N	\N	
8897	\N	\N	\N	
8898	\N	\N	\N	
8899	\N	\N	\N	
8900	\N	\N	\N	
8901	\N	\N	\N	
8902	\N	\N	\N	
8903	\N	\N	\N	
8904	\N	\N	\N	
8905	\N	\N	\N	
8906	\N	\N	\N	
8907	\N	\N	\N	
8908	\N	\N	\N	
8909	\N	\N	\N	
8910	\N	\N	\N	
8911	\N	\N	\N	
8912	\N	\N	\N	
8913	\N	\N	\N	
8914	\N	\N	\N	
8915	\N	\N	\N	
8916	\N	\N	\N	
8917	\N	\N	\N	
8918	\N	\N	\N	
8919	\N	\N	\N	
8920	\N	\N	\N	
8921	\N	\N	\N	
8922	\N	\N	\N	
8923	\N	\N	\N	
8924	\N	\N	\N	
8925	\N	\N	\N	
8926	\N	\N	\N	
8927	\N	\N	\N	
8928	\N	\N	\N	
8929	\N	\N	\N	
8930	\N	\N	\N	
8931	\N	\N	\N	
8932	\N	\N	\N	
8933	\N	\N	\N	
8934	\N	\N	\N	
8935	\N	\N	\N	
8936	\N	\N	\N	
8937	\N	\N	\N	
8938	\N	\N	\N	
8939	\N	\N	\N	
8940	\N	\N	\N	
8941	\N	\N	\N	
8942	\N	\N	\N	
8943	\N	\N	\N	
8944	\N	\N	\N	
8945	\N	\N	\N	
8946	\N	\N	\N	
8947	\N	\N	\N	
8948	\N	\N	\N	
8949	\N	\N	\N	
8950	\N	\N	\N	
8951	\N	\N	\N	
8952	\N	\N	\N	
8953	\N	\N	\N	
8954	\N	\N	\N	
8955	\N	\N	\N	
8956	\N	\N	\N	
8957	\N	\N	\N	
8958	\N	\N	\N	
8959	\N	\N	\N	
8960	\N	\N	\N	
8961	\N	\N	\N	
8962	\N	\N	\N	
8963	\N	\N	\N	
8964	\N	\N	\N	
8965	\N	\N	\N	
8966	\N	\N	\N	
8967	\N	\N	\N	
8968	\N	\N	\N	
8969	\N	\N	\N	
8970	\N	\N	\N	
8971	\N	\N	\N	
8972	\N	\N	\N	
8973	\N	\N	\N	
8974	\N	\N	\N	
8975	\N	\N	\N	
8976	\N	\N	\N	
8977	\N	\N	\N	
8978	\N	\N	\N	
8979	\N	\N	\N	
8980	\N	\N	\N	
8981	\N	\N	\N	
8982	\N	\N	\N	
8983	\N	\N	\N	
8984	\N	\N	\N	
8985	\N	\N	\N	
8986	\N	\N	\N	
8987	\N	\N	\N	
8988	\N	\N	\N	
8989	\N	\N	\N	
8990	\N	\N	\N	
8991	\N	\N	\N	
8992	\N	\N	\N	
8993	\N	\N	\N	
8994	\N	\N	\N	
8995	\N	\N	\N	
8996	\N	\N	\N	
8997	\N	\N	\N	
8998	\N	\N	\N	
8999	\N	\N	\N	
9000	\N	\N	\N	
9001	\N	\N	\N	
9002	\N	\N	\N	
9003	\N	\N	\N	
9004	\N	\N	\N	
9005	\N	\N	\N	
9006	\N	\N	\N	
9007	\N	\N	\N	
9008	\N	\N	\N	
9009	\N	\N	\N	
9010	\N	\N	\N	
9011	\N	\N	\N	
9012	\N	\N	\N	
9013	\N	\N	\N	
9014	\N	\N	\N	
9015	\N	\N	\N	
9016	\N	\N	\N	
9017	\N	\N	\N	
9018	\N	\N	\N	
9019	\N	\N	\N	
9020	\N	\N	\N	
9021	\N	\N	\N	
9022	\N	\N	\N	
9023	\N	\N	\N	
9024	\N	\N	\N	
9025	\N	\N	\N	
9026	\N	\N	\N	
9027	\N	\N	\N	
9028	\N	\N	\N	
9029	\N	\N	\N	
9030	\N	\N	\N	
9031	\N	\N	\N	
9032	\N	\N	\N	
9033	\N	\N	\N	
9034	\N	\N	\N	
9035	\N	\N	\N	
9036	\N	\N	\N	
9037	\N	\N	\N	
9038	\N	\N	\N	
9039	\N	\N	\N	
9040	\N	\N	\N	
9041	\N	\N	\N	
9042	\N	\N	\N	
9043	\N	\N	\N	
9044	\N	\N	\N	
9045	\N	\N	\N	
9046	\N	\N	\N	
9047	\N	\N	\N	
9048	\N	\N	\N	
9049	\N	\N	\N	
9050	\N	\N	\N	
9051	\N	\N	\N	
9052	\N	\N	\N	
9053	\N	\N	\N	
9054	\N	\N	\N	
9055	\N	\N	\N	
9056	\N	\N	\N	
9057	\N	\N	\N	
9058	\N	\N	\N	
9059	\N	\N	\N	
9060	\N	\N	\N	
9061	\N	\N	\N	
9062	\N	\N	\N	
9063	\N	\N	\N	
9064	\N	\N	\N	
9065	\N	\N	\N	
9066	\N	\N	\N	
9067	\N	\N	\N	
9068	\N	\N	\N	
9069	\N	\N	\N	
9070	\N	\N	\N	
9071	\N	\N	\N	
9072	\N	\N	\N	
9073	\N	\N	\N	
9074	\N	\N	\N	
9075	\N	\N	\N	
9076	\N	\N	\N	
9077	\N	\N	\N	
9078	\N	\N	\N	
9079	\N	\N	\N	
9080	\N	\N	\N	
9081	\N	\N	\N	
9082	\N	\N	\N	
9083	\N	\N	\N	
9084	\N	\N	\N	
9085	\N	\N	\N	
9086	\N	\N	\N	
9087	\N	\N	\N	
9088	\N	\N	\N	
9089	\N	\N	\N	
9090	\N	\N	\N	
9091	\N	\N	\N	
9092	\N	\N	\N	
9093	\N	\N	\N	
9094	\N	\N	\N	
9095	\N	\N	\N	
9096	\N	\N	\N	
9097	\N	\N	\N	
9098	\N	\N	\N	
9099	\N	\N	\N	
9100	\N	\N	\N	
9101	\N	\N	\N	
9102	\N	\N	\N	
9103	\N	\N	\N	
9104	\N	\N	\N	
9105	\N	\N	\N	
9106	\N	\N	\N	
9107	\N	\N	\N	
9108	\N	\N	\N	
9109	\N	\N	\N	
9110	\N	\N	\N	
9111	\N	\N	\N	
9112	\N	\N	\N	
9113	\N	\N	\N	
9114	\N	\N	\N	
9115	\N	\N	\N	
9116	\N	\N	\N	
9117	\N	\N	\N	
9118	\N	\N	\N	
9119	\N	\N	\N	
9120	\N	\N	\N	
9121	\N	\N	\N	
9122	\N	\N	\N	
9123	\N	\N	\N	
9124	\N	\N	\N	
9125	\N	\N	\N	
9126	\N	\N	\N	
9127	\N	\N	\N	
9128	\N	\N	\N	
9129	\N	\N	\N	
9130	\N	\N	\N	
9131	\N	\N	\N	
9132	\N	\N	\N	
9133	\N	\N	\N	
9134	\N	\N	\N	
9135	\N	\N	\N	
9136	\N	\N	\N	
9137	\N	\N	\N	
9138	\N	\N	\N	
9139	\N	\N	\N	
9140	\N	\N	\N	
9141	\N	\N	\N	
9142	\N	\N	\N	
9143	\N	\N	\N	
9144	\N	\N	\N	
9145	\N	\N	\N	
9146	\N	\N	\N	
9147	\N	\N	\N	
9148	\N	\N	\N	
9149	\N	\N	\N	
9150	\N	\N	\N	
9151	\N	\N	\N	
9152	\N	\N	\N	
9153	\N	\N	\N	
9154	\N	\N	\N	
9155	\N	\N	\N	
9156	\N	\N	\N	
9157	\N	\N	\N	
9158	\N	\N	\N	
9159	\N	\N	\N	
9160	\N	\N	\N	
9161	\N	\N	\N	
9162	\N	\N	\N	
9163	\N	\N	\N	
9164	\N	\N	\N	
9165	\N	\N	\N	
9166	\N	\N	\N	
9167	\N	\N	\N	
9168	\N	\N	\N	
9169	\N	\N	\N	
9170	\N	\N	\N	
9171	\N	\N	\N	
9172	\N	\N	\N	
9173	\N	\N	\N	
9174	\N	\N	\N	
9175	\N	\N	\N	
9176	\N	\N	\N	
9177	\N	\N	\N	
9178	\N	\N	\N	
9179	\N	\N	\N	
9180	\N	\N	\N	
9181	\N	\N	\N	
9182	\N	\N	\N	
9183	\N	\N	\N	
9184	\N	\N	\N	
9185	\N	\N	\N	
9186	\N	\N	\N	
9187	\N	\N	\N	
9188	\N	\N	\N	
9189	\N	\N	\N	
9190	\N	\N	\N	
9191	\N	\N	\N	
9192	\N	\N	\N	
9193	\N	\N	\N	
9194	\N	\N	\N	
9195	\N	\N	\N	
9196	\N	\N	\N	
9197	\N	\N	\N	
9198	\N	\N	\N	
9199	\N	\N	\N	
9200	\N	\N	\N	
9201	\N	\N	\N	
9202	\N	\N	\N	
9203	\N	\N	\N	
9204	\N	\N	\N	
9205	\N	\N	\N	
9206	\N	\N	\N	
9207	\N	\N	\N	
9208	\N	\N	\N	
9209	\N	\N	\N	
9210	\N	\N	\N	
9211	\N	\N	\N	
9212	\N	\N	\N	
9213	\N	\N	\N	
9214	\N	\N	\N	
9215	\N	\N	\N	
9216	\N	\N	\N	
9217	\N	\N	\N	
9218	\N	\N	\N	
9219	\N	\N	\N	
9220	\N	\N	\N	
9221	\N	\N	\N	
9222	\N	\N	\N	
9223	\N	\N	\N	
9224	\N	\N	\N	
9225	\N	\N	\N	
9226	\N	\N	\N	
9227	\N	\N	\N	
9228	\N	\N	\N	
9229	\N	\N	\N	
9230	\N	\N	\N	
9231	\N	\N	\N	
9232	\N	\N	\N	
9233	\N	\N	\N	
9234	\N	\N	\N	
9235	\N	\N	\N	
9236	\N	\N	\N	
9237	\N	\N	\N	
9238	\N	\N	\N	
9239	\N	\N	\N	
9240	\N	\N	\N	
9241	\N	\N	\N	
9242	\N	\N	\N	
9243	\N	\N	\N	
9244	\N	\N	\N	
9245	\N	\N	\N	
9246	\N	\N	\N	
9247	\N	\N	\N	
9248	\N	\N	\N	
9249	\N	\N	\N	
9250	\N	\N	\N	
9251	\N	\N	\N	
9252	\N	\N	\N	
9253	\N	\N	\N	
9254	\N	\N	\N	
9255	\N	\N	\N	
9256	\N	\N	\N	
9257	\N	\N	\N	
9258	\N	\N	\N	
9259	\N	\N	\N	
9260	\N	\N	\N	
9261	\N	\N	\N	
9262	\N	\N	\N	
9263	\N	\N	\N	
9264	\N	\N	\N	
9265	\N	\N	\N	
9266	\N	\N	\N	
9267	\N	\N	\N	
9268	\N	\N	\N	
9269	\N	\N	\N	
9270	\N	\N	\N	
9271	\N	\N	\N	
9272	\N	\N	\N	
9273	\N	\N	\N	
9274	\N	\N	\N	
9275	\N	\N	\N	
9276	\N	\N	\N	
9277	\N	\N	\N	
9278	\N	\N	\N	
9279	\N	\N	\N	
9280	\N	\N	\N	
9281	\N	\N	\N	
9282	\N	\N	\N	
9283	\N	\N	\N	
9284	\N	\N	\N	
9285	\N	\N	\N	
9286	\N	\N	\N	
9287	\N	\N	\N	
9288	\N	\N	\N	
9289	\N	\N	\N	
9290	\N	\N	\N	
9291	\N	\N	\N	
9292	\N	\N	\N	
9293	\N	\N	\N	
9294	\N	\N	\N	
9295	\N	\N	\N	
9296	\N	\N	\N	
9297	\N	\N	\N	
9298	\N	\N	\N	
9299	\N	\N	\N	
9300	\N	\N	\N	
9301	\N	\N	\N	
9302	\N	\N	\N	
9303	\N	\N	\N	
9304	\N	\N	\N	
9305	\N	\N	\N	
9306	\N	\N	\N	
9307	\N	\N	\N	
9308	\N	\N	\N	
9309	\N	\N	\N	
9310	\N	\N	\N	
9311	\N	\N	\N	
9312	\N	\N	\N	
9313	\N	\N	\N	
9314	\N	\N	\N	
9315	\N	\N	\N	
9316	\N	\N	\N	
9317	\N	\N	\N	
9318	\N	\N	\N	
9319	\N	\N	\N	
9320	\N	\N	\N	
9321	\N	\N	\N	
9322	\N	\N	\N	
9323	\N	\N	\N	
9324	\N	\N	\N	
9325	\N	\N	\N	
9326	\N	\N	\N	
9327	\N	\N	\N	
9328	\N	\N	\N	
9329	\N	\N	\N	
9330	\N	\N	\N	
9331	\N	\N	\N	
9332	\N	\N	\N	
9333	\N	\N	\N	
9334	\N	\N	\N	
9335	\N	\N	\N	
9336	\N	\N	\N	
9337	\N	\N	\N	
9338	\N	\N	\N	
9339	\N	\N	\N	
9340	\N	\N	\N	
9341	\N	\N	\N	
9342	\N	\N	\N	
9343	\N	\N	\N	
9344	\N	\N	\N	
9345	\N	\N	\N	
9346	\N	\N	\N	
9347	\N	\N	\N	
9348	\N	\N	\N	
9349	\N	\N	\N	
9350	\N	\N	\N	
9351	\N	\N	\N	
9352	\N	\N	\N	
9353	\N	\N	\N	
9354	\N	\N	\N	
9355	\N	\N	\N	
9356	\N	\N	\N	
9357	\N	\N	\N	
9358	\N	\N	\N	
9359	\N	\N	\N	
9360	\N	\N	\N	
9361	\N	\N	\N	
9362	\N	\N	\N	
9363	\N	\N	\N	
9364	\N	\N	\N	
9365	\N	\N	\N	
9366	\N	\N	\N	
9367	\N	\N	\N	
9368	\N	\N	\N	
9369	\N	\N	\N	
9370	\N	\N	\N	
9371	\N	\N	\N	
9372	\N	\N	\N	
9373	\N	\N	\N	
9374	\N	\N	\N	
9375	\N	\N	\N	
9376	\N	\N	\N	
9377	\N	\N	\N	
9378	\N	\N	\N	
9379	\N	\N	\N	
9380	\N	\N	\N	
9381	\N	\N	\N	
9382	\N	\N	\N	
9383	\N	\N	\N	
9384	\N	\N	\N	
9385	\N	\N	\N	
9386	\N	\N	\N	
9387	\N	\N	\N	
9388	\N	\N	\N	
9389	\N	\N	\N	
9390	\N	\N	\N	
9391	\N	\N	\N	
9392	\N	\N	\N	
9393	\N	\N	\N	
9394	\N	\N	\N	
9395	\N	\N	\N	
9396	\N	\N	\N	
9397	\N	\N	\N	
9398	\N	\N	\N	
9399	\N	\N	\N	
9400	\N	\N	\N	
9401	\N	\N	\N	
9402	\N	\N	\N	
9403	\N	\N	\N	
9404	\N	\N	\N	
9405	\N	\N	\N	
9406	\N	\N	\N	
9407	\N	\N	\N	
9408	\N	\N	\N	
9409	\N	\N	\N	
9410	\N	\N	\N	
9411	\N	\N	\N	
9412	\N	\N	\N	
9413	\N	\N	\N	
9414	\N	\N	\N	
9415	\N	\N	\N	
9416	\N	\N	\N	
9417	\N	\N	\N	
9418	\N	\N	\N	
9419	\N	\N	\N	
9420	\N	\N	\N	
9421	\N	\N	\N	
9422	\N	\N	\N	
9423	\N	\N	\N	
9424	\N	\N	\N	
9425	\N	\N	\N	
9426	\N	\N	\N	
9427	\N	\N	\N	
9428	\N	\N	\N	
9429	\N	\N	\N	
9430	\N	\N	\N	
9431	\N	\N	\N	
9432	\N	\N	\N	
9433	\N	\N	\N	
9434	\N	\N	\N	
9435	\N	\N	\N	
9436	\N	\N	\N	
9437	\N	\N	\N	
9438	\N	\N	\N	
9439	\N	\N	\N	
9440	\N	\N	\N	
9441	\N	\N	\N	
9442	\N	\N	\N	
9443	\N	\N	\N	
9444	\N	\N	\N	
9445	\N	\N	\N	
9446	\N	\N	\N	
9447	\N	\N	\N	
9448	\N	\N	\N	
9449	\N	\N	\N	
9450	\N	\N	\N	
9451	\N	\N	\N	
9452	\N	\N	\N	
9453	\N	\N	\N	
9454	\N	\N	\N	
9455	\N	\N	\N	
9456	\N	\N	\N	
9457	\N	\N	\N	
9458	\N	\N	\N	
9459	\N	\N	\N	
9460	\N	\N	\N	
9461	\N	\N	\N	
9462	\N	\N	\N	
9463	\N	\N	\N	
9464	\N	\N	\N	
9465	\N	\N	\N	
9466	\N	\N	\N	
9467	\N	\N	\N	
9468	\N	\N	\N	
9469	\N	\N	\N	
9470	\N	\N	\N	
9471	\N	\N	\N	
9472	\N	\N	\N	
9473	\N	\N	\N	
9474	\N	\N	\N	
9475	\N	\N	\N	
9476	\N	\N	\N	
9477	\N	\N	\N	
9478	\N	\N	\N	
9479	\N	\N	\N	
9480	\N	\N	\N	
9481	\N	\N	\N	
9482	\N	\N	\N	
9483	\N	\N	\N	
9484	\N	\N	\N	
9485	\N	\N	\N	
9486	\N	\N	\N	
9487	\N	\N	\N	
9488	\N	\N	\N	
9489	\N	\N	\N	
9490	\N	\N	\N	
9491	\N	\N	\N	
9492	\N	\N	\N	
9493	\N	\N	\N	
9494	\N	\N	\N	
9495	\N	\N	\N	
9496	\N	\N	\N	
9497	\N	\N	\N	
9498	\N	\N	\N	
9499	\N	\N	\N	
9500	\N	\N	\N	
9501	\N	\N	\N	
9502	\N	\N	\N	
9503	\N	\N	\N	
9504	\N	\N	\N	
9505	\N	\N	\N	
9506	\N	\N	\N	
9507	\N	\N	\N	
9508	\N	\N	\N	
9509	\N	\N	\N	
9510	\N	\N	\N	
9511	\N	\N	\N	
9512	\N	\N	\N	
9513	\N	\N	\N	
9514	\N	\N	\N	
9515	\N	\N	\N	
9516	\N	\N	\N	
9517	\N	\N	\N	
9518	\N	\N	\N	
9519	\N	\N	\N	
9520	\N	\N	\N	
9521	\N	\N	\N	
9522	\N	\N	\N	
9523	\N	\N	\N	
9524	\N	\N	\N	
9525	\N	\N	\N	
9526	\N	\N	\N	
9527	\N	\N	\N	
9528	\N	\N	\N	
9529	\N	\N	\N	
9530	\N	\N	\N	
9531	\N	\N	\N	
9532	\N	\N	\N	
9533	\N	\N	\N	
9534	\N	\N	\N	
9535	\N	\N	\N	
9536	\N	\N	\N	
9537	\N	\N	\N	
9538	\N	\N	\N	
9539	\N	\N	\N	
9540	\N	\N	\N	
9541	\N	\N	\N	
9542	\N	\N	\N	
9543	\N	\N	\N	
9544	\N	\N	\N	
9545	\N	\N	\N	
9546	\N	\N	\N	
9547	\N	\N	\N	
9548	\N	\N	\N	
9549	\N	\N	\N	
9550	\N	\N	\N	
9551	\N	\N	\N	
9552	\N	\N	\N	
9553	\N	\N	\N	
9554	\N	\N	\N	
9555	\N	\N	\N	
9556	\N	\N	\N	
9557	\N	\N	\N	
9558	\N	\N	\N	
9559	\N	\N	\N	
9560	\N	\N	\N	
9561	\N	\N	\N	
9562	\N	\N	\N	
9563	\N	\N	\N	
9564	\N	\N	\N	
9565	\N	\N	\N	
9566	\N	\N	\N	
9567	\N	\N	\N	
9568	\N	\N	\N	
9569	\N	\N	\N	
9570	\N	\N	\N	
9571	\N	\N	\N	
9572	\N	\N	\N	
9573	\N	\N	\N	
9574	\N	\N	\N	
9575	\N	\N	\N	
9576	\N	\N	\N	
9577	\N	\N	\N	
9578	\N	\N	\N	
9579	\N	\N	\N	
9580	\N	\N	\N	
9581	\N	\N	\N	
9582	\N	\N	\N	
9583	\N	\N	\N	
9584	\N	\N	\N	
9585	\N	\N	\N	
9586	\N	\N	\N	
9587	\N	\N	\N	
9588	\N	\N	\N	
9589	\N	\N	\N	
9590	\N	\N	\N	
9591	\N	\N	\N	
9592	\N	\N	\N	
9593	\N	\N	\N	
9594	\N	\N	\N	
9595	\N	\N	\N	
9596	\N	\N	\N	
9597	\N	\N	\N	
9598	\N	\N	\N	
9599	\N	\N	\N	
9600	\N	\N	\N	
9601	\N	\N	\N	
9602	\N	\N	\N	
9603	\N	\N	\N	
9604	\N	\N	\N	
9605	\N	\N	\N	
9606	\N	\N	\N	
9607	\N	\N	\N	
9608	\N	\N	\N	
9609	\N	\N	\N	
9610	\N	\N	\N	
9611	\N	\N	\N	
9612	\N	\N	\N	
9613	\N	\N	\N	
9614	\N	\N	\N	
9615	\N	\N	\N	
9616	\N	\N	\N	
9617	\N	\N	\N	
9618	\N	\N	\N	
9619	\N	\N	\N	
9620	\N	\N	\N	
9621	\N	\N	\N	
9622	\N	\N	\N	
9623	\N	\N	\N	
9624	\N	\N	\N	
9625	\N	\N	\N	
9626	\N	\N	\N	
9627	\N	\N	\N	
9628	\N	\N	\N	
9629	\N	\N	\N	
9630	\N	\N	\N	
9631	\N	\N	\N	
9632	\N	\N	\N	
9633	\N	\N	\N	
9634	\N	\N	\N	
9635	\N	\N	\N	
9636	\N	\N	\N	
9637	\N	\N	\N	
9638	\N	\N	\N	
9639	\N	\N	\N	
9640	\N	\N	\N	
9641	\N	\N	\N	
9642	\N	\N	\N	
9643	\N	\N	\N	
9644	\N	\N	\N	
9645	\N	\N	\N	
9646	\N	\N	\N	
9647	\N	\N	\N	
9648	\N	\N	\N	
9649	\N	\N	\N	
9650	\N	\N	\N	
9651	\N	\N	\N	
9652	\N	\N	\N	
9653	\N	\N	\N	
9654	\N	\N	\N	
9655	\N	\N	\N	
9656	\N	\N	\N	
9657	\N	\N	\N	
9658	\N	\N	\N	
9659	\N	\N	\N	
9660	\N	\N	\N	
9661	\N	\N	\N	
9662	\N	\N	\N	
9663	\N	\N	\N	
9664	\N	\N	\N	
9665	\N	\N	\N	
9666	\N	\N	\N	
9667	\N	\N	\N	
9668	\N	\N	\N	
9669	\N	\N	\N	
9670	\N	\N	\N	
9671	\N	\N	\N	
9672	\N	\N	\N	
9673	\N	\N	\N	
9674	\N	\N	\N	
9675	\N	\N	\N	
9676	\N	\N	\N	
9677	\N	\N	\N	
9678	\N	\N	\N	
9679	\N	\N	\N	
9680	\N	\N	\N	
9681	\N	\N	\N	
9682	\N	\N	\N	
9683	\N	\N	\N	
9684	\N	\N	\N	
9685	\N	\N	\N	
9686	\N	\N	\N	
9687	\N	\N	\N	
9688	\N	\N	\N	
9689	\N	\N	\N	
9690	\N	\N	\N	
9691	\N	\N	\N	
9692	\N	\N	\N	
9693	\N	\N	\N	
9694	\N	\N	\N	
9695	\N	\N	\N	
9696	\N	\N	\N	
9697	\N	\N	\N	
9698	\N	\N	\N	
9699	\N	\N	\N	
9700	\N	\N	\N	
9701	\N	\N	\N	
9702	\N	\N	\N	
9703	\N	\N	\N	
9704	\N	\N	\N	
9705	\N	\N	\N	
9706	\N	\N	\N	
9707	\N	\N	\N	
9708	\N	\N	\N	
9709	\N	\N	\N	
9710	\N	\N	\N	
9711	\N	\N	\N	
9712	\N	\N	\N	
9713	\N	\N	\N	
9714	\N	\N	\N	
9715	\N	\N	\N	
9716	\N	\N	\N	
9717	\N	\N	\N	
9718	\N	\N	\N	
9719	\N	\N	\N	
9720	\N	\N	\N	
9721	\N	\N	\N	
9722	\N	\N	\N	
9723	\N	\N	\N	
9724	\N	\N	\N	
9725	\N	\N	\N	
9726	\N	\N	\N	
9727	\N	\N	\N	
9728	\N	\N	\N	
9729	\N	\N	\N	
9730	\N	\N	\N	
9731	\N	\N	\N	
9732	\N	\N	\N	
9733	\N	\N	\N	
9734	\N	\N	\N	
9735	\N	\N	\N	
9736	\N	\N	\N	
9737	\N	\N	\N	
9738	\N	\N	\N	
9739	\N	\N	\N	
9740	\N	\N	\N	
9741	\N	\N	\N	
9742	\N	\N	\N	
9743	\N	\N	\N	
9744	\N	\N	\N	
9745	\N	\N	\N	
9746	\N	\N	\N	
9747	\N	\N	\N	
9748	\N	\N	\N	
9749	\N	\N	\N	
9750	\N	\N	\N	
9751	\N	\N	\N	
9752	\N	\N	\N	
9753	\N	\N	\N	
9754	\N	\N	\N	
9755	\N	\N	\N	
9756	\N	\N	\N	
9757	\N	\N	\N	
9758	\N	\N	\N	
9759	\N	\N	\N	
9760	\N	\N	\N	
9761	\N	\N	\N	
9762	\N	\N	\N	
9763	\N	\N	\N	
9764	\N	\N	\N	
9765	\N	\N	\N	
9766	\N	\N	\N	
9767	\N	\N	\N	
9768	\N	\N	\N	
9769	\N	\N	\N	
9770	\N	\N	\N	
9771	\N	\N	\N	
9772	\N	\N	\N	
9773	\N	\N	\N	
9774	\N	\N	\N	
9775	\N	\N	\N	
9776	\N	\N	\N	
9777	\N	\N	\N	
9778	\N	\N	\N	
9779	\N	\N	\N	
9780	\N	\N	\N	
9781	\N	\N	\N	
9782	\N	\N	\N	
9783	\N	\N	\N	
9784	\N	\N	\N	
9785	\N	\N	\N	
9786	\N	\N	\N	
9787	\N	\N	\N	
9788	\N	\N	\N	
9789	\N	\N	\N	
9790	\N	\N	\N	
9791	\N	\N	\N	
9792	\N	\N	\N	
9793	\N	\N	\N	
9794	\N	\N	\N	
9795	\N	\N	\N	
9796	\N	\N	\N	
9797	\N	\N	\N	
9798	\N	\N	\N	
9799	\N	\N	\N	
9800	\N	\N	\N	
9801	\N	\N	\N	
9802	\N	\N	\N	
9803	\N	\N	\N	
9804	\N	\N	\N	
9805	\N	\N	\N	
9806	\N	\N	\N	
9807	\N	\N	\N	
9808	\N	\N	\N	
9809	\N	\N	\N	
9810	\N	\N	\N	
9811	\N	\N	\N	
9812	\N	\N	\N	
9813	\N	\N	\N	
9814	\N	\N	\N	
9815	\N	\N	\N	
9816	\N	\N	\N	
9817	\N	\N	\N	
9818	\N	\N	\N	
9819	\N	\N	\N	
9820	\N	\N	\N	
9821	\N	\N	\N	
9822	\N	\N	\N	
9823	\N	\N	\N	
9824	\N	\N	\N	
9825	\N	\N	\N	
9826	\N	\N	\N	
9827	\N	\N	\N	
9828	\N	\N	\N	
9829	\N	\N	\N	
9830	\N	\N	\N	
9831	\N	\N	\N	
9832	\N	\N	\N	
9833	\N	\N	\N	
9834	\N	\N	\N	
9835	\N	\N	\N	
9836	\N	\N	\N	
9837	\N	\N	\N	
9838	\N	\N	\N	
9839	\N	\N	\N	
9840	\N	\N	\N	
9841	\N	\N	\N	
9842	\N	\N	\N	
9843	\N	\N	\N	
9844	\N	\N	\N	
9845	\N	\N	\N	
9846	\N	\N	\N	
9847	\N	\N	\N	
9848	\N	\N	\N	
9849	\N	\N	\N	
9850	\N	\N	\N	
9851	\N	\N	\N	
9852	\N	\N	\N	
9853	\N	\N	\N	
9854	\N	\N	\N	
9855	\N	\N	\N	
9856	\N	\N	\N	
9857	\N	\N	\N	
9858	\N	\N	\N	
9859	\N	\N	\N	
9860	\N	\N	\N	
9861	\N	\N	\N	
9862	\N	\N	\N	
9863	\N	\N	\N	
9864	\N	\N	\N	
9865	\N	\N	\N	
9866	\N	\N	\N	
9867	\N	\N	\N	
9868	\N	\N	\N	
9869	\N	\N	\N	
9870	\N	\N	\N	
9871	\N	\N	\N	
9872	\N	\N	\N	
9873	\N	\N	\N	
9874	\N	\N	\N	
9875	\N	\N	\N	
9876	\N	\N	\N	
9877	\N	\N	\N	
9878	\N	\N	\N	
9879	\N	\N	\N	
9880	\N	\N	\N	
9881	\N	\N	\N	
9882	\N	\N	\N	
9883	\N	\N	\N	
9884	\N	\N	\N	
9885	\N	\N	\N	
9886	\N	\N	\N	
9887	\N	\N	\N	
9888	\N	\N	\N	
9889	\N	\N	\N	
9890	\N	\N	\N	
9891	\N	\N	\N	
9892	\N	\N	\N	
9893	\N	\N	\N	
9894	\N	\N	\N	
9895	\N	\N	\N	
9896	\N	\N	\N	
9897	\N	\N	\N	
9898	\N	\N	\N	
9899	\N	\N	\N	
9900	\N	\N	\N	
9901	\N	\N	\N	
9902	\N	\N	\N	
9903	\N	\N	\N	
9904	\N	\N	\N	
9905	\N	\N	\N	
9906	\N	\N	\N	
9907	\N	\N	\N	
9908	\N	\N	\N	
9909	\N	\N	\N	
9910	\N	\N	\N	
9911	\N	\N	\N	
9912	\N	\N	\N	
9913	\N	\N	\N	
9914	\N	\N	\N	
9915	\N	\N	\N	
9916	\N	\N	\N	
9917	\N	\N	\N	
9918	\N	\N	\N	
9919	\N	\N	\N	
9920	\N	\N	\N	
9921	\N	\N	\N	
9922	\N	\N	\N	
9923	\N	\N	\N	
9924	\N	\N	\N	
9925	\N	\N	\N	
9926	\N	\N	\N	
9927	\N	\N	\N	
9928	\N	\N	\N	
9929	\N	\N	\N	
9930	\N	\N	\N	
9931	\N	\N	\N	
9932	\N	\N	\N	
9933	\N	\N	\N	
9934	\N	\N	\N	
9935	\N	\N	\N	
9936	\N	\N	\N	
9937	\N	\N	\N	
9938	\N	\N	\N	
9939	\N	\N	\N	
9940	\N	\N	\N	
9941	\N	\N	\N	
9942	\N	\N	\N	
9943	\N	\N	\N	
9944	\N	\N	\N	
9945	\N	\N	\N	
9946	\N	\N	\N	
9947	\N	\N	\N	
9948	\N	\N	\N	
9949	\N	\N	\N	
9950	\N	\N	\N	
9951	\N	\N	\N	
9952	\N	\N	\N	
9953	\N	\N	\N	
9954	\N	\N	\N	
9955	\N	\N	\N	
9956	\N	\N	\N	
9957	\N	\N	\N	
9958	\N	\N	\N	
9959	\N	\N	\N	
9960	\N	\N	\N	
9961	\N	\N	\N	
9962	\N	\N	\N	
9963	\N	\N	\N	
9964	\N	\N	\N	
9965	\N	\N	\N	
9966	\N	\N	\N	
9967	\N	\N	\N	
9968	\N	\N	\N	
9969	\N	\N	\N	
9970	\N	\N	\N	
9971	\N	\N	\N	
9972	\N	\N	\N	
9973	\N	\N	\N	
9974	\N	\N	\N	
9975	\N	\N	\N	
9976	\N	\N	\N	
9977	\N	\N	\N	
9978	\N	\N	\N	
9979	\N	\N	\N	
9980	\N	\N	\N	
9981	\N	\N	\N	
9982	\N	\N	\N	
9983	\N	\N	\N	
9984	\N	\N	\N	
9985	\N	\N	\N	
9986	\N	\N	\N	
9987	\N	\N	\N	
9988	\N	\N	\N	
9989	\N	\N	\N	
9990	\N	\N	\N	
9991	\N	\N	\N	
9992	\N	\N	\N	
9993	\N	\N	\N	
9994	\N	\N	\N	
9995	\N	\N	\N	
9996	\N	\N	\N	
9997	\N	\N	\N	
9998	\N	\N	\N	
9999	\N	\N	\N	
10000	\N	\N	\N	
10001	\N	\N	\N	
10002	\N	\N	\N	
10003	\N	\N	\N	
10004	\N	\N	\N	
10005	\N	\N	\N	
10006	\N	\N	\N	
10007	\N	\N	\N	
10008	\N	\N	\N	
10009	\N	\N	\N	
10010	\N	\N	\N	
10011	\N	\N	\N	
10012	\N	\N	\N	
10013	\N	\N	\N	
10014	\N	\N	\N	
10015	\N	\N	\N	
10016	\N	\N	\N	
10017	\N	\N	\N	
10018	\N	\N	\N	
10019	\N	\N	\N	
10020	\N	\N	\N	
10021	\N	\N	\N	
10022	\N	\N	\N	
10023	\N	\N	\N	
10024	\N	\N	\N	
10025	\N	\N	\N	
10026	\N	\N	\N	
10027	\N	\N	\N	
10028	\N	\N	\N	
10029	\N	\N	\N	
10030	\N	\N	\N	
10031	\N	\N	\N	
10032	\N	\N	\N	
10033	\N	\N	\N	
10034	\N	\N	\N	
10035	\N	\N	\N	
10036	\N	\N	\N	
10037	\N	\N	\N	
10038	\N	\N	\N	
10039	\N	\N	\N	
10040	\N	\N	\N	
10041	\N	\N	\N	
10042	\N	\N	\N	
10043	\N	\N	\N	
10044	\N	\N	\N	
10045	\N	\N	\N	
10046	\N	\N	\N	
10047	\N	\N	\N	
10048	\N	\N	\N	
10049	\N	\N	\N	
10050	\N	\N	\N	
10051	\N	\N	\N	
10052	\N	\N	\N	
10053	\N	\N	\N	
10054	\N	\N	\N	
10055	\N	\N	\N	
10056	\N	\N	\N	
10057	\N	\N	\N	
10058	\N	\N	\N	
10059	\N	\N	\N	
10060	\N	\N	\N	
10061	\N	\N	\N	
10062	\N	\N	\N	
10063	\N	\N	\N	
10064	\N	\N	\N	
10065	\N	\N	\N	
10066	\N	\N	\N	
10067	\N	\N	\N	
10068	\N	\N	\N	
10069	\N	\N	\N	
10070	\N	\N	\N	
10071	\N	\N	\N	
10072	\N	\N	\N	
10073	\N	\N	\N	
10074	\N	\N	\N	
10075	\N	\N	\N	
10076	\N	\N	\N	
10077	\N	\N	\N	
10078	\N	\N	\N	
10079	\N	\N	\N	
10080	\N	\N	\N	
10081	\N	\N	\N	
10082	\N	\N	\N	
10083	\N	\N	\N	
10084	\N	\N	\N	
10085	\N	\N	\N	
10086	\N	\N	\N	
10087	\N	\N	\N	
10088	\N	\N	\N	
10089	\N	\N	\N	
10090	\N	\N	\N	
10091	\N	\N	\N	
10092	\N	\N	\N	
10093	\N	\N	\N	
10094	\N	\N	\N	
10095	\N	\N	\N	
10096	\N	\N	\N	
10097	\N	\N	\N	
10098	\N	\N	\N	
10099	\N	\N	\N	
10100	\N	\N	\N	
10101	\N	\N	\N	
10102	\N	\N	\N	
10103	\N	\N	\N	
10104	\N	\N	\N	
10105	\N	\N	\N	
10106	\N	\N	\N	
10107	\N	\N	\N	
10108	\N	\N	\N	
10109	\N	\N	\N	
10110	\N	\N	\N	
10111	\N	\N	\N	
10112	\N	\N	\N	
10113	\N	\N	\N	
10114	\N	\N	\N	
10115	\N	\N	\N	
10116	\N	\N	\N	
10117	\N	\N	\N	
10118	\N	\N	\N	
10119	\N	\N	\N	
10120	\N	\N	\N	
10121	\N	\N	\N	
10122	\N	\N	\N	
10123	\N	\N	\N	
10124	\N	\N	\N	
10125	\N	\N	\N	
10126	\N	\N	\N	
10127	\N	\N	\N	
10128	\N	\N	\N	
10129	\N	\N	\N	
10130	\N	\N	\N	
10131	\N	\N	\N	
10132	\N	\N	\N	
10133	\N	\N	\N	
10134	\N	\N	\N	
10135	\N	\N	\N	
10136	\N	\N	\N	
10137	\N	\N	\N	
10138	\N	\N	\N	
10139	\N	\N	\N	
10140	\N	\N	\N	
10141	\N	\N	\N	
10142	\N	\N	\N	
10143	\N	\N	\N	
10144	\N	\N	\N	
10145	\N	\N	\N	
10146	\N	\N	\N	
10147	\N	\N	\N	
10148	\N	\N	\N	
10149	\N	\N	\N	
10150	\N	\N	\N	
10151	\N	\N	\N	
10152	\N	\N	\N	
10153	\N	\N	\N	
10154	\N	\N	\N	
10155	\N	\N	\N	
10156	\N	\N	\N	
10157	\N	\N	\N	
10158	\N	\N	\N	
10159	\N	\N	\N	
10160	\N	\N	\N	
10161	\N	\N	\N	
10162	\N	\N	\N	
10163	\N	\N	\N	
10164	\N	\N	\N	
10165	\N	\N	\N	
10166	\N	\N	\N	
10167	\N	\N	\N	
10168	\N	\N	\N	
10169	\N	\N	\N	
10170	\N	\N	\N	
10171	\N	\N	\N	
10172	\N	\N	\N	
10173	\N	\N	\N	
10174	\N	\N	\N	
10175	\N	\N	\N	
10176	\N	\N	\N	
10177	\N	\N	\N	
10178	\N	\N	\N	
10179	\N	\N	\N	
10180	\N	\N	\N	
10181	\N	\N	\N	
10182	\N	\N	\N	
10183	\N	\N	\N	
10184	\N	\N	\N	
10185	\N	\N	\N	
10186	\N	\N	\N	
10187	\N	\N	\N	
10188	\N	\N	\N	
10189	\N	\N	\N	
10190	\N	\N	\N	
10191	\N	\N	\N	
10192	\N	\N	\N	
10193	\N	\N	\N	
10194	\N	\N	\N	
10195	\N	\N	\N	
10196	\N	\N	\N	
10197	\N	\N	\N	
10198	\N	\N	\N	
10199	\N	\N	\N	
10200	\N	\N	\N	
10201	\N	\N	\N	
10202	\N	\N	\N	
10203	\N	\N	\N	
10204	\N	\N	\N	
10205	\N	\N	\N	
10206	\N	\N	\N	
10207	\N	\N	\N	
10208	\N	\N	\N	
10209	\N	\N	\N	
10210	\N	\N	\N	
10211	\N	\N	\N	
10212	\N	\N	\N	
10213	\N	\N	\N	
10214	\N	\N	\N	
10215	\N	\N	\N	
10216	\N	\N	\N	
10217	\N	\N	\N	
10218	\N	\N	\N	
10219	\N	\N	\N	
10220	\N	\N	\N	
10221	\N	\N	\N	
10222	\N	\N	\N	
10223	\N	\N	\N	
10224	\N	\N	\N	
10225	\N	\N	\N	
10226	\N	\N	\N	
10227	\N	\N	\N	
10228	\N	\N	\N	
10229	\N	\N	\N	
10230	\N	\N	\N	
10231	\N	\N	\N	
10232	\N	\N	\N	
10233	\N	\N	\N	
10234	\N	\N	\N	
10235	\N	\N	\N	
10236	\N	\N	\N	
10237	\N	\N	\N	
10238	\N	\N	\N	
10239	\N	\N	\N	
10240	\N	\N	\N	
10241	\N	\N	\N	
10242	\N	\N	\N	
10243	\N	\N	\N	
10244	\N	\N	\N	
10245	\N	\N	\N	
10246	\N	\N	\N	
10247	\N	\N	\N	
10248	\N	\N	\N	
10249	\N	\N	\N	
10250	\N	\N	\N	
10251	\N	\N	\N	
10252	\N	\N	\N	
10253	\N	\N	\N	
10254	\N	\N	\N	
10255	\N	\N	\N	
10256	\N	\N	\N	
10257	\N	\N	\N	
10258	\N	\N	\N	
10259	\N	\N	\N	
10260	\N	\N	\N	
10261	\N	\N	\N	
10262	\N	\N	\N	
10263	\N	\N	\N	
10264	\N	\N	\N	
10265	\N	\N	\N	
10266	\N	\N	\N	
10267	\N	\N	\N	
10268	\N	\N	\N	
10269	\N	\N	\N	
10270	\N	\N	\N	
10271	\N	\N	\N	
10272	\N	\N	\N	
10273	\N	\N	\N	
10274	\N	\N	\N	
10275	\N	\N	\N	
10276	\N	\N	\N	
10277	\N	\N	\N	
10278	\N	\N	\N	
10279	\N	\N	\N	
10280	\N	\N	\N	
10281	\N	\N	\N	
10282	\N	\N	\N	
10283	\N	\N	\N	
10284	\N	\N	\N	
10285	\N	\N	\N	
10286	\N	\N	\N	
10287	\N	\N	\N	
10288	\N	\N	\N	
10289	\N	\N	\N	
10290	\N	\N	\N	
10291	\N	\N	\N	
10292	\N	\N	\N	
10293	\N	\N	\N	
10294	\N	\N	\N	
10295	\N	\N	\N	
10296	\N	\N	\N	
10297	\N	\N	\N	
10298	\N	\N	\N	
10299	\N	\N	\N	
10300	\N	\N	\N	
10301	\N	\N	\N	
10302	\N	\N	\N	
10303	\N	\N	\N	
10304	\N	\N	\N	
10305	\N	\N	\N	
10306	\N	\N	\N	
10307	\N	\N	\N	
10308	\N	\N	\N	
10309	\N	\N	\N	
10310	\N	\N	\N	
10311	\N	\N	\N	
10312	\N	\N	\N	
10313	\N	\N	\N	
10314	\N	\N	\N	
10315	\N	\N	\N	
10316	\N	\N	\N	
10317	\N	\N	\N	
10318	\N	\N	\N	
10319	\N	\N	\N	
10320	\N	\N	\N	
10321	\N	\N	\N	
10322	\N	\N	\N	
10323	\N	\N	\N	
10324	\N	\N	\N	
10325	\N	\N	\N	
10326	\N	\N	\N	
10327	\N	\N	\N	
10328	\N	\N	\N	
10329	\N	\N	\N	
10330	\N	\N	\N	
10331	\N	\N	\N	
10332	\N	\N	\N	
10333	\N	\N	\N	
10334	\N	\N	\N	
10335	\N	\N	\N	
10336	\N	\N	\N	
10337	\N	\N	\N	
10338	\N	\N	\N	
10339	\N	\N	\N	
10340	\N	\N	\N	
10341	\N	\N	\N	
10342	\N	\N	\N	
10343	\N	\N	\N	
10344	\N	\N	\N	
10345	\N	\N	\N	
10346	\N	\N	\N	
10347	\N	\N	\N	
10348	\N	\N	\N	
10349	\N	\N	\N	
10350	\N	\N	\N	
10351	\N	\N	\N	
10352	\N	\N	\N	
10353	\N	\N	\N	
10354	\N	\N	\N	
10355	\N	\N	\N	
10356	\N	\N	\N	
10357	\N	\N	\N	
10358	\N	\N	\N	
10359	\N	\N	\N	
10360	\N	\N	\N	
10361	\N	\N	\N	
10362	\N	\N	\N	
10363	\N	\N	\N	
10364	\N	\N	\N	
10365	\N	\N	\N	
10366	\N	\N	\N	
10367	\N	\N	\N	
10368	\N	\N	\N	
10369	\N	\N	\N	
10370	\N	\N	\N	
10371	\N	\N	\N	
10372	\N	\N	\N	
10373	\N	\N	\N	
10374	\N	\N	\N	
10375	\N	\N	\N	
10376	\N	\N	\N	
10377	\N	\N	\N	
10378	\N	\N	\N	
10379	\N	\N	\N	
10380	\N	\N	\N	
10381	\N	\N	\N	
10382	\N	\N	\N	
10383	\N	\N	\N	
10384	\N	\N	\N	
10385	\N	\N	\N	
10386	\N	\N	\N	
10387	\N	\N	\N	
10388	\N	\N	\N	
10389	\N	\N	\N	
10390	\N	\N	\N	
10391	\N	\N	\N	
10392	\N	\N	\N	
10393	\N	\N	\N	
10394	\N	\N	\N	
10395	\N	\N	\N	
10396	\N	\N	\N	
10397	\N	\N	\N	
10398	\N	\N	\N	
10399	\N	\N	\N	
10400	\N	\N	\N	
10401	\N	\N	\N	
10402	\N	\N	\N	
10403	\N	\N	\N	
10404	\N	\N	\N	
10405	\N	\N	\N	
10406	\N	\N	\N	
10407	\N	\N	\N	
10408	\N	\N	\N	
10409	\N	\N	\N	
10410	\N	\N	\N	
10411	\N	\N	\N	
10412	\N	\N	\N	
10413	\N	\N	\N	
10414	\N	\N	\N	
10415	\N	\N	\N	
10416	\N	\N	\N	
10417	\N	\N	\N	
10418	\N	\N	\N	
10419	\N	\N	\N	
10420	\N	\N	\N	
10421	\N	\N	\N	
10422	\N	\N	\N	
10423	\N	\N	\N	
10424	\N	\N	\N	
10425	\N	\N	\N	
10426	\N	\N	\N	
10427	\N	\N	\N	
10428	\N	\N	\N	
10429	\N	\N	\N	
10430	\N	\N	\N	
10431	\N	\N	\N	
10432	\N	\N	\N	
10433	\N	\N	\N	
10434	\N	\N	\N	
10435	\N	\N	\N	
10436	\N	\N	\N	
10437	\N	\N	\N	
10438	\N	\N	\N	
10439	\N	\N	\N	
10440	\N	\N	\N	
10441	\N	\N	\N	
10442	\N	\N	\N	
10443	\N	\N	\N	
10444	\N	\N	\N	
10445	\N	\N	\N	
10446	\N	\N	\N	
10447	\N	\N	\N	
10448	\N	\N	\N	
10449	\N	\N	\N	
10450	\N	\N	\N	
10451	\N	\N	\N	
10452	\N	\N	\N	
10453	\N	\N	\N	
10454	\N	\N	\N	
10455	\N	\N	\N	
10456	\N	\N	\N	
10457	\N	\N	\N	
10458	\N	\N	\N	
10459	\N	\N	\N	
10460	\N	\N	\N	
10461	\N	\N	\N	
10462	\N	\N	\N	
10463	\N	\N	\N	
10464	\N	\N	\N	
10465	\N	\N	\N	
10466	\N	\N	\N	
10467	\N	\N	\N	
10468	\N	\N	\N	
10469	\N	\N	\N	
10470	\N	\N	\N	
10471	\N	\N	\N	
10472	\N	\N	\N	
10473	\N	\N	\N	
10474	\N	\N	\N	
10475	\N	\N	\N	
10476	\N	\N	\N	
10477	\N	\N	\N	
10478	\N	\N	\N	
10479	\N	\N	\N	
10480	\N	\N	\N	
10481	\N	\N	\N	
10482	\N	\N	\N	
10483	\N	\N	\N	
10484	\N	\N	\N	
10485	\N	\N	\N	
10486	\N	\N	\N	
10487	\N	\N	\N	
10488	\N	\N	\N	
10489	\N	\N	\N	
10490	\N	\N	\N	
10491	\N	\N	\N	
10492	\N	\N	\N	
10493	\N	\N	\N	
10494	\N	\N	\N	
10495	\N	\N	\N	
10496	\N	\N	\N	
10497	\N	\N	\N	
10498	\N	\N	\N	
10499	\N	\N	\N	
10500	\N	\N	\N	
10501	\N	\N	\N	
10502	\N	\N	\N	
10503	\N	\N	\N	
10504	\N	\N	\N	
10505	\N	\N	\N	
10506	\N	\N	\N	
10507	\N	\N	\N	
10508	\N	\N	\N	
10509	\N	\N	\N	
10510	\N	\N	\N	
10511	\N	\N	\N	
10512	\N	\N	\N	
10513	\N	\N	\N	
10514	\N	\N	\N	
10515	\N	\N	\N	
10516	\N	\N	\N	
10517	\N	\N	\N	
10518	\N	\N	\N	
10519	\N	\N	\N	
10520	\N	\N	\N	
10521	\N	\N	\N	
10522	\N	\N	\N	
10523	\N	\N	\N	
10524	\N	\N	\N	
10525	\N	\N	\N	
10526	\N	\N	\N	
10527	\N	\N	\N	
10528	\N	\N	\N	
10529	\N	\N	\N	
10530	\N	\N	\N	
10531	\N	\N	\N	
10532	\N	\N	\N	
10533	\N	\N	\N	
10534	\N	\N	\N	
10535	\N	\N	\N	
10536	\N	\N	\N	
10537	\N	\N	\N	
10538	\N	\N	\N	
10539	\N	\N	\N	
10540	\N	\N	\N	
10541	\N	\N	\N	
10542	\N	\N	\N	
10543	\N	\N	\N	
10544	\N	\N	\N	
10545	\N	\N	\N	
10546	\N	\N	\N	
10547	\N	\N	\N	
10548	\N	\N	\N	
10549	\N	\N	\N	
10550	\N	\N	\N	
10551	\N	\N	\N	
10552	\N	\N	\N	
10553	\N	\N	\N	
10554	\N	\N	\N	
10555	\N	\N	\N	
10556	\N	\N	\N	
10557	\N	\N	\N	
10558	\N	\N	\N	
10559	\N	\N	\N	
10560	\N	\N	\N	
10561	\N	\N	\N	
10562	\N	\N	\N	
10563	\N	\N	\N	
10564	\N	\N	\N	
10565	\N	\N	\N	
10566	\N	\N	\N	
10567	\N	\N	\N	
10568	\N	\N	\N	
10569	\N	\N	\N	
10570	\N	\N	\N	
10571	\N	\N	\N	
10572	\N	\N	\N	
10573	\N	\N	\N	
10574	\N	\N	\N	
10575	\N	\N	\N	
10576	\N	\N	\N	
10577	\N	\N	\N	
10578	\N	\N	\N	
10579	\N	\N	\N	
10580	\N	\N	\N	
10581	\N	\N	\N	
10582	\N	\N	\N	
10583	\N	\N	\N	
10584	\N	\N	\N	
10585	\N	\N	\N	
10586	\N	\N	\N	
10587	\N	\N	\N	
10588	\N	\N	\N	
10589	\N	\N	\N	
10590	\N	\N	\N	
10591	\N	\N	\N	
10592	\N	\N	\N	
10593	\N	\N	\N	
10594	\N	\N	\N	
10595	\N	\N	\N	
10596	\N	\N	\N	
10597	\N	\N	\N	
10598	\N	\N	\N	
10599	\N	\N	\N	
10600	\N	\N	\N	
10601	\N	\N	\N	
10602	\N	\N	\N	
10603	\N	\N	\N	
10604	\N	\N	\N	
10605	\N	\N	\N	
10606	\N	\N	\N	
10607	\N	\N	\N	
10608	\N	\N	\N	
10609	\N	\N	\N	
10610	\N	\N	\N	
10611	\N	\N	\N	
10612	\N	\N	\N	
10613	\N	\N	\N	
10614	\N	\N	\N	
10615	\N	\N	\N	
10616	\N	\N	\N	
10617	\N	\N	\N	
10618	\N	\N	\N	
10619	\N	\N	\N	
10620	\N	\N	\N	
10621	\N	\N	\N	
10622	\N	\N	\N	
10623	\N	\N	\N	
10624	\N	\N	\N	
10625	\N	\N	\N	
10626	\N	\N	\N	
10627	\N	\N	\N	
10628	\N	\N	\N	
10629	\N	\N	\N	
10630	\N	\N	\N	
10631	\N	\N	\N	
10632	\N	\N	\N	
10633	\N	\N	\N	
10634	\N	\N	\N	
10635	\N	\N	\N	
10636	\N	\N	\N	
10637	\N	\N	\N	
10638	\N	\N	\N	
10639	\N	\N	\N	
10640	\N	\N	\N	
10641	\N	\N	\N	
10642	\N	\N	\N	
10643	\N	\N	\N	
10644	\N	\N	\N	
10645	\N	\N	\N	
10646	\N	\N	\N	
10647	\N	\N	\N	
10648	\N	\N	\N	
10649	\N	\N	\N	
10650	\N	\N	\N	
10651	\N	\N	\N	
10652	\N	\N	\N	
10653	\N	\N	\N	
10654	\N	\N	\N	
10655	\N	\N	\N	
10656	\N	\N	\N	
10657	\N	\N	\N	
10658	\N	\N	\N	
10659	\N	\N	\N	
10660	\N	\N	\N	
10661	\N	\N	\N	
10662	\N	\N	\N	
10663	\N	\N	\N	
10664	\N	\N	\N	
10665	\N	\N	\N	
10666	\N	\N	\N	
10667	\N	\N	\N	
10668	\N	\N	\N	
10669	\N	\N	\N	
10670	\N	\N	\N	
10671	\N	\N	\N	
10672	\N	\N	\N	
10673	\N	\N	\N	
10674	\N	\N	\N	
10675	\N	\N	\N	
10676	\N	\N	\N	
10677	\N	\N	\N	
10678	\N	\N	\N	
10679	\N	\N	\N	
10680	\N	\N	\N	
10681	\N	\N	\N	
10682	\N	\N	\N	
10683	\N	\N	\N	
10684	\N	\N	\N	
10685	\N	\N	\N	
10686	\N	\N	\N	
10687	\N	\N	\N	
10688	\N	\N	\N	
10689	\N	\N	\N	
10690	\N	\N	\N	
10691	\N	\N	\N	
10692	\N	\N	\N	
10693	\N	\N	\N	
10694	\N	\N	\N	
10695	\N	\N	\N	
10696	\N	\N	\N	
10697	\N	\N	\N	
10698	\N	\N	\N	
10699	\N	\N	\N	
10700	\N	\N	\N	
10701	\N	\N	\N	
10702	\N	\N	\N	
10703	\N	\N	\N	
10704	\N	\N	\N	
10705	\N	\N	\N	
10706	\N	\N	\N	
10707	\N	\N	\N	
10708	\N	\N	\N	
10709	\N	\N	\N	
10710	\N	\N	\N	
10711	\N	\N	\N	
10712	\N	\N	\N	
10713	\N	\N	\N	
10714	\N	\N	\N	
10715	\N	\N	\N	
10716	\N	\N	\N	
10717	\N	\N	\N	
10718	\N	\N	\N	
10719	\N	\N	\N	
10720	\N	\N	\N	
10721	\N	\N	\N	
10722	\N	\N	\N	
10723	\N	\N	\N	
10724	\N	\N	\N	
10725	\N	\N	\N	
10726	\N	\N	\N	
10727	\N	\N	\N	
10728	\N	\N	\N	
10729	\N	\N	\N	
10730	\N	\N	\N	
10731	\N	\N	\N	
10732	\N	\N	\N	
10733	\N	\N	\N	
10734	\N	\N	\N	
10735	\N	\N	\N	
10736	\N	\N	\N	
10737	\N	\N	\N	
10738	\N	\N	\N	
10739	\N	\N	\N	
10740	\N	\N	\N	
10741	\N	\N	\N	
10742	\N	\N	\N	
10743	\N	\N	\N	
10744	\N	\N	\N	
10745	\N	\N	\N	
10746	\N	\N	\N	
10747	\N	\N	\N	
10748	\N	\N	\N	
10749	\N	\N	\N	
10750	\N	\N	\N	
10751	\N	\N	\N	
10752	\N	\N	\N	
10753	\N	\N	\N	
10754	\N	\N	\N	
10755	\N	\N	\N	
10756	\N	\N	\N	
10757	\N	\N	\N	
10758	\N	\N	\N	
10759	\N	\N	\N	
10760	\N	\N	\N	
10761	\N	\N	\N	
10762	\N	\N	\N	
10763	\N	\N	\N	
10764	\N	\N	\N	
10765	\N	\N	\N	
10766	\N	\N	\N	
10767	\N	\N	\N	
10768	\N	\N	\N	
10769	\N	\N	\N	
10770	\N	\N	\N	
10771	\N	\N	\N	
10772	\N	\N	\N	
10773	\N	\N	\N	
10774	\N	\N	\N	
10775	\N	\N	\N	
10776	\N	\N	\N	
10777	\N	\N	\N	
10778	\N	\N	\N	
10779	\N	\N	\N	
10780	\N	\N	\N	
10781	\N	\N	\N	
10782	\N	\N	\N	
10783	\N	\N	\N	
10784	\N	\N	\N	
10785	\N	\N	\N	
10786	\N	\N	\N	
10787	\N	\N	\N	
10788	\N	\N	\N	
10789	\N	\N	\N	
10790	\N	\N	\N	
10791	\N	\N	\N	
10792	\N	\N	\N	
10793	\N	\N	\N	
10794	\N	\N	\N	
10795	\N	\N	\N	
10796	\N	\N	\N	
10797	\N	\N	\N	
10798	\N	\N	\N	
10799	\N	\N	\N	
10800	\N	\N	\N	
10801	\N	\N	\N	
10802	\N	\N	\N	
10803	\N	\N	\N	
10804	\N	\N	\N	
10805	\N	\N	\N	
10806	\N	\N	\N	
10807	\N	\N	\N	
10808	\N	\N	\N	
10809	\N	\N	\N	
10810	\N	\N	\N	
10811	\N	\N	\N	
10812	\N	\N	\N	
10813	\N	\N	\N	
10814	\N	\N	\N	
10815	\N	\N	\N	
10816	\N	\N	\N	
10817	\N	\N	\N	
10818	\N	\N	\N	
10819	\N	\N	\N	
10820	\N	\N	\N	
10821	\N	\N	\N	
10822	\N	\N	\N	
10823	\N	\N	\N	
10824	\N	\N	\N	
10825	\N	\N	\N	
10826	\N	\N	\N	
10827	\N	\N	\N	
10828	\N	\N	\N	
10829	\N	\N	\N	
10830	\N	\N	\N	
10831	\N	\N	\N	
10832	\N	\N	\N	
10833	\N	\N	\N	
10834	\N	\N	\N	
10835	\N	\N	\N	
10836	\N	\N	\N	
10837	\N	\N	\N	
10838	\N	\N	\N	
10839	\N	\N	\N	
10840	\N	\N	\N	
10841	\N	\N	\N	
10842	\N	\N	\N	
10843	\N	\N	\N	
10844	\N	\N	\N	
10845	\N	\N	\N	
10846	\N	\N	\N	
10847	\N	\N	\N	
10848	\N	\N	\N	
10849	\N	\N	\N	
10850	\N	\N	\N	
10851	\N	\N	\N	
10852	\N	\N	\N	
10853	\N	\N	\N	
10854	\N	\N	\N	
10855	\N	\N	\N	
10856	\N	\N	\N	
10857	\N	\N	\N	
10858	\N	\N	\N	
10859	\N	\N	\N	
10860	\N	\N	\N	
10861	\N	\N	\N	
10862	\N	\N	\N	
10863	\N	\N	\N	
10864	\N	\N	\N	
10865	\N	\N	\N	
10866	\N	\N	\N	
10867	\N	\N	\N	
10868	\N	\N	\N	
10869	\N	\N	\N	
10870	\N	\N	\N	
10871	\N	\N	\N	
10872	\N	\N	\N	
10873	\N	\N	\N	
10874	\N	\N	\N	
10875	\N	\N	\N	
10876	\N	\N	\N	
10877	\N	\N	\N	
10878	\N	\N	\N	
10879	\N	\N	\N	
10880	\N	\N	\N	
10881	\N	\N	\N	
10882	\N	\N	\N	
10883	\N	\N	\N	
10884	\N	\N	\N	
10885	\N	\N	\N	
10886	\N	\N	\N	
10887	\N	\N	\N	
10888	\N	\N	\N	
10889	\N	\N	\N	
10890	\N	\N	\N	
10891	\N	\N	\N	
10892	\N	\N	\N	
10893	\N	\N	\N	
10894	\N	\N	\N	
10895	\N	\N	\N	
10896	\N	\N	\N	
10897	\N	\N	\N	
10898	\N	\N	\N	
10899	\N	\N	\N	
10900	\N	\N	\N	
10901	\N	\N	\N	
10902	\N	\N	\N	
10903	\N	\N	\N	
10904	\N	\N	\N	
10905	\N	\N	\N	
10906	\N	\N	\N	
10907	\N	\N	\N	
10908	\N	\N	\N	
10909	\N	\N	\N	
10910	\N	\N	\N	
10911	\N	\N	\N	
10912	\N	\N	\N	
10913	\N	\N	\N	
10914	\N	\N	\N	
10915	\N	\N	\N	
10916	\N	\N	\N	
10917	\N	\N	\N	
10918	\N	\N	\N	
10919	\N	\N	\N	
10920	\N	\N	\N	
10921	\N	\N	\N	
10922	\N	\N	\N	
10923	\N	\N	\N	
10924	\N	\N	\N	
10925	\N	\N	\N	
10926	\N	\N	\N	
10927	\N	\N	\N	
10928	\N	\N	\N	
10929	\N	\N	\N	
10930	\N	\N	\N	
10931	\N	\N	\N	
10932	\N	\N	\N	
10933	\N	\N	\N	
10934	\N	\N	\N	
10935	\N	\N	\N	
10936	\N	\N	\N	
10937	\N	\N	\N	
10938	\N	\N	\N	
10939	\N	\N	\N	
10940	\N	\N	\N	
10941	\N	\N	\N	
10942	\N	\N	\N	
10943	\N	\N	\N	
10944	\N	\N	\N	
10945	\N	\N	\N	
10946	\N	\N	\N	
10947	\N	\N	\N	
10948	\N	\N	\N	
10949	\N	\N	\N	
10950	\N	\N	\N	
10951	\N	\N	\N	
10952	\N	\N	\N	
10953	\N	\N	\N	
10954	\N	\N	\N	
10955	\N	\N	\N	
10956	\N	\N	\N	
10957	\N	\N	\N	
10958	\N	\N	\N	
10959	\N	\N	\N	
10960	\N	\N	\N	
10961	\N	\N	\N	
10962	\N	\N	\N	
10963	\N	\N	\N	
10964	\N	\N	\N	
10965	\N	\N	\N	
10966	\N	\N	\N	
10967	\N	\N	\N	
10968	\N	\N	\N	
10969	\N	\N	\N	
10970	\N	\N	\N	
10971	\N	\N	\N	
10972	\N	\N	\N	
10973	\N	\N	\N	
10974	\N	\N	\N	
10975	\N	\N	\N	
10976	\N	\N	\N	
10977	\N	\N	\N	
10978	\N	\N	\N	
10979	\N	\N	\N	
10980	\N	\N	\N	
10981	\N	\N	\N	
10982	\N	\N	\N	
10983	\N	\N	\N	
10984	\N	\N	\N	
10985	\N	\N	\N	
10986	\N	\N	\N	
10987	\N	\N	\N	
10988	\N	\N	\N	
10989	\N	\N	\N	
10990	\N	\N	\N	
10991	\N	\N	\N	
10992	\N	\N	\N	
10993	\N	\N	\N	
10994	\N	\N	\N	
10995	\N	\N	\N	
10996	\N	\N	\N	
10997	\N	\N	\N	
10998	\N	\N	\N	
10999	\N	\N	\N	
11000	\N	\N	\N	
11001	\N	\N	\N	
11002	\N	\N	\N	
11003	\N	\N	\N	
11004	\N	\N	\N	
11005	\N	\N	\N	
11006	\N	\N	\N	
11007	\N	\N	\N	
11008	\N	\N	\N	
11009	\N	\N	\N	
11010	\N	\N	\N	
11011	\N	\N	\N	
11012	\N	\N	\N	
11013	\N	\N	\N	
11014	\N	\N	\N	
11015	\N	\N	\N	
11016	\N	\N	\N	
11017	\N	\N	\N	
11018	\N	\N	\N	
11019	\N	\N	\N	
11020	\N	\N	\N	
11021	\N	\N	\N	
11022	\N	\N	\N	
11023	\N	\N	\N	
11024	\N	\N	\N	
11025	\N	\N	\N	
11026	\N	\N	\N	
11027	\N	\N	\N	
11028	\N	\N	\N	
11029	\N	\N	\N	
11030	\N	\N	\N	
11031	\N	\N	\N	
11032	\N	\N	\N	
11033	\N	\N	\N	
11034	\N	\N	\N	
11035	\N	\N	\N	
11036	\N	\N	\N	
11037	\N	\N	\N	
11038	\N	\N	\N	
11039	\N	\N	\N	
11040	\N	\N	\N	
11041	\N	\N	\N	
11042	\N	\N	\N	
11043	\N	\N	\N	
11044	\N	\N	\N	
11045	\N	\N	\N	
11046	\N	\N	\N	
11047	\N	\N	\N	
11048	\N	\N	\N	
11049	\N	\N	\N	
11050	\N	\N	\N	
11051	\N	\N	\N	
11052	\N	\N	\N	
11053	\N	\N	\N	
11054	\N	\N	\N	
11055	\N	\N	\N	
11056	\N	\N	\N	
11057	\N	\N	\N	
11058	\N	\N	\N	
11059	\N	\N	\N	
11060	\N	\N	\N	
11061	\N	\N	\N	
11062	\N	\N	\N	
11063	\N	\N	\N	
11064	\N	\N	\N	
11065	\N	\N	\N	
11066	\N	\N	\N	
11067	\N	\N	\N	
11068	\N	\N	\N	
11069	\N	\N	\N	
11070	\N	\N	\N	
11071	\N	\N	\N	
11072	\N	\N	\N	
11073	\N	\N	\N	
11074	\N	\N	\N	
11075	\N	\N	\N	
11076	\N	\N	\N	
11077	\N	\N	\N	
11078	\N	\N	\N	
11079	\N	\N	\N	
11080	\N	\N	\N	
11081	\N	\N	\N	
11082	\N	\N	\N	
11083	\N	\N	\N	
11084	\N	\N	\N	
11085	\N	\N	\N	
11086	\N	\N	\N	
11087	\N	\N	\N	
11088	\N	\N	\N	
11089	\N	\N	\N	
11090	\N	\N	\N	
11091	\N	\N	\N	
11092	\N	\N	\N	
11093	\N	\N	\N	
11094	\N	\N	\N	
11095	\N	\N	\N	
11096	\N	\N	\N	
11097	\N	\N	\N	
11098	\N	\N	\N	
11099	\N	\N	\N	
11100	\N	\N	\N	
11101	\N	\N	\N	
11102	\N	\N	\N	
11103	\N	\N	\N	
11104	\N	\N	\N	
11105	\N	\N	\N	
11106	\N	\N	\N	
11107	\N	\N	\N	
11108	\N	\N	\N	
11109	\N	\N	\N	
11110	\N	\N	\N	
11111	\N	\N	\N	
11112	\N	\N	\N	
11113	\N	\N	\N	
11114	\N	\N	\N	
11115	\N	\N	\N	
11116	\N	\N	\N	
11117	\N	\N	\N	
11118	\N	\N	\N	
11119	\N	\N	\N	
11120	\N	\N	\N	
11121	\N	\N	\N	
11122	\N	\N	\N	
11123	\N	\N	\N	
11124	\N	\N	\N	
11125	\N	\N	\N	
11126	\N	\N	\N	
11127	\N	\N	\N	
11128	\N	\N	\N	
11129	\N	\N	\N	
11130	\N	\N	\N	
11131	\N	\N	\N	
11132	\N	\N	\N	
11133	\N	\N	\N	
11134	\N	\N	\N	
11135	\N	\N	\N	
11136	\N	\N	\N	
11137	\N	\N	\N	
11138	\N	\N	\N	
11139	\N	\N	\N	
11140	\N	\N	\N	
11141	\N	\N	\N	
11142	\N	\N	\N	
11143	\N	\N	\N	
11144	\N	\N	\N	
11145	\N	\N	\N	
11146	\N	\N	\N	
11147	\N	\N	\N	
11148	\N	\N	\N	
11149	\N	\N	\N	
11150	\N	\N	\N	
11151	\N	\N	\N	
11152	\N	\N	\N	
11153	\N	\N	\N	
11154	\N	\N	\N	
11155	\N	\N	\N	
11156	\N	\N	\N	
11157	\N	\N	\N	
11158	\N	\N	\N	
11159	\N	\N	\N	
11160	\N	\N	\N	
11161	\N	\N	\N	
11162	\N	\N	\N	
11163	\N	\N	\N	
11164	\N	\N	\N	
11165	\N	\N	\N	
11166	\N	\N	\N	
11167	\N	\N	\N	
11168	\N	\N	\N	
11169	\N	\N	\N	
11170	\N	\N	\N	
11171	\N	\N	\N	
11172	\N	\N	\N	
11173	\N	\N	\N	
11174	\N	\N	\N	
11175	\N	\N	\N	
11176	\N	\N	\N	
11177	\N	\N	\N	
11178	\N	\N	\N	
11179	\N	\N	\N	
11180	\N	\N	\N	
11181	\N	\N	\N	
11182	\N	\N	\N	
11183	\N	\N	\N	
11184	\N	\N	\N	
11185	\N	\N	\N	
11186	\N	\N	\N	
11187	\N	\N	\N	
11188	\N	\N	\N	
11189	\N	\N	\N	
11190	\N	\N	\N	
11191	\N	\N	\N	
11192	\N	\N	\N	
11193	\N	\N	\N	
11194	\N	\N	\N	
11195	\N	\N	\N	
11196	\N	\N	\N	
11197	\N	\N	\N	
11198	\N	\N	\N	
11199	\N	\N	\N	
11200	\N	\N	\N	
11201	\N	\N	\N	
11202	\N	\N	\N	
11203	\N	\N	\N	
11204	\N	\N	\N	
11205	\N	\N	\N	
11206	\N	\N	\N	
11207	\N	\N	\N	
11208	\N	\N	\N	
11209	\N	\N	\N	
11210	\N	\N	\N	
11211	\N	\N	\N	
11212	\N	\N	\N	
11213	\N	\N	\N	
11214	\N	\N	\N	
11215	\N	\N	\N	
11216	\N	\N	\N	
11217	\N	\N	\N	
11218	\N	\N	\N	
11219	\N	\N	\N	
11220	\N	\N	\N	
11221	\N	\N	\N	
11222	\N	\N	\N	
11223	\N	\N	\N	
11224	\N	\N	\N	
11225	\N	\N	\N	
11226	\N	\N	\N	
11227	\N	\N	\N	
11228	\N	\N	\N	
11229	\N	\N	\N	
11230	\N	\N	\N	
11231	\N	\N	\N	
11232	\N	\N	\N	
11233	\N	\N	\N	
11234	\N	\N	\N	
11235	\N	\N	\N	
11236	\N	\N	\N	
11237	\N	\N	\N	
11238	\N	\N	\N	
11239	\N	\N	\N	
11240	\N	\N	\N	
11241	\N	\N	\N	
11242	\N	\N	\N	
11243	\N	\N	\N	
11244	\N	\N	\N	
11245	\N	\N	\N	
11246	\N	\N	\N	
11247	\N	\N	\N	
11248	\N	\N	\N	
11249	\N	\N	\N	
11250	\N	\N	\N	
11251	\N	\N	\N	
11252	\N	\N	\N	
11253	\N	\N	\N	
11254	\N	\N	\N	
11255	\N	\N	\N	
11256	\N	\N	\N	
11257	\N	\N	\N	
11258	\N	\N	\N	
11259	\N	\N	\N	
11260	\N	\N	\N	
11261	\N	\N	\N	
11262	\N	\N	\N	
11263	\N	\N	\N	
11264	\N	\N	\N	
11265	\N	\N	\N	
11266	\N	\N	\N	
11267	\N	\N	\N	
11268	\N	\N	\N	
11269	\N	\N	\N	
11270	\N	\N	\N	
11271	\N	\N	\N	
11272	\N	\N	\N	
11273	\N	\N	\N	
11274	\N	\N	\N	
11275	\N	\N	\N	
11276	\N	\N	\N	
11277	\N	\N	\N	
11278	\N	\N	\N	
11279	\N	\N	\N	
11280	\N	\N	\N	
11281	\N	\N	\N	
11282	\N	\N	\N	
11283	\N	\N	\N	
11284	\N	\N	\N	
11285	\N	\N	\N	
11286	\N	\N	\N	
11287	\N	\N	\N	
11288	\N	\N	\N	
11289	\N	\N	\N	
11290	\N	\N	\N	
11291	\N	\N	\N	
11292	\N	\N	\N	
11293	\N	\N	\N	
11294	\N	\N	\N	
11295	\N	\N	\N	
11296	\N	\N	\N	
11297	\N	\N	\N	
11298	\N	\N	\N	
11299	\N	\N	\N	
11300	\N	\N	\N	
11301	\N	\N	\N	
11302	\N	\N	\N	
11303	\N	\N	\N	
11304	\N	\N	\N	
11305	\N	\N	\N	
11306	\N	\N	\N	
11307	\N	\N	\N	
11308	\N	\N	\N	
11309	\N	\N	\N	
11310	\N	\N	\N	
11311	\N	\N	\N	
11312	\N	\N	\N	
11313	\N	\N	\N	
11314	\N	\N	\N	
11315	\N	\N	\N	
11316	\N	\N	\N	
11317	\N	\N	\N	
11318	\N	\N	\N	
11319	\N	\N	\N	
11320	\N	\N	\N	
11321	\N	\N	\N	
11322	\N	\N	\N	
11323	\N	\N	\N	
11324	\N	\N	\N	
11325	\N	\N	\N	
11326	\N	\N	\N	
11327	\N	\N	\N	
11328	\N	\N	\N	
11329	\N	\N	\N	
11330	\N	\N	\N	
11331	\N	\N	\N	
11332	\N	\N	\N	
11333	\N	\N	\N	
11334	\N	\N	\N	
11335	\N	\N	\N	
11336	\N	\N	\N	
11337	\N	\N	\N	
11338	\N	\N	\N	
11339	\N	\N	\N	
11340	\N	\N	\N	
11341	\N	\N	\N	
11342	\N	\N	\N	
11343	\N	\N	\N	
11344	\N	\N	\N	
11345	\N	\N	\N	
11346	\N	\N	\N	
11347	\N	\N	\N	
11348	\N	\N	\N	
11349	\N	\N	\N	
11350	\N	\N	\N	
11351	\N	\N	\N	
11352	\N	\N	\N	
11353	\N	\N	\N	
11354	\N	\N	\N	
11355	\N	\N	\N	
11356	\N	\N	\N	
11357	\N	\N	\N	
11358	\N	\N	\N	
11359	\N	\N	\N	
11360	\N	\N	\N	
11361	\N	\N	\N	
11362	\N	\N	\N	
11363	\N	\N	\N	
11364	\N	\N	\N	
11365	\N	\N	\N	
11366	\N	\N	\N	
11367	\N	\N	\N	
11368	\N	\N	\N	
11369	\N	\N	\N	
11370	\N	\N	\N	
11371	\N	\N	\N	
11372	\N	\N	\N	
11373	\N	\N	\N	
11374	\N	\N	\N	
11375	\N	\N	\N	
11376	\N	\N	\N	
11377	\N	\N	\N	
11378	\N	\N	\N	
11379	\N	\N	\N	
11380	\N	\N	\N	
11381	\N	\N	\N	
11382	\N	\N	\N	
11383	\N	\N	\N	
11384	\N	\N	\N	
11385	\N	\N	\N	
11386	\N	\N	\N	
11387	\N	\N	\N	
11388	\N	\N	\N	
11389	\N	\N	\N	
11390	\N	\N	\N	
11391	\N	\N	\N	
11392	\N	\N	\N	
11393	\N	\N	\N	
11394	\N	\N	\N	
11395	\N	\N	\N	
11396	\N	\N	\N	
11397	\N	\N	\N	
11398	\N	\N	\N	
11399	\N	\N	\N	
11400	\N	\N	\N	
11401	\N	\N	\N	
11402	\N	\N	\N	
11403	\N	\N	\N	
11404	\N	\N	\N	
11405	\N	\N	\N	
11406	\N	\N	\N	
11407	\N	\N	\N	
11408	\N	\N	\N	
11409	\N	\N	\N	
11410	\N	\N	\N	
11411	\N	\N	\N	
11412	\N	\N	\N	
11413	\N	\N	\N	
11414	\N	\N	\N	
11415	\N	\N	\N	
11416	\N	\N	\N	
11417	\N	\N	\N	
11418	\N	\N	\N	
11419	\N	\N	\N	
11420	\N	\N	\N	
11421	\N	\N	\N	
11422	\N	\N	\N	
11423	\N	\N	\N	
11424	\N	\N	\N	
11425	\N	\N	\N	
11426	\N	\N	\N	
11427	\N	\N	\N	
11428	\N	\N	\N	
11429	\N	\N	\N	
11430	\N	\N	\N	
11431	\N	\N	\N	
11432	\N	\N	\N	
11433	\N	\N	\N	
11434	\N	\N	\N	
11435	\N	\N	\N	
11436	\N	\N	\N	
11437	\N	\N	\N	
11438	\N	\N	\N	
11439	\N	\N	\N	
11440	\N	\N	\N	
11441	\N	\N	\N	
11442	\N	\N	\N	
11443	\N	\N	\N	
11444	\N	\N	\N	
11445	\N	\N	\N	
11446	\N	\N	\N	
11447	\N	\N	\N	
11448	\N	\N	\N	
11449	\N	\N	\N	
11450	\N	\N	\N	
11451	\N	\N	\N	
11452	\N	\N	\N	
11453	\N	\N	\N	
11454	\N	\N	\N	
11455	\N	\N	\N	
11456	\N	\N	\N	
11457	\N	\N	\N	
11458	\N	\N	\N	
11459	\N	\N	\N	
11460	\N	\N	\N	
11461	\N	\N	\N	
11462	\N	\N	\N	
11463	\N	\N	\N	
11464	\N	\N	\N	
11465	\N	\N	\N	
11466	\N	\N	\N	
11467	\N	\N	\N	
11468	\N	\N	\N	
11469	\N	\N	\N	
11470	\N	\N	\N	
11471	\N	\N	\N	
11472	\N	\N	\N	
11473	\N	\N	\N	
11474	\N	\N	\N	
11475	\N	\N	\N	
11476	\N	\N	\N	
11477	\N	\N	\N	
11478	\N	\N	\N	
11479	\N	\N	\N	
11480	\N	\N	\N	
11481	\N	\N	\N	
11482	\N	\N	\N	
11483	\N	\N	\N	
11484	\N	\N	\N	
11485	\N	\N	\N	
11486	\N	\N	\N	
11487	\N	\N	\N	
11488	\N	\N	\N	
11489	\N	\N	\N	
11490	\N	\N	\N	
11491	\N	\N	\N	
11492	\N	\N	\N	
11493	\N	\N	\N	
11494	\N	\N	\N	
11495	\N	\N	\N	
11496	\N	\N	\N	
11497	\N	\N	\N	
11498	\N	\N	\N	
11499	\N	\N	\N	
11500	\N	\N	\N	
11501	\N	\N	\N	
11502	\N	\N	\N	
11503	\N	\N	\N	
11504	\N	\N	\N	
11505	\N	\N	\N	
11506	\N	\N	\N	
11507	\N	\N	\N	
11508	\N	\N	\N	
11509	\N	\N	\N	
11510	\N	\N	\N	
11511	\N	\N	\N	
11512	\N	\N	\N	
11513	\N	\N	\N	
11514	\N	\N	\N	
11515	\N	\N	\N	
11516	\N	\N	\N	
11517	\N	\N	\N	
11518	\N	\N	\N	
11519	\N	\N	\N	
11520	\N	\N	\N	
11521	\N	\N	\N	
11522	\N	\N	\N	
11523	\N	\N	\N	
11524	\N	\N	\N	
11525	\N	\N	\N	
11526	\N	\N	\N	
11527	\N	\N	\N	
11528	\N	\N	\N	
11529	\N	\N	\N	
11530	\N	\N	\N	
11531	\N	\N	\N	
11532	\N	\N	\N	
11533	\N	\N	\N	
11534	\N	\N	\N	
11535	\N	\N	\N	
11536	\N	\N	\N	
11537	\N	\N	\N	
11538	\N	\N	\N	
11539	\N	\N	\N	
11540	\N	\N	\N	
11541	\N	\N	\N	
11542	\N	\N	\N	
11543	\N	\N	\N	
11544	\N	\N	\N	
11545	\N	\N	\N	
11546	\N	\N	\N	
11547	\N	\N	\N	
11548	\N	\N	\N	
11549	\N	\N	\N	
11550	\N	\N	\N	
11551	\N	\N	\N	
11552	\N	\N	\N	
11553	\N	\N	\N	
11554	\N	\N	\N	
11555	\N	\N	\N	
11556	\N	\N	\N	
11557	\N	\N	\N	
11558	\N	\N	\N	
11559	\N	\N	\N	
11560	\N	\N	\N	
11561	\N	\N	\N	
11562	\N	\N	\N	
11563	\N	\N	\N	
11564	\N	\N	\N	
11565	\N	\N	\N	
11566	\N	\N	\N	
11567	\N	\N	\N	
11568	\N	\N	\N	
11569	\N	\N	\N	
11570	\N	\N	\N	
11571	\N	\N	\N	
11572	\N	\N	\N	
11573	\N	\N	\N	
11574	\N	\N	\N	
11575	\N	\N	\N	
11576	\N	\N	\N	
11577	\N	\N	\N	
11578	\N	\N	\N	
11579	\N	\N	\N	
11580	\N	\N	\N	
11581	\N	\N	\N	
11582	\N	\N	\N	
11583	\N	\N	\N	
11584	\N	\N	\N	
11585	\N	\N	\N	
11586	\N	\N	\N	
11587	\N	\N	\N	
11588	\N	\N	\N	
11589	\N	\N	\N	
11590	\N	\N	\N	
11591	\N	\N	\N	
11592	\N	\N	\N	
11593	\N	\N	\N	
11594	\N	\N	\N	
11595	\N	\N	\N	
11596	\N	\N	\N	
11597	\N	\N	\N	
11598	\N	\N	\N	
11599	\N	\N	\N	
11600	\N	\N	\N	
11601	\N	\N	\N	
11602	\N	\N	\N	
11603	\N	\N	\N	
11604	\N	\N	\N	
11605	\N	\N	\N	
11606	\N	\N	\N	
11607	\N	\N	\N	
11608	\N	\N	\N	
11609	\N	\N	\N	
11610	\N	\N	\N	
11611	\N	\N	\N	
11612	\N	\N	\N	
11613	\N	\N	\N	
11614	\N	\N	\N	
11615	\N	\N	\N	
11616	\N	\N	\N	
11617	\N	\N	\N	
11618	\N	\N	\N	
11619	\N	\N	\N	
11620	\N	\N	\N	
11621	\N	\N	\N	
11622	\N	\N	\N	
11623	\N	\N	\N	
11624	\N	\N	\N	
11625	\N	\N	\N	
11626	\N	\N	\N	
11627	\N	\N	\N	
11628	\N	\N	\N	
11629	\N	\N	\N	
11630	\N	\N	\N	
11631	\N	\N	\N	
11632	\N	\N	\N	
11633	\N	\N	\N	
11634	\N	\N	\N	
11635	\N	\N	\N	
11636	\N	\N	\N	
11637	\N	\N	\N	
11638	\N	\N	\N	
11639	\N	\N	\N	
11640	\N	\N	\N	
11641	\N	\N	\N	
11642	\N	\N	\N	
11643	\N	\N	\N	
11644	\N	\N	\N	
11645	\N	\N	\N	
11646	\N	\N	\N	
11647	\N	\N	\N	
11648	\N	\N	\N	
11649	\N	\N	\N	
11650	\N	\N	\N	
11651	\N	\N	\N	
11652	\N	\N	\N	
11653	\N	\N	\N	
11654	\N	\N	\N	
11655	\N	\N	\N	
11656	\N	\N	\N	
11657	\N	\N	\N	
11658	\N	\N	\N	
11659	\N	\N	\N	
11660	\N	\N	\N	
11661	\N	\N	\N	
11662	\N	\N	\N	
11663	\N	\N	\N	
11664	\N	\N	\N	
11665	\N	\N	\N	
11666	\N	\N	\N	
11667	\N	\N	\N	
11668	\N	\N	\N	
11669	\N	\N	\N	
11670	\N	\N	\N	
11671	\N	\N	\N	
11672	\N	\N	\N	
11673	\N	\N	\N	
11674	\N	\N	\N	
11675	\N	\N	\N	
11676	\N	\N	\N	
11677	\N	\N	\N	
11678	\N	\N	\N	
11679	\N	\N	\N	
11680	\N	\N	\N	
11681	\N	\N	\N	
11682	\N	\N	\N	
11683	\N	\N	\N	
11684	\N	\N	\N	
11685	\N	\N	\N	
11686	\N	\N	\N	
11687	\N	\N	\N	
11688	\N	\N	\N	
11689	\N	\N	\N	
11690	\N	\N	\N	
11691	\N	\N	\N	
11692	\N	\N	\N	
11693	\N	\N	\N	
11694	\N	\N	\N	
11695	\N	\N	\N	
11696	\N	\N	\N	
11697	\N	\N	\N	
11698	\N	\N	\N	
11699	\N	\N	\N	
11700	\N	\N	\N	
11701	\N	\N	\N	
11702	\N	\N	\N	
11703	\N	\N	\N	
11704	\N	\N	\N	
11705	\N	\N	\N	
11706	\N	\N	\N	
11707	\N	\N	\N	
11708	\N	\N	\N	
11709	\N	\N	\N	
11710	\N	\N	\N	
11711	\N	\N	\N	
11712	\N	\N	\N	
11713	\N	\N	\N	
11714	\N	\N	\N	
11715	\N	\N	\N	
11716	\N	\N	\N	
11717	\N	\N	\N	
11718	\N	\N	\N	
11719	\N	\N	\N	
11720	\N	\N	\N	
11721	\N	\N	\N	
11722	\N	\N	\N	
11723	\N	\N	\N	
11724	\N	\N	\N	
11725	\N	\N	\N	
11726	\N	\N	\N	
11727	\N	\N	\N	
11728	\N	\N	\N	
11729	\N	\N	\N	
11730	\N	\N	\N	
11731	\N	\N	\N	
11732	\N	\N	\N	
11733	\N	\N	\N	
11734	\N	\N	\N	
11735	\N	\N	\N	
11736	\N	\N	\N	
11737	\N	\N	\N	
11738	\N	\N	\N	
11739	\N	\N	\N	
11740	\N	\N	\N	
11741	\N	\N	\N	
11742	\N	\N	\N	
11743	\N	\N	\N	
11744	\N	\N	\N	
11745	\N	\N	\N	
11746	\N	\N	\N	
11747	\N	\N	\N	
11748	\N	\N	\N	
11749	\N	\N	\N	
11750	\N	\N	\N	
11751	\N	\N	\N	
11752	\N	\N	\N	
11753	\N	\N	\N	
11754	\N	\N	\N	
11755	\N	\N	\N	
11756	\N	\N	\N	
11757	\N	\N	\N	
11758	\N	\N	\N	
11759	\N	\N	\N	
11760	\N	\N	\N	
11761	\N	\N	\N	
11762	\N	\N	\N	
11763	\N	\N	\N	
11764	\N	\N	\N	
11765	\N	\N	\N	
11766	\N	\N	\N	
11767	\N	\N	\N	
11768	\N	\N	\N	
11769	\N	\N	\N	
11770	\N	\N	\N	
11771	\N	\N	\N	
11772	\N	\N	\N	
11773	\N	\N	\N	
11774	\N	\N	\N	
11775	\N	\N	\N	
11776	\N	\N	\N	
11777	\N	\N	\N	
11778	\N	\N	\N	
11779	\N	\N	\N	
11780	\N	\N	\N	
11781	\N	\N	\N	
11782	\N	\N	\N	
11783	\N	\N	\N	
11784	\N	\N	\N	
11785	\N	\N	\N	
11786	\N	\N	\N	
11787	\N	\N	\N	
11788	\N	\N	\N	
11789	\N	\N	\N	
11790	\N	\N	\N	
11791	\N	\N	\N	
11792	\N	\N	\N	
11793	\N	\N	\N	
11794	\N	\N	\N	
11795	\N	\N	\N	
11796	\N	\N	\N	
11797	\N	\N	\N	
11798	\N	\N	\N	
11799	\N	\N	\N	
11800	\N	\N	\N	
11801	\N	\N	\N	
11802	\N	\N	\N	
11803	\N	\N	\N	
11804	\N	\N	\N	
11805	\N	\N	\N	
11806	\N	\N	\N	
11807	\N	\N	\N	
11808	\N	\N	\N	
11809	\N	\N	\N	
11810	\N	\N	\N	
11811	\N	\N	\N	
11812	\N	\N	\N	
11813	\N	\N	\N	
11814	\N	\N	\N	
11815	\N	\N	\N	
11816	\N	\N	\N	
11817	\N	\N	\N	
11818	\N	\N	\N	
11819	\N	\N	\N	
11820	\N	\N	\N	
11821	\N	\N	\N	
11822	\N	\N	\N	
11823	\N	\N	\N	
11824	\N	\N	\N	
11825	\N	\N	\N	
11826	\N	\N	\N	
11827	\N	\N	\N	
11828	\N	\N	\N	
11829	\N	\N	\N	
11830	\N	\N	\N	
11831	\N	\N	\N	
11832	\N	\N	\N	
11833	\N	\N	\N	
11834	\N	\N	\N	
11835	\N	\N	\N	
11836	\N	\N	\N	
11837	\N	\N	\N	
11838	\N	\N	\N	
11839	\N	\N	\N	
11840	\N	\N	\N	
11841	\N	\N	\N	
11842	\N	\N	\N	
11843	\N	\N	\N	
11844	\N	\N	\N	
11845	\N	\N	\N	
11846	\N	\N	\N	
11847	\N	\N	\N	
11848	\N	\N	\N	
11849	\N	\N	\N	
11850	\N	\N	\N	
11851	\N	\N	\N	
11852	\N	\N	\N	
11853	\N	\N	\N	
11854	\N	\N	\N	
11855	\N	\N	\N	
11856	\N	\N	\N	
11857	\N	\N	\N	
11858	\N	\N	\N	
11859	\N	\N	\N	
11860	\N	\N	\N	
11861	\N	\N	\N	
11862	\N	\N	\N	
11863	\N	\N	\N	
11864	\N	\N	\N	
11865	\N	\N	\N	
11866	\N	\N	\N	
11867	\N	\N	\N	
11868	\N	\N	\N	
11869	\N	\N	\N	
11870	\N	\N	\N	
11871	\N	\N	\N	
11872	\N	\N	\N	
11873	\N	\N	\N	
11874	\N	\N	\N	
11875	\N	\N	\N	
11876	\N	\N	\N	
11877	\N	\N	\N	
11878	\N	\N	\N	
11879	\N	\N	\N	
11880	\N	\N	\N	
11881	\N	\N	\N	
11882	\N	\N	\N	
11883	\N	\N	\N	
11884	\N	\N	\N	
11885	\N	\N	\N	
11886	\N	\N	\N	
11887	\N	\N	\N	
11888	\N	\N	\N	
11889	\N	\N	\N	
11890	\N	\N	\N	
11891	\N	\N	\N	
11892	\N	\N	\N	
11893	\N	\N	\N	
11894	\N	\N	\N	
11895	\N	\N	\N	
11896	\N	\N	\N	
11897	\N	\N	\N	
11898	\N	\N	\N	
11899	\N	\N	\N	
11900	\N	\N	\N	
11901	\N	\N	\N	
11902	\N	\N	\N	
11903	\N	\N	\N	
11904	\N	\N	\N	
11905	\N	\N	\N	
11906	\N	\N	\N	
11907	\N	\N	\N	
11908	\N	\N	\N	
11909	\N	\N	\N	
11910	\N	\N	\N	
11911	\N	\N	\N	
11912	\N	\N	\N	
11913	\N	\N	\N	
11914	\N	\N	\N	
11915	\N	\N	\N	
11916	\N	\N	\N	
11917	\N	\N	\N	
11918	\N	\N	\N	
11919	\N	\N	\N	
11920	\N	\N	\N	
11921	\N	\N	\N	
11922	\N	\N	\N	
11923	\N	\N	\N	
11924	\N	\N	\N	
11925	\N	\N	\N	
11926	\N	\N	\N	
11927	\N	\N	\N	
11928	\N	\N	\N	
11929	\N	\N	\N	
11930	\N	\N	\N	
11931	\N	\N	\N	
11932	\N	\N	\N	
11933	\N	\N	\N	
11934	\N	\N	\N	
11935	\N	\N	\N	
11936	\N	\N	\N	
11937	\N	\N	\N	
11938	\N	\N	\N	
11939	\N	\N	\N	
11940	\N	\N	\N	
11941	\N	\N	\N	
11942	\N	\N	\N	
11943	\N	\N	\N	
11944	\N	\N	\N	
11945	\N	\N	\N	
11946	\N	\N	\N	
11947	\N	\N	\N	
11948	\N	\N	\N	
11949	\N	\N	\N	
11950	\N	\N	\N	
11951	\N	\N	\N	
11952	\N	\N	\N	
11953	\N	\N	\N	
11954	\N	\N	\N	
11955	\N	\N	\N	
11956	\N	\N	\N	
11957	\N	\N	\N	
11958	\N	\N	\N	
11959	\N	\N	\N	
11960	\N	\N	\N	
11961	\N	\N	\N	
11962	\N	\N	\N	
11963	\N	\N	\N	
11964	\N	\N	\N	
11965	\N	\N	\N	
11966	\N	\N	\N	
11967	\N	\N	\N	
11968	\N	\N	\N	
11969	\N	\N	\N	
11970	\N	\N	\N	
11971	\N	\N	\N	
11972	\N	\N	\N	
11973	\N	\N	\N	
11974	\N	\N	\N	
11975	\N	\N	\N	
11976	\N	\N	\N	
11977	\N	\N	\N	
11978	\N	\N	\N	
11979	\N	\N	\N	
11980	\N	\N	\N	
11981	\N	\N	\N	
11982	\N	\N	\N	
11983	\N	\N	\N	
11984	\N	\N	\N	
11985	\N	\N	\N	
11986	\N	\N	\N	
11987	\N	\N	\N	
11988	\N	\N	\N	
11989	\N	\N	\N	
11990	\N	\N	\N	
11991	\N	\N	\N	
11992	\N	\N	\N	
11993	\N	\N	\N	
11994	\N	\N	\N	
11995	\N	\N	\N	
11996	\N	\N	\N	
11997	\N	\N	\N	
11998	\N	\N	\N	
11999	\N	\N	\N	
12000	\N	\N	\N	
12001	\N	\N	\N	
12002	\N	\N	\N	
12003	\N	\N	\N	
12004	\N	\N	\N	
12005	\N	\N	\N	
12006	\N	\N	\N	
12007	\N	\N	\N	
12008	\N	\N	\N	
12009	\N	\N	\N	
12010	\N	\N	\N	
12011	\N	\N	\N	
12012	\N	\N	\N	
12013	\N	\N	\N	
12014	\N	\N	\N	
12015	\N	\N	\N	
12016	\N	\N	\N	
12017	\N	\N	\N	
12018	\N	\N	\N	
12019	\N	\N	\N	
12020	\N	\N	\N	
12021	\N	\N	\N	
12022	\N	\N	\N	
12023	\N	\N	\N	
12024	\N	\N	\N	
12025	\N	\N	\N	
12026	\N	\N	\N	
12027	\N	\N	\N	
12028	\N	\N	\N	
12029	\N	\N	\N	
12030	\N	\N	\N	
12031	\N	\N	\N	
12032	\N	\N	\N	
12033	\N	\N	\N	
12034	\N	\N	\N	
12035	\N	\N	\N	
12036	\N	\N	\N	
12037	\N	\N	\N	
12038	\N	\N	\N	
12039	\N	\N	\N	
12040	\N	\N	\N	
12041	\N	\N	\N	
12042	\N	\N	\N	
12043	\N	\N	\N	
12044	\N	\N	\N	
12045	\N	\N	\N	
12046	\N	\N	\N	
12047	\N	\N	\N	
12048	\N	\N	\N	
12049	\N	\N	\N	
12050	\N	\N	\N	
12051	\N	\N	\N	
12052	\N	\N	\N	
12053	\N	\N	\N	
12054	\N	\N	\N	
12055	\N	\N	\N	
12056	\N	\N	\N	
12057	\N	\N	\N	
12058	\N	\N	\N	
12059	\N	\N	\N	
12060	\N	\N	\N	
12061	\N	\N	\N	
12062	\N	\N	\N	
12063	\N	\N	\N	
12064	\N	\N	\N	
12065	\N	\N	\N	
12066	\N	\N	\N	
12067	\N	\N	\N	
12068	\N	\N	\N	
12069	\N	\N	\N	
12070	\N	\N	\N	
12071	\N	\N	\N	
12072	\N	\N	\N	
12073	\N	\N	\N	
12074	\N	\N	\N	
12075	\N	\N	\N	
12076	\N	\N	\N	
12077	\N	\N	\N	
12078	\N	\N	\N	
12079	\N	\N	\N	
12080	\N	\N	\N	
12081	\N	\N	\N	
12082	\N	\N	\N	
12083	\N	\N	\N	
12084	\N	\N	\N	
12085	\N	\N	\N	
12086	\N	\N	\N	
12087	\N	\N	\N	
12088	\N	\N	\N	
12089	\N	\N	\N	
12090	\N	\N	\N	
12091	\N	\N	\N	
12092	\N	\N	\N	
12093	\N	\N	\N	
12094	\N	\N	\N	
12095	\N	\N	\N	
12096	\N	\N	\N	
12097	\N	\N	\N	
12098	\N	\N	\N	
12099	\N	\N	\N	
12100	\N	\N	\N	
12101	\N	\N	\N	
12102	\N	\N	\N	
12103	\N	\N	\N	
12104	\N	\N	\N	
12105	\N	\N	\N	
12106	\N	\N	\N	
12107	\N	\N	\N	
12108	\N	\N	\N	
12109	\N	\N	\N	
12110	\N	\N	\N	
12111	\N	\N	\N	
12112	\N	\N	\N	
12113	\N	\N	\N	
12114	\N	\N	\N	
12115	\N	\N	\N	
12116	\N	\N	\N	
12117	\N	\N	\N	
12118	\N	\N	\N	
12119	\N	\N	\N	
12120	\N	\N	\N	
12121	\N	\N	\N	
12122	\N	\N	\N	
12123	\N	\N	\N	
12124	\N	\N	\N	
12125	\N	\N	\N	
12126	\N	\N	\N	
12127	\N	\N	\N	
12128	\N	\N	\N	
12129	\N	\N	\N	
12130	\N	\N	\N	
12131	\N	\N	\N	
12132	\N	\N	\N	
12133	\N	\N	\N	
12134	\N	\N	\N	
12135	\N	\N	\N	
12136	\N	\N	\N	
12137	\N	\N	\N	
12138	\N	\N	\N	
12139	\N	\N	\N	
12140	\N	\N	\N	
12141	\N	\N	\N	
12142	\N	\N	\N	
12143	\N	\N	\N	
12144	\N	\N	\N	
12145	\N	\N	\N	
12146	\N	\N	\N	
12147	\N	\N	\N	
12148	\N	\N	\N	
12149	\N	\N	\N	
12150	\N	\N	\N	
12151	\N	\N	\N	
12152	\N	\N	\N	
12153	\N	\N	\N	
12154	\N	\N	\N	
12155	\N	\N	\N	
12156	\N	\N	\N	
12157	\N	\N	\N	
12158	\N	\N	\N	
12159	\N	\N	\N	
12160	\N	\N	\N	
12161	\N	\N	\N	
12162	\N	\N	\N	
12163	\N	\N	\N	
12164	\N	\N	\N	
12165	\N	\N	\N	
12166	\N	\N	\N	
12167	\N	\N	\N	
12168	\N	\N	\N	
12169	\N	\N	\N	
12170	\N	\N	\N	
12171	\N	\N	\N	
12172	\N	\N	\N	
12173	\N	\N	\N	
12174	\N	\N	\N	
12175	\N	\N	\N	
12176	\N	\N	\N	
12177	\N	\N	\N	
12178	\N	\N	\N	
12179	\N	\N	\N	
12180	\N	\N	\N	
12181	\N	\N	\N	
12182	\N	\N	\N	
12183	\N	\N	\N	
12184	\N	\N	\N	
12185	\N	\N	\N	
12186	\N	\N	\N	
12187	\N	\N	\N	
12188	\N	\N	\N	
12189	\N	\N	\N	
12190	\N	\N	\N	
12191	\N	\N	\N	
12192	\N	\N	\N	
12193	\N	\N	\N	
12194	\N	\N	\N	
12195	\N	\N	\N	
12196	\N	\N	\N	
12197	\N	\N	\N	
12198	\N	\N	\N	
12199	\N	\N	\N	
12200	\N	\N	\N	
12201	\N	\N	\N	
12202	\N	\N	\N	
12203	\N	\N	\N	
12204	\N	\N	\N	
12205	\N	\N	\N	
12206	\N	\N	\N	
12207	\N	\N	\N	
12208	\N	\N	\N	
12209	\N	\N	\N	
12210	\N	\N	\N	
12211	\N	\N	\N	
12212	\N	\N	\N	
12213	\N	\N	\N	
12214	\N	\N	\N	
12215	\N	\N	\N	
12216	\N	\N	\N	
12217	\N	\N	\N	
12218	\N	\N	\N	
12219	\N	\N	\N	
12220	\N	\N	\N	
12221	\N	\N	\N	
12222	\N	\N	\N	
12223	\N	\N	\N	
12224	\N	\N	\N	
12225	\N	\N	\N	
12226	\N	\N	\N	
12227	\N	\N	\N	
12228	\N	\N	\N	
12229	\N	\N	\N	
12230	\N	\N	\N	
12231	\N	\N	\N	
12232	\N	\N	\N	
12233	\N	\N	\N	
12234	\N	\N	\N	
12235	\N	\N	\N	
12236	\N	\N	\N	
12237	\N	\N	\N	
12238	\N	\N	\N	
12239	\N	\N	\N	
12240	\N	\N	\N	
12241	\N	\N	\N	
12242	\N	\N	\N	
12243	\N	\N	\N	
12244	\N	\N	\N	
12245	\N	\N	\N	
12246	\N	\N	\N	
12247	\N	\N	\N	
12248	\N	\N	\N	
12249	\N	\N	\N	
12250	\N	\N	\N	
12251	\N	\N	\N	
12252	\N	\N	\N	
12253	\N	\N	\N	
12254	\N	\N	\N	
12255	\N	\N	\N	
12256	\N	\N	\N	
12257	\N	\N	\N	
12258	\N	\N	\N	
12259	\N	\N	\N	
12260	\N	\N	\N	
12261	\N	\N	\N	
12262	\N	\N	\N	
12263	\N	\N	\N	
12264	\N	\N	\N	
12265	\N	\N	\N	
12266	\N	\N	\N	
12267	\N	\N	\N	
12268	\N	\N	\N	
12269	\N	\N	\N	
12270	\N	\N	\N	
12271	\N	\N	\N	
12272	\N	\N	\N	
12273	\N	\N	\N	
12274	\N	\N	\N	
12275	\N	\N	\N	
12276	\N	\N	\N	
12277	\N	\N	\N	
12278	\N	\N	\N	
12279	\N	\N	\N	
12280	\N	\N	\N	
12281	\N	\N	\N	
12282	\N	\N	\N	
12283	\N	\N	\N	
12284	\N	\N	\N	
12285	\N	\N	\N	
12286	\N	\N	\N	
12287	\N	\N	\N	
12288	\N	\N	\N	
12289	\N	\N	\N	
12290	\N	\N	\N	
12291	\N	\N	\N	
12292	\N	\N	\N	
12293	\N	\N	\N	
12294	\N	\N	\N	
12295	\N	\N	\N	
12296	\N	\N	\N	
12297	\N	\N	\N	
12298	\N	\N	\N	
12299	\N	\N	\N	
12300	\N	\N	\N	
12301	\N	\N	\N	
12302	\N	\N	\N	
12303	\N	\N	\N	
12304	\N	\N	\N	
12305	\N	\N	\N	
12306	\N	\N	\N	
12307	\N	\N	\N	
12308	\N	\N	\N	
12309	\N	\N	\N	
12310	\N	\N	\N	
12311	\N	\N	\N	
12312	\N	\N	\N	
12313	\N	\N	\N	
12314	\N	\N	\N	
12315	\N	\N	\N	
12316	\N	\N	\N	
12317	\N	\N	\N	
12318	\N	\N	\N	
12319	\N	\N	\N	
12320	\N	\N	\N	
12321	\N	\N	\N	
12322	\N	\N	\N	
12323	\N	\N	\N	
12324	\N	\N	\N	
12325	\N	\N	\N	
12326	\N	\N	\N	
12327	\N	\N	\N	
12328	\N	\N	\N	
12329	\N	\N	\N	
12330	\N	\N	\N	
12331	\N	\N	\N	
12332	\N	\N	\N	
12333	\N	\N	\N	
12334	\N	\N	\N	
12335	\N	\N	\N	
12336	\N	\N	\N	
12337	\N	\N	\N	
12338	\N	\N	\N	
12339	\N	\N	\N	
12340	\N	\N	\N	
12341	\N	\N	\N	
12342	\N	\N	\N	
12343	\N	\N	\N	
12344	\N	\N	\N	
12345	\N	\N	\N	
12346	\N	\N	\N	
12347	\N	\N	\N	
12348	\N	\N	\N	
12349	\N	\N	\N	
12350	\N	\N	\N	
12351	\N	\N	\N	
12352	\N	\N	\N	
12353	\N	\N	\N	
12354	\N	\N	\N	
12355	\N	\N	\N	
12356	\N	\N	\N	
12357	\N	\N	\N	
12358	\N	\N	\N	
12359	\N	\N	\N	
12360	\N	\N	\N	
12361	\N	\N	\N	
12362	\N	\N	\N	
12363	\N	\N	\N	
12364	\N	\N	\N	
12365	\N	\N	\N	
12366	\N	\N	\N	
12367	\N	\N	\N	
12368	\N	\N	\N	
12369	\N	\N	\N	
12370	\N	\N	\N	
12371	\N	\N	\N	
12372	\N	\N	\N	
12373	\N	\N	\N	
12374	\N	\N	\N	
12375	\N	\N	\N	
12376	\N	\N	\N	
12377	\N	\N	\N	
12378	\N	\N	\N	
12379	\N	\N	\N	
12380	\N	\N	\N	
12381	\N	\N	\N	
12382	\N	\N	\N	
12383	\N	\N	\N	
12384	\N	\N	\N	
12385	\N	\N	\N	
12386	\N	\N	\N	
12387	\N	\N	\N	
12388	\N	\N	\N	
12389	\N	\N	\N	
12390	\N	\N	\N	
12391	\N	\N	\N	
12392	\N	\N	\N	
12393	\N	\N	\N	
12394	\N	\N	\N	
12395	\N	\N	\N	
12396	\N	\N	\N	
12397	\N	\N	\N	
12398	\N	\N	\N	
12399	\N	\N	\N	
12400	\N	\N	\N	
12401	\N	\N	\N	
12402	\N	\N	\N	
12403	\N	\N	\N	
12404	\N	\N	\N	
12405	\N	\N	\N	
12406	\N	\N	\N	
12407	\N	\N	\N	
12408	\N	\N	\N	
12409	\N	\N	\N	
12410	\N	\N	\N	
12411	\N	\N	\N	
12412	\N	\N	\N	
12413	\N	\N	\N	
12414	\N	\N	\N	
12415	\N	\N	\N	
12416	\N	\N	\N	
12417	\N	\N	\N	
12418	\N	\N	\N	
12419	\N	\N	\N	
12420	\N	\N	\N	
12421	\N	\N	\N	
12422	\N	\N	\N	
12423	\N	\N	\N	
12424	\N	\N	\N	
12425	\N	\N	\N	
12426	\N	\N	\N	
12427	\N	\N	\N	
12428	\N	\N	\N	
12429	\N	\N	\N	
12430	\N	\N	\N	
12431	\N	\N	\N	
12432	\N	\N	\N	
12433	\N	\N	\N	
12434	\N	\N	\N	
12435	\N	\N	\N	
12436	\N	\N	\N	
12437	\N	\N	\N	
12438	\N	\N	\N	
12439	\N	\N	\N	
12440	\N	\N	\N	
12441	\N	\N	\N	
12442	\N	\N	\N	
12443	\N	\N	\N	
12444	\N	\N	\N	
12445	\N	\N	\N	
12446	\N	\N	\N	
12447	\N	\N	\N	
12448	\N	\N	\N	
12449	\N	\N	\N	
12450	\N	\N	\N	
12451	\N	\N	\N	
12452	\N	\N	\N	
12453	\N	\N	\N	
12454	\N	\N	\N	
12455	\N	\N	\N	
12456	\N	\N	\N	
12457	\N	\N	\N	
12458	\N	\N	\N	
12459	\N	\N	\N	
12460	\N	\N	\N	
12461	\N	\N	\N	
12462	\N	\N	\N	
12463	\N	\N	\N	
12464	\N	\N	\N	
12465	\N	\N	\N	
12466	\N	\N	\N	
12467	\N	\N	\N	
12468	\N	\N	\N	
12469	\N	\N	\N	
12470	\N	\N	\N	
12471	\N	\N	\N	
12472	\N	\N	\N	
12473	\N	\N	\N	
12474	\N	\N	\N	
12475	\N	\N	\N	
12476	\N	\N	\N	
12477	\N	\N	\N	
12478	\N	\N	\N	
12479	\N	\N	\N	
12480	\N	\N	\N	
12481	\N	\N	\N	
12482	\N	\N	\N	
12483	\N	\N	\N	
12484	\N	\N	\N	
12485	\N	\N	\N	
12486	\N	\N	\N	
12487	\N	\N	\N	
12488	\N	\N	\N	
12489	\N	\N	\N	
12490	\N	\N	\N	
12491	\N	\N	\N	
12492	\N	\N	\N	
12493	\N	\N	\N	
12494	\N	\N	\N	
12495	\N	\N	\N	
12496	\N	\N	\N	
12497	\N	\N	\N	
12498	\N	\N	\N	
12499	\N	\N	\N	
12500	\N	\N	\N	
12501	\N	\N	\N	
12502	\N	\N	\N	
12503	\N	\N	\N	
12504	\N	\N	\N	
12505	\N	\N	\N	
12506	\N	\N	\N	
12507	\N	\N	\N	
12508	\N	\N	\N	
12509	\N	\N	\N	
12510	\N	\N	\N	
12511	\N	\N	\N	
12512	\N	\N	\N	
12513	\N	\N	\N	
12514	\N	\N	\N	
12515	\N	\N	\N	
12516	\N	\N	\N	
12517	\N	\N	\N	
12518	\N	\N	\N	
12519	\N	\N	\N	
12520	\N	\N	\N	
12521	\N	\N	\N	
12522	\N	\N	\N	
12523	\N	\N	\N	
12524	\N	\N	\N	
12525	\N	\N	\N	
12526	\N	\N	\N	
12527	\N	\N	\N	
12528	\N	\N	\N	
12529	\N	\N	\N	
12530	\N	\N	\N	
12531	\N	\N	\N	
12532	\N	\N	\N	
12533	\N	\N	\N	
12534	\N	\N	\N	
12535	\N	\N	\N	
12536	\N	\N	\N	
12537	\N	\N	\N	
12538	\N	\N	\N	
12539	\N	\N	\N	
12540	\N	\N	\N	
12541	\N	\N	\N	
12542	\N	\N	\N	
12543	\N	\N	\N	
12544	\N	\N	\N	
12545	\N	\N	\N	
12546	\N	\N	\N	
12547	\N	\N	\N	
12548	\N	\N	\N	
12549	\N	\N	\N	
12550	\N	\N	\N	
12551	\N	\N	\N	
12552	\N	\N	\N	
12553	\N	\N	\N	
12554	\N	\N	\N	
12555	\N	\N	\N	
12556	\N	\N	\N	
12557	\N	\N	\N	
12558	\N	\N	\N	
12559	\N	\N	\N	
12560	\N	\N	\N	
12561	\N	\N	\N	
12562	\N	\N	\N	
12563	\N	\N	\N	
12564	\N	\N	\N	
12565	\N	\N	\N	
12566	\N	\N	\N	
12567	\N	\N	\N	
12568	\N	\N	\N	
12569	\N	\N	\N	
12570	\N	\N	\N	
12571	\N	\N	\N	
12572	\N	\N	\N	
12573	\N	\N	\N	
12574	\N	\N	\N	
12575	\N	\N	\N	
12576	\N	\N	\N	
12577	\N	\N	\N	
12578	\N	\N	\N	
12579	\N	\N	\N	
12580	\N	\N	\N	
12581	\N	\N	\N	
12582	\N	\N	\N	
12583	\N	\N	\N	
12584	\N	\N	\N	
12585	\N	\N	\N	
12586	\N	\N	\N	
12587	\N	\N	\N	
12588	\N	\N	\N	
12589	\N	\N	\N	
12590	\N	\N	\N	
12591	\N	\N	\N	
12592	\N	\N	\N	
12593	\N	\N	\N	
12594	\N	\N	\N	
12595	\N	\N	\N	
12596	\N	\N	\N	
12597	\N	\N	\N	
12598	\N	\N	\N	
12599	\N	\N	\N	
12600	\N	\N	\N	
12601	\N	\N	\N	
12602	\N	\N	\N	
12603	\N	\N	\N	
12604	\N	\N	\N	
12605	\N	\N	\N	
12606	\N	\N	\N	
12607	\N	\N	\N	
12608	\N	\N	\N	
12609	\N	\N	\N	
12610	\N	\N	\N	
12611	\N	\N	\N	
12612	\N	\N	\N	
12613	\N	\N	\N	
12614	\N	\N	\N	
12615	\N	\N	\N	
12616	\N	\N	\N	
12617	\N	\N	\N	
12618	\N	\N	\N	
12619	\N	\N	\N	
12620	\N	\N	\N	
12621	\N	\N	\N	
12622	\N	\N	\N	
12623	\N	\N	\N	
12624	\N	\N	\N	
12625	\N	\N	\N	
12626	\N	\N	\N	
12627	\N	\N	\N	
12628	\N	\N	\N	
12629	\N	\N	\N	
12630	\N	\N	\N	
12631	\N	\N	\N	
12632	\N	\N	\N	
12633	\N	\N	\N	
12634	\N	\N	\N	
12635	\N	\N	\N	
12636	\N	\N	\N	
12637	\N	\N	\N	
12638	\N	\N	\N	
12639	\N	\N	\N	
12640	\N	\N	\N	
12641	\N	\N	\N	
12642	\N	\N	\N	
12643	\N	\N	\N	
12644	\N	\N	\N	
12645	\N	\N	\N	
12646	\N	\N	\N	
12647	\N	\N	\N	
12648	\N	\N	\N	
12649	\N	\N	\N	
12650	\N	\N	\N	
12651	\N	\N	\N	
12652	\N	\N	\N	
12653	\N	\N	\N	
12654	\N	\N	\N	
12655	\N	\N	\N	
12656	\N	\N	\N	
12657	\N	\N	\N	
12658	\N	\N	\N	
12659	\N	\N	\N	
12660	\N	\N	\N	
12661	\N	\N	\N	
12662	\N	\N	\N	
12663	\N	\N	\N	
12664	\N	\N	\N	
12665	\N	\N	\N	
12666	\N	\N	\N	
12667	\N	\N	\N	
12668	\N	\N	\N	
12669	\N	\N	\N	
12670	\N	\N	\N	
12671	\N	\N	\N	
12672	\N	\N	\N	
12673	\N	\N	\N	
12674	\N	\N	\N	
12675	\N	\N	\N	
12676	\N	\N	\N	
12677	\N	\N	\N	
12678	\N	\N	\N	
12679	\N	\N	\N	
12680	\N	\N	\N	
12681	\N	\N	\N	
12682	\N	\N	\N	
12683	\N	\N	\N	
12684	\N	\N	\N	
12685	\N	\N	\N	
12686	\N	\N	\N	
12687	\N	\N	\N	
12688	\N	\N	\N	
12689	\N	\N	\N	
12690	\N	\N	\N	
12691	\N	\N	\N	
12692	\N	\N	\N	
12693	\N	\N	\N	
12694	\N	\N	\N	
12695	\N	\N	\N	
12696	\N	\N	\N	
12697	\N	\N	\N	
12698	\N	\N	\N	
12699	\N	\N	\N	
12700	\N	\N	\N	
12701	\N	\N	\N	
12702	\N	\N	\N	
12703	\N	\N	\N	
12704	\N	\N	\N	
12705	\N	\N	\N	
12706	\N	\N	\N	
12707	\N	\N	\N	
12708	\N	\N	\N	
12709	\N	\N	\N	
12710	\N	\N	\N	
12711	\N	\N	\N	
12712	\N	\N	\N	
12713	\N	\N	\N	
12714	\N	\N	\N	
12715	\N	\N	\N	
12716	\N	\N	\N	
12717	\N	\N	\N	
12718	\N	\N	\N	
12719	\N	\N	\N	
12720	\N	\N	\N	
12721	\N	\N	\N	
12722	\N	\N	\N	
12723	\N	\N	\N	
12724	\N	\N	\N	
12725	\N	\N	\N	
12726	\N	\N	\N	
12727	\N	\N	\N	
12728	\N	\N	\N	
12729	\N	\N	\N	
12730	\N	\N	\N	
12731	\N	\N	\N	
12732	\N	\N	\N	
12733	\N	\N	\N	
12734	\N	\N	\N	
12735	\N	\N	\N	
12736	\N	\N	\N	
12737	\N	\N	\N	
12738	\N	\N	\N	
12739	\N	\N	\N	
12740	\N	\N	\N	
12741	\N	\N	\N	
12742	\N	\N	\N	
12743	\N	\N	\N	
12744	\N	\N	\N	
12745	\N	\N	\N	
12746	\N	\N	\N	
12747	\N	\N	\N	
12748	\N	\N	\N	
12749	\N	\N	\N	
12750	\N	\N	\N	
12751	\N	\N	\N	
12752	\N	\N	\N	
12753	\N	\N	\N	
12754	\N	\N	\N	
12755	\N	\N	\N	
12756	\N	\N	\N	
12757	\N	\N	\N	
12758	\N	\N	\N	
12759	\N	\N	\N	
12760	\N	\N	\N	
12761	\N	\N	\N	
12762	\N	\N	\N	
12763	\N	\N	\N	
12764	\N	\N	\N	
12765	\N	\N	\N	
12766	\N	\N	\N	
12767	\N	\N	\N	
12768	\N	\N	\N	
12769	\N	\N	\N	
12770	\N	\N	\N	
12771	\N	\N	\N	
12772	\N	\N	\N	
12773	\N	\N	\N	
12774	\N	\N	\N	
12775	\N	\N	\N	
12776	\N	\N	\N	
12777	\N	\N	\N	
12778	\N	\N	\N	
12779	\N	\N	\N	
12780	\N	\N	\N	
12781	\N	\N	\N	
12782	\N	\N	\N	
12783	\N	\N	\N	
12784	\N	\N	\N	
12785	\N	\N	\N	
12786	\N	\N	\N	
12787	\N	\N	\N	
12788	\N	\N	\N	
12789	\N	\N	\N	
12790	\N	\N	\N	
12791	\N	\N	\N	
12792	\N	\N	\N	
12793	\N	\N	\N	
12794	\N	\N	\N	
12795	\N	\N	\N	
12796	\N	\N	\N	
12797	\N	\N	\N	
12798	\N	\N	\N	
12799	\N	\N	\N	
12800	\N	\N	\N	
12801	\N	\N	\N	
12802	\N	\N	\N	
12803	\N	\N	\N	
12804	\N	\N	\N	
12805	\N	\N	\N	
12806	\N	\N	\N	
12807	\N	\N	\N	
12808	\N	\N	\N	
12809	\N	\N	\N	
12810	\N	\N	\N	
12811	\N	\N	\N	
12812	\N	\N	\N	
12813	\N	\N	\N	
12814	\N	\N	\N	
12815	\N	\N	\N	
12816	\N	\N	\N	
12817	\N	\N	\N	
12818	\N	\N	\N	
12819	\N	\N	\N	
12820	\N	\N	\N	
12821	\N	\N	\N	
12822	\N	\N	\N	
12823	\N	\N	\N	
12824	\N	\N	\N	
12825	\N	\N	\N	
12826	\N	\N	\N	
12827	\N	\N	\N	
12828	\N	\N	\N	
12829	\N	\N	\N	
12830	\N	\N	\N	
12831	\N	\N	\N	
12832	\N	\N	\N	
12833	\N	\N	\N	
12834	\N	\N	\N	
12835	\N	\N	\N	
12836	\N	\N	\N	
12837	\N	\N	\N	
12838	\N	\N	\N	
12839	\N	\N	\N	
12840	\N	\N	\N	
12841	\N	\N	\N	
12842	\N	\N	\N	
12843	\N	\N	\N	
12844	\N	\N	\N	
12845	\N	\N	\N	
12846	\N	\N	\N	
12847	\N	\N	\N	
12848	\N	\N	\N	
12849	\N	\N	\N	
12850	\N	\N	\N	
12851	\N	\N	\N	
12852	\N	\N	\N	
12853	\N	\N	\N	
12854	\N	\N	\N	
12855	\N	\N	\N	
12856	\N	\N	\N	
12857	\N	\N	\N	
12858	\N	\N	\N	
12859	\N	\N	\N	
12860	\N	\N	\N	
12861	\N	\N	\N	
12862	\N	\N	\N	
12863	\N	\N	\N	
12864	\N	\N	\N	
12865	\N	\N	\N	
12866	\N	\N	\N	
12867	\N	\N	\N	
12868	\N	\N	\N	
12869	\N	\N	\N	
12870	\N	\N	\N	
12871	\N	\N	\N	
12872	\N	\N	\N	
12873	\N	\N	\N	
12874	\N	\N	\N	
12875	\N	\N	\N	
12876	\N	\N	\N	
12877	\N	\N	\N	
12878	\N	\N	\N	
12879	\N	\N	\N	
12880	\N	\N	\N	
12881	\N	\N	\N	
12882	\N	\N	\N	
12883	\N	\N	\N	
12884	\N	\N	\N	
12885	\N	\N	\N	
12886	\N	\N	\N	
12887	\N	\N	\N	
12888	\N	\N	\N	
12889	\N	\N	\N	
12890	\N	\N	\N	
12891	\N	\N	\N	
12892	\N	\N	\N	
12893	\N	\N	\N	
12894	\N	\N	\N	
12895	\N	\N	\N	
12896	\N	\N	\N	
12897	\N	\N	\N	
12898	\N	\N	\N	
12899	\N	\N	\N	
12900	\N	\N	\N	
12901	\N	\N	\N	
12902	\N	\N	\N	
12903	\N	\N	\N	
12904	\N	\N	\N	
12905	\N	\N	\N	
12906	\N	\N	\N	
12907	\N	\N	\N	
12908	\N	\N	\N	
12909	\N	\N	\N	
12910	\N	\N	\N	
12911	\N	\N	\N	
12912	\N	\N	\N	
12913	\N	\N	\N	
12914	\N	\N	\N	
12915	\N	\N	\N	
12916	\N	\N	\N	
12917	\N	\N	\N	
12918	\N	\N	\N	
12919	\N	\N	\N	
12920	\N	\N	\N	
12921	\N	\N	\N	
12922	\N	\N	\N	
12923	\N	\N	\N	
12924	\N	\N	\N	
12925	\N	\N	\N	
12926	\N	\N	\N	
12927	\N	\N	\N	
12928	\N	\N	\N	
12929	\N	\N	\N	
12930	\N	\N	\N	
12931	\N	\N	\N	
12932	\N	\N	\N	
12933	\N	\N	\N	
12934	\N	\N	\N	
12935	\N	\N	\N	
12936	\N	\N	\N	
12937	\N	\N	\N	
12938	\N	\N	\N	
12939	\N	\N	\N	
12940	\N	\N	\N	
12941	\N	\N	\N	
12942	\N	\N	\N	
12943	\N	\N	\N	
12944	\N	\N	\N	
12945	\N	\N	\N	
12946	\N	\N	\N	
12947	\N	\N	\N	
12948	\N	\N	\N	
12949	\N	\N	\N	
12950	\N	\N	\N	
12951	\N	\N	\N	
12952	\N	\N	\N	
12953	\N	\N	\N	
12954	\N	\N	\N	
12955	\N	\N	\N	
12956	\N	\N	\N	
12957	\N	\N	\N	
12958	\N	\N	\N	
12959	\N	\N	\N	
12960	\N	\N	\N	
12961	\N	\N	\N	
12962	\N	\N	\N	
12963	\N	\N	\N	
12964	\N	\N	\N	
12965	\N	\N	\N	
12966	\N	\N	\N	
12967	\N	\N	\N	
12968	\N	\N	\N	
12969	\N	\N	\N	
12970	\N	\N	\N	
12971	\N	\N	\N	
12972	\N	\N	\N	
12973	\N	\N	\N	
12974	\N	\N	\N	
12975	\N	\N	\N	
12976	\N	\N	\N	
12977	\N	\N	\N	
12978	\N	\N	\N	
12979	\N	\N	\N	
12980	\N	\N	\N	
12981	\N	\N	\N	
12982	\N	\N	\N	
12983	\N	\N	\N	
12984	\N	\N	\N	
12985	\N	\N	\N	
12986	\N	\N	\N	
12987	\N	\N	\N	
12988	\N	\N	\N	
12989	\N	\N	\N	
12990	\N	\N	\N	
12991	\N	\N	\N	
12992	\N	\N	\N	
12993	\N	\N	\N	
12994	\N	\N	\N	
12995	\N	\N	\N	
12996	\N	\N	\N	
12997	\N	\N	\N	
12998	\N	\N	\N	
12999	\N	\N	\N	
13000	\N	\N	\N	
13001	\N	\N	\N	
13002	\N	\N	\N	
13003	\N	\N	\N	
13004	\N	\N	\N	
13005	\N	\N	\N	
13006	\N	\N	\N	
13007	\N	\N	\N	
13008	\N	\N	\N	
13009	\N	\N	\N	
13010	\N	\N	\N	
13011	\N	\N	\N	
13012	\N	\N	\N	
13013	\N	\N	\N	
13014	\N	\N	\N	
13015	\N	\N	\N	
13016	\N	\N	\N	
13017	\N	\N	\N	
13018	\N	\N	\N	
13019	\N	\N	\N	
13020	\N	\N	\N	
13021	\N	\N	\N	
13022	\N	\N	\N	
13023	\N	\N	\N	
13024	\N	\N	\N	
13025	\N	\N	\N	
13026	\N	\N	\N	
13027	\N	\N	\N	
13028	\N	\N	\N	
13029	\N	\N	\N	
13030	\N	\N	\N	
13031	\N	\N	\N	
13032	\N	\N	\N	
13033	\N	\N	\N	
13034	\N	\N	\N	
13035	\N	\N	\N	
13036	\N	\N	\N	
13037	\N	\N	\N	
13038	\N	\N	\N	
13039	\N	\N	\N	
13040	\N	\N	\N	
13041	\N	\N	\N	
13042	\N	\N	\N	
13043	\N	\N	\N	
13044	\N	\N	\N	
13045	\N	\N	\N	
13046	\N	\N	\N	
13047	\N	\N	\N	
13048	\N	\N	\N	
13049	\N	\N	\N	
13050	\N	\N	\N	
13051	\N	\N	\N	
13052	\N	\N	\N	
13053	\N	\N	\N	
13054	\N	\N	\N	
13055	\N	\N	\N	
13056	\N	\N	\N	
13057	\N	\N	\N	
13058	\N	\N	\N	
13059	\N	\N	\N	
13060	\N	\N	\N	
13061	\N	\N	\N	
13062	\N	\N	\N	
13063	\N	\N	\N	
13064	\N	\N	\N	
13065	\N	\N	\N	
13066	\N	\N	\N	
13067	\N	\N	\N	
13068	\N	\N	\N	
13069	\N	\N	\N	
13070	\N	\N	\N	
13071	\N	\N	\N	
13072	\N	\N	\N	
13073	\N	\N	\N	
13074	\N	\N	\N	
13075	\N	\N	\N	
13076	\N	\N	\N	
13077	\N	\N	\N	
13078	\N	\N	\N	
13079	\N	\N	\N	
13080	\N	\N	\N	
13081	\N	\N	\N	
13082	\N	\N	\N	
13083	\N	\N	\N	
13084	\N	\N	\N	
13085	\N	\N	\N	
13086	\N	\N	\N	
13087	\N	\N	\N	
13088	\N	\N	\N	
13089	\N	\N	\N	
13090	\N	\N	\N	
13091	\N	\N	\N	
13092	\N	\N	\N	
13093	\N	\N	\N	
13094	\N	\N	\N	
13095	\N	\N	\N	
13096	\N	\N	\N	
13097	\N	\N	\N	
13098	\N	\N	\N	
13099	\N	\N	\N	
13100	\N	\N	\N	
13101	\N	\N	\N	
13102	\N	\N	\N	
13103	\N	\N	\N	
13104	\N	\N	\N	
13105	\N	\N	\N	
13106	\N	\N	\N	
13107	\N	\N	\N	
13108	\N	\N	\N	
13109	\N	\N	\N	
13110	\N	\N	\N	
13111	\N	\N	\N	
13112	\N	\N	\N	
13113	\N	\N	\N	
13114	\N	\N	\N	
13115	\N	\N	\N	
13116	\N	\N	\N	
13117	\N	\N	\N	
13118	\N	\N	\N	
13119	\N	\N	\N	
13120	\N	\N	\N	
13121	\N	\N	\N	
13122	\N	\N	\N	
13123	\N	\N	\N	
13124	\N	\N	\N	
13125	\N	\N	\N	
13126	\N	\N	\N	
13127	\N	\N	\N	
13128	\N	\N	\N	
13129	\N	\N	\N	
13130	\N	\N	\N	
13131	\N	\N	\N	
13132	\N	\N	\N	
13133	\N	\N	\N	
13134	\N	\N	\N	
13135	\N	\N	\N	
13136	\N	\N	\N	
13137	\N	\N	\N	
13138	\N	\N	\N	
13139	\N	\N	\N	
13140	\N	\N	\N	
13141	\N	\N	\N	
13142	\N	\N	\N	
13143	\N	\N	\N	
13144	\N	\N	\N	
13145	\N	\N	\N	
13146	\N	\N	\N	
13147	\N	\N	\N	
13148	\N	\N	\N	
13149	\N	\N	\N	
13150	\N	\N	\N	
13151	\N	\N	\N	
13152	\N	\N	\N	
13153	\N	\N	\N	
13154	\N	\N	\N	
13155	\N	\N	\N	
13156	\N	\N	\N	
13157	\N	\N	\N	
13158	\N	\N	\N	
13159	\N	\N	\N	
13160	\N	\N	\N	
13161	\N	\N	\N	
13162	\N	\N	\N	
13163	\N	\N	\N	
13164	\N	\N	\N	
13165	\N	\N	\N	
13166	\N	\N	\N	
13167	\N	\N	\N	
13168	\N	\N	\N	
13169	\N	\N	\N	
13170	\N	\N	\N	
13171	\N	\N	\N	
13172	\N	\N	\N	
13173	\N	\N	\N	
13174	\N	\N	\N	
13175	\N	\N	\N	
13176	\N	\N	\N	
13177	\N	\N	\N	
13178	\N	\N	\N	
13179	\N	\N	\N	
13180	\N	\N	\N	
13181	\N	\N	\N	
13182	\N	\N	\N	
13183	\N	\N	\N	
13184	\N	\N	\N	
13185	\N	\N	\N	
13186	\N	\N	\N	
13187	\N	\N	\N	
13188	\N	\N	\N	
13189	\N	\N	\N	
13190	\N	\N	\N	
13191	\N	\N	\N	
13192	\N	\N	\N	
13193	\N	\N	\N	
13194	\N	\N	\N	
13195	\N	\N	\N	
13196	\N	\N	\N	
13197	\N	\N	\N	
13198	\N	\N	\N	
13199	\N	\N	\N	
13200	\N	\N	\N	
13201	\N	\N	\N	
13202	\N	\N	\N	
13203	\N	\N	\N	
13204	\N	\N	\N	
13205	\N	\N	\N	
13206	\N	\N	\N	
13207	\N	\N	\N	
13208	\N	\N	\N	
13209	\N	\N	\N	
13210	\N	\N	\N	
13211	\N	\N	\N	
13212	\N	\N	\N	
13213	\N	\N	\N	
13214	\N	\N	\N	
13215	\N	\N	\N	
13216	\N	\N	\N	
13217	\N	\N	\N	
13218	\N	\N	\N	
13219	\N	\N	\N	
13220	\N	\N	\N	
13221	\N	\N	\N	
13222	\N	\N	\N	
13223	\N	\N	\N	
13224	\N	\N	\N	
13225	\N	\N	\N	
13226	\N	\N	\N	
13227	\N	\N	\N	
13228	\N	\N	\N	
13229	\N	\N	\N	
13230	\N	\N	\N	
13231	\N	\N	\N	
13232	\N	\N	\N	
13233	\N	\N	\N	
13234	\N	\N	\N	
13235	\N	\N	\N	
13236	\N	\N	\N	
13237	\N	\N	\N	
13238	\N	\N	\N	
13239	\N	\N	\N	
13240	\N	\N	\N	
13241	\N	\N	\N	
13242	\N	\N	\N	
13243	\N	\N	\N	
13244	\N	\N	\N	
13245	\N	\N	\N	
13246	\N	\N	\N	
13247	\N	\N	\N	
13248	\N	\N	\N	
13249	\N	\N	\N	
13250	\N	\N	\N	
13251	\N	\N	\N	
13252	\N	\N	\N	
13253	\N	\N	\N	
13254	\N	\N	\N	
13255	\N	\N	\N	
13256	\N	\N	\N	
13257	\N	\N	\N	
13258	\N	\N	\N	
13259	\N	\N	\N	
13260	\N	\N	\N	
13261	\N	\N	\N	
13262	\N	\N	\N	
13263	\N	\N	\N	
13264	\N	\N	\N	
13265	\N	\N	\N	
13266	\N	\N	\N	
13267	\N	\N	\N	
13268	\N	\N	\N	
13269	\N	\N	\N	
13270	\N	\N	\N	
13271	\N	\N	\N	
13272	\N	\N	\N	
13273	\N	\N	\N	
13274	\N	\N	\N	
13275	\N	\N	\N	
13276	\N	\N	\N	
13277	\N	\N	\N	
13278	\N	\N	\N	
13279	\N	\N	\N	
13280	\N	\N	\N	
13281	\N	\N	\N	
13282	\N	\N	\N	
13283	\N	\N	\N	
13284	\N	\N	\N	
13285	\N	\N	\N	
13286	\N	\N	\N	
13287	\N	\N	\N	
13288	\N	\N	\N	
13289	\N	\N	\N	
13290	\N	\N	\N	
13291	\N	\N	\N	
13292	\N	\N	\N	
13293	\N	\N	\N	
13294	\N	\N	\N	
13295	\N	\N	\N	
13296	\N	\N	\N	
13297	\N	\N	\N	
13298	\N	\N	\N	
13299	\N	\N	\N	
13300	\N	\N	\N	
13301	\N	\N	\N	
13302	\N	\N	\N	
13303	\N	\N	\N	
13304	\N	\N	\N	
13305	\N	\N	\N	
13306	\N	\N	\N	
13307	\N	\N	\N	
13308	\N	\N	\N	
13309	\N	\N	\N	
13310	\N	\N	\N	
13311	\N	\N	\N	
13312	\N	\N	\N	
13313	\N	\N	\N	
13314	\N	\N	\N	
13315	\N	\N	\N	
13316	\N	\N	\N	
13317	\N	\N	\N	
13318	\N	\N	\N	
13319	\N	\N	\N	
13320	\N	\N	\N	
13321	\N	\N	\N	
13322	\N	\N	\N	
13323	\N	\N	\N	
13324	\N	\N	\N	
13325	\N	\N	\N	
13326	\N	\N	\N	
13327	\N	\N	\N	
13328	\N	\N	\N	
13329	\N	\N	\N	
13330	\N	\N	\N	
13331	\N	\N	\N	
13332	\N	\N	\N	
13333	\N	\N	\N	
13334	\N	\N	\N	
13335	\N	\N	\N	
13336	\N	\N	\N	
13337	\N	\N	\N	
13338	\N	\N	\N	
13339	\N	\N	\N	
13340	\N	\N	\N	
13341	\N	\N	\N	
13342	\N	\N	\N	
13343	\N	\N	\N	
13344	\N	\N	\N	
13345	\N	\N	\N	
13346	\N	\N	\N	
13347	\N	\N	\N	
13348	\N	\N	\N	
13349	\N	\N	\N	
13350	\N	\N	\N	
13351	\N	\N	\N	
13352	\N	\N	\N	
13353	\N	\N	\N	
13354	\N	\N	\N	
13355	\N	\N	\N	
13356	\N	\N	\N	
13357	\N	\N	\N	
13358	\N	\N	\N	
13359	\N	\N	\N	
13360	\N	\N	\N	
13361	\N	\N	\N	
13362	\N	\N	\N	
13363	\N	\N	\N	
13364	\N	\N	\N	
13365	\N	\N	\N	
13366	\N	\N	\N	
13367	\N	\N	\N	
13368	\N	\N	\N	
13369	\N	\N	\N	
13370	\N	\N	\N	
13371	\N	\N	\N	
13372	\N	\N	\N	
13373	\N	\N	\N	
13374	\N	\N	\N	
13375	\N	\N	\N	
13376	\N	\N	\N	
13377	\N	\N	\N	
13378	\N	\N	\N	
13379	\N	\N	\N	
13380	\N	\N	\N	
13381	\N	\N	\N	
13382	\N	\N	\N	
13383	\N	\N	\N	
13384	\N	\N	\N	
13385	\N	\N	\N	
13386	\N	\N	\N	
13387	\N	\N	\N	
13388	\N	\N	\N	
13389	\N	\N	\N	
13390	\N	\N	\N	
13391	\N	\N	\N	
13392	\N	\N	\N	
13393	\N	\N	\N	
13394	\N	\N	\N	
13395	\N	\N	\N	
13396	\N	\N	\N	
13397	\N	\N	\N	
13398	\N	\N	\N	
13399	\N	\N	\N	
13400	\N	\N	\N	
13401	\N	\N	\N	
13402	\N	\N	\N	
13403	\N	\N	\N	
13404	\N	\N	\N	
13405	\N	\N	\N	
13406	\N	\N	\N	
13407	\N	\N	\N	
13408	\N	\N	\N	
13409	\N	\N	\N	
13410	\N	\N	\N	
13411	\N	\N	\N	
13412	\N	\N	\N	
13413	\N	\N	\N	
13414	\N	\N	\N	
13415	\N	\N	\N	
13416	\N	\N	\N	
13417	\N	\N	\N	
13418	\N	\N	\N	
13419	\N	\N	\N	
13420	\N	\N	\N	
13421	\N	\N	\N	
13422	\N	\N	\N	
13423	\N	\N	\N	
13424	\N	\N	\N	
13425	\N	\N	\N	
13426	\N	\N	\N	
13427	\N	\N	\N	
13428	\N	\N	\N	
13429	\N	\N	\N	
13430	\N	\N	\N	
13431	\N	\N	\N	
13432	\N	\N	\N	
13433	\N	\N	\N	
13434	\N	\N	\N	
13435	\N	\N	\N	
13436	\N	\N	\N	
13437	\N	\N	\N	
13438	\N	\N	\N	
13439	\N	\N	\N	
13440	\N	\N	\N	
13441	\N	\N	\N	
13442	\N	\N	\N	
13443	\N	\N	\N	
13444	\N	\N	\N	
13445	\N	\N	\N	
13446	\N	\N	\N	
13447	\N	\N	\N	
13448	\N	\N	\N	
13449	\N	\N	\N	
13450	\N	\N	\N	
13451	\N	\N	\N	
13452	\N	\N	\N	
13453	\N	\N	\N	
13454	\N	\N	\N	
13455	\N	\N	\N	
13456	\N	\N	\N	
13457	\N	\N	\N	
13458	\N	\N	\N	
13459	\N	\N	\N	
13460	\N	\N	\N	
13461	\N	\N	\N	
13462	\N	\N	\N	
13463	\N	\N	\N	
13464	\N	\N	\N	
13465	\N	\N	\N	
13466	\N	\N	\N	
13467	\N	\N	\N	
13468	\N	\N	\N	
13469	\N	\N	\N	
13470	\N	\N	\N	
13471	\N	\N	\N	
13472	\N	\N	\N	
13473	\N	\N	\N	
13474	\N	\N	\N	
13475	\N	\N	\N	
13476	\N	\N	\N	
13477	\N	\N	\N	
13478	\N	\N	\N	
13479	\N	\N	\N	
13480	\N	\N	\N	
13481	\N	\N	\N	
13482	\N	\N	\N	
13483	\N	\N	\N	
13484	\N	\N	\N	
13485	\N	\N	\N	
13486	\N	\N	\N	
13487	\N	\N	\N	
13488	\N	\N	\N	
13489	\N	\N	\N	
13490	\N	\N	\N	
13491	\N	\N	\N	
13492	\N	\N	\N	
13493	\N	\N	\N	
13494	\N	\N	\N	
13495	\N	\N	\N	
13496	\N	\N	\N	
13497	\N	\N	\N	
13498	\N	\N	\N	
13499	\N	\N	\N	
13500	\N	\N	\N	
13501	\N	\N	\N	
13502	\N	\N	\N	
13503	\N	\N	\N	
13504	\N	\N	\N	
13505	\N	\N	\N	
13506	\N	\N	\N	
13507	\N	\N	\N	
13508	\N	\N	\N	
13509	\N	\N	\N	
13510	\N	\N	\N	
13511	\N	\N	\N	
13512	\N	\N	\N	
13513	\N	\N	\N	
13514	\N	\N	\N	
13515	\N	\N	\N	
13516	\N	\N	\N	
13517	\N	\N	\N	
13518	\N	\N	\N	
13519	\N	\N	\N	
13520	\N	\N	\N	
13521	\N	\N	\N	
13522	\N	\N	\N	
13523	\N	\N	\N	
13524	\N	\N	\N	
13525	\N	\N	\N	
13526	\N	\N	\N	
13527	\N	\N	\N	
13528	\N	\N	\N	
13529	\N	\N	\N	
13530	\N	\N	\N	
13531	\N	\N	\N	
13532	\N	\N	\N	
13533	\N	\N	\N	
13534	\N	\N	\N	
13535	\N	\N	\N	
13536	\N	\N	\N	
13537	\N	\N	\N	
13538	\N	\N	\N	
13539	\N	\N	\N	
13540	\N	\N	\N	
13541	\N	\N	\N	
13542	\N	\N	\N	
13543	\N	\N	\N	
13544	\N	\N	\N	
13545	\N	\N	\N	
13546	\N	\N	\N	
13547	\N	\N	\N	
13548	\N	\N	\N	
13549	\N	\N	\N	
13550	\N	\N	\N	
13551	\N	\N	\N	
13552	\N	\N	\N	
13553	\N	\N	\N	
13554	\N	\N	\N	
13555	\N	\N	\N	
13556	\N	\N	\N	
13557	\N	\N	\N	
13558	\N	\N	\N	
13559	\N	\N	\N	
13560	\N	\N	\N	
13561	\N	\N	\N	
13562	\N	\N	\N	
13563	\N	\N	\N	
13564	\N	\N	\N	
13565	\N	\N	\N	
13566	\N	\N	\N	
13567	\N	\N	\N	
13568	\N	\N	\N	
13569	\N	\N	\N	
13570	\N	\N	\N	
13571	\N	\N	\N	
13572	\N	\N	\N	
13573	\N	\N	\N	
13574	\N	\N	\N	
13575	\N	\N	\N	
13576	\N	\N	\N	
13577	\N	\N	\N	
13578	\N	\N	\N	
13579	\N	\N	\N	
13580	\N	\N	\N	
13581	\N	\N	\N	
13582	\N	\N	\N	
13583	\N	\N	\N	
13584	\N	\N	\N	
13585	\N	\N	\N	
13586	\N	\N	\N	
13587	\N	\N	\N	
13588	\N	\N	\N	
13589	\N	\N	\N	
13590	\N	\N	\N	
13591	\N	\N	\N	
13592	\N	\N	\N	
13593	\N	\N	\N	
13594	\N	\N	\N	
13595	\N	\N	\N	
13596	\N	\N	\N	
13597	\N	\N	\N	
13598	\N	\N	\N	
13599	\N	\N	\N	
13600	\N	\N	\N	
13601	\N	\N	\N	
13602	\N	\N	\N	
13603	\N	\N	\N	
13604	\N	\N	\N	
13605	\N	\N	\N	
13606	\N	\N	\N	
13607	\N	\N	\N	
13608	\N	\N	\N	
13609	\N	\N	\N	
13610	\N	\N	\N	
13611	\N	\N	\N	
13612	\N	\N	\N	
13613	\N	\N	\N	
13614	\N	\N	\N	
13615	\N	\N	\N	
13616	\N	\N	\N	
13617	\N	\N	\N	
13618	\N	\N	\N	
13619	\N	\N	\N	
13620	\N	\N	\N	
13621	\N	\N	\N	
13622	\N	\N	\N	
13623	\N	\N	\N	
13624	\N	\N	\N	
13625	\N	\N	\N	
13626	\N	\N	\N	
13627	\N	\N	\N	
13628	\N	\N	\N	
13629	\N	\N	\N	
13630	\N	\N	\N	
13631	\N	\N	\N	
13632	\N	\N	\N	
13633	\N	\N	\N	
13634	\N	\N	\N	
13635	\N	\N	\N	
13636	\N	\N	\N	
13637	\N	\N	\N	
13638	\N	\N	\N	
13639	\N	\N	\N	
13640	\N	\N	\N	
13641	\N	\N	\N	
13642	\N	\N	\N	
13643	\N	\N	\N	
13644	\N	\N	\N	
13645	\N	\N	\N	
13646	\N	\N	\N	
13647	\N	\N	\N	
13648	\N	\N	\N	
13649	\N	\N	\N	
13650	\N	\N	\N	
13651	\N	\N	\N	
13652	\N	\N	\N	
13653	\N	\N	\N	
13654	\N	\N	\N	
13655	\N	\N	\N	
13656	\N	\N	\N	
13657	\N	\N	\N	
13658	\N	\N	\N	
13659	\N	\N	\N	
13660	\N	\N	\N	
13661	\N	\N	\N	
13662	\N	\N	\N	
13663	\N	\N	\N	
13664	\N	\N	\N	
13665	\N	\N	\N	
13666	\N	\N	\N	
13667	\N	\N	\N	
13668	\N	\N	\N	
13669	\N	\N	\N	
13670	\N	\N	\N	
13671	\N	\N	\N	
13672	\N	\N	\N	
13673	\N	\N	\N	
13674	\N	\N	\N	
13675	\N	\N	\N	
13676	\N	\N	\N	
13677	\N	\N	\N	
13678	\N	\N	\N	
13679	\N	\N	\N	
13680	\N	\N	\N	
13681	\N	\N	\N	
13682	\N	\N	\N	
13683	\N	\N	\N	
13684	\N	\N	\N	
13685	\N	\N	\N	
13686	\N	\N	\N	
13687	\N	\N	\N	
13688	\N	\N	\N	
13689	\N	\N	\N	
13690	\N	\N	\N	
13691	\N	\N	\N	
13692	\N	\N	\N	
13693	\N	\N	\N	
13694	\N	\N	\N	
13695	\N	\N	\N	
13696	\N	\N	\N	
13697	\N	\N	\N	
13698	\N	\N	\N	
13699	\N	\N	\N	
13700	\N	\N	\N	
13701	\N	\N	\N	
13702	\N	\N	\N	
13703	\N	\N	\N	
13704	\N	\N	\N	
13705	\N	\N	\N	
13706	\N	\N	\N	
13707	\N	\N	\N	
13708	\N	\N	\N	
13709	\N	\N	\N	
13710	\N	\N	\N	
13711	\N	\N	\N	
13712	\N	\N	\N	
13713	\N	\N	\N	
13714	\N	\N	\N	
13715	\N	\N	\N	
13716	\N	\N	\N	
13717	\N	\N	\N	
13718	\N	\N	\N	
13719	\N	\N	\N	
13720	\N	\N	\N	
13721	\N	\N	\N	
13722	\N	\N	\N	
13723	\N	\N	\N	
13724	\N	\N	\N	
13725	\N	\N	\N	
13726	\N	\N	\N	
13727	\N	\N	\N	
13728	\N	\N	\N	
13729	\N	\N	\N	
13730	\N	\N	\N	
13731	\N	\N	\N	
13732	\N	\N	\N	
13733	\N	\N	\N	
13734	\N	\N	\N	
13735	\N	\N	\N	
13736	\N	\N	\N	
13737	\N	\N	\N	
13738	\N	\N	\N	
13739	\N	\N	\N	
13740	\N	\N	\N	
13741	\N	\N	\N	
13742	\N	\N	\N	
13743	\N	\N	\N	
13744	\N	\N	\N	
13745	\N	\N	\N	
13746	\N	\N	\N	
13747	\N	\N	\N	
13748	\N	\N	\N	
13749	\N	\N	\N	
13750	\N	\N	\N	
13751	\N	\N	\N	
13752	\N	\N	\N	
13753	\N	\N	\N	
13754	\N	\N	\N	
13755	\N	\N	\N	
13756	\N	\N	\N	
13757	\N	\N	\N	
13758	\N	\N	\N	
13759	\N	\N	\N	
13760	\N	\N	\N	
13761	\N	\N	\N	
13762	\N	\N	\N	
13763	\N	\N	\N	
13764	\N	\N	\N	
13765	\N	\N	\N	
13766	\N	\N	\N	
13767	\N	\N	\N	
13768	\N	\N	\N	
13769	\N	\N	\N	
13770	\N	\N	\N	
13771	\N	\N	\N	
13772	\N	\N	\N	
13773	\N	\N	\N	
13774	\N	\N	\N	
13775	\N	\N	\N	
13776	\N	\N	\N	
13777	\N	\N	\N	
13778	\N	\N	\N	
13779	\N	\N	\N	
13780	\N	\N	\N	
13781	\N	\N	\N	
13782	\N	\N	\N	
13783	\N	\N	\N	
13784	\N	\N	\N	
13785	\N	\N	\N	
13786	\N	\N	\N	
13787	\N	\N	\N	
13788	\N	\N	\N	
13789	\N	\N	\N	
13790	\N	\N	\N	
13791	\N	\N	\N	
13792	\N	\N	\N	
13793	\N	\N	\N	
13794	\N	\N	\N	
13795	\N	\N	\N	
13796	\N	\N	\N	
13797	\N	\N	\N	
13798	\N	\N	\N	
13799	\N	\N	\N	
13800	\N	\N	\N	
13801	\N	\N	\N	
13802	\N	\N	\N	
13803	\N	\N	\N	
13804	\N	\N	\N	
13805	\N	\N	\N	
13806	\N	\N	\N	
13807	\N	\N	\N	
13808	\N	\N	\N	
13809	\N	\N	\N	
13810	\N	\N	\N	
13811	\N	\N	\N	
13812	\N	\N	\N	
13813	\N	\N	\N	
13814	\N	\N	\N	
13815	\N	\N	\N	
13816	\N	\N	\N	
13817	\N	\N	\N	
13818	\N	\N	\N	
13819	\N	\N	\N	
13820	\N	\N	\N	
13821	\N	\N	\N	
13822	\N	\N	\N	
13823	\N	\N	\N	
13824	\N	\N	\N	
13825	\N	\N	\N	
13826	\N	\N	\N	
13827	\N	\N	\N	
13828	\N	\N	\N	
13829	\N	\N	\N	
13830	\N	\N	\N	
13831	\N	\N	\N	
13832	\N	\N	\N	
13833	\N	\N	\N	
13834	\N	\N	\N	
13835	\N	\N	\N	
13836	\N	\N	\N	
13837	\N	\N	\N	
13838	\N	\N	\N	
13839	\N	\N	\N	
13840	\N	\N	\N	
13841	\N	\N	\N	
13842	\N	\N	\N	
13843	\N	\N	\N	
13844	\N	\N	\N	
13845	\N	\N	\N	
13846	\N	\N	\N	
13847	\N	\N	\N	
13848	\N	\N	\N	
13849	\N	\N	\N	
13850	\N	\N	\N	
13851	\N	\N	\N	
13852	\N	\N	\N	
13853	\N	\N	\N	
13854	\N	\N	\N	
13855	\N	\N	\N	
13856	\N	\N	\N	
13857	\N	\N	\N	
13858	\N	\N	\N	
13859	\N	\N	\N	
13860	\N	\N	\N	
13861	\N	\N	\N	
13862	\N	\N	\N	
13863	\N	\N	\N	
13864	\N	\N	\N	
13865	\N	\N	\N	
13866	\N	\N	\N	
13867	\N	\N	\N	
13868	\N	\N	\N	
13869	\N	\N	\N	
13870	\N	\N	\N	
13871	\N	\N	\N	
13872	\N	\N	\N	
13873	\N	\N	\N	
13874	\N	\N	\N	
13875	\N	\N	\N	
13876	\N	\N	\N	
13877	\N	\N	\N	
13878	\N	\N	\N	
13879	\N	\N	\N	
13880	\N	\N	\N	
13881	\N	\N	\N	
13882	\N	\N	\N	
13883	\N	\N	\N	
13884	\N	\N	\N	
13885	\N	\N	\N	
13886	\N	\N	\N	
13887	\N	\N	\N	
13888	\N	\N	\N	
13889	\N	\N	\N	
13890	\N	\N	\N	
13891	\N	\N	\N	
13892	\N	\N	\N	
13893	\N	\N	\N	
13894	\N	\N	\N	
13895	\N	\N	\N	
13896	\N	\N	\N	
13897	\N	\N	\N	
13898	\N	\N	\N	
13899	\N	\N	\N	
13900	\N	\N	\N	
13901	\N	\N	\N	
13902	\N	\N	\N	
13903	\N	\N	\N	
13904	\N	\N	\N	
13905	\N	\N	\N	
13906	\N	\N	\N	
13907	\N	\N	\N	
13908	\N	\N	\N	
13909	\N	\N	\N	
13910	\N	\N	\N	
13911	\N	\N	\N	
13912	\N	\N	\N	
13913	\N	\N	\N	
13914	\N	\N	\N	
13915	\N	\N	\N	
13916	\N	\N	\N	
13917	\N	\N	\N	
13918	\N	\N	\N	
13919	\N	\N	\N	
13920	\N	\N	\N	
13921	\N	\N	\N	
13922	\N	\N	\N	
13923	\N	\N	\N	
13924	\N	\N	\N	
13925	\N	\N	\N	
13926	\N	\N	\N	
13927	\N	\N	\N	
13928	\N	\N	\N	
13929	\N	\N	\N	
13930	\N	\N	\N	
13931	\N	\N	\N	
13932	\N	\N	\N	
13933	\N	\N	\N	
13934	\N	\N	\N	
13935	\N	\N	\N	
13936	\N	\N	\N	
13937	\N	\N	\N	
13938	\N	\N	\N	
13939	\N	\N	\N	
13940	\N	\N	\N	
13941	\N	\N	\N	
13942	\N	\N	\N	
13943	\N	\N	\N	
13944	\N	\N	\N	
13945	\N	\N	\N	
13946	\N	\N	\N	
13947	\N	\N	\N	
13948	\N	\N	\N	
13949	\N	\N	\N	
13950	\N	\N	\N	
13951	\N	\N	\N	
13952	\N	\N	\N	
13953	\N	\N	\N	
13954	\N	\N	\N	
13955	\N	\N	\N	
13956	\N	\N	\N	
13957	\N	\N	\N	
13958	\N	\N	\N	
13959	\N	\N	\N	
13960	\N	\N	\N	
13961	\N	\N	\N	
13962	\N	\N	\N	
13963	\N	\N	\N	
13964	\N	\N	\N	
13965	\N	\N	\N	
13966	\N	\N	\N	
13967	\N	\N	\N	
13968	\N	\N	\N	
13969	\N	\N	\N	
13970	\N	\N	\N	
13971	\N	\N	\N	
13972	\N	\N	\N	
13973	\N	\N	\N	
13974	\N	\N	\N	
13975	\N	\N	\N	
13976	\N	\N	\N	
13977	\N	\N	\N	
13978	\N	\N	\N	
13979	\N	\N	\N	
13980	\N	\N	\N	
13981	\N	\N	\N	
13982	\N	\N	\N	
13983	\N	\N	\N	
13984	\N	\N	\N	
13985	\N	\N	\N	
13986	\N	\N	\N	
13987	\N	\N	\N	
13988	\N	\N	\N	
13989	\N	\N	\N	
13990	\N	\N	\N	
13991	\N	\N	\N	
13992	\N	\N	\N	
13993	\N	\N	\N	
13994	\N	\N	\N	
13995	\N	\N	\N	
13996	\N	\N	\N	
13997	\N	\N	\N	
13998	\N	\N	\N	
13999	\N	\N	\N	
14000	\N	\N	\N	
14001	\N	\N	\N	
14002	\N	\N	\N	
14003	\N	\N	\N	
14004	\N	\N	\N	
14005	\N	\N	\N	
14006	\N	\N	\N	
14007	\N	\N	\N	
14008	\N	\N	\N	
14009	\N	\N	\N	
14010	\N	\N	\N	
14011	\N	\N	\N	
14012	\N	\N	\N	
14013	\N	\N	\N	
14014	\N	\N	\N	
14015	\N	\N	\N	
14016	\N	\N	\N	
14017	\N	\N	\N	
14018	\N	\N	\N	
14019	\N	\N	\N	
14020	\N	\N	\N	
14021	\N	\N	\N	
14022	\N	\N	\N	
14023	\N	\N	\N	
14024	\N	\N	\N	
14025	\N	\N	\N	
14026	\N	\N	\N	
14027	\N	\N	\N	
14028	\N	\N	\N	
14029	\N	\N	\N	
14030	\N	\N	\N	
14031	\N	\N	\N	
14032	\N	\N	\N	
14033	\N	\N	\N	
14034	\N	\N	\N	
14035	\N	\N	\N	
14036	\N	\N	\N	
14037	\N	\N	\N	
14038	\N	\N	\N	
14039	\N	\N	\N	
14040	\N	\N	\N	
14041	\N	\N	\N	
14042	\N	\N	\N	
14043	\N	\N	\N	
14044	\N	\N	\N	
14045	\N	\N	\N	
14046	\N	\N	\N	
14047	\N	\N	\N	
14048	\N	\N	\N	
14049	\N	\N	\N	
14050	\N	\N	\N	
14051	\N	\N	\N	
14052	\N	\N	\N	
14053	\N	\N	\N	
14054	\N	\N	\N	
14055	\N	\N	\N	
14056	\N	\N	\N	
14057	\N	\N	\N	
14058	\N	\N	\N	
14059	\N	\N	\N	
14060	\N	\N	\N	
14061	\N	\N	\N	
14062	\N	\N	\N	
14063	\N	\N	\N	
14064	\N	\N	\N	
14065	\N	\N	\N	
14066	\N	\N	\N	
14067	\N	\N	\N	
14068	\N	\N	\N	
14069	\N	\N	\N	
14070	\N	\N	\N	
14071	\N	\N	\N	
14072	\N	\N	\N	
14073	\N	\N	\N	
14074	\N	\N	\N	
14075	\N	\N	\N	
14076	\N	\N	\N	
14077	\N	\N	\N	
14078	\N	\N	\N	
14079	\N	\N	\N	
14080	\N	\N	\N	
14081	\N	\N	\N	
14082	\N	\N	\N	
14083	\N	\N	\N	
14084	\N	\N	\N	
14085	\N	\N	\N	
14086	\N	\N	\N	
14087	\N	\N	\N	
14088	\N	\N	\N	
14089	\N	\N	\N	
14090	\N	\N	\N	
14091	\N	\N	\N	
14092	\N	\N	\N	
14093	\N	\N	\N	
14094	\N	\N	\N	
14095	\N	\N	\N	
14096	\N	\N	\N	
14097	\N	\N	\N	
14098	\N	\N	\N	
14099	\N	\N	\N	
14100	\N	\N	\N	
14101	\N	\N	\N	
14102	\N	\N	\N	
14103	\N	\N	\N	
14104	\N	\N	\N	
14105	\N	\N	\N	
14106	\N	\N	\N	
14107	\N	\N	\N	
14108	\N	\N	\N	
14109	\N	\N	\N	
14110	\N	\N	\N	
14111	\N	\N	\N	
14112	\N	\N	\N	
14113	\N	\N	\N	
14114	\N	\N	\N	
14115	\N	\N	\N	
14116	\N	\N	\N	
14117	\N	\N	\N	
14118	\N	\N	\N	
14119	\N	\N	\N	
14120	\N	\N	\N	
14121	\N	\N	\N	
14122	\N	\N	\N	
14123	\N	\N	\N	
14124	\N	\N	\N	
14125	\N	\N	\N	
14126	\N	\N	\N	
14127	\N	\N	\N	
14128	\N	\N	\N	
14129	\N	\N	\N	
14130	\N	\N	\N	
14131	\N	\N	\N	
14132	\N	\N	\N	
14133	\N	\N	\N	
14134	\N	\N	\N	
14135	\N	\N	\N	
14136	\N	\N	\N	
14137	\N	\N	\N	
14138	\N	\N	\N	
14139	\N	\N	\N	
14140	\N	\N	\N	
14141	\N	\N	\N	
14142	\N	\N	\N	
14143	\N	\N	\N	
14144	\N	\N	\N	
14145	\N	\N	\N	
14146	\N	\N	\N	
14147	\N	\N	\N	
14148	\N	\N	\N	
14149	\N	\N	\N	
14150	\N	\N	\N	
14151	\N	\N	\N	
14152	\N	\N	\N	
14153	\N	\N	\N	
14154	\N	\N	\N	
14155	\N	\N	\N	
14156	\N	\N	\N	
14157	\N	\N	\N	
14158	\N	\N	\N	
14159	\N	\N	\N	
14160	\N	\N	\N	
14161	\N	\N	\N	
14162	\N	\N	\N	
14163	\N	\N	\N	
14164	\N	\N	\N	
14165	\N	\N	\N	
14166	\N	\N	\N	
14167	\N	\N	\N	
14168	\N	\N	\N	
14169	\N	\N	\N	
14170	\N	\N	\N	
14171	\N	\N	\N	
14172	\N	\N	\N	
14173	\N	\N	\N	
14174	\N	\N	\N	
14175	\N	\N	\N	
14176	\N	\N	\N	
14177	\N	\N	\N	
14178	\N	\N	\N	
14179	\N	\N	\N	
14180	\N	\N	\N	
14181	\N	\N	\N	
14182	\N	\N	\N	
14183	\N	\N	\N	
14184	\N	\N	\N	
14185	\N	\N	\N	
14186	\N	\N	\N	
14187	\N	\N	\N	
14188	\N	\N	\N	
14189	\N	\N	\N	
14190	\N	\N	\N	
14191	\N	\N	\N	
14192	\N	\N	\N	
14193	\N	\N	\N	
14194	\N	\N	\N	
14195	\N	\N	\N	
14196	\N	\N	\N	
14197	\N	\N	\N	
14198	\N	\N	\N	
14199	\N	\N	\N	
14200	\N	\N	\N	
14201	\N	\N	\N	
14202	\N	\N	\N	
14203	\N	\N	\N	
14204	\N	\N	\N	
14205	\N	\N	\N	
14206	\N	\N	\N	
14207	\N	\N	\N	
14208	\N	\N	\N	
14209	\N	\N	\N	
14210	\N	\N	\N	
14211	\N	\N	\N	
14212	\N	\N	\N	
14213	\N	\N	\N	
14214	\N	\N	\N	
14215	\N	\N	\N	
14216	\N	\N	\N	
14217	\N	\N	\N	
14218	\N	\N	\N	
14219	\N	\N	\N	
14220	\N	\N	\N	
14221	\N	\N	\N	
14222	\N	\N	\N	
14223	\N	\N	\N	
14224	\N	\N	\N	
14225	\N	\N	\N	
14226	\N	\N	\N	
14227	\N	\N	\N	
14228	\N	\N	\N	
14229	\N	\N	\N	
14230	\N	\N	\N	
14231	\N	\N	\N	
14232	\N	\N	\N	
14233	\N	\N	\N	
14234	\N	\N	\N	
14235	\N	\N	\N	
14236	\N	\N	\N	
14237	\N	\N	\N	
14238	\N	\N	\N	
14239	\N	\N	\N	
14240	\N	\N	\N	
14241	\N	\N	\N	
14242	\N	\N	\N	
14243	\N	\N	\N	
14244	\N	\N	\N	
14245	\N	\N	\N	
14246	\N	\N	\N	
14247	\N	\N	\N	
14248	\N	\N	\N	
14249	\N	\N	\N	
14250	\N	\N	\N	
14251	\N	\N	\N	
14252	\N	\N	\N	
14253	\N	\N	\N	
14254	\N	\N	\N	
14255	\N	\N	\N	
14256	\N	\N	\N	
14257	\N	\N	\N	
14258	\N	\N	\N	
14259	\N	\N	\N	
14260	\N	\N	\N	
14261	\N	\N	\N	
14262	\N	\N	\N	
14263	\N	\N	\N	
14264	\N	\N	\N	
14265	\N	\N	\N	
14266	\N	\N	\N	
14267	\N	\N	\N	
14268	\N	\N	\N	
14269	\N	\N	\N	
14270	\N	\N	\N	
14271	\N	\N	\N	
14272	\N	\N	\N	
14273	\N	\N	\N	
14274	\N	\N	\N	
14275	\N	\N	\N	
14276	\N	\N	\N	
14277	\N	\N	\N	
14278	\N	\N	\N	
14279	\N	\N	\N	
14280	\N	\N	\N	
14281	\N	\N	\N	
14282	\N	\N	\N	
14283	\N	\N	\N	
14284	\N	\N	\N	
14285	\N	\N	\N	
14286	\N	\N	\N	
14287	\N	\N	\N	
14288	\N	\N	\N	
14289	\N	\N	\N	
14290	\N	\N	\N	
14291	\N	\N	\N	
14292	\N	\N	\N	
14293	\N	\N	\N	
14294	\N	\N	\N	
14295	\N	\N	\N	
14296	\N	\N	\N	
14297	\N	\N	\N	
14298	\N	\N	\N	
14299	\N	\N	\N	
14300	\N	\N	\N	
14301	\N	\N	\N	
14302	\N	\N	\N	
14303	\N	\N	\N	
14304	\N	\N	\N	
14305	\N	\N	\N	
14306	\N	\N	\N	
14307	\N	\N	\N	
14308	\N	\N	\N	
14309	\N	\N	\N	
14310	\N	\N	\N	
14311	\N	\N	\N	
14312	\N	\N	\N	
14313	\N	\N	\N	
14314	\N	\N	\N	
14315	\N	\N	\N	
14316	\N	\N	\N	
14317	\N	\N	\N	
14318	\N	\N	\N	
14319	\N	\N	\N	
14320	\N	\N	\N	
14321	\N	\N	\N	
14322	\N	\N	\N	
14323	\N	\N	\N	
14324	\N	\N	\N	
14325	\N	\N	\N	
14326	\N	\N	\N	
14327	\N	\N	\N	
14328	\N	\N	\N	
14329	\N	\N	\N	
14330	\N	\N	\N	
14331	\N	\N	\N	
14332	\N	\N	\N	
14333	\N	\N	\N	
14334	\N	\N	\N	
14335	\N	\N	\N	
14336	\N	\N	\N	
14337	\N	\N	\N	
14338	\N	\N	\N	
14339	\N	\N	\N	
14340	\N	\N	\N	
14341	\N	\N	\N	
14342	\N	\N	\N	
14343	\N	\N	\N	
14344	\N	\N	\N	
14345	\N	\N	\N	
14346	\N	\N	\N	
14347	\N	\N	\N	
14348	\N	\N	\N	
14349	\N	\N	\N	
14350	\N	\N	\N	
14351	\N	\N	\N	
14352	\N	\N	\N	
14353	\N	\N	\N	
14354	\N	\N	\N	
14355	\N	\N	\N	
14356	\N	\N	\N	
14357	\N	\N	\N	
14358	\N	\N	\N	
14359	\N	\N	\N	
14360	\N	\N	\N	
14361	\N	\N	\N	
14362	\N	\N	\N	
14363	\N	\N	\N	
14364	\N	\N	\N	
14365	\N	\N	\N	
14366	\N	\N	\N	
14367	\N	\N	\N	
14368	\N	\N	\N	
14369	\N	\N	\N	
14370	\N	\N	\N	
14371	\N	\N	\N	
14372	\N	\N	\N	
14373	\N	\N	\N	
14374	\N	\N	\N	
14375	\N	\N	\N	
14376	\N	\N	\N	
14377	\N	\N	\N	
14378	\N	\N	\N	
14379	\N	\N	\N	
14380	\N	\N	\N	
14381	\N	\N	\N	
14382	\N	\N	\N	
14383	\N	\N	\N	
14384	\N	\N	\N	
14385	\N	\N	\N	
14386	\N	\N	\N	
14387	\N	\N	\N	
14388	\N	\N	\N	
14389	\N	\N	\N	
14390	\N	\N	\N	
14391	\N	\N	\N	
14392	\N	\N	\N	
14393	\N	\N	\N	
14394	\N	\N	\N	
14395	\N	\N	\N	
14396	\N	\N	\N	
14397	\N	\N	\N	
14398	\N	\N	\N	
14399	\N	\N	\N	
14400	\N	\N	\N	
14401	\N	\N	\N	
14402	\N	\N	\N	
14403	\N	\N	\N	
14404	\N	\N	\N	
14405	\N	\N	\N	
14406	\N	\N	\N	
14407	\N	\N	\N	
14408	\N	\N	\N	
14409	\N	\N	\N	
14410	\N	\N	\N	
14411	\N	\N	\N	
14412	\N	\N	\N	
14413	\N	\N	\N	
14414	\N	\N	\N	
14415	\N	\N	\N	
14416	\N	\N	\N	
14417	\N	\N	\N	
14418	\N	\N	\N	
14419	\N	\N	\N	
14420	\N	\N	\N	
14421	\N	\N	\N	
14422	\N	\N	\N	
14423	\N	\N	\N	
14424	\N	\N	\N	
14425	\N	\N	\N	
14426	\N	\N	\N	
14427	\N	\N	\N	
14428	\N	\N	\N	
14429	\N	\N	\N	
14430	\N	\N	\N	
14431	\N	\N	\N	
14432	\N	\N	\N	
14433	\N	\N	\N	
14434	\N	\N	\N	
14435	\N	\N	\N	
14436	\N	\N	\N	
14437	\N	\N	\N	
14438	\N	\N	\N	
14439	\N	\N	\N	
14440	\N	\N	\N	
14441	\N	\N	\N	
14442	\N	\N	\N	
14443	\N	\N	\N	
14444	\N	\N	\N	
14445	\N	\N	\N	
14446	\N	\N	\N	
14447	\N	\N	\N	
14448	\N	\N	\N	
14449	\N	\N	\N	
14450	\N	\N	\N	
14451	\N	\N	\N	
14452	\N	\N	\N	
14453	\N	\N	\N	
14454	\N	\N	\N	
14455	\N	\N	\N	
14456	\N	\N	\N	
14457	\N	\N	\N	
14458	\N	\N	\N	
14459	\N	\N	\N	
14460	\N	\N	\N	
14461	\N	\N	\N	
14462	\N	\N	\N	
14463	\N	\N	\N	
14464	\N	\N	\N	
14465	\N	\N	\N	
14466	\N	\N	\N	
14467	\N	\N	\N	
14468	\N	\N	\N	
14469	\N	\N	\N	
14470	\N	\N	\N	
14471	\N	\N	\N	
14472	\N	\N	\N	
14473	\N	\N	\N	
14474	\N	\N	\N	
14475	\N	\N	\N	
14476	\N	\N	\N	
14477	\N	\N	\N	
14478	\N	\N	\N	
14479	\N	\N	\N	
14480	\N	\N	\N	
14481	\N	\N	\N	
14482	\N	\N	\N	
14483	\N	\N	\N	
14484	\N	\N	\N	
14485	\N	\N	\N	
14486	\N	\N	\N	
14487	\N	\N	\N	
14488	\N	\N	\N	
14489	\N	\N	\N	
14490	\N	\N	\N	
14491	\N	\N	\N	
14492	\N	\N	\N	
14493	\N	\N	\N	
14494	\N	\N	\N	
14495	\N	\N	\N	
14496	\N	\N	\N	
14497	\N	\N	\N	
14498	\N	\N	\N	
14499	\N	\N	\N	
14500	\N	\N	\N	
14501	\N	\N	\N	
14502	\N	\N	\N	
14503	\N	\N	\N	
14504	\N	\N	\N	
14505	\N	\N	\N	
14506	\N	\N	\N	
14507	\N	\N	\N	
14508	\N	\N	\N	
14509	\N	\N	\N	
14510	\N	\N	\N	
14511	\N	\N	\N	
14512	\N	\N	\N	
14513	\N	\N	\N	
14514	\N	\N	\N	
14515	\N	\N	\N	
14516	\N	\N	\N	
14517	\N	\N	\N	
14518	\N	\N	\N	
14519	\N	\N	\N	
14520	\N	\N	\N	
14521	\N	\N	\N	
14522	\N	\N	\N	
14523	\N	\N	\N	
14524	\N	\N	\N	
14525	\N	\N	\N	
14526	\N	\N	\N	
14527	\N	\N	\N	
14528	\N	\N	\N	
14529	\N	\N	\N	
14530	\N	\N	\N	
14531	\N	\N	\N	
14532	\N	\N	\N	
14533	\N	\N	\N	
14534	\N	\N	\N	
14535	\N	\N	\N	
14536	\N	\N	\N	
14537	\N	\N	\N	
14538	\N	\N	\N	
14539	\N	\N	\N	
14540	\N	\N	\N	
14541	\N	\N	\N	
14542	\N	\N	\N	
14543	\N	\N	\N	
14544	\N	\N	\N	
14545	\N	\N	\N	
14546	\N	\N	\N	
14547	\N	\N	\N	
14548	\N	\N	\N	
14549	\N	\N	\N	
14550	\N	\N	\N	
14551	\N	\N	\N	
14552	\N	\N	\N	
14553	\N	\N	\N	
14554	\N	\N	\N	
14555	\N	\N	\N	
14556	\N	\N	\N	
14557	\N	\N	\N	
14558	\N	\N	\N	
14559	\N	\N	\N	
14560	\N	\N	\N	
14561	\N	\N	\N	
14562	\N	\N	\N	
14563	\N	\N	\N	
14564	\N	\N	\N	
14565	\N	\N	\N	
14566	\N	\N	\N	
14567	\N	\N	\N	
14568	\N	\N	\N	
14569	\N	\N	\N	
14570	\N	\N	\N	
14571	\N	\N	\N	
14572	\N	\N	\N	
14573	\N	\N	\N	
14574	\N	\N	\N	
14575	\N	\N	\N	
14576	\N	\N	\N	
14577	\N	\N	\N	
14578	\N	\N	\N	
14579	\N	\N	\N	
14580	\N	\N	\N	
14581	\N	\N	\N	
14582	\N	\N	\N	
14583	\N	\N	\N	
14584	\N	\N	\N	
14585	\N	\N	\N	
14586	\N	\N	\N	
14587	\N	\N	\N	
14588	\N	\N	\N	
14589	\N	\N	\N	
14590	\N	\N	\N	
14591	\N	\N	\N	
14592	\N	\N	\N	
14593	\N	\N	\N	
14594	\N	\N	\N	
14595	\N	\N	\N	
14596	\N	\N	\N	
14597	\N	\N	\N	
14598	\N	\N	\N	
14599	\N	\N	\N	
14600	\N	\N	\N	
14601	\N	\N	\N	
14602	\N	\N	\N	
14603	\N	\N	\N	
14604	\N	\N	\N	
14605	\N	\N	\N	
14606	\N	\N	\N	
14607	\N	\N	\N	
14608	\N	\N	\N	
14609	\N	\N	\N	
14610	\N	\N	\N	
14611	\N	\N	\N	
14612	\N	\N	\N	
14613	\N	\N	\N	
14614	\N	\N	\N	
14615	\N	\N	\N	
14616	\N	\N	\N	
14617	\N	\N	\N	
14618	\N	\N	\N	
14619	\N	\N	\N	
14620	\N	\N	\N	
14621	\N	\N	\N	
14622	\N	\N	\N	
14623	\N	\N	\N	
14624	\N	\N	\N	
14625	\N	\N	\N	
14626	\N	\N	\N	
14627	\N	\N	\N	
14628	\N	\N	\N	
14629	\N	\N	\N	
14630	\N	\N	\N	
14631	\N	\N	\N	
14632	\N	\N	\N	
14633	\N	\N	\N	
14634	\N	\N	\N	
14635	\N	\N	\N	
14636	\N	\N	\N	
14637	\N	\N	\N	
14638	\N	\N	\N	
14639	\N	\N	\N	
14640	\N	\N	\N	
14641	\N	\N	\N	
14642	\N	\N	\N	
14643	\N	\N	\N	
14644	\N	\N	\N	
14645	\N	\N	\N	
14646	\N	\N	\N	
14647	\N	\N	\N	
14648	\N	\N	\N	
14649	\N	\N	\N	
14650	\N	\N	\N	
14651	\N	\N	\N	
14652	\N	\N	\N	
14653	\N	\N	\N	
14654	\N	\N	\N	
14655	\N	\N	\N	
14656	\N	\N	\N	
14657	\N	\N	\N	
14658	\N	\N	\N	
14659	\N	\N	\N	
14660	\N	\N	\N	
14661	\N	\N	\N	
14662	\N	\N	\N	
14663	\N	\N	\N	
14664	\N	\N	\N	
14665	\N	\N	\N	
14666	\N	\N	\N	
14667	\N	\N	\N	
14668	\N	\N	\N	
14669	\N	\N	\N	
14670	\N	\N	\N	
14671	\N	\N	\N	
14672	\N	\N	\N	
14673	\N	\N	\N	
14674	\N	\N	\N	
14675	\N	\N	\N	
14676	\N	\N	\N	
14677	\N	\N	\N	
14678	\N	\N	\N	
14679	\N	\N	\N	
14680	\N	\N	\N	
14681	\N	\N	\N	
14682	\N	\N	\N	
14683	\N	\N	\N	
14684	\N	\N	\N	
14685	\N	\N	\N	
14686	\N	\N	\N	
14687	\N	\N	\N	
14688	\N	\N	\N	
14689	\N	\N	\N	
14690	\N	\N	\N	
14691	\N	\N	\N	
14692	\N	\N	\N	
14693	\N	\N	\N	
14694	\N	\N	\N	
14695	\N	\N	\N	
14696	\N	\N	\N	
14697	\N	\N	\N	
14698	\N	\N	\N	
14699	\N	\N	\N	
14700	\N	\N	\N	
14701	\N	\N	\N	
14702	\N	\N	\N	
14703	\N	\N	\N	
14704	\N	\N	\N	
14705	\N	\N	\N	
14706	\N	\N	\N	
14707	\N	\N	\N	
14708	\N	\N	\N	
14709	\N	\N	\N	
14710	\N	\N	\N	
14711	\N	\N	\N	
14712	\N	\N	\N	
14713	\N	\N	\N	
14714	\N	\N	\N	
14715	\N	\N	\N	
14716	\N	\N	\N	
14717	\N	\N	\N	
14718	\N	\N	\N	
14719	\N	\N	\N	
14720	\N	\N	\N	
14721	\N	\N	\N	
14722	\N	\N	\N	
14723	\N	\N	\N	
14724	\N	\N	\N	
14725	\N	\N	\N	
14726	\N	\N	\N	
14727	\N	\N	\N	
14728	\N	\N	\N	
14729	\N	\N	\N	
14730	\N	\N	\N	
14731	\N	\N	\N	
14732	\N	\N	\N	
14733	\N	\N	\N	
14734	\N	\N	\N	
14735	\N	\N	\N	
14736	\N	\N	\N	
14737	\N	\N	\N	
14738	\N	\N	\N	
14739	\N	\N	\N	
14740	\N	\N	\N	
14741	\N	\N	\N	
14742	\N	\N	\N	
14743	\N	\N	\N	
14744	\N	\N	\N	
14745	\N	\N	\N	
14746	\N	\N	\N	
14747	\N	\N	\N	
14748	\N	\N	\N	
14749	\N	\N	\N	
14750	\N	\N	\N	
14751	\N	\N	\N	
14752	\N	\N	\N	
14753	\N	\N	\N	
14754	\N	\N	\N	
14755	\N	\N	\N	
14756	\N	\N	\N	
14757	\N	\N	\N	
14758	\N	\N	\N	
14759	\N	\N	\N	
14760	\N	\N	\N	
14761	\N	\N	\N	
14762	\N	\N	\N	
14763	\N	\N	\N	
14764	\N	\N	\N	
14765	\N	\N	\N	
14766	\N	\N	\N	
14767	\N	\N	\N	
14768	\N	\N	\N	
14769	\N	\N	\N	
14770	\N	\N	\N	
14771	\N	\N	\N	
14772	\N	\N	\N	
14773	\N	\N	\N	
14774	\N	\N	\N	
14775	\N	\N	\N	
14776	\N	\N	\N	
14777	\N	\N	\N	
14778	\N	\N	\N	
14779	\N	\N	\N	
14780	\N	\N	\N	
14781	\N	\N	\N	
14782	\N	\N	\N	
14783	\N	\N	\N	
14784	\N	\N	\N	
14785	\N	\N	\N	
14786	\N	\N	\N	
14787	\N	\N	\N	
14788	\N	\N	\N	
14789	\N	\N	\N	
14790	\N	\N	\N	
14791	\N	\N	\N	
14792	\N	\N	\N	
14793	\N	\N	\N	
14794	\N	\N	\N	
14795	\N	\N	\N	
14796	\N	\N	\N	
14797	\N	\N	\N	
14798	\N	\N	\N	
14799	\N	\N	\N	
14800	\N	\N	\N	
14801	\N	\N	\N	
14802	\N	\N	\N	
14803	\N	\N	\N	
14804	\N	\N	\N	
14805	\N	\N	\N	
14806	\N	\N	\N	
14807	\N	\N	\N	
14808	\N	\N	\N	
14809	\N	\N	\N	
14810	\N	\N	\N	
14811	\N	\N	\N	
14812	\N	\N	\N	
14813	\N	\N	\N	
14814	\N	\N	\N	
14815	\N	\N	\N	
14816	\N	\N	\N	
14817	\N	\N	\N	
14818	\N	\N	\N	
14819	\N	\N	\N	
14820	\N	\N	\N	
14821	\N	\N	\N	
14822	\N	\N	\N	
14823	\N	\N	\N	
14824	\N	\N	\N	
14825	\N	\N	\N	
14826	\N	\N	\N	
14827	\N	\N	\N	
14828	\N	\N	\N	
14829	\N	\N	\N	
14830	\N	\N	\N	
14831	\N	\N	\N	
14832	\N	\N	\N	
14833	\N	\N	\N	
14834	\N	\N	\N	
14835	\N	\N	\N	
14836	\N	\N	\N	
14837	\N	\N	\N	
14838	\N	\N	\N	
14839	\N	\N	\N	
14840	\N	\N	\N	
14841	\N	\N	\N	
14842	\N	\N	\N	
14843	\N	\N	\N	
14844	\N	\N	\N	
14845	\N	\N	\N	
14846	\N	\N	\N	
14847	\N	\N	\N	
14848	\N	\N	\N	
14849	\N	\N	\N	
14850	\N	\N	\N	
14851	\N	\N	\N	
14852	\N	\N	\N	
14853	\N	\N	\N	
14854	\N	\N	\N	
14855	\N	\N	\N	
14856	\N	\N	\N	
14857	\N	\N	\N	
14858	\N	\N	\N	
14859	\N	\N	\N	
14860	\N	\N	\N	
14861	\N	\N	\N	
14862	\N	\N	\N	
14863	\N	\N	\N	
14864	\N	\N	\N	
14865	\N	\N	\N	
14866	\N	\N	\N	
14867	\N	\N	\N	
14868	\N	\N	\N	
14869	\N	\N	\N	
14870	\N	\N	\N	
14871	\N	\N	\N	
14872	\N	\N	\N	
14873	\N	\N	\N	
14874	\N	\N	\N	
14875	\N	\N	\N	
14876	\N	\N	\N	
14877	\N	\N	\N	
14878	\N	\N	\N	
14879	\N	\N	\N	
14880	\N	\N	\N	
14881	\N	\N	\N	
14882	\N	\N	\N	
14883	\N	\N	\N	
14884	\N	\N	\N	
14885	\N	\N	\N	
14886	\N	\N	\N	
14887	\N	\N	\N	
14888	\N	\N	\N	
14889	\N	\N	\N	
14890	\N	\N	\N	
14891	\N	\N	\N	
14892	\N	\N	\N	
14893	\N	\N	\N	
14894	\N	\N	\N	
14895	\N	\N	\N	
14896	\N	\N	\N	
14897	\N	\N	\N	
14898	\N	\N	\N	
14899	\N	\N	\N	
14900	\N	\N	\N	
14901	\N	\N	\N	
14902	\N	\N	\N	
14903	\N	\N	\N	
14904	\N	\N	\N	
14905	\N	\N	\N	
14906	\N	\N	\N	
14907	\N	\N	\N	
14908	\N	\N	\N	
14909	\N	\N	\N	
14910	\N	\N	\N	
14911	\N	\N	\N	
14912	\N	\N	\N	
14913	\N	\N	\N	
14914	\N	\N	\N	
14915	\N	\N	\N	
14916	\N	\N	\N	
14917	\N	\N	\N	
14918	\N	\N	\N	
14919	\N	\N	\N	
14920	\N	\N	\N	
14921	\N	\N	\N	
14922	\N	\N	\N	
14923	\N	\N	\N	
14924	\N	\N	\N	
14925	\N	\N	\N	
14926	\N	\N	\N	
14927	\N	\N	\N	
14928	\N	\N	\N	
14929	\N	\N	\N	
14930	\N	\N	\N	
14931	\N	\N	\N	
14932	\N	\N	\N	
14933	\N	\N	\N	
14934	\N	\N	\N	
14935	\N	\N	\N	
14936	\N	\N	\N	
14937	\N	\N	\N	
14938	\N	\N	\N	
14939	\N	\N	\N	
14940	\N	\N	\N	
14941	\N	\N	\N	
14942	\N	\N	\N	
14943	\N	\N	\N	
14944	\N	\N	\N	
14945	\N	\N	\N	
14946	\N	\N	\N	
14947	\N	\N	\N	
14948	\N	\N	\N	
14949	\N	\N	\N	
14950	\N	\N	\N	
14951	\N	\N	\N	
14952	\N	\N	\N	
14953	\N	\N	\N	
14954	\N	\N	\N	
14955	\N	\N	\N	
14956	\N	\N	\N	
14957	\N	\N	\N	
14958	\N	\N	\N	
14959	\N	\N	\N	
14960	\N	\N	\N	
14961	\N	\N	\N	
14962	\N	\N	\N	
14963	\N	\N	\N	
14964	\N	\N	\N	
14965	\N	\N	\N	
14966	\N	\N	\N	
14967	\N	\N	\N	
14968	\N	\N	\N	
14969	\N	\N	\N	
14970	\N	\N	\N	
14971	\N	\N	\N	
14972	\N	\N	\N	
14973	\N	\N	\N	
14974	\N	\N	\N	
14975	\N	\N	\N	
14976	\N	\N	\N	
14977	\N	\N	\N	
14978	\N	\N	\N	
14979	\N	\N	\N	
14980	\N	\N	\N	
14981	\N	\N	\N	
14982	\N	\N	\N	
14983	\N	\N	\N	
14984	\N	\N	\N	
14985	\N	\N	\N	
14986	\N	\N	\N	
14987	\N	\N	\N	
14988	\N	\N	\N	
14989	\N	\N	\N	
14990	\N	\N	\N	
14991	\N	\N	\N	
14992	\N	\N	\N	
14993	\N	\N	\N	
14994	\N	\N	\N	
14995	\N	\N	\N	
14996	\N	\N	\N	
14997	\N	\N	\N	
14998	\N	\N	\N	
14999	\N	\N	\N	
15000	\N	\N	\N	
15001	\N	\N	\N	
15002	\N	\N	\N	
15003	\N	\N	\N	
15004	\N	\N	\N	
15005	\N	\N	\N	
15006	\N	\N	\N	
15007	\N	\N	\N	
15008	\N	\N	\N	
15009	\N	\N	\N	
15010	\N	\N	\N	
15011	\N	\N	\N	
15012	\N	\N	\N	
15013	\N	\N	\N	
15014	\N	\N	\N	
15015	\N	\N	\N	
15016	\N	\N	\N	
15017	\N	\N	\N	
15018	\N	\N	\N	
15019	\N	\N	\N	
15020	\N	\N	\N	
15021	\N	\N	\N	
15022	\N	\N	\N	
15023	\N	\N	\N	
15024	\N	\N	\N	
15025	\N	\N	\N	
15026	\N	\N	\N	
15027	\N	\N	\N	
15028	\N	\N	\N	
15029	\N	\N	\N	
15030	\N	\N	\N	
15031	\N	\N	\N	
15032	\N	\N	\N	
15033	\N	\N	\N	
15034	\N	\N	\N	
15035	\N	\N	\N	
15036	\N	\N	\N	
15037	\N	\N	\N	
15038	\N	\N	\N	
15039	\N	\N	\N	
15040	\N	\N	\N	
15041	\N	\N	\N	
15042	\N	\N	\N	
15043	\N	\N	\N	
15044	\N	\N	\N	
15045	\N	\N	\N	
15046	\N	\N	\N	
15047	\N	\N	\N	
15048	\N	\N	\N	
15049	\N	\N	\N	
15050	\N	\N	\N	
15051	\N	\N	\N	
15052	\N	\N	\N	
15053	\N	\N	\N	
15054	\N	\N	\N	
15055	\N	\N	\N	
15056	\N	\N	\N	
15057	\N	\N	\N	
15058	\N	\N	\N	
15059	\N	\N	\N	
15060	\N	\N	\N	
15061	\N	\N	\N	
15062	\N	\N	\N	
15063	\N	\N	\N	
15064	\N	\N	\N	
15065	\N	\N	\N	
15066	\N	\N	\N	
15067	\N	\N	\N	
15068	\N	\N	\N	
15069	\N	\N	\N	
15070	\N	\N	\N	
15071	\N	\N	\N	
15072	\N	\N	\N	
15073	\N	\N	\N	
15074	\N	\N	\N	
15075	\N	\N	\N	
15076	\N	\N	\N	
15077	\N	\N	\N	
15078	\N	\N	\N	
15079	\N	\N	\N	
15080	\N	\N	\N	
15081	\N	\N	\N	
15082	\N	\N	\N	
15083	\N	\N	\N	
15084	\N	\N	\N	
15085	\N	\N	\N	
15086	\N	\N	\N	
15087	\N	\N	\N	
15088	\N	\N	\N	
15089	\N	\N	\N	
15090	\N	\N	\N	
15091	\N	\N	\N	
15092	\N	\N	\N	
15093	\N	\N	\N	
15094	\N	\N	\N	
15095	\N	\N	\N	
15096	\N	\N	\N	
15097	\N	\N	\N	
15098	\N	\N	\N	
15099	\N	\N	\N	
15100	\N	\N	\N	
15101	\N	\N	\N	
15102	\N	\N	\N	
15103	\N	\N	\N	
15104	\N	\N	\N	
15105	\N	\N	\N	
15106	\N	\N	\N	
15107	\N	\N	\N	
15108	\N	\N	\N	
15109	\N	\N	\N	
15110	\N	\N	\N	
15111	\N	\N	\N	
15112	\N	\N	\N	
15113	\N	\N	\N	
15114	\N	\N	\N	
15115	\N	\N	\N	
15116	\N	\N	\N	
15117	\N	\N	\N	
15118	\N	\N	\N	
15119	\N	\N	\N	
15120	\N	\N	\N	
15121	\N	\N	\N	
15122	\N	\N	\N	
15123	\N	\N	\N	
15124	\N	\N	\N	
15125	\N	\N	\N	
15126	\N	\N	\N	
15127	\N	\N	\N	
15128	\N	\N	\N	
15129	\N	\N	\N	
15130	\N	\N	\N	
15131	\N	\N	\N	
15132	\N	\N	\N	
15133	\N	\N	\N	
15134	\N	\N	\N	
15135	\N	\N	\N	
15136	\N	\N	\N	
15137	\N	\N	\N	
15138	\N	\N	\N	
15139	\N	\N	\N	
15140	\N	\N	\N	
15141	\N	\N	\N	
15142	\N	\N	\N	
15143	\N	\N	\N	
15144	\N	\N	\N	
15145	\N	\N	\N	
15146	\N	\N	\N	
15147	\N	\N	\N	
15148	\N	\N	\N	
15149	\N	\N	\N	
15150	\N	\N	\N	
15151	\N	\N	\N	
15152	\N	\N	\N	
15153	\N	\N	\N	
15154	\N	\N	\N	
15155	\N	\N	\N	
15156	\N	\N	\N	
15157	\N	\N	\N	
15158	\N	\N	\N	
15159	\N	\N	\N	
15160	\N	\N	\N	
15161	\N	\N	\N	
15162	\N	\N	\N	
15163	\N	\N	\N	
15164	\N	\N	\N	
15165	\N	\N	\N	
15166	\N	\N	\N	
15167	\N	\N	\N	
15168	\N	\N	\N	
15169	\N	\N	\N	
15170	\N	\N	\N	
15171	\N	\N	\N	
15172	\N	\N	\N	
15173	\N	\N	\N	
15174	\N	\N	\N	
15175	\N	\N	\N	
15176	\N	\N	\N	
15177	\N	\N	\N	
15178	\N	\N	\N	
15179	\N	\N	\N	
15180	\N	\N	\N	
15181	\N	\N	\N	
15182	\N	\N	\N	
15183	\N	\N	\N	
15184	\N	\N	\N	
15185	\N	\N	\N	
15186	\N	\N	\N	
15187	\N	\N	\N	
15188	\N	\N	\N	
15189	\N	\N	\N	
15190	\N	\N	\N	
15191	\N	\N	\N	
15192	\N	\N	\N	
15193	\N	\N	\N	
15194	\N	\N	\N	
15195	\N	\N	\N	
15196	\N	\N	\N	
15197	\N	\N	\N	
15198	\N	\N	\N	
15199	\N	\N	\N	
15200	\N	\N	\N	
15201	\N	\N	\N	
15202	\N	\N	\N	
15203	\N	\N	\N	
15204	\N	\N	\N	
15205	\N	\N	\N	
15206	\N	\N	\N	
15207	\N	\N	\N	
15208	\N	\N	\N	
15209	\N	\N	\N	
15210	\N	\N	\N	
15211	\N	\N	\N	
15212	\N	\N	\N	
15213	\N	\N	\N	
15214	\N	\N	\N	
15215	\N	\N	\N	
15216	\N	\N	\N	
15217	\N	\N	\N	
15218	\N	\N	\N	
15219	\N	\N	\N	
15220	\N	\N	\N	
15221	\N	\N	\N	
15222	\N	\N	\N	
15223	\N	\N	\N	
15224	\N	\N	\N	
15225	\N	\N	\N	
15226	\N	\N	\N	
15227	\N	\N	\N	
15228	\N	\N	\N	
15229	\N	\N	\N	
15230	\N	\N	\N	
15231	\N	\N	\N	
15232	\N	\N	\N	
15233	\N	\N	\N	
15234	\N	\N	\N	
15235	\N	\N	\N	
15236	\N	\N	\N	
15237	\N	\N	\N	
15238	\N	\N	\N	
15239	\N	\N	\N	
15240	\N	\N	\N	
15241	\N	\N	\N	
15242	\N	\N	\N	
15243	\N	\N	\N	
15244	\N	\N	\N	
15245	\N	\N	\N	
15246	\N	\N	\N	
15247	\N	\N	\N	
15248	\N	\N	\N	
15249	\N	\N	\N	
15250	\N	\N	\N	
15251	\N	\N	\N	
15252	\N	\N	\N	
15253	\N	\N	\N	
15254	\N	\N	\N	
15255	\N	\N	\N	
15256	\N	\N	\N	
15257	\N	\N	\N	
15258	\N	\N	\N	
15259	\N	\N	\N	
15260	\N	\N	\N	
15261	\N	\N	\N	
15262	\N	\N	\N	
15263	\N	\N	\N	
15264	\N	\N	\N	
15265	\N	\N	\N	
15266	\N	\N	\N	
15267	\N	\N	\N	
15268	\N	\N	\N	
15269	\N	\N	\N	
15270	\N	\N	\N	
15271	\N	\N	\N	
15272	\N	\N	\N	
15273	\N	\N	\N	
15274	\N	\N	\N	
15275	\N	\N	\N	
15276	\N	\N	\N	
15277	\N	\N	\N	
15278	\N	\N	\N	
15279	\N	\N	\N	
15280	\N	\N	\N	
15281	\N	\N	\N	
15282	\N	\N	\N	
15283	\N	\N	\N	
15284	\N	\N	\N	
15285	\N	\N	\N	
15286	\N	\N	\N	
15287	\N	\N	\N	
15288	\N	\N	\N	
15289	\N	\N	\N	
15290	\N	\N	\N	
15291	\N	\N	\N	
15292	\N	\N	\N	
15293	\N	\N	\N	
15294	\N	\N	\N	
15295	\N	\N	\N	
15296	\N	\N	\N	
15297	\N	\N	\N	
15298	\N	\N	\N	
15299	\N	\N	\N	
15300	\N	\N	\N	
15301	\N	\N	\N	
15302	\N	\N	\N	
15303	\N	\N	\N	
15304	\N	\N	\N	
15305	\N	\N	\N	
15306	\N	\N	\N	
15307	\N	\N	\N	
15308	\N	\N	\N	
15309	\N	\N	\N	
15310	\N	\N	\N	
15311	\N	\N	\N	
15312	\N	\N	\N	
15313	\N	\N	\N	
15314	\N	\N	\N	
15315	\N	\N	\N	
15316	\N	\N	\N	
15317	\N	\N	\N	
15318	\N	\N	\N	
15319	\N	\N	\N	
15320	\N	\N	\N	
15321	\N	\N	\N	
15322	\N	\N	\N	
15323	\N	\N	\N	
15324	\N	\N	\N	
15325	\N	\N	\N	
15326	\N	\N	\N	
15327	\N	\N	\N	
15328	\N	\N	\N	
15329	\N	\N	\N	
15330	\N	\N	\N	
15331	\N	\N	\N	
15332	\N	\N	\N	
15333	\N	\N	\N	
15334	\N	\N	\N	
15335	\N	\N	\N	
15336	\N	\N	\N	
15337	\N	\N	\N	
15338	\N	\N	\N	
15339	\N	\N	\N	
15340	\N	\N	\N	
15341	\N	\N	\N	
15342	\N	\N	\N	
15343	\N	\N	\N	
15344	\N	\N	\N	
15345	\N	\N	\N	
15346	\N	\N	\N	
15347	\N	\N	\N	
15348	\N	\N	\N	
15349	\N	\N	\N	
15350	\N	\N	\N	
15351	\N	\N	\N	
15352	\N	\N	\N	
15353	\N	\N	\N	
15354	\N	\N	\N	
15355	\N	\N	\N	
15356	\N	\N	\N	
15357	\N	\N	\N	
15358	\N	\N	\N	
15359	\N	\N	\N	
15360	\N	\N	\N	
15361	\N	\N	\N	
15362	\N	\N	\N	
15363	\N	\N	\N	
15364	\N	\N	\N	
15365	\N	\N	\N	
15366	\N	\N	\N	
15367	\N	\N	\N	
15368	\N	\N	\N	
15369	\N	\N	\N	
15370	\N	\N	\N	
15371	\N	\N	\N	
15372	\N	\N	\N	
15373	\N	\N	\N	
15374	\N	\N	\N	
15375	\N	\N	\N	
15376	\N	\N	\N	
15377	\N	\N	\N	
15378	\N	\N	\N	
15379	\N	\N	\N	
15380	\N	\N	\N	
15381	\N	\N	\N	
15382	\N	\N	\N	
15383	\N	\N	\N	
15384	\N	\N	\N	
15385	\N	\N	\N	
15386	\N	\N	\N	
15387	\N	\N	\N	
15388	\N	\N	\N	
15389	\N	\N	\N	
15390	\N	\N	\N	
15391	\N	\N	\N	
15392	\N	\N	\N	
15393	\N	\N	\N	
15394	\N	\N	\N	
15395	\N	\N	\N	
15396	\N	\N	\N	
15397	\N	\N	\N	
15398	\N	\N	\N	
15399	\N	\N	\N	
15400	\N	\N	\N	
15401	\N	\N	\N	
15402	\N	\N	\N	
15403	\N	\N	\N	
15404	\N	\N	\N	
15405	\N	\N	\N	
15406	\N	\N	\N	
15407	\N	\N	\N	
15408	\N	\N	\N	
15409	\N	\N	\N	
15410	\N	\N	\N	
15411	\N	\N	\N	
15412	\N	\N	\N	
15413	\N	\N	\N	
15414	\N	\N	\N	
15415	\N	\N	\N	
15416	\N	\N	\N	
15417	\N	\N	\N	
15418	\N	\N	\N	
15419	\N	\N	\N	
15420	\N	\N	\N	
15421	\N	\N	\N	
15422	\N	\N	\N	
15423	\N	\N	\N	
15424	\N	\N	\N	
15425	\N	\N	\N	
15426	\N	\N	\N	
15427	\N	\N	\N	
15428	\N	\N	\N	
15429	\N	\N	\N	
15430	\N	\N	\N	
15431	\N	\N	\N	
15432	\N	\N	\N	
15433	\N	\N	\N	
15434	\N	\N	\N	
15435	\N	\N	\N	
15436	\N	\N	\N	
15437	\N	\N	\N	
15438	\N	\N	\N	
15439	\N	\N	\N	
15440	\N	\N	\N	
15441	\N	\N	\N	
15442	\N	\N	\N	
15443	\N	\N	\N	
15444	\N	\N	\N	
15445	\N	\N	\N	
15446	\N	\N	\N	
15447	\N	\N	\N	
15448	\N	\N	\N	
15449	\N	\N	\N	
15450	\N	\N	\N	
15451	\N	\N	\N	
15452	\N	\N	\N	
15453	\N	\N	\N	
15454	\N	\N	\N	
15455	\N	\N	\N	
15456	\N	\N	\N	
15457	\N	\N	\N	
15458	\N	\N	\N	
15459	\N	\N	\N	
15460	\N	\N	\N	
15461	\N	\N	\N	
15462	\N	\N	\N	
15463	\N	\N	\N	
15464	\N	\N	\N	
15465	\N	\N	\N	
15466	\N	\N	\N	
15467	\N	\N	\N	
15468	\N	\N	\N	
15469	\N	\N	\N	
15470	\N	\N	\N	
15471	\N	\N	\N	
15472	\N	\N	\N	
15473	\N	\N	\N	
15474	\N	\N	\N	
15475	\N	\N	\N	
15476	\N	\N	\N	
15477	\N	\N	\N	
15478	\N	\N	\N	
15479	\N	\N	\N	
15480	\N	\N	\N	
15481	\N	\N	\N	
15482	\N	\N	\N	
15483	\N	\N	\N	
15484	\N	\N	\N	
15485	\N	\N	\N	
15486	\N	\N	\N	
15487	\N	\N	\N	
15488	\N	\N	\N	
15489	\N	\N	\N	
15490	\N	\N	\N	
15491	\N	\N	\N	
15492	\N	\N	\N	
15493	\N	\N	\N	
15494	\N	\N	\N	
15495	\N	\N	\N	
15496	\N	\N	\N	
15497	\N	\N	\N	
15498	\N	\N	\N	
15499	\N	\N	\N	
15500	\N	\N	\N	
15501	\N	\N	\N	
15502	\N	\N	\N	
15503	\N	\N	\N	
15504	\N	\N	\N	
15505	\N	\N	\N	
15506	\N	\N	\N	
15507	\N	\N	\N	
15508	\N	\N	\N	
15509	\N	\N	\N	
15510	\N	\N	\N	
15511	\N	\N	\N	
15512	\N	\N	\N	
15513	\N	\N	\N	
15514	\N	\N	\N	
15515	\N	\N	\N	
15516	\N	\N	\N	
15517	\N	\N	\N	
15518	\N	\N	\N	
15519	\N	\N	\N	
15520	\N	\N	\N	
15521	\N	\N	\N	
15522	\N	\N	\N	
15523	\N	\N	\N	
15524	\N	\N	\N	
15525	\N	\N	\N	
15526	\N	\N	\N	
15527	\N	\N	\N	
15528	\N	\N	\N	
15529	\N	\N	\N	
15530	\N	\N	\N	
15531	\N	\N	\N	
15532	\N	\N	\N	
15533	\N	\N	\N	
15534	\N	\N	\N	
15535	\N	\N	\N	
15536	\N	\N	\N	
15537	\N	\N	\N	
15538	\N	\N	\N	
15539	\N	\N	\N	
15540	\N	\N	\N	
15541	\N	\N	\N	
15542	\N	\N	\N	
15543	\N	\N	\N	
15544	\N	\N	\N	
15545	\N	\N	\N	
15546	\N	\N	\N	
15547	\N	\N	\N	
15548	\N	\N	\N	
15549	\N	\N	\N	
15550	\N	\N	\N	
15551	\N	\N	\N	
15552	\N	\N	\N	
15553	\N	\N	\N	
15554	\N	\N	\N	
15555	\N	\N	\N	
15556	\N	\N	\N	
15557	\N	\N	\N	
15558	\N	\N	\N	
15559	\N	\N	\N	
15560	\N	\N	\N	
15561	\N	\N	\N	
15562	\N	\N	\N	
15563	\N	\N	\N	
15564	\N	\N	\N	
15565	\N	\N	\N	
15566	\N	\N	\N	
15567	\N	\N	\N	
15568	\N	\N	\N	
15569	\N	\N	\N	
15570	\N	\N	\N	
15571	\N	\N	\N	
15572	\N	\N	\N	
15573	\N	\N	\N	
15574	\N	\N	\N	
15575	\N	\N	\N	
15576	\N	\N	\N	
15577	\N	\N	\N	
15578	\N	\N	\N	
15579	\N	\N	\N	
15580	\N	\N	\N	
15581	\N	\N	\N	
15582	\N	\N	\N	
15583	\N	\N	\N	
15584	\N	\N	\N	
15585	\N	\N	\N	
15586	\N	\N	\N	
15587	\N	\N	\N	
15588	\N	\N	\N	
15589	\N	\N	\N	
15590	\N	\N	\N	
15591	\N	\N	\N	
15592	\N	\N	\N	
15593	\N	\N	\N	
15594	\N	\N	\N	
15595	\N	\N	\N	
15596	\N	\N	\N	
15597	\N	\N	\N	
15598	\N	\N	\N	
15599	\N	\N	\N	
15600	\N	\N	\N	
15601	\N	\N	\N	
15602	\N	\N	\N	
15603	\N	\N	\N	
15604	\N	\N	\N	
15605	\N	\N	\N	
15606	\N	\N	\N	
15607	\N	\N	\N	
15608	\N	\N	\N	
15609	\N	\N	\N	
15610	\N	\N	\N	
15611	\N	\N	\N	
15612	\N	\N	\N	
15613	\N	\N	\N	
15614	\N	\N	\N	
15615	\N	\N	\N	
15616	\N	\N	\N	
15617	\N	\N	\N	
15618	\N	\N	\N	
15619	\N	\N	\N	
15620	\N	\N	\N	
15621	\N	\N	\N	
15622	\N	\N	\N	
15623	\N	\N	\N	
15624	\N	\N	\N	
15625	\N	\N	\N	
15626	\N	\N	\N	
15627	\N	\N	\N	
15628	\N	\N	\N	
15629	\N	\N	\N	
15630	\N	\N	\N	
15631	\N	\N	\N	
15632	\N	\N	\N	
15633	\N	\N	\N	
15634	\N	\N	\N	
15635	\N	\N	\N	
15636	\N	\N	\N	
15637	\N	\N	\N	
15638	\N	\N	\N	
15639	\N	\N	\N	
15640	\N	\N	\N	
15641	\N	\N	\N	
15642	\N	\N	\N	
15643	\N	\N	\N	
15644	\N	\N	\N	
15645	\N	\N	\N	
15646	\N	\N	\N	
15647	\N	\N	\N	
15648	\N	\N	\N	
15649	\N	\N	\N	
15650	\N	\N	\N	
15651	\N	\N	\N	
15652	\N	\N	\N	
15653	\N	\N	\N	
15654	\N	\N	\N	
15655	\N	\N	\N	
15656	\N	\N	\N	
15657	\N	\N	\N	
15658	\N	\N	\N	
15659	\N	\N	\N	
15660	\N	\N	\N	
15661	\N	\N	\N	
15662	\N	\N	\N	
15663	\N	\N	\N	
15664	\N	\N	\N	
15665	\N	\N	\N	
15666	\N	\N	\N	
15667	\N	\N	\N	
15668	\N	\N	\N	
15669	\N	\N	\N	
15670	\N	\N	\N	
15671	\N	\N	\N	
15672	\N	\N	\N	
15673	\N	\N	\N	
15674	\N	\N	\N	
15675	\N	\N	\N	
15676	\N	\N	\N	
15677	\N	\N	\N	
15678	\N	\N	\N	
15679	\N	\N	\N	
15680	\N	\N	\N	
15681	\N	\N	\N	
15682	\N	\N	\N	
15683	\N	\N	\N	
15684	\N	\N	\N	
15685	\N	\N	\N	
15686	\N	\N	\N	
15687	\N	\N	\N	
15688	\N	\N	\N	
15689	\N	\N	\N	
15690	\N	\N	\N	
15691	\N	\N	\N	
15692	\N	\N	\N	
15693	\N	\N	\N	
15694	\N	\N	\N	
15695	\N	\N	\N	
15696	\N	\N	\N	
15697	\N	\N	\N	
15698	\N	\N	\N	
15699	\N	\N	\N	
15700	\N	\N	\N	
15701	\N	\N	\N	
15702	\N	\N	\N	
15703	\N	\N	\N	
15704	\N	\N	\N	
15705	\N	\N	\N	
15706	\N	\N	\N	
15707	\N	\N	\N	
15708	\N	\N	\N	
15709	\N	\N	\N	
15710	\N	\N	\N	
15711	\N	\N	\N	
15712	\N	\N	\N	
15713	\N	\N	\N	
15714	\N	\N	\N	
15715	\N	\N	\N	
15716	\N	\N	\N	
15717	\N	\N	\N	
15718	\N	\N	\N	
15719	\N	\N	\N	
15720	\N	\N	\N	
15721	\N	\N	\N	
15722	\N	\N	\N	
15723	\N	\N	\N	
15724	\N	\N	\N	
15725	\N	\N	\N	
15726	\N	\N	\N	
15727	\N	\N	\N	
15728	\N	\N	\N	
15729	\N	\N	\N	
15730	\N	\N	\N	
15731	\N	\N	\N	
15732	\N	\N	\N	
15733	\N	\N	\N	
15734	\N	\N	\N	
15735	\N	\N	\N	
15736	\N	\N	\N	
15737	\N	\N	\N	
15738	\N	\N	\N	
15739	\N	\N	\N	
15740	\N	\N	\N	
15741	\N	\N	\N	
15742	\N	\N	\N	
15743	\N	\N	\N	
15744	\N	\N	\N	
15745	\N	\N	\N	
15746	\N	\N	\N	
15747	\N	\N	\N	
15748	\N	\N	\N	
15749	\N	\N	\N	
15750	\N	\N	\N	
15751	\N	\N	\N	
15752	\N	\N	\N	
15753	\N	\N	\N	
15754	\N	\N	\N	
15755	\N	\N	\N	
15756	\N	\N	\N	
15757	\N	\N	\N	
15758	\N	\N	\N	
15759	\N	\N	\N	
15760	\N	\N	\N	
15761	\N	\N	\N	
15762	\N	\N	\N	
15763	\N	\N	\N	
15764	\N	\N	\N	
15765	\N	\N	\N	
15766	\N	\N	\N	
15767	\N	\N	\N	
15768	\N	\N	\N	
15769	\N	\N	\N	
15770	\N	\N	\N	
15771	\N	\N	\N	
15772	\N	\N	\N	
15773	\N	\N	\N	
15774	\N	\N	\N	
15775	\N	\N	\N	
15776	\N	\N	\N	
15777	\N	\N	\N	
15778	\N	\N	\N	
15779	\N	\N	\N	
15780	\N	\N	\N	
15781	\N	\N	\N	
15782	\N	\N	\N	
15783	\N	\N	\N	
15784	\N	\N	\N	
15785	\N	\N	\N	
15786	\N	\N	\N	
15787	\N	\N	\N	
15788	\N	\N	\N	
15789	\N	\N	\N	
15790	\N	\N	\N	
15791	\N	\N	\N	
15792	\N	\N	\N	
15793	\N	\N	\N	
15794	\N	\N	\N	
15795	\N	\N	\N	
15796	\N	\N	\N	
15797	\N	\N	\N	
15798	\N	\N	\N	
15799	\N	\N	\N	
15800	\N	\N	\N	
15801	\N	\N	\N	
15802	\N	\N	\N	
15803	\N	\N	\N	
15804	\N	\N	\N	
15805	\N	\N	\N	
15806	\N	\N	\N	
15807	\N	\N	\N	
15808	\N	\N	\N	
15809	\N	\N	\N	
15810	\N	\N	\N	
15811	\N	\N	\N	
15812	\N	\N	\N	
15813	\N	\N	\N	
15814	\N	\N	\N	
15815	\N	\N	\N	
15816	\N	\N	\N	
15817	\N	\N	\N	
15818	\N	\N	\N	
15819	\N	\N	\N	
15820	\N	\N	\N	
15821	\N	\N	\N	
15822	\N	\N	\N	
15823	\N	\N	\N	
15824	\N	\N	\N	
15825	\N	\N	\N	
15826	\N	\N	\N	
15827	\N	\N	\N	
15828	\N	\N	\N	
15829	\N	\N	\N	
15830	\N	\N	\N	
15831	\N	\N	\N	
15832	\N	\N	\N	
15833	\N	\N	\N	
15834	\N	\N	\N	
15835	\N	\N	\N	
15836	\N	\N	\N	
15837	\N	\N	\N	
15838	\N	\N	\N	
15839	\N	\N	\N	
15840	\N	\N	\N	
15841	\N	\N	\N	
15842	\N	\N	\N	
15843	\N	\N	\N	
15844	\N	\N	\N	
15845	\N	\N	\N	
15846	\N	\N	\N	
15847	\N	\N	\N	
15848	\N	\N	\N	
15849	\N	\N	\N	
15850	\N	\N	\N	
15851	\N	\N	\N	
15852	\N	\N	\N	
15853	\N	\N	\N	
15854	\N	\N	\N	
15855	\N	\N	\N	
15856	\N	\N	\N	
15857	\N	\N	\N	
15858	\N	\N	\N	
15859	\N	\N	\N	
15860	\N	\N	\N	
15861	\N	\N	\N	
15862	\N	\N	\N	
15863	\N	\N	\N	
15864	\N	\N	\N	
15865	\N	\N	\N	
15866	\N	\N	\N	
15867	\N	\N	\N	
15868	\N	\N	\N	
15869	\N	\N	\N	
15870	\N	\N	\N	
15871	\N	\N	\N	
15872	\N	\N	\N	
15873	\N	\N	\N	
15874	\N	\N	\N	
15875	\N	\N	\N	
15876	\N	\N	\N	
15877	\N	\N	\N	
15878	\N	\N	\N	
15879	\N	\N	\N	
15880	\N	\N	\N	
15881	\N	\N	\N	
15882	\N	\N	\N	
15883	\N	\N	\N	
15884	\N	\N	\N	
15885	\N	\N	\N	
15886	\N	\N	\N	
15887	\N	\N	\N	
15888	\N	\N	\N	
15889	\N	\N	\N	
15890	\N	\N	\N	
15891	\N	\N	\N	
15892	\N	\N	\N	
15893	\N	\N	\N	
15894	\N	\N	\N	
15895	\N	\N	\N	
15896	\N	\N	\N	
15897	\N	\N	\N	
15898	\N	\N	\N	
15899	\N	\N	\N	
15900	\N	\N	\N	
15901	\N	\N	\N	
15902	\N	\N	\N	
15903	\N	\N	\N	
15904	\N	\N	\N	
15905	\N	\N	\N	
15906	\N	\N	\N	
15907	\N	\N	\N	
15908	\N	\N	\N	
15909	\N	\N	\N	
15910	\N	\N	\N	
15911	\N	\N	\N	
15912	\N	\N	\N	
15913	\N	\N	\N	
15914	\N	\N	\N	
15915	\N	\N	\N	
15916	\N	\N	\N	
15917	\N	\N	\N	
15918	\N	\N	\N	
15919	\N	\N	\N	
15920	\N	\N	\N	
15921	\N	\N	\N	
15922	\N	\N	\N	
15923	\N	\N	\N	
15924	\N	\N	\N	
15925	\N	\N	\N	
15926	\N	\N	\N	
15927	\N	\N	\N	
15928	\N	\N	\N	
15929	\N	\N	\N	
15930	\N	\N	\N	
15931	\N	\N	\N	
15932	\N	\N	\N	
15933	\N	\N	\N	
15934	\N	\N	\N	
15935	\N	\N	\N	
15936	\N	\N	\N	
15937	\N	\N	\N	
15938	\N	\N	\N	
15939	\N	\N	\N	
15940	\N	\N	\N	
15941	\N	\N	\N	
15942	\N	\N	\N	
15943	\N	\N	\N	
15944	\N	\N	\N	
15945	\N	\N	\N	
15946	\N	\N	\N	
15947	\N	\N	\N	
15948	\N	\N	\N	
15949	\N	\N	\N	
15950	\N	\N	\N	
15951	\N	\N	\N	
15952	\N	\N	\N	
15953	\N	\N	\N	
15954	\N	\N	\N	
15955	\N	\N	\N	
15956	\N	\N	\N	
15957	\N	\N	\N	
15958	\N	\N	\N	
15959	\N	\N	\N	
15960	\N	\N	\N	
15961	\N	\N	\N	
15962	\N	\N	\N	
15963	\N	\N	\N	
15964	\N	\N	\N	
15965	\N	\N	\N	
15966	\N	\N	\N	
15967	\N	\N	\N	
15968	\N	\N	\N	
15969	\N	\N	\N	
15970	\N	\N	\N	
15971	\N	\N	\N	
15972	\N	\N	\N	
15973	\N	\N	\N	
15974	\N	\N	\N	
15975	\N	\N	\N	
15976	\N	\N	\N	
15977	\N	\N	\N	
15978	\N	\N	\N	
15979	\N	\N	\N	
15980	\N	\N	\N	
15981	\N	\N	\N	
15982	\N	\N	\N	
15983	\N	\N	\N	
15984	\N	\N	\N	
15985	\N	\N	\N	
15986	\N	\N	\N	
15987	\N	\N	\N	
15988	\N	\N	\N	
15989	\N	\N	\N	
15990	\N	\N	\N	
15991	\N	\N	\N	
15992	\N	\N	\N	
15993	\N	\N	\N	
15994	\N	\N	\N	
15995	\N	\N	\N	
15996	\N	\N	\N	
15997	\N	\N	\N	
15998	\N	\N	\N	
15999	\N	\N	\N	
16000	\N	\N	\N	
16001	\N	\N	\N	
16002	\N	\N	\N	
16003	\N	\N	\N	
16004	\N	\N	\N	
16005	\N	\N	\N	
16006	\N	\N	\N	
16007	\N	\N	\N	
16008	\N	\N	\N	
16009	\N	\N	\N	
16010	\N	\N	\N	
16011	\N	\N	\N	
16012	\N	\N	\N	
16013	\N	\N	\N	
16014	\N	\N	\N	
16015	\N	\N	\N	
16016	\N	\N	\N	
16017	\N	\N	\N	
16018	\N	\N	\N	
16019	\N	\N	\N	
16020	\N	\N	\N	
16021	\N	\N	\N	
16022	\N	\N	\N	
16023	\N	\N	\N	
16024	\N	\N	\N	
16025	\N	\N	\N	
16026	\N	\N	\N	
16027	\N	\N	\N	
16028	\N	\N	\N	
16029	\N	\N	\N	
16030	\N	\N	\N	
16031	\N	\N	\N	
16032	\N	\N	\N	
16033	\N	\N	\N	
16034	\N	\N	\N	
16035	\N	\N	\N	
16036	\N	\N	\N	
16037	\N	\N	\N	
16038	\N	\N	\N	
16039	\N	\N	\N	
16040	\N	\N	\N	
16041	\N	\N	\N	
16042	\N	\N	\N	
16043	\N	\N	\N	
16044	\N	\N	\N	
16045	\N	\N	\N	
16046	\N	\N	\N	
16047	\N	\N	\N	
16048	\N	\N	\N	
16049	\N	\N	\N	
16050	\N	\N	\N	
16051	\N	\N	\N	
16052	\N	\N	\N	
16053	\N	\N	\N	
16054	\N	\N	\N	
16055	\N	\N	\N	
16056	\N	\N	\N	
16057	\N	\N	\N	
16058	\N	\N	\N	
16059	\N	\N	\N	
16060	\N	\N	\N	
16061	\N	\N	\N	
16062	\N	\N	\N	
16063	\N	\N	\N	
16064	\N	\N	\N	
16065	\N	\N	\N	
16066	\N	\N	\N	
16067	\N	\N	\N	
16068	\N	\N	\N	
16069	\N	\N	\N	
16070	\N	\N	\N	
16071	\N	\N	\N	
16072	\N	\N	\N	
16073	\N	\N	\N	
16074	\N	\N	\N	
16075	\N	\N	\N	
16076	\N	\N	\N	
16077	\N	\N	\N	
16078	\N	\N	\N	
16079	\N	\N	\N	
16080	\N	\N	\N	
16081	\N	\N	\N	
16082	\N	\N	\N	
16083	\N	\N	\N	
16084	\N	\N	\N	
16085	\N	\N	\N	
16086	\N	\N	\N	
16087	\N	\N	\N	
16088	\N	\N	\N	
16089	\N	\N	\N	
16090	\N	\N	\N	
16091	\N	\N	\N	
16092	\N	\N	\N	
16093	\N	\N	\N	
16094	\N	\N	\N	
16095	\N	\N	\N	
16096	\N	\N	\N	
16097	\N	\N	\N	
16098	\N	\N	\N	
16099	\N	\N	\N	
16100	\N	\N	\N	
16101	\N	\N	\N	
16102	\N	\N	\N	
16103	\N	\N	\N	
16104	\N	\N	\N	
16105	\N	\N	\N	
16106	\N	\N	\N	
16107	\N	\N	\N	
16108	\N	\N	\N	
16109	\N	\N	\N	
16110	\N	\N	\N	
16111	\N	\N	\N	
16112	\N	\N	\N	
16113	\N	\N	\N	
16114	\N	\N	\N	
16115	\N	\N	\N	
16116	\N	\N	\N	
16117	\N	\N	\N	
16118	\N	\N	\N	
16119	\N	\N	\N	
16120	\N	\N	\N	
16121	\N	\N	\N	
16122	\N	\N	\N	
16123	\N	\N	\N	
16124	\N	\N	\N	
16125	\N	\N	\N	
16126	\N	\N	\N	
16127	\N	\N	\N	
16128	\N	\N	\N	
16129	\N	\N	\N	
16130	\N	\N	\N	
16131	\N	\N	\N	
16132	\N	\N	\N	
16133	\N	\N	\N	
16134	\N	\N	\N	
16135	\N	\N	\N	
16136	\N	\N	\N	
16137	\N	\N	\N	
16138	\N	\N	\N	
16139	\N	\N	\N	
16140	\N	\N	\N	
16141	\N	\N	\N	
16142	\N	\N	\N	
16143	\N	\N	\N	
16144	\N	\N	\N	
16145	\N	\N	\N	
16146	\N	\N	\N	
16147	\N	\N	\N	
16148	\N	\N	\N	
16149	\N	\N	\N	
16150	\N	\N	\N	
16151	\N	\N	\N	
16152	\N	\N	\N	
16153	\N	\N	\N	
16154	\N	\N	\N	
16155	\N	\N	\N	
16156	\N	\N	\N	
16157	\N	\N	\N	
16158	\N	\N	\N	
16159	\N	\N	\N	
16160	\N	\N	\N	
16161	\N	\N	\N	
16162	\N	\N	\N	
16163	\N	\N	\N	
16164	\N	\N	\N	
16165	\N	\N	\N	
16166	\N	\N	\N	
16167	\N	\N	\N	
16168	\N	\N	\N	
16169	\N	\N	\N	
16170	\N	\N	\N	
16171	\N	\N	\N	
16172	\N	\N	\N	
16173	\N	\N	\N	
16174	\N	\N	\N	
16175	\N	\N	\N	
16176	\N	\N	\N	
16177	\N	\N	\N	
16178	\N	\N	\N	
16179	\N	\N	\N	
16180	\N	\N	\N	
16181	\N	\N	\N	
16182	\N	\N	\N	
16183	\N	\N	\N	
16184	\N	\N	\N	
16185	\N	\N	\N	
16186	\N	\N	\N	
16187	\N	\N	\N	
16188	\N	\N	\N	
16189	\N	\N	\N	
16190	\N	\N	\N	
16191	\N	\N	\N	
16192	\N	\N	\N	
16193	\N	\N	\N	
16194	\N	\N	\N	
16195	\N	\N	\N	
16196	\N	\N	\N	
16197	\N	\N	\N	
16198	\N	\N	\N	
16199	\N	\N	\N	
16200	\N	\N	\N	
16201	\N	\N	\N	
16202	\N	\N	\N	
16203	\N	\N	\N	
16204	\N	\N	\N	
16205	\N	\N	\N	
16206	\N	\N	\N	
16207	\N	\N	\N	
16208	\N	\N	\N	
16209	\N	\N	\N	
16210	\N	\N	\N	
16211	\N	\N	\N	
16212	\N	\N	\N	
16213	\N	\N	\N	
16214	\N	\N	\N	
16215	\N	\N	\N	
16216	\N	\N	\N	
16217	\N	\N	\N	
16218	\N	\N	\N	
16219	\N	\N	\N	
16220	\N	\N	\N	
16221	\N	\N	\N	
16222	\N	\N	\N	
16223	\N	\N	\N	
16224	\N	\N	\N	
16225	\N	\N	\N	
16226	\N	\N	\N	
16227	\N	\N	\N	
16228	\N	\N	\N	
16229	\N	\N	\N	
16230	\N	\N	\N	
16231	\N	\N	\N	
16232	\N	\N	\N	
16233	\N	\N	\N	
16234	\N	\N	\N	
16235	\N	\N	\N	
16236	\N	\N	\N	
16237	\N	\N	\N	
16238	\N	\N	\N	
16239	\N	\N	\N	
16240	\N	\N	\N	
16241	\N	\N	\N	
16242	\N	\N	\N	
16243	\N	\N	\N	
16244	\N	\N	\N	
16245	\N	\N	\N	
16246	\N	\N	\N	
16247	\N	\N	\N	
16248	\N	\N	\N	
16249	\N	\N	\N	
16250	\N	\N	\N	
16251	\N	\N	\N	
16252	\N	\N	\N	
16253	\N	\N	\N	
16254	\N	\N	\N	
16255	\N	\N	\N	
16256	\N	\N	\N	
16257	\N	\N	\N	
16258	\N	\N	\N	
16259	\N	\N	\N	
16260	\N	\N	\N	
16261	\N	\N	\N	
16262	\N	\N	\N	
16263	\N	\N	\N	
16264	\N	\N	\N	
16265	\N	\N	\N	
16266	\N	\N	\N	
16267	\N	\N	\N	
16268	\N	\N	\N	
16269	\N	\N	\N	
16270	\N	\N	\N	
16271	\N	\N	\N	
16272	\N	\N	\N	
16273	\N	\N	\N	
16274	\N	\N	\N	
16275	\N	\N	\N	
16276	\N	\N	\N	
16277	\N	\N	\N	
16278	\N	\N	\N	
16279	\N	\N	\N	
16280	\N	\N	\N	
16281	\N	\N	\N	
16282	\N	\N	\N	
16283	\N	\N	\N	
16284	\N	\N	\N	
16285	\N	\N	\N	
16286	\N	\N	\N	
16287	\N	\N	\N	
16288	\N	\N	\N	
16289	\N	\N	\N	
16290	\N	\N	\N	
16291	\N	\N	\N	
16292	\N	\N	\N	
16293	\N	\N	\N	
16294	\N	\N	\N	
16295	\N	\N	\N	
16296	\N	\N	\N	
16297	\N	\N	\N	
16298	\N	\N	\N	
16299	\N	\N	\N	
16300	\N	\N	\N	
16301	\N	\N	\N	
16302	\N	\N	\N	
16303	\N	\N	\N	
16304	\N	\N	\N	
16305	\N	\N	\N	
16306	\N	\N	\N	
16307	\N	\N	\N	
16308	\N	\N	\N	
16309	\N	\N	\N	
16310	\N	\N	\N	
16311	\N	\N	\N	
16312	\N	\N	\N	
16313	\N	\N	\N	
16314	\N	\N	\N	
16315	\N	\N	\N	
16316	\N	\N	\N	
16317	\N	\N	\N	
16318	\N	\N	\N	
16319	\N	\N	\N	
16320	\N	\N	\N	
16321	\N	\N	\N	
16322	\N	\N	\N	
16323	\N	\N	\N	
16324	\N	\N	\N	
16325	\N	\N	\N	
16326	\N	\N	\N	
16327	\N	\N	\N	
16328	\N	\N	\N	
16329	\N	\N	\N	
16330	\N	\N	\N	
16331	\N	\N	\N	
16332	\N	\N	\N	
16333	\N	\N	\N	
16334	\N	\N	\N	
16335	\N	\N	\N	
16336	\N	\N	\N	
16337	\N	\N	\N	
16338	\N	\N	\N	
16339	\N	\N	\N	
16340	\N	\N	\N	
16341	\N	\N	\N	
16342	\N	\N	\N	
16343	\N	\N	\N	
16344	\N	\N	\N	
16345	\N	\N	\N	
16346	\N	\N	\N	
16347	\N	\N	\N	
16348	\N	\N	\N	
16349	\N	\N	\N	
16350	\N	\N	\N	
16351	\N	\N	\N	
16352	\N	\N	\N	
16353	\N	\N	\N	
16354	\N	\N	\N	
16355	\N	\N	\N	
16356	\N	\N	\N	
16357	\N	\N	\N	
16358	\N	\N	\N	
16359	\N	\N	\N	
16360	\N	\N	\N	
16361	\N	\N	\N	
16362	\N	\N	\N	
16363	\N	\N	\N	
16364	\N	\N	\N	
16365	\N	\N	\N	
16366	\N	\N	\N	
16367	\N	\N	\N	
16368	\N	\N	\N	
16369	\N	\N	\N	
16370	\N	\N	\N	
16371	\N	\N	\N	
16372	\N	\N	\N	
16373	\N	\N	\N	
16374	\N	\N	\N	
16375	\N	\N	\N	
16376	\N	\N	\N	
16377	\N	\N	\N	
16378	\N	\N	\N	
16379	\N	\N	\N	
16380	\N	\N	\N	
16381	\N	\N	\N	
16382	\N	\N	\N	
16383	\N	\N	\N	
16384	\N	\N	\N	
16385	\N	\N	\N	
16386	\N	\N	\N	
16387	\N	\N	\N	
16388	\N	\N	\N	
16389	\N	\N	\N	
16390	\N	\N	\N	
16391	\N	\N	\N	
16392	\N	\N	\N	
16393	\N	\N	\N	
16394	\N	\N	\N	
16395	\N	\N	\N	
16396	\N	\N	\N	
16397	\N	\N	\N	
16398	\N	\N	\N	
16399	\N	\N	\N	
16400	\N	\N	\N	
16401	\N	\N	\N	
16402	\N	\N	\N	
16403	\N	\N	\N	
16404	\N	\N	\N	
16405	\N	\N	\N	
16406	\N	\N	\N	
16407	\N	\N	\N	
16408	\N	\N	\N	
16409	\N	\N	\N	
16410	\N	\N	\N	
16411	\N	\N	\N	
16412	\N	\N	\N	
16413	\N	\N	\N	
16414	\N	\N	\N	
16415	\N	\N	\N	
16416	\N	\N	\N	
16417	\N	\N	\N	
16418	\N	\N	\N	
16419	\N	\N	\N	
16420	\N	\N	\N	
16421	\N	\N	\N	
16422	\N	\N	\N	
16423	\N	\N	\N	
16424	\N	\N	\N	
16425	\N	\N	\N	
16426	\N	\N	\N	
16427	\N	\N	\N	
16428	\N	\N	\N	
16429	\N	\N	\N	
16430	\N	\N	\N	
16431	\N	\N	\N	
16432	\N	\N	\N	
16433	\N	\N	\N	
16434	\N	\N	\N	
16435	\N	\N	\N	
16436	\N	\N	\N	
16437	\N	\N	\N	
16438	\N	\N	\N	
16439	\N	\N	\N	
16440	\N	\N	\N	
16441	\N	\N	\N	
16442	\N	\N	\N	
16443	\N	\N	\N	
16444	\N	\N	\N	
16445	\N	\N	\N	
16446	\N	\N	\N	
16447	\N	\N	\N	
16448	\N	\N	\N	
16449	\N	\N	\N	
16450	\N	\N	\N	
16451	\N	\N	\N	
16452	\N	\N	\N	
16453	\N	\N	\N	
16454	\N	\N	\N	
16455	\N	\N	\N	
16456	\N	\N	\N	
16457	\N	\N	\N	
16458	\N	\N	\N	
16459	\N	\N	\N	
16460	\N	\N	\N	
16461	\N	\N	\N	
16462	\N	\N	\N	
16463	\N	\N	\N	
16464	\N	\N	\N	
16465	\N	\N	\N	
16466	\N	\N	\N	
16467	\N	\N	\N	
16468	\N	\N	\N	
16469	\N	\N	\N	
16470	\N	\N	\N	
16471	\N	\N	\N	
16472	\N	\N	\N	
16473	\N	\N	\N	
16474	\N	\N	\N	
16475	\N	\N	\N	
16476	\N	\N	\N	
16477	\N	\N	\N	
16478	\N	\N	\N	
16479	\N	\N	\N	
16480	\N	\N	\N	
16481	\N	\N	\N	
16482	\N	\N	\N	
16483	\N	\N	\N	
16484	\N	\N	\N	
16485	\N	\N	\N	
16486	\N	\N	\N	
16487	\N	\N	\N	
16488	\N	\N	\N	
16489	\N	\N	\N	
16490	\N	\N	\N	
16491	\N	\N	\N	
16492	\N	\N	\N	
16493	\N	\N	\N	
16494	\N	\N	\N	
16495	\N	\N	\N	
16496	\N	\N	\N	
16497	\N	\N	\N	
16498	\N	\N	\N	
16499	\N	\N	\N	
16500	\N	\N	\N	
16501	\N	\N	\N	
16502	\N	\N	\N	
16503	\N	\N	\N	
16504	\N	\N	\N	
16505	\N	\N	\N	
16506	\N	\N	\N	
16507	\N	\N	\N	
16508	\N	\N	\N	
16509	\N	\N	\N	
16510	\N	\N	\N	
16511	\N	\N	\N	
16512	\N	\N	\N	
16513	\N	\N	\N	
16514	\N	\N	\N	
16515	\N	\N	\N	
16516	\N	\N	\N	
16517	\N	\N	\N	
16518	\N	\N	\N	
16519	\N	\N	\N	
16520	\N	\N	\N	
16521	\N	\N	\N	
16522	\N	\N	\N	
16523	\N	\N	\N	
16524	\N	\N	\N	
16525	\N	\N	\N	
16526	\N	\N	\N	
16527	\N	\N	\N	
16528	\N	\N	\N	
16529	\N	\N	\N	
16530	\N	\N	\N	
16531	\N	\N	\N	
16532	\N	\N	\N	
16533	\N	\N	\N	
16534	\N	\N	\N	
16535	\N	\N	\N	
16536	\N	\N	\N	
16537	\N	\N	\N	
16538	\N	\N	\N	
16539	\N	\N	\N	
16540	\N	\N	\N	
16541	\N	\N	\N	
16542	\N	\N	\N	
16543	\N	\N	\N	
16544	\N	\N	\N	
16545	\N	\N	\N	
16546	\N	\N	\N	
16547	\N	\N	\N	
16548	\N	\N	\N	
16549	\N	\N	\N	
16550	\N	\N	\N	
16551	\N	\N	\N	
16552	\N	\N	\N	
16553	\N	\N	\N	
16554	\N	\N	\N	
16555	\N	\N	\N	
16556	\N	\N	\N	
16557	\N	\N	\N	
16558	\N	\N	\N	
16559	\N	\N	\N	
16560	\N	\N	\N	
16561	\N	\N	\N	
16562	\N	\N	\N	
16563	\N	\N	\N	
16564	\N	\N	\N	
16565	\N	\N	\N	
16566	\N	\N	\N	
16567	\N	\N	\N	
16568	\N	\N	\N	
16569	\N	\N	\N	
16570	\N	\N	\N	
16571	\N	\N	\N	
16572	\N	\N	\N	
16573	\N	\N	\N	
16574	\N	\N	\N	
16575	\N	\N	\N	
16576	\N	\N	\N	
16577	\N	\N	\N	
16578	\N	\N	\N	
16579	\N	\N	\N	
16580	\N	\N	\N	
16581	\N	\N	\N	
16582	\N	\N	\N	
16583	\N	\N	\N	
16584	\N	\N	\N	
16585	\N	\N	\N	
16586	\N	\N	\N	
16587	\N	\N	\N	
16588	\N	\N	\N	
16589	\N	\N	\N	
16590	\N	\N	\N	
16591	\N	\N	\N	
16592	\N	\N	\N	
16593	\N	\N	\N	
16594	\N	\N	\N	
16595	\N	\N	\N	
16596	\N	\N	\N	
16597	\N	\N	\N	
16598	\N	\N	\N	
16599	\N	\N	\N	
16600	\N	\N	\N	
16601	\N	\N	\N	
16602	\N	\N	\N	
16603	\N	\N	\N	
16604	\N	\N	\N	
16605	\N	\N	\N	
16606	\N	\N	\N	
16607	\N	\N	\N	
16608	\N	\N	\N	
16609	\N	\N	\N	
16610	\N	\N	\N	
16611	\N	\N	\N	
16612	\N	\N	\N	
16613	\N	\N	\N	
16614	\N	\N	\N	
16615	\N	\N	\N	
16616	\N	\N	\N	
16617	\N	\N	\N	
16618	\N	\N	\N	
16619	\N	\N	\N	
16620	\N	\N	\N	
16621	\N	\N	\N	
16622	\N	\N	\N	
16623	\N	\N	\N	
16624	\N	\N	\N	
16625	\N	\N	\N	
16626	\N	\N	\N	
16627	\N	\N	\N	
16628	\N	\N	\N	
16629	\N	\N	\N	
16630	\N	\N	\N	
16631	\N	\N	\N	
16632	\N	\N	\N	
16633	\N	\N	\N	
16634	\N	\N	\N	
16635	\N	\N	\N	
16636	\N	\N	\N	
16637	\N	\N	\N	
16638	\N	\N	\N	
16639	\N	\N	\N	
16640	\N	\N	\N	
16641	\N	\N	\N	
16642	\N	\N	\N	
16643	\N	\N	\N	
16644	\N	\N	\N	
16645	\N	\N	\N	
16646	\N	\N	\N	
16647	\N	\N	\N	
16648	\N	\N	\N	
16649	\N	\N	\N	
16650	\N	\N	\N	
16651	\N	\N	\N	
16652	\N	\N	\N	
16653	\N	\N	\N	
16654	\N	\N	\N	
16655	\N	\N	\N	
16656	\N	\N	\N	
16657	\N	\N	\N	
16658	\N	\N	\N	
16659	\N	\N	\N	
16660	\N	\N	\N	
16661	\N	\N	\N	
16662	\N	\N	\N	
16663	\N	\N	\N	
16664	\N	\N	\N	
16665	\N	\N	\N	
16666	\N	\N	\N	
16667	\N	\N	\N	
16668	\N	\N	\N	
16669	\N	\N	\N	
16670	\N	\N	\N	
16671	\N	\N	\N	
16672	\N	\N	\N	
16673	\N	\N	\N	
16674	\N	\N	\N	
16675	\N	\N	\N	
16676	\N	\N	\N	
16677	\N	\N	\N	
16678	\N	\N	\N	
16679	\N	\N	\N	
16680	\N	\N	\N	
16681	\N	\N	\N	
16682	\N	\N	\N	
16683	\N	\N	\N	
16684	\N	\N	\N	
16685	\N	\N	\N	
16686	\N	\N	\N	
16687	\N	\N	\N	
16688	\N	\N	\N	
16689	\N	\N	\N	
16690	\N	\N	\N	
16691	\N	\N	\N	
16692	\N	\N	\N	
16693	\N	\N	\N	
16694	\N	\N	\N	
16695	\N	\N	\N	
16696	\N	\N	\N	
16697	\N	\N	\N	
16698	\N	\N	\N	
16699	\N	\N	\N	
16700	\N	\N	\N	
16701	\N	\N	\N	
16702	\N	\N	\N	
16703	\N	\N	\N	
16704	\N	\N	\N	
16705	\N	\N	\N	
16706	\N	\N	\N	
16707	\N	\N	\N	
16708	\N	\N	\N	
16709	\N	\N	\N	
16710	\N	\N	\N	
16711	\N	\N	\N	
16712	\N	\N	\N	
16713	\N	\N	\N	
16714	\N	\N	\N	
16715	\N	\N	\N	
16716	\N	\N	\N	
16717	\N	\N	\N	
16718	\N	\N	\N	
16719	\N	\N	\N	
16720	\N	\N	\N	
16721	\N	\N	\N	
16722	\N	\N	\N	
16723	\N	\N	\N	
16724	\N	\N	\N	
16725	\N	\N	\N	
16726	\N	\N	\N	
16727	\N	\N	\N	
16728	\N	\N	\N	
16729	\N	\N	\N	
16730	\N	\N	\N	
16731	\N	\N	\N	
16732	\N	\N	\N	
16733	\N	\N	\N	
16734	\N	\N	\N	
16735	\N	\N	\N	
16736	\N	\N	\N	
16737	\N	\N	\N	
16738	\N	\N	\N	
16739	\N	\N	\N	
16740	\N	\N	\N	
16741	\N	\N	\N	
16742	\N	\N	\N	
16743	\N	\N	\N	
16744	\N	\N	\N	
16745	\N	\N	\N	
16746	\N	\N	\N	
16747	\N	\N	\N	
16748	\N	\N	\N	
16749	\N	\N	\N	
16750	\N	\N	\N	
16751	\N	\N	\N	
16752	\N	\N	\N	
16753	\N	\N	\N	
16754	\N	\N	\N	
16755	\N	\N	\N	
16756	\N	\N	\N	
16757	\N	\N	\N	
16758	\N	\N	\N	
16759	\N	\N	\N	
16760	\N	\N	\N	
16761	\N	\N	\N	
16762	\N	\N	\N	
16763	\N	\N	\N	
16764	\N	\N	\N	
16765	\N	\N	\N	
16766	\N	\N	\N	
16767	\N	\N	\N	
16768	\N	\N	\N	
16769	\N	\N	\N	
16770	\N	\N	\N	
16771	\N	\N	\N	
16772	\N	\N	\N	
16773	\N	\N	\N	
16774	\N	\N	\N	
16775	\N	\N	\N	
16776	\N	\N	\N	
16777	\N	\N	\N	
16778	\N	\N	\N	
16779	\N	\N	\N	
16780	\N	\N	\N	
16781	\N	\N	\N	
16782	\N	\N	\N	
16783	\N	\N	\N	
16784	\N	\N	\N	
16785	\N	\N	\N	
16786	\N	\N	\N	
16787	\N	\N	\N	
16788	\N	\N	\N	
16789	\N	\N	\N	
16790	\N	\N	\N	
16791	\N	\N	\N	
16792	\N	\N	\N	
16793	\N	\N	\N	
16794	\N	\N	\N	
16795	\N	\N	\N	
16796	\N	\N	\N	
16797	\N	\N	\N	
16798	\N	\N	\N	
16799	\N	\N	\N	
16800	\N	\N	\N	
16801	\N	\N	\N	
16802	\N	\N	\N	
16803	\N	\N	\N	
16804	\N	\N	\N	
16805	\N	\N	\N	
16806	\N	\N	\N	
16807	\N	\N	\N	
16808	\N	\N	\N	
16809	\N	\N	\N	
16810	\N	\N	\N	
16811	\N	\N	\N	
16812	\N	\N	\N	
16813	\N	\N	\N	
16814	\N	\N	\N	
16815	\N	\N	\N	
16816	\N	\N	\N	
16817	\N	\N	\N	
16818	\N	\N	\N	
16819	\N	\N	\N	
16820	\N	\N	\N	
16821	\N	\N	\N	
16822	\N	\N	\N	
16823	\N	\N	\N	
16824	\N	\N	\N	
16825	\N	\N	\N	
16826	\N	\N	\N	
16827	\N	\N	\N	
16828	\N	\N	\N	
16829	\N	\N	\N	
16830	\N	\N	\N	
16831	\N	\N	\N	
16832	\N	\N	\N	
16833	\N	\N	\N	
16834	\N	\N	\N	
16835	\N	\N	\N	
16836	\N	\N	\N	
16837	\N	\N	\N	
16838	\N	\N	\N	
16839	\N	\N	\N	
16840	\N	\N	\N	
16841	\N	\N	\N	
16842	\N	\N	\N	
16843	\N	\N	\N	
16844	\N	\N	\N	
16845	\N	\N	\N	
16846	\N	\N	\N	
16847	\N	\N	\N	
16848	\N	\N	\N	
16849	\N	\N	\N	
16850	\N	\N	\N	
16851	\N	\N	\N	
16852	\N	\N	\N	
16853	\N	\N	\N	
16854	\N	\N	\N	
16855	\N	\N	\N	
16856	\N	\N	\N	
16857	\N	\N	\N	
16858	\N	\N	\N	
16859	\N	\N	\N	
16860	\N	\N	\N	
16861	\N	\N	\N	
16862	\N	\N	\N	
16863	\N	\N	\N	
16864	\N	\N	\N	
16865	\N	\N	\N	
16866	\N	\N	\N	
16867	\N	\N	\N	
16868	\N	\N	\N	
16869	\N	\N	\N	
16870	\N	\N	\N	
16871	\N	\N	\N	
16872	\N	\N	\N	
16873	\N	\N	\N	
16874	\N	\N	\N	
16875	\N	\N	\N	
16876	\N	\N	\N	
16877	\N	\N	\N	
16878	\N	\N	\N	
16879	\N	\N	\N	
16880	\N	\N	\N	
16881	\N	\N	\N	
16882	\N	\N	\N	
16883	\N	\N	\N	
16884	\N	\N	\N	
16885	\N	\N	\N	
16886	\N	\N	\N	
16887	\N	\N	\N	
16888	\N	\N	\N	
16889	\N	\N	\N	
16890	\N	\N	\N	
16891	\N	\N	\N	
16892	\N	\N	\N	
16893	\N	\N	\N	
16894	\N	\N	\N	
16895	\N	\N	\N	
16896	\N	\N	\N	
16897	\N	\N	\N	
16898	\N	\N	\N	
16899	\N	\N	\N	
16900	\N	\N	\N	
16901	\N	\N	\N	
16902	\N	\N	\N	
16903	\N	\N	\N	
16904	\N	\N	\N	
16905	\N	\N	\N	
16906	\N	\N	\N	
16907	\N	\N	\N	
16908	\N	\N	\N	
16909	\N	\N	\N	
16910	\N	\N	\N	
16911	\N	\N	\N	
16912	\N	\N	\N	
16913	\N	\N	\N	
16914	\N	\N	\N	
16915	\N	\N	\N	
16916	\N	\N	\N	
16917	\N	\N	\N	
16918	\N	\N	\N	
16919	\N	\N	\N	
16920	\N	\N	\N	
16921	\N	\N	\N	
16922	\N	\N	\N	
16923	\N	\N	\N	
16924	\N	\N	\N	
16925	\N	\N	\N	
16926	\N	\N	\N	
16927	\N	\N	\N	
16928	\N	\N	\N	
16929	\N	\N	\N	
16930	\N	\N	\N	
16931	\N	\N	\N	
16932	\N	\N	\N	
16933	\N	\N	\N	
16934	\N	\N	\N	
16935	\N	\N	\N	
16936	\N	\N	\N	
16937	\N	\N	\N	
16938	\N	\N	\N	
16939	\N	\N	\N	
16940	\N	\N	\N	
16941	\N	\N	\N	
16942	\N	\N	\N	
16943	\N	\N	\N	
16944	\N	\N	\N	
16945	\N	\N	\N	
16946	\N	\N	\N	
16947	\N	\N	\N	
16948	\N	\N	\N	
16949	\N	\N	\N	
16950	\N	\N	\N	
16951	\N	\N	\N	
16952	\N	\N	\N	
16953	\N	\N	\N	
16954	\N	\N	\N	
16955	\N	\N	\N	
16956	\N	\N	\N	
16957	\N	\N	\N	
16958	\N	\N	\N	
16959	\N	\N	\N	
16960	\N	\N	\N	
16961	\N	\N	\N	
16962	\N	\N	\N	
16963	\N	\N	\N	
16964	\N	\N	\N	
16965	\N	\N	\N	
16966	\N	\N	\N	
16967	\N	\N	\N	
16968	\N	\N	\N	
16969	\N	\N	\N	
16970	\N	\N	\N	
16971	\N	\N	\N	
16972	\N	\N	\N	
16973	\N	\N	\N	
16974	\N	\N	\N	
16975	\N	\N	\N	
16976	\N	\N	\N	
16977	\N	\N	\N	
16978	\N	\N	\N	
16979	\N	\N	\N	
16980	\N	\N	\N	
16981	\N	\N	\N	
16982	\N	\N	\N	
16983	\N	\N	\N	
16984	\N	\N	\N	
16985	\N	\N	\N	
16986	\N	\N	\N	
16987	\N	\N	\N	
16988	\N	\N	\N	
16989	\N	\N	\N	
16990	\N	\N	\N	
16991	\N	\N	\N	
16992	\N	\N	\N	
16993	\N	\N	\N	
16994	\N	\N	\N	
16995	\N	\N	\N	
16996	\N	\N	\N	
16997	\N	\N	\N	
16998	\N	\N	\N	
16999	\N	\N	\N	
17000	\N	\N	\N	
17001	\N	\N	\N	
17002	\N	\N	\N	
17003	\N	\N	\N	
17004	\N	\N	\N	
17005	\N	\N	\N	
17006	\N	\N	\N	
17007	\N	\N	\N	
17008	\N	\N	\N	
17009	\N	\N	\N	
17010	\N	\N	\N	
17011	\N	\N	\N	
17012	\N	\N	\N	
17013	\N	\N	\N	
17014	\N	\N	\N	
17015	\N	\N	\N	
17016	\N	\N	\N	
17017	\N	\N	\N	
17018	\N	\N	\N	
17019	\N	\N	\N	
17020	\N	\N	\N	
17021	\N	\N	\N	
17022	\N	\N	\N	
17023	\N	\N	\N	
17024	\N	\N	\N	
17025	\N	\N	\N	
17026	\N	\N	\N	
17027	\N	\N	\N	
17028	\N	\N	\N	
17029	\N	\N	\N	
17030	\N	\N	\N	
17031	\N	\N	\N	
17032	\N	\N	\N	
17033	\N	\N	\N	
17034	\N	\N	\N	
17035	\N	\N	\N	
17036	\N	\N	\N	
17037	\N	\N	\N	
17038	\N	\N	\N	
17039	\N	\N	\N	
17040	\N	\N	\N	
17041	\N	\N	\N	
17042	\N	\N	\N	
17043	\N	\N	\N	
17044	\N	\N	\N	
17045	\N	\N	\N	
17046	\N	\N	\N	
17047	\N	\N	\N	
17048	\N	\N	\N	
17049	\N	\N	\N	
17050	\N	\N	\N	
17051	\N	\N	\N	
17052	\N	\N	\N	
17053	\N	\N	\N	
17054	\N	\N	\N	
17055	\N	\N	\N	
17056	\N	\N	\N	
17057	\N	\N	\N	
17058	\N	\N	\N	
17059	\N	\N	\N	
17060	\N	\N	\N	
17061	\N	\N	\N	
17062	\N	\N	\N	
17063	\N	\N	\N	
17064	\N	\N	\N	
17065	\N	\N	\N	
17066	\N	\N	\N	
17067	\N	\N	\N	
17068	\N	\N	\N	
17069	\N	\N	\N	
17070	\N	\N	\N	
17071	\N	\N	\N	
17072	\N	\N	\N	
17073	\N	\N	\N	
17074	\N	\N	\N	
17075	\N	\N	\N	
17076	\N	\N	\N	
17077	\N	\N	\N	
17078	\N	\N	\N	
17079	\N	\N	\N	
17080	\N	\N	\N	
17081	\N	\N	\N	
17082	\N	\N	\N	
17083	\N	\N	\N	
17084	\N	\N	\N	
17085	\N	\N	\N	
17086	\N	\N	\N	
17087	\N	\N	\N	
17088	\N	\N	\N	
17089	\N	\N	\N	
17090	\N	\N	\N	
17091	\N	\N	\N	
17092	\N	\N	\N	
17093	\N	\N	\N	
17094	\N	\N	\N	
17095	\N	\N	\N	
17096	\N	\N	\N	
17097	\N	\N	\N	
17098	\N	\N	\N	
17099	\N	\N	\N	
17100	\N	\N	\N	
17101	\N	\N	\N	
17102	\N	\N	\N	
17103	\N	\N	\N	
17104	\N	\N	\N	
17105	\N	\N	\N	
17106	\N	\N	\N	
17107	\N	\N	\N	
17108	\N	\N	\N	
17109	\N	\N	\N	
17110	\N	\N	\N	
17111	\N	\N	\N	
17112	\N	\N	\N	
17113	\N	\N	\N	
17114	\N	\N	\N	
17115	\N	\N	\N	
17116	\N	\N	\N	
17117	\N	\N	\N	
17118	\N	\N	\N	
17119	\N	\N	\N	
17120	\N	\N	\N	
17121	\N	\N	\N	
17122	\N	\N	\N	
17123	\N	\N	\N	
17124	\N	\N	\N	
17125	\N	\N	\N	
17126	\N	\N	\N	
17127	\N	\N	\N	
17128	\N	\N	\N	
17129	\N	\N	\N	
17130	\N	\N	\N	
17131	\N	\N	\N	
17132	\N	\N	\N	
17133	\N	\N	\N	
17134	\N	\N	\N	
17135	\N	\N	\N	
17136	\N	\N	\N	
17137	\N	\N	\N	
17138	\N	\N	\N	
17139	\N	\N	\N	
17140	\N	\N	\N	
17141	\N	\N	\N	
17142	\N	\N	\N	
17143	\N	\N	\N	
17144	\N	\N	\N	
17145	\N	\N	\N	
17146	\N	\N	\N	
17147	\N	\N	\N	
17148	\N	\N	\N	
17149	\N	\N	\N	
17150	\N	\N	\N	
17151	\N	\N	\N	
17152	\N	\N	\N	
17153	\N	\N	\N	
17154	\N	\N	\N	
17155	\N	\N	\N	
17156	\N	\N	\N	
17157	\N	\N	\N	
17158	\N	\N	\N	
17159	\N	\N	\N	
17160	\N	\N	\N	
17161	\N	\N	\N	
17162	\N	\N	\N	
17163	\N	\N	\N	
17164	\N	\N	\N	
17165	\N	\N	\N	
17166	\N	\N	\N	
17167	\N	\N	\N	
17168	\N	\N	\N	
17169	\N	\N	\N	
17170	\N	\N	\N	
17171	\N	\N	\N	
17172	\N	\N	\N	
17173	\N	\N	\N	
17174	\N	\N	\N	
17175	\N	\N	\N	
17176	\N	\N	\N	
17177	\N	\N	\N	
17178	\N	\N	\N	
17179	\N	\N	\N	
17180	\N	\N	\N	
17181	\N	\N	\N	
17182	\N	\N	\N	
17183	\N	\N	\N	
17184	\N	\N	\N	
17185	\N	\N	\N	
17186	\N	\N	\N	
17187	\N	\N	\N	
17188	\N	\N	\N	
17189	\N	\N	\N	
17190	\N	\N	\N	
17191	\N	\N	\N	
17192	\N	\N	\N	
17193	\N	\N	\N	
17194	\N	\N	\N	
17195	\N	\N	\N	
17196	\N	\N	\N	
17197	\N	\N	\N	
17198	\N	\N	\N	
17199	\N	\N	\N	
17200	\N	\N	\N	
17201	\N	\N	\N	
17202	\N	\N	\N	
17203	\N	\N	\N	
17204	\N	\N	\N	
17205	\N	\N	\N	
17206	\N	\N	\N	
17207	\N	\N	\N	
17208	\N	\N	\N	
17209	\N	\N	\N	
17210	\N	\N	\N	
17211	\N	\N	\N	
17212	\N	\N	\N	
17213	\N	\N	\N	
17214	\N	\N	\N	
17215	\N	\N	\N	
17216	\N	\N	\N	
17217	\N	\N	\N	
17218	\N	\N	\N	
17219	\N	\N	\N	
17220	\N	\N	\N	
17221	\N	\N	\N	
17222	\N	\N	\N	
17223	\N	\N	\N	
17224	\N	\N	\N	
17225	\N	\N	\N	
17226	\N	\N	\N	
17227	\N	\N	\N	
17228	\N	\N	\N	
17229	\N	\N	\N	
17230	\N	\N	\N	
17231	\N	\N	\N	
17232	\N	\N	\N	
17233	\N	\N	\N	
17234	\N	\N	\N	
17235	\N	\N	\N	
17236	\N	\N	\N	
17237	\N	\N	\N	
17238	\N	\N	\N	
17239	\N	\N	\N	
17240	\N	\N	\N	
17241	\N	\N	\N	
17242	\N	\N	\N	
17243	\N	\N	\N	
17244	\N	\N	\N	
17245	\N	\N	\N	
17246	\N	\N	\N	
17247	\N	\N	\N	
17248	\N	\N	\N	
17249	\N	\N	\N	
17250	\N	\N	\N	
17251	\N	\N	\N	
17252	\N	\N	\N	
17253	\N	\N	\N	
17254	\N	\N	\N	
17255	\N	\N	\N	
17256	\N	\N	\N	
17257	\N	\N	\N	
17258	\N	\N	\N	
17259	\N	\N	\N	
17260	\N	\N	\N	
17261	\N	\N	\N	
17262	\N	\N	\N	
17263	\N	\N	\N	
17264	\N	\N	\N	
17265	\N	\N	\N	
17266	\N	\N	\N	
17267	\N	\N	\N	
17268	\N	\N	\N	
17269	\N	\N	\N	
17270	\N	\N	\N	
17271	\N	\N	\N	
17272	\N	\N	\N	
17273	\N	\N	\N	
17274	\N	\N	\N	
17275	\N	\N	\N	
17276	\N	\N	\N	
17277	\N	\N	\N	
17278	\N	\N	\N	
17279	\N	\N	\N	
17280	\N	\N	\N	
17281	\N	\N	\N	
17282	\N	\N	\N	
17283	\N	\N	\N	
17284	\N	\N	\N	
17285	\N	\N	\N	
17286	\N	\N	\N	
17287	\N	\N	\N	
17288	\N	\N	\N	
17289	\N	\N	\N	
17290	\N	\N	\N	
17291	\N	\N	\N	
17292	\N	\N	\N	
17293	\N	\N	\N	
17294	\N	\N	\N	
17295	\N	\N	\N	
17296	\N	\N	\N	
17297	\N	\N	\N	
17298	\N	\N	\N	
17299	\N	\N	\N	
17300	\N	\N	\N	
17301	\N	\N	\N	
17302	\N	\N	\N	
17303	\N	\N	\N	
17304	\N	\N	\N	
17305	\N	\N	\N	
17306	\N	\N	\N	
17307	\N	\N	\N	
17308	\N	\N	\N	
17309	\N	\N	\N	
17310	\N	\N	\N	
17311	\N	\N	\N	
17312	\N	\N	\N	
17313	\N	\N	\N	
17314	\N	\N	\N	
17315	\N	\N	\N	
17316	\N	\N	\N	
17317	\N	\N	\N	
17318	\N	\N	\N	
17319	\N	\N	\N	
17320	\N	\N	\N	
17321	\N	\N	\N	
17322	\N	\N	\N	
17323	\N	\N	\N	
17324	\N	\N	\N	
17325	\N	\N	\N	
17326	\N	\N	\N	
17327	\N	\N	\N	
17328	\N	\N	\N	
17329	\N	\N	\N	
17330	\N	\N	\N	
17331	\N	\N	\N	
17332	\N	\N	\N	
17333	\N	\N	\N	
17334	\N	\N	\N	
17335	\N	\N	\N	
17336	\N	\N	\N	
17337	\N	\N	\N	
17338	\N	\N	\N	
17339	\N	\N	\N	
17340	\N	\N	\N	
17341	\N	\N	\N	
17342	\N	\N	\N	
17343	\N	\N	\N	
17344	\N	\N	\N	
17345	\N	\N	\N	
17346	\N	\N	\N	
17347	\N	\N	\N	
17348	\N	\N	\N	
17349	\N	\N	\N	
17350	\N	\N	\N	
17351	\N	\N	\N	
17352	\N	\N	\N	
17353	\N	\N	\N	
17354	\N	\N	\N	
17355	\N	\N	\N	
17356	\N	\N	\N	
17357	\N	\N	\N	
17358	\N	\N	\N	
17359	\N	\N	\N	
17360	\N	\N	\N	
17361	\N	\N	\N	
17362	\N	\N	\N	
17363	\N	\N	\N	
17364	\N	\N	\N	
17365	\N	\N	\N	
17366	\N	\N	\N	
17367	\N	\N	\N	
17368	\N	\N	\N	
17369	\N	\N	\N	
17370	\N	\N	\N	
17371	\N	\N	\N	
17372	\N	\N	\N	
17373	\N	\N	\N	
17374	\N	\N	\N	
17375	\N	\N	\N	
17376	\N	\N	\N	
17377	\N	\N	\N	
17378	\N	\N	\N	
17379	\N	\N	\N	
17380	\N	\N	\N	
17381	\N	\N	\N	
17382	\N	\N	\N	
17383	\N	\N	\N	
17384	\N	\N	\N	
17385	\N	\N	\N	
17386	\N	\N	\N	
17387	\N	\N	\N	
17388	\N	\N	\N	
17389	\N	\N	\N	
17390	\N	\N	\N	
17391	\N	\N	\N	
17392	\N	\N	\N	
17393	\N	\N	\N	
17394	\N	\N	\N	
17395	\N	\N	\N	
17396	\N	\N	\N	
17397	\N	\N	\N	
17398	\N	\N	\N	
17399	\N	\N	\N	
17400	\N	\N	\N	
17401	\N	\N	\N	
17402	\N	\N	\N	
17403	\N	\N	\N	
17404	\N	\N	\N	
17405	\N	\N	\N	
17406	\N	\N	\N	
17407	\N	\N	\N	
17408	\N	\N	\N	
17409	\N	\N	\N	
17410	\N	\N	\N	
17411	\N	\N	\N	
17412	\N	\N	\N	
17413	\N	\N	\N	
17414	\N	\N	\N	
17415	\N	\N	\N	
17416	\N	\N	\N	
17417	\N	\N	\N	
17418	\N	\N	\N	
17419	\N	\N	\N	
17420	\N	\N	\N	
17421	\N	\N	\N	
17422	\N	\N	\N	
17423	\N	\N	\N	
17424	\N	\N	\N	
17425	\N	\N	\N	
17426	\N	\N	\N	
17427	\N	\N	\N	
17428	\N	\N	\N	
17429	\N	\N	\N	
17430	\N	\N	\N	
17431	\N	\N	\N	
17432	\N	\N	\N	
17433	\N	\N	\N	
17434	\N	\N	\N	
17435	\N	\N	\N	
17436	\N	\N	\N	
17437	\N	\N	\N	
17438	\N	\N	\N	
17439	\N	\N	\N	
17440	\N	\N	\N	
17441	\N	\N	\N	
17442	\N	\N	\N	
17443	\N	\N	\N	
17444	\N	\N	\N	
17445	\N	\N	\N	
17446	\N	\N	\N	
17447	\N	\N	\N	
17448	\N	\N	\N	
17449	\N	\N	\N	
17450	\N	\N	\N	
17451	\N	\N	\N	
17452	\N	\N	\N	
17453	\N	\N	\N	
17454	\N	\N	\N	
17455	\N	\N	\N	
17456	\N	\N	\N	
17457	\N	\N	\N	
17458	\N	\N	\N	
17459	\N	\N	\N	
17460	\N	\N	\N	
17461	\N	\N	\N	
17462	\N	\N	\N	
17463	\N	\N	\N	
17464	\N	\N	\N	
17465	\N	\N	\N	
17466	\N	\N	\N	
17467	\N	\N	\N	
17468	\N	\N	\N	
17469	\N	\N	\N	
17470	\N	\N	\N	
17471	\N	\N	\N	
17472	\N	\N	\N	
17473	\N	\N	\N	
17474	\N	\N	\N	
17475	\N	\N	\N	
17476	\N	\N	\N	
17477	\N	\N	\N	
17478	\N	\N	\N	
17479	\N	\N	\N	
17480	\N	\N	\N	
17481	\N	\N	\N	
17482	\N	\N	\N	
17483	\N	\N	\N	
17484	\N	\N	\N	
17485	\N	\N	\N	
17486	\N	\N	\N	
17487	\N	\N	\N	
17488	\N	\N	\N	
17489	\N	\N	\N	
17490	\N	\N	\N	
17491	\N	\N	\N	
17492	\N	\N	\N	
17493	\N	\N	\N	
17494	\N	\N	\N	
17495	\N	\N	\N	
17496	\N	\N	\N	
17497	\N	\N	\N	
17498	\N	\N	\N	
17499	\N	\N	\N	
17500	\N	\N	\N	
17501	\N	\N	\N	
17502	\N	\N	\N	
17503	\N	\N	\N	
17504	\N	\N	\N	
17505	\N	\N	\N	
17506	\N	\N	\N	
17507	\N	\N	\N	
17508	\N	\N	\N	
17509	\N	\N	\N	
17510	\N	\N	\N	
17511	\N	\N	\N	
17512	\N	\N	\N	
17513	\N	\N	\N	
17514	\N	\N	\N	
17515	\N	\N	\N	
17516	\N	\N	\N	
17517	\N	\N	\N	
17518	\N	\N	\N	
17519	\N	\N	\N	
17520	\N	\N	\N	
17521	\N	\N	\N	
17522	\N	\N	\N	
17523	\N	\N	\N	
17524	\N	\N	\N	
17525	\N	\N	\N	
17526	\N	\N	\N	
17527	\N	\N	\N	
17528	\N	\N	\N	
17529	\N	\N	\N	
17530	\N	\N	\N	
17531	\N	\N	\N	
17532	\N	\N	\N	
17533	\N	\N	\N	
17534	\N	\N	\N	
17535	\N	\N	\N	
17536	\N	\N	\N	
17537	\N	\N	\N	
17538	\N	\N	\N	
17539	\N	\N	\N	
17540	\N	\N	\N	
17541	\N	\N	\N	
17542	\N	\N	\N	
17543	\N	\N	\N	
17544	\N	\N	\N	
17545	\N	\N	\N	
17546	\N	\N	\N	
17547	\N	\N	\N	
17548	\N	\N	\N	
17549	\N	\N	\N	
17550	\N	\N	\N	
17551	\N	\N	\N	
17552	\N	\N	\N	
17553	\N	\N	\N	
17554	\N	\N	\N	
17555	\N	\N	\N	
17556	\N	\N	\N	
17557	\N	\N	\N	
17558	\N	\N	\N	
17559	\N	\N	\N	
17560	\N	\N	\N	
17561	\N	\N	\N	
17562	\N	\N	\N	
17563	\N	\N	\N	
17564	\N	\N	\N	
17565	\N	\N	\N	
17566	\N	\N	\N	
17567	\N	\N	\N	
17568	\N	\N	\N	
17569	\N	\N	\N	
17570	\N	\N	\N	
17571	\N	\N	\N	
17572	\N	\N	\N	
17573	\N	\N	\N	
17574	\N	\N	\N	
17575	\N	\N	\N	
17576	\N	\N	\N	
17577	\N	\N	\N	
17578	\N	\N	\N	
17579	\N	\N	\N	
17580	\N	\N	\N	
17581	\N	\N	\N	
17582	\N	\N	\N	
17583	\N	\N	\N	
17584	\N	\N	\N	
17585	\N	\N	\N	
17586	\N	\N	\N	
17587	\N	\N	\N	
17588	\N	\N	\N	
17589	\N	\N	\N	
17590	\N	\N	\N	
17591	\N	\N	\N	
17592	\N	\N	\N	
17593	\N	\N	\N	
17594	\N	\N	\N	
17595	\N	\N	\N	
17596	\N	\N	\N	
17597	\N	\N	\N	
17598	\N	\N	\N	
17599	\N	\N	\N	
17600	\N	\N	\N	
17601	\N	\N	\N	
17602	\N	\N	\N	
17603	\N	\N	\N	
17604	\N	\N	\N	
17605	\N	\N	\N	
17606	\N	\N	\N	
17607	\N	\N	\N	
17608	\N	\N	\N	
17609	\N	\N	\N	
17610	\N	\N	\N	
17611	\N	\N	\N	
17612	\N	\N	\N	
17613	\N	\N	\N	
17614	\N	\N	\N	
17615	\N	\N	\N	
17616	\N	\N	\N	
17617	\N	\N	\N	
17618	\N	\N	\N	
17619	\N	\N	\N	
17620	\N	\N	\N	
17621	\N	\N	\N	
17622	\N	\N	\N	
17623	\N	\N	\N	
17624	\N	\N	\N	
17625	\N	\N	\N	
17626	\N	\N	\N	
17627	\N	\N	\N	
17628	\N	\N	\N	
17629	\N	\N	\N	
17630	\N	\N	\N	
17631	\N	\N	\N	
17632	\N	\N	\N	
17633	\N	\N	\N	
17634	\N	\N	\N	
17635	\N	\N	\N	
17636	\N	\N	\N	
17637	\N	\N	\N	
17638	\N	\N	\N	
17639	\N	\N	\N	
17640	\N	\N	\N	
17641	\N	\N	\N	
17642	\N	\N	\N	
17643	\N	\N	\N	
17644	\N	\N	\N	
17645	\N	\N	\N	
17646	\N	\N	\N	
17647	\N	\N	\N	
17648	\N	\N	\N	
17649	\N	\N	\N	
17650	\N	\N	\N	
17651	\N	\N	\N	
17652	\N	\N	\N	
17653	\N	\N	\N	
17654	\N	\N	\N	
17655	\N	\N	\N	
17656	\N	\N	\N	
17657	\N	\N	\N	
17658	\N	\N	\N	
17659	\N	\N	\N	
17660	\N	\N	\N	
17661	\N	\N	\N	
17662	\N	\N	\N	
17663	\N	\N	\N	
17664	\N	\N	\N	
17665	\N	\N	\N	
17666	\N	\N	\N	
17667	\N	\N	\N	
17668	\N	\N	\N	
17669	\N	\N	\N	
17670	\N	\N	\N	
17671	\N	\N	\N	
17672	\N	\N	\N	
17673	\N	\N	\N	
17674	\N	\N	\N	
17675	\N	\N	\N	
17676	\N	\N	\N	
17677	\N	\N	\N	
17678	\N	\N	\N	
17679	\N	\N	\N	
17680	\N	\N	\N	
17681	\N	\N	\N	
17682	\N	\N	\N	
17683	\N	\N	\N	
17684	\N	\N	\N	
17685	\N	\N	\N	
17686	\N	\N	\N	
17687	\N	\N	\N	
17688	\N	\N	\N	
17689	\N	\N	\N	
17690	\N	\N	\N	
17691	\N	\N	\N	
17692	\N	\N	\N	
17693	\N	\N	\N	
17694	\N	\N	\N	
17695	\N	\N	\N	
17696	\N	\N	\N	
17697	\N	\N	\N	
17698	\N	\N	\N	
17699	\N	\N	\N	
17700	\N	\N	\N	
17701	\N	\N	\N	
17702	\N	\N	\N	
17703	\N	\N	\N	
17704	\N	\N	\N	
17705	\N	\N	\N	
17706	\N	\N	\N	
17707	\N	\N	\N	
17708	\N	\N	\N	
17709	\N	\N	\N	
17710	\N	\N	\N	
17711	\N	\N	\N	
17712	\N	\N	\N	
17713	\N	\N	\N	
17714	\N	\N	\N	
17715	\N	\N	\N	
17716	\N	\N	\N	
17717	\N	\N	\N	
17718	\N	\N	\N	
17719	\N	\N	\N	
17720	\N	\N	\N	
17721	\N	\N	\N	
17722	\N	\N	\N	
17723	\N	\N	\N	
17724	\N	\N	\N	
17725	\N	\N	\N	
17726	\N	\N	\N	
17727	\N	\N	\N	
17728	\N	\N	\N	
17729	\N	\N	\N	
17730	\N	\N	\N	
17731	\N	\N	\N	
17732	\N	\N	\N	
17733	\N	\N	\N	
17734	\N	\N	\N	
17735	\N	\N	\N	
17736	\N	\N	\N	
17737	\N	\N	\N	
17738	\N	\N	\N	
17739	\N	\N	\N	
17740	\N	\N	\N	
17741	\N	\N	\N	
17742	\N	\N	\N	
17743	\N	\N	\N	
17744	\N	\N	\N	
17745	\N	\N	\N	
17746	\N	\N	\N	
17747	\N	\N	\N	
17748	\N	\N	\N	
17749	\N	\N	\N	
17750	\N	\N	\N	
17751	\N	\N	\N	
17752	\N	\N	\N	
17753	\N	\N	\N	
17754	\N	\N	\N	
17755	\N	\N	\N	
17756	\N	\N	\N	
17757	\N	\N	\N	
17758	\N	\N	\N	
17759	\N	\N	\N	
17760	\N	\N	\N	
17761	\N	\N	\N	
17762	\N	\N	\N	
17763	\N	\N	\N	
17764	\N	\N	\N	
17765	\N	\N	\N	
17766	\N	\N	\N	
17767	\N	\N	\N	
17768	\N	\N	\N	
17769	\N	\N	\N	
17770	\N	\N	\N	
17771	\N	\N	\N	
17772	\N	\N	\N	
17773	\N	\N	\N	
17774	\N	\N	\N	
17775	\N	\N	\N	
17776	\N	\N	\N	
17777	\N	\N	\N	
17778	\N	\N	\N	
17779	\N	\N	\N	
17780	\N	\N	\N	
17781	\N	\N	\N	
17782	\N	\N	\N	
17783	\N	\N	\N	
17784	\N	\N	\N	
17785	\N	\N	\N	
17786	\N	\N	\N	
17787	\N	\N	\N	
17788	\N	\N	\N	
17789	\N	\N	\N	
17790	\N	\N	\N	
17791	\N	\N	\N	
17792	\N	\N	\N	
17793	\N	\N	\N	
17794	\N	\N	\N	
17795	\N	\N	\N	
17796	\N	\N	\N	
17797	\N	\N	\N	
17798	\N	\N	\N	
17799	\N	\N	\N	
17800	\N	\N	\N	
17801	\N	\N	\N	
17802	\N	\N	\N	
17803	\N	\N	\N	
17804	\N	\N	\N	
17805	\N	\N	\N	
17806	\N	\N	\N	
17807	\N	\N	\N	
17808	\N	\N	\N	
17809	\N	\N	\N	
17810	\N	\N	\N	
17811	\N	\N	\N	
17812	\N	\N	\N	
17813	\N	\N	\N	
17814	\N	\N	\N	
17815	\N	\N	\N	
17816	\N	\N	\N	
17817	\N	\N	\N	
17818	\N	\N	\N	
17819	\N	\N	\N	
17820	\N	\N	\N	
17821	\N	\N	\N	
17822	\N	\N	\N	
17823	\N	\N	\N	
17824	\N	\N	\N	
17825	\N	\N	\N	
17826	\N	\N	\N	
17827	\N	\N	\N	
17828	\N	\N	\N	
17829	\N	\N	\N	
17830	\N	\N	\N	
17831	\N	\N	\N	
17832	\N	\N	\N	
17833	\N	\N	\N	
17834	\N	\N	\N	
17835	\N	\N	\N	
17836	\N	\N	\N	
17837	\N	\N	\N	
17838	\N	\N	\N	
17839	\N	\N	\N	
17840	\N	\N	\N	
17841	\N	\N	\N	
17842	\N	\N	\N	
17843	\N	\N	\N	
17844	\N	\N	\N	
17845	\N	\N	\N	
17846	\N	\N	\N	
17847	\N	\N	\N	
17848	\N	\N	\N	
17849	\N	\N	\N	
17850	\N	\N	\N	
17851	\N	\N	\N	
17852	\N	\N	\N	
17853	\N	\N	\N	
17854	\N	\N	\N	
17855	\N	\N	\N	
17856	\N	\N	\N	
17857	\N	\N	\N	
17858	\N	\N	\N	
17859	\N	\N	\N	
17860	\N	\N	\N	
17861	\N	\N	\N	
17862	\N	\N	\N	
17863	\N	\N	\N	
17864	\N	\N	\N	
17865	\N	\N	\N	
17866	\N	\N	\N	
17867	\N	\N	\N	
17868	\N	\N	\N	
17869	\N	\N	\N	
17870	\N	\N	\N	
17871	\N	\N	\N	
17872	\N	\N	\N	
17873	\N	\N	\N	
17874	\N	\N	\N	
17875	\N	\N	\N	
17876	\N	\N	\N	
17877	\N	\N	\N	
17878	\N	\N	\N	
17879	\N	\N	\N	
17880	\N	\N	\N	
17881	\N	\N	\N	
17882	\N	\N	\N	
17883	\N	\N	\N	
17884	\N	\N	\N	
17885	\N	\N	\N	
17886	\N	\N	\N	
17887	\N	\N	\N	
17888	\N	\N	\N	
17889	\N	\N	\N	
17890	\N	\N	\N	
17891	\N	\N	\N	
17892	\N	\N	\N	
17893	\N	\N	\N	
17894	\N	\N	\N	
17895	\N	\N	\N	
17896	\N	\N	\N	
17897	\N	\N	\N	
17898	\N	\N	\N	
17899	\N	\N	\N	
17900	\N	\N	\N	
17901	\N	\N	\N	
17902	\N	\N	\N	
17903	\N	\N	\N	
17904	\N	\N	\N	
17905	\N	\N	\N	
17906	\N	\N	\N	
17907	\N	\N	\N	
17908	\N	\N	\N	
17909	\N	\N	\N	
17910	\N	\N	\N	
17911	\N	\N	\N	
17912	\N	\N	\N	
17913	\N	\N	\N	
17914	\N	\N	\N	
17915	\N	\N	\N	
17916	\N	\N	\N	
17917	\N	\N	\N	
17918	\N	\N	\N	
17919	\N	\N	\N	
17920	\N	\N	\N	
17921	\N	\N	\N	
17922	\N	\N	\N	
17923	\N	\N	\N	
17924	\N	\N	\N	
17925	\N	\N	\N	
17926	\N	\N	\N	
17927	\N	\N	\N	
17928	\N	\N	\N	
17929	\N	\N	\N	
17930	\N	\N	\N	
17931	\N	\N	\N	
17932	\N	\N	\N	
17933	\N	\N	\N	
17934	\N	\N	\N	
17935	\N	\N	\N	
17936	\N	\N	\N	
17937	\N	\N	\N	
17938	\N	\N	\N	
17939	\N	\N	\N	
17940	\N	\N	\N	
17941	\N	\N	\N	
17942	\N	\N	\N	
17943	\N	\N	\N	
17944	\N	\N	\N	
17945	\N	\N	\N	
17946	\N	\N	\N	
17947	\N	\N	\N	
17948	\N	\N	\N	
17949	\N	\N	\N	
17950	\N	\N	\N	
17951	\N	\N	\N	
17952	\N	\N	\N	
17953	\N	\N	\N	
17954	\N	\N	\N	
17955	\N	\N	\N	
17956	\N	\N	\N	
17957	\N	\N	\N	
17958	\N	\N	\N	
17959	\N	\N	\N	
17960	\N	\N	\N	
17961	\N	\N	\N	
17962	\N	\N	\N	
17963	\N	\N	\N	
17964	\N	\N	\N	
17965	\N	\N	\N	
17966	\N	\N	\N	
17967	\N	\N	\N	
17968	\N	\N	\N	
17969	\N	\N	\N	
17970	\N	\N	\N	
17971	\N	\N	\N	
17972	\N	\N	\N	
17973	\N	\N	\N	
17974	\N	\N	\N	
17975	\N	\N	\N	
17976	\N	\N	\N	
17977	\N	\N	\N	
17978	\N	\N	\N	
17979	\N	\N	\N	
17980	\N	\N	\N	
17981	\N	\N	\N	
17982	\N	\N	\N	
17983	\N	\N	\N	
17984	\N	\N	\N	
17985	\N	\N	\N	
17986	\N	\N	\N	
17987	\N	\N	\N	
17988	\N	\N	\N	
17989	\N	\N	\N	
17990	\N	\N	\N	
17991	\N	\N	\N	
17992	\N	\N	\N	
17993	\N	\N	\N	
17994	\N	\N	\N	
17995	\N	\N	\N	
17996	\N	\N	\N	
17997	\N	\N	\N	
17998	\N	\N	\N	
17999	\N	\N	\N	
18000	\N	\N	\N	
18001	\N	\N	\N	
18002	\N	\N	\N	
18003	\N	\N	\N	
18004	\N	\N	\N	
18005	\N	\N	\N	
18006	\N	\N	\N	
18007	\N	\N	\N	
18008	\N	\N	\N	
18009	\N	\N	\N	
18010	\N	\N	\N	
18011	\N	\N	\N	
18012	\N	\N	\N	
18013	\N	\N	\N	
18014	\N	\N	\N	
18015	\N	\N	\N	
18016	\N	\N	\N	
18017	\N	\N	\N	
18018	\N	\N	\N	
18019	\N	\N	\N	
18020	\N	\N	\N	
18021	\N	\N	\N	
18022	\N	\N	\N	
18023	\N	\N	\N	
18024	\N	\N	\N	
18025	\N	\N	\N	
18026	\N	\N	\N	
18027	\N	\N	\N	
18028	\N	\N	\N	
18029	\N	\N	\N	
18030	\N	\N	\N	
18031	\N	\N	\N	
18032	\N	\N	\N	
18033	\N	\N	\N	
18034	\N	\N	\N	
18035	\N	\N	\N	
18036	\N	\N	\N	
18037	\N	\N	\N	
18038	\N	\N	\N	
18039	\N	\N	\N	
18040	\N	\N	\N	
18041	\N	\N	\N	
18042	\N	\N	\N	
18043	\N	\N	\N	
18044	\N	\N	\N	
18045	\N	\N	\N	
18046	\N	\N	\N	
18047	\N	\N	\N	
18048	\N	\N	\N	
18049	\N	\N	\N	
18050	\N	\N	\N	
18051	\N	\N	\N	
18052	\N	\N	\N	
18053	\N	\N	\N	
18054	\N	\N	\N	
18055	\N	\N	\N	
18056	\N	\N	\N	
18057	\N	\N	\N	
18058	\N	\N	\N	
18059	\N	\N	\N	
18060	\N	\N	\N	
18061	\N	\N	\N	
18062	\N	\N	\N	
18063	\N	\N	\N	
18064	\N	\N	\N	
18065	\N	\N	\N	
18066	\N	\N	\N	
18067	\N	\N	\N	
18068	\N	\N	\N	
18069	\N	\N	\N	
18070	\N	\N	\N	
18071	\N	\N	\N	
18072	\N	\N	\N	
18073	\N	\N	\N	
18074	\N	\N	\N	
18075	\N	\N	\N	
18076	\N	\N	\N	
18077	\N	\N	\N	
18078	\N	\N	\N	
18079	\N	\N	\N	
18080	\N	\N	\N	
18081	\N	\N	\N	
18082	\N	\N	\N	
18083	\N	\N	\N	
18084	\N	\N	\N	
18085	\N	\N	\N	
18086	\N	\N	\N	
18087	\N	\N	\N	
18088	\N	\N	\N	
18089	\N	\N	\N	
18090	\N	\N	\N	
18091	\N	\N	\N	
18092	\N	\N	\N	
18093	\N	\N	\N	
18094	\N	\N	\N	
18095	\N	\N	\N	
18096	\N	\N	\N	
18097	\N	\N	\N	
18098	\N	\N	\N	
18099	\N	\N	\N	
18100	\N	\N	\N	
18101	\N	\N	\N	
18102	\N	\N	\N	
18103	\N	\N	\N	
18104	\N	\N	\N	
18105	\N	\N	\N	
18106	\N	\N	\N	
18107	\N	\N	\N	
18108	\N	\N	\N	
18109	\N	\N	\N	
18110	\N	\N	\N	
18111	\N	\N	\N	
18112	\N	\N	\N	
18113	\N	\N	\N	
18114	\N	\N	\N	
18115	\N	\N	\N	
18116	\N	\N	\N	
18117	\N	\N	\N	
18118	\N	\N	\N	
18119	\N	\N	\N	
18120	\N	\N	\N	
18121	\N	\N	\N	
18122	\N	\N	\N	
18123	\N	\N	\N	
18124	\N	\N	\N	
18125	\N	\N	\N	
18126	\N	\N	\N	
18127	\N	\N	\N	
18128	\N	\N	\N	
18129	\N	\N	\N	
18130	\N	\N	\N	
18131	\N	\N	\N	
18132	\N	\N	\N	
18133	\N	\N	\N	
18134	\N	\N	\N	
18135	\N	\N	\N	
18136	\N	\N	\N	
18137	\N	\N	\N	
18138	\N	\N	\N	
18139	\N	\N	\N	
18140	\N	\N	\N	
18141	\N	\N	\N	
18142	\N	\N	\N	
18143	\N	\N	\N	
18144	\N	\N	\N	
18145	\N	\N	\N	
18146	\N	\N	\N	
18147	\N	\N	\N	
18148	\N	\N	\N	
18149	\N	\N	\N	
18150	\N	\N	\N	
18151	\N	\N	\N	
18152	\N	\N	\N	
18153	\N	\N	\N	
18154	\N	\N	\N	
18155	\N	\N	\N	
18156	\N	\N	\N	
18157	\N	\N	\N	
18158	\N	\N	\N	
18159	\N	\N	\N	
18160	\N	\N	\N	
18161	\N	\N	\N	
18162	\N	\N	\N	
18163	\N	\N	\N	
18164	\N	\N	\N	
18165	\N	\N	\N	
18166	\N	\N	\N	
18167	\N	\N	\N	
18168	\N	\N	\N	
18169	\N	\N	\N	
18170	\N	\N	\N	
18171	\N	\N	\N	
18172	\N	\N	\N	
18173	\N	\N	\N	
18174	\N	\N	\N	
18175	\N	\N	\N	
18176	\N	\N	\N	
18177	\N	\N	\N	
18178	\N	\N	\N	
18179	\N	\N	\N	
18180	\N	\N	\N	
18181	\N	\N	\N	
18182	\N	\N	\N	
18183	\N	\N	\N	
18184	\N	\N	\N	
18185	\N	\N	\N	
18186	\N	\N	\N	
18187	\N	\N	\N	
18188	\N	\N	\N	
18189	\N	\N	\N	
18190	\N	\N	\N	
18191	\N	\N	\N	
18192	\N	\N	\N	
18193	\N	\N	\N	
18194	\N	\N	\N	
18195	\N	\N	\N	
18196	\N	\N	\N	
18197	\N	\N	\N	
18198	\N	\N	\N	
18199	\N	\N	\N	
18200	\N	\N	\N	
18201	\N	\N	\N	
18202	\N	\N	\N	
18203	\N	\N	\N	
18204	\N	\N	\N	
18205	\N	\N	\N	
18206	\N	\N	\N	
18207	\N	\N	\N	
18208	\N	\N	\N	
18209	\N	\N	\N	
18210	\N	\N	\N	
18211	\N	\N	\N	
18212	\N	\N	\N	
18213	\N	\N	\N	
18214	\N	\N	\N	
18215	\N	\N	\N	
18216	\N	\N	\N	
18217	\N	\N	\N	
18218	\N	\N	\N	
18219	\N	\N	\N	
18220	\N	\N	\N	
18221	\N	\N	\N	
18222	\N	\N	\N	
18223	\N	\N	\N	
18224	\N	\N	\N	
18225	\N	\N	\N	
18226	\N	\N	\N	
18227	\N	\N	\N	
18228	\N	\N	\N	
18229	\N	\N	\N	
18230	\N	\N	\N	
18231	\N	\N	\N	
18232	\N	\N	\N	
18233	\N	\N	\N	
18234	\N	\N	\N	
18235	\N	\N	\N	
18236	\N	\N	\N	
18237	\N	\N	\N	
18238	\N	\N	\N	
18239	\N	\N	\N	
18240	\N	\N	\N	
18241	\N	\N	\N	
18242	\N	\N	\N	
18243	\N	\N	\N	
18244	\N	\N	\N	
18245	\N	\N	\N	
18246	\N	\N	\N	
18247	\N	\N	\N	
18248	\N	\N	\N	
18249	\N	\N	\N	
18250	\N	\N	\N	
18251	\N	\N	\N	
18252	\N	\N	\N	
18253	\N	\N	\N	
18254	\N	\N	\N	
18255	\N	\N	\N	
18256	\N	\N	\N	
18257	\N	\N	\N	
18258	\N	\N	\N	
18259	\N	\N	\N	
18260	\N	\N	\N	
18261	\N	\N	\N	
18262	\N	\N	\N	
18263	\N	\N	\N	
18264	\N	\N	\N	
18265	\N	\N	\N	
18266	\N	\N	\N	
18267	\N	\N	\N	
18268	\N	\N	\N	
18269	\N	\N	\N	
18270	\N	\N	\N	
18271	\N	\N	\N	
18272	\N	\N	\N	
18273	\N	\N	\N	
18274	\N	\N	\N	
18275	\N	\N	\N	
18276	\N	\N	\N	
18277	\N	\N	\N	
18278	\N	\N	\N	
18279	\N	\N	\N	
18280	\N	\N	\N	
18281	\N	\N	\N	
18282	\N	\N	\N	
18283	\N	\N	\N	
18284	\N	\N	\N	
18285	\N	\N	\N	
18286	\N	\N	\N	
18287	\N	\N	\N	
18288	\N	\N	\N	
18289	\N	\N	\N	
18290	\N	\N	\N	
18291	\N	\N	\N	
18292	\N	\N	\N	
18293	\N	\N	\N	
18294	\N	\N	\N	
18295	\N	\N	\N	
18296	\N	\N	\N	
18297	\N	\N	\N	
18298	\N	\N	\N	
18299	\N	\N	\N	
18300	\N	\N	\N	
18301	\N	\N	\N	
18302	\N	\N	\N	
18303	\N	\N	\N	
18304	\N	\N	\N	
18305	\N	\N	\N	
18306	\N	\N	\N	
18307	\N	\N	\N	
18308	\N	\N	\N	
18309	\N	\N	\N	
18310	\N	\N	\N	
18311	\N	\N	\N	
18312	\N	\N	\N	
18313	\N	\N	\N	
18314	\N	\N	\N	
18315	\N	\N	\N	
18316	\N	\N	\N	
18317	\N	\N	\N	
18318	\N	\N	\N	
18319	\N	\N	\N	
18320	\N	\N	\N	
18321	\N	\N	\N	
18322	\N	\N	\N	
18323	\N	\N	\N	
18324	\N	\N	\N	
18325	\N	\N	\N	
18326	\N	\N	\N	
18327	\N	\N	\N	
18328	\N	\N	\N	
18329	\N	\N	\N	
18330	\N	\N	\N	
18331	\N	\N	\N	
18332	\N	\N	\N	
18333	\N	\N	\N	
18334	\N	\N	\N	
18335	\N	\N	\N	
18336	\N	\N	\N	
18337	\N	\N	\N	
18338	\N	\N	\N	
18339	\N	\N	\N	
18340	\N	\N	\N	
18341	\N	\N	\N	
18342	\N	\N	\N	
18343	\N	\N	\N	
18344	\N	\N	\N	
18345	\N	\N	\N	
18346	\N	\N	\N	
18347	\N	\N	\N	
18348	\N	\N	\N	
18349	\N	\N	\N	
18350	\N	\N	\N	
18351	\N	\N	\N	
18352	\N	\N	\N	
18353	\N	\N	\N	
18354	\N	\N	\N	
18355	\N	\N	\N	
18356	\N	\N	\N	
18357	\N	\N	\N	
18358	\N	\N	\N	
18359	\N	\N	\N	
18360	\N	\N	\N	
18361	\N	\N	\N	
18362	\N	\N	\N	
18363	\N	\N	\N	
18364	\N	\N	\N	
18365	\N	\N	\N	
18366	\N	\N	\N	
18367	\N	\N	\N	
18368	\N	\N	\N	
18369	\N	\N	\N	
18370	\N	\N	\N	
18371	\N	\N	\N	
18372	\N	\N	\N	
18373	\N	\N	\N	
18374	\N	\N	\N	
18375	\N	\N	\N	
18376	\N	\N	\N	
18377	\N	\N	\N	
18378	\N	\N	\N	
18379	\N	\N	\N	
18380	\N	\N	\N	
18381	\N	\N	\N	
18382	\N	\N	\N	
18383	\N	\N	\N	
18384	\N	\N	\N	
18385	\N	\N	\N	
18386	\N	\N	\N	
18387	\N	\N	\N	
18388	\N	\N	\N	
18389	\N	\N	\N	
18390	\N	\N	\N	
18391	\N	\N	\N	
18392	\N	\N	\N	
18393	\N	\N	\N	
18394	\N	\N	\N	
18395	\N	\N	\N	
18396	\N	\N	\N	
18397	\N	\N	\N	
18398	\N	\N	\N	
18399	\N	\N	\N	
18400	\N	\N	\N	
18401	\N	\N	\N	
18402	\N	\N	\N	
18403	\N	\N	\N	
18404	\N	\N	\N	
18405	\N	\N	\N	
18406	\N	\N	\N	
18407	\N	\N	\N	
18408	\N	\N	\N	
18409	\N	\N	\N	
18410	\N	\N	\N	
18411	\N	\N	\N	
18412	\N	\N	\N	
18413	\N	\N	\N	
18414	\N	\N	\N	
18415	\N	\N	\N	
18416	\N	\N	\N	
18417	\N	\N	\N	
18418	\N	\N	\N	
18419	\N	\N	\N	
18420	\N	\N	\N	
18421	\N	\N	\N	
18422	\N	\N	\N	
18423	\N	\N	\N	
18424	\N	\N	\N	
18425	\N	\N	\N	
18426	\N	\N	\N	
18427	\N	\N	\N	
18428	\N	\N	\N	
18429	\N	\N	\N	
18430	\N	\N	\N	
18431	\N	\N	\N	
18432	\N	\N	\N	
18433	\N	\N	\N	
18434	\N	\N	\N	
18435	\N	\N	\N	
18436	\N	\N	\N	
18437	\N	\N	\N	
18438	\N	\N	\N	
18439	\N	\N	\N	
18440	\N	\N	\N	
18441	\N	\N	\N	
18442	\N	\N	\N	
18443	\N	\N	\N	
18444	\N	\N	\N	
18445	\N	\N	\N	
18446	\N	\N	\N	
18447	\N	\N	\N	
18448	\N	\N	\N	
18449	\N	\N	\N	
18450	\N	\N	\N	
18451	\N	\N	\N	
18452	\N	\N	\N	
18453	\N	\N	\N	
18454	\N	\N	\N	
18455	\N	\N	\N	
18456	\N	\N	\N	
18457	\N	\N	\N	
18458	\N	\N	\N	
18459	\N	\N	\N	
18460	\N	\N	\N	
18461	\N	\N	\N	
18462	\N	\N	\N	
18463	\N	\N	\N	
18464	\N	\N	\N	
18465	\N	\N	\N	
18466	\N	\N	\N	
18467	\N	\N	\N	
18468	\N	\N	\N	
18469	\N	\N	\N	
18470	\N	\N	\N	
18471	\N	\N	\N	
18472	\N	\N	\N	
18473	\N	\N	\N	
18474	\N	\N	\N	
18475	\N	\N	\N	
18476	\N	\N	\N	
18477	\N	\N	\N	
18478	\N	\N	\N	
18479	\N	\N	\N	
18480	\N	\N	\N	
18481	\N	\N	\N	
18482	\N	\N	\N	
18483	\N	\N	\N	
18484	\N	\N	\N	
18485	\N	\N	\N	
18486	\N	\N	\N	
18487	\N	\N	\N	
18488	\N	\N	\N	
18489	\N	\N	\N	
18490	\N	\N	\N	
18491	\N	\N	\N	
18492	\N	\N	\N	
18493	\N	\N	\N	
18494	\N	\N	\N	
18495	\N	\N	\N	
18496	\N	\N	\N	
18497	\N	\N	\N	
18498	\N	\N	\N	
18499	\N	\N	\N	
18500	\N	\N	\N	
18501	\N	\N	\N	
18502	\N	\N	\N	
18503	\N	\N	\N	
18504	\N	\N	\N	
18505	\N	\N	\N	
18506	\N	\N	\N	
18507	\N	\N	\N	
18508	\N	\N	\N	
18509	\N	\N	\N	
18510	\N	\N	\N	
18511	\N	\N	\N	
18512	\N	\N	\N	
18513	\N	\N	\N	
18514	\N	\N	\N	
18515	\N	\N	\N	
18516	\N	\N	\N	
18517	\N	\N	\N	
18518	\N	\N	\N	
18519	\N	\N	\N	
18520	\N	\N	\N	
18521	\N	\N	\N	
18522	\N	\N	\N	
18523	\N	\N	\N	
18524	\N	\N	\N	
18525	\N	\N	\N	
18526	\N	\N	\N	
18527	\N	\N	\N	
18528	\N	\N	\N	
18529	\N	\N	\N	
18530	\N	\N	\N	
18531	\N	\N	\N	
18532	\N	\N	\N	
18533	\N	\N	\N	
18534	\N	\N	\N	
18535	\N	\N	\N	
18536	\N	\N	\N	
18537	\N	\N	\N	
18538	\N	\N	\N	
18539	\N	\N	\N	
18540	\N	\N	\N	
18541	\N	\N	\N	
18542	\N	\N	\N	
18543	\N	\N	\N	
18544	\N	\N	\N	
18545	\N	\N	\N	
18546	\N	\N	\N	
18547	\N	\N	\N	
18548	\N	\N	\N	
18549	\N	\N	\N	
18550	\N	\N	\N	
18551	\N	\N	\N	
18552	\N	\N	\N	
18553	\N	\N	\N	
18554	\N	\N	\N	
18555	\N	\N	\N	
18556	\N	\N	\N	
18557	\N	\N	\N	
18558	\N	\N	\N	
18559	\N	\N	\N	
18560	\N	\N	\N	
18561	\N	\N	\N	
18562	\N	\N	\N	
18563	\N	\N	\N	
18564	\N	\N	\N	
18565	\N	\N	\N	
18566	\N	\N	\N	
18567	\N	\N	\N	
18568	\N	\N	\N	
18569	\N	\N	\N	
18570	\N	\N	\N	
18571	\N	\N	\N	
18572	\N	\N	\N	
18573	\N	\N	\N	
18574	\N	\N	\N	
18575	\N	\N	\N	
18576	\N	\N	\N	
18577	\N	\N	\N	
18578	\N	\N	\N	
18579	\N	\N	\N	
18580	\N	\N	\N	
18581	\N	\N	\N	
18582	\N	\N	\N	
18583	\N	\N	\N	
18584	\N	\N	\N	
18585	\N	\N	\N	
18586	\N	\N	\N	
18587	\N	\N	\N	
18588	\N	\N	\N	
18589	\N	\N	\N	
18590	\N	\N	\N	
18591	\N	\N	\N	
18592	\N	\N	\N	
18593	\N	\N	\N	
18594	\N	\N	\N	
18595	\N	\N	\N	
18596	\N	\N	\N	
18597	\N	\N	\N	
18598	\N	\N	\N	
18599	\N	\N	\N	
18600	\N	\N	\N	
18601	\N	\N	\N	
18602	\N	\N	\N	
18603	\N	\N	\N	
18604	\N	\N	\N	
18605	\N	\N	\N	
18606	\N	\N	\N	
18607	\N	\N	\N	
18608	\N	\N	\N	
18609	\N	\N	\N	
18610	\N	\N	\N	
18611	\N	\N	\N	
18612	\N	\N	\N	
18613	\N	\N	\N	
18614	\N	\N	\N	
18615	\N	\N	\N	
18616	\N	\N	\N	
18617	\N	\N	\N	
18618	\N	\N	\N	
18619	\N	\N	\N	
18620	\N	\N	\N	
18621	\N	\N	\N	
18622	\N	\N	\N	
18623	\N	\N	\N	
18624	\N	\N	\N	
18625	\N	\N	\N	
18626	\N	\N	\N	
18627	\N	\N	\N	
18628	\N	\N	\N	
18629	\N	\N	\N	
18630	\N	\N	\N	
18631	\N	\N	\N	
18632	\N	\N	\N	
18633	\N	\N	\N	
18634	\N	\N	\N	
18635	\N	\N	\N	
18636	\N	\N	\N	
18637	\N	\N	\N	
18638	\N	\N	\N	
18639	\N	\N	\N	
18640	\N	\N	\N	
18641	\N	\N	\N	
18642	\N	\N	\N	
18643	\N	\N	\N	
18644	\N	\N	\N	
18645	\N	\N	\N	
18646	\N	\N	\N	
18647	\N	\N	\N	
18648	\N	\N	\N	
18649	\N	\N	\N	
18650	\N	\N	\N	
18651	\N	\N	\N	
18652	\N	\N	\N	
18653	\N	\N	\N	
18654	\N	\N	\N	
18655	\N	\N	\N	
18656	\N	\N	\N	
18657	\N	\N	\N	
18658	\N	\N	\N	
18659	\N	\N	\N	
18660	\N	\N	\N	
18661	\N	\N	\N	
18662	\N	\N	\N	
18663	\N	\N	\N	
18664	\N	\N	\N	
18665	\N	\N	\N	
18666	\N	\N	\N	
18667	\N	\N	\N	
18668	\N	\N	\N	
18669	\N	\N	\N	
18670	\N	\N	\N	
18671	\N	\N	\N	
18672	\N	\N	\N	
18673	\N	\N	\N	
18674	\N	\N	\N	
18675	\N	\N	\N	
18676	\N	\N	\N	
18677	\N	\N	\N	
18678	\N	\N	\N	
18679	\N	\N	\N	
18680	\N	\N	\N	
18681	\N	\N	\N	
18682	\N	\N	\N	
18683	\N	\N	\N	
18684	\N	\N	\N	
18685	\N	\N	\N	
18686	\N	\N	\N	
18687	\N	\N	\N	
18688	\N	\N	\N	
18689	\N	\N	\N	
18690	\N	\N	\N	
18691	\N	\N	\N	
18692	\N	\N	\N	
18693	\N	\N	\N	
18694	\N	\N	\N	
18695	\N	\N	\N	
18696	\N	\N	\N	
18697	\N	\N	\N	
18698	\N	\N	\N	
18699	\N	\N	\N	
18700	\N	\N	\N	
18701	\N	\N	\N	
18702	\N	\N	\N	
18703	\N	\N	\N	
18704	\N	\N	\N	
18705	\N	\N	\N	
18706	\N	\N	\N	
18707	\N	\N	\N	
18708	\N	\N	\N	
18709	\N	\N	\N	
18710	\N	\N	\N	
18711	\N	\N	\N	
18712	\N	\N	\N	
18713	\N	\N	\N	
18714	\N	\N	\N	
18715	\N	\N	\N	
18716	\N	\N	\N	
18717	\N	\N	\N	
18718	\N	\N	\N	
18719	\N	\N	\N	
18720	\N	\N	\N	
18721	\N	\N	\N	
18722	\N	\N	\N	
18723	\N	\N	\N	
18724	\N	\N	\N	
18725	\N	\N	\N	
18726	\N	\N	\N	
18727	\N	\N	\N	
18728	\N	\N	\N	
18729	\N	\N	\N	
18730	\N	\N	\N	
18731	\N	\N	\N	
18732	\N	\N	\N	
18733	\N	\N	\N	
18734	\N	\N	\N	
18735	\N	\N	\N	
18736	\N	\N	\N	
18737	\N	\N	\N	
18738	\N	\N	\N	
18739	\N	\N	\N	
18740	\N	\N	\N	
18741	\N	\N	\N	
18742	\N	\N	\N	
18743	\N	\N	\N	
18744	\N	\N	\N	
18745	\N	\N	\N	
18746	\N	\N	\N	
18747	\N	\N	\N	
18748	\N	\N	\N	
18749	\N	\N	\N	
18750	\N	\N	\N	
18751	\N	\N	\N	
18752	\N	\N	\N	
18753	\N	\N	\N	
18754	\N	\N	\N	
18755	\N	\N	\N	
18756	\N	\N	\N	
18757	\N	\N	\N	
18758	\N	\N	\N	
18759	\N	\N	\N	
18760	\N	\N	\N	
18761	\N	\N	\N	
18762	\N	\N	\N	
18763	\N	\N	\N	
18764	\N	\N	\N	
18765	\N	\N	\N	
18766	\N	\N	\N	
18767	\N	\N	\N	
18768	\N	\N	\N	
18769	\N	\N	\N	
18770	\N	\N	\N	
18771	\N	\N	\N	
18772	\N	\N	\N	
18773	\N	\N	\N	
18774	\N	\N	\N	
18775	\N	\N	\N	
18776	\N	\N	\N	
18777	\N	\N	\N	
18778	\N	\N	\N	
18779	\N	\N	\N	
18780	\N	\N	\N	
18781	\N	\N	\N	
18782	\N	\N	\N	
18783	\N	\N	\N	
18784	\N	\N	\N	
18785	\N	\N	\N	
18786	\N	\N	\N	
18787	\N	\N	\N	
18788	\N	\N	\N	
18789	\N	\N	\N	
18790	\N	\N	\N	
18791	\N	\N	\N	
18792	\N	\N	\N	
18793	\N	\N	\N	
18794	\N	\N	\N	
18795	\N	\N	\N	
18796	\N	\N	\N	
18797	\N	\N	\N	
18798	\N	\N	\N	
18799	\N	\N	\N	
18800	\N	\N	\N	
18801	\N	\N	\N	
18802	\N	\N	\N	
18803	\N	\N	\N	
18804	\N	\N	\N	
18805	\N	\N	\N	
18806	\N	\N	\N	
18807	\N	\N	\N	
18808	\N	\N	\N	
18809	\N	\N	\N	
18810	\N	\N	\N	
18811	\N	\N	\N	
18812	\N	\N	\N	
18813	\N	\N	\N	
18814	\N	\N	\N	
18815	\N	\N	\N	
18816	\N	\N	\N	
18817	\N	\N	\N	
18818	\N	\N	\N	
18819	\N	\N	\N	
18820	\N	\N	\N	
18821	\N	\N	\N	
18822	\N	\N	\N	
18823	\N	\N	\N	
18824	\N	\N	\N	
18825	\N	\N	\N	
18826	\N	\N	\N	
18827	\N	\N	\N	
18828	\N	\N	\N	
18829	\N	\N	\N	
18830	\N	\N	\N	
18831	\N	\N	\N	
18832	\N	\N	\N	
18833	\N	\N	\N	
18834	\N	\N	\N	
18835	\N	\N	\N	
18836	\N	\N	\N	
18837	\N	\N	\N	
18838	\N	\N	\N	
18839	\N	\N	\N	
18840	\N	\N	\N	
18841	\N	\N	\N	
18842	\N	\N	\N	
18843	\N	\N	\N	
18844	\N	\N	\N	
18845	\N	\N	\N	
18846	\N	\N	\N	
18847	\N	\N	\N	
18848	\N	\N	\N	
18849	\N	\N	\N	
18850	\N	\N	\N	
18851	\N	\N	\N	
18852	\N	\N	\N	
18853	\N	\N	\N	
18854	\N	\N	\N	
18855	\N	\N	\N	
18856	\N	\N	\N	
18857	\N	\N	\N	
18858	\N	\N	\N	
18859	\N	\N	\N	
18860	\N	\N	\N	
18861	\N	\N	\N	
18862	\N	\N	\N	
18863	\N	\N	\N	
18864	\N	\N	\N	
18865	\N	\N	\N	
18866	\N	\N	\N	
18867	\N	\N	\N	
18868	\N	\N	\N	
18869	\N	\N	\N	
18870	\N	\N	\N	
18871	\N	\N	\N	
18872	\N	\N	\N	
18873	\N	\N	\N	
18874	\N	\N	\N	
18875	\N	\N	\N	
18876	\N	\N	\N	
18877	\N	\N	\N	
18878	\N	\N	\N	
18879	\N	\N	\N	
18880	\N	\N	\N	
18881	\N	\N	\N	
18882	\N	\N	\N	
18883	\N	\N	\N	
18884	\N	\N	\N	
18885	\N	\N	\N	
18886	\N	\N	\N	
18887	\N	\N	\N	
18888	\N	\N	\N	
18889	\N	\N	\N	
18890	\N	\N	\N	
18891	\N	\N	\N	
18892	\N	\N	\N	
18893	\N	\N	\N	
18894	\N	\N	\N	
18895	\N	\N	\N	
18896	\N	\N	\N	
18897	\N	\N	\N	
18898	\N	\N	\N	
18899	\N	\N	\N	
18900	\N	\N	\N	
18901	\N	\N	\N	
18902	\N	\N	\N	
18903	\N	\N	\N	
18904	\N	\N	\N	
18905	\N	\N	\N	
18906	\N	\N	\N	
18907	\N	\N	\N	
18908	\N	\N	\N	
18909	\N	\N	\N	
18910	\N	\N	\N	
18911	\N	\N	\N	
18912	\N	\N	\N	
18913	\N	\N	\N	
18914	\N	\N	\N	
18915	\N	\N	\N	
18916	\N	\N	\N	
18917	\N	\N	\N	
18918	\N	\N	\N	
18919	\N	\N	\N	
18920	\N	\N	\N	
18921	\N	\N	\N	
18922	\N	\N	\N	
18923	\N	\N	\N	
18924	\N	\N	\N	
18925	\N	\N	\N	
18926	\N	\N	\N	
18927	\N	\N	\N	
18928	\N	\N	\N	
18929	\N	\N	\N	
18930	\N	\N	\N	
18931	\N	\N	\N	
18932	\N	\N	\N	
18933	\N	\N	\N	
18934	\N	\N	\N	
18935	\N	\N	\N	
18936	\N	\N	\N	
18937	\N	\N	\N	
18938	\N	\N	\N	
18939	\N	\N	\N	
18940	\N	\N	\N	
18941	\N	\N	\N	
18942	\N	\N	\N	
18943	\N	\N	\N	
18944	\N	\N	\N	
18945	\N	\N	\N	
18946	\N	\N	\N	
18947	\N	\N	\N	
18948	\N	\N	\N	
18949	\N	\N	\N	
18950	\N	\N	\N	
18951	\N	\N	\N	
18952	\N	\N	\N	
18953	\N	\N	\N	
18954	\N	\N	\N	
18955	\N	\N	\N	
18956	\N	\N	\N	
18957	\N	\N	\N	
18958	\N	\N	\N	
18959	\N	\N	\N	
18960	\N	\N	\N	
18961	\N	\N	\N	
18962	\N	\N	\N	
18963	\N	\N	\N	
18964	\N	\N	\N	
18965	\N	\N	\N	
18966	\N	\N	\N	
18967	\N	\N	\N	
18968	\N	\N	\N	
18969	\N	\N	\N	
18970	\N	\N	\N	
18971	\N	\N	\N	
18972	\N	\N	\N	
18973	\N	\N	\N	
18974	\N	\N	\N	
18975	\N	\N	\N	
18976	\N	\N	\N	
18977	\N	\N	\N	
18978	\N	\N	\N	
18979	\N	\N	\N	
18980	\N	\N	\N	
18981	\N	\N	\N	
18982	\N	\N	\N	
18983	\N	\N	\N	
18984	\N	\N	\N	
18985	\N	\N	\N	
18986	\N	\N	\N	
18987	\N	\N	\N	
18988	\N	\N	\N	
18989	\N	\N	\N	
18990	\N	\N	\N	
18991	\N	\N	\N	
18992	\N	\N	\N	
18993	\N	\N	\N	
18994	\N	\N	\N	
18995	\N	\N	\N	
18996	\N	\N	\N	
18997	\N	\N	\N	
18998	\N	\N	\N	
18999	\N	\N	\N	
19000	\N	\N	\N	
19001	\N	\N	\N	
19002	\N	\N	\N	
19003	\N	\N	\N	
19004	\N	\N	\N	
19005	\N	\N	\N	
19006	\N	\N	\N	
19007	\N	\N	\N	
19008	\N	\N	\N	
19009	\N	\N	\N	
19010	\N	\N	\N	
19011	\N	\N	\N	
19012	\N	\N	\N	
19013	\N	\N	\N	
19014	\N	\N	\N	
19015	\N	\N	\N	
19016	\N	\N	\N	
19017	\N	\N	\N	
19018	\N	\N	\N	
19019	\N	\N	\N	
19020	\N	\N	\N	
19021	\N	\N	\N	
19022	\N	\N	\N	
19023	\N	\N	\N	
19024	\N	\N	\N	
19025	\N	\N	\N	
19026	\N	\N	\N	
19027	\N	\N	\N	
19028	\N	\N	\N	
19029	\N	\N	\N	
19030	\N	\N	\N	
19031	\N	\N	\N	
19032	\N	\N	\N	
19033	\N	\N	\N	
19034	\N	\N	\N	
19035	\N	\N	\N	
19036	\N	\N	\N	
19037	\N	\N	\N	
19038	\N	\N	\N	
19039	\N	\N	\N	
19040	\N	\N	\N	
19041	\N	\N	\N	
19042	\N	\N	\N	
19043	\N	\N	\N	
19044	\N	\N	\N	
19045	\N	\N	\N	
19046	\N	\N	\N	
19047	\N	\N	\N	
19048	\N	\N	\N	
19049	\N	\N	\N	
19050	\N	\N	\N	
19051	\N	\N	\N	
19052	\N	\N	\N	
19053	\N	\N	\N	
19054	\N	\N	\N	
19055	\N	\N	\N	
19056	\N	\N	\N	
19057	\N	\N	\N	
19058	\N	\N	\N	
19059	\N	\N	\N	
19060	\N	\N	\N	
19061	\N	\N	\N	
19062	\N	\N	\N	
19063	\N	\N	\N	
19064	\N	\N	\N	
19065	\N	\N	\N	
19066	\N	\N	\N	
19067	\N	\N	\N	
19068	\N	\N	\N	
19069	\N	\N	\N	
19070	\N	\N	\N	
19071	\N	\N	\N	
19072	\N	\N	\N	
19073	\N	\N	\N	
19074	\N	\N	\N	
19075	\N	\N	\N	
19076	\N	\N	\N	
19077	\N	\N	\N	
19078	\N	\N	\N	
19079	\N	\N	\N	
19080	\N	\N	\N	
19081	\N	\N	\N	
19082	\N	\N	\N	
19083	\N	\N	\N	
19084	\N	\N	\N	
19085	\N	\N	\N	
19086	\N	\N	\N	
19087	\N	\N	\N	
19088	\N	\N	\N	
19089	\N	\N	\N	
19090	\N	\N	\N	
19091	\N	\N	\N	
19092	\N	\N	\N	
19093	\N	\N	\N	
19094	\N	\N	\N	
19095	\N	\N	\N	
19096	\N	\N	\N	
19097	\N	\N	\N	
19098	\N	\N	\N	
19099	\N	\N	\N	
19100	\N	\N	\N	
19101	\N	\N	\N	
19102	\N	\N	\N	
19103	\N	\N	\N	
19104	\N	\N	\N	
19105	\N	\N	\N	
19106	\N	\N	\N	
19107	\N	\N	\N	
19108	\N	\N	\N	
19109	\N	\N	\N	
19110	\N	\N	\N	
19111	\N	\N	\N	
19112	\N	\N	\N	
19113	\N	\N	\N	
19114	\N	\N	\N	
19115	\N	\N	\N	
19116	\N	\N	\N	
19117	\N	\N	\N	
19118	\N	\N	\N	
19119	\N	\N	\N	
19120	\N	\N	\N	
19121	\N	\N	\N	
19122	\N	\N	\N	
19123	\N	\N	\N	
19124	\N	\N	\N	
19125	\N	\N	\N	
19126	\N	\N	\N	
19127	\N	\N	\N	
19128	\N	\N	\N	
19129	\N	\N	\N	
19130	\N	\N	\N	
19131	\N	\N	\N	
19132	\N	\N	\N	
19133	\N	\N	\N	
19134	\N	\N	\N	
19135	\N	\N	\N	
19136	\N	\N	\N	
19137	\N	\N	\N	
19138	\N	\N	\N	
19139	\N	\N	\N	
19140	\N	\N	\N	
19141	\N	\N	\N	
19142	\N	\N	\N	
19143	\N	\N	\N	
19144	\N	\N	\N	
19145	\N	\N	\N	
19146	\N	\N	\N	
19147	\N	\N	\N	
19148	\N	\N	\N	
19149	\N	\N	\N	
19150	\N	\N	\N	
19151	\N	\N	\N	
19152	\N	\N	\N	
19153	\N	\N	\N	
19154	\N	\N	\N	
19155	\N	\N	\N	
19156	\N	\N	\N	
19157	\N	\N	\N	
19158	\N	\N	\N	
19159	\N	\N	\N	
19160	\N	\N	\N	
19161	\N	\N	\N	
19162	\N	\N	\N	
19163	\N	\N	\N	
19164	\N	\N	\N	
19165	\N	\N	\N	
19166	\N	\N	\N	
19167	\N	\N	\N	
19168	\N	\N	\N	
19169	\N	\N	\N	
19170	\N	\N	\N	
19171	\N	\N	\N	
19172	\N	\N	\N	
19173	\N	\N	\N	
19174	\N	\N	\N	
19175	\N	\N	\N	
19176	\N	\N	\N	
19177	\N	\N	\N	
19178	\N	\N	\N	
19179	\N	\N	\N	
19180	\N	\N	\N	
19181	\N	\N	\N	
19182	\N	\N	\N	
19183	\N	\N	\N	
19184	\N	\N	\N	
19185	\N	\N	\N	
19186	\N	\N	\N	
19187	\N	\N	\N	
19188	\N	\N	\N	
19189	\N	\N	\N	
19190	\N	\N	\N	
19191	\N	\N	\N	
19192	\N	\N	\N	
19193	\N	\N	\N	
19194	\N	\N	\N	
19195	\N	\N	\N	
19196	\N	\N	\N	
19197	\N	\N	\N	
19198	\N	\N	\N	
19199	\N	\N	\N	
19200	\N	\N	\N	
19201	\N	\N	\N	
19202	\N	\N	\N	
19203	\N	\N	\N	
19204	\N	\N	\N	
19205	\N	\N	\N	
19206	\N	\N	\N	
19207	\N	\N	\N	
19208	\N	\N	\N	
19209	\N	\N	\N	
19210	\N	\N	\N	
19211	\N	\N	\N	
19212	\N	\N	\N	
19213	\N	\N	\N	
19214	\N	\N	\N	
19215	\N	\N	\N	
19216	\N	\N	\N	
19217	\N	\N	\N	
19218	\N	\N	\N	
19219	\N	\N	\N	
19220	\N	\N	\N	
19221	\N	\N	\N	
19222	\N	\N	\N	
19223	\N	\N	\N	
19224	\N	\N	\N	
19225	\N	\N	\N	
19226	\N	\N	\N	
19227	\N	\N	\N	
19228	\N	\N	\N	
19229	\N	\N	\N	
19230	\N	\N	\N	
19231	\N	\N	\N	
19232	\N	\N	\N	
19233	\N	\N	\N	
19234	\N	\N	\N	
19235	\N	\N	\N	
19236	\N	\N	\N	
19237	\N	\N	\N	
19238	\N	\N	\N	
19239	\N	\N	\N	
19240	\N	\N	\N	
19241	\N	\N	\N	
19242	\N	\N	\N	
19243	\N	\N	\N	
19244	\N	\N	\N	
19245	\N	\N	\N	
19246	\N	\N	\N	
19247	\N	\N	\N	
19248	\N	\N	\N	
19249	\N	\N	\N	
19250	\N	\N	\N	
19251	\N	\N	\N	
19252	\N	\N	\N	
19253	\N	\N	\N	
19254	\N	\N	\N	
19255	\N	\N	\N	
19256	\N	\N	\N	
19257	\N	\N	\N	
19258	\N	\N	\N	
19259	\N	\N	\N	
19260	\N	\N	\N	
19261	\N	\N	\N	
19262	\N	\N	\N	
19263	\N	\N	\N	
19264	\N	\N	\N	
19265	\N	\N	\N	
19266	\N	\N	\N	
19267	\N	\N	\N	
19268	\N	\N	\N	
19269	\N	\N	\N	
19270	\N	\N	\N	
19271	\N	\N	\N	
19272	\N	\N	\N	
19273	\N	\N	\N	
19274	\N	\N	\N	
19275	\N	\N	\N	
19276	\N	\N	\N	
19277	\N	\N	\N	
19278	\N	\N	\N	
19279	\N	\N	\N	
19280	\N	\N	\N	
19281	\N	\N	\N	
19282	\N	\N	\N	
19283	\N	\N	\N	
19284	\N	\N	\N	
19285	\N	\N	\N	
19286	\N	\N	\N	
19287	\N	\N	\N	
19288	\N	\N	\N	
19289	\N	\N	\N	
19290	\N	\N	\N	
19291	\N	\N	\N	
19292	\N	\N	\N	
19293	\N	\N	\N	
19294	\N	\N	\N	
19295	\N	\N	\N	
19296	\N	\N	\N	
19297	\N	\N	\N	
19298	\N	\N	\N	
19299	\N	\N	\N	
19300	\N	\N	\N	
19301	\N	\N	\N	
19302	\N	\N	\N	
19303	\N	\N	\N	
19304	\N	\N	\N	
19305	\N	\N	\N	
19306	\N	\N	\N	
19307	\N	\N	\N	
19308	\N	\N	\N	
19309	\N	\N	\N	
19310	\N	\N	\N	
19311	\N	\N	\N	
19312	\N	\N	\N	
19313	\N	\N	\N	
19314	\N	\N	\N	
19315	\N	\N	\N	
19316	\N	\N	\N	
19317	\N	\N	\N	
19318	\N	\N	\N	
19319	\N	\N	\N	
19320	\N	\N	\N	
19321	\N	\N	\N	
19322	\N	\N	\N	
19323	\N	\N	\N	
19324	\N	\N	\N	
19325	\N	\N	\N	
19326	\N	\N	\N	
19327	\N	\N	\N	
19328	\N	\N	\N	
19329	\N	\N	\N	
19330	\N	\N	\N	
19331	\N	\N	\N	
19332	\N	\N	\N	
19333	\N	\N	\N	
19334	\N	\N	\N	
19335	\N	\N	\N	
19336	\N	\N	\N	
19337	\N	\N	\N	
19338	\N	\N	\N	
19339	\N	\N	\N	
19340	\N	\N	\N	
19341	\N	\N	\N	
19342	\N	\N	\N	
19343	\N	\N	\N	
19344	\N	\N	\N	
19345	\N	\N	\N	
19346	\N	\N	\N	
19347	\N	\N	\N	
19348	\N	\N	\N	
19349	\N	\N	\N	
19350	\N	\N	\N	
19351	\N	\N	\N	
19352	\N	\N	\N	
19353	\N	\N	\N	
19354	\N	\N	\N	
19355	\N	\N	\N	
19356	\N	\N	\N	
19357	\N	\N	\N	
19358	\N	\N	\N	
19359	\N	\N	\N	
19360	\N	\N	\N	
19361	\N	\N	\N	
19362	\N	\N	\N	
19363	\N	\N	\N	
19364	\N	\N	\N	
19365	\N	\N	\N	
19366	\N	\N	\N	
19367	\N	\N	\N	
19368	\N	\N	\N	
19369	\N	\N	\N	
19370	\N	\N	\N	
19371	\N	\N	\N	
19372	\N	\N	\N	
19373	\N	\N	\N	
19374	\N	\N	\N	
19375	\N	\N	\N	
19376	\N	\N	\N	
19377	\N	\N	\N	
19378	\N	\N	\N	
19379	\N	\N	\N	
19380	\N	\N	\N	
19381	\N	\N	\N	
19382	\N	\N	\N	
19383	\N	\N	\N	
19384	\N	\N	\N	
19385	\N	\N	\N	
19386	\N	\N	\N	
19387	\N	\N	\N	
19388	\N	\N	\N	
19389	\N	\N	\N	
19390	\N	\N	\N	
19391	\N	\N	\N	
19392	\N	\N	\N	
19393	\N	\N	\N	
19394	\N	\N	\N	
19395	\N	\N	\N	
19396	\N	\N	\N	
19397	\N	\N	\N	
19398	\N	\N	\N	
19399	\N	\N	\N	
19400	\N	\N	\N	
19401	\N	\N	\N	
19402	\N	\N	\N	
19403	\N	\N	\N	
19404	\N	\N	\N	
19405	\N	\N	\N	
19406	\N	\N	\N	
19407	\N	\N	\N	
19408	\N	\N	\N	
19409	\N	\N	\N	
19410	\N	\N	\N	
19411	\N	\N	\N	
19412	\N	\N	\N	
19413	\N	\N	\N	
19414	\N	\N	\N	
19415	\N	\N	\N	
19416	\N	\N	\N	
19417	\N	\N	\N	
19418	\N	\N	\N	
19419	\N	\N	\N	
19420	\N	\N	\N	
19421	\N	\N	\N	
19422	\N	\N	\N	
19423	\N	\N	\N	
19424	\N	\N	\N	
19425	\N	\N	\N	
19426	\N	\N	\N	
19427	\N	\N	\N	
19428	\N	\N	\N	
19429	\N	\N	\N	
19430	\N	\N	\N	
19431	\N	\N	\N	
19432	\N	\N	\N	
19433	\N	\N	\N	
19434	\N	\N	\N	
19435	\N	\N	\N	
19436	\N	\N	\N	
19437	\N	\N	\N	
19438	\N	\N	\N	
19439	\N	\N	\N	
19440	\N	\N	\N	
19441	\N	\N	\N	
19442	\N	\N	\N	
19443	\N	\N	\N	
19444	\N	\N	\N	
19445	\N	\N	\N	
19446	\N	\N	\N	
19447	\N	\N	\N	
19448	\N	\N	\N	
19449	\N	\N	\N	
19450	\N	\N	\N	
19451	\N	\N	\N	
19452	\N	\N	\N	
19453	\N	\N	\N	
19454	\N	\N	\N	
19455	\N	\N	\N	
19456	\N	\N	\N	
19457	\N	\N	\N	
19458	\N	\N	\N	
19459	\N	\N	\N	
19460	\N	\N	\N	
19461	\N	\N	\N	
19462	\N	\N	\N	
19463	\N	\N	\N	
19464	\N	\N	\N	
19465	\N	\N	\N	
19466	\N	\N	\N	
19467	\N	\N	\N	
19468	\N	\N	\N	
19469	\N	\N	\N	
19470	\N	\N	\N	
19471	\N	\N	\N	
19472	\N	\N	\N	
19473	\N	\N	\N	
19474	\N	\N	\N	
19475	\N	\N	\N	
19476	\N	\N	\N	
19477	\N	\N	\N	
19478	\N	\N	\N	
19479	\N	\N	\N	
19480	\N	\N	\N	
19481	\N	\N	\N	
19482	\N	\N	\N	
19483	\N	\N	\N	
19484	\N	\N	\N	
19485	\N	\N	\N	
19486	\N	\N	\N	
19487	\N	\N	\N	
19488	\N	\N	\N	
19489	\N	\N	\N	
19490	\N	\N	\N	
19491	\N	\N	\N	
19492	\N	\N	\N	
19493	\N	\N	\N	
19494	\N	\N	\N	
19495	\N	\N	\N	
19496	\N	\N	\N	
19497	\N	\N	\N	
19498	\N	\N	\N	
19499	\N	\N	\N	
19500	\N	\N	\N	
19501	\N	\N	\N	
19502	\N	\N	\N	
19503	\N	\N	\N	
19504	\N	\N	\N	
19505	\N	\N	\N	
19506	\N	\N	\N	
19507	\N	\N	\N	
19508	\N	\N	\N	
19509	\N	\N	\N	
19510	\N	\N	\N	
19511	\N	\N	\N	
19512	\N	\N	\N	
19513	\N	\N	\N	
19514	\N	\N	\N	
19515	\N	\N	\N	
19516	\N	\N	\N	
19517	\N	\N	\N	
19518	\N	\N	\N	
19519	\N	\N	\N	
19520	\N	\N	\N	
19521	\N	\N	\N	
19522	\N	\N	\N	
19523	\N	\N	\N	
19524	\N	\N	\N	
19525	\N	\N	\N	
19526	\N	\N	\N	
19527	\N	\N	\N	
19528	\N	\N	\N	
19529	\N	\N	\N	
19530	\N	\N	\N	
19531	\N	\N	\N	
19532	\N	\N	\N	
19533	\N	\N	\N	
19534	\N	\N	\N	
19535	\N	\N	\N	
19536	\N	\N	\N	
19537	\N	\N	\N	
19538	\N	\N	\N	
19539	\N	\N	\N	
19540	\N	\N	\N	
19541	\N	\N	\N	
19542	\N	\N	\N	
19543	\N	\N	\N	
19544	\N	\N	\N	
19545	\N	\N	\N	
19546	\N	\N	\N	
19547	\N	\N	\N	
19548	\N	\N	\N	
19549	\N	\N	\N	
19550	\N	\N	\N	
19551	\N	\N	\N	
19552	\N	\N	\N	
19553	\N	\N	\N	
19554	\N	\N	\N	
19555	\N	\N	\N	
19556	\N	\N	\N	
19557	\N	\N	\N	
19558	\N	\N	\N	
19559	\N	\N	\N	
19560	\N	\N	\N	
19561	\N	\N	\N	
19562	\N	\N	\N	
19563	\N	\N	\N	
19564	\N	\N	\N	
19565	\N	\N	\N	
19566	\N	\N	\N	
19567	\N	\N	\N	
19568	\N	\N	\N	
19569	\N	\N	\N	
19570	\N	\N	\N	
19571	\N	\N	\N	
19572	\N	\N	\N	
19573	\N	\N	\N	
19574	\N	\N	\N	
19575	\N	\N	\N	
19576	\N	\N	\N	
19577	\N	\N	\N	
19578	\N	\N	\N	
19579	\N	\N	\N	
19580	\N	\N	\N	
19581	\N	\N	\N	
19582	\N	\N	\N	
19583	\N	\N	\N	
19584	\N	\N	\N	
19585	\N	\N	\N	
19586	\N	\N	\N	
19587	\N	\N	\N	
19588	\N	\N	\N	
19589	\N	\N	\N	
19590	\N	\N	\N	
19591	\N	\N	\N	
19592	\N	\N	\N	
19593	\N	\N	\N	
19594	\N	\N	\N	
19595	\N	\N	\N	
19596	\N	\N	\N	
19597	\N	\N	\N	
19598	\N	\N	\N	
19599	\N	\N	\N	
19600	\N	\N	\N	
19601	\N	\N	\N	
19602	\N	\N	\N	
19603	\N	\N	\N	
19604	\N	\N	\N	
19605	\N	\N	\N	
19606	\N	\N	\N	
19607	\N	\N	\N	
19608	\N	\N	\N	
19609	\N	\N	\N	
19610	\N	\N	\N	
19611	\N	\N	\N	
19612	\N	\N	\N	
19613	\N	\N	\N	
19614	\N	\N	\N	
19615	\N	\N	\N	
19616	\N	\N	\N	
19617	\N	\N	\N	
19618	\N	\N	\N	
19619	\N	\N	\N	
19620	\N	\N	\N	
19621	\N	\N	\N	
19622	\N	\N	\N	
19623	\N	\N	\N	
19624	\N	\N	\N	
19625	\N	\N	\N	
19626	\N	\N	\N	
19627	\N	\N	\N	
19628	\N	\N	\N	
19629	\N	\N	\N	
19630	\N	\N	\N	
19631	\N	\N	\N	
19632	\N	\N	\N	
19633	\N	\N	\N	
19634	\N	\N	\N	
19635	\N	\N	\N	
19636	\N	\N	\N	
19637	\N	\N	\N	
19638	\N	\N	\N	
19639	\N	\N	\N	
19640	\N	\N	\N	
19641	\N	\N	\N	
19642	\N	\N	\N	
19643	\N	\N	\N	
19644	\N	\N	\N	
19645	\N	\N	\N	
19646	\N	\N	\N	
19647	\N	\N	\N	
19648	\N	\N	\N	
19649	\N	\N	\N	
19650	\N	\N	\N	
19651	\N	\N	\N	
19652	\N	\N	\N	
19653	\N	\N	\N	
19654	\N	\N	\N	
19655	\N	\N	\N	
19656	\N	\N	\N	
19657	\N	\N	\N	
19658	\N	\N	\N	
19659	\N	\N	\N	
19660	\N	\N	\N	
19661	\N	\N	\N	
19662	\N	\N	\N	
19663	\N	\N	\N	
19664	\N	\N	\N	
19665	\N	\N	\N	
19666	\N	\N	\N	
19667	\N	\N	\N	
19668	\N	\N	\N	
19669	\N	\N	\N	
19670	\N	\N	\N	
19671	\N	\N	\N	
19672	\N	\N	\N	
19673	\N	\N	\N	
19674	\N	\N	\N	
19675	\N	\N	\N	
19676	\N	\N	\N	
19677	\N	\N	\N	
19678	\N	\N	\N	
19679	\N	\N	\N	
19680	\N	\N	\N	
19681	\N	\N	\N	
19682	\N	\N	\N	
19683	\N	\N	\N	
19684	\N	\N	\N	
19685	\N	\N	\N	
19686	\N	\N	\N	
19687	\N	\N	\N	
19688	\N	\N	\N	
19689	\N	\N	\N	
19690	\N	\N	\N	
19691	\N	\N	\N	
19692	\N	\N	\N	
19693	\N	\N	\N	
19694	\N	\N	\N	
19695	\N	\N	\N	
19696	\N	\N	\N	
19697	\N	\N	\N	
19698	\N	\N	\N	
19699	\N	\N	\N	
19700	\N	\N	\N	
19701	\N	\N	\N	
19702	\N	\N	\N	
19703	\N	\N	\N	
19704	\N	\N	\N	
19705	\N	\N	\N	
19706	\N	\N	\N	
19707	\N	\N	\N	
19708	\N	\N	\N	
19709	\N	\N	\N	
19710	\N	\N	\N	
19711	\N	\N	\N	
19712	\N	\N	\N	
19713	\N	\N	\N	
19714	\N	\N	\N	
19715	\N	\N	\N	
19716	\N	\N	\N	
19717	\N	\N	\N	
19718	\N	\N	\N	
19719	\N	\N	\N	
19720	\N	\N	\N	
19721	\N	\N	\N	
19722	\N	\N	\N	
19723	\N	\N	\N	
19724	\N	\N	\N	
19725	\N	\N	\N	
19726	\N	\N	\N	
19727	\N	\N	\N	
19728	\N	\N	\N	
19729	\N	\N	\N	
19730	\N	\N	\N	
19731	\N	\N	\N	
19732	\N	\N	\N	
19733	\N	\N	\N	
19734	\N	\N	\N	
19735	\N	\N	\N	
19736	\N	\N	\N	
19737	\N	\N	\N	
19738	\N	\N	\N	
19739	\N	\N	\N	
19740	\N	\N	\N	
19741	\N	\N	\N	
19742	\N	\N	\N	
19743	\N	\N	\N	
19744	\N	\N	\N	
19745	\N	\N	\N	
19746	\N	\N	\N	
19747	\N	\N	\N	
19748	\N	\N	\N	
19749	\N	\N	\N	
19750	\N	\N	\N	
19751	\N	\N	\N	
19752	\N	\N	\N	
19753	\N	\N	\N	
19754	\N	\N	\N	
19755	\N	\N	\N	
19756	\N	\N	\N	
19757	\N	\N	\N	
19758	\N	\N	\N	
19759	\N	\N	\N	
19760	\N	\N	\N	
19761	\N	\N	\N	
19762	\N	\N	\N	
19763	\N	\N	\N	
19764	\N	\N	\N	
19765	\N	\N	\N	
19766	\N	\N	\N	
19767	\N	\N	\N	
19768	\N	\N	\N	
19769	\N	\N	\N	
19770	\N	\N	\N	
19771	\N	\N	\N	
19772	\N	\N	\N	
19773	\N	\N	\N	
19774	\N	\N	\N	
19775	\N	\N	\N	
19776	\N	\N	\N	
19777	\N	\N	\N	
19778	\N	\N	\N	
19779	\N	\N	\N	
19780	\N	\N	\N	
19781	\N	\N	\N	
19782	\N	\N	\N	
19783	\N	\N	\N	
19784	\N	\N	\N	
19785	\N	\N	\N	
19786	\N	\N	\N	
19787	\N	\N	\N	
19788	\N	\N	\N	
19789	\N	\N	\N	
19790	\N	\N	\N	
19791	\N	\N	\N	
19792	\N	\N	\N	
19793	\N	\N	\N	
19794	\N	\N	\N	
19795	\N	\N	\N	
19796	\N	\N	\N	
19797	\N	\N	\N	
19798	\N	\N	\N	
19799	\N	\N	\N	
19800	\N	\N	\N	
19801	\N	\N	\N	
19802	\N	\N	\N	
19803	\N	\N	\N	
19804	\N	\N	\N	
19805	\N	\N	\N	
19806	\N	\N	\N	
19807	\N	\N	\N	
19808	\N	\N	\N	
19809	\N	\N	\N	
19810	\N	\N	\N	
19811	\N	\N	\N	
19812	\N	\N	\N	
19813	\N	\N	\N	
19814	\N	\N	\N	
19815	\N	\N	\N	
19816	\N	\N	\N	
19817	\N	\N	\N	
19818	\N	\N	\N	
19819	\N	\N	\N	
19820	\N	\N	\N	
19821	\N	\N	\N	
19822	\N	\N	\N	
19823	\N	\N	\N	
19824	\N	\N	\N	
19825	\N	\N	\N	
19826	\N	\N	\N	
19827	\N	\N	\N	
19828	\N	\N	\N	
19829	\N	\N	\N	
19830	\N	\N	\N	
19831	\N	\N	\N	
19832	\N	\N	\N	
19833	\N	\N	\N	
19834	\N	\N	\N	
19835	\N	\N	\N	
19836	\N	\N	\N	
19837	\N	\N	\N	
19838	\N	\N	\N	
19839	\N	\N	\N	
19840	\N	\N	\N	
19841	\N	\N	\N	
19842	\N	\N	\N	
19843	\N	\N	\N	
19844	\N	\N	\N	
19845	\N	\N	\N	
19846	\N	\N	\N	
19847	\N	\N	\N	
19848	\N	\N	\N	
19849	\N	\N	\N	
19850	\N	\N	\N	
19851	\N	\N	\N	
19852	\N	\N	\N	
19853	\N	\N	\N	
19854	\N	\N	\N	
19855	\N	\N	\N	
19856	\N	\N	\N	
19857	\N	\N	\N	
19858	\N	\N	\N	
19859	\N	\N	\N	
19860	\N	\N	\N	
19861	\N	\N	\N	
19862	\N	\N	\N	
19863	\N	\N	\N	
19864	\N	\N	\N	
19865	\N	\N	\N	
19866	\N	\N	\N	
19867	\N	\N	\N	
19868	\N	\N	\N	
19869	\N	\N	\N	
19870	\N	\N	\N	
19871	\N	\N	\N	
19872	\N	\N	\N	
19873	\N	\N	\N	
19874	\N	\N	\N	
19875	\N	\N	\N	
19876	\N	\N	\N	
19877	\N	\N	\N	
19878	\N	\N	\N	
19879	\N	\N	\N	
19880	\N	\N	\N	
19881	\N	\N	\N	
19882	\N	\N	\N	
19883	\N	\N	\N	
19884	\N	\N	\N	
19885	\N	\N	\N	
19886	\N	\N	\N	
19887	\N	\N	\N	
19888	\N	\N	\N	
19889	\N	\N	\N	
19890	\N	\N	\N	
19891	\N	\N	\N	
19892	\N	\N	\N	
19893	\N	\N	\N	
19894	\N	\N	\N	
19895	\N	\N	\N	
19896	\N	\N	\N	
19897	\N	\N	\N	
19898	\N	\N	\N	
19899	\N	\N	\N	
19900	\N	\N	\N	
19901	\N	\N	\N	
19902	\N	\N	\N	
19903	\N	\N	\N	
19904	\N	\N	\N	
19905	\N	\N	\N	
19906	\N	\N	\N	
19907	\N	\N	\N	
19908	\N	\N	\N	
19909	\N	\N	\N	
19910	\N	\N	\N	
19911	\N	\N	\N	
19912	\N	\N	\N	
19913	\N	\N	\N	
19914	\N	\N	\N	
19915	\N	\N	\N	
19916	\N	\N	\N	
19917	\N	\N	\N	
19918	\N	\N	\N	
19919	\N	\N	\N	
19920	\N	\N	\N	
19921	\N	\N	\N	
19922	\N	\N	\N	
19923	\N	\N	\N	
19924	\N	\N	\N	
19925	\N	\N	\N	
19926	\N	\N	\N	
19927	\N	\N	\N	
19928	\N	\N	\N	
19929	\N	\N	\N	
19930	\N	\N	\N	
19931	\N	\N	\N	
19932	\N	\N	\N	
19933	\N	\N	\N	
19934	\N	\N	\N	
19935	\N	\N	\N	
19936	\N	\N	\N	
19937	\N	\N	\N	
19938	\N	\N	\N	
19939	\N	\N	\N	
19940	\N	\N	\N	
19941	\N	\N	\N	
19942	\N	\N	\N	
19943	\N	\N	\N	
19944	\N	\N	\N	
19945	\N	\N	\N	
19946	\N	\N	\N	
19947	\N	\N	\N	
19948	\N	\N	\N	
19949	\N	\N	\N	
19950	\N	\N	\N	
19951	\N	\N	\N	
19952	\N	\N	\N	
19953	\N	\N	\N	
19954	\N	\N	\N	
19955	\N	\N	\N	
19956	\N	\N	\N	
19957	\N	\N	\N	
19958	\N	\N	\N	
19959	\N	\N	\N	
19960	\N	\N	\N	
19961	\N	\N	\N	
19962	\N	\N	\N	
19963	\N	\N	\N	
19964	\N	\N	\N	
19965	\N	\N	\N	
19966	\N	\N	\N	
19967	\N	\N	\N	
19968	\N	\N	\N	
19969	\N	\N	\N	
19970	\N	\N	\N	
19971	\N	\N	\N	
19972	\N	\N	\N	
19973	\N	\N	\N	
19974	\N	\N	\N	
19975	\N	\N	\N	
19976	\N	\N	\N	
19977	\N	\N	\N	
19978	\N	\N	\N	
19979	\N	\N	\N	
19980	\N	\N	\N	
19981	\N	\N	\N	
19982	\N	\N	\N	
19983	\N	\N	\N	
19984	\N	\N	\N	
19985	\N	\N	\N	
19986	\N	\N	\N	
19987	\N	\N	\N	
19988	\N	\N	\N	
19989	\N	\N	\N	
19990	\N	\N	\N	
19991	\N	\N	\N	
19992	\N	\N	\N	
19993	\N	\N	\N	
19994	\N	\N	\N	
19995	\N	\N	\N	
19996	\N	\N	\N	
19997	\N	\N	\N	
19998	\N	\N	\N	
19999	\N	\N	\N	
20000	\N	\N	\N	
20001	\N	\N	\N	
20002	\N	\N	\N	
20003	\N	\N	\N	
20004	\N	\N	\N	
20005	\N	\N	\N	
20006	\N	\N	\N	
20007	\N	\N	\N	
20008	\N	\N	\N	
20009	\N	\N	\N	
20010	\N	\N	\N	
20011	\N	\N	\N	
20012	\N	\N	\N	
20013	\N	\N	\N	
20014	\N	\N	\N	
20015	\N	\N	\N	
20016	\N	\N	\N	
20017	\N	\N	\N	
20018	\N	\N	\N	
20019	\N	\N	\N	
20020	\N	\N	\N	
20021	\N	\N	\N	
20022	\N	\N	\N	
20023	\N	\N	\N	
20024	\N	\N	\N	
20025	\N	\N	\N	
20026	\N	\N	\N	
20027	\N	\N	\N	
20028	\N	\N	\N	
20029	\N	\N	\N	
20030	\N	\N	\N	
20031	\N	\N	\N	
20032	\N	\N	\N	
20033	\N	\N	\N	
20034	\N	\N	\N	
20035	\N	\N	\N	
20036	\N	\N	\N	
20037	\N	\N	\N	
20038	\N	\N	\N	
20039	\N	\N	\N	
20040	\N	\N	\N	
20041	\N	\N	\N	
20042	\N	\N	\N	
20043	\N	\N	\N	
20044	\N	\N	\N	
20045	\N	\N	\N	
20046	\N	\N	\N	
20047	\N	\N	\N	
20048	\N	\N	\N	
20049	\N	\N	\N	
20050	\N	\N	\N	
20051	\N	\N	\N	
20052	\N	\N	\N	
20053	\N	\N	\N	
20054	\N	\N	\N	
20055	\N	\N	\N	
20056	\N	\N	\N	
20057	\N	\N	\N	
20058	\N	\N	\N	
20059	\N	\N	\N	
20060	\N	\N	\N	
20061	\N	\N	\N	
20062	\N	\N	\N	
20063	\N	\N	\N	
20064	\N	\N	\N	
20065	\N	\N	\N	
20066	\N	\N	\N	
20067	\N	\N	\N	
20068	\N	\N	\N	
20069	\N	\N	\N	
20070	\N	\N	\N	
20071	\N	\N	\N	
20072	\N	\N	\N	
20073	\N	\N	\N	
20074	\N	\N	\N	
20075	\N	\N	\N	
20076	\N	\N	\N	
20077	\N	\N	\N	
20078	\N	\N	\N	
20079	\N	\N	\N	
20080	\N	\N	\N	
20081	\N	\N	\N	
20082	\N	\N	\N	
20083	\N	\N	\N	
20084	\N	\N	\N	
20085	\N	\N	\N	
20086	\N	\N	\N	
20087	\N	\N	\N	
20088	\N	\N	\N	
20089	\N	\N	\N	
20090	\N	\N	\N	
20091	\N	\N	\N	
20092	\N	\N	\N	
20093	\N	\N	\N	
20094	\N	\N	\N	
20095	\N	\N	\N	
20096	\N	\N	\N	
20097	\N	\N	\N	
20098	\N	\N	\N	
20099	\N	\N	\N	
20100	\N	\N	\N	
20101	\N	\N	\N	
20102	\N	\N	\N	
20103	\N	\N	\N	
20104	\N	\N	\N	
20105	\N	\N	\N	
20106	\N	\N	\N	
20107	\N	\N	\N	
20108	\N	\N	\N	
20109	\N	\N	\N	
20110	\N	\N	\N	
20111	\N	\N	\N	
20112	\N	\N	\N	
20113	\N	\N	\N	
20114	\N	\N	\N	
20115	\N	\N	\N	
20116	\N	\N	\N	
20117	\N	\N	\N	
20118	\N	\N	\N	
20119	\N	\N	\N	
20120	\N	\N	\N	
20121	\N	\N	\N	
20122	\N	\N	\N	
20123	\N	\N	\N	
20124	\N	\N	\N	
20125	\N	\N	\N	
20126	\N	\N	\N	
20127	\N	\N	\N	
20128	\N	\N	\N	
20129	\N	\N	\N	
20130	\N	\N	\N	
20131	\N	\N	\N	
20132	\N	\N	\N	
20133	\N	\N	\N	
20134	\N	\N	\N	
20135	\N	\N	\N	
20136	\N	\N	\N	
20137	\N	\N	\N	
20138	\N	\N	\N	
20139	\N	\N	\N	
20140	\N	\N	\N	
20141	\N	\N	\N	
20142	\N	\N	\N	
20143	\N	\N	\N	
20144	\N	\N	\N	
20145	\N	\N	\N	
20146	\N	\N	\N	
20147	\N	\N	\N	
20148	\N	\N	\N	
20149	\N	\N	\N	
20150	\N	\N	\N	
20151	\N	\N	\N	
20152	\N	\N	\N	
20153	\N	\N	\N	
20154	\N	\N	\N	
20155	\N	\N	\N	
20156	\N	\N	\N	
20157	\N	\N	\N	
20158	\N	\N	\N	
20159	\N	\N	\N	
20160	\N	\N	\N	
20161	\N	\N	\N	
20162	\N	\N	\N	
20163	\N	\N	\N	
20164	\N	\N	\N	
20165	\N	\N	\N	
20166	\N	\N	\N	
20167	\N	\N	\N	
20168	\N	\N	\N	
20169	\N	\N	\N	
20170	\N	\N	\N	
20171	\N	\N	\N	
20172	\N	\N	\N	
20173	\N	\N	\N	
20174	\N	\N	\N	
20175	\N	\N	\N	
20176	\N	\N	\N	
20177	\N	\N	\N	
20178	\N	\N	\N	
20179	\N	\N	\N	
20180	\N	\N	\N	
20181	\N	\N	\N	
20182	\N	\N	\N	
20183	\N	\N	\N	
20184	\N	\N	\N	
20185	\N	\N	\N	
20186	\N	\N	\N	
20187	\N	\N	\N	
20188	\N	\N	\N	
20189	\N	\N	\N	
20190	\N	\N	\N	
20191	\N	\N	\N	
20192	\N	\N	\N	
20193	\N	\N	\N	
20194	\N	\N	\N	
20195	\N	\N	\N	
20196	\N	\N	\N	
20197	\N	\N	\N	
20198	\N	\N	\N	
20199	\N	\N	\N	
20200	\N	\N	\N	
20201	\N	\N	\N	
20202	\N	\N	\N	
20203	\N	\N	\N	
20204	\N	\N	\N	
20205	\N	\N	\N	
20206	\N	\N	\N	
20207	\N	\N	\N	
20208	\N	\N	\N	
20209	\N	\N	\N	
20210	\N	\N	\N	
20211	\N	\N	\N	
20212	\N	\N	\N	
20213	\N	\N	\N	
20214	\N	\N	\N	
20215	\N	\N	\N	
20216	\N	\N	\N	
20217	\N	\N	\N	
20218	\N	\N	\N	
20219	\N	\N	\N	
20220	\N	\N	\N	
20221	\N	\N	\N	
20222	\N	\N	\N	
20223	\N	\N	\N	
20224	\N	\N	\N	
20225	\N	\N	\N	
20226	\N	\N	\N	
20227	\N	\N	\N	
20228	\N	\N	\N	
20229	\N	\N	\N	
20230	\N	\N	\N	
20231	\N	\N	\N	
20232	\N	\N	\N	
20233	\N	\N	\N	
20234	\N	\N	\N	
20235	\N	\N	\N	
20236	\N	\N	\N	
20237	\N	\N	\N	
20238	\N	\N	\N	
20239	\N	\N	\N	
20240	\N	\N	\N	
20241	\N	\N	\N	
20242	\N	\N	\N	
20243	\N	\N	\N	
20244	\N	\N	\N	
20245	\N	\N	\N	
20246	\N	\N	\N	
20247	\N	\N	\N	
20248	\N	\N	\N	
20249	\N	\N	\N	
20250	\N	\N	\N	
20251	\N	\N	\N	
20252	\N	\N	\N	
20253	\N	\N	\N	
20254	\N	\N	\N	
20255	\N	\N	\N	
20256	\N	\N	\N	
20257	\N	\N	\N	
20258	\N	\N	\N	
20259	\N	\N	\N	
20260	\N	\N	\N	
20261	\N	\N	\N	
20262	\N	\N	\N	
20263	\N	\N	\N	
20264	\N	\N	\N	
20265	\N	\N	\N	
20266	\N	\N	\N	
20267	\N	\N	\N	
20268	\N	\N	\N	
20269	\N	\N	\N	
20270	\N	\N	\N	
20271	\N	\N	\N	
20272	\N	\N	\N	
20273	\N	\N	\N	
20274	\N	\N	\N	
20275	\N	\N	\N	
20276	\N	\N	\N	
20277	\N	\N	\N	
20278	\N	\N	\N	
20279	\N	\N	\N	
20280	\N	\N	\N	
20281	\N	\N	\N	
20282	\N	\N	\N	
20283	\N	\N	\N	
20284	\N	\N	\N	
20285	\N	\N	\N	
20286	\N	\N	\N	
20287	\N	\N	\N	
20288	\N	\N	\N	
20289	\N	\N	\N	
20290	\N	\N	\N	
20291	\N	\N	\N	
20292	\N	\N	\N	
20293	\N	\N	\N	
20294	\N	\N	\N	
20295	\N	\N	\N	
20296	\N	\N	\N	
20297	\N	\N	\N	
20298	\N	\N	\N	
20299	\N	\N	\N	
20300	\N	\N	\N	
20301	\N	\N	\N	
20302	\N	\N	\N	
20303	\N	\N	\N	
20304	\N	\N	\N	
20305	\N	\N	\N	
20306	\N	\N	\N	
20307	\N	\N	\N	
20308	\N	\N	\N	
20309	\N	\N	\N	
20310	\N	\N	\N	
20311	\N	\N	\N	
20312	\N	\N	\N	
20313	\N	\N	\N	
20314	\N	\N	\N	
20315	\N	\N	\N	
20316	\N	\N	\N	
20317	\N	\N	\N	
20318	\N	\N	\N	
20319	\N	\N	\N	
20320	\N	\N	\N	
20321	\N	\N	\N	
20322	\N	\N	\N	
20323	\N	\N	\N	
20324	\N	\N	\N	
20325	\N	\N	\N	
20326	\N	\N	\N	
20327	\N	\N	\N	
20328	\N	\N	\N	
20329	\N	\N	\N	
20330	\N	\N	\N	
20331	\N	\N	\N	
20332	\N	\N	\N	
20333	\N	\N	\N	
20334	\N	\N	\N	
20335	\N	\N	\N	
20336	\N	\N	\N	
20337	\N	\N	\N	
20338	\N	\N	\N	
20339	\N	\N	\N	
20340	\N	\N	\N	
20341	\N	\N	\N	
20342	\N	\N	\N	
20343	\N	\N	\N	
20344	\N	\N	\N	
20345	\N	\N	\N	
20346	\N	\N	\N	
20347	\N	\N	\N	
20348	\N	\N	\N	
20349	\N	\N	\N	
20350	\N	\N	\N	
20351	\N	\N	\N	
20352	\N	\N	\N	
20353	\N	\N	\N	
20354	\N	\N	\N	
20355	\N	\N	\N	
20356	\N	\N	\N	
20357	\N	\N	\N	
20358	\N	\N	\N	
20359	\N	\N	\N	
20360	\N	\N	\N	
20361	\N	\N	\N	
20362	\N	\N	\N	
20363	\N	\N	\N	
20364	\N	\N	\N	
20365	\N	\N	\N	
20366	\N	\N	\N	
20367	\N	\N	\N	
20368	\N	\N	\N	
20369	\N	\N	\N	
20370	\N	\N	\N	
20371	\N	\N	\N	
20372	\N	\N	\N	
20373	\N	\N	\N	
20374	\N	\N	\N	
20375	\N	\N	\N	
20376	\N	\N	\N	
20377	\N	\N	\N	
20378	\N	\N	\N	
20379	\N	\N	\N	
20380	\N	\N	\N	
20381	\N	\N	\N	
20382	\N	\N	\N	
20383	\N	\N	\N	
20384	\N	\N	\N	
20385	\N	\N	\N	
20386	\N	\N	\N	
20387	\N	\N	\N	
20388	\N	\N	\N	
20389	\N	\N	\N	
20390	\N	\N	\N	
20391	\N	\N	\N	
20392	\N	\N	\N	
20393	\N	\N	\N	
20394	\N	\N	\N	
20395	\N	\N	\N	
20396	\N	\N	\N	
20397	\N	\N	\N	
20398	\N	\N	\N	
20399	\N	\N	\N	
20400	\N	\N	\N	
20401	\N	\N	\N	
20402	\N	\N	\N	
20403	\N	\N	\N	
20404	\N	\N	\N	
20405	\N	\N	\N	
20406	\N	\N	\N	
20407	\N	\N	\N	
20408	\N	\N	\N	
20409	\N	\N	\N	
20410	\N	\N	\N	
20411	\N	\N	\N	
20412	\N	\N	\N	
20413	\N	\N	\N	
20414	\N	\N	\N	
20415	\N	\N	\N	
20416	\N	\N	\N	
20417	\N	\N	\N	
20418	\N	\N	\N	
20419	\N	\N	\N	
20420	\N	\N	\N	
20421	\N	\N	\N	
20422	\N	\N	\N	
20423	\N	\N	\N	
20424	\N	\N	\N	
20425	\N	\N	\N	
20426	\N	\N	\N	
20427	\N	\N	\N	
20428	\N	\N	\N	
20429	\N	\N	\N	
20430	\N	\N	\N	
20431	\N	\N	\N	
20432	\N	\N	\N	
20433	\N	\N	\N	
20434	\N	\N	\N	
20435	\N	\N	\N	
20436	\N	\N	\N	
20437	\N	\N	\N	
20438	\N	\N	\N	
20439	\N	\N	\N	
20440	\N	\N	\N	
20441	\N	\N	\N	
20442	\N	\N	\N	
20443	\N	\N	\N	
20444	\N	\N	\N	
20445	\N	\N	\N	
20446	\N	\N	\N	
20447	\N	\N	\N	
20448	\N	\N	\N	
20449	\N	\N	\N	
20450	\N	\N	\N	
20451	\N	\N	\N	
20452	\N	\N	\N	
20453	\N	\N	\N	
20454	\N	\N	\N	
20455	\N	\N	\N	
20456	\N	\N	\N	
20457	\N	\N	\N	
20458	\N	\N	\N	
20459	\N	\N	\N	
20460	\N	\N	\N	
20461	\N	\N	\N	
20462	\N	\N	\N	
20463	\N	\N	\N	
20464	\N	\N	\N	
20465	\N	\N	\N	
20466	\N	\N	\N	
20467	\N	\N	\N	
20468	\N	\N	\N	
20469	\N	\N	\N	
20470	\N	\N	\N	
20471	\N	\N	\N	
20472	\N	\N	\N	
20473	\N	\N	\N	
20474	\N	\N	\N	
20475	\N	\N	\N	
20476	\N	\N	\N	
20477	\N	\N	\N	
20478	\N	\N	\N	
20479	\N	\N	\N	
20480	\N	\N	\N	
20481	\N	\N	\N	
20482	\N	\N	\N	
20483	\N	\N	\N	
20484	\N	\N	\N	
20485	\N	\N	\N	
20486	\N	\N	\N	
20487	\N	\N	\N	
20488	\N	\N	\N	
20489	\N	\N	\N	
20490	\N	\N	\N	
20491	\N	\N	\N	
20492	\N	\N	\N	
20493	\N	\N	\N	
20494	\N	\N	\N	
20495	\N	\N	\N	
20496	\N	\N	\N	
20497	\N	\N	\N	
20498	\N	\N	\N	
20499	\N	\N	\N	
20500	\N	\N	\N	
20501	\N	\N	\N	
20502	\N	\N	\N	
20503	\N	\N	\N	
20504	\N	\N	\N	
20505	\N	\N	\N	
20506	\N	\N	\N	
20507	\N	\N	\N	
20508	\N	\N	\N	
20509	\N	\N	\N	
20510	\N	\N	\N	
20511	\N	\N	\N	
20512	\N	\N	\N	
20513	\N	\N	\N	
20514	\N	\N	\N	
20515	\N	\N	\N	
20516	\N	\N	\N	
20517	\N	\N	\N	
20518	\N	\N	\N	
20519	\N	\N	\N	
20520	\N	\N	\N	
20521	\N	\N	\N	
20522	\N	\N	\N	
20523	\N	\N	\N	
20524	\N	\N	\N	
20525	\N	\N	\N	
20526	\N	\N	\N	
20527	\N	\N	\N	
20528	\N	\N	\N	
20529	\N	\N	\N	
20530	\N	\N	\N	
20531	\N	\N	\N	
20532	\N	\N	\N	
20533	\N	\N	\N	
20534	\N	\N	\N	
20535	\N	\N	\N	
20536	\N	\N	\N	
20537	\N	\N	\N	
20538	\N	\N	\N	
20539	\N	\N	\N	
20540	\N	\N	\N	
20541	\N	\N	\N	
20542	\N	\N	\N	
20543	\N	\N	\N	
20544	\N	\N	\N	
20545	\N	\N	\N	
20546	\N	\N	\N	
20547	\N	\N	\N	
20548	\N	\N	\N	
20549	\N	\N	\N	
20550	\N	\N	\N	
20551	\N	\N	\N	
20552	\N	\N	\N	
20553	\N	\N	\N	
20554	\N	\N	\N	
20555	\N	\N	\N	
20556	\N	\N	\N	
20557	\N	\N	\N	
20558	\N	\N	\N	
20559	\N	\N	\N	
20560	\N	\N	\N	
20561	\N	\N	\N	
20562	\N	\N	\N	
20563	\N	\N	\N	
20564	\N	\N	\N	
20565	\N	\N	\N	
20566	\N	\N	\N	
20567	\N	\N	\N	
20568	\N	\N	\N	
20569	\N	\N	\N	
20570	\N	\N	\N	
20571	\N	\N	\N	
20572	\N	\N	\N	
20573	\N	\N	\N	
20574	\N	\N	\N	
20575	\N	\N	\N	
20576	\N	\N	\N	
20577	\N	\N	\N	
20578	\N	\N	\N	
20579	\N	\N	\N	
20580	\N	\N	\N	
20581	\N	\N	\N	
20582	\N	\N	\N	
20583	\N	\N	\N	
20584	\N	\N	\N	
20585	\N	\N	\N	
20586	\N	\N	\N	
20587	\N	\N	\N	
20588	\N	\N	\N	
20589	\N	\N	\N	
20590	\N	\N	\N	
20591	\N	\N	\N	
20592	\N	\N	\N	
20593	\N	\N	\N	
20594	\N	\N	\N	
20595	\N	\N	\N	
20596	\N	\N	\N	
20597	\N	\N	\N	
20598	\N	\N	\N	
20599	\N	\N	\N	
20600	\N	\N	\N	
20601	\N	\N	\N	
20602	\N	\N	\N	
20603	\N	\N	\N	
20604	\N	\N	\N	
20605	\N	\N	\N	
20606	\N	\N	\N	
20607	\N	\N	\N	
20608	\N	\N	\N	
20609	\N	\N	\N	
20610	\N	\N	\N	
20611	\N	\N	\N	
20612	\N	\N	\N	
20613	\N	\N	\N	
20614	\N	\N	\N	
20615	\N	\N	\N	
20616	\N	\N	\N	
20617	\N	\N	\N	
20618	\N	\N	\N	
20619	\N	\N	\N	
20620	\N	\N	\N	
20621	\N	\N	\N	
20622	\N	\N	\N	
20623	\N	\N	\N	
20624	\N	\N	\N	
20625	\N	\N	\N	
20626	\N	\N	\N	
20627	\N	\N	\N	
20628	\N	\N	\N	
20629	\N	\N	\N	
20630	\N	\N	\N	
20631	\N	\N	\N	
20632	\N	\N	\N	
20633	\N	\N	\N	
20634	\N	\N	\N	
20635	\N	\N	\N	
20636	\N	\N	\N	
20637	\N	\N	\N	
20638	\N	\N	\N	
20639	\N	\N	\N	
20640	\N	\N	\N	
20641	\N	\N	\N	
20642	\N	\N	\N	
20643	\N	\N	\N	
20644	\N	\N	\N	
20645	\N	\N	\N	
20646	\N	\N	\N	
20647	\N	\N	\N	
20648	\N	\N	\N	
20649	\N	\N	\N	
20650	\N	\N	\N	
20651	\N	\N	\N	
20652	\N	\N	\N	
20653	\N	\N	\N	
20654	\N	\N	\N	
20655	\N	\N	\N	
20656	\N	\N	\N	
20657	\N	\N	\N	
20658	\N	\N	\N	
20659	\N	\N	\N	
20660	\N	\N	\N	
20661	\N	\N	\N	
20662	\N	\N	\N	
20663	\N	\N	\N	
20664	\N	\N	\N	
20665	\N	\N	\N	
20666	\N	\N	\N	
20667	\N	\N	\N	
20668	\N	\N	\N	
20669	\N	\N	\N	
20670	\N	\N	\N	
20671	\N	\N	\N	
20672	\N	\N	\N	
20673	\N	\N	\N	
20674	\N	\N	\N	
20675	\N	\N	\N	
20676	\N	\N	\N	
20677	\N	\N	\N	
20678	\N	\N	\N	
20679	\N	\N	\N	
20680	\N	\N	\N	
20681	\N	\N	\N	
20682	\N	\N	\N	
20683	\N	\N	\N	
20684	\N	\N	\N	
20685	\N	\N	\N	
20686	\N	\N	\N	
20687	\N	\N	\N	
20688	\N	\N	\N	
20689	\N	\N	\N	
20690	\N	\N	\N	
20691	\N	\N	\N	
20692	\N	\N	\N	
20693	\N	\N	\N	
20694	\N	\N	\N	
20695	\N	\N	\N	
20696	\N	\N	\N	
20697	\N	\N	\N	
20698	\N	\N	\N	
20699	\N	\N	\N	
20700	\N	\N	\N	
20701	\N	\N	\N	
20702	\N	\N	\N	
20703	\N	\N	\N	
20704	\N	\N	\N	
20705	\N	\N	\N	
20706	\N	\N	\N	
20707	\N	\N	\N	
20708	\N	\N	\N	
20709	\N	\N	\N	
20710	\N	\N	\N	
20711	\N	\N	\N	
20712	\N	\N	\N	
20713	\N	\N	\N	
20714	\N	\N	\N	
20715	\N	\N	\N	
20716	\N	\N	\N	
20717	\N	\N	\N	
20718	\N	\N	\N	
20719	\N	\N	\N	
20720	\N	\N	\N	
20721	\N	\N	\N	
20722	\N	\N	\N	
20723	\N	\N	\N	
20724	\N	\N	\N	
20725	\N	\N	\N	
20726	\N	\N	\N	
20727	\N	\N	\N	
20728	\N	\N	\N	
20729	\N	\N	\N	
20730	\N	\N	\N	
20731	\N	\N	\N	
20732	\N	\N	\N	
20733	\N	\N	\N	
20734	\N	\N	\N	
20735	\N	\N	\N	
20736	\N	\N	\N	
20737	\N	\N	\N	
20738	\N	\N	\N	
20739	\N	\N	\N	
20740	\N	\N	\N	
20741	\N	\N	\N	
20742	\N	\N	\N	
20743	\N	\N	\N	
20744	\N	\N	\N	
20745	\N	\N	\N	
20746	\N	\N	\N	
20747	\N	\N	\N	
20748	\N	\N	\N	
20749	\N	\N	\N	
20750	\N	\N	\N	
20751	\N	\N	\N	
20752	\N	\N	\N	
20753	\N	\N	\N	
20754	\N	\N	\N	
20755	\N	\N	\N	
20756	\N	\N	\N	
20757	\N	\N	\N	
20758	\N	\N	\N	
20759	\N	\N	\N	
20760	\N	\N	\N	
20761	\N	\N	\N	
20762	\N	\N	\N	
20763	\N	\N	\N	
20764	\N	\N	\N	
20765	\N	\N	\N	
20766	\N	\N	\N	
20767	\N	\N	\N	
20768	\N	\N	\N	
20769	\N	\N	\N	
20770	\N	\N	\N	
20771	\N	\N	\N	
20772	\N	\N	\N	
20773	\N	\N	\N	
20774	\N	\N	\N	
20775	\N	\N	\N	
20776	\N	\N	\N	
20777	\N	\N	\N	
20778	\N	\N	\N	
20779	\N	\N	\N	
20780	\N	\N	\N	
20781	\N	\N	\N	
20782	\N	\N	\N	
20783	\N	\N	\N	
20784	\N	\N	\N	
20785	\N	\N	\N	
20786	\N	\N	\N	
20787	\N	\N	\N	
20788	\N	\N	\N	
20789	\N	\N	\N	
20790	\N	\N	\N	
20791	\N	\N	\N	
20792	\N	\N	\N	
20793	\N	\N	\N	
20794	\N	\N	\N	
20795	\N	\N	\N	
20796	\N	\N	\N	
20797	\N	\N	\N	
20798	\N	\N	\N	
20799	\N	\N	\N	
20800	\N	\N	\N	
20801	\N	\N	\N	
20802	\N	\N	\N	
20803	\N	\N	\N	
20804	\N	\N	\N	
20805	\N	\N	\N	
20806	\N	\N	\N	
20807	\N	\N	\N	
20808	\N	\N	\N	
20809	\N	\N	\N	
20810	\N	\N	\N	
20811	\N	\N	\N	
20812	\N	\N	\N	
20813	\N	\N	\N	
20814	\N	\N	\N	
20815	\N	\N	\N	
20816	\N	\N	\N	
20817	\N	\N	\N	
20818	\N	\N	\N	
20819	\N	\N	\N	
20820	\N	\N	\N	
20821	\N	\N	\N	
20822	\N	\N	\N	
20823	\N	\N	\N	
20824	\N	\N	\N	
20825	\N	\N	\N	
20826	\N	\N	\N	
20827	\N	\N	\N	
20828	\N	\N	\N	
20829	\N	\N	\N	
20830	\N	\N	\N	
20831	\N	\N	\N	
20832	\N	\N	\N	
20833	\N	\N	\N	
20834	\N	\N	\N	
20835	\N	\N	\N	
20836	\N	\N	\N	
20837	\N	\N	\N	
20838	\N	\N	\N	
20839	\N	\N	\N	
20840	\N	\N	\N	
20841	\N	\N	\N	
20842	\N	\N	\N	
20843	\N	\N	\N	
20844	\N	\N	\N	
20845	\N	\N	\N	
20846	\N	\N	\N	
20847	\N	\N	\N	
20848	\N	\N	\N	
20849	\N	\N	\N	
20850	\N	\N	\N	
20851	\N	\N	\N	
20852	\N	\N	\N	
20853	\N	\N	\N	
20854	\N	\N	\N	
20855	\N	\N	\N	
20856	\N	\N	\N	
20857	\N	\N	\N	
20858	\N	\N	\N	
20859	\N	\N	\N	
20860	\N	\N	\N	
20861	\N	\N	\N	
20862	\N	\N	\N	
20863	\N	\N	\N	
20864	\N	\N	\N	
20865	\N	\N	\N	
20866	\N	\N	\N	
20867	\N	\N	\N	
20868	\N	\N	\N	
20869	\N	\N	\N	
20870	\N	\N	\N	
20871	\N	\N	\N	
20872	\N	\N	\N	
20873	\N	\N	\N	
20874	\N	\N	\N	
20875	\N	\N	\N	
20876	\N	\N	\N	
20877	\N	\N	\N	
20878	\N	\N	\N	
20879	\N	\N	\N	
20880	\N	\N	\N	
20881	\N	\N	\N	
20882	\N	\N	\N	
20883	\N	\N	\N	
20884	\N	\N	\N	
20885	\N	\N	\N	
20886	\N	\N	\N	
20887	\N	\N	\N	
20888	\N	\N	\N	
20889	\N	\N	\N	
20890	\N	\N	\N	
20891	\N	\N	\N	
20892	\N	\N	\N	
20893	\N	\N	\N	
20894	\N	\N	\N	
20895	\N	\N	\N	
20896	\N	\N	\N	
20897	\N	\N	\N	
20898	\N	\N	\N	
20899	\N	\N	\N	
20900	\N	\N	\N	
20901	\N	\N	\N	
20902	\N	\N	\N	
20903	\N	\N	\N	
20904	\N	\N	\N	
20905	\N	\N	\N	
20906	\N	\N	\N	
20907	\N	\N	\N	
20908	\N	\N	\N	
20909	\N	\N	\N	
20910	\N	\N	\N	
20911	\N	\N	\N	
20912	\N	\N	\N	
20913	\N	\N	\N	
20914	\N	\N	\N	
20915	\N	\N	\N	
20916	\N	\N	\N	
20917	\N	\N	\N	
20918	\N	\N	\N	
20919	\N	\N	\N	
20920	\N	\N	\N	
20921	\N	\N	\N	
20922	\N	\N	\N	
20923	\N	\N	\N	
20924	\N	\N	\N	
20925	\N	\N	\N	
20926	\N	\N	\N	
20927	\N	\N	\N	
20928	\N	\N	\N	
20929	\N	\N	\N	
20930	\N	\N	\N	
20931	\N	\N	\N	
20932	\N	\N	\N	
20933	\N	\N	\N	
20934	\N	\N	\N	
20935	\N	\N	\N	
20936	\N	\N	\N	
20937	\N	\N	\N	
20938	\N	\N	\N	
20939	\N	\N	\N	
20940	\N	\N	\N	
20941	\N	\N	\N	
20942	\N	\N	\N	
20943	\N	\N	\N	
20944	\N	\N	\N	
20945	\N	\N	\N	
20946	\N	\N	\N	
20947	\N	\N	\N	
20948	\N	\N	\N	
20949	\N	\N	\N	
20950	\N	\N	\N	
20951	\N	\N	\N	
20952	\N	\N	\N	
20953	\N	\N	\N	
20954	\N	\N	\N	
20955	\N	\N	\N	
20956	\N	\N	\N	
20957	\N	\N	\N	
20958	\N	\N	\N	
20959	\N	\N	\N	
20960	\N	\N	\N	
20961	\N	\N	\N	
20962	\N	\N	\N	
20963	\N	\N	\N	
20964	\N	\N	\N	
20965	\N	\N	\N	
20966	\N	\N	\N	
20967	\N	\N	\N	
20968	\N	\N	\N	
20969	\N	\N	\N	
20970	\N	\N	\N	
20971	\N	\N	\N	
20972	\N	\N	\N	
20973	\N	\N	\N	
20974	\N	\N	\N	
20975	\N	\N	\N	
20976	\N	\N	\N	
20977	\N	\N	\N	
20978	\N	\N	\N	
20979	\N	\N	\N	
20980	\N	\N	\N	
20981	\N	\N	\N	
20982	\N	\N	\N	
20983	\N	\N	\N	
20984	\N	\N	\N	
20985	\N	\N	\N	
20986	\N	\N	\N	
20987	\N	\N	\N	
20988	\N	\N	\N	
20989	\N	\N	\N	
20990	\N	\N	\N	
20991	\N	\N	\N	
20992	\N	\N	\N	
20993	\N	\N	\N	
20994	\N	\N	\N	
20995	\N	\N	\N	
20996	\N	\N	\N	
20997	\N	\N	\N	
20998	\N	\N	\N	
20999	\N	\N	\N	
21000	\N	\N	\N	
21001	\N	\N	\N	
21002	\N	\N	\N	
21003	\N	\N	\N	
21004	\N	\N	\N	
21005	\N	\N	\N	
21006	\N	\N	\N	
21007	\N	\N	\N	
21008	\N	\N	\N	
21009	\N	\N	\N	
21010	\N	\N	\N	
21011	\N	\N	\N	
21012	\N	\N	\N	
21013	\N	\N	\N	
21014	\N	\N	\N	
21015	\N	\N	\N	
21016	\N	\N	\N	
21017	\N	\N	\N	
21018	\N	\N	\N	
21019	\N	\N	\N	
21020	\N	\N	\N	
21021	\N	\N	\N	
21022	\N	\N	\N	
21023	\N	\N	\N	
21024	\N	\N	\N	
21025	\N	\N	\N	
21026	\N	\N	\N	
21027	\N	\N	\N	
21028	\N	\N	\N	
21029	\N	\N	\N	
21030	\N	\N	\N	
21031	\N	\N	\N	
21032	\N	\N	\N	
21033	\N	\N	\N	
21034	\N	\N	\N	
21035	\N	\N	\N	
21036	\N	\N	\N	
21037	\N	\N	\N	
21038	\N	\N	\N	
21039	\N	\N	\N	
21040	\N	\N	\N	
21041	\N	\N	\N	
21042	\N	\N	\N	
21043	\N	\N	\N	
21044	\N	\N	\N	
21045	\N	\N	\N	
21046	\N	\N	\N	
21047	\N	\N	\N	
21048	\N	\N	\N	
21049	\N	\N	\N	
21050	\N	\N	\N	
21051	\N	\N	\N	
21052	\N	\N	\N	
21053	\N	\N	\N	
21054	\N	\N	\N	
21055	\N	\N	\N	
21056	\N	\N	\N	
21057	\N	\N	\N	
21058	\N	\N	\N	
21059	\N	\N	\N	
21060	\N	\N	\N	
21061	\N	\N	\N	
21062	\N	\N	\N	
21063	\N	\N	\N	
21064	\N	\N	\N	
21065	\N	\N	\N	
21066	\N	\N	\N	
21067	\N	\N	\N	
21068	\N	\N	\N	
21069	\N	\N	\N	
21070	\N	\N	\N	
21071	\N	\N	\N	
21072	\N	\N	\N	
21073	\N	\N	\N	
21074	\N	\N	\N	
21075	\N	\N	\N	
21076	\N	\N	\N	
21077	\N	\N	\N	
21078	\N	\N	\N	
21079	\N	\N	\N	
21080	\N	\N	\N	
21081	\N	\N	\N	
21082	\N	\N	\N	
21083	\N	\N	\N	
21084	\N	\N	\N	
21085	\N	\N	\N	
21086	\N	\N	\N	
21087	\N	\N	\N	
21088	\N	\N	\N	
21089	\N	\N	\N	
21090	\N	\N	\N	
21091	\N	\N	\N	
21092	\N	\N	\N	
21093	\N	\N	\N	
21094	\N	\N	\N	
21095	\N	\N	\N	
21096	\N	\N	\N	
21097	\N	\N	\N	
21098	\N	\N	\N	
21099	\N	\N	\N	
21100	\N	\N	\N	
21101	\N	\N	\N	
21102	\N	\N	\N	
21103	\N	\N	\N	
21104	\N	\N	\N	
21105	\N	\N	\N	
21106	\N	\N	\N	
21107	\N	\N	\N	
21108	\N	\N	\N	
21109	\N	\N	\N	
21110	\N	\N	\N	
21111	\N	\N	\N	
21112	\N	\N	\N	
21113	\N	\N	\N	
21114	\N	\N	\N	
21115	\N	\N	\N	
21116	\N	\N	\N	
21117	\N	\N	\N	
21118	\N	\N	\N	
21119	\N	\N	\N	
21120	\N	\N	\N	
21121	\N	\N	\N	
21122	\N	\N	\N	
21123	\N	\N	\N	
21124	\N	\N	\N	
21125	\N	\N	\N	
21126	\N	\N	\N	
21127	\N	\N	\N	
21128	\N	\N	\N	
21129	\N	\N	\N	
21130	\N	\N	\N	
21131	\N	\N	\N	
21132	\N	\N	\N	
21133	\N	\N	\N	
21134	\N	\N	\N	
21135	\N	\N	\N	
21136	\N	\N	\N	
21137	\N	\N	\N	
21138	\N	\N	\N	
21139	\N	\N	\N	
21140	\N	\N	\N	
21141	\N	\N	\N	
21142	\N	\N	\N	
21143	\N	\N	\N	
21144	\N	\N	\N	
21145	\N	\N	\N	
21146	\N	\N	\N	
21147	\N	\N	\N	
21148	\N	\N	\N	
21149	\N	\N	\N	
21150	\N	\N	\N	
21151	\N	\N	\N	
21152	\N	\N	\N	
21153	\N	\N	\N	
21154	\N	\N	\N	
21155	\N	\N	\N	
21156	\N	\N	\N	
21157	\N	\N	\N	
21158	\N	\N	\N	
21159	\N	\N	\N	
21160	\N	\N	\N	
21161	\N	\N	\N	
21162	\N	\N	\N	
21163	\N	\N	\N	
21164	\N	\N	\N	
21165	\N	\N	\N	
21166	\N	\N	\N	
21167	\N	\N	\N	
21168	\N	\N	\N	
21169	\N	\N	\N	
21170	\N	\N	\N	
21171	\N	\N	\N	
21172	\N	\N	\N	
21173	\N	\N	\N	
21174	\N	\N	\N	
21175	\N	\N	\N	
21176	\N	\N	\N	
21177	\N	\N	\N	
21178	\N	\N	\N	
21179	\N	\N	\N	
21180	\N	\N	\N	
21181	\N	\N	\N	
21182	\N	\N	\N	
21183	\N	\N	\N	
21184	\N	\N	\N	
21185	\N	\N	\N	
21186	\N	\N	\N	
21187	\N	\N	\N	
21188	\N	\N	\N	
21189	\N	\N	\N	
21190	\N	\N	\N	
21191	\N	\N	\N	
21192	\N	\N	\N	
21193	\N	\N	\N	
21194	\N	\N	\N	
21195	\N	\N	\N	
21196	\N	\N	\N	
21197	\N	\N	\N	
21198	\N	\N	\N	
21199	\N	\N	\N	
21200	\N	\N	\N	
21201	\N	\N	\N	
21202	\N	\N	\N	
21203	\N	\N	\N	
21204	\N	\N	\N	
21205	\N	\N	\N	
21206	\N	\N	\N	
21207	\N	\N	\N	
21208	\N	\N	\N	
21209	\N	\N	\N	
21210	\N	\N	\N	
21211	\N	\N	\N	
21212	\N	\N	\N	
21213	\N	\N	\N	
21214	\N	\N	\N	
21215	\N	\N	\N	
21216	\N	\N	\N	
21217	\N	\N	\N	
21218	\N	\N	\N	
21219	\N	\N	\N	
21220	\N	\N	\N	
21221	\N	\N	\N	
21222	\N	\N	\N	
21223	\N	\N	\N	
21224	\N	\N	\N	
21225	\N	\N	\N	
21226	\N	\N	\N	
21227	\N	\N	\N	
21228	\N	\N	\N	
21229	\N	\N	\N	
21230	\N	\N	\N	
21231	\N	\N	\N	
21232	\N	\N	\N	
21233	\N	\N	\N	
21234	\N	\N	\N	
21235	\N	\N	\N	
21236	\N	\N	\N	
21237	\N	\N	\N	
21238	\N	\N	\N	
21239	\N	\N	\N	
21240	\N	\N	\N	
21241	\N	\N	\N	
21242	\N	\N	\N	
21243	\N	\N	\N	
21244	\N	\N	\N	
21245	\N	\N	\N	
21246	\N	\N	\N	
21247	\N	\N	\N	
21248	\N	\N	\N	
21249	\N	\N	\N	
21250	\N	\N	\N	
21251	\N	\N	\N	
21252	\N	\N	\N	
21253	\N	\N	\N	
21254	\N	\N	\N	
21255	\N	\N	\N	
21256	\N	\N	\N	
21257	\N	\N	\N	
21258	\N	\N	\N	
21259	\N	\N	\N	
21260	\N	\N	\N	
21261	\N	\N	\N	
21262	\N	\N	\N	
21263	\N	\N	\N	
21264	\N	\N	\N	
21265	\N	\N	\N	
21266	\N	\N	\N	
21267	\N	\N	\N	
21268	\N	\N	\N	
21269	\N	\N	\N	
21270	\N	\N	\N	
21271	\N	\N	\N	
21272	\N	\N	\N	
21273	\N	\N	\N	
21274	\N	\N	\N	
21275	\N	\N	\N	
21276	\N	\N	\N	
21277	\N	\N	\N	
21278	\N	\N	\N	
21279	\N	\N	\N	
21280	\N	\N	\N	
21281	\N	\N	\N	
21282	\N	\N	\N	
21283	\N	\N	\N	
21284	\N	\N	\N	
21285	\N	\N	\N	
21286	\N	\N	\N	
21287	\N	\N	\N	
21288	\N	\N	\N	
21289	\N	\N	\N	
21290	\N	\N	\N	
21291	\N	\N	\N	
21292	\N	\N	\N	
21293	\N	\N	\N	
21294	\N	\N	\N	
21295	\N	\N	\N	
21296	\N	\N	\N	
21297	\N	\N	\N	
21298	\N	\N	\N	
21299	\N	\N	\N	
21300	\N	\N	\N	
21301	\N	\N	\N	
21302	\N	\N	\N	
21303	\N	\N	\N	
21304	\N	\N	\N	
21305	\N	\N	\N	
21306	\N	\N	\N	
21307	\N	\N	\N	
21308	\N	\N	\N	
21309	\N	\N	\N	
21310	\N	\N	\N	
21311	\N	\N	\N	
21312	\N	\N	\N	
21313	\N	\N	\N	
21314	\N	\N	\N	
21315	\N	\N	\N	
21316	\N	\N	\N	
21317	\N	\N	\N	
21318	\N	\N	\N	
21319	\N	\N	\N	
21320	\N	\N	\N	
21321	\N	\N	\N	
21322	\N	\N	\N	
21323	\N	\N	\N	
21324	\N	\N	\N	
21325	\N	\N	\N	
21326	\N	\N	\N	
21327	\N	\N	\N	
21328	\N	\N	\N	
21329	\N	\N	\N	
21330	\N	\N	\N	
21331	\N	\N	\N	
21332	\N	\N	\N	
21333	\N	\N	\N	
21334	\N	\N	\N	
21335	\N	\N	\N	
21336	\N	\N	\N	
21337	\N	\N	\N	
21338	\N	\N	\N	
21339	\N	\N	\N	
21340	\N	\N	\N	
21341	\N	\N	\N	
21342	\N	\N	\N	
21343	\N	\N	\N	
21344	\N	\N	\N	
21345	\N	\N	\N	
21346	\N	\N	\N	
21347	\N	\N	\N	
21348	\N	\N	\N	
21349	\N	\N	\N	
21350	\N	\N	\N	
21351	\N	\N	\N	
21352	\N	\N	\N	
21353	\N	\N	\N	
21354	\N	\N	\N	
21355	\N	\N	\N	
21356	\N	\N	\N	
21357	\N	\N	\N	
21358	\N	\N	\N	
21359	\N	\N	\N	
21360	\N	\N	\N	
21361	\N	\N	\N	
21362	\N	\N	\N	
21363	\N	\N	\N	
21364	\N	\N	\N	
21365	\N	\N	\N	
21366	\N	\N	\N	
21367	\N	\N	\N	
21368	\N	\N	\N	
21369	\N	\N	\N	
21370	\N	\N	\N	
21371	\N	\N	\N	
21372	\N	\N	\N	
21373	\N	\N	\N	
21374	\N	\N	\N	
21375	\N	\N	\N	
21376	\N	\N	\N	
21377	\N	\N	\N	
21378	\N	\N	\N	
21379	\N	\N	\N	
21380	\N	\N	\N	
21381	\N	\N	\N	
21382	\N	\N	\N	
21383	\N	\N	\N	
21384	\N	\N	\N	
21385	\N	\N	\N	
21386	\N	\N	\N	
21387	\N	\N	\N	
21388	\N	\N	\N	
21389	\N	\N	\N	
21390	\N	\N	\N	
21391	\N	\N	\N	
21392	\N	\N	\N	
21393	\N	\N	\N	
21394	\N	\N	\N	
21395	\N	\N	\N	
21396	\N	\N	\N	
21397	\N	\N	\N	
21398	\N	\N	\N	
21399	\N	\N	\N	
21400	\N	\N	\N	
21401	\N	\N	\N	
21402	\N	\N	\N	
21403	\N	\N	\N	
21404	\N	\N	\N	
21405	\N	\N	\N	
21406	\N	\N	\N	
21407	\N	\N	\N	
21408	\N	\N	\N	
21409	\N	\N	\N	
21410	\N	\N	\N	
21411	\N	\N	\N	
21412	\N	\N	\N	
21413	\N	\N	\N	
21414	\N	\N	\N	
21415	\N	\N	\N	
21416	\N	\N	\N	
21417	\N	\N	\N	
21418	\N	\N	\N	
21419	\N	\N	\N	
21420	\N	\N	\N	
21421	\N	\N	\N	
21422	\N	\N	\N	
21423	\N	\N	\N	
21424	\N	\N	\N	
21425	\N	\N	\N	
21426	\N	\N	\N	
21427	\N	\N	\N	
21428	\N	\N	\N	
21429	\N	\N	\N	
21430	\N	\N	\N	
21431	\N	\N	\N	
21432	\N	\N	\N	
21433	\N	\N	\N	
21434	\N	\N	\N	
21435	\N	\N	\N	
21436	\N	\N	\N	
21437	\N	\N	\N	
21438	\N	\N	\N	
21439	\N	\N	\N	
21440	\N	\N	\N	
21441	\N	\N	\N	
21442	\N	\N	\N	
21443	\N	\N	\N	
21444	\N	\N	\N	
21445	\N	\N	\N	
21446	\N	\N	\N	
21447	\N	\N	\N	
21448	\N	\N	\N	
21449	\N	\N	\N	
21450	\N	\N	\N	
21451	\N	\N	\N	
21452	\N	\N	\N	
21453	\N	\N	\N	
21454	\N	\N	\N	
21455	\N	\N	\N	
21456	\N	\N	\N	
21457	\N	\N	\N	
21458	\N	\N	\N	
21459	\N	\N	\N	
21460	\N	\N	\N	
21461	\N	\N	\N	
21462	\N	\N	\N	
21463	\N	\N	\N	
21464	\N	\N	\N	
21465	\N	\N	\N	
21466	\N	\N	\N	
21467	\N	\N	\N	
21468	\N	\N	\N	
21469	\N	\N	\N	
21470	\N	\N	\N	
21471	\N	\N	\N	
21472	\N	\N	\N	
21473	\N	\N	\N	
21474	\N	\N	\N	
21475	\N	\N	\N	
21476	\N	\N	\N	
21477	\N	\N	\N	
21478	\N	\N	\N	
21479	\N	\N	\N	
21480	\N	\N	\N	
21481	\N	\N	\N	
21482	\N	\N	\N	
21483	\N	\N	\N	
21484	\N	\N	\N	
21485	\N	\N	\N	
21486	\N	\N	\N	
21487	\N	\N	\N	
21488	\N	\N	\N	
21489	\N	\N	\N	
21490	\N	\N	\N	
21491	\N	\N	\N	
21492	\N	\N	\N	
21493	\N	\N	\N	
21494	\N	\N	\N	
21495	\N	\N	\N	
21496	\N	\N	\N	
21497	\N	\N	\N	
21498	\N	\N	\N	
21499	\N	\N	\N	
21500	\N	\N	\N	
21501	\N	\N	\N	
21502	\N	\N	\N	
21503	\N	\N	\N	
21504	\N	\N	\N	
21505	\N	\N	\N	
21506	\N	\N	\N	
21507	\N	\N	\N	
21508	\N	\N	\N	
21509	\N	\N	\N	
21510	\N	\N	\N	
21511	\N	\N	\N	
21512	\N	\N	\N	
21513	\N	\N	\N	
21514	\N	\N	\N	
21515	\N	\N	\N	
21516	\N	\N	\N	
21517	\N	\N	\N	
21518	\N	\N	\N	
21519	\N	\N	\N	
21520	\N	\N	\N	
21521	\N	\N	\N	
21522	\N	\N	\N	
21523	\N	\N	\N	
21524	\N	\N	\N	
21525	\N	\N	\N	
21526	\N	\N	\N	
21527	\N	\N	\N	
21528	\N	\N	\N	
21529	\N	\N	\N	
21530	\N	\N	\N	
21531	\N	\N	\N	
21532	\N	\N	\N	
21533	\N	\N	\N	
21534	\N	\N	\N	
21535	\N	\N	\N	
21536	\N	\N	\N	
21537	\N	\N	\N	
21538	\N	\N	\N	
21539	\N	\N	\N	
21540	\N	\N	\N	
21541	\N	\N	\N	
21542	\N	\N	\N	
21543	\N	\N	\N	
21544	\N	\N	\N	
21545	\N	\N	\N	
21546	\N	\N	\N	
21547	\N	\N	\N	
21548	\N	\N	\N	
21549	\N	\N	\N	
21550	\N	\N	\N	
21551	\N	\N	\N	
21552	\N	\N	\N	
21553	\N	\N	\N	
21554	\N	\N	\N	
21555	\N	\N	\N	
21556	\N	\N	\N	
21557	\N	\N	\N	
21558	\N	\N	\N	
21559	\N	\N	\N	
21560	\N	\N	\N	
21561	\N	\N	\N	
21562	\N	\N	\N	
21563	\N	\N	\N	
21564	\N	\N	\N	
21565	\N	\N	\N	
21566	\N	\N	\N	
21567	\N	\N	\N	
21568	\N	\N	\N	
21569	\N	\N	\N	
21570	\N	\N	\N	
21571	\N	\N	\N	
21572	\N	\N	\N	
21573	\N	\N	\N	
21574	\N	\N	\N	
21575	\N	\N	\N	
21576	\N	\N	\N	
21577	\N	\N	\N	
21578	\N	\N	\N	
21579	\N	\N	\N	
21580	\N	\N	\N	
21581	\N	\N	\N	
21582	\N	\N	\N	
21583	\N	\N	\N	
21584	\N	\N	\N	
21585	\N	\N	\N	
21586	\N	\N	\N	
21587	\N	\N	\N	
21588	\N	\N	\N	
21589	\N	\N	\N	
21590	\N	\N	\N	
21591	\N	\N	\N	
21592	\N	\N	\N	
21593	\N	\N	\N	
21594	\N	\N	\N	
21595	\N	\N	\N	
21596	\N	\N	\N	
21597	\N	\N	\N	
21598	\N	\N	\N	
21599	\N	\N	\N	
21600	\N	\N	\N	
21601	\N	\N	\N	
21602	\N	\N	\N	
21603	\N	\N	\N	
21604	\N	\N	\N	
21605	\N	\N	\N	
21606	\N	\N	\N	
21607	\N	\N	\N	
21608	\N	\N	\N	
21609	\N	\N	\N	
21610	\N	\N	\N	
21611	\N	\N	\N	
21612	\N	\N	\N	
21613	\N	\N	\N	
21614	\N	\N	\N	
21615	\N	\N	\N	
21616	\N	\N	\N	
21617	\N	\N	\N	
21618	\N	\N	\N	
21619	\N	\N	\N	
21620	\N	\N	\N	
21621	\N	\N	\N	
21622	\N	\N	\N	
21623	\N	\N	\N	
21624	\N	\N	\N	
21625	\N	\N	\N	
21626	\N	\N	\N	
21627	\N	\N	\N	
21628	\N	\N	\N	
21629	\N	\N	\N	
21630	\N	\N	\N	
21631	\N	\N	\N	
21632	\N	\N	\N	
21633	\N	\N	\N	
21634	\N	\N	\N	
21635	\N	\N	\N	
21636	\N	\N	\N	
21637	\N	\N	\N	
21638	\N	\N	\N	
21639	\N	\N	\N	
21640	\N	\N	\N	
21641	\N	\N	\N	
21642	\N	\N	\N	
21643	\N	\N	\N	
21644	\N	\N	\N	
21645	\N	\N	\N	
21646	\N	\N	\N	
21647	\N	\N	\N	
21648	\N	\N	\N	
21649	\N	\N	\N	
21650	\N	\N	\N	
21651	\N	\N	\N	
21652	\N	\N	\N	
21653	\N	\N	\N	
21654	\N	\N	\N	
21655	\N	\N	\N	
21656	\N	\N	\N	
21657	\N	\N	\N	
21658	\N	\N	\N	
21659	\N	\N	\N	
21660	\N	\N	\N	
21661	\N	\N	\N	
21662	\N	\N	\N	
21663	\N	\N	\N	
21664	\N	\N	\N	
21665	\N	\N	\N	
21666	\N	\N	\N	
21667	\N	\N	\N	
21668	\N	\N	\N	
21669	\N	\N	\N	
21670	\N	\N	\N	
21671	\N	\N	\N	
21672	\N	\N	\N	
21673	\N	\N	\N	
21674	\N	\N	\N	
21675	\N	\N	\N	
21676	\N	\N	\N	
21677	\N	\N	\N	
21678	\N	\N	\N	
21679	\N	\N	\N	
21680	\N	\N	\N	
21681	\N	\N	\N	
21682	\N	\N	\N	
21683	\N	\N	\N	
21684	\N	\N	\N	
21685	\N	\N	\N	
21686	\N	\N	\N	
21687	\N	\N	\N	
21688	\N	\N	\N	
21689	\N	\N	\N	
21690	\N	\N	\N	
21691	\N	\N	\N	
21692	\N	\N	\N	
21693	\N	\N	\N	
21694	\N	\N	\N	
21695	\N	\N	\N	
21696	\N	\N	\N	
21697	\N	\N	\N	
21698	\N	\N	\N	
21699	\N	\N	\N	
21700	\N	\N	\N	
21701	\N	\N	\N	
21702	\N	\N	\N	
21703	\N	\N	\N	
21704	\N	\N	\N	
21705	\N	\N	\N	
21706	\N	\N	\N	
21707	\N	\N	\N	
21708	\N	\N	\N	
21709	\N	\N	\N	
21710	\N	\N	\N	
21711	\N	\N	\N	
21712	\N	\N	\N	
21713	\N	\N	\N	
21714	\N	\N	\N	
21715	\N	\N	\N	
21716	\N	\N	\N	
21717	\N	\N	\N	
21718	\N	\N	\N	
21719	\N	\N	\N	
21720	\N	\N	\N	
21721	\N	\N	\N	
21722	\N	\N	\N	
21723	\N	\N	\N	
21724	\N	\N	\N	
21725	\N	\N	\N	
21726	\N	\N	\N	
21727	\N	\N	\N	
21728	\N	\N	\N	
21729	\N	\N	\N	
21730	\N	\N	\N	
21731	\N	\N	\N	
21732	\N	\N	\N	
21733	\N	\N	\N	
21734	\N	\N	\N	
21735	\N	\N	\N	
21736	\N	\N	\N	
21737	\N	\N	\N	
21738	\N	\N	\N	
21739	\N	\N	\N	
21740	\N	\N	\N	
21741	\N	\N	\N	
21742	\N	\N	\N	
21743	\N	\N	\N	
21744	\N	\N	\N	
21745	\N	\N	\N	
21746	\N	\N	\N	
21747	\N	\N	\N	
21748	\N	\N	\N	
21749	\N	\N	\N	
21750	\N	\N	\N	
21751	\N	\N	\N	
21752	\N	\N	\N	
21753	\N	\N	\N	
21754	\N	\N	\N	
21755	\N	\N	\N	
21756	\N	\N	\N	
21757	\N	\N	\N	
21758	\N	\N	\N	
21759	\N	\N	\N	
21760	\N	\N	\N	
21761	\N	\N	\N	
21762	\N	\N	\N	
21763	\N	\N	\N	
21764	\N	\N	\N	
21765	\N	\N	\N	
21766	\N	\N	\N	
21767	\N	\N	\N	
21768	\N	\N	\N	
21769	\N	\N	\N	
21770	\N	\N	\N	
21771	\N	\N	\N	
21772	\N	\N	\N	
21773	\N	\N	\N	
21774	\N	\N	\N	
21775	\N	\N	\N	
21776	\N	\N	\N	
21777	\N	\N	\N	
21778	\N	\N	\N	
21779	\N	\N	\N	
21780	\N	\N	\N	
21781	\N	\N	\N	
21782	\N	\N	\N	
21783	\N	\N	\N	
21784	\N	\N	\N	
21785	\N	\N	\N	
21786	\N	\N	\N	
21787	\N	\N	\N	
21788	\N	\N	\N	
21789	\N	\N	\N	
21790	\N	\N	\N	
21791	\N	\N	\N	
21792	\N	\N	\N	
21793	\N	\N	\N	
21794	\N	\N	\N	
21795	\N	\N	\N	
21796	\N	\N	\N	
21797	\N	\N	\N	
21798	\N	\N	\N	
21799	\N	\N	\N	
21800	\N	\N	\N	
21801	\N	\N	\N	
21802	\N	\N	\N	
21803	\N	\N	\N	
21804	\N	\N	\N	
21805	\N	\N	\N	
21806	\N	\N	\N	
21807	\N	\N	\N	
21808	\N	\N	\N	
21809	\N	\N	\N	
21810	\N	\N	\N	
21811	\N	\N	\N	
21812	\N	\N	\N	
21813	\N	\N	\N	
21814	\N	\N	\N	
21815	\N	\N	\N	
21816	\N	\N	\N	
21817	\N	\N	\N	
21818	\N	\N	\N	
21819	\N	\N	\N	
21820	\N	\N	\N	
21821	\N	\N	\N	
21822	\N	\N	\N	
21823	\N	\N	\N	
21824	\N	\N	\N	
21825	\N	\N	\N	
21826	\N	\N	\N	
21827	\N	\N	\N	
21828	\N	\N	\N	
21829	\N	\N	\N	
21830	\N	\N	\N	
21831	\N	\N	\N	
21832	\N	\N	\N	
21833	\N	\N	\N	
21834	\N	\N	\N	
21835	\N	\N	\N	
21836	\N	\N	\N	
21837	\N	\N	\N	
21838	\N	\N	\N	
21839	\N	\N	\N	
21840	\N	\N	\N	
21841	\N	\N	\N	
21842	\N	\N	\N	
21843	\N	\N	\N	
21844	\N	\N	\N	
21845	\N	\N	\N	
21846	\N	\N	\N	
21847	\N	\N	\N	
21848	\N	\N	\N	
21849	\N	\N	\N	
21850	\N	\N	\N	
21851	\N	\N	\N	
21852	\N	\N	\N	
21853	\N	\N	\N	
21854	\N	\N	\N	
21855	\N	\N	\N	
21856	\N	\N	\N	
21857	\N	\N	\N	
21858	\N	\N	\N	
21859	\N	\N	\N	
21860	\N	\N	\N	
21861	\N	\N	\N	
21862	\N	\N	\N	
21863	\N	\N	\N	
21864	\N	\N	\N	
21865	\N	\N	\N	
21866	\N	\N	\N	
21867	\N	\N	\N	
21868	\N	\N	\N	
21869	\N	\N	\N	
21870	\N	\N	\N	
21871	\N	\N	\N	
21872	\N	\N	\N	
21873	\N	\N	\N	
21874	\N	\N	\N	
21875	\N	\N	\N	
21876	\N	\N	\N	
21877	\N	\N	\N	
21878	\N	\N	\N	
21879	\N	\N	\N	
21880	\N	\N	\N	
21881	\N	\N	\N	
21882	\N	\N	\N	
21883	\N	\N	\N	
21884	\N	\N	\N	
21885	\N	\N	\N	
21886	\N	\N	\N	
21887	\N	\N	\N	
21888	\N	\N	\N	
21889	\N	\N	\N	
21890	\N	\N	\N	
21891	\N	\N	\N	
21892	\N	\N	\N	
21893	\N	\N	\N	
21894	\N	\N	\N	
21895	\N	\N	\N	
21896	\N	\N	\N	
21897	\N	\N	\N	
21898	\N	\N	\N	
21899	\N	\N	\N	
21900	\N	\N	\N	
21901	\N	\N	\N	
21902	\N	\N	\N	
21903	\N	\N	\N	
21904	\N	\N	\N	
21905	\N	\N	\N	
21906	\N	\N	\N	
21907	\N	\N	\N	
21908	\N	\N	\N	
21909	\N	\N	\N	
21910	\N	\N	\N	
21911	\N	\N	\N	
21912	\N	\N	\N	
21913	\N	\N	\N	
21914	\N	\N	\N	
21915	\N	\N	\N	
21916	\N	\N	\N	
21917	\N	\N	\N	
21918	\N	\N	\N	
21919	\N	\N	\N	
21920	\N	\N	\N	
21921	\N	\N	\N	
21922	\N	\N	\N	
21923	\N	\N	\N	
21924	\N	\N	\N	
21925	\N	\N	\N	
21926	\N	\N	\N	
21927	\N	\N	\N	
21928	\N	\N	\N	
21929	\N	\N	\N	
21930	\N	\N	\N	
21931	\N	\N	\N	
21932	\N	\N	\N	
21933	\N	\N	\N	
21934	\N	\N	\N	
21935	\N	\N	\N	
21936	\N	\N	\N	
21937	\N	\N	\N	
21938	\N	\N	\N	
21939	\N	\N	\N	
21940	\N	\N	\N	
21941	\N	\N	\N	
21942	\N	\N	\N	
21943	\N	\N	\N	
21944	\N	\N	\N	
21945	\N	\N	\N	
21946	\N	\N	\N	
21947	\N	\N	\N	
21948	\N	\N	\N	
21949	\N	\N	\N	
21950	\N	\N	\N	
21951	\N	\N	\N	
21952	\N	\N	\N	
21953	\N	\N	\N	
21954	\N	\N	\N	
21955	\N	\N	\N	
21956	\N	\N	\N	
21957	\N	\N	\N	
21958	\N	\N	\N	
21959	\N	\N	\N	
21960	\N	\N	\N	
21961	\N	\N	\N	
21962	\N	\N	\N	
21963	\N	\N	\N	
21964	\N	\N	\N	
21965	\N	\N	\N	
21966	\N	\N	\N	
21967	\N	\N	\N	
21968	\N	\N	\N	
21969	\N	\N	\N	
21970	\N	\N	\N	
21971	\N	\N	\N	
21972	\N	\N	\N	
21973	\N	\N	\N	
21974	\N	\N	\N	
21975	\N	\N	\N	
21976	\N	\N	\N	
21977	\N	\N	\N	
21978	\N	\N	\N	
21979	\N	\N	\N	
21980	\N	\N	\N	
21981	\N	\N	\N	
21982	\N	\N	\N	
21983	\N	\N	\N	
21984	\N	\N	\N	
21985	\N	\N	\N	
21986	\N	\N	\N	
21987	\N	\N	\N	
21988	\N	\N	\N	
21989	\N	\N	\N	
21990	\N	\N	\N	
21991	\N	\N	\N	
21992	\N	\N	\N	
21993	\N	\N	\N	
21994	\N	\N	\N	
21995	\N	\N	\N	
21996	\N	\N	\N	
21997	\N	\N	\N	
21998	\N	\N	\N	
21999	\N	\N	\N	
22000	\N	\N	\N	
22001	\N	\N	\N	
22002	\N	\N	\N	
22003	\N	\N	\N	
22004	\N	\N	\N	
22005	\N	\N	\N	
22006	\N	\N	\N	
22007	\N	\N	\N	
22008	\N	\N	\N	
22009	\N	\N	\N	
22010	\N	\N	\N	
22011	\N	\N	\N	
22012	\N	\N	\N	
22013	\N	\N	\N	
22014	\N	\N	\N	
22015	\N	\N	\N	
22016	\N	\N	\N	
22017	\N	\N	\N	
22018	\N	\N	\N	
22019	\N	\N	\N	
22020	\N	\N	\N	
22021	\N	\N	\N	
22022	\N	\N	\N	
22023	\N	\N	\N	
22024	\N	\N	\N	
22025	\N	\N	\N	
22026	\N	\N	\N	
22027	\N	\N	\N	
22028	\N	\N	\N	
22029	\N	\N	\N	
22030	\N	\N	\N	
22031	\N	\N	\N	
22032	\N	\N	\N	
22033	\N	\N	\N	
22034	\N	\N	\N	
22035	\N	\N	\N	
22036	\N	\N	\N	
22037	\N	\N	\N	
22038	\N	\N	\N	
22039	\N	\N	\N	
22040	\N	\N	\N	
22041	\N	\N	\N	
22042	\N	\N	\N	
22043	\N	\N	\N	
22044	\N	\N	\N	
22045	\N	\N	\N	
22046	\N	\N	\N	
22047	\N	\N	\N	
22048	\N	\N	\N	
22049	\N	\N	\N	
22050	\N	\N	\N	
22051	\N	\N	\N	
22052	\N	\N	\N	
22053	\N	\N	\N	
22054	\N	\N	\N	
22055	\N	\N	\N	
22056	\N	\N	\N	
22057	\N	\N	\N	
22058	\N	\N	\N	
22059	\N	\N	\N	
22060	\N	\N	\N	
22061	\N	\N	\N	
22062	\N	\N	\N	
22063	\N	\N	\N	
22064	\N	\N	\N	
22065	\N	\N	\N	
22066	\N	\N	\N	
22067	\N	\N	\N	
22068	\N	\N	\N	
22069	\N	\N	\N	
22070	\N	\N	\N	
22071	\N	\N	\N	
22072	\N	\N	\N	
22073	\N	\N	\N	
22074	\N	\N	\N	
22075	\N	\N	\N	
22076	\N	\N	\N	
22077	\N	\N	\N	
22078	\N	\N	\N	
22079	\N	\N	\N	
22080	\N	\N	\N	
22081	\N	\N	\N	
22082	\N	\N	\N	
22083	\N	\N	\N	
22084	\N	\N	\N	
22085	\N	\N	\N	
22086	\N	\N	\N	
22087	\N	\N	\N	
22088	\N	\N	\N	
22089	\N	\N	\N	
22090	\N	\N	\N	
22091	\N	\N	\N	
22092	\N	\N	\N	
22093	\N	\N	\N	
22094	\N	\N	\N	
22095	\N	\N	\N	
22096	\N	\N	\N	
22097	\N	\N	\N	
22098	\N	\N	\N	
22099	\N	\N	\N	
22100	\N	\N	\N	
22101	\N	\N	\N	
22102	\N	\N	\N	
22103	\N	\N	\N	
22104	\N	\N	\N	
22105	\N	\N	\N	
22106	\N	\N	\N	
22107	\N	\N	\N	
22108	\N	\N	\N	
22109	\N	\N	\N	
22110	\N	\N	\N	
22111	\N	\N	\N	
22112	\N	\N	\N	
22113	\N	\N	\N	
22114	\N	\N	\N	
22115	\N	\N	\N	
22116	\N	\N	\N	
22117	\N	\N	\N	
22118	\N	\N	\N	
22119	\N	\N	\N	
22120	\N	\N	\N	
22121	\N	\N	\N	
22122	\N	\N	\N	
22123	\N	\N	\N	
22124	\N	\N	\N	
22125	\N	\N	\N	
22126	\N	\N	\N	
22127	\N	\N	\N	
22128	\N	\N	\N	
22129	\N	\N	\N	
22130	\N	\N	\N	
22131	\N	\N	\N	
22132	\N	\N	\N	
22133	\N	\N	\N	
22134	\N	\N	\N	
22135	\N	\N	\N	
22136	\N	\N	\N	
22137	\N	\N	\N	
22138	\N	\N	\N	
22139	\N	\N	\N	
22140	\N	\N	\N	
22141	\N	\N	\N	
22142	\N	\N	\N	
22143	\N	\N	\N	
22144	\N	\N	\N	
22145	\N	\N	\N	
22146	\N	\N	\N	
22147	\N	\N	\N	
22148	\N	\N	\N	
22149	\N	\N	\N	
22150	\N	\N	\N	
22151	\N	\N	\N	
22152	\N	\N	\N	
22153	\N	\N	\N	
22154	\N	\N	\N	
22155	\N	\N	\N	
22156	\N	\N	\N	
22157	\N	\N	\N	
22158	\N	\N	\N	
22159	\N	\N	\N	
22160	\N	\N	\N	
22161	\N	\N	\N	
22162	\N	\N	\N	
22163	\N	\N	\N	
22164	\N	\N	\N	
22165	\N	\N	\N	
22166	\N	\N	\N	
22167	\N	\N	\N	
22168	\N	\N	\N	
22169	\N	\N	\N	
22170	\N	\N	\N	
22171	\N	\N	\N	
22172	\N	\N	\N	
22173	\N	\N	\N	
22174	\N	\N	\N	
22175	\N	\N	\N	
22176	\N	\N	\N	
22177	\N	\N	\N	
22178	\N	\N	\N	
22179	\N	\N	\N	
22180	\N	\N	\N	
22181	\N	\N	\N	
22182	\N	\N	\N	
22183	\N	\N	\N	
22184	\N	\N	\N	
22185	\N	\N	\N	
22186	\N	\N	\N	
22187	\N	\N	\N	
22188	\N	\N	\N	
22189	\N	\N	\N	
22190	\N	\N	\N	
22191	\N	\N	\N	
22192	\N	\N	\N	
22193	\N	\N	\N	
22194	\N	\N	\N	
22195	\N	\N	\N	
22196	\N	\N	\N	
22197	\N	\N	\N	
22198	\N	\N	\N	
22199	\N	\N	\N	
22200	\N	\N	\N	
22201	\N	\N	\N	
22202	\N	\N	\N	
22203	\N	\N	\N	
22204	\N	\N	\N	
22205	\N	\N	\N	
22206	\N	\N	\N	
22207	\N	\N	\N	
22208	\N	\N	\N	
22209	\N	\N	\N	
22210	\N	\N	\N	
22211	\N	\N	\N	
22212	\N	\N	\N	
22213	\N	\N	\N	
22214	\N	\N	\N	
22215	\N	\N	\N	
22216	\N	\N	\N	
22217	\N	\N	\N	
22218	\N	\N	\N	
22219	\N	\N	\N	
22220	\N	\N	\N	
22221	\N	\N	\N	
22222	\N	\N	\N	
22223	\N	\N	\N	
22224	\N	\N	\N	
22225	\N	\N	\N	
22226	\N	\N	\N	
22227	\N	\N	\N	
22228	\N	\N	\N	
22229	\N	\N	\N	
22230	\N	\N	\N	
22231	\N	\N	\N	
22232	\N	\N	\N	
22233	\N	\N	\N	
22234	\N	\N	\N	
22235	\N	\N	\N	
22236	\N	\N	\N	
22237	\N	\N	\N	
22238	\N	\N	\N	
22239	\N	\N	\N	
22240	\N	\N	\N	
22241	\N	\N	\N	
22242	\N	\N	\N	
22243	\N	\N	\N	
22244	\N	\N	\N	
22245	\N	\N	\N	
22246	\N	\N	\N	
22247	\N	\N	\N	
22248	\N	\N	\N	
22249	\N	\N	\N	
22250	\N	\N	\N	
22251	\N	\N	\N	
22252	\N	\N	\N	
22253	\N	\N	\N	
22254	\N	\N	\N	
22255	\N	\N	\N	
22256	\N	\N	\N	
22257	\N	\N	\N	
22258	\N	\N	\N	
22259	\N	\N	\N	
22260	\N	\N	\N	
22261	\N	\N	\N	
22262	\N	\N	\N	
22263	\N	\N	\N	
22264	\N	\N	\N	
22265	\N	\N	\N	
22266	\N	\N	\N	
22267	\N	\N	\N	
22268	\N	\N	\N	
22269	\N	\N	\N	
22270	\N	\N	\N	
22271	\N	\N	\N	
22272	\N	\N	\N	
22273	\N	\N	\N	
22274	\N	\N	\N	
22275	\N	\N	\N	
22276	\N	\N	\N	
22277	\N	\N	\N	
22278	\N	\N	\N	
22279	\N	\N	\N	
22280	\N	\N	\N	
22281	\N	\N	\N	
22282	\N	\N	\N	
22283	\N	\N	\N	
22284	\N	\N	\N	
22285	\N	\N	\N	
22286	\N	\N	\N	
22287	\N	\N	\N	
22288	\N	\N	\N	
22289	\N	\N	\N	
22290	\N	\N	\N	
22291	\N	\N	\N	
22292	\N	\N	\N	
22293	\N	\N	\N	
22294	\N	\N	\N	
22295	\N	\N	\N	
22296	\N	\N	\N	
22297	\N	\N	\N	
22298	\N	\N	\N	
22299	\N	\N	\N	
22300	\N	\N	\N	
22301	\N	\N	\N	
22302	\N	\N	\N	
22303	\N	\N	\N	
22304	\N	\N	\N	
22305	\N	\N	\N	
22306	\N	\N	\N	
22307	\N	\N	\N	
22308	\N	\N	\N	
22309	\N	\N	\N	
22310	\N	\N	\N	
22311	\N	\N	\N	
22312	\N	\N	\N	
22313	\N	\N	\N	
22314	\N	\N	\N	
22315	\N	\N	\N	
22316	\N	\N	\N	
22317	\N	\N	\N	
22318	\N	\N	\N	
22319	\N	\N	\N	
22320	\N	\N	\N	
22321	\N	\N	\N	
22322	\N	\N	\N	
22323	\N	\N	\N	
22324	\N	\N	\N	
22325	\N	\N	\N	
22326	\N	\N	\N	
22327	\N	\N	\N	
22328	\N	\N	\N	
22329	\N	\N	\N	
22330	\N	\N	\N	
22331	\N	\N	\N	
22332	\N	\N	\N	
22333	\N	\N	\N	
22334	\N	\N	\N	
22335	\N	\N	\N	
22336	\N	\N	\N	
22337	\N	\N	\N	
22338	\N	\N	\N	
22339	\N	\N	\N	
22340	\N	\N	\N	
22341	\N	\N	\N	
22342	\N	\N	\N	
22343	\N	\N	\N	
22344	\N	\N	\N	
22345	\N	\N	\N	
22346	\N	\N	\N	
22347	\N	\N	\N	
22348	\N	\N	\N	
22349	\N	\N	\N	
22350	\N	\N	\N	
22351	\N	\N	\N	
22352	\N	\N	\N	
22353	\N	\N	\N	
22354	\N	\N	\N	
22355	\N	\N	\N	
22356	\N	\N	\N	
22357	\N	\N	\N	
22358	\N	\N	\N	
22359	\N	\N	\N	
22360	\N	\N	\N	
22361	\N	\N	\N	
22362	\N	\N	\N	
22363	\N	\N	\N	
22364	\N	\N	\N	
22365	\N	\N	\N	
22366	\N	\N	\N	
22367	\N	\N	\N	
22368	\N	\N	\N	
22369	\N	\N	\N	
22370	\N	\N	\N	
22371	\N	\N	\N	
22372	\N	\N	\N	
22373	\N	\N	\N	
22374	\N	\N	\N	
22375	\N	\N	\N	
22376	\N	\N	\N	
22377	\N	\N	\N	
22378	\N	\N	\N	
22379	\N	\N	\N	
22380	\N	\N	\N	
22381	\N	\N	\N	
22382	\N	\N	\N	
22383	\N	\N	\N	
22384	\N	\N	\N	
22385	\N	\N	\N	
22386	\N	\N	\N	
22387	\N	\N	\N	
22388	\N	\N	\N	
22389	\N	\N	\N	
22390	\N	\N	\N	
22391	\N	\N	\N	
22392	\N	\N	\N	
22393	\N	\N	\N	
22394	\N	\N	\N	
22395	\N	\N	\N	
22396	\N	\N	\N	
22397	\N	\N	\N	
22398	\N	\N	\N	
22399	\N	\N	\N	
22400	\N	\N	\N	
22401	\N	\N	\N	
22402	\N	\N	\N	
22403	\N	\N	\N	
22404	\N	\N	\N	
22405	\N	\N	\N	
22406	\N	\N	\N	
22407	\N	\N	\N	
22408	\N	\N	\N	
22409	\N	\N	\N	
22410	\N	\N	\N	
22411	\N	\N	\N	
22412	\N	\N	\N	
22413	\N	\N	\N	
22414	\N	\N	\N	
22415	\N	\N	\N	
22416	\N	\N	\N	
22417	\N	\N	\N	
22418	\N	\N	\N	
22419	\N	\N	\N	
22420	\N	\N	\N	
22421	\N	\N	\N	
22422	\N	\N	\N	
22423	\N	\N	\N	
22424	\N	\N	\N	
22425	\N	\N	\N	
22426	\N	\N	\N	
22427	\N	\N	\N	
22428	\N	\N	\N	
22429	\N	\N	\N	
22430	\N	\N	\N	
22431	\N	\N	\N	
22432	\N	\N	\N	
22433	\N	\N	\N	
22434	\N	\N	\N	
22435	\N	\N	\N	
22436	\N	\N	\N	
22437	\N	\N	\N	
22438	\N	\N	\N	
22439	\N	\N	\N	
22440	\N	\N	\N	
22441	\N	\N	\N	
22442	\N	\N	\N	
22443	\N	\N	\N	
22444	\N	\N	\N	
22445	\N	\N	\N	
22446	\N	\N	\N	
22447	\N	\N	\N	
22448	\N	\N	\N	
22449	\N	\N	\N	
22450	\N	\N	\N	
22451	\N	\N	\N	
22452	\N	\N	\N	
22453	\N	\N	\N	
22454	\N	\N	\N	
22455	\N	\N	\N	
22456	\N	\N	\N	
22457	\N	\N	\N	
22458	\N	\N	\N	
22459	\N	\N	\N	
22460	\N	\N	\N	
22461	\N	\N	\N	
22462	\N	\N	\N	
22463	\N	\N	\N	
22464	\N	\N	\N	
22465	\N	\N	\N	
22466	\N	\N	\N	
22467	\N	\N	\N	
22468	\N	\N	\N	
22469	\N	\N	\N	
22470	\N	\N	\N	
22471	\N	\N	\N	
22472	\N	\N	\N	
22473	\N	\N	\N	
22474	\N	\N	\N	
22475	\N	\N	\N	
22476	\N	\N	\N	
22477	\N	\N	\N	
22478	\N	\N	\N	
22479	\N	\N	\N	
22480	\N	\N	\N	
22481	\N	\N	\N	
22482	\N	\N	\N	
22483	\N	\N	\N	
22484	\N	\N	\N	
22485	\N	\N	\N	
22486	\N	\N	\N	
22487	\N	\N	\N	
22488	\N	\N	\N	
22489	\N	\N	\N	
22490	\N	\N	\N	
22491	\N	\N	\N	
22492	\N	\N	\N	
22493	\N	\N	\N	
22494	\N	\N	\N	
22495	\N	\N	\N	
22496	\N	\N	\N	
22497	\N	\N	\N	
22498	\N	\N	\N	
22499	\N	\N	\N	
22500	\N	\N	\N	
22501	\N	\N	\N	
22502	\N	\N	\N	
22503	\N	\N	\N	
22504	\N	\N	\N	
22505	\N	\N	\N	
22506	\N	\N	\N	
22507	\N	\N	\N	
22508	\N	\N	\N	
22509	\N	\N	\N	
22510	\N	\N	\N	
22511	\N	\N	\N	
22512	\N	\N	\N	
22513	\N	\N	\N	
22514	\N	\N	\N	
22515	\N	\N	\N	
22516	\N	\N	\N	
22517	\N	\N	\N	
22518	\N	\N	\N	
22519	\N	\N	\N	
22520	\N	\N	\N	
22521	\N	\N	\N	
22522	\N	\N	\N	
22523	\N	\N	\N	
22524	\N	\N	\N	
22525	\N	\N	\N	
22526	\N	\N	\N	
22527	\N	\N	\N	
22528	\N	\N	\N	
22529	\N	\N	\N	
22530	\N	\N	\N	
22531	\N	\N	\N	
22532	\N	\N	\N	
22533	\N	\N	\N	
22534	\N	\N	\N	
22535	\N	\N	\N	
22536	\N	\N	\N	
22537	\N	\N	\N	
22538	\N	\N	\N	
22539	\N	\N	\N	
22540	\N	\N	\N	
22541	\N	\N	\N	
22542	\N	\N	\N	
22543	\N	\N	\N	
22544	\N	\N	\N	
22545	\N	\N	\N	
22546	\N	\N	\N	
22547	\N	\N	\N	
22548	\N	\N	\N	
22549	\N	\N	\N	
22550	\N	\N	\N	
22551	\N	\N	\N	
22552	\N	\N	\N	
22553	\N	\N	\N	
22554	\N	\N	\N	
22555	\N	\N	\N	
22556	\N	\N	\N	
22557	\N	\N	\N	
22558	\N	\N	\N	
22559	\N	\N	\N	
22560	\N	\N	\N	
22561	\N	\N	\N	
22562	\N	\N	\N	
22563	\N	\N	\N	
22564	\N	\N	\N	
22565	\N	\N	\N	
22566	\N	\N	\N	
22567	\N	\N	\N	
22568	\N	\N	\N	
22569	\N	\N	\N	
22570	\N	\N	\N	
22571	\N	\N	\N	
22572	\N	\N	\N	
22573	\N	\N	\N	
22574	\N	\N	\N	
22575	\N	\N	\N	
22576	\N	\N	\N	
22577	\N	\N	\N	
22578	\N	\N	\N	
22579	\N	\N	\N	
22580	\N	\N	\N	
22581	\N	\N	\N	
22582	\N	\N	\N	
22583	\N	\N	\N	
22584	\N	\N	\N	
22585	\N	\N	\N	
22586	\N	\N	\N	
22587	\N	\N	\N	
22588	\N	\N	\N	
22589	\N	\N	\N	
22590	\N	\N	\N	
22591	\N	\N	\N	
22592	\N	\N	\N	
22593	\N	\N	\N	
22594	\N	\N	\N	
22595	\N	\N	\N	
22596	\N	\N	\N	
22597	\N	\N	\N	
22598	\N	\N	\N	
22599	\N	\N	\N	
22600	\N	\N	\N	
22601	\N	\N	\N	
22602	\N	\N	\N	
22603	\N	\N	\N	
22604	\N	\N	\N	
22605	\N	\N	\N	
22606	\N	\N	\N	
22607	\N	\N	\N	
22608	\N	\N	\N	
22609	\N	\N	\N	
22610	\N	\N	\N	
22611	\N	\N	\N	
22612	\N	\N	\N	
22613	\N	\N	\N	
22614	\N	\N	\N	
22615	\N	\N	\N	
22616	\N	\N	\N	
22617	\N	\N	\N	
22618	\N	\N	\N	
22619	\N	\N	\N	
22620	\N	\N	\N	
22621	\N	\N	\N	
22622	\N	\N	\N	
22623	\N	\N	\N	
22624	\N	\N	\N	
22625	\N	\N	\N	
22626	\N	\N	\N	
22627	\N	\N	\N	
22628	\N	\N	\N	
22629	\N	\N	\N	
22630	\N	\N	\N	
22631	\N	\N	\N	
22632	\N	\N	\N	
22633	\N	\N	\N	
22634	\N	\N	\N	
22635	\N	\N	\N	
22636	\N	\N	\N	
22637	\N	\N	\N	
22638	\N	\N	\N	
22639	\N	\N	\N	
22640	\N	\N	\N	
22641	\N	\N	\N	
22642	\N	\N	\N	
22643	\N	\N	\N	
22644	\N	\N	\N	
22645	\N	\N	\N	
22646	\N	\N	\N	
22647	\N	\N	\N	
22648	\N	\N	\N	
22649	\N	\N	\N	
22650	\N	\N	\N	
22651	\N	\N	\N	
22652	\N	\N	\N	
22653	\N	\N	\N	
22654	\N	\N	\N	
22655	\N	\N	\N	
22656	\N	\N	\N	
22657	\N	\N	\N	
22658	\N	\N	\N	
22659	\N	\N	\N	
22660	\N	\N	\N	
22661	\N	\N	\N	
22662	\N	\N	\N	
22663	\N	\N	\N	
22664	\N	\N	\N	
22665	\N	\N	\N	
22666	\N	\N	\N	
22667	\N	\N	\N	
22668	\N	\N	\N	
22669	\N	\N	\N	
22670	\N	\N	\N	
22671	\N	\N	\N	
22672	\N	\N	\N	
22673	\N	\N	\N	
22674	\N	\N	\N	
22675	\N	\N	\N	
22676	\N	\N	\N	
22677	\N	\N	\N	
22678	\N	\N	\N	
22679	\N	\N	\N	
22680	\N	\N	\N	
22681	\N	\N	\N	
22682	\N	\N	\N	
22683	\N	\N	\N	
22684	\N	\N	\N	
22685	\N	\N	\N	
22686	\N	\N	\N	
22687	\N	\N	\N	
22688	\N	\N	\N	
22689	\N	\N	\N	
22690	\N	\N	\N	
22691	\N	\N	\N	
22692	\N	\N	\N	
22693	\N	\N	\N	
22694	\N	\N	\N	
22695	\N	\N	\N	
22696	\N	\N	\N	
22697	\N	\N	\N	
22698	\N	\N	\N	
22699	\N	\N	\N	
22700	\N	\N	\N	
22701	\N	\N	\N	
22702	\N	\N	\N	
22703	\N	\N	\N	
22704	\N	\N	\N	
22705	\N	\N	\N	
22706	\N	\N	\N	
22707	\N	\N	\N	
22708	\N	\N	\N	
22709	\N	\N	\N	
22710	\N	\N	\N	
22711	\N	\N	\N	
22712	\N	\N	\N	
22713	\N	\N	\N	
22714	\N	\N	\N	
22715	\N	\N	\N	
22716	\N	\N	\N	
22717	\N	\N	\N	
22718	\N	\N	\N	
22719	\N	\N	\N	
22720	\N	\N	\N	
22721	\N	\N	\N	
22722	\N	\N	\N	
22723	\N	\N	\N	
22724	\N	\N	\N	
22725	\N	\N	\N	
22726	\N	\N	\N	
22727	\N	\N	\N	
22728	\N	\N	\N	
22729	\N	\N	\N	
22730	\N	\N	\N	
22731	\N	\N	\N	
22732	\N	\N	\N	
22733	\N	\N	\N	
22734	\N	\N	\N	
22735	\N	\N	\N	
22736	\N	\N	\N	
22737	\N	\N	\N	
22738	\N	\N	\N	
22739	\N	\N	\N	
22740	\N	\N	\N	
22741	\N	\N	\N	
22742	\N	\N	\N	
22743	\N	\N	\N	
22744	\N	\N	\N	
22745	\N	\N	\N	
22746	\N	\N	\N	
22747	\N	\N	\N	
22748	\N	\N	\N	
22749	\N	\N	\N	
22750	\N	\N	\N	
22751	\N	\N	\N	
22752	\N	\N	\N	
22753	\N	\N	\N	
22754	\N	\N	\N	
22755	\N	\N	\N	
22756	\N	\N	\N	
22757	\N	\N	\N	
22758	\N	\N	\N	
22759	\N	\N	\N	
22760	\N	\N	\N	
22761	\N	\N	\N	
22762	\N	\N	\N	
22763	\N	\N	\N	
22764	\N	\N	\N	
22765	\N	\N	\N	
22766	\N	\N	\N	
22767	\N	\N	\N	
22768	\N	\N	\N	
22769	\N	\N	\N	
22770	\N	\N	\N	
22771	\N	\N	\N	
22772	\N	\N	\N	
22773	\N	\N	\N	
22774	\N	\N	\N	
22775	\N	\N	\N	
22776	\N	\N	\N	
22777	\N	\N	\N	
22778	\N	\N	\N	
22779	\N	\N	\N	
22780	\N	\N	\N	
22781	\N	\N	\N	
22782	\N	\N	\N	
22783	\N	\N	\N	
22784	\N	\N	\N	
22785	\N	\N	\N	
22786	\N	\N	\N	
22787	\N	\N	\N	
22788	\N	\N	\N	
22789	\N	\N	\N	
22790	\N	\N	\N	
22791	\N	\N	\N	
22792	\N	\N	\N	
22793	\N	\N	\N	
22794	\N	\N	\N	
22795	\N	\N	\N	
22796	\N	\N	\N	
22797	\N	\N	\N	
22798	\N	\N	\N	
22799	\N	\N	\N	
22800	\N	\N	\N	
22801	\N	\N	\N	
22802	\N	\N	\N	
22803	\N	\N	\N	
22804	\N	\N	\N	
22805	\N	\N	\N	
22806	\N	\N	\N	
22807	\N	\N	\N	
22808	\N	\N	\N	
22809	\N	\N	\N	
22810	\N	\N	\N	
22811	\N	\N	\N	
22812	\N	\N	\N	
22813	\N	\N	\N	
22814	\N	\N	\N	
22815	\N	\N	\N	
22816	\N	\N	\N	
22817	\N	\N	\N	
22818	\N	\N	\N	
22819	\N	\N	\N	
22820	\N	\N	\N	
22821	\N	\N	\N	
22822	\N	\N	\N	
22823	\N	\N	\N	
22824	\N	\N	\N	
22825	\N	\N	\N	
22826	\N	\N	\N	
22827	\N	\N	\N	
22828	\N	\N	\N	
22829	\N	\N	\N	
22830	\N	\N	\N	
22831	\N	\N	\N	
22832	\N	\N	\N	
22833	\N	\N	\N	
22834	\N	\N	\N	
22835	\N	\N	\N	
22836	\N	\N	\N	
22837	\N	\N	\N	
22838	\N	\N	\N	
22839	\N	\N	\N	
22840	\N	\N	\N	
22841	\N	\N	\N	
22842	\N	\N	\N	
22843	\N	\N	\N	
22844	\N	\N	\N	
22845	\N	\N	\N	
22846	\N	\N	\N	
22847	\N	\N	\N	
22848	\N	\N	\N	
22849	\N	\N	\N	
22850	\N	\N	\N	
22851	\N	\N	\N	
22852	\N	\N	\N	
22853	\N	\N	\N	
22854	\N	\N	\N	
22855	\N	\N	\N	
22856	\N	\N	\N	
22857	\N	\N	\N	
22858	\N	\N	\N	
22859	\N	\N	\N	
22860	\N	\N	\N	
22861	\N	\N	\N	
22862	\N	\N	\N	
22863	\N	\N	\N	
22864	\N	\N	\N	
22865	\N	\N	\N	
22866	\N	\N	\N	
22867	\N	\N	\N	
22868	\N	\N	\N	
22869	\N	\N	\N	
22870	\N	\N	\N	
22871	\N	\N	\N	
22872	\N	\N	\N	
22873	\N	\N	\N	
22874	\N	\N	\N	
22875	\N	\N	\N	
22876	\N	\N	\N	
22877	\N	\N	\N	
22878	\N	\N	\N	
22879	\N	\N	\N	
22880	\N	\N	\N	
22881	\N	\N	\N	
22882	\N	\N	\N	
22883	\N	\N	\N	
22884	\N	\N	\N	
22885	\N	\N	\N	
22886	\N	\N	\N	
22887	\N	\N	\N	
22888	\N	\N	\N	
22889	\N	\N	\N	
22890	\N	\N	\N	
22891	\N	\N	\N	
22892	\N	\N	\N	
22893	\N	\N	\N	
22894	\N	\N	\N	
22895	\N	\N	\N	
22896	\N	\N	\N	
22897	\N	\N	\N	
22898	\N	\N	\N	
22899	\N	\N	\N	
22900	\N	\N	\N	
22901	\N	\N	\N	
22902	\N	\N	\N	
22903	\N	\N	\N	
22904	\N	\N	\N	
22905	\N	\N	\N	
22906	\N	\N	\N	
22907	\N	\N	\N	
22908	\N	\N	\N	
22909	\N	\N	\N	
22910	\N	\N	\N	
22911	\N	\N	\N	
22912	\N	\N	\N	
22913	\N	\N	\N	
22914	\N	\N	\N	
22915	\N	\N	\N	
22916	\N	\N	\N	
22917	\N	\N	\N	
22918	\N	\N	\N	
22919	\N	\N	\N	
22920	\N	\N	\N	
22921	\N	\N	\N	
22922	\N	\N	\N	
22923	\N	\N	\N	
22924	\N	\N	\N	
22925	\N	\N	\N	
22926	\N	\N	\N	
22927	\N	\N	\N	
22928	\N	\N	\N	
22929	\N	\N	\N	
22930	\N	\N	\N	
22931	\N	\N	\N	
22932	\N	\N	\N	
22933	\N	\N	\N	
22934	\N	\N	\N	
22935	\N	\N	\N	
22936	\N	\N	\N	
22937	\N	\N	\N	
22938	\N	\N	\N	
22939	\N	\N	\N	
22940	\N	\N	\N	
22941	\N	\N	\N	
22942	\N	\N	\N	
22943	\N	\N	\N	
22944	\N	\N	\N	
22945	\N	\N	\N	
22946	\N	\N	\N	
22947	\N	\N	\N	
22948	\N	\N	\N	
22949	\N	\N	\N	
22950	\N	\N	\N	
22951	\N	\N	\N	
22952	\N	\N	\N	
22953	\N	\N	\N	
22954	\N	\N	\N	
22955	\N	\N	\N	
22956	\N	\N	\N	
22957	\N	\N	\N	
22958	\N	\N	\N	
22959	\N	\N	\N	
22960	\N	\N	\N	
22961	\N	\N	\N	
22962	\N	\N	\N	
22963	\N	\N	\N	
22964	\N	\N	\N	
22965	\N	\N	\N	
22966	\N	\N	\N	
22967	\N	\N	\N	
22968	\N	\N	\N	
22969	\N	\N	\N	
22970	\N	\N	\N	
22971	\N	\N	\N	
22972	\N	\N	\N	
22973	\N	\N	\N	
22974	\N	\N	\N	
22975	\N	\N	\N	
22976	\N	\N	\N	
22977	\N	\N	\N	
22978	\N	\N	\N	
22979	\N	\N	\N	
22980	\N	\N	\N	
22981	\N	\N	\N	
22982	\N	\N	\N	
22983	\N	\N	\N	
22984	\N	\N	\N	
22985	\N	\N	\N	
22986	\N	\N	\N	
22987	\N	\N	\N	
22988	\N	\N	\N	
22989	\N	\N	\N	
22990	\N	\N	\N	
22991	\N	\N	\N	
22992	\N	\N	\N	
22993	\N	\N	\N	
22994	\N	\N	\N	
22995	\N	\N	\N	
22996	\N	\N	\N	
22997	\N	\N	\N	
22998	\N	\N	\N	
22999	\N	\N	\N	
23000	\N	\N	\N	
23001	\N	\N	\N	
23002	\N	\N	\N	
23003	\N	\N	\N	
23004	\N	\N	\N	
23005	\N	\N	\N	
23006	\N	\N	\N	
23007	\N	\N	\N	
23008	\N	\N	\N	
23009	\N	\N	\N	
23010	\N	\N	\N	
23011	\N	\N	\N	
23012	\N	\N	\N	
23013	\N	\N	\N	
23014	\N	\N	\N	
23015	\N	\N	\N	
23016	\N	\N	\N	
23017	\N	\N	\N	
23018	\N	\N	\N	
23019	\N	\N	\N	
23020	\N	\N	\N	
23021	\N	\N	\N	
23022	\N	\N	\N	
23023	\N	\N	\N	
23024	\N	\N	\N	
23025	\N	\N	\N	
23026	\N	\N	\N	
23027	\N	\N	\N	
23028	\N	\N	\N	
23029	\N	\N	\N	
23030	\N	\N	\N	
23031	\N	\N	\N	
23032	\N	\N	\N	
23033	\N	\N	\N	
23034	\N	\N	\N	
23035	\N	\N	\N	
23036	\N	\N	\N	
23037	\N	\N	\N	
23038	\N	\N	\N	
23039	\N	\N	\N	
23040	\N	\N	\N	
23041	\N	\N	\N	
23042	\N	\N	\N	
23043	\N	\N	\N	
23044	\N	\N	\N	
23045	\N	\N	\N	
23046	\N	\N	\N	
23047	\N	\N	\N	
23048	\N	\N	\N	
23049	\N	\N	\N	
23050	\N	\N	\N	
23051	\N	\N	\N	
23052	\N	\N	\N	
23053	\N	\N	\N	
23054	\N	\N	\N	
23055	\N	\N	\N	
23056	\N	\N	\N	
23057	\N	\N	\N	
23058	\N	\N	\N	
23059	\N	\N	\N	
23060	\N	\N	\N	
23061	\N	\N	\N	
23062	\N	\N	\N	
23063	\N	\N	\N	
23064	\N	\N	\N	
23065	\N	\N	\N	
23066	\N	\N	\N	
23067	\N	\N	\N	
23068	\N	\N	\N	
23069	\N	\N	\N	
23070	\N	\N	\N	
23071	\N	\N	\N	
23072	\N	\N	\N	
23073	\N	\N	\N	
23074	\N	\N	\N	
23075	\N	\N	\N	
23076	\N	\N	\N	
23077	\N	\N	\N	
23078	\N	\N	\N	
23079	\N	\N	\N	
23080	\N	\N	\N	
23081	\N	\N	\N	
23082	\N	\N	\N	
23083	\N	\N	\N	
23084	\N	\N	\N	
23085	\N	\N	\N	
23086	\N	\N	\N	
23087	\N	\N	\N	
23088	\N	\N	\N	
23089	\N	\N	\N	
23090	\N	\N	\N	
23091	\N	\N	\N	
23092	\N	\N	\N	
23093	\N	\N	\N	
23094	\N	\N	\N	
23095	\N	\N	\N	
23096	\N	\N	\N	
23097	\N	\N	\N	
23098	\N	\N	\N	
23099	\N	\N	\N	
23100	\N	\N	\N	
23101	\N	\N	\N	
23102	\N	\N	\N	
23103	\N	\N	\N	
23104	\N	\N	\N	
23105	\N	\N	\N	
23106	\N	\N	\N	
23107	\N	\N	\N	
23108	\N	\N	\N	
23109	\N	\N	\N	
23110	\N	\N	\N	
23111	\N	\N	\N	
23112	\N	\N	\N	
23113	\N	\N	\N	
23114	\N	\N	\N	
23115	\N	\N	\N	
23116	\N	\N	\N	
23117	\N	\N	\N	
23118	\N	\N	\N	
23119	\N	\N	\N	
23120	\N	\N	\N	
23121	\N	\N	\N	
23122	\N	\N	\N	
23123	\N	\N	\N	
23124	\N	\N	\N	
23125	\N	\N	\N	
23126	\N	\N	\N	
23127	\N	\N	\N	
23128	\N	\N	\N	
23129	\N	\N	\N	
23130	\N	\N	\N	
23131	\N	\N	\N	
23132	\N	\N	\N	
23133	\N	\N	\N	
23134	\N	\N	\N	
23135	\N	\N	\N	
23136	\N	\N	\N	
23137	\N	\N	\N	
23138	\N	\N	\N	
23139	\N	\N	\N	
23140	\N	\N	\N	
23141	\N	\N	\N	
23142	\N	\N	\N	
23143	\N	\N	\N	
23144	\N	\N	\N	
23145	\N	\N	\N	
23146	\N	\N	\N	
23147	\N	\N	\N	
23148	\N	\N	\N	
23149	\N	\N	\N	
23150	\N	\N	\N	
23151	\N	\N	\N	
23152	\N	\N	\N	
23153	\N	\N	\N	
23154	\N	\N	\N	
23155	\N	\N	\N	
23156	\N	\N	\N	
23157	\N	\N	\N	
23158	\N	\N	\N	
23159	\N	\N	\N	
23160	\N	\N	\N	
23161	\N	\N	\N	
23162	\N	\N	\N	
23163	\N	\N	\N	
23164	\N	\N	\N	
23165	\N	\N	\N	
23166	\N	\N	\N	
23167	\N	\N	\N	
23168	\N	\N	\N	
23169	\N	\N	\N	
23170	\N	\N	\N	
23171	\N	\N	\N	
23172	\N	\N	\N	
23173	\N	\N	\N	
23174	\N	\N	\N	
23175	\N	\N	\N	
23176	\N	\N	\N	
23177	\N	\N	\N	
23178	\N	\N	\N	
23179	\N	\N	\N	
23180	\N	\N	\N	
23181	\N	\N	\N	
23182	\N	\N	\N	
23183	\N	\N	\N	
23184	\N	\N	\N	
23185	\N	\N	\N	
23186	\N	\N	\N	
23187	\N	\N	\N	
23188	\N	\N	\N	
23189	\N	\N	\N	
23190	\N	\N	\N	
23191	\N	\N	\N	
23192	\N	\N	\N	
23193	\N	\N	\N	
23194	\N	\N	\N	
23195	\N	\N	\N	
23196	\N	\N	\N	
23197	\N	\N	\N	
23198	\N	\N	\N	
23199	\N	\N	\N	
23200	\N	\N	\N	
23201	\N	\N	\N	
23202	\N	\N	\N	
23203	\N	\N	\N	
23204	\N	\N	\N	
23205	\N	\N	\N	
23206	\N	\N	\N	
23207	\N	\N	\N	
23208	\N	\N	\N	
23209	\N	\N	\N	
23210	\N	\N	\N	
23211	\N	\N	\N	
23212	\N	\N	\N	
23213	\N	\N	\N	
23214	\N	\N	\N	
23215	\N	\N	\N	
23216	\N	\N	\N	
23217	\N	\N	\N	
23218	\N	\N	\N	
23219	\N	\N	\N	
23220	\N	\N	\N	
23221	\N	\N	\N	
23222	\N	\N	\N	
23223	\N	\N	\N	
23224	\N	\N	\N	
23225	\N	\N	\N	
23226	\N	\N	\N	
23227	\N	\N	\N	
23228	\N	\N	\N	
23229	\N	\N	\N	
23230	\N	\N	\N	
23231	\N	\N	\N	
23232	\N	\N	\N	
23233	\N	\N	\N	
23234	\N	\N	\N	
23235	\N	\N	\N	
23236	\N	\N	\N	
23237	\N	\N	\N	
23238	\N	\N	\N	
23239	\N	\N	\N	
23240	\N	\N	\N	
23241	\N	\N	\N	
23242	\N	\N	\N	
23243	\N	\N	\N	
23244	\N	\N	\N	
23245	\N	\N	\N	
23246	\N	\N	\N	
23247	\N	\N	\N	
23248	\N	\N	\N	
23249	\N	\N	\N	
23250	\N	\N	\N	
23251	\N	\N	\N	
23252	\N	\N	\N	
23253	\N	\N	\N	
23254	\N	\N	\N	
23255	\N	\N	\N	
23256	\N	\N	\N	
23257	\N	\N	\N	
23258	\N	\N	\N	
23259	\N	\N	\N	
23260	\N	\N	\N	
23261	\N	\N	\N	
23262	\N	\N	\N	
23263	\N	\N	\N	
23264	\N	\N	\N	
23265	\N	\N	\N	
23266	\N	\N	\N	
23267	\N	\N	\N	
23268	\N	\N	\N	
23269	\N	\N	\N	
23270	\N	\N	\N	
23271	\N	\N	\N	
23272	\N	\N	\N	
23273	\N	\N	\N	
23274	\N	\N	\N	
23275	\N	\N	\N	
23276	\N	\N	\N	
23277	\N	\N	\N	
23278	\N	\N	\N	
23279	\N	\N	\N	
23280	\N	\N	\N	
23281	\N	\N	\N	
23282	\N	\N	\N	
23283	\N	\N	\N	
23284	\N	\N	\N	
23285	\N	\N	\N	
23286	\N	\N	\N	
23287	\N	\N	\N	
23288	\N	\N	\N	
23289	\N	\N	\N	
23290	\N	\N	\N	
23291	\N	\N	\N	
23292	\N	\N	\N	
23293	\N	\N	\N	
23294	\N	\N	\N	
23295	\N	\N	\N	
23296	\N	\N	\N	
23297	\N	\N	\N	
23298	\N	\N	\N	
23299	\N	\N	\N	
23300	\N	\N	\N	
23301	\N	\N	\N	
23302	\N	\N	\N	
23303	\N	\N	\N	
23304	\N	\N	\N	
23305	\N	\N	\N	
23306	\N	\N	\N	
23307	\N	\N	\N	
23308	\N	\N	\N	
23309	\N	\N	\N	
23310	\N	\N	\N	
23311	\N	\N	\N	
23312	\N	\N	\N	
23313	\N	\N	\N	
23314	\N	\N	\N	
23315	\N	\N	\N	
23316	\N	\N	\N	
23317	\N	\N	\N	
23318	\N	\N	\N	
23319	\N	\N	\N	
23320	\N	\N	\N	
23321	\N	\N	\N	
23322	\N	\N	\N	
23323	\N	\N	\N	
23324	\N	\N	\N	
23325	\N	\N	\N	
23326	\N	\N	\N	
23327	\N	\N	\N	
23328	\N	\N	\N	
23329	\N	\N	\N	
23330	\N	\N	\N	
23331	\N	\N	\N	
23332	\N	\N	\N	
23333	\N	\N	\N	
23334	\N	\N	\N	
23335	\N	\N	\N	
23336	\N	\N	\N	
23337	\N	\N	\N	
23338	\N	\N	\N	
23339	\N	\N	\N	
23340	\N	\N	\N	
23341	\N	\N	\N	
23342	\N	\N	\N	
23343	\N	\N	\N	
23344	\N	\N	\N	
23345	\N	\N	\N	
23346	\N	\N	\N	
23347	\N	\N	\N	
23348	\N	\N	\N	
23349	\N	\N	\N	
23350	\N	\N	\N	
23351	\N	\N	\N	
23352	\N	\N	\N	
23353	\N	\N	\N	
23354	\N	\N	\N	
23355	\N	\N	\N	
23356	\N	\N	\N	
23357	\N	\N	\N	
23358	\N	\N	\N	
23359	\N	\N	\N	
23360	\N	\N	\N	
23361	\N	\N	\N	
23362	\N	\N	\N	
23363	\N	\N	\N	
23364	\N	\N	\N	
23365	\N	\N	\N	
23366	\N	\N	\N	
23367	\N	\N	\N	
23368	\N	\N	\N	
23369	\N	\N	\N	
23370	\N	\N	\N	
23371	\N	\N	\N	
23372	\N	\N	\N	
23373	\N	\N	\N	
23374	\N	\N	\N	
23375	\N	\N	\N	
23376	\N	\N	\N	
23377	\N	\N	\N	
23378	\N	\N	\N	
23379	\N	\N	\N	
23380	\N	\N	\N	
23381	\N	\N	\N	
23382	\N	\N	\N	
23383	\N	\N	\N	
23384	\N	\N	\N	
23385	\N	\N	\N	
23386	\N	\N	\N	
23387	\N	\N	\N	
23388	\N	\N	\N	
23389	\N	\N	\N	
23390	\N	\N	\N	
23391	\N	\N	\N	
23392	\N	\N	\N	
23393	\N	\N	\N	
23394	\N	\N	\N	
23395	\N	\N	\N	
23396	\N	\N	\N	
23397	\N	\N	\N	
23398	\N	\N	\N	
23399	\N	\N	\N	
23400	\N	\N	\N	
23401	\N	\N	\N	
23402	\N	\N	\N	
23403	\N	\N	\N	
23404	\N	\N	\N	
23405	\N	\N	\N	
23406	\N	\N	\N	
23407	\N	\N	\N	
23408	\N	\N	\N	
23409	\N	\N	\N	
23410	\N	\N	\N	
23411	\N	\N	\N	
23412	\N	\N	\N	
23413	\N	\N	\N	
23414	\N	\N	\N	
23415	\N	\N	\N	
23416	\N	\N	\N	
23417	\N	\N	\N	
23418	\N	\N	\N	
23419	\N	\N	\N	
23420	\N	\N	\N	
23421	\N	\N	\N	
23422	\N	\N	\N	
23423	\N	\N	\N	
23424	\N	\N	\N	
23425	\N	\N	\N	
23426	\N	\N	\N	
23427	\N	\N	\N	
23428	\N	\N	\N	
23429	\N	\N	\N	
23430	\N	\N	\N	
23431	\N	\N	\N	
23432	\N	\N	\N	
23433	\N	\N	\N	
23434	\N	\N	\N	
23435	\N	\N	\N	
23436	\N	\N	\N	
23437	\N	\N	\N	
23438	\N	\N	\N	
23439	\N	\N	\N	
23440	\N	\N	\N	
23441	\N	\N	\N	
23442	\N	\N	\N	
23443	\N	\N	\N	
23444	\N	\N	\N	
23445	\N	\N	\N	
23446	\N	\N	\N	
23447	\N	\N	\N	
23448	\N	\N	\N	
23449	\N	\N	\N	
23450	\N	\N	\N	
23451	\N	\N	\N	
23452	\N	\N	\N	
23453	\N	\N	\N	
23454	\N	\N	\N	
23455	\N	\N	\N	
23456	\N	\N	\N	
23457	\N	\N	\N	
23458	\N	\N	\N	
23459	\N	\N	\N	
23460	\N	\N	\N	
23461	\N	\N	\N	
23462	\N	\N	\N	
23463	\N	\N	\N	
23464	\N	\N	\N	
23465	\N	\N	\N	
23466	\N	\N	\N	
23467	\N	\N	\N	
23468	\N	\N	\N	
23469	\N	\N	\N	
23470	\N	\N	\N	
23471	\N	\N	\N	
23472	\N	\N	\N	
23473	\N	\N	\N	
23474	\N	\N	\N	
23475	\N	\N	\N	
23476	\N	\N	\N	
23477	\N	\N	\N	
23478	\N	\N	\N	
23479	\N	\N	\N	
23480	\N	\N	\N	
23481	\N	\N	\N	
23482	\N	\N	\N	
23483	\N	\N	\N	
23484	\N	\N	\N	
23485	\N	\N	\N	
23486	\N	\N	\N	
23487	\N	\N	\N	
23488	\N	\N	\N	
23489	\N	\N	\N	
23490	\N	\N	\N	
23491	\N	\N	\N	
23492	\N	\N	\N	
23493	\N	\N	\N	
23494	\N	\N	\N	
23495	\N	\N	\N	
23496	\N	\N	\N	
23497	\N	\N	\N	
23498	\N	\N	\N	
23499	\N	\N	\N	
23500	\N	\N	\N	
23501	\N	\N	\N	
23502	\N	\N	\N	
23503	\N	\N	\N	
23504	\N	\N	\N	
23505	\N	\N	\N	
23506	\N	\N	\N	
23507	\N	\N	\N	
23508	\N	\N	\N	
23509	\N	\N	\N	
23510	\N	\N	\N	
23511	\N	\N	\N	
23512	\N	\N	\N	
23513	\N	\N	\N	
23514	\N	\N	\N	
23515	\N	\N	\N	
23516	\N	\N	\N	
23517	\N	\N	\N	
23518	\N	\N	\N	
23519	\N	\N	\N	
23520	\N	\N	\N	
23521	\N	\N	\N	
23522	\N	\N	\N	
23523	\N	\N	\N	
23524	\N	\N	\N	
23525	\N	\N	\N	
23526	\N	\N	\N	
23527	\N	\N	\N	
23528	\N	\N	\N	
23529	\N	\N	\N	
23530	\N	\N	\N	
23531	\N	\N	\N	
23532	\N	\N	\N	
23533	\N	\N	\N	
23534	\N	\N	\N	
23535	\N	\N	\N	
23536	\N	\N	\N	
23537	\N	\N	\N	
23538	\N	\N	\N	
23539	\N	\N	\N	
23540	\N	\N	\N	
23541	\N	\N	\N	
23542	\N	\N	\N	
23543	\N	\N	\N	
23544	\N	\N	\N	
23545	\N	\N	\N	
23546	\N	\N	\N	
23547	\N	\N	\N	
23548	\N	\N	\N	
23549	\N	\N	\N	
23550	\N	\N	\N	
23551	\N	\N	\N	
23552	\N	\N	\N	
23553	\N	\N	\N	
23554	\N	\N	\N	
23555	\N	\N	\N	
23556	\N	\N	\N	
23557	\N	\N	\N	
23558	\N	\N	\N	
23559	\N	\N	\N	
23560	\N	\N	\N	
23561	\N	\N	\N	
23562	\N	\N	\N	
23563	\N	\N	\N	
23564	\N	\N	\N	
23565	\N	\N	\N	
23566	\N	\N	\N	
23567	\N	\N	\N	
23568	\N	\N	\N	
23569	\N	\N	\N	
23570	\N	\N	\N	
23571	\N	\N	\N	
23572	\N	\N	\N	
23573	\N	\N	\N	
23574	\N	\N	\N	
23575	\N	\N	\N	
23576	\N	\N	\N	
23577	\N	\N	\N	
23578	\N	\N	\N	
23579	\N	\N	\N	
23580	\N	\N	\N	
23581	\N	\N	\N	
23582	\N	\N	\N	
23583	\N	\N	\N	
23584	\N	\N	\N	
23585	\N	\N	\N	
23586	\N	\N	\N	
23587	\N	\N	\N	
23588	\N	\N	\N	
23589	\N	\N	\N	
23590	\N	\N	\N	
23591	\N	\N	\N	
23592	\N	\N	\N	
23593	\N	\N	\N	
23594	\N	\N	\N	
23595	\N	\N	\N	
23596	\N	\N	\N	
23597	\N	\N	\N	
23598	\N	\N	\N	
23599	\N	\N	\N	
23600	\N	\N	\N	
23601	\N	\N	\N	
23602	\N	\N	\N	
23603	\N	\N	\N	
23604	\N	\N	\N	
23605	\N	\N	\N	
23606	\N	\N	\N	
23607	\N	\N	\N	
23608	\N	\N	\N	
23609	\N	\N	\N	
23610	\N	\N	\N	
23611	\N	\N	\N	
23612	\N	\N	\N	
23613	\N	\N	\N	
23614	\N	\N	\N	
23615	\N	\N	\N	
23616	\N	\N	\N	
23617	\N	\N	\N	
23618	\N	\N	\N	
23619	\N	\N	\N	
23620	\N	\N	\N	
23621	\N	\N	\N	
23622	\N	\N	\N	
23623	\N	\N	\N	
23624	\N	\N	\N	
23625	\N	\N	\N	
23626	\N	\N	\N	
23627	\N	\N	\N	
23628	\N	\N	\N	
23629	\N	\N	\N	
23630	\N	\N	\N	
23631	\N	\N	\N	
23632	\N	\N	\N	
23633	\N	\N	\N	
23634	\N	\N	\N	
23635	\N	\N	\N	
23636	\N	\N	\N	
23637	\N	\N	\N	
23638	\N	\N	\N	
23639	\N	\N	\N	
23640	\N	\N	\N	
23641	\N	\N	\N	
23642	\N	\N	\N	
23643	\N	\N	\N	
23644	\N	\N	\N	
23645	\N	\N	\N	
23646	\N	\N	\N	
23647	\N	\N	\N	
23648	\N	\N	\N	
23649	\N	\N	\N	
23650	\N	\N	\N	
23651	\N	\N	\N	
23652	\N	\N	\N	
23653	\N	\N	\N	
23654	\N	\N	\N	
23655	\N	\N	\N	
23656	\N	\N	\N	
23657	\N	\N	\N	
23658	\N	\N	\N	
23659	\N	\N	\N	
23660	\N	\N	\N	
23661	\N	\N	\N	
23662	\N	\N	\N	
23663	\N	\N	\N	
23664	\N	\N	\N	
23665	\N	\N	\N	
23666	\N	\N	\N	
23667	\N	\N	\N	
23668	\N	\N	\N	
23669	\N	\N	\N	
23670	\N	\N	\N	
23671	\N	\N	\N	
23672	\N	\N	\N	
23673	\N	\N	\N	
23674	\N	\N	\N	
23675	\N	\N	\N	
23676	\N	\N	\N	
23677	\N	\N	\N	
23678	\N	\N	\N	
23679	\N	\N	\N	
23680	\N	\N	\N	
23681	\N	\N	\N	
23682	\N	\N	\N	
23683	\N	\N	\N	
23684	\N	\N	\N	
23685	\N	\N	\N	
23686	\N	\N	\N	
23687	\N	\N	\N	
23688	\N	\N	\N	
23689	\N	\N	\N	
23690	\N	\N	\N	
23691	\N	\N	\N	
23692	\N	\N	\N	
23693	\N	\N	\N	
23694	\N	\N	\N	
23695	\N	\N	\N	
23696	\N	\N	\N	
23697	\N	\N	\N	
23698	\N	\N	\N	
23699	\N	\N	\N	
23700	\N	\N	\N	
23701	\N	\N	\N	
23702	\N	\N	\N	
23703	\N	\N	\N	
23704	\N	\N	\N	
23705	\N	\N	\N	
23706	\N	\N	\N	
23707	\N	\N	\N	
23708	\N	\N	\N	
23709	\N	\N	\N	
23710	\N	\N	\N	
23711	\N	\N	\N	
23712	\N	\N	\N	
23713	\N	\N	\N	
23714	\N	\N	\N	
23715	\N	\N	\N	
23716	\N	\N	\N	
23717	\N	\N	\N	
23718	\N	\N	\N	
23719	\N	\N	\N	
23720	\N	\N	\N	
23721	\N	\N	\N	
23722	\N	\N	\N	
23723	\N	\N	\N	
23724	\N	\N	\N	
23725	\N	\N	\N	
23726	\N	\N	\N	
23727	\N	\N	\N	
23728	\N	\N	\N	
23729	\N	\N	\N	
23730	\N	\N	\N	
23731	\N	\N	\N	
23732	\N	\N	\N	
23733	\N	\N	\N	
23734	\N	\N	\N	
23735	\N	\N	\N	
23736	\N	\N	\N	
23737	\N	\N	\N	
23738	\N	\N	\N	
23739	\N	\N	\N	
23740	\N	\N	\N	
23741	\N	\N	\N	
23742	\N	\N	\N	
23743	\N	\N	\N	
23744	\N	\N	\N	
23745	\N	\N	\N	
23746	\N	\N	\N	
23747	\N	\N	\N	
23748	\N	\N	\N	
23749	\N	\N	\N	
23750	\N	\N	\N	
23751	\N	\N	\N	
23752	\N	\N	\N	
23753	\N	\N	\N	
23754	\N	\N	\N	
23755	\N	\N	\N	
23756	\N	\N	\N	
23757	\N	\N	\N	
23758	\N	\N	\N	
23759	\N	\N	\N	
23760	\N	\N	\N	
23761	\N	\N	\N	
23762	\N	\N	\N	
23763	\N	\N	\N	
23764	\N	\N	\N	
23765	\N	\N	\N	
23766	\N	\N	\N	
23767	\N	\N	\N	
23768	\N	\N	\N	
23769	\N	\N	\N	
23770	\N	\N	\N	
23771	\N	\N	\N	
23772	\N	\N	\N	
23773	\N	\N	\N	
23774	\N	\N	\N	
23775	\N	\N	\N	
23776	\N	\N	\N	
23777	\N	\N	\N	
23778	\N	\N	\N	
23779	\N	\N	\N	
23780	\N	\N	\N	
23781	\N	\N	\N	
23782	\N	\N	\N	
23783	\N	\N	\N	
23784	\N	\N	\N	
23785	\N	\N	\N	
23786	\N	\N	\N	
23787	\N	\N	\N	
23788	\N	\N	\N	
23789	\N	\N	\N	
23790	\N	\N	\N	
23791	\N	\N	\N	
23792	\N	\N	\N	
23793	\N	\N	\N	
23794	\N	\N	\N	
23795	\N	\N	\N	
23796	\N	\N	\N	
23797	\N	\N	\N	
23798	\N	\N	\N	
23799	\N	\N	\N	
23800	\N	\N	\N	
23801	\N	\N	\N	
23802	\N	\N	\N	
23803	\N	\N	\N	
23804	\N	\N	\N	
23805	\N	\N	\N	
23806	\N	\N	\N	
23807	\N	\N	\N	
23808	\N	\N	\N	
23809	\N	\N	\N	
23810	\N	\N	\N	
23811	\N	\N	\N	
23812	\N	\N	\N	
23813	\N	\N	\N	
23814	\N	\N	\N	
23815	\N	\N	\N	
23816	\N	\N	\N	
23817	\N	\N	\N	
23818	\N	\N	\N	
23819	\N	\N	\N	
23820	\N	\N	\N	
23821	\N	\N	\N	
23822	\N	\N	\N	
23823	\N	\N	\N	
23824	\N	\N	\N	
23825	\N	\N	\N	
23826	\N	\N	\N	
23827	\N	\N	\N	
23828	\N	\N	\N	
23829	\N	\N	\N	
23830	\N	\N	\N	
23831	\N	\N	\N	
23832	\N	\N	\N	
23833	\N	\N	\N	
23834	\N	\N	\N	
23835	\N	\N	\N	
23836	\N	\N	\N	
23837	\N	\N	\N	
23838	\N	\N	\N	
23839	\N	\N	\N	
23840	\N	\N	\N	
23841	\N	\N	\N	
23842	\N	\N	\N	
23843	\N	\N	\N	
23844	\N	\N	\N	
23845	\N	\N	\N	
23846	\N	\N	\N	
23847	\N	\N	\N	
23848	\N	\N	\N	
23849	\N	\N	\N	
23850	\N	\N	\N	
23851	\N	\N	\N	
23852	\N	\N	\N	
23853	\N	\N	\N	
23854	\N	\N	\N	
23855	\N	\N	\N	
23856	\N	\N	\N	
23857	\N	\N	\N	
23858	\N	\N	\N	
23859	\N	\N	\N	
23860	\N	\N	\N	
23861	\N	\N	\N	
23862	\N	\N	\N	
23863	\N	\N	\N	
23864	\N	\N	\N	
23865	\N	\N	\N	
23866	\N	\N	\N	
23867	\N	\N	\N	
23868	\N	\N	\N	
23869	\N	\N	\N	
23870	\N	\N	\N	
23871	\N	\N	\N	
23872	\N	\N	\N	
23873	\N	\N	\N	
23874	\N	\N	\N	
23875	\N	\N	\N	
23876	\N	\N	\N	
23877	\N	\N	\N	
23878	\N	\N	\N	
23879	\N	\N	\N	
23880	\N	\N	\N	
23881	\N	\N	\N	
23882	\N	\N	\N	
23883	\N	\N	\N	
23884	\N	\N	\N	
23885	\N	\N	\N	
23886	\N	\N	\N	
23887	\N	\N	\N	
23888	\N	\N	\N	
23889	\N	\N	\N	
23890	\N	\N	\N	
23891	\N	\N	\N	
23892	\N	\N	\N	
23893	\N	\N	\N	
23894	\N	\N	\N	
23895	\N	\N	\N	
23896	\N	\N	\N	
23897	\N	\N	\N	
23898	\N	\N	\N	
23899	\N	\N	\N	
23900	\N	\N	\N	
23901	\N	\N	\N	
23902	\N	\N	\N	
23903	\N	\N	\N	
23904	\N	\N	\N	
23905	\N	\N	\N	
23906	\N	\N	\N	
23907	\N	\N	\N	
23908	\N	\N	\N	
23909	\N	\N	\N	
23910	\N	\N	\N	
23911	\N	\N	\N	
23912	\N	\N	\N	
23913	\N	\N	\N	
23914	\N	\N	\N	
23915	\N	\N	\N	
23916	\N	\N	\N	
23917	\N	\N	\N	
23918	\N	\N	\N	
23919	\N	\N	\N	
23920	\N	\N	\N	
23921	\N	\N	\N	
23922	\N	\N	\N	
23923	\N	\N	\N	
23924	\N	\N	\N	
23925	\N	\N	\N	
23926	\N	\N	\N	
23927	\N	\N	\N	
23928	\N	\N	\N	
23929	\N	\N	\N	
23930	\N	\N	\N	
23931	\N	\N	\N	
23932	\N	\N	\N	
23933	\N	\N	\N	
23934	\N	\N	\N	
23935	\N	\N	\N	
23936	\N	\N	\N	
23937	\N	\N	\N	
23938	\N	\N	\N	
23939	\N	\N	\N	
23940	\N	\N	\N	
23941	\N	\N	\N	
23942	\N	\N	\N	
23943	\N	\N	\N	
23944	\N	\N	\N	
23945	\N	\N	\N	
23946	\N	\N	\N	
23947	\N	\N	\N	
23948	\N	\N	\N	
23949	\N	\N	\N	
23950	\N	\N	\N	
23951	\N	\N	\N	
23952	\N	\N	\N	
23953	\N	\N	\N	
23954	\N	\N	\N	
23955	\N	\N	\N	
23956	\N	\N	\N	
23957	\N	\N	\N	
23958	\N	\N	\N	
23959	\N	\N	\N	
23960	\N	\N	\N	
23961	\N	\N	\N	
23962	\N	\N	\N	
23963	\N	\N	\N	
23964	\N	\N	\N	
23965	\N	\N	\N	
23966	\N	\N	\N	
23967	\N	\N	\N	
23968	\N	\N	\N	
23969	\N	\N	\N	
23970	\N	\N	\N	
23971	\N	\N	\N	
23972	\N	\N	\N	
23973	\N	\N	\N	
23974	\N	\N	\N	
23975	\N	\N	\N	
23976	\N	\N	\N	
23977	\N	\N	\N	
23978	\N	\N	\N	
23979	\N	\N	\N	
23980	\N	\N	\N	
23981	\N	\N	\N	
23982	\N	\N	\N	
23983	\N	\N	\N	
23984	\N	\N	\N	
23985	\N	\N	\N	
23986	\N	\N	\N	
23987	\N	\N	\N	
23988	\N	\N	\N	
23989	\N	\N	\N	
23990	\N	\N	\N	
23991	\N	\N	\N	
23992	\N	\N	\N	
23993	\N	\N	\N	
23994	\N	\N	\N	
23995	\N	\N	\N	
23996	\N	\N	\N	
23997	\N	\N	\N	
23998	\N	\N	\N	
23999	\N	\N	\N	
24000	\N	\N	\N	
24001	\N	\N	\N	
24002	\N	\N	\N	
24003	\N	\N	\N	
24004	\N	\N	\N	
24005	\N	\N	\N	
24006	\N	\N	\N	
24007	\N	\N	\N	
24008	\N	\N	\N	
24009	\N	\N	\N	
24010	\N	\N	\N	
24011	\N	\N	\N	
24012	\N	\N	\N	
24013	\N	\N	\N	
24014	\N	\N	\N	
24015	\N	\N	\N	
24016	\N	\N	\N	
24017	\N	\N	\N	
24018	\N	\N	\N	
24019	\N	\N	\N	
24020	\N	\N	\N	
24021	\N	\N	\N	
24022	\N	\N	\N	
24023	\N	\N	\N	
24024	\N	\N	\N	
24025	\N	\N	\N	
24026	\N	\N	\N	
24027	\N	\N	\N	
24028	\N	\N	\N	
24029	\N	\N	\N	
24030	\N	\N	\N	
24031	\N	\N	\N	
24032	\N	\N	\N	
24033	\N	\N	\N	
24034	\N	\N	\N	
24035	\N	\N	\N	
24036	\N	\N	\N	
24037	\N	\N	\N	
24038	\N	\N	\N	
24039	\N	\N	\N	
24040	\N	\N	\N	
24041	\N	\N	\N	
24042	\N	\N	\N	
24043	\N	\N	\N	
24044	\N	\N	\N	
24045	\N	\N	\N	
24046	\N	\N	\N	
24047	\N	\N	\N	
24048	\N	\N	\N	
24049	\N	\N	\N	
24050	\N	\N	\N	
24051	\N	\N	\N	
24052	\N	\N	\N	
24053	\N	\N	\N	
24054	\N	\N	\N	
24055	\N	\N	\N	
24056	\N	\N	\N	
24057	\N	\N	\N	
24058	\N	\N	\N	
24059	\N	\N	\N	
24060	\N	\N	\N	
24061	\N	\N	\N	
24062	\N	\N	\N	
24063	\N	\N	\N	
24064	\N	\N	\N	
24065	\N	\N	\N	
24066	\N	\N	\N	
24067	\N	\N	\N	
24068	\N	\N	\N	
24069	\N	\N	\N	
24070	\N	\N	\N	
24071	\N	\N	\N	
24072	\N	\N	\N	
24073	\N	\N	\N	
24074	\N	\N	\N	
24075	\N	\N	\N	
24076	\N	\N	\N	
24077	\N	\N	\N	
24078	\N	\N	\N	
24079	\N	\N	\N	
24080	\N	\N	\N	
24081	\N	\N	\N	
24082	\N	\N	\N	
24083	\N	\N	\N	
24084	\N	\N	\N	
24085	\N	\N	\N	
24086	\N	\N	\N	
24087	\N	\N	\N	
24088	\N	\N	\N	
24089	\N	\N	\N	
24090	\N	\N	\N	
24091	\N	\N	\N	
24092	\N	\N	\N	
24093	\N	\N	\N	
24094	\N	\N	\N	
24095	\N	\N	\N	
24096	\N	\N	\N	
24097	\N	\N	\N	
24098	\N	\N	\N	
24099	\N	\N	\N	
24100	\N	\N	\N	
24101	\N	\N	\N	
24102	\N	\N	\N	
24103	\N	\N	\N	
24104	\N	\N	\N	
24105	\N	\N	\N	
24106	\N	\N	\N	
24107	\N	\N	\N	
24108	\N	\N	\N	
24109	\N	\N	\N	
24110	\N	\N	\N	
24111	\N	\N	\N	
24112	\N	\N	\N	
24113	\N	\N	\N	
24114	\N	\N	\N	
24115	\N	\N	\N	
24116	\N	\N	\N	
24117	\N	\N	\N	
24118	\N	\N	\N	
24119	\N	\N	\N	
24120	\N	\N	\N	
24121	\N	\N	\N	
24122	\N	\N	\N	
24123	\N	\N	\N	
24124	\N	\N	\N	
24125	\N	\N	\N	
24126	\N	\N	\N	
24127	\N	\N	\N	
24128	\N	\N	\N	
24129	\N	\N	\N	
24130	\N	\N	\N	
24131	\N	\N	\N	
24132	\N	\N	\N	
24133	\N	\N	\N	
24134	\N	\N	\N	
24135	\N	\N	\N	
24136	\N	\N	\N	
24137	\N	\N	\N	
24138	\N	\N	\N	
24139	\N	\N	\N	
24140	\N	\N	\N	
24141	\N	\N	\N	
24142	\N	\N	\N	
24143	\N	\N	\N	
24144	\N	\N	\N	
24145	\N	\N	\N	
24146	\N	\N	\N	
24147	\N	\N	\N	
24148	\N	\N	\N	
24149	\N	\N	\N	
24150	\N	\N	\N	
24151	\N	\N	\N	
24152	\N	\N	\N	
24153	\N	\N	\N	
24154	\N	\N	\N	
24155	\N	\N	\N	
24156	\N	\N	\N	
24157	\N	\N	\N	
24158	\N	\N	\N	
24159	\N	\N	\N	
24160	\N	\N	\N	
24161	\N	\N	\N	
24162	\N	\N	\N	
24163	\N	\N	\N	
24164	\N	\N	\N	
24165	\N	\N	\N	
24166	\N	\N	\N	
24167	\N	\N	\N	
24168	\N	\N	\N	
24169	\N	\N	\N	
24170	\N	\N	\N	
24171	\N	\N	\N	
24172	\N	\N	\N	
24173	\N	\N	\N	
24174	\N	\N	\N	
24175	\N	\N	\N	
24176	\N	\N	\N	
24177	\N	\N	\N	
24178	\N	\N	\N	
24179	\N	\N	\N	
24180	\N	\N	\N	
24181	\N	\N	\N	
24182	\N	\N	\N	
24183	\N	\N	\N	
24184	\N	\N	\N	
24185	\N	\N	\N	
24186	\N	\N	\N	
24187	\N	\N	\N	
24188	\N	\N	\N	
24189	\N	\N	\N	
24190	\N	\N	\N	
24191	\N	\N	\N	
24192	\N	\N	\N	
24193	\N	\N	\N	
24194	\N	\N	\N	
24195	\N	\N	\N	
24196	\N	\N	\N	
24197	\N	\N	\N	
24198	\N	\N	\N	
24199	\N	\N	\N	
24200	\N	\N	\N	
24201	\N	\N	\N	
24202	\N	\N	\N	
24203	\N	\N	\N	
24204	\N	\N	\N	
24205	\N	\N	\N	
24206	\N	\N	\N	
24207	\N	\N	\N	
24208	\N	\N	\N	
24209	\N	\N	\N	
24210	\N	\N	\N	
24211	\N	\N	\N	
24212	\N	\N	\N	
24213	\N	\N	\N	
24214	\N	\N	\N	
24215	\N	\N	\N	
24216	\N	\N	\N	
24217	\N	\N	\N	
24218	\N	\N	\N	
24219	\N	\N	\N	
24220	\N	\N	\N	
24221	\N	\N	\N	
24222	\N	\N	\N	
24223	\N	\N	\N	
24224	\N	\N	\N	
24225	\N	\N	\N	
24226	\N	\N	\N	
24227	\N	\N	\N	
24228	\N	\N	\N	
24229	\N	\N	\N	
24230	\N	\N	\N	
24231	\N	\N	\N	
24232	\N	\N	\N	
24233	\N	\N	\N	
24234	\N	\N	\N	
24235	\N	\N	\N	
24236	\N	\N	\N	
24237	\N	\N	\N	
24238	\N	\N	\N	
24239	\N	\N	\N	
24240	\N	\N	\N	
24241	\N	\N	\N	
24242	\N	\N	\N	
24243	\N	\N	\N	
24244	\N	\N	\N	
24245	\N	\N	\N	
24246	\N	\N	\N	
24247	\N	\N	\N	
24248	\N	\N	\N	
24249	\N	\N	\N	
24250	\N	\N	\N	
24251	\N	\N	\N	
24252	\N	\N	\N	
24253	\N	\N	\N	
24254	\N	\N	\N	
24255	\N	\N	\N	
24256	\N	\N	\N	
24257	\N	\N	\N	
24258	\N	\N	\N	
24259	\N	\N	\N	
24260	\N	\N	\N	
24261	\N	\N	\N	
24262	\N	\N	\N	
24263	\N	\N	\N	
24264	\N	\N	\N	
24265	\N	\N	\N	
24266	\N	\N	\N	
24267	\N	\N	\N	
24268	\N	\N	\N	
24269	\N	\N	\N	
24270	\N	\N	\N	
24271	\N	\N	\N	
24272	\N	\N	\N	
24273	\N	\N	\N	
24274	\N	\N	\N	
24275	\N	\N	\N	
24276	\N	\N	\N	
24277	\N	\N	\N	
24278	\N	\N	\N	
24279	\N	\N	\N	
24280	\N	\N	\N	
24281	\N	\N	\N	
24282	\N	\N	\N	
24283	\N	\N	\N	
24284	\N	\N	\N	
24285	\N	\N	\N	
24286	\N	\N	\N	
24287	\N	\N	\N	
24288	\N	\N	\N	
24289	\N	\N	\N	
24290	\N	\N	\N	
24291	\N	\N	\N	
24292	\N	\N	\N	
24293	\N	\N	\N	
24294	\N	\N	\N	
24295	\N	\N	\N	
24296	\N	\N	\N	
24297	\N	\N	\N	
24298	\N	\N	\N	
24299	\N	\N	\N	
24300	\N	\N	\N	
24301	\N	\N	\N	
24302	\N	\N	\N	
24303	\N	\N	\N	
24304	\N	\N	\N	
24305	\N	\N	\N	
24306	\N	\N	\N	
24307	\N	\N	\N	
24308	\N	\N	\N	
24309	\N	\N	\N	
24310	\N	\N	\N	
24311	\N	\N	\N	
24312	\N	\N	\N	
24313	\N	\N	\N	
24314	\N	\N	\N	
24315	\N	\N	\N	
24316	\N	\N	\N	
24317	\N	\N	\N	
24318	\N	\N	\N	
24319	\N	\N	\N	
24320	\N	\N	\N	
24321	\N	\N	\N	
24322	\N	\N	\N	
24323	\N	\N	\N	
24324	\N	\N	\N	
24325	\N	\N	\N	
24326	\N	\N	\N	
24327	\N	\N	\N	
24328	\N	\N	\N	
24329	\N	\N	\N	
24330	\N	\N	\N	
24331	\N	\N	\N	
24332	\N	\N	\N	
24333	\N	\N	\N	
24334	\N	\N	\N	
24335	\N	\N	\N	
24336	\N	\N	\N	
24337	\N	\N	\N	
24338	\N	\N	\N	
24339	\N	\N	\N	
24340	\N	\N	\N	
24341	\N	\N	\N	
24342	\N	\N	\N	
24343	\N	\N	\N	
24344	\N	\N	\N	
24345	\N	\N	\N	
24346	\N	\N	\N	
24347	\N	\N	\N	
24348	\N	\N	\N	
24349	\N	\N	\N	
24350	\N	\N	\N	
24351	\N	\N	\N	
24352	\N	\N	\N	
24353	\N	\N	\N	
24354	\N	\N	\N	
24355	\N	\N	\N	
24356	\N	\N	\N	
24357	\N	\N	\N	
24358	\N	\N	\N	
24359	\N	\N	\N	
24360	\N	\N	\N	
24361	\N	\N	\N	
24362	\N	\N	\N	
24363	\N	\N	\N	
24364	\N	\N	\N	
24365	\N	\N	\N	
24366	\N	\N	\N	
24367	\N	\N	\N	
24368	\N	\N	\N	
24369	\N	\N	\N	
24370	\N	\N	\N	
24371	\N	\N	\N	
24372	\N	\N	\N	
24373	\N	\N	\N	
24374	\N	\N	\N	
24375	\N	\N	\N	
24376	\N	\N	\N	
24377	\N	\N	\N	
24378	\N	\N	\N	
24379	\N	\N	\N	
24380	\N	\N	\N	
24381	\N	\N	\N	
24382	\N	\N	\N	
24383	\N	\N	\N	
24384	\N	\N	\N	
24385	\N	\N	\N	
24386	\N	\N	\N	
24387	\N	\N	\N	
24388	\N	\N	\N	
24389	\N	\N	\N	
24390	\N	\N	\N	
24391	\N	\N	\N	
24392	\N	\N	\N	
24393	\N	\N	\N	
24394	\N	\N	\N	
24395	\N	\N	\N	
24396	\N	\N	\N	
24397	\N	\N	\N	
24398	\N	\N	\N	
24399	\N	\N	\N	
24400	\N	\N	\N	
24401	\N	\N	\N	
24402	\N	\N	\N	
24403	\N	\N	\N	
24404	\N	\N	\N	
24405	\N	\N	\N	
24406	\N	\N	\N	
24407	\N	\N	\N	
24408	\N	\N	\N	
24409	\N	\N	\N	
24410	\N	\N	\N	
24411	\N	\N	\N	
24412	\N	\N	\N	
24413	\N	\N	\N	
24414	\N	\N	\N	
24415	\N	\N	\N	
24416	\N	\N	\N	
24417	\N	\N	\N	
24418	\N	\N	\N	
24419	\N	\N	\N	
24420	\N	\N	\N	
24421	\N	\N	\N	
24422	\N	\N	\N	
24423	\N	\N	\N	
24424	\N	\N	\N	
24425	\N	\N	\N	
24426	\N	\N	\N	
24427	\N	\N	\N	
24428	\N	\N	\N	
24429	\N	\N	\N	
24430	\N	\N	\N	
24431	\N	\N	\N	
24432	\N	\N	\N	
24433	\N	\N	\N	
24434	\N	\N	\N	
24435	\N	\N	\N	
24436	\N	\N	\N	
24437	\N	\N	\N	
24438	\N	\N	\N	
24439	\N	\N	\N	
24440	\N	\N	\N	
24441	\N	\N	\N	
24442	\N	\N	\N	
24443	\N	\N	\N	
24444	\N	\N	\N	
24445	\N	\N	\N	
24446	\N	\N	\N	
24447	\N	\N	\N	
24448	\N	\N	\N	
24449	\N	\N	\N	
24450	\N	\N	\N	
24451	\N	\N	\N	
24452	\N	\N	\N	
24453	\N	\N	\N	
24454	\N	\N	\N	
24455	\N	\N	\N	
24456	\N	\N	\N	
24457	\N	\N	\N	
24458	\N	\N	\N	
24459	\N	\N	\N	
24460	\N	\N	\N	
24461	\N	\N	\N	
24462	\N	\N	\N	
24463	\N	\N	\N	
24464	\N	\N	\N	
24465	\N	\N	\N	
24466	\N	\N	\N	
24467	\N	\N	\N	
24468	\N	\N	\N	
24469	\N	\N	\N	
24470	\N	\N	\N	
24471	\N	\N	\N	
24472	\N	\N	\N	
24473	\N	\N	\N	
24474	\N	\N	\N	
24475	\N	\N	\N	
24476	\N	\N	\N	
24477	\N	\N	\N	
24478	\N	\N	\N	
24479	\N	\N	\N	
24480	\N	\N	\N	
24481	\N	\N	\N	
24482	\N	\N	\N	
24483	\N	\N	\N	
24484	\N	\N	\N	
24485	\N	\N	\N	
24486	\N	\N	\N	
24487	\N	\N	\N	
24488	\N	\N	\N	
24489	\N	\N	\N	
24490	\N	\N	\N	
24491	\N	\N	\N	
24492	\N	\N	\N	
24493	\N	\N	\N	
24494	\N	\N	\N	
24495	\N	\N	\N	
24496	\N	\N	\N	
24497	\N	\N	\N	
24498	\N	\N	\N	
24499	\N	\N	\N	
24500	\N	\N	\N	
24501	\N	\N	\N	
24502	\N	\N	\N	
24503	\N	\N	\N	
24504	\N	\N	\N	
24505	\N	\N	\N	
24506	\N	\N	\N	
24507	\N	\N	\N	
24508	\N	\N	\N	
24509	\N	\N	\N	
24510	\N	\N	\N	
24511	\N	\N	\N	
24512	\N	\N	\N	
24513	\N	\N	\N	
24514	\N	\N	\N	
24515	\N	\N	\N	
24516	\N	\N	\N	
24517	\N	\N	\N	
24518	\N	\N	\N	
24519	\N	\N	\N	
24520	\N	\N	\N	
24521	\N	\N	\N	
24522	\N	\N	\N	
24523	\N	\N	\N	
24524	\N	\N	\N	
24525	\N	\N	\N	
24526	\N	\N	\N	
24527	\N	\N	\N	
24528	\N	\N	\N	
24529	\N	\N	\N	
24530	\N	\N	\N	
24531	\N	\N	\N	
24532	\N	\N	\N	
24533	\N	\N	\N	
24534	\N	\N	\N	
24535	\N	\N	\N	
24536	\N	\N	\N	
24537	\N	\N	\N	
24538	\N	\N	\N	
24539	\N	\N	\N	
24540	\N	\N	\N	
24541	\N	\N	\N	
24542	\N	\N	\N	
24543	\N	\N	\N	
24544	\N	\N	\N	
24545	\N	\N	\N	
24546	\N	\N	\N	
24547	\N	\N	\N	
24548	\N	\N	\N	
24549	\N	\N	\N	
24550	\N	\N	\N	
24551	\N	\N	\N	
24552	\N	\N	\N	
24553	\N	\N	\N	
24554	\N	\N	\N	
24555	\N	\N	\N	
24556	\N	\N	\N	
24557	\N	\N	\N	
24558	\N	\N	\N	
24559	\N	\N	\N	
24560	\N	\N	\N	
24561	\N	\N	\N	
24562	\N	\N	\N	
24563	\N	\N	\N	
24564	\N	\N	\N	
24565	\N	\N	\N	
24566	\N	\N	\N	
24567	\N	\N	\N	
24568	\N	\N	\N	
24569	\N	\N	\N	
24570	\N	\N	\N	
24571	\N	\N	\N	
24572	\N	\N	\N	
24573	\N	\N	\N	
24574	\N	\N	\N	
24575	\N	\N	\N	
24576	\N	\N	\N	
24577	\N	\N	\N	
24578	\N	\N	\N	
24579	\N	\N	\N	
24580	\N	\N	\N	
24581	\N	\N	\N	
24582	\N	\N	\N	
24583	\N	\N	\N	
24584	\N	\N	\N	
24585	\N	\N	\N	
24586	\N	\N	\N	
24587	\N	\N	\N	
24588	\N	\N	\N	
24589	\N	\N	\N	
24590	\N	\N	\N	
24591	\N	\N	\N	
24592	\N	\N	\N	
24593	\N	\N	\N	
24594	\N	\N	\N	
24595	\N	\N	\N	
24596	\N	\N	\N	
24597	\N	\N	\N	
24598	\N	\N	\N	
24599	\N	\N	\N	
24600	\N	\N	\N	
24601	\N	\N	\N	
24602	\N	\N	\N	
24603	\N	\N	\N	
24604	\N	\N	\N	
24605	\N	\N	\N	
24606	\N	\N	\N	
24607	\N	\N	\N	
24608	\N	\N	\N	
24609	\N	\N	\N	
24610	\N	\N	\N	
24611	\N	\N	\N	
24612	\N	\N	\N	
24613	\N	\N	\N	
24614	\N	\N	\N	
24615	\N	\N	\N	
24616	\N	\N	\N	
24617	\N	\N	\N	
24618	\N	\N	\N	
24619	\N	\N	\N	
24620	\N	\N	\N	
24621	\N	\N	\N	
24622	\N	\N	\N	
24623	\N	\N	\N	
24624	\N	\N	\N	
24625	\N	\N	\N	
24626	\N	\N	\N	
24627	\N	\N	\N	
24628	\N	\N	\N	
24629	\N	\N	\N	
24630	\N	\N	\N	
24631	\N	\N	\N	
24632	\N	\N	\N	
24633	\N	\N	\N	
24634	\N	\N	\N	
24635	\N	\N	\N	
24636	\N	\N	\N	
24637	\N	\N	\N	
24638	\N	\N	\N	
24639	\N	\N	\N	
24640	\N	\N	\N	
24641	\N	\N	\N	
24642	\N	\N	\N	
24643	\N	\N	\N	
24644	\N	\N	\N	
24645	\N	\N	\N	
24646	\N	\N	\N	
24647	\N	\N	\N	
24648	\N	\N	\N	
24649	\N	\N	\N	
24650	\N	\N	\N	
24651	\N	\N	\N	
24652	\N	\N	\N	
24653	\N	\N	\N	
24654	\N	\N	\N	
24655	\N	\N	\N	
24656	\N	\N	\N	
24657	\N	\N	\N	
24658	\N	\N	\N	
24659	\N	\N	\N	
24660	\N	\N	\N	
24661	\N	\N	\N	
24662	\N	\N	\N	
24663	\N	\N	\N	
24664	\N	\N	\N	
24665	\N	\N	\N	
24666	\N	\N	\N	
24667	\N	\N	\N	
24668	\N	\N	\N	
24669	\N	\N	\N	
24670	\N	\N	\N	
24671	\N	\N	\N	
24672	\N	\N	\N	
24673	\N	\N	\N	
24674	\N	\N	\N	
24675	\N	\N	\N	
24676	\N	\N	\N	
24677	\N	\N	\N	
24678	\N	\N	\N	
24679	\N	\N	\N	
24680	\N	\N	\N	
24681	\N	\N	\N	
24682	\N	\N	\N	
24683	\N	\N	\N	
24684	\N	\N	\N	
24685	\N	\N	\N	
24686	\N	\N	\N	
24687	\N	\N	\N	
24688	\N	\N	\N	
24689	\N	\N	\N	
24690	\N	\N	\N	
24691	\N	\N	\N	
24692	\N	\N	\N	
24693	\N	\N	\N	
24694	\N	\N	\N	
24695	\N	\N	\N	
24696	\N	\N	\N	
24697	\N	\N	\N	
24698	\N	\N	\N	
24699	\N	\N	\N	
24700	\N	\N	\N	
24701	\N	\N	\N	
24702	\N	\N	\N	
24703	\N	\N	\N	
24704	\N	\N	\N	
24705	\N	\N	\N	
24706	\N	\N	\N	
24707	\N	\N	\N	
24708	\N	\N	\N	
24709	\N	\N	\N	
24710	\N	\N	\N	
24711	\N	\N	\N	
24712	\N	\N	\N	
24713	\N	\N	\N	
24714	\N	\N	\N	
24715	\N	\N	\N	
24716	\N	\N	\N	
24717	\N	\N	\N	
24718	\N	\N	\N	
24719	\N	\N	\N	
24720	\N	\N	\N	
24721	\N	\N	\N	
24722	\N	\N	\N	
24723	\N	\N	\N	
24724	\N	\N	\N	
24725	\N	\N	\N	
24726	\N	\N	\N	
24727	\N	\N	\N	
24728	\N	\N	\N	
24729	\N	\N	\N	
24730	\N	\N	\N	
24731	\N	\N	\N	
24732	\N	\N	\N	
24733	\N	\N	\N	
24734	\N	\N	\N	
24735	\N	\N	\N	
24736	\N	\N	\N	
24737	\N	\N	\N	
24738	\N	\N	\N	
24739	\N	\N	\N	
24740	\N	\N	\N	
24741	\N	\N	\N	
24742	\N	\N	\N	
24743	\N	\N	\N	
24744	\N	\N	\N	
24745	\N	\N	\N	
24746	\N	\N	\N	
24747	\N	\N	\N	
24748	\N	\N	\N	
24749	\N	\N	\N	
24750	\N	\N	\N	
24751	\N	\N	\N	
24752	\N	\N	\N	
24753	\N	\N	\N	
24754	\N	\N	\N	
24755	\N	\N	\N	
24756	\N	\N	\N	
24757	\N	\N	\N	
24758	\N	\N	\N	
24759	\N	\N	\N	
24760	\N	\N	\N	
24761	\N	\N	\N	
24762	\N	\N	\N	
24763	\N	\N	\N	
24764	\N	\N	\N	
24765	\N	\N	\N	
24766	\N	\N	\N	
24767	\N	\N	\N	
24768	\N	\N	\N	
24769	\N	\N	\N	
24770	\N	\N	\N	
24771	\N	\N	\N	
24772	\N	\N	\N	
24773	\N	\N	\N	
24774	\N	\N	\N	
24775	\N	\N	\N	
24776	\N	\N	\N	
24777	\N	\N	\N	
24778	\N	\N	\N	
24779	\N	\N	\N	
24780	\N	\N	\N	
24781	\N	\N	\N	
24782	\N	\N	\N	
24783	\N	\N	\N	
24784	\N	\N	\N	
24785	\N	\N	\N	
24786	\N	\N	\N	
24787	\N	\N	\N	
24788	\N	\N	\N	
24789	\N	\N	\N	
24790	\N	\N	\N	
24791	\N	\N	\N	
24792	\N	\N	\N	
24793	\N	\N	\N	
24794	\N	\N	\N	
24795	\N	\N	\N	
24796	\N	\N	\N	
24797	\N	\N	\N	
24798	\N	\N	\N	
24799	\N	\N	\N	
24800	\N	\N	\N	
24801	\N	\N	\N	
24802	\N	\N	\N	
24803	\N	\N	\N	
24804	\N	\N	\N	
24805	\N	\N	\N	
24806	\N	\N	\N	
24807	\N	\N	\N	
24808	\N	\N	\N	
24809	\N	\N	\N	
24810	\N	\N	\N	
24811	\N	\N	\N	
24812	\N	\N	\N	
24813	\N	\N	\N	
24814	\N	\N	\N	
24815	\N	\N	\N	
24816	\N	\N	\N	
24817	\N	\N	\N	
24818	\N	\N	\N	
24819	\N	\N	\N	
24820	\N	\N	\N	
24821	\N	\N	\N	
24822	\N	\N	\N	
24823	\N	\N	\N	
24824	\N	\N	\N	
24825	\N	\N	\N	
24826	\N	\N	\N	
24827	\N	\N	\N	
24828	\N	\N	\N	
24829	\N	\N	\N	
24830	\N	\N	\N	
24831	\N	\N	\N	
24832	\N	\N	\N	
24833	\N	\N	\N	
24834	\N	\N	\N	
24835	\N	\N	\N	
24836	\N	\N	\N	
24837	\N	\N	\N	
24838	\N	\N	\N	
24839	\N	\N	\N	
24840	\N	\N	\N	
24841	\N	\N	\N	
24842	\N	\N	\N	
24843	\N	\N	\N	
24844	\N	\N	\N	
24845	\N	\N	\N	
24846	\N	\N	\N	
24847	\N	\N	\N	
24848	\N	\N	\N	
24849	\N	\N	\N	
24850	\N	\N	\N	
24851	\N	\N	\N	
24852	\N	\N	\N	
24853	\N	\N	\N	
24854	\N	\N	\N	
24855	\N	\N	\N	
24856	\N	\N	\N	
24857	\N	\N	\N	
24858	\N	\N	\N	
24859	\N	\N	\N	
24860	\N	\N	\N	
24861	\N	\N	\N	
24862	\N	\N	\N	
24863	\N	\N	\N	
24864	\N	\N	\N	
24865	\N	\N	\N	
24866	\N	\N	\N	
24867	\N	\N	\N	
24868	\N	\N	\N	
24869	\N	\N	\N	
24870	\N	\N	\N	
24871	\N	\N	\N	
24872	\N	\N	\N	
24873	\N	\N	\N	
24874	\N	\N	\N	
24875	\N	\N	\N	
24876	\N	\N	\N	
24877	\N	\N	\N	
24878	\N	\N	\N	
24879	\N	\N	\N	
24880	\N	\N	\N	
24881	\N	\N	\N	
24882	\N	\N	\N	
24883	\N	\N	\N	
24884	\N	\N	\N	
24885	\N	\N	\N	
24886	\N	\N	\N	
24887	\N	\N	\N	
24888	\N	\N	\N	
24889	\N	\N	\N	
24890	\N	\N	\N	
24891	\N	\N	\N	
24892	\N	\N	\N	
24893	\N	\N	\N	
24894	\N	\N	\N	
24895	\N	\N	\N	
24896	\N	\N	\N	
24897	\N	\N	\N	
24898	\N	\N	\N	
24899	\N	\N	\N	
24900	\N	\N	\N	
24901	\N	\N	\N	
24902	\N	\N	\N	
24903	\N	\N	\N	
24904	\N	\N	\N	
24905	\N	\N	\N	
24906	\N	\N	\N	
24907	\N	\N	\N	
24908	\N	\N	\N	
24909	\N	\N	\N	
24910	\N	\N	\N	
24911	\N	\N	\N	
24912	\N	\N	\N	
24913	\N	\N	\N	
24914	\N	\N	\N	
24915	\N	\N	\N	
24916	\N	\N	\N	
24917	\N	\N	\N	
24918	\N	\N	\N	
24919	\N	\N	\N	
24920	\N	\N	\N	
24921	\N	\N	\N	
24922	\N	\N	\N	
24923	\N	\N	\N	
24924	\N	\N	\N	
24925	\N	\N	\N	
24926	\N	\N	\N	
24927	\N	\N	\N	
24928	\N	\N	\N	
24929	\N	\N	\N	
24930	\N	\N	\N	
24931	\N	\N	\N	
24932	\N	\N	\N	
24933	\N	\N	\N	
24934	\N	\N	\N	
24935	\N	\N	\N	
24936	\N	\N	\N	
24937	\N	\N	\N	
24938	\N	\N	\N	
24939	\N	\N	\N	
24940	\N	\N	\N	
24941	\N	\N	\N	
24942	\N	\N	\N	
24943	\N	\N	\N	
24944	\N	\N	\N	
24945	\N	\N	\N	
24946	\N	\N	\N	
24947	\N	\N	\N	
24948	\N	\N	\N	
24949	\N	\N	\N	
24950	\N	\N	\N	
24951	\N	\N	\N	
24952	\N	\N	\N	
24953	\N	\N	\N	
24954	\N	\N	\N	
24955	\N	\N	\N	
24956	\N	\N	\N	
24957	\N	\N	\N	
24958	\N	\N	\N	
24959	\N	\N	\N	
24960	\N	\N	\N	
24961	\N	\N	\N	
24962	\N	\N	\N	
24963	\N	\N	\N	
24964	\N	\N	\N	
24965	\N	\N	\N	
24966	\N	\N	\N	
24967	\N	\N	\N	
24968	\N	\N	\N	
24969	\N	\N	\N	
24970	\N	\N	\N	
24971	\N	\N	\N	
24972	\N	\N	\N	
24973	\N	\N	\N	
24974	\N	\N	\N	
24975	\N	\N	\N	
24976	\N	\N	\N	
24977	\N	\N	\N	
24978	\N	\N	\N	
24979	\N	\N	\N	
24980	\N	\N	\N	
24981	\N	\N	\N	
24982	\N	\N	\N	
24983	\N	\N	\N	
24984	\N	\N	\N	
24985	\N	\N	\N	
24986	\N	\N	\N	
24987	\N	\N	\N	
24988	\N	\N	\N	
24989	\N	\N	\N	
24990	\N	\N	\N	
24991	\N	\N	\N	
24992	\N	\N	\N	
24993	\N	\N	\N	
24994	\N	\N	\N	
24995	\N	\N	\N	
24996	\N	\N	\N	
24997	\N	\N	\N	
24998	\N	\N	\N	
24999	\N	\N	\N	
25000	\N	\N	\N	
25001	\N	\N	\N	
25002	\N	\N	\N	
25003	\N	\N	\N	
25004	\N	\N	\N	
25005	\N	\N	\N	
25006	\N	\N	\N	
25007	\N	\N	\N	
25008	\N	\N	\N	
25009	\N	\N	\N	
25010	\N	\N	\N	
25011	\N	\N	\N	
25012	\N	\N	\N	
25013	\N	\N	\N	
25014	\N	\N	\N	
25015	\N	\N	\N	
25016	\N	\N	\N	
25017	\N	\N	\N	
25018	\N	\N	\N	
25019	\N	\N	\N	
25020	\N	\N	\N	
25021	\N	\N	\N	
25022	\N	\N	\N	
25023	\N	\N	\N	
25024	\N	\N	\N	
25025	\N	\N	\N	
25026	\N	\N	\N	
25027	\N	\N	\N	
25028	\N	\N	\N	
25029	\N	\N	\N	
25030	\N	\N	\N	
25031	\N	\N	\N	
25032	\N	\N	\N	
25033	\N	\N	\N	
25034	\N	\N	\N	
25035	\N	\N	\N	
25036	\N	\N	\N	
25037	\N	\N	\N	
25038	\N	\N	\N	
25039	\N	\N	\N	
25040	\N	\N	\N	
25041	\N	\N	\N	
25042	\N	\N	\N	
25043	\N	\N	\N	
25044	\N	\N	\N	
25045	\N	\N	\N	
25046	\N	\N	\N	
25047	\N	\N	\N	
25048	\N	\N	\N	
25049	\N	\N	\N	
25050	\N	\N	\N	
25051	\N	\N	\N	
25052	\N	\N	\N	
25053	\N	\N	\N	
25054	\N	\N	\N	
25055	\N	\N	\N	
25056	\N	\N	\N	
25057	\N	\N	\N	
25058	\N	\N	\N	
25059	\N	\N	\N	
25060	\N	\N	\N	
25061	\N	\N	\N	
25062	\N	\N	\N	
25063	\N	\N	\N	
25064	\N	\N	\N	
25065	\N	\N	\N	
25066	\N	\N	\N	
25067	\N	\N	\N	
25068	\N	\N	\N	
25069	\N	\N	\N	
25070	\N	\N	\N	
25071	\N	\N	\N	
25072	\N	\N	\N	
25073	\N	\N	\N	
25074	\N	\N	\N	
25075	\N	\N	\N	
25076	\N	\N	\N	
25077	\N	\N	\N	
25078	\N	\N	\N	
25079	\N	\N	\N	
25080	\N	\N	\N	
25081	\N	\N	\N	
25082	\N	\N	\N	
25083	\N	\N	\N	
25084	\N	\N	\N	
25085	\N	\N	\N	
25086	\N	\N	\N	
25087	\N	\N	\N	
25088	\N	\N	\N	
25089	\N	\N	\N	
25090	\N	\N	\N	
25091	\N	\N	\N	
25092	\N	\N	\N	
25093	\N	\N	\N	
25094	\N	\N	\N	
25095	\N	\N	\N	
25096	\N	\N	\N	
25097	\N	\N	\N	
25098	\N	\N	\N	
25099	\N	\N	\N	
25100	\N	\N	\N	
25101	\N	\N	\N	
25102	\N	\N	\N	
25103	\N	\N	\N	
25104	\N	\N	\N	
25105	\N	\N	\N	
25106	\N	\N	\N	
25107	\N	\N	\N	
25108	\N	\N	\N	
25109	\N	\N	\N	
25110	\N	\N	\N	
25111	\N	\N	\N	
25112	\N	\N	\N	
25113	\N	\N	\N	
25114	\N	\N	\N	
25115	\N	\N	\N	
25116	\N	\N	\N	
25117	\N	\N	\N	
25118	\N	\N	\N	
25119	\N	\N	\N	
25120	\N	\N	\N	
25121	\N	\N	\N	
25122	\N	\N	\N	
25123	\N	\N	\N	
25124	\N	\N	\N	
25125	\N	\N	\N	
25126	\N	\N	\N	
25127	\N	\N	\N	
25128	\N	\N	\N	
25129	\N	\N	\N	
25130	\N	\N	\N	
25131	\N	\N	\N	
25132	\N	\N	\N	
25133	\N	\N	\N	
25134	\N	\N	\N	
25135	\N	\N	\N	
25136	\N	\N	\N	
25137	\N	\N	\N	
25138	\N	\N	\N	
25139	\N	\N	\N	
25140	\N	\N	\N	
25141	\N	\N	\N	
25142	\N	\N	\N	
25143	\N	\N	\N	
25144	\N	\N	\N	
25145	\N	\N	\N	
25146	\N	\N	\N	
25147	\N	\N	\N	
25148	\N	\N	\N	
25149	\N	\N	\N	
25150	\N	\N	\N	
25151	\N	\N	\N	
25152	\N	\N	\N	
25153	\N	\N	\N	
25154	\N	\N	\N	
25155	\N	\N	\N	
25156	\N	\N	\N	
25157	\N	\N	\N	
25158	\N	\N	\N	
25159	\N	\N	\N	
25160	\N	\N	\N	
25161	\N	\N	\N	
25162	\N	\N	\N	
25163	\N	\N	\N	
25164	\N	\N	\N	
25165	\N	\N	\N	
25166	\N	\N	\N	
25167	\N	\N	\N	
25168	\N	\N	\N	
25169	\N	\N	\N	
25170	\N	\N	\N	
25171	\N	\N	\N	
25172	\N	\N	\N	
25173	\N	\N	\N	
25174	\N	\N	\N	
25175	\N	\N	\N	
25176	\N	\N	\N	
25177	\N	\N	\N	
25178	\N	\N	\N	
25179	\N	\N	\N	
25180	\N	\N	\N	
25181	\N	\N	\N	
25182	\N	\N	\N	
25183	\N	\N	\N	
25184	\N	\N	\N	
25185	\N	\N	\N	
25186	\N	\N	\N	
25187	\N	\N	\N	
25188	\N	\N	\N	
25189	\N	\N	\N	
25190	\N	\N	\N	
25191	\N	\N	\N	
25192	\N	\N	\N	
25193	\N	\N	\N	
25194	\N	\N	\N	
25195	\N	\N	\N	
25196	\N	\N	\N	
25197	\N	\N	\N	
25198	\N	\N	\N	
25199	\N	\N	\N	
25200	\N	\N	\N	
25201	\N	\N	\N	
25202	\N	\N	\N	
25203	\N	\N	\N	
25204	\N	\N	\N	
25205	\N	\N	\N	
25206	\N	\N	\N	
25207	\N	\N	\N	
25208	\N	\N	\N	
25209	\N	\N	\N	
25210	\N	\N	\N	
25211	\N	\N	\N	
25212	\N	\N	\N	
25213	\N	\N	\N	
25214	\N	\N	\N	
25215	\N	\N	\N	
25216	\N	\N	\N	
25217	\N	\N	\N	
25218	\N	\N	\N	
25219	\N	\N	\N	
25220	\N	\N	\N	
25221	\N	\N	\N	
25222	\N	\N	\N	
25223	\N	\N	\N	
25224	\N	\N	\N	
25225	\N	\N	\N	
25226	\N	\N	\N	
25227	\N	\N	\N	
25228	\N	\N	\N	
25229	\N	\N	\N	
25230	\N	\N	\N	
25231	\N	\N	\N	
25232	\N	\N	\N	
25233	\N	\N	\N	
25234	\N	\N	\N	
25235	\N	\N	\N	
25236	\N	\N	\N	
25237	\N	\N	\N	
25238	\N	\N	\N	
25239	\N	\N	\N	
25240	\N	\N	\N	
25241	\N	\N	\N	
25242	\N	\N	\N	
25243	\N	\N	\N	
25244	\N	\N	\N	
25245	\N	\N	\N	
25246	\N	\N	\N	
25247	\N	\N	\N	
25248	\N	\N	\N	
25249	\N	\N	\N	
25250	\N	\N	\N	
25251	\N	\N	\N	
25252	\N	\N	\N	
25253	\N	\N	\N	
25254	\N	\N	\N	
25255	\N	\N	\N	
25256	\N	\N	\N	
25257	\N	\N	\N	
25258	\N	\N	\N	
25259	\N	\N	\N	
25260	\N	\N	\N	
25261	\N	\N	\N	
25262	\N	\N	\N	
25263	\N	\N	\N	
25264	\N	\N	\N	
25265	\N	\N	\N	
25266	\N	\N	\N	
25267	\N	\N	\N	
25268	\N	\N	\N	
25269	\N	\N	\N	
25270	\N	\N	\N	
25271	\N	\N	\N	
25272	\N	\N	\N	
25273	\N	\N	\N	
25274	\N	\N	\N	
25275	\N	\N	\N	
25276	\N	\N	\N	
25277	\N	\N	\N	
25278	\N	\N	\N	
25279	\N	\N	\N	
25280	\N	\N	\N	
25281	\N	\N	\N	
25282	\N	\N	\N	
25283	\N	\N	\N	
25284	\N	\N	\N	
25285	\N	\N	\N	
25286	\N	\N	\N	
25287	\N	\N	\N	
25288	\N	\N	\N	
25289	\N	\N	\N	
25290	\N	\N	\N	
25291	\N	\N	\N	
25292	\N	\N	\N	
25293	\N	\N	\N	
25294	\N	\N	\N	
25295	\N	\N	\N	
25296	\N	\N	\N	
25297	\N	\N	\N	
25298	\N	\N	\N	
25299	\N	\N	\N	
25300	\N	\N	\N	
25301	\N	\N	\N	
25302	\N	\N	\N	
25303	\N	\N	\N	
25304	\N	\N	\N	
25305	\N	\N	\N	
25306	\N	\N	\N	
25307	\N	\N	\N	
25308	\N	\N	\N	
25309	\N	\N	\N	
25310	\N	\N	\N	
25311	\N	\N	\N	
25312	\N	\N	\N	
25313	\N	\N	\N	
25314	\N	\N	\N	
25315	\N	\N	\N	
25316	\N	\N	\N	
25317	\N	\N	\N	
25318	\N	\N	\N	
25319	\N	\N	\N	
25320	\N	\N	\N	
25321	\N	\N	\N	
25322	\N	\N	\N	
25323	\N	\N	\N	
25324	\N	\N	\N	
25325	\N	\N	\N	
25326	\N	\N	\N	
25327	\N	\N	\N	
25328	\N	\N	\N	
25329	\N	\N	\N	
25330	\N	\N	\N	
25331	\N	\N	\N	
25332	\N	\N	\N	
25333	\N	\N	\N	
25334	\N	\N	\N	
25335	\N	\N	\N	
25336	\N	\N	\N	
25337	\N	\N	\N	
25338	\N	\N	\N	
25339	\N	\N	\N	
25340	\N	\N	\N	
25341	\N	\N	\N	
25342	\N	\N	\N	
25343	\N	\N	\N	
25344	\N	\N	\N	
25345	\N	\N	\N	
25346	\N	\N	\N	
25347	\N	\N	\N	
25348	\N	\N	\N	
25349	\N	\N	\N	
25350	\N	\N	\N	
25351	\N	\N	\N	
25352	\N	\N	\N	
25353	\N	\N	\N	
25354	\N	\N	\N	
25355	\N	\N	\N	
25356	\N	\N	\N	
25357	\N	\N	\N	
25358	\N	\N	\N	
25359	\N	\N	\N	
25360	\N	\N	\N	
25361	\N	\N	\N	
25362	\N	\N	\N	
25363	\N	\N	\N	
25364	\N	\N	\N	
25365	\N	\N	\N	
25366	\N	\N	\N	
25367	\N	\N	\N	
25368	\N	\N	\N	
25369	\N	\N	\N	
25370	\N	\N	\N	
25371	\N	\N	\N	
25372	\N	\N	\N	
25373	\N	\N	\N	
25374	\N	\N	\N	
25375	\N	\N	\N	
25376	\N	\N	\N	
25377	\N	\N	\N	
25378	\N	\N	\N	
25379	\N	\N	\N	
25380	\N	\N	\N	
25381	\N	\N	\N	
25382	\N	\N	\N	
25383	\N	\N	\N	
25384	\N	\N	\N	
25385	\N	\N	\N	
25386	\N	\N	\N	
25387	\N	\N	\N	
25388	\N	\N	\N	
25389	\N	\N	\N	
25390	\N	\N	\N	
25391	\N	\N	\N	
25392	\N	\N	\N	
25393	\N	\N	\N	
25394	\N	\N	\N	
25395	\N	\N	\N	
25396	\N	\N	\N	
25397	\N	\N	\N	
25398	\N	\N	\N	
25399	\N	\N	\N	
25400	\N	\N	\N	
25401	\N	\N	\N	
25402	\N	\N	\N	
25403	\N	\N	\N	
25404	\N	\N	\N	
25405	\N	\N	\N	
25406	\N	\N	\N	
25407	\N	\N	\N	
25408	\N	\N	\N	
25409	\N	\N	\N	
25410	\N	\N	\N	
25411	\N	\N	\N	
25412	\N	\N	\N	
25413	\N	\N	\N	
25414	\N	\N	\N	
25415	\N	\N	\N	
25416	\N	\N	\N	
25417	\N	\N	\N	
25418	\N	\N	\N	
25419	\N	\N	\N	
25420	\N	\N	\N	
25421	\N	\N	\N	
25422	\N	\N	\N	
25423	\N	\N	\N	
25424	\N	\N	\N	
25425	\N	\N	\N	
25426	\N	\N	\N	
25427	\N	\N	\N	
25428	\N	\N	\N	
25429	\N	\N	\N	
25430	\N	\N	\N	
25431	\N	\N	\N	
25432	\N	\N	\N	
25433	\N	\N	\N	
25434	\N	\N	\N	
25435	\N	\N	\N	
25436	\N	\N	\N	
25437	\N	\N	\N	
25438	\N	\N	\N	
25439	\N	\N	\N	
25440	\N	\N	\N	
25441	\N	\N	\N	
25442	\N	\N	\N	
25443	\N	\N	\N	
25444	\N	\N	\N	
25445	\N	\N	\N	
25446	\N	\N	\N	
25447	\N	\N	\N	
25448	\N	\N	\N	
25449	\N	\N	\N	
25450	\N	\N	\N	
25451	\N	\N	\N	
25452	\N	\N	\N	
25453	\N	\N	\N	
25454	\N	\N	\N	
25455	\N	\N	\N	
25456	\N	\N	\N	
25457	\N	\N	\N	
25458	\N	\N	\N	
25459	\N	\N	\N	
25460	\N	\N	\N	
25461	\N	\N	\N	
25462	\N	\N	\N	
25463	\N	\N	\N	
25464	\N	\N	\N	
25465	\N	\N	\N	
25466	\N	\N	\N	
25467	\N	\N	\N	
25468	\N	\N	\N	
25469	\N	\N	\N	
25470	\N	\N	\N	
25471	\N	\N	\N	
25472	\N	\N	\N	
25473	\N	\N	\N	
25474	\N	\N	\N	
25475	\N	\N	\N	
25476	\N	\N	\N	
25477	\N	\N	\N	
25478	\N	\N	\N	
25479	\N	\N	\N	
25480	\N	\N	\N	
25481	\N	\N	\N	
25482	\N	\N	\N	
25483	\N	\N	\N	
25484	\N	\N	\N	
25485	\N	\N	\N	
25486	\N	\N	\N	
25487	\N	\N	\N	
25488	\N	\N	\N	
25489	\N	\N	\N	
25490	\N	\N	\N	
25491	\N	\N	\N	
25492	\N	\N	\N	
25493	\N	\N	\N	
25494	\N	\N	\N	
25495	\N	\N	\N	
25496	\N	\N	\N	
25497	\N	\N	\N	
25498	\N	\N	\N	
25499	\N	\N	\N	
25500	\N	\N	\N	
25501	\N	\N	\N	
25502	\N	\N	\N	
25503	\N	\N	\N	
25504	\N	\N	\N	
25505	\N	\N	\N	
25506	\N	\N	\N	
25507	\N	\N	\N	
25508	\N	\N	\N	
25509	\N	\N	\N	
25510	\N	\N	\N	
25511	\N	\N	\N	
25512	\N	\N	\N	
25513	\N	\N	\N	
25514	\N	\N	\N	
25515	\N	\N	\N	
25516	\N	\N	\N	
25517	\N	\N	\N	
25518	\N	\N	\N	
25519	\N	\N	\N	
25520	\N	\N	\N	
25521	\N	\N	\N	
25522	\N	\N	\N	
25523	\N	\N	\N	
25524	\N	\N	\N	
25525	\N	\N	\N	
25526	\N	\N	\N	
25527	\N	\N	\N	
25528	\N	\N	\N	
25529	\N	\N	\N	
25530	\N	\N	\N	
25531	\N	\N	\N	
25532	\N	\N	\N	
25533	\N	\N	\N	
25534	\N	\N	\N	
25535	\N	\N	\N	
25536	\N	\N	\N	
25537	\N	\N	\N	
25538	\N	\N	\N	
25539	\N	\N	\N	
25540	\N	\N	\N	
25541	\N	\N	\N	
25542	\N	\N	\N	
25543	\N	\N	\N	
25544	\N	\N	\N	
25545	\N	\N	\N	
25546	\N	\N	\N	
25547	\N	\N	\N	
25548	\N	\N	\N	
25549	\N	\N	\N	
25550	\N	\N	\N	
25551	\N	\N	\N	
25552	\N	\N	\N	
25553	\N	\N	\N	
25554	\N	\N	\N	
25555	\N	\N	\N	
25556	\N	\N	\N	
25557	\N	\N	\N	
25558	\N	\N	\N	
25559	\N	\N	\N	
25560	\N	\N	\N	
25561	\N	\N	\N	
25562	\N	\N	\N	
25563	\N	\N	\N	
25564	\N	\N	\N	
25565	\N	\N	\N	
25566	\N	\N	\N	
25567	\N	\N	\N	
25568	\N	\N	\N	
25569	\N	\N	\N	
25570	\N	\N	\N	
25571	\N	\N	\N	
25572	\N	\N	\N	
25573	\N	\N	\N	
25574	\N	\N	\N	
25575	\N	\N	\N	
25576	\N	\N	\N	
25577	\N	\N	\N	
25578	\N	\N	\N	
25579	\N	\N	\N	
25580	\N	\N	\N	
25581	\N	\N	\N	
25582	\N	\N	\N	
25583	\N	\N	\N	
25584	\N	\N	\N	
25585	\N	\N	\N	
25586	\N	\N	\N	
25587	\N	\N	\N	
25588	\N	\N	\N	
25589	\N	\N	\N	
25590	\N	\N	\N	
25591	\N	\N	\N	
25592	\N	\N	\N	
25593	\N	\N	\N	
25594	\N	\N	\N	
25595	\N	\N	\N	
25596	\N	\N	\N	
25597	\N	\N	\N	
25598	\N	\N	\N	
25599	\N	\N	\N	
25600	\N	\N	\N	
25601	\N	\N	\N	
25602	\N	\N	\N	
25603	\N	\N	\N	
25604	\N	\N	\N	
25605	\N	\N	\N	
25606	\N	\N	\N	
25607	\N	\N	\N	
25608	\N	\N	\N	
25609	\N	\N	\N	
25610	\N	\N	\N	
25611	\N	\N	\N	
25612	\N	\N	\N	
25613	\N	\N	\N	
25614	\N	\N	\N	
25615	\N	\N	\N	
25616	\N	\N	\N	
25617	\N	\N	\N	
25618	\N	\N	\N	
25619	\N	\N	\N	
25620	\N	\N	\N	
25621	\N	\N	\N	
25622	\N	\N	\N	
25623	\N	\N	\N	
25624	\N	\N	\N	
25625	\N	\N	\N	
25626	\N	\N	\N	
25627	\N	\N	\N	
25628	\N	\N	\N	
25629	\N	\N	\N	
25630	\N	\N	\N	
25631	\N	\N	\N	
25632	\N	\N	\N	
25633	\N	\N	\N	
25634	\N	\N	\N	
25635	\N	\N	\N	
25636	\N	\N	\N	
25637	\N	\N	\N	
25638	\N	\N	\N	
25639	\N	\N	\N	
25640	\N	\N	\N	
25641	\N	\N	\N	
25642	\N	\N	\N	
25643	\N	\N	\N	
25644	\N	\N	\N	
25645	\N	\N	\N	
25646	\N	\N	\N	
25647	\N	\N	\N	
25648	\N	\N	\N	
25649	\N	\N	\N	
25650	\N	\N	\N	
25651	\N	\N	\N	
25652	\N	\N	\N	
25653	\N	\N	\N	
25654	\N	\N	\N	
25655	\N	\N	\N	
25656	\N	\N	\N	
25657	\N	\N	\N	
25658	\N	\N	\N	
25659	\N	\N	\N	
25660	\N	\N	\N	
25661	\N	\N	\N	
25662	\N	\N	\N	
25663	\N	\N	\N	
25664	\N	\N	\N	
25665	\N	\N	\N	
25666	\N	\N	\N	
25667	\N	\N	\N	
25668	\N	\N	\N	
25669	\N	\N	\N	
25670	\N	\N	\N	
25671	\N	\N	\N	
25672	\N	\N	\N	
25673	\N	\N	\N	
25674	\N	\N	\N	
25675	\N	\N	\N	
25676	\N	\N	\N	
25677	\N	\N	\N	
25678	\N	\N	\N	
25679	\N	\N	\N	
25680	\N	\N	\N	
25681	\N	\N	\N	
25682	\N	\N	\N	
25683	\N	\N	\N	
25684	\N	\N	\N	
25685	\N	\N	\N	
25686	\N	\N	\N	
25687	\N	\N	\N	
25688	\N	\N	\N	
25689	\N	\N	\N	
25690	\N	\N	\N	
25691	\N	\N	\N	
25692	\N	\N	\N	
25693	\N	\N	\N	
25694	\N	\N	\N	
25695	\N	\N	\N	
25696	\N	\N	\N	
25697	\N	\N	\N	
25698	\N	\N	\N	
25699	\N	\N	\N	
25700	\N	\N	\N	
25701	\N	\N	\N	
25702	\N	\N	\N	
25703	\N	\N	\N	
25704	\N	\N	\N	
25705	\N	\N	\N	
25706	\N	\N	\N	
25707	\N	\N	\N	
25708	\N	\N	\N	
25709	\N	\N	\N	
25710	\N	\N	\N	
25711	\N	\N	\N	
25712	\N	\N	\N	
25713	\N	\N	\N	
25714	\N	\N	\N	
25715	\N	\N	\N	
25716	\N	\N	\N	
25717	\N	\N	\N	
25718	\N	\N	\N	
25719	\N	\N	\N	
25720	\N	\N	\N	
25721	\N	\N	\N	
25722	\N	\N	\N	
25723	\N	\N	\N	
25724	\N	\N	\N	
25725	\N	\N	\N	
25726	\N	\N	\N	
25727	\N	\N	\N	
25728	\N	\N	\N	
25729	\N	\N	\N	
25730	\N	\N	\N	
25731	\N	\N	\N	
25732	\N	\N	\N	
25733	\N	\N	\N	
25734	\N	\N	\N	
25735	\N	\N	\N	
25736	\N	\N	\N	
25737	\N	\N	\N	
25738	\N	\N	\N	
25739	\N	\N	\N	
25740	\N	\N	\N	
25741	\N	\N	\N	
25742	\N	\N	\N	
25743	\N	\N	\N	
25744	\N	\N	\N	
25745	\N	\N	\N	
25746	\N	\N	\N	
25747	\N	\N	\N	
25748	\N	\N	\N	
25749	\N	\N	\N	
25750	\N	\N	\N	
25751	\N	\N	\N	
25752	\N	\N	\N	
25753	\N	\N	\N	
25754	\N	\N	\N	
25755	\N	\N	\N	
25756	\N	\N	\N	
25757	\N	\N	\N	
25758	\N	\N	\N	
25759	\N	\N	\N	
25760	\N	\N	\N	
25761	\N	\N	\N	
25762	\N	\N	\N	
25763	\N	\N	\N	
25764	\N	\N	\N	
25765	\N	\N	\N	
25766	\N	\N	\N	
25767	\N	\N	\N	
25768	\N	\N	\N	
25769	\N	\N	\N	
25770	\N	\N	\N	
25771	\N	\N	\N	
25772	\N	\N	\N	
25773	\N	\N	\N	
25774	\N	\N	\N	
25775	\N	\N	\N	
25776	\N	\N	\N	
25777	\N	\N	\N	
25778	\N	\N	\N	
25779	\N	\N	\N	
25780	\N	\N	\N	
25781	\N	\N	\N	
25782	\N	\N	\N	
25783	\N	\N	\N	
25784	\N	\N	\N	
25785	\N	\N	\N	
25786	\N	\N	\N	
25787	\N	\N	\N	
25788	\N	\N	\N	
25789	\N	\N	\N	
25790	\N	\N	\N	
25791	\N	\N	\N	
25792	\N	\N	\N	
25793	\N	\N	\N	
25794	\N	\N	\N	
25795	\N	\N	\N	
25796	\N	\N	\N	
25797	\N	\N	\N	
25798	\N	\N	\N	
25799	\N	\N	\N	
25800	\N	\N	\N	
25801	\N	\N	\N	
25802	\N	\N	\N	
25803	\N	\N	\N	
25804	\N	\N	\N	
25805	\N	\N	\N	
25806	\N	\N	\N	
25807	\N	\N	\N	
25808	\N	\N	\N	
25809	\N	\N	\N	
25810	\N	\N	\N	
25811	\N	\N	\N	
25812	\N	\N	\N	
25813	\N	\N	\N	
25814	\N	\N	\N	
25815	\N	\N	\N	
25816	\N	\N	\N	
25817	\N	\N	\N	
25818	\N	\N	\N	
25819	\N	\N	\N	
25820	\N	\N	\N	
25821	\N	\N	\N	
25822	\N	\N	\N	
25823	\N	\N	\N	
25824	\N	\N	\N	
25825	\N	\N	\N	
25826	\N	\N	\N	
25827	\N	\N	\N	
25828	\N	\N	\N	
25829	\N	\N	\N	
25830	\N	\N	\N	
25831	\N	\N	\N	
25832	\N	\N	\N	
25833	\N	\N	\N	
25834	\N	\N	\N	
25835	\N	\N	\N	
25836	\N	\N	\N	
25837	\N	\N	\N	
25838	\N	\N	\N	
25839	\N	\N	\N	
25840	\N	\N	\N	
25841	\N	\N	\N	
25842	\N	\N	\N	
25843	\N	\N	\N	
25844	\N	\N	\N	
25845	\N	\N	\N	
25846	\N	\N	\N	
25847	\N	\N	\N	
25848	\N	\N	\N	
25849	\N	\N	\N	
25850	\N	\N	\N	
25851	\N	\N	\N	
25852	\N	\N	\N	
25853	\N	\N	\N	
25854	\N	\N	\N	
25855	\N	\N	\N	
25856	\N	\N	\N	
25857	\N	\N	\N	
25858	\N	\N	\N	
25859	\N	\N	\N	
25860	\N	\N	\N	
25861	\N	\N	\N	
25862	\N	\N	\N	
25863	\N	\N	\N	
25864	\N	\N	\N	
25865	\N	\N	\N	
25866	\N	\N	\N	
25867	\N	\N	\N	
25868	\N	\N	\N	
25869	\N	\N	\N	
25870	\N	\N	\N	
25871	\N	\N	\N	
25872	\N	\N	\N	
25873	\N	\N	\N	
25874	\N	\N	\N	
25875	\N	\N	\N	
25876	\N	\N	\N	
25877	\N	\N	\N	
25878	\N	\N	\N	
25879	\N	\N	\N	
25880	\N	\N	\N	
25881	\N	\N	\N	
25882	\N	\N	\N	
25883	\N	\N	\N	
25884	\N	\N	\N	
25885	\N	\N	\N	
25886	\N	\N	\N	
25887	\N	\N	\N	
25888	\N	\N	\N	
25889	\N	\N	\N	
25890	\N	\N	\N	
25891	\N	\N	\N	
25892	\N	\N	\N	
25893	\N	\N	\N	
25894	\N	\N	\N	
25895	\N	\N	\N	
25896	\N	\N	\N	
25897	\N	\N	\N	
25898	\N	\N	\N	
25899	\N	\N	\N	
25900	\N	\N	\N	
25901	\N	\N	\N	
25902	\N	\N	\N	
25903	\N	\N	\N	
25904	\N	\N	\N	
25905	\N	\N	\N	
25906	\N	\N	\N	
25907	\N	\N	\N	
25908	\N	\N	\N	
25909	\N	\N	\N	
25910	\N	\N	\N	
25911	\N	\N	\N	
25912	\N	\N	\N	
25913	\N	\N	\N	
25914	\N	\N	\N	
25915	\N	\N	\N	
25916	\N	\N	\N	
25917	\N	\N	\N	
25918	\N	\N	\N	
25919	\N	\N	\N	
25920	\N	\N	\N	
25921	\N	\N	\N	
25922	\N	\N	\N	
25923	\N	\N	\N	
25924	\N	\N	\N	
25925	\N	\N	\N	
25926	\N	\N	\N	
25927	\N	\N	\N	
25928	\N	\N	\N	
25929	\N	\N	\N	
25930	\N	\N	\N	
25931	\N	\N	\N	
25932	\N	\N	\N	
25933	\N	\N	\N	
25934	\N	\N	\N	
25935	\N	\N	\N	
25936	\N	\N	\N	
25937	\N	\N	\N	
25938	\N	\N	\N	
25939	\N	\N	\N	
25940	\N	\N	\N	
25941	\N	\N	\N	
25942	\N	\N	\N	
25943	\N	\N	\N	
25944	\N	\N	\N	
25945	\N	\N	\N	
25946	\N	\N	\N	
25947	\N	\N	\N	
25948	\N	\N	\N	
25949	\N	\N	\N	
25950	\N	\N	\N	
25951	\N	\N	\N	
25952	\N	\N	\N	
25953	\N	\N	\N	
25954	\N	\N	\N	
25955	\N	\N	\N	
25956	\N	\N	\N	
25957	\N	\N	\N	
25958	\N	\N	\N	
25959	\N	\N	\N	
25960	\N	\N	\N	
25961	\N	\N	\N	
25962	\N	\N	\N	
25963	\N	\N	\N	
25964	\N	\N	\N	
25965	\N	\N	\N	
25966	\N	\N	\N	
25967	\N	\N	\N	
25968	\N	\N	\N	
25969	\N	\N	\N	
25970	\N	\N	\N	
25971	\N	\N	\N	
25972	\N	\N	\N	
25973	\N	\N	\N	
25974	\N	\N	\N	
25975	\N	\N	\N	
25976	\N	\N	\N	
25977	\N	\N	\N	
25978	\N	\N	\N	
25979	\N	\N	\N	
25980	\N	\N	\N	
25981	\N	\N	\N	
25982	\N	\N	\N	
25983	\N	\N	\N	
25984	\N	\N	\N	
25985	\N	\N	\N	
25986	\N	\N	\N	
25987	\N	\N	\N	
25988	\N	\N	\N	
25989	\N	\N	\N	
25990	\N	\N	\N	
25991	\N	\N	\N	
25992	\N	\N	\N	
25993	\N	\N	\N	
25994	\N	\N	\N	
25995	\N	\N	\N	
25996	\N	\N	\N	
25997	\N	\N	\N	
25998	\N	\N	\N	
25999	\N	\N	\N	
26000	\N	\N	\N	
26001	\N	\N	\N	
26002	\N	\N	\N	
26003	\N	\N	\N	
26004	\N	\N	\N	
26005	\N	\N	\N	
26006	\N	\N	\N	
26007	\N	\N	\N	
26008	\N	\N	\N	
26009	\N	\N	\N	
26010	\N	\N	\N	
26011	\N	\N	\N	
26012	\N	\N	\N	
26013	\N	\N	\N	
26014	\N	\N	\N	
26015	\N	\N	\N	
26016	\N	\N	\N	
26017	\N	\N	\N	
26018	\N	\N	\N	
26019	\N	\N	\N	
26020	\N	\N	\N	
26021	\N	\N	\N	
26022	\N	\N	\N	
26023	\N	\N	\N	
26024	\N	\N	\N	
26025	\N	\N	\N	
26026	\N	\N	\N	
26027	\N	\N	\N	
26028	\N	\N	\N	
26029	\N	\N	\N	
26030	\N	\N	\N	
26031	\N	\N	\N	
26032	\N	\N	\N	
26033	\N	\N	\N	
26034	\N	\N	\N	
26035	\N	\N	\N	
26036	\N	\N	\N	
26037	\N	\N	\N	
26038	\N	\N	\N	
26039	\N	\N	\N	
26040	\N	\N	\N	
26041	\N	\N	\N	
26042	\N	\N	\N	
26043	\N	\N	\N	
26044	\N	\N	\N	
26045	\N	\N	\N	
26046	\N	\N	\N	
26047	\N	\N	\N	
26048	\N	\N	\N	
26049	\N	\N	\N	
26050	\N	\N	\N	
26051	\N	\N	\N	
26052	\N	\N	\N	
26053	\N	\N	\N	
26054	\N	\N	\N	
26055	\N	\N	\N	
26056	\N	\N	\N	
26057	\N	\N	\N	
26058	\N	\N	\N	
26059	\N	\N	\N	
26060	\N	\N	\N	
26061	\N	\N	\N	
26062	\N	\N	\N	
26063	\N	\N	\N	
26064	\N	\N	\N	
26065	\N	\N	\N	
26066	\N	\N	\N	
26067	\N	\N	\N	
26068	\N	\N	\N	
26069	\N	\N	\N	
26070	\N	\N	\N	
26071	\N	\N	\N	
26072	\N	\N	\N	
26073	\N	\N	\N	
26074	\N	\N	\N	
26075	\N	\N	\N	
26076	\N	\N	\N	
26077	\N	\N	\N	
26078	\N	\N	\N	
26079	\N	\N	\N	
26080	\N	\N	\N	
26081	\N	\N	\N	
26082	\N	\N	\N	
26083	\N	\N	\N	
26084	\N	\N	\N	
26085	\N	\N	\N	
26086	\N	\N	\N	
26087	\N	\N	\N	
26088	\N	\N	\N	
26089	\N	\N	\N	
26090	\N	\N	\N	
26091	\N	\N	\N	
26092	\N	\N	\N	
26093	\N	\N	\N	
26094	\N	\N	\N	
26095	\N	\N	\N	
26096	\N	\N	\N	
26097	\N	\N	\N	
26098	\N	\N	\N	
26099	\N	\N	\N	
26100	\N	\N	\N	
26101	\N	\N	\N	
26102	\N	\N	\N	
26103	\N	\N	\N	
26104	\N	\N	\N	
26105	\N	\N	\N	
26106	\N	\N	\N	
26107	\N	\N	\N	
26108	\N	\N	\N	
26109	\N	\N	\N	
26110	\N	\N	\N	
26111	\N	\N	\N	
26112	\N	\N	\N	
26113	\N	\N	\N	
26114	\N	\N	\N	
26115	\N	\N	\N	
26116	\N	\N	\N	
26117	\N	\N	\N	
26118	\N	\N	\N	
26119	\N	\N	\N	
26120	\N	\N	\N	
26121	\N	\N	\N	
26122	\N	\N	\N	
26123	\N	\N	\N	
26124	\N	\N	\N	
26125	\N	\N	\N	
26126	\N	\N	\N	
26127	\N	\N	\N	
26128	\N	\N	\N	
26129	\N	\N	\N	
26130	\N	\N	\N	
26131	\N	\N	\N	
26132	\N	\N	\N	
26133	\N	\N	\N	
26134	\N	\N	\N	
26135	\N	\N	\N	
26136	\N	\N	\N	
26137	\N	\N	\N	
26138	\N	\N	\N	
26139	\N	\N	\N	
26140	\N	\N	\N	
26141	\N	\N	\N	
26142	\N	\N	\N	
26143	\N	\N	\N	
26144	\N	\N	\N	
26145	\N	\N	\N	
26146	\N	\N	\N	
26147	\N	\N	\N	
26148	\N	\N	\N	
26149	\N	\N	\N	
26150	\N	\N	\N	
26151	\N	\N	\N	
26152	\N	\N	\N	
26153	\N	\N	\N	
26154	\N	\N	\N	
26155	\N	\N	\N	
26156	\N	\N	\N	
26157	\N	\N	\N	
26158	\N	\N	\N	
26159	\N	\N	\N	
26160	\N	\N	\N	
26161	\N	\N	\N	
26162	\N	\N	\N	
26163	\N	\N	\N	
26164	\N	\N	\N	
26165	\N	\N	\N	
26166	\N	\N	\N	
26167	\N	\N	\N	
26168	\N	\N	\N	
26169	\N	\N	\N	
26170	\N	\N	\N	
26171	\N	\N	\N	
26172	\N	\N	\N	
26173	\N	\N	\N	
26174	\N	\N	\N	
26175	\N	\N	\N	
26176	\N	\N	\N	
26177	\N	\N	\N	
26178	\N	\N	\N	
26179	\N	\N	\N	
26180	\N	\N	\N	
26181	\N	\N	\N	
26182	\N	\N	\N	
26183	\N	\N	\N	
26184	\N	\N	\N	
26185	\N	\N	\N	
26186	\N	\N	\N	
26187	\N	\N	\N	
26188	\N	\N	\N	
26189	\N	\N	\N	
26190	\N	\N	\N	
26191	\N	\N	\N	
26192	\N	\N	\N	
26193	\N	\N	\N	
26194	\N	\N	\N	
26195	\N	\N	\N	
26196	\N	\N	\N	
26197	\N	\N	\N	
26198	\N	\N	\N	
26199	\N	\N	\N	
26200	\N	\N	\N	
26201	\N	\N	\N	
26202	\N	\N	\N	
26203	\N	\N	\N	
26204	\N	\N	\N	
26205	\N	\N	\N	
26206	\N	\N	\N	
26207	\N	\N	\N	
26208	\N	\N	\N	
26209	\N	\N	\N	
26210	\N	\N	\N	
26211	\N	\N	\N	
26212	\N	\N	\N	
26213	\N	\N	\N	
26214	\N	\N	\N	
26215	\N	\N	\N	
26216	\N	\N	\N	
26217	\N	\N	\N	
26218	\N	\N	\N	
26219	\N	\N	\N	
26220	\N	\N	\N	
26221	\N	\N	\N	
26222	\N	\N	\N	
26223	\N	\N	\N	
26224	\N	\N	\N	
26225	\N	\N	\N	
26226	\N	\N	\N	
26227	\N	\N	\N	
26228	\N	\N	\N	
26229	\N	\N	\N	
26230	\N	\N	\N	
26231	\N	\N	\N	
26232	\N	\N	\N	
26233	\N	\N	\N	
26234	\N	\N	\N	
26235	\N	\N	\N	
26236	\N	\N	\N	
26237	\N	\N	\N	
26238	\N	\N	\N	
26239	\N	\N	\N	
26240	\N	\N	\N	
26241	\N	\N	\N	
26242	\N	\N	\N	
26243	\N	\N	\N	
26244	\N	\N	\N	
26245	\N	\N	\N	
26246	\N	\N	\N	
26247	\N	\N	\N	
26248	\N	\N	\N	
26249	\N	\N	\N	
26250	\N	\N	\N	
26251	\N	\N	\N	
26252	\N	\N	\N	
26253	\N	\N	\N	
26254	\N	\N	\N	
26255	\N	\N	\N	
26256	\N	\N	\N	
26257	\N	\N	\N	
26258	\N	\N	\N	
26259	\N	\N	\N	
26260	\N	\N	\N	
26261	\N	\N	\N	
26262	\N	\N	\N	
26263	\N	\N	\N	
26264	\N	\N	\N	
26265	\N	\N	\N	
26266	\N	\N	\N	
26267	\N	\N	\N	
26268	\N	\N	\N	
26269	\N	\N	\N	
26270	\N	\N	\N	
26271	\N	\N	\N	
26272	\N	\N	\N	
26273	\N	\N	\N	
26274	\N	\N	\N	
26275	\N	\N	\N	
26276	\N	\N	\N	
26277	\N	\N	\N	
26278	\N	\N	\N	
26279	\N	\N	\N	
26280	\N	\N	\N	
26281	\N	\N	\N	
26282	\N	\N	\N	
26283	\N	\N	\N	
26284	\N	\N	\N	
26285	\N	\N	\N	
26286	\N	\N	\N	
26287	\N	\N	\N	
26288	\N	\N	\N	
26289	\N	\N	\N	
26290	\N	\N	\N	
26291	\N	\N	\N	
26292	\N	\N	\N	
26293	\N	\N	\N	
26294	\N	\N	\N	
26295	\N	\N	\N	
26296	\N	\N	\N	
26297	\N	\N	\N	
26298	\N	\N	\N	
26299	\N	\N	\N	
26300	\N	\N	\N	
26301	\N	\N	\N	
26302	\N	\N	\N	
26303	\N	\N	\N	
26304	\N	\N	\N	
26305	\N	\N	\N	
26306	\N	\N	\N	
26307	\N	\N	\N	
26308	\N	\N	\N	
26309	\N	\N	\N	
26310	\N	\N	\N	
26311	\N	\N	\N	
26312	\N	\N	\N	
26313	\N	\N	\N	
26314	\N	\N	\N	
26315	\N	\N	\N	
26316	\N	\N	\N	
26317	\N	\N	\N	
26318	\N	\N	\N	
26319	\N	\N	\N	
26320	\N	\N	\N	
26321	\N	\N	\N	
26322	\N	\N	\N	
26323	\N	\N	\N	
26324	\N	\N	\N	
26325	\N	\N	\N	
26326	\N	\N	\N	
26327	\N	\N	\N	
26328	\N	\N	\N	
26329	\N	\N	\N	
26330	\N	\N	\N	
26331	\N	\N	\N	
26332	\N	\N	\N	
26333	\N	\N	\N	
26334	\N	\N	\N	
26335	\N	\N	\N	
26336	\N	\N	\N	
26337	\N	\N	\N	
26338	\N	\N	\N	
26339	\N	\N	\N	
26340	\N	\N	\N	
26341	\N	\N	\N	
26342	\N	\N	\N	
26343	\N	\N	\N	
26344	\N	\N	\N	
26345	\N	\N	\N	
26346	\N	\N	\N	
26347	\N	\N	\N	
26348	\N	\N	\N	
26349	\N	\N	\N	
26350	\N	\N	\N	
26351	\N	\N	\N	
26352	\N	\N	\N	
26353	\N	\N	\N	
26354	\N	\N	\N	
26355	\N	\N	\N	
26356	\N	\N	\N	
26357	\N	\N	\N	
26358	\N	\N	\N	
26359	\N	\N	\N	
26360	\N	\N	\N	
26361	\N	\N	\N	
26362	\N	\N	\N	
26363	\N	\N	\N	
26364	\N	\N	\N	
26365	\N	\N	\N	
26366	\N	\N	\N	
26367	\N	\N	\N	
26368	\N	\N	\N	
26369	\N	\N	\N	
26370	\N	\N	\N	
26371	\N	\N	\N	
26372	\N	\N	\N	
26373	\N	\N	\N	
26374	\N	\N	\N	
26375	\N	\N	\N	
26376	\N	\N	\N	
26377	\N	\N	\N	
26378	\N	\N	\N	
26379	\N	\N	\N	
26380	\N	\N	\N	
26381	\N	\N	\N	
26382	\N	\N	\N	
26383	\N	\N	\N	
26384	\N	\N	\N	
26385	\N	\N	\N	
26386	\N	\N	\N	
26387	\N	\N	\N	
26388	\N	\N	\N	
26389	\N	\N	\N	
26390	\N	\N	\N	
26391	\N	\N	\N	
26392	\N	\N	\N	
26393	\N	\N	\N	
26394	\N	\N	\N	
26395	\N	\N	\N	
26396	\N	\N	\N	
26397	\N	\N	\N	
26398	\N	\N	\N	
26399	\N	\N	\N	
26400	\N	\N	\N	
26401	\N	\N	\N	
26402	\N	\N	\N	
26403	\N	\N	\N	
26404	\N	\N	\N	
26405	\N	\N	\N	
26406	\N	\N	\N	
26407	\N	\N	\N	
26408	\N	\N	\N	
26409	\N	\N	\N	
26410	\N	\N	\N	
26411	\N	\N	\N	
26412	\N	\N	\N	
26413	\N	\N	\N	
26414	\N	\N	\N	
26415	\N	\N	\N	
26416	\N	\N	\N	
26417	\N	\N	\N	
26418	\N	\N	\N	
26419	\N	\N	\N	
26420	\N	\N	\N	
26421	\N	\N	\N	
26422	\N	\N	\N	
26423	\N	\N	\N	
26424	\N	\N	\N	
26425	\N	\N	\N	
26426	\N	\N	\N	
26427	\N	\N	\N	
26428	\N	\N	\N	
26429	\N	\N	\N	
26430	\N	\N	\N	
26431	\N	\N	\N	
26432	\N	\N	\N	
26433	\N	\N	\N	
26434	\N	\N	\N	
26435	\N	\N	\N	
26436	\N	\N	\N	
26437	\N	\N	\N	
26438	\N	\N	\N	
26439	\N	\N	\N	
26440	\N	\N	\N	
26441	\N	\N	\N	
26442	\N	\N	\N	
26443	\N	\N	\N	
26444	\N	\N	\N	
26445	\N	\N	\N	
26446	\N	\N	\N	
26447	\N	\N	\N	
26448	\N	\N	\N	
26449	\N	\N	\N	
26450	\N	\N	\N	
26451	\N	\N	\N	
26452	\N	\N	\N	
26453	\N	\N	\N	
26454	\N	\N	\N	
26455	\N	\N	\N	
26456	\N	\N	\N	
26457	\N	\N	\N	
26458	\N	\N	\N	
26459	\N	\N	\N	
26460	\N	\N	\N	
26461	\N	\N	\N	
26462	\N	\N	\N	
26463	\N	\N	\N	
26464	\N	\N	\N	
26465	\N	\N	\N	
26466	\N	\N	\N	
26467	\N	\N	\N	
26468	\N	\N	\N	
26469	\N	\N	\N	
26470	\N	\N	\N	
26471	\N	\N	\N	
26472	\N	\N	\N	
26473	\N	\N	\N	
26474	\N	\N	\N	
26475	\N	\N	\N	
26476	\N	\N	\N	
26477	\N	\N	\N	
26478	\N	\N	\N	
26479	\N	\N	\N	
26480	\N	\N	\N	
26481	\N	\N	\N	
26482	\N	\N	\N	
26483	\N	\N	\N	
26484	\N	\N	\N	
26485	\N	\N	\N	
26486	\N	\N	\N	
26487	\N	\N	\N	
26488	\N	\N	\N	
26489	\N	\N	\N	
26490	\N	\N	\N	
26491	\N	\N	\N	
26492	\N	\N	\N	
26493	\N	\N	\N	
26494	\N	\N	\N	
26495	\N	\N	\N	
26496	\N	\N	\N	
26497	\N	\N	\N	
26498	\N	\N	\N	
26499	\N	\N	\N	
26500	\N	\N	\N	
26501	\N	\N	\N	
26502	\N	\N	\N	
26503	\N	\N	\N	
26504	\N	\N	\N	
26505	\N	\N	\N	
26506	\N	\N	\N	
26507	\N	\N	\N	
26508	\N	\N	\N	
26509	\N	\N	\N	
26510	\N	\N	\N	
26511	\N	\N	\N	
26512	\N	\N	\N	
26513	\N	\N	\N	
26514	\N	\N	\N	
26515	\N	\N	\N	
26516	\N	\N	\N	
26517	\N	\N	\N	
26518	\N	\N	\N	
26519	\N	\N	\N	
26520	\N	\N	\N	
26521	\N	\N	\N	
26522	\N	\N	\N	
26523	\N	\N	\N	
26524	\N	\N	\N	
26525	\N	\N	\N	
26526	\N	\N	\N	
26527	\N	\N	\N	
26528	\N	\N	\N	
26529	\N	\N	\N	
26530	\N	\N	\N	
26531	\N	\N	\N	
26532	\N	\N	\N	
26533	\N	\N	\N	
26534	\N	\N	\N	
26535	\N	\N	\N	
26536	\N	\N	\N	
26537	\N	\N	\N	
26538	\N	\N	\N	
26539	\N	\N	\N	
26540	\N	\N	\N	
26541	\N	\N	\N	
26542	\N	\N	\N	
26543	\N	\N	\N	
26544	\N	\N	\N	
26545	\N	\N	\N	
26546	\N	\N	\N	
26547	\N	\N	\N	
26548	\N	\N	\N	
26549	\N	\N	\N	
26550	\N	\N	\N	
26551	\N	\N	\N	
26552	\N	\N	\N	
26553	\N	\N	\N	
26554	\N	\N	\N	
26555	\N	\N	\N	
26556	\N	\N	\N	
26557	\N	\N	\N	
26558	\N	\N	\N	
26559	\N	\N	\N	
26560	\N	\N	\N	
26561	\N	\N	\N	
26562	\N	\N	\N	
26563	\N	\N	\N	
26564	\N	\N	\N	
26565	\N	\N	\N	
26566	\N	\N	\N	
26567	\N	\N	\N	
26568	\N	\N	\N	
26569	\N	\N	\N	
26570	\N	\N	\N	
26571	\N	\N	\N	
26572	\N	\N	\N	
26573	\N	\N	\N	
26574	\N	\N	\N	
26575	\N	\N	\N	
26576	\N	\N	\N	
26577	\N	\N	\N	
26578	\N	\N	\N	
26579	\N	\N	\N	
26580	\N	\N	\N	
26581	\N	\N	\N	
26582	\N	\N	\N	
26583	\N	\N	\N	
26584	\N	\N	\N	
26585	\N	\N	\N	
26586	\N	\N	\N	
26587	\N	\N	\N	
26588	\N	\N	\N	
26589	\N	\N	\N	
26590	\N	\N	\N	
26591	\N	\N	\N	
26592	\N	\N	\N	
26593	\N	\N	\N	
26594	\N	\N	\N	
26595	\N	\N	\N	
26596	\N	\N	\N	
26597	\N	\N	\N	
26598	\N	\N	\N	
26599	\N	\N	\N	
26600	\N	\N	\N	
26601	\N	\N	\N	
26602	\N	\N	\N	
26603	\N	\N	\N	
26604	\N	\N	\N	
26605	\N	\N	\N	
26606	\N	\N	\N	
26607	\N	\N	\N	
26608	\N	\N	\N	
26609	\N	\N	\N	
26610	\N	\N	\N	
26611	\N	\N	\N	
26612	\N	\N	\N	
26613	\N	\N	\N	
26614	\N	\N	\N	
26615	\N	\N	\N	
26616	\N	\N	\N	
26617	\N	\N	\N	
26618	\N	\N	\N	
26619	\N	\N	\N	
26620	\N	\N	\N	
26621	\N	\N	\N	
26622	\N	\N	\N	
26623	\N	\N	\N	
26624	\N	\N	\N	
26625	\N	\N	\N	
26626	\N	\N	\N	
26627	\N	\N	\N	
26628	\N	\N	\N	
26629	\N	\N	\N	
26630	\N	\N	\N	
26631	\N	\N	\N	
26632	\N	\N	\N	
26633	\N	\N	\N	
26634	\N	\N	\N	
26635	\N	\N	\N	
26636	\N	\N	\N	
26637	\N	\N	\N	
26638	\N	\N	\N	
26639	\N	\N	\N	
26640	\N	\N	\N	
26641	\N	\N	\N	
26642	\N	\N	\N	
26643	\N	\N	\N	
26644	\N	\N	\N	
26645	\N	\N	\N	
26646	\N	\N	\N	
26647	\N	\N	\N	
26648	\N	\N	\N	
26649	\N	\N	\N	
26650	\N	\N	\N	
26651	\N	\N	\N	
26652	\N	\N	\N	
26653	\N	\N	\N	
26654	\N	\N	\N	
26655	\N	\N	\N	
26656	\N	\N	\N	
26657	\N	\N	\N	
26658	\N	\N	\N	
26659	\N	\N	\N	
26660	\N	\N	\N	
26661	\N	\N	\N	
26662	\N	\N	\N	
26663	\N	\N	\N	
26664	\N	\N	\N	
26665	\N	\N	\N	
26666	\N	\N	\N	
26667	\N	\N	\N	
26668	\N	\N	\N	
26669	\N	\N	\N	
26670	\N	\N	\N	
26671	\N	\N	\N	
26672	\N	\N	\N	
26673	\N	\N	\N	
26674	\N	\N	\N	
26675	\N	\N	\N	
26676	\N	\N	\N	
26677	\N	\N	\N	
26678	\N	\N	\N	
26679	\N	\N	\N	
26680	\N	\N	\N	
26681	\N	\N	\N	
26682	\N	\N	\N	
26683	\N	\N	\N	
26684	\N	\N	\N	
26685	\N	\N	\N	
26686	\N	\N	\N	
26687	\N	\N	\N	
26688	\N	\N	\N	
26689	\N	\N	\N	
26690	\N	\N	\N	
26691	\N	\N	\N	
26692	\N	\N	\N	
26693	\N	\N	\N	
26694	\N	\N	\N	
26695	\N	\N	\N	
26696	\N	\N	\N	
26697	\N	\N	\N	
26698	\N	\N	\N	
26699	\N	\N	\N	
26700	\N	\N	\N	
26701	\N	\N	\N	
26702	\N	\N	\N	
26703	\N	\N	\N	
26704	\N	\N	\N	
26705	\N	\N	\N	
26706	\N	\N	\N	
26707	\N	\N	\N	
26708	\N	\N	\N	
26709	\N	\N	\N	
26710	\N	\N	\N	
26711	\N	\N	\N	
26712	\N	\N	\N	
26713	\N	\N	\N	
26714	\N	\N	\N	
26715	\N	\N	\N	
26716	\N	\N	\N	
26717	\N	\N	\N	
26718	\N	\N	\N	
26719	\N	\N	\N	
26720	\N	\N	\N	
26721	\N	\N	\N	
26722	\N	\N	\N	
26723	\N	\N	\N	
26724	\N	\N	\N	
26725	\N	\N	\N	
26726	\N	\N	\N	
26727	\N	\N	\N	
26728	\N	\N	\N	
26729	\N	\N	\N	
26730	\N	\N	\N	
26731	\N	\N	\N	
26732	\N	\N	\N	
26733	\N	\N	\N	
26734	\N	\N	\N	
26735	\N	\N	\N	
26736	\N	\N	\N	
26737	\N	\N	\N	
26738	\N	\N	\N	
26739	\N	\N	\N	
26740	\N	\N	\N	
26741	\N	\N	\N	
26742	\N	\N	\N	
26743	\N	\N	\N	
26744	\N	\N	\N	
26745	\N	\N	\N	
26746	\N	\N	\N	
26747	\N	\N	\N	
26748	\N	\N	\N	
26749	\N	\N	\N	
26750	\N	\N	\N	
26751	\N	\N	\N	
26752	\N	\N	\N	
26753	\N	\N	\N	
26754	\N	\N	\N	
26755	\N	\N	\N	
26756	\N	\N	\N	
26757	\N	\N	\N	
26758	\N	\N	\N	
26759	\N	\N	\N	
26760	\N	\N	\N	
26761	\N	\N	\N	
26762	\N	\N	\N	
26763	\N	\N	\N	
26764	\N	\N	\N	
26765	\N	\N	\N	
26766	\N	\N	\N	
26767	\N	\N	\N	
26768	\N	\N	\N	
26769	\N	\N	\N	
26770	\N	\N	\N	
26771	\N	\N	\N	
26772	\N	\N	\N	
26773	\N	\N	\N	
26774	\N	\N	\N	
26775	\N	\N	\N	
26776	\N	\N	\N	
26777	\N	\N	\N	
26778	\N	\N	\N	
26779	\N	\N	\N	
26780	\N	\N	\N	
26781	\N	\N	\N	
26782	\N	\N	\N	
26783	\N	\N	\N	
26784	\N	\N	\N	
26785	\N	\N	\N	
26786	\N	\N	\N	
26787	\N	\N	\N	
26788	\N	\N	\N	
26789	\N	\N	\N	
26790	\N	\N	\N	
26791	\N	\N	\N	
26792	\N	\N	\N	
26793	\N	\N	\N	
26794	\N	\N	\N	
26795	\N	\N	\N	
26796	\N	\N	\N	
26797	\N	\N	\N	
26798	\N	\N	\N	
26799	\N	\N	\N	
26800	\N	\N	\N	
26801	\N	\N	\N	
26802	\N	\N	\N	
26803	\N	\N	\N	
26804	\N	\N	\N	
26805	\N	\N	\N	
26806	\N	\N	\N	
26807	\N	\N	\N	
26808	\N	\N	\N	
26809	\N	\N	\N	
26810	\N	\N	\N	
26811	\N	\N	\N	
26812	\N	\N	\N	
26813	\N	\N	\N	
26814	\N	\N	\N	
26815	\N	\N	\N	
26816	\N	\N	\N	
26817	\N	\N	\N	
26818	\N	\N	\N	
26819	\N	\N	\N	
26820	\N	\N	\N	
26821	\N	\N	\N	
26822	\N	\N	\N	
26823	\N	\N	\N	
26824	\N	\N	\N	
26825	\N	\N	\N	
26826	\N	\N	\N	
26827	\N	\N	\N	
26828	\N	\N	\N	
26829	\N	\N	\N	
26830	\N	\N	\N	
26831	\N	\N	\N	
26832	\N	\N	\N	
26833	\N	\N	\N	
26834	\N	\N	\N	
26835	\N	\N	\N	
26836	\N	\N	\N	
26837	\N	\N	\N	
26838	\N	\N	\N	
26839	\N	\N	\N	
26840	\N	\N	\N	
26841	\N	\N	\N	
26842	\N	\N	\N	
26843	\N	\N	\N	
26844	\N	\N	\N	
26845	\N	\N	\N	
26846	\N	\N	\N	
26847	\N	\N	\N	
26848	\N	\N	\N	
26849	\N	\N	\N	
26850	\N	\N	\N	
26851	\N	\N	\N	
26852	\N	\N	\N	
26853	\N	\N	\N	
26854	\N	\N	\N	
26855	\N	\N	\N	
26856	\N	\N	\N	
26857	\N	\N	\N	
26858	\N	\N	\N	
26859	\N	\N	\N	
26860	\N	\N	\N	
26861	\N	\N	\N	
26862	\N	\N	\N	
26863	\N	\N	\N	
26864	\N	\N	\N	
26865	\N	\N	\N	
26866	\N	\N	\N	
26867	\N	\N	\N	
26868	\N	\N	\N	
26869	\N	\N	\N	
26870	\N	\N	\N	
26871	\N	\N	\N	
26872	\N	\N	\N	
26873	\N	\N	\N	
26874	\N	\N	\N	
26875	\N	\N	\N	
26876	\N	\N	\N	
26877	\N	\N	\N	
26878	\N	\N	\N	
26879	\N	\N	\N	
26880	\N	\N	\N	
26881	\N	\N	\N	
26882	\N	\N	\N	
26883	\N	\N	\N	
26884	\N	\N	\N	
26885	\N	\N	\N	
26886	\N	\N	\N	
26887	\N	\N	\N	
26888	\N	\N	\N	
26889	\N	\N	\N	
26890	\N	\N	\N	
26891	\N	\N	\N	
26892	\N	\N	\N	
26893	\N	\N	\N	
26894	\N	\N	\N	
26895	\N	\N	\N	
26896	\N	\N	\N	
26897	\N	\N	\N	
26898	\N	\N	\N	
26899	\N	\N	\N	
26900	\N	\N	\N	
26901	\N	\N	\N	
26902	\N	\N	\N	
26903	\N	\N	\N	
26904	\N	\N	\N	
26905	\N	\N	\N	
26906	\N	\N	\N	
26907	\N	\N	\N	
26908	\N	\N	\N	
26909	\N	\N	\N	
26910	\N	\N	\N	
26911	\N	\N	\N	
26912	\N	\N	\N	
26913	\N	\N	\N	
26914	\N	\N	\N	
26915	\N	\N	\N	
26916	\N	\N	\N	
26917	\N	\N	\N	
26918	\N	\N	\N	
26919	\N	\N	\N	
26920	\N	\N	\N	
26921	\N	\N	\N	
26922	\N	\N	\N	
26923	\N	\N	\N	
26924	\N	\N	\N	
26925	\N	\N	\N	
26926	\N	\N	\N	
26927	\N	\N	\N	
26928	\N	\N	\N	
26929	\N	\N	\N	
26930	\N	\N	\N	
26931	\N	\N	\N	
26932	\N	\N	\N	
26933	\N	\N	\N	
26934	\N	\N	\N	
26935	\N	\N	\N	
26936	\N	\N	\N	
26937	\N	\N	\N	
26938	\N	\N	\N	
26939	\N	\N	\N	
26940	\N	\N	\N	
26941	\N	\N	\N	
26942	\N	\N	\N	
26943	\N	\N	\N	
26944	\N	\N	\N	
26945	\N	\N	\N	
26946	\N	\N	\N	
26947	\N	\N	\N	
26948	\N	\N	\N	
26949	\N	\N	\N	
26950	\N	\N	\N	
26951	\N	\N	\N	
26952	\N	\N	\N	
26953	\N	\N	\N	
26954	\N	\N	\N	
26955	\N	\N	\N	
26956	\N	\N	\N	
26957	\N	\N	\N	
26958	\N	\N	\N	
26959	\N	\N	\N	
26960	\N	\N	\N	
26961	\N	\N	\N	
26962	\N	\N	\N	
26963	\N	\N	\N	
26964	\N	\N	\N	
26965	\N	\N	\N	
26966	\N	\N	\N	
26967	\N	\N	\N	
26968	\N	\N	\N	
26969	\N	\N	\N	
26970	\N	\N	\N	
26971	\N	\N	\N	
26972	\N	\N	\N	
26973	\N	\N	\N	
26974	\N	\N	\N	
26975	\N	\N	\N	
26976	\N	\N	\N	
26977	\N	\N	\N	
26978	\N	\N	\N	
26979	\N	\N	\N	
26980	\N	\N	\N	
26981	\N	\N	\N	
26982	\N	\N	\N	
26983	\N	\N	\N	
26984	\N	\N	\N	
26985	\N	\N	\N	
26986	\N	\N	\N	
26987	\N	\N	\N	
26988	\N	\N	\N	
26989	\N	\N	\N	
26990	\N	\N	\N	
26991	\N	\N	\N	
26992	\N	\N	\N	
26993	\N	\N	\N	
26994	\N	\N	\N	
26995	\N	\N	\N	
26996	\N	\N	\N	
26997	\N	\N	\N	
26998	\N	\N	\N	
26999	\N	\N	\N	
27000	\N	\N	\N	
27001	\N	\N	\N	
27002	\N	\N	\N	
27003	\N	\N	\N	
27004	\N	\N	\N	
27005	\N	\N	\N	
27006	\N	\N	\N	
27007	\N	\N	\N	
27008	\N	\N	\N	
27009	\N	\N	\N	
27010	\N	\N	\N	
27011	\N	\N	\N	
27012	\N	\N	\N	
27013	\N	\N	\N	
27014	\N	\N	\N	
27015	\N	\N	\N	
27016	\N	\N	\N	
27017	\N	\N	\N	
27018	\N	\N	\N	
27019	\N	\N	\N	
27020	\N	\N	\N	
27021	\N	\N	\N	
27022	\N	\N	\N	
27023	\N	\N	\N	
27024	\N	\N	\N	
27025	\N	\N	\N	
27026	\N	\N	\N	
27027	\N	\N	\N	
27028	\N	\N	\N	
27029	\N	\N	\N	
27030	\N	\N	\N	
27031	\N	\N	\N	
27032	\N	\N	\N	
27033	\N	\N	\N	
27034	\N	\N	\N	
27035	\N	\N	\N	
27036	\N	\N	\N	
27037	\N	\N	\N	
27038	\N	\N	\N	
27039	\N	\N	\N	
27040	\N	\N	\N	
27041	\N	\N	\N	
27042	\N	\N	\N	
27043	\N	\N	\N	
27044	\N	\N	\N	
27045	\N	\N	\N	
27046	\N	\N	\N	
27047	\N	\N	\N	
27048	\N	\N	\N	
27049	\N	\N	\N	
27050	\N	\N	\N	
27051	\N	\N	\N	
27052	\N	\N	\N	
27053	\N	\N	\N	
27054	\N	\N	\N	
27055	\N	\N	\N	
27056	\N	\N	\N	
27057	\N	\N	\N	
27058	\N	\N	\N	
27059	\N	\N	\N	
27060	\N	\N	\N	
27061	\N	\N	\N	
27062	\N	\N	\N	
27063	\N	\N	\N	
27064	\N	\N	\N	
27065	\N	\N	\N	
27066	\N	\N	\N	
27067	\N	\N	\N	
27068	\N	\N	\N	
27069	\N	\N	\N	
27070	\N	\N	\N	
27071	\N	\N	\N	
27072	\N	\N	\N	
27073	\N	\N	\N	
27074	\N	\N	\N	
27075	\N	\N	\N	
27076	\N	\N	\N	
27077	\N	\N	\N	
27078	\N	\N	\N	
27079	\N	\N	\N	
27080	\N	\N	\N	
27081	\N	\N	\N	
27082	\N	\N	\N	
27083	\N	\N	\N	
27084	\N	\N	\N	
27085	\N	\N	\N	
27086	\N	\N	\N	
27087	\N	\N	\N	
27088	\N	\N	\N	
27089	\N	\N	\N	
27090	\N	\N	\N	
27091	\N	\N	\N	
27092	\N	\N	\N	
27093	\N	\N	\N	
27094	\N	\N	\N	
27095	\N	\N	\N	
27096	\N	\N	\N	
27097	\N	\N	\N	
27098	\N	\N	\N	
27099	\N	\N	\N	
27100	\N	\N	\N	
27101	\N	\N	\N	
27102	\N	\N	\N	
27103	\N	\N	\N	
27104	\N	\N	\N	
27105	\N	\N	\N	
27106	\N	\N	\N	
27107	\N	\N	\N	
27108	\N	\N	\N	
27109	\N	\N	\N	
27110	\N	\N	\N	
27111	\N	\N	\N	
27112	\N	\N	\N	
27113	\N	\N	\N	
27114	\N	\N	\N	
27115	\N	\N	\N	
27116	\N	\N	\N	
27117	\N	\N	\N	
27118	\N	\N	\N	
27119	\N	\N	\N	
27120	\N	\N	\N	
27121	\N	\N	\N	
27122	\N	\N	\N	
27123	\N	\N	\N	
27124	\N	\N	\N	
27125	\N	\N	\N	
27126	\N	\N	\N	
27127	\N	\N	\N	
27128	\N	\N	\N	
27129	\N	\N	\N	
27130	\N	\N	\N	
27131	\N	\N	\N	
27132	\N	\N	\N	
27133	\N	\N	\N	
27134	\N	\N	\N	
27135	\N	\N	\N	
27136	\N	\N	\N	
27137	\N	\N	\N	
27138	\N	\N	\N	
27139	\N	\N	\N	
27140	\N	\N	\N	
27141	\N	\N	\N	
27142	\N	\N	\N	
27143	\N	\N	\N	
27144	\N	\N	\N	
27145	\N	\N	\N	
27146	\N	\N	\N	
27147	\N	\N	\N	
27148	\N	\N	\N	
27149	\N	\N	\N	
27150	\N	\N	\N	
27151	\N	\N	\N	
27152	\N	\N	\N	
27153	\N	\N	\N	
27154	\N	\N	\N	
27155	\N	\N	\N	
27156	\N	\N	\N	
27157	\N	\N	\N	
27158	\N	\N	\N	
27159	\N	\N	\N	
27160	\N	\N	\N	
27161	\N	\N	\N	
27162	\N	\N	\N	
27163	\N	\N	\N	
27164	\N	\N	\N	
27165	\N	\N	\N	
27166	\N	\N	\N	
27167	\N	\N	\N	
27168	\N	\N	\N	
27169	\N	\N	\N	
27170	\N	\N	\N	
27171	\N	\N	\N	
27172	\N	\N	\N	
27173	\N	\N	\N	
27174	\N	\N	\N	
27175	\N	\N	\N	
27176	\N	\N	\N	
27177	\N	\N	\N	
27178	\N	\N	\N	
27179	\N	\N	\N	
27180	\N	\N	\N	
27181	\N	\N	\N	
27182	\N	\N	\N	
27183	\N	\N	\N	
27184	\N	\N	\N	
27185	\N	\N	\N	
27186	\N	\N	\N	
27187	\N	\N	\N	
27188	\N	\N	\N	
27189	\N	\N	\N	
27190	\N	\N	\N	
27191	\N	\N	\N	
27192	\N	\N	\N	
27193	\N	\N	\N	
27194	\N	\N	\N	
27195	\N	\N	\N	
27196	\N	\N	\N	
27197	\N	\N	\N	
27198	\N	\N	\N	
27199	\N	\N	\N	
27200	\N	\N	\N	
27201	\N	\N	\N	
27202	\N	\N	\N	
27203	\N	\N	\N	
27204	\N	\N	\N	
27205	\N	\N	\N	
27206	\N	\N	\N	
27207	\N	\N	\N	
27208	\N	\N	\N	
27209	\N	\N	\N	
27210	\N	\N	\N	
27211	\N	\N	\N	
27212	\N	\N	\N	
27213	\N	\N	\N	
27214	\N	\N	\N	
27215	\N	\N	\N	
27216	\N	\N	\N	
27217	\N	\N	\N	
27218	\N	\N	\N	
27219	\N	\N	\N	
27220	\N	\N	\N	
27221	\N	\N	\N	
27222	\N	\N	\N	
27223	\N	\N	\N	
27224	\N	\N	\N	
27225	\N	\N	\N	
27226	\N	\N	\N	
27227	\N	\N	\N	
27228	\N	\N	\N	
27229	\N	\N	\N	
27230	\N	\N	\N	
27231	\N	\N	\N	
27232	\N	\N	\N	
27233	\N	\N	\N	
27234	\N	\N	\N	
27235	\N	\N	\N	
27236	\N	\N	\N	
27237	\N	\N	\N	
27238	\N	\N	\N	
27239	\N	\N	\N	
27240	\N	\N	\N	
27241	\N	\N	\N	
27242	\N	\N	\N	
27243	\N	\N	\N	
27244	\N	\N	\N	
27245	\N	\N	\N	
27246	\N	\N	\N	
27247	\N	\N	\N	
27248	\N	\N	\N	
27249	\N	\N	\N	
27250	\N	\N	\N	
27251	\N	\N	\N	
27252	\N	\N	\N	
27253	\N	\N	\N	
27254	\N	\N	\N	
27255	\N	\N	\N	
27256	\N	\N	\N	
27257	\N	\N	\N	
27258	\N	\N	\N	
27259	\N	\N	\N	
27260	\N	\N	\N	
27261	\N	\N	\N	
27262	\N	\N	\N	
27263	\N	\N	\N	
27264	\N	\N	\N	
27265	\N	\N	\N	
27266	\N	\N	\N	
27267	\N	\N	\N	
27268	\N	\N	\N	
27269	\N	\N	\N	
27270	\N	\N	\N	
27271	\N	\N	\N	
27272	\N	\N	\N	
27273	\N	\N	\N	
27274	\N	\N	\N	
27275	\N	\N	\N	
27276	\N	\N	\N	
27277	\N	\N	\N	
27278	\N	\N	\N	
27279	\N	\N	\N	
27280	\N	\N	\N	
27281	\N	\N	\N	
27282	\N	\N	\N	
27283	\N	\N	\N	
27284	\N	\N	\N	
27285	\N	\N	\N	
27286	\N	\N	\N	
27287	\N	\N	\N	
27288	\N	\N	\N	
27289	\N	\N	\N	
27290	\N	\N	\N	
27291	\N	\N	\N	
27292	\N	\N	\N	
27293	\N	\N	\N	
27294	\N	\N	\N	
27295	\N	\N	\N	
27296	\N	\N	\N	
27297	\N	\N	\N	
27298	\N	\N	\N	
27299	\N	\N	\N	
27300	\N	\N	\N	
27301	\N	\N	\N	
27302	\N	\N	\N	
27303	\N	\N	\N	
27304	\N	\N	\N	
27305	\N	\N	\N	
27306	\N	\N	\N	
27307	\N	\N	\N	
27308	\N	\N	\N	
27309	\N	\N	\N	
27310	\N	\N	\N	
27311	\N	\N	\N	
27312	\N	\N	\N	
27313	\N	\N	\N	
27314	\N	\N	\N	
27315	\N	\N	\N	
27316	\N	\N	\N	
27317	\N	\N	\N	
27318	\N	\N	\N	
27319	\N	\N	\N	
27320	\N	\N	\N	
27321	\N	\N	\N	
27322	\N	\N	\N	
27323	\N	\N	\N	
27324	\N	\N	\N	
27325	\N	\N	\N	
27326	\N	\N	\N	
27327	\N	\N	\N	
27328	\N	\N	\N	
27329	\N	\N	\N	
27330	\N	\N	\N	
27331	\N	\N	\N	
27332	\N	\N	\N	
27333	\N	\N	\N	
27334	\N	\N	\N	
27335	\N	\N	\N	
27336	\N	\N	\N	
27337	\N	\N	\N	
27338	\N	\N	\N	
27339	\N	\N	\N	
27340	\N	\N	\N	
27341	\N	\N	\N	
27342	\N	\N	\N	
27343	\N	\N	\N	
27344	\N	\N	\N	
27345	\N	\N	\N	
27346	\N	\N	\N	
27347	\N	\N	\N	
27348	\N	\N	\N	
27349	\N	\N	\N	
27350	\N	\N	\N	
27351	\N	\N	\N	
27352	\N	\N	\N	
27353	\N	\N	\N	
27354	\N	\N	\N	
27355	\N	\N	\N	
27356	\N	\N	\N	
27357	\N	\N	\N	
27358	\N	\N	\N	
27359	\N	\N	\N	
27360	\N	\N	\N	
27361	\N	\N	\N	
27362	\N	\N	\N	
27363	\N	\N	\N	
27364	\N	\N	\N	
27365	\N	\N	\N	
27366	\N	\N	\N	
27367	\N	\N	\N	
27368	\N	\N	\N	
27369	\N	\N	\N	
27370	\N	\N	\N	
27371	\N	\N	\N	
27372	\N	\N	\N	
27373	\N	\N	\N	
27374	\N	\N	\N	
27375	\N	\N	\N	
27376	\N	\N	\N	
27377	\N	\N	\N	
27378	\N	\N	\N	
27379	\N	\N	\N	
27380	\N	\N	\N	
27381	\N	\N	\N	
27382	\N	\N	\N	
27383	\N	\N	\N	
27384	\N	\N	\N	
27385	\N	\N	\N	
27386	\N	\N	\N	
27387	\N	\N	\N	
27388	\N	\N	\N	
27389	\N	\N	\N	
27390	\N	\N	\N	
27391	\N	\N	\N	
27392	\N	\N	\N	
27393	\N	\N	\N	
27394	\N	\N	\N	
27395	\N	\N	\N	
27396	\N	\N	\N	
27397	\N	\N	\N	
27398	\N	\N	\N	
27399	\N	\N	\N	
27400	\N	\N	\N	
27401	\N	\N	\N	
27402	\N	\N	\N	
27403	\N	\N	\N	
27404	\N	\N	\N	
27405	\N	\N	\N	
27406	\N	\N	\N	
27407	\N	\N	\N	
27408	\N	\N	\N	
27409	\N	\N	\N	
27410	\N	\N	\N	
27411	\N	\N	\N	
27412	\N	\N	\N	
27413	\N	\N	\N	
27414	\N	\N	\N	
27415	\N	\N	\N	
27416	\N	\N	\N	
27417	\N	\N	\N	
27418	\N	\N	\N	
27419	\N	\N	\N	
27420	\N	\N	\N	
27421	\N	\N	\N	
27422	\N	\N	\N	
27423	\N	\N	\N	
27424	\N	\N	\N	
27425	\N	\N	\N	
27426	\N	\N	\N	
27427	\N	\N	\N	
27428	\N	\N	\N	
27429	\N	\N	\N	
27430	\N	\N	\N	
27431	\N	\N	\N	
27432	\N	\N	\N	
27433	\N	\N	\N	
27434	\N	\N	\N	
27435	\N	\N	\N	
27436	\N	\N	\N	
27437	\N	\N	\N	
27438	\N	\N	\N	
27439	\N	\N	\N	
27440	\N	\N	\N	
27441	\N	\N	\N	
27442	\N	\N	\N	
27443	\N	\N	\N	
27444	\N	\N	\N	
27445	\N	\N	\N	
27446	\N	\N	\N	
27447	\N	\N	\N	
27448	\N	\N	\N	
27449	\N	\N	\N	
27450	\N	\N	\N	
27451	\N	\N	\N	
27452	\N	\N	\N	
27453	\N	\N	\N	
27454	\N	\N	\N	
27455	\N	\N	\N	
27456	\N	\N	\N	
27457	\N	\N	\N	
27458	\N	\N	\N	
27459	\N	\N	\N	
27460	\N	\N	\N	
27461	\N	\N	\N	
27462	\N	\N	\N	
27463	\N	\N	\N	
27464	\N	\N	\N	
27465	\N	\N	\N	
27466	\N	\N	\N	
27467	\N	\N	\N	
27468	\N	\N	\N	
27469	\N	\N	\N	
27470	\N	\N	\N	
27471	\N	\N	\N	
27472	\N	\N	\N	
27473	\N	\N	\N	
27474	\N	\N	\N	
27475	\N	\N	\N	
27476	\N	\N	\N	
27477	\N	\N	\N	
27478	\N	\N	\N	
27479	\N	\N	\N	
27480	\N	\N	\N	
27481	\N	\N	\N	
27482	\N	\N	\N	
27483	\N	\N	\N	
27484	\N	\N	\N	
27485	\N	\N	\N	
27486	\N	\N	\N	
27487	\N	\N	\N	
27488	\N	\N	\N	
27489	\N	\N	\N	
27490	\N	\N	\N	
27491	\N	\N	\N	
27492	\N	\N	\N	
27493	\N	\N	\N	
27494	\N	\N	\N	
27495	\N	\N	\N	
27496	\N	\N	\N	
27497	\N	\N	\N	
27498	\N	\N	\N	
27499	\N	\N	\N	
27500	\N	\N	\N	
27501	\N	\N	\N	
27502	\N	\N	\N	
27503	\N	\N	\N	
27504	\N	\N	\N	
27505	\N	\N	\N	
27506	\N	\N	\N	
27507	\N	\N	\N	
27508	\N	\N	\N	
27509	\N	\N	\N	
27510	\N	\N	\N	
27511	\N	\N	\N	
27512	\N	\N	\N	
27513	\N	\N	\N	
27514	\N	\N	\N	
27515	\N	\N	\N	
27516	\N	\N	\N	
27517	\N	\N	\N	
27518	\N	\N	\N	
27519	\N	\N	\N	
27520	\N	\N	\N	
27521	\N	\N	\N	
27522	\N	\N	\N	
27523	\N	\N	\N	
27524	\N	\N	\N	
27525	\N	\N	\N	
27526	\N	\N	\N	
27527	\N	\N	\N	
27528	\N	\N	\N	
27529	\N	\N	\N	
27530	\N	\N	\N	
27531	\N	\N	\N	
27532	\N	\N	\N	
27533	\N	\N	\N	
27534	\N	\N	\N	
27535	\N	\N	\N	
27536	\N	\N	\N	
27537	\N	\N	\N	
27538	\N	\N	\N	
27539	\N	\N	\N	
27540	\N	\N	\N	
27541	\N	\N	\N	
27542	\N	\N	\N	
27543	\N	\N	\N	
27544	\N	\N	\N	
27545	\N	\N	\N	
27546	\N	\N	\N	
27547	\N	\N	\N	
27548	\N	\N	\N	
27549	\N	\N	\N	
27550	\N	\N	\N	
27551	\N	\N	\N	
27552	\N	\N	\N	
27553	\N	\N	\N	
27554	\N	\N	\N	
27555	\N	\N	\N	
27556	\N	\N	\N	
27557	\N	\N	\N	
27558	\N	\N	\N	
27559	\N	\N	\N	
27560	\N	\N	\N	
27561	\N	\N	\N	
27562	\N	\N	\N	
27563	\N	\N	\N	
27564	\N	\N	\N	
27565	\N	\N	\N	
27566	\N	\N	\N	
27567	\N	\N	\N	
27568	\N	\N	\N	
27569	\N	\N	\N	
27570	\N	\N	\N	
27571	\N	\N	\N	
27572	\N	\N	\N	
27573	\N	\N	\N	
27574	\N	\N	\N	
27575	\N	\N	\N	
27576	\N	\N	\N	
27577	\N	\N	\N	
27578	\N	\N	\N	
27579	\N	\N	\N	
27580	\N	\N	\N	
27581	\N	\N	\N	
27582	\N	\N	\N	
27583	\N	\N	\N	
27584	\N	\N	\N	
27585	\N	\N	\N	
27586	\N	\N	\N	
27587	\N	\N	\N	
27588	\N	\N	\N	
27589	\N	\N	\N	
27590	\N	\N	\N	
27591	\N	\N	\N	
27592	\N	\N	\N	
27593	\N	\N	\N	
27594	\N	\N	\N	
27595	\N	\N	\N	
27596	\N	\N	\N	
27597	\N	\N	\N	
27598	\N	\N	\N	
27599	\N	\N	\N	
27600	\N	\N	\N	
27601	\N	\N	\N	
27602	\N	\N	\N	
27603	\N	\N	\N	
27604	\N	\N	\N	
27605	\N	\N	\N	
27606	\N	\N	\N	
27607	\N	\N	\N	
27608	\N	\N	\N	
27609	\N	\N	\N	
27610	\N	\N	\N	
27611	\N	\N	\N	
27612	\N	\N	\N	
27613	\N	\N	\N	
27614	\N	\N	\N	
27615	\N	\N	\N	
27616	\N	\N	\N	
27617	\N	\N	\N	
27618	\N	\N	\N	
27619	\N	\N	\N	
27620	\N	\N	\N	
27621	\N	\N	\N	
27622	\N	\N	\N	
27623	\N	\N	\N	
27624	\N	\N	\N	
27625	\N	\N	\N	
27626	\N	\N	\N	
27627	\N	\N	\N	
27628	\N	\N	\N	
27629	\N	\N	\N	
27630	\N	\N	\N	
27631	\N	\N	\N	
27632	\N	\N	\N	
27633	\N	\N	\N	
27634	\N	\N	\N	
27635	\N	\N	\N	
27636	\N	\N	\N	
27637	\N	\N	\N	
27638	\N	\N	\N	
27639	\N	\N	\N	
27640	\N	\N	\N	
27641	\N	\N	\N	
27642	\N	\N	\N	
27643	\N	\N	\N	
27644	\N	\N	\N	
27645	\N	\N	\N	
27646	\N	\N	\N	
27647	\N	\N	\N	
27648	\N	\N	\N	
27649	\N	\N	\N	
27650	\N	\N	\N	
27651	\N	\N	\N	
27652	\N	\N	\N	
27653	\N	\N	\N	
27654	\N	\N	\N	
27655	\N	\N	\N	
27656	\N	\N	\N	
27657	\N	\N	\N	
27658	\N	\N	\N	
27659	\N	\N	\N	
27660	\N	\N	\N	
27661	\N	\N	\N	
27662	\N	\N	\N	
27663	\N	\N	\N	
27664	\N	\N	\N	
27665	\N	\N	\N	
27666	\N	\N	\N	
27667	\N	\N	\N	
27668	\N	\N	\N	
27669	\N	\N	\N	
27670	\N	\N	\N	
27671	\N	\N	\N	
27672	\N	\N	\N	
27673	\N	\N	\N	
27674	\N	\N	\N	
27675	\N	\N	\N	
27676	\N	\N	\N	
27677	\N	\N	\N	
27678	\N	\N	\N	
27679	\N	\N	\N	
27680	\N	\N	\N	
27681	\N	\N	\N	
27682	\N	\N	\N	
27683	\N	\N	\N	
27684	\N	\N	\N	
27685	\N	\N	\N	
27686	\N	\N	\N	
27687	\N	\N	\N	
27688	\N	\N	\N	
27689	\N	\N	\N	
27690	\N	\N	\N	
27691	\N	\N	\N	
27692	\N	\N	\N	
27693	\N	\N	\N	
27694	\N	\N	\N	
27695	\N	\N	\N	
27696	\N	\N	\N	
27697	\N	\N	\N	
27698	\N	\N	\N	
27699	\N	\N	\N	
27700	\N	\N	\N	
27701	\N	\N	\N	
27702	\N	\N	\N	
27703	\N	\N	\N	
27704	\N	\N	\N	
27705	\N	\N	\N	
27706	\N	\N	\N	
27707	\N	\N	\N	
27708	\N	\N	\N	
27709	\N	\N	\N	
27710	\N	\N	\N	
27711	\N	\N	\N	
27712	\N	\N	\N	
27713	\N	\N	\N	
27714	\N	\N	\N	
27715	\N	\N	\N	
27716	\N	\N	\N	
27717	\N	\N	\N	
27718	\N	\N	\N	
27719	\N	\N	\N	
27720	\N	\N	\N	
27721	\N	\N	\N	
27722	\N	\N	\N	
27723	\N	\N	\N	
27724	\N	\N	\N	
27725	\N	\N	\N	
27726	\N	\N	\N	
27727	\N	\N	\N	
27728	\N	\N	\N	
27729	\N	\N	\N	
27730	\N	\N	\N	
27731	\N	\N	\N	
27732	\N	\N	\N	
27733	\N	\N	\N	
27734	\N	\N	\N	
27735	\N	\N	\N	
27736	\N	\N	\N	
27737	\N	\N	\N	
27738	\N	\N	\N	
27739	\N	\N	\N	
27740	\N	\N	\N	
27741	\N	\N	\N	
27742	\N	\N	\N	
27743	\N	\N	\N	
27744	\N	\N	\N	
27745	\N	\N	\N	
27746	\N	\N	\N	
27747	\N	\N	\N	
27748	\N	\N	\N	
27749	\N	\N	\N	
27750	\N	\N	\N	
27751	\N	\N	\N	
27752	\N	\N	\N	
27753	\N	\N	\N	
27754	\N	\N	\N	
27755	\N	\N	\N	
27756	\N	\N	\N	
27757	\N	\N	\N	
27758	\N	\N	\N	
27759	\N	\N	\N	
27760	\N	\N	\N	
27761	\N	\N	\N	
27762	\N	\N	\N	
27763	\N	\N	\N	
27764	\N	\N	\N	
27765	\N	\N	\N	
27766	\N	\N	\N	
27767	\N	\N	\N	
27768	\N	\N	\N	
27769	\N	\N	\N	
27770	\N	\N	\N	
27771	\N	\N	\N	
27772	\N	\N	\N	
27773	\N	\N	\N	
27774	\N	\N	\N	
27775	\N	\N	\N	
27776	\N	\N	\N	
27777	\N	\N	\N	
27778	\N	\N	\N	
27779	\N	\N	\N	
27780	\N	\N	\N	
27781	\N	\N	\N	
27782	\N	\N	\N	
27783	\N	\N	\N	
27784	\N	\N	\N	
27785	\N	\N	\N	
27786	\N	\N	\N	
27787	\N	\N	\N	
27788	\N	\N	\N	
27789	\N	\N	\N	
27790	\N	\N	\N	
27791	\N	\N	\N	
27792	\N	\N	\N	
27793	\N	\N	\N	
27794	\N	\N	\N	
27795	\N	\N	\N	
27796	\N	\N	\N	
27797	\N	\N	\N	
27798	\N	\N	\N	
27799	\N	\N	\N	
27800	\N	\N	\N	
27801	\N	\N	\N	
27802	\N	\N	\N	
27803	\N	\N	\N	
27804	\N	\N	\N	
27805	\N	\N	\N	
27806	\N	\N	\N	
27807	\N	\N	\N	
27808	\N	\N	\N	
27809	\N	\N	\N	
27810	\N	\N	\N	
27811	\N	\N	\N	
27812	\N	\N	\N	
27813	\N	\N	\N	
27814	\N	\N	\N	
27815	\N	\N	\N	
27816	\N	\N	\N	
27817	\N	\N	\N	
27818	\N	\N	\N	
27819	\N	\N	\N	
27820	\N	\N	\N	
27821	\N	\N	\N	
27822	\N	\N	\N	
27823	\N	\N	\N	
27824	\N	\N	\N	
27825	\N	\N	\N	
27826	\N	\N	\N	
27827	\N	\N	\N	
27828	\N	\N	\N	
27829	\N	\N	\N	
27830	\N	\N	\N	
27831	\N	\N	\N	
27832	\N	\N	\N	
27833	\N	\N	\N	
27834	\N	\N	\N	
27835	\N	\N	\N	
27836	\N	\N	\N	
27837	\N	\N	\N	
27838	\N	\N	\N	
27839	\N	\N	\N	
27840	\N	\N	\N	
27841	\N	\N	\N	
27842	\N	\N	\N	
27843	\N	\N	\N	
27844	\N	\N	\N	
27845	\N	\N	\N	
27846	\N	\N	\N	
27847	\N	\N	\N	
27848	\N	\N	\N	
27849	\N	\N	\N	
27850	\N	\N	\N	
27851	\N	\N	\N	
27852	\N	\N	\N	
27853	\N	\N	\N	
27854	\N	\N	\N	
27855	\N	\N	\N	
27856	\N	\N	\N	
27857	\N	\N	\N	
27858	\N	\N	\N	
27859	\N	\N	\N	
27860	\N	\N	\N	
27861	\N	\N	\N	
27862	\N	\N	\N	
27863	\N	\N	\N	
27864	\N	\N	\N	
27865	\N	\N	\N	
27866	\N	\N	\N	
27867	\N	\N	\N	
27868	\N	\N	\N	
27869	\N	\N	\N	
27870	\N	\N	\N	
27871	\N	\N	\N	
27872	\N	\N	\N	
27873	\N	\N	\N	
27874	\N	\N	\N	
27875	\N	\N	\N	
27876	\N	\N	\N	
27877	\N	\N	\N	
27878	\N	\N	\N	
27879	\N	\N	\N	
27880	\N	\N	\N	
27881	\N	\N	\N	
27882	\N	\N	\N	
27883	\N	\N	\N	
27884	\N	\N	\N	
27885	\N	\N	\N	
27886	\N	\N	\N	
27887	\N	\N	\N	
27888	\N	\N	\N	
27889	\N	\N	\N	
27890	\N	\N	\N	
27891	\N	\N	\N	
27892	\N	\N	\N	
27893	\N	\N	\N	
27894	\N	\N	\N	
27895	\N	\N	\N	
27896	\N	\N	\N	
27897	\N	\N	\N	
27898	\N	\N	\N	
27899	\N	\N	\N	
27900	\N	\N	\N	
27901	\N	\N	\N	
27902	\N	\N	\N	
27903	\N	\N	\N	
27904	\N	\N	\N	
27905	\N	\N	\N	
27906	\N	\N	\N	
27907	\N	\N	\N	
27908	\N	\N	\N	
27909	\N	\N	\N	
27910	\N	\N	\N	
27911	\N	\N	\N	
27912	\N	\N	\N	
27913	\N	\N	\N	
27914	\N	\N	\N	
27915	\N	\N	\N	
27916	\N	\N	\N	
27917	\N	\N	\N	
27918	\N	\N	\N	
27919	\N	\N	\N	
27920	\N	\N	\N	
27921	\N	\N	\N	
27922	\N	\N	\N	
27923	\N	\N	\N	
27924	\N	\N	\N	
27925	\N	\N	\N	
27926	\N	\N	\N	
27927	\N	\N	\N	
27928	\N	\N	\N	
27929	\N	\N	\N	
27930	\N	\N	\N	
27931	\N	\N	\N	
27932	\N	\N	\N	
27933	\N	\N	\N	
27934	\N	\N	\N	
27935	\N	\N	\N	
27936	\N	\N	\N	
27937	\N	\N	\N	
27938	\N	\N	\N	
27939	\N	\N	\N	
27940	\N	\N	\N	
27941	\N	\N	\N	
27942	\N	\N	\N	
27943	\N	\N	\N	
27944	\N	\N	\N	
27945	\N	\N	\N	
27946	\N	\N	\N	
27947	\N	\N	\N	
27948	\N	\N	\N	
27949	\N	\N	\N	
27950	\N	\N	\N	
27951	\N	\N	\N	
27952	\N	\N	\N	
27953	\N	\N	\N	
27954	\N	\N	\N	
27955	\N	\N	\N	
27956	\N	\N	\N	
27957	\N	\N	\N	
27958	\N	\N	\N	
27959	\N	\N	\N	
27960	\N	\N	\N	
27961	\N	\N	\N	
27962	\N	\N	\N	
27963	\N	\N	\N	
27964	\N	\N	\N	
27965	\N	\N	\N	
27966	\N	\N	\N	
27967	\N	\N	\N	
27968	\N	\N	\N	
27969	\N	\N	\N	
27970	\N	\N	\N	
27971	\N	\N	\N	
27972	\N	\N	\N	
27973	\N	\N	\N	
27974	\N	\N	\N	
27975	\N	\N	\N	
27976	\N	\N	\N	
27977	\N	\N	\N	
27978	\N	\N	\N	
27979	\N	\N	\N	
27980	\N	\N	\N	
27981	\N	\N	\N	
27982	\N	\N	\N	
27983	\N	\N	\N	
27984	\N	\N	\N	
27985	\N	\N	\N	
27986	\N	\N	\N	
27987	\N	\N	\N	
27988	\N	\N	\N	
27989	\N	\N	\N	
27990	\N	\N	\N	
27991	\N	\N	\N	
27992	\N	\N	\N	
27993	\N	\N	\N	
27994	\N	\N	\N	
27995	\N	\N	\N	
27996	\N	\N	\N	
27997	\N	\N	\N	
27998	\N	\N	\N	
27999	\N	\N	\N	
28000	\N	\N	\N	
28001	\N	\N	\N	
28002	\N	\N	\N	
28003	\N	\N	\N	
28004	\N	\N	\N	
28005	\N	\N	\N	
28006	\N	\N	\N	
28007	\N	\N	\N	
28008	\N	\N	\N	
28009	\N	\N	\N	
28010	\N	\N	\N	
28011	\N	\N	\N	
28012	\N	\N	\N	
28013	\N	\N	\N	
28014	\N	\N	\N	
28015	\N	\N	\N	
28016	\N	\N	\N	
28017	\N	\N	\N	
28018	\N	\N	\N	
28019	\N	\N	\N	
28020	\N	\N	\N	
28021	\N	\N	\N	
28022	\N	\N	\N	
28023	\N	\N	\N	
28024	\N	\N	\N	
28025	\N	\N	\N	
28026	\N	\N	\N	
28027	\N	\N	\N	
28028	\N	\N	\N	
28029	\N	\N	\N	
28030	\N	\N	\N	
28031	\N	\N	\N	
28032	\N	\N	\N	
28033	\N	\N	\N	
28034	\N	\N	\N	
28035	\N	\N	\N	
28036	\N	\N	\N	
28037	\N	\N	\N	
28038	\N	\N	\N	
28039	\N	\N	\N	
28040	\N	\N	\N	
28041	\N	\N	\N	
28042	\N	\N	\N	
28043	\N	\N	\N	
28044	\N	\N	\N	
28045	\N	\N	\N	
28046	\N	\N	\N	
28047	\N	\N	\N	
28048	\N	\N	\N	
28049	\N	\N	\N	
28050	\N	\N	\N	
28051	\N	\N	\N	
28052	\N	\N	\N	
28053	\N	\N	\N	
28054	\N	\N	\N	
28055	\N	\N	\N	
28056	\N	\N	\N	
28057	\N	\N	\N	
28058	\N	\N	\N	
28059	\N	\N	\N	
28060	\N	\N	\N	
28061	\N	\N	\N	
28062	\N	\N	\N	
28063	\N	\N	\N	
28064	\N	\N	\N	
28065	\N	\N	\N	
28066	\N	\N	\N	
28067	\N	\N	\N	
28068	\N	\N	\N	
28069	\N	\N	\N	
28070	\N	\N	\N	
28071	\N	\N	\N	
28072	\N	\N	\N	
28073	\N	\N	\N	
28074	\N	\N	\N	
28075	\N	\N	\N	
28076	\N	\N	\N	
28077	\N	\N	\N	
28078	\N	\N	\N	
28079	\N	\N	\N	
28080	\N	\N	\N	
28081	\N	\N	\N	
28082	\N	\N	\N	
28083	\N	\N	\N	
28084	\N	\N	\N	
28085	\N	\N	\N	
28086	\N	\N	\N	
28087	\N	\N	\N	
28088	\N	\N	\N	
28089	\N	\N	\N	
28090	\N	\N	\N	
28091	\N	\N	\N	
28092	\N	\N	\N	
28093	\N	\N	\N	
28094	\N	\N	\N	
28095	\N	\N	\N	
28096	\N	\N	\N	
28097	\N	\N	\N	
28098	\N	\N	\N	
28099	\N	\N	\N	
28100	\N	\N	\N	
28101	\N	\N	\N	
28102	\N	\N	\N	
28103	\N	\N	\N	
28104	\N	\N	\N	
28105	\N	\N	\N	
28106	\N	\N	\N	
28107	\N	\N	\N	
28108	\N	\N	\N	
28109	\N	\N	\N	
28110	\N	\N	\N	
28111	\N	\N	\N	
28112	\N	\N	\N	
28113	\N	\N	\N	
28114	\N	\N	\N	
28115	\N	\N	\N	
28116	\N	\N	\N	
28117	\N	\N	\N	
28118	\N	\N	\N	
28119	\N	\N	\N	
28120	\N	\N	\N	
28121	\N	\N	\N	
28122	\N	\N	\N	
28123	\N	\N	\N	
28124	\N	\N	\N	
28125	\N	\N	\N	
28126	\N	\N	\N	
28127	\N	\N	\N	
28128	\N	\N	\N	
28129	\N	\N	\N	
28130	\N	\N	\N	
28131	\N	\N	\N	
28132	\N	\N	\N	
28133	\N	\N	\N	
28134	\N	\N	\N	
28135	\N	\N	\N	
28136	\N	\N	\N	
28137	\N	\N	\N	
28138	\N	\N	\N	
28139	\N	\N	\N	
28140	\N	\N	\N	
28141	\N	\N	\N	
28142	\N	\N	\N	
28143	\N	\N	\N	
28144	\N	\N	\N	
28145	\N	\N	\N	
28146	\N	\N	\N	
28147	\N	\N	\N	
28148	\N	\N	\N	
28149	\N	\N	\N	
28150	\N	\N	\N	
28151	\N	\N	\N	
28152	\N	\N	\N	
28153	\N	\N	\N	
28154	\N	\N	\N	
28155	\N	\N	\N	
28156	\N	\N	\N	
28157	\N	\N	\N	
28158	\N	\N	\N	
28159	\N	\N	\N	
28160	\N	\N	\N	
28161	\N	\N	\N	
28162	\N	\N	\N	
28163	\N	\N	\N	
28164	\N	\N	\N	
28165	\N	\N	\N	
28166	\N	\N	\N	
28167	\N	\N	\N	
28168	\N	\N	\N	
28169	\N	\N	\N	
28170	\N	\N	\N	
28171	\N	\N	\N	
28172	\N	\N	\N	
28173	\N	\N	\N	
28174	\N	\N	\N	
28175	\N	\N	\N	
28176	\N	\N	\N	
28177	\N	\N	\N	
28178	\N	\N	\N	
28179	\N	\N	\N	
28180	\N	\N	\N	
28181	\N	\N	\N	
28182	\N	\N	\N	
28183	\N	\N	\N	
28184	\N	\N	\N	
28185	\N	\N	\N	
28186	\N	\N	\N	
28187	\N	\N	\N	
28188	\N	\N	\N	
28189	\N	\N	\N	
28190	\N	\N	\N	
28191	\N	\N	\N	
28192	\N	\N	\N	
28193	\N	\N	\N	
28194	\N	\N	\N	
28195	\N	\N	\N	
28196	\N	\N	\N	
28197	\N	\N	\N	
28198	\N	\N	\N	
28199	\N	\N	\N	
28200	\N	\N	\N	
28201	\N	\N	\N	
28202	\N	\N	\N	
28203	\N	\N	\N	
28204	\N	\N	\N	
28205	\N	\N	\N	
28206	\N	\N	\N	
28207	\N	\N	\N	
28208	\N	\N	\N	
28209	\N	\N	\N	
28210	\N	\N	\N	
28211	\N	\N	\N	
28212	\N	\N	\N	
28213	\N	\N	\N	
28214	\N	\N	\N	
28215	\N	\N	\N	
28216	\N	\N	\N	
28217	\N	\N	\N	
28218	\N	\N	\N	
28219	\N	\N	\N	
28220	\N	\N	\N	
28221	\N	\N	\N	
28222	\N	\N	\N	
28223	\N	\N	\N	
28224	\N	\N	\N	
28225	\N	\N	\N	
28226	\N	\N	\N	
28227	\N	\N	\N	
28228	\N	\N	\N	
28229	\N	\N	\N	
28230	\N	\N	\N	
28231	\N	\N	\N	
28232	\N	\N	\N	
28233	\N	\N	\N	
28234	\N	\N	\N	
28235	\N	\N	\N	
28236	\N	\N	\N	
28237	\N	\N	\N	
28238	\N	\N	\N	
28239	\N	\N	\N	
28240	\N	\N	\N	
28241	\N	\N	\N	
28242	\N	\N	\N	
28243	\N	\N	\N	
28244	\N	\N	\N	
28245	\N	\N	\N	
28246	\N	\N	\N	
28247	\N	\N	\N	
28248	\N	\N	\N	
28249	\N	\N	\N	
28250	\N	\N	\N	
28251	\N	\N	\N	
28252	\N	\N	\N	
28253	\N	\N	\N	
28254	\N	\N	\N	
28255	\N	\N	\N	
28256	\N	\N	\N	
28257	\N	\N	\N	
28258	\N	\N	\N	
28259	\N	\N	\N	
28260	\N	\N	\N	
28261	\N	\N	\N	
28262	\N	\N	\N	
28263	\N	\N	\N	
28264	\N	\N	\N	
28265	\N	\N	\N	
28266	\N	\N	\N	
28267	\N	\N	\N	
28268	\N	\N	\N	
28269	\N	\N	\N	
28270	\N	\N	\N	
28271	\N	\N	\N	
28272	\N	\N	\N	
28273	\N	\N	\N	
28274	\N	\N	\N	
28275	\N	\N	\N	
28276	\N	\N	\N	
28277	\N	\N	\N	
28278	\N	\N	\N	
28279	\N	\N	\N	
28280	\N	\N	\N	
28281	\N	\N	\N	
28282	\N	\N	\N	
28283	\N	\N	\N	
28284	\N	\N	\N	
28285	\N	\N	\N	
28286	\N	\N	\N	
28287	\N	\N	\N	
28288	\N	\N	\N	
28289	\N	\N	\N	
28290	\N	\N	\N	
28291	\N	\N	\N	
28292	\N	\N	\N	
28293	\N	\N	\N	
28294	\N	\N	\N	
28295	\N	\N	\N	
28296	\N	\N	\N	
28297	\N	\N	\N	
28298	\N	\N	\N	
28299	\N	\N	\N	
28300	\N	\N	\N	
28301	\N	\N	\N	
28302	\N	\N	\N	
28303	\N	\N	\N	
28304	\N	\N	\N	
28305	\N	\N	\N	
28306	\N	\N	\N	
28307	\N	\N	\N	
28308	\N	\N	\N	
28309	\N	\N	\N	
28310	\N	\N	\N	
28311	\N	\N	\N	
28312	\N	\N	\N	
28313	\N	\N	\N	
28314	\N	\N	\N	
28315	\N	\N	\N	
28316	\N	\N	\N	
28317	\N	\N	\N	
28318	\N	\N	\N	
28319	\N	\N	\N	
28320	\N	\N	\N	
28321	\N	\N	\N	
28322	\N	\N	\N	
28323	\N	\N	\N	
28324	\N	\N	\N	
28325	\N	\N	\N	
28326	\N	\N	\N	
28327	\N	\N	\N	
28328	\N	\N	\N	
28329	\N	\N	\N	
28330	\N	\N	\N	
28331	\N	\N	\N	
28332	\N	\N	\N	
28333	\N	\N	\N	
28334	\N	\N	\N	
28335	\N	\N	\N	
28336	\N	\N	\N	
28337	\N	\N	\N	
28338	\N	\N	\N	
28339	\N	\N	\N	
28340	\N	\N	\N	
28341	\N	\N	\N	
28342	\N	\N	\N	
28343	\N	\N	\N	
28344	\N	\N	\N	
28345	\N	\N	\N	
28346	\N	\N	\N	
28347	\N	\N	\N	
28348	\N	\N	\N	
28349	\N	\N	\N	
28350	\N	\N	\N	
28351	\N	\N	\N	
28352	\N	\N	\N	
28353	\N	\N	\N	
28354	\N	\N	\N	
28355	\N	\N	\N	
28356	\N	\N	\N	
28357	\N	\N	\N	
28358	\N	\N	\N	
28359	\N	\N	\N	
28360	\N	\N	\N	
28361	\N	\N	\N	
28362	\N	\N	\N	
28363	\N	\N	\N	
28364	\N	\N	\N	
28365	\N	\N	\N	
28366	\N	\N	\N	
28367	\N	\N	\N	
28368	\N	\N	\N	
28369	\N	\N	\N	
28370	\N	\N	\N	
28371	\N	\N	\N	
28372	\N	\N	\N	
28373	\N	\N	\N	
28374	\N	\N	\N	
28375	\N	\N	\N	
28376	\N	\N	\N	
28377	\N	\N	\N	
28378	\N	\N	\N	
28379	\N	\N	\N	
28380	\N	\N	\N	
28381	\N	\N	\N	
28382	\N	\N	\N	
28383	\N	\N	\N	
28384	\N	\N	\N	
28385	\N	\N	\N	
28386	\N	\N	\N	
28387	\N	\N	\N	
28388	\N	\N	\N	
28389	\N	\N	\N	
28390	\N	\N	\N	
28391	\N	\N	\N	
28392	\N	\N	\N	
28393	\N	\N	\N	
28394	\N	\N	\N	
28395	\N	\N	\N	
28396	\N	\N	\N	
28397	\N	\N	\N	
28398	\N	\N	\N	
28399	\N	\N	\N	
28400	\N	\N	\N	
28401	\N	\N	\N	
28402	\N	\N	\N	
28403	\N	\N	\N	
28404	\N	\N	\N	
28405	\N	\N	\N	
28406	\N	\N	\N	
28407	\N	\N	\N	
28408	\N	\N	\N	
28409	\N	\N	\N	
28410	\N	\N	\N	
28411	\N	\N	\N	
28412	\N	\N	\N	
28413	\N	\N	\N	
28414	\N	\N	\N	
28415	\N	\N	\N	
28416	\N	\N	\N	
28417	\N	\N	\N	
28418	\N	\N	\N	
28419	\N	\N	\N	
28420	\N	\N	\N	
28421	\N	\N	\N	
28422	\N	\N	\N	
28423	\N	\N	\N	
28424	\N	\N	\N	
28425	\N	\N	\N	
28426	\N	\N	\N	
28427	\N	\N	\N	
28428	\N	\N	\N	
28429	\N	\N	\N	
28430	\N	\N	\N	
28431	\N	\N	\N	
28432	\N	\N	\N	
28433	\N	\N	\N	
28434	\N	\N	\N	
28435	\N	\N	\N	
28436	\N	\N	\N	
28437	\N	\N	\N	
28438	\N	\N	\N	
28439	\N	\N	\N	
28440	\N	\N	\N	
28441	\N	\N	\N	
28442	\N	\N	\N	
28443	\N	\N	\N	
28444	\N	\N	\N	
28445	\N	\N	\N	
28446	\N	\N	\N	
28447	\N	\N	\N	
28448	\N	\N	\N	
28449	\N	\N	\N	
28450	\N	\N	\N	
28451	\N	\N	\N	
28452	\N	\N	\N	
28453	\N	\N	\N	
28454	\N	\N	\N	
28455	\N	\N	\N	
28456	\N	\N	\N	
28457	\N	\N	\N	
28458	\N	\N	\N	
28459	\N	\N	\N	
28460	\N	\N	\N	
28461	\N	\N	\N	
28462	\N	\N	\N	
28463	\N	\N	\N	
28464	\N	\N	\N	
28465	\N	\N	\N	
28466	\N	\N	\N	
28467	\N	\N	\N	
28468	\N	\N	\N	
28469	\N	\N	\N	
28470	\N	\N	\N	
28471	\N	\N	\N	
28472	\N	\N	\N	
28473	\N	\N	\N	
28474	\N	\N	\N	
28475	\N	\N	\N	
28476	\N	\N	\N	
28477	\N	\N	\N	
28478	\N	\N	\N	
28479	\N	\N	\N	
28480	\N	\N	\N	
28481	\N	\N	\N	
28482	\N	\N	\N	
28483	\N	\N	\N	
28484	\N	\N	\N	
28485	\N	\N	\N	
28486	\N	\N	\N	
28487	\N	\N	\N	
28488	\N	\N	\N	
28489	\N	\N	\N	
28490	\N	\N	\N	
28491	\N	\N	\N	
28492	\N	\N	\N	
28493	\N	\N	\N	
28494	\N	\N	\N	
28495	\N	\N	\N	
28496	\N	\N	\N	
28497	\N	\N	\N	
28498	\N	\N	\N	
28499	\N	\N	\N	
28500	\N	\N	\N	
28501	\N	\N	\N	
28502	\N	\N	\N	
28503	\N	\N	\N	
28504	\N	\N	\N	
28505	\N	\N	\N	
28506	\N	\N	\N	
28507	\N	\N	\N	
28508	\N	\N	\N	
28509	\N	\N	\N	
28510	\N	\N	\N	
28511	\N	\N	\N	
28512	\N	\N	\N	
28513	\N	\N	\N	
28514	\N	\N	\N	
28515	\N	\N	\N	
28516	\N	\N	\N	
28517	\N	\N	\N	
28518	\N	\N	\N	
28519	\N	\N	\N	
28520	\N	\N	\N	
28521	\N	\N	\N	
28522	\N	\N	\N	
28523	\N	\N	\N	
28524	\N	\N	\N	
28525	\N	\N	\N	
28526	\N	\N	\N	
28527	\N	\N	\N	
28528	\N	\N	\N	
28529	\N	\N	\N	
28530	\N	\N	\N	
28531	\N	\N	\N	
28532	\N	\N	\N	
28533	\N	\N	\N	
28534	\N	\N	\N	
28535	\N	\N	\N	
28536	\N	\N	\N	
28537	\N	\N	\N	
28538	\N	\N	\N	
28539	\N	\N	\N	
28540	\N	\N	\N	
28541	\N	\N	\N	
28542	\N	\N	\N	
28543	\N	\N	\N	
28544	\N	\N	\N	
28545	\N	\N	\N	
28546	\N	\N	\N	
28547	\N	\N	\N	
28548	\N	\N	\N	
28549	\N	\N	\N	
28550	\N	\N	\N	
28551	\N	\N	\N	
28552	\N	\N	\N	
28553	\N	\N	\N	
28554	\N	\N	\N	
28555	\N	\N	\N	
28556	\N	\N	\N	
28557	\N	\N	\N	
28558	\N	\N	\N	
28559	\N	\N	\N	
28560	\N	\N	\N	
28561	\N	\N	\N	
28562	\N	\N	\N	
28563	\N	\N	\N	
28564	\N	\N	\N	
28565	\N	\N	\N	
28566	\N	\N	\N	
28567	\N	\N	\N	
28568	\N	\N	\N	
28569	\N	\N	\N	
28570	\N	\N	\N	
28571	\N	\N	\N	
28572	\N	\N	\N	
28573	\N	\N	\N	
28574	\N	\N	\N	
28575	\N	\N	\N	
28576	\N	\N	\N	
28577	\N	\N	\N	
28578	\N	\N	\N	
28579	\N	\N	\N	
28580	\N	\N	\N	
28581	\N	\N	\N	
28582	\N	\N	\N	
28583	\N	\N	\N	
28584	\N	\N	\N	
28585	\N	\N	\N	
28586	\N	\N	\N	
28587	\N	\N	\N	
28588	\N	\N	\N	
28589	\N	\N	\N	
28590	\N	\N	\N	
28591	\N	\N	\N	
28592	\N	\N	\N	
28593	\N	\N	\N	
28594	\N	\N	\N	
28595	\N	\N	\N	
28596	\N	\N	\N	
28597	\N	\N	\N	
28598	\N	\N	\N	
28599	\N	\N	\N	
28600	\N	\N	\N	
28601	\N	\N	\N	
28602	\N	\N	\N	
28603	\N	\N	\N	
28604	\N	\N	\N	
28605	\N	\N	\N	
28606	\N	\N	\N	
28607	\N	\N	\N	
28608	\N	\N	\N	
28609	\N	\N	\N	
28610	\N	\N	\N	
28611	\N	\N	\N	
28612	\N	\N	\N	
28613	\N	\N	\N	
28614	\N	\N	\N	
28615	\N	\N	\N	
28616	\N	\N	\N	
28617	\N	\N	\N	
28618	\N	\N	\N	
28619	\N	\N	\N	
28620	\N	\N	\N	
28621	\N	\N	\N	
28622	\N	\N	\N	
28623	\N	\N	\N	
28624	\N	\N	\N	
28625	\N	\N	\N	
28626	\N	\N	\N	
28627	\N	\N	\N	
28628	\N	\N	\N	
28629	\N	\N	\N	
28630	\N	\N	\N	
28631	\N	\N	\N	
28632	\N	\N	\N	
28633	\N	\N	\N	
28634	\N	\N	\N	
28635	\N	\N	\N	
28636	\N	\N	\N	
28637	\N	\N	\N	
28638	\N	\N	\N	
28639	\N	\N	\N	
28640	\N	\N	\N	
28641	\N	\N	\N	
28642	\N	\N	\N	
28643	\N	\N	\N	
28644	\N	\N	\N	
28645	\N	\N	\N	
28646	\N	\N	\N	
28647	\N	\N	\N	
28648	\N	\N	\N	
28649	\N	\N	\N	
28650	\N	\N	\N	
28651	\N	\N	\N	
28652	\N	\N	\N	
28653	\N	\N	\N	
28654	\N	\N	\N	
28655	\N	\N	\N	
28656	\N	\N	\N	
28657	\N	\N	\N	
28658	\N	\N	\N	
28659	\N	\N	\N	
28660	\N	\N	\N	
28661	\N	\N	\N	
28662	\N	\N	\N	
28663	\N	\N	\N	
28664	\N	\N	\N	
28665	\N	\N	\N	
28666	\N	\N	\N	
28667	\N	\N	\N	
28668	\N	\N	\N	
28669	\N	\N	\N	
28670	\N	\N	\N	
28671	\N	\N	\N	
28672	\N	\N	\N	
28673	\N	\N	\N	
28674	\N	\N	\N	
28675	\N	\N	\N	
28676	\N	\N	\N	
28677	\N	\N	\N	
28678	\N	\N	\N	
28679	\N	\N	\N	
28680	\N	\N	\N	
28681	\N	\N	\N	
28682	\N	\N	\N	
28683	\N	\N	\N	
28684	\N	\N	\N	
28685	\N	\N	\N	
28686	\N	\N	\N	
28687	\N	\N	\N	
28688	\N	\N	\N	
28689	\N	\N	\N	
28690	\N	\N	\N	
28691	\N	\N	\N	
28692	\N	\N	\N	
28693	\N	\N	\N	
28694	\N	\N	\N	
28695	\N	\N	\N	
28696	\N	\N	\N	
28697	\N	\N	\N	
28698	\N	\N	\N	
28699	\N	\N	\N	
28700	\N	\N	\N	
28701	\N	\N	\N	
28702	\N	\N	\N	
28703	\N	\N	\N	
28704	\N	\N	\N	
28705	\N	\N	\N	
28706	\N	\N	\N	
28707	\N	\N	\N	
28708	\N	\N	\N	
28709	\N	\N	\N	
28710	\N	\N	\N	
28711	\N	\N	\N	
28712	\N	\N	\N	
28713	\N	\N	\N	
28714	\N	\N	\N	
28715	\N	\N	\N	
28716	\N	\N	\N	
28717	\N	\N	\N	
28718	\N	\N	\N	
28719	\N	\N	\N	
28720	\N	\N	\N	
28721	\N	\N	\N	
28722	\N	\N	\N	
28723	\N	\N	\N	
28724	\N	\N	\N	
28725	\N	\N	\N	
28726	\N	\N	\N	
28727	\N	\N	\N	
28728	\N	\N	\N	
28729	\N	\N	\N	
28730	\N	\N	\N	
28731	\N	\N	\N	
28732	\N	\N	\N	
28733	\N	\N	\N	
28734	\N	\N	\N	
28735	\N	\N	\N	
28736	\N	\N	\N	
28737	\N	\N	\N	
28738	\N	\N	\N	
28739	\N	\N	\N	
28740	\N	\N	\N	
28741	\N	\N	\N	
28742	\N	\N	\N	
28743	\N	\N	\N	
28744	\N	\N	\N	
28745	\N	\N	\N	
28746	\N	\N	\N	
28747	\N	\N	\N	
28748	\N	\N	\N	
28749	\N	\N	\N	
28750	\N	\N	\N	
28751	\N	\N	\N	
28752	\N	\N	\N	
28753	\N	\N	\N	
28754	\N	\N	\N	
28755	\N	\N	\N	
28756	\N	\N	\N	
28757	\N	\N	\N	
28758	\N	\N	\N	
28759	\N	\N	\N	
28760	\N	\N	\N	
28761	\N	\N	\N	
28762	\N	\N	\N	
28763	\N	\N	\N	
28764	\N	\N	\N	
28765	\N	\N	\N	
28766	\N	\N	\N	
28767	\N	\N	\N	
28768	\N	\N	\N	
28769	\N	\N	\N	
28770	\N	\N	\N	
28771	\N	\N	\N	
28772	\N	\N	\N	
28773	\N	\N	\N	
28774	\N	\N	\N	
28775	\N	\N	\N	
28776	\N	\N	\N	
28777	\N	\N	\N	
28778	\N	\N	\N	
28779	\N	\N	\N	
28780	\N	\N	\N	
28781	\N	\N	\N	
28782	\N	\N	\N	
28783	\N	\N	\N	
28784	\N	\N	\N	
28785	\N	\N	\N	
28786	\N	\N	\N	
28787	\N	\N	\N	
28788	\N	\N	\N	
28789	\N	\N	\N	
28790	\N	\N	\N	
28791	\N	\N	\N	
28792	\N	\N	\N	
28793	\N	\N	\N	
28794	\N	\N	\N	
28795	\N	\N	\N	
28796	\N	\N	\N	
28797	\N	\N	\N	
28798	\N	\N	\N	
28799	\N	\N	\N	
28800	\N	\N	\N	
28801	\N	\N	\N	
28802	\N	\N	\N	
28803	\N	\N	\N	
28804	\N	\N	\N	
28805	\N	\N	\N	
28806	\N	\N	\N	
28807	\N	\N	\N	
28808	\N	\N	\N	
28809	\N	\N	\N	
28810	\N	\N	\N	
28811	\N	\N	\N	
28812	\N	\N	\N	
28813	\N	\N	\N	
28814	\N	\N	\N	
28815	\N	\N	\N	
28816	\N	\N	\N	
28817	\N	\N	\N	
28818	\N	\N	\N	
28819	\N	\N	\N	
28820	\N	\N	\N	
28821	\N	\N	\N	
28822	\N	\N	\N	
28823	\N	\N	\N	
28824	\N	\N	\N	
28825	\N	\N	\N	
28826	\N	\N	\N	
28827	\N	\N	\N	
28828	\N	\N	\N	
28829	\N	\N	\N	
28830	\N	\N	\N	
28831	\N	\N	\N	
28832	\N	\N	\N	
28833	\N	\N	\N	
28834	\N	\N	\N	
28835	\N	\N	\N	
28836	\N	\N	\N	
28837	\N	\N	\N	
28838	\N	\N	\N	
28839	\N	\N	\N	
28840	\N	\N	\N	
28841	\N	\N	\N	
28842	\N	\N	\N	
28843	\N	\N	\N	
28844	\N	\N	\N	
28845	\N	\N	\N	
28846	\N	\N	\N	
28847	\N	\N	\N	
28848	\N	\N	\N	
28849	\N	\N	\N	
28850	\N	\N	\N	
28851	\N	\N	\N	
28852	\N	\N	\N	
28853	\N	\N	\N	
28854	\N	\N	\N	
28855	\N	\N	\N	
28856	\N	\N	\N	
28857	\N	\N	\N	
28858	\N	\N	\N	
28859	\N	\N	\N	
28860	\N	\N	\N	
28861	\N	\N	\N	
28862	\N	\N	\N	
28863	\N	\N	\N	
28864	\N	\N	\N	
28865	\N	\N	\N	
28866	\N	\N	\N	
28867	\N	\N	\N	
28868	\N	\N	\N	
28869	\N	\N	\N	
28870	\N	\N	\N	
28871	\N	\N	\N	
28872	\N	\N	\N	
28873	\N	\N	\N	
28874	\N	\N	\N	
28875	\N	\N	\N	
28876	\N	\N	\N	
28877	\N	\N	\N	
28878	\N	\N	\N	
28879	\N	\N	\N	
28880	\N	\N	\N	
28881	\N	\N	\N	
28882	\N	\N	\N	
28883	\N	\N	\N	
28884	\N	\N	\N	
28885	\N	\N	\N	
28886	\N	\N	\N	
28887	\N	\N	\N	
28888	\N	\N	\N	
28889	\N	\N	\N	
28890	\N	\N	\N	
28891	\N	\N	\N	
28892	\N	\N	\N	
28893	\N	\N	\N	
28894	\N	\N	\N	
28895	\N	\N	\N	
28896	\N	\N	\N	
28897	\N	\N	\N	
28898	\N	\N	\N	
28899	\N	\N	\N	
28900	\N	\N	\N	
28901	\N	\N	\N	
28902	\N	\N	\N	
28903	\N	\N	\N	
28904	\N	\N	\N	
28905	\N	\N	\N	
28906	\N	\N	\N	
28907	\N	\N	\N	
28908	\N	\N	\N	
28909	\N	\N	\N	
28910	\N	\N	\N	
28911	\N	\N	\N	
28912	\N	\N	\N	
28913	\N	\N	\N	
28914	\N	\N	\N	
28915	\N	\N	\N	
28916	\N	\N	\N	
28917	\N	\N	\N	
28918	\N	\N	\N	
28919	\N	\N	\N	
28920	\N	\N	\N	
28921	\N	\N	\N	
28922	\N	\N	\N	
28923	\N	\N	\N	
28924	\N	\N	\N	
28925	\N	\N	\N	
28926	\N	\N	\N	
28927	\N	\N	\N	
28928	\N	\N	\N	
28929	\N	\N	\N	
28930	\N	\N	\N	
28931	\N	\N	\N	
28932	\N	\N	\N	
28933	\N	\N	\N	
28934	\N	\N	\N	
28935	\N	\N	\N	
28936	\N	\N	\N	
28937	\N	\N	\N	
28938	\N	\N	\N	
28939	\N	\N	\N	
28940	\N	\N	\N	
28941	\N	\N	\N	
28942	\N	\N	\N	
28943	\N	\N	\N	
28944	\N	\N	\N	
28945	\N	\N	\N	
28946	\N	\N	\N	
28947	\N	\N	\N	
28948	\N	\N	\N	
28949	\N	\N	\N	
28950	\N	\N	\N	
28951	\N	\N	\N	
28952	\N	\N	\N	
28953	\N	\N	\N	
28954	\N	\N	\N	
28955	\N	\N	\N	
28956	\N	\N	\N	
28957	\N	\N	\N	
28958	\N	\N	\N	
28959	\N	\N	\N	
28960	\N	\N	\N	
28961	\N	\N	\N	
28962	\N	\N	\N	
28963	\N	\N	\N	
28964	\N	\N	\N	
28965	\N	\N	\N	
28966	\N	\N	\N	
28967	\N	\N	\N	
28968	\N	\N	\N	
28969	\N	\N	\N	
28970	\N	\N	\N	
28971	\N	\N	\N	
28972	\N	\N	\N	
28973	\N	\N	\N	
28974	\N	\N	\N	
28975	\N	\N	\N	
28976	\N	\N	\N	
28977	\N	\N	\N	
28978	\N	\N	\N	
28979	\N	\N	\N	
28980	\N	\N	\N	
28981	\N	\N	\N	
28982	\N	\N	\N	
28983	\N	\N	\N	
28984	\N	\N	\N	
28985	\N	\N	\N	
28986	\N	\N	\N	
28987	\N	\N	\N	
28988	\N	\N	\N	
28989	\N	\N	\N	
28990	\N	\N	\N	
28991	\N	\N	\N	
28992	\N	\N	\N	
28993	\N	\N	\N	
28994	\N	\N	\N	
28995	\N	\N	\N	
28996	\N	\N	\N	
28997	\N	\N	\N	
28998	\N	\N	\N	
28999	\N	\N	\N	
29000	\N	\N	\N	
29001	\N	\N	\N	
29002	\N	\N	\N	
29003	\N	\N	\N	
29004	\N	\N	\N	
29005	\N	\N	\N	
29006	\N	\N	\N	
29007	\N	\N	\N	
29008	\N	\N	\N	
29009	\N	\N	\N	
29010	\N	\N	\N	
29011	\N	\N	\N	
29012	\N	\N	\N	
29013	\N	\N	\N	
29014	\N	\N	\N	
29015	\N	\N	\N	
29016	\N	\N	\N	
29017	\N	\N	\N	
29018	\N	\N	\N	
29019	\N	\N	\N	
29020	\N	\N	\N	
29021	\N	\N	\N	
29022	\N	\N	\N	
29023	\N	\N	\N	
29024	\N	\N	\N	
29025	\N	\N	\N	
29026	\N	\N	\N	
29027	\N	\N	\N	
29028	\N	\N	\N	
29029	\N	\N	\N	
29030	\N	\N	\N	
29031	\N	\N	\N	
29032	\N	\N	\N	
29033	\N	\N	\N	
29034	\N	\N	\N	
29035	\N	\N	\N	
29036	\N	\N	\N	
29037	\N	\N	\N	
29038	\N	\N	\N	
29039	\N	\N	\N	
29040	\N	\N	\N	
29041	\N	\N	\N	
29042	\N	\N	\N	
29043	\N	\N	\N	
29044	\N	\N	\N	
29045	\N	\N	\N	
29046	\N	\N	\N	
29047	\N	\N	\N	
29048	\N	\N	\N	
29049	\N	\N	\N	
29050	\N	\N	\N	
29051	\N	\N	\N	
29052	\N	\N	\N	
29053	\N	\N	\N	
29054	\N	\N	\N	
29055	\N	\N	\N	
29056	\N	\N	\N	
29057	\N	\N	\N	
29058	\N	\N	\N	
29059	\N	\N	\N	
29060	\N	\N	\N	
29061	\N	\N	\N	
29062	\N	\N	\N	
29063	\N	\N	\N	
29064	\N	\N	\N	
29065	\N	\N	\N	
29066	\N	\N	\N	
29067	\N	\N	\N	
29068	\N	\N	\N	
29069	\N	\N	\N	
29070	\N	\N	\N	
29071	\N	\N	\N	
29072	\N	\N	\N	
29073	\N	\N	\N	
29074	\N	\N	\N	
29075	\N	\N	\N	
29076	\N	\N	\N	
29077	\N	\N	\N	
29078	\N	\N	\N	
29079	\N	\N	\N	
29080	\N	\N	\N	
29081	\N	\N	\N	
29082	\N	\N	\N	
29083	\N	\N	\N	
29084	\N	\N	\N	
29085	\N	\N	\N	
29086	\N	\N	\N	
29087	\N	\N	\N	
29088	\N	\N	\N	
29089	\N	\N	\N	
29090	\N	\N	\N	
29091	\N	\N	\N	
29092	\N	\N	\N	
29093	\N	\N	\N	
29094	\N	\N	\N	
29095	\N	\N	\N	
29096	\N	\N	\N	
29097	\N	\N	\N	
29098	\N	\N	\N	
29099	\N	\N	\N	
29100	\N	\N	\N	
29101	\N	\N	\N	
29102	\N	\N	\N	
29103	\N	\N	\N	
29104	\N	\N	\N	
29105	\N	\N	\N	
29106	\N	\N	\N	
29107	\N	\N	\N	
29108	\N	\N	\N	
29109	\N	\N	\N	
29110	\N	\N	\N	
29111	\N	\N	\N	
29112	\N	\N	\N	
29113	\N	\N	\N	
29114	\N	\N	\N	
29115	\N	\N	\N	
29116	\N	\N	\N	
29117	\N	\N	\N	
29118	\N	\N	\N	
29119	\N	\N	\N	
29120	\N	\N	\N	
29121	\N	\N	\N	
29122	\N	\N	\N	
29123	\N	\N	\N	
29124	\N	\N	\N	
29125	\N	\N	\N	
29126	\N	\N	\N	
29127	\N	\N	\N	
29128	\N	\N	\N	
29129	\N	\N	\N	
29130	\N	\N	\N	
29131	\N	\N	\N	
29132	\N	\N	\N	
29133	\N	\N	\N	
29134	\N	\N	\N	
29135	\N	\N	\N	
29136	\N	\N	\N	
29137	\N	\N	\N	
29138	\N	\N	\N	
29139	\N	\N	\N	
29140	\N	\N	\N	
29141	\N	\N	\N	
29142	\N	\N	\N	
29143	\N	\N	\N	
29144	\N	\N	\N	
29145	\N	\N	\N	
29146	\N	\N	\N	
29147	\N	\N	\N	
29148	\N	\N	\N	
29149	\N	\N	\N	
29150	\N	\N	\N	
29151	\N	\N	\N	
29152	\N	\N	\N	
29153	\N	\N	\N	
29154	\N	\N	\N	
29155	\N	\N	\N	
29156	\N	\N	\N	
29157	\N	\N	\N	
29158	\N	\N	\N	
29159	\N	\N	\N	
29160	\N	\N	\N	
29161	\N	\N	\N	
29162	\N	\N	\N	
29163	\N	\N	\N	
29164	\N	\N	\N	
29165	\N	\N	\N	
29166	\N	\N	\N	
29167	\N	\N	\N	
29168	\N	\N	\N	
29169	\N	\N	\N	
29170	\N	\N	\N	
29171	\N	\N	\N	
29172	\N	\N	\N	
29173	\N	\N	\N	
29174	\N	\N	\N	
29175	\N	\N	\N	
29176	\N	\N	\N	
29177	\N	\N	\N	
29178	\N	\N	\N	
29179	\N	\N	\N	
29180	\N	\N	\N	
29181	\N	\N	\N	
29182	\N	\N	\N	
29183	\N	\N	\N	
29184	\N	\N	\N	
29185	\N	\N	\N	
29186	\N	\N	\N	
29187	\N	\N	\N	
29188	\N	\N	\N	
29189	\N	\N	\N	
29190	\N	\N	\N	
29191	\N	\N	\N	
29192	\N	\N	\N	
29193	\N	\N	\N	
29194	\N	\N	\N	
29195	\N	\N	\N	
29196	\N	\N	\N	
29197	\N	\N	\N	
29198	\N	\N	\N	
29199	\N	\N	\N	
29200	\N	\N	\N	
29201	\N	\N	\N	
29202	\N	\N	\N	
29203	\N	\N	\N	
29204	\N	\N	\N	
29205	\N	\N	\N	
29206	\N	\N	\N	
29207	\N	\N	\N	
29208	\N	\N	\N	
29209	\N	\N	\N	
29210	\N	\N	\N	
29211	\N	\N	\N	
29212	\N	\N	\N	
29213	\N	\N	\N	
29214	\N	\N	\N	
29215	\N	\N	\N	
29216	\N	\N	\N	
29217	\N	\N	\N	
29218	\N	\N	\N	
29219	\N	\N	\N	
29220	\N	\N	\N	
29221	\N	\N	\N	
29222	\N	\N	\N	
29223	\N	\N	\N	
29224	\N	\N	\N	
29225	\N	\N	\N	
29226	\N	\N	\N	
29227	\N	\N	\N	
29228	\N	\N	\N	
29229	\N	\N	\N	
29230	\N	\N	\N	
29231	\N	\N	\N	
29232	\N	\N	\N	
29233	\N	\N	\N	
29234	\N	\N	\N	
29235	\N	\N	\N	
29236	\N	\N	\N	
29237	\N	\N	\N	
29238	\N	\N	\N	
29239	\N	\N	\N	
29240	\N	\N	\N	
29241	\N	\N	\N	
29242	\N	\N	\N	
29243	\N	\N	\N	
29244	\N	\N	\N	
29245	\N	\N	\N	
29246	\N	\N	\N	
29247	\N	\N	\N	
29248	\N	\N	\N	
29249	\N	\N	\N	
29250	\N	\N	\N	
29251	\N	\N	\N	
29252	\N	\N	\N	
29253	\N	\N	\N	
29254	\N	\N	\N	
29255	\N	\N	\N	
29256	\N	\N	\N	
29257	\N	\N	\N	
29258	\N	\N	\N	
29259	\N	\N	\N	
29260	\N	\N	\N	
29261	\N	\N	\N	
29262	\N	\N	\N	
29263	\N	\N	\N	
29264	\N	\N	\N	
29265	\N	\N	\N	
29266	\N	\N	\N	
29267	\N	\N	\N	
29268	\N	\N	\N	
29269	\N	\N	\N	
29270	\N	\N	\N	
29271	\N	\N	\N	
29272	\N	\N	\N	
29273	\N	\N	\N	
29274	\N	\N	\N	
29275	\N	\N	\N	
29276	\N	\N	\N	
29277	\N	\N	\N	
29278	\N	\N	\N	
29279	\N	\N	\N	
29280	\N	\N	\N	
29281	\N	\N	\N	
29282	\N	\N	\N	
29283	\N	\N	\N	
29284	\N	\N	\N	
29285	\N	\N	\N	
29286	\N	\N	\N	
29287	\N	\N	\N	
29288	\N	\N	\N	
29289	\N	\N	\N	
29290	\N	\N	\N	
29291	\N	\N	\N	
29292	\N	\N	\N	
29293	\N	\N	\N	
29294	\N	\N	\N	
29295	\N	\N	\N	
29296	\N	\N	\N	
29297	\N	\N	\N	
29298	\N	\N	\N	
29299	\N	\N	\N	
29300	\N	\N	\N	
29301	\N	\N	\N	
29302	\N	\N	\N	
29303	\N	\N	\N	
29304	\N	\N	\N	
29305	\N	\N	\N	
29306	\N	\N	\N	
29307	\N	\N	\N	
29308	\N	\N	\N	
29309	\N	\N	\N	
29310	\N	\N	\N	
29311	\N	\N	\N	
29312	\N	\N	\N	
29313	\N	\N	\N	
29314	\N	\N	\N	
29315	\N	\N	\N	
29316	\N	\N	\N	
29317	\N	\N	\N	
29318	\N	\N	\N	
29319	\N	\N	\N	
29320	\N	\N	\N	
29321	\N	\N	\N	
29322	\N	\N	\N	
29323	\N	\N	\N	
29324	\N	\N	\N	
29325	\N	\N	\N	
29326	\N	\N	\N	
29327	\N	\N	\N	
29328	\N	\N	\N	
29329	\N	\N	\N	
29330	\N	\N	\N	
29331	\N	\N	\N	
29332	\N	\N	\N	
29333	\N	\N	\N	
29334	\N	\N	\N	
29335	\N	\N	\N	
29336	\N	\N	\N	
29337	\N	\N	\N	
29338	\N	\N	\N	
29339	\N	\N	\N	
29340	\N	\N	\N	
29341	\N	\N	\N	
29342	\N	\N	\N	
29343	\N	\N	\N	
29344	\N	\N	\N	
29345	\N	\N	\N	
29346	\N	\N	\N	
29347	\N	\N	\N	
29348	\N	\N	\N	
29349	\N	\N	\N	
29350	\N	\N	\N	
29351	\N	\N	\N	
29352	\N	\N	\N	
29353	\N	\N	\N	
29354	\N	\N	\N	
29355	\N	\N	\N	
29356	\N	\N	\N	
29357	\N	\N	\N	
29358	\N	\N	\N	
29359	\N	\N	\N	
29360	\N	\N	\N	
29361	\N	\N	\N	
29362	\N	\N	\N	
29363	\N	\N	\N	
29364	\N	\N	\N	
29365	\N	\N	\N	
29366	\N	\N	\N	
29367	\N	\N	\N	
29368	\N	\N	\N	
29369	\N	\N	\N	
29370	\N	\N	\N	
29371	\N	\N	\N	
29372	\N	\N	\N	
29373	\N	\N	\N	
29374	\N	\N	\N	
29375	\N	\N	\N	
29376	\N	\N	\N	
29377	\N	\N	\N	
29378	\N	\N	\N	
29379	\N	\N	\N	
29380	\N	\N	\N	
29381	\N	\N	\N	
29382	\N	\N	\N	
29383	\N	\N	\N	
29384	\N	\N	\N	
29385	\N	\N	\N	
29386	\N	\N	\N	
29387	\N	\N	\N	
29388	\N	\N	\N	
29389	\N	\N	\N	
29390	\N	\N	\N	
29391	\N	\N	\N	
29392	\N	\N	\N	
29393	\N	\N	\N	
29394	\N	\N	\N	
29395	\N	\N	\N	
29396	\N	\N	\N	
29397	\N	\N	\N	
29398	\N	\N	\N	
29399	\N	\N	\N	
29400	\N	\N	\N	
29401	\N	\N	\N	
29402	\N	\N	\N	
29403	\N	\N	\N	
29404	\N	\N	\N	
29405	\N	\N	\N	
29406	\N	\N	\N	
29407	\N	\N	\N	
29408	\N	\N	\N	
29409	\N	\N	\N	
29410	\N	\N	\N	
29411	\N	\N	\N	
29412	\N	\N	\N	
29413	\N	\N	\N	
29414	\N	\N	\N	
29415	\N	\N	\N	
29416	\N	\N	\N	
29417	\N	\N	\N	
29418	\N	\N	\N	
29419	\N	\N	\N	
29420	\N	\N	\N	
29421	\N	\N	\N	
29422	\N	\N	\N	
29423	\N	\N	\N	
29424	\N	\N	\N	
29425	\N	\N	\N	
29426	\N	\N	\N	
29427	\N	\N	\N	
29428	\N	\N	\N	
29429	\N	\N	\N	
29430	\N	\N	\N	
29431	\N	\N	\N	
29432	\N	\N	\N	
29433	\N	\N	\N	
29434	\N	\N	\N	
29435	\N	\N	\N	
29436	\N	\N	\N	
29437	\N	\N	\N	
29438	\N	\N	\N	
29439	\N	\N	\N	
29440	\N	\N	\N	
29441	\N	\N	\N	
29442	\N	\N	\N	
29443	\N	\N	\N	
29444	\N	\N	\N	
29445	\N	\N	\N	
29446	\N	\N	\N	
29447	\N	\N	\N	
29448	\N	\N	\N	
29449	\N	\N	\N	
29450	\N	\N	\N	
29451	\N	\N	\N	
29452	\N	\N	\N	
29453	\N	\N	\N	
29454	\N	\N	\N	
29455	\N	\N	\N	
29456	\N	\N	\N	
29457	\N	\N	\N	
29458	\N	\N	\N	
29459	\N	\N	\N	
29460	\N	\N	\N	
29461	\N	\N	\N	
29462	\N	\N	\N	
29463	\N	\N	\N	
29464	\N	\N	\N	
29465	\N	\N	\N	
29466	\N	\N	\N	
29467	\N	\N	\N	
29468	\N	\N	\N	
29469	\N	\N	\N	
29470	\N	\N	\N	
29471	\N	\N	\N	
29472	\N	\N	\N	
29473	\N	\N	\N	
29474	\N	\N	\N	
29475	\N	\N	\N	
29476	\N	\N	\N	
29477	\N	\N	\N	
29478	\N	\N	\N	
29479	\N	\N	\N	
29480	\N	\N	\N	
29481	\N	\N	\N	
29482	\N	\N	\N	
29483	\N	\N	\N	
29484	\N	\N	\N	
29485	\N	\N	\N	
29486	\N	\N	\N	
29487	\N	\N	\N	
29488	\N	\N	\N	
29489	\N	\N	\N	
29490	\N	\N	\N	
29491	\N	\N	\N	
29492	\N	\N	\N	
29493	\N	\N	\N	
29494	\N	\N	\N	
29495	\N	\N	\N	
29496	\N	\N	\N	
29497	\N	\N	\N	
29498	\N	\N	\N	
29499	\N	\N	\N	
29500	\N	\N	\N	
29501	\N	\N	\N	
29502	\N	\N	\N	
29503	\N	\N	\N	
29504	\N	\N	\N	
29505	\N	\N	\N	
29506	\N	\N	\N	
29507	\N	\N	\N	
29508	\N	\N	\N	
29509	\N	\N	\N	
29510	\N	\N	\N	
29511	\N	\N	\N	
29512	\N	\N	\N	
29513	\N	\N	\N	
29514	\N	\N	\N	
29515	\N	\N	\N	
29516	\N	\N	\N	
29517	\N	\N	\N	
29518	\N	\N	\N	
29519	\N	\N	\N	
29520	\N	\N	\N	
29521	\N	\N	\N	
29522	\N	\N	\N	
29523	\N	\N	\N	
29524	\N	\N	\N	
29525	\N	\N	\N	
29526	\N	\N	\N	
29527	\N	\N	\N	
29528	\N	\N	\N	
29529	\N	\N	\N	
29530	\N	\N	\N	
29531	\N	\N	\N	
29532	\N	\N	\N	
29533	\N	\N	\N	
29534	\N	\N	\N	
29535	\N	\N	\N	
29536	\N	\N	\N	
29537	\N	\N	\N	
29538	\N	\N	\N	
29539	\N	\N	\N	
29540	\N	\N	\N	
29541	\N	\N	\N	
29542	\N	\N	\N	
29543	\N	\N	\N	
29544	\N	\N	\N	
29545	\N	\N	\N	
29546	\N	\N	\N	
29547	\N	\N	\N	
29548	\N	\N	\N	
29549	\N	\N	\N	
29550	\N	\N	\N	
29551	\N	\N	\N	
29552	\N	\N	\N	
29553	\N	\N	\N	
29554	\N	\N	\N	
29555	\N	\N	\N	
29556	\N	\N	\N	
29557	\N	\N	\N	
29558	\N	\N	\N	
29559	\N	\N	\N	
29560	\N	\N	\N	
29561	\N	\N	\N	
29562	\N	\N	\N	
29563	\N	\N	\N	
29564	\N	\N	\N	
29565	\N	\N	\N	
29566	\N	\N	\N	
29567	\N	\N	\N	
29568	\N	\N	\N	
29569	\N	\N	\N	
29570	\N	\N	\N	
29571	\N	\N	\N	
29572	\N	\N	\N	
29573	\N	\N	\N	
29574	\N	\N	\N	
29575	\N	\N	\N	
29576	\N	\N	\N	
29577	\N	\N	\N	
29578	\N	\N	\N	
29579	\N	\N	\N	
29580	\N	\N	\N	
29581	\N	\N	\N	
29582	\N	\N	\N	
29583	\N	\N	\N	
29584	\N	\N	\N	
29585	\N	\N	\N	
29586	\N	\N	\N	
29587	\N	\N	\N	
29588	\N	\N	\N	
29589	\N	\N	\N	
29590	\N	\N	\N	
29591	\N	\N	\N	
29592	\N	\N	\N	
29593	\N	\N	\N	
29594	\N	\N	\N	
29595	\N	\N	\N	
29596	\N	\N	\N	
29597	\N	\N	\N	
29598	\N	\N	\N	
29599	\N	\N	\N	
29600	\N	\N	\N	
29601	\N	\N	\N	
29602	\N	\N	\N	
29603	\N	\N	\N	
29604	\N	\N	\N	
29605	\N	\N	\N	
29606	\N	\N	\N	
29607	\N	\N	\N	
29608	\N	\N	\N	
29609	\N	\N	\N	
29610	\N	\N	\N	
29611	\N	\N	\N	
29612	\N	\N	\N	
29613	\N	\N	\N	
29614	\N	\N	\N	
29615	\N	\N	\N	
29616	\N	\N	\N	
29617	\N	\N	\N	
29618	\N	\N	\N	
29619	\N	\N	\N	
29620	\N	\N	\N	
29621	\N	\N	\N	
29622	\N	\N	\N	
29623	\N	\N	\N	
29624	\N	\N	\N	
29625	\N	\N	\N	
29626	\N	\N	\N	
29627	\N	\N	\N	
29628	\N	\N	\N	
29629	\N	\N	\N	
29630	\N	\N	\N	
29631	\N	\N	\N	
29632	\N	\N	\N	
29633	\N	\N	\N	
29634	\N	\N	\N	
29635	\N	\N	\N	
29636	\N	\N	\N	
29637	\N	\N	\N	
29638	\N	\N	\N	
29639	\N	\N	\N	
29640	\N	\N	\N	
29641	\N	\N	\N	
29642	\N	\N	\N	
29643	\N	\N	\N	
29644	\N	\N	\N	
29645	\N	\N	\N	
29646	\N	\N	\N	
29647	\N	\N	\N	
29648	\N	\N	\N	
29649	\N	\N	\N	
29650	\N	\N	\N	
29651	\N	\N	\N	
29652	\N	\N	\N	
29653	\N	\N	\N	
29654	\N	\N	\N	
29655	\N	\N	\N	
29656	\N	\N	\N	
29657	\N	\N	\N	
29658	\N	\N	\N	
29659	\N	\N	\N	
29660	\N	\N	\N	
29661	\N	\N	\N	
29662	\N	\N	\N	
29663	\N	\N	\N	
29664	\N	\N	\N	
29665	\N	\N	\N	
29666	\N	\N	\N	
29667	\N	\N	\N	
29668	\N	\N	\N	
29669	\N	\N	\N	
29670	\N	\N	\N	
29671	\N	\N	\N	
29672	\N	\N	\N	
29673	\N	\N	\N	
29674	\N	\N	\N	
29675	\N	\N	\N	
29676	\N	\N	\N	
29677	\N	\N	\N	
29678	\N	\N	\N	
29679	\N	\N	\N	
29680	\N	\N	\N	
29681	\N	\N	\N	
29682	\N	\N	\N	
29683	\N	\N	\N	
29684	\N	\N	\N	
29685	\N	\N	\N	
29686	\N	\N	\N	
29687	\N	\N	\N	
29688	\N	\N	\N	
29689	\N	\N	\N	
29690	\N	\N	\N	
29691	\N	\N	\N	
29692	\N	\N	\N	
29693	\N	\N	\N	
29694	\N	\N	\N	
29695	\N	\N	\N	
29696	\N	\N	\N	
29697	\N	\N	\N	
29698	\N	\N	\N	
29699	\N	\N	\N	
29700	\N	\N	\N	
29701	\N	\N	\N	
29702	\N	\N	\N	
29703	\N	\N	\N	
29704	\N	\N	\N	
29705	\N	\N	\N	
29706	\N	\N	\N	
29707	\N	\N	\N	
29708	\N	\N	\N	
29709	\N	\N	\N	
29710	\N	\N	\N	
29711	\N	\N	\N	
29712	\N	\N	\N	
29713	\N	\N	\N	
29714	\N	\N	\N	
29715	\N	\N	\N	
29716	\N	\N	\N	
29717	\N	\N	\N	
29718	\N	\N	\N	
29719	\N	\N	\N	
29720	\N	\N	\N	
29721	\N	\N	\N	
29722	\N	\N	\N	
29723	\N	\N	\N	
29724	\N	\N	\N	
29725	\N	\N	\N	
29726	\N	\N	\N	
29727	\N	\N	\N	
29728	\N	\N	\N	
29729	\N	\N	\N	
29730	\N	\N	\N	
29731	\N	\N	\N	
29732	\N	\N	\N	
29733	\N	\N	\N	
29734	\N	\N	\N	
29735	\N	\N	\N	
29736	\N	\N	\N	
29737	\N	\N	\N	
29738	\N	\N	\N	
29739	\N	\N	\N	
29740	\N	\N	\N	
29741	\N	\N	\N	
29742	\N	\N	\N	
29743	\N	\N	\N	
29744	\N	\N	\N	
29745	\N	\N	\N	
29746	\N	\N	\N	
29747	\N	\N	\N	
29748	\N	\N	\N	
29749	\N	\N	\N	
29750	\N	\N	\N	
29751	\N	\N	\N	
29752	\N	\N	\N	
29753	\N	\N	\N	
29754	\N	\N	\N	
29755	\N	\N	\N	
29756	\N	\N	\N	
29757	\N	\N	\N	
29758	\N	\N	\N	
29759	\N	\N	\N	
29760	\N	\N	\N	
29761	\N	\N	\N	
29762	\N	\N	\N	
29763	\N	\N	\N	
29764	\N	\N	\N	
29765	\N	\N	\N	
29766	\N	\N	\N	
29767	\N	\N	\N	
29768	\N	\N	\N	
29769	\N	\N	\N	
29770	\N	\N	\N	
29771	\N	\N	\N	
29772	\N	\N	\N	
29773	\N	\N	\N	
29774	\N	\N	\N	
29775	\N	\N	\N	
29776	\N	\N	\N	
29777	\N	\N	\N	
29778	\N	\N	\N	
29779	\N	\N	\N	
29780	\N	\N	\N	
29781	\N	\N	\N	
29782	\N	\N	\N	
29783	\N	\N	\N	
29784	\N	\N	\N	
29785	\N	\N	\N	
29786	\N	\N	\N	
29787	\N	\N	\N	
29788	\N	\N	\N	
29789	\N	\N	\N	
29790	\N	\N	\N	
29791	\N	\N	\N	
29792	\N	\N	\N	
29793	\N	\N	\N	
29794	\N	\N	\N	
29795	\N	\N	\N	
29796	\N	\N	\N	
29797	\N	\N	\N	
29798	\N	\N	\N	
29799	\N	\N	\N	
29800	\N	\N	\N	
29801	\N	\N	\N	
29802	\N	\N	\N	
29803	\N	\N	\N	
29804	\N	\N	\N	
29805	\N	\N	\N	
29806	\N	\N	\N	
29807	\N	\N	\N	
29808	\N	\N	\N	
29809	\N	\N	\N	
29810	\N	\N	\N	
29811	\N	\N	\N	
29812	\N	\N	\N	
29813	\N	\N	\N	
29814	\N	\N	\N	
29815	\N	\N	\N	
29816	\N	\N	\N	
29817	\N	\N	\N	
29818	\N	\N	\N	
29819	\N	\N	\N	
29820	\N	\N	\N	
29821	\N	\N	\N	
29822	\N	\N	\N	
29823	\N	\N	\N	
29824	\N	\N	\N	
29825	\N	\N	\N	
29826	\N	\N	\N	
29827	\N	\N	\N	
29828	\N	\N	\N	
29829	\N	\N	\N	
29830	\N	\N	\N	
29831	\N	\N	\N	
29832	\N	\N	\N	
29833	\N	\N	\N	
29834	\N	\N	\N	
29835	\N	\N	\N	
29836	\N	\N	\N	
29837	\N	\N	\N	
29838	\N	\N	\N	
29839	\N	\N	\N	
29840	\N	\N	\N	
29841	\N	\N	\N	
29842	\N	\N	\N	
29843	\N	\N	\N	
29844	\N	\N	\N	
29845	\N	\N	\N	
29846	\N	\N	\N	
29847	\N	\N	\N	
29848	\N	\N	\N	
29849	\N	\N	\N	
29850	\N	\N	\N	
29851	\N	\N	\N	
29852	\N	\N	\N	
29853	\N	\N	\N	
29854	\N	\N	\N	
29855	\N	\N	\N	
29856	\N	\N	\N	
29857	\N	\N	\N	
29858	\N	\N	\N	
29859	\N	\N	\N	
29860	\N	\N	\N	
29861	\N	\N	\N	
29862	\N	\N	\N	
29863	\N	\N	\N	
29864	\N	\N	\N	
29865	\N	\N	\N	
29866	\N	\N	\N	
29867	\N	\N	\N	
29868	\N	\N	\N	
29869	\N	\N	\N	
29870	\N	\N	\N	
29871	\N	\N	\N	
29872	\N	\N	\N	
29873	\N	\N	\N	
29874	\N	\N	\N	
29875	\N	\N	\N	
29876	\N	\N	\N	
29877	\N	\N	\N	
29878	\N	\N	\N	
29879	\N	\N	\N	
29880	\N	\N	\N	
29881	\N	\N	\N	
29882	\N	\N	\N	
29883	\N	\N	\N	
29884	\N	\N	\N	
29885	\N	\N	\N	
29886	\N	\N	\N	
29887	\N	\N	\N	
29888	\N	\N	\N	
29889	\N	\N	\N	
29890	\N	\N	\N	
29891	\N	\N	\N	
29892	\N	\N	\N	
29893	\N	\N	\N	
29894	\N	\N	\N	
29895	\N	\N	\N	
29896	\N	\N	\N	
29897	\N	\N	\N	
29898	\N	\N	\N	
29899	\N	\N	\N	
29900	\N	\N	\N	
29901	\N	\N	\N	
29902	\N	\N	\N	
29903	\N	\N	\N	
29904	\N	\N	\N	
29905	\N	\N	\N	
29906	\N	\N	\N	
29907	\N	\N	\N	
29908	\N	\N	\N	
29909	\N	\N	\N	
29910	\N	\N	\N	
29911	\N	\N	\N	
29912	\N	\N	\N	
29913	\N	\N	\N	
29914	\N	\N	\N	
29915	\N	\N	\N	
29916	\N	\N	\N	
29917	\N	\N	\N	
29918	\N	\N	\N	
29919	\N	\N	\N	
29920	\N	\N	\N	
29921	\N	\N	\N	
29922	\N	\N	\N	
29923	\N	\N	\N	
29924	\N	\N	\N	
29925	\N	\N	\N	
29926	\N	\N	\N	
29927	\N	\N	\N	
29928	\N	\N	\N	
29929	\N	\N	\N	
29930	\N	\N	\N	
29931	\N	\N	\N	
29932	\N	\N	\N	
29933	\N	\N	\N	
29934	\N	\N	\N	
29935	\N	\N	\N	
29936	\N	\N	\N	
29937	\N	\N	\N	
29938	\N	\N	\N	
29939	\N	\N	\N	
29940	\N	\N	\N	
29941	\N	\N	\N	
29942	\N	\N	\N	
29943	\N	\N	\N	
29944	\N	\N	\N	
29945	\N	\N	\N	
29946	\N	\N	\N	
29947	\N	\N	\N	
29948	\N	\N	\N	
29949	\N	\N	\N	
29950	\N	\N	\N	
29951	\N	\N	\N	
29952	\N	\N	\N	
29953	\N	\N	\N	
29954	\N	\N	\N	
29955	\N	\N	\N	
29956	\N	\N	\N	
29957	\N	\N	\N	
29958	\N	\N	\N	
29959	\N	\N	\N	
29960	\N	\N	\N	
29961	\N	\N	\N	
29962	\N	\N	\N	
29963	\N	\N	\N	
29964	\N	\N	\N	
29965	\N	\N	\N	
29966	\N	\N	\N	
29967	\N	\N	\N	
29968	\N	\N	\N	
29969	\N	\N	\N	
29970	\N	\N	\N	
29971	\N	\N	\N	
29972	\N	\N	\N	
29973	\N	\N	\N	
29974	\N	\N	\N	
29975	\N	\N	\N	
29976	\N	\N	\N	
29977	\N	\N	\N	
29978	\N	\N	\N	
29979	\N	\N	\N	
29980	\N	\N	\N	
29981	\N	\N	\N	
29982	\N	\N	\N	
29983	\N	\N	\N	
29984	\N	\N	\N	
29985	\N	\N	\N	
29986	\N	\N	\N	
29987	\N	\N	\N	
29988	\N	\N	\N	
29989	\N	\N	\N	
29990	\N	\N	\N	
29991	\N	\N	\N	
29992	\N	\N	\N	
29993	\N	\N	\N	
29994	\N	\N	\N	
29995	\N	\N	\N	
29996	\N	\N	\N	
29997	\N	\N	\N	
29998	\N	\N	\N	
29999	\N	\N	\N	
30000	\N	\N	\N	
30001	\N	\N	\N	
30002	\N	\N	\N	
30003	\N	\N	\N	
30004	\N	\N	\N	
30005	\N	\N	\N	
30006	\N	\N	\N	
30007	\N	\N	\N	
30008	\N	\N	\N	
30009	\N	\N	\N	
30010	\N	\N	\N	
30011	\N	\N	\N	
30012	\N	\N	\N	
30013	\N	\N	\N	
30014	\N	\N	\N	
30015	\N	\N	\N	
30016	\N	\N	\N	
30017	\N	\N	\N	
30018	\N	\N	\N	
30019	\N	\N	\N	
30020	\N	\N	\N	
30021	\N	\N	\N	
30022	\N	\N	\N	
30023	\N	\N	\N	
30024	\N	\N	\N	
30025	\N	\N	\N	
30026	\N	\N	\N	
30027	\N	\N	\N	
30028	\N	\N	\N	
30029	\N	\N	\N	
30030	\N	\N	\N	
30031	\N	\N	\N	
30032	\N	\N	\N	
30033	\N	\N	\N	
30034	\N	\N	\N	
30035	\N	\N	\N	
30036	\N	\N	\N	
30037	\N	\N	\N	
30038	\N	\N	\N	
30039	\N	\N	\N	
30040	\N	\N	\N	
30041	\N	\N	\N	
30042	\N	\N	\N	
30043	\N	\N	\N	
30044	\N	\N	\N	
30045	\N	\N	\N	
30046	\N	\N	\N	
30047	\N	\N	\N	
30048	\N	\N	\N	
30049	\N	\N	\N	
30050	\N	\N	\N	
30051	\N	\N	\N	
30052	\N	\N	\N	
30053	\N	\N	\N	
30054	\N	\N	\N	
30055	\N	\N	\N	
30056	\N	\N	\N	
30057	\N	\N	\N	
30058	\N	\N	\N	
30059	\N	\N	\N	
30060	\N	\N	\N	
30061	\N	\N	\N	
30062	\N	\N	\N	
30063	\N	\N	\N	
30064	\N	\N	\N	
30065	\N	\N	\N	
30066	\N	\N	\N	
30067	\N	\N	\N	
30068	\N	\N	\N	
30069	\N	\N	\N	
30070	\N	\N	\N	
30071	\N	\N	\N	
30072	\N	\N	\N	
30073	\N	\N	\N	
30074	\N	\N	\N	
30075	\N	\N	\N	
30076	\N	\N	\N	
30077	\N	\N	\N	
30078	\N	\N	\N	
30079	\N	\N	\N	
30080	\N	\N	\N	
30081	\N	\N	\N	
30082	\N	\N	\N	
30083	\N	\N	\N	
30084	\N	\N	\N	
30085	\N	\N	\N	
30086	\N	\N	\N	
30087	\N	\N	\N	
30088	\N	\N	\N	
30089	\N	\N	\N	
30090	\N	\N	\N	
30091	\N	\N	\N	
30092	\N	\N	\N	
30093	\N	\N	\N	
30094	\N	\N	\N	
30095	\N	\N	\N	
30096	\N	\N	\N	
30097	\N	\N	\N	
30098	\N	\N	\N	
30099	\N	\N	\N	
30100	\N	\N	\N	
30101	\N	\N	\N	
30102	\N	\N	\N	
30103	\N	\N	\N	
30104	\N	\N	\N	
30105	\N	\N	\N	
30106	\N	\N	\N	
30107	\N	\N	\N	
30108	\N	\N	\N	
30109	\N	\N	\N	
30110	\N	\N	\N	
30111	\N	\N	\N	
30112	\N	\N	\N	
30113	\N	\N	\N	
30114	\N	\N	\N	
30115	\N	\N	\N	
30116	\N	\N	\N	
30117	\N	\N	\N	
30118	\N	\N	\N	
30119	\N	\N	\N	
30120	\N	\N	\N	
30121	\N	\N	\N	
30122	\N	\N	\N	
30123	\N	\N	\N	
30124	\N	\N	\N	
30125	\N	\N	\N	
30126	\N	\N	\N	
30127	\N	\N	\N	
30128	\N	\N	\N	
30129	\N	\N	\N	
30130	\N	\N	\N	
30131	\N	\N	\N	
30132	\N	\N	\N	
30133	\N	\N	\N	
30134	\N	\N	\N	
30135	\N	\N	\N	
30136	\N	\N	\N	
30137	\N	\N	\N	
30138	\N	\N	\N	
30139	\N	\N	\N	
30140	\N	\N	\N	
30141	\N	\N	\N	
30142	\N	\N	\N	
30143	\N	\N	\N	
30144	\N	\N	\N	
30145	\N	\N	\N	
30146	\N	\N	\N	
30147	\N	\N	\N	
30148	\N	\N	\N	
30149	\N	\N	\N	
30150	\N	\N	\N	
30151	\N	\N	\N	
30152	\N	\N	\N	
30153	\N	\N	\N	
30154	\N	\N	\N	
30155	\N	\N	\N	
30156	\N	\N	\N	
30157	\N	\N	\N	
30158	\N	\N	\N	
30159	\N	\N	\N	
30160	\N	\N	\N	
30161	\N	\N	\N	
30162	\N	\N	\N	
30163	\N	\N	\N	
30164	\N	\N	\N	
30165	\N	\N	\N	
30166	\N	\N	\N	
30167	\N	\N	\N	
30168	\N	\N	\N	
30169	\N	\N	\N	
30170	\N	\N	\N	
30171	\N	\N	\N	
30172	\N	\N	\N	
30173	\N	\N	\N	
30174	\N	\N	\N	
30175	\N	\N	\N	
30176	\N	\N	\N	
30177	\N	\N	\N	
30178	\N	\N	\N	
30179	\N	\N	\N	
30180	\N	\N	\N	
30181	\N	\N	\N	
30182	\N	\N	\N	
30183	\N	\N	\N	
30184	\N	\N	\N	
30185	\N	\N	\N	
30186	\N	\N	\N	
30187	\N	\N	\N	
30188	\N	\N	\N	
30189	\N	\N	\N	
30190	\N	\N	\N	
30191	\N	\N	\N	
30192	\N	\N	\N	
30193	\N	\N	\N	
30194	\N	\N	\N	
30195	\N	\N	\N	
30196	\N	\N	\N	
30197	\N	\N	\N	
30198	\N	\N	\N	
30199	\N	\N	\N	
30200	\N	\N	\N	
30201	\N	\N	\N	
30202	\N	\N	\N	
30203	\N	\N	\N	
30204	\N	\N	\N	
30205	\N	\N	\N	
30206	\N	\N	\N	
30207	\N	\N	\N	
30208	\N	\N	\N	
30209	\N	\N	\N	
30210	\N	\N	\N	
30211	\N	\N	\N	
30212	\N	\N	\N	
30213	\N	\N	\N	
30214	\N	\N	\N	
30215	\N	\N	\N	
30216	\N	\N	\N	
30217	\N	\N	\N	
30218	\N	\N	\N	
30219	\N	\N	\N	
30220	\N	\N	\N	
30221	\N	\N	\N	
30222	\N	\N	\N	
30223	\N	\N	\N	
30224	\N	\N	\N	
30225	\N	\N	\N	
30226	\N	\N	\N	
30227	\N	\N	\N	
30228	\N	\N	\N	
30229	\N	\N	\N	
30230	\N	\N	\N	
30231	\N	\N	\N	
30232	\N	\N	\N	
30233	\N	\N	\N	
30234	\N	\N	\N	
30235	\N	\N	\N	
30236	\N	\N	\N	
30237	\N	\N	\N	
30238	\N	\N	\N	
30239	\N	\N	\N	
30240	\N	\N	\N	
30241	\N	\N	\N	
30242	\N	\N	\N	
30243	\N	\N	\N	
30244	\N	\N	\N	
30245	\N	\N	\N	
30246	\N	\N	\N	
30247	\N	\N	\N	
30248	\N	\N	\N	
30249	\N	\N	\N	
30250	\N	\N	\N	
30251	\N	\N	\N	
30252	\N	\N	\N	
30253	\N	\N	\N	
30254	\N	\N	\N	
30255	\N	\N	\N	
30256	\N	\N	\N	
30257	\N	\N	\N	
30258	\N	\N	\N	
30259	\N	\N	\N	
30260	\N	\N	\N	
30261	\N	\N	\N	
30262	\N	\N	\N	
30263	\N	\N	\N	
30264	\N	\N	\N	
30265	\N	\N	\N	
30266	\N	\N	\N	
30267	\N	\N	\N	
30268	\N	\N	\N	
30269	\N	\N	\N	
30270	\N	\N	\N	
30271	\N	\N	\N	
30272	\N	\N	\N	
30273	\N	\N	\N	
30274	\N	\N	\N	
30275	\N	\N	\N	
30276	\N	\N	\N	
30277	\N	\N	\N	
30278	\N	\N	\N	
30279	\N	\N	\N	
30280	\N	\N	\N	
30281	\N	\N	\N	
30282	\N	\N	\N	
30283	\N	\N	\N	
30284	\N	\N	\N	
30285	\N	\N	\N	
30286	\N	\N	\N	
30287	\N	\N	\N	
30288	\N	\N	\N	
30289	\N	\N	\N	
30290	\N	\N	\N	
30291	\N	\N	\N	
30292	\N	\N	\N	
30293	\N	\N	\N	
30294	\N	\N	\N	
30295	\N	\N	\N	
30296	\N	\N	\N	
30297	\N	\N	\N	
30298	\N	\N	\N	
30299	\N	\N	\N	
30300	\N	\N	\N	
30301	\N	\N	\N	
30302	\N	\N	\N	
30303	\N	\N	\N	
30304	\N	\N	\N	
30305	\N	\N	\N	
30306	\N	\N	\N	
30307	\N	\N	\N	
30308	\N	\N	\N	
30309	\N	\N	\N	
30310	\N	\N	\N	
30311	\N	\N	\N	
30312	\N	\N	\N	
30313	\N	\N	\N	
30314	\N	\N	\N	
30315	\N	\N	\N	
30316	\N	\N	\N	
30317	\N	\N	\N	
30318	\N	\N	\N	
30319	\N	\N	\N	
30320	\N	\N	\N	
30321	\N	\N	\N	
30322	\N	\N	\N	
30323	\N	\N	\N	
30324	\N	\N	\N	
30325	\N	\N	\N	
30326	\N	\N	\N	
30327	\N	\N	\N	
30328	\N	\N	\N	
30329	\N	\N	\N	
30330	\N	\N	\N	
30331	\N	\N	\N	
30332	\N	\N	\N	
30333	\N	\N	\N	
30334	\N	\N	\N	
30335	\N	\N	\N	
30336	\N	\N	\N	
30337	\N	\N	\N	
30338	\N	\N	\N	
30339	\N	\N	\N	
30340	\N	\N	\N	
30341	\N	\N	\N	
30342	\N	\N	\N	
30343	\N	\N	\N	
30344	\N	\N	\N	
30345	\N	\N	\N	
30346	\N	\N	\N	
30347	\N	\N	\N	
30348	\N	\N	\N	
30349	\N	\N	\N	
30350	\N	\N	\N	
30351	\N	\N	\N	
30352	\N	\N	\N	
30353	\N	\N	\N	
30354	\N	\N	\N	
30355	\N	\N	\N	
30356	\N	\N	\N	
30357	\N	\N	\N	
30358	\N	\N	\N	
30359	\N	\N	\N	
30360	\N	\N	\N	
30361	\N	\N	\N	
30362	\N	\N	\N	
30363	\N	\N	\N	
30364	\N	\N	\N	
30365	\N	\N	\N	
30366	\N	\N	\N	
30367	\N	\N	\N	
30368	\N	\N	\N	
30369	\N	\N	\N	
30370	\N	\N	\N	
30371	\N	\N	\N	
30372	\N	\N	\N	
30373	\N	\N	\N	
30374	\N	\N	\N	
30375	\N	\N	\N	
30376	\N	\N	\N	
30377	\N	\N	\N	
30378	\N	\N	\N	
30379	\N	\N	\N	
30380	\N	\N	\N	
30381	\N	\N	\N	
30382	\N	\N	\N	
30383	\N	\N	\N	
30384	\N	\N	\N	
30385	\N	\N	\N	
30386	\N	\N	\N	
30387	\N	\N	\N	
30388	\N	\N	\N	
30389	\N	\N	\N	
30390	\N	\N	\N	
30391	\N	\N	\N	
30392	\N	\N	\N	
30393	\N	\N	\N	
30394	\N	\N	\N	
30395	\N	\N	\N	
30396	\N	\N	\N	
30397	\N	\N	\N	
30398	\N	\N	\N	
30399	\N	\N	\N	
30400	\N	\N	\N	
30401	\N	\N	\N	
30402	\N	\N	\N	
30403	\N	\N	\N	
30404	\N	\N	\N	
30405	\N	\N	\N	
30406	\N	\N	\N	
30407	\N	\N	\N	
30408	\N	\N	\N	
30409	\N	\N	\N	
30410	\N	\N	\N	
30411	\N	\N	\N	
30412	\N	\N	\N	
30413	\N	\N	\N	
30414	\N	\N	\N	
30415	\N	\N	\N	
30416	\N	\N	\N	
30417	\N	\N	\N	
30418	\N	\N	\N	
30419	\N	\N	\N	
30420	\N	\N	\N	
30421	\N	\N	\N	
30422	\N	\N	\N	
30423	\N	\N	\N	
30424	\N	\N	\N	
30425	\N	\N	\N	
30426	\N	\N	\N	
30427	\N	\N	\N	
30428	\N	\N	\N	
30429	\N	\N	\N	
30430	\N	\N	\N	
30431	\N	\N	\N	
30432	\N	\N	\N	
30433	\N	\N	\N	
30434	\N	\N	\N	
30435	\N	\N	\N	
30436	\N	\N	\N	
30437	\N	\N	\N	
30438	\N	\N	\N	
30439	\N	\N	\N	
30440	\N	\N	\N	
30441	\N	\N	\N	
30442	\N	\N	\N	
30443	\N	\N	\N	
30444	\N	\N	\N	
30445	\N	\N	\N	
30446	\N	\N	\N	
30447	\N	\N	\N	
30448	\N	\N	\N	
30449	\N	\N	\N	
30450	\N	\N	\N	
30451	\N	\N	\N	
30452	\N	\N	\N	
30453	\N	\N	\N	
30454	\N	\N	\N	
30455	\N	\N	\N	
30456	\N	\N	\N	
30457	\N	\N	\N	
30458	\N	\N	\N	
30459	\N	\N	\N	
30460	\N	\N	\N	
30461	\N	\N	\N	
30462	\N	\N	\N	
30463	\N	\N	\N	
30464	\N	\N	\N	
30465	\N	\N	\N	
30466	\N	\N	\N	
30467	\N	\N	\N	
30468	\N	\N	\N	
30469	\N	\N	\N	
30470	\N	\N	\N	
30471	\N	\N	\N	
30472	\N	\N	\N	
30473	\N	\N	\N	
30474	\N	\N	\N	
30475	\N	\N	\N	
30476	\N	\N	\N	
30477	\N	\N	\N	
30478	\N	\N	\N	
30479	\N	\N	\N	
30480	\N	\N	\N	
30481	\N	\N	\N	
30482	\N	\N	\N	
30483	\N	\N	\N	
30484	\N	\N	\N	
30485	\N	\N	\N	
30486	\N	\N	\N	
30487	\N	\N	\N	
30488	\N	\N	\N	
30489	\N	\N	\N	
30490	\N	\N	\N	
30491	\N	\N	\N	
30492	\N	\N	\N	
30493	\N	\N	\N	
30494	\N	\N	\N	
30495	\N	\N	\N	
30496	\N	\N	\N	
30497	\N	\N	\N	
30498	\N	\N	\N	
30499	\N	\N	\N	
30500	\N	\N	\N	
30501	\N	\N	\N	
30502	\N	\N	\N	
30503	\N	\N	\N	
30504	\N	\N	\N	
30505	\N	\N	\N	
30506	\N	\N	\N	
30507	\N	\N	\N	
30508	\N	\N	\N	
30509	\N	\N	\N	
30510	\N	\N	\N	
30511	\N	\N	\N	
30512	\N	\N	\N	
30513	\N	\N	\N	
30514	\N	\N	\N	
30515	\N	\N	\N	
30516	\N	\N	\N	
30517	\N	\N	\N	
30518	\N	\N	\N	
30519	\N	\N	\N	
30520	\N	\N	\N	
30521	\N	\N	\N	
30522	\N	\N	\N	
30523	\N	\N	\N	
30524	\N	\N	\N	
30525	\N	\N	\N	
30526	\N	\N	\N	
30527	\N	\N	\N	
30528	\N	\N	\N	
30529	\N	\N	\N	
30530	\N	\N	\N	
30531	\N	\N	\N	
30532	\N	\N	\N	
30533	\N	\N	\N	
30534	\N	\N	\N	
30535	\N	\N	\N	
30536	\N	\N	\N	
30537	\N	\N	\N	
30538	\N	\N	\N	
30539	\N	\N	\N	
30540	\N	\N	\N	
30541	\N	\N	\N	
30542	\N	\N	\N	
30543	\N	\N	\N	
30544	\N	\N	\N	
30545	\N	\N	\N	
30546	\N	\N	\N	
30547	\N	\N	\N	
30548	\N	\N	\N	
30549	\N	\N	\N	
30550	\N	\N	\N	
30551	\N	\N	\N	
30552	\N	\N	\N	
30553	\N	\N	\N	
30554	\N	\N	\N	
30555	\N	\N	\N	
30556	\N	\N	\N	
30557	\N	\N	\N	
30558	\N	\N	\N	
30559	\N	\N	\N	
30560	\N	\N	\N	
30561	\N	\N	\N	
30562	\N	\N	\N	
30563	\N	\N	\N	
30564	\N	\N	\N	
30565	\N	\N	\N	
30566	\N	\N	\N	
30567	\N	\N	\N	
30568	\N	\N	\N	
30569	\N	\N	\N	
30570	\N	\N	\N	
30571	\N	\N	\N	
30572	\N	\N	\N	
30573	\N	\N	\N	
30574	\N	\N	\N	
30575	\N	\N	\N	
30576	\N	\N	\N	
30577	\N	\N	\N	
30578	\N	\N	\N	
30579	\N	\N	\N	
30580	\N	\N	\N	
30581	\N	\N	\N	
30582	\N	\N	\N	
30583	\N	\N	\N	
30584	\N	\N	\N	
30585	\N	\N	\N	
30586	\N	\N	\N	
30587	\N	\N	\N	
30588	\N	\N	\N	
30589	\N	\N	\N	
30590	\N	\N	\N	
30591	\N	\N	\N	
30592	\N	\N	\N	
30593	\N	\N	\N	
30594	\N	\N	\N	
30595	\N	\N	\N	
30596	\N	\N	\N	
30597	\N	\N	\N	
30598	\N	\N	\N	
30599	\N	\N	\N	
30600	\N	\N	\N	
30601	\N	\N	\N	
30602	\N	\N	\N	
30603	\N	\N	\N	
30604	\N	\N	\N	
30605	\N	\N	\N	
30606	\N	\N	\N	
30607	\N	\N	\N	
30608	\N	\N	\N	
30609	\N	\N	\N	
30610	\N	\N	\N	
30611	\N	\N	\N	
30612	\N	\N	\N	
30613	\N	\N	\N	
30614	\N	\N	\N	
30615	\N	\N	\N	
30616	\N	\N	\N	
30617	\N	\N	\N	
30618	\N	\N	\N	
30619	\N	\N	\N	
30620	\N	\N	\N	
30621	\N	\N	\N	
30622	\N	\N	\N	
30623	\N	\N	\N	
30624	\N	\N	\N	
30625	\N	\N	\N	
30626	\N	\N	\N	
30627	\N	\N	\N	
30628	\N	\N	\N	
30629	\N	\N	\N	
30630	\N	\N	\N	
30631	\N	\N	\N	
30632	\N	\N	\N	
30633	\N	\N	\N	
30634	\N	\N	\N	
30635	\N	\N	\N	
30636	\N	\N	\N	
30637	\N	\N	\N	
30638	\N	\N	\N	
30639	\N	\N	\N	
30640	\N	\N	\N	
30641	\N	\N	\N	
30642	\N	\N	\N	
30643	\N	\N	\N	
30644	\N	\N	\N	
30645	\N	\N	\N	
30646	\N	\N	\N	
30647	\N	\N	\N	
30648	\N	\N	\N	
30649	\N	\N	\N	
30650	\N	\N	\N	
30651	\N	\N	\N	
30652	\N	\N	\N	
30653	\N	\N	\N	
30654	\N	\N	\N	
30655	\N	\N	\N	
30656	\N	\N	\N	
30657	\N	\N	\N	
30658	\N	\N	\N	
30659	\N	\N	\N	
30660	\N	\N	\N	
30661	\N	\N	\N	
30662	\N	\N	\N	
30663	\N	\N	\N	
30664	\N	\N	\N	
30665	\N	\N	\N	
30666	\N	\N	\N	
30667	\N	\N	\N	
30668	\N	\N	\N	
30669	\N	\N	\N	
30670	\N	\N	\N	
30671	\N	\N	\N	
30672	\N	\N	\N	
30673	\N	\N	\N	
30674	\N	\N	\N	
30675	\N	\N	\N	
30676	\N	\N	\N	
30677	\N	\N	\N	
30678	\N	\N	\N	
30679	\N	\N	\N	
30680	\N	\N	\N	
30681	\N	\N	\N	
30682	\N	\N	\N	
30683	\N	\N	\N	
30684	\N	\N	\N	
30685	\N	\N	\N	
30686	\N	\N	\N	
30687	\N	\N	\N	
30688	\N	\N	\N	
30689	\N	\N	\N	
30690	\N	\N	\N	
30691	\N	\N	\N	
30692	\N	\N	\N	
30693	\N	\N	\N	
30694	\N	\N	\N	
30695	\N	\N	\N	
30696	\N	\N	\N	
30697	\N	\N	\N	
30698	\N	\N	\N	
30699	\N	\N	\N	
30700	\N	\N	\N	
30701	\N	\N	\N	
30702	\N	\N	\N	
30703	\N	\N	\N	
30704	\N	\N	\N	
30705	\N	\N	\N	
30706	\N	\N	\N	
30707	\N	\N	\N	
30708	\N	\N	\N	
30709	\N	\N	\N	
30710	\N	\N	\N	
30711	\N	\N	\N	
30712	\N	\N	\N	
30713	\N	\N	\N	
30714	\N	\N	\N	
30715	\N	\N	\N	
30716	\N	\N	\N	
30717	\N	\N	\N	
30718	\N	\N	\N	
30719	\N	\N	\N	
30720	\N	\N	\N	
30721	\N	\N	\N	
30722	\N	\N	\N	
30723	\N	\N	\N	
30724	\N	\N	\N	
30725	\N	\N	\N	
30726	\N	\N	\N	
30727	\N	\N	\N	
30728	\N	\N	\N	
30729	\N	\N	\N	
30730	\N	\N	\N	
30731	\N	\N	\N	
30732	\N	\N	\N	
30733	\N	\N	\N	
30734	\N	\N	\N	
30735	\N	\N	\N	
30736	\N	\N	\N	
30737	\N	\N	\N	
30738	\N	\N	\N	
30739	\N	\N	\N	
30740	\N	\N	\N	
30741	\N	\N	\N	
30742	\N	\N	\N	
30743	\N	\N	\N	
30744	\N	\N	\N	
30745	\N	\N	\N	
30746	\N	\N	\N	
30747	\N	\N	\N	
30748	\N	\N	\N	
30749	\N	\N	\N	
30750	\N	\N	\N	
30751	\N	\N	\N	
30752	\N	\N	\N	
30753	\N	\N	\N	
30754	\N	\N	\N	
30755	\N	\N	\N	
30756	\N	\N	\N	
30757	\N	\N	\N	
30758	\N	\N	\N	
30759	\N	\N	\N	
30760	\N	\N	\N	
30761	\N	\N	\N	
30762	\N	\N	\N	
30763	\N	\N	\N	
30764	\N	\N	\N	
30765	\N	\N	\N	
30766	\N	\N	\N	
30767	\N	\N	\N	
30768	\N	\N	\N	
30769	\N	\N	\N	
30770	\N	\N	\N	
30771	\N	\N	\N	
30772	\N	\N	\N	
30773	\N	\N	\N	
30774	\N	\N	\N	
30775	\N	\N	\N	
30776	\N	\N	\N	
30777	\N	\N	\N	
30778	\N	\N	\N	
30779	\N	\N	\N	
30780	\N	\N	\N	
30781	\N	\N	\N	
30782	\N	\N	\N	
30783	\N	\N	\N	
30784	\N	\N	\N	
30785	\N	\N	\N	
30786	\N	\N	\N	
30787	\N	\N	\N	
30788	\N	\N	\N	
30789	\N	\N	\N	
30790	\N	\N	\N	
30791	\N	\N	\N	
30792	\N	\N	\N	
30793	\N	\N	\N	
30794	\N	\N	\N	
30795	\N	\N	\N	
30796	\N	\N	\N	
30797	\N	\N	\N	
30798	\N	\N	\N	
30799	\N	\N	\N	
30800	\N	\N	\N	
30801	\N	\N	\N	
30802	\N	\N	\N	
30803	\N	\N	\N	
30804	\N	\N	\N	
30805	\N	\N	\N	
30806	\N	\N	\N	
30807	\N	\N	\N	
30808	\N	\N	\N	
30809	\N	\N	\N	
30810	\N	\N	\N	
30811	\N	\N	\N	
30812	\N	\N	\N	
30813	\N	\N	\N	
30814	\N	\N	\N	
30815	\N	\N	\N	
30816	\N	\N	\N	
30817	\N	\N	\N	
30818	\N	\N	\N	
30819	\N	\N	\N	
30820	\N	\N	\N	
30821	\N	\N	\N	
30822	\N	\N	\N	
30823	\N	\N	\N	
30824	\N	\N	\N	
30825	\N	\N	\N	
30826	\N	\N	\N	
30827	\N	\N	\N	
30828	\N	\N	\N	
30829	\N	\N	\N	
30830	\N	\N	\N	
30831	\N	\N	\N	
30832	\N	\N	\N	
30833	\N	\N	\N	
30834	\N	\N	\N	
30835	\N	\N	\N	
30836	\N	\N	\N	
30837	\N	\N	\N	
30838	\N	\N	\N	
30839	\N	\N	\N	
30840	\N	\N	\N	
30841	\N	\N	\N	
30842	\N	\N	\N	
30843	\N	\N	\N	
30844	\N	\N	\N	
30845	\N	\N	\N	
30846	\N	\N	\N	
30847	\N	\N	\N	
30848	\N	\N	\N	
30849	\N	\N	\N	
30850	\N	\N	\N	
30851	\N	\N	\N	
30852	\N	\N	\N	
30853	\N	\N	\N	
30854	\N	\N	\N	
30855	\N	\N	\N	
30856	\N	\N	\N	
30857	\N	\N	\N	
30858	\N	\N	\N	
30859	\N	\N	\N	
30860	\N	\N	\N	
30861	\N	\N	\N	
30862	\N	\N	\N	
30863	\N	\N	\N	
30864	\N	\N	\N	
30865	\N	\N	\N	
30866	\N	\N	\N	
30867	\N	\N	\N	
30868	\N	\N	\N	
30869	\N	\N	\N	
30870	\N	\N	\N	
30871	\N	\N	\N	
30872	\N	\N	\N	
30873	\N	\N	\N	
30874	\N	\N	\N	
30875	\N	\N	\N	
30876	\N	\N	\N	
30877	\N	\N	\N	
30878	\N	\N	\N	
30879	\N	\N	\N	
30880	\N	\N	\N	
30881	\N	\N	\N	
30882	\N	\N	\N	
30883	\N	\N	\N	
30884	\N	\N	\N	
30885	\N	\N	\N	
30886	\N	\N	\N	
30887	\N	\N	\N	
30888	\N	\N	\N	
30889	\N	\N	\N	
30890	\N	\N	\N	
30891	\N	\N	\N	
30892	\N	\N	\N	
30893	\N	\N	\N	
30894	\N	\N	\N	
30895	\N	\N	\N	
30896	\N	\N	\N	
30897	\N	\N	\N	
30898	\N	\N	\N	
30899	\N	\N	\N	
30900	\N	\N	\N	
30901	\N	\N	\N	
30902	\N	\N	\N	
30903	\N	\N	\N	
30904	\N	\N	\N	
30905	\N	\N	\N	
30906	\N	\N	\N	
30907	\N	\N	\N	
30908	\N	\N	\N	
30909	\N	\N	\N	
30910	\N	\N	\N	
30911	\N	\N	\N	
30912	\N	\N	\N	
30913	\N	\N	\N	
30914	\N	\N	\N	
30915	\N	\N	\N	
30916	\N	\N	\N	
30917	\N	\N	\N	
30918	\N	\N	\N	
30919	\N	\N	\N	
30920	\N	\N	\N	
30921	\N	\N	\N	
30922	\N	\N	\N	
30923	\N	\N	\N	
30924	\N	\N	\N	
30925	\N	\N	\N	
30926	\N	\N	\N	
30927	\N	\N	\N	
30928	\N	\N	\N	
30929	\N	\N	\N	
30930	\N	\N	\N	
30931	\N	\N	\N	
30932	\N	\N	\N	
30933	\N	\N	\N	
30934	\N	\N	\N	
30935	\N	\N	\N	
30936	\N	\N	\N	
30937	\N	\N	\N	
30938	\N	\N	\N	
30939	\N	\N	\N	
30940	\N	\N	\N	
30941	\N	\N	\N	
30942	\N	\N	\N	
30943	\N	\N	\N	
30944	\N	\N	\N	
30945	\N	\N	\N	
30946	\N	\N	\N	
30947	\N	\N	\N	
30948	\N	\N	\N	
30949	\N	\N	\N	
30950	\N	\N	\N	
30951	\N	\N	\N	
30952	\N	\N	\N	
30953	\N	\N	\N	
30954	\N	\N	\N	
30955	\N	\N	\N	
30956	\N	\N	\N	
30957	\N	\N	\N	
30958	\N	\N	\N	
30959	\N	\N	\N	
30960	\N	\N	\N	
30961	\N	\N	\N	
30962	\N	\N	\N	
30963	\N	\N	\N	
30964	\N	\N	\N	
30965	\N	\N	\N	
30966	\N	\N	\N	
30967	\N	\N	\N	
30968	\N	\N	\N	
30969	\N	\N	\N	
30970	\N	\N	\N	
30971	\N	\N	\N	
30972	\N	\N	\N	
30973	\N	\N	\N	
30974	\N	\N	\N	
30975	\N	\N	\N	
30976	\N	\N	\N	
30977	\N	\N	\N	
30978	\N	\N	\N	
30979	\N	\N	\N	
30980	\N	\N	\N	
30981	\N	\N	\N	
30982	\N	\N	\N	
30983	\N	\N	\N	
30984	\N	\N	\N	
30985	\N	\N	\N	
30986	\N	\N	\N	
30987	\N	\N	\N	
30988	\N	\N	\N	
30989	\N	\N	\N	
30990	\N	\N	\N	
30991	\N	\N	\N	
30992	\N	\N	\N	
30993	\N	\N	\N	
30994	\N	\N	\N	
30995	\N	\N	\N	
30996	\N	\N	\N	
30997	\N	\N	\N	
30998	\N	\N	\N	
30999	\N	\N	\N	
31000	\N	\N	\N	
31001	\N	\N	\N	
31002	\N	\N	\N	
31003	\N	\N	\N	
31004	\N	\N	\N	
31005	\N	\N	\N	
31006	\N	\N	\N	
31007	\N	\N	\N	
31008	\N	\N	\N	
31009	\N	\N	\N	
31010	\N	\N	\N	
31011	\N	\N	\N	
31012	\N	\N	\N	
31013	\N	\N	\N	
31014	\N	\N	\N	
31015	\N	\N	\N	
31016	\N	\N	\N	
31017	\N	\N	\N	
31018	\N	\N	\N	
31019	\N	\N	\N	
31020	\N	\N	\N	
31021	\N	\N	\N	
31022	\N	\N	\N	
31023	\N	\N	\N	
31024	\N	\N	\N	
31025	\N	\N	\N	
31026	\N	\N	\N	
31027	\N	\N	\N	
31028	\N	\N	\N	
31029	\N	\N	\N	
31030	\N	\N	\N	
31031	\N	\N	\N	
31032	\N	\N	\N	
31033	\N	\N	\N	
31034	\N	\N	\N	
31035	\N	\N	\N	
31036	\N	\N	\N	
31037	\N	\N	\N	
31038	\N	\N	\N	
31039	\N	\N	\N	
31040	\N	\N	\N	
31041	\N	\N	\N	
31042	\N	\N	\N	
31043	\N	\N	\N	
31044	\N	\N	\N	
31045	\N	\N	\N	
31046	\N	\N	\N	
31047	\N	\N	\N	
31048	\N	\N	\N	
31049	\N	\N	\N	
31050	\N	\N	\N	
31051	\N	\N	\N	
31052	\N	\N	\N	
31053	\N	\N	\N	
31054	\N	\N	\N	
31055	\N	\N	\N	
31056	\N	\N	\N	
31057	\N	\N	\N	
31058	\N	\N	\N	
31059	\N	\N	\N	
31060	\N	\N	\N	
31061	\N	\N	\N	
31062	\N	\N	\N	
31063	\N	\N	\N	
31064	\N	\N	\N	
31065	\N	\N	\N	
31066	\N	\N	\N	
31067	\N	\N	\N	
31068	\N	\N	\N	
31069	\N	\N	\N	
31070	\N	\N	\N	
31071	\N	\N	\N	
31072	\N	\N	\N	
31073	\N	\N	\N	
31074	\N	\N	\N	
31075	\N	\N	\N	
31076	\N	\N	\N	
31077	\N	\N	\N	
31078	\N	\N	\N	
31079	\N	\N	\N	
31080	\N	\N	\N	
31081	\N	\N	\N	
31082	\N	\N	\N	
31083	\N	\N	\N	
31084	\N	\N	\N	
31085	\N	\N	\N	
31086	\N	\N	\N	
31087	\N	\N	\N	
31088	\N	\N	\N	
31089	\N	\N	\N	
31090	\N	\N	\N	
31091	\N	\N	\N	
31092	\N	\N	\N	
31093	\N	\N	\N	
31094	\N	\N	\N	
31095	\N	\N	\N	
31096	\N	\N	\N	
31097	\N	\N	\N	
31098	\N	\N	\N	
31099	\N	\N	\N	
31100	\N	\N	\N	
31101	\N	\N	\N	
31102	\N	\N	\N	
31103	\N	\N	\N	
31104	\N	\N	\N	
31105	\N	\N	\N	
31106	\N	\N	\N	
31107	\N	\N	\N	
31108	\N	\N	\N	
31109	\N	\N	\N	
31110	\N	\N	\N	
31111	\N	\N	\N	
31112	\N	\N	\N	
31113	\N	\N	\N	
31114	\N	\N	\N	
31115	\N	\N	\N	
31116	\N	\N	\N	
31117	\N	\N	\N	
31118	\N	\N	\N	
31119	\N	\N	\N	
31120	\N	\N	\N	
31121	\N	\N	\N	
31122	\N	\N	\N	
31123	\N	\N	\N	
31124	\N	\N	\N	
31125	\N	\N	\N	
31126	\N	\N	\N	
31127	\N	\N	\N	
31128	\N	\N	\N	
31129	\N	\N	\N	
31130	\N	\N	\N	
31131	\N	\N	\N	
31132	\N	\N	\N	
31133	\N	\N	\N	
31134	\N	\N	\N	
31135	\N	\N	\N	
31136	\N	\N	\N	
31137	\N	\N	\N	
31138	\N	\N	\N	
31139	\N	\N	\N	
31140	\N	\N	\N	
31141	\N	\N	\N	
31142	\N	\N	\N	
31143	\N	\N	\N	
31144	\N	\N	\N	
31145	\N	\N	\N	
31146	\N	\N	\N	
31147	\N	\N	\N	
31148	\N	\N	\N	
31149	\N	\N	\N	
31150	\N	\N	\N	
31151	\N	\N	\N	
31152	\N	\N	\N	
31153	\N	\N	\N	
31154	\N	\N	\N	
31155	\N	\N	\N	
31156	\N	\N	\N	
31157	\N	\N	\N	
31158	\N	\N	\N	
31159	\N	\N	\N	
31160	\N	\N	\N	
31161	\N	\N	\N	
31162	\N	\N	\N	
31163	\N	\N	\N	
31164	\N	\N	\N	
31165	\N	\N	\N	
31166	\N	\N	\N	
31167	\N	\N	\N	
31168	\N	\N	\N	
31169	\N	\N	\N	
31170	\N	\N	\N	
31171	\N	\N	\N	
31172	\N	\N	\N	
31173	\N	\N	\N	
31174	\N	\N	\N	
31175	\N	\N	\N	
31176	\N	\N	\N	
31177	\N	\N	\N	
31178	\N	\N	\N	
31179	\N	\N	\N	
31180	\N	\N	\N	
31181	\N	\N	\N	
31182	\N	\N	\N	
31183	\N	\N	\N	
31184	\N	\N	\N	
31185	\N	\N	\N	
31186	\N	\N	\N	
31187	\N	\N	\N	
31188	\N	\N	\N	
31189	\N	\N	\N	
31190	\N	\N	\N	
31191	\N	\N	\N	
31192	\N	\N	\N	
31193	\N	\N	\N	
31194	\N	\N	\N	
31195	\N	\N	\N	
31196	\N	\N	\N	
31197	\N	\N	\N	
31198	\N	\N	\N	
31199	\N	\N	\N	
31200	\N	\N	\N	
31201	\N	\N	\N	
31202	\N	\N	\N	
31203	\N	\N	\N	
31204	\N	\N	\N	
31205	\N	\N	\N	
31206	\N	\N	\N	
31207	\N	\N	\N	
31208	\N	\N	\N	
31209	\N	\N	\N	
31210	\N	\N	\N	
31211	\N	\N	\N	
31212	\N	\N	\N	
31213	\N	\N	\N	
31214	\N	\N	\N	
31215	\N	\N	\N	
31216	\N	\N	\N	
31217	\N	\N	\N	
31218	\N	\N	\N	
31219	\N	\N	\N	
31220	\N	\N	\N	
31221	\N	\N	\N	
31222	\N	\N	\N	
31223	\N	\N	\N	
31224	\N	\N	\N	
31225	\N	\N	\N	
31226	\N	\N	\N	
31227	\N	\N	\N	
31228	\N	\N	\N	
31229	\N	\N	\N	
31230	\N	\N	\N	
31231	\N	\N	\N	
31232	\N	\N	\N	
31233	\N	\N	\N	
31234	\N	\N	\N	
31235	\N	\N	\N	
31236	\N	\N	\N	
31237	\N	\N	\N	
31238	\N	\N	\N	
31239	\N	\N	\N	
31240	\N	\N	\N	
31241	\N	\N	\N	
31242	\N	\N	\N	
31243	\N	\N	\N	
31244	\N	\N	\N	
31245	\N	\N	\N	
31246	\N	\N	\N	
31247	\N	\N	\N	
31248	\N	\N	\N	
31249	\N	\N	\N	
31250	\N	\N	\N	
31251	\N	\N	\N	
31252	\N	\N	\N	
31253	\N	\N	\N	
31254	\N	\N	\N	
31255	\N	\N	\N	
31256	\N	\N	\N	
31257	\N	\N	\N	
31258	\N	\N	\N	
31259	\N	\N	\N	
31260	\N	\N	\N	
31261	\N	\N	\N	
31262	\N	\N	\N	
31263	\N	\N	\N	
31264	\N	\N	\N	
31265	\N	\N	\N	
31266	\N	\N	\N	
31267	\N	\N	\N	
31268	\N	\N	\N	
31269	\N	\N	\N	
31270	\N	\N	\N	
31271	\N	\N	\N	
31272	\N	\N	\N	
31273	\N	\N	\N	
31274	\N	\N	\N	
31275	\N	\N	\N	
31276	\N	\N	\N	
31277	\N	\N	\N	
31278	\N	\N	\N	
31279	\N	\N	\N	
31280	\N	\N	\N	
31281	\N	\N	\N	
31282	\N	\N	\N	
31283	\N	\N	\N	
31284	\N	\N	\N	
31285	\N	\N	\N	
31286	\N	\N	\N	
31287	\N	\N	\N	
31288	\N	\N	\N	
31289	\N	\N	\N	
31290	\N	\N	\N	
31291	\N	\N	\N	
31292	\N	\N	\N	
31293	\N	\N	\N	
31294	\N	\N	\N	
31295	\N	\N	\N	
31296	\N	\N	\N	
31297	\N	\N	\N	
31298	\N	\N	\N	
31299	\N	\N	\N	
31300	\N	\N	\N	
31301	\N	\N	\N	
31302	\N	\N	\N	
31303	\N	\N	\N	
31304	\N	\N	\N	
31305	\N	\N	\N	
31306	\N	\N	\N	
31307	\N	\N	\N	
31308	\N	\N	\N	
31309	\N	\N	\N	
31310	\N	\N	\N	
31311	\N	\N	\N	
31312	\N	\N	\N	
31313	\N	\N	\N	
31314	\N	\N	\N	
31315	\N	\N	\N	
31316	\N	\N	\N	
31317	\N	\N	\N	
31318	\N	\N	\N	
31319	\N	\N	\N	
31320	\N	\N	\N	
31321	\N	\N	\N	
31322	\N	\N	\N	
31323	\N	\N	\N	
31324	\N	\N	\N	
31325	\N	\N	\N	
31326	\N	\N	\N	
31327	\N	\N	\N	
31328	\N	\N	\N	
31329	\N	\N	\N	
31330	\N	\N	\N	
31331	\N	\N	\N	
31332	\N	\N	\N	
31333	\N	\N	\N	
31334	\N	\N	\N	
31335	\N	\N	\N	
31336	\N	\N	\N	
31337	\N	\N	\N	
31338	\N	\N	\N	
31339	\N	\N	\N	
31340	\N	\N	\N	
31341	\N	\N	\N	
31342	\N	\N	\N	
31343	\N	\N	\N	
31344	\N	\N	\N	
31345	\N	\N	\N	
31346	\N	\N	\N	
31347	\N	\N	\N	
31348	\N	\N	\N	
31349	\N	\N	\N	
31350	\N	\N	\N	
31351	\N	\N	\N	
31352	\N	\N	\N	
31353	\N	\N	\N	
31354	\N	\N	\N	
31355	\N	\N	\N	
31356	\N	\N	\N	
31357	\N	\N	\N	
31358	\N	\N	\N	
31359	\N	\N	\N	
31360	\N	\N	\N	
31361	\N	\N	\N	
31362	\N	\N	\N	
31363	\N	\N	\N	
31364	\N	\N	\N	
31365	\N	\N	\N	
31366	\N	\N	\N	
31367	\N	\N	\N	
31368	\N	\N	\N	
31369	\N	\N	\N	
31370	\N	\N	\N	
31371	\N	\N	\N	
31372	\N	\N	\N	
31373	\N	\N	\N	
31374	\N	\N	\N	
31375	\N	\N	\N	
31376	\N	\N	\N	
31377	\N	\N	\N	
31378	\N	\N	\N	
31379	\N	\N	\N	
31380	\N	\N	\N	
31381	\N	\N	\N	
31382	\N	\N	\N	
31383	\N	\N	\N	
31384	\N	\N	\N	
31385	\N	\N	\N	
31386	\N	\N	\N	
31387	\N	\N	\N	
31388	\N	\N	\N	
31389	\N	\N	\N	
31390	\N	\N	\N	
31391	\N	\N	\N	
31392	\N	\N	\N	
31393	\N	\N	\N	
31394	\N	\N	\N	
31395	\N	\N	\N	
31396	\N	\N	\N	
31397	\N	\N	\N	
31398	\N	\N	\N	
31399	\N	\N	\N	
31400	\N	\N	\N	
31401	\N	\N	\N	
31402	\N	\N	\N	
31403	\N	\N	\N	
31404	\N	\N	\N	
31405	\N	\N	\N	
31406	\N	\N	\N	
31407	\N	\N	\N	
31408	\N	\N	\N	
31409	\N	\N	\N	
31410	\N	\N	\N	
31411	\N	\N	\N	
31412	\N	\N	\N	
31413	\N	\N	\N	
31414	\N	\N	\N	
31415	\N	\N	\N	
31416	\N	\N	\N	
31417	\N	\N	\N	
31418	\N	\N	\N	
31419	\N	\N	\N	
31420	\N	\N	\N	
31421	\N	\N	\N	
31422	\N	\N	\N	
31423	\N	\N	\N	
31424	\N	\N	\N	
31425	\N	\N	\N	
31426	\N	\N	\N	
31427	\N	\N	\N	
31428	\N	\N	\N	
31429	\N	\N	\N	
31430	\N	\N	\N	
31431	\N	\N	\N	
31432	\N	\N	\N	
31433	\N	\N	\N	
31434	\N	\N	\N	
31435	\N	\N	\N	
31436	\N	\N	\N	
31437	\N	\N	\N	
31438	\N	\N	\N	
31439	\N	\N	\N	
31440	\N	\N	\N	
31441	\N	\N	\N	
31442	\N	\N	\N	
31443	\N	\N	\N	
31444	\N	\N	\N	
31445	\N	\N	\N	
31446	\N	\N	\N	
31447	\N	\N	\N	
31448	\N	\N	\N	
31449	\N	\N	\N	
31450	\N	\N	\N	
31451	\N	\N	\N	
31452	\N	\N	\N	
31453	\N	\N	\N	
31454	\N	\N	\N	
31455	\N	\N	\N	
31456	\N	\N	\N	
31457	\N	\N	\N	
31458	\N	\N	\N	
31459	\N	\N	\N	
31460	\N	\N	\N	
31461	\N	\N	\N	
31462	\N	\N	\N	
31463	\N	\N	\N	
31464	\N	\N	\N	
31465	\N	\N	\N	
31466	\N	\N	\N	
31467	\N	\N	\N	
31468	\N	\N	\N	
31469	\N	\N	\N	
31470	\N	\N	\N	
31471	\N	\N	\N	
31472	\N	\N	\N	
31473	\N	\N	\N	
31474	\N	\N	\N	
31475	\N	\N	\N	
31476	\N	\N	\N	
31477	\N	\N	\N	
31478	\N	\N	\N	
31479	\N	\N	\N	
31480	\N	\N	\N	
31481	\N	\N	\N	
31482	\N	\N	\N	
31483	\N	\N	\N	
31484	\N	\N	\N	
31485	\N	\N	\N	
31486	\N	\N	\N	
31487	\N	\N	\N	
31488	\N	\N	\N	
31489	\N	\N	\N	
31490	\N	\N	\N	
31491	\N	\N	\N	
31492	\N	\N	\N	
31493	\N	\N	\N	
31494	\N	\N	\N	
31495	\N	\N	\N	
31496	\N	\N	\N	
31497	\N	\N	\N	
31498	\N	\N	\N	
31499	\N	\N	\N	
31500	\N	\N	\N	
31501	\N	\N	\N	
31502	\N	\N	\N	
31503	\N	\N	\N	
31504	\N	\N	\N	
31505	\N	\N	\N	
31506	\N	\N	\N	
31507	\N	\N	\N	
31508	\N	\N	\N	
31509	\N	\N	\N	
31510	\N	\N	\N	
31511	\N	\N	\N	
31512	\N	\N	\N	
31513	\N	\N	\N	
31514	\N	\N	\N	
31515	\N	\N	\N	
31516	\N	\N	\N	
31517	\N	\N	\N	
31518	\N	\N	\N	
31519	\N	\N	\N	
31520	\N	\N	\N	
31521	\N	\N	\N	
31522	\N	\N	\N	
31523	\N	\N	\N	
31524	\N	\N	\N	
31525	\N	\N	\N	
31526	\N	\N	\N	
31527	\N	\N	\N	
31528	\N	\N	\N	
31529	\N	\N	\N	
31530	\N	\N	\N	
31531	\N	\N	\N	
31532	\N	\N	\N	
31533	\N	\N	\N	
31534	\N	\N	\N	
31535	\N	\N	\N	
31536	\N	\N	\N	
31537	\N	\N	\N	
31538	\N	\N	\N	
31539	\N	\N	\N	
31540	\N	\N	\N	
31541	\N	\N	\N	
31542	\N	\N	\N	
31543	\N	\N	\N	
31544	\N	\N	\N	
31545	\N	\N	\N	
31546	\N	\N	\N	
31547	\N	\N	\N	
31548	\N	\N	\N	
31549	\N	\N	\N	
31550	\N	\N	\N	
31551	\N	\N	\N	
31552	\N	\N	\N	
31553	\N	\N	\N	
31554	\N	\N	\N	
31555	\N	\N	\N	
31556	\N	\N	\N	
31557	\N	\N	\N	
31558	\N	\N	\N	
31559	\N	\N	\N	
31560	\N	\N	\N	
31561	\N	\N	\N	
31562	\N	\N	\N	
31563	\N	\N	\N	
31564	\N	\N	\N	
31565	\N	\N	\N	
31566	\N	\N	\N	
31567	\N	\N	\N	
31568	\N	\N	\N	
31569	\N	\N	\N	
31570	\N	\N	\N	
31571	\N	\N	\N	
31572	\N	\N	\N	
31573	\N	\N	\N	
31574	\N	\N	\N	
31575	\N	\N	\N	
31576	\N	\N	\N	
31577	\N	\N	\N	
31578	\N	\N	\N	
31579	\N	\N	\N	
31580	\N	\N	\N	
31581	\N	\N	\N	
31582	\N	\N	\N	
31583	\N	\N	\N	
31584	\N	\N	\N	
31585	\N	\N	\N	
31586	\N	\N	\N	
31587	\N	\N	\N	
31588	\N	\N	\N	
31589	\N	\N	\N	
31590	\N	\N	\N	
31591	\N	\N	\N	
31592	\N	\N	\N	
31593	\N	\N	\N	
31594	\N	\N	\N	
31595	\N	\N	\N	
31596	\N	\N	\N	
31597	\N	\N	\N	
31598	\N	\N	\N	
31599	\N	\N	\N	
31600	\N	\N	\N	
31601	\N	\N	\N	
31602	\N	\N	\N	
31603	\N	\N	\N	
31604	\N	\N	\N	
31605	\N	\N	\N	
31606	\N	\N	\N	
31607	\N	\N	\N	
31608	\N	\N	\N	
31609	\N	\N	\N	
31610	\N	\N	\N	
31611	\N	\N	\N	
31612	\N	\N	\N	
31613	\N	\N	\N	
31614	\N	\N	\N	
31615	\N	\N	\N	
31616	\N	\N	\N	
31617	\N	\N	\N	
31618	\N	\N	\N	
31619	\N	\N	\N	
31620	\N	\N	\N	
31621	\N	\N	\N	
31622	\N	\N	\N	
31623	\N	\N	\N	
31624	\N	\N	\N	
31625	\N	\N	\N	
31626	\N	\N	\N	
31627	\N	\N	\N	
31628	\N	\N	\N	
31629	\N	\N	\N	
31630	\N	\N	\N	
31631	\N	\N	\N	
31632	\N	\N	\N	
31633	\N	\N	\N	
31634	\N	\N	\N	
31635	\N	\N	\N	
31636	\N	\N	\N	
31637	\N	\N	\N	
31638	\N	\N	\N	
31639	\N	\N	\N	
31640	\N	\N	\N	
31641	\N	\N	\N	
31642	\N	\N	\N	
31643	\N	\N	\N	
31644	\N	\N	\N	
31645	\N	\N	\N	
31646	\N	\N	\N	
31647	\N	\N	\N	
31648	\N	\N	\N	
31649	\N	\N	\N	
31650	\N	\N	\N	
31651	\N	\N	\N	
31652	\N	\N	\N	
31653	\N	\N	\N	
31654	\N	\N	\N	
31655	\N	\N	\N	
31656	\N	\N	\N	
31657	\N	\N	\N	
31658	\N	\N	\N	
31659	\N	\N	\N	
31660	\N	\N	\N	
31661	\N	\N	\N	
31662	\N	\N	\N	
31663	\N	\N	\N	
31664	\N	\N	\N	
31665	\N	\N	\N	
31666	\N	\N	\N	
31667	\N	\N	\N	
31668	\N	\N	\N	
31669	\N	\N	\N	
31670	\N	\N	\N	
31671	\N	\N	\N	
31672	\N	\N	\N	
31673	\N	\N	\N	
31674	\N	\N	\N	
31675	\N	\N	\N	
31676	\N	\N	\N	
31677	\N	\N	\N	
31678	\N	\N	\N	
31679	\N	\N	\N	
31680	\N	\N	\N	
31681	\N	\N	\N	
31682	\N	\N	\N	
31683	\N	\N	\N	
31684	\N	\N	\N	
31685	\N	\N	\N	
31686	\N	\N	\N	
31687	\N	\N	\N	
31688	\N	\N	\N	
31689	\N	\N	\N	
31690	\N	\N	\N	
31691	\N	\N	\N	
31692	\N	\N	\N	
31693	\N	\N	\N	
31694	\N	\N	\N	
31695	\N	\N	\N	
31696	\N	\N	\N	
31697	\N	\N	\N	
31698	\N	\N	\N	
31699	\N	\N	\N	
31700	\N	\N	\N	
31701	\N	\N	\N	
31702	\N	\N	\N	
31703	\N	\N	\N	
31704	\N	\N	\N	
31705	\N	\N	\N	
31706	\N	\N	\N	
31707	\N	\N	\N	
31708	\N	\N	\N	
31709	\N	\N	\N	
31710	\N	\N	\N	
31711	\N	\N	\N	
31712	\N	\N	\N	
31713	\N	\N	\N	
31714	\N	\N	\N	
31715	\N	\N	\N	
31716	\N	\N	\N	
31717	\N	\N	\N	
31718	\N	\N	\N	
31719	\N	\N	\N	
31720	\N	\N	\N	
31721	\N	\N	\N	
31722	\N	\N	\N	
31723	\N	\N	\N	
31724	\N	\N	\N	
31725	\N	\N	\N	
31726	\N	\N	\N	
31727	\N	\N	\N	
31728	\N	\N	\N	
31729	\N	\N	\N	
31730	\N	\N	\N	
31731	\N	\N	\N	
31732	\N	\N	\N	
31733	\N	\N	\N	
31734	\N	\N	\N	
31735	\N	\N	\N	
31736	\N	\N	\N	
31737	\N	\N	\N	
31738	\N	\N	\N	
31739	\N	\N	\N	
31740	\N	\N	\N	
31741	\N	\N	\N	
31742	\N	\N	\N	
31743	\N	\N	\N	
31744	\N	\N	\N	
31745	\N	\N	\N	
31746	\N	\N	\N	
31747	\N	\N	\N	
31748	\N	\N	\N	
31749	\N	\N	\N	
31750	\N	\N	\N	
31751	\N	\N	\N	
31752	\N	\N	\N	
31753	\N	\N	\N	
31754	\N	\N	\N	
31755	\N	\N	\N	
31756	\N	\N	\N	
31757	\N	\N	\N	
31758	\N	\N	\N	
31759	\N	\N	\N	
31760	\N	\N	\N	
31761	\N	\N	\N	
31762	\N	\N	\N	
31763	\N	\N	\N	
31764	\N	\N	\N	
31765	\N	\N	\N	
31766	\N	\N	\N	
31767	\N	\N	\N	
31768	\N	\N	\N	
31769	\N	\N	\N	
31770	\N	\N	\N	
31771	\N	\N	\N	
31772	\N	\N	\N	
31773	\N	\N	\N	
31774	\N	\N	\N	
31775	\N	\N	\N	
31776	\N	\N	\N	
31777	\N	\N	\N	
31778	\N	\N	\N	
31779	\N	\N	\N	
31780	\N	\N	\N	
31781	\N	\N	\N	
31782	\N	\N	\N	
31783	\N	\N	\N	
31784	\N	\N	\N	
31785	\N	\N	\N	
31786	\N	\N	\N	
31787	\N	\N	\N	
31788	\N	\N	\N	
31789	\N	\N	\N	
31790	\N	\N	\N	
31791	\N	\N	\N	
31792	\N	\N	\N	
31793	\N	\N	\N	
31794	\N	\N	\N	
31795	\N	\N	\N	
31796	\N	\N	\N	
31797	\N	\N	\N	
31798	\N	\N	\N	
31799	\N	\N	\N	
31800	\N	\N	\N	
31801	\N	\N	\N	
31802	\N	\N	\N	
31803	\N	\N	\N	
31804	\N	\N	\N	
31805	\N	\N	\N	
31806	\N	\N	\N	
31807	\N	\N	\N	
31808	\N	\N	\N	
31809	\N	\N	\N	
31810	\N	\N	\N	
31811	\N	\N	\N	
31812	\N	\N	\N	
31813	\N	\N	\N	
31814	\N	\N	\N	
31815	\N	\N	\N	
31816	\N	\N	\N	
31817	\N	\N	\N	
31818	\N	\N	\N	
31819	\N	\N	\N	
31820	\N	\N	\N	
31821	\N	\N	\N	
31822	\N	\N	\N	
31823	\N	\N	\N	
31824	\N	\N	\N	
31825	\N	\N	\N	
31826	\N	\N	\N	
31827	\N	\N	\N	
31828	\N	\N	\N	
31829	\N	\N	\N	
31830	\N	\N	\N	
31831	\N	\N	\N	
31832	\N	\N	\N	
31833	\N	\N	\N	
31834	\N	\N	\N	
31835	\N	\N	\N	
31836	\N	\N	\N	
31837	\N	\N	\N	
31838	\N	\N	\N	
31839	\N	\N	\N	
31840	\N	\N	\N	
31841	\N	\N	\N	
31842	\N	\N	\N	
31843	\N	\N	\N	
31844	\N	\N	\N	
31845	\N	\N	\N	
31846	\N	\N	\N	
31847	\N	\N	\N	
31848	\N	\N	\N	
31849	\N	\N	\N	
31850	\N	\N	\N	
31851	\N	\N	\N	
31852	\N	\N	\N	
31853	\N	\N	\N	
31854	\N	\N	\N	
31855	\N	\N	\N	
31856	\N	\N	\N	
31857	\N	\N	\N	
31858	\N	\N	\N	
31859	\N	\N	\N	
31860	\N	\N	\N	
31861	\N	\N	\N	
31862	\N	\N	\N	
31863	\N	\N	\N	
31864	\N	\N	\N	
31865	\N	\N	\N	
31866	\N	\N	\N	
31867	\N	\N	\N	
31868	\N	\N	\N	
31869	\N	\N	\N	
31870	\N	\N	\N	
31871	\N	\N	\N	
31872	\N	\N	\N	
31873	\N	\N	\N	
31874	\N	\N	\N	
31875	\N	\N	\N	
31876	\N	\N	\N	
31877	\N	\N	\N	
31878	\N	\N	\N	
31879	\N	\N	\N	
31880	\N	\N	\N	
31881	\N	\N	\N	
31882	\N	\N	\N	
31883	\N	\N	\N	
31884	\N	\N	\N	
31885	\N	\N	\N	
31886	\N	\N	\N	
31887	\N	\N	\N	
31888	\N	\N	\N	
31889	\N	\N	\N	
31890	\N	\N	\N	
31891	\N	\N	\N	
31892	\N	\N	\N	
31893	\N	\N	\N	
31894	\N	\N	\N	
31895	\N	\N	\N	
31896	\N	\N	\N	
31897	\N	\N	\N	
31898	\N	\N	\N	
31899	\N	\N	\N	
31900	\N	\N	\N	
31901	\N	\N	\N	
31902	\N	\N	\N	
31903	\N	\N	\N	
31904	\N	\N	\N	
31905	\N	\N	\N	
31906	\N	\N	\N	
31907	\N	\N	\N	
31908	\N	\N	\N	
31909	\N	\N	\N	
31910	\N	\N	\N	
31911	\N	\N	\N	
31912	\N	\N	\N	
31913	\N	\N	\N	
31914	\N	\N	\N	
31915	\N	\N	\N	
31916	\N	\N	\N	
31917	\N	\N	\N	
31918	\N	\N	\N	
31919	\N	\N	\N	
31920	\N	\N	\N	
31921	\N	\N	\N	
31922	\N	\N	\N	
31923	\N	\N	\N	
31924	\N	\N	\N	
31925	\N	\N	\N	
31926	\N	\N	\N	
31927	\N	\N	\N	
31928	\N	\N	\N	
31929	\N	\N	\N	
31930	\N	\N	\N	
31931	\N	\N	\N	
31932	\N	\N	\N	
31933	\N	\N	\N	
31934	\N	\N	\N	
31935	\N	\N	\N	
31936	\N	\N	\N	
31937	\N	\N	\N	
31938	\N	\N	\N	
31939	\N	\N	\N	
31940	\N	\N	\N	
31941	\N	\N	\N	
31942	\N	\N	\N	
31943	\N	\N	\N	
31944	\N	\N	\N	
31945	\N	\N	\N	
31946	\N	\N	\N	
31947	\N	\N	\N	
31948	\N	\N	\N	
31949	\N	\N	\N	
31950	\N	\N	\N	
31951	\N	\N	\N	
31952	\N	\N	\N	
31953	\N	\N	\N	
31954	\N	\N	\N	
31955	\N	\N	\N	
31956	\N	\N	\N	
31957	\N	\N	\N	
31958	\N	\N	\N	
31959	\N	\N	\N	
31960	\N	\N	\N	
31961	\N	\N	\N	
31962	\N	\N	\N	
31963	\N	\N	\N	
31964	\N	\N	\N	
31965	\N	\N	\N	
31966	\N	\N	\N	
31967	\N	\N	\N	
31968	\N	\N	\N	
31969	\N	\N	\N	
31970	\N	\N	\N	
31971	\N	\N	\N	
31972	\N	\N	\N	
31973	\N	\N	\N	
31974	\N	\N	\N	
31975	\N	\N	\N	
31976	\N	\N	\N	
31977	\N	\N	\N	
31978	\N	\N	\N	
31979	\N	\N	\N	
31980	\N	\N	\N	
31981	\N	\N	\N	
31982	\N	\N	\N	
31983	\N	\N	\N	
31984	\N	\N	\N	
31985	\N	\N	\N	
31986	\N	\N	\N	
31987	\N	\N	\N	
31988	\N	\N	\N	
31989	\N	\N	\N	
31990	\N	\N	\N	
31991	\N	\N	\N	
31992	\N	\N	\N	
31993	\N	\N	\N	
31994	\N	\N	\N	
31995	\N	\N	\N	
31996	\N	\N	\N	
31997	\N	\N	\N	
31998	\N	\N	\N	
31999	\N	\N	\N	
32000	\N	\N	\N	
32001	\N	\N	\N	
32002	\N	\N	\N	
32003	\N	\N	\N	
32004	\N	\N	\N	
32005	\N	\N	\N	
32006	\N	\N	\N	
32007	\N	\N	\N	
32008	\N	\N	\N	
32009	\N	\N	\N	
32010	\N	\N	\N	
32011	\N	\N	\N	
32012	\N	\N	\N	
32013	\N	\N	\N	
32014	\N	\N	\N	
32015	\N	\N	\N	
32016	\N	\N	\N	
32017	\N	\N	\N	
32018	\N	\N	\N	
32019	\N	\N	\N	
32020	\N	\N	\N	
32021	\N	\N	\N	
32022	\N	\N	\N	
32023	\N	\N	\N	
32024	\N	\N	\N	
32025	\N	\N	\N	
32026	\N	\N	\N	
32027	\N	\N	\N	
32028	\N	\N	\N	
32029	\N	\N	\N	
32030	\N	\N	\N	
32031	\N	\N	\N	
32032	\N	\N	\N	
32033	\N	\N	\N	
32034	\N	\N	\N	
32035	\N	\N	\N	
32036	\N	\N	\N	
32037	\N	\N	\N	
32038	\N	\N	\N	
32039	\N	\N	\N	
32040	\N	\N	\N	
32041	\N	\N	\N	
32042	\N	\N	\N	
32043	\N	\N	\N	
32044	\N	\N	\N	
32045	\N	\N	\N	
32046	\N	\N	\N	
32047	\N	\N	\N	
32048	\N	\N	\N	
32049	\N	\N	\N	
32050	\N	\N	\N	
32051	\N	\N	\N	
32052	\N	\N	\N	
32053	\N	\N	\N	
32054	\N	\N	\N	
32055	\N	\N	\N	
32056	\N	\N	\N	
32057	\N	\N	\N	
32058	\N	\N	\N	
32059	\N	\N	\N	
32060	\N	\N	\N	
32061	\N	\N	\N	
32062	\N	\N	\N	
32063	\N	\N	\N	
32064	\N	\N	\N	
32065	\N	\N	\N	
32066	\N	\N	\N	
32067	\N	\N	\N	
32068	\N	\N	\N	
32069	\N	\N	\N	
32070	\N	\N	\N	
32071	\N	\N	\N	
32072	\N	\N	\N	
32073	\N	\N	\N	
32074	\N	\N	\N	
32075	\N	\N	\N	
32076	\N	\N	\N	
32077	\N	\N	\N	
32078	\N	\N	\N	
32079	\N	\N	\N	
32080	\N	\N	\N	
32081	\N	\N	\N	
32082	\N	\N	\N	
32083	\N	\N	\N	
32084	\N	\N	\N	
32085	\N	\N	\N	
32086	\N	\N	\N	
32087	\N	\N	\N	
32088	\N	\N	\N	
32089	\N	\N	\N	
32090	\N	\N	\N	
32091	\N	\N	\N	
32092	\N	\N	\N	
32093	\N	\N	\N	
32094	\N	\N	\N	
32095	\N	\N	\N	
32096	\N	\N	\N	
32097	\N	\N	\N	
32098	\N	\N	\N	
32099	\N	\N	\N	
32100	\N	\N	\N	
32101	\N	\N	\N	
32102	\N	\N	\N	
32103	\N	\N	\N	
32104	\N	\N	\N	
32105	\N	\N	\N	
32106	\N	\N	\N	
32107	\N	\N	\N	
32108	\N	\N	\N	
32109	\N	\N	\N	
32110	\N	\N	\N	
32111	\N	\N	\N	
32112	\N	\N	\N	
32113	\N	\N	\N	
32114	\N	\N	\N	
32115	\N	\N	\N	
32116	\N	\N	\N	
32117	\N	\N	\N	
32118	\N	\N	\N	
32119	\N	\N	\N	
32120	\N	\N	\N	
32121	\N	\N	\N	
32122	\N	\N	\N	
32123	\N	\N	\N	
32124	\N	\N	\N	
32125	\N	\N	\N	
32126	\N	\N	\N	
32127	\N	\N	\N	
32128	\N	\N	\N	
32129	\N	\N	\N	
32130	\N	\N	\N	
32131	\N	\N	\N	
32132	\N	\N	\N	
32133	\N	\N	\N	
32134	\N	\N	\N	
32135	\N	\N	\N	
32136	\N	\N	\N	
32137	\N	\N	\N	
32138	\N	\N	\N	
32139	\N	\N	\N	
32140	\N	\N	\N	
32141	\N	\N	\N	
32142	\N	\N	\N	
32143	\N	\N	\N	
32144	\N	\N	\N	
32145	\N	\N	\N	
32146	\N	\N	\N	
32147	\N	\N	\N	
32148	\N	\N	\N	
32149	\N	\N	\N	
32150	\N	\N	\N	
32151	\N	\N	\N	
32152	\N	\N	\N	
32153	\N	\N	\N	
32154	\N	\N	\N	
32155	\N	\N	\N	
32156	\N	\N	\N	
32157	\N	\N	\N	
32158	\N	\N	\N	
32159	\N	\N	\N	
32160	\N	\N	\N	
32161	\N	\N	\N	
32162	\N	\N	\N	
32163	\N	\N	\N	
32164	\N	\N	\N	
32165	\N	\N	\N	
32166	\N	\N	\N	
32167	\N	\N	\N	
32168	\N	\N	\N	
32169	\N	\N	\N	
32170	\N	\N	\N	
32171	\N	\N	\N	
32172	\N	\N	\N	
32173	\N	\N	\N	
32174	\N	\N	\N	
32175	\N	\N	\N	
32176	\N	\N	\N	
32177	\N	\N	\N	
32178	\N	\N	\N	
32179	\N	\N	\N	
32180	\N	\N	\N	
32181	\N	\N	\N	
32182	\N	\N	\N	
32183	\N	\N	\N	
32184	\N	\N	\N	
32185	\N	\N	\N	
32186	\N	\N	\N	
32187	\N	\N	\N	
32188	\N	\N	\N	
32189	\N	\N	\N	
32190	\N	\N	\N	
32191	\N	\N	\N	
32192	\N	\N	\N	
32193	\N	\N	\N	
32194	\N	\N	\N	
32195	\N	\N	\N	
32196	\N	\N	\N	
32197	\N	\N	\N	
32198	\N	\N	\N	
32199	\N	\N	\N	
32200	\N	\N	\N	
32201	\N	\N	\N	
32202	\N	\N	\N	
32203	\N	\N	\N	
32204	\N	\N	\N	
32205	\N	\N	\N	
32206	\N	\N	\N	
32207	\N	\N	\N	
32208	\N	\N	\N	
32209	\N	\N	\N	
32210	\N	\N	\N	
32211	\N	\N	\N	
32212	\N	\N	\N	
32213	\N	\N	\N	
32214	\N	\N	\N	
32215	\N	\N	\N	
32216	\N	\N	\N	
32217	\N	\N	\N	
32218	\N	\N	\N	
32219	\N	\N	\N	
32220	\N	\N	\N	
32221	\N	\N	\N	
32222	\N	\N	\N	
32223	\N	\N	\N	
32224	\N	\N	\N	
32225	\N	\N	\N	
32226	\N	\N	\N	
32227	\N	\N	\N	
32228	\N	\N	\N	
32229	\N	\N	\N	
32230	\N	\N	\N	
32231	\N	\N	\N	
32232	\N	\N	\N	
32233	\N	\N	\N	
32234	\N	\N	\N	
32235	\N	\N	\N	
32236	\N	\N	\N	
32237	\N	\N	\N	
32238	\N	\N	\N	
32239	\N	\N	\N	
32240	\N	\N	\N	
32241	\N	\N	\N	
32242	\N	\N	\N	
32243	\N	\N	\N	
32244	\N	\N	\N	
32245	\N	\N	\N	
32246	\N	\N	\N	
32247	\N	\N	\N	
32248	\N	\N	\N	
32249	\N	\N	\N	
32250	\N	\N	\N	
32251	\N	\N	\N	
32252	\N	\N	\N	
32253	\N	\N	\N	
32254	\N	\N	\N	
32255	\N	\N	\N	
32256	\N	\N	\N	
32257	\N	\N	\N	
32258	\N	\N	\N	
32259	\N	\N	\N	
32260	\N	\N	\N	
32261	\N	\N	\N	
32262	\N	\N	\N	
32263	\N	\N	\N	
32264	\N	\N	\N	
32265	\N	\N	\N	
32266	\N	\N	\N	
32267	\N	\N	\N	
32268	\N	\N	\N	
32269	\N	\N	\N	
32270	\N	\N	\N	
32271	\N	\N	\N	
32272	\N	\N	\N	
32273	\N	\N	\N	
32274	\N	\N	\N	
32275	\N	\N	\N	
32276	\N	\N	\N	
32277	\N	\N	\N	
32278	\N	\N	\N	
32279	\N	\N	\N	
32280	\N	\N	\N	
32281	\N	\N	\N	
32282	\N	\N	\N	
32283	\N	\N	\N	
32284	\N	\N	\N	
32285	\N	\N	\N	
32286	\N	\N	\N	
32287	\N	\N	\N	
32288	\N	\N	\N	
32289	\N	\N	\N	
32290	\N	\N	\N	
32291	\N	\N	\N	
32292	\N	\N	\N	
32293	\N	\N	\N	
32294	\N	\N	\N	
32295	\N	\N	\N	
32296	\N	\N	\N	
32297	\N	\N	\N	
32298	\N	\N	\N	
32299	\N	\N	\N	
32300	\N	\N	\N	
32301	\N	\N	\N	
32302	\N	\N	\N	
32303	\N	\N	\N	
32304	\N	\N	\N	
32305	\N	\N	\N	
32306	\N	\N	\N	
32307	\N	\N	\N	
32308	\N	\N	\N	
32309	\N	\N	\N	
32310	\N	\N	\N	
32311	\N	\N	\N	
32312	\N	\N	\N	
32313	\N	\N	\N	
32314	\N	\N	\N	
32315	\N	\N	\N	
32316	\N	\N	\N	
32317	\N	\N	\N	
32318	\N	\N	\N	
32319	\N	\N	\N	
32320	\N	\N	\N	
32321	\N	\N	\N	
32322	\N	\N	\N	
32323	\N	\N	\N	
32324	\N	\N	\N	
32325	\N	\N	\N	
32326	\N	\N	\N	
32327	\N	\N	\N	
32328	\N	\N	\N	
32329	\N	\N	\N	
32330	\N	\N	\N	
32331	\N	\N	\N	
32332	\N	\N	\N	
32333	\N	\N	\N	
32334	\N	\N	\N	
32335	\N	\N	\N	
32336	\N	\N	\N	
32337	\N	\N	\N	
32338	\N	\N	\N	
32339	\N	\N	\N	
32340	\N	\N	\N	
32341	\N	\N	\N	
32342	\N	\N	\N	
32343	\N	\N	\N	
32344	\N	\N	\N	
32345	\N	\N	\N	
32346	\N	\N	\N	
32347	\N	\N	\N	
32348	\N	\N	\N	
32349	\N	\N	\N	
32350	\N	\N	\N	
32351	\N	\N	\N	
32352	\N	\N	\N	
32353	\N	\N	\N	
32354	\N	\N	\N	
32355	\N	\N	\N	
32356	\N	\N	\N	
32357	\N	\N	\N	
32358	\N	\N	\N	
32359	\N	\N	\N	
32360	\N	\N	\N	
32361	\N	\N	\N	
32362	\N	\N	\N	
32363	\N	\N	\N	
32364	\N	\N	\N	
32365	\N	\N	\N	
32366	\N	\N	\N	
32367	\N	\N	\N	
32368	\N	\N	\N	
32369	\N	\N	\N	
32370	\N	\N	\N	
32371	\N	\N	\N	
32372	\N	\N	\N	
32373	\N	\N	\N	
32374	\N	\N	\N	
32375	\N	\N	\N	
32376	\N	\N	\N	
32377	\N	\N	\N	
32378	\N	\N	\N	
32379	\N	\N	\N	
32380	\N	\N	\N	
32381	\N	\N	\N	
32382	\N	\N	\N	
32383	\N	\N	\N	
32384	\N	\N	\N	
32385	\N	\N	\N	
32386	\N	\N	\N	
32387	\N	\N	\N	
32388	\N	\N	\N	
32389	\N	\N	\N	
32390	\N	\N	\N	
32391	\N	\N	\N	
32392	\N	\N	\N	
32393	\N	\N	\N	
32394	\N	\N	\N	
32395	\N	\N	\N	
32396	\N	\N	\N	
32397	\N	\N	\N	
32398	\N	\N	\N	
32399	\N	\N	\N	
32400	\N	\N	\N	
32401	\N	\N	\N	
32402	\N	\N	\N	
32403	\N	\N	\N	
32404	\N	\N	\N	
32405	\N	\N	\N	
32406	\N	\N	\N	
32407	\N	\N	\N	
32408	\N	\N	\N	
32409	\N	\N	\N	
32410	\N	\N	\N	
32411	\N	\N	\N	
32412	\N	\N	\N	
32413	\N	\N	\N	
32414	\N	\N	\N	
32415	\N	\N	\N	
32416	\N	\N	\N	
32417	\N	\N	\N	
32418	\N	\N	\N	
32419	\N	\N	\N	
32420	\N	\N	\N	
32421	\N	\N	\N	
32422	\N	\N	\N	
32423	\N	\N	\N	
32424	\N	\N	\N	
32425	\N	\N	\N	
32426	\N	\N	\N	
32427	\N	\N	\N	
32428	\N	\N	\N	
32429	\N	\N	\N	
32430	\N	\N	\N	
32431	\N	\N	\N	
32432	\N	\N	\N	
32433	\N	\N	\N	
32434	\N	\N	\N	
32435	\N	\N	\N	
32436	\N	\N	\N	
32437	\N	\N	\N	
32438	\N	\N	\N	
32439	\N	\N	\N	
32440	\N	\N	\N	
32441	\N	\N	\N	
32442	\N	\N	\N	
32443	\N	\N	\N	
32444	\N	\N	\N	
32445	\N	\N	\N	
32446	\N	\N	\N	
32447	\N	\N	\N	
32448	\N	\N	\N	
32449	\N	\N	\N	
32450	\N	\N	\N	
32451	\N	\N	\N	
32452	\N	\N	\N	
32453	\N	\N	\N	
32454	\N	\N	\N	
32455	\N	\N	\N	
32456	\N	\N	\N	
32457	\N	\N	\N	
32458	\N	\N	\N	
32459	\N	\N	\N	
32460	\N	\N	\N	
32461	\N	\N	\N	
32462	\N	\N	\N	
32463	\N	\N	\N	
32464	\N	\N	\N	
32465	\N	\N	\N	
32466	\N	\N	\N	
32467	\N	\N	\N	
32468	\N	\N	\N	
32469	\N	\N	\N	
32470	\N	\N	\N	
32471	\N	\N	\N	
32472	\N	\N	\N	
32473	\N	\N	\N	
32474	\N	\N	\N	
32475	\N	\N	\N	
32476	\N	\N	\N	
32477	\N	\N	\N	
32478	\N	\N	\N	
32479	\N	\N	\N	
32480	\N	\N	\N	
32481	\N	\N	\N	
32482	\N	\N	\N	
32483	\N	\N	\N	
32484	\N	\N	\N	
32485	\N	\N	\N	
32486	\N	\N	\N	
32487	\N	\N	\N	
32488	\N	\N	\N	
32489	\N	\N	\N	
32490	\N	\N	\N	
32491	\N	\N	\N	
32492	\N	\N	\N	
32493	\N	\N	\N	
32494	\N	\N	\N	
32495	\N	\N	\N	
32496	\N	\N	\N	
32497	\N	\N	\N	
32498	\N	\N	\N	
32499	\N	\N	\N	
32500	\N	\N	\N	
32501	\N	\N	\N	
32502	\N	\N	\N	
32503	\N	\N	\N	
32504	\N	\N	\N	
32505	\N	\N	\N	
32506	\N	\N	\N	
32507	\N	\N	\N	
32508	\N	\N	\N	
32509	\N	\N	\N	
32510	\N	\N	\N	
32511	\N	\N	\N	
32512	\N	\N	\N	
32513	\N	\N	\N	
32514	\N	\N	\N	
32515	\N	\N	\N	
32516	\N	\N	\N	
32517	\N	\N	\N	
32518	\N	\N	\N	
32519	\N	\N	\N	
32520	\N	\N	\N	
32521	\N	\N	\N	
32522	\N	\N	\N	
32523	\N	\N	\N	
32524	\N	\N	\N	
32525	\N	\N	\N	
32526	\N	\N	\N	
32527	\N	\N	\N	
32528	\N	\N	\N	
32529	\N	\N	\N	
32530	\N	\N	\N	
32531	\N	\N	\N	
32532	\N	\N	\N	
32533	\N	\N	\N	
32534	\N	\N	\N	
32535	\N	\N	\N	
32536	\N	\N	\N	
32537	\N	\N	\N	
32538	\N	\N	\N	
32539	\N	\N	\N	
32540	\N	\N	\N	
32541	\N	\N	\N	
32542	\N	\N	\N	
32543	\N	\N	\N	
32544	\N	\N	\N	
32545	\N	\N	\N	
32546	\N	\N	\N	
32547	\N	\N	\N	
32548	\N	\N	\N	
32549	\N	\N	\N	
32550	\N	\N	\N	
32551	\N	\N	\N	
32552	\N	\N	\N	
32553	\N	\N	\N	
32554	\N	\N	\N	
32555	\N	\N	\N	
32556	\N	\N	\N	
32557	\N	\N	\N	
32558	\N	\N	\N	
32559	\N	\N	\N	
32560	\N	\N	\N	
32561	\N	\N	\N	
32562	\N	\N	\N	
32563	\N	\N	\N	
32564	\N	\N	\N	
32565	\N	\N	\N	
32566	\N	\N	\N	
32567	\N	\N	\N	
32568	\N	\N	\N	
32569	\N	\N	\N	
32570	\N	\N	\N	
32571	\N	\N	\N	
32572	\N	\N	\N	
32573	\N	\N	\N	
32574	\N	\N	\N	
32575	\N	\N	\N	
32576	\N	\N	\N	
32577	\N	\N	\N	
32578	\N	\N	\N	
32579	\N	\N	\N	
32580	\N	\N	\N	
32581	\N	\N	\N	
32582	\N	\N	\N	
32583	\N	\N	\N	
32584	\N	\N	\N	
32585	\N	\N	\N	
32586	\N	\N	\N	
32587	\N	\N	\N	
32588	\N	\N	\N	
32589	\N	\N	\N	
32590	\N	\N	\N	
32591	\N	\N	\N	
32592	\N	\N	\N	
32593	\N	\N	\N	
32594	\N	\N	\N	
32595	\N	\N	\N	
32596	\N	\N	\N	
32597	\N	\N	\N	
32598	\N	\N	\N	
32599	\N	\N	\N	
32600	\N	\N	\N	
32601	\N	\N	\N	
32602	\N	\N	\N	
32603	\N	\N	\N	
32604	\N	\N	\N	
32605	\N	\N	\N	
32606	\N	\N	\N	
32607	\N	\N	\N	
32608	\N	\N	\N	
32609	\N	\N	\N	
32610	\N	\N	\N	
32611	\N	\N	\N	
32612	\N	\N	\N	
32613	\N	\N	\N	
32614	\N	\N	\N	
32615	\N	\N	\N	
32616	\N	\N	\N	
32617	\N	\N	\N	
32618	\N	\N	\N	
32619	\N	\N	\N	
32620	\N	\N	\N	
32621	\N	\N	\N	
32622	\N	\N	\N	
32623	\N	\N	\N	
32624	\N	\N	\N	
32625	\N	\N	\N	
32626	\N	\N	\N	
32627	\N	\N	\N	
32628	\N	\N	\N	
32629	\N	\N	\N	
32630	\N	\N	\N	
32631	\N	\N	\N	
32632	\N	\N	\N	
32633	\N	\N	\N	
32634	\N	\N	\N	
32635	\N	\N	\N	
32636	\N	\N	\N	
32637	\N	\N	\N	
32638	\N	\N	\N	
32639	\N	\N	\N	
32640	\N	\N	\N	
32641	\N	\N	\N	
32642	\N	\N	\N	
32643	\N	\N	\N	
32644	\N	\N	\N	
32645	\N	\N	\N	
32646	\N	\N	\N	
32647	\N	\N	\N	
32648	\N	\N	\N	
32649	\N	\N	\N	
32650	\N	\N	\N	
32651	\N	\N	\N	
32652	\N	\N	\N	
32653	\N	\N	\N	
32654	\N	\N	\N	
32655	\N	\N	\N	
32656	\N	\N	\N	
32657	\N	\N	\N	
32658	\N	\N	\N	
32659	\N	\N	\N	
32660	\N	\N	\N	
32661	\N	\N	\N	
32662	\N	\N	\N	
32663	\N	\N	\N	
32664	\N	\N	\N	
32665	\N	\N	\N	
32666	\N	\N	\N	
32667	\N	\N	\N	
32668	\N	\N	\N	
32669	\N	\N	\N	
32670	\N	\N	\N	
32671	\N	\N	\N	
32672	\N	\N	\N	
32673	\N	\N	\N	
32674	\N	\N	\N	
32675	\N	\N	\N	
32676	\N	\N	\N	
32677	\N	\N	\N	
32678	\N	\N	\N	
32679	\N	\N	\N	
32680	\N	\N	\N	
32681	\N	\N	\N	
32682	\N	\N	\N	
32683	\N	\N	\N	
32684	\N	\N	\N	
32685	\N	\N	\N	
32686	\N	\N	\N	
32687	\N	\N	\N	
32688	\N	\N	\N	
32689	\N	\N	\N	
32690	\N	\N	\N	
32691	\N	\N	\N	
32692	\N	\N	\N	
32693	\N	\N	\N	
32694	\N	\N	\N	
32695	\N	\N	\N	
32696	\N	\N	\N	
32697	\N	\N	\N	
32698	\N	\N	\N	
32699	\N	\N	\N	
32700	\N	\N	\N	
32701	\N	\N	\N	
32702	\N	\N	\N	
32703	\N	\N	\N	
32704	\N	\N	\N	
32705	\N	\N	\N	
32706	\N	\N	\N	
32707	\N	\N	\N	
32708	\N	\N	\N	
32709	\N	\N	\N	
32710	\N	\N	\N	
32711	\N	\N	\N	
32712	\N	\N	\N	
32713	\N	\N	\N	
32714	\N	\N	\N	
32715	\N	\N	\N	
32716	\N	\N	\N	
32717	\N	\N	\N	
32718	\N	\N	\N	
32719	\N	\N	\N	
32720	\N	\N	\N	
32721	\N	\N	\N	
32722	\N	\N	\N	
32723	\N	\N	\N	
32724	\N	\N	\N	
32725	\N	\N	\N	
32726	\N	\N	\N	
32727	\N	\N	\N	
32728	\N	\N	\N	
32729	\N	\N	\N	
32730	\N	\N	\N	
32731	\N	\N	\N	
32732	\N	\N	\N	
32733	\N	\N	\N	
32734	\N	\N	\N	
32735	\N	\N	\N	
32736	\N	\N	\N	
32737	\N	\N	\N	
32738	\N	\N	\N	
32739	\N	\N	\N	
32740	\N	\N	\N	
32741	\N	\N	\N	
32742	\N	\N	\N	
32743	\N	\N	\N	
32744	\N	\N	\N	
32745	\N	\N	\N	
32746	\N	\N	\N	
32747	\N	\N	\N	
32748	\N	\N	\N	
32749	\N	\N	\N	
32750	\N	\N	\N	
32751	\N	\N	\N	
32752	\N	\N	\N	
32753	\N	\N	\N	
32754	\N	\N	\N	
32755	\N	\N	\N	
32756	\N	\N	\N	
32757	\N	\N	\N	
32758	\N	\N	\N	
32759	\N	\N	\N	
32760	\N	\N	\N	
32761	\N	\N	\N	
32762	\N	\N	\N	
32763	\N	\N	\N	
32764	\N	\N	\N	
32765	\N	\N	\N	
32766	\N	\N	\N	
32767	\N	\N	\N	
32768	\N	\N	\N	
32769	\N	\N	\N	
32770	\N	\N	\N	
32771	\N	\N	\N	
32772	\N	\N	\N	
32773	\N	\N	\N	
32774	\N	\N	\N	
32775	\N	\N	\N	
32776	\N	\N	\N	
32777	\N	\N	\N	
32778	\N	\N	\N	
32779	\N	\N	\N	
32780	\N	\N	\N	
32781	\N	\N	\N	
32782	\N	\N	\N	
32783	\N	\N	\N	
32784	\N	\N	\N	
32785	\N	\N	\N	
32786	\N	\N	\N	
32787	\N	\N	\N	
32788	\N	\N	\N	
32789	\N	\N	\N	
32790	\N	\N	\N	
32791	\N	\N	\N	
32792	\N	\N	\N	
32793	\N	\N	\N	
32794	\N	\N	\N	
32795	\N	\N	\N	
32796	\N	\N	\N	
32797	\N	\N	\N	
32798	\N	\N	\N	
32799	\N	\N	\N	
32800	\N	\N	\N	
32801	\N	\N	\N	
32802	\N	\N	\N	
32803	\N	\N	\N	
32804	\N	\N	\N	
32805	\N	\N	\N	
32806	\N	\N	\N	
32807	\N	\N	\N	
32808	\N	\N	\N	
32809	\N	\N	\N	
32810	\N	\N	\N	
32811	\N	\N	\N	
32812	\N	\N	\N	
32813	\N	\N	\N	
32814	\N	\N	\N	
32815	\N	\N	\N	
32816	\N	\N	\N	
32817	\N	\N	\N	
32818	\N	\N	\N	
32819	\N	\N	\N	
32820	\N	\N	\N	
32821	\N	\N	\N	
32822	\N	\N	\N	
32823	\N	\N	\N	
32824	\N	\N	\N	
32825	\N	\N	\N	
32826	\N	\N	\N	
32827	\N	\N	\N	
32828	\N	\N	\N	
32829	\N	\N	\N	
32830	\N	\N	\N	
32831	\N	\N	\N	
32832	\N	\N	\N	
32833	\N	\N	\N	
32834	\N	\N	\N	
32835	\N	\N	\N	
32836	\N	\N	\N	
32837	\N	\N	\N	
32838	\N	\N	\N	
32839	\N	\N	\N	
32840	\N	\N	\N	
32841	\N	\N	\N	
32842	\N	\N	\N	
32843	\N	\N	\N	
32844	\N	\N	\N	
32845	\N	\N	\N	
32846	\N	\N	\N	
32847	\N	\N	\N	
32848	\N	\N	\N	
32849	\N	\N	\N	
32850	\N	\N	\N	
32851	\N	\N	\N	
32852	\N	\N	\N	
32853	\N	\N	\N	
32854	\N	\N	\N	
32855	\N	\N	\N	
32856	\N	\N	\N	
32857	\N	\N	\N	
32858	\N	\N	\N	
32859	\N	\N	\N	
32860	\N	\N	\N	
32861	\N	\N	\N	
32862	\N	\N	\N	
32863	\N	\N	\N	
32864	\N	\N	\N	
32865	\N	\N	\N	
32866	\N	\N	\N	
32867	\N	\N	\N	
32868	\N	\N	\N	
32869	\N	\N	\N	
32870	\N	\N	\N	
32871	\N	\N	\N	
32872	\N	\N	\N	
32873	\N	\N	\N	
32874	\N	\N	\N	
32875	\N	\N	\N	
32876	\N	\N	\N	
32877	\N	\N	\N	
32878	\N	\N	\N	
32879	\N	\N	\N	
32880	\N	\N	\N	
32881	\N	\N	\N	
32882	\N	\N	\N	
32883	\N	\N	\N	
32884	\N	\N	\N	
32885	\N	\N	\N	
32886	\N	\N	\N	
32887	\N	\N	\N	
32888	\N	\N	\N	
32889	\N	\N	\N	
32890	\N	\N	\N	
32891	\N	\N	\N	
32892	\N	\N	\N	
32893	\N	\N	\N	
32894	\N	\N	\N	
32895	\N	\N	\N	
32896	\N	\N	\N	
32897	\N	\N	\N	
32898	\N	\N	\N	
32899	\N	\N	\N	
32900	\N	\N	\N	
32901	\N	\N	\N	
32902	\N	\N	\N	
32903	\N	\N	\N	
32904	\N	\N	\N	
32905	\N	\N	\N	
32906	\N	\N	\N	
32907	\N	\N	\N	
32908	\N	\N	\N	
32909	\N	\N	\N	
32910	\N	\N	\N	
32911	\N	\N	\N	
32912	\N	\N	\N	
32913	\N	\N	\N	
32914	\N	\N	\N	
32915	\N	\N	\N	
32916	\N	\N	\N	
32917	\N	\N	\N	
32918	\N	\N	\N	
32919	\N	\N	\N	
32920	\N	\N	\N	
32921	\N	\N	\N	
32922	\N	\N	\N	
32923	\N	\N	\N	
32924	\N	\N	\N	
32925	\N	\N	\N	
32926	\N	\N	\N	
32927	\N	\N	\N	
32928	\N	\N	\N	
32929	\N	\N	\N	
32930	\N	\N	\N	
32931	\N	\N	\N	
32932	\N	\N	\N	
32933	\N	\N	\N	
32934	\N	\N	\N	
32935	\N	\N	\N	
32936	\N	\N	\N	
32937	\N	\N	\N	
32938	\N	\N	\N	
32939	\N	\N	\N	
32940	\N	\N	\N	
32941	\N	\N	\N	
32942	\N	\N	\N	
32943	\N	\N	\N	
32944	\N	\N	\N	
32945	\N	\N	\N	
32946	\N	\N	\N	
32947	\N	\N	\N	
32948	\N	\N	\N	
32949	\N	\N	\N	
32950	\N	\N	\N	
32951	\N	\N	\N	
32952	\N	\N	\N	
32953	\N	\N	\N	
32954	\N	\N	\N	
32955	\N	\N	\N	
32956	\N	\N	\N	
32957	\N	\N	\N	
32958	\N	\N	\N	
32959	\N	\N	\N	
32960	\N	\N	\N	
32961	\N	\N	\N	
32962	\N	\N	\N	
32963	\N	\N	\N	
32964	\N	\N	\N	
32965	\N	\N	\N	
32966	\N	\N	\N	
32967	\N	\N	\N	
32968	\N	\N	\N	
32969	\N	\N	\N	
32970	\N	\N	\N	
32971	\N	\N	\N	
32972	\N	\N	\N	
32973	\N	\N	\N	
32974	\N	\N	\N	
32975	\N	\N	\N	
32976	\N	\N	\N	
32977	\N	\N	\N	
32978	\N	\N	\N	
32979	\N	\N	\N	
32980	\N	\N	\N	
32981	\N	\N	\N	
32982	\N	\N	\N	
32983	\N	\N	\N	
32984	\N	\N	\N	
32985	\N	\N	\N	
32986	\N	\N	\N	
32987	\N	\N	\N	
32988	\N	\N	\N	
32989	\N	\N	\N	
32990	\N	\N	\N	
32991	\N	\N	\N	
32992	\N	\N	\N	
32993	\N	\N	\N	
32994	\N	\N	\N	
32995	\N	\N	\N	
32996	\N	\N	\N	
32997	\N	\N	\N	
32998	\N	\N	\N	
32999	\N	\N	\N	
33000	\N	\N	\N	
33001	\N	\N	\N	
33002	\N	\N	\N	
33003	\N	\N	\N	
33004	\N	\N	\N	
33005	\N	\N	\N	
33006	\N	\N	\N	
33007	\N	\N	\N	
33008	\N	\N	\N	
33009	\N	\N	\N	
33010	\N	\N	\N	
33011	\N	\N	\N	
33012	\N	\N	\N	
33013	\N	\N	\N	
33014	\N	\N	\N	
33015	\N	\N	\N	
33016	\N	\N	\N	
33017	\N	\N	\N	
33018	\N	\N	\N	
33019	\N	\N	\N	
33020	\N	\N	\N	
33021	\N	\N	\N	
33022	\N	\N	\N	
33023	\N	\N	\N	
33024	\N	\N	\N	
33025	\N	\N	\N	
33026	\N	\N	\N	
33027	\N	\N	\N	
33028	\N	\N	\N	
33029	\N	\N	\N	
33030	\N	\N	\N	
33031	\N	\N	\N	
33032	\N	\N	\N	
33033	\N	\N	\N	
33034	\N	\N	\N	
33035	\N	\N	\N	
33036	\N	\N	\N	
33037	\N	\N	\N	
33038	\N	\N	\N	
33039	\N	\N	\N	
33040	\N	\N	\N	
33041	\N	\N	\N	
33042	\N	\N	\N	
33043	\N	\N	\N	
33044	\N	\N	\N	
33045	\N	\N	\N	
33046	\N	\N	\N	
33047	\N	\N	\N	
33048	\N	\N	\N	
33049	\N	\N	\N	
33050	\N	\N	\N	
33051	\N	\N	\N	
33052	\N	\N	\N	
33053	\N	\N	\N	
33054	\N	\N	\N	
33055	\N	\N	\N	
33056	\N	\N	\N	
33057	\N	\N	\N	
33058	\N	\N	\N	
33059	\N	\N	\N	
33060	\N	\N	\N	
33061	\N	\N	\N	
33062	\N	\N	\N	
33063	\N	\N	\N	
33064	\N	\N	\N	
33065	\N	\N	\N	
33066	\N	\N	\N	
33067	\N	\N	\N	
33068	\N	\N	\N	
33069	\N	\N	\N	
33070	\N	\N	\N	
33071	\N	\N	\N	
33072	\N	\N	\N	
33073	\N	\N	\N	
33074	\N	\N	\N	
33075	\N	\N	\N	
33076	\N	\N	\N	
33077	\N	\N	\N	
33078	\N	\N	\N	
33079	\N	\N	\N	
33080	\N	\N	\N	
33081	\N	\N	\N	
33082	\N	\N	\N	
33083	\N	\N	\N	
33084	\N	\N	\N	
33085	\N	\N	\N	
33086	\N	\N	\N	
33087	\N	\N	\N	
33088	\N	\N	\N	
33089	\N	\N	\N	
33090	\N	\N	\N	
33091	\N	\N	\N	
33092	\N	\N	\N	
33093	\N	\N	\N	
33094	\N	\N	\N	
33095	\N	\N	\N	
33096	\N	\N	\N	
33097	\N	\N	\N	
33098	\N	\N	\N	
33099	\N	\N	\N	
33100	\N	\N	\N	
33101	\N	\N	\N	
33102	\N	\N	\N	
33103	\N	\N	\N	
33104	\N	\N	\N	
33105	\N	\N	\N	
33106	\N	\N	\N	
33107	\N	\N	\N	
33108	\N	\N	\N	
33109	\N	\N	\N	
33110	\N	\N	\N	
33111	\N	\N	\N	
33112	\N	\N	\N	
33143	\N	\N	\N	
33144	\N	\N	\N	
33145	\N	\N	\N	
33146	\N	\N	\N	
33147	\N	\N	\N	
33148	\N	\N	\N	
33149	\N	\N	\N	
33150	\N	\N	\N	
33151	\N	\N	\N	
33152	\N	\N	\N	
33153	\N	\N	\N	
33154	\N	\N	\N	
33155	\N	\N	\N	
33156	\N	\N	\N	
33157	\N	\N	\N	
33158	\N	\N	\N	
33159	\N	\N	\N	
33160	\N	\N	\N	
33161	\N	\N	\N	
33162	\N	\N	\N	
33163	\N	\N	\N	
33164	\N	\N	\N	
33165	\N	\N	\N	
33166	\N	\N	\N	
33167	\N	\N	\N	
33168	\N	\N	\N	
33169	\N	\N	\N	
33170	\N	\N	\N	
33171	\N	\N	\N	
33172	\N	\N	\N	
33173	\N	\N	\N	
33174	\N	\N	\N	
33175	\N	\N	\N	
33176	\N	\N	\N	
33177	\N	\N	\N	
33178	\N	\N	\N	
33179	\N	\N	\N	
33180	\N	\N	\N	
33181	\N	\N	\N	
33182	\N	\N	\N	
33183	\N	\N	\N	
33184	\N	\N	\N	
33185	\N	\N	\N	
33186	\N	\N	\N	
33187	\N	\N	\N	
33188	\N	\N	\N	
33189	\N	\N	\N	
33190	\N	\N	\N	
33191	\N	\N	\N	
33192	\N	\N	\N	
33193	\N	\N	\N	
33194	\N	\N	\N	
33195	\N	\N	\N	
33196	\N	\N	\N	
33197	\N	\N	\N	
33198	\N	\N	\N	
33199	\N	\N	\N	
33200	\N	\N	\N	
33201	\N	\N	\N	
33202	\N	\N	\N	
33203	\N	\N	\N	
33204	\N	\N	\N	
33205	\N	\N	\N	
33206	\N	\N	\N	
33207	\N	\N	\N	
33208	\N	\N	\N	
33209	\N	\N	\N	
33210	\N	\N	\N	
33211	\N	\N	\N	
33212	\N	\N	\N	
33213	\N	\N	\N	
33214	\N	\N	\N	
33215	\N	\N	\N	
33216	\N	\N	\N	
33217	\N	\N	\N	
33218	\N	\N	\N	
33219	\N	\N	\N	
33220	\N	\N	\N	
33221	\N	\N	\N	
33222	\N	\N	\N	
33223	\N	\N	\N	
33224	\N	\N	\N	
33225	\N	\N	\N	
33226	\N	\N	\N	
33227	\N	\N	\N	
33228	\N	\N	\N	
33229	\N	\N	\N	
33230	\N	\N	\N	
33231	\N	\N	\N	
33232	\N	\N	\N	
33233	\N	\N	\N	
33234	\N	\N	\N	
33235	\N	\N	\N	
33236	\N	\N	\N	
33237	\N	\N	\N	
33238	\N	\N	\N	
33239	\N	\N	\N	
33240	\N	\N	\N	
33241	\N	\N	\N	
33242	\N	\N	\N	
33243	\N	\N	\N	
33244	\N	\N	\N	
33245	\N	\N	\N	
33246	\N	\N	\N	
33247	\N	\N	\N	
33248	\N	\N	\N	
\.


--
-- TOC entry 3479 (class 0 OID 57664)
-- Dependencies: 217
-- Data for Name: cidades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cidades (id, nome, pais_id) FROM stdin;
17	Berlim	17
18	Munique	17
19	Dortmund	17
20	Colônia	17
21	Frankfurt	17
22	Stuttgart	17
23	Hamburgo	17
24	Leipzig	17
\.


--
-- TOC entry 3505 (class 0 OID 57866)
-- Dependencies: 243
-- Data for Name: classificacoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classificacoes (id, grupo_id, selecao_id, pontos, jogos, vitorias, empates, derrotas, gols_pro, gols_contra, saldo_gols) FROM stdin;
3	5	19	0	17	22	0	11	42	23	19
4	5	20	3	16	20	0	10	39	28	11
14	8	30	0	6	6	0	6	6	22	-16
5	6	21	3	12	16	2	6	26	10	16
8	6	24	0	8	8	1	7	8	20	-12
15	8	31	0	6	7	0	5	10	12	-2
6	6	22	1	10	11	1	6	23	21	2
7	6	23	1	10	9	2	7	15	21	-6
12	7	28	6	7	9	1	3	26	14	12
10	7	26	1	7	6	2	5	22	28	-6
16	8	32	4	7	9	1	3	19	5	14
13	8	29	1	7	8	1	4	17	13	4
9	7	25	0	6	6	1	5	12	22	-10
1	5	17	0	20	23	0	17	32	44	-12
2	5	18	3	18	20	0	14	28	47	-19
11	7	27	0	6	8	0	4	16	12	4
\.


--
-- TOC entry 3493 (class 0 OID 57759)
-- Dependencies: 231
-- Data for Name: equipes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.equipes (id, jogo_id, selecao_id) FROM stdin;
\.


--
-- TOC entry 3481 (class 0 OID 57676)
-- Dependencies: 219
-- Data for Name: estadios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.estadios (id, nome, cidade_id, capacidade) FROM stdin;
9	Olympiastadion	17	75000
10	Allianz Arena	18	75000
11	Signal Iduna Park	19	81365
12	RheinEnergieStadion	20	50000
13	Commerzbank-Arena	21	51500
14	Mercedes-Benz Arena	22	60469
15	Volksparkstadion	23	57000
16	Red Bull Arena	24	42000
\.


--
-- TOC entry 3501 (class 0 OID 57832)
-- Dependencies: 239
-- Data for Name: estatisticas_equipe; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.estatisticas_equipe (id, jogo_id, selecao_id, remates, livres, foras_de_jogo) FROM stdin;
1418	812	17	5	4	4
1419	812	18	17	7	1
1436	822	18	0	2	4
1437	822	20	15	9	4
1454	831	25	8	4	1
1455	831	27	13	3	3
1472	840	30	11	5	2
1473	840	32	3	3	1
1490	849	18	14	7	3
1491	849	19	18	4	1
1420	813	17	7	3	1
1421	813	19	16	9	2
1438	823	19	14	4	0
1439	823	20	11	2	3
1456	832	25	12	1	3
1457	832	28	19	4	1
1474	841	31	8	1	1
1475	841	32	10	3	3
1492	850	18	17	5	2
1493	850	20	11	8	4
1422	814	17	12	2	0
1423	814	20	11	2	2
1440	824	21	6	3	4
1441	824	22	0	3	3
1458	833	26	12	6	3
1459	833	27	10	0	1
1476	842	19	14	8	2
1477	842	20	4	4	0
1494	851	19	0	9	1
1495	851	20	16	3	4
1424	815	18	11	1	4
1425	815	19	5	7	3
1442	825	21	2	3	1
1443	825	23	2	5	0
1460	834	26	6	4	3
1461	834	28	11	6	2
1478	843	22	14	5	0
1479	843	23	3	8	3
1496	852	21	16	4	2
1497	852	22	14	0	2
1426	817	17	18	8	2
1427	817	18	5	2	0
1444	826	21	2	9	2
1445	826	24	2	1	1
1462	835	27	11	9	1
1463	835	28	10	2	2
1480	844	28	11	6	3
1481	844	26	8	8	3
1498	853	21	2	7	3
1499	853	23	12	7	1
1428	818	17	17	6	4
1429	818	18	14	9	0
1446	827	22	9	1	0
1447	827	23	12	2	0
1464	836	29	16	8	4
1465	836	30	7	0	1
1482	845	32	17	1	4
1483	845	29	0	2	3
1500	854	21	1	8	2
1501	854	24	14	6	4
1430	819	17	17	6	1
1431	819	19	14	7	1
1448	828	22	3	6	1
1449	828	24	11	7	4
1466	837	29	16	3	1
1467	837	31	0	7	1
1484	846	17	13	8	0
1485	846	18	10	5	4
1432	820	17	1	0	2
1433	820	20	2	4	0
1450	829	23	10	8	1
1451	829	24	13	1	4
1468	838	29	0	2	3
1469	838	32	16	3	3
1486	847	17	7	1	2
1487	847	19	16	5	3
1	\N	\N	\N	\N	\N
2	\N	\N	\N	\N	\N
1326	\N	\N	\N	\N	\N
1327	\N	\N	\N	\N	\N
1330	\N	\N	\N	\N	\N
1331	\N	\N	\N	\N	\N
1334	\N	\N	\N	\N	\N
1335	\N	\N	\N	\N	\N
1338	\N	\N	\N	\N	\N
1339	\N	\N	\N	\N	\N
1342	\N	\N	\N	\N	\N
1343	\N	\N	\N	\N	\N
1346	\N	\N	\N	\N	\N
1347	\N	\N	\N	\N	\N
1350	\N	\N	\N	\N	\N
1351	\N	\N	\N	\N	\N
1354	\N	\N	\N	\N	\N
1355	\N	\N	\N	\N	\N
1358	\N	\N	\N	\N	\N
1359	\N	\N	\N	\N	\N
1362	\N	\N	\N	\N	\N
1363	\N	\N	\N	\N	\N
1366	\N	\N	\N	\N	\N
1367	\N	\N	\N	\N	\N
1370	\N	\N	\N	\N	\N
1371	\N	\N	\N	\N	\N
1374	\N	\N	\N	\N	\N
1375	\N	\N	\N	\N	\N
1378	\N	\N	\N	\N	\N
1379	\N	\N	\N	\N	\N
1382	\N	\N	\N	\N	\N
1383	\N	\N	\N	\N	\N
1386	\N	\N	\N	\N	\N
1387	\N	\N	\N	\N	\N
1390	\N	\N	\N	\N	\N
1391	\N	\N	\N	\N	\N
1394	\N	\N	\N	\N	\N
1395	\N	\N	\N	\N	\N
1398	\N	\N	\N	\N	\N
1399	\N	\N	\N	\N	\N
1402	\N	\N	\N	\N	\N
1403	\N	\N	\N	\N	\N
1406	\N	\N	\N	\N	\N
1407	\N	\N	\N	\N	\N
1410	\N	\N	\N	\N	\N
1411	\N	\N	\N	\N	\N
1414	\N	\N	\N	\N	\N
1415	\N	\N	\N	\N	\N
1416	\N	\N	\N	\N	\N
1417	\N	\N	\N	\N	\N
164	\N	\N	\N	\N	\N
165	\N	\N	\N	\N	\N
166	\N	\N	\N	\N	\N
167	\N	\N	\N	\N	\N
168	\N	\N	\N	\N	\N
169	\N	\N	\N	\N	\N
170	\N	\N	\N	\N	\N
171	\N	\N	\N	\N	\N
172	\N	\N	\N	\N	\N
173	\N	\N	\N	\N	\N
174	\N	\N	\N	\N	\N
175	\N	\N	\N	\N	\N
176	\N	\N	\N	\N	\N
177	\N	\N	\N	\N	\N
178	\N	\N	\N	\N	\N
179	\N	\N	\N	\N	\N
180	\N	\N	\N	\N	\N
181	\N	\N	\N	\N	\N
182	\N	\N	\N	\N	\N
183	\N	\N	\N	\N	\N
184	\N	\N	\N	\N	\N
185	\N	\N	\N	\N	\N
186	\N	\N	\N	\N	\N
187	\N	\N	\N	\N	\N
188	\N	\N	\N	\N	\N
189	\N	\N	\N	\N	\N
190	\N	\N	\N	\N	\N
191	\N	\N	\N	\N	\N
192	\N	\N	\N	\N	\N
193	\N	\N	\N	\N	\N
194	\N	\N	\N	\N	\N
195	\N	\N	\N	\N	\N
196	\N	\N	\N	\N	\N
197	\N	\N	\N	\N	\N
198	\N	\N	\N	\N	\N
199	\N	\N	\N	\N	\N
200	\N	\N	\N	\N	\N
201	\N	\N	\N	\N	\N
202	\N	\N	\N	\N	\N
203	\N	\N	\N	\N	\N
204	\N	\N	\N	\N	\N
205	\N	\N	\N	\N	\N
206	\N	\N	\N	\N	\N
207	\N	\N	\N	\N	\N
208	\N	\N	\N	\N	\N
209	\N	\N	\N	\N	\N
210	\N	\N	\N	\N	\N
211	\N	\N	\N	\N	\N
212	\N	\N	\N	\N	\N
213	\N	\N	\N	\N	\N
214	\N	\N	\N	\N	\N
215	\N	\N	\N	\N	\N
216	\N	\N	\N	\N	\N
217	\N	\N	\N	\N	\N
218	\N	\N	\N	\N	\N
219	\N	\N	\N	\N	\N
220	\N	\N	\N	\N	\N
221	\N	\N	\N	\N	\N
222	\N	\N	\N	\N	\N
223	\N	\N	\N	\N	\N
224	\N	\N	\N	\N	\N
225	\N	\N	\N	\N	\N
226	\N	\N	\N	\N	\N
227	\N	\N	\N	\N	\N
228	\N	\N	\N	\N	\N
229	\N	\N	\N	\N	\N
230	\N	\N	\N	\N	\N
231	\N	\N	\N	\N	\N
232	\N	\N	\N	\N	\N
233	\N	\N	\N	\N	\N
234	\N	\N	\N	\N	\N
235	\N	\N	\N	\N	\N
236	\N	\N	\N	\N	\N
237	\N	\N	\N	\N	\N
238	\N	\N	\N	\N	\N
239	\N	\N	\N	\N	\N
240	\N	\N	\N	\N	\N
241	\N	\N	\N	\N	\N
242	\N	\N	\N	\N	\N
243	\N	\N	\N	\N	\N
244	\N	\N	\N	\N	\N
245	\N	\N	\N	\N	\N
246	\N	\N	\N	\N	\N
247	\N	\N	\N	\N	\N
248	\N	\N	\N	\N	\N
249	\N	\N	\N	\N	\N
250	\N	\N	\N	\N	\N
251	\N	\N	\N	\N	\N
252	\N	\N	\N	\N	\N
253	\N	\N	\N	\N	\N
254	\N	\N	\N	\N	\N
255	\N	\N	\N	\N	\N
256	\N	\N	\N	\N	\N
257	\N	\N	\N	\N	\N
258	\N	\N	\N	\N	\N
259	\N	\N	\N	\N	\N
260	\N	\N	\N	\N	\N
261	\N	\N	\N	\N	\N
262	\N	\N	\N	\N	\N
263	\N	\N	\N	\N	\N
264	\N	\N	\N	\N	\N
265	\N	\N	\N	\N	\N
266	\N	\N	\N	\N	\N
267	\N	\N	\N	\N	\N
268	\N	\N	\N	\N	\N
269	\N	\N	\N	\N	\N
270	\N	\N	\N	\N	\N
271	\N	\N	\N	\N	\N
272	\N	\N	\N	\N	\N
273	\N	\N	\N	\N	\N
274	\N	\N	\N	\N	\N
275	\N	\N	\N	\N	\N
276	\N	\N	\N	\N	\N
277	\N	\N	\N	\N	\N
278	\N	\N	\N	\N	\N
279	\N	\N	\N	\N	\N
280	\N	\N	\N	\N	\N
281	\N	\N	\N	\N	\N
282	\N	\N	\N	\N	\N
283	\N	\N	\N	\N	\N
284	\N	\N	\N	\N	\N
285	\N	\N	\N	\N	\N
286	\N	\N	\N	\N	\N
287	\N	\N	\N	\N	\N
288	\N	\N	\N	\N	\N
289	\N	\N	\N	\N	\N
290	\N	\N	\N	\N	\N
291	\N	\N	\N	\N	\N
292	\N	\N	\N	\N	\N
293	\N	\N	\N	\N	\N
294	\N	\N	\N	\N	\N
295	\N	\N	\N	\N	\N
296	\N	\N	\N	\N	\N
297	\N	\N	\N	\N	\N
298	\N	\N	\N	\N	\N
299	\N	\N	\N	\N	\N
300	\N	\N	\N	\N	\N
301	\N	\N	\N	\N	\N
302	\N	\N	\N	\N	\N
303	\N	\N	\N	\N	\N
304	\N	\N	\N	\N	\N
305	\N	\N	\N	\N	\N
306	\N	\N	\N	\N	\N
307	\N	\N	\N	\N	\N
308	\N	\N	\N	\N	\N
309	\N	\N	\N	\N	\N
310	\N	\N	\N	\N	\N
311	\N	\N	\N	\N	\N
312	\N	\N	\N	\N	\N
313	\N	\N	\N	\N	\N
314	\N	\N	\N	\N	\N
315	\N	\N	\N	\N	\N
316	\N	\N	\N	\N	\N
317	\N	\N	\N	\N	\N
318	\N	\N	\N	\N	\N
319	\N	\N	\N	\N	\N
320	\N	\N	\N	\N	\N
321	\N	\N	\N	\N	\N
322	\N	\N	\N	\N	\N
323	\N	\N	\N	\N	\N
324	\N	\N	\N	\N	\N
325	\N	\N	\N	\N	\N
326	\N	\N	\N	\N	\N
327	\N	\N	\N	\N	\N
328	\N	\N	\N	\N	\N
329	\N	\N	\N	\N	\N
330	\N	\N	\N	\N	\N
331	\N	\N	\N	\N	\N
332	\N	\N	\N	\N	\N
333	\N	\N	\N	\N	\N
334	\N	\N	\N	\N	\N
335	\N	\N	\N	\N	\N
336	\N	\N	\N	\N	\N
337	\N	\N	\N	\N	\N
338	\N	\N	\N	\N	\N
339	\N	\N	\N	\N	\N
340	\N	\N	\N	\N	\N
341	\N	\N	\N	\N	\N
342	\N	\N	\N	\N	\N
343	\N	\N	\N	\N	\N
344	\N	\N	\N	\N	\N
345	\N	\N	\N	\N	\N
346	\N	\N	\N	\N	\N
347	\N	\N	\N	\N	\N
348	\N	\N	\N	\N	\N
349	\N	\N	\N	\N	\N
350	\N	\N	\N	\N	\N
351	\N	\N	\N	\N	\N
352	\N	\N	\N	\N	\N
353	\N	\N	\N	\N	\N
354	\N	\N	\N	\N	\N
355	\N	\N	\N	\N	\N
356	\N	\N	\N	\N	\N
357	\N	\N	\N	\N	\N
358	\N	\N	\N	\N	\N
359	\N	\N	\N	\N	\N
360	\N	\N	\N	\N	\N
361	\N	\N	\N	\N	\N
362	\N	\N	\N	\N	\N
363	\N	\N	\N	\N	\N
364	\N	\N	\N	\N	\N
365	\N	\N	\N	\N	\N
366	\N	\N	\N	\N	\N
367	\N	\N	\N	\N	\N
368	\N	\N	\N	\N	\N
369	\N	\N	\N	\N	\N
370	\N	\N	\N	\N	\N
371	\N	\N	\N	\N	\N
372	\N	\N	\N	\N	\N
373	\N	\N	\N	\N	\N
374	\N	\N	\N	\N	\N
375	\N	\N	\N	\N	\N
376	\N	\N	\N	\N	\N
377	\N	\N	\N	\N	\N
378	\N	\N	\N	\N	\N
379	\N	\N	\N	\N	\N
380	\N	\N	\N	\N	\N
381	\N	\N	\N	\N	\N
382	\N	\N	\N	\N	\N
383	\N	\N	\N	\N	\N
384	\N	\N	\N	\N	\N
385	\N	\N	\N	\N	\N
386	\N	\N	\N	\N	\N
387	\N	\N	\N	\N	\N
388	\N	\N	\N	\N	\N
389	\N	\N	\N	\N	\N
390	\N	\N	\N	\N	\N
391	\N	\N	\N	\N	\N
392	\N	\N	\N	\N	\N
393	\N	\N	\N	\N	\N
394	\N	\N	\N	\N	\N
395	\N	\N	\N	\N	\N
396	\N	\N	\N	\N	\N
397	\N	\N	\N	\N	\N
398	\N	\N	\N	\N	\N
399	\N	\N	\N	\N	\N
400	\N	\N	\N	\N	\N
401	\N	\N	\N	\N	\N
402	\N	\N	\N	\N	\N
403	\N	\N	\N	\N	\N
404	\N	\N	\N	\N	\N
405	\N	\N	\N	\N	\N
406	\N	\N	\N	\N	\N
407	\N	\N	\N	\N	\N
408	\N	\N	\N	\N	\N
409	\N	\N	\N	\N	\N
410	\N	\N	\N	\N	\N
411	\N	\N	\N	\N	\N
412	\N	\N	\N	\N	\N
413	\N	\N	\N	\N	\N
414	\N	\N	\N	\N	\N
415	\N	\N	\N	\N	\N
416	\N	\N	\N	\N	\N
417	\N	\N	\N	\N	\N
418	\N	\N	\N	\N	\N
419	\N	\N	\N	\N	\N
420	\N	\N	\N	\N	\N
421	\N	\N	\N	\N	\N
422	\N	\N	\N	\N	\N
423	\N	\N	\N	\N	\N
424	\N	\N	\N	\N	\N
425	\N	\N	\N	\N	\N
426	\N	\N	\N	\N	\N
427	\N	\N	\N	\N	\N
428	\N	\N	\N	\N	\N
429	\N	\N	\N	\N	\N
430	\N	\N	\N	\N	\N
431	\N	\N	\N	\N	\N
432	\N	\N	\N	\N	\N
433	\N	\N	\N	\N	\N
434	\N	\N	\N	\N	\N
435	\N	\N	\N	\N	\N
436	\N	\N	\N	\N	\N
437	\N	\N	\N	\N	\N
438	\N	\N	\N	\N	\N
439	\N	\N	\N	\N	\N
440	\N	\N	\N	\N	\N
441	\N	\N	\N	\N	\N
442	\N	\N	\N	\N	\N
443	\N	\N	\N	\N	\N
444	\N	\N	\N	\N	\N
445	\N	\N	\N	\N	\N
446	\N	\N	\N	\N	\N
447	\N	\N	\N	\N	\N
448	\N	\N	\N	\N	\N
449	\N	\N	\N	\N	\N
450	\N	\N	\N	\N	\N
451	\N	\N	\N	\N	\N
452	\N	\N	\N	\N	\N
453	\N	\N	\N	\N	\N
454	\N	\N	\N	\N	\N
455	\N	\N	\N	\N	\N
456	\N	\N	\N	\N	\N
457	\N	\N	\N	\N	\N
458	\N	\N	\N	\N	\N
459	\N	\N	\N	\N	\N
460	\N	\N	\N	\N	\N
461	\N	\N	\N	\N	\N
462	\N	\N	\N	\N	\N
463	\N	\N	\N	\N	\N
464	\N	\N	\N	\N	\N
465	\N	\N	\N	\N	\N
466	\N	\N	\N	\N	\N
467	\N	\N	\N	\N	\N
468	\N	\N	\N	\N	\N
469	\N	\N	\N	\N	\N
470	\N	\N	\N	\N	\N
471	\N	\N	\N	\N	\N
472	\N	\N	\N	\N	\N
473	\N	\N	\N	\N	\N
474	\N	\N	\N	\N	\N
475	\N	\N	\N	\N	\N
476	\N	\N	\N	\N	\N
477	\N	\N	\N	\N	\N
478	\N	\N	\N	\N	\N
479	\N	\N	\N	\N	\N
480	\N	\N	\N	\N	\N
481	\N	\N	\N	\N	\N
482	\N	\N	\N	\N	\N
483	\N	\N	\N	\N	\N
484	\N	\N	\N	\N	\N
485	\N	\N	\N	\N	\N
486	\N	\N	\N	\N	\N
487	\N	\N	\N	\N	\N
488	\N	\N	\N	\N	\N
489	\N	\N	\N	\N	\N
490	\N	\N	\N	\N	\N
491	\N	\N	\N	\N	\N
492	\N	\N	\N	\N	\N
493	\N	\N	\N	\N	\N
494	\N	\N	\N	\N	\N
495	\N	\N	\N	\N	\N
496	\N	\N	\N	\N	\N
497	\N	\N	\N	\N	\N
498	\N	\N	\N	\N	\N
499	\N	\N	\N	\N	\N
500	\N	\N	\N	\N	\N
501	\N	\N	\N	\N	\N
502	\N	\N	\N	\N	\N
503	\N	\N	\N	\N	\N
504	\N	\N	\N	\N	\N
505	\N	\N	\N	\N	\N
506	\N	\N	\N	\N	\N
507	\N	\N	\N	\N	\N
508	\N	\N	\N	\N	\N
509	\N	\N	\N	\N	\N
510	\N	\N	\N	\N	\N
511	\N	\N	\N	\N	\N
512	\N	\N	\N	\N	\N
513	\N	\N	\N	\N	\N
514	\N	\N	\N	\N	\N
515	\N	\N	\N	\N	\N
516	\N	\N	\N	\N	\N
517	\N	\N	\N	\N	\N
518	\N	\N	\N	\N	\N
519	\N	\N	\N	\N	\N
520	\N	\N	\N	\N	\N
521	\N	\N	\N	\N	\N
522	\N	\N	\N	\N	\N
523	\N	\N	\N	\N	\N
524	\N	\N	\N	\N	\N
525	\N	\N	\N	\N	\N
526	\N	\N	\N	\N	\N
527	\N	\N	\N	\N	\N
528	\N	\N	\N	\N	\N
529	\N	\N	\N	\N	\N
530	\N	\N	\N	\N	\N
531	\N	\N	\N	\N	\N
532	\N	\N	\N	\N	\N
533	\N	\N	\N	\N	\N
534	\N	\N	\N	\N	\N
535	\N	\N	\N	\N	\N
536	\N	\N	\N	\N	\N
537	\N	\N	\N	\N	\N
538	\N	\N	\N	\N	\N
539	\N	\N	\N	\N	\N
540	\N	\N	\N	\N	\N
541	\N	\N	\N	\N	\N
542	\N	\N	\N	\N	\N
543	\N	\N	\N	\N	\N
544	\N	\N	\N	\N	\N
545	\N	\N	\N	\N	\N
546	\N	\N	\N	\N	\N
547	\N	\N	\N	\N	\N
548	\N	\N	\N	\N	\N
549	\N	\N	\N	\N	\N
550	\N	\N	\N	\N	\N
551	\N	\N	\N	\N	\N
552	\N	\N	\N	\N	\N
553	\N	\N	\N	\N	\N
554	\N	\N	\N	\N	\N
555	\N	\N	\N	\N	\N
556	\N	\N	\N	\N	\N
557	\N	\N	\N	\N	\N
558	\N	\N	\N	\N	\N
559	\N	\N	\N	\N	\N
560	\N	\N	\N	\N	\N
561	\N	\N	\N	\N	\N
562	\N	\N	\N	\N	\N
563	\N	\N	\N	\N	\N
564	\N	\N	\N	\N	\N
565	\N	\N	\N	\N	\N
566	\N	\N	\N	\N	\N
567	\N	\N	\N	\N	\N
568	\N	\N	\N	\N	\N
569	\N	\N	\N	\N	\N
570	\N	\N	\N	\N	\N
571	\N	\N	\N	\N	\N
572	\N	\N	\N	\N	\N
573	\N	\N	\N	\N	\N
574	\N	\N	\N	\N	\N
575	\N	\N	\N	\N	\N
576	\N	\N	\N	\N	\N
577	\N	\N	\N	\N	\N
578	\N	\N	\N	\N	\N
579	\N	\N	\N	\N	\N
580	\N	\N	\N	\N	\N
581	\N	\N	\N	\N	\N
582	\N	\N	\N	\N	\N
583	\N	\N	\N	\N	\N
584	\N	\N	\N	\N	\N
585	\N	\N	\N	\N	\N
586	\N	\N	\N	\N	\N
587	\N	\N	\N	\N	\N
588	\N	\N	\N	\N	\N
589	\N	\N	\N	\N	\N
590	\N	\N	\N	\N	\N
591	\N	\N	\N	\N	\N
592	\N	\N	\N	\N	\N
593	\N	\N	\N	\N	\N
594	\N	\N	\N	\N	\N
595	\N	\N	\N	\N	\N
596	\N	\N	\N	\N	\N
597	\N	\N	\N	\N	\N
598	\N	\N	\N	\N	\N
599	\N	\N	\N	\N	\N
600	\N	\N	\N	\N	\N
601	\N	\N	\N	\N	\N
602	\N	\N	\N	\N	\N
603	\N	\N	\N	\N	\N
604	\N	\N	\N	\N	\N
605	\N	\N	\N	\N	\N
606	\N	\N	\N	\N	\N
607	\N	\N	\N	\N	\N
608	\N	\N	\N	\N	\N
609	\N	\N	\N	\N	\N
610	\N	\N	\N	\N	\N
611	\N	\N	\N	\N	\N
612	\N	\N	\N	\N	\N
613	\N	\N	\N	\N	\N
614	\N	\N	\N	\N	\N
615	\N	\N	\N	\N	\N
616	\N	\N	\N	\N	\N
617	\N	\N	\N	\N	\N
618	\N	\N	\N	\N	\N
619	\N	\N	\N	\N	\N
620	\N	\N	\N	\N	\N
621	\N	\N	\N	\N	\N
622	\N	\N	\N	\N	\N
623	\N	\N	\N	\N	\N
624	\N	\N	\N	\N	\N
625	\N	\N	\N	\N	\N
626	\N	\N	\N	\N	\N
627	\N	\N	\N	\N	\N
628	\N	\N	\N	\N	\N
629	\N	\N	\N	\N	\N
630	\N	\N	\N	\N	\N
631	\N	\N	\N	\N	\N
632	\N	\N	\N	\N	\N
633	\N	\N	\N	\N	\N
634	\N	\N	\N	\N	\N
635	\N	\N	\N	\N	\N
636	\N	\N	\N	\N	\N
637	\N	\N	\N	\N	\N
638	\N	\N	\N	\N	\N
639	\N	\N	\N	\N	\N
640	\N	\N	\N	\N	\N
641	\N	\N	\N	\N	\N
642	\N	\N	\N	\N	\N
643	\N	\N	\N	\N	\N
644	\N	\N	\N	\N	\N
645	\N	\N	\N	\N	\N
646	\N	\N	\N	\N	\N
647	\N	\N	\N	\N	\N
648	\N	\N	\N	\N	\N
649	\N	\N	\N	\N	\N
650	\N	\N	\N	\N	\N
651	\N	\N	\N	\N	\N
652	\N	\N	\N	\N	\N
653	\N	\N	\N	\N	\N
654	\N	\N	\N	\N	\N
655	\N	\N	\N	\N	\N
656	\N	\N	\N	\N	\N
657	\N	\N	\N	\N	\N
658	\N	\N	\N	\N	\N
659	\N	\N	\N	\N	\N
660	\N	\N	\N	\N	\N
661	\N	\N	\N	\N	\N
662	\N	\N	\N	\N	\N
663	\N	\N	\N	\N	\N
664	\N	\N	\N	\N	\N
665	\N	\N	\N	\N	\N
666	\N	\N	\N	\N	\N
667	\N	\N	\N	\N	\N
668	\N	\N	\N	\N	\N
669	\N	\N	\N	\N	\N
670	\N	\N	\N	\N	\N
671	\N	\N	\N	\N	\N
672	\N	\N	\N	\N	\N
673	\N	\N	\N	\N	\N
674	\N	\N	\N	\N	\N
675	\N	\N	\N	\N	\N
676	\N	\N	\N	\N	\N
677	\N	\N	\N	\N	\N
678	\N	\N	\N	\N	\N
679	\N	\N	\N	\N	\N
680	\N	\N	\N	\N	\N
681	\N	\N	\N	\N	\N
682	\N	\N	\N	\N	\N
683	\N	\N	\N	\N	\N
684	\N	\N	\N	\N	\N
685	\N	\N	\N	\N	\N
686	\N	\N	\N	\N	\N
687	\N	\N	\N	\N	\N
688	\N	\N	\N	\N	\N
689	\N	\N	\N	\N	\N
690	\N	\N	\N	\N	\N
691	\N	\N	\N	\N	\N
692	\N	\N	\N	\N	\N
693	\N	\N	\N	\N	\N
694	\N	\N	\N	\N	\N
695	\N	\N	\N	\N	\N
696	\N	\N	\N	\N	\N
697	\N	\N	\N	\N	\N
698	\N	\N	\N	\N	\N
699	\N	\N	\N	\N	\N
700	\N	\N	\N	\N	\N
701	\N	\N	\N	\N	\N
702	\N	\N	\N	\N	\N
703	\N	\N	\N	\N	\N
704	\N	\N	\N	\N	\N
705	\N	\N	\N	\N	\N
706	\N	\N	\N	\N	\N
707	\N	\N	\N	\N	\N
708	\N	\N	\N	\N	\N
709	\N	\N	\N	\N	\N
710	\N	\N	\N	\N	\N
711	\N	\N	\N	\N	\N
712	\N	\N	\N	\N	\N
713	\N	\N	\N	\N	\N
714	\N	\N	\N	\N	\N
715	\N	\N	\N	\N	\N
716	\N	\N	\N	\N	\N
717	\N	\N	\N	\N	\N
718	\N	\N	\N	\N	\N
719	\N	\N	\N	\N	\N
720	\N	\N	\N	\N	\N
721	\N	\N	\N	\N	\N
722	\N	\N	\N	\N	\N
723	\N	\N	\N	\N	\N
724	\N	\N	\N	\N	\N
725	\N	\N	\N	\N	\N
726	\N	\N	\N	\N	\N
727	\N	\N	\N	\N	\N
728	\N	\N	\N	\N	\N
729	\N	\N	\N	\N	\N
730	\N	\N	\N	\N	\N
731	\N	\N	\N	\N	\N
732	\N	\N	\N	\N	\N
733	\N	\N	\N	\N	\N
734	\N	\N	\N	\N	\N
735	\N	\N	\N	\N	\N
736	\N	\N	\N	\N	\N
737	\N	\N	\N	\N	\N
738	\N	\N	\N	\N	\N
739	\N	\N	\N	\N	\N
740	\N	\N	\N	\N	\N
741	\N	\N	\N	\N	\N
742	\N	\N	\N	\N	\N
743	\N	\N	\N	\N	\N
744	\N	\N	\N	\N	\N
745	\N	\N	\N	\N	\N
746	\N	\N	\N	\N	\N
747	\N	\N	\N	\N	\N
748	\N	\N	\N	\N	\N
749	\N	\N	\N	\N	\N
750	\N	\N	\N	\N	\N
751	\N	\N	\N	\N	\N
752	\N	\N	\N	\N	\N
753	\N	\N	\N	\N	\N
754	\N	\N	\N	\N	\N
755	\N	\N	\N	\N	\N
756	\N	\N	\N	\N	\N
757	\N	\N	\N	\N	\N
758	\N	\N	\N	\N	\N
759	\N	\N	\N	\N	\N
760	\N	\N	\N	\N	\N
761	\N	\N	\N	\N	\N
762	\N	\N	\N	\N	\N
763	\N	\N	\N	\N	\N
764	\N	\N	\N	\N	\N
765	\N	\N	\N	\N	\N
766	\N	\N	\N	\N	\N
767	\N	\N	\N	\N	\N
768	\N	\N	\N	\N	\N
769	\N	\N	\N	\N	\N
770	\N	\N	\N	\N	\N
771	\N	\N	\N	\N	\N
772	\N	\N	\N	\N	\N
773	\N	\N	\N	\N	\N
774	\N	\N	\N	\N	\N
775	\N	\N	\N	\N	\N
776	\N	\N	\N	\N	\N
777	\N	\N	\N	\N	\N
778	\N	\N	\N	\N	\N
779	\N	\N	\N	\N	\N
780	\N	\N	\N	\N	\N
781	\N	\N	\N	\N	\N
782	\N	\N	\N	\N	\N
783	\N	\N	\N	\N	\N
784	\N	\N	\N	\N	\N
785	\N	\N	\N	\N	\N
786	\N	\N	\N	\N	\N
787	\N	\N	\N	\N	\N
788	\N	\N	\N	\N	\N
789	\N	\N	\N	\N	\N
790	\N	\N	\N	\N	\N
791	\N	\N	\N	\N	\N
792	\N	\N	\N	\N	\N
793	\N	\N	\N	\N	\N
794	\N	\N	\N	\N	\N
795	\N	\N	\N	\N	\N
796	\N	\N	\N	\N	\N
797	\N	\N	\N	\N	\N
798	\N	\N	\N	\N	\N
799	\N	\N	\N	\N	\N
800	\N	\N	\N	\N	\N
801	\N	\N	\N	\N	\N
802	\N	\N	\N	\N	\N
803	\N	\N	\N	\N	\N
804	\N	\N	\N	\N	\N
805	\N	\N	\N	\N	\N
806	\N	\N	\N	\N	\N
807	\N	\N	\N	\N	\N
808	\N	\N	\N	\N	\N
809	\N	\N	\N	\N	\N
810	\N	\N	\N	\N	\N
811	\N	\N	\N	\N	\N
812	\N	\N	\N	\N	\N
813	\N	\N	\N	\N	\N
814	\N	\N	\N	\N	\N
815	\N	\N	\N	\N	\N
816	\N	\N	\N	\N	\N
817	\N	\N	\N	\N	\N
818	\N	\N	\N	\N	\N
819	\N	\N	\N	\N	\N
820	\N	\N	\N	\N	\N
821	\N	\N	\N	\N	\N
822	\N	\N	\N	\N	\N
823	\N	\N	\N	\N	\N
824	\N	\N	\N	\N	\N
825	\N	\N	\N	\N	\N
826	\N	\N	\N	\N	\N
827	\N	\N	\N	\N	\N
828	\N	\N	\N	\N	\N
829	\N	\N	\N	\N	\N
830	\N	\N	\N	\N	\N
831	\N	\N	\N	\N	\N
832	\N	\N	\N	\N	\N
833	\N	\N	\N	\N	\N
834	\N	\N	\N	\N	\N
835	\N	\N	\N	\N	\N
836	\N	\N	\N	\N	\N
837	\N	\N	\N	\N	\N
838	\N	\N	\N	\N	\N
839	\N	\N	\N	\N	\N
840	\N	\N	\N	\N	\N
841	\N	\N	\N	\N	\N
842	\N	\N	\N	\N	\N
843	\N	\N	\N	\N	\N
844	\N	\N	\N	\N	\N
845	\N	\N	\N	\N	\N
846	\N	\N	\N	\N	\N
847	\N	\N	\N	\N	\N
848	\N	\N	\N	\N	\N
849	\N	\N	\N	\N	\N
850	\N	\N	\N	\N	\N
851	\N	\N	\N	\N	\N
852	\N	\N	\N	\N	\N
853	\N	\N	\N	\N	\N
854	\N	\N	\N	\N	\N
855	\N	\N	\N	\N	\N
856	\N	\N	\N	\N	\N
857	\N	\N	\N	\N	\N
858	\N	\N	\N	\N	\N
859	\N	\N	\N	\N	\N
860	\N	\N	\N	\N	\N
861	\N	\N	\N	\N	\N
862	\N	\N	\N	\N	\N
863	\N	\N	\N	\N	\N
864	\N	\N	\N	\N	\N
865	\N	\N	\N	\N	\N
866	\N	\N	\N	\N	\N
867	\N	\N	\N	\N	\N
868	\N	\N	\N	\N	\N
869	\N	\N	\N	\N	\N
870	\N	\N	\N	\N	\N
871	\N	\N	\N	\N	\N
872	\N	\N	\N	\N	\N
873	\N	\N	\N	\N	\N
874	\N	\N	\N	\N	\N
875	\N	\N	\N	\N	\N
876	\N	\N	\N	\N	\N
877	\N	\N	\N	\N	\N
878	\N	\N	\N	\N	\N
879	\N	\N	\N	\N	\N
880	\N	\N	\N	\N	\N
881	\N	\N	\N	\N	\N
882	\N	\N	\N	\N	\N
883	\N	\N	\N	\N	\N
884	\N	\N	\N	\N	\N
885	\N	\N	\N	\N	\N
886	\N	\N	\N	\N	\N
887	\N	\N	\N	\N	\N
888	\N	\N	\N	\N	\N
889	\N	\N	\N	\N	\N
890	\N	\N	\N	\N	\N
891	\N	\N	\N	\N	\N
892	\N	\N	\N	\N	\N
893	\N	\N	\N	\N	\N
894	\N	\N	\N	\N	\N
895	\N	\N	\N	\N	\N
896	\N	\N	\N	\N	\N
897	\N	\N	\N	\N	\N
898	\N	\N	\N	\N	\N
899	\N	\N	\N	\N	\N
900	\N	\N	\N	\N	\N
901	\N	\N	\N	\N	\N
902	\N	\N	\N	\N	\N
903	\N	\N	\N	\N	\N
904	\N	\N	\N	\N	\N
905	\N	\N	\N	\N	\N
906	\N	\N	\N	\N	\N
907	\N	\N	\N	\N	\N
908	\N	\N	\N	\N	\N
909	\N	\N	\N	\N	\N
910	\N	\N	\N	\N	\N
911	\N	\N	\N	\N	\N
912	\N	\N	\N	\N	\N
913	\N	\N	\N	\N	\N
914	\N	\N	\N	\N	\N
915	\N	\N	\N	\N	\N
916	\N	\N	\N	\N	\N
917	\N	\N	\N	\N	\N
918	\N	\N	\N	\N	\N
919	\N	\N	\N	\N	\N
920	\N	\N	\N	\N	\N
921	\N	\N	\N	\N	\N
922	\N	\N	\N	\N	\N
923	\N	\N	\N	\N	\N
924	\N	\N	\N	\N	\N
925	\N	\N	\N	\N	\N
926	\N	\N	\N	\N	\N
927	\N	\N	\N	\N	\N
928	\N	\N	\N	\N	\N
929	\N	\N	\N	\N	\N
930	\N	\N	\N	\N	\N
931	\N	\N	\N	\N	\N
932	\N	\N	\N	\N	\N
933	\N	\N	\N	\N	\N
934	\N	\N	\N	\N	\N
935	\N	\N	\N	\N	\N
936	\N	\N	\N	\N	\N
937	\N	\N	\N	\N	\N
938	\N	\N	\N	\N	\N
939	\N	\N	\N	\N	\N
940	\N	\N	\N	\N	\N
941	\N	\N	\N	\N	\N
942	\N	\N	\N	\N	\N
943	\N	\N	\N	\N	\N
944	\N	\N	\N	\N	\N
945	\N	\N	\N	\N	\N
946	\N	\N	\N	\N	\N
947	\N	\N	\N	\N	\N
948	\N	\N	\N	\N	\N
949	\N	\N	\N	\N	\N
950	\N	\N	\N	\N	\N
951	\N	\N	\N	\N	\N
952	\N	\N	\N	\N	\N
953	\N	\N	\N	\N	\N
954	\N	\N	\N	\N	\N
955	\N	\N	\N	\N	\N
956	\N	\N	\N	\N	\N
957	\N	\N	\N	\N	\N
958	\N	\N	\N	\N	\N
959	\N	\N	\N	\N	\N
960	\N	\N	\N	\N	\N
961	\N	\N	\N	\N	\N
962	\N	\N	\N	\N	\N
963	\N	\N	\N	\N	\N
964	\N	\N	\N	\N	\N
965	\N	\N	\N	\N	\N
966	\N	\N	\N	\N	\N
967	\N	\N	\N	\N	\N
968	\N	\N	\N	\N	\N
969	\N	\N	\N	\N	\N
970	\N	\N	\N	\N	\N
971	\N	\N	\N	\N	\N
972	\N	\N	\N	\N	\N
973	\N	\N	\N	\N	\N
974	\N	\N	\N	\N	\N
975	\N	\N	\N	\N	\N
976	\N	\N	\N	\N	\N
977	\N	\N	\N	\N	\N
978	\N	\N	\N	\N	\N
979	\N	\N	\N	\N	\N
980	\N	\N	\N	\N	\N
981	\N	\N	\N	\N	\N
982	\N	\N	\N	\N	\N
983	\N	\N	\N	\N	\N
984	\N	\N	\N	\N	\N
985	\N	\N	\N	\N	\N
986	\N	\N	\N	\N	\N
987	\N	\N	\N	\N	\N
988	\N	\N	\N	\N	\N
989	\N	\N	\N	\N	\N
990	\N	\N	\N	\N	\N
991	\N	\N	\N	\N	\N
992	\N	\N	\N	\N	\N
993	\N	\N	\N	\N	\N
994	\N	\N	\N	\N	\N
995	\N	\N	\N	\N	\N
996	\N	\N	\N	\N	\N
997	\N	\N	\N	\N	\N
998	\N	\N	\N	\N	\N
999	\N	\N	\N	\N	\N
1000	\N	\N	\N	\N	\N
1001	\N	\N	\N	\N	\N
1002	\N	\N	\N	\N	\N
1003	\N	\N	\N	\N	\N
1004	\N	\N	\N	\N	\N
1005	\N	\N	\N	\N	\N
1006	\N	\N	\N	\N	\N
1007	\N	\N	\N	\N	\N
1008	\N	\N	\N	\N	\N
1009	\N	\N	\N	\N	\N
1010	\N	\N	\N	\N	\N
1011	\N	\N	\N	\N	\N
1012	\N	\N	\N	\N	\N
1013	\N	\N	\N	\N	\N
1014	\N	\N	\N	\N	\N
1015	\N	\N	\N	\N	\N
1016	\N	\N	\N	\N	\N
1017	\N	\N	\N	\N	\N
1018	\N	\N	\N	\N	\N
1019	\N	\N	\N	\N	\N
1020	\N	\N	\N	\N	\N
1021	\N	\N	\N	\N	\N
1022	\N	\N	\N	\N	\N
1023	\N	\N	\N	\N	\N
1024	\N	\N	\N	\N	\N
1025	\N	\N	\N	\N	\N
1026	\N	\N	\N	\N	\N
1027	\N	\N	\N	\N	\N
1028	\N	\N	\N	\N	\N
1029	\N	\N	\N	\N	\N
1030	\N	\N	\N	\N	\N
1031	\N	\N	\N	\N	\N
1032	\N	\N	\N	\N	\N
1033	\N	\N	\N	\N	\N
1034	\N	\N	\N	\N	\N
1035	\N	\N	\N	\N	\N
1036	\N	\N	\N	\N	\N
1037	\N	\N	\N	\N	\N
1038	\N	\N	\N	\N	\N
1039	\N	\N	\N	\N	\N
1040	\N	\N	\N	\N	\N
1041	\N	\N	\N	\N	\N
1042	\N	\N	\N	\N	\N
1043	\N	\N	\N	\N	\N
1044	\N	\N	\N	\N	\N
1045	\N	\N	\N	\N	\N
1046	\N	\N	\N	\N	\N
1047	\N	\N	\N	\N	\N
1048	\N	\N	\N	\N	\N
1049	\N	\N	\N	\N	\N
1050	\N	\N	\N	\N	\N
1051	\N	\N	\N	\N	\N
1052	\N	\N	\N	\N	\N
1053	\N	\N	\N	\N	\N
1054	\N	\N	\N	\N	\N
1055	\N	\N	\N	\N	\N
1056	\N	\N	\N	\N	\N
1057	\N	\N	\N	\N	\N
1058	\N	\N	\N	\N	\N
1059	\N	\N	\N	\N	\N
1060	\N	\N	\N	\N	\N
1061	\N	\N	\N	\N	\N
1062	\N	\N	\N	\N	\N
1063	\N	\N	\N	\N	\N
1064	\N	\N	\N	\N	\N
1065	\N	\N	\N	\N	\N
1066	\N	\N	\N	\N	\N
1067	\N	\N	\N	\N	\N
1068	\N	\N	\N	\N	\N
1069	\N	\N	\N	\N	\N
1070	\N	\N	\N	\N	\N
1071	\N	\N	\N	\N	\N
1072	\N	\N	\N	\N	\N
1073	\N	\N	\N	\N	\N
1074	\N	\N	\N	\N	\N
1075	\N	\N	\N	\N	\N
1076	\N	\N	\N	\N	\N
1077	\N	\N	\N	\N	\N
1078	\N	\N	\N	\N	\N
1079	\N	\N	\N	\N	\N
1080	\N	\N	\N	\N	\N
1081	\N	\N	\N	\N	\N
1082	\N	\N	\N	\N	\N
1083	\N	\N	\N	\N	\N
1084	\N	\N	\N	\N	\N
1085	\N	\N	\N	\N	\N
1086	\N	\N	\N	\N	\N
1087	\N	\N	\N	\N	\N
1088	\N	\N	\N	\N	\N
1089	\N	\N	\N	\N	\N
1090	\N	\N	\N	\N	\N
1091	\N	\N	\N	\N	\N
1092	\N	\N	\N	\N	\N
1093	\N	\N	\N	\N	\N
1094	\N	\N	\N	\N	\N
1095	\N	\N	\N	\N	\N
1096	\N	\N	\N	\N	\N
1097	\N	\N	\N	\N	\N
1098	\N	\N	\N	\N	\N
1099	\N	\N	\N	\N	\N
1100	\N	\N	\N	\N	\N
1101	\N	\N	\N	\N	\N
1102	\N	\N	\N	\N	\N
1103	\N	\N	\N	\N	\N
1104	\N	\N	\N	\N	\N
1105	\N	\N	\N	\N	\N
1106	\N	\N	\N	\N	\N
1107	\N	\N	\N	\N	\N
1108	\N	\N	\N	\N	\N
1109	\N	\N	\N	\N	\N
1110	\N	\N	\N	\N	\N
1111	\N	\N	\N	\N	\N
1112	\N	\N	\N	\N	\N
1113	\N	\N	\N	\N	\N
1114	\N	\N	\N	\N	\N
1115	\N	\N	\N	\N	\N
1116	\N	\N	\N	\N	\N
1117	\N	\N	\N	\N	\N
1118	\N	\N	\N	\N	\N
1119	\N	\N	\N	\N	\N
1120	\N	\N	\N	\N	\N
1121	\N	\N	\N	\N	\N
1122	\N	\N	\N	\N	\N
1123	\N	\N	\N	\N	\N
1124	\N	\N	\N	\N	\N
1125	\N	\N	\N	\N	\N
1126	\N	\N	\N	\N	\N
1127	\N	\N	\N	\N	\N
1128	\N	\N	\N	\N	\N
1129	\N	\N	\N	\N	\N
1130	\N	\N	\N	\N	\N
1131	\N	\N	\N	\N	\N
1132	\N	\N	\N	\N	\N
1133	\N	\N	\N	\N	\N
1134	\N	\N	\N	\N	\N
1135	\N	\N	\N	\N	\N
1136	\N	\N	\N	\N	\N
1137	\N	\N	\N	\N	\N
1138	\N	\N	\N	\N	\N
1139	\N	\N	\N	\N	\N
1140	\N	\N	\N	\N	\N
1141	\N	\N	\N	\N	\N
1142	\N	\N	\N	\N	\N
1143	\N	\N	\N	\N	\N
1144	\N	\N	\N	\N	\N
1145	\N	\N	\N	\N	\N
1146	\N	\N	\N	\N	\N
1147	\N	\N	\N	\N	\N
1148	\N	\N	\N	\N	\N
1149	\N	\N	\N	\N	\N
1150	\N	\N	\N	\N	\N
1151	\N	\N	\N	\N	\N
1152	\N	\N	\N	\N	\N
1153	\N	\N	\N	\N	\N
1154	\N	\N	\N	\N	\N
1155	\N	\N	\N	\N	\N
1156	\N	\N	\N	\N	\N
1157	\N	\N	\N	\N	\N
1158	\N	\N	\N	\N	\N
1159	\N	\N	\N	\N	\N
1160	\N	\N	\N	\N	\N
1161	\N	\N	\N	\N	\N
1162	\N	\N	\N	\N	\N
1163	\N	\N	\N	\N	\N
1164	\N	\N	\N	\N	\N
1165	\N	\N	\N	\N	\N
1166	\N	\N	\N	\N	\N
1167	\N	\N	\N	\N	\N
1168	\N	\N	\N	\N	\N
1169	\N	\N	\N	\N	\N
1170	\N	\N	\N	\N	\N
1171	\N	\N	\N	\N	\N
1172	\N	\N	\N	\N	\N
1173	\N	\N	\N	\N	\N
1174	\N	\N	\N	\N	\N
1175	\N	\N	\N	\N	\N
1176	\N	\N	\N	\N	\N
1177	\N	\N	\N	\N	\N
1178	\N	\N	\N	\N	\N
1179	\N	\N	\N	\N	\N
1180	\N	\N	\N	\N	\N
1181	\N	\N	\N	\N	\N
1182	\N	\N	\N	\N	\N
1183	\N	\N	\N	\N	\N
1184	\N	\N	\N	\N	\N
1185	\N	\N	\N	\N	\N
1186	\N	\N	\N	\N	\N
1187	\N	\N	\N	\N	\N
1188	\N	\N	\N	\N	\N
1189	\N	\N	\N	\N	\N
1190	\N	\N	\N	\N	\N
1191	\N	\N	\N	\N	\N
1192	\N	\N	\N	\N	\N
1193	\N	\N	\N	\N	\N
1194	\N	\N	\N	\N	\N
1195	\N	\N	\N	\N	\N
1196	\N	\N	\N	\N	\N
1197	\N	\N	\N	\N	\N
1198	\N	\N	\N	\N	\N
1199	\N	\N	\N	\N	\N
1200	\N	\N	\N	\N	\N
1201	\N	\N	\N	\N	\N
1202	\N	\N	\N	\N	\N
1203	\N	\N	\N	\N	\N
1204	\N	\N	\N	\N	\N
1205	\N	\N	\N	\N	\N
1206	\N	\N	\N	\N	\N
1207	\N	\N	\N	\N	\N
1208	\N	\N	\N	\N	\N
1209	\N	\N	\N	\N	\N
1210	\N	\N	\N	\N	\N
1211	\N	\N	\N	\N	\N
1212	\N	\N	\N	\N	\N
1213	\N	\N	\N	\N	\N
1214	\N	\N	\N	\N	\N
1215	\N	\N	\N	\N	\N
1216	\N	\N	\N	\N	\N
1217	\N	\N	\N	\N	\N
1218	\N	\N	\N	\N	\N
1219	\N	\N	\N	\N	\N
1220	\N	\N	\N	\N	\N
1221	\N	\N	\N	\N	\N
1222	\N	\N	\N	\N	\N
1223	\N	\N	\N	\N	\N
1224	\N	\N	\N	\N	\N
1225	\N	\N	\N	\N	\N
1226	\N	\N	\N	\N	\N
1227	\N	\N	\N	\N	\N
1228	\N	\N	\N	\N	\N
1229	\N	\N	\N	\N	\N
1230	\N	\N	\N	\N	\N
1231	\N	\N	\N	\N	\N
1232	\N	\N	\N	\N	\N
1233	\N	\N	\N	\N	\N
1234	\N	\N	\N	\N	\N
1235	\N	\N	\N	\N	\N
1236	\N	\N	\N	\N	\N
1237	\N	\N	\N	\N	\N
1238	\N	\N	\N	\N	\N
1239	\N	\N	\N	\N	\N
1240	\N	\N	\N	\N	\N
1241	\N	\N	\N	\N	\N
1242	\N	\N	\N	\N	\N
1243	\N	\N	\N	\N	\N
1244	\N	\N	\N	\N	\N
1245	\N	\N	\N	\N	\N
1246	\N	\N	\N	\N	\N
1247	\N	\N	\N	\N	\N
1248	\N	\N	\N	\N	\N
1249	\N	\N	\N	\N	\N
1250	\N	\N	\N	\N	\N
1251	\N	\N	\N	\N	\N
1252	\N	\N	\N	\N	\N
1253	\N	\N	\N	\N	\N
1254	\N	\N	\N	\N	\N
1255	\N	\N	\N	\N	\N
1256	\N	\N	\N	\N	\N
1257	\N	\N	\N	\N	\N
1258	\N	\N	\N	\N	\N
1259	\N	\N	\N	\N	\N
1260	\N	\N	\N	\N	\N
1261	\N	\N	\N	\N	\N
1262	\N	\N	\N	\N	\N
1263	\N	\N	\N	\N	\N
1264	\N	\N	\N	\N	\N
1265	\N	\N	\N	\N	\N
1266	\N	\N	\N	\N	\N
1267	\N	\N	\N	\N	\N
1268	\N	\N	\N	\N	\N
1269	\N	\N	\N	\N	\N
1270	\N	\N	\N	\N	\N
1271	\N	\N	\N	\N	\N
1272	\N	\N	\N	\N	\N
1273	\N	\N	\N	\N	\N
1274	\N	\N	\N	\N	\N
1275	\N	\N	\N	\N	\N
1276	\N	\N	\N	\N	\N
1277	\N	\N	\N	\N	\N
1278	\N	\N	\N	\N	\N
1279	\N	\N	\N	\N	\N
1280	\N	\N	\N	\N	\N
1281	\N	\N	\N	\N	\N
1282	\N	\N	\N	\N	\N
1283	\N	\N	\N	\N	\N
1284	\N	\N	\N	\N	\N
1285	\N	\N	\N	\N	\N
1286	\N	\N	\N	\N	\N
1287	\N	\N	\N	\N	\N
1288	\N	\N	\N	\N	\N
1289	\N	\N	\N	\N	\N
1290	\N	\N	\N	\N	\N
1291	\N	\N	\N	\N	\N
1292	\N	\N	\N	\N	\N
1293	\N	\N	\N	\N	\N
1294	\N	\N	\N	\N	\N
1295	\N	\N	\N	\N	\N
1296	\N	\N	\N	\N	\N
1297	\N	\N	\N	\N	\N
1298	\N	\N	\N	\N	\N
1299	\N	\N	\N	\N	\N
1300	\N	\N	\N	\N	\N
1301	\N	\N	\N	\N	\N
1302	\N	\N	\N	\N	\N
1303	\N	\N	\N	\N	\N
1304	\N	\N	\N	\N	\N
1305	\N	\N	\N	\N	\N
1306	\N	\N	\N	\N	\N
1307	\N	\N	\N	\N	\N
1308	\N	\N	\N	\N	\N
1309	\N	\N	\N	\N	\N
1310	\N	\N	\N	\N	\N
1311	\N	\N	\N	\N	\N
1312	\N	\N	\N	\N	\N
1313	\N	\N	\N	\N	\N
1314	\N	\N	\N	\N	\N
1315	\N	\N	\N	\N	\N
1316	\N	\N	\N	\N	\N
1317	\N	\N	\N	\N	\N
1318	\N	\N	\N	\N	\N
1319	\N	\N	\N	\N	\N
1320	\N	\N	\N	\N	\N
1321	\N	\N	\N	\N	\N
1322	\N	\N	\N	\N	\N
1323	\N	\N	\N	\N	\N
1324	\N	\N	\N	\N	\N
1325	\N	\N	\N	\N	\N
1328	\N	\N	\N	\N	\N
1329	\N	\N	\N	\N	\N
1332	\N	\N	\N	\N	\N
1333	\N	\N	\N	\N	\N
1336	\N	\N	\N	\N	\N
1337	\N	\N	\N	\N	\N
1340	\N	\N	\N	\N	\N
1341	\N	\N	\N	\N	\N
1344	\N	\N	\N	\N	\N
1345	\N	\N	\N	\N	\N
1348	\N	\N	\N	\N	\N
1349	\N	\N	\N	\N	\N
1352	\N	\N	\N	\N	\N
1353	\N	\N	\N	\N	\N
1356	\N	\N	\N	\N	\N
1357	\N	\N	\N	\N	\N
1360	\N	\N	\N	\N	\N
1361	\N	\N	\N	\N	\N
1364	\N	\N	\N	\N	\N
1365	\N	\N	\N	\N	\N
1368	\N	\N	\N	\N	\N
1369	\N	\N	\N	\N	\N
1372	\N	\N	\N	\N	\N
1373	\N	\N	\N	\N	\N
1376	\N	\N	\N	\N	\N
1377	\N	\N	\N	\N	\N
1380	\N	\N	\N	\N	\N
1381	\N	\N	\N	\N	\N
1384	\N	\N	\N	\N	\N
1385	\N	\N	\N	\N	\N
1388	\N	\N	\N	\N	\N
1389	\N	\N	\N	\N	\N
1392	\N	\N	\N	\N	\N
1393	\N	\N	\N	\N	\N
1396	\N	\N	\N	\N	\N
1397	\N	\N	\N	\N	\N
1400	\N	\N	\N	\N	\N
1401	\N	\N	\N	\N	\N
1404	\N	\N	\N	\N	\N
1405	\N	\N	\N	\N	\N
1408	\N	\N	\N	\N	\N
1409	\N	\N	\N	\N	\N
1412	\N	\N	\N	\N	\N
1413	\N	\N	\N	\N	\N
1434	821	18	4	7	3
1435	821	19	11	6	1
1452	830	25	4	5	3
1453	830	26	7	7	2
1470	839	30	12	5	4
1471	839	31	1	1	0
1488	848	17	14	9	2
1489	848	20	9	5	4
\.


--
-- TOC entry 3503 (class 0 OID 57849)
-- Dependencies: 241
-- Data for Name: estatisticas_jogador; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.estatisticas_jogador (id, jogo_id, jogador_id, passes, assistencias, remates, minutos_jogados) FROM stdin;
25734	812	162	43	0	4	11
25735	812	163	37	1	1	27
25736	812	164	79	1	8	65
25737	812	165	90	2	17	2
25738	812	166	68	2	4	57
25739	812	167	59	0	17	76
25740	812	168	50	1	10	50
25741	812	169	10	2	17	42
25742	812	170	2	1	14	4
25743	812	171	24	0	18	85
25744	812	172	29	1	8	52
25745	812	173	52	0	0	9
25746	812	174	12	1	7	34
25747	812	175	75	1	2	59
25748	812	176	17	2	7	9
25749	812	177	54	0	0	37
25750	812	178	2	2	9	47
25751	812	179	38	0	7	57
25752	812	180	95	1	10	45
25753	812	181	79	1	4	65
25754	812	182	23	2	18	18
25755	812	183	72	2	13	28
25756	812	184	86	0	11	31
25757	812	1	93	1	6	88
25758	812	2	35	0	13	5
25759	812	3	80	1	0	44
25760	812	4	80	1	2	60
25761	812	5	23	2	19	61
25762	812	6	7	1	3	63
25763	812	7	87	0	7	75
25764	812	8	2	1	6	59
25765	812	9	56	2	1	16
25766	812	10	23	0	7	25
25767	812	11	37	0	5	59
25768	812	185	33	2	19	64
25769	812	186	54	1	4	21
25770	812	187	28	2	15	58
25771	812	188	46	1	0	8
25772	812	189	39	1	2	42
25773	812	190	55	2	1	6
25774	812	191	97	1	13	3
25775	812	192	55	1	10	44
25776	812	193	40	0	10	26
25777	812	194	63	2	2	16
25778	812	195	87	0	10	62
25779	812	196	21	0	10	73
25780	812	197	85	1	3	45
25781	812	198	24	0	14	46
25782	812	199	3	2	9	58
25783	812	200	30	1	14	62
25784	812	201	87	1	13	58
25785	812	202	38	1	13	7
25786	812	203	29	2	2	32
25787	812	204	73	1	10	55
25788	812	205	0	1	0	85
25789	812	206	35	1	6	36
25790	812	207	17	0	11	30
25791	813	162	79	0	1	38
25792	813	163	56	1	12	2
25793	813	164	32	2	10	6
25794	813	165	33	1	18	46
25795	813	166	99	0	13	81
25796	813	167	45	0	10	80
25797	813	168	12	2	2	46
25798	813	169	3	2	0	53
25799	813	170	26	0	0	19
25800	813	171	42	0	3	62
25801	813	172	50	0	4	0
25802	813	173	90	0	3	81
25803	813	174	90	1	5	53
25804	813	175	30	2	16	6
25805	813	176	20	2	19	66
25806	813	177	19	2	16	26
25807	813	178	27	0	10	48
25808	813	179	13	0	18	71
25809	813	180	51	0	10	50
25810	813	181	13	1	0	87
25811	813	182	2	2	17	15
25812	813	183	65	0	2	86
25813	813	184	71	1	2	74
25814	813	1	58	0	10	24
25815	813	2	8	1	8	16
25816	813	3	92	1	8	65
25817	813	4	79	0	11	31
25818	813	5	25	2	12	6
25819	813	6	97	2	6	13
25820	813	7	57	0	4	30
25821	813	8	94	1	19	10
25822	813	9	45	1	1	44
25823	813	10	69	0	1	28
25824	813	11	17	0	2	70
25825	813	208	57	2	6	75
25826	813	209	53	0	15	19
25827	813	210	83	1	8	84
25828	813	211	74	2	3	31
25829	813	212	4	1	15	8
25830	813	213	96	2	12	9
25831	813	214	12	1	10	13
25832	813	215	55	1	3	44
25833	813	216	8	2	10	6
25834	813	217	25	1	8	49
25835	813	218	58	2	4	33
25836	813	219	14	2	15	68
25837	813	220	74	0	4	72
25838	813	221	0	2	8	14
25839	813	222	34	0	13	13
25840	813	223	27	2	6	69
25841	813	224	39	0	18	41
25842	813	225	67	0	6	34
25843	813	226	92	1	15	14
25844	813	227	74	1	8	0
25845	813	228	63	0	13	43
25846	813	229	29	0	2	32
25847	813	230	15	0	14	26
25848	814	162	89	1	5	61
25849	814	163	29	1	7	60
25850	814	164	87	0	10	56
25851	814	165	43	2	17	21
25852	814	166	64	0	12	86
25853	814	167	6	2	5	15
25854	814	168	93	1	5	0
25855	814	169	46	2	12	60
25856	814	170	48	0	16	38
25857	814	171	26	2	16	18
25858	814	172	42	1	15	81
25859	814	173	35	2	10	83
25860	814	174	73	0	7	31
25861	814	175	26	2	1	21
25862	814	176	29	0	14	1
25863	814	177	46	1	16	46
25864	814	178	80	0	9	25
25865	814	179	75	1	4	19
25866	814	180	47	0	3	37
25867	814	181	31	1	14	38
25868	814	182	52	2	15	56
25869	814	183	41	0	4	74
25870	814	184	71	0	11	89
25871	814	1	51	2	0	83
25872	814	2	81	0	19	81
25873	814	3	28	1	10	47
25874	814	4	87	2	9	75
25875	814	5	87	1	6	41
25876	814	6	65	0	10	82
25877	814	7	4	0	5	87
25878	814	8	3	2	7	5
25879	814	9	90	0	10	25
25880	814	10	77	1	2	60
25881	814	11	91	1	3	40
25882	814	231	36	0	2	81
25883	814	232	27	1	3	85
25884	814	233	31	1	1	66
25885	814	234	1	2	13	19
25886	814	235	75	0	13	16
25887	814	236	60	0	13	34
25888	814	237	3	2	2	50
25889	814	238	86	0	17	74
25890	814	239	77	2	2	54
25891	814	240	31	2	9	23
25892	814	241	14	1	19	50
25893	814	242	18	0	0	72
25894	814	243	34	0	11	20
25895	814	244	10	2	18	50
25896	814	245	86	1	15	45
25897	814	246	33	1	4	74
25898	814	247	88	1	8	52
25899	814	248	37	2	6	29
25900	814	249	18	2	18	48
25901	814	250	63	1	4	32
25902	814	251	90	2	10	67
25903	814	252	44	0	4	55
25904	814	253	99	2	9	26
25905	815	185	17	0	6	79
25906	815	186	33	1	17	78
25907	815	187	11	1	2	0
25908	815	188	5	0	14	35
25909	815	189	91	1	1	2
25910	815	190	77	0	0	52
25911	815	191	56	2	11	65
25912	815	192	3	1	10	31
25913	815	193	85	1	2	39
25914	815	194	55	2	0	65
25915	815	195	85	0	8	88
25916	815	196	68	2	1	46
25917	815	197	88	2	0	3
25918	815	198	77	2	11	78
25919	815	199	36	2	3	49
25920	815	200	36	2	0	59
25921	815	201	37	0	5	64
25922	815	202	12	1	17	54
25923	815	203	27	0	0	82
25924	815	204	55	0	12	78
25925	815	205	89	1	4	43
25926	815	206	91	2	3	30
25927	815	207	18	2	0	8
25928	815	208	14	1	7	29
25929	815	209	70	0	12	68
25930	815	210	78	0	17	6
25931	815	211	59	2	13	70
25932	815	212	73	1	8	20
25933	815	213	0	1	4	71
25934	815	214	40	1	1	27
25935	815	215	97	1	11	57
25936	815	216	69	2	8	28
25937	815	217	11	0	9	83
25938	815	218	60	1	19	3
25939	815	219	65	2	5	52
25940	815	220	51	2	18	5
25941	815	221	61	0	17	63
25942	815	222	80	0	5	79
25943	815	223	41	2	15	32
25944	815	224	8	2	7	75
25945	815	225	98	0	7	2
25946	815	226	19	0	2	27
25947	815	227	95	2	1	41
25948	815	228	45	0	17	21
25949	815	229	51	2	17	28
25950	815	230	20	0	16	84
25951	817	162	21	0	11	89
25952	817	163	91	2	12	72
25953	817	164	61	1	8	3
25954	817	165	12	1	8	67
25955	817	166	49	0	5	8
25956	817	167	30	0	15	30
25957	817	168	24	2	10	39
25958	817	169	31	0	16	18
25959	817	170	93	0	9	15
25960	817	171	75	1	14	85
25961	817	172	2	2	14	42
25962	817	173	7	2	19	54
25963	817	174	75	2	9	5
25964	817	175	21	0	16	68
25965	817	176	89	2	19	2
25966	817	177	79	1	0	8
25967	817	178	20	2	0	87
25968	817	179	92	1	8	28
25969	817	180	51	1	4	30
25970	817	181	43	1	10	8
25971	817	182	46	0	17	66
25972	817	183	89	0	0	51
25973	817	184	12	2	3	32
25974	817	1	73	1	4	79
25975	817	2	50	1	4	81
25976	817	3	47	1	16	59
25977	817	4	60	2	6	39
25978	817	5	77	2	6	34
25979	817	6	90	1	6	10
25980	817	7	10	0	12	37
25981	817	8	8	2	18	72
25982	817	9	81	2	0	44
25983	817	10	23	0	10	88
25984	817	11	33	2	2	52
25985	817	185	8	2	15	82
25986	817	186	81	1	4	49
25987	817	187	42	0	11	0
25988	817	188	31	2	19	69
25989	817	189	63	1	1	85
25990	817	190	20	0	8	29
25991	817	191	85	2	3	58
25992	817	192	47	1	1	27
25993	817	193	99	2	2	42
25994	817	194	19	2	11	46
25995	817	195	86	2	3	18
25996	817	196	17	2	17	81
25997	817	197	7	2	15	0
25998	817	198	92	0	9	41
25999	817	199	44	0	1	20
26000	817	200	42	2	2	69
26001	817	201	21	1	11	34
26002	817	202	93	1	10	75
26003	817	203	83	0	0	84
26004	817	204	59	2	5	69
26005	817	205	15	1	4	50
26006	817	206	74	0	10	4
26007	817	207	31	0	12	61
26008	818	162	18	2	4	88
26009	818	163	81	0	6	77
26010	818	164	5	1	9	16
26011	818	165	83	2	15	77
26012	818	166	9	2	17	54
26013	818	167	25	1	0	1
26014	818	168	83	0	3	66
26015	818	169	34	0	18	2
26016	818	170	49	2	13	2
26017	818	171	83	1	16	64
26018	818	172	55	2	3	79
26019	818	173	58	1	6	22
26020	818	174	19	2	14	29
26021	818	175	27	1	17	66
26022	818	176	29	1	4	0
26023	818	177	58	0	5	83
26024	818	178	9	0	9	36
26025	818	179	94	0	18	55
26026	818	180	46	1	1	63
26027	818	181	85	0	6	57
26028	818	182	54	0	15	61
26029	818	183	24	1	0	63
26030	818	184	42	1	2	85
26031	818	1	87	2	12	74
26032	818	2	32	1	1	6
26033	818	3	78	0	16	8
26034	818	4	79	0	4	47
26035	818	5	90	1	15	89
26036	818	6	99	0	0	61
26037	818	7	82	0	4	41
26038	818	8	87	2	5	13
26039	818	9	18	1	3	71
26040	818	10	0	1	1	60
26041	818	11	81	1	6	1
26042	818	185	73	2	17	60
26043	818	186	53	0	11	24
26044	818	187	62	0	19	13
26045	818	188	22	2	10	21
26046	818	189	31	2	0	33
26047	818	190	14	1	13	38
26048	818	191	73	1	6	71
26049	818	192	23	1	5	20
26050	818	193	9	2	17	83
26051	818	194	54	1	5	50
26052	818	195	41	0	19	10
26053	818	196	65	1	4	43
26054	818	197	95	1	4	30
26055	818	198	32	0	17	54
26056	818	199	7	2	8	12
26057	818	200	81	0	1	45
26058	818	201	7	1	1	76
26059	818	202	95	1	14	58
26060	818	203	37	2	7	53
26061	818	204	92	2	6	55
26062	818	205	78	1	11	30
26063	818	206	20	0	6	48
26064	818	207	5	1	18	28
26065	819	162	46	0	17	62
26066	819	163	99	2	18	9
26067	819	164	70	2	1	62
26068	819	165	76	1	11	88
26069	819	166	12	1	4	63
26070	819	167	31	2	13	26
26071	819	168	85	2	9	83
26072	819	169	29	1	17	12
26073	819	170	46	2	8	15
26074	819	171	84	1	19	57
26075	819	172	98	2	15	66
26076	819	173	16	1	1	57
26077	819	174	86	0	13	44
26078	819	175	55	2	4	80
26079	819	176	96	1	14	80
26080	819	177	29	1	10	38
26081	819	178	8	2	10	31
26082	819	179	8	1	5	13
26083	819	180	38	1	15	46
26084	819	181	25	2	2	9
26085	819	182	95	2	19	84
26086	819	183	7	2	4	63
26087	819	184	28	1	1	6
26088	819	1	43	2	15	79
26089	819	2	48	2	5	68
26090	819	3	29	2	2	60
26091	819	4	31	1	14	81
26092	819	5	44	0	0	72
26093	819	6	42	2	10	56
26094	819	7	47	1	19	37
26095	819	8	24	1	9	42
26096	819	9	2	1	15	33
26097	819	10	92	0	8	10
26098	819	11	60	1	3	69
26099	819	208	87	0	3	22
26100	819	209	76	2	12	86
26101	819	210	64	2	16	46
26102	819	211	25	2	3	72
26103	819	212	68	2	4	8
26104	819	213	89	1	10	13
26105	819	214	55	0	15	24
26106	819	215	22	0	11	65
26107	819	216	32	0	14	62
26108	819	217	95	1	16	71
26109	819	218	64	0	0	5
26110	819	219	31	0	8	33
26111	819	220	32	1	1	78
26112	819	221	9	0	19	29
26113	819	222	14	2	2	2
26114	819	223	56	2	16	58
26115	819	224	69	2	12	50
26116	819	225	63	2	4	87
26117	819	226	55	1	15	10
26118	819	227	1	2	15	57
26119	819	228	98	2	6	14
26120	819	229	77	1	6	72
26121	819	230	33	2	12	62
26122	820	162	40	0	0	21
26123	820	163	18	2	9	56
26124	820	164	94	1	4	13
26125	820	165	18	0	13	41
26126	820	166	25	0	15	55
26127	820	167	26	2	17	28
26128	820	168	32	2	14	36
26129	820	169	90	1	15	2
26130	820	170	34	1	18	39
26131	820	171	89	0	6	80
26132	820	172	23	2	4	62
26133	820	173	84	0	17	22
26134	820	174	80	1	5	38
26135	820	175	2	0	13	25
26136	820	176	15	0	16	26
26137	820	177	60	2	19	25
26138	820	178	83	2	10	72
26139	820	179	47	2	6	15
26140	820	180	19	2	0	25
26141	820	181	99	1	0	13
26142	820	182	26	1	17	10
26143	820	183	0	2	8	4
26144	820	184	15	2	5	27
26145	820	1	51	2	0	5
26146	820	2	46	1	4	36
26147	820	3	79	1	3	79
26148	820	4	1	1	17	33
26149	820	5	71	0	6	9
26150	820	6	75	0	14	9
26151	820	7	80	2	15	85
26152	820	8	17	2	11	30
26153	820	9	1	1	8	80
26154	820	10	24	1	10	6
26155	820	11	48	2	19	26
26156	820	231	73	0	7	71
26157	820	232	58	1	18	81
26158	820	233	77	1	16	12
26159	820	234	30	0	10	25
26160	820	235	3	0	10	24
26161	820	236	2	0	4	83
26162	820	237	5	1	16	78
26163	820	238	89	2	7	47
26164	820	239	18	0	3	38
26165	820	240	6	0	7	23
26166	820	241	12	2	0	46
26167	820	242	63	0	12	10
26168	820	243	42	1	8	61
26169	820	244	42	0	8	78
26170	820	245	75	0	7	69
26171	820	246	94	2	15	16
26172	820	247	12	0	10	53
26173	820	248	27	1	9	85
26174	820	249	65	2	4	1
26175	820	250	41	0	2	61
26176	820	251	39	0	0	72
26177	820	252	33	0	2	11
26178	820	253	48	2	12	65
26179	821	185	12	2	13	36
26180	821	186	78	0	13	71
26181	821	187	93	1	13	12
26182	821	188	50	0	12	48
26183	821	189	90	0	5	49
26184	821	190	55	0	9	65
26185	821	191	34	1	7	21
26186	821	192	28	2	14	53
26187	821	193	20	1	2	44
26188	821	194	20	2	3	20
26189	821	195	61	2	3	39
26190	821	196	93	1	3	49
26191	821	197	45	1	15	69
26192	821	198	7	0	6	37
26193	821	199	58	2	5	51
26194	821	200	84	1	15	1
26195	821	201	76	0	10	49
26196	821	202	29	0	16	48
26197	821	203	32	2	5	75
26198	821	204	44	1	13	51
26199	821	205	69	1	13	17
26200	821	206	4	0	14	69
26201	821	207	63	2	0	37
26202	821	208	74	1	13	44
26203	821	209	66	0	10	15
26204	821	210	93	0	9	69
26205	821	211	72	1	9	61
26206	821	212	33	1	14	29
26207	821	213	51	2	8	56
26208	821	214	73	0	7	22
26209	821	215	25	1	17	11
26210	821	216	84	2	4	2
26211	821	217	14	0	12	50
26212	821	218	84	1	8	72
26213	821	219	56	0	15	72
26214	821	220	67	1	18	11
26215	821	221	60	1	10	53
26216	821	222	53	1	16	69
26217	821	223	39	1	18	77
26218	821	224	55	0	8	12
26219	821	225	81	2	14	12
26220	821	226	15	2	14	57
26221	821	227	47	1	12	24
26222	821	228	18	2	9	19
26223	821	229	91	1	15	65
26224	821	230	41	0	7	27
26225	822	185	18	0	14	19
26226	822	186	54	1	8	29
26227	822	187	92	2	2	63
26228	822	188	91	2	4	43
26229	822	189	22	0	6	63
26230	822	190	90	2	13	11
26231	822	191	72	2	16	49
26232	822	192	94	2	6	71
26233	822	193	60	2	12	68
26234	822	194	55	2	3	47
26235	822	195	37	1	11	46
26236	822	196	34	2	18	80
26237	822	197	40	1	12	79
26238	822	198	78	1	12	25
26239	822	199	77	0	0	8
26240	822	200	37	2	16	40
26241	822	201	82	0	7	56
26242	822	202	34	2	17	64
26243	822	203	28	0	10	86
26244	822	204	54	1	2	89
26245	822	205	27	1	10	14
26246	822	206	2	0	18	45
26247	822	207	40	1	19	72
26248	822	231	43	0	19	42
26249	822	232	41	0	10	1
26250	822	233	74	0	16	44
26251	822	234	16	1	5	74
26252	822	235	52	2	2	86
26253	822	236	17	0	15	46
26254	822	237	43	1	5	37
26255	822	238	67	1	2	41
26256	822	239	66	2	17	89
26257	822	240	85	2	1	50
26258	822	241	4	0	2	7
26259	822	242	39	0	9	75
26260	822	243	73	0	12	5
26261	822	244	90	0	0	81
26262	822	245	2	0	7	38
26263	822	246	22	2	9	40
26264	822	247	46	1	7	46
26265	822	248	44	2	15	27
26266	822	249	92	0	17	72
26267	822	250	31	1	16	53
26268	822	251	76	1	4	29
26269	822	252	99	0	15	43
26270	822	253	60	2	19	4
26271	823	208	12	1	19	73
26272	823	209	27	1	10	83
26273	823	210	5	0	2	3
26274	823	211	62	2	1	69
26275	823	212	72	1	18	6
26276	823	213	10	0	14	37
26277	823	214	50	0	6	85
26278	823	215	86	1	13	42
26279	823	216	87	2	4	76
26280	823	217	69	2	8	17
26281	823	218	48	2	17	33
26282	823	219	32	0	14	75
26283	823	220	23	2	1	88
26284	823	221	98	0	4	36
26285	823	222	60	1	5	3
26286	823	223	49	1	15	77
26287	823	224	61	0	10	20
26288	823	225	9	2	1	12
26289	823	226	50	0	14	11
26290	823	227	86	0	1	52
26291	823	228	85	1	17	32
26292	823	229	0	1	3	7
26293	823	230	12	2	4	76
26294	823	231	80	1	5	21
26295	823	232	0	1	17	42
26296	823	233	64	1	6	41
26297	823	234	13	0	13	0
26298	823	235	10	0	11	47
26299	823	236	90	0	11	65
26300	823	237	0	1	19	0
26301	823	238	53	2	4	70
26302	823	239	41	0	5	12
26303	823	240	31	2	1	26
26304	823	241	29	1	12	60
26305	823	242	37	0	2	72
26306	823	243	42	0	7	81
26307	823	244	22	0	10	30
26308	823	245	33	0	5	64
26309	823	246	34	1	19	42
26310	823	247	32	2	16	72
26311	823	248	57	2	16	19
26312	823	249	21	2	14	86
26313	823	250	7	1	5	47
26314	823	251	94	1	13	21
26315	823	252	2	2	17	58
26316	823	253	71	1	4	33
26317	824	254	86	0	3	77
26318	824	255	66	1	6	35
26319	824	256	96	2	4	37
26320	824	257	88	1	12	26
26321	824	258	30	2	13	83
26322	824	259	18	0	19	79
26323	824	260	51	2	4	67
26324	824	261	50	0	11	57
26325	824	262	74	2	11	54
26326	824	263	20	0	13	34
26327	824	264	68	1	1	14
26328	824	265	1	2	4	15
26329	824	266	90	2	19	33
26330	824	267	26	2	15	0
26331	824	268	58	1	18	71
26332	824	269	74	0	16	87
26333	824	270	94	0	6	29
26334	824	271	96	0	12	47
26335	824	272	81	2	14	17
26336	824	273	51	1	0	89
26337	824	274	39	2	2	68
26338	824	275	50	1	15	85
26339	824	276	62	1	15	24
26340	824	277	35	2	11	74
26341	824	278	68	0	13	44
26342	824	279	31	1	5	9
26343	824	280	53	0	18	34
26344	824	281	85	0	0	14
26345	824	282	22	1	1	2
26346	824	283	7	0	9	63
26347	824	284	90	0	1	89
26348	824	285	34	1	18	29
26349	824	286	77	2	18	5
26350	824	287	99	2	19	6
26351	824	288	55	0	13	20
26352	824	289	1	0	6	20
26353	824	290	33	1	14	7
26354	824	291	1	0	9	23
26355	824	292	81	2	14	36
26356	824	293	94	0	14	62
26357	824	294	10	2	7	8
26358	824	295	37	0	11	58
26359	824	296	86	1	19	38
26360	824	297	22	2	1	66
26361	824	298	65	1	11	75
26362	824	299	52	2	4	66
26363	825	254	11	1	16	51
26364	825	255	29	2	6	5
26365	825	256	45	2	2	30
26366	825	257	77	0	15	28
26367	825	258	46	0	9	63
26368	825	259	78	2	15	84
26369	825	260	48	0	17	2
26370	825	261	94	0	4	80
26371	825	262	38	2	14	68
26372	825	263	38	0	12	63
26373	825	264	53	1	2	32
26374	825	265	6	2	7	62
26375	825	266	34	0	16	74
26376	825	267	81	1	6	2
26377	825	268	35	0	12	19
26378	825	269	50	0	4	57
26379	825	270	29	2	4	68
26380	825	271	60	1	6	66
26381	825	272	56	0	18	2
26382	825	273	4	1	14	3
26383	825	274	87	0	2	35
26384	825	275	30	1	16	29
26385	825	276	23	2	1	57
26386	825	300	74	0	14	78
26387	825	301	47	2	15	88
26388	825	302	9	0	7	45
26389	825	303	36	1	13	80
26390	825	304	9	2	4	26
26391	825	305	99	0	13	5
26392	825	306	49	1	4	42
26393	825	307	0	2	2	10
26394	825	308	0	2	15	21
26395	825	309	68	2	13	85
26396	825	310	27	1	2	41
26397	825	311	5	2	18	9
26398	825	312	12	0	17	8
26399	825	313	53	0	5	78
26400	825	314	16	1	9	68
26401	825	315	71	2	18	72
26402	825	316	63	1	9	47
26403	825	317	33	0	7	20
26404	825	318	7	0	14	6
26405	825	319	64	0	12	35
26406	825	320	7	2	19	88
26407	825	321	83	0	11	22
26408	825	322	88	2	16	24
26409	826	254	32	1	14	64
26410	826	255	61	0	10	36
26411	826	256	5	0	11	5
26412	826	257	83	2	18	7
26413	826	258	95	1	14	74
26414	826	259	65	0	16	33
26415	826	260	50	2	6	81
26416	826	261	62	1	18	83
26417	826	262	97	1	6	37
26418	826	263	45	0	17	73
26419	826	264	60	1	4	81
26420	826	265	5	1	16	79
26421	826	266	65	0	0	2
26422	826	267	25	0	12	12
26423	826	268	28	0	12	23
26424	826	269	37	2	3	29
26425	826	270	23	1	7	50
26426	826	271	39	2	19	36
26427	826	272	94	1	11	37
26428	826	273	53	2	19	64
26429	826	274	33	1	2	85
26430	826	275	78	1	3	7
26431	826	276	9	2	17	48
26432	826	323	44	0	15	89
26433	826	324	4	1	12	1
26434	826	325	97	2	17	55
26435	826	326	14	2	19	21
26436	826	327	34	0	15	54
26437	826	328	25	2	17	47
26438	826	329	17	2	1	64
26439	826	330	80	1	18	76
26440	826	331	39	1	19	53
26441	826	332	2	0	17	86
26442	826	333	9	0	14	44
26443	826	334	51	2	11	16
26444	826	335	76	2	18	83
26445	826	336	85	1	0	77
26446	826	337	7	2	5	12
26447	826	338	34	0	12	9
26448	826	339	42	0	17	7
26449	826	340	43	2	6	46
26450	826	341	87	1	18	58
26451	826	342	38	0	18	45
26452	826	343	20	0	2	0
26453	826	344	6	2	6	63
26454	826	345	3	1	5	49
26455	827	277	64	0	13	80
26456	827	278	40	2	8	17
26457	827	279	91	1	16	23
26458	827	280	66	1	18	23
26459	827	281	56	0	13	32
26460	827	282	78	0	1	5
26461	827	283	8	2	4	16
26462	827	284	65	2	11	41
26463	827	285	59	0	12	50
26464	827	286	67	1	3	12
26465	827	287	47	2	11	51
26466	827	288	14	1	3	80
26467	827	289	79	0	6	43
26468	827	290	91	1	7	51
26469	827	291	76	1	4	61
26470	827	292	58	1	1	59
26471	827	293	64	1	17	75
26472	827	294	61	1	14	1
26473	827	295	85	2	17	86
26474	827	296	58	2	13	70
26475	827	297	63	2	12	84
26476	827	298	29	0	3	61
26477	827	299	19	0	6	11
26478	827	300	47	1	17	10
26479	827	301	58	2	19	60
26480	827	302	14	0	19	12
26481	827	303	4	2	19	81
26482	827	304	46	2	9	59
26483	827	305	51	2	3	11
26484	827	306	32	1	17	56
26485	827	307	98	0	14	47
26486	827	308	90	1	2	85
26487	827	309	7	0	0	87
26488	827	310	75	0	13	12
26489	827	311	2	1	19	43
26490	827	312	72	0	9	41
26491	827	313	78	1	19	7
26492	827	314	37	0	4	55
26493	827	315	78	2	16	74
26494	827	316	58	2	11	47
26495	827	317	27	2	3	74
26496	827	318	34	1	19	34
26497	827	319	76	1	8	12
26498	827	320	74	0	12	54
26499	827	321	73	2	5	36
26500	827	322	98	1	3	79
26501	828	277	91	1	18	8
26502	828	278	66	2	19	41
26503	828	279	30	0	19	51
26504	828	280	96	0	7	21
26505	828	281	14	2	14	38
26506	828	282	44	1	5	39
26507	828	283	33	2	0	0
26508	828	284	76	0	7	20
26509	828	285	34	0	10	79
26510	828	286	12	1	2	55
26511	828	287	55	2	11	78
26512	828	288	65	2	19	82
26513	828	289	31	1	13	45
26514	828	290	20	0	17	54
26515	828	291	84	1	11	58
26516	828	292	99	2	3	15
26517	828	293	17	1	2	55
26518	828	294	15	2	12	13
26519	828	295	56	2	19	61
26520	828	296	0	1	3	42
26521	828	297	86	0	0	44
26522	828	298	91	2	12	19
26523	828	299	37	2	0	83
26524	828	323	68	1	6	23
26525	828	324	54	0	14	70
26526	828	325	41	0	3	40
26527	828	326	23	2	10	3
26528	828	327	2	0	16	3
26529	828	328	38	2	7	16
26530	828	329	70	0	11	7
26531	828	330	70	0	6	15
26532	828	331	54	1	16	69
26533	828	332	98	0	6	59
26534	828	333	74	2	12	82
26535	828	334	78	0	7	11
26536	828	335	91	0	1	75
26537	828	336	73	1	9	10
26538	828	337	84	0	6	45
26539	828	338	16	0	11	12
26540	828	339	95	0	2	10
26541	828	340	57	0	8	30
26542	828	341	52	1	18	17
26543	828	342	45	1	14	30
26544	828	343	35	2	16	6
26545	828	344	2	2	7	28
26546	828	345	22	0	5	6
26547	829	300	17	1	14	48
26548	829	301	90	1	12	34
26549	829	302	60	0	18	22
26550	829	303	10	2	6	34
26551	829	304	40	1	15	40
26552	829	305	12	0	4	39
26553	829	306	47	0	5	82
26554	829	307	41	0	15	41
26555	829	308	45	2	16	35
26556	829	309	84	2	18	79
26557	829	310	91	1	12	87
26558	829	311	83	0	5	75
26559	829	312	98	1	13	89
26560	829	313	94	2	14	81
26561	829	314	21	0	6	17
26562	829	315	15	1	15	41
26563	829	316	53	0	19	52
26564	829	317	22	2	9	79
26565	829	318	12	1	0	31
26566	829	319	13	1	19	46
26567	829	320	23	1	18	59
26568	829	321	44	0	19	80
26569	829	322	31	1	5	21
26570	829	323	2	2	11	61
26571	829	324	3	0	14	23
26572	829	325	13	0	11	76
26573	829	326	54	2	9	19
26574	829	327	93	1	14	56
26575	829	328	63	2	3	52
26576	829	329	5	1	5	7
26577	829	330	0	1	5	26
26578	829	331	69	1	13	33
26579	829	332	91	2	7	13
26580	829	333	94	0	14	88
26581	829	334	99	2	5	42
26582	829	335	44	0	8	57
26583	829	336	98	2	15	89
26584	829	337	73	1	4	44
26585	829	338	90	2	16	88
26586	829	339	75	1	12	40
26587	829	340	86	1	10	29
26588	829	341	46	0	5	34
26589	829	342	63	1	16	78
26590	829	343	56	2	10	76
26591	829	344	61	2	3	11
26592	829	345	60	0	3	87
26593	830	346	13	1	4	74
26594	830	347	75	1	15	38
26595	830	348	3	2	12	3
26596	830	349	53	0	9	26
26597	830	350	86	1	4	11
26598	830	351	53	0	4	18
26599	830	352	29	2	4	18
26600	830	353	85	0	19	0
26601	830	354	51	1	8	77
26602	830	355	99	0	4	53
26603	830	356	29	0	18	18
26604	830	357	58	0	15	78
26605	830	358	43	2	7	62
26606	830	359	14	0	19	45
26607	830	360	36	1	17	56
26608	830	361	17	0	14	20
26609	830	362	24	2	4	77
26610	830	363	26	2	11	88
26611	830	364	88	0	7	86
26612	830	365	11	0	8	59
26613	830	366	85	1	9	86
26614	830	367	34	0	9	26
26615	830	368	45	1	14	82
26616	830	369	34	2	11	79
26617	830	370	93	0	3	0
26618	830	371	34	1	0	8
26619	830	372	15	1	6	79
26620	830	373	59	1	11	22
26621	830	374	75	2	8	26
26622	830	375	45	0	2	79
26623	830	376	26	2	13	15
26624	830	377	89	0	5	76
26625	830	378	43	0	6	7
26626	830	379	51	0	14	80
26627	830	380	83	2	14	30
26628	830	381	22	0	3	29
26629	830	382	88	2	3	42
26630	830	383	25	0	18	69
26631	830	384	77	2	0	66
26632	830	385	79	1	12	87
26633	830	386	29	1	14	88
26634	830	387	71	2	3	71
26635	830	388	45	0	2	27
26636	830	389	34	1	6	23
26637	830	390	28	2	12	57
26638	830	391	9	1	9	44
26639	831	346	13	0	19	8
26640	831	347	5	2	12	59
26641	831	348	80	2	4	16
26642	831	349	13	0	18	6
26643	831	350	26	1	6	15
26644	831	351	63	1	6	81
26645	831	352	16	1	14	13
26646	831	353	24	2	6	43
26647	831	354	92	0	11	1
26648	831	355	76	2	6	58
26649	831	356	56	1	14	88
26650	831	357	35	0	6	39
26651	831	358	98	2	15	70
26652	831	359	73	2	8	31
26653	831	360	6	0	11	73
26654	831	361	38	1	4	23
26655	831	362	59	2	11	30
26656	831	363	69	2	2	7
26657	831	364	71	1	13	86
26658	831	365	7	0	15	22
26659	831	366	83	2	17	76
26660	831	367	29	2	1	74
26661	831	368	55	0	16	1
26662	831	392	33	1	2	15
26663	831	393	75	2	11	32
26664	831	394	53	0	7	20
26665	831	395	41	2	11	37
26666	831	396	8	2	8	27
26667	831	397	40	2	14	11
26668	831	398	47	2	8	32
26669	831	399	46	0	8	22
26670	831	400	80	0	9	51
26671	831	401	11	0	17	37
26672	831	402	35	1	15	35
26673	831	403	7	0	18	26
26674	831	404	82	2	7	83
26675	831	405	43	2	13	24
26676	831	406	76	0	18	56
26677	831	407	6	2	13	79
26678	831	408	69	2	7	20
26679	831	409	74	1	8	85
26680	831	410	56	1	14	77
26681	831	411	51	1	2	41
26682	831	412	22	2	5	52
26683	831	413	21	2	9	36
26684	831	414	70	1	14	57
26685	832	346	0	0	1	0
26686	832	347	42	0	4	87
26687	832	348	0	1	0	83
26688	832	349	38	0	12	23
26689	832	350	13	0	4	38
26690	832	351	96	1	14	54
26691	832	352	77	0	2	18
26692	832	353	4	0	12	35
26693	832	354	31	0	19	77
26694	832	355	13	0	0	76
26695	832	356	93	0	6	4
26696	832	357	89	2	16	68
26697	832	358	52	1	2	54
26698	832	359	42	0	5	80
26699	832	360	17	1	4	78
26700	832	361	87	0	2	54
26701	832	362	68	2	18	37
26702	832	363	28	0	8	46
26703	832	364	22	1	0	57
26704	832	365	29	1	3	58
26705	832	366	83	2	16	8
26706	832	367	4	1	7	68
26707	832	368	94	1	2	63
26708	832	415	21	2	17	64
26709	832	416	35	1	8	55
26710	832	417	28	1	18	70
26711	832	418	72	1	8	5
26712	832	419	44	1	3	46
26713	832	420	61	1	6	14
26714	832	421	34	1	3	11
26715	832	422	12	2	14	53
26716	832	423	77	2	15	40
26717	832	424	57	1	18	77
26718	832	425	29	0	4	31
26719	832	426	78	0	5	43
26720	832	427	96	2	7	4
26721	832	428	66	2	9	16
26722	832	429	11	0	5	12
26723	832	430	48	0	12	22
26724	832	431	14	1	9	6
26725	832	432	70	1	3	63
26726	832	433	48	2	17	25
26727	832	434	21	0	12	15
26728	832	435	48	1	16	15
26729	832	436	99	2	6	20
26730	832	437	6	2	6	36
26731	833	369	54	2	15	85
26732	833	370	5	2	13	42
26733	833	371	55	2	3	67
26734	833	372	85	0	9	51
26735	833	373	41	1	13	68
26736	833	374	32	2	15	76
26737	833	375	92	0	7	85
26738	833	376	38	0	4	7
26739	833	377	55	2	13	51
26740	833	378	23	2	14	47
26741	833	379	28	0	10	14
26742	833	380	46	0	17	77
26743	833	381	11	0	19	52
26744	833	382	98	0	0	72
26745	833	383	79	1	14	14
26746	833	384	24	1	5	30
26747	833	385	78	0	18	48
26748	833	386	93	1	6	81
26749	833	387	73	2	10	74
26750	833	388	98	1	5	31
26751	833	389	19	2	4	16
26752	833	390	92	0	5	53
26753	833	391	2	1	12	57
26754	833	392	51	0	19	39
26755	833	393	61	2	2	34
26756	833	394	45	1	18	11
26757	833	395	98	0	12	50
26758	833	396	59	2	2	19
26759	833	397	23	2	6	0
26760	833	398	72	1	12	18
26761	833	399	12	2	15	82
26762	833	400	68	1	18	13
26763	833	401	81	2	0	79
26764	833	402	11	2	2	52
26765	833	403	75	2	18	66
26766	833	404	87	0	14	77
26767	833	405	82	1	11	57
26768	833	406	30	1	4	42
26769	833	407	8	1	2	66
26770	833	408	94	2	14	3
26771	833	409	75	2	7	53
26772	833	410	10	2	2	53
26773	833	411	2	0	0	52
26774	833	412	85	0	9	84
26775	833	413	43	2	7	22
26776	833	414	22	0	0	39
26777	834	369	37	0	2	35
26778	834	370	74	1	3	65
26779	834	371	93	2	11	49
26780	834	372	58	2	18	79
26781	834	373	7	2	18	14
26782	834	374	51	0	2	50
26783	834	375	70	0	5	41
26784	834	376	95	1	8	48
26785	834	377	70	2	15	29
26786	834	378	68	0	16	25
26787	834	379	66	0	8	38
26788	834	380	29	2	3	70
26789	834	381	97	2	17	52
26790	834	382	36	2	15	43
26791	834	383	26	2	6	53
26792	834	384	52	1	9	83
26793	834	385	3	0	6	50
26794	834	386	99	2	13	34
26795	834	387	55	2	10	63
26796	834	388	70	0	16	14
26797	834	389	44	0	9	62
26798	834	390	38	0	2	3
26799	834	391	13	0	13	67
26800	834	415	33	1	19	65
26801	834	416	88	1	7	73
26802	834	417	48	0	0	57
26803	834	418	13	2	12	11
26804	834	419	81	2	16	12
26805	834	420	91	2	8	89
26806	834	421	89	1	0	1
26807	834	422	67	2	5	79
26808	834	423	88	1	2	83
26809	834	424	54	2	15	18
26810	834	425	19	1	12	34
26811	834	426	47	2	5	4
26812	834	427	94	0	1	65
26813	834	428	8	0	14	26
26814	834	429	99	2	7	0
26815	834	430	13	2	15	30
26816	834	431	15	0	8	0
26817	834	432	90	0	0	6
26818	834	433	80	1	14	37
26819	834	434	21	1	18	12
26820	834	435	88	0	10	24
26821	834	436	51	0	12	12
26822	834	437	50	0	8	82
26823	835	392	66	1	11	71
26824	835	393	27	2	4	50
26825	835	394	49	1	16	19
26826	835	395	18	2	3	2
26827	835	396	69	2	13	20
26828	835	397	37	1	1	25
26829	835	398	26	2	9	26
26830	835	399	14	2	11	36
26831	835	400	53	0	0	67
26832	835	401	93	1	18	75
26833	835	402	99	0	7	69
26834	835	403	41	1	8	61
26835	835	404	6	2	17	39
26836	835	405	17	0	13	80
26837	835	406	33	2	6	43
26838	835	407	71	2	0	52
26839	835	408	20	1	8	51
26840	835	409	29	2	2	61
26841	835	410	8	0	17	28
26842	835	411	62	2	14	10
26843	835	412	92	1	9	35
26844	835	413	37	0	10	42
26845	835	414	94	0	2	11
26846	835	415	91	2	14	74
26847	835	416	38	2	15	48
26848	835	417	99	0	14	50
26849	835	418	7	1	0	27
26850	835	419	99	2	9	39
26851	835	420	81	2	10	40
26852	835	421	75	2	14	1
26853	835	422	9	1	16	3
26854	835	423	28	0	9	85
26855	835	424	49	0	17	61
26856	835	425	66	2	17	44
26857	835	426	9	0	11	17
26858	835	427	53	0	6	8
26859	835	428	51	1	17	70
26860	835	429	31	2	10	56
26861	835	430	49	1	12	18
26862	835	431	18	1	12	2
26863	835	432	29	0	11	43
26864	835	433	11	2	0	75
26865	835	434	99	2	19	39
26866	835	435	58	1	18	62
26867	835	436	99	0	3	4
26868	835	437	20	2	1	0
26869	836	438	38	0	10	49
26870	836	439	30	2	0	4
26871	836	440	46	1	3	19
26872	836	441	48	0	13	39
26873	836	442	29	0	11	29
26874	836	443	41	1	16	78
26875	836	444	4	1	16	10
26876	836	445	94	0	9	50
26877	836	446	52	0	12	25
26878	836	447	47	2	11	8
26879	836	448	2	2	6	87
26880	836	449	54	2	4	50
26881	836	450	70	2	18	80
26882	836	451	29	1	17	41
26883	836	452	11	0	11	40
26884	836	453	90	2	8	57
26885	836	454	16	1	8	28
26886	836	455	15	2	0	85
26887	836	456	83	2	2	53
26888	836	457	7	0	3	87
26889	836	458	37	2	16	40
26890	836	459	1	0	8	67
26891	836	460	99	1	1	8
26892	836	461	49	1	5	9
26893	836	462	40	0	13	69
26894	836	463	73	2	18	72
26895	836	464	91	2	13	3
26896	836	465	27	1	13	0
26897	836	466	84	0	6	53
26898	836	467	96	0	11	84
26899	836	468	28	0	6	15
26900	836	469	17	2	5	34
26901	836	470	2	2	3	23
26902	836	471	44	0	1	84
26903	836	472	54	0	3	56
26904	836	473	95	0	5	16
26905	836	474	58	0	3	32
26906	836	475	9	0	4	41
26907	836	476	29	1	4	4
26908	836	477	11	2	6	59
26909	836	478	63	1	7	13
26910	836	479	31	0	1	89
26911	836	480	20	1	8	36
26912	836	481	49	2	2	79
26913	836	482	15	0	12	17
26914	836	483	70	2	11	78
26915	837	438	65	2	11	27
26916	837	439	60	0	12	80
26917	837	440	98	1	17	38
26918	837	441	9	2	8	24
26919	837	442	30	0	1	59
26920	837	443	21	1	5	89
26921	837	444	60	0	3	11
26922	837	445	0	1	15	61
26923	837	446	68	2	13	49
26924	837	447	73	0	4	34
26925	837	448	55	1	7	66
26926	837	449	16	2	18	43
26927	837	450	87	1	11	81
26928	837	451	66	1	17	26
26929	837	452	47	1	8	18
26930	837	453	30	2	18	31
26931	837	454	42	1	5	74
26932	837	455	55	2	1	35
26933	837	456	51	0	17	36
26934	837	457	74	1	9	68
26935	837	458	75	2	12	16
26936	837	459	20	2	4	76
26937	837	460	81	1	10	82
26938	837	484	7	1	9	71
26939	837	485	55	0	6	13
26940	837	486	8	0	8	22
26941	837	487	48	0	17	18
26942	837	488	99	1	5	38
26943	837	489	5	1	16	29
26944	837	490	12	1	9	29
26945	837	491	56	2	2	87
26946	837	492	85	0	7	65
26947	837	493	52	0	15	10
26948	837	494	40	0	0	84
26949	837	495	61	0	14	3
26950	837	496	68	1	0	48
26951	837	497	14	2	11	52
26952	837	498	97	0	13	64
26953	837	499	17	1	4	49
26954	837	500	39	0	14	43
26955	837	501	29	0	5	32
26956	837	502	99	2	3	17
26957	837	503	83	0	4	66
26958	837	504	80	0	8	71
26959	837	505	46	2	3	62
26960	837	506	88	1	9	9
26961	838	438	65	0	11	20
26962	838	439	80	2	7	63
26963	838	440	10	0	3	5
26964	838	441	70	1	13	63
26965	838	442	49	1	17	75
26966	838	443	72	1	9	82
26967	838	444	75	1	9	4
26968	838	445	85	1	5	84
26969	838	446	41	2	13	5
26970	838	447	53	0	18	28
26971	838	448	92	2	18	36
26972	838	449	38	2	0	55
26973	838	450	10	2	8	16
26974	838	451	27	0	18	60
26975	838	452	93	2	4	66
26976	838	453	62	2	15	48
26977	838	454	98	1	5	13
26978	838	455	87	2	5	47
26979	838	456	61	0	0	0
26980	838	457	21	0	8	52
26981	838	458	14	1	6	27
26982	838	459	89	1	8	3
26983	838	460	90	2	18	11
26984	838	507	40	2	19	63
26985	838	508	9	1	18	82
26986	838	509	1	2	13	68
26987	838	510	49	2	18	3
26988	838	511	49	2	18	10
26989	838	512	93	2	12	85
26990	838	513	84	2	11	33
26991	838	514	98	0	13	56
26992	838	515	48	1	16	65
26993	838	516	84	0	19	11
26994	838	517	3	2	13	88
26995	838	518	46	2	7	38
26996	838	519	51	2	9	86
26997	838	520	13	2	9	70
26998	838	521	52	2	7	77
26999	838	522	22	2	4	46
27000	838	523	21	2	1	45
27001	838	524	9	2	10	74
27002	838	525	75	2	11	23
27003	838	526	67	2	5	60
27004	838	527	92	1	1	13
27005	838	528	14	0	5	70
27006	838	529	44	0	17	15
27007	839	461	99	0	12	54
27008	839	462	98	2	9	34
27009	839	463	56	1	12	66
27010	839	464	57	0	9	38
27011	839	465	71	1	4	61
27012	839	466	43	2	5	50
27013	839	467	92	1	0	15
27014	839	468	28	1	2	61
27015	839	469	80	1	3	51
27016	839	470	48	0	17	42
27017	839	471	33	0	16	7
27018	839	472	88	2	18	89
27019	839	473	13	1	13	75
27020	839	474	71	2	3	40
27021	839	475	80	1	7	69
27022	839	476	14	2	3	49
27023	839	477	43	0	3	86
27024	839	478	27	1	2	56
27025	839	479	89	1	10	72
27026	839	480	52	2	0	37
27027	839	481	39	1	19	27
27028	839	482	86	2	2	81
27029	839	483	81	0	2	53
27030	839	484	59	0	10	43
27031	839	485	25	1	8	78
27032	839	486	55	0	4	49
27033	839	487	91	0	19	76
27034	839	488	47	2	12	80
27035	839	489	23	1	9	45
27036	839	490	9	2	1	70
27037	839	491	65	0	14	25
27038	839	492	81	0	11	9
27039	839	493	60	1	4	2
27040	839	494	60	2	16	34
27041	839	495	56	2	0	64
27042	839	496	73	1	18	57
27043	839	497	65	2	18	41
27044	839	498	47	1	6	76
27045	839	499	54	2	2	38
27046	839	500	53	2	5	35
27047	839	501	43	1	0	89
27048	839	502	93	1	3	4
27049	839	503	1	2	12	43
27050	839	504	25	0	16	23
27051	839	505	90	2	13	65
27052	839	506	1	1	12	5
27053	840	461	47	0	14	44
27054	840	462	97	1	14	6
27055	840	463	91	2	5	32
27056	840	464	39	1	1	75
27057	840	465	24	0	17	49
27058	840	466	99	2	18	18
27059	840	467	6	1	16	15
27060	840	468	54	1	1	39
27061	840	469	92	0	6	2
27062	840	470	66	2	16	12
27063	840	471	72	2	12	46
27064	840	472	54	1	14	59
27065	840	473	8	0	6	48
27066	840	474	64	1	1	12
27067	840	475	68	0	9	24
27068	840	476	91	2	3	35
27069	840	477	28	0	19	87
27070	840	478	13	2	6	21
27071	840	479	23	2	14	78
27072	840	480	2	1	3	87
27073	840	481	67	1	15	19
27074	840	482	21	1	18	21
27075	840	483	42	0	4	5
27076	840	507	3	2	9	81
27077	840	508	42	0	19	58
27078	840	509	82	0	17	11
27079	840	510	7	1	8	20
27080	840	511	82	1	16	67
27081	840	512	72	1	3	76
27082	840	513	82	0	13	4
27083	840	514	17	1	1	18
27084	840	515	52	0	11	70
27085	840	516	16	0	13	4
27086	840	517	88	1	5	75
27087	840	518	75	0	3	32
27088	840	519	28	0	9	22
27089	840	520	51	1	13	29
27090	840	521	20	2	14	19
27091	840	522	0	0	9	18
27092	840	523	39	2	13	41
27093	840	524	28	0	1	66
27094	840	525	22	2	12	76
27095	840	526	71	2	9	44
27096	840	527	12	2	13	2
27097	840	528	33	1	11	60
27098	840	529	53	1	12	43
27099	841	484	80	1	17	65
27100	841	485	36	1	18	9
27101	841	486	74	1	0	14
27102	841	487	13	2	6	62
27103	841	488	80	1	17	87
27104	841	489	47	1	7	74
27105	841	490	72	0	10	50
27106	841	491	92	2	12	49
27107	841	492	1	0	0	63
27108	841	493	34	1	6	21
27109	841	494	44	1	0	64
27110	841	495	43	1	15	72
27111	841	496	16	0	8	1
27112	841	497	78	2	4	22
27113	841	498	99	0	17	53
27114	841	499	55	0	0	61
27115	841	500	40	1	5	87
27116	841	501	78	1	16	11
27117	841	502	55	2	6	9
27118	841	503	52	2	13	89
27119	841	504	44	1	11	23
27120	841	505	29	2	18	62
27121	841	506	31	2	18	75
27122	841	507	37	2	4	53
27123	841	508	55	1	11	65
27124	841	509	96	1	8	9
27125	841	510	88	2	12	83
27126	841	511	76	2	13	13
27127	841	512	33	0	11	25
27128	841	513	8	2	17	21
27129	841	514	18	2	11	44
27130	841	515	53	1	7	57
27131	841	516	24	1	17	57
27132	841	517	6	1	6	13
27133	841	518	15	0	19	85
27134	841	519	12	2	2	45
27135	841	520	9	1	17	53
27136	841	521	46	0	2	11
27137	841	522	30	2	2	55
27138	841	523	80	0	17	47
27139	841	524	15	1	3	6
27140	841	525	39	2	13	51
27141	841	526	15	1	3	55
27142	841	527	99	2	18	19
27143	841	528	7	0	19	38
27144	841	529	61	1	19	22
27145	842	208	88	0	18	41
27146	842	209	28	1	16	46
27147	842	210	95	1	16	65
27148	842	211	52	0	6	17
27149	842	212	43	1	0	19
27150	842	213	42	1	18	29
27151	842	214	0	2	2	41
27152	842	215	29	2	5	38
27153	842	216	51	1	0	11
27154	842	217	28	0	13	46
27155	842	218	19	2	7	28
27156	842	219	79	2	3	43
27157	842	220	32	1	7	80
27158	842	221	74	2	4	7
27159	842	222	98	2	8	12
27160	842	223	29	1	0	32
27161	842	224	34	0	2	25
27162	842	225	6	2	5	21
27163	842	226	79	0	4	52
27164	842	227	62	1	8	54
27165	842	228	6	0	6	24
27166	842	229	36	0	5	31
27167	842	230	26	1	15	85
27168	842	231	25	0	17	46
27169	842	232	35	2	14	15
27170	842	233	99	1	15	21
27171	842	234	20	2	9	85
27172	842	235	7	0	15	75
27173	842	236	58	1	1	85
27174	842	237	84	0	19	16
27175	842	238	38	0	16	58
27176	842	239	80	0	1	40
27177	842	240	33	1	5	68
27178	842	241	51	0	10	1
27179	842	242	91	1	6	60
27180	842	243	4	2	12	33
27181	842	244	55	0	12	69
27182	842	245	72	0	15	81
27183	842	246	68	1	3	5
27184	842	247	80	2	16	57
27185	842	248	96	2	10	14
27186	842	249	63	2	14	53
27187	842	250	59	0	3	76
27188	842	251	54	1	1	27
27189	842	252	27	2	1	77
27190	842	253	74	2	0	23
27191	843	277	32	2	2	88
27192	843	278	41	1	0	38
27193	843	279	78	0	9	87
27194	843	280	11	1	11	74
27195	843	281	61	0	17	18
27196	843	282	6	0	4	18
27197	843	283	21	1	0	74
27198	843	284	83	0	8	81
27199	843	285	59	2	16	71
27200	843	286	93	0	12	70
27201	843	287	26	0	1	32
27202	843	288	40	0	17	8
27203	843	289	96	0	15	80
27204	843	290	97	1	5	22
27205	843	291	24	0	15	78
27206	843	292	90	2	12	10
27207	843	293	21	0	15	88
27208	843	294	70	0	19	72
27209	843	295	26	1	19	1
27210	843	296	0	2	9	88
27211	843	297	36	0	17	21
27212	843	298	59	2	10	9
27213	843	299	58	2	3	65
27214	843	300	29	1	19	52
27215	843	301	37	1	9	38
27216	843	302	35	0	10	52
27217	843	303	5	1	5	8
27218	843	304	54	1	10	46
27219	843	305	11	0	9	19
27220	843	306	77	1	5	60
27221	843	307	27	0	15	24
27222	843	308	7	1	13	7
27223	843	309	88	1	4	86
27224	843	310	50	0	10	50
27225	843	311	43	0	6	61
27226	843	312	63	1	14	79
27227	843	313	38	1	0	24
27228	843	314	23	2	5	8
27229	843	315	61	0	15	2
27230	843	316	71	1	19	81
27231	843	317	6	1	6	8
27232	843	318	9	0	3	51
27233	843	319	16	0	2	0
27234	843	320	99	0	0	87
27235	843	321	88	1	13	78
27236	843	322	60	2	5	50
27237	844	415	76	2	2	59
27238	844	416	24	0	7	77
27239	844	417	47	1	13	49
27240	844	418	94	1	2	71
27241	844	419	78	0	5	49
27242	844	420	42	2	10	32
27243	844	421	31	0	14	26
27244	844	422	88	1	13	86
27245	844	423	19	1	3	16
27246	844	424	93	2	7	64
27247	844	425	52	0	5	78
27248	844	426	27	0	4	68
27249	844	427	67	1	4	77
27250	844	428	18	2	17	64
27251	844	429	60	2	3	49
27252	844	430	21	2	3	15
27253	844	431	65	1	8	17
27254	844	432	35	2	6	72
27255	844	433	4	0	4	78
27256	844	434	22	0	5	84
27257	844	435	43	0	18	70
27258	844	436	47	2	2	19
27259	844	437	67	1	0	31
27260	844	369	29	0	1	30
27261	844	370	6	2	11	39
27262	844	371	18	2	18	70
27263	844	372	41	1	9	71
27264	844	373	70	2	7	80
27265	844	374	47	2	14	89
27266	844	375	82	2	1	86
27267	844	376	19	2	19	66
27268	844	377	87	2	10	71
27269	844	378	53	1	4	74
27270	844	379	43	0	18	18
27271	844	380	12	0	12	52
27272	844	381	11	0	8	22
27273	844	382	87	0	9	27
27274	844	383	83	2	4	60
27275	844	384	83	2	3	89
27276	844	385	99	1	5	32
27277	844	386	85	1	7	24
27278	844	387	67	1	12	2
27279	844	388	49	1	6	51
27280	844	389	17	2	6	44
27281	844	390	9	0	17	72
27282	844	391	6	1	16	70
27283	845	507	81	0	11	54
27284	845	508	11	0	11	51
27285	845	509	19	1	17	85
27286	845	510	50	0	1	12
27287	845	511	71	2	4	70
27288	845	512	51	0	7	10
27289	845	513	95	0	18	33
27290	845	514	97	1	0	0
27291	845	515	27	2	10	8
27292	845	516	82	2	7	12
27293	845	517	11	0	9	27
27294	845	518	31	2	12	77
27295	845	519	35	2	12	56
27296	845	520	34	2	13	74
27297	845	521	90	2	4	22
27298	845	522	23	2	11	75
27299	845	523	19	1	10	76
27300	845	524	86	2	6	68
27301	845	525	73	0	8	28
27302	845	526	40	1	14	28
27303	845	527	94	0	3	58
27304	845	528	94	0	9	57
27305	845	529	93	0	16	70
27306	845	438	10	1	16	29
27307	845	439	27	0	15	38
27308	845	440	36	1	10	0
27309	845	441	82	0	2	83
27310	845	442	87	0	14	19
27311	845	443	3	0	16	28
27312	845	444	55	0	10	62
27313	845	445	97	1	3	20
27314	845	446	95	2	17	22
27315	845	447	71	2	6	50
27316	845	448	70	0	19	22
27317	845	449	32	2	0	47
27318	845	450	87	2	1	43
27319	845	451	66	2	17	24
27320	845	452	9	2	6	49
27321	845	453	67	0	0	59
27322	845	454	24	1	0	41
27323	845	455	6	2	1	85
27324	845	456	22	2	8	62
27325	845	457	73	0	4	57
27326	845	458	2	1	0	19
27327	845	459	17	2	17	82
27328	845	460	88	2	11	47
27329	846	162	83	2	11	59
27330	846	163	78	1	5	21
27331	846	164	87	1	19	42
27332	846	165	31	2	11	53
27333	846	166	82	1	15	40
27334	846	167	35	1	7	57
27335	846	168	76	1	13	72
27336	846	169	26	2	1	58
27337	846	170	65	0	4	64
27338	846	171	85	0	3	69
27339	846	172	97	0	15	43
27340	846	173	77	0	8	86
27341	846	174	77	0	19	5
27342	846	175	64	2	18	53
27343	846	176	39	1	4	6
27344	846	177	85	2	2	36
27345	846	178	97	0	17	32
27346	846	179	94	0	2	83
27347	846	180	36	0	15	83
27348	846	181	59	1	7	60
27349	846	182	44	0	17	62
27350	846	183	43	1	19	84
27351	846	184	29	0	2	27
27352	846	1	78	1	14	67
27353	846	2	43	1	19	31
27354	846	3	50	1	3	88
27355	846	4	26	1	13	47
27356	846	5	51	1	2	49
27357	846	6	4	2	15	57
27358	846	7	85	2	4	58
27359	846	8	6	0	1	85
27360	846	9	42	0	12	21
27361	846	10	30	0	9	63
27362	846	11	99	2	14	84
27363	846	185	37	1	9	85
27364	846	186	30	1	10	74
27365	846	187	94	1	14	66
27366	846	188	15	1	4	83
27367	846	189	22	1	10	48
27368	846	190	55	2	5	55
27369	846	191	82	1	3	49
27370	846	192	76	1	2	56
27371	846	193	89	0	18	43
27372	846	194	22	2	13	68
27373	846	195	83	2	1	4
27374	846	196	91	1	6	82
27375	846	197	11	0	10	3
27376	846	198	81	2	6	67
27377	846	199	69	0	16	5
27378	846	200	62	0	8	30
27379	846	201	24	0	9	24
27380	846	202	25	2	4	55
27381	846	203	1	1	5	4
27382	846	204	99	1	12	53
27383	846	205	28	0	11	60
27384	846	206	74	0	11	78
27385	846	207	42	0	7	67
27386	847	162	72	0	2	72
27387	847	163	62	0	18	60
27388	847	164	68	1	5	77
27389	847	165	8	1	2	29
27390	847	166	85	0	7	88
27391	847	167	24	0	12	87
27392	847	168	90	0	1	35
27393	847	169	52	1	4	47
27394	847	170	57	2	1	8
27395	847	171	63	0	3	37
27396	847	172	51	0	19	20
27397	847	173	65	0	8	5
27398	847	174	96	0	14	80
27399	847	175	17	1	10	46
27400	847	176	90	1	12	20
27401	847	177	81	2	4	48
27402	847	178	50	0	7	61
27403	847	179	85	1	15	52
27404	847	180	94	0	14	40
27405	847	181	37	2	10	25
27406	847	182	36	0	13	0
27407	847	183	2	2	7	0
27408	847	184	2	2	17	85
27409	847	1	47	1	13	84
27410	847	2	50	2	3	5
27411	847	3	17	1	1	53
27412	847	4	73	0	0	81
27413	847	5	54	0	1	55
27414	847	6	74	0	7	24
27415	847	7	15	0	15	82
27416	847	8	48	0	2	60
27417	847	9	7	1	15	39
27418	847	10	95	0	4	74
27419	847	11	53	1	10	80
27420	847	208	9	2	2	19
27421	847	209	36	1	7	42
27422	847	210	1	1	16	2
27423	847	211	64	0	6	12
27424	847	212	18	2	0	40
27425	847	213	69	0	4	15
27426	847	214	79	1	10	69
27427	847	215	7	2	15	31
27428	847	216	54	2	14	64
27429	847	217	58	1	19	65
27430	847	218	26	1	2	34
27431	847	219	85	0	1	23
27432	847	220	98	0	14	39
27433	847	221	95	1	8	6
27434	847	222	68	1	18	22
27435	847	223	36	2	3	57
27436	847	224	9	1	19	63
27437	847	225	65	0	12	35
27438	847	226	86	1	16	50
27439	847	227	1	1	8	13
27440	847	228	39	1	16	64
27441	847	229	36	2	13	3
27442	847	230	12	1	5	83
27443	848	162	50	1	17	62
27444	848	163	19	2	1	0
27445	848	164	13	2	9	63
27446	848	165	46	2	7	2
27447	848	166	79	1	1	5
27448	848	167	76	1	6	27
27449	848	168	85	2	0	4
27450	848	169	17	0	4	30
27451	848	170	85	1	7	42
27452	848	171	34	1	0	18
27453	848	172	55	2	2	9
27454	848	173	33	1	18	35
27455	848	174	97	0	6	87
27456	848	175	17	1	4	21
27457	848	176	6	2	12	52
27458	848	177	21	1	7	13
27459	848	178	95	1	0	17
27460	848	179	13	2	12	63
27461	848	180	71	2	13	77
27462	848	181	36	2	11	68
27463	848	182	98	2	1	41
27464	848	183	87	0	7	31
27465	848	184	87	2	6	44
27466	848	1	60	2	0	39
27467	848	2	72	2	3	2
27468	848	3	74	0	12	13
27469	848	4	38	0	13	79
27470	848	5	48	0	9	51
27471	848	6	48	2	4	83
27472	848	7	70	2	10	54
27473	848	8	83	2	8	23
27474	848	9	96	1	17	17
27475	848	10	1	2	11	30
27476	848	11	73	1	12	0
27477	848	231	89	2	15	71
27478	848	232	84	0	17	54
27479	848	233	64	0	1	44
27480	848	234	52	1	11	86
27481	848	235	89	1	19	52
27482	848	236	88	2	10	16
27483	848	237	12	2	11	3
27484	848	238	35	2	17	43
27485	848	239	12	2	18	16
27486	848	240	94	1	12	43
27487	848	241	26	2	10	79
27488	848	242	77	0	5	9
27489	848	243	4	1	10	24
27490	848	244	65	2	3	81
27491	848	245	26	1	16	46
27492	848	246	40	0	2	61
27493	848	247	3	1	8	25
27494	848	248	3	1	16	84
27495	848	249	31	0	7	57
27496	848	250	57	0	1	60
27497	848	251	95	0	15	79
27498	848	252	35	2	2	29
27499	848	253	42	0	19	11
27500	849	185	62	0	18	44
27501	849	186	55	2	10	84
27502	849	187	42	0	18	87
27503	849	188	46	2	15	73
27504	849	189	21	0	6	44
27505	849	190	90	0	18	83
27506	849	191	90	1	19	78
27507	849	192	89	1	0	4
27508	849	193	96	1	3	88
27509	849	194	49	1	10	31
27510	849	195	95	1	10	43
27511	849	196	38	0	0	30
27512	849	197	77	2	3	3
27513	849	198	49	0	5	40
27514	849	199	85	1	2	89
27515	849	200	39	2	1	56
27516	849	201	82	2	18	70
27517	849	202	15	2	3	75
27518	849	203	38	0	9	28
27519	849	204	40	2	6	78
27520	849	205	71	0	8	4
27521	849	206	13	2	7	25
27522	849	207	25	0	15	88
27523	849	208	40	2	0	36
27524	849	209	62	2	14	86
27525	849	210	21	2	12	89
27526	849	211	68	1	1	28
27527	849	212	62	1	0	42
27528	849	213	53	0	17	0
27529	849	214	43	0	11	87
27530	849	215	67	2	13	26
27531	849	216	34	1	14	74
27532	849	217	71	1	15	18
27533	849	218	37	0	9	8
27534	849	219	42	1	13	73
27535	849	220	7	0	5	7
27536	849	221	16	2	6	55
27537	849	222	47	1	19	6
27538	849	223	66	0	8	15
27539	849	224	8	0	0	16
27540	849	225	51	1	8	41
27541	849	226	29	1	1	12
27542	849	227	80	0	16	37
27543	849	228	42	0	15	74
27544	849	229	98	1	10	62
27545	849	230	57	2	9	32
27546	850	185	25	2	5	26
27547	850	186	63	0	7	25
27548	850	187	51	0	9	68
27549	850	188	21	0	4	28
27550	850	189	35	1	18	71
27551	850	190	56	1	9	52
27552	850	191	39	1	10	4
27553	850	192	86	2	19	76
27554	850	193	32	0	12	33
27555	850	194	78	2	10	39
27556	850	195	10	0	7	45
27557	850	196	64	2	5	80
27558	850	197	50	0	12	65
27559	850	198	51	1	0	18
27560	850	199	69	2	1	61
27561	850	200	45	2	10	36
27562	850	201	2	0	1	58
27563	850	202	92	1	15	85
27564	850	203	39	1	12	68
27565	850	204	2	1	6	68
27566	850	205	47	1	16	7
27567	850	206	8	1	2	14
27568	850	207	11	2	4	60
27569	850	231	12	2	2	70
27570	850	232	89	0	11	71
27571	850	233	59	1	7	80
27572	850	234	33	0	2	81
27573	850	235	40	1	10	35
27574	850	236	67	0	19	85
27575	850	237	47	0	6	11
27576	850	238	5	1	3	81
27577	850	239	75	1	3	34
27578	850	240	13	0	2	36
27579	850	241	69	0	10	3
27580	850	242	86	0	15	65
27581	850	243	91	2	16	13
27582	850	244	32	1	4	49
27583	850	245	52	0	0	1
27584	850	246	97	1	7	44
27585	850	247	66	2	18	69
27586	850	248	23	2	12	85
27587	850	249	62	1	12	46
27588	850	250	57	0	8	87
27589	850	251	99	2	14	56
27590	850	252	69	2	2	85
27591	850	253	18	2	4	71
27592	851	208	17	0	3	15
27593	851	209	67	1	10	69
27594	851	210	10	2	13	72
27595	851	211	17	2	11	71
27596	851	212	96	0	8	44
27597	851	213	96	2	1	12
27598	851	214	93	2	18	61
27599	851	215	0	1	14	70
27600	851	216	38	1	18	41
27601	851	217	23	1	14	23
27602	851	218	90	1	2	7
27603	851	219	79	2	14	52
27604	851	220	13	2	16	64
27605	851	221	82	2	15	80
27606	851	222	78	2	2	57
27607	851	223	50	0	3	30
27608	851	224	43	2	11	75
27609	851	225	79	2	12	37
27610	851	226	80	2	6	37
27611	851	227	72	2	7	66
27612	851	228	6	0	15	32
27613	851	229	85	2	10	81
27614	851	230	67	1	13	44
27615	851	231	27	2	5	17
27616	851	232	60	1	18	76
27617	851	233	11	1	12	23
27618	851	234	94	0	7	57
27619	851	235	32	0	10	0
27620	851	236	76	0	19	16
27621	851	237	30	0	11	25
27622	851	238	36	1	11	16
27623	851	239	95	1	4	37
27624	851	240	0	0	10	46
27625	851	241	18	2	16	75
27626	851	242	22	2	12	63
27627	851	243	90	2	9	16
27628	851	244	7	2	13	26
27629	851	245	63	2	16	71
27630	851	246	83	1	17	19
27631	851	247	94	1	14	26
27632	851	248	79	0	1	25
27633	851	249	61	0	8	12
27634	851	250	31	2	3	68
27635	851	251	6	2	18	64
27636	851	252	34	2	5	27
27637	851	253	86	1	2	60
27638	852	254	8	1	8	25
27639	852	255	4	0	0	11
27640	852	256	51	2	3	74
27641	852	257	9	2	17	87
27642	852	258	39	0	2	70
27643	852	259	67	2	5	71
27644	852	260	44	2	7	36
27645	852	261	70	0	10	23
27646	852	262	12	2	2	76
27647	852	263	40	2	5	64
27648	852	264	47	0	3	78
27649	852	265	31	1	16	73
27650	852	266	85	1	10	8
27651	852	267	54	2	8	87
27652	852	268	84	2	1	39
27653	852	269	86	1	0	15
27654	852	270	88	2	12	59
27655	852	271	73	1	18	9
27656	852	272	67	2	3	57
27657	852	273	57	1	12	3
27658	852	274	90	0	4	24
27659	852	275	80	0	19	74
27660	852	276	52	2	12	85
27661	852	277	18	0	16	28
27662	852	278	81	0	2	35
27663	852	279	52	0	12	20
27664	852	280	57	2	5	10
27665	852	281	36	1	3	71
27666	852	282	29	2	0	55
27667	852	283	37	2	3	7
27668	852	284	59	1	16	41
27669	852	285	19	1	7	36
27670	852	286	21	2	4	53
27671	852	287	25	2	13	23
27672	852	288	93	0	12	29
27673	852	289	91	1	10	73
27674	852	290	66	1	18	52
27675	852	291	76	1	12	21
27676	852	292	63	0	7	22
27677	852	293	35	1	3	20
27678	852	294	0	0	8	7
27679	852	295	91	0	7	85
27680	852	296	39	0	9	2
27681	852	297	22	0	14	32
27682	852	298	7	1	8	59
27683	852	299	64	0	16	44
27684	853	254	90	2	16	68
27685	853	255	69	0	8	42
27686	853	256	4	1	3	3
27687	853	257	49	1	1	37
27688	853	258	75	2	11	62
27689	853	259	39	1	14	24
27690	853	260	56	2	7	74
27691	853	261	96	0	3	89
27692	853	262	71	1	8	30
27693	853	263	34	2	16	38
27694	853	264	70	0	2	28
27695	853	265	20	0	7	56
27696	853	266	30	2	4	38
27697	853	267	32	2	17	8
27698	853	268	70	0	4	9
27699	853	269	68	0	4	77
27700	853	270	74	2	9	41
27701	853	271	33	1	0	37
27702	853	272	80	0	12	56
27703	853	273	46	1	0	55
27704	853	274	17	0	16	15
27705	853	275	67	1	17	3
27706	853	276	82	2	14	49
27707	853	300	33	2	6	26
27708	853	301	61	0	14	80
27709	853	302	63	0	11	51
27710	853	303	53	1	0	61
27711	853	304	82	1	11	54
27712	853	305	61	1	6	76
27713	853	306	60	2	6	89
27714	853	307	37	1	9	40
27715	853	308	50	0	13	51
27716	853	309	30	0	11	16
27717	853	310	13	1	5	50
27718	853	311	47	1	0	8
27719	853	312	71	2	4	34
27720	853	313	84	2	10	46
27721	853	314	81	2	7	83
27722	853	315	4	2	1	82
27723	853	316	79	2	1	48
27724	853	317	55	0	5	56
27725	853	318	63	2	10	17
27726	853	319	75	2	17	11
27727	853	320	80	2	19	56
27728	853	321	46	1	15	1
27729	853	322	26	2	13	41
27730	854	254	25	2	10	8
27731	854	255	9	2	2	84
27732	854	256	87	0	15	82
27733	854	257	71	1	6	83
27734	854	258	81	2	11	81
27735	854	259	85	2	2	50
27736	854	260	89	1	18	35
27737	854	261	7	1	1	64
27738	854	262	81	1	0	15
27739	854	263	63	0	5	6
27740	854	264	78	2	16	40
27741	854	265	8	0	18	61
27742	854	266	49	0	4	48
27743	854	267	98	0	8	1
27744	854	268	38	1	12	41
27745	854	269	39	1	8	65
27746	854	270	49	0	19	32
27747	854	271	5	0	13	39
27748	854	272	75	1	16	50
27749	854	273	67	0	8	66
27750	854	274	12	2	16	54
27751	854	275	21	2	1	4
27752	854	276	19	1	6	65
27753	854	323	72	0	5	76
27754	854	324	77	0	7	58
27755	854	325	71	1	2	84
27756	854	326	46	0	18	51
27757	854	327	43	1	3	83
27758	854	328	63	0	4	24
27759	854	329	84	2	0	80
27760	854	330	34	0	9	81
27761	854	331	86	1	4	13
27762	854	332	51	2	12	34
27763	854	333	34	0	3	72
27764	854	334	14	0	11	10
27765	854	335	23	1	14	58
27766	854	336	60	1	6	5
27767	854	337	74	2	12	88
27768	854	338	94	1	19	29
27769	854	339	22	0	17	45
27770	854	340	18	2	8	26
27771	854	341	62	2	14	79
27772	854	342	46	1	0	72
27773	854	343	53	2	3	59
27774	854	344	83	0	18	59
27775	854	345	40	1	4	23
1467	\N	\N	\N	\N	\N	\N
1468	\N	\N	\N	\N	\N	\N
1469	\N	\N	\N	\N	\N	\N
1470	\N	\N	\N	\N	\N	\N
1471	\N	\N	\N	\N	\N	\N
1472	\N	\N	\N	\N	\N	\N
1473	\N	\N	\N	\N	\N	\N
1474	\N	\N	\N	\N	\N	\N
1475	\N	\N	\N	\N	\N	\N
1476	\N	\N	\N	\N	\N	\N
1477	\N	\N	\N	\N	\N	\N
1478	\N	\N	\N	\N	\N	\N
1479	\N	\N	\N	\N	\N	\N
1480	\N	\N	\N	\N	\N	\N
1481	\N	\N	\N	\N	\N	\N
1482	\N	\N	\N	\N	\N	\N
1483	\N	\N	\N	\N	\N	\N
1484	\N	\N	\N	\N	\N	\N
251	\N	\N	\N	\N	\N	\N
252	\N	\N	\N	\N	\N	\N
253	\N	\N	\N	\N	\N	\N
254	\N	\N	\N	\N	\N	\N
255	\N	\N	\N	\N	\N	\N
256	\N	\N	\N	\N	\N	\N
257	\N	\N	\N	\N	\N	\N
258	\N	\N	\N	\N	\N	\N
259	\N	\N	\N	\N	\N	\N
260	\N	\N	\N	\N	\N	\N
261	\N	\N	\N	\N	\N	\N
262	\N	\N	\N	\N	\N	\N
263	\N	\N	\N	\N	\N	\N
264	\N	\N	\N	\N	\N	\N
265	\N	\N	\N	\N	\N	\N
266	\N	\N	\N	\N	\N	\N
267	\N	\N	\N	\N	\N	\N
268	\N	\N	\N	\N	\N	\N
269	\N	\N	\N	\N	\N	\N
270	\N	\N	\N	\N	\N	\N
271	\N	\N	\N	\N	\N	\N
272	\N	\N	\N	\N	\N	\N
273	\N	\N	\N	\N	\N	\N
274	\N	\N	\N	\N	\N	\N
275	\N	\N	\N	\N	\N	\N
276	\N	\N	\N	\N	\N	\N
277	\N	\N	\N	\N	\N	\N
278	\N	\N	\N	\N	\N	\N
279	\N	\N	\N	\N	\N	\N
280	\N	\N	\N	\N	\N	\N
281	\N	\N	\N	\N	\N	\N
282	\N	\N	\N	\N	\N	\N
283	\N	\N	\N	\N	\N	\N
284	\N	\N	\N	\N	\N	\N
285	\N	\N	\N	\N	\N	\N
286	\N	\N	\N	\N	\N	\N
287	\N	\N	\N	\N	\N	\N
288	\N	\N	\N	\N	\N	\N
289	\N	\N	\N	\N	\N	\N
290	\N	\N	\N	\N	\N	\N
291	\N	\N	\N	\N	\N	\N
292	\N	\N	\N	\N	\N	\N
293	\N	\N	\N	\N	\N	\N
294	\N	\N	\N	\N	\N	\N
295	\N	\N	\N	\N	\N	\N
296	\N	\N	\N	\N	\N	\N
297	\N	\N	\N	\N	\N	\N
298	\N	\N	\N	\N	\N	\N
299	\N	\N	\N	\N	\N	\N
300	\N	\N	\N	\N	\N	\N
301	\N	\N	\N	\N	\N	\N
302	\N	\N	\N	\N	\N	\N
303	\N	\N	\N	\N	\N	\N
304	\N	\N	\N	\N	\N	\N
305	\N	\N	\N	\N	\N	\N
306	\N	\N	\N	\N	\N	\N
307	\N	\N	\N	\N	\N	\N
308	\N	\N	\N	\N	\N	\N
309	\N	\N	\N	\N	\N	\N
310	\N	\N	\N	\N	\N	\N
311	\N	\N	\N	\N	\N	\N
312	\N	\N	\N	\N	\N	\N
313	\N	\N	\N	\N	\N	\N
314	\N	\N	\N	\N	\N	\N
315	\N	\N	\N	\N	\N	\N
316	\N	\N	\N	\N	\N	\N
317	\N	\N	\N	\N	\N	\N
318	\N	\N	\N	\N	\N	\N
319	\N	\N	\N	\N	\N	\N
320	\N	\N	\N	\N	\N	\N
321	\N	\N	\N	\N	\N	\N
322	\N	\N	\N	\N	\N	\N
323	\N	\N	\N	\N	\N	\N
324	\N	\N	\N	\N	\N	\N
325	\N	\N	\N	\N	\N	\N
326	\N	\N	\N	\N	\N	\N
327	\N	\N	\N	\N	\N	\N
328	\N	\N	\N	\N	\N	\N
329	\N	\N	\N	\N	\N	\N
330	\N	\N	\N	\N	\N	\N
331	\N	\N	\N	\N	\N	\N
332	\N	\N	\N	\N	\N	\N
333	\N	\N	\N	\N	\N	\N
334	\N	\N	\N	\N	\N	\N
335	\N	\N	\N	\N	\N	\N
336	\N	\N	\N	\N	\N	\N
337	\N	\N	\N	\N	\N	\N
338	\N	\N	\N	\N	\N	\N
339	\N	\N	\N	\N	\N	\N
340	\N	\N	\N	\N	\N	\N
341	\N	\N	\N	\N	\N	\N
342	\N	\N	\N	\N	\N	\N
343	\N	\N	\N	\N	\N	\N
344	\N	\N	\N	\N	\N	\N
345	\N	\N	\N	\N	\N	\N
346	\N	\N	\N	\N	\N	\N
347	\N	\N	\N	\N	\N	\N
348	\N	\N	\N	\N	\N	\N
349	\N	\N	\N	\N	\N	\N
350	\N	\N	\N	\N	\N	\N
351	\N	\N	\N	\N	\N	\N
352	\N	\N	\N	\N	\N	\N
353	\N	\N	\N	\N	\N	\N
354	\N	\N	\N	\N	\N	\N
355	\N	\N	\N	\N	\N	\N
356	\N	\N	\N	\N	\N	\N
357	\N	\N	\N	\N	\N	\N
358	\N	\N	\N	\N	\N	\N
359	\N	\N	\N	\N	\N	\N
360	\N	\N	\N	\N	\N	\N
361	\N	\N	\N	\N	\N	\N
362	\N	\N	\N	\N	\N	\N
363	\N	\N	\N	\N	\N	\N
364	\N	\N	\N	\N	\N	\N
365	\N	\N	\N	\N	\N	\N
366	\N	\N	\N	\N	\N	\N
367	\N	\N	\N	\N	\N	\N
368	\N	\N	\N	\N	\N	\N
369	\N	\N	\N	\N	\N	\N
370	\N	\N	\N	\N	\N	\N
371	\N	\N	\N	\N	\N	\N
372	\N	\N	\N	\N	\N	\N
373	\N	\N	\N	\N	\N	\N
374	\N	\N	\N	\N	\N	\N
375	\N	\N	\N	\N	\N	\N
376	\N	\N	\N	\N	\N	\N
377	\N	\N	\N	\N	\N	\N
378	\N	\N	\N	\N	\N	\N
379	\N	\N	\N	\N	\N	\N
380	\N	\N	\N	\N	\N	\N
381	\N	\N	\N	\N	\N	\N
382	\N	\N	\N	\N	\N	\N
383	\N	\N	\N	\N	\N	\N
384	\N	\N	\N	\N	\N	\N
385	\N	\N	\N	\N	\N	\N
386	\N	\N	\N	\N	\N	\N
387	\N	\N	\N	\N	\N	\N
388	\N	\N	\N	\N	\N	\N
389	\N	\N	\N	\N	\N	\N
390	\N	\N	\N	\N	\N	\N
391	\N	\N	\N	\N	\N	\N
392	\N	\N	\N	\N	\N	\N
393	\N	\N	\N	\N	\N	\N
394	\N	\N	\N	\N	\N	\N
395	\N	\N	\N	\N	\N	\N
396	\N	\N	\N	\N	\N	\N
397	\N	\N	\N	\N	\N	\N
398	\N	\N	\N	\N	\N	\N
399	\N	\N	\N	\N	\N	\N
400	\N	\N	\N	\N	\N	\N
401	\N	\N	\N	\N	\N	\N
402	\N	\N	\N	\N	\N	\N
403	\N	\N	\N	\N	\N	\N
404	\N	\N	\N	\N	\N	\N
405	\N	\N	\N	\N	\N	\N
406	\N	\N	\N	\N	\N	\N
407	\N	\N	\N	\N	\N	\N
408	\N	\N	\N	\N	\N	\N
409	\N	\N	\N	\N	\N	\N
410	\N	\N	\N	\N	\N	\N
411	\N	\N	\N	\N	\N	\N
412	\N	\N	\N	\N	\N	\N
413	\N	\N	\N	\N	\N	\N
414	\N	\N	\N	\N	\N	\N
415	\N	\N	\N	\N	\N	\N
416	\N	\N	\N	\N	\N	\N
417	\N	\N	\N	\N	\N	\N
418	\N	\N	\N	\N	\N	\N
419	\N	\N	\N	\N	\N	\N
420	\N	\N	\N	\N	\N	\N
421	\N	\N	\N	\N	\N	\N
422	\N	\N	\N	\N	\N	\N
423	\N	\N	\N	\N	\N	\N
424	\N	\N	\N	\N	\N	\N
425	\N	\N	\N	\N	\N	\N
426	\N	\N	\N	\N	\N	\N
427	\N	\N	\N	\N	\N	\N
428	\N	\N	\N	\N	\N	\N
429	\N	\N	\N	\N	\N	\N
430	\N	\N	\N	\N	\N	\N
431	\N	\N	\N	\N	\N	\N
432	\N	\N	\N	\N	\N	\N
433	\N	\N	\N	\N	\N	\N
434	\N	\N	\N	\N	\N	\N
435	\N	\N	\N	\N	\N	\N
436	\N	\N	\N	\N	\N	\N
437	\N	\N	\N	\N	\N	\N
438	\N	\N	\N	\N	\N	\N
439	\N	\N	\N	\N	\N	\N
440	\N	\N	\N	\N	\N	\N
441	\N	\N	\N	\N	\N	\N
442	\N	\N	\N	\N	\N	\N
443	\N	\N	\N	\N	\N	\N
444	\N	\N	\N	\N	\N	\N
445	\N	\N	\N	\N	\N	\N
446	\N	\N	\N	\N	\N	\N
447	\N	\N	\N	\N	\N	\N
448	\N	\N	\N	\N	\N	\N
449	\N	\N	\N	\N	\N	\N
450	\N	\N	\N	\N	\N	\N
451	\N	\N	\N	\N	\N	\N
452	\N	\N	\N	\N	\N	\N
453	\N	\N	\N	\N	\N	\N
454	\N	\N	\N	\N	\N	\N
455	\N	\N	\N	\N	\N	\N
456	\N	\N	\N	\N	\N	\N
457	\N	\N	\N	\N	\N	\N
458	\N	\N	\N	\N	\N	\N
459	\N	\N	\N	\N	\N	\N
460	\N	\N	\N	\N	\N	\N
461	\N	\N	\N	\N	\N	\N
462	\N	\N	\N	\N	\N	\N
463	\N	\N	\N	\N	\N	\N
464	\N	\N	\N	\N	\N	\N
465	\N	\N	\N	\N	\N	\N
466	\N	\N	\N	\N	\N	\N
467	\N	\N	\N	\N	\N	\N
468	\N	\N	\N	\N	\N	\N
469	\N	\N	\N	\N	\N	\N
470	\N	\N	\N	\N	\N	\N
471	\N	\N	\N	\N	\N	\N
472	\N	\N	\N	\N	\N	\N
473	\N	\N	\N	\N	\N	\N
474	\N	\N	\N	\N	\N	\N
475	\N	\N	\N	\N	\N	\N
476	\N	\N	\N	\N	\N	\N
477	\N	\N	\N	\N	\N	\N
478	\N	\N	\N	\N	\N	\N
479	\N	\N	\N	\N	\N	\N
480	\N	\N	\N	\N	\N	\N
481	\N	\N	\N	\N	\N	\N
482	\N	\N	\N	\N	\N	\N
483	\N	\N	\N	\N	\N	\N
484	\N	\N	\N	\N	\N	\N
485	\N	\N	\N	\N	\N	\N
486	\N	\N	\N	\N	\N	\N
487	\N	\N	\N	\N	\N	\N
488	\N	\N	\N	\N	\N	\N
489	\N	\N	\N	\N	\N	\N
490	\N	\N	\N	\N	\N	\N
491	\N	\N	\N	\N	\N	\N
492	\N	\N	\N	\N	\N	\N
493	\N	\N	\N	\N	\N	\N
494	\N	\N	\N	\N	\N	\N
495	\N	\N	\N	\N	\N	\N
496	\N	\N	\N	\N	\N	\N
497	\N	\N	\N	\N	\N	\N
498	\N	\N	\N	\N	\N	\N
499	\N	\N	\N	\N	\N	\N
500	\N	\N	\N	\N	\N	\N
501	\N	\N	\N	\N	\N	\N
502	\N	\N	\N	\N	\N	\N
503	\N	\N	\N	\N	\N	\N
504	\N	\N	\N	\N	\N	\N
505	\N	\N	\N	\N	\N	\N
506	\N	\N	\N	\N	\N	\N
507	\N	\N	\N	\N	\N	\N
508	\N	\N	\N	\N	\N	\N
509	\N	\N	\N	\N	\N	\N
510	\N	\N	\N	\N	\N	\N
511	\N	\N	\N	\N	\N	\N
512	\N	\N	\N	\N	\N	\N
513	\N	\N	\N	\N	\N	\N
514	\N	\N	\N	\N	\N	\N
515	\N	\N	\N	\N	\N	\N
516	\N	\N	\N	\N	\N	\N
517	\N	\N	\N	\N	\N	\N
518	\N	\N	\N	\N	\N	\N
519	\N	\N	\N	\N	\N	\N
520	\N	\N	\N	\N	\N	\N
521	\N	\N	\N	\N	\N	\N
522	\N	\N	\N	\N	\N	\N
523	\N	\N	\N	\N	\N	\N
524	\N	\N	\N	\N	\N	\N
525	\N	\N	\N	\N	\N	\N
526	\N	\N	\N	\N	\N	\N
527	\N	\N	\N	\N	\N	\N
528	\N	\N	\N	\N	\N	\N
529	\N	\N	\N	\N	\N	\N
530	\N	\N	\N	\N	\N	\N
531	\N	\N	\N	\N	\N	\N
532	\N	\N	\N	\N	\N	\N
533	\N	\N	\N	\N	\N	\N
534	\N	\N	\N	\N	\N	\N
535	\N	\N	\N	\N	\N	\N
536	\N	\N	\N	\N	\N	\N
537	\N	\N	\N	\N	\N	\N
538	\N	\N	\N	\N	\N	\N
539	\N	\N	\N	\N	\N	\N
540	\N	\N	\N	\N	\N	\N
541	\N	\N	\N	\N	\N	\N
542	\N	\N	\N	\N	\N	\N
543	\N	\N	\N	\N	\N	\N
544	\N	\N	\N	\N	\N	\N
545	\N	\N	\N	\N	\N	\N
546	\N	\N	\N	\N	\N	\N
547	\N	\N	\N	\N	\N	\N
548	\N	\N	\N	\N	\N	\N
549	\N	\N	\N	\N	\N	\N
550	\N	\N	\N	\N	\N	\N
551	\N	\N	\N	\N	\N	\N
552	\N	\N	\N	\N	\N	\N
553	\N	\N	\N	\N	\N	\N
554	\N	\N	\N	\N	\N	\N
555	\N	\N	\N	\N	\N	\N
556	\N	\N	\N	\N	\N	\N
557	\N	\N	\N	\N	\N	\N
558	\N	\N	\N	\N	\N	\N
559	\N	\N	\N	\N	\N	\N
560	\N	\N	\N	\N	\N	\N
561	\N	\N	\N	\N	\N	\N
562	\N	\N	\N	\N	\N	\N
563	\N	\N	\N	\N	\N	\N
564	\N	\N	\N	\N	\N	\N
565	\N	\N	\N	\N	\N	\N
566	\N	\N	\N	\N	\N	\N
567	\N	\N	\N	\N	\N	\N
568	\N	\N	\N	\N	\N	\N
569	\N	\N	\N	\N	\N	\N
570	\N	\N	\N	\N	\N	\N
571	\N	\N	\N	\N	\N	\N
572	\N	\N	\N	\N	\N	\N
573	\N	\N	\N	\N	\N	\N
574	\N	\N	\N	\N	\N	\N
575	\N	\N	\N	\N	\N	\N
576	\N	\N	\N	\N	\N	\N
577	\N	\N	\N	\N	\N	\N
578	\N	\N	\N	\N	\N	\N
579	\N	\N	\N	\N	\N	\N
580	\N	\N	\N	\N	\N	\N
581	\N	\N	\N	\N	\N	\N
582	\N	\N	\N	\N	\N	\N
583	\N	\N	\N	\N	\N	\N
584	\N	\N	\N	\N	\N	\N
585	\N	\N	\N	\N	\N	\N
586	\N	\N	\N	\N	\N	\N
587	\N	\N	\N	\N	\N	\N
588	\N	\N	\N	\N	\N	\N
589	\N	\N	\N	\N	\N	\N
590	\N	\N	\N	\N	\N	\N
591	\N	\N	\N	\N	\N	\N
592	\N	\N	\N	\N	\N	\N
593	\N	\N	\N	\N	\N	\N
594	\N	\N	\N	\N	\N	\N
595	\N	\N	\N	\N	\N	\N
596	\N	\N	\N	\N	\N	\N
597	\N	\N	\N	\N	\N	\N
598	\N	\N	\N	\N	\N	\N
599	\N	\N	\N	\N	\N	\N
600	\N	\N	\N	\N	\N	\N
601	\N	\N	\N	\N	\N	\N
602	\N	\N	\N	\N	\N	\N
603	\N	\N	\N	\N	\N	\N
604	\N	\N	\N	\N	\N	\N
605	\N	\N	\N	\N	\N	\N
606	\N	\N	\N	\N	\N	\N
607	\N	\N	\N	\N	\N	\N
608	\N	\N	\N	\N	\N	\N
609	\N	\N	\N	\N	\N	\N
610	\N	\N	\N	\N	\N	\N
611	\N	\N	\N	\N	\N	\N
612	\N	\N	\N	\N	\N	\N
613	\N	\N	\N	\N	\N	\N
614	\N	\N	\N	\N	\N	\N
615	\N	\N	\N	\N	\N	\N
616	\N	\N	\N	\N	\N	\N
617	\N	\N	\N	\N	\N	\N
618	\N	\N	\N	\N	\N	\N
619	\N	\N	\N	\N	\N	\N
620	\N	\N	\N	\N	\N	\N
621	\N	\N	\N	\N	\N	\N
622	\N	\N	\N	\N	\N	\N
623	\N	\N	\N	\N	\N	\N
624	\N	\N	\N	\N	\N	\N
625	\N	\N	\N	\N	\N	\N
626	\N	\N	\N	\N	\N	\N
627	\N	\N	\N	\N	\N	\N
628	\N	\N	\N	\N	\N	\N
629	\N	\N	\N	\N	\N	\N
630	\N	\N	\N	\N	\N	\N
631	\N	\N	\N	\N	\N	\N
632	\N	\N	\N	\N	\N	\N
633	\N	\N	\N	\N	\N	\N
634	\N	\N	\N	\N	\N	\N
635	\N	\N	\N	\N	\N	\N
636	\N	\N	\N	\N	\N	\N
637	\N	\N	\N	\N	\N	\N
638	\N	\N	\N	\N	\N	\N
639	\N	\N	\N	\N	\N	\N
640	\N	\N	\N	\N	\N	\N
641	\N	\N	\N	\N	\N	\N
642	\N	\N	\N	\N	\N	\N
643	\N	\N	\N	\N	\N	\N
644	\N	\N	\N	\N	\N	\N
645	\N	\N	\N	\N	\N	\N
646	\N	\N	\N	\N	\N	\N
647	\N	\N	\N	\N	\N	\N
648	\N	\N	\N	\N	\N	\N
649	\N	\N	\N	\N	\N	\N
650	\N	\N	\N	\N	\N	\N
651	\N	\N	\N	\N	\N	\N
652	\N	\N	\N	\N	\N	\N
653	\N	\N	\N	\N	\N	\N
654	\N	\N	\N	\N	\N	\N
655	\N	\N	\N	\N	\N	\N
656	\N	\N	\N	\N	\N	\N
657	\N	\N	\N	\N	\N	\N
658	\N	\N	\N	\N	\N	\N
659	\N	\N	\N	\N	\N	\N
660	\N	\N	\N	\N	\N	\N
661	\N	\N	\N	\N	\N	\N
662	\N	\N	\N	\N	\N	\N
663	\N	\N	\N	\N	\N	\N
664	\N	\N	\N	\N	\N	\N
665	\N	\N	\N	\N	\N	\N
666	\N	\N	\N	\N	\N	\N
667	\N	\N	\N	\N	\N	\N
668	\N	\N	\N	\N	\N	\N
669	\N	\N	\N	\N	\N	\N
670	\N	\N	\N	\N	\N	\N
671	\N	\N	\N	\N	\N	\N
672	\N	\N	\N	\N	\N	\N
673	\N	\N	\N	\N	\N	\N
674	\N	\N	\N	\N	\N	\N
675	\N	\N	\N	\N	\N	\N
676	\N	\N	\N	\N	\N	\N
677	\N	\N	\N	\N	\N	\N
678	\N	\N	\N	\N	\N	\N
679	\N	\N	\N	\N	\N	\N
680	\N	\N	\N	\N	\N	\N
681	\N	\N	\N	\N	\N	\N
682	\N	\N	\N	\N	\N	\N
683	\N	\N	\N	\N	\N	\N
684	\N	\N	\N	\N	\N	\N
685	\N	\N	\N	\N	\N	\N
686	\N	\N	\N	\N	\N	\N
687	\N	\N	\N	\N	\N	\N
688	\N	\N	\N	\N	\N	\N
689	\N	\N	\N	\N	\N	\N
690	\N	\N	\N	\N	\N	\N
691	\N	\N	\N	\N	\N	\N
692	\N	\N	\N	\N	\N	\N
693	\N	\N	\N	\N	\N	\N
694	\N	\N	\N	\N	\N	\N
695	\N	\N	\N	\N	\N	\N
696	\N	\N	\N	\N	\N	\N
697	\N	\N	\N	\N	\N	\N
698	\N	\N	\N	\N	\N	\N
699	\N	\N	\N	\N	\N	\N
700	\N	\N	\N	\N	\N	\N
701	\N	\N	\N	\N	\N	\N
702	\N	\N	\N	\N	\N	\N
703	\N	\N	\N	\N	\N	\N
704	\N	\N	\N	\N	\N	\N
705	\N	\N	\N	\N	\N	\N
706	\N	\N	\N	\N	\N	\N
707	\N	\N	\N	\N	\N	\N
708	\N	\N	\N	\N	\N	\N
709	\N	\N	\N	\N	\N	\N
710	\N	\N	\N	\N	\N	\N
711	\N	\N	\N	\N	\N	\N
712	\N	\N	\N	\N	\N	\N
713	\N	\N	\N	\N	\N	\N
714	\N	\N	\N	\N	\N	\N
715	\N	\N	\N	\N	\N	\N
716	\N	\N	\N	\N	\N	\N
717	\N	\N	\N	\N	\N	\N
718	\N	\N	\N	\N	\N	\N
719	\N	\N	\N	\N	\N	\N
720	\N	\N	\N	\N	\N	\N
721	\N	\N	\N	\N	\N	\N
722	\N	\N	\N	\N	\N	\N
723	\N	\N	\N	\N	\N	\N
724	\N	\N	\N	\N	\N	\N
725	\N	\N	\N	\N	\N	\N
726	\N	\N	\N	\N	\N	\N
727	\N	\N	\N	\N	\N	\N
728	\N	\N	\N	\N	\N	\N
729	\N	\N	\N	\N	\N	\N
730	\N	\N	\N	\N	\N	\N
731	\N	\N	\N	\N	\N	\N
732	\N	\N	\N	\N	\N	\N
733	\N	\N	\N	\N	\N	\N
734	\N	\N	\N	\N	\N	\N
735	\N	\N	\N	\N	\N	\N
736	\N	\N	\N	\N	\N	\N
737	\N	\N	\N	\N	\N	\N
738	\N	\N	\N	\N	\N	\N
739	\N	\N	\N	\N	\N	\N
740	\N	\N	\N	\N	\N	\N
741	\N	\N	\N	\N	\N	\N
742	\N	\N	\N	\N	\N	\N
743	\N	\N	\N	\N	\N	\N
744	\N	\N	\N	\N	\N	\N
745	\N	\N	\N	\N	\N	\N
746	\N	\N	\N	\N	\N	\N
747	\N	\N	\N	\N	\N	\N
748	\N	\N	\N	\N	\N	\N
749	\N	\N	\N	\N	\N	\N
750	\N	\N	\N	\N	\N	\N
751	\N	\N	\N	\N	\N	\N
752	\N	\N	\N	\N	\N	\N
753	\N	\N	\N	\N	\N	\N
754	\N	\N	\N	\N	\N	\N
755	\N	\N	\N	\N	\N	\N
756	\N	\N	\N	\N	\N	\N
757	\N	\N	\N	\N	\N	\N
758	\N	\N	\N	\N	\N	\N
759	\N	\N	\N	\N	\N	\N
760	\N	\N	\N	\N	\N	\N
761	\N	\N	\N	\N	\N	\N
762	\N	\N	\N	\N	\N	\N
763	\N	\N	\N	\N	\N	\N
764	\N	\N	\N	\N	\N	\N
765	\N	\N	\N	\N	\N	\N
766	\N	\N	\N	\N	\N	\N
767	\N	\N	\N	\N	\N	\N
768	\N	\N	\N	\N	\N	\N
769	\N	\N	\N	\N	\N	\N
770	\N	\N	\N	\N	\N	\N
771	\N	\N	\N	\N	\N	\N
772	\N	\N	\N	\N	\N	\N
773	\N	\N	\N	\N	\N	\N
774	\N	\N	\N	\N	\N	\N
775	\N	\N	\N	\N	\N	\N
776	\N	\N	\N	\N	\N	\N
777	\N	\N	\N	\N	\N	\N
778	\N	\N	\N	\N	\N	\N
779	\N	\N	\N	\N	\N	\N
780	\N	\N	\N	\N	\N	\N
781	\N	\N	\N	\N	\N	\N
782	\N	\N	\N	\N	\N	\N
783	\N	\N	\N	\N	\N	\N
784	\N	\N	\N	\N	\N	\N
785	\N	\N	\N	\N	\N	\N
786	\N	\N	\N	\N	\N	\N
787	\N	\N	\N	\N	\N	\N
788	\N	\N	\N	\N	\N	\N
789	\N	\N	\N	\N	\N	\N
790	\N	\N	\N	\N	\N	\N
791	\N	\N	\N	\N	\N	\N
792	\N	\N	\N	\N	\N	\N
793	\N	\N	\N	\N	\N	\N
794	\N	\N	\N	\N	\N	\N
795	\N	\N	\N	\N	\N	\N
796	\N	\N	\N	\N	\N	\N
797	\N	\N	\N	\N	\N	\N
798	\N	\N	\N	\N	\N	\N
799	\N	\N	\N	\N	\N	\N
800	\N	\N	\N	\N	\N	\N
801	\N	\N	\N	\N	\N	\N
802	\N	\N	\N	\N	\N	\N
803	\N	\N	\N	\N	\N	\N
804	\N	\N	\N	\N	\N	\N
805	\N	\N	\N	\N	\N	\N
806	\N	\N	\N	\N	\N	\N
807	\N	\N	\N	\N	\N	\N
808	\N	\N	\N	\N	\N	\N
809	\N	\N	\N	\N	\N	\N
810	\N	\N	\N	\N	\N	\N
811	\N	\N	\N	\N	\N	\N
812	\N	\N	\N	\N	\N	\N
813	\N	\N	\N	\N	\N	\N
814	\N	\N	\N	\N	\N	\N
815	\N	\N	\N	\N	\N	\N
816	\N	\N	\N	\N	\N	\N
817	\N	\N	\N	\N	\N	\N
818	\N	\N	\N	\N	\N	\N
819	\N	\N	\N	\N	\N	\N
820	\N	\N	\N	\N	\N	\N
821	\N	\N	\N	\N	\N	\N
822	\N	\N	\N	\N	\N	\N
823	\N	\N	\N	\N	\N	\N
824	\N	\N	\N	\N	\N	\N
825	\N	\N	\N	\N	\N	\N
826	\N	\N	\N	\N	\N	\N
827	\N	\N	\N	\N	\N	\N
828	\N	\N	\N	\N	\N	\N
829	\N	\N	\N	\N	\N	\N
830	\N	\N	\N	\N	\N	\N
831	\N	\N	\N	\N	\N	\N
832	\N	\N	\N	\N	\N	\N
833	\N	\N	\N	\N	\N	\N
834	\N	\N	\N	\N	\N	\N
835	\N	\N	\N	\N	\N	\N
836	\N	\N	\N	\N	\N	\N
837	\N	\N	\N	\N	\N	\N
838	\N	\N	\N	\N	\N	\N
839	\N	\N	\N	\N	\N	\N
840	\N	\N	\N	\N	\N	\N
841	\N	\N	\N	\N	\N	\N
842	\N	\N	\N	\N	\N	\N
843	\N	\N	\N	\N	\N	\N
844	\N	\N	\N	\N	\N	\N
845	\N	\N	\N	\N	\N	\N
846	\N	\N	\N	\N	\N	\N
847	\N	\N	\N	\N	\N	\N
848	\N	\N	\N	\N	\N	\N
849	\N	\N	\N	\N	\N	\N
850	\N	\N	\N	\N	\N	\N
851	\N	\N	\N	\N	\N	\N
852	\N	\N	\N	\N	\N	\N
853	\N	\N	\N	\N	\N	\N
854	\N	\N	\N	\N	\N	\N
855	\N	\N	\N	\N	\N	\N
856	\N	\N	\N	\N	\N	\N
857	\N	\N	\N	\N	\N	\N
858	\N	\N	\N	\N	\N	\N
859	\N	\N	\N	\N	\N	\N
860	\N	\N	\N	\N	\N	\N
861	\N	\N	\N	\N	\N	\N
862	\N	\N	\N	\N	\N	\N
863	\N	\N	\N	\N	\N	\N
864	\N	\N	\N	\N	\N	\N
865	\N	\N	\N	\N	\N	\N
866	\N	\N	\N	\N	\N	\N
867	\N	\N	\N	\N	\N	\N
868	\N	\N	\N	\N	\N	\N
869	\N	\N	\N	\N	\N	\N
870	\N	\N	\N	\N	\N	\N
871	\N	\N	\N	\N	\N	\N
872	\N	\N	\N	\N	\N	\N
873	\N	\N	\N	\N	\N	\N
874	\N	\N	\N	\N	\N	\N
875	\N	\N	\N	\N	\N	\N
876	\N	\N	\N	\N	\N	\N
877	\N	\N	\N	\N	\N	\N
878	\N	\N	\N	\N	\N	\N
879	\N	\N	\N	\N	\N	\N
880	\N	\N	\N	\N	\N	\N
881	\N	\N	\N	\N	\N	\N
882	\N	\N	\N	\N	\N	\N
883	\N	\N	\N	\N	\N	\N
884	\N	\N	\N	\N	\N	\N
885	\N	\N	\N	\N	\N	\N
886	\N	\N	\N	\N	\N	\N
887	\N	\N	\N	\N	\N	\N
888	\N	\N	\N	\N	\N	\N
889	\N	\N	\N	\N	\N	\N
890	\N	\N	\N	\N	\N	\N
891	\N	\N	\N	\N	\N	\N
892	\N	\N	\N	\N	\N	\N
893	\N	\N	\N	\N	\N	\N
894	\N	\N	\N	\N	\N	\N
895	\N	\N	\N	\N	\N	\N
896	\N	\N	\N	\N	\N	\N
897	\N	\N	\N	\N	\N	\N
898	\N	\N	\N	\N	\N	\N
899	\N	\N	\N	\N	\N	\N
900	\N	\N	\N	\N	\N	\N
901	\N	\N	\N	\N	\N	\N
902	\N	\N	\N	\N	\N	\N
903	\N	\N	\N	\N	\N	\N
904	\N	\N	\N	\N	\N	\N
905	\N	\N	\N	\N	\N	\N
906	\N	\N	\N	\N	\N	\N
907	\N	\N	\N	\N	\N	\N
908	\N	\N	\N	\N	\N	\N
909	\N	\N	\N	\N	\N	\N
910	\N	\N	\N	\N	\N	\N
911	\N	\N	\N	\N	\N	\N
912	\N	\N	\N	\N	\N	\N
913	\N	\N	\N	\N	\N	\N
914	\N	\N	\N	\N	\N	\N
915	\N	\N	\N	\N	\N	\N
916	\N	\N	\N	\N	\N	\N
917	\N	\N	\N	\N	\N	\N
918	\N	\N	\N	\N	\N	\N
919	\N	\N	\N	\N	\N	\N
920	\N	\N	\N	\N	\N	\N
921	\N	\N	\N	\N	\N	\N
922	\N	\N	\N	\N	\N	\N
923	\N	\N	\N	\N	\N	\N
924	\N	\N	\N	\N	\N	\N
925	\N	\N	\N	\N	\N	\N
926	\N	\N	\N	\N	\N	\N
927	\N	\N	\N	\N	\N	\N
928	\N	\N	\N	\N	\N	\N
929	\N	\N	\N	\N	\N	\N
930	\N	\N	\N	\N	\N	\N
931	\N	\N	\N	\N	\N	\N
932	\N	\N	\N	\N	\N	\N
933	\N	\N	\N	\N	\N	\N
934	\N	\N	\N	\N	\N	\N
935	\N	\N	\N	\N	\N	\N
936	\N	\N	\N	\N	\N	\N
937	\N	\N	\N	\N	\N	\N
938	\N	\N	\N	\N	\N	\N
939	\N	\N	\N	\N	\N	\N
940	\N	\N	\N	\N	\N	\N
941	\N	\N	\N	\N	\N	\N
942	\N	\N	\N	\N	\N	\N
943	\N	\N	\N	\N	\N	\N
944	\N	\N	\N	\N	\N	\N
945	\N	\N	\N	\N	\N	\N
946	\N	\N	\N	\N	\N	\N
947	\N	\N	\N	\N	\N	\N
948	\N	\N	\N	\N	\N	\N
949	\N	\N	\N	\N	\N	\N
950	\N	\N	\N	\N	\N	\N
951	\N	\N	\N	\N	\N	\N
952	\N	\N	\N	\N	\N	\N
953	\N	\N	\N	\N	\N	\N
954	\N	\N	\N	\N	\N	\N
955	\N	\N	\N	\N	\N	\N
956	\N	\N	\N	\N	\N	\N
957	\N	\N	\N	\N	\N	\N
958	\N	\N	\N	\N	\N	\N
959	\N	\N	\N	\N	\N	\N
960	\N	\N	\N	\N	\N	\N
961	\N	\N	\N	\N	\N	\N
962	\N	\N	\N	\N	\N	\N
963	\N	\N	\N	\N	\N	\N
964	\N	\N	\N	\N	\N	\N
965	\N	\N	\N	\N	\N	\N
966	\N	\N	\N	\N	\N	\N
967	\N	\N	\N	\N	\N	\N
968	\N	\N	\N	\N	\N	\N
969	\N	\N	\N	\N	\N	\N
970	\N	\N	\N	\N	\N	\N
971	\N	\N	\N	\N	\N	\N
972	\N	\N	\N	\N	\N	\N
973	\N	\N	\N	\N	\N	\N
974	\N	\N	\N	\N	\N	\N
975	\N	\N	\N	\N	\N	\N
976	\N	\N	\N	\N	\N	\N
977	\N	\N	\N	\N	\N	\N
978	\N	\N	\N	\N	\N	\N
979	\N	\N	\N	\N	\N	\N
980	\N	\N	\N	\N	\N	\N
981	\N	\N	\N	\N	\N	\N
982	\N	\N	\N	\N	\N	\N
983	\N	\N	\N	\N	\N	\N
984	\N	\N	\N	\N	\N	\N
985	\N	\N	\N	\N	\N	\N
986	\N	\N	\N	\N	\N	\N
987	\N	\N	\N	\N	\N	\N
988	\N	\N	\N	\N	\N	\N
989	\N	\N	\N	\N	\N	\N
990	\N	\N	\N	\N	\N	\N
991	\N	\N	\N	\N	\N	\N
992	\N	\N	\N	\N	\N	\N
993	\N	\N	\N	\N	\N	\N
994	\N	\N	\N	\N	\N	\N
995	\N	\N	\N	\N	\N	\N
996	\N	\N	\N	\N	\N	\N
997	\N	\N	\N	\N	\N	\N
998	\N	\N	\N	\N	\N	\N
999	\N	\N	\N	\N	\N	\N
1000	\N	\N	\N	\N	\N	\N
1001	\N	\N	\N	\N	\N	\N
1002	\N	\N	\N	\N	\N	\N
1003	\N	\N	\N	\N	\N	\N
1004	\N	\N	\N	\N	\N	\N
1005	\N	\N	\N	\N	\N	\N
1006	\N	\N	\N	\N	\N	\N
1007	\N	\N	\N	\N	\N	\N
1008	\N	\N	\N	\N	\N	\N
1009	\N	\N	\N	\N	\N	\N
1010	\N	\N	\N	\N	\N	\N
1011	\N	\N	\N	\N	\N	\N
1012	\N	\N	\N	\N	\N	\N
1013	\N	\N	\N	\N	\N	\N
1014	\N	\N	\N	\N	\N	\N
1015	\N	\N	\N	\N	\N	\N
1016	\N	\N	\N	\N	\N	\N
1017	\N	\N	\N	\N	\N	\N
1018	\N	\N	\N	\N	\N	\N
1019	\N	\N	\N	\N	\N	\N
1020	\N	\N	\N	\N	\N	\N
1021	\N	\N	\N	\N	\N	\N
1022	\N	\N	\N	\N	\N	\N
1023	\N	\N	\N	\N	\N	\N
1024	\N	\N	\N	\N	\N	\N
1025	\N	\N	\N	\N	\N	\N
1026	\N	\N	\N	\N	\N	\N
1027	\N	\N	\N	\N	\N	\N
1028	\N	\N	\N	\N	\N	\N
1029	\N	\N	\N	\N	\N	\N
1030	\N	\N	\N	\N	\N	\N
1031	\N	\N	\N	\N	\N	\N
1032	\N	\N	\N	\N	\N	\N
1033	\N	\N	\N	\N	\N	\N
1034	\N	\N	\N	\N	\N	\N
1035	\N	\N	\N	\N	\N	\N
1036	\N	\N	\N	\N	\N	\N
1037	\N	\N	\N	\N	\N	\N
1038	\N	\N	\N	\N	\N	\N
1039	\N	\N	\N	\N	\N	\N
1040	\N	\N	\N	\N	\N	\N
1041	\N	\N	\N	\N	\N	\N
1042	\N	\N	\N	\N	\N	\N
1043	\N	\N	\N	\N	\N	\N
1044	\N	\N	\N	\N	\N	\N
1045	\N	\N	\N	\N	\N	\N
1046	\N	\N	\N	\N	\N	\N
1047	\N	\N	\N	\N	\N	\N
1048	\N	\N	\N	\N	\N	\N
1049	\N	\N	\N	\N	\N	\N
1050	\N	\N	\N	\N	\N	\N
1051	\N	\N	\N	\N	\N	\N
1052	\N	\N	\N	\N	\N	\N
1053	\N	\N	\N	\N	\N	\N
1054	\N	\N	\N	\N	\N	\N
1055	\N	\N	\N	\N	\N	\N
1056	\N	\N	\N	\N	\N	\N
1057	\N	\N	\N	\N	\N	\N
1058	\N	\N	\N	\N	\N	\N
1059	\N	\N	\N	\N	\N	\N
1060	\N	\N	\N	\N	\N	\N
1061	\N	\N	\N	\N	\N	\N
1062	\N	\N	\N	\N	\N	\N
1063	\N	\N	\N	\N	\N	\N
1064	\N	\N	\N	\N	\N	\N
1065	\N	\N	\N	\N	\N	\N
1066	\N	\N	\N	\N	\N	\N
1067	\N	\N	\N	\N	\N	\N
1068	\N	\N	\N	\N	\N	\N
1069	\N	\N	\N	\N	\N	\N
1070	\N	\N	\N	\N	\N	\N
1071	\N	\N	\N	\N	\N	\N
1072	\N	\N	\N	\N	\N	\N
1073	\N	\N	\N	\N	\N	\N
1074	\N	\N	\N	\N	\N	\N
1075	\N	\N	\N	\N	\N	\N
1076	\N	\N	\N	\N	\N	\N
1077	\N	\N	\N	\N	\N	\N
1078	\N	\N	\N	\N	\N	\N
1079	\N	\N	\N	\N	\N	\N
1080	\N	\N	\N	\N	\N	\N
1081	\N	\N	\N	\N	\N	\N
1082	\N	\N	\N	\N	\N	\N
1083	\N	\N	\N	\N	\N	\N
1084	\N	\N	\N	\N	\N	\N
1085	\N	\N	\N	\N	\N	\N
1086	\N	\N	\N	\N	\N	\N
1087	\N	\N	\N	\N	\N	\N
1088	\N	\N	\N	\N	\N	\N
1089	\N	\N	\N	\N	\N	\N
1090	\N	\N	\N	\N	\N	\N
1091	\N	\N	\N	\N	\N	\N
1092	\N	\N	\N	\N	\N	\N
1093	\N	\N	\N	\N	\N	\N
1094	\N	\N	\N	\N	\N	\N
1095	\N	\N	\N	\N	\N	\N
1096	\N	\N	\N	\N	\N	\N
1097	\N	\N	\N	\N	\N	\N
1098	\N	\N	\N	\N	\N	\N
1099	\N	\N	\N	\N	\N	\N
1100	\N	\N	\N	\N	\N	\N
1101	\N	\N	\N	\N	\N	\N
1102	\N	\N	\N	\N	\N	\N
1103	\N	\N	\N	\N	\N	\N
1104	\N	\N	\N	\N	\N	\N
1105	\N	\N	\N	\N	\N	\N
1106	\N	\N	\N	\N	\N	\N
1107	\N	\N	\N	\N	\N	\N
1108	\N	\N	\N	\N	\N	\N
1109	\N	\N	\N	\N	\N	\N
1110	\N	\N	\N	\N	\N	\N
1111	\N	\N	\N	\N	\N	\N
1112	\N	\N	\N	\N	\N	\N
1113	\N	\N	\N	\N	\N	\N
1114	\N	\N	\N	\N	\N	\N
1115	\N	\N	\N	\N	\N	\N
1116	\N	\N	\N	\N	\N	\N
1117	\N	\N	\N	\N	\N	\N
1118	\N	\N	\N	\N	\N	\N
1119	\N	\N	\N	\N	\N	\N
1120	\N	\N	\N	\N	\N	\N
1121	\N	\N	\N	\N	\N	\N
1122	\N	\N	\N	\N	\N	\N
1123	\N	\N	\N	\N	\N	\N
1124	\N	\N	\N	\N	\N	\N
1125	\N	\N	\N	\N	\N	\N
1126	\N	\N	\N	\N	\N	\N
1127	\N	\N	\N	\N	\N	\N
1128	\N	\N	\N	\N	\N	\N
1129	\N	\N	\N	\N	\N	\N
1130	\N	\N	\N	\N	\N	\N
1131	\N	\N	\N	\N	\N	\N
1132	\N	\N	\N	\N	\N	\N
1133	\N	\N	\N	\N	\N	\N
1134	\N	\N	\N	\N	\N	\N
1135	\N	\N	\N	\N	\N	\N
1136	\N	\N	\N	\N	\N	\N
1137	\N	\N	\N	\N	\N	\N
1138	\N	\N	\N	\N	\N	\N
1139	\N	\N	\N	\N	\N	\N
1140	\N	\N	\N	\N	\N	\N
1141	\N	\N	\N	\N	\N	\N
1142	\N	\N	\N	\N	\N	\N
1143	\N	\N	\N	\N	\N	\N
1144	\N	\N	\N	\N	\N	\N
1145	\N	\N	\N	\N	\N	\N
1146	\N	\N	\N	\N	\N	\N
1147	\N	\N	\N	\N	\N	\N
1148	\N	\N	\N	\N	\N	\N
1149	\N	\N	\N	\N	\N	\N
1150	\N	\N	\N	\N	\N	\N
1151	\N	\N	\N	\N	\N	\N
1152	\N	\N	\N	\N	\N	\N
1153	\N	\N	\N	\N	\N	\N
1154	\N	\N	\N	\N	\N	\N
1155	\N	\N	\N	\N	\N	\N
1156	\N	\N	\N	\N	\N	\N
1157	\N	\N	\N	\N	\N	\N
1158	\N	\N	\N	\N	\N	\N
1159	\N	\N	\N	\N	\N	\N
1160	\N	\N	\N	\N	\N	\N
1161	\N	\N	\N	\N	\N	\N
1162	\N	\N	\N	\N	\N	\N
1163	\N	\N	\N	\N	\N	\N
1164	\N	\N	\N	\N	\N	\N
1165	\N	\N	\N	\N	\N	\N
1166	\N	\N	\N	\N	\N	\N
1167	\N	\N	\N	\N	\N	\N
1168	\N	\N	\N	\N	\N	\N
1169	\N	\N	\N	\N	\N	\N
1170	\N	\N	\N	\N	\N	\N
1171	\N	\N	\N	\N	\N	\N
1172	\N	\N	\N	\N	\N	\N
1173	\N	\N	\N	\N	\N	\N
1174	\N	\N	\N	\N	\N	\N
1175	\N	\N	\N	\N	\N	\N
1176	\N	\N	\N	\N	\N	\N
1177	\N	\N	\N	\N	\N	\N
1178	\N	\N	\N	\N	\N	\N
1179	\N	\N	\N	\N	\N	\N
1180	\N	\N	\N	\N	\N	\N
1181	\N	\N	\N	\N	\N	\N
1182	\N	\N	\N	\N	\N	\N
1183	\N	\N	\N	\N	\N	\N
1184	\N	\N	\N	\N	\N	\N
1185	\N	\N	\N	\N	\N	\N
1186	\N	\N	\N	\N	\N	\N
1187	\N	\N	\N	\N	\N	\N
1188	\N	\N	\N	\N	\N	\N
1189	\N	\N	\N	\N	\N	\N
1190	\N	\N	\N	\N	\N	\N
1191	\N	\N	\N	\N	\N	\N
1192	\N	\N	\N	\N	\N	\N
1193	\N	\N	\N	\N	\N	\N
1194	\N	\N	\N	\N	\N	\N
1195	\N	\N	\N	\N	\N	\N
1196	\N	\N	\N	\N	\N	\N
1197	\N	\N	\N	\N	\N	\N
1198	\N	\N	\N	\N	\N	\N
1199	\N	\N	\N	\N	\N	\N
1200	\N	\N	\N	\N	\N	\N
1201	\N	\N	\N	\N	\N	\N
1202	\N	\N	\N	\N	\N	\N
1203	\N	\N	\N	\N	\N	\N
1204	\N	\N	\N	\N	\N	\N
1205	\N	\N	\N	\N	\N	\N
1206	\N	\N	\N	\N	\N	\N
1207	\N	\N	\N	\N	\N	\N
1208	\N	\N	\N	\N	\N	\N
1209	\N	\N	\N	\N	\N	\N
1210	\N	\N	\N	\N	\N	\N
1211	\N	\N	\N	\N	\N	\N
1212	\N	\N	\N	\N	\N	\N
1213	\N	\N	\N	\N	\N	\N
1214	\N	\N	\N	\N	\N	\N
1215	\N	\N	\N	\N	\N	\N
1216	\N	\N	\N	\N	\N	\N
1217	\N	\N	\N	\N	\N	\N
1218	\N	\N	\N	\N	\N	\N
1219	\N	\N	\N	\N	\N	\N
1220	\N	\N	\N	\N	\N	\N
1221	\N	\N	\N	\N	\N	\N
1222	\N	\N	\N	\N	\N	\N
1223	\N	\N	\N	\N	\N	\N
1224	\N	\N	\N	\N	\N	\N
1225	\N	\N	\N	\N	\N	\N
1226	\N	\N	\N	\N	\N	\N
1227	\N	\N	\N	\N	\N	\N
1228	\N	\N	\N	\N	\N	\N
1229	\N	\N	\N	\N	\N	\N
1230	\N	\N	\N	\N	\N	\N
1231	\N	\N	\N	\N	\N	\N
1232	\N	\N	\N	\N	\N	\N
1233	\N	\N	\N	\N	\N	\N
1234	\N	\N	\N	\N	\N	\N
1235	\N	\N	\N	\N	\N	\N
1236	\N	\N	\N	\N	\N	\N
1237	\N	\N	\N	\N	\N	\N
1238	\N	\N	\N	\N	\N	\N
1239	\N	\N	\N	\N	\N	\N
1240	\N	\N	\N	\N	\N	\N
1241	\N	\N	\N	\N	\N	\N
1242	\N	\N	\N	\N	\N	\N
1243	\N	\N	\N	\N	\N	\N
1244	\N	\N	\N	\N	\N	\N
1245	\N	\N	\N	\N	\N	\N
1246	\N	\N	\N	\N	\N	\N
1247	\N	\N	\N	\N	\N	\N
1248	\N	\N	\N	\N	\N	\N
1249	\N	\N	\N	\N	\N	\N
1250	\N	\N	\N	\N	\N	\N
1251	\N	\N	\N	\N	\N	\N
1252	\N	\N	\N	\N	\N	\N
1253	\N	\N	\N	\N	\N	\N
1254	\N	\N	\N	\N	\N	\N
1255	\N	\N	\N	\N	\N	\N
1256	\N	\N	\N	\N	\N	\N
1257	\N	\N	\N	\N	\N	\N
1258	\N	\N	\N	\N	\N	\N
1259	\N	\N	\N	\N	\N	\N
1260	\N	\N	\N	\N	\N	\N
1261	\N	\N	\N	\N	\N	\N
1262	\N	\N	\N	\N	\N	\N
1263	\N	\N	\N	\N	\N	\N
1264	\N	\N	\N	\N	\N	\N
1265	\N	\N	\N	\N	\N	\N
1266	\N	\N	\N	\N	\N	\N
1267	\N	\N	\N	\N	\N	\N
1268	\N	\N	\N	\N	\N	\N
1269	\N	\N	\N	\N	\N	\N
1270	\N	\N	\N	\N	\N	\N
1271	\N	\N	\N	\N	\N	\N
1272	\N	\N	\N	\N	\N	\N
1273	\N	\N	\N	\N	\N	\N
1274	\N	\N	\N	\N	\N	\N
1275	\N	\N	\N	\N	\N	\N
1276	\N	\N	\N	\N	\N	\N
1277	\N	\N	\N	\N	\N	\N
1278	\N	\N	\N	\N	\N	\N
1279	\N	\N	\N	\N	\N	\N
1280	\N	\N	\N	\N	\N	\N
1281	\N	\N	\N	\N	\N	\N
1282	\N	\N	\N	\N	\N	\N
1283	\N	\N	\N	\N	\N	\N
1284	\N	\N	\N	\N	\N	\N
1285	\N	\N	\N	\N	\N	\N
1286	\N	\N	\N	\N	\N	\N
1287	\N	\N	\N	\N	\N	\N
1288	\N	\N	\N	\N	\N	\N
1289	\N	\N	\N	\N	\N	\N
1290	\N	\N	\N	\N	\N	\N
1291	\N	\N	\N	\N	\N	\N
1292	\N	\N	\N	\N	\N	\N
1293	\N	\N	\N	\N	\N	\N
1294	\N	\N	\N	\N	\N	\N
1295	\N	\N	\N	\N	\N	\N
1296	\N	\N	\N	\N	\N	\N
1297	\N	\N	\N	\N	\N	\N
1298	\N	\N	\N	\N	\N	\N
1299	\N	\N	\N	\N	\N	\N
1300	\N	\N	\N	\N	\N	\N
1301	\N	\N	\N	\N	\N	\N
1302	\N	\N	\N	\N	\N	\N
1303	\N	\N	\N	\N	\N	\N
1304	\N	\N	\N	\N	\N	\N
1305	\N	\N	\N	\N	\N	\N
1306	\N	\N	\N	\N	\N	\N
1307	\N	\N	\N	\N	\N	\N
1308	\N	\N	\N	\N	\N	\N
1309	\N	\N	\N	\N	\N	\N
1310	\N	\N	\N	\N	\N	\N
1311	\N	\N	\N	\N	\N	\N
1312	\N	\N	\N	\N	\N	\N
1313	\N	\N	\N	\N	\N	\N
1314	\N	\N	\N	\N	\N	\N
1315	\N	\N	\N	\N	\N	\N
1316	\N	\N	\N	\N	\N	\N
1317	\N	\N	\N	\N	\N	\N
1318	\N	\N	\N	\N	\N	\N
1319	\N	\N	\N	\N	\N	\N
1320	\N	\N	\N	\N	\N	\N
1321	\N	\N	\N	\N	\N	\N
1322	\N	\N	\N	\N	\N	\N
1323	\N	\N	\N	\N	\N	\N
1324	\N	\N	\N	\N	\N	\N
1325	\N	\N	\N	\N	\N	\N
1326	\N	\N	\N	\N	\N	\N
1327	\N	\N	\N	\N	\N	\N
1328	\N	\N	\N	\N	\N	\N
1329	\N	\N	\N	\N	\N	\N
1330	\N	\N	\N	\N	\N	\N
1331	\N	\N	\N	\N	\N	\N
1332	\N	\N	\N	\N	\N	\N
1333	\N	\N	\N	\N	\N	\N
1334	\N	\N	\N	\N	\N	\N
1335	\N	\N	\N	\N	\N	\N
1336	\N	\N	\N	\N	\N	\N
1337	\N	\N	\N	\N	\N	\N
1338	\N	\N	\N	\N	\N	\N
1339	\N	\N	\N	\N	\N	\N
1340	\N	\N	\N	\N	\N	\N
1341	\N	\N	\N	\N	\N	\N
1342	\N	\N	\N	\N	\N	\N
1343	\N	\N	\N	\N	\N	\N
1344	\N	\N	\N	\N	\N	\N
1345	\N	\N	\N	\N	\N	\N
1346	\N	\N	\N	\N	\N	\N
1347	\N	\N	\N	\N	\N	\N
1348	\N	\N	\N	\N	\N	\N
1349	\N	\N	\N	\N	\N	\N
1350	\N	\N	\N	\N	\N	\N
1351	\N	\N	\N	\N	\N	\N
1352	\N	\N	\N	\N	\N	\N
1353	\N	\N	\N	\N	\N	\N
1354	\N	\N	\N	\N	\N	\N
1355	\N	\N	\N	\N	\N	\N
1356	\N	\N	\N	\N	\N	\N
1357	\N	\N	\N	\N	\N	\N
1358	\N	\N	\N	\N	\N	\N
1359	\N	\N	\N	\N	\N	\N
1360	\N	\N	\N	\N	\N	\N
1361	\N	\N	\N	\N	\N	\N
1362	\N	\N	\N	\N	\N	\N
1363	\N	\N	\N	\N	\N	\N
1364	\N	\N	\N	\N	\N	\N
1365	\N	\N	\N	\N	\N	\N
1366	\N	\N	\N	\N	\N	\N
1367	\N	\N	\N	\N	\N	\N
1368	\N	\N	\N	\N	\N	\N
1369	\N	\N	\N	\N	\N	\N
1370	\N	\N	\N	\N	\N	\N
1371	\N	\N	\N	\N	\N	\N
1372	\N	\N	\N	\N	\N	\N
1373	\N	\N	\N	\N	\N	\N
1374	\N	\N	\N	\N	\N	\N
1375	\N	\N	\N	\N	\N	\N
1376	\N	\N	\N	\N	\N	\N
1377	\N	\N	\N	\N	\N	\N
1378	\N	\N	\N	\N	\N	\N
1379	\N	\N	\N	\N	\N	\N
1380	\N	\N	\N	\N	\N	\N
1381	\N	\N	\N	\N	\N	\N
1382	\N	\N	\N	\N	\N	\N
1383	\N	\N	\N	\N	\N	\N
1384	\N	\N	\N	\N	\N	\N
1385	\N	\N	\N	\N	\N	\N
1386	\N	\N	\N	\N	\N	\N
1387	\N	\N	\N	\N	\N	\N
1388	\N	\N	\N	\N	\N	\N
1389	\N	\N	\N	\N	\N	\N
1390	\N	\N	\N	\N	\N	\N
1391	\N	\N	\N	\N	\N	\N
1392	\N	\N	\N	\N	\N	\N
1393	\N	\N	\N	\N	\N	\N
1394	\N	\N	\N	\N	\N	\N
1395	\N	\N	\N	\N	\N	\N
1396	\N	\N	\N	\N	\N	\N
1397	\N	\N	\N	\N	\N	\N
1398	\N	\N	\N	\N	\N	\N
1399	\N	\N	\N	\N	\N	\N
1400	\N	\N	\N	\N	\N	\N
1401	\N	\N	\N	\N	\N	\N
1402	\N	\N	\N	\N	\N	\N
1403	\N	\N	\N	\N	\N	\N
1404	\N	\N	\N	\N	\N	\N
1405	\N	\N	\N	\N	\N	\N
1406	\N	\N	\N	\N	\N	\N
1407	\N	\N	\N	\N	\N	\N
1408	\N	\N	\N	\N	\N	\N
1409	\N	\N	\N	\N	\N	\N
1410	\N	\N	\N	\N	\N	\N
1411	\N	\N	\N	\N	\N	\N
1412	\N	\N	\N	\N	\N	\N
1413	\N	\N	\N	\N	\N	\N
1414	\N	\N	\N	\N	\N	\N
1415	\N	\N	\N	\N	\N	\N
1416	\N	\N	\N	\N	\N	\N
1417	\N	\N	\N	\N	\N	\N
1418	\N	\N	\N	\N	\N	\N
1419	\N	\N	\N	\N	\N	\N
1420	\N	\N	\N	\N	\N	\N
1421	\N	\N	\N	\N	\N	\N
1422	\N	\N	\N	\N	\N	\N
1423	\N	\N	\N	\N	\N	\N
1424	\N	\N	\N	\N	\N	\N
1425	\N	\N	\N	\N	\N	\N
1426	\N	\N	\N	\N	\N	\N
1427	\N	\N	\N	\N	\N	\N
1428	\N	\N	\N	\N	\N	\N
1429	\N	\N	\N	\N	\N	\N
1430	\N	\N	\N	\N	\N	\N
1431	\N	\N	\N	\N	\N	\N
1432	\N	\N	\N	\N	\N	\N
1433	\N	\N	\N	\N	\N	\N
1434	\N	\N	\N	\N	\N	\N
1435	\N	\N	\N	\N	\N	\N
1436	\N	\N	\N	\N	\N	\N
1437	\N	\N	\N	\N	\N	\N
1438	\N	\N	\N	\N	\N	\N
1439	\N	\N	\N	\N	\N	\N
1440	\N	\N	\N	\N	\N	\N
1441	\N	\N	\N	\N	\N	\N
1442	\N	\N	\N	\N	\N	\N
1443	\N	\N	\N	\N	\N	\N
1444	\N	\N	\N	\N	\N	\N
1445	\N	\N	\N	\N	\N	\N
1446	\N	\N	\N	\N	\N	\N
1447	\N	\N	\N	\N	\N	\N
1448	\N	\N	\N	\N	\N	\N
1449	\N	\N	\N	\N	\N	\N
1450	\N	\N	\N	\N	\N	\N
1451	\N	\N	\N	\N	\N	\N
1452	\N	\N	\N	\N	\N	\N
1453	\N	\N	\N	\N	\N	\N
1454	\N	\N	\N	\N	\N	\N
1455	\N	\N	\N	\N	\N	\N
1456	\N	\N	\N	\N	\N	\N
1457	\N	\N	\N	\N	\N	\N
1458	\N	\N	\N	\N	\N	\N
1459	\N	\N	\N	\N	\N	\N
1460	\N	\N	\N	\N	\N	\N
1461	\N	\N	\N	\N	\N	\N
1462	\N	\N	\N	\N	\N	\N
1463	\N	\N	\N	\N	\N	\N
1464	\N	\N	\N	\N	\N	\N
1465	\N	\N	\N	\N	\N	\N
1466	\N	\N	\N	\N	\N	\N
1485	\N	\N	\N	\N	\N	\N
1486	\N	\N	\N	\N	\N	\N
1487	\N	\N	\N	\N	\N	\N
1488	\N	\N	\N	\N	\N	\N
1489	\N	\N	\N	\N	\N	\N
1490	\N	\N	\N	\N	\N	\N
1491	\N	\N	\N	\N	\N	\N
1492	\N	\N	\N	\N	\N	\N
1493	\N	\N	\N	\N	\N	\N
1494	\N	\N	\N	\N	\N	\N
1495	\N	\N	\N	\N	\N	\N
1496	\N	\N	\N	\N	\N	\N
1497	\N	\N	\N	\N	\N	\N
1498	\N	\N	\N	\N	\N	\N
1499	\N	\N	\N	\N	\N	\N
1500	\N	\N	\N	\N	\N	\N
1501	\N	\N	\N	\N	\N	\N
1502	\N	\N	\N	\N	\N	\N
1503	\N	\N	\N	\N	\N	\N
1504	\N	\N	\N	\N	\N	\N
1505	\N	\N	\N	\N	\N	\N
1506	\N	\N	\N	\N	\N	\N
1507	\N	\N	\N	\N	\N	\N
1508	\N	\N	\N	\N	\N	\N
1509	\N	\N	\N	\N	\N	\N
1510	\N	\N	\N	\N	\N	\N
1511	\N	\N	\N	\N	\N	\N
1512	\N	\N	\N	\N	\N	\N
1513	\N	\N	\N	\N	\N	\N
1514	\N	\N	\N	\N	\N	\N
1515	\N	\N	\N	\N	\N	\N
1516	\N	\N	\N	\N	\N	\N
1517	\N	\N	\N	\N	\N	\N
1518	\N	\N	\N	\N	\N	\N
1519	\N	\N	\N	\N	\N	\N
1520	\N	\N	\N	\N	\N	\N
1521	\N	\N	\N	\N	\N	\N
1522	\N	\N	\N	\N	\N	\N
1523	\N	\N	\N	\N	\N	\N
1524	\N	\N	\N	\N	\N	\N
1525	\N	\N	\N	\N	\N	\N
1526	\N	\N	\N	\N	\N	\N
1527	\N	\N	\N	\N	\N	\N
1528	\N	\N	\N	\N	\N	\N
1529	\N	\N	\N	\N	\N	\N
1530	\N	\N	\N	\N	\N	\N
1531	\N	\N	\N	\N	\N	\N
1532	\N	\N	\N	\N	\N	\N
1533	\N	\N	\N	\N	\N	\N
1534	\N	\N	\N	\N	\N	\N
1535	\N	\N	\N	\N	\N	\N
1536	\N	\N	\N	\N	\N	\N
1537	\N	\N	\N	\N	\N	\N
1538	\N	\N	\N	\N	\N	\N
1539	\N	\N	\N	\N	\N	\N
1540	\N	\N	\N	\N	\N	\N
1541	\N	\N	\N	\N	\N	\N
1542	\N	\N	\N	\N	\N	\N
1543	\N	\N	\N	\N	\N	\N
1544	\N	\N	\N	\N	\N	\N
1545	\N	\N	\N	\N	\N	\N
1546	\N	\N	\N	\N	\N	\N
1547	\N	\N	\N	\N	\N	\N
1548	\N	\N	\N	\N	\N	\N
1549	\N	\N	\N	\N	\N	\N
1550	\N	\N	\N	\N	\N	\N
1551	\N	\N	\N	\N	\N	\N
1552	\N	\N	\N	\N	\N	\N
1553	\N	\N	\N	\N	\N	\N
1554	\N	\N	\N	\N	\N	\N
1555	\N	\N	\N	\N	\N	\N
1556	\N	\N	\N	\N	\N	\N
1557	\N	\N	\N	\N	\N	\N
1558	\N	\N	\N	\N	\N	\N
1559	\N	\N	\N	\N	\N	\N
1560	\N	\N	\N	\N	\N	\N
1561	\N	\N	\N	\N	\N	\N
1562	\N	\N	\N	\N	\N	\N
1563	\N	\N	\N	\N	\N	\N
1564	\N	\N	\N	\N	\N	\N
1565	\N	\N	\N	\N	\N	\N
1566	\N	\N	\N	\N	\N	\N
1567	\N	\N	\N	\N	\N	\N
1568	\N	\N	\N	\N	\N	\N
1569	\N	\N	\N	\N	\N	\N
1570	\N	\N	\N	\N	\N	\N
1571	\N	\N	\N	\N	\N	\N
1572	\N	\N	\N	\N	\N	\N
1573	\N	\N	\N	\N	\N	\N
1574	\N	\N	\N	\N	\N	\N
1575	\N	\N	\N	\N	\N	\N
1576	\N	\N	\N	\N	\N	\N
1577	\N	\N	\N	\N	\N	\N
1578	\N	\N	\N	\N	\N	\N
1579	\N	\N	\N	\N	\N	\N
1580	\N	\N	\N	\N	\N	\N
1581	\N	\N	\N	\N	\N	\N
1582	\N	\N	\N	\N	\N	\N
1583	\N	\N	\N	\N	\N	\N
1584	\N	\N	\N	\N	\N	\N
1585	\N	\N	\N	\N	\N	\N
1586	\N	\N	\N	\N	\N	\N
1587	\N	\N	\N	\N	\N	\N
1588	\N	\N	\N	\N	\N	\N
1589	\N	\N	\N	\N	\N	\N
1590	\N	\N	\N	\N	\N	\N
1591	\N	\N	\N	\N	\N	\N
1592	\N	\N	\N	\N	\N	\N
1593	\N	\N	\N	\N	\N	\N
1594	\N	\N	\N	\N	\N	\N
1595	\N	\N	\N	\N	\N	\N
1596	\N	\N	\N	\N	\N	\N
1597	\N	\N	\N	\N	\N	\N
1598	\N	\N	\N	\N	\N	\N
1599	\N	\N	\N	\N	\N	\N
1600	\N	\N	\N	\N	\N	\N
1601	\N	\N	\N	\N	\N	\N
1602	\N	\N	\N	\N	\N	\N
1603	\N	\N	\N	\N	\N	\N
1604	\N	\N	\N	\N	\N	\N
1605	\N	\N	\N	\N	\N	\N
1606	\N	\N	\N	\N	\N	\N
1607	\N	\N	\N	\N	\N	\N
1608	\N	\N	\N	\N	\N	\N
1609	\N	\N	\N	\N	\N	\N
1610	\N	\N	\N	\N	\N	\N
1611	\N	\N	\N	\N	\N	\N
1612	\N	\N	\N	\N	\N	\N
1613	\N	\N	\N	\N	\N	\N
1614	\N	\N	\N	\N	\N	\N
1615	\N	\N	\N	\N	\N	\N
1616	\N	\N	\N	\N	\N	\N
1617	\N	\N	\N	\N	\N	\N
1618	\N	\N	\N	\N	\N	\N
1619	\N	\N	\N	\N	\N	\N
1620	\N	\N	\N	\N	\N	\N
1621	\N	\N	\N	\N	\N	\N
1622	\N	\N	\N	\N	\N	\N
1623	\N	\N	\N	\N	\N	\N
1624	\N	\N	\N	\N	\N	\N
1625	\N	\N	\N	\N	\N	\N
1626	\N	\N	\N	\N	\N	\N
1627	\N	\N	\N	\N	\N	\N
1628	\N	\N	\N	\N	\N	\N
1629	\N	\N	\N	\N	\N	\N
1630	\N	\N	\N	\N	\N	\N
1631	\N	\N	\N	\N	\N	\N
1632	\N	\N	\N	\N	\N	\N
1633	\N	\N	\N	\N	\N	\N
1634	\N	\N	\N	\N	\N	\N
1635	\N	\N	\N	\N	\N	\N
1636	\N	\N	\N	\N	\N	\N
1637	\N	\N	\N	\N	\N	\N
1638	\N	\N	\N	\N	\N	\N
1639	\N	\N	\N	\N	\N	\N
1640	\N	\N	\N	\N	\N	\N
1641	\N	\N	\N	\N	\N	\N
1642	\N	\N	\N	\N	\N	\N
1643	\N	\N	\N	\N	\N	\N
1644	\N	\N	\N	\N	\N	\N
1645	\N	\N	\N	\N	\N	\N
1646	\N	\N	\N	\N	\N	\N
1647	\N	\N	\N	\N	\N	\N
1648	\N	\N	\N	\N	\N	\N
1649	\N	\N	\N	\N	\N	\N
1650	\N	\N	\N	\N	\N	\N
1651	\N	\N	\N	\N	\N	\N
1652	\N	\N	\N	\N	\N	\N
1653	\N	\N	\N	\N	\N	\N
1654	\N	\N	\N	\N	\N	\N
1655	\N	\N	\N	\N	\N	\N
1656	\N	\N	\N	\N	\N	\N
1657	\N	\N	\N	\N	\N	\N
1658	\N	\N	\N	\N	\N	\N
1659	\N	\N	\N	\N	\N	\N
1660	\N	\N	\N	\N	\N	\N
1661	\N	\N	\N	\N	\N	\N
1662	\N	\N	\N	\N	\N	\N
1663	\N	\N	\N	\N	\N	\N
1664	\N	\N	\N	\N	\N	\N
1665	\N	\N	\N	\N	\N	\N
1666	\N	\N	\N	\N	\N	\N
1667	\N	\N	\N	\N	\N	\N
1668	\N	\N	\N	\N	\N	\N
1669	\N	\N	\N	\N	\N	\N
1670	\N	\N	\N	\N	\N	\N
1671	\N	\N	\N	\N	\N	\N
1672	\N	\N	\N	\N	\N	\N
1673	\N	\N	\N	\N	\N	\N
1674	\N	\N	\N	\N	\N	\N
1675	\N	\N	\N	\N	\N	\N
1676	\N	\N	\N	\N	\N	\N
1677	\N	\N	\N	\N	\N	\N
1678	\N	\N	\N	\N	\N	\N
1679	\N	\N	\N	\N	\N	\N
1680	\N	\N	\N	\N	\N	\N
1681	\N	\N	\N	\N	\N	\N
1682	\N	\N	\N	\N	\N	\N
1683	\N	\N	\N	\N	\N	\N
1684	\N	\N	\N	\N	\N	\N
1685	\N	\N	\N	\N	\N	\N
1686	\N	\N	\N	\N	\N	\N
1687	\N	\N	\N	\N	\N	\N
1688	\N	\N	\N	\N	\N	\N
1689	\N	\N	\N	\N	\N	\N
1690	\N	\N	\N	\N	\N	\N
1691	\N	\N	\N	\N	\N	\N
1692	\N	\N	\N	\N	\N	\N
1693	\N	\N	\N	\N	\N	\N
1694	\N	\N	\N	\N	\N	\N
1695	\N	\N	\N	\N	\N	\N
1696	\N	\N	\N	\N	\N	\N
1697	\N	\N	\N	\N	\N	\N
1698	\N	\N	\N	\N	\N	\N
1699	\N	\N	\N	\N	\N	\N
1700	\N	\N	\N	\N	\N	\N
1701	\N	\N	\N	\N	\N	\N
1702	\N	\N	\N	\N	\N	\N
1703	\N	\N	\N	\N	\N	\N
1704	\N	\N	\N	\N	\N	\N
1705	\N	\N	\N	\N	\N	\N
1706	\N	\N	\N	\N	\N	\N
1707	\N	\N	\N	\N	\N	\N
1708	\N	\N	\N	\N	\N	\N
1709	\N	\N	\N	\N	\N	\N
1710	\N	\N	\N	\N	\N	\N
1711	\N	\N	\N	\N	\N	\N
1712	\N	\N	\N	\N	\N	\N
1713	\N	\N	\N	\N	\N	\N
1714	\N	\N	\N	\N	\N	\N
1715	\N	\N	\N	\N	\N	\N
1716	\N	\N	\N	\N	\N	\N
1717	\N	\N	\N	\N	\N	\N
1718	\N	\N	\N	\N	\N	\N
1719	\N	\N	\N	\N	\N	\N
1720	\N	\N	\N	\N	\N	\N
1721	\N	\N	\N	\N	\N	\N
1722	\N	\N	\N	\N	\N	\N
1723	\N	\N	\N	\N	\N	\N
1724	\N	\N	\N	\N	\N	\N
1725	\N	\N	\N	\N	\N	\N
1726	\N	\N	\N	\N	\N	\N
1727	\N	\N	\N	\N	\N	\N
1728	\N	\N	\N	\N	\N	\N
1729	\N	\N	\N	\N	\N	\N
1730	\N	\N	\N	\N	\N	\N
1731	\N	\N	\N	\N	\N	\N
1732	\N	\N	\N	\N	\N	\N
1733	\N	\N	\N	\N	\N	\N
1734	\N	\N	\N	\N	\N	\N
1735	\N	\N	\N	\N	\N	\N
1736	\N	\N	\N	\N	\N	\N
1737	\N	\N	\N	\N	\N	\N
1738	\N	\N	\N	\N	\N	\N
1739	\N	\N	\N	\N	\N	\N
1740	\N	\N	\N	\N	\N	\N
1741	\N	\N	\N	\N	\N	\N
1742	\N	\N	\N	\N	\N	\N
1743	\N	\N	\N	\N	\N	\N
1744	\N	\N	\N	\N	\N	\N
1745	\N	\N	\N	\N	\N	\N
1746	\N	\N	\N	\N	\N	\N
1747	\N	\N	\N	\N	\N	\N
1748	\N	\N	\N	\N	\N	\N
1749	\N	\N	\N	\N	\N	\N
1750	\N	\N	\N	\N	\N	\N
1751	\N	\N	\N	\N	\N	\N
1752	\N	\N	\N	\N	\N	\N
1753	\N	\N	\N	\N	\N	\N
1754	\N	\N	\N	\N	\N	\N
1755	\N	\N	\N	\N	\N	\N
1756	\N	\N	\N	\N	\N	\N
1757	\N	\N	\N	\N	\N	\N
1758	\N	\N	\N	\N	\N	\N
1759	\N	\N	\N	\N	\N	\N
1760	\N	\N	\N	\N	\N	\N
1761	\N	\N	\N	\N	\N	\N
1762	\N	\N	\N	\N	\N	\N
1763	\N	\N	\N	\N	\N	\N
1764	\N	\N	\N	\N	\N	\N
1765	\N	\N	\N	\N	\N	\N
1766	\N	\N	\N	\N	\N	\N
1767	\N	\N	\N	\N	\N	\N
1768	\N	\N	\N	\N	\N	\N
1769	\N	\N	\N	\N	\N	\N
1770	\N	\N	\N	\N	\N	\N
1771	\N	\N	\N	\N	\N	\N
1772	\N	\N	\N	\N	\N	\N
1773	\N	\N	\N	\N	\N	\N
1774	\N	\N	\N	\N	\N	\N
1775	\N	\N	\N	\N	\N	\N
1776	\N	\N	\N	\N	\N	\N
1777	\N	\N	\N	\N	\N	\N
1778	\N	\N	\N	\N	\N	\N
1779	\N	\N	\N	\N	\N	\N
1780	\N	\N	\N	\N	\N	\N
1781	\N	\N	\N	\N	\N	\N
1782	\N	\N	\N	\N	\N	\N
1783	\N	\N	\N	\N	\N	\N
1784	\N	\N	\N	\N	\N	\N
1785	\N	\N	\N	\N	\N	\N
1786	\N	\N	\N	\N	\N	\N
1787	\N	\N	\N	\N	\N	\N
1788	\N	\N	\N	\N	\N	\N
1789	\N	\N	\N	\N	\N	\N
1790	\N	\N	\N	\N	\N	\N
1791	\N	\N	\N	\N	\N	\N
1792	\N	\N	\N	\N	\N	\N
1793	\N	\N	\N	\N	\N	\N
1794	\N	\N	\N	\N	\N	\N
1795	\N	\N	\N	\N	\N	\N
1796	\N	\N	\N	\N	\N	\N
1797	\N	\N	\N	\N	\N	\N
1798	\N	\N	\N	\N	\N	\N
1799	\N	\N	\N	\N	\N	\N
1800	\N	\N	\N	\N	\N	\N
1801	\N	\N	\N	\N	\N	\N
1802	\N	\N	\N	\N	\N	\N
1803	\N	\N	\N	\N	\N	\N
1804	\N	\N	\N	\N	\N	\N
1805	\N	\N	\N	\N	\N	\N
1806	\N	\N	\N	\N	\N	\N
1807	\N	\N	\N	\N	\N	\N
1808	\N	\N	\N	\N	\N	\N
1809	\N	\N	\N	\N	\N	\N
1810	\N	\N	\N	\N	\N	\N
1811	\N	\N	\N	\N	\N	\N
1812	\N	\N	\N	\N	\N	\N
1813	\N	\N	\N	\N	\N	\N
1814	\N	\N	\N	\N	\N	\N
1815	\N	\N	\N	\N	\N	\N
1816	\N	\N	\N	\N	\N	\N
1817	\N	\N	\N	\N	\N	\N
1818	\N	\N	\N	\N	\N	\N
1819	\N	\N	\N	\N	\N	\N
1820	\N	\N	\N	\N	\N	\N
1821	\N	\N	\N	\N	\N	\N
1822	\N	\N	\N	\N	\N	\N
1823	\N	\N	\N	\N	\N	\N
1824	\N	\N	\N	\N	\N	\N
1825	\N	\N	\N	\N	\N	\N
1826	\N	\N	\N	\N	\N	\N
1827	\N	\N	\N	\N	\N	\N
1828	\N	\N	\N	\N	\N	\N
1829	\N	\N	\N	\N	\N	\N
1830	\N	\N	\N	\N	\N	\N
1831	\N	\N	\N	\N	\N	\N
1832	\N	\N	\N	\N	\N	\N
1833	\N	\N	\N	\N	\N	\N
1834	\N	\N	\N	\N	\N	\N
1835	\N	\N	\N	\N	\N	\N
1836	\N	\N	\N	\N	\N	\N
1837	\N	\N	\N	\N	\N	\N
1838	\N	\N	\N	\N	\N	\N
1839	\N	\N	\N	\N	\N	\N
1840	\N	\N	\N	\N	\N	\N
1841	\N	\N	\N	\N	\N	\N
1842	\N	\N	\N	\N	\N	\N
1843	\N	\N	\N	\N	\N	\N
1844	\N	\N	\N	\N	\N	\N
1845	\N	\N	\N	\N	\N	\N
1846	\N	\N	\N	\N	\N	\N
1847	\N	\N	\N	\N	\N	\N
1848	\N	\N	\N	\N	\N	\N
1849	\N	\N	\N	\N	\N	\N
1850	\N	\N	\N	\N	\N	\N
1851	\N	\N	\N	\N	\N	\N
1852	\N	\N	\N	\N	\N	\N
1853	\N	\N	\N	\N	\N	\N
1854	\N	\N	\N	\N	\N	\N
1855	\N	\N	\N	\N	\N	\N
1856	\N	\N	\N	\N	\N	\N
1857	\N	\N	\N	\N	\N	\N
1858	\N	\N	\N	\N	\N	\N
1859	\N	\N	\N	\N	\N	\N
1860	\N	\N	\N	\N	\N	\N
1861	\N	\N	\N	\N	\N	\N
1862	\N	\N	\N	\N	\N	\N
1863	\N	\N	\N	\N	\N	\N
1864	\N	\N	\N	\N	\N	\N
1865	\N	\N	\N	\N	\N	\N
1866	\N	\N	\N	\N	\N	\N
1867	\N	\N	\N	\N	\N	\N
1868	\N	\N	\N	\N	\N	\N
1869	\N	\N	\N	\N	\N	\N
1870	\N	\N	\N	\N	\N	\N
1871	\N	\N	\N	\N	\N	\N
1872	\N	\N	\N	\N	\N	\N
1873	\N	\N	\N	\N	\N	\N
1874	\N	\N	\N	\N	\N	\N
1875	\N	\N	\N	\N	\N	\N
1876	\N	\N	\N	\N	\N	\N
1877	\N	\N	\N	\N	\N	\N
1878	\N	\N	\N	\N	\N	\N
1879	\N	\N	\N	\N	\N	\N
1880	\N	\N	\N	\N	\N	\N
1881	\N	\N	\N	\N	\N	\N
1882	\N	\N	\N	\N	\N	\N
1883	\N	\N	\N	\N	\N	\N
1884	\N	\N	\N	\N	\N	\N
1885	\N	\N	\N	\N	\N	\N
1886	\N	\N	\N	\N	\N	\N
1887	\N	\N	\N	\N	\N	\N
1888	\N	\N	\N	\N	\N	\N
1889	\N	\N	\N	\N	\N	\N
1890	\N	\N	\N	\N	\N	\N
1891	\N	\N	\N	\N	\N	\N
1892	\N	\N	\N	\N	\N	\N
1893	\N	\N	\N	\N	\N	\N
1894	\N	\N	\N	\N	\N	\N
1895	\N	\N	\N	\N	\N	\N
1896	\N	\N	\N	\N	\N	\N
1897	\N	\N	\N	\N	\N	\N
1898	\N	\N	\N	\N	\N	\N
1899	\N	\N	\N	\N	\N	\N
1900	\N	\N	\N	\N	\N	\N
1901	\N	\N	\N	\N	\N	\N
1902	\N	\N	\N	\N	\N	\N
1903	\N	\N	\N	\N	\N	\N
1904	\N	\N	\N	\N	\N	\N
1905	\N	\N	\N	\N	\N	\N
1906	\N	\N	\N	\N	\N	\N
1907	\N	\N	\N	\N	\N	\N
1908	\N	\N	\N	\N	\N	\N
1909	\N	\N	\N	\N	\N	\N
1910	\N	\N	\N	\N	\N	\N
1911	\N	\N	\N	\N	\N	\N
1912	\N	\N	\N	\N	\N	\N
1913	\N	\N	\N	\N	\N	\N
1914	\N	\N	\N	\N	\N	\N
1915	\N	\N	\N	\N	\N	\N
1916	\N	\N	\N	\N	\N	\N
1917	\N	\N	\N	\N	\N	\N
1918	\N	\N	\N	\N	\N	\N
1919	\N	\N	\N	\N	\N	\N
1920	\N	\N	\N	\N	\N	\N
1921	\N	\N	\N	\N	\N	\N
1922	\N	\N	\N	\N	\N	\N
1923	\N	\N	\N	\N	\N	\N
1924	\N	\N	\N	\N	\N	\N
1925	\N	\N	\N	\N	\N	\N
1926	\N	\N	\N	\N	\N	\N
1927	\N	\N	\N	\N	\N	\N
1928	\N	\N	\N	\N	\N	\N
1929	\N	\N	\N	\N	\N	\N
1930	\N	\N	\N	\N	\N	\N
1931	\N	\N	\N	\N	\N	\N
1932	\N	\N	\N	\N	\N	\N
1933	\N	\N	\N	\N	\N	\N
1934	\N	\N	\N	\N	\N	\N
1935	\N	\N	\N	\N	\N	\N
1936	\N	\N	\N	\N	\N	\N
1937	\N	\N	\N	\N	\N	\N
1938	\N	\N	\N	\N	\N	\N
1939	\N	\N	\N	\N	\N	\N
1940	\N	\N	\N	\N	\N	\N
1941	\N	\N	\N	\N	\N	\N
1942	\N	\N	\N	\N	\N	\N
1943	\N	\N	\N	\N	\N	\N
1944	\N	\N	\N	\N	\N	\N
1945	\N	\N	\N	\N	\N	\N
1946	\N	\N	\N	\N	\N	\N
1947	\N	\N	\N	\N	\N	\N
1948	\N	\N	\N	\N	\N	\N
1949	\N	\N	\N	\N	\N	\N
1950	\N	\N	\N	\N	\N	\N
1951	\N	\N	\N	\N	\N	\N
1952	\N	\N	\N	\N	\N	\N
1953	\N	\N	\N	\N	\N	\N
1954	\N	\N	\N	\N	\N	\N
1955	\N	\N	\N	\N	\N	\N
1956	\N	\N	\N	\N	\N	\N
1957	\N	\N	\N	\N	\N	\N
1958	\N	\N	\N	\N	\N	\N
1959	\N	\N	\N	\N	\N	\N
1960	\N	\N	\N	\N	\N	\N
1961	\N	\N	\N	\N	\N	\N
1962	\N	\N	\N	\N	\N	\N
1963	\N	\N	\N	\N	\N	\N
1964	\N	\N	\N	\N	\N	\N
1965	\N	\N	\N	\N	\N	\N
1966	\N	\N	\N	\N	\N	\N
1967	\N	\N	\N	\N	\N	\N
1968	\N	\N	\N	\N	\N	\N
1969	\N	\N	\N	\N	\N	\N
1970	\N	\N	\N	\N	\N	\N
1971	\N	\N	\N	\N	\N	\N
1972	\N	\N	\N	\N	\N	\N
1973	\N	\N	\N	\N	\N	\N
1974	\N	\N	\N	\N	\N	\N
1975	\N	\N	\N	\N	\N	\N
1976	\N	\N	\N	\N	\N	\N
1977	\N	\N	\N	\N	\N	\N
1978	\N	\N	\N	\N	\N	\N
1979	\N	\N	\N	\N	\N	\N
1980	\N	\N	\N	\N	\N	\N
1981	\N	\N	\N	\N	\N	\N
1982	\N	\N	\N	\N	\N	\N
1983	\N	\N	\N	\N	\N	\N
1984	\N	\N	\N	\N	\N	\N
1985	\N	\N	\N	\N	\N	\N
1986	\N	\N	\N	\N	\N	\N
1987	\N	\N	\N	\N	\N	\N
1988	\N	\N	\N	\N	\N	\N
1989	\N	\N	\N	\N	\N	\N
1990	\N	\N	\N	\N	\N	\N
1991	\N	\N	\N	\N	\N	\N
1992	\N	\N	\N	\N	\N	\N
1993	\N	\N	\N	\N	\N	\N
1994	\N	\N	\N	\N	\N	\N
1995	\N	\N	\N	\N	\N	\N
1996	\N	\N	\N	\N	\N	\N
1997	\N	\N	\N	\N	\N	\N
1998	\N	\N	\N	\N	\N	\N
1999	\N	\N	\N	\N	\N	\N
2000	\N	\N	\N	\N	\N	\N
2001	\N	\N	\N	\N	\N	\N
2002	\N	\N	\N	\N	\N	\N
2003	\N	\N	\N	\N	\N	\N
2004	\N	\N	\N	\N	\N	\N
2005	\N	\N	\N	\N	\N	\N
2006	\N	\N	\N	\N	\N	\N
2007	\N	\N	\N	\N	\N	\N
2008	\N	\N	\N	\N	\N	\N
2009	\N	\N	\N	\N	\N	\N
2010	\N	\N	\N	\N	\N	\N
2011	\N	\N	\N	\N	\N	\N
2012	\N	\N	\N	\N	\N	\N
2013	\N	\N	\N	\N	\N	\N
2014	\N	\N	\N	\N	\N	\N
2015	\N	\N	\N	\N	\N	\N
2016	\N	\N	\N	\N	\N	\N
2017	\N	\N	\N	\N	\N	\N
2018	\N	\N	\N	\N	\N	\N
2019	\N	\N	\N	\N	\N	\N
2020	\N	\N	\N	\N	\N	\N
2021	\N	\N	\N	\N	\N	\N
2022	\N	\N	\N	\N	\N	\N
2023	\N	\N	\N	\N	\N	\N
2024	\N	\N	\N	\N	\N	\N
2025	\N	\N	\N	\N	\N	\N
2026	\N	\N	\N	\N	\N	\N
2027	\N	\N	\N	\N	\N	\N
2028	\N	\N	\N	\N	\N	\N
2029	\N	\N	\N	\N	\N	\N
2030	\N	\N	\N	\N	\N	\N
2031	\N	\N	\N	\N	\N	\N
2032	\N	\N	\N	\N	\N	\N
2033	\N	\N	\N	\N	\N	\N
2034	\N	\N	\N	\N	\N	\N
2035	\N	\N	\N	\N	\N	\N
2036	\N	\N	\N	\N	\N	\N
2037	\N	\N	\N	\N	\N	\N
2038	\N	\N	\N	\N	\N	\N
2039	\N	\N	\N	\N	\N	\N
2040	\N	\N	\N	\N	\N	\N
2041	\N	\N	\N	\N	\N	\N
2042	\N	\N	\N	\N	\N	\N
2043	\N	\N	\N	\N	\N	\N
2044	\N	\N	\N	\N	\N	\N
2045	\N	\N	\N	\N	\N	\N
2046	\N	\N	\N	\N	\N	\N
2047	\N	\N	\N	\N	\N	\N
2048	\N	\N	\N	\N	\N	\N
2049	\N	\N	\N	\N	\N	\N
2050	\N	\N	\N	\N	\N	\N
2051	\N	\N	\N	\N	\N	\N
2052	\N	\N	\N	\N	\N	\N
2053	\N	\N	\N	\N	\N	\N
2054	\N	\N	\N	\N	\N	\N
2055	\N	\N	\N	\N	\N	\N
2056	\N	\N	\N	\N	\N	\N
2057	\N	\N	\N	\N	\N	\N
2058	\N	\N	\N	\N	\N	\N
2059	\N	\N	\N	\N	\N	\N
2060	\N	\N	\N	\N	\N	\N
2061	\N	\N	\N	\N	\N	\N
2062	\N	\N	\N	\N	\N	\N
2063	\N	\N	\N	\N	\N	\N
2064	\N	\N	\N	\N	\N	\N
2065	\N	\N	\N	\N	\N	\N
2066	\N	\N	\N	\N	\N	\N
2067	\N	\N	\N	\N	\N	\N
2068	\N	\N	\N	\N	\N	\N
2069	\N	\N	\N	\N	\N	\N
2070	\N	\N	\N	\N	\N	\N
2071	\N	\N	\N	\N	\N	\N
2072	\N	\N	\N	\N	\N	\N
2073	\N	\N	\N	\N	\N	\N
2074	\N	\N	\N	\N	\N	\N
2075	\N	\N	\N	\N	\N	\N
2076	\N	\N	\N	\N	\N	\N
2077	\N	\N	\N	\N	\N	\N
2078	\N	\N	\N	\N	\N	\N
2079	\N	\N	\N	\N	\N	\N
2080	\N	\N	\N	\N	\N	\N
2081	\N	\N	\N	\N	\N	\N
2082	\N	\N	\N	\N	\N	\N
2083	\N	\N	\N	\N	\N	\N
2084	\N	\N	\N	\N	\N	\N
2085	\N	\N	\N	\N	\N	\N
2086	\N	\N	\N	\N	\N	\N
2087	\N	\N	\N	\N	\N	\N
2088	\N	\N	\N	\N	\N	\N
2089	\N	\N	\N	\N	\N	\N
2090	\N	\N	\N	\N	\N	\N
2091	\N	\N	\N	\N	\N	\N
2092	\N	\N	\N	\N	\N	\N
2093	\N	\N	\N	\N	\N	\N
2094	\N	\N	\N	\N	\N	\N
2095	\N	\N	\N	\N	\N	\N
2096	\N	\N	\N	\N	\N	\N
2097	\N	\N	\N	\N	\N	\N
2098	\N	\N	\N	\N	\N	\N
2099	\N	\N	\N	\N	\N	\N
2100	\N	\N	\N	\N	\N	\N
2101	\N	\N	\N	\N	\N	\N
2102	\N	\N	\N	\N	\N	\N
2103	\N	\N	\N	\N	\N	\N
2104	\N	\N	\N	\N	\N	\N
2105	\N	\N	\N	\N	\N	\N
2106	\N	\N	\N	\N	\N	\N
2107	\N	\N	\N	\N	\N	\N
2108	\N	\N	\N	\N	\N	\N
2109	\N	\N	\N	\N	\N	\N
2110	\N	\N	\N	\N	\N	\N
2111	\N	\N	\N	\N	\N	\N
2112	\N	\N	\N	\N	\N	\N
2113	\N	\N	\N	\N	\N	\N
2114	\N	\N	\N	\N	\N	\N
2115	\N	\N	\N	\N	\N	\N
2116	\N	\N	\N	\N	\N	\N
2117	\N	\N	\N	\N	\N	\N
2118	\N	\N	\N	\N	\N	\N
2119	\N	\N	\N	\N	\N	\N
2120	\N	\N	\N	\N	\N	\N
2121	\N	\N	\N	\N	\N	\N
2122	\N	\N	\N	\N	\N	\N
2123	\N	\N	\N	\N	\N	\N
2124	\N	\N	\N	\N	\N	\N
2125	\N	\N	\N	\N	\N	\N
2126	\N	\N	\N	\N	\N	\N
2127	\N	\N	\N	\N	\N	\N
2128	\N	\N	\N	\N	\N	\N
2129	\N	\N	\N	\N	\N	\N
2130	\N	\N	\N	\N	\N	\N
2131	\N	\N	\N	\N	\N	\N
2132	\N	\N	\N	\N	\N	\N
2133	\N	\N	\N	\N	\N	\N
2134	\N	\N	\N	\N	\N	\N
2135	\N	\N	\N	\N	\N	\N
2136	\N	\N	\N	\N	\N	\N
2137	\N	\N	\N	\N	\N	\N
2138	\N	\N	\N	\N	\N	\N
2139	\N	\N	\N	\N	\N	\N
2140	\N	\N	\N	\N	\N	\N
2141	\N	\N	\N	\N	\N	\N
2142	\N	\N	\N	\N	\N	\N
2143	\N	\N	\N	\N	\N	\N
2144	\N	\N	\N	\N	\N	\N
2145	\N	\N	\N	\N	\N	\N
2146	\N	\N	\N	\N	\N	\N
2147	\N	\N	\N	\N	\N	\N
2148	\N	\N	\N	\N	\N	\N
2149	\N	\N	\N	\N	\N	\N
2150	\N	\N	\N	\N	\N	\N
2151	\N	\N	\N	\N	\N	\N
2152	\N	\N	\N	\N	\N	\N
2153	\N	\N	\N	\N	\N	\N
2154	\N	\N	\N	\N	\N	\N
2155	\N	\N	\N	\N	\N	\N
2156	\N	\N	\N	\N	\N	\N
2157	\N	\N	\N	\N	\N	\N
2158	\N	\N	\N	\N	\N	\N
2159	\N	\N	\N	\N	\N	\N
2160	\N	\N	\N	\N	\N	\N
2161	\N	\N	\N	\N	\N	\N
2162	\N	\N	\N	\N	\N	\N
2163	\N	\N	\N	\N	\N	\N
2164	\N	\N	\N	\N	\N	\N
2165	\N	\N	\N	\N	\N	\N
2166	\N	\N	\N	\N	\N	\N
2167	\N	\N	\N	\N	\N	\N
2168	\N	\N	\N	\N	\N	\N
2169	\N	\N	\N	\N	\N	\N
2170	\N	\N	\N	\N	\N	\N
2171	\N	\N	\N	\N	\N	\N
2172	\N	\N	\N	\N	\N	\N
2173	\N	\N	\N	\N	\N	\N
2174	\N	\N	\N	\N	\N	\N
2175	\N	\N	\N	\N	\N	\N
2176	\N	\N	\N	\N	\N	\N
2177	\N	\N	\N	\N	\N	\N
2178	\N	\N	\N	\N	\N	\N
2179	\N	\N	\N	\N	\N	\N
2180	\N	\N	\N	\N	\N	\N
2181	\N	\N	\N	\N	\N	\N
2182	\N	\N	\N	\N	\N	\N
2183	\N	\N	\N	\N	\N	\N
2184	\N	\N	\N	\N	\N	\N
2185	\N	\N	\N	\N	\N	\N
2186	\N	\N	\N	\N	\N	\N
2187	\N	\N	\N	\N	\N	\N
2188	\N	\N	\N	\N	\N	\N
2189	\N	\N	\N	\N	\N	\N
2190	\N	\N	\N	\N	\N	\N
2191	\N	\N	\N	\N	\N	\N
2192	\N	\N	\N	\N	\N	\N
2193	\N	\N	\N	\N	\N	\N
2194	\N	\N	\N	\N	\N	\N
2195	\N	\N	\N	\N	\N	\N
2196	\N	\N	\N	\N	\N	\N
2197	\N	\N	\N	\N	\N	\N
2198	\N	\N	\N	\N	\N	\N
2199	\N	\N	\N	\N	\N	\N
2200	\N	\N	\N	\N	\N	\N
2201	\N	\N	\N	\N	\N	\N
2202	\N	\N	\N	\N	\N	\N
2203	\N	\N	\N	\N	\N	\N
2204	\N	\N	\N	\N	\N	\N
2205	\N	\N	\N	\N	\N	\N
2206	\N	\N	\N	\N	\N	\N
2207	\N	\N	\N	\N	\N	\N
2208	\N	\N	\N	\N	\N	\N
2209	\N	\N	\N	\N	\N	\N
2210	\N	\N	\N	\N	\N	\N
2211	\N	\N	\N	\N	\N	\N
2212	\N	\N	\N	\N	\N	\N
2213	\N	\N	\N	\N	\N	\N
2214	\N	\N	\N	\N	\N	\N
2215	\N	\N	\N	\N	\N	\N
2216	\N	\N	\N	\N	\N	\N
2217	\N	\N	\N	\N	\N	\N
2218	\N	\N	\N	\N	\N	\N
2219	\N	\N	\N	\N	\N	\N
2220	\N	\N	\N	\N	\N	\N
2221	\N	\N	\N	\N	\N	\N
2222	\N	\N	\N	\N	\N	\N
2223	\N	\N	\N	\N	\N	\N
2224	\N	\N	\N	\N	\N	\N
2225	\N	\N	\N	\N	\N	\N
2226	\N	\N	\N	\N	\N	\N
2227	\N	\N	\N	\N	\N	\N
2228	\N	\N	\N	\N	\N	\N
2229	\N	\N	\N	\N	\N	\N
2230	\N	\N	\N	\N	\N	\N
2231	\N	\N	\N	\N	\N	\N
2232	\N	\N	\N	\N	\N	\N
2233	\N	\N	\N	\N	\N	\N
2234	\N	\N	\N	\N	\N	\N
2235	\N	\N	\N	\N	\N	\N
2236	\N	\N	\N	\N	\N	\N
2237	\N	\N	\N	\N	\N	\N
2238	\N	\N	\N	\N	\N	\N
2239	\N	\N	\N	\N	\N	\N
2240	\N	\N	\N	\N	\N	\N
2241	\N	\N	\N	\N	\N	\N
2242	\N	\N	\N	\N	\N	\N
2243	\N	\N	\N	\N	\N	\N
2244	\N	\N	\N	\N	\N	\N
2245	\N	\N	\N	\N	\N	\N
2246	\N	\N	\N	\N	\N	\N
2247	\N	\N	\N	\N	\N	\N
2248	\N	\N	\N	\N	\N	\N
2249	\N	\N	\N	\N	\N	\N
2250	\N	\N	\N	\N	\N	\N
2251	\N	\N	\N	\N	\N	\N
2252	\N	\N	\N	\N	\N	\N
2253	\N	\N	\N	\N	\N	\N
2254	\N	\N	\N	\N	\N	\N
2255	\N	\N	\N	\N	\N	\N
2256	\N	\N	\N	\N	\N	\N
2257	\N	\N	\N	\N	\N	\N
2258	\N	\N	\N	\N	\N	\N
2259	\N	\N	\N	\N	\N	\N
2260	\N	\N	\N	\N	\N	\N
2261	\N	\N	\N	\N	\N	\N
2262	\N	\N	\N	\N	\N	\N
2263	\N	\N	\N	\N	\N	\N
2264	\N	\N	\N	\N	\N	\N
2265	\N	\N	\N	\N	\N	\N
2266	\N	\N	\N	\N	\N	\N
2267	\N	\N	\N	\N	\N	\N
2268	\N	\N	\N	\N	\N	\N
2269	\N	\N	\N	\N	\N	\N
2270	\N	\N	\N	\N	\N	\N
2271	\N	\N	\N	\N	\N	\N
2272	\N	\N	\N	\N	\N	\N
2273	\N	\N	\N	\N	\N	\N
2274	\N	\N	\N	\N	\N	\N
2275	\N	\N	\N	\N	\N	\N
2276	\N	\N	\N	\N	\N	\N
2277	\N	\N	\N	\N	\N	\N
2278	\N	\N	\N	\N	\N	\N
2279	\N	\N	\N	\N	\N	\N
2280	\N	\N	\N	\N	\N	\N
2281	\N	\N	\N	\N	\N	\N
2282	\N	\N	\N	\N	\N	\N
2283	\N	\N	\N	\N	\N	\N
2284	\N	\N	\N	\N	\N	\N
2285	\N	\N	\N	\N	\N	\N
2286	\N	\N	\N	\N	\N	\N
2287	\N	\N	\N	\N	\N	\N
2288	\N	\N	\N	\N	\N	\N
2289	\N	\N	\N	\N	\N	\N
2290	\N	\N	\N	\N	\N	\N
2291	\N	\N	\N	\N	\N	\N
2292	\N	\N	\N	\N	\N	\N
2293	\N	\N	\N	\N	\N	\N
2294	\N	\N	\N	\N	\N	\N
2295	\N	\N	\N	\N	\N	\N
2296	\N	\N	\N	\N	\N	\N
2297	\N	\N	\N	\N	\N	\N
2298	\N	\N	\N	\N	\N	\N
2299	\N	\N	\N	\N	\N	\N
2300	\N	\N	\N	\N	\N	\N
2301	\N	\N	\N	\N	\N	\N
2302	\N	\N	\N	\N	\N	\N
2303	\N	\N	\N	\N	\N	\N
2304	\N	\N	\N	\N	\N	\N
2305	\N	\N	\N	\N	\N	\N
2306	\N	\N	\N	\N	\N	\N
2307	\N	\N	\N	\N	\N	\N
2308	\N	\N	\N	\N	\N	\N
2309	\N	\N	\N	\N	\N	\N
2310	\N	\N	\N	\N	\N	\N
2311	\N	\N	\N	\N	\N	\N
2312	\N	\N	\N	\N	\N	\N
2313	\N	\N	\N	\N	\N	\N
2314	\N	\N	\N	\N	\N	\N
2315	\N	\N	\N	\N	\N	\N
2316	\N	\N	\N	\N	\N	\N
2317	\N	\N	\N	\N	\N	\N
2318	\N	\N	\N	\N	\N	\N
2319	\N	\N	\N	\N	\N	\N
2320	\N	\N	\N	\N	\N	\N
2321	\N	\N	\N	\N	\N	\N
2322	\N	\N	\N	\N	\N	\N
2323	\N	\N	\N	\N	\N	\N
2324	\N	\N	\N	\N	\N	\N
2325	\N	\N	\N	\N	\N	\N
2326	\N	\N	\N	\N	\N	\N
2327	\N	\N	\N	\N	\N	\N
2328	\N	\N	\N	\N	\N	\N
2329	\N	\N	\N	\N	\N	\N
2330	\N	\N	\N	\N	\N	\N
2331	\N	\N	\N	\N	\N	\N
2332	\N	\N	\N	\N	\N	\N
2333	\N	\N	\N	\N	\N	\N
2334	\N	\N	\N	\N	\N	\N
2335	\N	\N	\N	\N	\N	\N
2336	\N	\N	\N	\N	\N	\N
2337	\N	\N	\N	\N	\N	\N
2338	\N	\N	\N	\N	\N	\N
2339	\N	\N	\N	\N	\N	\N
2340	\N	\N	\N	\N	\N	\N
2341	\N	\N	\N	\N	\N	\N
2342	\N	\N	\N	\N	\N	\N
2343	\N	\N	\N	\N	\N	\N
2344	\N	\N	\N	\N	\N	\N
2345	\N	\N	\N	\N	\N	\N
2346	\N	\N	\N	\N	\N	\N
2347	\N	\N	\N	\N	\N	\N
2348	\N	\N	\N	\N	\N	\N
2349	\N	\N	\N	\N	\N	\N
2350	\N	\N	\N	\N	\N	\N
2351	\N	\N	\N	\N	\N	\N
2352	\N	\N	\N	\N	\N	\N
2353	\N	\N	\N	\N	\N	\N
2354	\N	\N	\N	\N	\N	\N
2355	\N	\N	\N	\N	\N	\N
2356	\N	\N	\N	\N	\N	\N
2357	\N	\N	\N	\N	\N	\N
2358	\N	\N	\N	\N	\N	\N
2359	\N	\N	\N	\N	\N	\N
2360	\N	\N	\N	\N	\N	\N
2361	\N	\N	\N	\N	\N	\N
2362	\N	\N	\N	\N	\N	\N
2363	\N	\N	\N	\N	\N	\N
2364	\N	\N	\N	\N	\N	\N
2365	\N	\N	\N	\N	\N	\N
2366	\N	\N	\N	\N	\N	\N
2367	\N	\N	\N	\N	\N	\N
2368	\N	\N	\N	\N	\N	\N
2369	\N	\N	\N	\N	\N	\N
2370	\N	\N	\N	\N	\N	\N
2371	\N	\N	\N	\N	\N	\N
2372	\N	\N	\N	\N	\N	\N
2373	\N	\N	\N	\N	\N	\N
2374	\N	\N	\N	\N	\N	\N
2375	\N	\N	\N	\N	\N	\N
2376	\N	\N	\N	\N	\N	\N
2377	\N	\N	\N	\N	\N	\N
2378	\N	\N	\N	\N	\N	\N
2379	\N	\N	\N	\N	\N	\N
2380	\N	\N	\N	\N	\N	\N
2381	\N	\N	\N	\N	\N	\N
2382	\N	\N	\N	\N	\N	\N
2383	\N	\N	\N	\N	\N	\N
2384	\N	\N	\N	\N	\N	\N
2385	\N	\N	\N	\N	\N	\N
2386	\N	\N	\N	\N	\N	\N
2387	\N	\N	\N	\N	\N	\N
2388	\N	\N	\N	\N	\N	\N
2389	\N	\N	\N	\N	\N	\N
2390	\N	\N	\N	\N	\N	\N
2391	\N	\N	\N	\N	\N	\N
2392	\N	\N	\N	\N	\N	\N
2393	\N	\N	\N	\N	\N	\N
2394	\N	\N	\N	\N	\N	\N
2395	\N	\N	\N	\N	\N	\N
2396	\N	\N	\N	\N	\N	\N
2397	\N	\N	\N	\N	\N	\N
2398	\N	\N	\N	\N	\N	\N
2399	\N	\N	\N	\N	\N	\N
2400	\N	\N	\N	\N	\N	\N
2401	\N	\N	\N	\N	\N	\N
2402	\N	\N	\N	\N	\N	\N
2403	\N	\N	\N	\N	\N	\N
2404	\N	\N	\N	\N	\N	\N
2405	\N	\N	\N	\N	\N	\N
2406	\N	\N	\N	\N	\N	\N
2407	\N	\N	\N	\N	\N	\N
2408	\N	\N	\N	\N	\N	\N
2409	\N	\N	\N	\N	\N	\N
2410	\N	\N	\N	\N	\N	\N
2411	\N	\N	\N	\N	\N	\N
2412	\N	\N	\N	\N	\N	\N
2413	\N	\N	\N	\N	\N	\N
2414	\N	\N	\N	\N	\N	\N
2415	\N	\N	\N	\N	\N	\N
2416	\N	\N	\N	\N	\N	\N
2417	\N	\N	\N	\N	\N	\N
2418	\N	\N	\N	\N	\N	\N
2419	\N	\N	\N	\N	\N	\N
2420	\N	\N	\N	\N	\N	\N
2421	\N	\N	\N	\N	\N	\N
2422	\N	\N	\N	\N	\N	\N
2423	\N	\N	\N	\N	\N	\N
2424	\N	\N	\N	\N	\N	\N
2425	\N	\N	\N	\N	\N	\N
2426	\N	\N	\N	\N	\N	\N
2427	\N	\N	\N	\N	\N	\N
2428	\N	\N	\N	\N	\N	\N
2429	\N	\N	\N	\N	\N	\N
2430	\N	\N	\N	\N	\N	\N
2431	\N	\N	\N	\N	\N	\N
2432	\N	\N	\N	\N	\N	\N
2433	\N	\N	\N	\N	\N	\N
2434	\N	\N	\N	\N	\N	\N
2435	\N	\N	\N	\N	\N	\N
2436	\N	\N	\N	\N	\N	\N
2437	\N	\N	\N	\N	\N	\N
2438	\N	\N	\N	\N	\N	\N
2439	\N	\N	\N	\N	\N	\N
2440	\N	\N	\N	\N	\N	\N
2441	\N	\N	\N	\N	\N	\N
2442	\N	\N	\N	\N	\N	\N
2443	\N	\N	\N	\N	\N	\N
2444	\N	\N	\N	\N	\N	\N
2445	\N	\N	\N	\N	\N	\N
2446	\N	\N	\N	\N	\N	\N
2447	\N	\N	\N	\N	\N	\N
2448	\N	\N	\N	\N	\N	\N
2449	\N	\N	\N	\N	\N	\N
2450	\N	\N	\N	\N	\N	\N
2451	\N	\N	\N	\N	\N	\N
2452	\N	\N	\N	\N	\N	\N
2453	\N	\N	\N	\N	\N	\N
2454	\N	\N	\N	\N	\N	\N
2455	\N	\N	\N	\N	\N	\N
2456	\N	\N	\N	\N	\N	\N
2457	\N	\N	\N	\N	\N	\N
2458	\N	\N	\N	\N	\N	\N
2459	\N	\N	\N	\N	\N	\N
2460	\N	\N	\N	\N	\N	\N
2461	\N	\N	\N	\N	\N	\N
2462	\N	\N	\N	\N	\N	\N
2463	\N	\N	\N	\N	\N	\N
2464	\N	\N	\N	\N	\N	\N
2465	\N	\N	\N	\N	\N	\N
2466	\N	\N	\N	\N	\N	\N
2467	\N	\N	\N	\N	\N	\N
2468	\N	\N	\N	\N	\N	\N
2469	\N	\N	\N	\N	\N	\N
2470	\N	\N	\N	\N	\N	\N
2471	\N	\N	\N	\N	\N	\N
2472	\N	\N	\N	\N	\N	\N
2473	\N	\N	\N	\N	\N	\N
2474	\N	\N	\N	\N	\N	\N
2475	\N	\N	\N	\N	\N	\N
2476	\N	\N	\N	\N	\N	\N
2477	\N	\N	\N	\N	\N	\N
2478	\N	\N	\N	\N	\N	\N
2479	\N	\N	\N	\N	\N	\N
2480	\N	\N	\N	\N	\N	\N
2481	\N	\N	\N	\N	\N	\N
2482	\N	\N	\N	\N	\N	\N
2483	\N	\N	\N	\N	\N	\N
2484	\N	\N	\N	\N	\N	\N
2485	\N	\N	\N	\N	\N	\N
2486	\N	\N	\N	\N	\N	\N
2487	\N	\N	\N	\N	\N	\N
2488	\N	\N	\N	\N	\N	\N
2489	\N	\N	\N	\N	\N	\N
2490	\N	\N	\N	\N	\N	\N
2491	\N	\N	\N	\N	\N	\N
2492	\N	\N	\N	\N	\N	\N
2493	\N	\N	\N	\N	\N	\N
2494	\N	\N	\N	\N	\N	\N
2495	\N	\N	\N	\N	\N	\N
2496	\N	\N	\N	\N	\N	\N
2497	\N	\N	\N	\N	\N	\N
2498	\N	\N	\N	\N	\N	\N
2499	\N	\N	\N	\N	\N	\N
2500	\N	\N	\N	\N	\N	\N
2501	\N	\N	\N	\N	\N	\N
2502	\N	\N	\N	\N	\N	\N
2503	\N	\N	\N	\N	\N	\N
2504	\N	\N	\N	\N	\N	\N
2505	\N	\N	\N	\N	\N	\N
2506	\N	\N	\N	\N	\N	\N
2507	\N	\N	\N	\N	\N	\N
2508	\N	\N	\N	\N	\N	\N
2509	\N	\N	\N	\N	\N	\N
2510	\N	\N	\N	\N	\N	\N
2511	\N	\N	\N	\N	\N	\N
2512	\N	\N	\N	\N	\N	\N
2513	\N	\N	\N	\N	\N	\N
2514	\N	\N	\N	\N	\N	\N
2515	\N	\N	\N	\N	\N	\N
2516	\N	\N	\N	\N	\N	\N
2517	\N	\N	\N	\N	\N	\N
2518	\N	\N	\N	\N	\N	\N
2519	\N	\N	\N	\N	\N	\N
2520	\N	\N	\N	\N	\N	\N
2521	\N	\N	\N	\N	\N	\N
2522	\N	\N	\N	\N	\N	\N
2523	\N	\N	\N	\N	\N	\N
2524	\N	\N	\N	\N	\N	\N
2525	\N	\N	\N	\N	\N	\N
2526	\N	\N	\N	\N	\N	\N
2527	\N	\N	\N	\N	\N	\N
2528	\N	\N	\N	\N	\N	\N
2529	\N	\N	\N	\N	\N	\N
2530	\N	\N	\N	\N	\N	\N
2531	\N	\N	\N	\N	\N	\N
2532	\N	\N	\N	\N	\N	\N
2533	\N	\N	\N	\N	\N	\N
2534	\N	\N	\N	\N	\N	\N
2535	\N	\N	\N	\N	\N	\N
2536	\N	\N	\N	\N	\N	\N
2537	\N	\N	\N	\N	\N	\N
2538	\N	\N	\N	\N	\N	\N
2539	\N	\N	\N	\N	\N	\N
2540	\N	\N	\N	\N	\N	\N
2541	\N	\N	\N	\N	\N	\N
2542	\N	\N	\N	\N	\N	\N
2543	\N	\N	\N	\N	\N	\N
2544	\N	\N	\N	\N	\N	\N
2545	\N	\N	\N	\N	\N	\N
2546	\N	\N	\N	\N	\N	\N
2547	\N	\N	\N	\N	\N	\N
2548	\N	\N	\N	\N	\N	\N
2549	\N	\N	\N	\N	\N	\N
2550	\N	\N	\N	\N	\N	\N
2551	\N	\N	\N	\N	\N	\N
2552	\N	\N	\N	\N	\N	\N
2553	\N	\N	\N	\N	\N	\N
2554	\N	\N	\N	\N	\N	\N
2555	\N	\N	\N	\N	\N	\N
2556	\N	\N	\N	\N	\N	\N
2557	\N	\N	\N	\N	\N	\N
2558	\N	\N	\N	\N	\N	\N
2559	\N	\N	\N	\N	\N	\N
2560	\N	\N	\N	\N	\N	\N
2561	\N	\N	\N	\N	\N	\N
2562	\N	\N	\N	\N	\N	\N
2563	\N	\N	\N	\N	\N	\N
2564	\N	\N	\N	\N	\N	\N
2565	\N	\N	\N	\N	\N	\N
2566	\N	\N	\N	\N	\N	\N
2567	\N	\N	\N	\N	\N	\N
2568	\N	\N	\N	\N	\N	\N
2569	\N	\N	\N	\N	\N	\N
2570	\N	\N	\N	\N	\N	\N
2571	\N	\N	\N	\N	\N	\N
2572	\N	\N	\N	\N	\N	\N
2573	\N	\N	\N	\N	\N	\N
2574	\N	\N	\N	\N	\N	\N
2575	\N	\N	\N	\N	\N	\N
2576	\N	\N	\N	\N	\N	\N
2577	\N	\N	\N	\N	\N	\N
2578	\N	\N	\N	\N	\N	\N
2579	\N	\N	\N	\N	\N	\N
2580	\N	\N	\N	\N	\N	\N
2581	\N	\N	\N	\N	\N	\N
2582	\N	\N	\N	\N	\N	\N
2583	\N	\N	\N	\N	\N	\N
2584	\N	\N	\N	\N	\N	\N
2585	\N	\N	\N	\N	\N	\N
2586	\N	\N	\N	\N	\N	\N
2587	\N	\N	\N	\N	\N	\N
2588	\N	\N	\N	\N	\N	\N
2589	\N	\N	\N	\N	\N	\N
2590	\N	\N	\N	\N	\N	\N
2591	\N	\N	\N	\N	\N	\N
2592	\N	\N	\N	\N	\N	\N
2593	\N	\N	\N	\N	\N	\N
2594	\N	\N	\N	\N	\N	\N
2595	\N	\N	\N	\N	\N	\N
2596	\N	\N	\N	\N	\N	\N
2597	\N	\N	\N	\N	\N	\N
2598	\N	\N	\N	\N	\N	\N
2599	\N	\N	\N	\N	\N	\N
2600	\N	\N	\N	\N	\N	\N
2601	\N	\N	\N	\N	\N	\N
2602	\N	\N	\N	\N	\N	\N
2603	\N	\N	\N	\N	\N	\N
2604	\N	\N	\N	\N	\N	\N
2605	\N	\N	\N	\N	\N	\N
2606	\N	\N	\N	\N	\N	\N
2607	\N	\N	\N	\N	\N	\N
2608	\N	\N	\N	\N	\N	\N
2609	\N	\N	\N	\N	\N	\N
2610	\N	\N	\N	\N	\N	\N
2611	\N	\N	\N	\N	\N	\N
2612	\N	\N	\N	\N	\N	\N
2613	\N	\N	\N	\N	\N	\N
2614	\N	\N	\N	\N	\N	\N
2615	\N	\N	\N	\N	\N	\N
2616	\N	\N	\N	\N	\N	\N
2617	\N	\N	\N	\N	\N	\N
2618	\N	\N	\N	\N	\N	\N
2619	\N	\N	\N	\N	\N	\N
2620	\N	\N	\N	\N	\N	\N
2621	\N	\N	\N	\N	\N	\N
2622	\N	\N	\N	\N	\N	\N
2623	\N	\N	\N	\N	\N	\N
2624	\N	\N	\N	\N	\N	\N
2625	\N	\N	\N	\N	\N	\N
2626	\N	\N	\N	\N	\N	\N
2627	\N	\N	\N	\N	\N	\N
2628	\N	\N	\N	\N	\N	\N
2629	\N	\N	\N	\N	\N	\N
2630	\N	\N	\N	\N	\N	\N
2631	\N	\N	\N	\N	\N	\N
2632	\N	\N	\N	\N	\N	\N
2633	\N	\N	\N	\N	\N	\N
2634	\N	\N	\N	\N	\N	\N
2635	\N	\N	\N	\N	\N	\N
2636	\N	\N	\N	\N	\N	\N
2637	\N	\N	\N	\N	\N	\N
2638	\N	\N	\N	\N	\N	\N
2639	\N	\N	\N	\N	\N	\N
2640	\N	\N	\N	\N	\N	\N
2641	\N	\N	\N	\N	\N	\N
2642	\N	\N	\N	\N	\N	\N
2643	\N	\N	\N	\N	\N	\N
2644	\N	\N	\N	\N	\N	\N
2645	\N	\N	\N	\N	\N	\N
2646	\N	\N	\N	\N	\N	\N
2647	\N	\N	\N	\N	\N	\N
2648	\N	\N	\N	\N	\N	\N
2649	\N	\N	\N	\N	\N	\N
2650	\N	\N	\N	\N	\N	\N
2651	\N	\N	\N	\N	\N	\N
2652	\N	\N	\N	\N	\N	\N
2653	\N	\N	\N	\N	\N	\N
2654	\N	\N	\N	\N	\N	\N
2655	\N	\N	\N	\N	\N	\N
2656	\N	\N	\N	\N	\N	\N
2657	\N	\N	\N	\N	\N	\N
2658	\N	\N	\N	\N	\N	\N
2659	\N	\N	\N	\N	\N	\N
2660	\N	\N	\N	\N	\N	\N
2661	\N	\N	\N	\N	\N	\N
2662	\N	\N	\N	\N	\N	\N
2663	\N	\N	\N	\N	\N	\N
2664	\N	\N	\N	\N	\N	\N
2665	\N	\N	\N	\N	\N	\N
2666	\N	\N	\N	\N	\N	\N
2667	\N	\N	\N	\N	\N	\N
2668	\N	\N	\N	\N	\N	\N
2669	\N	\N	\N	\N	\N	\N
2670	\N	\N	\N	\N	\N	\N
2671	\N	\N	\N	\N	\N	\N
2672	\N	\N	\N	\N	\N	\N
2673	\N	\N	\N	\N	\N	\N
2674	\N	\N	\N	\N	\N	\N
2675	\N	\N	\N	\N	\N	\N
2676	\N	\N	\N	\N	\N	\N
2677	\N	\N	\N	\N	\N	\N
2678	\N	\N	\N	\N	\N	\N
2679	\N	\N	\N	\N	\N	\N
2680	\N	\N	\N	\N	\N	\N
2681	\N	\N	\N	\N	\N	\N
2682	\N	\N	\N	\N	\N	\N
2683	\N	\N	\N	\N	\N	\N
2684	\N	\N	\N	\N	\N	\N
2685	\N	\N	\N	\N	\N	\N
2686	\N	\N	\N	\N	\N	\N
2687	\N	\N	\N	\N	\N	\N
2688	\N	\N	\N	\N	\N	\N
2689	\N	\N	\N	\N	\N	\N
2690	\N	\N	\N	\N	\N	\N
2691	\N	\N	\N	\N	\N	\N
2692	\N	\N	\N	\N	\N	\N
2693	\N	\N	\N	\N	\N	\N
2694	\N	\N	\N	\N	\N	\N
2695	\N	\N	\N	\N	\N	\N
2696	\N	\N	\N	\N	\N	\N
2697	\N	\N	\N	\N	\N	\N
2698	\N	\N	\N	\N	\N	\N
2699	\N	\N	\N	\N	\N	\N
2700	\N	\N	\N	\N	\N	\N
2701	\N	\N	\N	\N	\N	\N
2702	\N	\N	\N	\N	\N	\N
2703	\N	\N	\N	\N	\N	\N
2704	\N	\N	\N	\N	\N	\N
2705	\N	\N	\N	\N	\N	\N
2706	\N	\N	\N	\N	\N	\N
2707	\N	\N	\N	\N	\N	\N
2708	\N	\N	\N	\N	\N	\N
2709	\N	\N	\N	\N	\N	\N
2710	\N	\N	\N	\N	\N	\N
2711	\N	\N	\N	\N	\N	\N
2712	\N	\N	\N	\N	\N	\N
2713	\N	\N	\N	\N	\N	\N
2714	\N	\N	\N	\N	\N	\N
2715	\N	\N	\N	\N	\N	\N
2716	\N	\N	\N	\N	\N	\N
2717	\N	\N	\N	\N	\N	\N
2718	\N	\N	\N	\N	\N	\N
2719	\N	\N	\N	\N	\N	\N
2720	\N	\N	\N	\N	\N	\N
2721	\N	\N	\N	\N	\N	\N
2722	\N	\N	\N	\N	\N	\N
2723	\N	\N	\N	\N	\N	\N
2724	\N	\N	\N	\N	\N	\N
2725	\N	\N	\N	\N	\N	\N
2726	\N	\N	\N	\N	\N	\N
2727	\N	\N	\N	\N	\N	\N
2728	\N	\N	\N	\N	\N	\N
2729	\N	\N	\N	\N	\N	\N
2730	\N	\N	\N	\N	\N	\N
2731	\N	\N	\N	\N	\N	\N
2732	\N	\N	\N	\N	\N	\N
2733	\N	\N	\N	\N	\N	\N
2734	\N	\N	\N	\N	\N	\N
2735	\N	\N	\N	\N	\N	\N
2736	\N	\N	\N	\N	\N	\N
2737	\N	\N	\N	\N	\N	\N
2738	\N	\N	\N	\N	\N	\N
2739	\N	\N	\N	\N	\N	\N
2740	\N	\N	\N	\N	\N	\N
2741	\N	\N	\N	\N	\N	\N
2742	\N	\N	\N	\N	\N	\N
2743	\N	\N	\N	\N	\N	\N
2744	\N	\N	\N	\N	\N	\N
2745	\N	\N	\N	\N	\N	\N
2746	\N	\N	\N	\N	\N	\N
2747	\N	\N	\N	\N	\N	\N
2748	\N	\N	\N	\N	\N	\N
2749	\N	\N	\N	\N	\N	\N
2750	\N	\N	\N	\N	\N	\N
2751	\N	\N	\N	\N	\N	\N
2752	\N	\N	\N	\N	\N	\N
2753	\N	\N	\N	\N	\N	\N
2754	\N	\N	\N	\N	\N	\N
2755	\N	\N	\N	\N	\N	\N
2756	\N	\N	\N	\N	\N	\N
2757	\N	\N	\N	\N	\N	\N
2758	\N	\N	\N	\N	\N	\N
2759	\N	\N	\N	\N	\N	\N
2760	\N	\N	\N	\N	\N	\N
2761	\N	\N	\N	\N	\N	\N
2762	\N	\N	\N	\N	\N	\N
2763	\N	\N	\N	\N	\N	\N
2764	\N	\N	\N	\N	\N	\N
2765	\N	\N	\N	\N	\N	\N
2766	\N	\N	\N	\N	\N	\N
2767	\N	\N	\N	\N	\N	\N
2768	\N	\N	\N	\N	\N	\N
2769	\N	\N	\N	\N	\N	\N
2770	\N	\N	\N	\N	\N	\N
2771	\N	\N	\N	\N	\N	\N
2772	\N	\N	\N	\N	\N	\N
2773	\N	\N	\N	\N	\N	\N
2774	\N	\N	\N	\N	\N	\N
2775	\N	\N	\N	\N	\N	\N
2776	\N	\N	\N	\N	\N	\N
2777	\N	\N	\N	\N	\N	\N
2778	\N	\N	\N	\N	\N	\N
2779	\N	\N	\N	\N	\N	\N
2780	\N	\N	\N	\N	\N	\N
2781	\N	\N	\N	\N	\N	\N
2782	\N	\N	\N	\N	\N	\N
2783	\N	\N	\N	\N	\N	\N
2784	\N	\N	\N	\N	\N	\N
2785	\N	\N	\N	\N	\N	\N
2786	\N	\N	\N	\N	\N	\N
2787	\N	\N	\N	\N	\N	\N
2788	\N	\N	\N	\N	\N	\N
2789	\N	\N	\N	\N	\N	\N
2790	\N	\N	\N	\N	\N	\N
2791	\N	\N	\N	\N	\N	\N
2792	\N	\N	\N	\N	\N	\N
2793	\N	\N	\N	\N	\N	\N
2794	\N	\N	\N	\N	\N	\N
2795	\N	\N	\N	\N	\N	\N
2796	\N	\N	\N	\N	\N	\N
2797	\N	\N	\N	\N	\N	\N
2798	\N	\N	\N	\N	\N	\N
2799	\N	\N	\N	\N	\N	\N
2800	\N	\N	\N	\N	\N	\N
2801	\N	\N	\N	\N	\N	\N
2802	\N	\N	\N	\N	\N	\N
2803	\N	\N	\N	\N	\N	\N
2804	\N	\N	\N	\N	\N	\N
2805	\N	\N	\N	\N	\N	\N
2806	\N	\N	\N	\N	\N	\N
2807	\N	\N	\N	\N	\N	\N
2808	\N	\N	\N	\N	\N	\N
2809	\N	\N	\N	\N	\N	\N
2810	\N	\N	\N	\N	\N	\N
2811	\N	\N	\N	\N	\N	\N
2812	\N	\N	\N	\N	\N	\N
2813	\N	\N	\N	\N	\N	\N
2814	\N	\N	\N	\N	\N	\N
2815	\N	\N	\N	\N	\N	\N
2816	\N	\N	\N	\N	\N	\N
2817	\N	\N	\N	\N	\N	\N
2818	\N	\N	\N	\N	\N	\N
2819	\N	\N	\N	\N	\N	\N
2820	\N	\N	\N	\N	\N	\N
2821	\N	\N	\N	\N	\N	\N
2822	\N	\N	\N	\N	\N	\N
2823	\N	\N	\N	\N	\N	\N
2824	\N	\N	\N	\N	\N	\N
2825	\N	\N	\N	\N	\N	\N
2826	\N	\N	\N	\N	\N	\N
2827	\N	\N	\N	\N	\N	\N
2828	\N	\N	\N	\N	\N	\N
2829	\N	\N	\N	\N	\N	\N
2830	\N	\N	\N	\N	\N	\N
2831	\N	\N	\N	\N	\N	\N
2832	\N	\N	\N	\N	\N	\N
2833	\N	\N	\N	\N	\N	\N
2834	\N	\N	\N	\N	\N	\N
2835	\N	\N	\N	\N	\N	\N
2836	\N	\N	\N	\N	\N	\N
2837	\N	\N	\N	\N	\N	\N
2838	\N	\N	\N	\N	\N	\N
2839	\N	\N	\N	\N	\N	\N
2840	\N	\N	\N	\N	\N	\N
2841	\N	\N	\N	\N	\N	\N
2842	\N	\N	\N	\N	\N	\N
2843	\N	\N	\N	\N	\N	\N
2844	\N	\N	\N	\N	\N	\N
2845	\N	\N	\N	\N	\N	\N
2846	\N	\N	\N	\N	\N	\N
2847	\N	\N	\N	\N	\N	\N
2848	\N	\N	\N	\N	\N	\N
2849	\N	\N	\N	\N	\N	\N
2850	\N	\N	\N	\N	\N	\N
2851	\N	\N	\N	\N	\N	\N
2852	\N	\N	\N	\N	\N	\N
2853	\N	\N	\N	\N	\N	\N
2854	\N	\N	\N	\N	\N	\N
2855	\N	\N	\N	\N	\N	\N
2856	\N	\N	\N	\N	\N	\N
2857	\N	\N	\N	\N	\N	\N
2858	\N	\N	\N	\N	\N	\N
2859	\N	\N	\N	\N	\N	\N
2860	\N	\N	\N	\N	\N	\N
2861	\N	\N	\N	\N	\N	\N
2862	\N	\N	\N	\N	\N	\N
2863	\N	\N	\N	\N	\N	\N
2864	\N	\N	\N	\N	\N	\N
2865	\N	\N	\N	\N	\N	\N
2866	\N	\N	\N	\N	\N	\N
2867	\N	\N	\N	\N	\N	\N
2868	\N	\N	\N	\N	\N	\N
2869	\N	\N	\N	\N	\N	\N
2870	\N	\N	\N	\N	\N	\N
2871	\N	\N	\N	\N	\N	\N
2872	\N	\N	\N	\N	\N	\N
2873	\N	\N	\N	\N	\N	\N
2874	\N	\N	\N	\N	\N	\N
2875	\N	\N	\N	\N	\N	\N
2876	\N	\N	\N	\N	\N	\N
2877	\N	\N	\N	\N	\N	\N
2878	\N	\N	\N	\N	\N	\N
2879	\N	\N	\N	\N	\N	\N
2880	\N	\N	\N	\N	\N	\N
2881	\N	\N	\N	\N	\N	\N
2882	\N	\N	\N	\N	\N	\N
2883	\N	\N	\N	\N	\N	\N
2884	\N	\N	\N	\N	\N	\N
2885	\N	\N	\N	\N	\N	\N
2886	\N	\N	\N	\N	\N	\N
2887	\N	\N	\N	\N	\N	\N
2888	\N	\N	\N	\N	\N	\N
2889	\N	\N	\N	\N	\N	\N
2890	\N	\N	\N	\N	\N	\N
2891	\N	\N	\N	\N	\N	\N
2892	\N	\N	\N	\N	\N	\N
2893	\N	\N	\N	\N	\N	\N
2894	\N	\N	\N	\N	\N	\N
2895	\N	\N	\N	\N	\N	\N
2896	\N	\N	\N	\N	\N	\N
2897	\N	\N	\N	\N	\N	\N
2898	\N	\N	\N	\N	\N	\N
2899	\N	\N	\N	\N	\N	\N
2900	\N	\N	\N	\N	\N	\N
2901	\N	\N	\N	\N	\N	\N
2902	\N	\N	\N	\N	\N	\N
2903	\N	\N	\N	\N	\N	\N
2904	\N	\N	\N	\N	\N	\N
2905	\N	\N	\N	\N	\N	\N
2906	\N	\N	\N	\N	\N	\N
2907	\N	\N	\N	\N	\N	\N
2908	\N	\N	\N	\N	\N	\N
2909	\N	\N	\N	\N	\N	\N
2910	\N	\N	\N	\N	\N	\N
2911	\N	\N	\N	\N	\N	\N
2912	\N	\N	\N	\N	\N	\N
2913	\N	\N	\N	\N	\N	\N
2914	\N	\N	\N	\N	\N	\N
2915	\N	\N	\N	\N	\N	\N
2916	\N	\N	\N	\N	\N	\N
2917	\N	\N	\N	\N	\N	\N
2918	\N	\N	\N	\N	\N	\N
2919	\N	\N	\N	\N	\N	\N
2920	\N	\N	\N	\N	\N	\N
2921	\N	\N	\N	\N	\N	\N
2922	\N	\N	\N	\N	\N	\N
2923	\N	\N	\N	\N	\N	\N
2924	\N	\N	\N	\N	\N	\N
2925	\N	\N	\N	\N	\N	\N
2926	\N	\N	\N	\N	\N	\N
2927	\N	\N	\N	\N	\N	\N
2928	\N	\N	\N	\N	\N	\N
2929	\N	\N	\N	\N	\N	\N
2930	\N	\N	\N	\N	\N	\N
2931	\N	\N	\N	\N	\N	\N
2932	\N	\N	\N	\N	\N	\N
2933	\N	\N	\N	\N	\N	\N
2934	\N	\N	\N	\N	\N	\N
2935	\N	\N	\N	\N	\N	\N
2936	\N	\N	\N	\N	\N	\N
2937	\N	\N	\N	\N	\N	\N
2938	\N	\N	\N	\N	\N	\N
2939	\N	\N	\N	\N	\N	\N
2940	\N	\N	\N	\N	\N	\N
2941	\N	\N	\N	\N	\N	\N
2942	\N	\N	\N	\N	\N	\N
2943	\N	\N	\N	\N	\N	\N
2944	\N	\N	\N	\N	\N	\N
2945	\N	\N	\N	\N	\N	\N
2946	\N	\N	\N	\N	\N	\N
2947	\N	\N	\N	\N	\N	\N
2948	\N	\N	\N	\N	\N	\N
2949	\N	\N	\N	\N	\N	\N
2950	\N	\N	\N	\N	\N	\N
2951	\N	\N	\N	\N	\N	\N
2952	\N	\N	\N	\N	\N	\N
2953	\N	\N	\N	\N	\N	\N
2954	\N	\N	\N	\N	\N	\N
2955	\N	\N	\N	\N	\N	\N
2956	\N	\N	\N	\N	\N	\N
2957	\N	\N	\N	\N	\N	\N
2958	\N	\N	\N	\N	\N	\N
2959	\N	\N	\N	\N	\N	\N
2960	\N	\N	\N	\N	\N	\N
2961	\N	\N	\N	\N	\N	\N
2962	\N	\N	\N	\N	\N	\N
2963	\N	\N	\N	\N	\N	\N
2964	\N	\N	\N	\N	\N	\N
2965	\N	\N	\N	\N	\N	\N
2966	\N	\N	\N	\N	\N	\N
2967	\N	\N	\N	\N	\N	\N
2968	\N	\N	\N	\N	\N	\N
2969	\N	\N	\N	\N	\N	\N
2970	\N	\N	\N	\N	\N	\N
2971	\N	\N	\N	\N	\N	\N
2972	\N	\N	\N	\N	\N	\N
2973	\N	\N	\N	\N	\N	\N
2974	\N	\N	\N	\N	\N	\N
2975	\N	\N	\N	\N	\N	\N
2976	\N	\N	\N	\N	\N	\N
2977	\N	\N	\N	\N	\N	\N
2978	\N	\N	\N	\N	\N	\N
2979	\N	\N	\N	\N	\N	\N
2980	\N	\N	\N	\N	\N	\N
2981	\N	\N	\N	\N	\N	\N
2982	\N	\N	\N	\N	\N	\N
2983	\N	\N	\N	\N	\N	\N
2984	\N	\N	\N	\N	\N	\N
2985	\N	\N	\N	\N	\N	\N
2986	\N	\N	\N	\N	\N	\N
2987	\N	\N	\N	\N	\N	\N
2988	\N	\N	\N	\N	\N	\N
2989	\N	\N	\N	\N	\N	\N
2990	\N	\N	\N	\N	\N	\N
2991	\N	\N	\N	\N	\N	\N
2992	\N	\N	\N	\N	\N	\N
2993	\N	\N	\N	\N	\N	\N
2994	\N	\N	\N	\N	\N	\N
2995	\N	\N	\N	\N	\N	\N
2996	\N	\N	\N	\N	\N	\N
2997	\N	\N	\N	\N	\N	\N
2998	\N	\N	\N	\N	\N	\N
2999	\N	\N	\N	\N	\N	\N
3000	\N	\N	\N	\N	\N	\N
3001	\N	\N	\N	\N	\N	\N
3002	\N	\N	\N	\N	\N	\N
3003	\N	\N	\N	\N	\N	\N
3004	\N	\N	\N	\N	\N	\N
3005	\N	\N	\N	\N	\N	\N
3006	\N	\N	\N	\N	\N	\N
3007	\N	\N	\N	\N	\N	\N
3008	\N	\N	\N	\N	\N	\N
3009	\N	\N	\N	\N	\N	\N
3010	\N	\N	\N	\N	\N	\N
3011	\N	\N	\N	\N	\N	\N
3012	\N	\N	\N	\N	\N	\N
3013	\N	\N	\N	\N	\N	\N
3014	\N	\N	\N	\N	\N	\N
3015	\N	\N	\N	\N	\N	\N
3016	\N	\N	\N	\N	\N	\N
3017	\N	\N	\N	\N	\N	\N
3018	\N	\N	\N	\N	\N	\N
3019	\N	\N	\N	\N	\N	\N
3020	\N	\N	\N	\N	\N	\N
3021	\N	\N	\N	\N	\N	\N
3022	\N	\N	\N	\N	\N	\N
3023	\N	\N	\N	\N	\N	\N
3024	\N	\N	\N	\N	\N	\N
3025	\N	\N	\N	\N	\N	\N
3026	\N	\N	\N	\N	\N	\N
3027	\N	\N	\N	\N	\N	\N
3028	\N	\N	\N	\N	\N	\N
3029	\N	\N	\N	\N	\N	\N
3030	\N	\N	\N	\N	\N	\N
3031	\N	\N	\N	\N	\N	\N
3032	\N	\N	\N	\N	\N	\N
3033	\N	\N	\N	\N	\N	\N
3034	\N	\N	\N	\N	\N	\N
3035	\N	\N	\N	\N	\N	\N
3036	\N	\N	\N	\N	\N	\N
3037	\N	\N	\N	\N	\N	\N
3038	\N	\N	\N	\N	\N	\N
3039	\N	\N	\N	\N	\N	\N
3040	\N	\N	\N	\N	\N	\N
3041	\N	\N	\N	\N	\N	\N
3042	\N	\N	\N	\N	\N	\N
3043	\N	\N	\N	\N	\N	\N
3044	\N	\N	\N	\N	\N	\N
3045	\N	\N	\N	\N	\N	\N
3046	\N	\N	\N	\N	\N	\N
3047	\N	\N	\N	\N	\N	\N
3048	\N	\N	\N	\N	\N	\N
3049	\N	\N	\N	\N	\N	\N
3050	\N	\N	\N	\N	\N	\N
3051	\N	\N	\N	\N	\N	\N
3052	\N	\N	\N	\N	\N	\N
3053	\N	\N	\N	\N	\N	\N
3054	\N	\N	\N	\N	\N	\N
3055	\N	\N	\N	\N	\N	\N
3056	\N	\N	\N	\N	\N	\N
3057	\N	\N	\N	\N	\N	\N
3058	\N	\N	\N	\N	\N	\N
3059	\N	\N	\N	\N	\N	\N
3060	\N	\N	\N	\N	\N	\N
3061	\N	\N	\N	\N	\N	\N
3062	\N	\N	\N	\N	\N	\N
3063	\N	\N	\N	\N	\N	\N
3064	\N	\N	\N	\N	\N	\N
3065	\N	\N	\N	\N	\N	\N
3066	\N	\N	\N	\N	\N	\N
3067	\N	\N	\N	\N	\N	\N
3068	\N	\N	\N	\N	\N	\N
3069	\N	\N	\N	\N	\N	\N
3070	\N	\N	\N	\N	\N	\N
3071	\N	\N	\N	\N	\N	\N
3072	\N	\N	\N	\N	\N	\N
3073	\N	\N	\N	\N	\N	\N
3074	\N	\N	\N	\N	\N	\N
3075	\N	\N	\N	\N	\N	\N
3076	\N	\N	\N	\N	\N	\N
3077	\N	\N	\N	\N	\N	\N
3078	\N	\N	\N	\N	\N	\N
3079	\N	\N	\N	\N	\N	\N
3080	\N	\N	\N	\N	\N	\N
3081	\N	\N	\N	\N	\N	\N
3082	\N	\N	\N	\N	\N	\N
3083	\N	\N	\N	\N	\N	\N
3084	\N	\N	\N	\N	\N	\N
3085	\N	\N	\N	\N	\N	\N
3086	\N	\N	\N	\N	\N	\N
3087	\N	\N	\N	\N	\N	\N
3088	\N	\N	\N	\N	\N	\N
3089	\N	\N	\N	\N	\N	\N
3090	\N	\N	\N	\N	\N	\N
3091	\N	\N	\N	\N	\N	\N
3092	\N	\N	\N	\N	\N	\N
3093	\N	\N	\N	\N	\N	\N
3094	\N	\N	\N	\N	\N	\N
3095	\N	\N	\N	\N	\N	\N
3096	\N	\N	\N	\N	\N	\N
3097	\N	\N	\N	\N	\N	\N
3098	\N	\N	\N	\N	\N	\N
3099	\N	\N	\N	\N	\N	\N
3100	\N	\N	\N	\N	\N	\N
3101	\N	\N	\N	\N	\N	\N
3102	\N	\N	\N	\N	\N	\N
3103	\N	\N	\N	\N	\N	\N
3104	\N	\N	\N	\N	\N	\N
3105	\N	\N	\N	\N	\N	\N
3106	\N	\N	\N	\N	\N	\N
3107	\N	\N	\N	\N	\N	\N
3108	\N	\N	\N	\N	\N	\N
3109	\N	\N	\N	\N	\N	\N
3110	\N	\N	\N	\N	\N	\N
3111	\N	\N	\N	\N	\N	\N
3112	\N	\N	\N	\N	\N	\N
3113	\N	\N	\N	\N	\N	\N
3114	\N	\N	\N	\N	\N	\N
3115	\N	\N	\N	\N	\N	\N
3116	\N	\N	\N	\N	\N	\N
3117	\N	\N	\N	\N	\N	\N
3118	\N	\N	\N	\N	\N	\N
3119	\N	\N	\N	\N	\N	\N
3120	\N	\N	\N	\N	\N	\N
3121	\N	\N	\N	\N	\N	\N
3122	\N	\N	\N	\N	\N	\N
3123	\N	\N	\N	\N	\N	\N
3124	\N	\N	\N	\N	\N	\N
3125	\N	\N	\N	\N	\N	\N
3126	\N	\N	\N	\N	\N	\N
3127	\N	\N	\N	\N	\N	\N
3128	\N	\N	\N	\N	\N	\N
3129	\N	\N	\N	\N	\N	\N
3130	\N	\N	\N	\N	\N	\N
3131	\N	\N	\N	\N	\N	\N
3132	\N	\N	\N	\N	\N	\N
3133	\N	\N	\N	\N	\N	\N
3134	\N	\N	\N	\N	\N	\N
3135	\N	\N	\N	\N	\N	\N
3136	\N	\N	\N	\N	\N	\N
3137	\N	\N	\N	\N	\N	\N
3138	\N	\N	\N	\N	\N	\N
3139	\N	\N	\N	\N	\N	\N
3140	\N	\N	\N	\N	\N	\N
3141	\N	\N	\N	\N	\N	\N
3142	\N	\N	\N	\N	\N	\N
3143	\N	\N	\N	\N	\N	\N
3144	\N	\N	\N	\N	\N	\N
3145	\N	\N	\N	\N	\N	\N
3146	\N	\N	\N	\N	\N	\N
3147	\N	\N	\N	\N	\N	\N
3148	\N	\N	\N	\N	\N	\N
3149	\N	\N	\N	\N	\N	\N
3150	\N	\N	\N	\N	\N	\N
3151	\N	\N	\N	\N	\N	\N
3152	\N	\N	\N	\N	\N	\N
3153	\N	\N	\N	\N	\N	\N
3154	\N	\N	\N	\N	\N	\N
3155	\N	\N	\N	\N	\N	\N
3156	\N	\N	\N	\N	\N	\N
3157	\N	\N	\N	\N	\N	\N
3158	\N	\N	\N	\N	\N	\N
3159	\N	\N	\N	\N	\N	\N
3160	\N	\N	\N	\N	\N	\N
3161	\N	\N	\N	\N	\N	\N
3162	\N	\N	\N	\N	\N	\N
3163	\N	\N	\N	\N	\N	\N
3164	\N	\N	\N	\N	\N	\N
3165	\N	\N	\N	\N	\N	\N
3166	\N	\N	\N	\N	\N	\N
3167	\N	\N	\N	\N	\N	\N
3168	\N	\N	\N	\N	\N	\N
3169	\N	\N	\N	\N	\N	\N
3170	\N	\N	\N	\N	\N	\N
3171	\N	\N	\N	\N	\N	\N
3172	\N	\N	\N	\N	\N	\N
3173	\N	\N	\N	\N	\N	\N
3174	\N	\N	\N	\N	\N	\N
3175	\N	\N	\N	\N	\N	\N
3176	\N	\N	\N	\N	\N	\N
3177	\N	\N	\N	\N	\N	\N
3178	\N	\N	\N	\N	\N	\N
3179	\N	\N	\N	\N	\N	\N
3180	\N	\N	\N	\N	\N	\N
3181	\N	\N	\N	\N	\N	\N
3182	\N	\N	\N	\N	\N	\N
3183	\N	\N	\N	\N	\N	\N
3184	\N	\N	\N	\N	\N	\N
3185	\N	\N	\N	\N	\N	\N
3186	\N	\N	\N	\N	\N	\N
3187	\N	\N	\N	\N	\N	\N
3188	\N	\N	\N	\N	\N	\N
3189	\N	\N	\N	\N	\N	\N
3190	\N	\N	\N	\N	\N	\N
3191	\N	\N	\N	\N	\N	\N
3192	\N	\N	\N	\N	\N	\N
3193	\N	\N	\N	\N	\N	\N
3194	\N	\N	\N	\N	\N	\N
3195	\N	\N	\N	\N	\N	\N
3196	\N	\N	\N	\N	\N	\N
3197	\N	\N	\N	\N	\N	\N
3198	\N	\N	\N	\N	\N	\N
3199	\N	\N	\N	\N	\N	\N
3200	\N	\N	\N	\N	\N	\N
3201	\N	\N	\N	\N	\N	\N
3202	\N	\N	\N	\N	\N	\N
3203	\N	\N	\N	\N	\N	\N
3204	\N	\N	\N	\N	\N	\N
3205	\N	\N	\N	\N	\N	\N
3206	\N	\N	\N	\N	\N	\N
3207	\N	\N	\N	\N	\N	\N
3208	\N	\N	\N	\N	\N	\N
3209	\N	\N	\N	\N	\N	\N
3210	\N	\N	\N	\N	\N	\N
3211	\N	\N	\N	\N	\N	\N
3212	\N	\N	\N	\N	\N	\N
3213	\N	\N	\N	\N	\N	\N
3214	\N	\N	\N	\N	\N	\N
3215	\N	\N	\N	\N	\N	\N
3216	\N	\N	\N	\N	\N	\N
3217	\N	\N	\N	\N	\N	\N
3218	\N	\N	\N	\N	\N	\N
3219	\N	\N	\N	\N	\N	\N
3220	\N	\N	\N	\N	\N	\N
3221	\N	\N	\N	\N	\N	\N
3222	\N	\N	\N	\N	\N	\N
3223	\N	\N	\N	\N	\N	\N
3224	\N	\N	\N	\N	\N	\N
3225	\N	\N	\N	\N	\N	\N
3226	\N	\N	\N	\N	\N	\N
3227	\N	\N	\N	\N	\N	\N
3228	\N	\N	\N	\N	\N	\N
3229	\N	\N	\N	\N	\N	\N
3230	\N	\N	\N	\N	\N	\N
3231	\N	\N	\N	\N	\N	\N
3232	\N	\N	\N	\N	\N	\N
3233	\N	\N	\N	\N	\N	\N
3234	\N	\N	\N	\N	\N	\N
3235	\N	\N	\N	\N	\N	\N
3236	\N	\N	\N	\N	\N	\N
3237	\N	\N	\N	\N	\N	\N
3238	\N	\N	\N	\N	\N	\N
3239	\N	\N	\N	\N	\N	\N
3240	\N	\N	\N	\N	\N	\N
3241	\N	\N	\N	\N	\N	\N
3242	\N	\N	\N	\N	\N	\N
3243	\N	\N	\N	\N	\N	\N
3244	\N	\N	\N	\N	\N	\N
3245	\N	\N	\N	\N	\N	\N
3246	\N	\N	\N	\N	\N	\N
3247	\N	\N	\N	\N	\N	\N
3248	\N	\N	\N	\N	\N	\N
3249	\N	\N	\N	\N	\N	\N
3250	\N	\N	\N	\N	\N	\N
3251	\N	\N	\N	\N	\N	\N
3252	\N	\N	\N	\N	\N	\N
3253	\N	\N	\N	\N	\N	\N
3254	\N	\N	\N	\N	\N	\N
3255	\N	\N	\N	\N	\N	\N
3256	\N	\N	\N	\N	\N	\N
3257	\N	\N	\N	\N	\N	\N
3258	\N	\N	\N	\N	\N	\N
3259	\N	\N	\N	\N	\N	\N
3260	\N	\N	\N	\N	\N	\N
3261	\N	\N	\N	\N	\N	\N
3262	\N	\N	\N	\N	\N	\N
3263	\N	\N	\N	\N	\N	\N
3264	\N	\N	\N	\N	\N	\N
3265	\N	\N	\N	\N	\N	\N
3266	\N	\N	\N	\N	\N	\N
3267	\N	\N	\N	\N	\N	\N
3268	\N	\N	\N	\N	\N	\N
3269	\N	\N	\N	\N	\N	\N
3270	\N	\N	\N	\N	\N	\N
3271	\N	\N	\N	\N	\N	\N
3272	\N	\N	\N	\N	\N	\N
3273	\N	\N	\N	\N	\N	\N
3274	\N	\N	\N	\N	\N	\N
3275	\N	\N	\N	\N	\N	\N
3276	\N	\N	\N	\N	\N	\N
3277	\N	\N	\N	\N	\N	\N
3278	\N	\N	\N	\N	\N	\N
3279	\N	\N	\N	\N	\N	\N
3280	\N	\N	\N	\N	\N	\N
3281	\N	\N	\N	\N	\N	\N
3282	\N	\N	\N	\N	\N	\N
3283	\N	\N	\N	\N	\N	\N
3284	\N	\N	\N	\N	\N	\N
3285	\N	\N	\N	\N	\N	\N
3286	\N	\N	\N	\N	\N	\N
3287	\N	\N	\N	\N	\N	\N
3288	\N	\N	\N	\N	\N	\N
3289	\N	\N	\N	\N	\N	\N
3290	\N	\N	\N	\N	\N	\N
3291	\N	\N	\N	\N	\N	\N
3292	\N	\N	\N	\N	\N	\N
3293	\N	\N	\N	\N	\N	\N
3294	\N	\N	\N	\N	\N	\N
3295	\N	\N	\N	\N	\N	\N
3296	\N	\N	\N	\N	\N	\N
3297	\N	\N	\N	\N	\N	\N
3298	\N	\N	\N	\N	\N	\N
3299	\N	\N	\N	\N	\N	\N
3300	\N	\N	\N	\N	\N	\N
3301	\N	\N	\N	\N	\N	\N
3302	\N	\N	\N	\N	\N	\N
3303	\N	\N	\N	\N	\N	\N
3304	\N	\N	\N	\N	\N	\N
3305	\N	\N	\N	\N	\N	\N
3306	\N	\N	\N	\N	\N	\N
3307	\N	\N	\N	\N	\N	\N
3308	\N	\N	\N	\N	\N	\N
3309	\N	\N	\N	\N	\N	\N
3310	\N	\N	\N	\N	\N	\N
3311	\N	\N	\N	\N	\N	\N
3312	\N	\N	\N	\N	\N	\N
3313	\N	\N	\N	\N	\N	\N
3314	\N	\N	\N	\N	\N	\N
3315	\N	\N	\N	\N	\N	\N
3316	\N	\N	\N	\N	\N	\N
3317	\N	\N	\N	\N	\N	\N
3318	\N	\N	\N	\N	\N	\N
3319	\N	\N	\N	\N	\N	\N
3320	\N	\N	\N	\N	\N	\N
3321	\N	\N	\N	\N	\N	\N
3322	\N	\N	\N	\N	\N	\N
3323	\N	\N	\N	\N	\N	\N
3324	\N	\N	\N	\N	\N	\N
3325	\N	\N	\N	\N	\N	\N
3326	\N	\N	\N	\N	\N	\N
3327	\N	\N	\N	\N	\N	\N
3328	\N	\N	\N	\N	\N	\N
3329	\N	\N	\N	\N	\N	\N
3330	\N	\N	\N	\N	\N	\N
3331	\N	\N	\N	\N	\N	\N
3332	\N	\N	\N	\N	\N	\N
3333	\N	\N	\N	\N	\N	\N
3334	\N	\N	\N	\N	\N	\N
3335	\N	\N	\N	\N	\N	\N
3336	\N	\N	\N	\N	\N	\N
3337	\N	\N	\N	\N	\N	\N
3338	\N	\N	\N	\N	\N	\N
3339	\N	\N	\N	\N	\N	\N
3340	\N	\N	\N	\N	\N	\N
3341	\N	\N	\N	\N	\N	\N
3342	\N	\N	\N	\N	\N	\N
3343	\N	\N	\N	\N	\N	\N
3344	\N	\N	\N	\N	\N	\N
3345	\N	\N	\N	\N	\N	\N
3346	\N	\N	\N	\N	\N	\N
3347	\N	\N	\N	\N	\N	\N
3348	\N	\N	\N	\N	\N	\N
3349	\N	\N	\N	\N	\N	\N
3350	\N	\N	\N	\N	\N	\N
3351	\N	\N	\N	\N	\N	\N
3352	\N	\N	\N	\N	\N	\N
3353	\N	\N	\N	\N	\N	\N
3354	\N	\N	\N	\N	\N	\N
3355	\N	\N	\N	\N	\N	\N
3356	\N	\N	\N	\N	\N	\N
3357	\N	\N	\N	\N	\N	\N
3358	\N	\N	\N	\N	\N	\N
3359	\N	\N	\N	\N	\N	\N
3360	\N	\N	\N	\N	\N	\N
3361	\N	\N	\N	\N	\N	\N
3362	\N	\N	\N	\N	\N	\N
3363	\N	\N	\N	\N	\N	\N
3364	\N	\N	\N	\N	\N	\N
3365	\N	\N	\N	\N	\N	\N
3366	\N	\N	\N	\N	\N	\N
3367	\N	\N	\N	\N	\N	\N
3368	\N	\N	\N	\N	\N	\N
3369	\N	\N	\N	\N	\N	\N
3370	\N	\N	\N	\N	\N	\N
3371	\N	\N	\N	\N	\N	\N
3372	\N	\N	\N	\N	\N	\N
3373	\N	\N	\N	\N	\N	\N
3374	\N	\N	\N	\N	\N	\N
3375	\N	\N	\N	\N	\N	\N
3376	\N	\N	\N	\N	\N	\N
3377	\N	\N	\N	\N	\N	\N
3378	\N	\N	\N	\N	\N	\N
3379	\N	\N	\N	\N	\N	\N
3380	\N	\N	\N	\N	\N	\N
3381	\N	\N	\N	\N	\N	\N
3382	\N	\N	\N	\N	\N	\N
3383	\N	\N	\N	\N	\N	\N
3384	\N	\N	\N	\N	\N	\N
3385	\N	\N	\N	\N	\N	\N
3386	\N	\N	\N	\N	\N	\N
3387	\N	\N	\N	\N	\N	\N
3388	\N	\N	\N	\N	\N	\N
3389	\N	\N	\N	\N	\N	\N
3390	\N	\N	\N	\N	\N	\N
3391	\N	\N	\N	\N	\N	\N
3392	\N	\N	\N	\N	\N	\N
3393	\N	\N	\N	\N	\N	\N
3394	\N	\N	\N	\N	\N	\N
3395	\N	\N	\N	\N	\N	\N
3396	\N	\N	\N	\N	\N	\N
3397	\N	\N	\N	\N	\N	\N
3398	\N	\N	\N	\N	\N	\N
3399	\N	\N	\N	\N	\N	\N
3400	\N	\N	\N	\N	\N	\N
3401	\N	\N	\N	\N	\N	\N
3402	\N	\N	\N	\N	\N	\N
3403	\N	\N	\N	\N	\N	\N
3404	\N	\N	\N	\N	\N	\N
3405	\N	\N	\N	\N	\N	\N
3406	\N	\N	\N	\N	\N	\N
3407	\N	\N	\N	\N	\N	\N
3408	\N	\N	\N	\N	\N	\N
3409	\N	\N	\N	\N	\N	\N
3410	\N	\N	\N	\N	\N	\N
3411	\N	\N	\N	\N	\N	\N
3412	\N	\N	\N	\N	\N	\N
3413	\N	\N	\N	\N	\N	\N
3414	\N	\N	\N	\N	\N	\N
3415	\N	\N	\N	\N	\N	\N
3416	\N	\N	\N	\N	\N	\N
3417	\N	\N	\N	\N	\N	\N
3418	\N	\N	\N	\N	\N	\N
3419	\N	\N	\N	\N	\N	\N
3420	\N	\N	\N	\N	\N	\N
3421	\N	\N	\N	\N	\N	\N
3422	\N	\N	\N	\N	\N	\N
3423	\N	\N	\N	\N	\N	\N
3424	\N	\N	\N	\N	\N	\N
3425	\N	\N	\N	\N	\N	\N
3426	\N	\N	\N	\N	\N	\N
3427	\N	\N	\N	\N	\N	\N
3428	\N	\N	\N	\N	\N	\N
3429	\N	\N	\N	\N	\N	\N
3430	\N	\N	\N	\N	\N	\N
3431	\N	\N	\N	\N	\N	\N
3432	\N	\N	\N	\N	\N	\N
3433	\N	\N	\N	\N	\N	\N
3434	\N	\N	\N	\N	\N	\N
3435	\N	\N	\N	\N	\N	\N
3436	\N	\N	\N	\N	\N	\N
3437	\N	\N	\N	\N	\N	\N
3438	\N	\N	\N	\N	\N	\N
3439	\N	\N	\N	\N	\N	\N
3440	\N	\N	\N	\N	\N	\N
3441	\N	\N	\N	\N	\N	\N
3442	\N	\N	\N	\N	\N	\N
3443	\N	\N	\N	\N	\N	\N
3444	\N	\N	\N	\N	\N	\N
3445	\N	\N	\N	\N	\N	\N
3446	\N	\N	\N	\N	\N	\N
3447	\N	\N	\N	\N	\N	\N
3448	\N	\N	\N	\N	\N	\N
3449	\N	\N	\N	\N	\N	\N
3450	\N	\N	\N	\N	\N	\N
3451	\N	\N	\N	\N	\N	\N
3452	\N	\N	\N	\N	\N	\N
3453	\N	\N	\N	\N	\N	\N
3454	\N	\N	\N	\N	\N	\N
3455	\N	\N	\N	\N	\N	\N
3456	\N	\N	\N	\N	\N	\N
3457	\N	\N	\N	\N	\N	\N
3458	\N	\N	\N	\N	\N	\N
3459	\N	\N	\N	\N	\N	\N
3460	\N	\N	\N	\N	\N	\N
3461	\N	\N	\N	\N	\N	\N
3462	\N	\N	\N	\N	\N	\N
3463	\N	\N	\N	\N	\N	\N
3464	\N	\N	\N	\N	\N	\N
3465	\N	\N	\N	\N	\N	\N
3466	\N	\N	\N	\N	\N	\N
3467	\N	\N	\N	\N	\N	\N
3468	\N	\N	\N	\N	\N	\N
3469	\N	\N	\N	\N	\N	\N
3470	\N	\N	\N	\N	\N	\N
3471	\N	\N	\N	\N	\N	\N
3472	\N	\N	\N	\N	\N	\N
3473	\N	\N	\N	\N	\N	\N
3474	\N	\N	\N	\N	\N	\N
3475	\N	\N	\N	\N	\N	\N
3476	\N	\N	\N	\N	\N	\N
3477	\N	\N	\N	\N	\N	\N
3478	\N	\N	\N	\N	\N	\N
3479	\N	\N	\N	\N	\N	\N
3480	\N	\N	\N	\N	\N	\N
3481	\N	\N	\N	\N	\N	\N
3482	\N	\N	\N	\N	\N	\N
3483	\N	\N	\N	\N	\N	\N
3484	\N	\N	\N	\N	\N	\N
3485	\N	\N	\N	\N	\N	\N
3486	\N	\N	\N	\N	\N	\N
3487	\N	\N	\N	\N	\N	\N
3488	\N	\N	\N	\N	\N	\N
3489	\N	\N	\N	\N	\N	\N
3490	\N	\N	\N	\N	\N	\N
3491	\N	\N	\N	\N	\N	\N
3492	\N	\N	\N	\N	\N	\N
3493	\N	\N	\N	\N	\N	\N
3494	\N	\N	\N	\N	\N	\N
3495	\N	\N	\N	\N	\N	\N
3496	\N	\N	\N	\N	\N	\N
3497	\N	\N	\N	\N	\N	\N
3498	\N	\N	\N	\N	\N	\N
3499	\N	\N	\N	\N	\N	\N
3500	\N	\N	\N	\N	\N	\N
3501	\N	\N	\N	\N	\N	\N
3502	\N	\N	\N	\N	\N	\N
3503	\N	\N	\N	\N	\N	\N
3504	\N	\N	\N	\N	\N	\N
3505	\N	\N	\N	\N	\N	\N
3506	\N	\N	\N	\N	\N	\N
3507	\N	\N	\N	\N	\N	\N
3508	\N	\N	\N	\N	\N	\N
3509	\N	\N	\N	\N	\N	\N
3510	\N	\N	\N	\N	\N	\N
3511	\N	\N	\N	\N	\N	\N
3512	\N	\N	\N	\N	\N	\N
3513	\N	\N	\N	\N	\N	\N
3514	\N	\N	\N	\N	\N	\N
3515	\N	\N	\N	\N	\N	\N
3516	\N	\N	\N	\N	\N	\N
3517	\N	\N	\N	\N	\N	\N
3518	\N	\N	\N	\N	\N	\N
3519	\N	\N	\N	\N	\N	\N
3520	\N	\N	\N	\N	\N	\N
3521	\N	\N	\N	\N	\N	\N
3522	\N	\N	\N	\N	\N	\N
3523	\N	\N	\N	\N	\N	\N
3524	\N	\N	\N	\N	\N	\N
3525	\N	\N	\N	\N	\N	\N
3526	\N	\N	\N	\N	\N	\N
3527	\N	\N	\N	\N	\N	\N
3528	\N	\N	\N	\N	\N	\N
3529	\N	\N	\N	\N	\N	\N
3530	\N	\N	\N	\N	\N	\N
3531	\N	\N	\N	\N	\N	\N
3532	\N	\N	\N	\N	\N	\N
3533	\N	\N	\N	\N	\N	\N
3534	\N	\N	\N	\N	\N	\N
3535	\N	\N	\N	\N	\N	\N
3536	\N	\N	\N	\N	\N	\N
3537	\N	\N	\N	\N	\N	\N
3538	\N	\N	\N	\N	\N	\N
3539	\N	\N	\N	\N	\N	\N
3540	\N	\N	\N	\N	\N	\N
3541	\N	\N	\N	\N	\N	\N
3542	\N	\N	\N	\N	\N	\N
3543	\N	\N	\N	\N	\N	\N
3544	\N	\N	\N	\N	\N	\N
3545	\N	\N	\N	\N	\N	\N
3546	\N	\N	\N	\N	\N	\N
3547	\N	\N	\N	\N	\N	\N
3548	\N	\N	\N	\N	\N	\N
3549	\N	\N	\N	\N	\N	\N
3550	\N	\N	\N	\N	\N	\N
3551	\N	\N	\N	\N	\N	\N
3552	\N	\N	\N	\N	\N	\N
3553	\N	\N	\N	\N	\N	\N
3554	\N	\N	\N	\N	\N	\N
3555	\N	\N	\N	\N	\N	\N
3556	\N	\N	\N	\N	\N	\N
3557	\N	\N	\N	\N	\N	\N
3558	\N	\N	\N	\N	\N	\N
3559	\N	\N	\N	\N	\N	\N
3560	\N	\N	\N	\N	\N	\N
3561	\N	\N	\N	\N	\N	\N
3562	\N	\N	\N	\N	\N	\N
3563	\N	\N	\N	\N	\N	\N
3564	\N	\N	\N	\N	\N	\N
3565	\N	\N	\N	\N	\N	\N
3566	\N	\N	\N	\N	\N	\N
3567	\N	\N	\N	\N	\N	\N
3568	\N	\N	\N	\N	\N	\N
3569	\N	\N	\N	\N	\N	\N
3570	\N	\N	\N	\N	\N	\N
3571	\N	\N	\N	\N	\N	\N
3572	\N	\N	\N	\N	\N	\N
3573	\N	\N	\N	\N	\N	\N
3574	\N	\N	\N	\N	\N	\N
3575	\N	\N	\N	\N	\N	\N
3576	\N	\N	\N	\N	\N	\N
3577	\N	\N	\N	\N	\N	\N
3578	\N	\N	\N	\N	\N	\N
3579	\N	\N	\N	\N	\N	\N
3580	\N	\N	\N	\N	\N	\N
3581	\N	\N	\N	\N	\N	\N
3582	\N	\N	\N	\N	\N	\N
3583	\N	\N	\N	\N	\N	\N
3584	\N	\N	\N	\N	\N	\N
3585	\N	\N	\N	\N	\N	\N
3586	\N	\N	\N	\N	\N	\N
3587	\N	\N	\N	\N	\N	\N
3588	\N	\N	\N	\N	\N	\N
3589	\N	\N	\N	\N	\N	\N
3590	\N	\N	\N	\N	\N	\N
3591	\N	\N	\N	\N	\N	\N
3592	\N	\N	\N	\N	\N	\N
3593	\N	\N	\N	\N	\N	\N
3594	\N	\N	\N	\N	\N	\N
3595	\N	\N	\N	\N	\N	\N
3596	\N	\N	\N	\N	\N	\N
3597	\N	\N	\N	\N	\N	\N
3598	\N	\N	\N	\N	\N	\N
3599	\N	\N	\N	\N	\N	\N
3600	\N	\N	\N	\N	\N	\N
3601	\N	\N	\N	\N	\N	\N
3602	\N	\N	\N	\N	\N	\N
3603	\N	\N	\N	\N	\N	\N
3604	\N	\N	\N	\N	\N	\N
3605	\N	\N	\N	\N	\N	\N
3606	\N	\N	\N	\N	\N	\N
3607	\N	\N	\N	\N	\N	\N
3608	\N	\N	\N	\N	\N	\N
3609	\N	\N	\N	\N	\N	\N
3610	\N	\N	\N	\N	\N	\N
3611	\N	\N	\N	\N	\N	\N
3612	\N	\N	\N	\N	\N	\N
3613	\N	\N	\N	\N	\N	\N
3614	\N	\N	\N	\N	\N	\N
3615	\N	\N	\N	\N	\N	\N
3616	\N	\N	\N	\N	\N	\N
3617	\N	\N	\N	\N	\N	\N
3618	\N	\N	\N	\N	\N	\N
3619	\N	\N	\N	\N	\N	\N
3620	\N	\N	\N	\N	\N	\N
3621	\N	\N	\N	\N	\N	\N
3622	\N	\N	\N	\N	\N	\N
3623	\N	\N	\N	\N	\N	\N
3624	\N	\N	\N	\N	\N	\N
3625	\N	\N	\N	\N	\N	\N
3626	\N	\N	\N	\N	\N	\N
3627	\N	\N	\N	\N	\N	\N
3628	\N	\N	\N	\N	\N	\N
3629	\N	\N	\N	\N	\N	\N
3630	\N	\N	\N	\N	\N	\N
3631	\N	\N	\N	\N	\N	\N
3632	\N	\N	\N	\N	\N	\N
3633	\N	\N	\N	\N	\N	\N
3634	\N	\N	\N	\N	\N	\N
3635	\N	\N	\N	\N	\N	\N
3636	\N	\N	\N	\N	\N	\N
3637	\N	\N	\N	\N	\N	\N
3638	\N	\N	\N	\N	\N	\N
3639	\N	\N	\N	\N	\N	\N
3640	\N	\N	\N	\N	\N	\N
3641	\N	\N	\N	\N	\N	\N
3642	\N	\N	\N	\N	\N	\N
3643	\N	\N	\N	\N	\N	\N
3644	\N	\N	\N	\N	\N	\N
3645	\N	\N	\N	\N	\N	\N
3646	\N	\N	\N	\N	\N	\N
3647	\N	\N	\N	\N	\N	\N
3648	\N	\N	\N	\N	\N	\N
3649	\N	\N	\N	\N	\N	\N
3650	\N	\N	\N	\N	\N	\N
3651	\N	\N	\N	\N	\N	\N
3652	\N	\N	\N	\N	\N	\N
3653	\N	\N	\N	\N	\N	\N
3654	\N	\N	\N	\N	\N	\N
3655	\N	\N	\N	\N	\N	\N
3656	\N	\N	\N	\N	\N	\N
3657	\N	\N	\N	\N	\N	\N
3658	\N	\N	\N	\N	\N	\N
3659	\N	\N	\N	\N	\N	\N
3660	\N	\N	\N	\N	\N	\N
3661	\N	\N	\N	\N	\N	\N
3662	\N	\N	\N	\N	\N	\N
3663	\N	\N	\N	\N	\N	\N
3664	\N	\N	\N	\N	\N	\N
3665	\N	\N	\N	\N	\N	\N
3666	\N	\N	\N	\N	\N	\N
3667	\N	\N	\N	\N	\N	\N
3668	\N	\N	\N	\N	\N	\N
3669	\N	\N	\N	\N	\N	\N
3670	\N	\N	\N	\N	\N	\N
3671	\N	\N	\N	\N	\N	\N
3672	\N	\N	\N	\N	\N	\N
3673	\N	\N	\N	\N	\N	\N
3674	\N	\N	\N	\N	\N	\N
3675	\N	\N	\N	\N	\N	\N
3676	\N	\N	\N	\N	\N	\N
3677	\N	\N	\N	\N	\N	\N
3678	\N	\N	\N	\N	\N	\N
3679	\N	\N	\N	\N	\N	\N
3680	\N	\N	\N	\N	\N	\N
3681	\N	\N	\N	\N	\N	\N
3682	\N	\N	\N	\N	\N	\N
3683	\N	\N	\N	\N	\N	\N
3684	\N	\N	\N	\N	\N	\N
3685	\N	\N	\N	\N	\N	\N
3686	\N	\N	\N	\N	\N	\N
3687	\N	\N	\N	\N	\N	\N
3688	\N	\N	\N	\N	\N	\N
3689	\N	\N	\N	\N	\N	\N
3690	\N	\N	\N	\N	\N	\N
3691	\N	\N	\N	\N	\N	\N
3692	\N	\N	\N	\N	\N	\N
3693	\N	\N	\N	\N	\N	\N
3694	\N	\N	\N	\N	\N	\N
3695	\N	\N	\N	\N	\N	\N
3696	\N	\N	\N	\N	\N	\N
3697	\N	\N	\N	\N	\N	\N
3698	\N	\N	\N	\N	\N	\N
3699	\N	\N	\N	\N	\N	\N
3700	\N	\N	\N	\N	\N	\N
3701	\N	\N	\N	\N	\N	\N
3702	\N	\N	\N	\N	\N	\N
3703	\N	\N	\N	\N	\N	\N
3704	\N	\N	\N	\N	\N	\N
3705	\N	\N	\N	\N	\N	\N
3706	\N	\N	\N	\N	\N	\N
3707	\N	\N	\N	\N	\N	\N
3708	\N	\N	\N	\N	\N	\N
3709	\N	\N	\N	\N	\N	\N
3710	\N	\N	\N	\N	\N	\N
3711	\N	\N	\N	\N	\N	\N
3712	\N	\N	\N	\N	\N	\N
3713	\N	\N	\N	\N	\N	\N
3714	\N	\N	\N	\N	\N	\N
3715	\N	\N	\N	\N	\N	\N
3716	\N	\N	\N	\N	\N	\N
3717	\N	\N	\N	\N	\N	\N
3718	\N	\N	\N	\N	\N	\N
3719	\N	\N	\N	\N	\N	\N
3720	\N	\N	\N	\N	\N	\N
3721	\N	\N	\N	\N	\N	\N
3722	\N	\N	\N	\N	\N	\N
3723	\N	\N	\N	\N	\N	\N
3724	\N	\N	\N	\N	\N	\N
3725	\N	\N	\N	\N	\N	\N
3726	\N	\N	\N	\N	\N	\N
3727	\N	\N	\N	\N	\N	\N
3728	\N	\N	\N	\N	\N	\N
3729	\N	\N	\N	\N	\N	\N
3730	\N	\N	\N	\N	\N	\N
3731	\N	\N	\N	\N	\N	\N
3732	\N	\N	\N	\N	\N	\N
3733	\N	\N	\N	\N	\N	\N
3734	\N	\N	\N	\N	\N	\N
3735	\N	\N	\N	\N	\N	\N
3736	\N	\N	\N	\N	\N	\N
3737	\N	\N	\N	\N	\N	\N
3738	\N	\N	\N	\N	\N	\N
3739	\N	\N	\N	\N	\N	\N
3740	\N	\N	\N	\N	\N	\N
3741	\N	\N	\N	\N	\N	\N
3742	\N	\N	\N	\N	\N	\N
3743	\N	\N	\N	\N	\N	\N
3744	\N	\N	\N	\N	\N	\N
3745	\N	\N	\N	\N	\N	\N
3746	\N	\N	\N	\N	\N	\N
3747	\N	\N	\N	\N	\N	\N
3748	\N	\N	\N	\N	\N	\N
3749	\N	\N	\N	\N	\N	\N
3750	\N	\N	\N	\N	\N	\N
3751	\N	\N	\N	\N	\N	\N
3752	\N	\N	\N	\N	\N	\N
3753	\N	\N	\N	\N	\N	\N
3754	\N	\N	\N	\N	\N	\N
3755	\N	\N	\N	\N	\N	\N
3756	\N	\N	\N	\N	\N	\N
3757	\N	\N	\N	\N	\N	\N
3758	\N	\N	\N	\N	\N	\N
3759	\N	\N	\N	\N	\N	\N
3760	\N	\N	\N	\N	\N	\N
3761	\N	\N	\N	\N	\N	\N
3762	\N	\N	\N	\N	\N	\N
3763	\N	\N	\N	\N	\N	\N
3764	\N	\N	\N	\N	\N	\N
3765	\N	\N	\N	\N	\N	\N
3766	\N	\N	\N	\N	\N	\N
3767	\N	\N	\N	\N	\N	\N
3768	\N	\N	\N	\N	\N	\N
3769	\N	\N	\N	\N	\N	\N
3770	\N	\N	\N	\N	\N	\N
3771	\N	\N	\N	\N	\N	\N
3772	\N	\N	\N	\N	\N	\N
3773	\N	\N	\N	\N	\N	\N
3774	\N	\N	\N	\N	\N	\N
3775	\N	\N	\N	\N	\N	\N
3776	\N	\N	\N	\N	\N	\N
3777	\N	\N	\N	\N	\N	\N
3778	\N	\N	\N	\N	\N	\N
3779	\N	\N	\N	\N	\N	\N
3780	\N	\N	\N	\N	\N	\N
3781	\N	\N	\N	\N	\N	\N
3782	\N	\N	\N	\N	\N	\N
3783	\N	\N	\N	\N	\N	\N
3784	\N	\N	\N	\N	\N	\N
3785	\N	\N	\N	\N	\N	\N
3786	\N	\N	\N	\N	\N	\N
3787	\N	\N	\N	\N	\N	\N
3788	\N	\N	\N	\N	\N	\N
3789	\N	\N	\N	\N	\N	\N
3790	\N	\N	\N	\N	\N	\N
3791	\N	\N	\N	\N	\N	\N
3792	\N	\N	\N	\N	\N	\N
3793	\N	\N	\N	\N	\N	\N
3794	\N	\N	\N	\N	\N	\N
3795	\N	\N	\N	\N	\N	\N
3796	\N	\N	\N	\N	\N	\N
3797	\N	\N	\N	\N	\N	\N
3798	\N	\N	\N	\N	\N	\N
3799	\N	\N	\N	\N	\N	\N
3800	\N	\N	\N	\N	\N	\N
3801	\N	\N	\N	\N	\N	\N
3802	\N	\N	\N	\N	\N	\N
3803	\N	\N	\N	\N	\N	\N
3804	\N	\N	\N	\N	\N	\N
3805	\N	\N	\N	\N	\N	\N
3806	\N	\N	\N	\N	\N	\N
3807	\N	\N	\N	\N	\N	\N
3808	\N	\N	\N	\N	\N	\N
3809	\N	\N	\N	\N	\N	\N
3810	\N	\N	\N	\N	\N	\N
3811	\N	\N	\N	\N	\N	\N
3812	\N	\N	\N	\N	\N	\N
3813	\N	\N	\N	\N	\N	\N
3814	\N	\N	\N	\N	\N	\N
3815	\N	\N	\N	\N	\N	\N
3816	\N	\N	\N	\N	\N	\N
3817	\N	\N	\N	\N	\N	\N
3818	\N	\N	\N	\N	\N	\N
3819	\N	\N	\N	\N	\N	\N
3820	\N	\N	\N	\N	\N	\N
3821	\N	\N	\N	\N	\N	\N
3822	\N	\N	\N	\N	\N	\N
3823	\N	\N	\N	\N	\N	\N
3824	\N	\N	\N	\N	\N	\N
3825	\N	\N	\N	\N	\N	\N
3826	\N	\N	\N	\N	\N	\N
3827	\N	\N	\N	\N	\N	\N
3828	\N	\N	\N	\N	\N	\N
3829	\N	\N	\N	\N	\N	\N
3830	\N	\N	\N	\N	\N	\N
3831	\N	\N	\N	\N	\N	\N
3832	\N	\N	\N	\N	\N	\N
3833	\N	\N	\N	\N	\N	\N
3834	\N	\N	\N	\N	\N	\N
3835	\N	\N	\N	\N	\N	\N
3836	\N	\N	\N	\N	\N	\N
3837	\N	\N	\N	\N	\N	\N
3838	\N	\N	\N	\N	\N	\N
3839	\N	\N	\N	\N	\N	\N
3840	\N	\N	\N	\N	\N	\N
3841	\N	\N	\N	\N	\N	\N
3842	\N	\N	\N	\N	\N	\N
3843	\N	\N	\N	\N	\N	\N
3844	\N	\N	\N	\N	\N	\N
3845	\N	\N	\N	\N	\N	\N
3846	\N	\N	\N	\N	\N	\N
3847	\N	\N	\N	\N	\N	\N
3848	\N	\N	\N	\N	\N	\N
3849	\N	\N	\N	\N	\N	\N
3850	\N	\N	\N	\N	\N	\N
3851	\N	\N	\N	\N	\N	\N
3852	\N	\N	\N	\N	\N	\N
3853	\N	\N	\N	\N	\N	\N
3854	\N	\N	\N	\N	\N	\N
3855	\N	\N	\N	\N	\N	\N
3856	\N	\N	\N	\N	\N	\N
3857	\N	\N	\N	\N	\N	\N
3858	\N	\N	\N	\N	\N	\N
3859	\N	\N	\N	\N	\N	\N
3860	\N	\N	\N	\N	\N	\N
3861	\N	\N	\N	\N	\N	\N
3862	\N	\N	\N	\N	\N	\N
3863	\N	\N	\N	\N	\N	\N
3864	\N	\N	\N	\N	\N	\N
3865	\N	\N	\N	\N	\N	\N
3866	\N	\N	\N	\N	\N	\N
3867	\N	\N	\N	\N	\N	\N
3868	\N	\N	\N	\N	\N	\N
3869	\N	\N	\N	\N	\N	\N
3870	\N	\N	\N	\N	\N	\N
3871	\N	\N	\N	\N	\N	\N
3872	\N	\N	\N	\N	\N	\N
3873	\N	\N	\N	\N	\N	\N
3874	\N	\N	\N	\N	\N	\N
3875	\N	\N	\N	\N	\N	\N
3876	\N	\N	\N	\N	\N	\N
3877	\N	\N	\N	\N	\N	\N
3878	\N	\N	\N	\N	\N	\N
3879	\N	\N	\N	\N	\N	\N
3880	\N	\N	\N	\N	\N	\N
3881	\N	\N	\N	\N	\N	\N
3882	\N	\N	\N	\N	\N	\N
3883	\N	\N	\N	\N	\N	\N
3884	\N	\N	\N	\N	\N	\N
3885	\N	\N	\N	\N	\N	\N
3886	\N	\N	\N	\N	\N	\N
3887	\N	\N	\N	\N	\N	\N
3888	\N	\N	\N	\N	\N	\N
3889	\N	\N	\N	\N	\N	\N
3890	\N	\N	\N	\N	\N	\N
3891	\N	\N	\N	\N	\N	\N
3892	\N	\N	\N	\N	\N	\N
3893	\N	\N	\N	\N	\N	\N
3894	\N	\N	\N	\N	\N	\N
3895	\N	\N	\N	\N	\N	\N
3896	\N	\N	\N	\N	\N	\N
3897	\N	\N	\N	\N	\N	\N
3898	\N	\N	\N	\N	\N	\N
3899	\N	\N	\N	\N	\N	\N
3900	\N	\N	\N	\N	\N	\N
3901	\N	\N	\N	\N	\N	\N
3902	\N	\N	\N	\N	\N	\N
3903	\N	\N	\N	\N	\N	\N
3904	\N	\N	\N	\N	\N	\N
3905	\N	\N	\N	\N	\N	\N
3906	\N	\N	\N	\N	\N	\N
3907	\N	\N	\N	\N	\N	\N
3908	\N	\N	\N	\N	\N	\N
3909	\N	\N	\N	\N	\N	\N
3910	\N	\N	\N	\N	\N	\N
3911	\N	\N	\N	\N	\N	\N
3912	\N	\N	\N	\N	\N	\N
3913	\N	\N	\N	\N	\N	\N
3914	\N	\N	\N	\N	\N	\N
3915	\N	\N	\N	\N	\N	\N
3916	\N	\N	\N	\N	\N	\N
3917	\N	\N	\N	\N	\N	\N
3918	\N	\N	\N	\N	\N	\N
3919	\N	\N	\N	\N	\N	\N
3920	\N	\N	\N	\N	\N	\N
3921	\N	\N	\N	\N	\N	\N
3922	\N	\N	\N	\N	\N	\N
3923	\N	\N	\N	\N	\N	\N
3924	\N	\N	\N	\N	\N	\N
3925	\N	\N	\N	\N	\N	\N
3926	\N	\N	\N	\N	\N	\N
3927	\N	\N	\N	\N	\N	\N
3928	\N	\N	\N	\N	\N	\N
3929	\N	\N	\N	\N	\N	\N
3930	\N	\N	\N	\N	\N	\N
3931	\N	\N	\N	\N	\N	\N
3932	\N	\N	\N	\N	\N	\N
3933	\N	\N	\N	\N	\N	\N
3934	\N	\N	\N	\N	\N	\N
3935	\N	\N	\N	\N	\N	\N
3936	\N	\N	\N	\N	\N	\N
3937	\N	\N	\N	\N	\N	\N
3938	\N	\N	\N	\N	\N	\N
3939	\N	\N	\N	\N	\N	\N
3940	\N	\N	\N	\N	\N	\N
3941	\N	\N	\N	\N	\N	\N
3942	\N	\N	\N	\N	\N	\N
3943	\N	\N	\N	\N	\N	\N
3944	\N	\N	\N	\N	\N	\N
3945	\N	\N	\N	\N	\N	\N
3946	\N	\N	\N	\N	\N	\N
3947	\N	\N	\N	\N	\N	\N
3948	\N	\N	\N	\N	\N	\N
3949	\N	\N	\N	\N	\N	\N
3950	\N	\N	\N	\N	\N	\N
3951	\N	\N	\N	\N	\N	\N
3952	\N	\N	\N	\N	\N	\N
3953	\N	\N	\N	\N	\N	\N
3954	\N	\N	\N	\N	\N	\N
3955	\N	\N	\N	\N	\N	\N
3956	\N	\N	\N	\N	\N	\N
3957	\N	\N	\N	\N	\N	\N
3958	\N	\N	\N	\N	\N	\N
3959	\N	\N	\N	\N	\N	\N
3960	\N	\N	\N	\N	\N	\N
3961	\N	\N	\N	\N	\N	\N
3962	\N	\N	\N	\N	\N	\N
3963	\N	\N	\N	\N	\N	\N
3964	\N	\N	\N	\N	\N	\N
3965	\N	\N	\N	\N	\N	\N
3966	\N	\N	\N	\N	\N	\N
3967	\N	\N	\N	\N	\N	\N
3968	\N	\N	\N	\N	\N	\N
3969	\N	\N	\N	\N	\N	\N
3970	\N	\N	\N	\N	\N	\N
3971	\N	\N	\N	\N	\N	\N
3972	\N	\N	\N	\N	\N	\N
3973	\N	\N	\N	\N	\N	\N
3974	\N	\N	\N	\N	\N	\N
3975	\N	\N	\N	\N	\N	\N
3976	\N	\N	\N	\N	\N	\N
3977	\N	\N	\N	\N	\N	\N
3978	\N	\N	\N	\N	\N	\N
3979	\N	\N	\N	\N	\N	\N
3980	\N	\N	\N	\N	\N	\N
3981	\N	\N	\N	\N	\N	\N
3982	\N	\N	\N	\N	\N	\N
3983	\N	\N	\N	\N	\N	\N
3984	\N	\N	\N	\N	\N	\N
3985	\N	\N	\N	\N	\N	\N
3986	\N	\N	\N	\N	\N	\N
3987	\N	\N	\N	\N	\N	\N
3988	\N	\N	\N	\N	\N	\N
3989	\N	\N	\N	\N	\N	\N
3990	\N	\N	\N	\N	\N	\N
3991	\N	\N	\N	\N	\N	\N
3992	\N	\N	\N	\N	\N	\N
3993	\N	\N	\N	\N	\N	\N
3994	\N	\N	\N	\N	\N	\N
3995	\N	\N	\N	\N	\N	\N
3996	\N	\N	\N	\N	\N	\N
3997	\N	\N	\N	\N	\N	\N
3998	\N	\N	\N	\N	\N	\N
3999	\N	\N	\N	\N	\N	\N
4000	\N	\N	\N	\N	\N	\N
4001	\N	\N	\N	\N	\N	\N
4002	\N	\N	\N	\N	\N	\N
4003	\N	\N	\N	\N	\N	\N
4004	\N	\N	\N	\N	\N	\N
4005	\N	\N	\N	\N	\N	\N
4006	\N	\N	\N	\N	\N	\N
4007	\N	\N	\N	\N	\N	\N
4008	\N	\N	\N	\N	\N	\N
4009	\N	\N	\N	\N	\N	\N
4010	\N	\N	\N	\N	\N	\N
4011	\N	\N	\N	\N	\N	\N
4012	\N	\N	\N	\N	\N	\N
4013	\N	\N	\N	\N	\N	\N
4014	\N	\N	\N	\N	\N	\N
4015	\N	\N	\N	\N	\N	\N
4016	\N	\N	\N	\N	\N	\N
4017	\N	\N	\N	\N	\N	\N
4018	\N	\N	\N	\N	\N	\N
4019	\N	\N	\N	\N	\N	\N
4020	\N	\N	\N	\N	\N	\N
4021	\N	\N	\N	\N	\N	\N
4022	\N	\N	\N	\N	\N	\N
4023	\N	\N	\N	\N	\N	\N
4024	\N	\N	\N	\N	\N	\N
4025	\N	\N	\N	\N	\N	\N
4026	\N	\N	\N	\N	\N	\N
4027	\N	\N	\N	\N	\N	\N
4028	\N	\N	\N	\N	\N	\N
4029	\N	\N	\N	\N	\N	\N
4030	\N	\N	\N	\N	\N	\N
4031	\N	\N	\N	\N	\N	\N
4032	\N	\N	\N	\N	\N	\N
4033	\N	\N	\N	\N	\N	\N
4034	\N	\N	\N	\N	\N	\N
4035	\N	\N	\N	\N	\N	\N
4036	\N	\N	\N	\N	\N	\N
4037	\N	\N	\N	\N	\N	\N
4038	\N	\N	\N	\N	\N	\N
4039	\N	\N	\N	\N	\N	\N
4040	\N	\N	\N	\N	\N	\N
4041	\N	\N	\N	\N	\N	\N
4042	\N	\N	\N	\N	\N	\N
4043	\N	\N	\N	\N	\N	\N
4044	\N	\N	\N	\N	\N	\N
4045	\N	\N	\N	\N	\N	\N
4046	\N	\N	\N	\N	\N	\N
4047	\N	\N	\N	\N	\N	\N
4048	\N	\N	\N	\N	\N	\N
4049	\N	\N	\N	\N	\N	\N
4050	\N	\N	\N	\N	\N	\N
4051	\N	\N	\N	\N	\N	\N
4052	\N	\N	\N	\N	\N	\N
4053	\N	\N	\N	\N	\N	\N
4054	\N	\N	\N	\N	\N	\N
4055	\N	\N	\N	\N	\N	\N
4056	\N	\N	\N	\N	\N	\N
4057	\N	\N	\N	\N	\N	\N
4058	\N	\N	\N	\N	\N	\N
4059	\N	\N	\N	\N	\N	\N
4060	\N	\N	\N	\N	\N	\N
4061	\N	\N	\N	\N	\N	\N
4062	\N	\N	\N	\N	\N	\N
4063	\N	\N	\N	\N	\N	\N
4064	\N	\N	\N	\N	\N	\N
4065	\N	\N	\N	\N	\N	\N
4066	\N	\N	\N	\N	\N	\N
4067	\N	\N	\N	\N	\N	\N
4068	\N	\N	\N	\N	\N	\N
4069	\N	\N	\N	\N	\N	\N
4070	\N	\N	\N	\N	\N	\N
4071	\N	\N	\N	\N	\N	\N
4072	\N	\N	\N	\N	\N	\N
4073	\N	\N	\N	\N	\N	\N
4074	\N	\N	\N	\N	\N	\N
4075	\N	\N	\N	\N	\N	\N
4076	\N	\N	\N	\N	\N	\N
4077	\N	\N	\N	\N	\N	\N
4078	\N	\N	\N	\N	\N	\N
4079	\N	\N	\N	\N	\N	\N
4080	\N	\N	\N	\N	\N	\N
4081	\N	\N	\N	\N	\N	\N
4082	\N	\N	\N	\N	\N	\N
4083	\N	\N	\N	\N	\N	\N
4084	\N	\N	\N	\N	\N	\N
4085	\N	\N	\N	\N	\N	\N
4086	\N	\N	\N	\N	\N	\N
4087	\N	\N	\N	\N	\N	\N
4088	\N	\N	\N	\N	\N	\N
4089	\N	\N	\N	\N	\N	\N
4090	\N	\N	\N	\N	\N	\N
4091	\N	\N	\N	\N	\N	\N
4092	\N	\N	\N	\N	\N	\N
4093	\N	\N	\N	\N	\N	\N
4094	\N	\N	\N	\N	\N	\N
4095	\N	\N	\N	\N	\N	\N
4096	\N	\N	\N	\N	\N	\N
4097	\N	\N	\N	\N	\N	\N
4098	\N	\N	\N	\N	\N	\N
4099	\N	\N	\N	\N	\N	\N
4100	\N	\N	\N	\N	\N	\N
4101	\N	\N	\N	\N	\N	\N
4102	\N	\N	\N	\N	\N	\N
4103	\N	\N	\N	\N	\N	\N
4104	\N	\N	\N	\N	\N	\N
4105	\N	\N	\N	\N	\N	\N
4106	\N	\N	\N	\N	\N	\N
4107	\N	\N	\N	\N	\N	\N
4108	\N	\N	\N	\N	\N	\N
4109	\N	\N	\N	\N	\N	\N
4110	\N	\N	\N	\N	\N	\N
4111	\N	\N	\N	\N	\N	\N
4112	\N	\N	\N	\N	\N	\N
4113	\N	\N	\N	\N	\N	\N
4114	\N	\N	\N	\N	\N	\N
4115	\N	\N	\N	\N	\N	\N
4116	\N	\N	\N	\N	\N	\N
4117	\N	\N	\N	\N	\N	\N
4118	\N	\N	\N	\N	\N	\N
4119	\N	\N	\N	\N	\N	\N
4120	\N	\N	\N	\N	\N	\N
4121	\N	\N	\N	\N	\N	\N
4122	\N	\N	\N	\N	\N	\N
4123	\N	\N	\N	\N	\N	\N
4124	\N	\N	\N	\N	\N	\N
4125	\N	\N	\N	\N	\N	\N
4126	\N	\N	\N	\N	\N	\N
4127	\N	\N	\N	\N	\N	\N
4128	\N	\N	\N	\N	\N	\N
4129	\N	\N	\N	\N	\N	\N
4130	\N	\N	\N	\N	\N	\N
4131	\N	\N	\N	\N	\N	\N
4132	\N	\N	\N	\N	\N	\N
4133	\N	\N	\N	\N	\N	\N
4134	\N	\N	\N	\N	\N	\N
4135	\N	\N	\N	\N	\N	\N
4136	\N	\N	\N	\N	\N	\N
4137	\N	\N	\N	\N	\N	\N
4138	\N	\N	\N	\N	\N	\N
4139	\N	\N	\N	\N	\N	\N
4140	\N	\N	\N	\N	\N	\N
4141	\N	\N	\N	\N	\N	\N
4142	\N	\N	\N	\N	\N	\N
4143	\N	\N	\N	\N	\N	\N
4144	\N	\N	\N	\N	\N	\N
4145	\N	\N	\N	\N	\N	\N
4146	\N	\N	\N	\N	\N	\N
4147	\N	\N	\N	\N	\N	\N
4148	\N	\N	\N	\N	\N	\N
4149	\N	\N	\N	\N	\N	\N
4150	\N	\N	\N	\N	\N	\N
4151	\N	\N	\N	\N	\N	\N
4152	\N	\N	\N	\N	\N	\N
4153	\N	\N	\N	\N	\N	\N
4154	\N	\N	\N	\N	\N	\N
4155	\N	\N	\N	\N	\N	\N
4156	\N	\N	\N	\N	\N	\N
4157	\N	\N	\N	\N	\N	\N
4158	\N	\N	\N	\N	\N	\N
4159	\N	\N	\N	\N	\N	\N
4160	\N	\N	\N	\N	\N	\N
4161	\N	\N	\N	\N	\N	\N
4162	\N	\N	\N	\N	\N	\N
4163	\N	\N	\N	\N	\N	\N
4164	\N	\N	\N	\N	\N	\N
4165	\N	\N	\N	\N	\N	\N
4166	\N	\N	\N	\N	\N	\N
4167	\N	\N	\N	\N	\N	\N
4168	\N	\N	\N	\N	\N	\N
4169	\N	\N	\N	\N	\N	\N
4170	\N	\N	\N	\N	\N	\N
4171	\N	\N	\N	\N	\N	\N
4172	\N	\N	\N	\N	\N	\N
4173	\N	\N	\N	\N	\N	\N
4174	\N	\N	\N	\N	\N	\N
4175	\N	\N	\N	\N	\N	\N
4176	\N	\N	\N	\N	\N	\N
4177	\N	\N	\N	\N	\N	\N
4178	\N	\N	\N	\N	\N	\N
4179	\N	\N	\N	\N	\N	\N
4180	\N	\N	\N	\N	\N	\N
4181	\N	\N	\N	\N	\N	\N
4182	\N	\N	\N	\N	\N	\N
4183	\N	\N	\N	\N	\N	\N
4184	\N	\N	\N	\N	\N	\N
4185	\N	\N	\N	\N	\N	\N
4186	\N	\N	\N	\N	\N	\N
4187	\N	\N	\N	\N	\N	\N
4188	\N	\N	\N	\N	\N	\N
4189	\N	\N	\N	\N	\N	\N
4190	\N	\N	\N	\N	\N	\N
4191	\N	\N	\N	\N	\N	\N
4192	\N	\N	\N	\N	\N	\N
4193	\N	\N	\N	\N	\N	\N
4194	\N	\N	\N	\N	\N	\N
4195	\N	\N	\N	\N	\N	\N
4196	\N	\N	\N	\N	\N	\N
4197	\N	\N	\N	\N	\N	\N
4198	\N	\N	\N	\N	\N	\N
4199	\N	\N	\N	\N	\N	\N
4200	\N	\N	\N	\N	\N	\N
4201	\N	\N	\N	\N	\N	\N
4202	\N	\N	\N	\N	\N	\N
4203	\N	\N	\N	\N	\N	\N
4204	\N	\N	\N	\N	\N	\N
4205	\N	\N	\N	\N	\N	\N
4206	\N	\N	\N	\N	\N	\N
4207	\N	\N	\N	\N	\N	\N
4208	\N	\N	\N	\N	\N	\N
4209	\N	\N	\N	\N	\N	\N
4210	\N	\N	\N	\N	\N	\N
4211	\N	\N	\N	\N	\N	\N
4212	\N	\N	\N	\N	\N	\N
4213	\N	\N	\N	\N	\N	\N
4214	\N	\N	\N	\N	\N	\N
4215	\N	\N	\N	\N	\N	\N
4216	\N	\N	\N	\N	\N	\N
4217	\N	\N	\N	\N	\N	\N
4218	\N	\N	\N	\N	\N	\N
4219	\N	\N	\N	\N	\N	\N
4220	\N	\N	\N	\N	\N	\N
4221	\N	\N	\N	\N	\N	\N
4222	\N	\N	\N	\N	\N	\N
4223	\N	\N	\N	\N	\N	\N
4224	\N	\N	\N	\N	\N	\N
4225	\N	\N	\N	\N	\N	\N
4226	\N	\N	\N	\N	\N	\N
4227	\N	\N	\N	\N	\N	\N
4228	\N	\N	\N	\N	\N	\N
4229	\N	\N	\N	\N	\N	\N
4230	\N	\N	\N	\N	\N	\N
4231	\N	\N	\N	\N	\N	\N
4232	\N	\N	\N	\N	\N	\N
4233	\N	\N	\N	\N	\N	\N
4234	\N	\N	\N	\N	\N	\N
4235	\N	\N	\N	\N	\N	\N
4236	\N	\N	\N	\N	\N	\N
4237	\N	\N	\N	\N	\N	\N
4238	\N	\N	\N	\N	\N	\N
4239	\N	\N	\N	\N	\N	\N
4240	\N	\N	\N	\N	\N	\N
4241	\N	\N	\N	\N	\N	\N
4242	\N	\N	\N	\N	\N	\N
4243	\N	\N	\N	\N	\N	\N
4244	\N	\N	\N	\N	\N	\N
4245	\N	\N	\N	\N	\N	\N
4246	\N	\N	\N	\N	\N	\N
4247	\N	\N	\N	\N	\N	\N
4248	\N	\N	\N	\N	\N	\N
4249	\N	\N	\N	\N	\N	\N
4250	\N	\N	\N	\N	\N	\N
4251	\N	\N	\N	\N	\N	\N
4252	\N	\N	\N	\N	\N	\N
4253	\N	\N	\N	\N	\N	\N
4254	\N	\N	\N	\N	\N	\N
4255	\N	\N	\N	\N	\N	\N
4256	\N	\N	\N	\N	\N	\N
4257	\N	\N	\N	\N	\N	\N
4258	\N	\N	\N	\N	\N	\N
4259	\N	\N	\N	\N	\N	\N
4260	\N	\N	\N	\N	\N	\N
4261	\N	\N	\N	\N	\N	\N
4262	\N	\N	\N	\N	\N	\N
4263	\N	\N	\N	\N	\N	\N
4264	\N	\N	\N	\N	\N	\N
4265	\N	\N	\N	\N	\N	\N
4266	\N	\N	\N	\N	\N	\N
4267	\N	\N	\N	\N	\N	\N
4268	\N	\N	\N	\N	\N	\N
4269	\N	\N	\N	\N	\N	\N
4270	\N	\N	\N	\N	\N	\N
4271	\N	\N	\N	\N	\N	\N
4272	\N	\N	\N	\N	\N	\N
4273	\N	\N	\N	\N	\N	\N
4274	\N	\N	\N	\N	\N	\N
4275	\N	\N	\N	\N	\N	\N
4276	\N	\N	\N	\N	\N	\N
4277	\N	\N	\N	\N	\N	\N
4278	\N	\N	\N	\N	\N	\N
4279	\N	\N	\N	\N	\N	\N
4280	\N	\N	\N	\N	\N	\N
4281	\N	\N	\N	\N	\N	\N
4282	\N	\N	\N	\N	\N	\N
4283	\N	\N	\N	\N	\N	\N
4284	\N	\N	\N	\N	\N	\N
4285	\N	\N	\N	\N	\N	\N
4286	\N	\N	\N	\N	\N	\N
4287	\N	\N	\N	\N	\N	\N
4288	\N	\N	\N	\N	\N	\N
4289	\N	\N	\N	\N	\N	\N
4290	\N	\N	\N	\N	\N	\N
4291	\N	\N	\N	\N	\N	\N
4292	\N	\N	\N	\N	\N	\N
4293	\N	\N	\N	\N	\N	\N
4294	\N	\N	\N	\N	\N	\N
4295	\N	\N	\N	\N	\N	\N
4296	\N	\N	\N	\N	\N	\N
4297	\N	\N	\N	\N	\N	\N
4298	\N	\N	\N	\N	\N	\N
4299	\N	\N	\N	\N	\N	\N
4300	\N	\N	\N	\N	\N	\N
4301	\N	\N	\N	\N	\N	\N
4302	\N	\N	\N	\N	\N	\N
4303	\N	\N	\N	\N	\N	\N
4304	\N	\N	\N	\N	\N	\N
4305	\N	\N	\N	\N	\N	\N
4306	\N	\N	\N	\N	\N	\N
4307	\N	\N	\N	\N	\N	\N
4308	\N	\N	\N	\N	\N	\N
4309	\N	\N	\N	\N	\N	\N
4310	\N	\N	\N	\N	\N	\N
4311	\N	\N	\N	\N	\N	\N
4312	\N	\N	\N	\N	\N	\N
4313	\N	\N	\N	\N	\N	\N
4314	\N	\N	\N	\N	\N	\N
4315	\N	\N	\N	\N	\N	\N
4316	\N	\N	\N	\N	\N	\N
4317	\N	\N	\N	\N	\N	\N
4318	\N	\N	\N	\N	\N	\N
4319	\N	\N	\N	\N	\N	\N
4320	\N	\N	\N	\N	\N	\N
4321	\N	\N	\N	\N	\N	\N
4322	\N	\N	\N	\N	\N	\N
4323	\N	\N	\N	\N	\N	\N
4324	\N	\N	\N	\N	\N	\N
4325	\N	\N	\N	\N	\N	\N
4326	\N	\N	\N	\N	\N	\N
4327	\N	\N	\N	\N	\N	\N
4328	\N	\N	\N	\N	\N	\N
4329	\N	\N	\N	\N	\N	\N
4330	\N	\N	\N	\N	\N	\N
4331	\N	\N	\N	\N	\N	\N
4332	\N	\N	\N	\N	\N	\N
4333	\N	\N	\N	\N	\N	\N
4334	\N	\N	\N	\N	\N	\N
4335	\N	\N	\N	\N	\N	\N
4336	\N	\N	\N	\N	\N	\N
4337	\N	\N	\N	\N	\N	\N
4338	\N	\N	\N	\N	\N	\N
4339	\N	\N	\N	\N	\N	\N
4340	\N	\N	\N	\N	\N	\N
4341	\N	\N	\N	\N	\N	\N
4342	\N	\N	\N	\N	\N	\N
4343	\N	\N	\N	\N	\N	\N
4344	\N	\N	\N	\N	\N	\N
4345	\N	\N	\N	\N	\N	\N
4346	\N	\N	\N	\N	\N	\N
4347	\N	\N	\N	\N	\N	\N
4348	\N	\N	\N	\N	\N	\N
4349	\N	\N	\N	\N	\N	\N
4350	\N	\N	\N	\N	\N	\N
4351	\N	\N	\N	\N	\N	\N
4352	\N	\N	\N	\N	\N	\N
4353	\N	\N	\N	\N	\N	\N
4354	\N	\N	\N	\N	\N	\N
4355	\N	\N	\N	\N	\N	\N
4356	\N	\N	\N	\N	\N	\N
4357	\N	\N	\N	\N	\N	\N
4358	\N	\N	\N	\N	\N	\N
4359	\N	\N	\N	\N	\N	\N
4360	\N	\N	\N	\N	\N	\N
4361	\N	\N	\N	\N	\N	\N
4362	\N	\N	\N	\N	\N	\N
4363	\N	\N	\N	\N	\N	\N
4364	\N	\N	\N	\N	\N	\N
4365	\N	\N	\N	\N	\N	\N
4366	\N	\N	\N	\N	\N	\N
4367	\N	\N	\N	\N	\N	\N
4368	\N	\N	\N	\N	\N	\N
4369	\N	\N	\N	\N	\N	\N
4370	\N	\N	\N	\N	\N	\N
4371	\N	\N	\N	\N	\N	\N
4372	\N	\N	\N	\N	\N	\N
4373	\N	\N	\N	\N	\N	\N
4374	\N	\N	\N	\N	\N	\N
4375	\N	\N	\N	\N	\N	\N
4376	\N	\N	\N	\N	\N	\N
4377	\N	\N	\N	\N	\N	\N
4378	\N	\N	\N	\N	\N	\N
4379	\N	\N	\N	\N	\N	\N
4380	\N	\N	\N	\N	\N	\N
4381	\N	\N	\N	\N	\N	\N
4382	\N	\N	\N	\N	\N	\N
4383	\N	\N	\N	\N	\N	\N
4384	\N	\N	\N	\N	\N	\N
4385	\N	\N	\N	\N	\N	\N
4386	\N	\N	\N	\N	\N	\N
4387	\N	\N	\N	\N	\N	\N
4388	\N	\N	\N	\N	\N	\N
4389	\N	\N	\N	\N	\N	\N
4390	\N	\N	\N	\N	\N	\N
4391	\N	\N	\N	\N	\N	\N
4392	\N	\N	\N	\N	\N	\N
4393	\N	\N	\N	\N	\N	\N
4394	\N	\N	\N	\N	\N	\N
4395	\N	\N	\N	\N	\N	\N
4396	\N	\N	\N	\N	\N	\N
4397	\N	\N	\N	\N	\N	\N
4398	\N	\N	\N	\N	\N	\N
4399	\N	\N	\N	\N	\N	\N
4400	\N	\N	\N	\N	\N	\N
4401	\N	\N	\N	\N	\N	\N
4402	\N	\N	\N	\N	\N	\N
4403	\N	\N	\N	\N	\N	\N
4404	\N	\N	\N	\N	\N	\N
4405	\N	\N	\N	\N	\N	\N
4406	\N	\N	\N	\N	\N	\N
4407	\N	\N	\N	\N	\N	\N
4408	\N	\N	\N	\N	\N	\N
4409	\N	\N	\N	\N	\N	\N
4410	\N	\N	\N	\N	\N	\N
4411	\N	\N	\N	\N	\N	\N
4412	\N	\N	\N	\N	\N	\N
4413	\N	\N	\N	\N	\N	\N
4414	\N	\N	\N	\N	\N	\N
4415	\N	\N	\N	\N	\N	\N
4416	\N	\N	\N	\N	\N	\N
4417	\N	\N	\N	\N	\N	\N
4418	\N	\N	\N	\N	\N	\N
4419	\N	\N	\N	\N	\N	\N
4420	\N	\N	\N	\N	\N	\N
4421	\N	\N	\N	\N	\N	\N
4422	\N	\N	\N	\N	\N	\N
4423	\N	\N	\N	\N	\N	\N
4424	\N	\N	\N	\N	\N	\N
4425	\N	\N	\N	\N	\N	\N
4426	\N	\N	\N	\N	\N	\N
4427	\N	\N	\N	\N	\N	\N
4428	\N	\N	\N	\N	\N	\N
4429	\N	\N	\N	\N	\N	\N
4430	\N	\N	\N	\N	\N	\N
4431	\N	\N	\N	\N	\N	\N
4432	\N	\N	\N	\N	\N	\N
4433	\N	\N	\N	\N	\N	\N
4434	\N	\N	\N	\N	\N	\N
4435	\N	\N	\N	\N	\N	\N
4436	\N	\N	\N	\N	\N	\N
4437	\N	\N	\N	\N	\N	\N
4438	\N	\N	\N	\N	\N	\N
4439	\N	\N	\N	\N	\N	\N
4440	\N	\N	\N	\N	\N	\N
4441	\N	\N	\N	\N	\N	\N
4442	\N	\N	\N	\N	\N	\N
4443	\N	\N	\N	\N	\N	\N
4444	\N	\N	\N	\N	\N	\N
4445	\N	\N	\N	\N	\N	\N
4446	\N	\N	\N	\N	\N	\N
4447	\N	\N	\N	\N	\N	\N
4448	\N	\N	\N	\N	\N	\N
4449	\N	\N	\N	\N	\N	\N
4450	\N	\N	\N	\N	\N	\N
4451	\N	\N	\N	\N	\N	\N
4452	\N	\N	\N	\N	\N	\N
4453	\N	\N	\N	\N	\N	\N
4454	\N	\N	\N	\N	\N	\N
4455	\N	\N	\N	\N	\N	\N
4456	\N	\N	\N	\N	\N	\N
4457	\N	\N	\N	\N	\N	\N
4458	\N	\N	\N	\N	\N	\N
4459	\N	\N	\N	\N	\N	\N
4460	\N	\N	\N	\N	\N	\N
4461	\N	\N	\N	\N	\N	\N
4462	\N	\N	\N	\N	\N	\N
4463	\N	\N	\N	\N	\N	\N
4464	\N	\N	\N	\N	\N	\N
4465	\N	\N	\N	\N	\N	\N
4466	\N	\N	\N	\N	\N	\N
4467	\N	\N	\N	\N	\N	\N
4468	\N	\N	\N	\N	\N	\N
4469	\N	\N	\N	\N	\N	\N
4470	\N	\N	\N	\N	\N	\N
4471	\N	\N	\N	\N	\N	\N
4472	\N	\N	\N	\N	\N	\N
4473	\N	\N	\N	\N	\N	\N
4474	\N	\N	\N	\N	\N	\N
4475	\N	\N	\N	\N	\N	\N
4476	\N	\N	\N	\N	\N	\N
4477	\N	\N	\N	\N	\N	\N
4478	\N	\N	\N	\N	\N	\N
4479	\N	\N	\N	\N	\N	\N
4480	\N	\N	\N	\N	\N	\N
4481	\N	\N	\N	\N	\N	\N
4482	\N	\N	\N	\N	\N	\N
4483	\N	\N	\N	\N	\N	\N
4484	\N	\N	\N	\N	\N	\N
4485	\N	\N	\N	\N	\N	\N
4486	\N	\N	\N	\N	\N	\N
4487	\N	\N	\N	\N	\N	\N
4488	\N	\N	\N	\N	\N	\N
4489	\N	\N	\N	\N	\N	\N
4490	\N	\N	\N	\N	\N	\N
4491	\N	\N	\N	\N	\N	\N
4492	\N	\N	\N	\N	\N	\N
4493	\N	\N	\N	\N	\N	\N
4494	\N	\N	\N	\N	\N	\N
4495	\N	\N	\N	\N	\N	\N
4496	\N	\N	\N	\N	\N	\N
4497	\N	\N	\N	\N	\N	\N
4498	\N	\N	\N	\N	\N	\N
4499	\N	\N	\N	\N	\N	\N
4500	\N	\N	\N	\N	\N	\N
4501	\N	\N	\N	\N	\N	\N
4502	\N	\N	\N	\N	\N	\N
4503	\N	\N	\N	\N	\N	\N
4504	\N	\N	\N	\N	\N	\N
4505	\N	\N	\N	\N	\N	\N
4506	\N	\N	\N	\N	\N	\N
4507	\N	\N	\N	\N	\N	\N
4508	\N	\N	\N	\N	\N	\N
4509	\N	\N	\N	\N	\N	\N
4510	\N	\N	\N	\N	\N	\N
4511	\N	\N	\N	\N	\N	\N
4512	\N	\N	\N	\N	\N	\N
4513	\N	\N	\N	\N	\N	\N
4514	\N	\N	\N	\N	\N	\N
4515	\N	\N	\N	\N	\N	\N
4516	\N	\N	\N	\N	\N	\N
4517	\N	\N	\N	\N	\N	\N
4518	\N	\N	\N	\N	\N	\N
4519	\N	\N	\N	\N	\N	\N
4520	\N	\N	\N	\N	\N	\N
4521	\N	\N	\N	\N	\N	\N
4522	\N	\N	\N	\N	\N	\N
4523	\N	\N	\N	\N	\N	\N
4524	\N	\N	\N	\N	\N	\N
4525	\N	\N	\N	\N	\N	\N
4526	\N	\N	\N	\N	\N	\N
4527	\N	\N	\N	\N	\N	\N
4528	\N	\N	\N	\N	\N	\N
4529	\N	\N	\N	\N	\N	\N
4530	\N	\N	\N	\N	\N	\N
4531	\N	\N	\N	\N	\N	\N
4532	\N	\N	\N	\N	\N	\N
4533	\N	\N	\N	\N	\N	\N
4534	\N	\N	\N	\N	\N	\N
4535	\N	\N	\N	\N	\N	\N
4536	\N	\N	\N	\N	\N	\N
4537	\N	\N	\N	\N	\N	\N
4538	\N	\N	\N	\N	\N	\N
4539	\N	\N	\N	\N	\N	\N
4540	\N	\N	\N	\N	\N	\N
4541	\N	\N	\N	\N	\N	\N
4542	\N	\N	\N	\N	\N	\N
4543	\N	\N	\N	\N	\N	\N
4544	\N	\N	\N	\N	\N	\N
4545	\N	\N	\N	\N	\N	\N
4546	\N	\N	\N	\N	\N	\N
4547	\N	\N	\N	\N	\N	\N
4548	\N	\N	\N	\N	\N	\N
4549	\N	\N	\N	\N	\N	\N
4550	\N	\N	\N	\N	\N	\N
4551	\N	\N	\N	\N	\N	\N
4552	\N	\N	\N	\N	\N	\N
4553	\N	\N	\N	\N	\N	\N
4554	\N	\N	\N	\N	\N	\N
4555	\N	\N	\N	\N	\N	\N
4556	\N	\N	\N	\N	\N	\N
4557	\N	\N	\N	\N	\N	\N
4558	\N	\N	\N	\N	\N	\N
4559	\N	\N	\N	\N	\N	\N
4560	\N	\N	\N	\N	\N	\N
4561	\N	\N	\N	\N	\N	\N
4562	\N	\N	\N	\N	\N	\N
4563	\N	\N	\N	\N	\N	\N
4564	\N	\N	\N	\N	\N	\N
4565	\N	\N	\N	\N	\N	\N
4566	\N	\N	\N	\N	\N	\N
4567	\N	\N	\N	\N	\N	\N
4568	\N	\N	\N	\N	\N	\N
4569	\N	\N	\N	\N	\N	\N
4570	\N	\N	\N	\N	\N	\N
4571	\N	\N	\N	\N	\N	\N
4572	\N	\N	\N	\N	\N	\N
4573	\N	\N	\N	\N	\N	\N
4574	\N	\N	\N	\N	\N	\N
4575	\N	\N	\N	\N	\N	\N
4576	\N	\N	\N	\N	\N	\N
4577	\N	\N	\N	\N	\N	\N
4578	\N	\N	\N	\N	\N	\N
4579	\N	\N	\N	\N	\N	\N
4580	\N	\N	\N	\N	\N	\N
4581	\N	\N	\N	\N	\N	\N
4582	\N	\N	\N	\N	\N	\N
4583	\N	\N	\N	\N	\N	\N
4584	\N	\N	\N	\N	\N	\N
4585	\N	\N	\N	\N	\N	\N
4586	\N	\N	\N	\N	\N	\N
4587	\N	\N	\N	\N	\N	\N
4588	\N	\N	\N	\N	\N	\N
4589	\N	\N	\N	\N	\N	\N
4590	\N	\N	\N	\N	\N	\N
4591	\N	\N	\N	\N	\N	\N
4592	\N	\N	\N	\N	\N	\N
4593	\N	\N	\N	\N	\N	\N
4594	\N	\N	\N	\N	\N	\N
4595	\N	\N	\N	\N	\N	\N
4596	\N	\N	\N	\N	\N	\N
4597	\N	\N	\N	\N	\N	\N
4598	\N	\N	\N	\N	\N	\N
4599	\N	\N	\N	\N	\N	\N
4600	\N	\N	\N	\N	\N	\N
4601	\N	\N	\N	\N	\N	\N
4602	\N	\N	\N	\N	\N	\N
4603	\N	\N	\N	\N	\N	\N
4604	\N	\N	\N	\N	\N	\N
4605	\N	\N	\N	\N	\N	\N
4606	\N	\N	\N	\N	\N	\N
4607	\N	\N	\N	\N	\N	\N
4608	\N	\N	\N	\N	\N	\N
4609	\N	\N	\N	\N	\N	\N
4610	\N	\N	\N	\N	\N	\N
4611	\N	\N	\N	\N	\N	\N
4612	\N	\N	\N	\N	\N	\N
4613	\N	\N	\N	\N	\N	\N
4614	\N	\N	\N	\N	\N	\N
4615	\N	\N	\N	\N	\N	\N
4616	\N	\N	\N	\N	\N	\N
4617	\N	\N	\N	\N	\N	\N
4618	\N	\N	\N	\N	\N	\N
4619	\N	\N	\N	\N	\N	\N
4620	\N	\N	\N	\N	\N	\N
4621	\N	\N	\N	\N	\N	\N
4622	\N	\N	\N	\N	\N	\N
4623	\N	\N	\N	\N	\N	\N
4624	\N	\N	\N	\N	\N	\N
4625	\N	\N	\N	\N	\N	\N
4626	\N	\N	\N	\N	\N	\N
4627	\N	\N	\N	\N	\N	\N
4628	\N	\N	\N	\N	\N	\N
4629	\N	\N	\N	\N	\N	\N
4630	\N	\N	\N	\N	\N	\N
4631	\N	\N	\N	\N	\N	\N
4632	\N	\N	\N	\N	\N	\N
4633	\N	\N	\N	\N	\N	\N
4634	\N	\N	\N	\N	\N	\N
4635	\N	\N	\N	\N	\N	\N
4636	\N	\N	\N	\N	\N	\N
4637	\N	\N	\N	\N	\N	\N
4638	\N	\N	\N	\N	\N	\N
4639	\N	\N	\N	\N	\N	\N
4640	\N	\N	\N	\N	\N	\N
4641	\N	\N	\N	\N	\N	\N
4642	\N	\N	\N	\N	\N	\N
4643	\N	\N	\N	\N	\N	\N
4644	\N	\N	\N	\N	\N	\N
4645	\N	\N	\N	\N	\N	\N
4646	\N	\N	\N	\N	\N	\N
4647	\N	\N	\N	\N	\N	\N
4648	\N	\N	\N	\N	\N	\N
4649	\N	\N	\N	\N	\N	\N
4650	\N	\N	\N	\N	\N	\N
4651	\N	\N	\N	\N	\N	\N
4652	\N	\N	\N	\N	\N	\N
4653	\N	\N	\N	\N	\N	\N
4654	\N	\N	\N	\N	\N	\N
4655	\N	\N	\N	\N	\N	\N
4656	\N	\N	\N	\N	\N	\N
4657	\N	\N	\N	\N	\N	\N
4658	\N	\N	\N	\N	\N	\N
4659	\N	\N	\N	\N	\N	\N
4660	\N	\N	\N	\N	\N	\N
4661	\N	\N	\N	\N	\N	\N
4662	\N	\N	\N	\N	\N	\N
4663	\N	\N	\N	\N	\N	\N
4664	\N	\N	\N	\N	\N	\N
4665	\N	\N	\N	\N	\N	\N
4666	\N	\N	\N	\N	\N	\N
4667	\N	\N	\N	\N	\N	\N
4668	\N	\N	\N	\N	\N	\N
4669	\N	\N	\N	\N	\N	\N
4670	\N	\N	\N	\N	\N	\N
4671	\N	\N	\N	\N	\N	\N
4672	\N	\N	\N	\N	\N	\N
4673	\N	\N	\N	\N	\N	\N
4674	\N	\N	\N	\N	\N	\N
4675	\N	\N	\N	\N	\N	\N
4676	\N	\N	\N	\N	\N	\N
4677	\N	\N	\N	\N	\N	\N
4678	\N	\N	\N	\N	\N	\N
4679	\N	\N	\N	\N	\N	\N
4680	\N	\N	\N	\N	\N	\N
4681	\N	\N	\N	\N	\N	\N
4682	\N	\N	\N	\N	\N	\N
4683	\N	\N	\N	\N	\N	\N
4684	\N	\N	\N	\N	\N	\N
4685	\N	\N	\N	\N	\N	\N
4686	\N	\N	\N	\N	\N	\N
4687	\N	\N	\N	\N	\N	\N
4688	\N	\N	\N	\N	\N	\N
4689	\N	\N	\N	\N	\N	\N
4690	\N	\N	\N	\N	\N	\N
4691	\N	\N	\N	\N	\N	\N
4692	\N	\N	\N	\N	\N	\N
4693	\N	\N	\N	\N	\N	\N
4694	\N	\N	\N	\N	\N	\N
4695	\N	\N	\N	\N	\N	\N
4696	\N	\N	\N	\N	\N	\N
4697	\N	\N	\N	\N	\N	\N
4698	\N	\N	\N	\N	\N	\N
4699	\N	\N	\N	\N	\N	\N
4700	\N	\N	\N	\N	\N	\N
4701	\N	\N	\N	\N	\N	\N
4702	\N	\N	\N	\N	\N	\N
4703	\N	\N	\N	\N	\N	\N
4704	\N	\N	\N	\N	\N	\N
4705	\N	\N	\N	\N	\N	\N
4706	\N	\N	\N	\N	\N	\N
4707	\N	\N	\N	\N	\N	\N
4708	\N	\N	\N	\N	\N	\N
4709	\N	\N	\N	\N	\N	\N
4710	\N	\N	\N	\N	\N	\N
4711	\N	\N	\N	\N	\N	\N
4712	\N	\N	\N	\N	\N	\N
4713	\N	\N	\N	\N	\N	\N
4714	\N	\N	\N	\N	\N	\N
4715	\N	\N	\N	\N	\N	\N
4716	\N	\N	\N	\N	\N	\N
4717	\N	\N	\N	\N	\N	\N
4718	\N	\N	\N	\N	\N	\N
4719	\N	\N	\N	\N	\N	\N
4720	\N	\N	\N	\N	\N	\N
4721	\N	\N	\N	\N	\N	\N
4722	\N	\N	\N	\N	\N	\N
4723	\N	\N	\N	\N	\N	\N
4724	\N	\N	\N	\N	\N	\N
4725	\N	\N	\N	\N	\N	\N
4726	\N	\N	\N	\N	\N	\N
4727	\N	\N	\N	\N	\N	\N
4728	\N	\N	\N	\N	\N	\N
4729	\N	\N	\N	\N	\N	\N
4730	\N	\N	\N	\N	\N	\N
4731	\N	\N	\N	\N	\N	\N
4732	\N	\N	\N	\N	\N	\N
4733	\N	\N	\N	\N	\N	\N
4734	\N	\N	\N	\N	\N	\N
4735	\N	\N	\N	\N	\N	\N
4736	\N	\N	\N	\N	\N	\N
4737	\N	\N	\N	\N	\N	\N
4738	\N	\N	\N	\N	\N	\N
4739	\N	\N	\N	\N	\N	\N
4740	\N	\N	\N	\N	\N	\N
4741	\N	\N	\N	\N	\N	\N
4742	\N	\N	\N	\N	\N	\N
4743	\N	\N	\N	\N	\N	\N
4744	\N	\N	\N	\N	\N	\N
4745	\N	\N	\N	\N	\N	\N
4746	\N	\N	\N	\N	\N	\N
4747	\N	\N	\N	\N	\N	\N
4748	\N	\N	\N	\N	\N	\N
4749	\N	\N	\N	\N	\N	\N
4750	\N	\N	\N	\N	\N	\N
4751	\N	\N	\N	\N	\N	\N
4752	\N	\N	\N	\N	\N	\N
4753	\N	\N	\N	\N	\N	\N
4754	\N	\N	\N	\N	\N	\N
4755	\N	\N	\N	\N	\N	\N
4756	\N	\N	\N	\N	\N	\N
4757	\N	\N	\N	\N	\N	\N
4758	\N	\N	\N	\N	\N	\N
4759	\N	\N	\N	\N	\N	\N
4760	\N	\N	\N	\N	\N	\N
4761	\N	\N	\N	\N	\N	\N
4762	\N	\N	\N	\N	\N	\N
4763	\N	\N	\N	\N	\N	\N
4764	\N	\N	\N	\N	\N	\N
4765	\N	\N	\N	\N	\N	\N
4766	\N	\N	\N	\N	\N	\N
4767	\N	\N	\N	\N	\N	\N
4768	\N	\N	\N	\N	\N	\N
4769	\N	\N	\N	\N	\N	\N
4770	\N	\N	\N	\N	\N	\N
4771	\N	\N	\N	\N	\N	\N
4772	\N	\N	\N	\N	\N	\N
4773	\N	\N	\N	\N	\N	\N
4774	\N	\N	\N	\N	\N	\N
4775	\N	\N	\N	\N	\N	\N
4776	\N	\N	\N	\N	\N	\N
4777	\N	\N	\N	\N	\N	\N
4778	\N	\N	\N	\N	\N	\N
4779	\N	\N	\N	\N	\N	\N
4780	\N	\N	\N	\N	\N	\N
4781	\N	\N	\N	\N	\N	\N
4782	\N	\N	\N	\N	\N	\N
4783	\N	\N	\N	\N	\N	\N
4784	\N	\N	\N	\N	\N	\N
4785	\N	\N	\N	\N	\N	\N
4786	\N	\N	\N	\N	\N	\N
4787	\N	\N	\N	\N	\N	\N
4788	\N	\N	\N	\N	\N	\N
4789	\N	\N	\N	\N	\N	\N
4790	\N	\N	\N	\N	\N	\N
4791	\N	\N	\N	\N	\N	\N
4792	\N	\N	\N	\N	\N	\N
4793	\N	\N	\N	\N	\N	\N
4794	\N	\N	\N	\N	\N	\N
4795	\N	\N	\N	\N	\N	\N
4796	\N	\N	\N	\N	\N	\N
4797	\N	\N	\N	\N	\N	\N
4798	\N	\N	\N	\N	\N	\N
4799	\N	\N	\N	\N	\N	\N
4800	\N	\N	\N	\N	\N	\N
4801	\N	\N	\N	\N	\N	\N
4802	\N	\N	\N	\N	\N	\N
4803	\N	\N	\N	\N	\N	\N
4804	\N	\N	\N	\N	\N	\N
4805	\N	\N	\N	\N	\N	\N
4806	\N	\N	\N	\N	\N	\N
4807	\N	\N	\N	\N	\N	\N
4808	\N	\N	\N	\N	\N	\N
4809	\N	\N	\N	\N	\N	\N
4810	\N	\N	\N	\N	\N	\N
4811	\N	\N	\N	\N	\N	\N
4812	\N	\N	\N	\N	\N	\N
4813	\N	\N	\N	\N	\N	\N
4814	\N	\N	\N	\N	\N	\N
4815	\N	\N	\N	\N	\N	\N
4816	\N	\N	\N	\N	\N	\N
4817	\N	\N	\N	\N	\N	\N
4818	\N	\N	\N	\N	\N	\N
4819	\N	\N	\N	\N	\N	\N
4820	\N	\N	\N	\N	\N	\N
4821	\N	\N	\N	\N	\N	\N
4822	\N	\N	\N	\N	\N	\N
4823	\N	\N	\N	\N	\N	\N
4824	\N	\N	\N	\N	\N	\N
4825	\N	\N	\N	\N	\N	\N
4826	\N	\N	\N	\N	\N	\N
4827	\N	\N	\N	\N	\N	\N
4828	\N	\N	\N	\N	\N	\N
4829	\N	\N	\N	\N	\N	\N
4830	\N	\N	\N	\N	\N	\N
4831	\N	\N	\N	\N	\N	\N
4832	\N	\N	\N	\N	\N	\N
4833	\N	\N	\N	\N	\N	\N
4834	\N	\N	\N	\N	\N	\N
4835	\N	\N	\N	\N	\N	\N
4836	\N	\N	\N	\N	\N	\N
4837	\N	\N	\N	\N	\N	\N
4838	\N	\N	\N	\N	\N	\N
4839	\N	\N	\N	\N	\N	\N
4840	\N	\N	\N	\N	\N	\N
4841	\N	\N	\N	\N	\N	\N
4842	\N	\N	\N	\N	\N	\N
4843	\N	\N	\N	\N	\N	\N
4844	\N	\N	\N	\N	\N	\N
4845	\N	\N	\N	\N	\N	\N
4846	\N	\N	\N	\N	\N	\N
4847	\N	\N	\N	\N	\N	\N
4848	\N	\N	\N	\N	\N	\N
4849	\N	\N	\N	\N	\N	\N
4850	\N	\N	\N	\N	\N	\N
4851	\N	\N	\N	\N	\N	\N
4852	\N	\N	\N	\N	\N	\N
4853	\N	\N	\N	\N	\N	\N
4854	\N	\N	\N	\N	\N	\N
4855	\N	\N	\N	\N	\N	\N
4856	\N	\N	\N	\N	\N	\N
4857	\N	\N	\N	\N	\N	\N
4858	\N	\N	\N	\N	\N	\N
4859	\N	\N	\N	\N	\N	\N
4860	\N	\N	\N	\N	\N	\N
4861	\N	\N	\N	\N	\N	\N
4862	\N	\N	\N	\N	\N	\N
4863	\N	\N	\N	\N	\N	\N
4864	\N	\N	\N	\N	\N	\N
4865	\N	\N	\N	\N	\N	\N
4866	\N	\N	\N	\N	\N	\N
4867	\N	\N	\N	\N	\N	\N
4868	\N	\N	\N	\N	\N	\N
4869	\N	\N	\N	\N	\N	\N
4870	\N	\N	\N	\N	\N	\N
4871	\N	\N	\N	\N	\N	\N
4872	\N	\N	\N	\N	\N	\N
4873	\N	\N	\N	\N	\N	\N
4874	\N	\N	\N	\N	\N	\N
4875	\N	\N	\N	\N	\N	\N
4876	\N	\N	\N	\N	\N	\N
4877	\N	\N	\N	\N	\N	\N
4878	\N	\N	\N	\N	\N	\N
4879	\N	\N	\N	\N	\N	\N
4880	\N	\N	\N	\N	\N	\N
4881	\N	\N	\N	\N	\N	\N
4882	\N	\N	\N	\N	\N	\N
4883	\N	\N	\N	\N	\N	\N
4884	\N	\N	\N	\N	\N	\N
4885	\N	\N	\N	\N	\N	\N
4886	\N	\N	\N	\N	\N	\N
4887	\N	\N	\N	\N	\N	\N
4888	\N	\N	\N	\N	\N	\N
4889	\N	\N	\N	\N	\N	\N
4890	\N	\N	\N	\N	\N	\N
4891	\N	\N	\N	\N	\N	\N
4892	\N	\N	\N	\N	\N	\N
4893	\N	\N	\N	\N	\N	\N
4894	\N	\N	\N	\N	\N	\N
4895	\N	\N	\N	\N	\N	\N
4896	\N	\N	\N	\N	\N	\N
4897	\N	\N	\N	\N	\N	\N
4898	\N	\N	\N	\N	\N	\N
4899	\N	\N	\N	\N	\N	\N
4900	\N	\N	\N	\N	\N	\N
4901	\N	\N	\N	\N	\N	\N
4902	\N	\N	\N	\N	\N	\N
4903	\N	\N	\N	\N	\N	\N
4904	\N	\N	\N	\N	\N	\N
4905	\N	\N	\N	\N	\N	\N
4906	\N	\N	\N	\N	\N	\N
4907	\N	\N	\N	\N	\N	\N
4908	\N	\N	\N	\N	\N	\N
4909	\N	\N	\N	\N	\N	\N
4910	\N	\N	\N	\N	\N	\N
4911	\N	\N	\N	\N	\N	\N
4912	\N	\N	\N	\N	\N	\N
4913	\N	\N	\N	\N	\N	\N
4914	\N	\N	\N	\N	\N	\N
4915	\N	\N	\N	\N	\N	\N
4916	\N	\N	\N	\N	\N	\N
4917	\N	\N	\N	\N	\N	\N
4918	\N	\N	\N	\N	\N	\N
4919	\N	\N	\N	\N	\N	\N
4920	\N	\N	\N	\N	\N	\N
4921	\N	\N	\N	\N	\N	\N
4922	\N	\N	\N	\N	\N	\N
4923	\N	\N	\N	\N	\N	\N
4924	\N	\N	\N	\N	\N	\N
4925	\N	\N	\N	\N	\N	\N
4926	\N	\N	\N	\N	\N	\N
4927	\N	\N	\N	\N	\N	\N
4928	\N	\N	\N	\N	\N	\N
4929	\N	\N	\N	\N	\N	\N
4930	\N	\N	\N	\N	\N	\N
4931	\N	\N	\N	\N	\N	\N
4932	\N	\N	\N	\N	\N	\N
4933	\N	\N	\N	\N	\N	\N
4934	\N	\N	\N	\N	\N	\N
4935	\N	\N	\N	\N	\N	\N
4936	\N	\N	\N	\N	\N	\N
4937	\N	\N	\N	\N	\N	\N
4938	\N	\N	\N	\N	\N	\N
4939	\N	\N	\N	\N	\N	\N
4940	\N	\N	\N	\N	\N	\N
4941	\N	\N	\N	\N	\N	\N
4942	\N	\N	\N	\N	\N	\N
4943	\N	\N	\N	\N	\N	\N
4944	\N	\N	\N	\N	\N	\N
4945	\N	\N	\N	\N	\N	\N
4946	\N	\N	\N	\N	\N	\N
4947	\N	\N	\N	\N	\N	\N
4948	\N	\N	\N	\N	\N	\N
4949	\N	\N	\N	\N	\N	\N
4950	\N	\N	\N	\N	\N	\N
4951	\N	\N	\N	\N	\N	\N
4952	\N	\N	\N	\N	\N	\N
4953	\N	\N	\N	\N	\N	\N
4954	\N	\N	\N	\N	\N	\N
4955	\N	\N	\N	\N	\N	\N
4956	\N	\N	\N	\N	\N	\N
4957	\N	\N	\N	\N	\N	\N
4958	\N	\N	\N	\N	\N	\N
4959	\N	\N	\N	\N	\N	\N
4960	\N	\N	\N	\N	\N	\N
4961	\N	\N	\N	\N	\N	\N
4962	\N	\N	\N	\N	\N	\N
4963	\N	\N	\N	\N	\N	\N
4964	\N	\N	\N	\N	\N	\N
4965	\N	\N	\N	\N	\N	\N
4966	\N	\N	\N	\N	\N	\N
4967	\N	\N	\N	\N	\N	\N
4968	\N	\N	\N	\N	\N	\N
4969	\N	\N	\N	\N	\N	\N
4970	\N	\N	\N	\N	\N	\N
4971	\N	\N	\N	\N	\N	\N
4972	\N	\N	\N	\N	\N	\N
4973	\N	\N	\N	\N	\N	\N
4974	\N	\N	\N	\N	\N	\N
4975	\N	\N	\N	\N	\N	\N
4976	\N	\N	\N	\N	\N	\N
4977	\N	\N	\N	\N	\N	\N
4978	\N	\N	\N	\N	\N	\N
4979	\N	\N	\N	\N	\N	\N
4980	\N	\N	\N	\N	\N	\N
4981	\N	\N	\N	\N	\N	\N
4982	\N	\N	\N	\N	\N	\N
4983	\N	\N	\N	\N	\N	\N
4984	\N	\N	\N	\N	\N	\N
4985	\N	\N	\N	\N	\N	\N
4986	\N	\N	\N	\N	\N	\N
4987	\N	\N	\N	\N	\N	\N
4988	\N	\N	\N	\N	\N	\N
4989	\N	\N	\N	\N	\N	\N
4990	\N	\N	\N	\N	\N	\N
4991	\N	\N	\N	\N	\N	\N
4992	\N	\N	\N	\N	\N	\N
4993	\N	\N	\N	\N	\N	\N
4994	\N	\N	\N	\N	\N	\N
4995	\N	\N	\N	\N	\N	\N
4996	\N	\N	\N	\N	\N	\N
4997	\N	\N	\N	\N	\N	\N
4998	\N	\N	\N	\N	\N	\N
4999	\N	\N	\N	\N	\N	\N
5000	\N	\N	\N	\N	\N	\N
5001	\N	\N	\N	\N	\N	\N
5002	\N	\N	\N	\N	\N	\N
5003	\N	\N	\N	\N	\N	\N
5004	\N	\N	\N	\N	\N	\N
5005	\N	\N	\N	\N	\N	\N
5006	\N	\N	\N	\N	\N	\N
5007	\N	\N	\N	\N	\N	\N
5008	\N	\N	\N	\N	\N	\N
5009	\N	\N	\N	\N	\N	\N
5010	\N	\N	\N	\N	\N	\N
5011	\N	\N	\N	\N	\N	\N
5012	\N	\N	\N	\N	\N	\N
5013	\N	\N	\N	\N	\N	\N
5014	\N	\N	\N	\N	\N	\N
5015	\N	\N	\N	\N	\N	\N
5016	\N	\N	\N	\N	\N	\N
5017	\N	\N	\N	\N	\N	\N
5018	\N	\N	\N	\N	\N	\N
5019	\N	\N	\N	\N	\N	\N
5020	\N	\N	\N	\N	\N	\N
5021	\N	\N	\N	\N	\N	\N
5022	\N	\N	\N	\N	\N	\N
5023	\N	\N	\N	\N	\N	\N
5024	\N	\N	\N	\N	\N	\N
5025	\N	\N	\N	\N	\N	\N
5026	\N	\N	\N	\N	\N	\N
5027	\N	\N	\N	\N	\N	\N
5028	\N	\N	\N	\N	\N	\N
5029	\N	\N	\N	\N	\N	\N
5030	\N	\N	\N	\N	\N	\N
5031	\N	\N	\N	\N	\N	\N
5032	\N	\N	\N	\N	\N	\N
5033	\N	\N	\N	\N	\N	\N
5034	\N	\N	\N	\N	\N	\N
5035	\N	\N	\N	\N	\N	\N
5036	\N	\N	\N	\N	\N	\N
5037	\N	\N	\N	\N	\N	\N
5038	\N	\N	\N	\N	\N	\N
5039	\N	\N	\N	\N	\N	\N
5040	\N	\N	\N	\N	\N	\N
5041	\N	\N	\N	\N	\N	\N
5042	\N	\N	\N	\N	\N	\N
5043	\N	\N	\N	\N	\N	\N
5044	\N	\N	\N	\N	\N	\N
5045	\N	\N	\N	\N	\N	\N
5046	\N	\N	\N	\N	\N	\N
5047	\N	\N	\N	\N	\N	\N
5048	\N	\N	\N	\N	\N	\N
5049	\N	\N	\N	\N	\N	\N
5050	\N	\N	\N	\N	\N	\N
5051	\N	\N	\N	\N	\N	\N
5052	\N	\N	\N	\N	\N	\N
5053	\N	\N	\N	\N	\N	\N
5054	\N	\N	\N	\N	\N	\N
5055	\N	\N	\N	\N	\N	\N
5056	\N	\N	\N	\N	\N	\N
5057	\N	\N	\N	\N	\N	\N
5058	\N	\N	\N	\N	\N	\N
5059	\N	\N	\N	\N	\N	\N
5060	\N	\N	\N	\N	\N	\N
5061	\N	\N	\N	\N	\N	\N
5062	\N	\N	\N	\N	\N	\N
5063	\N	\N	\N	\N	\N	\N
5064	\N	\N	\N	\N	\N	\N
5065	\N	\N	\N	\N	\N	\N
5066	\N	\N	\N	\N	\N	\N
5067	\N	\N	\N	\N	\N	\N
5068	\N	\N	\N	\N	\N	\N
5069	\N	\N	\N	\N	\N	\N
5070	\N	\N	\N	\N	\N	\N
5071	\N	\N	\N	\N	\N	\N
5072	\N	\N	\N	\N	\N	\N
5073	\N	\N	\N	\N	\N	\N
5074	\N	\N	\N	\N	\N	\N
5075	\N	\N	\N	\N	\N	\N
5076	\N	\N	\N	\N	\N	\N
5077	\N	\N	\N	\N	\N	\N
5078	\N	\N	\N	\N	\N	\N
5079	\N	\N	\N	\N	\N	\N
5080	\N	\N	\N	\N	\N	\N
5081	\N	\N	\N	\N	\N	\N
5082	\N	\N	\N	\N	\N	\N
5083	\N	\N	\N	\N	\N	\N
5084	\N	\N	\N	\N	\N	\N
5085	\N	\N	\N	\N	\N	\N
5086	\N	\N	\N	\N	\N	\N
5087	\N	\N	\N	\N	\N	\N
5088	\N	\N	\N	\N	\N	\N
5089	\N	\N	\N	\N	\N	\N
5090	\N	\N	\N	\N	\N	\N
5091	\N	\N	\N	\N	\N	\N
5092	\N	\N	\N	\N	\N	\N
5093	\N	\N	\N	\N	\N	\N
5094	\N	\N	\N	\N	\N	\N
5095	\N	\N	\N	\N	\N	\N
5096	\N	\N	\N	\N	\N	\N
5097	\N	\N	\N	\N	\N	\N
5098	\N	\N	\N	\N	\N	\N
5099	\N	\N	\N	\N	\N	\N
5100	\N	\N	\N	\N	\N	\N
5101	\N	\N	\N	\N	\N	\N
5102	\N	\N	\N	\N	\N	\N
5103	\N	\N	\N	\N	\N	\N
5104	\N	\N	\N	\N	\N	\N
5105	\N	\N	\N	\N	\N	\N
5106	\N	\N	\N	\N	\N	\N
5107	\N	\N	\N	\N	\N	\N
5108	\N	\N	\N	\N	\N	\N
5109	\N	\N	\N	\N	\N	\N
5110	\N	\N	\N	\N	\N	\N
5111	\N	\N	\N	\N	\N	\N
5112	\N	\N	\N	\N	\N	\N
5113	\N	\N	\N	\N	\N	\N
5114	\N	\N	\N	\N	\N	\N
5115	\N	\N	\N	\N	\N	\N
5116	\N	\N	\N	\N	\N	\N
5117	\N	\N	\N	\N	\N	\N
5118	\N	\N	\N	\N	\N	\N
5119	\N	\N	\N	\N	\N	\N
5120	\N	\N	\N	\N	\N	\N
5121	\N	\N	\N	\N	\N	\N
5122	\N	\N	\N	\N	\N	\N
5123	\N	\N	\N	\N	\N	\N
5124	\N	\N	\N	\N	\N	\N
5125	\N	\N	\N	\N	\N	\N
5126	\N	\N	\N	\N	\N	\N
5127	\N	\N	\N	\N	\N	\N
5128	\N	\N	\N	\N	\N	\N
5129	\N	\N	\N	\N	\N	\N
5130	\N	\N	\N	\N	\N	\N
5131	\N	\N	\N	\N	\N	\N
5132	\N	\N	\N	\N	\N	\N
5133	\N	\N	\N	\N	\N	\N
5134	\N	\N	\N	\N	\N	\N
5135	\N	\N	\N	\N	\N	\N
5136	\N	\N	\N	\N	\N	\N
5137	\N	\N	\N	\N	\N	\N
5138	\N	\N	\N	\N	\N	\N
5139	\N	\N	\N	\N	\N	\N
5140	\N	\N	\N	\N	\N	\N
5141	\N	\N	\N	\N	\N	\N
5142	\N	\N	\N	\N	\N	\N
5143	\N	\N	\N	\N	\N	\N
5144	\N	\N	\N	\N	\N	\N
5145	\N	\N	\N	\N	\N	\N
5146	\N	\N	\N	\N	\N	\N
5147	\N	\N	\N	\N	\N	\N
5148	\N	\N	\N	\N	\N	\N
5149	\N	\N	\N	\N	\N	\N
5150	\N	\N	\N	\N	\N	\N
5151	\N	\N	\N	\N	\N	\N
5152	\N	\N	\N	\N	\N	\N
5153	\N	\N	\N	\N	\N	\N
5154	\N	\N	\N	\N	\N	\N
5155	\N	\N	\N	\N	\N	\N
5156	\N	\N	\N	\N	\N	\N
5157	\N	\N	\N	\N	\N	\N
5158	\N	\N	\N	\N	\N	\N
5159	\N	\N	\N	\N	\N	\N
5160	\N	\N	\N	\N	\N	\N
5161	\N	\N	\N	\N	\N	\N
5162	\N	\N	\N	\N	\N	\N
5163	\N	\N	\N	\N	\N	\N
5164	\N	\N	\N	\N	\N	\N
5165	\N	\N	\N	\N	\N	\N
5166	\N	\N	\N	\N	\N	\N
5167	\N	\N	\N	\N	\N	\N
5168	\N	\N	\N	\N	\N	\N
5169	\N	\N	\N	\N	\N	\N
5170	\N	\N	\N	\N	\N	\N
5171	\N	\N	\N	\N	\N	\N
5172	\N	\N	\N	\N	\N	\N
5173	\N	\N	\N	\N	\N	\N
5174	\N	\N	\N	\N	\N	\N
5175	\N	\N	\N	\N	\N	\N
5176	\N	\N	\N	\N	\N	\N
5177	\N	\N	\N	\N	\N	\N
5178	\N	\N	\N	\N	\N	\N
5179	\N	\N	\N	\N	\N	\N
5180	\N	\N	\N	\N	\N	\N
5181	\N	\N	\N	\N	\N	\N
5182	\N	\N	\N	\N	\N	\N
5183	\N	\N	\N	\N	\N	\N
5184	\N	\N	\N	\N	\N	\N
5185	\N	\N	\N	\N	\N	\N
5186	\N	\N	\N	\N	\N	\N
5187	\N	\N	\N	\N	\N	\N
5188	\N	\N	\N	\N	\N	\N
5189	\N	\N	\N	\N	\N	\N
5190	\N	\N	\N	\N	\N	\N
5191	\N	\N	\N	\N	\N	\N
5192	\N	\N	\N	\N	\N	\N
5193	\N	\N	\N	\N	\N	\N
5194	\N	\N	\N	\N	\N	\N
5195	\N	\N	\N	\N	\N	\N
5196	\N	\N	\N	\N	\N	\N
5197	\N	\N	\N	\N	\N	\N
5198	\N	\N	\N	\N	\N	\N
5199	\N	\N	\N	\N	\N	\N
5200	\N	\N	\N	\N	\N	\N
5201	\N	\N	\N	\N	\N	\N
5202	\N	\N	\N	\N	\N	\N
5203	\N	\N	\N	\N	\N	\N
5204	\N	\N	\N	\N	\N	\N
5205	\N	\N	\N	\N	\N	\N
5206	\N	\N	\N	\N	\N	\N
5207	\N	\N	\N	\N	\N	\N
5208	\N	\N	\N	\N	\N	\N
5209	\N	\N	\N	\N	\N	\N
5210	\N	\N	\N	\N	\N	\N
5211	\N	\N	\N	\N	\N	\N
5212	\N	\N	\N	\N	\N	\N
5213	\N	\N	\N	\N	\N	\N
5214	\N	\N	\N	\N	\N	\N
5215	\N	\N	\N	\N	\N	\N
5216	\N	\N	\N	\N	\N	\N
5217	\N	\N	\N	\N	\N	\N
5218	\N	\N	\N	\N	\N	\N
5219	\N	\N	\N	\N	\N	\N
5220	\N	\N	\N	\N	\N	\N
5221	\N	\N	\N	\N	\N	\N
5222	\N	\N	\N	\N	\N	\N
5223	\N	\N	\N	\N	\N	\N
5224	\N	\N	\N	\N	\N	\N
5225	\N	\N	\N	\N	\N	\N
5226	\N	\N	\N	\N	\N	\N
5227	\N	\N	\N	\N	\N	\N
5228	\N	\N	\N	\N	\N	\N
5229	\N	\N	\N	\N	\N	\N
5230	\N	\N	\N	\N	\N	\N
5231	\N	\N	\N	\N	\N	\N
5232	\N	\N	\N	\N	\N	\N
5233	\N	\N	\N	\N	\N	\N
5234	\N	\N	\N	\N	\N	\N
5235	\N	\N	\N	\N	\N	\N
5236	\N	\N	\N	\N	\N	\N
5237	\N	\N	\N	\N	\N	\N
5238	\N	\N	\N	\N	\N	\N
5239	\N	\N	\N	\N	\N	\N
5240	\N	\N	\N	\N	\N	\N
5241	\N	\N	\N	\N	\N	\N
5242	\N	\N	\N	\N	\N	\N
5243	\N	\N	\N	\N	\N	\N
5244	\N	\N	\N	\N	\N	\N
5245	\N	\N	\N	\N	\N	\N
5246	\N	\N	\N	\N	\N	\N
5247	\N	\N	\N	\N	\N	\N
5248	\N	\N	\N	\N	\N	\N
5249	\N	\N	\N	\N	\N	\N
5250	\N	\N	\N	\N	\N	\N
5251	\N	\N	\N	\N	\N	\N
5252	\N	\N	\N	\N	\N	\N
5253	\N	\N	\N	\N	\N	\N
5254	\N	\N	\N	\N	\N	\N
5255	\N	\N	\N	\N	\N	\N
5256	\N	\N	\N	\N	\N	\N
5257	\N	\N	\N	\N	\N	\N
5258	\N	\N	\N	\N	\N	\N
5259	\N	\N	\N	\N	\N	\N
5260	\N	\N	\N	\N	\N	\N
5261	\N	\N	\N	\N	\N	\N
5262	\N	\N	\N	\N	\N	\N
5263	\N	\N	\N	\N	\N	\N
5264	\N	\N	\N	\N	\N	\N
5265	\N	\N	\N	\N	\N	\N
5266	\N	\N	\N	\N	\N	\N
5267	\N	\N	\N	\N	\N	\N
5268	\N	\N	\N	\N	\N	\N
5269	\N	\N	\N	\N	\N	\N
5270	\N	\N	\N	\N	\N	\N
5271	\N	\N	\N	\N	\N	\N
5272	\N	\N	\N	\N	\N	\N
5273	\N	\N	\N	\N	\N	\N
5274	\N	\N	\N	\N	\N	\N
5275	\N	\N	\N	\N	\N	\N
5276	\N	\N	\N	\N	\N	\N
5277	\N	\N	\N	\N	\N	\N
5278	\N	\N	\N	\N	\N	\N
5279	\N	\N	\N	\N	\N	\N
5280	\N	\N	\N	\N	\N	\N
5281	\N	\N	\N	\N	\N	\N
5282	\N	\N	\N	\N	\N	\N
5283	\N	\N	\N	\N	\N	\N
5284	\N	\N	\N	\N	\N	\N
5285	\N	\N	\N	\N	\N	\N
5286	\N	\N	\N	\N	\N	\N
5287	\N	\N	\N	\N	\N	\N
5288	\N	\N	\N	\N	\N	\N
5289	\N	\N	\N	\N	\N	\N
5290	\N	\N	\N	\N	\N	\N
5291	\N	\N	\N	\N	\N	\N
5292	\N	\N	\N	\N	\N	\N
5293	\N	\N	\N	\N	\N	\N
5294	\N	\N	\N	\N	\N	\N
5295	\N	\N	\N	\N	\N	\N
5296	\N	\N	\N	\N	\N	\N
5297	\N	\N	\N	\N	\N	\N
5298	\N	\N	\N	\N	\N	\N
5299	\N	\N	\N	\N	\N	\N
5300	\N	\N	\N	\N	\N	\N
5301	\N	\N	\N	\N	\N	\N
5302	\N	\N	\N	\N	\N	\N
5303	\N	\N	\N	\N	\N	\N
5304	\N	\N	\N	\N	\N	\N
5305	\N	\N	\N	\N	\N	\N
5306	\N	\N	\N	\N	\N	\N
5307	\N	\N	\N	\N	\N	\N
5308	\N	\N	\N	\N	\N	\N
5309	\N	\N	\N	\N	\N	\N
5310	\N	\N	\N	\N	\N	\N
5311	\N	\N	\N	\N	\N	\N
5312	\N	\N	\N	\N	\N	\N
5313	\N	\N	\N	\N	\N	\N
5314	\N	\N	\N	\N	\N	\N
5315	\N	\N	\N	\N	\N	\N
5316	\N	\N	\N	\N	\N	\N
5317	\N	\N	\N	\N	\N	\N
5318	\N	\N	\N	\N	\N	\N
5319	\N	\N	\N	\N	\N	\N
5320	\N	\N	\N	\N	\N	\N
5321	\N	\N	\N	\N	\N	\N
5322	\N	\N	\N	\N	\N	\N
5323	\N	\N	\N	\N	\N	\N
5324	\N	\N	\N	\N	\N	\N
5325	\N	\N	\N	\N	\N	\N
5326	\N	\N	\N	\N	\N	\N
5327	\N	\N	\N	\N	\N	\N
5328	\N	\N	\N	\N	\N	\N
5329	\N	\N	\N	\N	\N	\N
5330	\N	\N	\N	\N	\N	\N
5331	\N	\N	\N	\N	\N	\N
5332	\N	\N	\N	\N	\N	\N
5333	\N	\N	\N	\N	\N	\N
5334	\N	\N	\N	\N	\N	\N
5335	\N	\N	\N	\N	\N	\N
5336	\N	\N	\N	\N	\N	\N
5337	\N	\N	\N	\N	\N	\N
5338	\N	\N	\N	\N	\N	\N
5339	\N	\N	\N	\N	\N	\N
5340	\N	\N	\N	\N	\N	\N
5341	\N	\N	\N	\N	\N	\N
5342	\N	\N	\N	\N	\N	\N
5343	\N	\N	\N	\N	\N	\N
5344	\N	\N	\N	\N	\N	\N
5345	\N	\N	\N	\N	\N	\N
5346	\N	\N	\N	\N	\N	\N
5347	\N	\N	\N	\N	\N	\N
5348	\N	\N	\N	\N	\N	\N
5349	\N	\N	\N	\N	\N	\N
5350	\N	\N	\N	\N	\N	\N
5351	\N	\N	\N	\N	\N	\N
5352	\N	\N	\N	\N	\N	\N
5353	\N	\N	\N	\N	\N	\N
5354	\N	\N	\N	\N	\N	\N
5355	\N	\N	\N	\N	\N	\N
5356	\N	\N	\N	\N	\N	\N
5357	\N	\N	\N	\N	\N	\N
5358	\N	\N	\N	\N	\N	\N
5359	\N	\N	\N	\N	\N	\N
5360	\N	\N	\N	\N	\N	\N
5361	\N	\N	\N	\N	\N	\N
5362	\N	\N	\N	\N	\N	\N
5363	\N	\N	\N	\N	\N	\N
5364	\N	\N	\N	\N	\N	\N
5365	\N	\N	\N	\N	\N	\N
5366	\N	\N	\N	\N	\N	\N
5367	\N	\N	\N	\N	\N	\N
5368	\N	\N	\N	\N	\N	\N
5369	\N	\N	\N	\N	\N	\N
5370	\N	\N	\N	\N	\N	\N
5371	\N	\N	\N	\N	\N	\N
5372	\N	\N	\N	\N	\N	\N
5373	\N	\N	\N	\N	\N	\N
5374	\N	\N	\N	\N	\N	\N
5375	\N	\N	\N	\N	\N	\N
5376	\N	\N	\N	\N	\N	\N
5377	\N	\N	\N	\N	\N	\N
5378	\N	\N	\N	\N	\N	\N
5379	\N	\N	\N	\N	\N	\N
5380	\N	\N	\N	\N	\N	\N
5381	\N	\N	\N	\N	\N	\N
5382	\N	\N	\N	\N	\N	\N
5383	\N	\N	\N	\N	\N	\N
5384	\N	\N	\N	\N	\N	\N
5385	\N	\N	\N	\N	\N	\N
5386	\N	\N	\N	\N	\N	\N
5387	\N	\N	\N	\N	\N	\N
5388	\N	\N	\N	\N	\N	\N
5389	\N	\N	\N	\N	\N	\N
5390	\N	\N	\N	\N	\N	\N
5391	\N	\N	\N	\N	\N	\N
5392	\N	\N	\N	\N	\N	\N
5393	\N	\N	\N	\N	\N	\N
5394	\N	\N	\N	\N	\N	\N
5395	\N	\N	\N	\N	\N	\N
5396	\N	\N	\N	\N	\N	\N
5397	\N	\N	\N	\N	\N	\N
5398	\N	\N	\N	\N	\N	\N
5399	\N	\N	\N	\N	\N	\N
5400	\N	\N	\N	\N	\N	\N
5401	\N	\N	\N	\N	\N	\N
5402	\N	\N	\N	\N	\N	\N
5403	\N	\N	\N	\N	\N	\N
5404	\N	\N	\N	\N	\N	\N
5405	\N	\N	\N	\N	\N	\N
5406	\N	\N	\N	\N	\N	\N
5407	\N	\N	\N	\N	\N	\N
5408	\N	\N	\N	\N	\N	\N
5409	\N	\N	\N	\N	\N	\N
5410	\N	\N	\N	\N	\N	\N
5411	\N	\N	\N	\N	\N	\N
5412	\N	\N	\N	\N	\N	\N
5413	\N	\N	\N	\N	\N	\N
5414	\N	\N	\N	\N	\N	\N
5415	\N	\N	\N	\N	\N	\N
5416	\N	\N	\N	\N	\N	\N
5417	\N	\N	\N	\N	\N	\N
5418	\N	\N	\N	\N	\N	\N
5419	\N	\N	\N	\N	\N	\N
5420	\N	\N	\N	\N	\N	\N
5421	\N	\N	\N	\N	\N	\N
5422	\N	\N	\N	\N	\N	\N
5423	\N	\N	\N	\N	\N	\N
5424	\N	\N	\N	\N	\N	\N
5425	\N	\N	\N	\N	\N	\N
5426	\N	\N	\N	\N	\N	\N
5427	\N	\N	\N	\N	\N	\N
5428	\N	\N	\N	\N	\N	\N
5429	\N	\N	\N	\N	\N	\N
5430	\N	\N	\N	\N	\N	\N
5431	\N	\N	\N	\N	\N	\N
5432	\N	\N	\N	\N	\N	\N
5433	\N	\N	\N	\N	\N	\N
5434	\N	\N	\N	\N	\N	\N
5435	\N	\N	\N	\N	\N	\N
5436	\N	\N	\N	\N	\N	\N
5437	\N	\N	\N	\N	\N	\N
5438	\N	\N	\N	\N	\N	\N
5439	\N	\N	\N	\N	\N	\N
5440	\N	\N	\N	\N	\N	\N
5441	\N	\N	\N	\N	\N	\N
5442	\N	\N	\N	\N	\N	\N
5443	\N	\N	\N	\N	\N	\N
5444	\N	\N	\N	\N	\N	\N
5445	\N	\N	\N	\N	\N	\N
5446	\N	\N	\N	\N	\N	\N
5447	\N	\N	\N	\N	\N	\N
5448	\N	\N	\N	\N	\N	\N
5449	\N	\N	\N	\N	\N	\N
5450	\N	\N	\N	\N	\N	\N
5451	\N	\N	\N	\N	\N	\N
5452	\N	\N	\N	\N	\N	\N
5453	\N	\N	\N	\N	\N	\N
5454	\N	\N	\N	\N	\N	\N
5455	\N	\N	\N	\N	\N	\N
5456	\N	\N	\N	\N	\N	\N
5457	\N	\N	\N	\N	\N	\N
5458	\N	\N	\N	\N	\N	\N
5459	\N	\N	\N	\N	\N	\N
5460	\N	\N	\N	\N	\N	\N
5461	\N	\N	\N	\N	\N	\N
5462	\N	\N	\N	\N	\N	\N
5463	\N	\N	\N	\N	\N	\N
5464	\N	\N	\N	\N	\N	\N
5465	\N	\N	\N	\N	\N	\N
5466	\N	\N	\N	\N	\N	\N
5467	\N	\N	\N	\N	\N	\N
5468	\N	\N	\N	\N	\N	\N
5469	\N	\N	\N	\N	\N	\N
5470	\N	\N	\N	\N	\N	\N
5471	\N	\N	\N	\N	\N	\N
5472	\N	\N	\N	\N	\N	\N
5473	\N	\N	\N	\N	\N	\N
5474	\N	\N	\N	\N	\N	\N
5475	\N	\N	\N	\N	\N	\N
5476	\N	\N	\N	\N	\N	\N
5477	\N	\N	\N	\N	\N	\N
5478	\N	\N	\N	\N	\N	\N
5479	\N	\N	\N	\N	\N	\N
5480	\N	\N	\N	\N	\N	\N
5481	\N	\N	\N	\N	\N	\N
5482	\N	\N	\N	\N	\N	\N
5483	\N	\N	\N	\N	\N	\N
5484	\N	\N	\N	\N	\N	\N
5485	\N	\N	\N	\N	\N	\N
5486	\N	\N	\N	\N	\N	\N
5487	\N	\N	\N	\N	\N	\N
5488	\N	\N	\N	\N	\N	\N
5489	\N	\N	\N	\N	\N	\N
5490	\N	\N	\N	\N	\N	\N
5491	\N	\N	\N	\N	\N	\N
5492	\N	\N	\N	\N	\N	\N
5493	\N	\N	\N	\N	\N	\N
5494	\N	\N	\N	\N	\N	\N
5495	\N	\N	\N	\N	\N	\N
5496	\N	\N	\N	\N	\N	\N
5497	\N	\N	\N	\N	\N	\N
5498	\N	\N	\N	\N	\N	\N
5499	\N	\N	\N	\N	\N	\N
5500	\N	\N	\N	\N	\N	\N
5501	\N	\N	\N	\N	\N	\N
5502	\N	\N	\N	\N	\N	\N
5503	\N	\N	\N	\N	\N	\N
5504	\N	\N	\N	\N	\N	\N
5505	\N	\N	\N	\N	\N	\N
5506	\N	\N	\N	\N	\N	\N
5507	\N	\N	\N	\N	\N	\N
5508	\N	\N	\N	\N	\N	\N
5509	\N	\N	\N	\N	\N	\N
5510	\N	\N	\N	\N	\N	\N
5511	\N	\N	\N	\N	\N	\N
5512	\N	\N	\N	\N	\N	\N
5513	\N	\N	\N	\N	\N	\N
5514	\N	\N	\N	\N	\N	\N
5515	\N	\N	\N	\N	\N	\N
5516	\N	\N	\N	\N	\N	\N
5517	\N	\N	\N	\N	\N	\N
5518	\N	\N	\N	\N	\N	\N
5519	\N	\N	\N	\N	\N	\N
5520	\N	\N	\N	\N	\N	\N
5521	\N	\N	\N	\N	\N	\N
5522	\N	\N	\N	\N	\N	\N
5523	\N	\N	\N	\N	\N	\N
5524	\N	\N	\N	\N	\N	\N
5525	\N	\N	\N	\N	\N	\N
5526	\N	\N	\N	\N	\N	\N
5527	\N	\N	\N	\N	\N	\N
5528	\N	\N	\N	\N	\N	\N
5529	\N	\N	\N	\N	\N	\N
5530	\N	\N	\N	\N	\N	\N
5531	\N	\N	\N	\N	\N	\N
5532	\N	\N	\N	\N	\N	\N
5533	\N	\N	\N	\N	\N	\N
5534	\N	\N	\N	\N	\N	\N
5535	\N	\N	\N	\N	\N	\N
5536	\N	\N	\N	\N	\N	\N
5537	\N	\N	\N	\N	\N	\N
5538	\N	\N	\N	\N	\N	\N
5539	\N	\N	\N	\N	\N	\N
5540	\N	\N	\N	\N	\N	\N
5541	\N	\N	\N	\N	\N	\N
5542	\N	\N	\N	\N	\N	\N
5543	\N	\N	\N	\N	\N	\N
5544	\N	\N	\N	\N	\N	\N
5545	\N	\N	\N	\N	\N	\N
5546	\N	\N	\N	\N	\N	\N
5547	\N	\N	\N	\N	\N	\N
5548	\N	\N	\N	\N	\N	\N
5549	\N	\N	\N	\N	\N	\N
5550	\N	\N	\N	\N	\N	\N
5551	\N	\N	\N	\N	\N	\N
5552	\N	\N	\N	\N	\N	\N
5553	\N	\N	\N	\N	\N	\N
5554	\N	\N	\N	\N	\N	\N
5555	\N	\N	\N	\N	\N	\N
5556	\N	\N	\N	\N	\N	\N
5557	\N	\N	\N	\N	\N	\N
5558	\N	\N	\N	\N	\N	\N
5559	\N	\N	\N	\N	\N	\N
5560	\N	\N	\N	\N	\N	\N
5561	\N	\N	\N	\N	\N	\N
5562	\N	\N	\N	\N	\N	\N
5563	\N	\N	\N	\N	\N	\N
5564	\N	\N	\N	\N	\N	\N
5565	\N	\N	\N	\N	\N	\N
5566	\N	\N	\N	\N	\N	\N
5567	\N	\N	\N	\N	\N	\N
5568	\N	\N	\N	\N	\N	\N
5569	\N	\N	\N	\N	\N	\N
5570	\N	\N	\N	\N	\N	\N
5571	\N	\N	\N	\N	\N	\N
5572	\N	\N	\N	\N	\N	\N
5573	\N	\N	\N	\N	\N	\N
5574	\N	\N	\N	\N	\N	\N
5575	\N	\N	\N	\N	\N	\N
5576	\N	\N	\N	\N	\N	\N
5577	\N	\N	\N	\N	\N	\N
5578	\N	\N	\N	\N	\N	\N
5579	\N	\N	\N	\N	\N	\N
5580	\N	\N	\N	\N	\N	\N
5581	\N	\N	\N	\N	\N	\N
5582	\N	\N	\N	\N	\N	\N
5583	\N	\N	\N	\N	\N	\N
5584	\N	\N	\N	\N	\N	\N
5585	\N	\N	\N	\N	\N	\N
5586	\N	\N	\N	\N	\N	\N
5587	\N	\N	\N	\N	\N	\N
5588	\N	\N	\N	\N	\N	\N
5589	\N	\N	\N	\N	\N	\N
5590	\N	\N	\N	\N	\N	\N
5591	\N	\N	\N	\N	\N	\N
5592	\N	\N	\N	\N	\N	\N
5593	\N	\N	\N	\N	\N	\N
5594	\N	\N	\N	\N	\N	\N
5595	\N	\N	\N	\N	\N	\N
5596	\N	\N	\N	\N	\N	\N
5597	\N	\N	\N	\N	\N	\N
5598	\N	\N	\N	\N	\N	\N
5599	\N	\N	\N	\N	\N	\N
5600	\N	\N	\N	\N	\N	\N
5601	\N	\N	\N	\N	\N	\N
5602	\N	\N	\N	\N	\N	\N
5603	\N	\N	\N	\N	\N	\N
5604	\N	\N	\N	\N	\N	\N
5605	\N	\N	\N	\N	\N	\N
5606	\N	\N	\N	\N	\N	\N
5607	\N	\N	\N	\N	\N	\N
5608	\N	\N	\N	\N	\N	\N
5609	\N	\N	\N	\N	\N	\N
5610	\N	\N	\N	\N	\N	\N
5611	\N	\N	\N	\N	\N	\N
5612	\N	\N	\N	\N	\N	\N
5613	\N	\N	\N	\N	\N	\N
5614	\N	\N	\N	\N	\N	\N
5615	\N	\N	\N	\N	\N	\N
5616	\N	\N	\N	\N	\N	\N
5617	\N	\N	\N	\N	\N	\N
5618	\N	\N	\N	\N	\N	\N
5619	\N	\N	\N	\N	\N	\N
5620	\N	\N	\N	\N	\N	\N
5621	\N	\N	\N	\N	\N	\N
5622	\N	\N	\N	\N	\N	\N
5623	\N	\N	\N	\N	\N	\N
5624	\N	\N	\N	\N	\N	\N
5625	\N	\N	\N	\N	\N	\N
5626	\N	\N	\N	\N	\N	\N
5627	\N	\N	\N	\N	\N	\N
5628	\N	\N	\N	\N	\N	\N
5629	\N	\N	\N	\N	\N	\N
5630	\N	\N	\N	\N	\N	\N
5631	\N	\N	\N	\N	\N	\N
5632	\N	\N	\N	\N	\N	\N
5633	\N	\N	\N	\N	\N	\N
5634	\N	\N	\N	\N	\N	\N
5635	\N	\N	\N	\N	\N	\N
5636	\N	\N	\N	\N	\N	\N
5637	\N	\N	\N	\N	\N	\N
5638	\N	\N	\N	\N	\N	\N
5639	\N	\N	\N	\N	\N	\N
5640	\N	\N	\N	\N	\N	\N
5641	\N	\N	\N	\N	\N	\N
5642	\N	\N	\N	\N	\N	\N
5643	\N	\N	\N	\N	\N	\N
5644	\N	\N	\N	\N	\N	\N
5645	\N	\N	\N	\N	\N	\N
5646	\N	\N	\N	\N	\N	\N
5647	\N	\N	\N	\N	\N	\N
5648	\N	\N	\N	\N	\N	\N
5649	\N	\N	\N	\N	\N	\N
5650	\N	\N	\N	\N	\N	\N
5651	\N	\N	\N	\N	\N	\N
5652	\N	\N	\N	\N	\N	\N
5653	\N	\N	\N	\N	\N	\N
5654	\N	\N	\N	\N	\N	\N
5655	\N	\N	\N	\N	\N	\N
5656	\N	\N	\N	\N	\N	\N
5657	\N	\N	\N	\N	\N	\N
5658	\N	\N	\N	\N	\N	\N
5659	\N	\N	\N	\N	\N	\N
5660	\N	\N	\N	\N	\N	\N
5661	\N	\N	\N	\N	\N	\N
5662	\N	\N	\N	\N	\N	\N
5663	\N	\N	\N	\N	\N	\N
5664	\N	\N	\N	\N	\N	\N
5665	\N	\N	\N	\N	\N	\N
5666	\N	\N	\N	\N	\N	\N
5667	\N	\N	\N	\N	\N	\N
5668	\N	\N	\N	\N	\N	\N
5669	\N	\N	\N	\N	\N	\N
5670	\N	\N	\N	\N	\N	\N
5671	\N	\N	\N	\N	\N	\N
5672	\N	\N	\N	\N	\N	\N
5673	\N	\N	\N	\N	\N	\N
5674	\N	\N	\N	\N	\N	\N
5675	\N	\N	\N	\N	\N	\N
5676	\N	\N	\N	\N	\N	\N
5677	\N	\N	\N	\N	\N	\N
5678	\N	\N	\N	\N	\N	\N
5679	\N	\N	\N	\N	\N	\N
5680	\N	\N	\N	\N	\N	\N
5681	\N	\N	\N	\N	\N	\N
5682	\N	\N	\N	\N	\N	\N
5683	\N	\N	\N	\N	\N	\N
5684	\N	\N	\N	\N	\N	\N
5685	\N	\N	\N	\N	\N	\N
5686	\N	\N	\N	\N	\N	\N
5687	\N	\N	\N	\N	\N	\N
5688	\N	\N	\N	\N	\N	\N
5689	\N	\N	\N	\N	\N	\N
5690	\N	\N	\N	\N	\N	\N
5691	\N	\N	\N	\N	\N	\N
5692	\N	\N	\N	\N	\N	\N
5693	\N	\N	\N	\N	\N	\N
5694	\N	\N	\N	\N	\N	\N
5695	\N	\N	\N	\N	\N	\N
5696	\N	\N	\N	\N	\N	\N
5697	\N	\N	\N	\N	\N	\N
5698	\N	\N	\N	\N	\N	\N
5699	\N	\N	\N	\N	\N	\N
5700	\N	\N	\N	\N	\N	\N
5701	\N	\N	\N	\N	\N	\N
5702	\N	\N	\N	\N	\N	\N
5703	\N	\N	\N	\N	\N	\N
5704	\N	\N	\N	\N	\N	\N
5705	\N	\N	\N	\N	\N	\N
5706	\N	\N	\N	\N	\N	\N
5707	\N	\N	\N	\N	\N	\N
5708	\N	\N	\N	\N	\N	\N
5709	\N	\N	\N	\N	\N	\N
5710	\N	\N	\N	\N	\N	\N
5711	\N	\N	\N	\N	\N	\N
5712	\N	\N	\N	\N	\N	\N
5713	\N	\N	\N	\N	\N	\N
5714	\N	\N	\N	\N	\N	\N
5715	\N	\N	\N	\N	\N	\N
5716	\N	\N	\N	\N	\N	\N
5717	\N	\N	\N	\N	\N	\N
5718	\N	\N	\N	\N	\N	\N
5719	\N	\N	\N	\N	\N	\N
5720	\N	\N	\N	\N	\N	\N
5721	\N	\N	\N	\N	\N	\N
5722	\N	\N	\N	\N	\N	\N
5723	\N	\N	\N	\N	\N	\N
5724	\N	\N	\N	\N	\N	\N
5725	\N	\N	\N	\N	\N	\N
5726	\N	\N	\N	\N	\N	\N
5727	\N	\N	\N	\N	\N	\N
5728	\N	\N	\N	\N	\N	\N
5729	\N	\N	\N	\N	\N	\N
5730	\N	\N	\N	\N	\N	\N
5731	\N	\N	\N	\N	\N	\N
5732	\N	\N	\N	\N	\N	\N
5733	\N	\N	\N	\N	\N	\N
5734	\N	\N	\N	\N	\N	\N
5735	\N	\N	\N	\N	\N	\N
5736	\N	\N	\N	\N	\N	\N
5737	\N	\N	\N	\N	\N	\N
5738	\N	\N	\N	\N	\N	\N
5739	\N	\N	\N	\N	\N	\N
5740	\N	\N	\N	\N	\N	\N
5741	\N	\N	\N	\N	\N	\N
5742	\N	\N	\N	\N	\N	\N
5743	\N	\N	\N	\N	\N	\N
5744	\N	\N	\N	\N	\N	\N
5745	\N	\N	\N	\N	\N	\N
5746	\N	\N	\N	\N	\N	\N
5747	\N	\N	\N	\N	\N	\N
5748	\N	\N	\N	\N	\N	\N
5749	\N	\N	\N	\N	\N	\N
5750	\N	\N	\N	\N	\N	\N
5751	\N	\N	\N	\N	\N	\N
5752	\N	\N	\N	\N	\N	\N
5753	\N	\N	\N	\N	\N	\N
5754	\N	\N	\N	\N	\N	\N
5755	\N	\N	\N	\N	\N	\N
5756	\N	\N	\N	\N	\N	\N
5757	\N	\N	\N	\N	\N	\N
5758	\N	\N	\N	\N	\N	\N
5759	\N	\N	\N	\N	\N	\N
5760	\N	\N	\N	\N	\N	\N
5761	\N	\N	\N	\N	\N	\N
5762	\N	\N	\N	\N	\N	\N
5763	\N	\N	\N	\N	\N	\N
5764	\N	\N	\N	\N	\N	\N
5765	\N	\N	\N	\N	\N	\N
5766	\N	\N	\N	\N	\N	\N
5767	\N	\N	\N	\N	\N	\N
5768	\N	\N	\N	\N	\N	\N
5769	\N	\N	\N	\N	\N	\N
5770	\N	\N	\N	\N	\N	\N
5771	\N	\N	\N	\N	\N	\N
5772	\N	\N	\N	\N	\N	\N
5773	\N	\N	\N	\N	\N	\N
5774	\N	\N	\N	\N	\N	\N
5775	\N	\N	\N	\N	\N	\N
5776	\N	\N	\N	\N	\N	\N
5777	\N	\N	\N	\N	\N	\N
5778	\N	\N	\N	\N	\N	\N
5779	\N	\N	\N	\N	\N	\N
5780	\N	\N	\N	\N	\N	\N
5781	\N	\N	\N	\N	\N	\N
5782	\N	\N	\N	\N	\N	\N
5783	\N	\N	\N	\N	\N	\N
5784	\N	\N	\N	\N	\N	\N
5785	\N	\N	\N	\N	\N	\N
5786	\N	\N	\N	\N	\N	\N
5787	\N	\N	\N	\N	\N	\N
5788	\N	\N	\N	\N	\N	\N
5789	\N	\N	\N	\N	\N	\N
5790	\N	\N	\N	\N	\N	\N
5791	\N	\N	\N	\N	\N	\N
5792	\N	\N	\N	\N	\N	\N
5793	\N	\N	\N	\N	\N	\N
5794	\N	\N	\N	\N	\N	\N
5795	\N	\N	\N	\N	\N	\N
5796	\N	\N	\N	\N	\N	\N
5797	\N	\N	\N	\N	\N	\N
5798	\N	\N	\N	\N	\N	\N
5799	\N	\N	\N	\N	\N	\N
5800	\N	\N	\N	\N	\N	\N
5801	\N	\N	\N	\N	\N	\N
5802	\N	\N	\N	\N	\N	\N
5803	\N	\N	\N	\N	\N	\N
5804	\N	\N	\N	\N	\N	\N
5805	\N	\N	\N	\N	\N	\N
5806	\N	\N	\N	\N	\N	\N
5807	\N	\N	\N	\N	\N	\N
5808	\N	\N	\N	\N	\N	\N
5809	\N	\N	\N	\N	\N	\N
5810	\N	\N	\N	\N	\N	\N
5811	\N	\N	\N	\N	\N	\N
5812	\N	\N	\N	\N	\N	\N
5813	\N	\N	\N	\N	\N	\N
5814	\N	\N	\N	\N	\N	\N
5815	\N	\N	\N	\N	\N	\N
5816	\N	\N	\N	\N	\N	\N
5817	\N	\N	\N	\N	\N	\N
5818	\N	\N	\N	\N	\N	\N
5819	\N	\N	\N	\N	\N	\N
5820	\N	\N	\N	\N	\N	\N
5821	\N	\N	\N	\N	\N	\N
5822	\N	\N	\N	\N	\N	\N
5823	\N	\N	\N	\N	\N	\N
5824	\N	\N	\N	\N	\N	\N
5825	\N	\N	\N	\N	\N	\N
5826	\N	\N	\N	\N	\N	\N
5827	\N	\N	\N	\N	\N	\N
5828	\N	\N	\N	\N	\N	\N
5829	\N	\N	\N	\N	\N	\N
5830	\N	\N	\N	\N	\N	\N
5831	\N	\N	\N	\N	\N	\N
5832	\N	\N	\N	\N	\N	\N
5833	\N	\N	\N	\N	\N	\N
5834	\N	\N	\N	\N	\N	\N
5835	\N	\N	\N	\N	\N	\N
5836	\N	\N	\N	\N	\N	\N
5837	\N	\N	\N	\N	\N	\N
5838	\N	\N	\N	\N	\N	\N
5839	\N	\N	\N	\N	\N	\N
5840	\N	\N	\N	\N	\N	\N
5841	\N	\N	\N	\N	\N	\N
5842	\N	\N	\N	\N	\N	\N
5843	\N	\N	\N	\N	\N	\N
5844	\N	\N	\N	\N	\N	\N
5845	\N	\N	\N	\N	\N	\N
5846	\N	\N	\N	\N	\N	\N
5847	\N	\N	\N	\N	\N	\N
5848	\N	\N	\N	\N	\N	\N
5849	\N	\N	\N	\N	\N	\N
5850	\N	\N	\N	\N	\N	\N
5851	\N	\N	\N	\N	\N	\N
5852	\N	\N	\N	\N	\N	\N
5853	\N	\N	\N	\N	\N	\N
5854	\N	\N	\N	\N	\N	\N
5855	\N	\N	\N	\N	\N	\N
5856	\N	\N	\N	\N	\N	\N
5857	\N	\N	\N	\N	\N	\N
5858	\N	\N	\N	\N	\N	\N
5859	\N	\N	\N	\N	\N	\N
5860	\N	\N	\N	\N	\N	\N
5861	\N	\N	\N	\N	\N	\N
5862	\N	\N	\N	\N	\N	\N
5863	\N	\N	\N	\N	\N	\N
5864	\N	\N	\N	\N	\N	\N
5865	\N	\N	\N	\N	\N	\N
5866	\N	\N	\N	\N	\N	\N
5867	\N	\N	\N	\N	\N	\N
5868	\N	\N	\N	\N	\N	\N
5869	\N	\N	\N	\N	\N	\N
5870	\N	\N	\N	\N	\N	\N
5871	\N	\N	\N	\N	\N	\N
5872	\N	\N	\N	\N	\N	\N
5873	\N	\N	\N	\N	\N	\N
5874	\N	\N	\N	\N	\N	\N
5875	\N	\N	\N	\N	\N	\N
5876	\N	\N	\N	\N	\N	\N
5877	\N	\N	\N	\N	\N	\N
5878	\N	\N	\N	\N	\N	\N
5879	\N	\N	\N	\N	\N	\N
5880	\N	\N	\N	\N	\N	\N
5881	\N	\N	\N	\N	\N	\N
5882	\N	\N	\N	\N	\N	\N
5883	\N	\N	\N	\N	\N	\N
5884	\N	\N	\N	\N	\N	\N
5885	\N	\N	\N	\N	\N	\N
5886	\N	\N	\N	\N	\N	\N
5887	\N	\N	\N	\N	\N	\N
5888	\N	\N	\N	\N	\N	\N
5889	\N	\N	\N	\N	\N	\N
5890	\N	\N	\N	\N	\N	\N
5891	\N	\N	\N	\N	\N	\N
5892	\N	\N	\N	\N	\N	\N
5893	\N	\N	\N	\N	\N	\N
5894	\N	\N	\N	\N	\N	\N
5895	\N	\N	\N	\N	\N	\N
5896	\N	\N	\N	\N	\N	\N
5897	\N	\N	\N	\N	\N	\N
5898	\N	\N	\N	\N	\N	\N
5899	\N	\N	\N	\N	\N	\N
5900	\N	\N	\N	\N	\N	\N
5901	\N	\N	\N	\N	\N	\N
5902	\N	\N	\N	\N	\N	\N
5903	\N	\N	\N	\N	\N	\N
5904	\N	\N	\N	\N	\N	\N
5905	\N	\N	\N	\N	\N	\N
5906	\N	\N	\N	\N	\N	\N
5907	\N	\N	\N	\N	\N	\N
5908	\N	\N	\N	\N	\N	\N
5909	\N	\N	\N	\N	\N	\N
5910	\N	\N	\N	\N	\N	\N
5911	\N	\N	\N	\N	\N	\N
5912	\N	\N	\N	\N	\N	\N
5913	\N	\N	\N	\N	\N	\N
5914	\N	\N	\N	\N	\N	\N
5915	\N	\N	\N	\N	\N	\N
5916	\N	\N	\N	\N	\N	\N
5917	\N	\N	\N	\N	\N	\N
5918	\N	\N	\N	\N	\N	\N
5919	\N	\N	\N	\N	\N	\N
5920	\N	\N	\N	\N	\N	\N
5921	\N	\N	\N	\N	\N	\N
5922	\N	\N	\N	\N	\N	\N
5923	\N	\N	\N	\N	\N	\N
5924	\N	\N	\N	\N	\N	\N
5925	\N	\N	\N	\N	\N	\N
5926	\N	\N	\N	\N	\N	\N
5927	\N	\N	\N	\N	\N	\N
5928	\N	\N	\N	\N	\N	\N
5929	\N	\N	\N	\N	\N	\N
5930	\N	\N	\N	\N	\N	\N
5931	\N	\N	\N	\N	\N	\N
5932	\N	\N	\N	\N	\N	\N
5933	\N	\N	\N	\N	\N	\N
5934	\N	\N	\N	\N	\N	\N
5935	\N	\N	\N	\N	\N	\N
5936	\N	\N	\N	\N	\N	\N
5937	\N	\N	\N	\N	\N	\N
5938	\N	\N	\N	\N	\N	\N
5939	\N	\N	\N	\N	\N	\N
5940	\N	\N	\N	\N	\N	\N
5941	\N	\N	\N	\N	\N	\N
5942	\N	\N	\N	\N	\N	\N
5943	\N	\N	\N	\N	\N	\N
5944	\N	\N	\N	\N	\N	\N
5945	\N	\N	\N	\N	\N	\N
5946	\N	\N	\N	\N	\N	\N
5947	\N	\N	\N	\N	\N	\N
5948	\N	\N	\N	\N	\N	\N
5949	\N	\N	\N	\N	\N	\N
5950	\N	\N	\N	\N	\N	\N
5951	\N	\N	\N	\N	\N	\N
5952	\N	\N	\N	\N	\N	\N
5953	\N	\N	\N	\N	\N	\N
5954	\N	\N	\N	\N	\N	\N
5955	\N	\N	\N	\N	\N	\N
5956	\N	\N	\N	\N	\N	\N
5957	\N	\N	\N	\N	\N	\N
5958	\N	\N	\N	\N	\N	\N
5959	\N	\N	\N	\N	\N	\N
5960	\N	\N	\N	\N	\N	\N
5961	\N	\N	\N	\N	\N	\N
5962	\N	\N	\N	\N	\N	\N
5963	\N	\N	\N	\N	\N	\N
5964	\N	\N	\N	\N	\N	\N
5965	\N	\N	\N	\N	\N	\N
5966	\N	\N	\N	\N	\N	\N
5967	\N	\N	\N	\N	\N	\N
5968	\N	\N	\N	\N	\N	\N
5969	\N	\N	\N	\N	\N	\N
5970	\N	\N	\N	\N	\N	\N
5971	\N	\N	\N	\N	\N	\N
5972	\N	\N	\N	\N	\N	\N
5973	\N	\N	\N	\N	\N	\N
5974	\N	\N	\N	\N	\N	\N
5975	\N	\N	\N	\N	\N	\N
5976	\N	\N	\N	\N	\N	\N
5977	\N	\N	\N	\N	\N	\N
5978	\N	\N	\N	\N	\N	\N
5979	\N	\N	\N	\N	\N	\N
5980	\N	\N	\N	\N	\N	\N
5981	\N	\N	\N	\N	\N	\N
5982	\N	\N	\N	\N	\N	\N
5983	\N	\N	\N	\N	\N	\N
5984	\N	\N	\N	\N	\N	\N
5985	\N	\N	\N	\N	\N	\N
5986	\N	\N	\N	\N	\N	\N
5987	\N	\N	\N	\N	\N	\N
5988	\N	\N	\N	\N	\N	\N
5989	\N	\N	\N	\N	\N	\N
5990	\N	\N	\N	\N	\N	\N
5991	\N	\N	\N	\N	\N	\N
5992	\N	\N	\N	\N	\N	\N
5993	\N	\N	\N	\N	\N	\N
5994	\N	\N	\N	\N	\N	\N
5995	\N	\N	\N	\N	\N	\N
5996	\N	\N	\N	\N	\N	\N
5997	\N	\N	\N	\N	\N	\N
5998	\N	\N	\N	\N	\N	\N
5999	\N	\N	\N	\N	\N	\N
6000	\N	\N	\N	\N	\N	\N
6001	\N	\N	\N	\N	\N	\N
6002	\N	\N	\N	\N	\N	\N
6003	\N	\N	\N	\N	\N	\N
6004	\N	\N	\N	\N	\N	\N
6005	\N	\N	\N	\N	\N	\N
6006	\N	\N	\N	\N	\N	\N
6007	\N	\N	\N	\N	\N	\N
6008	\N	\N	\N	\N	\N	\N
6009	\N	\N	\N	\N	\N	\N
6010	\N	\N	\N	\N	\N	\N
6011	\N	\N	\N	\N	\N	\N
6012	\N	\N	\N	\N	\N	\N
6013	\N	\N	\N	\N	\N	\N
6014	\N	\N	\N	\N	\N	\N
6015	\N	\N	\N	\N	\N	\N
6016	\N	\N	\N	\N	\N	\N
6017	\N	\N	\N	\N	\N	\N
6018	\N	\N	\N	\N	\N	\N
6019	\N	\N	\N	\N	\N	\N
6020	\N	\N	\N	\N	\N	\N
6021	\N	\N	\N	\N	\N	\N
6022	\N	\N	\N	\N	\N	\N
6023	\N	\N	\N	\N	\N	\N
6024	\N	\N	\N	\N	\N	\N
6025	\N	\N	\N	\N	\N	\N
6026	\N	\N	\N	\N	\N	\N
6027	\N	\N	\N	\N	\N	\N
6028	\N	\N	\N	\N	\N	\N
6029	\N	\N	\N	\N	\N	\N
6030	\N	\N	\N	\N	\N	\N
6031	\N	\N	\N	\N	\N	\N
6032	\N	\N	\N	\N	\N	\N
6033	\N	\N	\N	\N	\N	\N
6034	\N	\N	\N	\N	\N	\N
6035	\N	\N	\N	\N	\N	\N
6036	\N	\N	\N	\N	\N	\N
6037	\N	\N	\N	\N	\N	\N
6038	\N	\N	\N	\N	\N	\N
6039	\N	\N	\N	\N	\N	\N
6040	\N	\N	\N	\N	\N	\N
6041	\N	\N	\N	\N	\N	\N
6042	\N	\N	\N	\N	\N	\N
6043	\N	\N	\N	\N	\N	\N
6044	\N	\N	\N	\N	\N	\N
6045	\N	\N	\N	\N	\N	\N
6046	\N	\N	\N	\N	\N	\N
6047	\N	\N	\N	\N	\N	\N
6048	\N	\N	\N	\N	\N	\N
6049	\N	\N	\N	\N	\N	\N
6050	\N	\N	\N	\N	\N	\N
6051	\N	\N	\N	\N	\N	\N
6052	\N	\N	\N	\N	\N	\N
6053	\N	\N	\N	\N	\N	\N
6054	\N	\N	\N	\N	\N	\N
6055	\N	\N	\N	\N	\N	\N
6056	\N	\N	\N	\N	\N	\N
6057	\N	\N	\N	\N	\N	\N
6058	\N	\N	\N	\N	\N	\N
6059	\N	\N	\N	\N	\N	\N
6060	\N	\N	\N	\N	\N	\N
6061	\N	\N	\N	\N	\N	\N
6062	\N	\N	\N	\N	\N	\N
6063	\N	\N	\N	\N	\N	\N
6064	\N	\N	\N	\N	\N	\N
6065	\N	\N	\N	\N	\N	\N
6066	\N	\N	\N	\N	\N	\N
6067	\N	\N	\N	\N	\N	\N
6068	\N	\N	\N	\N	\N	\N
6069	\N	\N	\N	\N	\N	\N
6070	\N	\N	\N	\N	\N	\N
6071	\N	\N	\N	\N	\N	\N
6072	\N	\N	\N	\N	\N	\N
6073	\N	\N	\N	\N	\N	\N
6074	\N	\N	\N	\N	\N	\N
6075	\N	\N	\N	\N	\N	\N
6076	\N	\N	\N	\N	\N	\N
6077	\N	\N	\N	\N	\N	\N
6078	\N	\N	\N	\N	\N	\N
6079	\N	\N	\N	\N	\N	\N
6080	\N	\N	\N	\N	\N	\N
6081	\N	\N	\N	\N	\N	\N
6082	\N	\N	\N	\N	\N	\N
6083	\N	\N	\N	\N	\N	\N
6084	\N	\N	\N	\N	\N	\N
6085	\N	\N	\N	\N	\N	\N
6086	\N	\N	\N	\N	\N	\N
6087	\N	\N	\N	\N	\N	\N
6088	\N	\N	\N	\N	\N	\N
6089	\N	\N	\N	\N	\N	\N
6090	\N	\N	\N	\N	\N	\N
6091	\N	\N	\N	\N	\N	\N
6092	\N	\N	\N	\N	\N	\N
6093	\N	\N	\N	\N	\N	\N
6094	\N	\N	\N	\N	\N	\N
6095	\N	\N	\N	\N	\N	\N
6096	\N	\N	\N	\N	\N	\N
6097	\N	\N	\N	\N	\N	\N
6098	\N	\N	\N	\N	\N	\N
6099	\N	\N	\N	\N	\N	\N
6100	\N	\N	\N	\N	\N	\N
6101	\N	\N	\N	\N	\N	\N
6102	\N	\N	\N	\N	\N	\N
6103	\N	\N	\N	\N	\N	\N
6104	\N	\N	\N	\N	\N	\N
6105	\N	\N	\N	\N	\N	\N
6106	\N	\N	\N	\N	\N	\N
6107	\N	\N	\N	\N	\N	\N
6108	\N	\N	\N	\N	\N	\N
6109	\N	\N	\N	\N	\N	\N
6110	\N	\N	\N	\N	\N	\N
6111	\N	\N	\N	\N	\N	\N
6112	\N	\N	\N	\N	\N	\N
6113	\N	\N	\N	\N	\N	\N
6114	\N	\N	\N	\N	\N	\N
6115	\N	\N	\N	\N	\N	\N
6116	\N	\N	\N	\N	\N	\N
6117	\N	\N	\N	\N	\N	\N
6118	\N	\N	\N	\N	\N	\N
6119	\N	\N	\N	\N	\N	\N
6120	\N	\N	\N	\N	\N	\N
6121	\N	\N	\N	\N	\N	\N
6122	\N	\N	\N	\N	\N	\N
6123	\N	\N	\N	\N	\N	\N
6124	\N	\N	\N	\N	\N	\N
6125	\N	\N	\N	\N	\N	\N
6126	\N	\N	\N	\N	\N	\N
6127	\N	\N	\N	\N	\N	\N
6128	\N	\N	\N	\N	\N	\N
6129	\N	\N	\N	\N	\N	\N
6130	\N	\N	\N	\N	\N	\N
6131	\N	\N	\N	\N	\N	\N
6132	\N	\N	\N	\N	\N	\N
6133	\N	\N	\N	\N	\N	\N
6134	\N	\N	\N	\N	\N	\N
6135	\N	\N	\N	\N	\N	\N
6136	\N	\N	\N	\N	\N	\N
6137	\N	\N	\N	\N	\N	\N
6138	\N	\N	\N	\N	\N	\N
6139	\N	\N	\N	\N	\N	\N
6140	\N	\N	\N	\N	\N	\N
6141	\N	\N	\N	\N	\N	\N
6142	\N	\N	\N	\N	\N	\N
6143	\N	\N	\N	\N	\N	\N
6144	\N	\N	\N	\N	\N	\N
6145	\N	\N	\N	\N	\N	\N
6146	\N	\N	\N	\N	\N	\N
6147	\N	\N	\N	\N	\N	\N
6148	\N	\N	\N	\N	\N	\N
6149	\N	\N	\N	\N	\N	\N
6150	\N	\N	\N	\N	\N	\N
6151	\N	\N	\N	\N	\N	\N
6152	\N	\N	\N	\N	\N	\N
6153	\N	\N	\N	\N	\N	\N
6154	\N	\N	\N	\N	\N	\N
6155	\N	\N	\N	\N	\N	\N
6156	\N	\N	\N	\N	\N	\N
6157	\N	\N	\N	\N	\N	\N
6158	\N	\N	\N	\N	\N	\N
6159	\N	\N	\N	\N	\N	\N
6160	\N	\N	\N	\N	\N	\N
6161	\N	\N	\N	\N	\N	\N
6162	\N	\N	\N	\N	\N	\N
6163	\N	\N	\N	\N	\N	\N
6164	\N	\N	\N	\N	\N	\N
6165	\N	\N	\N	\N	\N	\N
6166	\N	\N	\N	\N	\N	\N
6167	\N	\N	\N	\N	\N	\N
6168	\N	\N	\N	\N	\N	\N
6169	\N	\N	\N	\N	\N	\N
6170	\N	\N	\N	\N	\N	\N
6171	\N	\N	\N	\N	\N	\N
6172	\N	\N	\N	\N	\N	\N
6173	\N	\N	\N	\N	\N	\N
6174	\N	\N	\N	\N	\N	\N
6175	\N	\N	\N	\N	\N	\N
6176	\N	\N	\N	\N	\N	\N
6177	\N	\N	\N	\N	\N	\N
6178	\N	\N	\N	\N	\N	\N
6179	\N	\N	\N	\N	\N	\N
6180	\N	\N	\N	\N	\N	\N
6181	\N	\N	\N	\N	\N	\N
6182	\N	\N	\N	\N	\N	\N
6183	\N	\N	\N	\N	\N	\N
6184	\N	\N	\N	\N	\N	\N
6185	\N	\N	\N	\N	\N	\N
6186	\N	\N	\N	\N	\N	\N
6187	\N	\N	\N	\N	\N	\N
6188	\N	\N	\N	\N	\N	\N
6189	\N	\N	\N	\N	\N	\N
6190	\N	\N	\N	\N	\N	\N
6191	\N	\N	\N	\N	\N	\N
6192	\N	\N	\N	\N	\N	\N
6193	\N	\N	\N	\N	\N	\N
6194	\N	\N	\N	\N	\N	\N
6195	\N	\N	\N	\N	\N	\N
6196	\N	\N	\N	\N	\N	\N
6197	\N	\N	\N	\N	\N	\N
6198	\N	\N	\N	\N	\N	\N
6199	\N	\N	\N	\N	\N	\N
6200	\N	\N	\N	\N	\N	\N
6201	\N	\N	\N	\N	\N	\N
6202	\N	\N	\N	\N	\N	\N
6203	\N	\N	\N	\N	\N	\N
6204	\N	\N	\N	\N	\N	\N
6205	\N	\N	\N	\N	\N	\N
6206	\N	\N	\N	\N	\N	\N
6207	\N	\N	\N	\N	\N	\N
6208	\N	\N	\N	\N	\N	\N
6209	\N	\N	\N	\N	\N	\N
6210	\N	\N	\N	\N	\N	\N
6211	\N	\N	\N	\N	\N	\N
6212	\N	\N	\N	\N	\N	\N
6213	\N	\N	\N	\N	\N	\N
6214	\N	\N	\N	\N	\N	\N
6215	\N	\N	\N	\N	\N	\N
6216	\N	\N	\N	\N	\N	\N
6217	\N	\N	\N	\N	\N	\N
6218	\N	\N	\N	\N	\N	\N
6219	\N	\N	\N	\N	\N	\N
6220	\N	\N	\N	\N	\N	\N
6221	\N	\N	\N	\N	\N	\N
6222	\N	\N	\N	\N	\N	\N
6223	\N	\N	\N	\N	\N	\N
6224	\N	\N	\N	\N	\N	\N
6225	\N	\N	\N	\N	\N	\N
6226	\N	\N	\N	\N	\N	\N
6227	\N	\N	\N	\N	\N	\N
6228	\N	\N	\N	\N	\N	\N
6229	\N	\N	\N	\N	\N	\N
6230	\N	\N	\N	\N	\N	\N
6231	\N	\N	\N	\N	\N	\N
6232	\N	\N	\N	\N	\N	\N
6233	\N	\N	\N	\N	\N	\N
6234	\N	\N	\N	\N	\N	\N
6235	\N	\N	\N	\N	\N	\N
6236	\N	\N	\N	\N	\N	\N
6237	\N	\N	\N	\N	\N	\N
6238	\N	\N	\N	\N	\N	\N
6239	\N	\N	\N	\N	\N	\N
6240	\N	\N	\N	\N	\N	\N
6241	\N	\N	\N	\N	\N	\N
6242	\N	\N	\N	\N	\N	\N
6243	\N	\N	\N	\N	\N	\N
6244	\N	\N	\N	\N	\N	\N
6245	\N	\N	\N	\N	\N	\N
6246	\N	\N	\N	\N	\N	\N
6247	\N	\N	\N	\N	\N	\N
6248	\N	\N	\N	\N	\N	\N
6249	\N	\N	\N	\N	\N	\N
6250	\N	\N	\N	\N	\N	\N
6251	\N	\N	\N	\N	\N	\N
6252	\N	\N	\N	\N	\N	\N
6253	\N	\N	\N	\N	\N	\N
6254	\N	\N	\N	\N	\N	\N
6255	\N	\N	\N	\N	\N	\N
6256	\N	\N	\N	\N	\N	\N
6257	\N	\N	\N	\N	\N	\N
6258	\N	\N	\N	\N	\N	\N
6259	\N	\N	\N	\N	\N	\N
6260	\N	\N	\N	\N	\N	\N
6261	\N	\N	\N	\N	\N	\N
6262	\N	\N	\N	\N	\N	\N
6263	\N	\N	\N	\N	\N	\N
6264	\N	\N	\N	\N	\N	\N
6265	\N	\N	\N	\N	\N	\N
6266	\N	\N	\N	\N	\N	\N
6267	\N	\N	\N	\N	\N	\N
6268	\N	\N	\N	\N	\N	\N
6269	\N	\N	\N	\N	\N	\N
6270	\N	\N	\N	\N	\N	\N
6271	\N	\N	\N	\N	\N	\N
6272	\N	\N	\N	\N	\N	\N
6273	\N	\N	\N	\N	\N	\N
6274	\N	\N	\N	\N	\N	\N
6275	\N	\N	\N	\N	\N	\N
6276	\N	\N	\N	\N	\N	\N
6277	\N	\N	\N	\N	\N	\N
6278	\N	\N	\N	\N	\N	\N
6279	\N	\N	\N	\N	\N	\N
6280	\N	\N	\N	\N	\N	\N
6281	\N	\N	\N	\N	\N	\N
6282	\N	\N	\N	\N	\N	\N
6283	\N	\N	\N	\N	\N	\N
6284	\N	\N	\N	\N	\N	\N
6285	\N	\N	\N	\N	\N	\N
6286	\N	\N	\N	\N	\N	\N
6287	\N	\N	\N	\N	\N	\N
6288	\N	\N	\N	\N	\N	\N
6289	\N	\N	\N	\N	\N	\N
6290	\N	\N	\N	\N	\N	\N
6291	\N	\N	\N	\N	\N	\N
6292	\N	\N	\N	\N	\N	\N
6293	\N	\N	\N	\N	\N	\N
6294	\N	\N	\N	\N	\N	\N
6295	\N	\N	\N	\N	\N	\N
6296	\N	\N	\N	\N	\N	\N
6297	\N	\N	\N	\N	\N	\N
6298	\N	\N	\N	\N	\N	\N
6299	\N	\N	\N	\N	\N	\N
6300	\N	\N	\N	\N	\N	\N
6301	\N	\N	\N	\N	\N	\N
6302	\N	\N	\N	\N	\N	\N
6303	\N	\N	\N	\N	\N	\N
6304	\N	\N	\N	\N	\N	\N
6305	\N	\N	\N	\N	\N	\N
6306	\N	\N	\N	\N	\N	\N
6307	\N	\N	\N	\N	\N	\N
6308	\N	\N	\N	\N	\N	\N
6309	\N	\N	\N	\N	\N	\N
6310	\N	\N	\N	\N	\N	\N
6311	\N	\N	\N	\N	\N	\N
6312	\N	\N	\N	\N	\N	\N
6313	\N	\N	\N	\N	\N	\N
6314	\N	\N	\N	\N	\N	\N
6315	\N	\N	\N	\N	\N	\N
6316	\N	\N	\N	\N	\N	\N
6317	\N	\N	\N	\N	\N	\N
6318	\N	\N	\N	\N	\N	\N
6319	\N	\N	\N	\N	\N	\N
6320	\N	\N	\N	\N	\N	\N
6321	\N	\N	\N	\N	\N	\N
6322	\N	\N	\N	\N	\N	\N
6323	\N	\N	\N	\N	\N	\N
6324	\N	\N	\N	\N	\N	\N
6325	\N	\N	\N	\N	\N	\N
6326	\N	\N	\N	\N	\N	\N
6327	\N	\N	\N	\N	\N	\N
6328	\N	\N	\N	\N	\N	\N
6329	\N	\N	\N	\N	\N	\N
6330	\N	\N	\N	\N	\N	\N
6331	\N	\N	\N	\N	\N	\N
6332	\N	\N	\N	\N	\N	\N
6333	\N	\N	\N	\N	\N	\N
6334	\N	\N	\N	\N	\N	\N
6335	\N	\N	\N	\N	\N	\N
6336	\N	\N	\N	\N	\N	\N
6337	\N	\N	\N	\N	\N	\N
6338	\N	\N	\N	\N	\N	\N
6339	\N	\N	\N	\N	\N	\N
6340	\N	\N	\N	\N	\N	\N
6341	\N	\N	\N	\N	\N	\N
6342	\N	\N	\N	\N	\N	\N
6343	\N	\N	\N	\N	\N	\N
6344	\N	\N	\N	\N	\N	\N
6345	\N	\N	\N	\N	\N	\N
6346	\N	\N	\N	\N	\N	\N
6347	\N	\N	\N	\N	\N	\N
6348	\N	\N	\N	\N	\N	\N
6349	\N	\N	\N	\N	\N	\N
6350	\N	\N	\N	\N	\N	\N
6351	\N	\N	\N	\N	\N	\N
6352	\N	\N	\N	\N	\N	\N
6353	\N	\N	\N	\N	\N	\N
6354	\N	\N	\N	\N	\N	\N
6355	\N	\N	\N	\N	\N	\N
6356	\N	\N	\N	\N	\N	\N
6357	\N	\N	\N	\N	\N	\N
6358	\N	\N	\N	\N	\N	\N
6359	\N	\N	\N	\N	\N	\N
6360	\N	\N	\N	\N	\N	\N
6361	\N	\N	\N	\N	\N	\N
6362	\N	\N	\N	\N	\N	\N
6363	\N	\N	\N	\N	\N	\N
6364	\N	\N	\N	\N	\N	\N
6365	\N	\N	\N	\N	\N	\N
6366	\N	\N	\N	\N	\N	\N
6367	\N	\N	\N	\N	\N	\N
6368	\N	\N	\N	\N	\N	\N
6369	\N	\N	\N	\N	\N	\N
6370	\N	\N	\N	\N	\N	\N
6371	\N	\N	\N	\N	\N	\N
6372	\N	\N	\N	\N	\N	\N
6373	\N	\N	\N	\N	\N	\N
6374	\N	\N	\N	\N	\N	\N
6375	\N	\N	\N	\N	\N	\N
6376	\N	\N	\N	\N	\N	\N
6377	\N	\N	\N	\N	\N	\N
6378	\N	\N	\N	\N	\N	\N
6379	\N	\N	\N	\N	\N	\N
6380	\N	\N	\N	\N	\N	\N
6381	\N	\N	\N	\N	\N	\N
6382	\N	\N	\N	\N	\N	\N
6383	\N	\N	\N	\N	\N	\N
6384	\N	\N	\N	\N	\N	\N
6385	\N	\N	\N	\N	\N	\N
6386	\N	\N	\N	\N	\N	\N
6387	\N	\N	\N	\N	\N	\N
6388	\N	\N	\N	\N	\N	\N
6389	\N	\N	\N	\N	\N	\N
6390	\N	\N	\N	\N	\N	\N
6391	\N	\N	\N	\N	\N	\N
6392	\N	\N	\N	\N	\N	\N
6393	\N	\N	\N	\N	\N	\N
6394	\N	\N	\N	\N	\N	\N
6395	\N	\N	\N	\N	\N	\N
6396	\N	\N	\N	\N	\N	\N
6397	\N	\N	\N	\N	\N	\N
6398	\N	\N	\N	\N	\N	\N
6399	\N	\N	\N	\N	\N	\N
6400	\N	\N	\N	\N	\N	\N
6401	\N	\N	\N	\N	\N	\N
6402	\N	\N	\N	\N	\N	\N
6403	\N	\N	\N	\N	\N	\N
6404	\N	\N	\N	\N	\N	\N
6405	\N	\N	\N	\N	\N	\N
6406	\N	\N	\N	\N	\N	\N
6407	\N	\N	\N	\N	\N	\N
6408	\N	\N	\N	\N	\N	\N
6409	\N	\N	\N	\N	\N	\N
6410	\N	\N	\N	\N	\N	\N
6411	\N	\N	\N	\N	\N	\N
6412	\N	\N	\N	\N	\N	\N
6413	\N	\N	\N	\N	\N	\N
6414	\N	\N	\N	\N	\N	\N
6415	\N	\N	\N	\N	\N	\N
6416	\N	\N	\N	\N	\N	\N
6417	\N	\N	\N	\N	\N	\N
6418	\N	\N	\N	\N	\N	\N
6419	\N	\N	\N	\N	\N	\N
6420	\N	\N	\N	\N	\N	\N
6421	\N	\N	\N	\N	\N	\N
6422	\N	\N	\N	\N	\N	\N
6423	\N	\N	\N	\N	\N	\N
6424	\N	\N	\N	\N	\N	\N
6425	\N	\N	\N	\N	\N	\N
6426	\N	\N	\N	\N	\N	\N
6427	\N	\N	\N	\N	\N	\N
6428	\N	\N	\N	\N	\N	\N
6429	\N	\N	\N	\N	\N	\N
6430	\N	\N	\N	\N	\N	\N
6431	\N	\N	\N	\N	\N	\N
6432	\N	\N	\N	\N	\N	\N
6433	\N	\N	\N	\N	\N	\N
6434	\N	\N	\N	\N	\N	\N
6435	\N	\N	\N	\N	\N	\N
6436	\N	\N	\N	\N	\N	\N
6437	\N	\N	\N	\N	\N	\N
6438	\N	\N	\N	\N	\N	\N
6439	\N	\N	\N	\N	\N	\N
6440	\N	\N	\N	\N	\N	\N
6441	\N	\N	\N	\N	\N	\N
6442	\N	\N	\N	\N	\N	\N
6443	\N	\N	\N	\N	\N	\N
6444	\N	\N	\N	\N	\N	\N
6445	\N	\N	\N	\N	\N	\N
6446	\N	\N	\N	\N	\N	\N
6447	\N	\N	\N	\N	\N	\N
6448	\N	\N	\N	\N	\N	\N
6449	\N	\N	\N	\N	\N	\N
6450	\N	\N	\N	\N	\N	\N
6451	\N	\N	\N	\N	\N	\N
6452	\N	\N	\N	\N	\N	\N
6453	\N	\N	\N	\N	\N	\N
6454	\N	\N	\N	\N	\N	\N
6455	\N	\N	\N	\N	\N	\N
6456	\N	\N	\N	\N	\N	\N
6457	\N	\N	\N	\N	\N	\N
6458	\N	\N	\N	\N	\N	\N
6459	\N	\N	\N	\N	\N	\N
6460	\N	\N	\N	\N	\N	\N
6461	\N	\N	\N	\N	\N	\N
6462	\N	\N	\N	\N	\N	\N
6463	\N	\N	\N	\N	\N	\N
6464	\N	\N	\N	\N	\N	\N
6465	\N	\N	\N	\N	\N	\N
6466	\N	\N	\N	\N	\N	\N
6467	\N	\N	\N	\N	\N	\N
6468	\N	\N	\N	\N	\N	\N
6469	\N	\N	\N	\N	\N	\N
6470	\N	\N	\N	\N	\N	\N
6471	\N	\N	\N	\N	\N	\N
6472	\N	\N	\N	\N	\N	\N
6473	\N	\N	\N	\N	\N	\N
6474	\N	\N	\N	\N	\N	\N
6475	\N	\N	\N	\N	\N	\N
6476	\N	\N	\N	\N	\N	\N
6477	\N	\N	\N	\N	\N	\N
6478	\N	\N	\N	\N	\N	\N
6479	\N	\N	\N	\N	\N	\N
6480	\N	\N	\N	\N	\N	\N
6481	\N	\N	\N	\N	\N	\N
6482	\N	\N	\N	\N	\N	\N
6483	\N	\N	\N	\N	\N	\N
6484	\N	\N	\N	\N	\N	\N
6485	\N	\N	\N	\N	\N	\N
6486	\N	\N	\N	\N	\N	\N
6487	\N	\N	\N	\N	\N	\N
6488	\N	\N	\N	\N	\N	\N
6489	\N	\N	\N	\N	\N	\N
6490	\N	\N	\N	\N	\N	\N
6491	\N	\N	\N	\N	\N	\N
6492	\N	\N	\N	\N	\N	\N
6493	\N	\N	\N	\N	\N	\N
6494	\N	\N	\N	\N	\N	\N
6495	\N	\N	\N	\N	\N	\N
6496	\N	\N	\N	\N	\N	\N
6497	\N	\N	\N	\N	\N	\N
6498	\N	\N	\N	\N	\N	\N
6499	\N	\N	\N	\N	\N	\N
6500	\N	\N	\N	\N	\N	\N
6501	\N	\N	\N	\N	\N	\N
6502	\N	\N	\N	\N	\N	\N
6503	\N	\N	\N	\N	\N	\N
6504	\N	\N	\N	\N	\N	\N
6505	\N	\N	\N	\N	\N	\N
6506	\N	\N	\N	\N	\N	\N
6507	\N	\N	\N	\N	\N	\N
6508	\N	\N	\N	\N	\N	\N
6509	\N	\N	\N	\N	\N	\N
6510	\N	\N	\N	\N	\N	\N
6511	\N	\N	\N	\N	\N	\N
6512	\N	\N	\N	\N	\N	\N
6513	\N	\N	\N	\N	\N	\N
6514	\N	\N	\N	\N	\N	\N
6515	\N	\N	\N	\N	\N	\N
6516	\N	\N	\N	\N	\N	\N
6517	\N	\N	\N	\N	\N	\N
6518	\N	\N	\N	\N	\N	\N
6519	\N	\N	\N	\N	\N	\N
6520	\N	\N	\N	\N	\N	\N
6521	\N	\N	\N	\N	\N	\N
6522	\N	\N	\N	\N	\N	\N
6523	\N	\N	\N	\N	\N	\N
6524	\N	\N	\N	\N	\N	\N
6525	\N	\N	\N	\N	\N	\N
6526	\N	\N	\N	\N	\N	\N
6527	\N	\N	\N	\N	\N	\N
6528	\N	\N	\N	\N	\N	\N
6529	\N	\N	\N	\N	\N	\N
6530	\N	\N	\N	\N	\N	\N
6531	\N	\N	\N	\N	\N	\N
6532	\N	\N	\N	\N	\N	\N
6533	\N	\N	\N	\N	\N	\N
6534	\N	\N	\N	\N	\N	\N
6535	\N	\N	\N	\N	\N	\N
6536	\N	\N	\N	\N	\N	\N
6537	\N	\N	\N	\N	\N	\N
6538	\N	\N	\N	\N	\N	\N
6539	\N	\N	\N	\N	\N	\N
6540	\N	\N	\N	\N	\N	\N
6541	\N	\N	\N	\N	\N	\N
6542	\N	\N	\N	\N	\N	\N
6543	\N	\N	\N	\N	\N	\N
6544	\N	\N	\N	\N	\N	\N
6545	\N	\N	\N	\N	\N	\N
6546	\N	\N	\N	\N	\N	\N
6547	\N	\N	\N	\N	\N	\N
6548	\N	\N	\N	\N	\N	\N
6549	\N	\N	\N	\N	\N	\N
6550	\N	\N	\N	\N	\N	\N
6551	\N	\N	\N	\N	\N	\N
6552	\N	\N	\N	\N	\N	\N
6553	\N	\N	\N	\N	\N	\N
6554	\N	\N	\N	\N	\N	\N
6555	\N	\N	\N	\N	\N	\N
6556	\N	\N	\N	\N	\N	\N
6557	\N	\N	\N	\N	\N	\N
6558	\N	\N	\N	\N	\N	\N
6559	\N	\N	\N	\N	\N	\N
6560	\N	\N	\N	\N	\N	\N
6561	\N	\N	\N	\N	\N	\N
6562	\N	\N	\N	\N	\N	\N
6563	\N	\N	\N	\N	\N	\N
6564	\N	\N	\N	\N	\N	\N
6565	\N	\N	\N	\N	\N	\N
6566	\N	\N	\N	\N	\N	\N
6567	\N	\N	\N	\N	\N	\N
6568	\N	\N	\N	\N	\N	\N
6569	\N	\N	\N	\N	\N	\N
6570	\N	\N	\N	\N	\N	\N
6571	\N	\N	\N	\N	\N	\N
6572	\N	\N	\N	\N	\N	\N
6573	\N	\N	\N	\N	\N	\N
6574	\N	\N	\N	\N	\N	\N
6575	\N	\N	\N	\N	\N	\N
6576	\N	\N	\N	\N	\N	\N
6577	\N	\N	\N	\N	\N	\N
6578	\N	\N	\N	\N	\N	\N
6579	\N	\N	\N	\N	\N	\N
6580	\N	\N	\N	\N	\N	\N
6581	\N	\N	\N	\N	\N	\N
6582	\N	\N	\N	\N	\N	\N
6583	\N	\N	\N	\N	\N	\N
6584	\N	\N	\N	\N	\N	\N
6585	\N	\N	\N	\N	\N	\N
6586	\N	\N	\N	\N	\N	\N
6587	\N	\N	\N	\N	\N	\N
6588	\N	\N	\N	\N	\N	\N
6589	\N	\N	\N	\N	\N	\N
6590	\N	\N	\N	\N	\N	\N
6591	\N	\N	\N	\N	\N	\N
6592	\N	\N	\N	\N	\N	\N
6593	\N	\N	\N	\N	\N	\N
6594	\N	\N	\N	\N	\N	\N
6595	\N	\N	\N	\N	\N	\N
6596	\N	\N	\N	\N	\N	\N
6597	\N	\N	\N	\N	\N	\N
6598	\N	\N	\N	\N	\N	\N
6599	\N	\N	\N	\N	\N	\N
6600	\N	\N	\N	\N	\N	\N
6601	\N	\N	\N	\N	\N	\N
6602	\N	\N	\N	\N	\N	\N
6603	\N	\N	\N	\N	\N	\N
6604	\N	\N	\N	\N	\N	\N
6605	\N	\N	\N	\N	\N	\N
6606	\N	\N	\N	\N	\N	\N
6607	\N	\N	\N	\N	\N	\N
6608	\N	\N	\N	\N	\N	\N
6609	\N	\N	\N	\N	\N	\N
6610	\N	\N	\N	\N	\N	\N
6611	\N	\N	\N	\N	\N	\N
6612	\N	\N	\N	\N	\N	\N
6613	\N	\N	\N	\N	\N	\N
6614	\N	\N	\N	\N	\N	\N
6615	\N	\N	\N	\N	\N	\N
6616	\N	\N	\N	\N	\N	\N
6617	\N	\N	\N	\N	\N	\N
6618	\N	\N	\N	\N	\N	\N
6619	\N	\N	\N	\N	\N	\N
6620	\N	\N	\N	\N	\N	\N
6621	\N	\N	\N	\N	\N	\N
6622	\N	\N	\N	\N	\N	\N
6623	\N	\N	\N	\N	\N	\N
6624	\N	\N	\N	\N	\N	\N
6625	\N	\N	\N	\N	\N	\N
6626	\N	\N	\N	\N	\N	\N
6627	\N	\N	\N	\N	\N	\N
6628	\N	\N	\N	\N	\N	\N
6629	\N	\N	\N	\N	\N	\N
6630	\N	\N	\N	\N	\N	\N
6631	\N	\N	\N	\N	\N	\N
6632	\N	\N	\N	\N	\N	\N
6633	\N	\N	\N	\N	\N	\N
6634	\N	\N	\N	\N	\N	\N
6635	\N	\N	\N	\N	\N	\N
6636	\N	\N	\N	\N	\N	\N
6637	\N	\N	\N	\N	\N	\N
6638	\N	\N	\N	\N	\N	\N
6639	\N	\N	\N	\N	\N	\N
6640	\N	\N	\N	\N	\N	\N
6641	\N	\N	\N	\N	\N	\N
6642	\N	\N	\N	\N	\N	\N
6643	\N	\N	\N	\N	\N	\N
6644	\N	\N	\N	\N	\N	\N
6645	\N	\N	\N	\N	\N	\N
6646	\N	\N	\N	\N	\N	\N
6647	\N	\N	\N	\N	\N	\N
6648	\N	\N	\N	\N	\N	\N
6649	\N	\N	\N	\N	\N	\N
6650	\N	\N	\N	\N	\N	\N
6651	\N	\N	\N	\N	\N	\N
6652	\N	\N	\N	\N	\N	\N
6653	\N	\N	\N	\N	\N	\N
6654	\N	\N	\N	\N	\N	\N
6655	\N	\N	\N	\N	\N	\N
6656	\N	\N	\N	\N	\N	\N
6657	\N	\N	\N	\N	\N	\N
6658	\N	\N	\N	\N	\N	\N
6659	\N	\N	\N	\N	\N	\N
6660	\N	\N	\N	\N	\N	\N
6661	\N	\N	\N	\N	\N	\N
6662	\N	\N	\N	\N	\N	\N
6663	\N	\N	\N	\N	\N	\N
6664	\N	\N	\N	\N	\N	\N
6665	\N	\N	\N	\N	\N	\N
6666	\N	\N	\N	\N	\N	\N
6667	\N	\N	\N	\N	\N	\N
6668	\N	\N	\N	\N	\N	\N
6669	\N	\N	\N	\N	\N	\N
6670	\N	\N	\N	\N	\N	\N
6671	\N	\N	\N	\N	\N	\N
6672	\N	\N	\N	\N	\N	\N
6673	\N	\N	\N	\N	\N	\N
6674	\N	\N	\N	\N	\N	\N
6675	\N	\N	\N	\N	\N	\N
6676	\N	\N	\N	\N	\N	\N
6677	\N	\N	\N	\N	\N	\N
6678	\N	\N	\N	\N	\N	\N
6679	\N	\N	\N	\N	\N	\N
6680	\N	\N	\N	\N	\N	\N
6681	\N	\N	\N	\N	\N	\N
6682	\N	\N	\N	\N	\N	\N
6683	\N	\N	\N	\N	\N	\N
6684	\N	\N	\N	\N	\N	\N
6685	\N	\N	\N	\N	\N	\N
6686	\N	\N	\N	\N	\N	\N
6687	\N	\N	\N	\N	\N	\N
6688	\N	\N	\N	\N	\N	\N
6689	\N	\N	\N	\N	\N	\N
6690	\N	\N	\N	\N	\N	\N
6691	\N	\N	\N	\N	\N	\N
6692	\N	\N	\N	\N	\N	\N
6693	\N	\N	\N	\N	\N	\N
6694	\N	\N	\N	\N	\N	\N
6695	\N	\N	\N	\N	\N	\N
6696	\N	\N	\N	\N	\N	\N
6697	\N	\N	\N	\N	\N	\N
6698	\N	\N	\N	\N	\N	\N
6699	\N	\N	\N	\N	\N	\N
6700	\N	\N	\N	\N	\N	\N
6701	\N	\N	\N	\N	\N	\N
6702	\N	\N	\N	\N	\N	\N
6703	\N	\N	\N	\N	\N	\N
6704	\N	\N	\N	\N	\N	\N
6705	\N	\N	\N	\N	\N	\N
6706	\N	\N	\N	\N	\N	\N
6707	\N	\N	\N	\N	\N	\N
6708	\N	\N	\N	\N	\N	\N
6709	\N	\N	\N	\N	\N	\N
6710	\N	\N	\N	\N	\N	\N
6711	\N	\N	\N	\N	\N	\N
6712	\N	\N	\N	\N	\N	\N
6713	\N	\N	\N	\N	\N	\N
6714	\N	\N	\N	\N	\N	\N
6715	\N	\N	\N	\N	\N	\N
6716	\N	\N	\N	\N	\N	\N
6717	\N	\N	\N	\N	\N	\N
6718	\N	\N	\N	\N	\N	\N
6719	\N	\N	\N	\N	\N	\N
6720	\N	\N	\N	\N	\N	\N
6721	\N	\N	\N	\N	\N	\N
6722	\N	\N	\N	\N	\N	\N
6723	\N	\N	\N	\N	\N	\N
6724	\N	\N	\N	\N	\N	\N
6725	\N	\N	\N	\N	\N	\N
6726	\N	\N	\N	\N	\N	\N
6727	\N	\N	\N	\N	\N	\N
6728	\N	\N	\N	\N	\N	\N
6729	\N	\N	\N	\N	\N	\N
6730	\N	\N	\N	\N	\N	\N
6731	\N	\N	\N	\N	\N	\N
6732	\N	\N	\N	\N	\N	\N
6733	\N	\N	\N	\N	\N	\N
6734	\N	\N	\N	\N	\N	\N
6735	\N	\N	\N	\N	\N	\N
6736	\N	\N	\N	\N	\N	\N
6737	\N	\N	\N	\N	\N	\N
6738	\N	\N	\N	\N	\N	\N
6739	\N	\N	\N	\N	\N	\N
6740	\N	\N	\N	\N	\N	\N
6741	\N	\N	\N	\N	\N	\N
6742	\N	\N	\N	\N	\N	\N
6743	\N	\N	\N	\N	\N	\N
6744	\N	\N	\N	\N	\N	\N
6745	\N	\N	\N	\N	\N	\N
6746	\N	\N	\N	\N	\N	\N
6747	\N	\N	\N	\N	\N	\N
6748	\N	\N	\N	\N	\N	\N
6749	\N	\N	\N	\N	\N	\N
6750	\N	\N	\N	\N	\N	\N
6751	\N	\N	\N	\N	\N	\N
6752	\N	\N	\N	\N	\N	\N
6753	\N	\N	\N	\N	\N	\N
6754	\N	\N	\N	\N	\N	\N
6755	\N	\N	\N	\N	\N	\N
6756	\N	\N	\N	\N	\N	\N
6757	\N	\N	\N	\N	\N	\N
6758	\N	\N	\N	\N	\N	\N
6759	\N	\N	\N	\N	\N	\N
6760	\N	\N	\N	\N	\N	\N
6761	\N	\N	\N	\N	\N	\N
6762	\N	\N	\N	\N	\N	\N
6763	\N	\N	\N	\N	\N	\N
6764	\N	\N	\N	\N	\N	\N
6765	\N	\N	\N	\N	\N	\N
6766	\N	\N	\N	\N	\N	\N
6767	\N	\N	\N	\N	\N	\N
6768	\N	\N	\N	\N	\N	\N
6769	\N	\N	\N	\N	\N	\N
6770	\N	\N	\N	\N	\N	\N
6771	\N	\N	\N	\N	\N	\N
6772	\N	\N	\N	\N	\N	\N
6773	\N	\N	\N	\N	\N	\N
6774	\N	\N	\N	\N	\N	\N
6775	\N	\N	\N	\N	\N	\N
6776	\N	\N	\N	\N	\N	\N
6777	\N	\N	\N	\N	\N	\N
6778	\N	\N	\N	\N	\N	\N
6779	\N	\N	\N	\N	\N	\N
6780	\N	\N	\N	\N	\N	\N
6781	\N	\N	\N	\N	\N	\N
6782	\N	\N	\N	\N	\N	\N
6783	\N	\N	\N	\N	\N	\N
6784	\N	\N	\N	\N	\N	\N
6785	\N	\N	\N	\N	\N	\N
6786	\N	\N	\N	\N	\N	\N
6787	\N	\N	\N	\N	\N	\N
6788	\N	\N	\N	\N	\N	\N
6789	\N	\N	\N	\N	\N	\N
6790	\N	\N	\N	\N	\N	\N
6791	\N	\N	\N	\N	\N	\N
6792	\N	\N	\N	\N	\N	\N
6793	\N	\N	\N	\N	\N	\N
6794	\N	\N	\N	\N	\N	\N
6795	\N	\N	\N	\N	\N	\N
6796	\N	\N	\N	\N	\N	\N
6797	\N	\N	\N	\N	\N	\N
6798	\N	\N	\N	\N	\N	\N
6799	\N	\N	\N	\N	\N	\N
6800	\N	\N	\N	\N	\N	\N
6801	\N	\N	\N	\N	\N	\N
6802	\N	\N	\N	\N	\N	\N
6803	\N	\N	\N	\N	\N	\N
6804	\N	\N	\N	\N	\N	\N
6805	\N	\N	\N	\N	\N	\N
6806	\N	\N	\N	\N	\N	\N
6807	\N	\N	\N	\N	\N	\N
6808	\N	\N	\N	\N	\N	\N
6809	\N	\N	\N	\N	\N	\N
6810	\N	\N	\N	\N	\N	\N
6811	\N	\N	\N	\N	\N	\N
6812	\N	\N	\N	\N	\N	\N
6813	\N	\N	\N	\N	\N	\N
6814	\N	\N	\N	\N	\N	\N
6815	\N	\N	\N	\N	\N	\N
6816	\N	\N	\N	\N	\N	\N
6817	\N	\N	\N	\N	\N	\N
6818	\N	\N	\N	\N	\N	\N
6819	\N	\N	\N	\N	\N	\N
6820	\N	\N	\N	\N	\N	\N
6821	\N	\N	\N	\N	\N	\N
6822	\N	\N	\N	\N	\N	\N
6823	\N	\N	\N	\N	\N	\N
6824	\N	\N	\N	\N	\N	\N
6825	\N	\N	\N	\N	\N	\N
6826	\N	\N	\N	\N	\N	\N
6827	\N	\N	\N	\N	\N	\N
6828	\N	\N	\N	\N	\N	\N
6829	\N	\N	\N	\N	\N	\N
6830	\N	\N	\N	\N	\N	\N
6831	\N	\N	\N	\N	\N	\N
6832	\N	\N	\N	\N	\N	\N
6833	\N	\N	\N	\N	\N	\N
6834	\N	\N	\N	\N	\N	\N
6835	\N	\N	\N	\N	\N	\N
6836	\N	\N	\N	\N	\N	\N
6837	\N	\N	\N	\N	\N	\N
6838	\N	\N	\N	\N	\N	\N
6839	\N	\N	\N	\N	\N	\N
6840	\N	\N	\N	\N	\N	\N
6841	\N	\N	\N	\N	\N	\N
6842	\N	\N	\N	\N	\N	\N
6843	\N	\N	\N	\N	\N	\N
6844	\N	\N	\N	\N	\N	\N
6845	\N	\N	\N	\N	\N	\N
6846	\N	\N	\N	\N	\N	\N
6847	\N	\N	\N	\N	\N	\N
6848	\N	\N	\N	\N	\N	\N
6849	\N	\N	\N	\N	\N	\N
6850	\N	\N	\N	\N	\N	\N
6851	\N	\N	\N	\N	\N	\N
6852	\N	\N	\N	\N	\N	\N
6853	\N	\N	\N	\N	\N	\N
6854	\N	\N	\N	\N	\N	\N
6855	\N	\N	\N	\N	\N	\N
6856	\N	\N	\N	\N	\N	\N
6857	\N	\N	\N	\N	\N	\N
6858	\N	\N	\N	\N	\N	\N
6859	\N	\N	\N	\N	\N	\N
6860	\N	\N	\N	\N	\N	\N
6861	\N	\N	\N	\N	\N	\N
6862	\N	\N	\N	\N	\N	\N
6863	\N	\N	\N	\N	\N	\N
6864	\N	\N	\N	\N	\N	\N
6865	\N	\N	\N	\N	\N	\N
6866	\N	\N	\N	\N	\N	\N
6867	\N	\N	\N	\N	\N	\N
6868	\N	\N	\N	\N	\N	\N
6869	\N	\N	\N	\N	\N	\N
6870	\N	\N	\N	\N	\N	\N
6871	\N	\N	\N	\N	\N	\N
6872	\N	\N	\N	\N	\N	\N
6873	\N	\N	\N	\N	\N	\N
6874	\N	\N	\N	\N	\N	\N
6875	\N	\N	\N	\N	\N	\N
6876	\N	\N	\N	\N	\N	\N
6877	\N	\N	\N	\N	\N	\N
6878	\N	\N	\N	\N	\N	\N
6879	\N	\N	\N	\N	\N	\N
6880	\N	\N	\N	\N	\N	\N
6881	\N	\N	\N	\N	\N	\N
6882	\N	\N	\N	\N	\N	\N
6883	\N	\N	\N	\N	\N	\N
6884	\N	\N	\N	\N	\N	\N
6885	\N	\N	\N	\N	\N	\N
6886	\N	\N	\N	\N	\N	\N
6887	\N	\N	\N	\N	\N	\N
6888	\N	\N	\N	\N	\N	\N
6889	\N	\N	\N	\N	\N	\N
6890	\N	\N	\N	\N	\N	\N
6891	\N	\N	\N	\N	\N	\N
6892	\N	\N	\N	\N	\N	\N
6893	\N	\N	\N	\N	\N	\N
6894	\N	\N	\N	\N	\N	\N
6895	\N	\N	\N	\N	\N	\N
6896	\N	\N	\N	\N	\N	\N
6897	\N	\N	\N	\N	\N	\N
6898	\N	\N	\N	\N	\N	\N
6899	\N	\N	\N	\N	\N	\N
6900	\N	\N	\N	\N	\N	\N
6901	\N	\N	\N	\N	\N	\N
6902	\N	\N	\N	\N	\N	\N
6903	\N	\N	\N	\N	\N	\N
6904	\N	\N	\N	\N	\N	\N
6905	\N	\N	\N	\N	\N	\N
6906	\N	\N	\N	\N	\N	\N
6907	\N	\N	\N	\N	\N	\N
6908	\N	\N	\N	\N	\N	\N
6909	\N	\N	\N	\N	\N	\N
6910	\N	\N	\N	\N	\N	\N
6911	\N	\N	\N	\N	\N	\N
6912	\N	\N	\N	\N	\N	\N
6913	\N	\N	\N	\N	\N	\N
6914	\N	\N	\N	\N	\N	\N
6915	\N	\N	\N	\N	\N	\N
6916	\N	\N	\N	\N	\N	\N
6917	\N	\N	\N	\N	\N	\N
6918	\N	\N	\N	\N	\N	\N
6919	\N	\N	\N	\N	\N	\N
6920	\N	\N	\N	\N	\N	\N
6921	\N	\N	\N	\N	\N	\N
6922	\N	\N	\N	\N	\N	\N
6923	\N	\N	\N	\N	\N	\N
6924	\N	\N	\N	\N	\N	\N
6925	\N	\N	\N	\N	\N	\N
6926	\N	\N	\N	\N	\N	\N
6927	\N	\N	\N	\N	\N	\N
6928	\N	\N	\N	\N	\N	\N
6929	\N	\N	\N	\N	\N	\N
6930	\N	\N	\N	\N	\N	\N
6931	\N	\N	\N	\N	\N	\N
6932	\N	\N	\N	\N	\N	\N
6933	\N	\N	\N	\N	\N	\N
6934	\N	\N	\N	\N	\N	\N
6935	\N	\N	\N	\N	\N	\N
6936	\N	\N	\N	\N	\N	\N
6937	\N	\N	\N	\N	\N	\N
6938	\N	\N	\N	\N	\N	\N
6939	\N	\N	\N	\N	\N	\N
6940	\N	\N	\N	\N	\N	\N
6941	\N	\N	\N	\N	\N	\N
6942	\N	\N	\N	\N	\N	\N
6943	\N	\N	\N	\N	\N	\N
6944	\N	\N	\N	\N	\N	\N
6945	\N	\N	\N	\N	\N	\N
6946	\N	\N	\N	\N	\N	\N
6947	\N	\N	\N	\N	\N	\N
6948	\N	\N	\N	\N	\N	\N
6949	\N	\N	\N	\N	\N	\N
6950	\N	\N	\N	\N	\N	\N
6951	\N	\N	\N	\N	\N	\N
6952	\N	\N	\N	\N	\N	\N
6953	\N	\N	\N	\N	\N	\N
6954	\N	\N	\N	\N	\N	\N
6955	\N	\N	\N	\N	\N	\N
6956	\N	\N	\N	\N	\N	\N
6957	\N	\N	\N	\N	\N	\N
6958	\N	\N	\N	\N	\N	\N
6959	\N	\N	\N	\N	\N	\N
6960	\N	\N	\N	\N	\N	\N
6961	\N	\N	\N	\N	\N	\N
6962	\N	\N	\N	\N	\N	\N
6963	\N	\N	\N	\N	\N	\N
6964	\N	\N	\N	\N	\N	\N
6965	\N	\N	\N	\N	\N	\N
6966	\N	\N	\N	\N	\N	\N
6967	\N	\N	\N	\N	\N	\N
6968	\N	\N	\N	\N	\N	\N
6969	\N	\N	\N	\N	\N	\N
6970	\N	\N	\N	\N	\N	\N
6971	\N	\N	\N	\N	\N	\N
6972	\N	\N	\N	\N	\N	\N
6973	\N	\N	\N	\N	\N	\N
6974	\N	\N	\N	\N	\N	\N
6975	\N	\N	\N	\N	\N	\N
6976	\N	\N	\N	\N	\N	\N
6977	\N	\N	\N	\N	\N	\N
6978	\N	\N	\N	\N	\N	\N
6979	\N	\N	\N	\N	\N	\N
6980	\N	\N	\N	\N	\N	\N
6981	\N	\N	\N	\N	\N	\N
6982	\N	\N	\N	\N	\N	\N
6983	\N	\N	\N	\N	\N	\N
6984	\N	\N	\N	\N	\N	\N
6985	\N	\N	\N	\N	\N	\N
6986	\N	\N	\N	\N	\N	\N
6987	\N	\N	\N	\N	\N	\N
6988	\N	\N	\N	\N	\N	\N
6989	\N	\N	\N	\N	\N	\N
6990	\N	\N	\N	\N	\N	\N
6991	\N	\N	\N	\N	\N	\N
6992	\N	\N	\N	\N	\N	\N
6993	\N	\N	\N	\N	\N	\N
6994	\N	\N	\N	\N	\N	\N
6995	\N	\N	\N	\N	\N	\N
6996	\N	\N	\N	\N	\N	\N
6997	\N	\N	\N	\N	\N	\N
6998	\N	\N	\N	\N	\N	\N
6999	\N	\N	\N	\N	\N	\N
7000	\N	\N	\N	\N	\N	\N
7001	\N	\N	\N	\N	\N	\N
7002	\N	\N	\N	\N	\N	\N
7003	\N	\N	\N	\N	\N	\N
7004	\N	\N	\N	\N	\N	\N
7005	\N	\N	\N	\N	\N	\N
7006	\N	\N	\N	\N	\N	\N
7007	\N	\N	\N	\N	\N	\N
7008	\N	\N	\N	\N	\N	\N
7009	\N	\N	\N	\N	\N	\N
7010	\N	\N	\N	\N	\N	\N
7011	\N	\N	\N	\N	\N	\N
7012	\N	\N	\N	\N	\N	\N
7013	\N	\N	\N	\N	\N	\N
7014	\N	\N	\N	\N	\N	\N
7015	\N	\N	\N	\N	\N	\N
7016	\N	\N	\N	\N	\N	\N
7017	\N	\N	\N	\N	\N	\N
7018	\N	\N	\N	\N	\N	\N
7019	\N	\N	\N	\N	\N	\N
7020	\N	\N	\N	\N	\N	\N
7021	\N	\N	\N	\N	\N	\N
7022	\N	\N	\N	\N	\N	\N
7023	\N	\N	\N	\N	\N	\N
7024	\N	\N	\N	\N	\N	\N
7025	\N	\N	\N	\N	\N	\N
7026	\N	\N	\N	\N	\N	\N
7027	\N	\N	\N	\N	\N	\N
7028	\N	\N	\N	\N	\N	\N
7029	\N	\N	\N	\N	\N	\N
7030	\N	\N	\N	\N	\N	\N
7031	\N	\N	\N	\N	\N	\N
7032	\N	\N	\N	\N	\N	\N
7033	\N	\N	\N	\N	\N	\N
7034	\N	\N	\N	\N	\N	\N
7035	\N	\N	\N	\N	\N	\N
7036	\N	\N	\N	\N	\N	\N
7037	\N	\N	\N	\N	\N	\N
7038	\N	\N	\N	\N	\N	\N
7039	\N	\N	\N	\N	\N	\N
7040	\N	\N	\N	\N	\N	\N
7041	\N	\N	\N	\N	\N	\N
7042	\N	\N	\N	\N	\N	\N
7043	\N	\N	\N	\N	\N	\N
7044	\N	\N	\N	\N	\N	\N
7045	\N	\N	\N	\N	\N	\N
7046	\N	\N	\N	\N	\N	\N
7047	\N	\N	\N	\N	\N	\N
7048	\N	\N	\N	\N	\N	\N
7049	\N	\N	\N	\N	\N	\N
7050	\N	\N	\N	\N	\N	\N
7051	\N	\N	\N	\N	\N	\N
7052	\N	\N	\N	\N	\N	\N
7053	\N	\N	\N	\N	\N	\N
7054	\N	\N	\N	\N	\N	\N
7055	\N	\N	\N	\N	\N	\N
7056	\N	\N	\N	\N	\N	\N
7057	\N	\N	\N	\N	\N	\N
7058	\N	\N	\N	\N	\N	\N
7059	\N	\N	\N	\N	\N	\N
7060	\N	\N	\N	\N	\N	\N
7061	\N	\N	\N	\N	\N	\N
7062	\N	\N	\N	\N	\N	\N
7063	\N	\N	\N	\N	\N	\N
7064	\N	\N	\N	\N	\N	\N
7065	\N	\N	\N	\N	\N	\N
7066	\N	\N	\N	\N	\N	\N
7067	\N	\N	\N	\N	\N	\N
7068	\N	\N	\N	\N	\N	\N
7069	\N	\N	\N	\N	\N	\N
7070	\N	\N	\N	\N	\N	\N
7071	\N	\N	\N	\N	\N	\N
7072	\N	\N	\N	\N	\N	\N
7073	\N	\N	\N	\N	\N	\N
7074	\N	\N	\N	\N	\N	\N
7075	\N	\N	\N	\N	\N	\N
7076	\N	\N	\N	\N	\N	\N
7077	\N	\N	\N	\N	\N	\N
7078	\N	\N	\N	\N	\N	\N
7079	\N	\N	\N	\N	\N	\N
7080	\N	\N	\N	\N	\N	\N
7081	\N	\N	\N	\N	\N	\N
7082	\N	\N	\N	\N	\N	\N
7083	\N	\N	\N	\N	\N	\N
7084	\N	\N	\N	\N	\N	\N
7085	\N	\N	\N	\N	\N	\N
7086	\N	\N	\N	\N	\N	\N
7087	\N	\N	\N	\N	\N	\N
7088	\N	\N	\N	\N	\N	\N
7089	\N	\N	\N	\N	\N	\N
7090	\N	\N	\N	\N	\N	\N
7091	\N	\N	\N	\N	\N	\N
7092	\N	\N	\N	\N	\N	\N
7093	\N	\N	\N	\N	\N	\N
7094	\N	\N	\N	\N	\N	\N
7095	\N	\N	\N	\N	\N	\N
7096	\N	\N	\N	\N	\N	\N
7097	\N	\N	\N	\N	\N	\N
7098	\N	\N	\N	\N	\N	\N
7099	\N	\N	\N	\N	\N	\N
7100	\N	\N	\N	\N	\N	\N
7101	\N	\N	\N	\N	\N	\N
7102	\N	\N	\N	\N	\N	\N
7103	\N	\N	\N	\N	\N	\N
7104	\N	\N	\N	\N	\N	\N
7105	\N	\N	\N	\N	\N	\N
7106	\N	\N	\N	\N	\N	\N
7107	\N	\N	\N	\N	\N	\N
7108	\N	\N	\N	\N	\N	\N
7109	\N	\N	\N	\N	\N	\N
7110	\N	\N	\N	\N	\N	\N
7111	\N	\N	\N	\N	\N	\N
7112	\N	\N	\N	\N	\N	\N
7113	\N	\N	\N	\N	\N	\N
7114	\N	\N	\N	\N	\N	\N
7115	\N	\N	\N	\N	\N	\N
7116	\N	\N	\N	\N	\N	\N
7117	\N	\N	\N	\N	\N	\N
7118	\N	\N	\N	\N	\N	\N
7119	\N	\N	\N	\N	\N	\N
7120	\N	\N	\N	\N	\N	\N
7121	\N	\N	\N	\N	\N	\N
7122	\N	\N	\N	\N	\N	\N
7123	\N	\N	\N	\N	\N	\N
7124	\N	\N	\N	\N	\N	\N
7125	\N	\N	\N	\N	\N	\N
7126	\N	\N	\N	\N	\N	\N
7127	\N	\N	\N	\N	\N	\N
7128	\N	\N	\N	\N	\N	\N
7129	\N	\N	\N	\N	\N	\N
7130	\N	\N	\N	\N	\N	\N
7131	\N	\N	\N	\N	\N	\N
7132	\N	\N	\N	\N	\N	\N
7133	\N	\N	\N	\N	\N	\N
7134	\N	\N	\N	\N	\N	\N
7135	\N	\N	\N	\N	\N	\N
7136	\N	\N	\N	\N	\N	\N
7137	\N	\N	\N	\N	\N	\N
7138	\N	\N	\N	\N	\N	\N
7139	\N	\N	\N	\N	\N	\N
7140	\N	\N	\N	\N	\N	\N
7141	\N	\N	\N	\N	\N	\N
7142	\N	\N	\N	\N	\N	\N
7143	\N	\N	\N	\N	\N	\N
7144	\N	\N	\N	\N	\N	\N
7145	\N	\N	\N	\N	\N	\N
7146	\N	\N	\N	\N	\N	\N
7147	\N	\N	\N	\N	\N	\N
7148	\N	\N	\N	\N	\N	\N
7149	\N	\N	\N	\N	\N	\N
7150	\N	\N	\N	\N	\N	\N
7151	\N	\N	\N	\N	\N	\N
7152	\N	\N	\N	\N	\N	\N
7153	\N	\N	\N	\N	\N	\N
7154	\N	\N	\N	\N	\N	\N
7155	\N	\N	\N	\N	\N	\N
7156	\N	\N	\N	\N	\N	\N
7157	\N	\N	\N	\N	\N	\N
7158	\N	\N	\N	\N	\N	\N
7159	\N	\N	\N	\N	\N	\N
7160	\N	\N	\N	\N	\N	\N
7161	\N	\N	\N	\N	\N	\N
7162	\N	\N	\N	\N	\N	\N
7163	\N	\N	\N	\N	\N	\N
7164	\N	\N	\N	\N	\N	\N
7165	\N	\N	\N	\N	\N	\N
7166	\N	\N	\N	\N	\N	\N
7167	\N	\N	\N	\N	\N	\N
7168	\N	\N	\N	\N	\N	\N
7169	\N	\N	\N	\N	\N	\N
7170	\N	\N	\N	\N	\N	\N
7171	\N	\N	\N	\N	\N	\N
7172	\N	\N	\N	\N	\N	\N
7173	\N	\N	\N	\N	\N	\N
7174	\N	\N	\N	\N	\N	\N
7175	\N	\N	\N	\N	\N	\N
7176	\N	\N	\N	\N	\N	\N
7177	\N	\N	\N	\N	\N	\N
7178	\N	\N	\N	\N	\N	\N
7179	\N	\N	\N	\N	\N	\N
7180	\N	\N	\N	\N	\N	\N
7181	\N	\N	\N	\N	\N	\N
7182	\N	\N	\N	\N	\N	\N
7183	\N	\N	\N	\N	\N	\N
7184	\N	\N	\N	\N	\N	\N
7185	\N	\N	\N	\N	\N	\N
7186	\N	\N	\N	\N	\N	\N
7187	\N	\N	\N	\N	\N	\N
7188	\N	\N	\N	\N	\N	\N
7189	\N	\N	\N	\N	\N	\N
7190	\N	\N	\N	\N	\N	\N
7191	\N	\N	\N	\N	\N	\N
7192	\N	\N	\N	\N	\N	\N
7193	\N	\N	\N	\N	\N	\N
7194	\N	\N	\N	\N	\N	\N
7195	\N	\N	\N	\N	\N	\N
7196	\N	\N	\N	\N	\N	\N
7197	\N	\N	\N	\N	\N	\N
7198	\N	\N	\N	\N	\N	\N
7199	\N	\N	\N	\N	\N	\N
7200	\N	\N	\N	\N	\N	\N
7201	\N	\N	\N	\N	\N	\N
7202	\N	\N	\N	\N	\N	\N
7203	\N	\N	\N	\N	\N	\N
7204	\N	\N	\N	\N	\N	\N
7205	\N	\N	\N	\N	\N	\N
7206	\N	\N	\N	\N	\N	\N
7207	\N	\N	\N	\N	\N	\N
7208	\N	\N	\N	\N	\N	\N
7209	\N	\N	\N	\N	\N	\N
7210	\N	\N	\N	\N	\N	\N
7211	\N	\N	\N	\N	\N	\N
7212	\N	\N	\N	\N	\N	\N
7213	\N	\N	\N	\N	\N	\N
7214	\N	\N	\N	\N	\N	\N
7215	\N	\N	\N	\N	\N	\N
7216	\N	\N	\N	\N	\N	\N
7217	\N	\N	\N	\N	\N	\N
7218	\N	\N	\N	\N	\N	\N
7219	\N	\N	\N	\N	\N	\N
7220	\N	\N	\N	\N	\N	\N
7221	\N	\N	\N	\N	\N	\N
7222	\N	\N	\N	\N	\N	\N
7223	\N	\N	\N	\N	\N	\N
7224	\N	\N	\N	\N	\N	\N
7225	\N	\N	\N	\N	\N	\N
7226	\N	\N	\N	\N	\N	\N
7227	\N	\N	\N	\N	\N	\N
7228	\N	\N	\N	\N	\N	\N
7229	\N	\N	\N	\N	\N	\N
7230	\N	\N	\N	\N	\N	\N
7231	\N	\N	\N	\N	\N	\N
7232	\N	\N	\N	\N	\N	\N
7233	\N	\N	\N	\N	\N	\N
7234	\N	\N	\N	\N	\N	\N
7235	\N	\N	\N	\N	\N	\N
7236	\N	\N	\N	\N	\N	\N
7237	\N	\N	\N	\N	\N	\N
7238	\N	\N	\N	\N	\N	\N
7239	\N	\N	\N	\N	\N	\N
7240	\N	\N	\N	\N	\N	\N
7241	\N	\N	\N	\N	\N	\N
7242	\N	\N	\N	\N	\N	\N
7243	\N	\N	\N	\N	\N	\N
7244	\N	\N	\N	\N	\N	\N
7245	\N	\N	\N	\N	\N	\N
7246	\N	\N	\N	\N	\N	\N
7247	\N	\N	\N	\N	\N	\N
7248	\N	\N	\N	\N	\N	\N
7249	\N	\N	\N	\N	\N	\N
7250	\N	\N	\N	\N	\N	\N
7251	\N	\N	\N	\N	\N	\N
7252	\N	\N	\N	\N	\N	\N
7253	\N	\N	\N	\N	\N	\N
7254	\N	\N	\N	\N	\N	\N
7255	\N	\N	\N	\N	\N	\N
7256	\N	\N	\N	\N	\N	\N
7257	\N	\N	\N	\N	\N	\N
7258	\N	\N	\N	\N	\N	\N
7259	\N	\N	\N	\N	\N	\N
7260	\N	\N	\N	\N	\N	\N
7261	\N	\N	\N	\N	\N	\N
7262	\N	\N	\N	\N	\N	\N
7263	\N	\N	\N	\N	\N	\N
7264	\N	\N	\N	\N	\N	\N
7265	\N	\N	\N	\N	\N	\N
7266	\N	\N	\N	\N	\N	\N
7267	\N	\N	\N	\N	\N	\N
7268	\N	\N	\N	\N	\N	\N
7269	\N	\N	\N	\N	\N	\N
7270	\N	\N	\N	\N	\N	\N
7271	\N	\N	\N	\N	\N	\N
7272	\N	\N	\N	\N	\N	\N
7273	\N	\N	\N	\N	\N	\N
7274	\N	\N	\N	\N	\N	\N
7275	\N	\N	\N	\N	\N	\N
7276	\N	\N	\N	\N	\N	\N
7277	\N	\N	\N	\N	\N	\N
7278	\N	\N	\N	\N	\N	\N
7279	\N	\N	\N	\N	\N	\N
7280	\N	\N	\N	\N	\N	\N
7281	\N	\N	\N	\N	\N	\N
7282	\N	\N	\N	\N	\N	\N
7283	\N	\N	\N	\N	\N	\N
7284	\N	\N	\N	\N	\N	\N
7285	\N	\N	\N	\N	\N	\N
7286	\N	\N	\N	\N	\N	\N
7287	\N	\N	\N	\N	\N	\N
7288	\N	\N	\N	\N	\N	\N
7289	\N	\N	\N	\N	\N	\N
7290	\N	\N	\N	\N	\N	\N
7291	\N	\N	\N	\N	\N	\N
7292	\N	\N	\N	\N	\N	\N
7293	\N	\N	\N	\N	\N	\N
7294	\N	\N	\N	\N	\N	\N
7295	\N	\N	\N	\N	\N	\N
7296	\N	\N	\N	\N	\N	\N
7297	\N	\N	\N	\N	\N	\N
7298	\N	\N	\N	\N	\N	\N
7299	\N	\N	\N	\N	\N	\N
7300	\N	\N	\N	\N	\N	\N
7301	\N	\N	\N	\N	\N	\N
7302	\N	\N	\N	\N	\N	\N
7303	\N	\N	\N	\N	\N	\N
7304	\N	\N	\N	\N	\N	\N
7305	\N	\N	\N	\N	\N	\N
7306	\N	\N	\N	\N	\N	\N
7307	\N	\N	\N	\N	\N	\N
7308	\N	\N	\N	\N	\N	\N
7309	\N	\N	\N	\N	\N	\N
7310	\N	\N	\N	\N	\N	\N
7311	\N	\N	\N	\N	\N	\N
7312	\N	\N	\N	\N	\N	\N
7313	\N	\N	\N	\N	\N	\N
7314	\N	\N	\N	\N	\N	\N
7315	\N	\N	\N	\N	\N	\N
7316	\N	\N	\N	\N	\N	\N
7317	\N	\N	\N	\N	\N	\N
7318	\N	\N	\N	\N	\N	\N
7319	\N	\N	\N	\N	\N	\N
7320	\N	\N	\N	\N	\N	\N
7321	\N	\N	\N	\N	\N	\N
7322	\N	\N	\N	\N	\N	\N
7323	\N	\N	\N	\N	\N	\N
7324	\N	\N	\N	\N	\N	\N
7325	\N	\N	\N	\N	\N	\N
7326	\N	\N	\N	\N	\N	\N
7327	\N	\N	\N	\N	\N	\N
7328	\N	\N	\N	\N	\N	\N
7329	\N	\N	\N	\N	\N	\N
7330	\N	\N	\N	\N	\N	\N
7331	\N	\N	\N	\N	\N	\N
7332	\N	\N	\N	\N	\N	\N
7333	\N	\N	\N	\N	\N	\N
7334	\N	\N	\N	\N	\N	\N
7335	\N	\N	\N	\N	\N	\N
7336	\N	\N	\N	\N	\N	\N
7337	\N	\N	\N	\N	\N	\N
7338	\N	\N	\N	\N	\N	\N
7339	\N	\N	\N	\N	\N	\N
7340	\N	\N	\N	\N	\N	\N
7341	\N	\N	\N	\N	\N	\N
7342	\N	\N	\N	\N	\N	\N
7343	\N	\N	\N	\N	\N	\N
7344	\N	\N	\N	\N	\N	\N
7345	\N	\N	\N	\N	\N	\N
7346	\N	\N	\N	\N	\N	\N
7347	\N	\N	\N	\N	\N	\N
7348	\N	\N	\N	\N	\N	\N
7349	\N	\N	\N	\N	\N	\N
7350	\N	\N	\N	\N	\N	\N
7351	\N	\N	\N	\N	\N	\N
7352	\N	\N	\N	\N	\N	\N
7353	\N	\N	\N	\N	\N	\N
7354	\N	\N	\N	\N	\N	\N
7355	\N	\N	\N	\N	\N	\N
7356	\N	\N	\N	\N	\N	\N
7357	\N	\N	\N	\N	\N	\N
7358	\N	\N	\N	\N	\N	\N
7359	\N	\N	\N	\N	\N	\N
7360	\N	\N	\N	\N	\N	\N
7361	\N	\N	\N	\N	\N	\N
7362	\N	\N	\N	\N	\N	\N
7363	\N	\N	\N	\N	\N	\N
7364	\N	\N	\N	\N	\N	\N
7365	\N	\N	\N	\N	\N	\N
7366	\N	\N	\N	\N	\N	\N
7367	\N	\N	\N	\N	\N	\N
7368	\N	\N	\N	\N	\N	\N
7369	\N	\N	\N	\N	\N	\N
7370	\N	\N	\N	\N	\N	\N
7371	\N	\N	\N	\N	\N	\N
7372	\N	\N	\N	\N	\N	\N
7373	\N	\N	\N	\N	\N	\N
7374	\N	\N	\N	\N	\N	\N
7375	\N	\N	\N	\N	\N	\N
7376	\N	\N	\N	\N	\N	\N
7377	\N	\N	\N	\N	\N	\N
7378	\N	\N	\N	\N	\N	\N
7379	\N	\N	\N	\N	\N	\N
7380	\N	\N	\N	\N	\N	\N
7381	\N	\N	\N	\N	\N	\N
7382	\N	\N	\N	\N	\N	\N
7383	\N	\N	\N	\N	\N	\N
7384	\N	\N	\N	\N	\N	\N
7385	\N	\N	\N	\N	\N	\N
7386	\N	\N	\N	\N	\N	\N
7387	\N	\N	\N	\N	\N	\N
7388	\N	\N	\N	\N	\N	\N
7389	\N	\N	\N	\N	\N	\N
7390	\N	\N	\N	\N	\N	\N
7391	\N	\N	\N	\N	\N	\N
7392	\N	\N	\N	\N	\N	\N
7393	\N	\N	\N	\N	\N	\N
7394	\N	\N	\N	\N	\N	\N
7395	\N	\N	\N	\N	\N	\N
7396	\N	\N	\N	\N	\N	\N
7397	\N	\N	\N	\N	\N	\N
7398	\N	\N	\N	\N	\N	\N
7399	\N	\N	\N	\N	\N	\N
7400	\N	\N	\N	\N	\N	\N
7401	\N	\N	\N	\N	\N	\N
7402	\N	\N	\N	\N	\N	\N
7403	\N	\N	\N	\N	\N	\N
7404	\N	\N	\N	\N	\N	\N
7405	\N	\N	\N	\N	\N	\N
7406	\N	\N	\N	\N	\N	\N
7407	\N	\N	\N	\N	\N	\N
7408	\N	\N	\N	\N	\N	\N
7409	\N	\N	\N	\N	\N	\N
7410	\N	\N	\N	\N	\N	\N
7411	\N	\N	\N	\N	\N	\N
7412	\N	\N	\N	\N	\N	\N
7413	\N	\N	\N	\N	\N	\N
7414	\N	\N	\N	\N	\N	\N
7415	\N	\N	\N	\N	\N	\N
7416	\N	\N	\N	\N	\N	\N
7417	\N	\N	\N	\N	\N	\N
7418	\N	\N	\N	\N	\N	\N
7419	\N	\N	\N	\N	\N	\N
7420	\N	\N	\N	\N	\N	\N
7421	\N	\N	\N	\N	\N	\N
7422	\N	\N	\N	\N	\N	\N
7423	\N	\N	\N	\N	\N	\N
7424	\N	\N	\N	\N	\N	\N
7425	\N	\N	\N	\N	\N	\N
7426	\N	\N	\N	\N	\N	\N
7427	\N	\N	\N	\N	\N	\N
7428	\N	\N	\N	\N	\N	\N
7429	\N	\N	\N	\N	\N	\N
7430	\N	\N	\N	\N	\N	\N
7431	\N	\N	\N	\N	\N	\N
7432	\N	\N	\N	\N	\N	\N
7433	\N	\N	\N	\N	\N	\N
7434	\N	\N	\N	\N	\N	\N
7435	\N	\N	\N	\N	\N	\N
7436	\N	\N	\N	\N	\N	\N
7437	\N	\N	\N	\N	\N	\N
7438	\N	\N	\N	\N	\N	\N
7439	\N	\N	\N	\N	\N	\N
7440	\N	\N	\N	\N	\N	\N
7441	\N	\N	\N	\N	\N	\N
7442	\N	\N	\N	\N	\N	\N
7443	\N	\N	\N	\N	\N	\N
7444	\N	\N	\N	\N	\N	\N
7445	\N	\N	\N	\N	\N	\N
7446	\N	\N	\N	\N	\N	\N
7447	\N	\N	\N	\N	\N	\N
7448	\N	\N	\N	\N	\N	\N
7449	\N	\N	\N	\N	\N	\N
7450	\N	\N	\N	\N	\N	\N
7451	\N	\N	\N	\N	\N	\N
7452	\N	\N	\N	\N	\N	\N
7453	\N	\N	\N	\N	\N	\N
7454	\N	\N	\N	\N	\N	\N
7455	\N	\N	\N	\N	\N	\N
7456	\N	\N	\N	\N	\N	\N
7457	\N	\N	\N	\N	\N	\N
7458	\N	\N	\N	\N	\N	\N
7459	\N	\N	\N	\N	\N	\N
7460	\N	\N	\N	\N	\N	\N
7461	\N	\N	\N	\N	\N	\N
7462	\N	\N	\N	\N	\N	\N
7463	\N	\N	\N	\N	\N	\N
7464	\N	\N	\N	\N	\N	\N
7465	\N	\N	\N	\N	\N	\N
7466	\N	\N	\N	\N	\N	\N
7467	\N	\N	\N	\N	\N	\N
7468	\N	\N	\N	\N	\N	\N
7469	\N	\N	\N	\N	\N	\N
7470	\N	\N	\N	\N	\N	\N
7471	\N	\N	\N	\N	\N	\N
7472	\N	\N	\N	\N	\N	\N
7473	\N	\N	\N	\N	\N	\N
7474	\N	\N	\N	\N	\N	\N
7475	\N	\N	\N	\N	\N	\N
7476	\N	\N	\N	\N	\N	\N
7477	\N	\N	\N	\N	\N	\N
7478	\N	\N	\N	\N	\N	\N
7479	\N	\N	\N	\N	\N	\N
7480	\N	\N	\N	\N	\N	\N
7481	\N	\N	\N	\N	\N	\N
7482	\N	\N	\N	\N	\N	\N
7483	\N	\N	\N	\N	\N	\N
7484	\N	\N	\N	\N	\N	\N
7485	\N	\N	\N	\N	\N	\N
7486	\N	\N	\N	\N	\N	\N
7487	\N	\N	\N	\N	\N	\N
7488	\N	\N	\N	\N	\N	\N
7489	\N	\N	\N	\N	\N	\N
7490	\N	\N	\N	\N	\N	\N
7491	\N	\N	\N	\N	\N	\N
7492	\N	\N	\N	\N	\N	\N
7493	\N	\N	\N	\N	\N	\N
7494	\N	\N	\N	\N	\N	\N
7495	\N	\N	\N	\N	\N	\N
7496	\N	\N	\N	\N	\N	\N
7497	\N	\N	\N	\N	\N	\N
7498	\N	\N	\N	\N	\N	\N
7499	\N	\N	\N	\N	\N	\N
7500	\N	\N	\N	\N	\N	\N
7501	\N	\N	\N	\N	\N	\N
7502	\N	\N	\N	\N	\N	\N
7503	\N	\N	\N	\N	\N	\N
7504	\N	\N	\N	\N	\N	\N
7505	\N	\N	\N	\N	\N	\N
7506	\N	\N	\N	\N	\N	\N
7507	\N	\N	\N	\N	\N	\N
7508	\N	\N	\N	\N	\N	\N
7509	\N	\N	\N	\N	\N	\N
7510	\N	\N	\N	\N	\N	\N
7511	\N	\N	\N	\N	\N	\N
7512	\N	\N	\N	\N	\N	\N
7513	\N	\N	\N	\N	\N	\N
7514	\N	\N	\N	\N	\N	\N
7515	\N	\N	\N	\N	\N	\N
7516	\N	\N	\N	\N	\N	\N
7517	\N	\N	\N	\N	\N	\N
7518	\N	\N	\N	\N	\N	\N
7519	\N	\N	\N	\N	\N	\N
7520	\N	\N	\N	\N	\N	\N
7521	\N	\N	\N	\N	\N	\N
7522	\N	\N	\N	\N	\N	\N
7523	\N	\N	\N	\N	\N	\N
7524	\N	\N	\N	\N	\N	\N
7525	\N	\N	\N	\N	\N	\N
7526	\N	\N	\N	\N	\N	\N
7527	\N	\N	\N	\N	\N	\N
7528	\N	\N	\N	\N	\N	\N
7529	\N	\N	\N	\N	\N	\N
7530	\N	\N	\N	\N	\N	\N
7531	\N	\N	\N	\N	\N	\N
7532	\N	\N	\N	\N	\N	\N
7533	\N	\N	\N	\N	\N	\N
7534	\N	\N	\N	\N	\N	\N
7535	\N	\N	\N	\N	\N	\N
7536	\N	\N	\N	\N	\N	\N
7537	\N	\N	\N	\N	\N	\N
7538	\N	\N	\N	\N	\N	\N
7539	\N	\N	\N	\N	\N	\N
7540	\N	\N	\N	\N	\N	\N
7541	\N	\N	\N	\N	\N	\N
7542	\N	\N	\N	\N	\N	\N
7543	\N	\N	\N	\N	\N	\N
7544	\N	\N	\N	\N	\N	\N
7545	\N	\N	\N	\N	\N	\N
7546	\N	\N	\N	\N	\N	\N
7547	\N	\N	\N	\N	\N	\N
7548	\N	\N	\N	\N	\N	\N
7549	\N	\N	\N	\N	\N	\N
7550	\N	\N	\N	\N	\N	\N
7551	\N	\N	\N	\N	\N	\N
7552	\N	\N	\N	\N	\N	\N
7553	\N	\N	\N	\N	\N	\N
7554	\N	\N	\N	\N	\N	\N
7555	\N	\N	\N	\N	\N	\N
7556	\N	\N	\N	\N	\N	\N
7557	\N	\N	\N	\N	\N	\N
7558	\N	\N	\N	\N	\N	\N
7559	\N	\N	\N	\N	\N	\N
7560	\N	\N	\N	\N	\N	\N
7561	\N	\N	\N	\N	\N	\N
7562	\N	\N	\N	\N	\N	\N
7563	\N	\N	\N	\N	\N	\N
7564	\N	\N	\N	\N	\N	\N
7565	\N	\N	\N	\N	\N	\N
7566	\N	\N	\N	\N	\N	\N
7567	\N	\N	\N	\N	\N	\N
7568	\N	\N	\N	\N	\N	\N
7569	\N	\N	\N	\N	\N	\N
7570	\N	\N	\N	\N	\N	\N
7571	\N	\N	\N	\N	\N	\N
7572	\N	\N	\N	\N	\N	\N
7573	\N	\N	\N	\N	\N	\N
7574	\N	\N	\N	\N	\N	\N
7575	\N	\N	\N	\N	\N	\N
7576	\N	\N	\N	\N	\N	\N
7577	\N	\N	\N	\N	\N	\N
7578	\N	\N	\N	\N	\N	\N
7579	\N	\N	\N	\N	\N	\N
7580	\N	\N	\N	\N	\N	\N
7581	\N	\N	\N	\N	\N	\N
7582	\N	\N	\N	\N	\N	\N
7583	\N	\N	\N	\N	\N	\N
7584	\N	\N	\N	\N	\N	\N
7585	\N	\N	\N	\N	\N	\N
7586	\N	\N	\N	\N	\N	\N
7587	\N	\N	\N	\N	\N	\N
7588	\N	\N	\N	\N	\N	\N
7589	\N	\N	\N	\N	\N	\N
7590	\N	\N	\N	\N	\N	\N
7591	\N	\N	\N	\N	\N	\N
7592	\N	\N	\N	\N	\N	\N
7593	\N	\N	\N	\N	\N	\N
7594	\N	\N	\N	\N	\N	\N
7595	\N	\N	\N	\N	\N	\N
7596	\N	\N	\N	\N	\N	\N
7597	\N	\N	\N	\N	\N	\N
7598	\N	\N	\N	\N	\N	\N
7599	\N	\N	\N	\N	\N	\N
7600	\N	\N	\N	\N	\N	\N
7601	\N	\N	\N	\N	\N	\N
7602	\N	\N	\N	\N	\N	\N
7603	\N	\N	\N	\N	\N	\N
7604	\N	\N	\N	\N	\N	\N
7605	\N	\N	\N	\N	\N	\N
7606	\N	\N	\N	\N	\N	\N
7607	\N	\N	\N	\N	\N	\N
7608	\N	\N	\N	\N	\N	\N
7609	\N	\N	\N	\N	\N	\N
7610	\N	\N	\N	\N	\N	\N
7611	\N	\N	\N	\N	\N	\N
7612	\N	\N	\N	\N	\N	\N
7613	\N	\N	\N	\N	\N	\N
7614	\N	\N	\N	\N	\N	\N
7615	\N	\N	\N	\N	\N	\N
7616	\N	\N	\N	\N	\N	\N
7617	\N	\N	\N	\N	\N	\N
7618	\N	\N	\N	\N	\N	\N
7619	\N	\N	\N	\N	\N	\N
7620	\N	\N	\N	\N	\N	\N
7621	\N	\N	\N	\N	\N	\N
7622	\N	\N	\N	\N	\N	\N
7623	\N	\N	\N	\N	\N	\N
7624	\N	\N	\N	\N	\N	\N
7625	\N	\N	\N	\N	\N	\N
7626	\N	\N	\N	\N	\N	\N
7627	\N	\N	\N	\N	\N	\N
7628	\N	\N	\N	\N	\N	\N
7629	\N	\N	\N	\N	\N	\N
7630	\N	\N	\N	\N	\N	\N
7631	\N	\N	\N	\N	\N	\N
7632	\N	\N	\N	\N	\N	\N
7633	\N	\N	\N	\N	\N	\N
7634	\N	\N	\N	\N	\N	\N
7635	\N	\N	\N	\N	\N	\N
7636	\N	\N	\N	\N	\N	\N
7637	\N	\N	\N	\N	\N	\N
7638	\N	\N	\N	\N	\N	\N
7639	\N	\N	\N	\N	\N	\N
7640	\N	\N	\N	\N	\N	\N
7641	\N	\N	\N	\N	\N	\N
7642	\N	\N	\N	\N	\N	\N
7643	\N	\N	\N	\N	\N	\N
7644	\N	\N	\N	\N	\N	\N
7645	\N	\N	\N	\N	\N	\N
7646	\N	\N	\N	\N	\N	\N
7647	\N	\N	\N	\N	\N	\N
7648	\N	\N	\N	\N	\N	\N
7649	\N	\N	\N	\N	\N	\N
7650	\N	\N	\N	\N	\N	\N
7651	\N	\N	\N	\N	\N	\N
7652	\N	\N	\N	\N	\N	\N
7653	\N	\N	\N	\N	\N	\N
7654	\N	\N	\N	\N	\N	\N
7655	\N	\N	\N	\N	\N	\N
7656	\N	\N	\N	\N	\N	\N
7657	\N	\N	\N	\N	\N	\N
7658	\N	\N	\N	\N	\N	\N
7659	\N	\N	\N	\N	\N	\N
7660	\N	\N	\N	\N	\N	\N
7661	\N	\N	\N	\N	\N	\N
7662	\N	\N	\N	\N	\N	\N
7663	\N	\N	\N	\N	\N	\N
7664	\N	\N	\N	\N	\N	\N
7665	\N	\N	\N	\N	\N	\N
7666	\N	\N	\N	\N	\N	\N
7667	\N	\N	\N	\N	\N	\N
7668	\N	\N	\N	\N	\N	\N
7669	\N	\N	\N	\N	\N	\N
7670	\N	\N	\N	\N	\N	\N
7671	\N	\N	\N	\N	\N	\N
7672	\N	\N	\N	\N	\N	\N
7673	\N	\N	\N	\N	\N	\N
7674	\N	\N	\N	\N	\N	\N
7675	\N	\N	\N	\N	\N	\N
7676	\N	\N	\N	\N	\N	\N
7677	\N	\N	\N	\N	\N	\N
7678	\N	\N	\N	\N	\N	\N
7679	\N	\N	\N	\N	\N	\N
7680	\N	\N	\N	\N	\N	\N
7681	\N	\N	\N	\N	\N	\N
7682	\N	\N	\N	\N	\N	\N
7683	\N	\N	\N	\N	\N	\N
7684	\N	\N	\N	\N	\N	\N
7685	\N	\N	\N	\N	\N	\N
7686	\N	\N	\N	\N	\N	\N
7687	\N	\N	\N	\N	\N	\N
7688	\N	\N	\N	\N	\N	\N
7689	\N	\N	\N	\N	\N	\N
7690	\N	\N	\N	\N	\N	\N
7691	\N	\N	\N	\N	\N	\N
7692	\N	\N	\N	\N	\N	\N
7693	\N	\N	\N	\N	\N	\N
7694	\N	\N	\N	\N	\N	\N
7695	\N	\N	\N	\N	\N	\N
7696	\N	\N	\N	\N	\N	\N
7697	\N	\N	\N	\N	\N	\N
7698	\N	\N	\N	\N	\N	\N
7699	\N	\N	\N	\N	\N	\N
7700	\N	\N	\N	\N	\N	\N
7701	\N	\N	\N	\N	\N	\N
7702	\N	\N	\N	\N	\N	\N
7703	\N	\N	\N	\N	\N	\N
7704	\N	\N	\N	\N	\N	\N
7705	\N	\N	\N	\N	\N	\N
7706	\N	\N	\N	\N	\N	\N
7707	\N	\N	\N	\N	\N	\N
7708	\N	\N	\N	\N	\N	\N
7709	\N	\N	\N	\N	\N	\N
7710	\N	\N	\N	\N	\N	\N
7711	\N	\N	\N	\N	\N	\N
7712	\N	\N	\N	\N	\N	\N
7713	\N	\N	\N	\N	\N	\N
7714	\N	\N	\N	\N	\N	\N
7715	\N	\N	\N	\N	\N	\N
7716	\N	\N	\N	\N	\N	\N
7717	\N	\N	\N	\N	\N	\N
7718	\N	\N	\N	\N	\N	\N
7719	\N	\N	\N	\N	\N	\N
7720	\N	\N	\N	\N	\N	\N
7721	\N	\N	\N	\N	\N	\N
7722	\N	\N	\N	\N	\N	\N
7723	\N	\N	\N	\N	\N	\N
7724	\N	\N	\N	\N	\N	\N
7725	\N	\N	\N	\N	\N	\N
7726	\N	\N	\N	\N	\N	\N
7727	\N	\N	\N	\N	\N	\N
7728	\N	\N	\N	\N	\N	\N
7729	\N	\N	\N	\N	\N	\N
7730	\N	\N	\N	\N	\N	\N
7731	\N	\N	\N	\N	\N	\N
7732	\N	\N	\N	\N	\N	\N
7733	\N	\N	\N	\N	\N	\N
7734	\N	\N	\N	\N	\N	\N
7735	\N	\N	\N	\N	\N	\N
7736	\N	\N	\N	\N	\N	\N
7737	\N	\N	\N	\N	\N	\N
7738	\N	\N	\N	\N	\N	\N
7739	\N	\N	\N	\N	\N	\N
7740	\N	\N	\N	\N	\N	\N
7741	\N	\N	\N	\N	\N	\N
7742	\N	\N	\N	\N	\N	\N
7743	\N	\N	\N	\N	\N	\N
7744	\N	\N	\N	\N	\N	\N
7745	\N	\N	\N	\N	\N	\N
7746	\N	\N	\N	\N	\N	\N
7747	\N	\N	\N	\N	\N	\N
7748	\N	\N	\N	\N	\N	\N
7749	\N	\N	\N	\N	\N	\N
7750	\N	\N	\N	\N	\N	\N
7751	\N	\N	\N	\N	\N	\N
7752	\N	\N	\N	\N	\N	\N
7753	\N	\N	\N	\N	\N	\N
7754	\N	\N	\N	\N	\N	\N
7755	\N	\N	\N	\N	\N	\N
7756	\N	\N	\N	\N	\N	\N
7757	\N	\N	\N	\N	\N	\N
7758	\N	\N	\N	\N	\N	\N
7759	\N	\N	\N	\N	\N	\N
7760	\N	\N	\N	\N	\N	\N
7761	\N	\N	\N	\N	\N	\N
7762	\N	\N	\N	\N	\N	\N
7763	\N	\N	\N	\N	\N	\N
7764	\N	\N	\N	\N	\N	\N
7765	\N	\N	\N	\N	\N	\N
7766	\N	\N	\N	\N	\N	\N
7767	\N	\N	\N	\N	\N	\N
7768	\N	\N	\N	\N	\N	\N
7769	\N	\N	\N	\N	\N	\N
7770	\N	\N	\N	\N	\N	\N
7771	\N	\N	\N	\N	\N	\N
7772	\N	\N	\N	\N	\N	\N
7773	\N	\N	\N	\N	\N	\N
7774	\N	\N	\N	\N	\N	\N
7775	\N	\N	\N	\N	\N	\N
7776	\N	\N	\N	\N	\N	\N
7777	\N	\N	\N	\N	\N	\N
7778	\N	\N	\N	\N	\N	\N
7779	\N	\N	\N	\N	\N	\N
7780	\N	\N	\N	\N	\N	\N
7781	\N	\N	\N	\N	\N	\N
7782	\N	\N	\N	\N	\N	\N
7783	\N	\N	\N	\N	\N	\N
7784	\N	\N	\N	\N	\N	\N
7785	\N	\N	\N	\N	\N	\N
7786	\N	\N	\N	\N	\N	\N
7787	\N	\N	\N	\N	\N	\N
7788	\N	\N	\N	\N	\N	\N
7789	\N	\N	\N	\N	\N	\N
7790	\N	\N	\N	\N	\N	\N
7791	\N	\N	\N	\N	\N	\N
7792	\N	\N	\N	\N	\N	\N
7793	\N	\N	\N	\N	\N	\N
7794	\N	\N	\N	\N	\N	\N
7795	\N	\N	\N	\N	\N	\N
7796	\N	\N	\N	\N	\N	\N
7797	\N	\N	\N	\N	\N	\N
7798	\N	\N	\N	\N	\N	\N
7799	\N	\N	\N	\N	\N	\N
7800	\N	\N	\N	\N	\N	\N
7801	\N	\N	\N	\N	\N	\N
7802	\N	\N	\N	\N	\N	\N
7803	\N	\N	\N	\N	\N	\N
7804	\N	\N	\N	\N	\N	\N
7805	\N	\N	\N	\N	\N	\N
7806	\N	\N	\N	\N	\N	\N
7807	\N	\N	\N	\N	\N	\N
7808	\N	\N	\N	\N	\N	\N
7809	\N	\N	\N	\N	\N	\N
7810	\N	\N	\N	\N	\N	\N
7811	\N	\N	\N	\N	\N	\N
7812	\N	\N	\N	\N	\N	\N
7813	\N	\N	\N	\N	\N	\N
7814	\N	\N	\N	\N	\N	\N
7815	\N	\N	\N	\N	\N	\N
7816	\N	\N	\N	\N	\N	\N
7817	\N	\N	\N	\N	\N	\N
7818	\N	\N	\N	\N	\N	\N
7819	\N	\N	\N	\N	\N	\N
7820	\N	\N	\N	\N	\N	\N
7821	\N	\N	\N	\N	\N	\N
7822	\N	\N	\N	\N	\N	\N
7823	\N	\N	\N	\N	\N	\N
7824	\N	\N	\N	\N	\N	\N
7825	\N	\N	\N	\N	\N	\N
7826	\N	\N	\N	\N	\N	\N
7827	\N	\N	\N	\N	\N	\N
7828	\N	\N	\N	\N	\N	\N
7829	\N	\N	\N	\N	\N	\N
7830	\N	\N	\N	\N	\N	\N
7831	\N	\N	\N	\N	\N	\N
7832	\N	\N	\N	\N	\N	\N
7833	\N	\N	\N	\N	\N	\N
7834	\N	\N	\N	\N	\N	\N
7835	\N	\N	\N	\N	\N	\N
7836	\N	\N	\N	\N	\N	\N
7837	\N	\N	\N	\N	\N	\N
7838	\N	\N	\N	\N	\N	\N
7839	\N	\N	\N	\N	\N	\N
7840	\N	\N	\N	\N	\N	\N
7841	\N	\N	\N	\N	\N	\N
7842	\N	\N	\N	\N	\N	\N
7843	\N	\N	\N	\N	\N	\N
7844	\N	\N	\N	\N	\N	\N
7845	\N	\N	\N	\N	\N	\N
7846	\N	\N	\N	\N	\N	\N
7847	\N	\N	\N	\N	\N	\N
7848	\N	\N	\N	\N	\N	\N
7849	\N	\N	\N	\N	\N	\N
7850	\N	\N	\N	\N	\N	\N
7851	\N	\N	\N	\N	\N	\N
7852	\N	\N	\N	\N	\N	\N
7853	\N	\N	\N	\N	\N	\N
7854	\N	\N	\N	\N	\N	\N
7855	\N	\N	\N	\N	\N	\N
7856	\N	\N	\N	\N	\N	\N
7857	\N	\N	\N	\N	\N	\N
7858	\N	\N	\N	\N	\N	\N
7859	\N	\N	\N	\N	\N	\N
7860	\N	\N	\N	\N	\N	\N
7861	\N	\N	\N	\N	\N	\N
7862	\N	\N	\N	\N	\N	\N
7863	\N	\N	\N	\N	\N	\N
7864	\N	\N	\N	\N	\N	\N
7865	\N	\N	\N	\N	\N	\N
7866	\N	\N	\N	\N	\N	\N
7867	\N	\N	\N	\N	\N	\N
7868	\N	\N	\N	\N	\N	\N
7869	\N	\N	\N	\N	\N	\N
7870	\N	\N	\N	\N	\N	\N
7871	\N	\N	\N	\N	\N	\N
7872	\N	\N	\N	\N	\N	\N
7873	\N	\N	\N	\N	\N	\N
7874	\N	\N	\N	\N	\N	\N
7875	\N	\N	\N	\N	\N	\N
7876	\N	\N	\N	\N	\N	\N
7877	\N	\N	\N	\N	\N	\N
7878	\N	\N	\N	\N	\N	\N
7879	\N	\N	\N	\N	\N	\N
7880	\N	\N	\N	\N	\N	\N
7881	\N	\N	\N	\N	\N	\N
7882	\N	\N	\N	\N	\N	\N
7883	\N	\N	\N	\N	\N	\N
7884	\N	\N	\N	\N	\N	\N
7885	\N	\N	\N	\N	\N	\N
7886	\N	\N	\N	\N	\N	\N
7887	\N	\N	\N	\N	\N	\N
7888	\N	\N	\N	\N	\N	\N
7889	\N	\N	\N	\N	\N	\N
7890	\N	\N	\N	\N	\N	\N
7891	\N	\N	\N	\N	\N	\N
7892	\N	\N	\N	\N	\N	\N
7893	\N	\N	\N	\N	\N	\N
7894	\N	\N	\N	\N	\N	\N
7895	\N	\N	\N	\N	\N	\N
7896	\N	\N	\N	\N	\N	\N
7897	\N	\N	\N	\N	\N	\N
7898	\N	\N	\N	\N	\N	\N
7899	\N	\N	\N	\N	\N	\N
7900	\N	\N	\N	\N	\N	\N
7901	\N	\N	\N	\N	\N	\N
7902	\N	\N	\N	\N	\N	\N
7903	\N	\N	\N	\N	\N	\N
7904	\N	\N	\N	\N	\N	\N
7905	\N	\N	\N	\N	\N	\N
7906	\N	\N	\N	\N	\N	\N
7907	\N	\N	\N	\N	\N	\N
7908	\N	\N	\N	\N	\N	\N
7909	\N	\N	\N	\N	\N	\N
7910	\N	\N	\N	\N	\N	\N
7911	\N	\N	\N	\N	\N	\N
7912	\N	\N	\N	\N	\N	\N
7913	\N	\N	\N	\N	\N	\N
7914	\N	\N	\N	\N	\N	\N
7915	\N	\N	\N	\N	\N	\N
7916	\N	\N	\N	\N	\N	\N
7917	\N	\N	\N	\N	\N	\N
7918	\N	\N	\N	\N	\N	\N
7919	\N	\N	\N	\N	\N	\N
7920	\N	\N	\N	\N	\N	\N
7921	\N	\N	\N	\N	\N	\N
7922	\N	\N	\N	\N	\N	\N
7923	\N	\N	\N	\N	\N	\N
7924	\N	\N	\N	\N	\N	\N
7925	\N	\N	\N	\N	\N	\N
7926	\N	\N	\N	\N	\N	\N
7927	\N	\N	\N	\N	\N	\N
7928	\N	\N	\N	\N	\N	\N
7929	\N	\N	\N	\N	\N	\N
7930	\N	\N	\N	\N	\N	\N
7931	\N	\N	\N	\N	\N	\N
7932	\N	\N	\N	\N	\N	\N
7933	\N	\N	\N	\N	\N	\N
7934	\N	\N	\N	\N	\N	\N
7935	\N	\N	\N	\N	\N	\N
7936	\N	\N	\N	\N	\N	\N
7937	\N	\N	\N	\N	\N	\N
7938	\N	\N	\N	\N	\N	\N
7939	\N	\N	\N	\N	\N	\N
7940	\N	\N	\N	\N	\N	\N
7941	\N	\N	\N	\N	\N	\N
7942	\N	\N	\N	\N	\N	\N
7943	\N	\N	\N	\N	\N	\N
7944	\N	\N	\N	\N	\N	\N
7945	\N	\N	\N	\N	\N	\N
7946	\N	\N	\N	\N	\N	\N
7947	\N	\N	\N	\N	\N	\N
7948	\N	\N	\N	\N	\N	\N
7949	\N	\N	\N	\N	\N	\N
7950	\N	\N	\N	\N	\N	\N
7951	\N	\N	\N	\N	\N	\N
7952	\N	\N	\N	\N	\N	\N
7953	\N	\N	\N	\N	\N	\N
7954	\N	\N	\N	\N	\N	\N
7955	\N	\N	\N	\N	\N	\N
7956	\N	\N	\N	\N	\N	\N
7957	\N	\N	\N	\N	\N	\N
7958	\N	\N	\N	\N	\N	\N
7959	\N	\N	\N	\N	\N	\N
7960	\N	\N	\N	\N	\N	\N
7961	\N	\N	\N	\N	\N	\N
7962	\N	\N	\N	\N	\N	\N
7963	\N	\N	\N	\N	\N	\N
7964	\N	\N	\N	\N	\N	\N
7965	\N	\N	\N	\N	\N	\N
7966	\N	\N	\N	\N	\N	\N
7967	\N	\N	\N	\N	\N	\N
7968	\N	\N	\N	\N	\N	\N
7969	\N	\N	\N	\N	\N	\N
7970	\N	\N	\N	\N	\N	\N
7971	\N	\N	\N	\N	\N	\N
7972	\N	\N	\N	\N	\N	\N
7973	\N	\N	\N	\N	\N	\N
7974	\N	\N	\N	\N	\N	\N
7975	\N	\N	\N	\N	\N	\N
7976	\N	\N	\N	\N	\N	\N
7977	\N	\N	\N	\N	\N	\N
7978	\N	\N	\N	\N	\N	\N
7979	\N	\N	\N	\N	\N	\N
7980	\N	\N	\N	\N	\N	\N
7981	\N	\N	\N	\N	\N	\N
7982	\N	\N	\N	\N	\N	\N
7983	\N	\N	\N	\N	\N	\N
7984	\N	\N	\N	\N	\N	\N
7985	\N	\N	\N	\N	\N	\N
7986	\N	\N	\N	\N	\N	\N
7987	\N	\N	\N	\N	\N	\N
7988	\N	\N	\N	\N	\N	\N
7989	\N	\N	\N	\N	\N	\N
7990	\N	\N	\N	\N	\N	\N
7991	\N	\N	\N	\N	\N	\N
7992	\N	\N	\N	\N	\N	\N
7993	\N	\N	\N	\N	\N	\N
7994	\N	\N	\N	\N	\N	\N
7995	\N	\N	\N	\N	\N	\N
7996	\N	\N	\N	\N	\N	\N
7997	\N	\N	\N	\N	\N	\N
7998	\N	\N	\N	\N	\N	\N
7999	\N	\N	\N	\N	\N	\N
8000	\N	\N	\N	\N	\N	\N
8001	\N	\N	\N	\N	\N	\N
8002	\N	\N	\N	\N	\N	\N
8003	\N	\N	\N	\N	\N	\N
8004	\N	\N	\N	\N	\N	\N
8005	\N	\N	\N	\N	\N	\N
8006	\N	\N	\N	\N	\N	\N
8007	\N	\N	\N	\N	\N	\N
8008	\N	\N	\N	\N	\N	\N
8009	\N	\N	\N	\N	\N	\N
8010	\N	\N	\N	\N	\N	\N
8011	\N	\N	\N	\N	\N	\N
8012	\N	\N	\N	\N	\N	\N
8013	\N	\N	\N	\N	\N	\N
8014	\N	\N	\N	\N	\N	\N
8015	\N	\N	\N	\N	\N	\N
8016	\N	\N	\N	\N	\N	\N
8017	\N	\N	\N	\N	\N	\N
8018	\N	\N	\N	\N	\N	\N
8019	\N	\N	\N	\N	\N	\N
8020	\N	\N	\N	\N	\N	\N
8021	\N	\N	\N	\N	\N	\N
8022	\N	\N	\N	\N	\N	\N
8023	\N	\N	\N	\N	\N	\N
8024	\N	\N	\N	\N	\N	\N
8025	\N	\N	\N	\N	\N	\N
8026	\N	\N	\N	\N	\N	\N
8027	\N	\N	\N	\N	\N	\N
8028	\N	\N	\N	\N	\N	\N
8029	\N	\N	\N	\N	\N	\N
8030	\N	\N	\N	\N	\N	\N
8031	\N	\N	\N	\N	\N	\N
8032	\N	\N	\N	\N	\N	\N
8033	\N	\N	\N	\N	\N	\N
8034	\N	\N	\N	\N	\N	\N
8035	\N	\N	\N	\N	\N	\N
8036	\N	\N	\N	\N	\N	\N
8037	\N	\N	\N	\N	\N	\N
8038	\N	\N	\N	\N	\N	\N
8039	\N	\N	\N	\N	\N	\N
8040	\N	\N	\N	\N	\N	\N
8041	\N	\N	\N	\N	\N	\N
8042	\N	\N	\N	\N	\N	\N
8043	\N	\N	\N	\N	\N	\N
8044	\N	\N	\N	\N	\N	\N
8045	\N	\N	\N	\N	\N	\N
8046	\N	\N	\N	\N	\N	\N
8047	\N	\N	\N	\N	\N	\N
8048	\N	\N	\N	\N	\N	\N
8049	\N	\N	\N	\N	\N	\N
8050	\N	\N	\N	\N	\N	\N
8051	\N	\N	\N	\N	\N	\N
8052	\N	\N	\N	\N	\N	\N
8053	\N	\N	\N	\N	\N	\N
8054	\N	\N	\N	\N	\N	\N
8055	\N	\N	\N	\N	\N	\N
8056	\N	\N	\N	\N	\N	\N
8057	\N	\N	\N	\N	\N	\N
8058	\N	\N	\N	\N	\N	\N
8059	\N	\N	\N	\N	\N	\N
8060	\N	\N	\N	\N	\N	\N
8061	\N	\N	\N	\N	\N	\N
8062	\N	\N	\N	\N	\N	\N
8063	\N	\N	\N	\N	\N	\N
8064	\N	\N	\N	\N	\N	\N
8065	\N	\N	\N	\N	\N	\N
8066	\N	\N	\N	\N	\N	\N
8067	\N	\N	\N	\N	\N	\N
8068	\N	\N	\N	\N	\N	\N
8069	\N	\N	\N	\N	\N	\N
8070	\N	\N	\N	\N	\N	\N
8071	\N	\N	\N	\N	\N	\N
8072	\N	\N	\N	\N	\N	\N
8073	\N	\N	\N	\N	\N	\N
8074	\N	\N	\N	\N	\N	\N
8075	\N	\N	\N	\N	\N	\N
8076	\N	\N	\N	\N	\N	\N
8077	\N	\N	\N	\N	\N	\N
8078	\N	\N	\N	\N	\N	\N
8079	\N	\N	\N	\N	\N	\N
8080	\N	\N	\N	\N	\N	\N
8081	\N	\N	\N	\N	\N	\N
8082	\N	\N	\N	\N	\N	\N
8083	\N	\N	\N	\N	\N	\N
8084	\N	\N	\N	\N	\N	\N
8085	\N	\N	\N	\N	\N	\N
8086	\N	\N	\N	\N	\N	\N
8087	\N	\N	\N	\N	\N	\N
8088	\N	\N	\N	\N	\N	\N
8089	\N	\N	\N	\N	\N	\N
8090	\N	\N	\N	\N	\N	\N
8091	\N	\N	\N	\N	\N	\N
8092	\N	\N	\N	\N	\N	\N
8093	\N	\N	\N	\N	\N	\N
8094	\N	\N	\N	\N	\N	\N
8095	\N	\N	\N	\N	\N	\N
8096	\N	\N	\N	\N	\N	\N
8097	\N	\N	\N	\N	\N	\N
8098	\N	\N	\N	\N	\N	\N
8099	\N	\N	\N	\N	\N	\N
8100	\N	\N	\N	\N	\N	\N
8101	\N	\N	\N	\N	\N	\N
8102	\N	\N	\N	\N	\N	\N
8103	\N	\N	\N	\N	\N	\N
8104	\N	\N	\N	\N	\N	\N
8105	\N	\N	\N	\N	\N	\N
8106	\N	\N	\N	\N	\N	\N
8107	\N	\N	\N	\N	\N	\N
8108	\N	\N	\N	\N	\N	\N
8109	\N	\N	\N	\N	\N	\N
8110	\N	\N	\N	\N	\N	\N
8111	\N	\N	\N	\N	\N	\N
8112	\N	\N	\N	\N	\N	\N
8113	\N	\N	\N	\N	\N	\N
8114	\N	\N	\N	\N	\N	\N
8115	\N	\N	\N	\N	\N	\N
8116	\N	\N	\N	\N	\N	\N
8117	\N	\N	\N	\N	\N	\N
8118	\N	\N	\N	\N	\N	\N
8119	\N	\N	\N	\N	\N	\N
8120	\N	\N	\N	\N	\N	\N
8121	\N	\N	\N	\N	\N	\N
8122	\N	\N	\N	\N	\N	\N
8123	\N	\N	\N	\N	\N	\N
8124	\N	\N	\N	\N	\N	\N
8125	\N	\N	\N	\N	\N	\N
8126	\N	\N	\N	\N	\N	\N
8127	\N	\N	\N	\N	\N	\N
8128	\N	\N	\N	\N	\N	\N
8129	\N	\N	\N	\N	\N	\N
8130	\N	\N	\N	\N	\N	\N
8131	\N	\N	\N	\N	\N	\N
8132	\N	\N	\N	\N	\N	\N
8133	\N	\N	\N	\N	\N	\N
8134	\N	\N	\N	\N	\N	\N
8135	\N	\N	\N	\N	\N	\N
8136	\N	\N	\N	\N	\N	\N
8137	\N	\N	\N	\N	\N	\N
8138	\N	\N	\N	\N	\N	\N
8139	\N	\N	\N	\N	\N	\N
8140	\N	\N	\N	\N	\N	\N
8141	\N	\N	\N	\N	\N	\N
8142	\N	\N	\N	\N	\N	\N
8143	\N	\N	\N	\N	\N	\N
8144	\N	\N	\N	\N	\N	\N
8145	\N	\N	\N	\N	\N	\N
8146	\N	\N	\N	\N	\N	\N
8147	\N	\N	\N	\N	\N	\N
8148	\N	\N	\N	\N	\N	\N
8149	\N	\N	\N	\N	\N	\N
8150	\N	\N	\N	\N	\N	\N
8151	\N	\N	\N	\N	\N	\N
8152	\N	\N	\N	\N	\N	\N
8153	\N	\N	\N	\N	\N	\N
8154	\N	\N	\N	\N	\N	\N
8155	\N	\N	\N	\N	\N	\N
8156	\N	\N	\N	\N	\N	\N
8157	\N	\N	\N	\N	\N	\N
8158	\N	\N	\N	\N	\N	\N
8159	\N	\N	\N	\N	\N	\N
8160	\N	\N	\N	\N	\N	\N
8161	\N	\N	\N	\N	\N	\N
8162	\N	\N	\N	\N	\N	\N
8163	\N	\N	\N	\N	\N	\N
8164	\N	\N	\N	\N	\N	\N
8165	\N	\N	\N	\N	\N	\N
8166	\N	\N	\N	\N	\N	\N
8167	\N	\N	\N	\N	\N	\N
8168	\N	\N	\N	\N	\N	\N
8169	\N	\N	\N	\N	\N	\N
8170	\N	\N	\N	\N	\N	\N
8171	\N	\N	\N	\N	\N	\N
8172	\N	\N	\N	\N	\N	\N
8173	\N	\N	\N	\N	\N	\N
8174	\N	\N	\N	\N	\N	\N
8175	\N	\N	\N	\N	\N	\N
8176	\N	\N	\N	\N	\N	\N
8177	\N	\N	\N	\N	\N	\N
8178	\N	\N	\N	\N	\N	\N
8179	\N	\N	\N	\N	\N	\N
8180	\N	\N	\N	\N	\N	\N
8181	\N	\N	\N	\N	\N	\N
8182	\N	\N	\N	\N	\N	\N
8183	\N	\N	\N	\N	\N	\N
8184	\N	\N	\N	\N	\N	\N
8185	\N	\N	\N	\N	\N	\N
8186	\N	\N	\N	\N	\N	\N
8187	\N	\N	\N	\N	\N	\N
8188	\N	\N	\N	\N	\N	\N
8189	\N	\N	\N	\N	\N	\N
8190	\N	\N	\N	\N	\N	\N
8191	\N	\N	\N	\N	\N	\N
8192	\N	\N	\N	\N	\N	\N
8193	\N	\N	\N	\N	\N	\N
8194	\N	\N	\N	\N	\N	\N
8195	\N	\N	\N	\N	\N	\N
8196	\N	\N	\N	\N	\N	\N
8197	\N	\N	\N	\N	\N	\N
8198	\N	\N	\N	\N	\N	\N
8199	\N	\N	\N	\N	\N	\N
8200	\N	\N	\N	\N	\N	\N
8201	\N	\N	\N	\N	\N	\N
8202	\N	\N	\N	\N	\N	\N
8203	\N	\N	\N	\N	\N	\N
8204	\N	\N	\N	\N	\N	\N
8205	\N	\N	\N	\N	\N	\N
8206	\N	\N	\N	\N	\N	\N
8207	\N	\N	\N	\N	\N	\N
8208	\N	\N	\N	\N	\N	\N
8209	\N	\N	\N	\N	\N	\N
8210	\N	\N	\N	\N	\N	\N
8211	\N	\N	\N	\N	\N	\N
8212	\N	\N	\N	\N	\N	\N
8213	\N	\N	\N	\N	\N	\N
8214	\N	\N	\N	\N	\N	\N
8215	\N	\N	\N	\N	\N	\N
8216	\N	\N	\N	\N	\N	\N
8217	\N	\N	\N	\N	\N	\N
8218	\N	\N	\N	\N	\N	\N
8219	\N	\N	\N	\N	\N	\N
8220	\N	\N	\N	\N	\N	\N
8221	\N	\N	\N	\N	\N	\N
8222	\N	\N	\N	\N	\N	\N
8223	\N	\N	\N	\N	\N	\N
8224	\N	\N	\N	\N	\N	\N
8225	\N	\N	\N	\N	\N	\N
8226	\N	\N	\N	\N	\N	\N
8227	\N	\N	\N	\N	\N	\N
8228	\N	\N	\N	\N	\N	\N
8229	\N	\N	\N	\N	\N	\N
8230	\N	\N	\N	\N	\N	\N
8231	\N	\N	\N	\N	\N	\N
8232	\N	\N	\N	\N	\N	\N
8233	\N	\N	\N	\N	\N	\N
8234	\N	\N	\N	\N	\N	\N
8235	\N	\N	\N	\N	\N	\N
8236	\N	\N	\N	\N	\N	\N
8237	\N	\N	\N	\N	\N	\N
8238	\N	\N	\N	\N	\N	\N
8239	\N	\N	\N	\N	\N	\N
8240	\N	\N	\N	\N	\N	\N
8241	\N	\N	\N	\N	\N	\N
8242	\N	\N	\N	\N	\N	\N
8243	\N	\N	\N	\N	\N	\N
8244	\N	\N	\N	\N	\N	\N
8245	\N	\N	\N	\N	\N	\N
8246	\N	\N	\N	\N	\N	\N
8247	\N	\N	\N	\N	\N	\N
8248	\N	\N	\N	\N	\N	\N
8249	\N	\N	\N	\N	\N	\N
8250	\N	\N	\N	\N	\N	\N
8251	\N	\N	\N	\N	\N	\N
8252	\N	\N	\N	\N	\N	\N
8253	\N	\N	\N	\N	\N	\N
8254	\N	\N	\N	\N	\N	\N
8255	\N	\N	\N	\N	\N	\N
8256	\N	\N	\N	\N	\N	\N
8257	\N	\N	\N	\N	\N	\N
8258	\N	\N	\N	\N	\N	\N
8259	\N	\N	\N	\N	\N	\N
8260	\N	\N	\N	\N	\N	\N
8261	\N	\N	\N	\N	\N	\N
8262	\N	\N	\N	\N	\N	\N
8263	\N	\N	\N	\N	\N	\N
8264	\N	\N	\N	\N	\N	\N
8265	\N	\N	\N	\N	\N	\N
8266	\N	\N	\N	\N	\N	\N
8267	\N	\N	\N	\N	\N	\N
8268	\N	\N	\N	\N	\N	\N
8269	\N	\N	\N	\N	\N	\N
8270	\N	\N	\N	\N	\N	\N
8271	\N	\N	\N	\N	\N	\N
8272	\N	\N	\N	\N	\N	\N
8273	\N	\N	\N	\N	\N	\N
8274	\N	\N	\N	\N	\N	\N
8275	\N	\N	\N	\N	\N	\N
8276	\N	\N	\N	\N	\N	\N
8277	\N	\N	\N	\N	\N	\N
8278	\N	\N	\N	\N	\N	\N
8279	\N	\N	\N	\N	\N	\N
8280	\N	\N	\N	\N	\N	\N
8281	\N	\N	\N	\N	\N	\N
8282	\N	\N	\N	\N	\N	\N
8283	\N	\N	\N	\N	\N	\N
8284	\N	\N	\N	\N	\N	\N
8285	\N	\N	\N	\N	\N	\N
8286	\N	\N	\N	\N	\N	\N
8287	\N	\N	\N	\N	\N	\N
8288	\N	\N	\N	\N	\N	\N
8289	\N	\N	\N	\N	\N	\N
8290	\N	\N	\N	\N	\N	\N
8291	\N	\N	\N	\N	\N	\N
8292	\N	\N	\N	\N	\N	\N
8293	\N	\N	\N	\N	\N	\N
8294	\N	\N	\N	\N	\N	\N
8295	\N	\N	\N	\N	\N	\N
8296	\N	\N	\N	\N	\N	\N
8297	\N	\N	\N	\N	\N	\N
8298	\N	\N	\N	\N	\N	\N
8299	\N	\N	\N	\N	\N	\N
8300	\N	\N	\N	\N	\N	\N
8301	\N	\N	\N	\N	\N	\N
8302	\N	\N	\N	\N	\N	\N
8303	\N	\N	\N	\N	\N	\N
8304	\N	\N	\N	\N	\N	\N
8305	\N	\N	\N	\N	\N	\N
8306	\N	\N	\N	\N	\N	\N
8307	\N	\N	\N	\N	\N	\N
8308	\N	\N	\N	\N	\N	\N
8309	\N	\N	\N	\N	\N	\N
8310	\N	\N	\N	\N	\N	\N
8311	\N	\N	\N	\N	\N	\N
8312	\N	\N	\N	\N	\N	\N
8313	\N	\N	\N	\N	\N	\N
8314	\N	\N	\N	\N	\N	\N
8315	\N	\N	\N	\N	\N	\N
8316	\N	\N	\N	\N	\N	\N
8317	\N	\N	\N	\N	\N	\N
8318	\N	\N	\N	\N	\N	\N
8319	\N	\N	\N	\N	\N	\N
8320	\N	\N	\N	\N	\N	\N
8321	\N	\N	\N	\N	\N	\N
8322	\N	\N	\N	\N	\N	\N
8323	\N	\N	\N	\N	\N	\N
8324	\N	\N	\N	\N	\N	\N
8325	\N	\N	\N	\N	\N	\N
8326	\N	\N	\N	\N	\N	\N
8327	\N	\N	\N	\N	\N	\N
8328	\N	\N	\N	\N	\N	\N
8329	\N	\N	\N	\N	\N	\N
8330	\N	\N	\N	\N	\N	\N
8331	\N	\N	\N	\N	\N	\N
8332	\N	\N	\N	\N	\N	\N
8333	\N	\N	\N	\N	\N	\N
8334	\N	\N	\N	\N	\N	\N
8335	\N	\N	\N	\N	\N	\N
8336	\N	\N	\N	\N	\N	\N
8337	\N	\N	\N	\N	\N	\N
8338	\N	\N	\N	\N	\N	\N
8339	\N	\N	\N	\N	\N	\N
8340	\N	\N	\N	\N	\N	\N
8341	\N	\N	\N	\N	\N	\N
8342	\N	\N	\N	\N	\N	\N
8343	\N	\N	\N	\N	\N	\N
8344	\N	\N	\N	\N	\N	\N
8345	\N	\N	\N	\N	\N	\N
8346	\N	\N	\N	\N	\N	\N
8347	\N	\N	\N	\N	\N	\N
8348	\N	\N	\N	\N	\N	\N
8349	\N	\N	\N	\N	\N	\N
8350	\N	\N	\N	\N	\N	\N
8351	\N	\N	\N	\N	\N	\N
8352	\N	\N	\N	\N	\N	\N
8353	\N	\N	\N	\N	\N	\N
8354	\N	\N	\N	\N	\N	\N
8355	\N	\N	\N	\N	\N	\N
8356	\N	\N	\N	\N	\N	\N
8357	\N	\N	\N	\N	\N	\N
8358	\N	\N	\N	\N	\N	\N
8359	\N	\N	\N	\N	\N	\N
8360	\N	\N	\N	\N	\N	\N
8361	\N	\N	\N	\N	\N	\N
8362	\N	\N	\N	\N	\N	\N
8363	\N	\N	\N	\N	\N	\N
8364	\N	\N	\N	\N	\N	\N
8365	\N	\N	\N	\N	\N	\N
8366	\N	\N	\N	\N	\N	\N
8367	\N	\N	\N	\N	\N	\N
8368	\N	\N	\N	\N	\N	\N
8369	\N	\N	\N	\N	\N	\N
8370	\N	\N	\N	\N	\N	\N
8371	\N	\N	\N	\N	\N	\N
8372	\N	\N	\N	\N	\N	\N
8373	\N	\N	\N	\N	\N	\N
8374	\N	\N	\N	\N	\N	\N
8375	\N	\N	\N	\N	\N	\N
8376	\N	\N	\N	\N	\N	\N
8377	\N	\N	\N	\N	\N	\N
8378	\N	\N	\N	\N	\N	\N
8379	\N	\N	\N	\N	\N	\N
8380	\N	\N	\N	\N	\N	\N
8381	\N	\N	\N	\N	\N	\N
8382	\N	\N	\N	\N	\N	\N
8383	\N	\N	\N	\N	\N	\N
8384	\N	\N	\N	\N	\N	\N
8385	\N	\N	\N	\N	\N	\N
8386	\N	\N	\N	\N	\N	\N
8387	\N	\N	\N	\N	\N	\N
8388	\N	\N	\N	\N	\N	\N
8389	\N	\N	\N	\N	\N	\N
8390	\N	\N	\N	\N	\N	\N
8391	\N	\N	\N	\N	\N	\N
8392	\N	\N	\N	\N	\N	\N
8393	\N	\N	\N	\N	\N	\N
8394	\N	\N	\N	\N	\N	\N
8395	\N	\N	\N	\N	\N	\N
8396	\N	\N	\N	\N	\N	\N
8397	\N	\N	\N	\N	\N	\N
8398	\N	\N	\N	\N	\N	\N
8399	\N	\N	\N	\N	\N	\N
8400	\N	\N	\N	\N	\N	\N
8401	\N	\N	\N	\N	\N	\N
8402	\N	\N	\N	\N	\N	\N
8403	\N	\N	\N	\N	\N	\N
8404	\N	\N	\N	\N	\N	\N
8405	\N	\N	\N	\N	\N	\N
8406	\N	\N	\N	\N	\N	\N
8407	\N	\N	\N	\N	\N	\N
8408	\N	\N	\N	\N	\N	\N
8409	\N	\N	\N	\N	\N	\N
8410	\N	\N	\N	\N	\N	\N
8411	\N	\N	\N	\N	\N	\N
8412	\N	\N	\N	\N	\N	\N
8413	\N	\N	\N	\N	\N	\N
8414	\N	\N	\N	\N	\N	\N
8415	\N	\N	\N	\N	\N	\N
8416	\N	\N	\N	\N	\N	\N
8417	\N	\N	\N	\N	\N	\N
8418	\N	\N	\N	\N	\N	\N
8419	\N	\N	\N	\N	\N	\N
8420	\N	\N	\N	\N	\N	\N
8421	\N	\N	\N	\N	\N	\N
8422	\N	\N	\N	\N	\N	\N
8423	\N	\N	\N	\N	\N	\N
8424	\N	\N	\N	\N	\N	\N
8425	\N	\N	\N	\N	\N	\N
8426	\N	\N	\N	\N	\N	\N
8427	\N	\N	\N	\N	\N	\N
8428	\N	\N	\N	\N	\N	\N
8429	\N	\N	\N	\N	\N	\N
8430	\N	\N	\N	\N	\N	\N
8431	\N	\N	\N	\N	\N	\N
8432	\N	\N	\N	\N	\N	\N
8433	\N	\N	\N	\N	\N	\N
8434	\N	\N	\N	\N	\N	\N
8435	\N	\N	\N	\N	\N	\N
8436	\N	\N	\N	\N	\N	\N
8437	\N	\N	\N	\N	\N	\N
8438	\N	\N	\N	\N	\N	\N
8439	\N	\N	\N	\N	\N	\N
8440	\N	\N	\N	\N	\N	\N
8441	\N	\N	\N	\N	\N	\N
8442	\N	\N	\N	\N	\N	\N
8443	\N	\N	\N	\N	\N	\N
8444	\N	\N	\N	\N	\N	\N
8445	\N	\N	\N	\N	\N	\N
8446	\N	\N	\N	\N	\N	\N
8447	\N	\N	\N	\N	\N	\N
8448	\N	\N	\N	\N	\N	\N
8449	\N	\N	\N	\N	\N	\N
8450	\N	\N	\N	\N	\N	\N
8451	\N	\N	\N	\N	\N	\N
8452	\N	\N	\N	\N	\N	\N
8453	\N	\N	\N	\N	\N	\N
8454	\N	\N	\N	\N	\N	\N
8455	\N	\N	\N	\N	\N	\N
8456	\N	\N	\N	\N	\N	\N
8457	\N	\N	\N	\N	\N	\N
8458	\N	\N	\N	\N	\N	\N
8459	\N	\N	\N	\N	\N	\N
8460	\N	\N	\N	\N	\N	\N
8461	\N	\N	\N	\N	\N	\N
8462	\N	\N	\N	\N	\N	\N
8463	\N	\N	\N	\N	\N	\N
8464	\N	\N	\N	\N	\N	\N
8465	\N	\N	\N	\N	\N	\N
8466	\N	\N	\N	\N	\N	\N
8467	\N	\N	\N	\N	\N	\N
8468	\N	\N	\N	\N	\N	\N
8469	\N	\N	\N	\N	\N	\N
8470	\N	\N	\N	\N	\N	\N
8471	\N	\N	\N	\N	\N	\N
8472	\N	\N	\N	\N	\N	\N
8473	\N	\N	\N	\N	\N	\N
8474	\N	\N	\N	\N	\N	\N
8475	\N	\N	\N	\N	\N	\N
8476	\N	\N	\N	\N	\N	\N
8477	\N	\N	\N	\N	\N	\N
8478	\N	\N	\N	\N	\N	\N
8479	\N	\N	\N	\N	\N	\N
8480	\N	\N	\N	\N	\N	\N
8481	\N	\N	\N	\N	\N	\N
8482	\N	\N	\N	\N	\N	\N
8483	\N	\N	\N	\N	\N	\N
8484	\N	\N	\N	\N	\N	\N
8485	\N	\N	\N	\N	\N	\N
8486	\N	\N	\N	\N	\N	\N
8487	\N	\N	\N	\N	\N	\N
8488	\N	\N	\N	\N	\N	\N
8489	\N	\N	\N	\N	\N	\N
8490	\N	\N	\N	\N	\N	\N
8491	\N	\N	\N	\N	\N	\N
8492	\N	\N	\N	\N	\N	\N
8493	\N	\N	\N	\N	\N	\N
8494	\N	\N	\N	\N	\N	\N
8495	\N	\N	\N	\N	\N	\N
8496	\N	\N	\N	\N	\N	\N
8497	\N	\N	\N	\N	\N	\N
8498	\N	\N	\N	\N	\N	\N
8499	\N	\N	\N	\N	\N	\N
8500	\N	\N	\N	\N	\N	\N
8501	\N	\N	\N	\N	\N	\N
8502	\N	\N	\N	\N	\N	\N
8503	\N	\N	\N	\N	\N	\N
8504	\N	\N	\N	\N	\N	\N
8505	\N	\N	\N	\N	\N	\N
8506	\N	\N	\N	\N	\N	\N
8507	\N	\N	\N	\N	\N	\N
8508	\N	\N	\N	\N	\N	\N
8509	\N	\N	\N	\N	\N	\N
8510	\N	\N	\N	\N	\N	\N
8511	\N	\N	\N	\N	\N	\N
8512	\N	\N	\N	\N	\N	\N
8513	\N	\N	\N	\N	\N	\N
8514	\N	\N	\N	\N	\N	\N
8515	\N	\N	\N	\N	\N	\N
8516	\N	\N	\N	\N	\N	\N
8517	\N	\N	\N	\N	\N	\N
8518	\N	\N	\N	\N	\N	\N
8519	\N	\N	\N	\N	\N	\N
8520	\N	\N	\N	\N	\N	\N
8521	\N	\N	\N	\N	\N	\N
8522	\N	\N	\N	\N	\N	\N
8523	\N	\N	\N	\N	\N	\N
8524	\N	\N	\N	\N	\N	\N
8525	\N	\N	\N	\N	\N	\N
8526	\N	\N	\N	\N	\N	\N
8527	\N	\N	\N	\N	\N	\N
8528	\N	\N	\N	\N	\N	\N
8529	\N	\N	\N	\N	\N	\N
8530	\N	\N	\N	\N	\N	\N
8531	\N	\N	\N	\N	\N	\N
8532	\N	\N	\N	\N	\N	\N
8533	\N	\N	\N	\N	\N	\N
8534	\N	\N	\N	\N	\N	\N
8535	\N	\N	\N	\N	\N	\N
8536	\N	\N	\N	\N	\N	\N
8537	\N	\N	\N	\N	\N	\N
8538	\N	\N	\N	\N	\N	\N
8539	\N	\N	\N	\N	\N	\N
8540	\N	\N	\N	\N	\N	\N
8541	\N	\N	\N	\N	\N	\N
8542	\N	\N	\N	\N	\N	\N
8543	\N	\N	\N	\N	\N	\N
8544	\N	\N	\N	\N	\N	\N
8545	\N	\N	\N	\N	\N	\N
8546	\N	\N	\N	\N	\N	\N
8547	\N	\N	\N	\N	\N	\N
8548	\N	\N	\N	\N	\N	\N
8549	\N	\N	\N	\N	\N	\N
8550	\N	\N	\N	\N	\N	\N
8551	\N	\N	\N	\N	\N	\N
8552	\N	\N	\N	\N	\N	\N
8553	\N	\N	\N	\N	\N	\N
8554	\N	\N	\N	\N	\N	\N
8555	\N	\N	\N	\N	\N	\N
8556	\N	\N	\N	\N	\N	\N
8557	\N	\N	\N	\N	\N	\N
8558	\N	\N	\N	\N	\N	\N
8559	\N	\N	\N	\N	\N	\N
8560	\N	\N	\N	\N	\N	\N
8561	\N	\N	\N	\N	\N	\N
8562	\N	\N	\N	\N	\N	\N
8563	\N	\N	\N	\N	\N	\N
8564	\N	\N	\N	\N	\N	\N
8565	\N	\N	\N	\N	\N	\N
8566	\N	\N	\N	\N	\N	\N
8567	\N	\N	\N	\N	\N	\N
8568	\N	\N	\N	\N	\N	\N
8569	\N	\N	\N	\N	\N	\N
8570	\N	\N	\N	\N	\N	\N
8571	\N	\N	\N	\N	\N	\N
8572	\N	\N	\N	\N	\N	\N
8573	\N	\N	\N	\N	\N	\N
8574	\N	\N	\N	\N	\N	\N
8575	\N	\N	\N	\N	\N	\N
8576	\N	\N	\N	\N	\N	\N
8577	\N	\N	\N	\N	\N	\N
8578	\N	\N	\N	\N	\N	\N
8579	\N	\N	\N	\N	\N	\N
8580	\N	\N	\N	\N	\N	\N
8581	\N	\N	\N	\N	\N	\N
8582	\N	\N	\N	\N	\N	\N
8583	\N	\N	\N	\N	\N	\N
8584	\N	\N	\N	\N	\N	\N
8585	\N	\N	\N	\N	\N	\N
8586	\N	\N	\N	\N	\N	\N
8587	\N	\N	\N	\N	\N	\N
8588	\N	\N	\N	\N	\N	\N
8589	\N	\N	\N	\N	\N	\N
8590	\N	\N	\N	\N	\N	\N
8591	\N	\N	\N	\N	\N	\N
8592	\N	\N	\N	\N	\N	\N
8593	\N	\N	\N	\N	\N	\N
8594	\N	\N	\N	\N	\N	\N
8595	\N	\N	\N	\N	\N	\N
8596	\N	\N	\N	\N	\N	\N
8597	\N	\N	\N	\N	\N	\N
8598	\N	\N	\N	\N	\N	\N
8599	\N	\N	\N	\N	\N	\N
8600	\N	\N	\N	\N	\N	\N
8601	\N	\N	\N	\N	\N	\N
8602	\N	\N	\N	\N	\N	\N
8603	\N	\N	\N	\N	\N	\N
8604	\N	\N	\N	\N	\N	\N
8605	\N	\N	\N	\N	\N	\N
8606	\N	\N	\N	\N	\N	\N
8607	\N	\N	\N	\N	\N	\N
8608	\N	\N	\N	\N	\N	\N
8609	\N	\N	\N	\N	\N	\N
8610	\N	\N	\N	\N	\N	\N
8611	\N	\N	\N	\N	\N	\N
8612	\N	\N	\N	\N	\N	\N
8613	\N	\N	\N	\N	\N	\N
8614	\N	\N	\N	\N	\N	\N
8615	\N	\N	\N	\N	\N	\N
8616	\N	\N	\N	\N	\N	\N
8617	\N	\N	\N	\N	\N	\N
8618	\N	\N	\N	\N	\N	\N
8619	\N	\N	\N	\N	\N	\N
8620	\N	\N	\N	\N	\N	\N
8621	\N	\N	\N	\N	\N	\N
8622	\N	\N	\N	\N	\N	\N
8623	\N	\N	\N	\N	\N	\N
8624	\N	\N	\N	\N	\N	\N
8625	\N	\N	\N	\N	\N	\N
8626	\N	\N	\N	\N	\N	\N
8627	\N	\N	\N	\N	\N	\N
8628	\N	\N	\N	\N	\N	\N
8629	\N	\N	\N	\N	\N	\N
8630	\N	\N	\N	\N	\N	\N
8631	\N	\N	\N	\N	\N	\N
8632	\N	\N	\N	\N	\N	\N
8633	\N	\N	\N	\N	\N	\N
8634	\N	\N	\N	\N	\N	\N
8635	\N	\N	\N	\N	\N	\N
8636	\N	\N	\N	\N	\N	\N
8637	\N	\N	\N	\N	\N	\N
8638	\N	\N	\N	\N	\N	\N
8639	\N	\N	\N	\N	\N	\N
8640	\N	\N	\N	\N	\N	\N
8641	\N	\N	\N	\N	\N	\N
8642	\N	\N	\N	\N	\N	\N
8643	\N	\N	\N	\N	\N	\N
8644	\N	\N	\N	\N	\N	\N
8645	\N	\N	\N	\N	\N	\N
8646	\N	\N	\N	\N	\N	\N
8647	\N	\N	\N	\N	\N	\N
8648	\N	\N	\N	\N	\N	\N
8649	\N	\N	\N	\N	\N	\N
8650	\N	\N	\N	\N	\N	\N
8651	\N	\N	\N	\N	\N	\N
8652	\N	\N	\N	\N	\N	\N
8653	\N	\N	\N	\N	\N	\N
8654	\N	\N	\N	\N	\N	\N
8655	\N	\N	\N	\N	\N	\N
8656	\N	\N	\N	\N	\N	\N
8657	\N	\N	\N	\N	\N	\N
8658	\N	\N	\N	\N	\N	\N
8659	\N	\N	\N	\N	\N	\N
8660	\N	\N	\N	\N	\N	\N
8661	\N	\N	\N	\N	\N	\N
8662	\N	\N	\N	\N	\N	\N
8663	\N	\N	\N	\N	\N	\N
8664	\N	\N	\N	\N	\N	\N
8665	\N	\N	\N	\N	\N	\N
8666	\N	\N	\N	\N	\N	\N
8667	\N	\N	\N	\N	\N	\N
8668	\N	\N	\N	\N	\N	\N
8669	\N	\N	\N	\N	\N	\N
8670	\N	\N	\N	\N	\N	\N
8671	\N	\N	\N	\N	\N	\N
8672	\N	\N	\N	\N	\N	\N
8673	\N	\N	\N	\N	\N	\N
8674	\N	\N	\N	\N	\N	\N
8675	\N	\N	\N	\N	\N	\N
8676	\N	\N	\N	\N	\N	\N
8677	\N	\N	\N	\N	\N	\N
8678	\N	\N	\N	\N	\N	\N
8679	\N	\N	\N	\N	\N	\N
8680	\N	\N	\N	\N	\N	\N
8681	\N	\N	\N	\N	\N	\N
8682	\N	\N	\N	\N	\N	\N
8683	\N	\N	\N	\N	\N	\N
8684	\N	\N	\N	\N	\N	\N
8685	\N	\N	\N	\N	\N	\N
8686	\N	\N	\N	\N	\N	\N
8687	\N	\N	\N	\N	\N	\N
8688	\N	\N	\N	\N	\N	\N
8689	\N	\N	\N	\N	\N	\N
8690	\N	\N	\N	\N	\N	\N
8691	\N	\N	\N	\N	\N	\N
8692	\N	\N	\N	\N	\N	\N
8693	\N	\N	\N	\N	\N	\N
8694	\N	\N	\N	\N	\N	\N
8695	\N	\N	\N	\N	\N	\N
8696	\N	\N	\N	\N	\N	\N
8697	\N	\N	\N	\N	\N	\N
8698	\N	\N	\N	\N	\N	\N
8699	\N	\N	\N	\N	\N	\N
8700	\N	\N	\N	\N	\N	\N
8701	\N	\N	\N	\N	\N	\N
8702	\N	\N	\N	\N	\N	\N
8703	\N	\N	\N	\N	\N	\N
8704	\N	\N	\N	\N	\N	\N
8705	\N	\N	\N	\N	\N	\N
8706	\N	\N	\N	\N	\N	\N
8707	\N	\N	\N	\N	\N	\N
8708	\N	\N	\N	\N	\N	\N
8709	\N	\N	\N	\N	\N	\N
8710	\N	\N	\N	\N	\N	\N
8711	\N	\N	\N	\N	\N	\N
8712	\N	\N	\N	\N	\N	\N
8713	\N	\N	\N	\N	\N	\N
8714	\N	\N	\N	\N	\N	\N
8715	\N	\N	\N	\N	\N	\N
8716	\N	\N	\N	\N	\N	\N
8717	\N	\N	\N	\N	\N	\N
8718	\N	\N	\N	\N	\N	\N
8719	\N	\N	\N	\N	\N	\N
8720	\N	\N	\N	\N	\N	\N
8721	\N	\N	\N	\N	\N	\N
8722	\N	\N	\N	\N	\N	\N
8723	\N	\N	\N	\N	\N	\N
8724	\N	\N	\N	\N	\N	\N
8725	\N	\N	\N	\N	\N	\N
8726	\N	\N	\N	\N	\N	\N
8727	\N	\N	\N	\N	\N	\N
8728	\N	\N	\N	\N	\N	\N
8729	\N	\N	\N	\N	\N	\N
8730	\N	\N	\N	\N	\N	\N
8731	\N	\N	\N	\N	\N	\N
8732	\N	\N	\N	\N	\N	\N
8733	\N	\N	\N	\N	\N	\N
8734	\N	\N	\N	\N	\N	\N
8735	\N	\N	\N	\N	\N	\N
8736	\N	\N	\N	\N	\N	\N
8737	\N	\N	\N	\N	\N	\N
8738	\N	\N	\N	\N	\N	\N
8739	\N	\N	\N	\N	\N	\N
8740	\N	\N	\N	\N	\N	\N
8741	\N	\N	\N	\N	\N	\N
8742	\N	\N	\N	\N	\N	\N
8743	\N	\N	\N	\N	\N	\N
8744	\N	\N	\N	\N	\N	\N
8745	\N	\N	\N	\N	\N	\N
8746	\N	\N	\N	\N	\N	\N
8747	\N	\N	\N	\N	\N	\N
8748	\N	\N	\N	\N	\N	\N
8749	\N	\N	\N	\N	\N	\N
8750	\N	\N	\N	\N	\N	\N
8751	\N	\N	\N	\N	\N	\N
8752	\N	\N	\N	\N	\N	\N
8753	\N	\N	\N	\N	\N	\N
8754	\N	\N	\N	\N	\N	\N
8755	\N	\N	\N	\N	\N	\N
8756	\N	\N	\N	\N	\N	\N
8757	\N	\N	\N	\N	\N	\N
8758	\N	\N	\N	\N	\N	\N
8759	\N	\N	\N	\N	\N	\N
8760	\N	\N	\N	\N	\N	\N
8761	\N	\N	\N	\N	\N	\N
8762	\N	\N	\N	\N	\N	\N
8763	\N	\N	\N	\N	\N	\N
8764	\N	\N	\N	\N	\N	\N
8765	\N	\N	\N	\N	\N	\N
8766	\N	\N	\N	\N	\N	\N
8767	\N	\N	\N	\N	\N	\N
8768	\N	\N	\N	\N	\N	\N
8769	\N	\N	\N	\N	\N	\N
8770	\N	\N	\N	\N	\N	\N
8771	\N	\N	\N	\N	\N	\N
8772	\N	\N	\N	\N	\N	\N
8773	\N	\N	\N	\N	\N	\N
8774	\N	\N	\N	\N	\N	\N
8775	\N	\N	\N	\N	\N	\N
8776	\N	\N	\N	\N	\N	\N
8777	\N	\N	\N	\N	\N	\N
8778	\N	\N	\N	\N	\N	\N
8779	\N	\N	\N	\N	\N	\N
8780	\N	\N	\N	\N	\N	\N
8781	\N	\N	\N	\N	\N	\N
8782	\N	\N	\N	\N	\N	\N
8783	\N	\N	\N	\N	\N	\N
8784	\N	\N	\N	\N	\N	\N
8785	\N	\N	\N	\N	\N	\N
8786	\N	\N	\N	\N	\N	\N
8787	\N	\N	\N	\N	\N	\N
8788	\N	\N	\N	\N	\N	\N
8789	\N	\N	\N	\N	\N	\N
8790	\N	\N	\N	\N	\N	\N
8791	\N	\N	\N	\N	\N	\N
8792	\N	\N	\N	\N	\N	\N
8793	\N	\N	\N	\N	\N	\N
8794	\N	\N	\N	\N	\N	\N
8795	\N	\N	\N	\N	\N	\N
8796	\N	\N	\N	\N	\N	\N
8797	\N	\N	\N	\N	\N	\N
8798	\N	\N	\N	\N	\N	\N
8799	\N	\N	\N	\N	\N	\N
8800	\N	\N	\N	\N	\N	\N
8801	\N	\N	\N	\N	\N	\N
8802	\N	\N	\N	\N	\N	\N
8803	\N	\N	\N	\N	\N	\N
8804	\N	\N	\N	\N	\N	\N
8805	\N	\N	\N	\N	\N	\N
8806	\N	\N	\N	\N	\N	\N
8807	\N	\N	\N	\N	\N	\N
8808	\N	\N	\N	\N	\N	\N
8809	\N	\N	\N	\N	\N	\N
8810	\N	\N	\N	\N	\N	\N
8811	\N	\N	\N	\N	\N	\N
8812	\N	\N	\N	\N	\N	\N
8813	\N	\N	\N	\N	\N	\N
8814	\N	\N	\N	\N	\N	\N
8815	\N	\N	\N	\N	\N	\N
8816	\N	\N	\N	\N	\N	\N
8817	\N	\N	\N	\N	\N	\N
8818	\N	\N	\N	\N	\N	\N
8819	\N	\N	\N	\N	\N	\N
8820	\N	\N	\N	\N	\N	\N
8821	\N	\N	\N	\N	\N	\N
8822	\N	\N	\N	\N	\N	\N
8823	\N	\N	\N	\N	\N	\N
8824	\N	\N	\N	\N	\N	\N
8825	\N	\N	\N	\N	\N	\N
8826	\N	\N	\N	\N	\N	\N
8827	\N	\N	\N	\N	\N	\N
8828	\N	\N	\N	\N	\N	\N
8829	\N	\N	\N	\N	\N	\N
8830	\N	\N	\N	\N	\N	\N
8831	\N	\N	\N	\N	\N	\N
8832	\N	\N	\N	\N	\N	\N
8833	\N	\N	\N	\N	\N	\N
8834	\N	\N	\N	\N	\N	\N
8835	\N	\N	\N	\N	\N	\N
8836	\N	\N	\N	\N	\N	\N
8837	\N	\N	\N	\N	\N	\N
8838	\N	\N	\N	\N	\N	\N
8839	\N	\N	\N	\N	\N	\N
8840	\N	\N	\N	\N	\N	\N
8841	\N	\N	\N	\N	\N	\N
8842	\N	\N	\N	\N	\N	\N
8843	\N	\N	\N	\N	\N	\N
8844	\N	\N	\N	\N	\N	\N
8845	\N	\N	\N	\N	\N	\N
8846	\N	\N	\N	\N	\N	\N
8847	\N	\N	\N	\N	\N	\N
8848	\N	\N	\N	\N	\N	\N
8849	\N	\N	\N	\N	\N	\N
8850	\N	\N	\N	\N	\N	\N
8851	\N	\N	\N	\N	\N	\N
8852	\N	\N	\N	\N	\N	\N
8853	\N	\N	\N	\N	\N	\N
8854	\N	\N	\N	\N	\N	\N
8855	\N	\N	\N	\N	\N	\N
8856	\N	\N	\N	\N	\N	\N
8857	\N	\N	\N	\N	\N	\N
8858	\N	\N	\N	\N	\N	\N
8859	\N	\N	\N	\N	\N	\N
8860	\N	\N	\N	\N	\N	\N
8861	\N	\N	\N	\N	\N	\N
8862	\N	\N	\N	\N	\N	\N
8863	\N	\N	\N	\N	\N	\N
8864	\N	\N	\N	\N	\N	\N
8865	\N	\N	\N	\N	\N	\N
8866	\N	\N	\N	\N	\N	\N
8867	\N	\N	\N	\N	\N	\N
8868	\N	\N	\N	\N	\N	\N
8869	\N	\N	\N	\N	\N	\N
8870	\N	\N	\N	\N	\N	\N
8871	\N	\N	\N	\N	\N	\N
8872	\N	\N	\N	\N	\N	\N
8873	\N	\N	\N	\N	\N	\N
8874	\N	\N	\N	\N	\N	\N
8875	\N	\N	\N	\N	\N	\N
8876	\N	\N	\N	\N	\N	\N
8877	\N	\N	\N	\N	\N	\N
8878	\N	\N	\N	\N	\N	\N
8879	\N	\N	\N	\N	\N	\N
8880	\N	\N	\N	\N	\N	\N
8881	\N	\N	\N	\N	\N	\N
8882	\N	\N	\N	\N	\N	\N
8883	\N	\N	\N	\N	\N	\N
8884	\N	\N	\N	\N	\N	\N
8885	\N	\N	\N	\N	\N	\N
8886	\N	\N	\N	\N	\N	\N
8887	\N	\N	\N	\N	\N	\N
8888	\N	\N	\N	\N	\N	\N
8889	\N	\N	\N	\N	\N	\N
8890	\N	\N	\N	\N	\N	\N
8891	\N	\N	\N	\N	\N	\N
8892	\N	\N	\N	\N	\N	\N
8893	\N	\N	\N	\N	\N	\N
8894	\N	\N	\N	\N	\N	\N
8895	\N	\N	\N	\N	\N	\N
8896	\N	\N	\N	\N	\N	\N
8897	\N	\N	\N	\N	\N	\N
8898	\N	\N	\N	\N	\N	\N
8899	\N	\N	\N	\N	\N	\N
8900	\N	\N	\N	\N	\N	\N
8901	\N	\N	\N	\N	\N	\N
8902	\N	\N	\N	\N	\N	\N
8903	\N	\N	\N	\N	\N	\N
8904	\N	\N	\N	\N	\N	\N
8905	\N	\N	\N	\N	\N	\N
8906	\N	\N	\N	\N	\N	\N
8907	\N	\N	\N	\N	\N	\N
8908	\N	\N	\N	\N	\N	\N
8909	\N	\N	\N	\N	\N	\N
8910	\N	\N	\N	\N	\N	\N
8911	\N	\N	\N	\N	\N	\N
8912	\N	\N	\N	\N	\N	\N
8913	\N	\N	\N	\N	\N	\N
8914	\N	\N	\N	\N	\N	\N
8915	\N	\N	\N	\N	\N	\N
8916	\N	\N	\N	\N	\N	\N
8917	\N	\N	\N	\N	\N	\N
8918	\N	\N	\N	\N	\N	\N
8919	\N	\N	\N	\N	\N	\N
8920	\N	\N	\N	\N	\N	\N
8921	\N	\N	\N	\N	\N	\N
8922	\N	\N	\N	\N	\N	\N
8923	\N	\N	\N	\N	\N	\N
8924	\N	\N	\N	\N	\N	\N
8925	\N	\N	\N	\N	\N	\N
8926	\N	\N	\N	\N	\N	\N
8927	\N	\N	\N	\N	\N	\N
8928	\N	\N	\N	\N	\N	\N
8929	\N	\N	\N	\N	\N	\N
8930	\N	\N	\N	\N	\N	\N
8931	\N	\N	\N	\N	\N	\N
8932	\N	\N	\N	\N	\N	\N
8933	\N	\N	\N	\N	\N	\N
8934	\N	\N	\N	\N	\N	\N
8935	\N	\N	\N	\N	\N	\N
8936	\N	\N	\N	\N	\N	\N
8937	\N	\N	\N	\N	\N	\N
8938	\N	\N	\N	\N	\N	\N
8939	\N	\N	\N	\N	\N	\N
8940	\N	\N	\N	\N	\N	\N
8941	\N	\N	\N	\N	\N	\N
8942	\N	\N	\N	\N	\N	\N
8943	\N	\N	\N	\N	\N	\N
8944	\N	\N	\N	\N	\N	\N
8945	\N	\N	\N	\N	\N	\N
8946	\N	\N	\N	\N	\N	\N
8947	\N	\N	\N	\N	\N	\N
8948	\N	\N	\N	\N	\N	\N
8949	\N	\N	\N	\N	\N	\N
8950	\N	\N	\N	\N	\N	\N
8951	\N	\N	\N	\N	\N	\N
8952	\N	\N	\N	\N	\N	\N
8953	\N	\N	\N	\N	\N	\N
8954	\N	\N	\N	\N	\N	\N
8955	\N	\N	\N	\N	\N	\N
8956	\N	\N	\N	\N	\N	\N
8957	\N	\N	\N	\N	\N	\N
8958	\N	\N	\N	\N	\N	\N
8959	\N	\N	\N	\N	\N	\N
8960	\N	\N	\N	\N	\N	\N
8961	\N	\N	\N	\N	\N	\N
8962	\N	\N	\N	\N	\N	\N
8963	\N	\N	\N	\N	\N	\N
8964	\N	\N	\N	\N	\N	\N
8965	\N	\N	\N	\N	\N	\N
8966	\N	\N	\N	\N	\N	\N
8967	\N	\N	\N	\N	\N	\N
8968	\N	\N	\N	\N	\N	\N
8969	\N	\N	\N	\N	\N	\N
8970	\N	\N	\N	\N	\N	\N
8971	\N	\N	\N	\N	\N	\N
8972	\N	\N	\N	\N	\N	\N
8973	\N	\N	\N	\N	\N	\N
8974	\N	\N	\N	\N	\N	\N
8975	\N	\N	\N	\N	\N	\N
8976	\N	\N	\N	\N	\N	\N
8977	\N	\N	\N	\N	\N	\N
8978	\N	\N	\N	\N	\N	\N
8979	\N	\N	\N	\N	\N	\N
8980	\N	\N	\N	\N	\N	\N
8981	\N	\N	\N	\N	\N	\N
8982	\N	\N	\N	\N	\N	\N
8983	\N	\N	\N	\N	\N	\N
8984	\N	\N	\N	\N	\N	\N
8985	\N	\N	\N	\N	\N	\N
8986	\N	\N	\N	\N	\N	\N
8987	\N	\N	\N	\N	\N	\N
8988	\N	\N	\N	\N	\N	\N
8989	\N	\N	\N	\N	\N	\N
8990	\N	\N	\N	\N	\N	\N
8991	\N	\N	\N	\N	\N	\N
8992	\N	\N	\N	\N	\N	\N
8993	\N	\N	\N	\N	\N	\N
8994	\N	\N	\N	\N	\N	\N
8995	\N	\N	\N	\N	\N	\N
8996	\N	\N	\N	\N	\N	\N
8997	\N	\N	\N	\N	\N	\N
8998	\N	\N	\N	\N	\N	\N
8999	\N	\N	\N	\N	\N	\N
9000	\N	\N	\N	\N	\N	\N
9001	\N	\N	\N	\N	\N	\N
9002	\N	\N	\N	\N	\N	\N
9003	\N	\N	\N	\N	\N	\N
9004	\N	\N	\N	\N	\N	\N
9005	\N	\N	\N	\N	\N	\N
9006	\N	\N	\N	\N	\N	\N
9007	\N	\N	\N	\N	\N	\N
9008	\N	\N	\N	\N	\N	\N
9009	\N	\N	\N	\N	\N	\N
9010	\N	\N	\N	\N	\N	\N
9011	\N	\N	\N	\N	\N	\N
9012	\N	\N	\N	\N	\N	\N
9013	\N	\N	\N	\N	\N	\N
9014	\N	\N	\N	\N	\N	\N
9015	\N	\N	\N	\N	\N	\N
9016	\N	\N	\N	\N	\N	\N
9017	\N	\N	\N	\N	\N	\N
9018	\N	\N	\N	\N	\N	\N
9019	\N	\N	\N	\N	\N	\N
9020	\N	\N	\N	\N	\N	\N
9021	\N	\N	\N	\N	\N	\N
9022	\N	\N	\N	\N	\N	\N
9023	\N	\N	\N	\N	\N	\N
9024	\N	\N	\N	\N	\N	\N
9025	\N	\N	\N	\N	\N	\N
9026	\N	\N	\N	\N	\N	\N
9027	\N	\N	\N	\N	\N	\N
9028	\N	\N	\N	\N	\N	\N
9029	\N	\N	\N	\N	\N	\N
9030	\N	\N	\N	\N	\N	\N
9031	\N	\N	\N	\N	\N	\N
9032	\N	\N	\N	\N	\N	\N
9033	\N	\N	\N	\N	\N	\N
9034	\N	\N	\N	\N	\N	\N
9035	\N	\N	\N	\N	\N	\N
9036	\N	\N	\N	\N	\N	\N
9037	\N	\N	\N	\N	\N	\N
9038	\N	\N	\N	\N	\N	\N
9039	\N	\N	\N	\N	\N	\N
9040	\N	\N	\N	\N	\N	\N
9041	\N	\N	\N	\N	\N	\N
9042	\N	\N	\N	\N	\N	\N
9043	\N	\N	\N	\N	\N	\N
9044	\N	\N	\N	\N	\N	\N
9045	\N	\N	\N	\N	\N	\N
9046	\N	\N	\N	\N	\N	\N
9047	\N	\N	\N	\N	\N	\N
9048	\N	\N	\N	\N	\N	\N
9049	\N	\N	\N	\N	\N	\N
9050	\N	\N	\N	\N	\N	\N
9051	\N	\N	\N	\N	\N	\N
9052	\N	\N	\N	\N	\N	\N
9053	\N	\N	\N	\N	\N	\N
9054	\N	\N	\N	\N	\N	\N
9055	\N	\N	\N	\N	\N	\N
9056	\N	\N	\N	\N	\N	\N
9057	\N	\N	\N	\N	\N	\N
9058	\N	\N	\N	\N	\N	\N
9059	\N	\N	\N	\N	\N	\N
9060	\N	\N	\N	\N	\N	\N
9061	\N	\N	\N	\N	\N	\N
9062	\N	\N	\N	\N	\N	\N
9063	\N	\N	\N	\N	\N	\N
9064	\N	\N	\N	\N	\N	\N
9065	\N	\N	\N	\N	\N	\N
9066	\N	\N	\N	\N	\N	\N
9067	\N	\N	\N	\N	\N	\N
9068	\N	\N	\N	\N	\N	\N
9069	\N	\N	\N	\N	\N	\N
9070	\N	\N	\N	\N	\N	\N
9071	\N	\N	\N	\N	\N	\N
9072	\N	\N	\N	\N	\N	\N
9073	\N	\N	\N	\N	\N	\N
9074	\N	\N	\N	\N	\N	\N
9075	\N	\N	\N	\N	\N	\N
9076	\N	\N	\N	\N	\N	\N
9077	\N	\N	\N	\N	\N	\N
9078	\N	\N	\N	\N	\N	\N
9079	\N	\N	\N	\N	\N	\N
9080	\N	\N	\N	\N	\N	\N
9081	\N	\N	\N	\N	\N	\N
9082	\N	\N	\N	\N	\N	\N
9083	\N	\N	\N	\N	\N	\N
9084	\N	\N	\N	\N	\N	\N
9085	\N	\N	\N	\N	\N	\N
9086	\N	\N	\N	\N	\N	\N
9087	\N	\N	\N	\N	\N	\N
9088	\N	\N	\N	\N	\N	\N
9089	\N	\N	\N	\N	\N	\N
9090	\N	\N	\N	\N	\N	\N
9091	\N	\N	\N	\N	\N	\N
9092	\N	\N	\N	\N	\N	\N
9093	\N	\N	\N	\N	\N	\N
9094	\N	\N	\N	\N	\N	\N
9095	\N	\N	\N	\N	\N	\N
9096	\N	\N	\N	\N	\N	\N
9097	\N	\N	\N	\N	\N	\N
9098	\N	\N	\N	\N	\N	\N
9099	\N	\N	\N	\N	\N	\N
9100	\N	\N	\N	\N	\N	\N
9101	\N	\N	\N	\N	\N	\N
9102	\N	\N	\N	\N	\N	\N
9103	\N	\N	\N	\N	\N	\N
9104	\N	\N	\N	\N	\N	\N
9105	\N	\N	\N	\N	\N	\N
9106	\N	\N	\N	\N	\N	\N
9107	\N	\N	\N	\N	\N	\N
9108	\N	\N	\N	\N	\N	\N
9109	\N	\N	\N	\N	\N	\N
9110	\N	\N	\N	\N	\N	\N
9111	\N	\N	\N	\N	\N	\N
9112	\N	\N	\N	\N	\N	\N
9113	\N	\N	\N	\N	\N	\N
9114	\N	\N	\N	\N	\N	\N
9115	\N	\N	\N	\N	\N	\N
9116	\N	\N	\N	\N	\N	\N
9117	\N	\N	\N	\N	\N	\N
9118	\N	\N	\N	\N	\N	\N
9119	\N	\N	\N	\N	\N	\N
9120	\N	\N	\N	\N	\N	\N
9121	\N	\N	\N	\N	\N	\N
9122	\N	\N	\N	\N	\N	\N
9123	\N	\N	\N	\N	\N	\N
9124	\N	\N	\N	\N	\N	\N
9125	\N	\N	\N	\N	\N	\N
9126	\N	\N	\N	\N	\N	\N
9127	\N	\N	\N	\N	\N	\N
9128	\N	\N	\N	\N	\N	\N
9129	\N	\N	\N	\N	\N	\N
9130	\N	\N	\N	\N	\N	\N
9131	\N	\N	\N	\N	\N	\N
9132	\N	\N	\N	\N	\N	\N
9133	\N	\N	\N	\N	\N	\N
9134	\N	\N	\N	\N	\N	\N
9135	\N	\N	\N	\N	\N	\N
9136	\N	\N	\N	\N	\N	\N
9137	\N	\N	\N	\N	\N	\N
9138	\N	\N	\N	\N	\N	\N
9139	\N	\N	\N	\N	\N	\N
9140	\N	\N	\N	\N	\N	\N
9141	\N	\N	\N	\N	\N	\N
9142	\N	\N	\N	\N	\N	\N
9143	\N	\N	\N	\N	\N	\N
9144	\N	\N	\N	\N	\N	\N
9145	\N	\N	\N	\N	\N	\N
9146	\N	\N	\N	\N	\N	\N
9147	\N	\N	\N	\N	\N	\N
9148	\N	\N	\N	\N	\N	\N
9149	\N	\N	\N	\N	\N	\N
9150	\N	\N	\N	\N	\N	\N
9151	\N	\N	\N	\N	\N	\N
9152	\N	\N	\N	\N	\N	\N
9153	\N	\N	\N	\N	\N	\N
9154	\N	\N	\N	\N	\N	\N
9155	\N	\N	\N	\N	\N	\N
9156	\N	\N	\N	\N	\N	\N
9157	\N	\N	\N	\N	\N	\N
9158	\N	\N	\N	\N	\N	\N
9159	\N	\N	\N	\N	\N	\N
9160	\N	\N	\N	\N	\N	\N
9161	\N	\N	\N	\N	\N	\N
9162	\N	\N	\N	\N	\N	\N
9163	\N	\N	\N	\N	\N	\N
9164	\N	\N	\N	\N	\N	\N
9165	\N	\N	\N	\N	\N	\N
9166	\N	\N	\N	\N	\N	\N
9167	\N	\N	\N	\N	\N	\N
9168	\N	\N	\N	\N	\N	\N
9169	\N	\N	\N	\N	\N	\N
9170	\N	\N	\N	\N	\N	\N
9171	\N	\N	\N	\N	\N	\N
9172	\N	\N	\N	\N	\N	\N
9173	\N	\N	\N	\N	\N	\N
9174	\N	\N	\N	\N	\N	\N
9175	\N	\N	\N	\N	\N	\N
9176	\N	\N	\N	\N	\N	\N
9177	\N	\N	\N	\N	\N	\N
9178	\N	\N	\N	\N	\N	\N
9179	\N	\N	\N	\N	\N	\N
9180	\N	\N	\N	\N	\N	\N
9181	\N	\N	\N	\N	\N	\N
9182	\N	\N	\N	\N	\N	\N
9183	\N	\N	\N	\N	\N	\N
9184	\N	\N	\N	\N	\N	\N
9185	\N	\N	\N	\N	\N	\N
9186	\N	\N	\N	\N	\N	\N
9187	\N	\N	\N	\N	\N	\N
9188	\N	\N	\N	\N	\N	\N
9189	\N	\N	\N	\N	\N	\N
9190	\N	\N	\N	\N	\N	\N
9191	\N	\N	\N	\N	\N	\N
9192	\N	\N	\N	\N	\N	\N
9193	\N	\N	\N	\N	\N	\N
9194	\N	\N	\N	\N	\N	\N
9195	\N	\N	\N	\N	\N	\N
9196	\N	\N	\N	\N	\N	\N
9197	\N	\N	\N	\N	\N	\N
9198	\N	\N	\N	\N	\N	\N
9199	\N	\N	\N	\N	\N	\N
9200	\N	\N	\N	\N	\N	\N
9201	\N	\N	\N	\N	\N	\N
9202	\N	\N	\N	\N	\N	\N
9203	\N	\N	\N	\N	\N	\N
9204	\N	\N	\N	\N	\N	\N
9205	\N	\N	\N	\N	\N	\N
9206	\N	\N	\N	\N	\N	\N
9207	\N	\N	\N	\N	\N	\N
9208	\N	\N	\N	\N	\N	\N
9209	\N	\N	\N	\N	\N	\N
9210	\N	\N	\N	\N	\N	\N
9211	\N	\N	\N	\N	\N	\N
9212	\N	\N	\N	\N	\N	\N
9213	\N	\N	\N	\N	\N	\N
9214	\N	\N	\N	\N	\N	\N
9215	\N	\N	\N	\N	\N	\N
9216	\N	\N	\N	\N	\N	\N
9217	\N	\N	\N	\N	\N	\N
9218	\N	\N	\N	\N	\N	\N
9219	\N	\N	\N	\N	\N	\N
9220	\N	\N	\N	\N	\N	\N
9221	\N	\N	\N	\N	\N	\N
9222	\N	\N	\N	\N	\N	\N
9223	\N	\N	\N	\N	\N	\N
9224	\N	\N	\N	\N	\N	\N
9225	\N	\N	\N	\N	\N	\N
9226	\N	\N	\N	\N	\N	\N
9227	\N	\N	\N	\N	\N	\N
9228	\N	\N	\N	\N	\N	\N
9229	\N	\N	\N	\N	\N	\N
9230	\N	\N	\N	\N	\N	\N
9231	\N	\N	\N	\N	\N	\N
9232	\N	\N	\N	\N	\N	\N
9233	\N	\N	\N	\N	\N	\N
9234	\N	\N	\N	\N	\N	\N
9235	\N	\N	\N	\N	\N	\N
9236	\N	\N	\N	\N	\N	\N
9237	\N	\N	\N	\N	\N	\N
9238	\N	\N	\N	\N	\N	\N
9239	\N	\N	\N	\N	\N	\N
9240	\N	\N	\N	\N	\N	\N
9241	\N	\N	\N	\N	\N	\N
9242	\N	\N	\N	\N	\N	\N
9243	\N	\N	\N	\N	\N	\N
9244	\N	\N	\N	\N	\N	\N
9245	\N	\N	\N	\N	\N	\N
9246	\N	\N	\N	\N	\N	\N
9247	\N	\N	\N	\N	\N	\N
9248	\N	\N	\N	\N	\N	\N
9249	\N	\N	\N	\N	\N	\N
9250	\N	\N	\N	\N	\N	\N
9251	\N	\N	\N	\N	\N	\N
9252	\N	\N	\N	\N	\N	\N
9253	\N	\N	\N	\N	\N	\N
9254	\N	\N	\N	\N	\N	\N
9255	\N	\N	\N	\N	\N	\N
9256	\N	\N	\N	\N	\N	\N
9257	\N	\N	\N	\N	\N	\N
9258	\N	\N	\N	\N	\N	\N
9259	\N	\N	\N	\N	\N	\N
9260	\N	\N	\N	\N	\N	\N
9261	\N	\N	\N	\N	\N	\N
9262	\N	\N	\N	\N	\N	\N
9263	\N	\N	\N	\N	\N	\N
9264	\N	\N	\N	\N	\N	\N
9265	\N	\N	\N	\N	\N	\N
9266	\N	\N	\N	\N	\N	\N
9267	\N	\N	\N	\N	\N	\N
9268	\N	\N	\N	\N	\N	\N
9269	\N	\N	\N	\N	\N	\N
9270	\N	\N	\N	\N	\N	\N
9271	\N	\N	\N	\N	\N	\N
9272	\N	\N	\N	\N	\N	\N
9273	\N	\N	\N	\N	\N	\N
9274	\N	\N	\N	\N	\N	\N
9275	\N	\N	\N	\N	\N	\N
9276	\N	\N	\N	\N	\N	\N
9277	\N	\N	\N	\N	\N	\N
9278	\N	\N	\N	\N	\N	\N
9279	\N	\N	\N	\N	\N	\N
9280	\N	\N	\N	\N	\N	\N
9281	\N	\N	\N	\N	\N	\N
9282	\N	\N	\N	\N	\N	\N
9283	\N	\N	\N	\N	\N	\N
9284	\N	\N	\N	\N	\N	\N
9285	\N	\N	\N	\N	\N	\N
9286	\N	\N	\N	\N	\N	\N
9287	\N	\N	\N	\N	\N	\N
9288	\N	\N	\N	\N	\N	\N
9289	\N	\N	\N	\N	\N	\N
9290	\N	\N	\N	\N	\N	\N
9291	\N	\N	\N	\N	\N	\N
9292	\N	\N	\N	\N	\N	\N
9293	\N	\N	\N	\N	\N	\N
9294	\N	\N	\N	\N	\N	\N
9295	\N	\N	\N	\N	\N	\N
9296	\N	\N	\N	\N	\N	\N
9297	\N	\N	\N	\N	\N	\N
9298	\N	\N	\N	\N	\N	\N
9299	\N	\N	\N	\N	\N	\N
9300	\N	\N	\N	\N	\N	\N
9301	\N	\N	\N	\N	\N	\N
9302	\N	\N	\N	\N	\N	\N
9303	\N	\N	\N	\N	\N	\N
9304	\N	\N	\N	\N	\N	\N
9305	\N	\N	\N	\N	\N	\N
9306	\N	\N	\N	\N	\N	\N
9307	\N	\N	\N	\N	\N	\N
9308	\N	\N	\N	\N	\N	\N
9309	\N	\N	\N	\N	\N	\N
9310	\N	\N	\N	\N	\N	\N
9311	\N	\N	\N	\N	\N	\N
9312	\N	\N	\N	\N	\N	\N
9313	\N	\N	\N	\N	\N	\N
9314	\N	\N	\N	\N	\N	\N
9315	\N	\N	\N	\N	\N	\N
9316	\N	\N	\N	\N	\N	\N
9317	\N	\N	\N	\N	\N	\N
9318	\N	\N	\N	\N	\N	\N
9319	\N	\N	\N	\N	\N	\N
9320	\N	\N	\N	\N	\N	\N
9321	\N	\N	\N	\N	\N	\N
9322	\N	\N	\N	\N	\N	\N
9323	\N	\N	\N	\N	\N	\N
9324	\N	\N	\N	\N	\N	\N
9325	\N	\N	\N	\N	\N	\N
9326	\N	\N	\N	\N	\N	\N
9327	\N	\N	\N	\N	\N	\N
9328	\N	\N	\N	\N	\N	\N
9329	\N	\N	\N	\N	\N	\N
9330	\N	\N	\N	\N	\N	\N
9331	\N	\N	\N	\N	\N	\N
9332	\N	\N	\N	\N	\N	\N
9333	\N	\N	\N	\N	\N	\N
9334	\N	\N	\N	\N	\N	\N
9335	\N	\N	\N	\N	\N	\N
9336	\N	\N	\N	\N	\N	\N
9337	\N	\N	\N	\N	\N	\N
9338	\N	\N	\N	\N	\N	\N
9339	\N	\N	\N	\N	\N	\N
9340	\N	\N	\N	\N	\N	\N
9341	\N	\N	\N	\N	\N	\N
9342	\N	\N	\N	\N	\N	\N
9343	\N	\N	\N	\N	\N	\N
9344	\N	\N	\N	\N	\N	\N
9345	\N	\N	\N	\N	\N	\N
9346	\N	\N	\N	\N	\N	\N
9347	\N	\N	\N	\N	\N	\N
9348	\N	\N	\N	\N	\N	\N
9349	\N	\N	\N	\N	\N	\N
9350	\N	\N	\N	\N	\N	\N
9351	\N	\N	\N	\N	\N	\N
9352	\N	\N	\N	\N	\N	\N
9353	\N	\N	\N	\N	\N	\N
9354	\N	\N	\N	\N	\N	\N
9355	\N	\N	\N	\N	\N	\N
9356	\N	\N	\N	\N	\N	\N
9357	\N	\N	\N	\N	\N	\N
9358	\N	\N	\N	\N	\N	\N
9359	\N	\N	\N	\N	\N	\N
9360	\N	\N	\N	\N	\N	\N
9361	\N	\N	\N	\N	\N	\N
9362	\N	\N	\N	\N	\N	\N
9363	\N	\N	\N	\N	\N	\N
9364	\N	\N	\N	\N	\N	\N
9365	\N	\N	\N	\N	\N	\N
9366	\N	\N	\N	\N	\N	\N
9367	\N	\N	\N	\N	\N	\N
9368	\N	\N	\N	\N	\N	\N
9369	\N	\N	\N	\N	\N	\N
9370	\N	\N	\N	\N	\N	\N
9371	\N	\N	\N	\N	\N	\N
9372	\N	\N	\N	\N	\N	\N
9373	\N	\N	\N	\N	\N	\N
9374	\N	\N	\N	\N	\N	\N
9375	\N	\N	\N	\N	\N	\N
9376	\N	\N	\N	\N	\N	\N
9377	\N	\N	\N	\N	\N	\N
9378	\N	\N	\N	\N	\N	\N
9379	\N	\N	\N	\N	\N	\N
9380	\N	\N	\N	\N	\N	\N
9381	\N	\N	\N	\N	\N	\N
9382	\N	\N	\N	\N	\N	\N
9383	\N	\N	\N	\N	\N	\N
9384	\N	\N	\N	\N	\N	\N
9385	\N	\N	\N	\N	\N	\N
9386	\N	\N	\N	\N	\N	\N
9387	\N	\N	\N	\N	\N	\N
9388	\N	\N	\N	\N	\N	\N
9389	\N	\N	\N	\N	\N	\N
9390	\N	\N	\N	\N	\N	\N
9391	\N	\N	\N	\N	\N	\N
9392	\N	\N	\N	\N	\N	\N
9393	\N	\N	\N	\N	\N	\N
9394	\N	\N	\N	\N	\N	\N
9395	\N	\N	\N	\N	\N	\N
9396	\N	\N	\N	\N	\N	\N
9397	\N	\N	\N	\N	\N	\N
9398	\N	\N	\N	\N	\N	\N
9399	\N	\N	\N	\N	\N	\N
9400	\N	\N	\N	\N	\N	\N
9401	\N	\N	\N	\N	\N	\N
9402	\N	\N	\N	\N	\N	\N
9403	\N	\N	\N	\N	\N	\N
9404	\N	\N	\N	\N	\N	\N
9405	\N	\N	\N	\N	\N	\N
9406	\N	\N	\N	\N	\N	\N
9407	\N	\N	\N	\N	\N	\N
9408	\N	\N	\N	\N	\N	\N
9409	\N	\N	\N	\N	\N	\N
9410	\N	\N	\N	\N	\N	\N
9411	\N	\N	\N	\N	\N	\N
9412	\N	\N	\N	\N	\N	\N
9413	\N	\N	\N	\N	\N	\N
9414	\N	\N	\N	\N	\N	\N
9415	\N	\N	\N	\N	\N	\N
9416	\N	\N	\N	\N	\N	\N
9417	\N	\N	\N	\N	\N	\N
9418	\N	\N	\N	\N	\N	\N
9419	\N	\N	\N	\N	\N	\N
9420	\N	\N	\N	\N	\N	\N
9421	\N	\N	\N	\N	\N	\N
9422	\N	\N	\N	\N	\N	\N
9423	\N	\N	\N	\N	\N	\N
9424	\N	\N	\N	\N	\N	\N
9425	\N	\N	\N	\N	\N	\N
9426	\N	\N	\N	\N	\N	\N
9427	\N	\N	\N	\N	\N	\N
9428	\N	\N	\N	\N	\N	\N
9429	\N	\N	\N	\N	\N	\N
9430	\N	\N	\N	\N	\N	\N
9431	\N	\N	\N	\N	\N	\N
9432	\N	\N	\N	\N	\N	\N
9433	\N	\N	\N	\N	\N	\N
9434	\N	\N	\N	\N	\N	\N
9435	\N	\N	\N	\N	\N	\N
9436	\N	\N	\N	\N	\N	\N
9437	\N	\N	\N	\N	\N	\N
9438	\N	\N	\N	\N	\N	\N
9439	\N	\N	\N	\N	\N	\N
9440	\N	\N	\N	\N	\N	\N
9441	\N	\N	\N	\N	\N	\N
9442	\N	\N	\N	\N	\N	\N
9443	\N	\N	\N	\N	\N	\N
9444	\N	\N	\N	\N	\N	\N
9445	\N	\N	\N	\N	\N	\N
9446	\N	\N	\N	\N	\N	\N
9447	\N	\N	\N	\N	\N	\N
9448	\N	\N	\N	\N	\N	\N
9449	\N	\N	\N	\N	\N	\N
9450	\N	\N	\N	\N	\N	\N
9451	\N	\N	\N	\N	\N	\N
9452	\N	\N	\N	\N	\N	\N
9453	\N	\N	\N	\N	\N	\N
9454	\N	\N	\N	\N	\N	\N
9455	\N	\N	\N	\N	\N	\N
9456	\N	\N	\N	\N	\N	\N
9457	\N	\N	\N	\N	\N	\N
9458	\N	\N	\N	\N	\N	\N
9459	\N	\N	\N	\N	\N	\N
9460	\N	\N	\N	\N	\N	\N
9461	\N	\N	\N	\N	\N	\N
9462	\N	\N	\N	\N	\N	\N
9463	\N	\N	\N	\N	\N	\N
9464	\N	\N	\N	\N	\N	\N
9465	\N	\N	\N	\N	\N	\N
9466	\N	\N	\N	\N	\N	\N
9467	\N	\N	\N	\N	\N	\N
9468	\N	\N	\N	\N	\N	\N
9469	\N	\N	\N	\N	\N	\N
9470	\N	\N	\N	\N	\N	\N
9471	\N	\N	\N	\N	\N	\N
9472	\N	\N	\N	\N	\N	\N
9473	\N	\N	\N	\N	\N	\N
9474	\N	\N	\N	\N	\N	\N
9475	\N	\N	\N	\N	\N	\N
9476	\N	\N	\N	\N	\N	\N
9477	\N	\N	\N	\N	\N	\N
9478	\N	\N	\N	\N	\N	\N
9479	\N	\N	\N	\N	\N	\N
9480	\N	\N	\N	\N	\N	\N
9481	\N	\N	\N	\N	\N	\N
9482	\N	\N	\N	\N	\N	\N
9483	\N	\N	\N	\N	\N	\N
9484	\N	\N	\N	\N	\N	\N
9485	\N	\N	\N	\N	\N	\N
9486	\N	\N	\N	\N	\N	\N
9487	\N	\N	\N	\N	\N	\N
9488	\N	\N	\N	\N	\N	\N
9489	\N	\N	\N	\N	\N	\N
9490	\N	\N	\N	\N	\N	\N
9491	\N	\N	\N	\N	\N	\N
9492	\N	\N	\N	\N	\N	\N
9493	\N	\N	\N	\N	\N	\N
9494	\N	\N	\N	\N	\N	\N
9495	\N	\N	\N	\N	\N	\N
9496	\N	\N	\N	\N	\N	\N
9497	\N	\N	\N	\N	\N	\N
9498	\N	\N	\N	\N	\N	\N
9499	\N	\N	\N	\N	\N	\N
9500	\N	\N	\N	\N	\N	\N
9501	\N	\N	\N	\N	\N	\N
9502	\N	\N	\N	\N	\N	\N
9503	\N	\N	\N	\N	\N	\N
9504	\N	\N	\N	\N	\N	\N
9505	\N	\N	\N	\N	\N	\N
9506	\N	\N	\N	\N	\N	\N
9507	\N	\N	\N	\N	\N	\N
9508	\N	\N	\N	\N	\N	\N
9509	\N	\N	\N	\N	\N	\N
9510	\N	\N	\N	\N	\N	\N
9511	\N	\N	\N	\N	\N	\N
9512	\N	\N	\N	\N	\N	\N
9513	\N	\N	\N	\N	\N	\N
9514	\N	\N	\N	\N	\N	\N
9515	\N	\N	\N	\N	\N	\N
9516	\N	\N	\N	\N	\N	\N
9517	\N	\N	\N	\N	\N	\N
9518	\N	\N	\N	\N	\N	\N
9519	\N	\N	\N	\N	\N	\N
9520	\N	\N	\N	\N	\N	\N
9521	\N	\N	\N	\N	\N	\N
9522	\N	\N	\N	\N	\N	\N
9523	\N	\N	\N	\N	\N	\N
9524	\N	\N	\N	\N	\N	\N
9525	\N	\N	\N	\N	\N	\N
9526	\N	\N	\N	\N	\N	\N
9527	\N	\N	\N	\N	\N	\N
9528	\N	\N	\N	\N	\N	\N
9529	\N	\N	\N	\N	\N	\N
9530	\N	\N	\N	\N	\N	\N
9531	\N	\N	\N	\N	\N	\N
9532	\N	\N	\N	\N	\N	\N
9533	\N	\N	\N	\N	\N	\N
9534	\N	\N	\N	\N	\N	\N
9535	\N	\N	\N	\N	\N	\N
9536	\N	\N	\N	\N	\N	\N
9537	\N	\N	\N	\N	\N	\N
9538	\N	\N	\N	\N	\N	\N
9539	\N	\N	\N	\N	\N	\N
9540	\N	\N	\N	\N	\N	\N
9541	\N	\N	\N	\N	\N	\N
9542	\N	\N	\N	\N	\N	\N
9543	\N	\N	\N	\N	\N	\N
9544	\N	\N	\N	\N	\N	\N
9545	\N	\N	\N	\N	\N	\N
9546	\N	\N	\N	\N	\N	\N
9547	\N	\N	\N	\N	\N	\N
9548	\N	\N	\N	\N	\N	\N
9549	\N	\N	\N	\N	\N	\N
9550	\N	\N	\N	\N	\N	\N
9551	\N	\N	\N	\N	\N	\N
9552	\N	\N	\N	\N	\N	\N
9553	\N	\N	\N	\N	\N	\N
9554	\N	\N	\N	\N	\N	\N
9555	\N	\N	\N	\N	\N	\N
9556	\N	\N	\N	\N	\N	\N
9557	\N	\N	\N	\N	\N	\N
9558	\N	\N	\N	\N	\N	\N
9559	\N	\N	\N	\N	\N	\N
9560	\N	\N	\N	\N	\N	\N
9561	\N	\N	\N	\N	\N	\N
9562	\N	\N	\N	\N	\N	\N
9563	\N	\N	\N	\N	\N	\N
9564	\N	\N	\N	\N	\N	\N
9565	\N	\N	\N	\N	\N	\N
9566	\N	\N	\N	\N	\N	\N
9567	\N	\N	\N	\N	\N	\N
9568	\N	\N	\N	\N	\N	\N
9569	\N	\N	\N	\N	\N	\N
9570	\N	\N	\N	\N	\N	\N
9571	\N	\N	\N	\N	\N	\N
9572	\N	\N	\N	\N	\N	\N
9573	\N	\N	\N	\N	\N	\N
9574	\N	\N	\N	\N	\N	\N
9575	\N	\N	\N	\N	\N	\N
9576	\N	\N	\N	\N	\N	\N
9577	\N	\N	\N	\N	\N	\N
9578	\N	\N	\N	\N	\N	\N
9579	\N	\N	\N	\N	\N	\N
9580	\N	\N	\N	\N	\N	\N
9581	\N	\N	\N	\N	\N	\N
9582	\N	\N	\N	\N	\N	\N
9583	\N	\N	\N	\N	\N	\N
9584	\N	\N	\N	\N	\N	\N
9585	\N	\N	\N	\N	\N	\N
9586	\N	\N	\N	\N	\N	\N
9587	\N	\N	\N	\N	\N	\N
9588	\N	\N	\N	\N	\N	\N
9589	\N	\N	\N	\N	\N	\N
9590	\N	\N	\N	\N	\N	\N
9591	\N	\N	\N	\N	\N	\N
9592	\N	\N	\N	\N	\N	\N
9593	\N	\N	\N	\N	\N	\N
9594	\N	\N	\N	\N	\N	\N
9595	\N	\N	\N	\N	\N	\N
9596	\N	\N	\N	\N	\N	\N
9597	\N	\N	\N	\N	\N	\N
9598	\N	\N	\N	\N	\N	\N
9599	\N	\N	\N	\N	\N	\N
9600	\N	\N	\N	\N	\N	\N
9601	\N	\N	\N	\N	\N	\N
9602	\N	\N	\N	\N	\N	\N
9603	\N	\N	\N	\N	\N	\N
9604	\N	\N	\N	\N	\N	\N
9605	\N	\N	\N	\N	\N	\N
9606	\N	\N	\N	\N	\N	\N
9607	\N	\N	\N	\N	\N	\N
9608	\N	\N	\N	\N	\N	\N
9609	\N	\N	\N	\N	\N	\N
9610	\N	\N	\N	\N	\N	\N
9611	\N	\N	\N	\N	\N	\N
9612	\N	\N	\N	\N	\N	\N
9613	\N	\N	\N	\N	\N	\N
9614	\N	\N	\N	\N	\N	\N
9615	\N	\N	\N	\N	\N	\N
9616	\N	\N	\N	\N	\N	\N
9617	\N	\N	\N	\N	\N	\N
9618	\N	\N	\N	\N	\N	\N
9619	\N	\N	\N	\N	\N	\N
9620	\N	\N	\N	\N	\N	\N
9621	\N	\N	\N	\N	\N	\N
9622	\N	\N	\N	\N	\N	\N
9623	\N	\N	\N	\N	\N	\N
9624	\N	\N	\N	\N	\N	\N
9625	\N	\N	\N	\N	\N	\N
9626	\N	\N	\N	\N	\N	\N
9627	\N	\N	\N	\N	\N	\N
9628	\N	\N	\N	\N	\N	\N
9629	\N	\N	\N	\N	\N	\N
9630	\N	\N	\N	\N	\N	\N
9631	\N	\N	\N	\N	\N	\N
9632	\N	\N	\N	\N	\N	\N
9633	\N	\N	\N	\N	\N	\N
9634	\N	\N	\N	\N	\N	\N
9635	\N	\N	\N	\N	\N	\N
9636	\N	\N	\N	\N	\N	\N
9637	\N	\N	\N	\N	\N	\N
9638	\N	\N	\N	\N	\N	\N
9639	\N	\N	\N	\N	\N	\N
9640	\N	\N	\N	\N	\N	\N
9641	\N	\N	\N	\N	\N	\N
9642	\N	\N	\N	\N	\N	\N
9643	\N	\N	\N	\N	\N	\N
9644	\N	\N	\N	\N	\N	\N
9645	\N	\N	\N	\N	\N	\N
9646	\N	\N	\N	\N	\N	\N
9647	\N	\N	\N	\N	\N	\N
9648	\N	\N	\N	\N	\N	\N
9649	\N	\N	\N	\N	\N	\N
9650	\N	\N	\N	\N	\N	\N
9651	\N	\N	\N	\N	\N	\N
9652	\N	\N	\N	\N	\N	\N
9653	\N	\N	\N	\N	\N	\N
9654	\N	\N	\N	\N	\N	\N
9655	\N	\N	\N	\N	\N	\N
9656	\N	\N	\N	\N	\N	\N
9657	\N	\N	\N	\N	\N	\N
9658	\N	\N	\N	\N	\N	\N
9659	\N	\N	\N	\N	\N	\N
9660	\N	\N	\N	\N	\N	\N
9661	\N	\N	\N	\N	\N	\N
9662	\N	\N	\N	\N	\N	\N
9663	\N	\N	\N	\N	\N	\N
9664	\N	\N	\N	\N	\N	\N
9665	\N	\N	\N	\N	\N	\N
9666	\N	\N	\N	\N	\N	\N
9667	\N	\N	\N	\N	\N	\N
9668	\N	\N	\N	\N	\N	\N
9669	\N	\N	\N	\N	\N	\N
9670	\N	\N	\N	\N	\N	\N
9671	\N	\N	\N	\N	\N	\N
9672	\N	\N	\N	\N	\N	\N
9673	\N	\N	\N	\N	\N	\N
9674	\N	\N	\N	\N	\N	\N
9675	\N	\N	\N	\N	\N	\N
9676	\N	\N	\N	\N	\N	\N
9677	\N	\N	\N	\N	\N	\N
9678	\N	\N	\N	\N	\N	\N
9679	\N	\N	\N	\N	\N	\N
9680	\N	\N	\N	\N	\N	\N
9681	\N	\N	\N	\N	\N	\N
9682	\N	\N	\N	\N	\N	\N
9683	\N	\N	\N	\N	\N	\N
9684	\N	\N	\N	\N	\N	\N
9685	\N	\N	\N	\N	\N	\N
9686	\N	\N	\N	\N	\N	\N
9687	\N	\N	\N	\N	\N	\N
9688	\N	\N	\N	\N	\N	\N
9689	\N	\N	\N	\N	\N	\N
9690	\N	\N	\N	\N	\N	\N
9691	\N	\N	\N	\N	\N	\N
9692	\N	\N	\N	\N	\N	\N
9693	\N	\N	\N	\N	\N	\N
9694	\N	\N	\N	\N	\N	\N
9695	\N	\N	\N	\N	\N	\N
9696	\N	\N	\N	\N	\N	\N
9697	\N	\N	\N	\N	\N	\N
9698	\N	\N	\N	\N	\N	\N
9699	\N	\N	\N	\N	\N	\N
9700	\N	\N	\N	\N	\N	\N
9701	\N	\N	\N	\N	\N	\N
9702	\N	\N	\N	\N	\N	\N
9703	\N	\N	\N	\N	\N	\N
9704	\N	\N	\N	\N	\N	\N
9705	\N	\N	\N	\N	\N	\N
9706	\N	\N	\N	\N	\N	\N
9707	\N	\N	\N	\N	\N	\N
9708	\N	\N	\N	\N	\N	\N
9709	\N	\N	\N	\N	\N	\N
9710	\N	\N	\N	\N	\N	\N
9711	\N	\N	\N	\N	\N	\N
9712	\N	\N	\N	\N	\N	\N
9713	\N	\N	\N	\N	\N	\N
9714	\N	\N	\N	\N	\N	\N
9715	\N	\N	\N	\N	\N	\N
9716	\N	\N	\N	\N	\N	\N
9717	\N	\N	\N	\N	\N	\N
9718	\N	\N	\N	\N	\N	\N
9719	\N	\N	\N	\N	\N	\N
9720	\N	\N	\N	\N	\N	\N
9721	\N	\N	\N	\N	\N	\N
9722	\N	\N	\N	\N	\N	\N
9723	\N	\N	\N	\N	\N	\N
9724	\N	\N	\N	\N	\N	\N
9725	\N	\N	\N	\N	\N	\N
9726	\N	\N	\N	\N	\N	\N
9727	\N	\N	\N	\N	\N	\N
9728	\N	\N	\N	\N	\N	\N
9729	\N	\N	\N	\N	\N	\N
9730	\N	\N	\N	\N	\N	\N
9731	\N	\N	\N	\N	\N	\N
9732	\N	\N	\N	\N	\N	\N
9733	\N	\N	\N	\N	\N	\N
9734	\N	\N	\N	\N	\N	\N
9735	\N	\N	\N	\N	\N	\N
9736	\N	\N	\N	\N	\N	\N
9737	\N	\N	\N	\N	\N	\N
9738	\N	\N	\N	\N	\N	\N
9739	\N	\N	\N	\N	\N	\N
9740	\N	\N	\N	\N	\N	\N
9741	\N	\N	\N	\N	\N	\N
9742	\N	\N	\N	\N	\N	\N
9743	\N	\N	\N	\N	\N	\N
9744	\N	\N	\N	\N	\N	\N
9745	\N	\N	\N	\N	\N	\N
9746	\N	\N	\N	\N	\N	\N
9747	\N	\N	\N	\N	\N	\N
9748	\N	\N	\N	\N	\N	\N
9749	\N	\N	\N	\N	\N	\N
9750	\N	\N	\N	\N	\N	\N
9751	\N	\N	\N	\N	\N	\N
9752	\N	\N	\N	\N	\N	\N
9753	\N	\N	\N	\N	\N	\N
9754	\N	\N	\N	\N	\N	\N
9755	\N	\N	\N	\N	\N	\N
9756	\N	\N	\N	\N	\N	\N
9757	\N	\N	\N	\N	\N	\N
9758	\N	\N	\N	\N	\N	\N
9759	\N	\N	\N	\N	\N	\N
9760	\N	\N	\N	\N	\N	\N
9761	\N	\N	\N	\N	\N	\N
9762	\N	\N	\N	\N	\N	\N
9763	\N	\N	\N	\N	\N	\N
9764	\N	\N	\N	\N	\N	\N
9765	\N	\N	\N	\N	\N	\N
9766	\N	\N	\N	\N	\N	\N
9767	\N	\N	\N	\N	\N	\N
9768	\N	\N	\N	\N	\N	\N
9769	\N	\N	\N	\N	\N	\N
9770	\N	\N	\N	\N	\N	\N
9771	\N	\N	\N	\N	\N	\N
9772	\N	\N	\N	\N	\N	\N
9773	\N	\N	\N	\N	\N	\N
9774	\N	\N	\N	\N	\N	\N
9775	\N	\N	\N	\N	\N	\N
9776	\N	\N	\N	\N	\N	\N
9777	\N	\N	\N	\N	\N	\N
9778	\N	\N	\N	\N	\N	\N
9779	\N	\N	\N	\N	\N	\N
9780	\N	\N	\N	\N	\N	\N
9781	\N	\N	\N	\N	\N	\N
9782	\N	\N	\N	\N	\N	\N
9783	\N	\N	\N	\N	\N	\N
9784	\N	\N	\N	\N	\N	\N
9785	\N	\N	\N	\N	\N	\N
9786	\N	\N	\N	\N	\N	\N
9787	\N	\N	\N	\N	\N	\N
9788	\N	\N	\N	\N	\N	\N
9789	\N	\N	\N	\N	\N	\N
9790	\N	\N	\N	\N	\N	\N
9791	\N	\N	\N	\N	\N	\N
9792	\N	\N	\N	\N	\N	\N
9793	\N	\N	\N	\N	\N	\N
9794	\N	\N	\N	\N	\N	\N
9795	\N	\N	\N	\N	\N	\N
9796	\N	\N	\N	\N	\N	\N
9797	\N	\N	\N	\N	\N	\N
9798	\N	\N	\N	\N	\N	\N
9799	\N	\N	\N	\N	\N	\N
9800	\N	\N	\N	\N	\N	\N
9801	\N	\N	\N	\N	\N	\N
9802	\N	\N	\N	\N	\N	\N
9803	\N	\N	\N	\N	\N	\N
9804	\N	\N	\N	\N	\N	\N
9805	\N	\N	\N	\N	\N	\N
9806	\N	\N	\N	\N	\N	\N
9807	\N	\N	\N	\N	\N	\N
9808	\N	\N	\N	\N	\N	\N
9809	\N	\N	\N	\N	\N	\N
9810	\N	\N	\N	\N	\N	\N
9811	\N	\N	\N	\N	\N	\N
9812	\N	\N	\N	\N	\N	\N
9813	\N	\N	\N	\N	\N	\N
9814	\N	\N	\N	\N	\N	\N
9815	\N	\N	\N	\N	\N	\N
9816	\N	\N	\N	\N	\N	\N
9817	\N	\N	\N	\N	\N	\N
9818	\N	\N	\N	\N	\N	\N
9819	\N	\N	\N	\N	\N	\N
9820	\N	\N	\N	\N	\N	\N
9821	\N	\N	\N	\N	\N	\N
9822	\N	\N	\N	\N	\N	\N
9823	\N	\N	\N	\N	\N	\N
9824	\N	\N	\N	\N	\N	\N
9825	\N	\N	\N	\N	\N	\N
9826	\N	\N	\N	\N	\N	\N
9827	\N	\N	\N	\N	\N	\N
9828	\N	\N	\N	\N	\N	\N
9829	\N	\N	\N	\N	\N	\N
9830	\N	\N	\N	\N	\N	\N
9831	\N	\N	\N	\N	\N	\N
9832	\N	\N	\N	\N	\N	\N
9833	\N	\N	\N	\N	\N	\N
9834	\N	\N	\N	\N	\N	\N
9835	\N	\N	\N	\N	\N	\N
9836	\N	\N	\N	\N	\N	\N
9837	\N	\N	\N	\N	\N	\N
9838	\N	\N	\N	\N	\N	\N
9839	\N	\N	\N	\N	\N	\N
9840	\N	\N	\N	\N	\N	\N
9841	\N	\N	\N	\N	\N	\N
9842	\N	\N	\N	\N	\N	\N
9843	\N	\N	\N	\N	\N	\N
9844	\N	\N	\N	\N	\N	\N
9845	\N	\N	\N	\N	\N	\N
9846	\N	\N	\N	\N	\N	\N
9847	\N	\N	\N	\N	\N	\N
9848	\N	\N	\N	\N	\N	\N
9849	\N	\N	\N	\N	\N	\N
9850	\N	\N	\N	\N	\N	\N
9851	\N	\N	\N	\N	\N	\N
9852	\N	\N	\N	\N	\N	\N
9853	\N	\N	\N	\N	\N	\N
9854	\N	\N	\N	\N	\N	\N
9855	\N	\N	\N	\N	\N	\N
9856	\N	\N	\N	\N	\N	\N
9857	\N	\N	\N	\N	\N	\N
9858	\N	\N	\N	\N	\N	\N
9859	\N	\N	\N	\N	\N	\N
9860	\N	\N	\N	\N	\N	\N
9861	\N	\N	\N	\N	\N	\N
9862	\N	\N	\N	\N	\N	\N
9863	\N	\N	\N	\N	\N	\N
9864	\N	\N	\N	\N	\N	\N
9865	\N	\N	\N	\N	\N	\N
9866	\N	\N	\N	\N	\N	\N
9867	\N	\N	\N	\N	\N	\N
9868	\N	\N	\N	\N	\N	\N
9869	\N	\N	\N	\N	\N	\N
9870	\N	\N	\N	\N	\N	\N
9871	\N	\N	\N	\N	\N	\N
9872	\N	\N	\N	\N	\N	\N
9873	\N	\N	\N	\N	\N	\N
9874	\N	\N	\N	\N	\N	\N
9875	\N	\N	\N	\N	\N	\N
9876	\N	\N	\N	\N	\N	\N
9877	\N	\N	\N	\N	\N	\N
9878	\N	\N	\N	\N	\N	\N
9879	\N	\N	\N	\N	\N	\N
9880	\N	\N	\N	\N	\N	\N
9881	\N	\N	\N	\N	\N	\N
9882	\N	\N	\N	\N	\N	\N
9883	\N	\N	\N	\N	\N	\N
9884	\N	\N	\N	\N	\N	\N
9885	\N	\N	\N	\N	\N	\N
9886	\N	\N	\N	\N	\N	\N
9887	\N	\N	\N	\N	\N	\N
9888	\N	\N	\N	\N	\N	\N
9889	\N	\N	\N	\N	\N	\N
9890	\N	\N	\N	\N	\N	\N
9891	\N	\N	\N	\N	\N	\N
9892	\N	\N	\N	\N	\N	\N
9893	\N	\N	\N	\N	\N	\N
9894	\N	\N	\N	\N	\N	\N
9895	\N	\N	\N	\N	\N	\N
9896	\N	\N	\N	\N	\N	\N
9897	\N	\N	\N	\N	\N	\N
9898	\N	\N	\N	\N	\N	\N
9899	\N	\N	\N	\N	\N	\N
9900	\N	\N	\N	\N	\N	\N
9901	\N	\N	\N	\N	\N	\N
9902	\N	\N	\N	\N	\N	\N
9903	\N	\N	\N	\N	\N	\N
9904	\N	\N	\N	\N	\N	\N
9905	\N	\N	\N	\N	\N	\N
9906	\N	\N	\N	\N	\N	\N
9907	\N	\N	\N	\N	\N	\N
9908	\N	\N	\N	\N	\N	\N
9909	\N	\N	\N	\N	\N	\N
9910	\N	\N	\N	\N	\N	\N
9911	\N	\N	\N	\N	\N	\N
9912	\N	\N	\N	\N	\N	\N
9913	\N	\N	\N	\N	\N	\N
9914	\N	\N	\N	\N	\N	\N
9915	\N	\N	\N	\N	\N	\N
9916	\N	\N	\N	\N	\N	\N
9917	\N	\N	\N	\N	\N	\N
9918	\N	\N	\N	\N	\N	\N
9919	\N	\N	\N	\N	\N	\N
9920	\N	\N	\N	\N	\N	\N
9921	\N	\N	\N	\N	\N	\N
9922	\N	\N	\N	\N	\N	\N
9923	\N	\N	\N	\N	\N	\N
9924	\N	\N	\N	\N	\N	\N
9925	\N	\N	\N	\N	\N	\N
9926	\N	\N	\N	\N	\N	\N
9927	\N	\N	\N	\N	\N	\N
9928	\N	\N	\N	\N	\N	\N
9929	\N	\N	\N	\N	\N	\N
9930	\N	\N	\N	\N	\N	\N
9931	\N	\N	\N	\N	\N	\N
9932	\N	\N	\N	\N	\N	\N
9933	\N	\N	\N	\N	\N	\N
9934	\N	\N	\N	\N	\N	\N
9935	\N	\N	\N	\N	\N	\N
9936	\N	\N	\N	\N	\N	\N
9937	\N	\N	\N	\N	\N	\N
9938	\N	\N	\N	\N	\N	\N
9939	\N	\N	\N	\N	\N	\N
9940	\N	\N	\N	\N	\N	\N
9941	\N	\N	\N	\N	\N	\N
9942	\N	\N	\N	\N	\N	\N
9943	\N	\N	\N	\N	\N	\N
9944	\N	\N	\N	\N	\N	\N
9945	\N	\N	\N	\N	\N	\N
9946	\N	\N	\N	\N	\N	\N
9947	\N	\N	\N	\N	\N	\N
9948	\N	\N	\N	\N	\N	\N
9949	\N	\N	\N	\N	\N	\N
9950	\N	\N	\N	\N	\N	\N
9951	\N	\N	\N	\N	\N	\N
9952	\N	\N	\N	\N	\N	\N
9953	\N	\N	\N	\N	\N	\N
9954	\N	\N	\N	\N	\N	\N
9955	\N	\N	\N	\N	\N	\N
9956	\N	\N	\N	\N	\N	\N
9957	\N	\N	\N	\N	\N	\N
9958	\N	\N	\N	\N	\N	\N
9959	\N	\N	\N	\N	\N	\N
9960	\N	\N	\N	\N	\N	\N
9961	\N	\N	\N	\N	\N	\N
9962	\N	\N	\N	\N	\N	\N
9963	\N	\N	\N	\N	\N	\N
9964	\N	\N	\N	\N	\N	\N
9965	\N	\N	\N	\N	\N	\N
9966	\N	\N	\N	\N	\N	\N
9967	\N	\N	\N	\N	\N	\N
9968	\N	\N	\N	\N	\N	\N
9969	\N	\N	\N	\N	\N	\N
9970	\N	\N	\N	\N	\N	\N
9971	\N	\N	\N	\N	\N	\N
9972	\N	\N	\N	\N	\N	\N
9973	\N	\N	\N	\N	\N	\N
9974	\N	\N	\N	\N	\N	\N
9975	\N	\N	\N	\N	\N	\N
9976	\N	\N	\N	\N	\N	\N
9977	\N	\N	\N	\N	\N	\N
9978	\N	\N	\N	\N	\N	\N
9979	\N	\N	\N	\N	\N	\N
9980	\N	\N	\N	\N	\N	\N
9981	\N	\N	\N	\N	\N	\N
9982	\N	\N	\N	\N	\N	\N
9983	\N	\N	\N	\N	\N	\N
9984	\N	\N	\N	\N	\N	\N
9985	\N	\N	\N	\N	\N	\N
9986	\N	\N	\N	\N	\N	\N
9987	\N	\N	\N	\N	\N	\N
9988	\N	\N	\N	\N	\N	\N
9989	\N	\N	\N	\N	\N	\N
9990	\N	\N	\N	\N	\N	\N
9991	\N	\N	\N	\N	\N	\N
9992	\N	\N	\N	\N	\N	\N
9993	\N	\N	\N	\N	\N	\N
9994	\N	\N	\N	\N	\N	\N
9995	\N	\N	\N	\N	\N	\N
9996	\N	\N	\N	\N	\N	\N
9997	\N	\N	\N	\N	\N	\N
9998	\N	\N	\N	\N	\N	\N
9999	\N	\N	\N	\N	\N	\N
10000	\N	\N	\N	\N	\N	\N
10001	\N	\N	\N	\N	\N	\N
10002	\N	\N	\N	\N	\N	\N
10003	\N	\N	\N	\N	\N	\N
10004	\N	\N	\N	\N	\N	\N
10005	\N	\N	\N	\N	\N	\N
10006	\N	\N	\N	\N	\N	\N
10007	\N	\N	\N	\N	\N	\N
10008	\N	\N	\N	\N	\N	\N
10009	\N	\N	\N	\N	\N	\N
10010	\N	\N	\N	\N	\N	\N
10011	\N	\N	\N	\N	\N	\N
10012	\N	\N	\N	\N	\N	\N
10013	\N	\N	\N	\N	\N	\N
10014	\N	\N	\N	\N	\N	\N
10015	\N	\N	\N	\N	\N	\N
10016	\N	\N	\N	\N	\N	\N
10017	\N	\N	\N	\N	\N	\N
10018	\N	\N	\N	\N	\N	\N
10019	\N	\N	\N	\N	\N	\N
10020	\N	\N	\N	\N	\N	\N
10021	\N	\N	\N	\N	\N	\N
10022	\N	\N	\N	\N	\N	\N
10023	\N	\N	\N	\N	\N	\N
10024	\N	\N	\N	\N	\N	\N
10025	\N	\N	\N	\N	\N	\N
10026	\N	\N	\N	\N	\N	\N
10027	\N	\N	\N	\N	\N	\N
10028	\N	\N	\N	\N	\N	\N
10029	\N	\N	\N	\N	\N	\N
10030	\N	\N	\N	\N	\N	\N
10031	\N	\N	\N	\N	\N	\N
10032	\N	\N	\N	\N	\N	\N
10033	\N	\N	\N	\N	\N	\N
10034	\N	\N	\N	\N	\N	\N
10035	\N	\N	\N	\N	\N	\N
10036	\N	\N	\N	\N	\N	\N
10037	\N	\N	\N	\N	\N	\N
10038	\N	\N	\N	\N	\N	\N
10039	\N	\N	\N	\N	\N	\N
10040	\N	\N	\N	\N	\N	\N
10041	\N	\N	\N	\N	\N	\N
10042	\N	\N	\N	\N	\N	\N
10043	\N	\N	\N	\N	\N	\N
10044	\N	\N	\N	\N	\N	\N
10045	\N	\N	\N	\N	\N	\N
10046	\N	\N	\N	\N	\N	\N
10047	\N	\N	\N	\N	\N	\N
10048	\N	\N	\N	\N	\N	\N
10049	\N	\N	\N	\N	\N	\N
10050	\N	\N	\N	\N	\N	\N
10051	\N	\N	\N	\N	\N	\N
10052	\N	\N	\N	\N	\N	\N
10053	\N	\N	\N	\N	\N	\N
10054	\N	\N	\N	\N	\N	\N
10055	\N	\N	\N	\N	\N	\N
10056	\N	\N	\N	\N	\N	\N
10057	\N	\N	\N	\N	\N	\N
10058	\N	\N	\N	\N	\N	\N
10059	\N	\N	\N	\N	\N	\N
10060	\N	\N	\N	\N	\N	\N
10061	\N	\N	\N	\N	\N	\N
10062	\N	\N	\N	\N	\N	\N
10063	\N	\N	\N	\N	\N	\N
10064	\N	\N	\N	\N	\N	\N
10065	\N	\N	\N	\N	\N	\N
10066	\N	\N	\N	\N	\N	\N
10067	\N	\N	\N	\N	\N	\N
10068	\N	\N	\N	\N	\N	\N
10069	\N	\N	\N	\N	\N	\N
10070	\N	\N	\N	\N	\N	\N
10071	\N	\N	\N	\N	\N	\N
10072	\N	\N	\N	\N	\N	\N
10073	\N	\N	\N	\N	\N	\N
10074	\N	\N	\N	\N	\N	\N
10075	\N	\N	\N	\N	\N	\N
10076	\N	\N	\N	\N	\N	\N
10077	\N	\N	\N	\N	\N	\N
10078	\N	\N	\N	\N	\N	\N
10079	\N	\N	\N	\N	\N	\N
10080	\N	\N	\N	\N	\N	\N
10081	\N	\N	\N	\N	\N	\N
10082	\N	\N	\N	\N	\N	\N
10083	\N	\N	\N	\N	\N	\N
10084	\N	\N	\N	\N	\N	\N
10085	\N	\N	\N	\N	\N	\N
10086	\N	\N	\N	\N	\N	\N
10087	\N	\N	\N	\N	\N	\N
10088	\N	\N	\N	\N	\N	\N
10089	\N	\N	\N	\N	\N	\N
10090	\N	\N	\N	\N	\N	\N
10091	\N	\N	\N	\N	\N	\N
10092	\N	\N	\N	\N	\N	\N
10093	\N	\N	\N	\N	\N	\N
10094	\N	\N	\N	\N	\N	\N
10095	\N	\N	\N	\N	\N	\N
10096	\N	\N	\N	\N	\N	\N
10097	\N	\N	\N	\N	\N	\N
10098	\N	\N	\N	\N	\N	\N
10099	\N	\N	\N	\N	\N	\N
10100	\N	\N	\N	\N	\N	\N
10101	\N	\N	\N	\N	\N	\N
10102	\N	\N	\N	\N	\N	\N
10103	\N	\N	\N	\N	\N	\N
10104	\N	\N	\N	\N	\N	\N
10105	\N	\N	\N	\N	\N	\N
10106	\N	\N	\N	\N	\N	\N
10107	\N	\N	\N	\N	\N	\N
10108	\N	\N	\N	\N	\N	\N
10109	\N	\N	\N	\N	\N	\N
10110	\N	\N	\N	\N	\N	\N
10111	\N	\N	\N	\N	\N	\N
10112	\N	\N	\N	\N	\N	\N
10113	\N	\N	\N	\N	\N	\N
10114	\N	\N	\N	\N	\N	\N
10115	\N	\N	\N	\N	\N	\N
10116	\N	\N	\N	\N	\N	\N
10117	\N	\N	\N	\N	\N	\N
10118	\N	\N	\N	\N	\N	\N
10119	\N	\N	\N	\N	\N	\N
10120	\N	\N	\N	\N	\N	\N
10121	\N	\N	\N	\N	\N	\N
10122	\N	\N	\N	\N	\N	\N
10123	\N	\N	\N	\N	\N	\N
10124	\N	\N	\N	\N	\N	\N
10125	\N	\N	\N	\N	\N	\N
10126	\N	\N	\N	\N	\N	\N
10127	\N	\N	\N	\N	\N	\N
10128	\N	\N	\N	\N	\N	\N
10129	\N	\N	\N	\N	\N	\N
10130	\N	\N	\N	\N	\N	\N
10131	\N	\N	\N	\N	\N	\N
10132	\N	\N	\N	\N	\N	\N
10133	\N	\N	\N	\N	\N	\N
10134	\N	\N	\N	\N	\N	\N
10135	\N	\N	\N	\N	\N	\N
10136	\N	\N	\N	\N	\N	\N
10137	\N	\N	\N	\N	\N	\N
10138	\N	\N	\N	\N	\N	\N
10139	\N	\N	\N	\N	\N	\N
10140	\N	\N	\N	\N	\N	\N
10141	\N	\N	\N	\N	\N	\N
10142	\N	\N	\N	\N	\N	\N
10143	\N	\N	\N	\N	\N	\N
10144	\N	\N	\N	\N	\N	\N
10145	\N	\N	\N	\N	\N	\N
10146	\N	\N	\N	\N	\N	\N
10147	\N	\N	\N	\N	\N	\N
10148	\N	\N	\N	\N	\N	\N
10149	\N	\N	\N	\N	\N	\N
10150	\N	\N	\N	\N	\N	\N
10151	\N	\N	\N	\N	\N	\N
10152	\N	\N	\N	\N	\N	\N
10153	\N	\N	\N	\N	\N	\N
10154	\N	\N	\N	\N	\N	\N
10155	\N	\N	\N	\N	\N	\N
10156	\N	\N	\N	\N	\N	\N
10157	\N	\N	\N	\N	\N	\N
10158	\N	\N	\N	\N	\N	\N
10159	\N	\N	\N	\N	\N	\N
10160	\N	\N	\N	\N	\N	\N
10161	\N	\N	\N	\N	\N	\N
10162	\N	\N	\N	\N	\N	\N
10163	\N	\N	\N	\N	\N	\N
10164	\N	\N	\N	\N	\N	\N
10165	\N	\N	\N	\N	\N	\N
10166	\N	\N	\N	\N	\N	\N
10167	\N	\N	\N	\N	\N	\N
10168	\N	\N	\N	\N	\N	\N
10169	\N	\N	\N	\N	\N	\N
10170	\N	\N	\N	\N	\N	\N
10171	\N	\N	\N	\N	\N	\N
10172	\N	\N	\N	\N	\N	\N
10173	\N	\N	\N	\N	\N	\N
10174	\N	\N	\N	\N	\N	\N
10175	\N	\N	\N	\N	\N	\N
10176	\N	\N	\N	\N	\N	\N
10177	\N	\N	\N	\N	\N	\N
10178	\N	\N	\N	\N	\N	\N
10179	\N	\N	\N	\N	\N	\N
10180	\N	\N	\N	\N	\N	\N
10181	\N	\N	\N	\N	\N	\N
10182	\N	\N	\N	\N	\N	\N
10183	\N	\N	\N	\N	\N	\N
10184	\N	\N	\N	\N	\N	\N
10185	\N	\N	\N	\N	\N	\N
10186	\N	\N	\N	\N	\N	\N
10187	\N	\N	\N	\N	\N	\N
10188	\N	\N	\N	\N	\N	\N
10189	\N	\N	\N	\N	\N	\N
10190	\N	\N	\N	\N	\N	\N
10191	\N	\N	\N	\N	\N	\N
10192	\N	\N	\N	\N	\N	\N
10193	\N	\N	\N	\N	\N	\N
10194	\N	\N	\N	\N	\N	\N
10195	\N	\N	\N	\N	\N	\N
10196	\N	\N	\N	\N	\N	\N
10197	\N	\N	\N	\N	\N	\N
10198	\N	\N	\N	\N	\N	\N
10199	\N	\N	\N	\N	\N	\N
10200	\N	\N	\N	\N	\N	\N
10201	\N	\N	\N	\N	\N	\N
10202	\N	\N	\N	\N	\N	\N
10203	\N	\N	\N	\N	\N	\N
10204	\N	\N	\N	\N	\N	\N
10205	\N	\N	\N	\N	\N	\N
10206	\N	\N	\N	\N	\N	\N
10207	\N	\N	\N	\N	\N	\N
10208	\N	\N	\N	\N	\N	\N
10209	\N	\N	\N	\N	\N	\N
10210	\N	\N	\N	\N	\N	\N
10211	\N	\N	\N	\N	\N	\N
10212	\N	\N	\N	\N	\N	\N
10213	\N	\N	\N	\N	\N	\N
10214	\N	\N	\N	\N	\N	\N
10215	\N	\N	\N	\N	\N	\N
10216	\N	\N	\N	\N	\N	\N
10217	\N	\N	\N	\N	\N	\N
10218	\N	\N	\N	\N	\N	\N
10219	\N	\N	\N	\N	\N	\N
10220	\N	\N	\N	\N	\N	\N
10221	\N	\N	\N	\N	\N	\N
10222	\N	\N	\N	\N	\N	\N
10223	\N	\N	\N	\N	\N	\N
10224	\N	\N	\N	\N	\N	\N
10225	\N	\N	\N	\N	\N	\N
10226	\N	\N	\N	\N	\N	\N
10227	\N	\N	\N	\N	\N	\N
10228	\N	\N	\N	\N	\N	\N
10229	\N	\N	\N	\N	\N	\N
10230	\N	\N	\N	\N	\N	\N
10231	\N	\N	\N	\N	\N	\N
10232	\N	\N	\N	\N	\N	\N
10233	\N	\N	\N	\N	\N	\N
10234	\N	\N	\N	\N	\N	\N
10235	\N	\N	\N	\N	\N	\N
10236	\N	\N	\N	\N	\N	\N
10237	\N	\N	\N	\N	\N	\N
10238	\N	\N	\N	\N	\N	\N
10239	\N	\N	\N	\N	\N	\N
10240	\N	\N	\N	\N	\N	\N
10241	\N	\N	\N	\N	\N	\N
10242	\N	\N	\N	\N	\N	\N
10243	\N	\N	\N	\N	\N	\N
10244	\N	\N	\N	\N	\N	\N
10245	\N	\N	\N	\N	\N	\N
10246	\N	\N	\N	\N	\N	\N
10247	\N	\N	\N	\N	\N	\N
10248	\N	\N	\N	\N	\N	\N
10249	\N	\N	\N	\N	\N	\N
10250	\N	\N	\N	\N	\N	\N
10251	\N	\N	\N	\N	\N	\N
10252	\N	\N	\N	\N	\N	\N
10253	\N	\N	\N	\N	\N	\N
10254	\N	\N	\N	\N	\N	\N
10255	\N	\N	\N	\N	\N	\N
10256	\N	\N	\N	\N	\N	\N
10257	\N	\N	\N	\N	\N	\N
10258	\N	\N	\N	\N	\N	\N
10259	\N	\N	\N	\N	\N	\N
10260	\N	\N	\N	\N	\N	\N
10261	\N	\N	\N	\N	\N	\N
10262	\N	\N	\N	\N	\N	\N
10263	\N	\N	\N	\N	\N	\N
10264	\N	\N	\N	\N	\N	\N
10265	\N	\N	\N	\N	\N	\N
10266	\N	\N	\N	\N	\N	\N
10267	\N	\N	\N	\N	\N	\N
10268	\N	\N	\N	\N	\N	\N
10269	\N	\N	\N	\N	\N	\N
10270	\N	\N	\N	\N	\N	\N
10271	\N	\N	\N	\N	\N	\N
10272	\N	\N	\N	\N	\N	\N
10273	\N	\N	\N	\N	\N	\N
10274	\N	\N	\N	\N	\N	\N
10275	\N	\N	\N	\N	\N	\N
10276	\N	\N	\N	\N	\N	\N
10277	\N	\N	\N	\N	\N	\N
10278	\N	\N	\N	\N	\N	\N
10279	\N	\N	\N	\N	\N	\N
10280	\N	\N	\N	\N	\N	\N
10281	\N	\N	\N	\N	\N	\N
10282	\N	\N	\N	\N	\N	\N
10283	\N	\N	\N	\N	\N	\N
10284	\N	\N	\N	\N	\N	\N
10285	\N	\N	\N	\N	\N	\N
10286	\N	\N	\N	\N	\N	\N
10287	\N	\N	\N	\N	\N	\N
10288	\N	\N	\N	\N	\N	\N
10289	\N	\N	\N	\N	\N	\N
10290	\N	\N	\N	\N	\N	\N
10291	\N	\N	\N	\N	\N	\N
10292	\N	\N	\N	\N	\N	\N
10293	\N	\N	\N	\N	\N	\N
10294	\N	\N	\N	\N	\N	\N
10295	\N	\N	\N	\N	\N	\N
10296	\N	\N	\N	\N	\N	\N
10297	\N	\N	\N	\N	\N	\N
10298	\N	\N	\N	\N	\N	\N
10299	\N	\N	\N	\N	\N	\N
10300	\N	\N	\N	\N	\N	\N
10301	\N	\N	\N	\N	\N	\N
10302	\N	\N	\N	\N	\N	\N
10303	\N	\N	\N	\N	\N	\N
10304	\N	\N	\N	\N	\N	\N
10305	\N	\N	\N	\N	\N	\N
10306	\N	\N	\N	\N	\N	\N
10307	\N	\N	\N	\N	\N	\N
10308	\N	\N	\N	\N	\N	\N
10309	\N	\N	\N	\N	\N	\N
10310	\N	\N	\N	\N	\N	\N
10311	\N	\N	\N	\N	\N	\N
10312	\N	\N	\N	\N	\N	\N
10313	\N	\N	\N	\N	\N	\N
10314	\N	\N	\N	\N	\N	\N
10315	\N	\N	\N	\N	\N	\N
10316	\N	\N	\N	\N	\N	\N
10317	\N	\N	\N	\N	\N	\N
10318	\N	\N	\N	\N	\N	\N
10319	\N	\N	\N	\N	\N	\N
10320	\N	\N	\N	\N	\N	\N
10321	\N	\N	\N	\N	\N	\N
10322	\N	\N	\N	\N	\N	\N
10323	\N	\N	\N	\N	\N	\N
10324	\N	\N	\N	\N	\N	\N
10325	\N	\N	\N	\N	\N	\N
10326	\N	\N	\N	\N	\N	\N
10327	\N	\N	\N	\N	\N	\N
10328	\N	\N	\N	\N	\N	\N
10329	\N	\N	\N	\N	\N	\N
10330	\N	\N	\N	\N	\N	\N
10331	\N	\N	\N	\N	\N	\N
10332	\N	\N	\N	\N	\N	\N
10333	\N	\N	\N	\N	\N	\N
10334	\N	\N	\N	\N	\N	\N
10335	\N	\N	\N	\N	\N	\N
10336	\N	\N	\N	\N	\N	\N
10337	\N	\N	\N	\N	\N	\N
10338	\N	\N	\N	\N	\N	\N
10339	\N	\N	\N	\N	\N	\N
10340	\N	\N	\N	\N	\N	\N
10341	\N	\N	\N	\N	\N	\N
10342	\N	\N	\N	\N	\N	\N
10343	\N	\N	\N	\N	\N	\N
10344	\N	\N	\N	\N	\N	\N
10345	\N	\N	\N	\N	\N	\N
10346	\N	\N	\N	\N	\N	\N
10347	\N	\N	\N	\N	\N	\N
10348	\N	\N	\N	\N	\N	\N
10349	\N	\N	\N	\N	\N	\N
10350	\N	\N	\N	\N	\N	\N
10351	\N	\N	\N	\N	\N	\N
10352	\N	\N	\N	\N	\N	\N
10353	\N	\N	\N	\N	\N	\N
10354	\N	\N	\N	\N	\N	\N
10355	\N	\N	\N	\N	\N	\N
10356	\N	\N	\N	\N	\N	\N
10357	\N	\N	\N	\N	\N	\N
10358	\N	\N	\N	\N	\N	\N
10359	\N	\N	\N	\N	\N	\N
10360	\N	\N	\N	\N	\N	\N
10361	\N	\N	\N	\N	\N	\N
10362	\N	\N	\N	\N	\N	\N
10363	\N	\N	\N	\N	\N	\N
10364	\N	\N	\N	\N	\N	\N
10365	\N	\N	\N	\N	\N	\N
10366	\N	\N	\N	\N	\N	\N
10367	\N	\N	\N	\N	\N	\N
10368	\N	\N	\N	\N	\N	\N
10369	\N	\N	\N	\N	\N	\N
10370	\N	\N	\N	\N	\N	\N
10371	\N	\N	\N	\N	\N	\N
10372	\N	\N	\N	\N	\N	\N
10373	\N	\N	\N	\N	\N	\N
10374	\N	\N	\N	\N	\N	\N
10375	\N	\N	\N	\N	\N	\N
10376	\N	\N	\N	\N	\N	\N
10377	\N	\N	\N	\N	\N	\N
10378	\N	\N	\N	\N	\N	\N
10379	\N	\N	\N	\N	\N	\N
10380	\N	\N	\N	\N	\N	\N
10381	\N	\N	\N	\N	\N	\N
10382	\N	\N	\N	\N	\N	\N
10383	\N	\N	\N	\N	\N	\N
10384	\N	\N	\N	\N	\N	\N
10385	\N	\N	\N	\N	\N	\N
10386	\N	\N	\N	\N	\N	\N
10387	\N	\N	\N	\N	\N	\N
10388	\N	\N	\N	\N	\N	\N
10389	\N	\N	\N	\N	\N	\N
10390	\N	\N	\N	\N	\N	\N
10391	\N	\N	\N	\N	\N	\N
10392	\N	\N	\N	\N	\N	\N
10393	\N	\N	\N	\N	\N	\N
10394	\N	\N	\N	\N	\N	\N
10395	\N	\N	\N	\N	\N	\N
10396	\N	\N	\N	\N	\N	\N
10397	\N	\N	\N	\N	\N	\N
10398	\N	\N	\N	\N	\N	\N
10399	\N	\N	\N	\N	\N	\N
10400	\N	\N	\N	\N	\N	\N
10401	\N	\N	\N	\N	\N	\N
10402	\N	\N	\N	\N	\N	\N
10403	\N	\N	\N	\N	\N	\N
10404	\N	\N	\N	\N	\N	\N
10405	\N	\N	\N	\N	\N	\N
10406	\N	\N	\N	\N	\N	\N
10407	\N	\N	\N	\N	\N	\N
10408	\N	\N	\N	\N	\N	\N
10409	\N	\N	\N	\N	\N	\N
10410	\N	\N	\N	\N	\N	\N
10411	\N	\N	\N	\N	\N	\N
10412	\N	\N	\N	\N	\N	\N
10413	\N	\N	\N	\N	\N	\N
10414	\N	\N	\N	\N	\N	\N
10415	\N	\N	\N	\N	\N	\N
10416	\N	\N	\N	\N	\N	\N
10417	\N	\N	\N	\N	\N	\N
10418	\N	\N	\N	\N	\N	\N
10419	\N	\N	\N	\N	\N	\N
10420	\N	\N	\N	\N	\N	\N
10421	\N	\N	\N	\N	\N	\N
10422	\N	\N	\N	\N	\N	\N
10423	\N	\N	\N	\N	\N	\N
10424	\N	\N	\N	\N	\N	\N
10425	\N	\N	\N	\N	\N	\N
10426	\N	\N	\N	\N	\N	\N
10427	\N	\N	\N	\N	\N	\N
10428	\N	\N	\N	\N	\N	\N
10429	\N	\N	\N	\N	\N	\N
10430	\N	\N	\N	\N	\N	\N
10431	\N	\N	\N	\N	\N	\N
10432	\N	\N	\N	\N	\N	\N
10433	\N	\N	\N	\N	\N	\N
10434	\N	\N	\N	\N	\N	\N
10435	\N	\N	\N	\N	\N	\N
10436	\N	\N	\N	\N	\N	\N
10437	\N	\N	\N	\N	\N	\N
10438	\N	\N	\N	\N	\N	\N
10439	\N	\N	\N	\N	\N	\N
10440	\N	\N	\N	\N	\N	\N
10441	\N	\N	\N	\N	\N	\N
10442	\N	\N	\N	\N	\N	\N
10443	\N	\N	\N	\N	\N	\N
10444	\N	\N	\N	\N	\N	\N
10445	\N	\N	\N	\N	\N	\N
10446	\N	\N	\N	\N	\N	\N
10447	\N	\N	\N	\N	\N	\N
10448	\N	\N	\N	\N	\N	\N
10449	\N	\N	\N	\N	\N	\N
10450	\N	\N	\N	\N	\N	\N
10451	\N	\N	\N	\N	\N	\N
10452	\N	\N	\N	\N	\N	\N
10453	\N	\N	\N	\N	\N	\N
10454	\N	\N	\N	\N	\N	\N
10455	\N	\N	\N	\N	\N	\N
10456	\N	\N	\N	\N	\N	\N
10457	\N	\N	\N	\N	\N	\N
10458	\N	\N	\N	\N	\N	\N
10459	\N	\N	\N	\N	\N	\N
10460	\N	\N	\N	\N	\N	\N
10461	\N	\N	\N	\N	\N	\N
10462	\N	\N	\N	\N	\N	\N
10463	\N	\N	\N	\N	\N	\N
10464	\N	\N	\N	\N	\N	\N
10465	\N	\N	\N	\N	\N	\N
10466	\N	\N	\N	\N	\N	\N
10467	\N	\N	\N	\N	\N	\N
10468	\N	\N	\N	\N	\N	\N
10469	\N	\N	\N	\N	\N	\N
10470	\N	\N	\N	\N	\N	\N
10471	\N	\N	\N	\N	\N	\N
10472	\N	\N	\N	\N	\N	\N
10473	\N	\N	\N	\N	\N	\N
10474	\N	\N	\N	\N	\N	\N
10475	\N	\N	\N	\N	\N	\N
10476	\N	\N	\N	\N	\N	\N
10477	\N	\N	\N	\N	\N	\N
10478	\N	\N	\N	\N	\N	\N
10479	\N	\N	\N	\N	\N	\N
10480	\N	\N	\N	\N	\N	\N
10481	\N	\N	\N	\N	\N	\N
10482	\N	\N	\N	\N	\N	\N
10483	\N	\N	\N	\N	\N	\N
10484	\N	\N	\N	\N	\N	\N
10485	\N	\N	\N	\N	\N	\N
10486	\N	\N	\N	\N	\N	\N
10487	\N	\N	\N	\N	\N	\N
10488	\N	\N	\N	\N	\N	\N
10489	\N	\N	\N	\N	\N	\N
10490	\N	\N	\N	\N	\N	\N
10491	\N	\N	\N	\N	\N	\N
10492	\N	\N	\N	\N	\N	\N
10493	\N	\N	\N	\N	\N	\N
10494	\N	\N	\N	\N	\N	\N
10495	\N	\N	\N	\N	\N	\N
10496	\N	\N	\N	\N	\N	\N
10497	\N	\N	\N	\N	\N	\N
10498	\N	\N	\N	\N	\N	\N
10499	\N	\N	\N	\N	\N	\N
10500	\N	\N	\N	\N	\N	\N
10501	\N	\N	\N	\N	\N	\N
10502	\N	\N	\N	\N	\N	\N
10503	\N	\N	\N	\N	\N	\N
10504	\N	\N	\N	\N	\N	\N
10505	\N	\N	\N	\N	\N	\N
10506	\N	\N	\N	\N	\N	\N
10507	\N	\N	\N	\N	\N	\N
10508	\N	\N	\N	\N	\N	\N
10509	\N	\N	\N	\N	\N	\N
10510	\N	\N	\N	\N	\N	\N
10511	\N	\N	\N	\N	\N	\N
10512	\N	\N	\N	\N	\N	\N
10513	\N	\N	\N	\N	\N	\N
10514	\N	\N	\N	\N	\N	\N
10515	\N	\N	\N	\N	\N	\N
10516	\N	\N	\N	\N	\N	\N
10517	\N	\N	\N	\N	\N	\N
10518	\N	\N	\N	\N	\N	\N
10519	\N	\N	\N	\N	\N	\N
10520	\N	\N	\N	\N	\N	\N
10521	\N	\N	\N	\N	\N	\N
10522	\N	\N	\N	\N	\N	\N
10523	\N	\N	\N	\N	\N	\N
10524	\N	\N	\N	\N	\N	\N
10525	\N	\N	\N	\N	\N	\N
10526	\N	\N	\N	\N	\N	\N
10527	\N	\N	\N	\N	\N	\N
10528	\N	\N	\N	\N	\N	\N
10529	\N	\N	\N	\N	\N	\N
10530	\N	\N	\N	\N	\N	\N
10531	\N	\N	\N	\N	\N	\N
10532	\N	\N	\N	\N	\N	\N
10533	\N	\N	\N	\N	\N	\N
10534	\N	\N	\N	\N	\N	\N
10535	\N	\N	\N	\N	\N	\N
10536	\N	\N	\N	\N	\N	\N
10537	\N	\N	\N	\N	\N	\N
10538	\N	\N	\N	\N	\N	\N
10539	\N	\N	\N	\N	\N	\N
10540	\N	\N	\N	\N	\N	\N
10541	\N	\N	\N	\N	\N	\N
10542	\N	\N	\N	\N	\N	\N
10543	\N	\N	\N	\N	\N	\N
10544	\N	\N	\N	\N	\N	\N
10545	\N	\N	\N	\N	\N	\N
10546	\N	\N	\N	\N	\N	\N
10547	\N	\N	\N	\N	\N	\N
10548	\N	\N	\N	\N	\N	\N
10549	\N	\N	\N	\N	\N	\N
10550	\N	\N	\N	\N	\N	\N
10551	\N	\N	\N	\N	\N	\N
10552	\N	\N	\N	\N	\N	\N
10553	\N	\N	\N	\N	\N	\N
10554	\N	\N	\N	\N	\N	\N
10555	\N	\N	\N	\N	\N	\N
10556	\N	\N	\N	\N	\N	\N
10557	\N	\N	\N	\N	\N	\N
10558	\N	\N	\N	\N	\N	\N
10559	\N	\N	\N	\N	\N	\N
10560	\N	\N	\N	\N	\N	\N
10561	\N	\N	\N	\N	\N	\N
10562	\N	\N	\N	\N	\N	\N
10563	\N	\N	\N	\N	\N	\N
10564	\N	\N	\N	\N	\N	\N
10565	\N	\N	\N	\N	\N	\N
10566	\N	\N	\N	\N	\N	\N
10567	\N	\N	\N	\N	\N	\N
10568	\N	\N	\N	\N	\N	\N
10569	\N	\N	\N	\N	\N	\N
10570	\N	\N	\N	\N	\N	\N
10571	\N	\N	\N	\N	\N	\N
10572	\N	\N	\N	\N	\N	\N
10573	\N	\N	\N	\N	\N	\N
10574	\N	\N	\N	\N	\N	\N
10575	\N	\N	\N	\N	\N	\N
10576	\N	\N	\N	\N	\N	\N
10577	\N	\N	\N	\N	\N	\N
10578	\N	\N	\N	\N	\N	\N
10579	\N	\N	\N	\N	\N	\N
10580	\N	\N	\N	\N	\N	\N
10581	\N	\N	\N	\N	\N	\N
10582	\N	\N	\N	\N	\N	\N
10583	\N	\N	\N	\N	\N	\N
10584	\N	\N	\N	\N	\N	\N
10585	\N	\N	\N	\N	\N	\N
10586	\N	\N	\N	\N	\N	\N
10587	\N	\N	\N	\N	\N	\N
10588	\N	\N	\N	\N	\N	\N
10589	\N	\N	\N	\N	\N	\N
10590	\N	\N	\N	\N	\N	\N
10591	\N	\N	\N	\N	\N	\N
10592	\N	\N	\N	\N	\N	\N
10593	\N	\N	\N	\N	\N	\N
10594	\N	\N	\N	\N	\N	\N
10595	\N	\N	\N	\N	\N	\N
10596	\N	\N	\N	\N	\N	\N
10597	\N	\N	\N	\N	\N	\N
10598	\N	\N	\N	\N	\N	\N
10599	\N	\N	\N	\N	\N	\N
10600	\N	\N	\N	\N	\N	\N
10601	\N	\N	\N	\N	\N	\N
10602	\N	\N	\N	\N	\N	\N
10603	\N	\N	\N	\N	\N	\N
10604	\N	\N	\N	\N	\N	\N
10605	\N	\N	\N	\N	\N	\N
10606	\N	\N	\N	\N	\N	\N
10607	\N	\N	\N	\N	\N	\N
10608	\N	\N	\N	\N	\N	\N
10609	\N	\N	\N	\N	\N	\N
10610	\N	\N	\N	\N	\N	\N
10611	\N	\N	\N	\N	\N	\N
10612	\N	\N	\N	\N	\N	\N
10613	\N	\N	\N	\N	\N	\N
10614	\N	\N	\N	\N	\N	\N
10615	\N	\N	\N	\N	\N	\N
10616	\N	\N	\N	\N	\N	\N
10617	\N	\N	\N	\N	\N	\N
10618	\N	\N	\N	\N	\N	\N
10619	\N	\N	\N	\N	\N	\N
10620	\N	\N	\N	\N	\N	\N
10621	\N	\N	\N	\N	\N	\N
10622	\N	\N	\N	\N	\N	\N
10623	\N	\N	\N	\N	\N	\N
10624	\N	\N	\N	\N	\N	\N
10625	\N	\N	\N	\N	\N	\N
10626	\N	\N	\N	\N	\N	\N
10627	\N	\N	\N	\N	\N	\N
10628	\N	\N	\N	\N	\N	\N
10629	\N	\N	\N	\N	\N	\N
10630	\N	\N	\N	\N	\N	\N
10631	\N	\N	\N	\N	\N	\N
10632	\N	\N	\N	\N	\N	\N
10633	\N	\N	\N	\N	\N	\N
10634	\N	\N	\N	\N	\N	\N
10635	\N	\N	\N	\N	\N	\N
10636	\N	\N	\N	\N	\N	\N
10637	\N	\N	\N	\N	\N	\N
10638	\N	\N	\N	\N	\N	\N
10639	\N	\N	\N	\N	\N	\N
10640	\N	\N	\N	\N	\N	\N
10641	\N	\N	\N	\N	\N	\N
10642	\N	\N	\N	\N	\N	\N
10643	\N	\N	\N	\N	\N	\N
10644	\N	\N	\N	\N	\N	\N
10645	\N	\N	\N	\N	\N	\N
10646	\N	\N	\N	\N	\N	\N
10647	\N	\N	\N	\N	\N	\N
10648	\N	\N	\N	\N	\N	\N
10649	\N	\N	\N	\N	\N	\N
10650	\N	\N	\N	\N	\N	\N
10651	\N	\N	\N	\N	\N	\N
10652	\N	\N	\N	\N	\N	\N
10653	\N	\N	\N	\N	\N	\N
10654	\N	\N	\N	\N	\N	\N
10655	\N	\N	\N	\N	\N	\N
10656	\N	\N	\N	\N	\N	\N
10657	\N	\N	\N	\N	\N	\N
10658	\N	\N	\N	\N	\N	\N
10659	\N	\N	\N	\N	\N	\N
10660	\N	\N	\N	\N	\N	\N
10661	\N	\N	\N	\N	\N	\N
10662	\N	\N	\N	\N	\N	\N
10663	\N	\N	\N	\N	\N	\N
10664	\N	\N	\N	\N	\N	\N
10665	\N	\N	\N	\N	\N	\N
10666	\N	\N	\N	\N	\N	\N
10667	\N	\N	\N	\N	\N	\N
10668	\N	\N	\N	\N	\N	\N
10669	\N	\N	\N	\N	\N	\N
10670	\N	\N	\N	\N	\N	\N
10671	\N	\N	\N	\N	\N	\N
10672	\N	\N	\N	\N	\N	\N
10673	\N	\N	\N	\N	\N	\N
10674	\N	\N	\N	\N	\N	\N
10675	\N	\N	\N	\N	\N	\N
10676	\N	\N	\N	\N	\N	\N
10677	\N	\N	\N	\N	\N	\N
10678	\N	\N	\N	\N	\N	\N
10679	\N	\N	\N	\N	\N	\N
10680	\N	\N	\N	\N	\N	\N
10681	\N	\N	\N	\N	\N	\N
10682	\N	\N	\N	\N	\N	\N
10683	\N	\N	\N	\N	\N	\N
10684	\N	\N	\N	\N	\N	\N
10685	\N	\N	\N	\N	\N	\N
10686	\N	\N	\N	\N	\N	\N
10687	\N	\N	\N	\N	\N	\N
10688	\N	\N	\N	\N	\N	\N
10689	\N	\N	\N	\N	\N	\N
10690	\N	\N	\N	\N	\N	\N
10691	\N	\N	\N	\N	\N	\N
10692	\N	\N	\N	\N	\N	\N
10693	\N	\N	\N	\N	\N	\N
10694	\N	\N	\N	\N	\N	\N
10695	\N	\N	\N	\N	\N	\N
10696	\N	\N	\N	\N	\N	\N
10697	\N	\N	\N	\N	\N	\N
10698	\N	\N	\N	\N	\N	\N
10699	\N	\N	\N	\N	\N	\N
10700	\N	\N	\N	\N	\N	\N
10701	\N	\N	\N	\N	\N	\N
10702	\N	\N	\N	\N	\N	\N
10703	\N	\N	\N	\N	\N	\N
10704	\N	\N	\N	\N	\N	\N
10705	\N	\N	\N	\N	\N	\N
10706	\N	\N	\N	\N	\N	\N
10707	\N	\N	\N	\N	\N	\N
10708	\N	\N	\N	\N	\N	\N
10709	\N	\N	\N	\N	\N	\N
10710	\N	\N	\N	\N	\N	\N
10711	\N	\N	\N	\N	\N	\N
10712	\N	\N	\N	\N	\N	\N
10713	\N	\N	\N	\N	\N	\N
10714	\N	\N	\N	\N	\N	\N
10715	\N	\N	\N	\N	\N	\N
10716	\N	\N	\N	\N	\N	\N
10717	\N	\N	\N	\N	\N	\N
10718	\N	\N	\N	\N	\N	\N
10719	\N	\N	\N	\N	\N	\N
10720	\N	\N	\N	\N	\N	\N
10721	\N	\N	\N	\N	\N	\N
10722	\N	\N	\N	\N	\N	\N
10723	\N	\N	\N	\N	\N	\N
10724	\N	\N	\N	\N	\N	\N
10725	\N	\N	\N	\N	\N	\N
10726	\N	\N	\N	\N	\N	\N
10727	\N	\N	\N	\N	\N	\N
10728	\N	\N	\N	\N	\N	\N
10729	\N	\N	\N	\N	\N	\N
10730	\N	\N	\N	\N	\N	\N
10731	\N	\N	\N	\N	\N	\N
10732	\N	\N	\N	\N	\N	\N
10733	\N	\N	\N	\N	\N	\N
10734	\N	\N	\N	\N	\N	\N
10735	\N	\N	\N	\N	\N	\N
10736	\N	\N	\N	\N	\N	\N
10737	\N	\N	\N	\N	\N	\N
10738	\N	\N	\N	\N	\N	\N
10739	\N	\N	\N	\N	\N	\N
10740	\N	\N	\N	\N	\N	\N
10741	\N	\N	\N	\N	\N	\N
10742	\N	\N	\N	\N	\N	\N
10743	\N	\N	\N	\N	\N	\N
10744	\N	\N	\N	\N	\N	\N
10745	\N	\N	\N	\N	\N	\N
10746	\N	\N	\N	\N	\N	\N
10747	\N	\N	\N	\N	\N	\N
10748	\N	\N	\N	\N	\N	\N
10749	\N	\N	\N	\N	\N	\N
10750	\N	\N	\N	\N	\N	\N
10751	\N	\N	\N	\N	\N	\N
10752	\N	\N	\N	\N	\N	\N
10753	\N	\N	\N	\N	\N	\N
10754	\N	\N	\N	\N	\N	\N
10755	\N	\N	\N	\N	\N	\N
10756	\N	\N	\N	\N	\N	\N
10757	\N	\N	\N	\N	\N	\N
10758	\N	\N	\N	\N	\N	\N
10759	\N	\N	\N	\N	\N	\N
10760	\N	\N	\N	\N	\N	\N
10761	\N	\N	\N	\N	\N	\N
10762	\N	\N	\N	\N	\N	\N
10763	\N	\N	\N	\N	\N	\N
10764	\N	\N	\N	\N	\N	\N
10765	\N	\N	\N	\N	\N	\N
10766	\N	\N	\N	\N	\N	\N
10767	\N	\N	\N	\N	\N	\N
10768	\N	\N	\N	\N	\N	\N
10769	\N	\N	\N	\N	\N	\N
10770	\N	\N	\N	\N	\N	\N
10771	\N	\N	\N	\N	\N	\N
10772	\N	\N	\N	\N	\N	\N
10773	\N	\N	\N	\N	\N	\N
10774	\N	\N	\N	\N	\N	\N
10775	\N	\N	\N	\N	\N	\N
10776	\N	\N	\N	\N	\N	\N
10777	\N	\N	\N	\N	\N	\N
10778	\N	\N	\N	\N	\N	\N
10779	\N	\N	\N	\N	\N	\N
10780	\N	\N	\N	\N	\N	\N
10781	\N	\N	\N	\N	\N	\N
10782	\N	\N	\N	\N	\N	\N
10783	\N	\N	\N	\N	\N	\N
10784	\N	\N	\N	\N	\N	\N
10785	\N	\N	\N	\N	\N	\N
10786	\N	\N	\N	\N	\N	\N
10787	\N	\N	\N	\N	\N	\N
10788	\N	\N	\N	\N	\N	\N
10789	\N	\N	\N	\N	\N	\N
10790	\N	\N	\N	\N	\N	\N
10791	\N	\N	\N	\N	\N	\N
10792	\N	\N	\N	\N	\N	\N
10793	\N	\N	\N	\N	\N	\N
10794	\N	\N	\N	\N	\N	\N
10795	\N	\N	\N	\N	\N	\N
10796	\N	\N	\N	\N	\N	\N
10797	\N	\N	\N	\N	\N	\N
10798	\N	\N	\N	\N	\N	\N
10799	\N	\N	\N	\N	\N	\N
10800	\N	\N	\N	\N	\N	\N
10801	\N	\N	\N	\N	\N	\N
10802	\N	\N	\N	\N	\N	\N
10803	\N	\N	\N	\N	\N	\N
10804	\N	\N	\N	\N	\N	\N
10805	\N	\N	\N	\N	\N	\N
10806	\N	\N	\N	\N	\N	\N
10807	\N	\N	\N	\N	\N	\N
10808	\N	\N	\N	\N	\N	\N
10809	\N	\N	\N	\N	\N	\N
10810	\N	\N	\N	\N	\N	\N
10811	\N	\N	\N	\N	\N	\N
10812	\N	\N	\N	\N	\N	\N
10813	\N	\N	\N	\N	\N	\N
10814	\N	\N	\N	\N	\N	\N
10815	\N	\N	\N	\N	\N	\N
10816	\N	\N	\N	\N	\N	\N
10817	\N	\N	\N	\N	\N	\N
10818	\N	\N	\N	\N	\N	\N
10819	\N	\N	\N	\N	\N	\N
10820	\N	\N	\N	\N	\N	\N
10821	\N	\N	\N	\N	\N	\N
10822	\N	\N	\N	\N	\N	\N
10823	\N	\N	\N	\N	\N	\N
10824	\N	\N	\N	\N	\N	\N
10825	\N	\N	\N	\N	\N	\N
10826	\N	\N	\N	\N	\N	\N
10827	\N	\N	\N	\N	\N	\N
10828	\N	\N	\N	\N	\N	\N
10829	\N	\N	\N	\N	\N	\N
10830	\N	\N	\N	\N	\N	\N
10831	\N	\N	\N	\N	\N	\N
10832	\N	\N	\N	\N	\N	\N
10833	\N	\N	\N	\N	\N	\N
10834	\N	\N	\N	\N	\N	\N
10835	\N	\N	\N	\N	\N	\N
10836	\N	\N	\N	\N	\N	\N
10837	\N	\N	\N	\N	\N	\N
10838	\N	\N	\N	\N	\N	\N
10839	\N	\N	\N	\N	\N	\N
10840	\N	\N	\N	\N	\N	\N
10841	\N	\N	\N	\N	\N	\N
10842	\N	\N	\N	\N	\N	\N
10843	\N	\N	\N	\N	\N	\N
10844	\N	\N	\N	\N	\N	\N
10845	\N	\N	\N	\N	\N	\N
10846	\N	\N	\N	\N	\N	\N
10847	\N	\N	\N	\N	\N	\N
10848	\N	\N	\N	\N	\N	\N
10849	\N	\N	\N	\N	\N	\N
10850	\N	\N	\N	\N	\N	\N
10851	\N	\N	\N	\N	\N	\N
10852	\N	\N	\N	\N	\N	\N
10853	\N	\N	\N	\N	\N	\N
10854	\N	\N	\N	\N	\N	\N
10855	\N	\N	\N	\N	\N	\N
10856	\N	\N	\N	\N	\N	\N
10857	\N	\N	\N	\N	\N	\N
10858	\N	\N	\N	\N	\N	\N
10859	\N	\N	\N	\N	\N	\N
10860	\N	\N	\N	\N	\N	\N
10861	\N	\N	\N	\N	\N	\N
10862	\N	\N	\N	\N	\N	\N
10863	\N	\N	\N	\N	\N	\N
10864	\N	\N	\N	\N	\N	\N
10865	\N	\N	\N	\N	\N	\N
10866	\N	\N	\N	\N	\N	\N
10867	\N	\N	\N	\N	\N	\N
10868	\N	\N	\N	\N	\N	\N
10869	\N	\N	\N	\N	\N	\N
10870	\N	\N	\N	\N	\N	\N
10871	\N	\N	\N	\N	\N	\N
10872	\N	\N	\N	\N	\N	\N
10873	\N	\N	\N	\N	\N	\N
10874	\N	\N	\N	\N	\N	\N
10875	\N	\N	\N	\N	\N	\N
10876	\N	\N	\N	\N	\N	\N
10877	\N	\N	\N	\N	\N	\N
10878	\N	\N	\N	\N	\N	\N
10879	\N	\N	\N	\N	\N	\N
10880	\N	\N	\N	\N	\N	\N
10881	\N	\N	\N	\N	\N	\N
10882	\N	\N	\N	\N	\N	\N
10883	\N	\N	\N	\N	\N	\N
10884	\N	\N	\N	\N	\N	\N
10885	\N	\N	\N	\N	\N	\N
10886	\N	\N	\N	\N	\N	\N
10887	\N	\N	\N	\N	\N	\N
10888	\N	\N	\N	\N	\N	\N
10889	\N	\N	\N	\N	\N	\N
10890	\N	\N	\N	\N	\N	\N
10891	\N	\N	\N	\N	\N	\N
10892	\N	\N	\N	\N	\N	\N
10893	\N	\N	\N	\N	\N	\N
10894	\N	\N	\N	\N	\N	\N
10895	\N	\N	\N	\N	\N	\N
10896	\N	\N	\N	\N	\N	\N
10897	\N	\N	\N	\N	\N	\N
10898	\N	\N	\N	\N	\N	\N
10899	\N	\N	\N	\N	\N	\N
10900	\N	\N	\N	\N	\N	\N
10901	\N	\N	\N	\N	\N	\N
10902	\N	\N	\N	\N	\N	\N
10903	\N	\N	\N	\N	\N	\N
10904	\N	\N	\N	\N	\N	\N
10905	\N	\N	\N	\N	\N	\N
10906	\N	\N	\N	\N	\N	\N
10907	\N	\N	\N	\N	\N	\N
10908	\N	\N	\N	\N	\N	\N
10909	\N	\N	\N	\N	\N	\N
10910	\N	\N	\N	\N	\N	\N
10911	\N	\N	\N	\N	\N	\N
10912	\N	\N	\N	\N	\N	\N
10913	\N	\N	\N	\N	\N	\N
10914	\N	\N	\N	\N	\N	\N
10915	\N	\N	\N	\N	\N	\N
10916	\N	\N	\N	\N	\N	\N
10917	\N	\N	\N	\N	\N	\N
10918	\N	\N	\N	\N	\N	\N
10919	\N	\N	\N	\N	\N	\N
10920	\N	\N	\N	\N	\N	\N
10921	\N	\N	\N	\N	\N	\N
10922	\N	\N	\N	\N	\N	\N
10923	\N	\N	\N	\N	\N	\N
10924	\N	\N	\N	\N	\N	\N
10925	\N	\N	\N	\N	\N	\N
10926	\N	\N	\N	\N	\N	\N
10927	\N	\N	\N	\N	\N	\N
10928	\N	\N	\N	\N	\N	\N
10929	\N	\N	\N	\N	\N	\N
10930	\N	\N	\N	\N	\N	\N
10931	\N	\N	\N	\N	\N	\N
10932	\N	\N	\N	\N	\N	\N
10933	\N	\N	\N	\N	\N	\N
10934	\N	\N	\N	\N	\N	\N
10935	\N	\N	\N	\N	\N	\N
10936	\N	\N	\N	\N	\N	\N
10937	\N	\N	\N	\N	\N	\N
10938	\N	\N	\N	\N	\N	\N
10939	\N	\N	\N	\N	\N	\N
10940	\N	\N	\N	\N	\N	\N
10941	\N	\N	\N	\N	\N	\N
10942	\N	\N	\N	\N	\N	\N
10943	\N	\N	\N	\N	\N	\N
10944	\N	\N	\N	\N	\N	\N
10945	\N	\N	\N	\N	\N	\N
10946	\N	\N	\N	\N	\N	\N
10947	\N	\N	\N	\N	\N	\N
10948	\N	\N	\N	\N	\N	\N
10949	\N	\N	\N	\N	\N	\N
10950	\N	\N	\N	\N	\N	\N
10951	\N	\N	\N	\N	\N	\N
10952	\N	\N	\N	\N	\N	\N
10953	\N	\N	\N	\N	\N	\N
10954	\N	\N	\N	\N	\N	\N
10955	\N	\N	\N	\N	\N	\N
10956	\N	\N	\N	\N	\N	\N
10957	\N	\N	\N	\N	\N	\N
10958	\N	\N	\N	\N	\N	\N
10959	\N	\N	\N	\N	\N	\N
10960	\N	\N	\N	\N	\N	\N
10961	\N	\N	\N	\N	\N	\N
10962	\N	\N	\N	\N	\N	\N
10963	\N	\N	\N	\N	\N	\N
10964	\N	\N	\N	\N	\N	\N
10965	\N	\N	\N	\N	\N	\N
10966	\N	\N	\N	\N	\N	\N
10967	\N	\N	\N	\N	\N	\N
10968	\N	\N	\N	\N	\N	\N
10969	\N	\N	\N	\N	\N	\N
10970	\N	\N	\N	\N	\N	\N
10971	\N	\N	\N	\N	\N	\N
10972	\N	\N	\N	\N	\N	\N
10973	\N	\N	\N	\N	\N	\N
10974	\N	\N	\N	\N	\N	\N
10975	\N	\N	\N	\N	\N	\N
10976	\N	\N	\N	\N	\N	\N
10977	\N	\N	\N	\N	\N	\N
10978	\N	\N	\N	\N	\N	\N
10979	\N	\N	\N	\N	\N	\N
10980	\N	\N	\N	\N	\N	\N
10981	\N	\N	\N	\N	\N	\N
10982	\N	\N	\N	\N	\N	\N
10983	\N	\N	\N	\N	\N	\N
10984	\N	\N	\N	\N	\N	\N
10985	\N	\N	\N	\N	\N	\N
10986	\N	\N	\N	\N	\N	\N
10987	\N	\N	\N	\N	\N	\N
10988	\N	\N	\N	\N	\N	\N
10989	\N	\N	\N	\N	\N	\N
10990	\N	\N	\N	\N	\N	\N
10991	\N	\N	\N	\N	\N	\N
10992	\N	\N	\N	\N	\N	\N
10993	\N	\N	\N	\N	\N	\N
10994	\N	\N	\N	\N	\N	\N
10995	\N	\N	\N	\N	\N	\N
10996	\N	\N	\N	\N	\N	\N
10997	\N	\N	\N	\N	\N	\N
10998	\N	\N	\N	\N	\N	\N
10999	\N	\N	\N	\N	\N	\N
11000	\N	\N	\N	\N	\N	\N
11001	\N	\N	\N	\N	\N	\N
11002	\N	\N	\N	\N	\N	\N
11003	\N	\N	\N	\N	\N	\N
11004	\N	\N	\N	\N	\N	\N
11005	\N	\N	\N	\N	\N	\N
11006	\N	\N	\N	\N	\N	\N
11007	\N	\N	\N	\N	\N	\N
11008	\N	\N	\N	\N	\N	\N
11009	\N	\N	\N	\N	\N	\N
11010	\N	\N	\N	\N	\N	\N
11011	\N	\N	\N	\N	\N	\N
11012	\N	\N	\N	\N	\N	\N
11013	\N	\N	\N	\N	\N	\N
11014	\N	\N	\N	\N	\N	\N
11015	\N	\N	\N	\N	\N	\N
11016	\N	\N	\N	\N	\N	\N
11017	\N	\N	\N	\N	\N	\N
11018	\N	\N	\N	\N	\N	\N
11019	\N	\N	\N	\N	\N	\N
11020	\N	\N	\N	\N	\N	\N
11021	\N	\N	\N	\N	\N	\N
11022	\N	\N	\N	\N	\N	\N
11023	\N	\N	\N	\N	\N	\N
11024	\N	\N	\N	\N	\N	\N
11025	\N	\N	\N	\N	\N	\N
11026	\N	\N	\N	\N	\N	\N
11027	\N	\N	\N	\N	\N	\N
11028	\N	\N	\N	\N	\N	\N
11029	\N	\N	\N	\N	\N	\N
11030	\N	\N	\N	\N	\N	\N
11031	\N	\N	\N	\N	\N	\N
11032	\N	\N	\N	\N	\N	\N
11033	\N	\N	\N	\N	\N	\N
11034	\N	\N	\N	\N	\N	\N
11035	\N	\N	\N	\N	\N	\N
11036	\N	\N	\N	\N	\N	\N
11037	\N	\N	\N	\N	\N	\N
11038	\N	\N	\N	\N	\N	\N
11039	\N	\N	\N	\N	\N	\N
11040	\N	\N	\N	\N	\N	\N
11041	\N	\N	\N	\N	\N	\N
11042	\N	\N	\N	\N	\N	\N
11043	\N	\N	\N	\N	\N	\N
11044	\N	\N	\N	\N	\N	\N
11045	\N	\N	\N	\N	\N	\N
11046	\N	\N	\N	\N	\N	\N
11047	\N	\N	\N	\N	\N	\N
11048	\N	\N	\N	\N	\N	\N
11049	\N	\N	\N	\N	\N	\N
11050	\N	\N	\N	\N	\N	\N
11051	\N	\N	\N	\N	\N	\N
11052	\N	\N	\N	\N	\N	\N
11053	\N	\N	\N	\N	\N	\N
11054	\N	\N	\N	\N	\N	\N
11055	\N	\N	\N	\N	\N	\N
11056	\N	\N	\N	\N	\N	\N
11057	\N	\N	\N	\N	\N	\N
11058	\N	\N	\N	\N	\N	\N
11059	\N	\N	\N	\N	\N	\N
11060	\N	\N	\N	\N	\N	\N
11061	\N	\N	\N	\N	\N	\N
11062	\N	\N	\N	\N	\N	\N
11063	\N	\N	\N	\N	\N	\N
11064	\N	\N	\N	\N	\N	\N
11065	\N	\N	\N	\N	\N	\N
11066	\N	\N	\N	\N	\N	\N
11067	\N	\N	\N	\N	\N	\N
11068	\N	\N	\N	\N	\N	\N
11069	\N	\N	\N	\N	\N	\N
11070	\N	\N	\N	\N	\N	\N
11071	\N	\N	\N	\N	\N	\N
11072	\N	\N	\N	\N	\N	\N
11073	\N	\N	\N	\N	\N	\N
11074	\N	\N	\N	\N	\N	\N
11075	\N	\N	\N	\N	\N	\N
11076	\N	\N	\N	\N	\N	\N
11077	\N	\N	\N	\N	\N	\N
11078	\N	\N	\N	\N	\N	\N
11079	\N	\N	\N	\N	\N	\N
11080	\N	\N	\N	\N	\N	\N
11081	\N	\N	\N	\N	\N	\N
11082	\N	\N	\N	\N	\N	\N
11083	\N	\N	\N	\N	\N	\N
11084	\N	\N	\N	\N	\N	\N
11085	\N	\N	\N	\N	\N	\N
11086	\N	\N	\N	\N	\N	\N
11087	\N	\N	\N	\N	\N	\N
11088	\N	\N	\N	\N	\N	\N
11089	\N	\N	\N	\N	\N	\N
11090	\N	\N	\N	\N	\N	\N
11091	\N	\N	\N	\N	\N	\N
11092	\N	\N	\N	\N	\N	\N
11093	\N	\N	\N	\N	\N	\N
11094	\N	\N	\N	\N	\N	\N
11095	\N	\N	\N	\N	\N	\N
11096	\N	\N	\N	\N	\N	\N
11097	\N	\N	\N	\N	\N	\N
11098	\N	\N	\N	\N	\N	\N
11099	\N	\N	\N	\N	\N	\N
11100	\N	\N	\N	\N	\N	\N
11101	\N	\N	\N	\N	\N	\N
11102	\N	\N	\N	\N	\N	\N
11103	\N	\N	\N	\N	\N	\N
11104	\N	\N	\N	\N	\N	\N
11105	\N	\N	\N	\N	\N	\N
11106	\N	\N	\N	\N	\N	\N
11107	\N	\N	\N	\N	\N	\N
11108	\N	\N	\N	\N	\N	\N
11109	\N	\N	\N	\N	\N	\N
11110	\N	\N	\N	\N	\N	\N
11111	\N	\N	\N	\N	\N	\N
11112	\N	\N	\N	\N	\N	\N
11113	\N	\N	\N	\N	\N	\N
11114	\N	\N	\N	\N	\N	\N
11115	\N	\N	\N	\N	\N	\N
11116	\N	\N	\N	\N	\N	\N
11117	\N	\N	\N	\N	\N	\N
11118	\N	\N	\N	\N	\N	\N
11119	\N	\N	\N	\N	\N	\N
11120	\N	\N	\N	\N	\N	\N
11121	\N	\N	\N	\N	\N	\N
11122	\N	\N	\N	\N	\N	\N
11123	\N	\N	\N	\N	\N	\N
11124	\N	\N	\N	\N	\N	\N
11125	\N	\N	\N	\N	\N	\N
11126	\N	\N	\N	\N	\N	\N
11127	\N	\N	\N	\N	\N	\N
11128	\N	\N	\N	\N	\N	\N
11129	\N	\N	\N	\N	\N	\N
11130	\N	\N	\N	\N	\N	\N
11131	\N	\N	\N	\N	\N	\N
11132	\N	\N	\N	\N	\N	\N
11133	\N	\N	\N	\N	\N	\N
11134	\N	\N	\N	\N	\N	\N
11135	\N	\N	\N	\N	\N	\N
11136	\N	\N	\N	\N	\N	\N
11137	\N	\N	\N	\N	\N	\N
11138	\N	\N	\N	\N	\N	\N
11139	\N	\N	\N	\N	\N	\N
11140	\N	\N	\N	\N	\N	\N
11141	\N	\N	\N	\N	\N	\N
11142	\N	\N	\N	\N	\N	\N
11143	\N	\N	\N	\N	\N	\N
11144	\N	\N	\N	\N	\N	\N
11145	\N	\N	\N	\N	\N	\N
11146	\N	\N	\N	\N	\N	\N
11147	\N	\N	\N	\N	\N	\N
11148	\N	\N	\N	\N	\N	\N
11149	\N	\N	\N	\N	\N	\N
11150	\N	\N	\N	\N	\N	\N
11151	\N	\N	\N	\N	\N	\N
11152	\N	\N	\N	\N	\N	\N
11153	\N	\N	\N	\N	\N	\N
11154	\N	\N	\N	\N	\N	\N
11155	\N	\N	\N	\N	\N	\N
11156	\N	\N	\N	\N	\N	\N
11157	\N	\N	\N	\N	\N	\N
11158	\N	\N	\N	\N	\N	\N
11159	\N	\N	\N	\N	\N	\N
11160	\N	\N	\N	\N	\N	\N
11161	\N	\N	\N	\N	\N	\N
11162	\N	\N	\N	\N	\N	\N
11163	\N	\N	\N	\N	\N	\N
11164	\N	\N	\N	\N	\N	\N
11165	\N	\N	\N	\N	\N	\N
11166	\N	\N	\N	\N	\N	\N
11167	\N	\N	\N	\N	\N	\N
11168	\N	\N	\N	\N	\N	\N
11169	\N	\N	\N	\N	\N	\N
11170	\N	\N	\N	\N	\N	\N
11171	\N	\N	\N	\N	\N	\N
11172	\N	\N	\N	\N	\N	\N
11173	\N	\N	\N	\N	\N	\N
11174	\N	\N	\N	\N	\N	\N
11175	\N	\N	\N	\N	\N	\N
11176	\N	\N	\N	\N	\N	\N
11177	\N	\N	\N	\N	\N	\N
11178	\N	\N	\N	\N	\N	\N
11179	\N	\N	\N	\N	\N	\N
11180	\N	\N	\N	\N	\N	\N
11181	\N	\N	\N	\N	\N	\N
11182	\N	\N	\N	\N	\N	\N
11183	\N	\N	\N	\N	\N	\N
11184	\N	\N	\N	\N	\N	\N
11185	\N	\N	\N	\N	\N	\N
11186	\N	\N	\N	\N	\N	\N
11187	\N	\N	\N	\N	\N	\N
11188	\N	\N	\N	\N	\N	\N
11189	\N	\N	\N	\N	\N	\N
11190	\N	\N	\N	\N	\N	\N
11191	\N	\N	\N	\N	\N	\N
11192	\N	\N	\N	\N	\N	\N
11193	\N	\N	\N	\N	\N	\N
11194	\N	\N	\N	\N	\N	\N
11195	\N	\N	\N	\N	\N	\N
11196	\N	\N	\N	\N	\N	\N
11197	\N	\N	\N	\N	\N	\N
11198	\N	\N	\N	\N	\N	\N
11199	\N	\N	\N	\N	\N	\N
11200	\N	\N	\N	\N	\N	\N
11201	\N	\N	\N	\N	\N	\N
11202	\N	\N	\N	\N	\N	\N
11203	\N	\N	\N	\N	\N	\N
11204	\N	\N	\N	\N	\N	\N
11205	\N	\N	\N	\N	\N	\N
11206	\N	\N	\N	\N	\N	\N
11207	\N	\N	\N	\N	\N	\N
11208	\N	\N	\N	\N	\N	\N
11209	\N	\N	\N	\N	\N	\N
11210	\N	\N	\N	\N	\N	\N
11211	\N	\N	\N	\N	\N	\N
11212	\N	\N	\N	\N	\N	\N
11213	\N	\N	\N	\N	\N	\N
11214	\N	\N	\N	\N	\N	\N
11215	\N	\N	\N	\N	\N	\N
11216	\N	\N	\N	\N	\N	\N
11217	\N	\N	\N	\N	\N	\N
11218	\N	\N	\N	\N	\N	\N
11219	\N	\N	\N	\N	\N	\N
11220	\N	\N	\N	\N	\N	\N
11221	\N	\N	\N	\N	\N	\N
11222	\N	\N	\N	\N	\N	\N
11223	\N	\N	\N	\N	\N	\N
11224	\N	\N	\N	\N	\N	\N
11225	\N	\N	\N	\N	\N	\N
11226	\N	\N	\N	\N	\N	\N
11227	\N	\N	\N	\N	\N	\N
11228	\N	\N	\N	\N	\N	\N
11229	\N	\N	\N	\N	\N	\N
11230	\N	\N	\N	\N	\N	\N
11231	\N	\N	\N	\N	\N	\N
11232	\N	\N	\N	\N	\N	\N
11233	\N	\N	\N	\N	\N	\N
11234	\N	\N	\N	\N	\N	\N
11235	\N	\N	\N	\N	\N	\N
11236	\N	\N	\N	\N	\N	\N
11237	\N	\N	\N	\N	\N	\N
11238	\N	\N	\N	\N	\N	\N
11239	\N	\N	\N	\N	\N	\N
11240	\N	\N	\N	\N	\N	\N
11241	\N	\N	\N	\N	\N	\N
11242	\N	\N	\N	\N	\N	\N
11243	\N	\N	\N	\N	\N	\N
11244	\N	\N	\N	\N	\N	\N
11245	\N	\N	\N	\N	\N	\N
11246	\N	\N	\N	\N	\N	\N
11247	\N	\N	\N	\N	\N	\N
11248	\N	\N	\N	\N	\N	\N
11249	\N	\N	\N	\N	\N	\N
11250	\N	\N	\N	\N	\N	\N
11251	\N	\N	\N	\N	\N	\N
11252	\N	\N	\N	\N	\N	\N
11253	\N	\N	\N	\N	\N	\N
11254	\N	\N	\N	\N	\N	\N
11255	\N	\N	\N	\N	\N	\N
11256	\N	\N	\N	\N	\N	\N
11257	\N	\N	\N	\N	\N	\N
11258	\N	\N	\N	\N	\N	\N
11259	\N	\N	\N	\N	\N	\N
11260	\N	\N	\N	\N	\N	\N
11261	\N	\N	\N	\N	\N	\N
11262	\N	\N	\N	\N	\N	\N
11263	\N	\N	\N	\N	\N	\N
11264	\N	\N	\N	\N	\N	\N
11265	\N	\N	\N	\N	\N	\N
11266	\N	\N	\N	\N	\N	\N
11267	\N	\N	\N	\N	\N	\N
11268	\N	\N	\N	\N	\N	\N
11269	\N	\N	\N	\N	\N	\N
11270	\N	\N	\N	\N	\N	\N
11271	\N	\N	\N	\N	\N	\N
11272	\N	\N	\N	\N	\N	\N
11273	\N	\N	\N	\N	\N	\N
11274	\N	\N	\N	\N	\N	\N
11275	\N	\N	\N	\N	\N	\N
11276	\N	\N	\N	\N	\N	\N
11277	\N	\N	\N	\N	\N	\N
11278	\N	\N	\N	\N	\N	\N
11279	\N	\N	\N	\N	\N	\N
11280	\N	\N	\N	\N	\N	\N
11281	\N	\N	\N	\N	\N	\N
11282	\N	\N	\N	\N	\N	\N
11283	\N	\N	\N	\N	\N	\N
11284	\N	\N	\N	\N	\N	\N
11285	\N	\N	\N	\N	\N	\N
11286	\N	\N	\N	\N	\N	\N
11287	\N	\N	\N	\N	\N	\N
11288	\N	\N	\N	\N	\N	\N
11289	\N	\N	\N	\N	\N	\N
11290	\N	\N	\N	\N	\N	\N
11291	\N	\N	\N	\N	\N	\N
11292	\N	\N	\N	\N	\N	\N
11293	\N	\N	\N	\N	\N	\N
11294	\N	\N	\N	\N	\N	\N
11295	\N	\N	\N	\N	\N	\N
11296	\N	\N	\N	\N	\N	\N
11297	\N	\N	\N	\N	\N	\N
11298	\N	\N	\N	\N	\N	\N
11299	\N	\N	\N	\N	\N	\N
11300	\N	\N	\N	\N	\N	\N
11301	\N	\N	\N	\N	\N	\N
11302	\N	\N	\N	\N	\N	\N
11303	\N	\N	\N	\N	\N	\N
11304	\N	\N	\N	\N	\N	\N
11305	\N	\N	\N	\N	\N	\N
11306	\N	\N	\N	\N	\N	\N
11307	\N	\N	\N	\N	\N	\N
11308	\N	\N	\N	\N	\N	\N
11309	\N	\N	\N	\N	\N	\N
11310	\N	\N	\N	\N	\N	\N
11311	\N	\N	\N	\N	\N	\N
11312	\N	\N	\N	\N	\N	\N
11313	\N	\N	\N	\N	\N	\N
11314	\N	\N	\N	\N	\N	\N
11315	\N	\N	\N	\N	\N	\N
11316	\N	\N	\N	\N	\N	\N
11317	\N	\N	\N	\N	\N	\N
11318	\N	\N	\N	\N	\N	\N
11319	\N	\N	\N	\N	\N	\N
11320	\N	\N	\N	\N	\N	\N
11321	\N	\N	\N	\N	\N	\N
11322	\N	\N	\N	\N	\N	\N
11323	\N	\N	\N	\N	\N	\N
11324	\N	\N	\N	\N	\N	\N
11325	\N	\N	\N	\N	\N	\N
11326	\N	\N	\N	\N	\N	\N
11327	\N	\N	\N	\N	\N	\N
11328	\N	\N	\N	\N	\N	\N
11329	\N	\N	\N	\N	\N	\N
11330	\N	\N	\N	\N	\N	\N
11331	\N	\N	\N	\N	\N	\N
11332	\N	\N	\N	\N	\N	\N
11333	\N	\N	\N	\N	\N	\N
11334	\N	\N	\N	\N	\N	\N
11335	\N	\N	\N	\N	\N	\N
11336	\N	\N	\N	\N	\N	\N
11337	\N	\N	\N	\N	\N	\N
11338	\N	\N	\N	\N	\N	\N
11339	\N	\N	\N	\N	\N	\N
11340	\N	\N	\N	\N	\N	\N
11341	\N	\N	\N	\N	\N	\N
11342	\N	\N	\N	\N	\N	\N
11343	\N	\N	\N	\N	\N	\N
11344	\N	\N	\N	\N	\N	\N
11345	\N	\N	\N	\N	\N	\N
11346	\N	\N	\N	\N	\N	\N
11347	\N	\N	\N	\N	\N	\N
11348	\N	\N	\N	\N	\N	\N
11349	\N	\N	\N	\N	\N	\N
11350	\N	\N	\N	\N	\N	\N
11351	\N	\N	\N	\N	\N	\N
11352	\N	\N	\N	\N	\N	\N
11353	\N	\N	\N	\N	\N	\N
11354	\N	\N	\N	\N	\N	\N
11355	\N	\N	\N	\N	\N	\N
11356	\N	\N	\N	\N	\N	\N
11357	\N	\N	\N	\N	\N	\N
11358	\N	\N	\N	\N	\N	\N
11359	\N	\N	\N	\N	\N	\N
11360	\N	\N	\N	\N	\N	\N
11361	\N	\N	\N	\N	\N	\N
11362	\N	\N	\N	\N	\N	\N
11363	\N	\N	\N	\N	\N	\N
11364	\N	\N	\N	\N	\N	\N
11365	\N	\N	\N	\N	\N	\N
11366	\N	\N	\N	\N	\N	\N
11367	\N	\N	\N	\N	\N	\N
11368	\N	\N	\N	\N	\N	\N
11369	\N	\N	\N	\N	\N	\N
11370	\N	\N	\N	\N	\N	\N
11371	\N	\N	\N	\N	\N	\N
11372	\N	\N	\N	\N	\N	\N
11373	\N	\N	\N	\N	\N	\N
11374	\N	\N	\N	\N	\N	\N
11375	\N	\N	\N	\N	\N	\N
11376	\N	\N	\N	\N	\N	\N
11377	\N	\N	\N	\N	\N	\N
11378	\N	\N	\N	\N	\N	\N
11379	\N	\N	\N	\N	\N	\N
11380	\N	\N	\N	\N	\N	\N
11381	\N	\N	\N	\N	\N	\N
11382	\N	\N	\N	\N	\N	\N
11383	\N	\N	\N	\N	\N	\N
11384	\N	\N	\N	\N	\N	\N
11385	\N	\N	\N	\N	\N	\N
11386	\N	\N	\N	\N	\N	\N
11387	\N	\N	\N	\N	\N	\N
11388	\N	\N	\N	\N	\N	\N
11389	\N	\N	\N	\N	\N	\N
11390	\N	\N	\N	\N	\N	\N
11391	\N	\N	\N	\N	\N	\N
11392	\N	\N	\N	\N	\N	\N
11393	\N	\N	\N	\N	\N	\N
11394	\N	\N	\N	\N	\N	\N
11395	\N	\N	\N	\N	\N	\N
11396	\N	\N	\N	\N	\N	\N
11397	\N	\N	\N	\N	\N	\N
11398	\N	\N	\N	\N	\N	\N
11399	\N	\N	\N	\N	\N	\N
11400	\N	\N	\N	\N	\N	\N
11401	\N	\N	\N	\N	\N	\N
11402	\N	\N	\N	\N	\N	\N
11403	\N	\N	\N	\N	\N	\N
11404	\N	\N	\N	\N	\N	\N
11405	\N	\N	\N	\N	\N	\N
11406	\N	\N	\N	\N	\N	\N
11407	\N	\N	\N	\N	\N	\N
11408	\N	\N	\N	\N	\N	\N
11409	\N	\N	\N	\N	\N	\N
11410	\N	\N	\N	\N	\N	\N
11411	\N	\N	\N	\N	\N	\N
11412	\N	\N	\N	\N	\N	\N
11413	\N	\N	\N	\N	\N	\N
11414	\N	\N	\N	\N	\N	\N
11415	\N	\N	\N	\N	\N	\N
11416	\N	\N	\N	\N	\N	\N
11417	\N	\N	\N	\N	\N	\N
11418	\N	\N	\N	\N	\N	\N
11419	\N	\N	\N	\N	\N	\N
11420	\N	\N	\N	\N	\N	\N
11421	\N	\N	\N	\N	\N	\N
11422	\N	\N	\N	\N	\N	\N
11423	\N	\N	\N	\N	\N	\N
11424	\N	\N	\N	\N	\N	\N
11425	\N	\N	\N	\N	\N	\N
11426	\N	\N	\N	\N	\N	\N
11427	\N	\N	\N	\N	\N	\N
11428	\N	\N	\N	\N	\N	\N
11429	\N	\N	\N	\N	\N	\N
11430	\N	\N	\N	\N	\N	\N
11431	\N	\N	\N	\N	\N	\N
11432	\N	\N	\N	\N	\N	\N
11433	\N	\N	\N	\N	\N	\N
11434	\N	\N	\N	\N	\N	\N
11435	\N	\N	\N	\N	\N	\N
11436	\N	\N	\N	\N	\N	\N
11437	\N	\N	\N	\N	\N	\N
11438	\N	\N	\N	\N	\N	\N
11439	\N	\N	\N	\N	\N	\N
11440	\N	\N	\N	\N	\N	\N
11441	\N	\N	\N	\N	\N	\N
11442	\N	\N	\N	\N	\N	\N
11443	\N	\N	\N	\N	\N	\N
11444	\N	\N	\N	\N	\N	\N
11445	\N	\N	\N	\N	\N	\N
11446	\N	\N	\N	\N	\N	\N
11447	\N	\N	\N	\N	\N	\N
11448	\N	\N	\N	\N	\N	\N
11449	\N	\N	\N	\N	\N	\N
11450	\N	\N	\N	\N	\N	\N
11451	\N	\N	\N	\N	\N	\N
11452	\N	\N	\N	\N	\N	\N
11453	\N	\N	\N	\N	\N	\N
11454	\N	\N	\N	\N	\N	\N
11455	\N	\N	\N	\N	\N	\N
11456	\N	\N	\N	\N	\N	\N
11457	\N	\N	\N	\N	\N	\N
11458	\N	\N	\N	\N	\N	\N
11459	\N	\N	\N	\N	\N	\N
11460	\N	\N	\N	\N	\N	\N
11461	\N	\N	\N	\N	\N	\N
11462	\N	\N	\N	\N	\N	\N
11463	\N	\N	\N	\N	\N	\N
11464	\N	\N	\N	\N	\N	\N
11465	\N	\N	\N	\N	\N	\N
11466	\N	\N	\N	\N	\N	\N
11467	\N	\N	\N	\N	\N	\N
11468	\N	\N	\N	\N	\N	\N
11469	\N	\N	\N	\N	\N	\N
11470	\N	\N	\N	\N	\N	\N
11471	\N	\N	\N	\N	\N	\N
11472	\N	\N	\N	\N	\N	\N
11473	\N	\N	\N	\N	\N	\N
11474	\N	\N	\N	\N	\N	\N
11475	\N	\N	\N	\N	\N	\N
11476	\N	\N	\N	\N	\N	\N
11477	\N	\N	\N	\N	\N	\N
11478	\N	\N	\N	\N	\N	\N
11479	\N	\N	\N	\N	\N	\N
11480	\N	\N	\N	\N	\N	\N
11481	\N	\N	\N	\N	\N	\N
11482	\N	\N	\N	\N	\N	\N
11483	\N	\N	\N	\N	\N	\N
11484	\N	\N	\N	\N	\N	\N
11485	\N	\N	\N	\N	\N	\N
11486	\N	\N	\N	\N	\N	\N
11487	\N	\N	\N	\N	\N	\N
11488	\N	\N	\N	\N	\N	\N
11489	\N	\N	\N	\N	\N	\N
11490	\N	\N	\N	\N	\N	\N
11491	\N	\N	\N	\N	\N	\N
11492	\N	\N	\N	\N	\N	\N
11493	\N	\N	\N	\N	\N	\N
11494	\N	\N	\N	\N	\N	\N
11495	\N	\N	\N	\N	\N	\N
11496	\N	\N	\N	\N	\N	\N
11497	\N	\N	\N	\N	\N	\N
11498	\N	\N	\N	\N	\N	\N
11499	\N	\N	\N	\N	\N	\N
11500	\N	\N	\N	\N	\N	\N
11501	\N	\N	\N	\N	\N	\N
11502	\N	\N	\N	\N	\N	\N
11503	\N	\N	\N	\N	\N	\N
11504	\N	\N	\N	\N	\N	\N
11505	\N	\N	\N	\N	\N	\N
11506	\N	\N	\N	\N	\N	\N
11507	\N	\N	\N	\N	\N	\N
11508	\N	\N	\N	\N	\N	\N
11509	\N	\N	\N	\N	\N	\N
11510	\N	\N	\N	\N	\N	\N
11511	\N	\N	\N	\N	\N	\N
11512	\N	\N	\N	\N	\N	\N
11513	\N	\N	\N	\N	\N	\N
11514	\N	\N	\N	\N	\N	\N
11515	\N	\N	\N	\N	\N	\N
11516	\N	\N	\N	\N	\N	\N
11517	\N	\N	\N	\N	\N	\N
11518	\N	\N	\N	\N	\N	\N
11519	\N	\N	\N	\N	\N	\N
11520	\N	\N	\N	\N	\N	\N
11521	\N	\N	\N	\N	\N	\N
11522	\N	\N	\N	\N	\N	\N
11523	\N	\N	\N	\N	\N	\N
11524	\N	\N	\N	\N	\N	\N
11525	\N	\N	\N	\N	\N	\N
11526	\N	\N	\N	\N	\N	\N
11527	\N	\N	\N	\N	\N	\N
11528	\N	\N	\N	\N	\N	\N
11529	\N	\N	\N	\N	\N	\N
11530	\N	\N	\N	\N	\N	\N
11531	\N	\N	\N	\N	\N	\N
11532	\N	\N	\N	\N	\N	\N
11533	\N	\N	\N	\N	\N	\N
11534	\N	\N	\N	\N	\N	\N
11535	\N	\N	\N	\N	\N	\N
11536	\N	\N	\N	\N	\N	\N
11537	\N	\N	\N	\N	\N	\N
11538	\N	\N	\N	\N	\N	\N
11539	\N	\N	\N	\N	\N	\N
11540	\N	\N	\N	\N	\N	\N
11541	\N	\N	\N	\N	\N	\N
11542	\N	\N	\N	\N	\N	\N
11543	\N	\N	\N	\N	\N	\N
11544	\N	\N	\N	\N	\N	\N
11545	\N	\N	\N	\N	\N	\N
11546	\N	\N	\N	\N	\N	\N
11547	\N	\N	\N	\N	\N	\N
11548	\N	\N	\N	\N	\N	\N
11549	\N	\N	\N	\N	\N	\N
11550	\N	\N	\N	\N	\N	\N
11551	\N	\N	\N	\N	\N	\N
11552	\N	\N	\N	\N	\N	\N
11553	\N	\N	\N	\N	\N	\N
11554	\N	\N	\N	\N	\N	\N
11555	\N	\N	\N	\N	\N	\N
11556	\N	\N	\N	\N	\N	\N
11557	\N	\N	\N	\N	\N	\N
11558	\N	\N	\N	\N	\N	\N
11559	\N	\N	\N	\N	\N	\N
11560	\N	\N	\N	\N	\N	\N
11561	\N	\N	\N	\N	\N	\N
11562	\N	\N	\N	\N	\N	\N
11563	\N	\N	\N	\N	\N	\N
11564	\N	\N	\N	\N	\N	\N
11565	\N	\N	\N	\N	\N	\N
11566	\N	\N	\N	\N	\N	\N
11567	\N	\N	\N	\N	\N	\N
11568	\N	\N	\N	\N	\N	\N
11569	\N	\N	\N	\N	\N	\N
11570	\N	\N	\N	\N	\N	\N
11571	\N	\N	\N	\N	\N	\N
11572	\N	\N	\N	\N	\N	\N
11573	\N	\N	\N	\N	\N	\N
11574	\N	\N	\N	\N	\N	\N
11575	\N	\N	\N	\N	\N	\N
11576	\N	\N	\N	\N	\N	\N
11577	\N	\N	\N	\N	\N	\N
11578	\N	\N	\N	\N	\N	\N
11579	\N	\N	\N	\N	\N	\N
11580	\N	\N	\N	\N	\N	\N
11581	\N	\N	\N	\N	\N	\N
11582	\N	\N	\N	\N	\N	\N
11583	\N	\N	\N	\N	\N	\N
11584	\N	\N	\N	\N	\N	\N
11585	\N	\N	\N	\N	\N	\N
11586	\N	\N	\N	\N	\N	\N
11587	\N	\N	\N	\N	\N	\N
11588	\N	\N	\N	\N	\N	\N
11589	\N	\N	\N	\N	\N	\N
11590	\N	\N	\N	\N	\N	\N
11591	\N	\N	\N	\N	\N	\N
11592	\N	\N	\N	\N	\N	\N
11593	\N	\N	\N	\N	\N	\N
11594	\N	\N	\N	\N	\N	\N
11595	\N	\N	\N	\N	\N	\N
11596	\N	\N	\N	\N	\N	\N
11597	\N	\N	\N	\N	\N	\N
11598	\N	\N	\N	\N	\N	\N
11599	\N	\N	\N	\N	\N	\N
11600	\N	\N	\N	\N	\N	\N
11601	\N	\N	\N	\N	\N	\N
11602	\N	\N	\N	\N	\N	\N
11603	\N	\N	\N	\N	\N	\N
11604	\N	\N	\N	\N	\N	\N
11605	\N	\N	\N	\N	\N	\N
11606	\N	\N	\N	\N	\N	\N
11607	\N	\N	\N	\N	\N	\N
11608	\N	\N	\N	\N	\N	\N
11609	\N	\N	\N	\N	\N	\N
11610	\N	\N	\N	\N	\N	\N
11611	\N	\N	\N	\N	\N	\N
11612	\N	\N	\N	\N	\N	\N
11613	\N	\N	\N	\N	\N	\N
11614	\N	\N	\N	\N	\N	\N
11615	\N	\N	\N	\N	\N	\N
11616	\N	\N	\N	\N	\N	\N
11617	\N	\N	\N	\N	\N	\N
11618	\N	\N	\N	\N	\N	\N
11619	\N	\N	\N	\N	\N	\N
11620	\N	\N	\N	\N	\N	\N
11621	\N	\N	\N	\N	\N	\N
11622	\N	\N	\N	\N	\N	\N
11623	\N	\N	\N	\N	\N	\N
11624	\N	\N	\N	\N	\N	\N
11625	\N	\N	\N	\N	\N	\N
11626	\N	\N	\N	\N	\N	\N
11627	\N	\N	\N	\N	\N	\N
11628	\N	\N	\N	\N	\N	\N
11629	\N	\N	\N	\N	\N	\N
11630	\N	\N	\N	\N	\N	\N
11631	\N	\N	\N	\N	\N	\N
11632	\N	\N	\N	\N	\N	\N
11633	\N	\N	\N	\N	\N	\N
11634	\N	\N	\N	\N	\N	\N
11635	\N	\N	\N	\N	\N	\N
11636	\N	\N	\N	\N	\N	\N
11637	\N	\N	\N	\N	\N	\N
11638	\N	\N	\N	\N	\N	\N
11639	\N	\N	\N	\N	\N	\N
11640	\N	\N	\N	\N	\N	\N
11641	\N	\N	\N	\N	\N	\N
11642	\N	\N	\N	\N	\N	\N
11643	\N	\N	\N	\N	\N	\N
11644	\N	\N	\N	\N	\N	\N
11645	\N	\N	\N	\N	\N	\N
11646	\N	\N	\N	\N	\N	\N
11647	\N	\N	\N	\N	\N	\N
11648	\N	\N	\N	\N	\N	\N
11649	\N	\N	\N	\N	\N	\N
11650	\N	\N	\N	\N	\N	\N
11651	\N	\N	\N	\N	\N	\N
11652	\N	\N	\N	\N	\N	\N
11653	\N	\N	\N	\N	\N	\N
11654	\N	\N	\N	\N	\N	\N
11655	\N	\N	\N	\N	\N	\N
11656	\N	\N	\N	\N	\N	\N
11657	\N	\N	\N	\N	\N	\N
11658	\N	\N	\N	\N	\N	\N
11659	\N	\N	\N	\N	\N	\N
11660	\N	\N	\N	\N	\N	\N
11661	\N	\N	\N	\N	\N	\N
11662	\N	\N	\N	\N	\N	\N
11663	\N	\N	\N	\N	\N	\N
11664	\N	\N	\N	\N	\N	\N
11665	\N	\N	\N	\N	\N	\N
11666	\N	\N	\N	\N	\N	\N
11667	\N	\N	\N	\N	\N	\N
11668	\N	\N	\N	\N	\N	\N
11669	\N	\N	\N	\N	\N	\N
11670	\N	\N	\N	\N	\N	\N
11671	\N	\N	\N	\N	\N	\N
11672	\N	\N	\N	\N	\N	\N
11673	\N	\N	\N	\N	\N	\N
11674	\N	\N	\N	\N	\N	\N
11675	\N	\N	\N	\N	\N	\N
11676	\N	\N	\N	\N	\N	\N
11677	\N	\N	\N	\N	\N	\N
11678	\N	\N	\N	\N	\N	\N
11679	\N	\N	\N	\N	\N	\N
11680	\N	\N	\N	\N	\N	\N
11681	\N	\N	\N	\N	\N	\N
11682	\N	\N	\N	\N	\N	\N
11683	\N	\N	\N	\N	\N	\N
11684	\N	\N	\N	\N	\N	\N
11685	\N	\N	\N	\N	\N	\N
11686	\N	\N	\N	\N	\N	\N
11687	\N	\N	\N	\N	\N	\N
11688	\N	\N	\N	\N	\N	\N
11689	\N	\N	\N	\N	\N	\N
11690	\N	\N	\N	\N	\N	\N
11691	\N	\N	\N	\N	\N	\N
11692	\N	\N	\N	\N	\N	\N
11693	\N	\N	\N	\N	\N	\N
11694	\N	\N	\N	\N	\N	\N
11695	\N	\N	\N	\N	\N	\N
11696	\N	\N	\N	\N	\N	\N
11697	\N	\N	\N	\N	\N	\N
11698	\N	\N	\N	\N	\N	\N
11699	\N	\N	\N	\N	\N	\N
11700	\N	\N	\N	\N	\N	\N
11701	\N	\N	\N	\N	\N	\N
11702	\N	\N	\N	\N	\N	\N
11703	\N	\N	\N	\N	\N	\N
11704	\N	\N	\N	\N	\N	\N
11705	\N	\N	\N	\N	\N	\N
11706	\N	\N	\N	\N	\N	\N
11707	\N	\N	\N	\N	\N	\N
11708	\N	\N	\N	\N	\N	\N
11709	\N	\N	\N	\N	\N	\N
11710	\N	\N	\N	\N	\N	\N
11711	\N	\N	\N	\N	\N	\N
11712	\N	\N	\N	\N	\N	\N
11713	\N	\N	\N	\N	\N	\N
11714	\N	\N	\N	\N	\N	\N
11715	\N	\N	\N	\N	\N	\N
11716	\N	\N	\N	\N	\N	\N
11717	\N	\N	\N	\N	\N	\N
11718	\N	\N	\N	\N	\N	\N
11719	\N	\N	\N	\N	\N	\N
11720	\N	\N	\N	\N	\N	\N
11721	\N	\N	\N	\N	\N	\N
11722	\N	\N	\N	\N	\N	\N
11723	\N	\N	\N	\N	\N	\N
11724	\N	\N	\N	\N	\N	\N
11725	\N	\N	\N	\N	\N	\N
11726	\N	\N	\N	\N	\N	\N
11727	\N	\N	\N	\N	\N	\N
11728	\N	\N	\N	\N	\N	\N
11729	\N	\N	\N	\N	\N	\N
11730	\N	\N	\N	\N	\N	\N
11731	\N	\N	\N	\N	\N	\N
11732	\N	\N	\N	\N	\N	\N
11733	\N	\N	\N	\N	\N	\N
11734	\N	\N	\N	\N	\N	\N
11735	\N	\N	\N	\N	\N	\N
11736	\N	\N	\N	\N	\N	\N
11737	\N	\N	\N	\N	\N	\N
11738	\N	\N	\N	\N	\N	\N
11739	\N	\N	\N	\N	\N	\N
11740	\N	\N	\N	\N	\N	\N
11741	\N	\N	\N	\N	\N	\N
11742	\N	\N	\N	\N	\N	\N
11743	\N	\N	\N	\N	\N	\N
11744	\N	\N	\N	\N	\N	\N
11745	\N	\N	\N	\N	\N	\N
11746	\N	\N	\N	\N	\N	\N
11747	\N	\N	\N	\N	\N	\N
11748	\N	\N	\N	\N	\N	\N
11749	\N	\N	\N	\N	\N	\N
11750	\N	\N	\N	\N	\N	\N
11751	\N	\N	\N	\N	\N	\N
11752	\N	\N	\N	\N	\N	\N
11753	\N	\N	\N	\N	\N	\N
11754	\N	\N	\N	\N	\N	\N
11755	\N	\N	\N	\N	\N	\N
11756	\N	\N	\N	\N	\N	\N
11757	\N	\N	\N	\N	\N	\N
11758	\N	\N	\N	\N	\N	\N
11759	\N	\N	\N	\N	\N	\N
11760	\N	\N	\N	\N	\N	\N
11761	\N	\N	\N	\N	\N	\N
11762	\N	\N	\N	\N	\N	\N
11763	\N	\N	\N	\N	\N	\N
11764	\N	\N	\N	\N	\N	\N
11765	\N	\N	\N	\N	\N	\N
11766	\N	\N	\N	\N	\N	\N
11767	\N	\N	\N	\N	\N	\N
11768	\N	\N	\N	\N	\N	\N
11769	\N	\N	\N	\N	\N	\N
11770	\N	\N	\N	\N	\N	\N
11771	\N	\N	\N	\N	\N	\N
11772	\N	\N	\N	\N	\N	\N
11773	\N	\N	\N	\N	\N	\N
11774	\N	\N	\N	\N	\N	\N
11775	\N	\N	\N	\N	\N	\N
11776	\N	\N	\N	\N	\N	\N
11777	\N	\N	\N	\N	\N	\N
11778	\N	\N	\N	\N	\N	\N
11779	\N	\N	\N	\N	\N	\N
11780	\N	\N	\N	\N	\N	\N
11781	\N	\N	\N	\N	\N	\N
11782	\N	\N	\N	\N	\N	\N
11783	\N	\N	\N	\N	\N	\N
11784	\N	\N	\N	\N	\N	\N
11785	\N	\N	\N	\N	\N	\N
11786	\N	\N	\N	\N	\N	\N
11787	\N	\N	\N	\N	\N	\N
11788	\N	\N	\N	\N	\N	\N
11789	\N	\N	\N	\N	\N	\N
11790	\N	\N	\N	\N	\N	\N
11791	\N	\N	\N	\N	\N	\N
11792	\N	\N	\N	\N	\N	\N
11793	\N	\N	\N	\N	\N	\N
11794	\N	\N	\N	\N	\N	\N
11795	\N	\N	\N	\N	\N	\N
11796	\N	\N	\N	\N	\N	\N
11797	\N	\N	\N	\N	\N	\N
11798	\N	\N	\N	\N	\N	\N
11799	\N	\N	\N	\N	\N	\N
11800	\N	\N	\N	\N	\N	\N
11801	\N	\N	\N	\N	\N	\N
11802	\N	\N	\N	\N	\N	\N
11803	\N	\N	\N	\N	\N	\N
11804	\N	\N	\N	\N	\N	\N
11805	\N	\N	\N	\N	\N	\N
11806	\N	\N	\N	\N	\N	\N
11807	\N	\N	\N	\N	\N	\N
11808	\N	\N	\N	\N	\N	\N
11809	\N	\N	\N	\N	\N	\N
11810	\N	\N	\N	\N	\N	\N
11811	\N	\N	\N	\N	\N	\N
11812	\N	\N	\N	\N	\N	\N
11813	\N	\N	\N	\N	\N	\N
11814	\N	\N	\N	\N	\N	\N
11815	\N	\N	\N	\N	\N	\N
11816	\N	\N	\N	\N	\N	\N
11817	\N	\N	\N	\N	\N	\N
11818	\N	\N	\N	\N	\N	\N
11819	\N	\N	\N	\N	\N	\N
11820	\N	\N	\N	\N	\N	\N
11821	\N	\N	\N	\N	\N	\N
11822	\N	\N	\N	\N	\N	\N
11823	\N	\N	\N	\N	\N	\N
11824	\N	\N	\N	\N	\N	\N
11825	\N	\N	\N	\N	\N	\N
11826	\N	\N	\N	\N	\N	\N
11827	\N	\N	\N	\N	\N	\N
11828	\N	\N	\N	\N	\N	\N
11829	\N	\N	\N	\N	\N	\N
11830	\N	\N	\N	\N	\N	\N
11831	\N	\N	\N	\N	\N	\N
11832	\N	\N	\N	\N	\N	\N
11833	\N	\N	\N	\N	\N	\N
11834	\N	\N	\N	\N	\N	\N
11835	\N	\N	\N	\N	\N	\N
11836	\N	\N	\N	\N	\N	\N
11837	\N	\N	\N	\N	\N	\N
11838	\N	\N	\N	\N	\N	\N
11839	\N	\N	\N	\N	\N	\N
11840	\N	\N	\N	\N	\N	\N
11841	\N	\N	\N	\N	\N	\N
11842	\N	\N	\N	\N	\N	\N
11843	\N	\N	\N	\N	\N	\N
11844	\N	\N	\N	\N	\N	\N
11845	\N	\N	\N	\N	\N	\N
11846	\N	\N	\N	\N	\N	\N
11847	\N	\N	\N	\N	\N	\N
11848	\N	\N	\N	\N	\N	\N
11849	\N	\N	\N	\N	\N	\N
11850	\N	\N	\N	\N	\N	\N
11851	\N	\N	\N	\N	\N	\N
11852	\N	\N	\N	\N	\N	\N
11853	\N	\N	\N	\N	\N	\N
11854	\N	\N	\N	\N	\N	\N
11855	\N	\N	\N	\N	\N	\N
11856	\N	\N	\N	\N	\N	\N
11857	\N	\N	\N	\N	\N	\N
11858	\N	\N	\N	\N	\N	\N
11859	\N	\N	\N	\N	\N	\N
11860	\N	\N	\N	\N	\N	\N
11861	\N	\N	\N	\N	\N	\N
11862	\N	\N	\N	\N	\N	\N
11863	\N	\N	\N	\N	\N	\N
11864	\N	\N	\N	\N	\N	\N
11865	\N	\N	\N	\N	\N	\N
11866	\N	\N	\N	\N	\N	\N
11867	\N	\N	\N	\N	\N	\N
11868	\N	\N	\N	\N	\N	\N
11869	\N	\N	\N	\N	\N	\N
11870	\N	\N	\N	\N	\N	\N
11871	\N	\N	\N	\N	\N	\N
11872	\N	\N	\N	\N	\N	\N
11873	\N	\N	\N	\N	\N	\N
11874	\N	\N	\N	\N	\N	\N
11875	\N	\N	\N	\N	\N	\N
11876	\N	\N	\N	\N	\N	\N
11877	\N	\N	\N	\N	\N	\N
11878	\N	\N	\N	\N	\N	\N
11879	\N	\N	\N	\N	\N	\N
11880	\N	\N	\N	\N	\N	\N
11881	\N	\N	\N	\N	\N	\N
11882	\N	\N	\N	\N	\N	\N
11883	\N	\N	\N	\N	\N	\N
11884	\N	\N	\N	\N	\N	\N
11885	\N	\N	\N	\N	\N	\N
11886	\N	\N	\N	\N	\N	\N
11887	\N	\N	\N	\N	\N	\N
11888	\N	\N	\N	\N	\N	\N
11889	\N	\N	\N	\N	\N	\N
11890	\N	\N	\N	\N	\N	\N
11891	\N	\N	\N	\N	\N	\N
11892	\N	\N	\N	\N	\N	\N
11893	\N	\N	\N	\N	\N	\N
11894	\N	\N	\N	\N	\N	\N
11895	\N	\N	\N	\N	\N	\N
11896	\N	\N	\N	\N	\N	\N
11897	\N	\N	\N	\N	\N	\N
11898	\N	\N	\N	\N	\N	\N
11899	\N	\N	\N	\N	\N	\N
11900	\N	\N	\N	\N	\N	\N
11901	\N	\N	\N	\N	\N	\N
11902	\N	\N	\N	\N	\N	\N
11903	\N	\N	\N	\N	\N	\N
11904	\N	\N	\N	\N	\N	\N
11905	\N	\N	\N	\N	\N	\N
11906	\N	\N	\N	\N	\N	\N
11907	\N	\N	\N	\N	\N	\N
11908	\N	\N	\N	\N	\N	\N
11909	\N	\N	\N	\N	\N	\N
11910	\N	\N	\N	\N	\N	\N
11911	\N	\N	\N	\N	\N	\N
11912	\N	\N	\N	\N	\N	\N
11913	\N	\N	\N	\N	\N	\N
11914	\N	\N	\N	\N	\N	\N
11915	\N	\N	\N	\N	\N	\N
11916	\N	\N	\N	\N	\N	\N
11917	\N	\N	\N	\N	\N	\N
11918	\N	\N	\N	\N	\N	\N
11919	\N	\N	\N	\N	\N	\N
11920	\N	\N	\N	\N	\N	\N
11921	\N	\N	\N	\N	\N	\N
11922	\N	\N	\N	\N	\N	\N
11923	\N	\N	\N	\N	\N	\N
11924	\N	\N	\N	\N	\N	\N
11925	\N	\N	\N	\N	\N	\N
11926	\N	\N	\N	\N	\N	\N
11927	\N	\N	\N	\N	\N	\N
11928	\N	\N	\N	\N	\N	\N
11929	\N	\N	\N	\N	\N	\N
11930	\N	\N	\N	\N	\N	\N
11931	\N	\N	\N	\N	\N	\N
11932	\N	\N	\N	\N	\N	\N
11933	\N	\N	\N	\N	\N	\N
11934	\N	\N	\N	\N	\N	\N
11935	\N	\N	\N	\N	\N	\N
11936	\N	\N	\N	\N	\N	\N
11937	\N	\N	\N	\N	\N	\N
11938	\N	\N	\N	\N	\N	\N
11939	\N	\N	\N	\N	\N	\N
11940	\N	\N	\N	\N	\N	\N
11941	\N	\N	\N	\N	\N	\N
11942	\N	\N	\N	\N	\N	\N
11943	\N	\N	\N	\N	\N	\N
11944	\N	\N	\N	\N	\N	\N
11945	\N	\N	\N	\N	\N	\N
11946	\N	\N	\N	\N	\N	\N
11947	\N	\N	\N	\N	\N	\N
11948	\N	\N	\N	\N	\N	\N
11949	\N	\N	\N	\N	\N	\N
11950	\N	\N	\N	\N	\N	\N
11951	\N	\N	\N	\N	\N	\N
11952	\N	\N	\N	\N	\N	\N
11953	\N	\N	\N	\N	\N	\N
11954	\N	\N	\N	\N	\N	\N
11955	\N	\N	\N	\N	\N	\N
11956	\N	\N	\N	\N	\N	\N
11957	\N	\N	\N	\N	\N	\N
11958	\N	\N	\N	\N	\N	\N
11959	\N	\N	\N	\N	\N	\N
11960	\N	\N	\N	\N	\N	\N
11961	\N	\N	\N	\N	\N	\N
11962	\N	\N	\N	\N	\N	\N
11963	\N	\N	\N	\N	\N	\N
11964	\N	\N	\N	\N	\N	\N
11965	\N	\N	\N	\N	\N	\N
11966	\N	\N	\N	\N	\N	\N
11967	\N	\N	\N	\N	\N	\N
11968	\N	\N	\N	\N	\N	\N
11969	\N	\N	\N	\N	\N	\N
11970	\N	\N	\N	\N	\N	\N
11971	\N	\N	\N	\N	\N	\N
11972	\N	\N	\N	\N	\N	\N
11973	\N	\N	\N	\N	\N	\N
11974	\N	\N	\N	\N	\N	\N
11975	\N	\N	\N	\N	\N	\N
11976	\N	\N	\N	\N	\N	\N
11977	\N	\N	\N	\N	\N	\N
11978	\N	\N	\N	\N	\N	\N
11979	\N	\N	\N	\N	\N	\N
11980	\N	\N	\N	\N	\N	\N
11981	\N	\N	\N	\N	\N	\N
11982	\N	\N	\N	\N	\N	\N
11983	\N	\N	\N	\N	\N	\N
11984	\N	\N	\N	\N	\N	\N
11985	\N	\N	\N	\N	\N	\N
11986	\N	\N	\N	\N	\N	\N
11987	\N	\N	\N	\N	\N	\N
11988	\N	\N	\N	\N	\N	\N
11989	\N	\N	\N	\N	\N	\N
11990	\N	\N	\N	\N	\N	\N
11991	\N	\N	\N	\N	\N	\N
11992	\N	\N	\N	\N	\N	\N
11993	\N	\N	\N	\N	\N	\N
11994	\N	\N	\N	\N	\N	\N
11995	\N	\N	\N	\N	\N	\N
11996	\N	\N	\N	\N	\N	\N
11997	\N	\N	\N	\N	\N	\N
11998	\N	\N	\N	\N	\N	\N
11999	\N	\N	\N	\N	\N	\N
12000	\N	\N	\N	\N	\N	\N
12001	\N	\N	\N	\N	\N	\N
12002	\N	\N	\N	\N	\N	\N
12003	\N	\N	\N	\N	\N	\N
12004	\N	\N	\N	\N	\N	\N
12005	\N	\N	\N	\N	\N	\N
12006	\N	\N	\N	\N	\N	\N
12007	\N	\N	\N	\N	\N	\N
12008	\N	\N	\N	\N	\N	\N
12009	\N	\N	\N	\N	\N	\N
12010	\N	\N	\N	\N	\N	\N
12011	\N	\N	\N	\N	\N	\N
12012	\N	\N	\N	\N	\N	\N
12013	\N	\N	\N	\N	\N	\N
12014	\N	\N	\N	\N	\N	\N
12015	\N	\N	\N	\N	\N	\N
12016	\N	\N	\N	\N	\N	\N
12017	\N	\N	\N	\N	\N	\N
12018	\N	\N	\N	\N	\N	\N
12019	\N	\N	\N	\N	\N	\N
12020	\N	\N	\N	\N	\N	\N
12021	\N	\N	\N	\N	\N	\N
12022	\N	\N	\N	\N	\N	\N
12023	\N	\N	\N	\N	\N	\N
12024	\N	\N	\N	\N	\N	\N
12025	\N	\N	\N	\N	\N	\N
12026	\N	\N	\N	\N	\N	\N
12027	\N	\N	\N	\N	\N	\N
12028	\N	\N	\N	\N	\N	\N
12029	\N	\N	\N	\N	\N	\N
12030	\N	\N	\N	\N	\N	\N
12031	\N	\N	\N	\N	\N	\N
12032	\N	\N	\N	\N	\N	\N
12033	\N	\N	\N	\N	\N	\N
12034	\N	\N	\N	\N	\N	\N
12035	\N	\N	\N	\N	\N	\N
12036	\N	\N	\N	\N	\N	\N
12037	\N	\N	\N	\N	\N	\N
12038	\N	\N	\N	\N	\N	\N
12039	\N	\N	\N	\N	\N	\N
12040	\N	\N	\N	\N	\N	\N
12041	\N	\N	\N	\N	\N	\N
12042	\N	\N	\N	\N	\N	\N
12043	\N	\N	\N	\N	\N	\N
12044	\N	\N	\N	\N	\N	\N
12045	\N	\N	\N	\N	\N	\N
12046	\N	\N	\N	\N	\N	\N
12047	\N	\N	\N	\N	\N	\N
12048	\N	\N	\N	\N	\N	\N
12049	\N	\N	\N	\N	\N	\N
12050	\N	\N	\N	\N	\N	\N
12051	\N	\N	\N	\N	\N	\N
12052	\N	\N	\N	\N	\N	\N
12053	\N	\N	\N	\N	\N	\N
12054	\N	\N	\N	\N	\N	\N
12055	\N	\N	\N	\N	\N	\N
12056	\N	\N	\N	\N	\N	\N
12057	\N	\N	\N	\N	\N	\N
12058	\N	\N	\N	\N	\N	\N
12059	\N	\N	\N	\N	\N	\N
12060	\N	\N	\N	\N	\N	\N
12061	\N	\N	\N	\N	\N	\N
12062	\N	\N	\N	\N	\N	\N
12063	\N	\N	\N	\N	\N	\N
12064	\N	\N	\N	\N	\N	\N
12065	\N	\N	\N	\N	\N	\N
12066	\N	\N	\N	\N	\N	\N
12067	\N	\N	\N	\N	\N	\N
12068	\N	\N	\N	\N	\N	\N
12069	\N	\N	\N	\N	\N	\N
12070	\N	\N	\N	\N	\N	\N
12071	\N	\N	\N	\N	\N	\N
12072	\N	\N	\N	\N	\N	\N
12073	\N	\N	\N	\N	\N	\N
12074	\N	\N	\N	\N	\N	\N
12075	\N	\N	\N	\N	\N	\N
12076	\N	\N	\N	\N	\N	\N
12077	\N	\N	\N	\N	\N	\N
12078	\N	\N	\N	\N	\N	\N
12079	\N	\N	\N	\N	\N	\N
12080	\N	\N	\N	\N	\N	\N
12081	\N	\N	\N	\N	\N	\N
12082	\N	\N	\N	\N	\N	\N
12083	\N	\N	\N	\N	\N	\N
12084	\N	\N	\N	\N	\N	\N
12085	\N	\N	\N	\N	\N	\N
12086	\N	\N	\N	\N	\N	\N
12087	\N	\N	\N	\N	\N	\N
12088	\N	\N	\N	\N	\N	\N
12089	\N	\N	\N	\N	\N	\N
12090	\N	\N	\N	\N	\N	\N
12091	\N	\N	\N	\N	\N	\N
12092	\N	\N	\N	\N	\N	\N
12093	\N	\N	\N	\N	\N	\N
12094	\N	\N	\N	\N	\N	\N
12095	\N	\N	\N	\N	\N	\N
12096	\N	\N	\N	\N	\N	\N
12097	\N	\N	\N	\N	\N	\N
12098	\N	\N	\N	\N	\N	\N
12099	\N	\N	\N	\N	\N	\N
12100	\N	\N	\N	\N	\N	\N
12101	\N	\N	\N	\N	\N	\N
12102	\N	\N	\N	\N	\N	\N
12103	\N	\N	\N	\N	\N	\N
12104	\N	\N	\N	\N	\N	\N
12105	\N	\N	\N	\N	\N	\N
12106	\N	\N	\N	\N	\N	\N
12107	\N	\N	\N	\N	\N	\N
12108	\N	\N	\N	\N	\N	\N
12109	\N	\N	\N	\N	\N	\N
12110	\N	\N	\N	\N	\N	\N
12111	\N	\N	\N	\N	\N	\N
12112	\N	\N	\N	\N	\N	\N
12113	\N	\N	\N	\N	\N	\N
12114	\N	\N	\N	\N	\N	\N
12115	\N	\N	\N	\N	\N	\N
12116	\N	\N	\N	\N	\N	\N
12117	\N	\N	\N	\N	\N	\N
12118	\N	\N	\N	\N	\N	\N
12119	\N	\N	\N	\N	\N	\N
12120	\N	\N	\N	\N	\N	\N
12121	\N	\N	\N	\N	\N	\N
12122	\N	\N	\N	\N	\N	\N
12123	\N	\N	\N	\N	\N	\N
12124	\N	\N	\N	\N	\N	\N
12125	\N	\N	\N	\N	\N	\N
12126	\N	\N	\N	\N	\N	\N
12127	\N	\N	\N	\N	\N	\N
12128	\N	\N	\N	\N	\N	\N
12129	\N	\N	\N	\N	\N	\N
12130	\N	\N	\N	\N	\N	\N
12131	\N	\N	\N	\N	\N	\N
12132	\N	\N	\N	\N	\N	\N
12133	\N	\N	\N	\N	\N	\N
12134	\N	\N	\N	\N	\N	\N
12135	\N	\N	\N	\N	\N	\N
12136	\N	\N	\N	\N	\N	\N
12137	\N	\N	\N	\N	\N	\N
12138	\N	\N	\N	\N	\N	\N
12139	\N	\N	\N	\N	\N	\N
12140	\N	\N	\N	\N	\N	\N
12141	\N	\N	\N	\N	\N	\N
12142	\N	\N	\N	\N	\N	\N
12143	\N	\N	\N	\N	\N	\N
12144	\N	\N	\N	\N	\N	\N
12145	\N	\N	\N	\N	\N	\N
12146	\N	\N	\N	\N	\N	\N
12147	\N	\N	\N	\N	\N	\N
12148	\N	\N	\N	\N	\N	\N
12149	\N	\N	\N	\N	\N	\N
12150	\N	\N	\N	\N	\N	\N
12151	\N	\N	\N	\N	\N	\N
12152	\N	\N	\N	\N	\N	\N
12153	\N	\N	\N	\N	\N	\N
12154	\N	\N	\N	\N	\N	\N
12155	\N	\N	\N	\N	\N	\N
12156	\N	\N	\N	\N	\N	\N
12157	\N	\N	\N	\N	\N	\N
12158	\N	\N	\N	\N	\N	\N
12159	\N	\N	\N	\N	\N	\N
12160	\N	\N	\N	\N	\N	\N
12161	\N	\N	\N	\N	\N	\N
12162	\N	\N	\N	\N	\N	\N
12163	\N	\N	\N	\N	\N	\N
12164	\N	\N	\N	\N	\N	\N
12165	\N	\N	\N	\N	\N	\N
12166	\N	\N	\N	\N	\N	\N
12167	\N	\N	\N	\N	\N	\N
12168	\N	\N	\N	\N	\N	\N
12169	\N	\N	\N	\N	\N	\N
12170	\N	\N	\N	\N	\N	\N
12171	\N	\N	\N	\N	\N	\N
12172	\N	\N	\N	\N	\N	\N
12173	\N	\N	\N	\N	\N	\N
12174	\N	\N	\N	\N	\N	\N
12175	\N	\N	\N	\N	\N	\N
12176	\N	\N	\N	\N	\N	\N
12177	\N	\N	\N	\N	\N	\N
12178	\N	\N	\N	\N	\N	\N
12179	\N	\N	\N	\N	\N	\N
12180	\N	\N	\N	\N	\N	\N
12181	\N	\N	\N	\N	\N	\N
12182	\N	\N	\N	\N	\N	\N
12183	\N	\N	\N	\N	\N	\N
12184	\N	\N	\N	\N	\N	\N
12185	\N	\N	\N	\N	\N	\N
12186	\N	\N	\N	\N	\N	\N
12187	\N	\N	\N	\N	\N	\N
12188	\N	\N	\N	\N	\N	\N
12189	\N	\N	\N	\N	\N	\N
12190	\N	\N	\N	\N	\N	\N
12191	\N	\N	\N	\N	\N	\N
12192	\N	\N	\N	\N	\N	\N
12193	\N	\N	\N	\N	\N	\N
12194	\N	\N	\N	\N	\N	\N
12195	\N	\N	\N	\N	\N	\N
12196	\N	\N	\N	\N	\N	\N
12197	\N	\N	\N	\N	\N	\N
12198	\N	\N	\N	\N	\N	\N
12199	\N	\N	\N	\N	\N	\N
12200	\N	\N	\N	\N	\N	\N
12201	\N	\N	\N	\N	\N	\N
12202	\N	\N	\N	\N	\N	\N
12203	\N	\N	\N	\N	\N	\N
12204	\N	\N	\N	\N	\N	\N
12205	\N	\N	\N	\N	\N	\N
12206	\N	\N	\N	\N	\N	\N
12207	\N	\N	\N	\N	\N	\N
12208	\N	\N	\N	\N	\N	\N
12209	\N	\N	\N	\N	\N	\N
12210	\N	\N	\N	\N	\N	\N
12211	\N	\N	\N	\N	\N	\N
12212	\N	\N	\N	\N	\N	\N
12213	\N	\N	\N	\N	\N	\N
12214	\N	\N	\N	\N	\N	\N
12215	\N	\N	\N	\N	\N	\N
12216	\N	\N	\N	\N	\N	\N
12217	\N	\N	\N	\N	\N	\N
12218	\N	\N	\N	\N	\N	\N
12219	\N	\N	\N	\N	\N	\N
12220	\N	\N	\N	\N	\N	\N
12221	\N	\N	\N	\N	\N	\N
12222	\N	\N	\N	\N	\N	\N
12223	\N	\N	\N	\N	\N	\N
12224	\N	\N	\N	\N	\N	\N
12225	\N	\N	\N	\N	\N	\N
12226	\N	\N	\N	\N	\N	\N
12227	\N	\N	\N	\N	\N	\N
12228	\N	\N	\N	\N	\N	\N
12229	\N	\N	\N	\N	\N	\N
12230	\N	\N	\N	\N	\N	\N
12231	\N	\N	\N	\N	\N	\N
12232	\N	\N	\N	\N	\N	\N
12233	\N	\N	\N	\N	\N	\N
12234	\N	\N	\N	\N	\N	\N
12235	\N	\N	\N	\N	\N	\N
12236	\N	\N	\N	\N	\N	\N
12237	\N	\N	\N	\N	\N	\N
12238	\N	\N	\N	\N	\N	\N
12239	\N	\N	\N	\N	\N	\N
12240	\N	\N	\N	\N	\N	\N
12241	\N	\N	\N	\N	\N	\N
12242	\N	\N	\N	\N	\N	\N
12243	\N	\N	\N	\N	\N	\N
12244	\N	\N	\N	\N	\N	\N
12245	\N	\N	\N	\N	\N	\N
12246	\N	\N	\N	\N	\N	\N
12247	\N	\N	\N	\N	\N	\N
12248	\N	\N	\N	\N	\N	\N
12249	\N	\N	\N	\N	\N	\N
12250	\N	\N	\N	\N	\N	\N
12251	\N	\N	\N	\N	\N	\N
12252	\N	\N	\N	\N	\N	\N
12253	\N	\N	\N	\N	\N	\N
12254	\N	\N	\N	\N	\N	\N
12255	\N	\N	\N	\N	\N	\N
12256	\N	\N	\N	\N	\N	\N
12257	\N	\N	\N	\N	\N	\N
12258	\N	\N	\N	\N	\N	\N
12259	\N	\N	\N	\N	\N	\N
12260	\N	\N	\N	\N	\N	\N
12261	\N	\N	\N	\N	\N	\N
12262	\N	\N	\N	\N	\N	\N
12263	\N	\N	\N	\N	\N	\N
12264	\N	\N	\N	\N	\N	\N
12265	\N	\N	\N	\N	\N	\N
12266	\N	\N	\N	\N	\N	\N
12267	\N	\N	\N	\N	\N	\N
12268	\N	\N	\N	\N	\N	\N
12269	\N	\N	\N	\N	\N	\N
12270	\N	\N	\N	\N	\N	\N
12271	\N	\N	\N	\N	\N	\N
12272	\N	\N	\N	\N	\N	\N
12273	\N	\N	\N	\N	\N	\N
12274	\N	\N	\N	\N	\N	\N
12275	\N	\N	\N	\N	\N	\N
12276	\N	\N	\N	\N	\N	\N
12277	\N	\N	\N	\N	\N	\N
12278	\N	\N	\N	\N	\N	\N
12279	\N	\N	\N	\N	\N	\N
12280	\N	\N	\N	\N	\N	\N
12281	\N	\N	\N	\N	\N	\N
12282	\N	\N	\N	\N	\N	\N
12283	\N	\N	\N	\N	\N	\N
12284	\N	\N	\N	\N	\N	\N
12285	\N	\N	\N	\N	\N	\N
12286	\N	\N	\N	\N	\N	\N
12287	\N	\N	\N	\N	\N	\N
12288	\N	\N	\N	\N	\N	\N
12289	\N	\N	\N	\N	\N	\N
12290	\N	\N	\N	\N	\N	\N
12291	\N	\N	\N	\N	\N	\N
12292	\N	\N	\N	\N	\N	\N
12293	\N	\N	\N	\N	\N	\N
12294	\N	\N	\N	\N	\N	\N
12295	\N	\N	\N	\N	\N	\N
12296	\N	\N	\N	\N	\N	\N
12297	\N	\N	\N	\N	\N	\N
12298	\N	\N	\N	\N	\N	\N
12299	\N	\N	\N	\N	\N	\N
12300	\N	\N	\N	\N	\N	\N
12301	\N	\N	\N	\N	\N	\N
12302	\N	\N	\N	\N	\N	\N
12303	\N	\N	\N	\N	\N	\N
12304	\N	\N	\N	\N	\N	\N
12305	\N	\N	\N	\N	\N	\N
12306	\N	\N	\N	\N	\N	\N
12307	\N	\N	\N	\N	\N	\N
12308	\N	\N	\N	\N	\N	\N
12309	\N	\N	\N	\N	\N	\N
12310	\N	\N	\N	\N	\N	\N
12311	\N	\N	\N	\N	\N	\N
12312	\N	\N	\N	\N	\N	\N
12313	\N	\N	\N	\N	\N	\N
12314	\N	\N	\N	\N	\N	\N
12315	\N	\N	\N	\N	\N	\N
12316	\N	\N	\N	\N	\N	\N
12317	\N	\N	\N	\N	\N	\N
12318	\N	\N	\N	\N	\N	\N
12319	\N	\N	\N	\N	\N	\N
12320	\N	\N	\N	\N	\N	\N
12321	\N	\N	\N	\N	\N	\N
12322	\N	\N	\N	\N	\N	\N
12323	\N	\N	\N	\N	\N	\N
12324	\N	\N	\N	\N	\N	\N
12325	\N	\N	\N	\N	\N	\N
12326	\N	\N	\N	\N	\N	\N
12327	\N	\N	\N	\N	\N	\N
12328	\N	\N	\N	\N	\N	\N
12329	\N	\N	\N	\N	\N	\N
12330	\N	\N	\N	\N	\N	\N
12331	\N	\N	\N	\N	\N	\N
12332	\N	\N	\N	\N	\N	\N
12333	\N	\N	\N	\N	\N	\N
12334	\N	\N	\N	\N	\N	\N
12335	\N	\N	\N	\N	\N	\N
12336	\N	\N	\N	\N	\N	\N
12337	\N	\N	\N	\N	\N	\N
12338	\N	\N	\N	\N	\N	\N
12339	\N	\N	\N	\N	\N	\N
12340	\N	\N	\N	\N	\N	\N
12341	\N	\N	\N	\N	\N	\N
12342	\N	\N	\N	\N	\N	\N
12343	\N	\N	\N	\N	\N	\N
12344	\N	\N	\N	\N	\N	\N
12345	\N	\N	\N	\N	\N	\N
12346	\N	\N	\N	\N	\N	\N
12347	\N	\N	\N	\N	\N	\N
12348	\N	\N	\N	\N	\N	\N
12349	\N	\N	\N	\N	\N	\N
12350	\N	\N	\N	\N	\N	\N
12351	\N	\N	\N	\N	\N	\N
12352	\N	\N	\N	\N	\N	\N
12353	\N	\N	\N	\N	\N	\N
12354	\N	\N	\N	\N	\N	\N
12355	\N	\N	\N	\N	\N	\N
12356	\N	\N	\N	\N	\N	\N
12357	\N	\N	\N	\N	\N	\N
12358	\N	\N	\N	\N	\N	\N
12359	\N	\N	\N	\N	\N	\N
12360	\N	\N	\N	\N	\N	\N
12361	\N	\N	\N	\N	\N	\N
12362	\N	\N	\N	\N	\N	\N
12363	\N	\N	\N	\N	\N	\N
12364	\N	\N	\N	\N	\N	\N
12365	\N	\N	\N	\N	\N	\N
12366	\N	\N	\N	\N	\N	\N
12367	\N	\N	\N	\N	\N	\N
12368	\N	\N	\N	\N	\N	\N
12369	\N	\N	\N	\N	\N	\N
12370	\N	\N	\N	\N	\N	\N
12371	\N	\N	\N	\N	\N	\N
12372	\N	\N	\N	\N	\N	\N
12373	\N	\N	\N	\N	\N	\N
12374	\N	\N	\N	\N	\N	\N
12375	\N	\N	\N	\N	\N	\N
12376	\N	\N	\N	\N	\N	\N
12377	\N	\N	\N	\N	\N	\N
12378	\N	\N	\N	\N	\N	\N
12379	\N	\N	\N	\N	\N	\N
12380	\N	\N	\N	\N	\N	\N
12381	\N	\N	\N	\N	\N	\N
12382	\N	\N	\N	\N	\N	\N
12383	\N	\N	\N	\N	\N	\N
12384	\N	\N	\N	\N	\N	\N
12385	\N	\N	\N	\N	\N	\N
12386	\N	\N	\N	\N	\N	\N
12387	\N	\N	\N	\N	\N	\N
12388	\N	\N	\N	\N	\N	\N
12389	\N	\N	\N	\N	\N	\N
12390	\N	\N	\N	\N	\N	\N
12391	\N	\N	\N	\N	\N	\N
12392	\N	\N	\N	\N	\N	\N
12393	\N	\N	\N	\N	\N	\N
12394	\N	\N	\N	\N	\N	\N
12395	\N	\N	\N	\N	\N	\N
12396	\N	\N	\N	\N	\N	\N
12397	\N	\N	\N	\N	\N	\N
12398	\N	\N	\N	\N	\N	\N
12399	\N	\N	\N	\N	\N	\N
12400	\N	\N	\N	\N	\N	\N
12401	\N	\N	\N	\N	\N	\N
12402	\N	\N	\N	\N	\N	\N
12403	\N	\N	\N	\N	\N	\N
12404	\N	\N	\N	\N	\N	\N
12405	\N	\N	\N	\N	\N	\N
12406	\N	\N	\N	\N	\N	\N
12407	\N	\N	\N	\N	\N	\N
12408	\N	\N	\N	\N	\N	\N
12409	\N	\N	\N	\N	\N	\N
12410	\N	\N	\N	\N	\N	\N
12411	\N	\N	\N	\N	\N	\N
12412	\N	\N	\N	\N	\N	\N
12413	\N	\N	\N	\N	\N	\N
12414	\N	\N	\N	\N	\N	\N
12415	\N	\N	\N	\N	\N	\N
12416	\N	\N	\N	\N	\N	\N
12417	\N	\N	\N	\N	\N	\N
12418	\N	\N	\N	\N	\N	\N
12419	\N	\N	\N	\N	\N	\N
12420	\N	\N	\N	\N	\N	\N
12421	\N	\N	\N	\N	\N	\N
12422	\N	\N	\N	\N	\N	\N
12423	\N	\N	\N	\N	\N	\N
12424	\N	\N	\N	\N	\N	\N
12425	\N	\N	\N	\N	\N	\N
12426	\N	\N	\N	\N	\N	\N
12427	\N	\N	\N	\N	\N	\N
12428	\N	\N	\N	\N	\N	\N
12429	\N	\N	\N	\N	\N	\N
12430	\N	\N	\N	\N	\N	\N
12431	\N	\N	\N	\N	\N	\N
12432	\N	\N	\N	\N	\N	\N
12433	\N	\N	\N	\N	\N	\N
12434	\N	\N	\N	\N	\N	\N
12435	\N	\N	\N	\N	\N	\N
12436	\N	\N	\N	\N	\N	\N
12437	\N	\N	\N	\N	\N	\N
12438	\N	\N	\N	\N	\N	\N
12439	\N	\N	\N	\N	\N	\N
12440	\N	\N	\N	\N	\N	\N
12441	\N	\N	\N	\N	\N	\N
12442	\N	\N	\N	\N	\N	\N
12443	\N	\N	\N	\N	\N	\N
12444	\N	\N	\N	\N	\N	\N
12445	\N	\N	\N	\N	\N	\N
12446	\N	\N	\N	\N	\N	\N
12447	\N	\N	\N	\N	\N	\N
12448	\N	\N	\N	\N	\N	\N
12449	\N	\N	\N	\N	\N	\N
12450	\N	\N	\N	\N	\N	\N
12451	\N	\N	\N	\N	\N	\N
12452	\N	\N	\N	\N	\N	\N
12453	\N	\N	\N	\N	\N	\N
12454	\N	\N	\N	\N	\N	\N
12455	\N	\N	\N	\N	\N	\N
12456	\N	\N	\N	\N	\N	\N
12457	\N	\N	\N	\N	\N	\N
12458	\N	\N	\N	\N	\N	\N
12459	\N	\N	\N	\N	\N	\N
12460	\N	\N	\N	\N	\N	\N
12461	\N	\N	\N	\N	\N	\N
12462	\N	\N	\N	\N	\N	\N
12463	\N	\N	\N	\N	\N	\N
12464	\N	\N	\N	\N	\N	\N
12465	\N	\N	\N	\N	\N	\N
12466	\N	\N	\N	\N	\N	\N
12467	\N	\N	\N	\N	\N	\N
12468	\N	\N	\N	\N	\N	\N
12469	\N	\N	\N	\N	\N	\N
12470	\N	\N	\N	\N	\N	\N
12471	\N	\N	\N	\N	\N	\N
12472	\N	\N	\N	\N	\N	\N
12473	\N	\N	\N	\N	\N	\N
12474	\N	\N	\N	\N	\N	\N
12475	\N	\N	\N	\N	\N	\N
12476	\N	\N	\N	\N	\N	\N
12477	\N	\N	\N	\N	\N	\N
12478	\N	\N	\N	\N	\N	\N
12479	\N	\N	\N	\N	\N	\N
12480	\N	\N	\N	\N	\N	\N
12481	\N	\N	\N	\N	\N	\N
12482	\N	\N	\N	\N	\N	\N
12483	\N	\N	\N	\N	\N	\N
12484	\N	\N	\N	\N	\N	\N
12485	\N	\N	\N	\N	\N	\N
12486	\N	\N	\N	\N	\N	\N
12487	\N	\N	\N	\N	\N	\N
12488	\N	\N	\N	\N	\N	\N
12489	\N	\N	\N	\N	\N	\N
12490	\N	\N	\N	\N	\N	\N
12491	\N	\N	\N	\N	\N	\N
12492	\N	\N	\N	\N	\N	\N
12493	\N	\N	\N	\N	\N	\N
12494	\N	\N	\N	\N	\N	\N
12495	\N	\N	\N	\N	\N	\N
12496	\N	\N	\N	\N	\N	\N
12497	\N	\N	\N	\N	\N	\N
12498	\N	\N	\N	\N	\N	\N
12499	\N	\N	\N	\N	\N	\N
12500	\N	\N	\N	\N	\N	\N
12501	\N	\N	\N	\N	\N	\N
12502	\N	\N	\N	\N	\N	\N
12503	\N	\N	\N	\N	\N	\N
12504	\N	\N	\N	\N	\N	\N
12505	\N	\N	\N	\N	\N	\N
12506	\N	\N	\N	\N	\N	\N
12507	\N	\N	\N	\N	\N	\N
12508	\N	\N	\N	\N	\N	\N
12509	\N	\N	\N	\N	\N	\N
12510	\N	\N	\N	\N	\N	\N
12511	\N	\N	\N	\N	\N	\N
12512	\N	\N	\N	\N	\N	\N
12513	\N	\N	\N	\N	\N	\N
12514	\N	\N	\N	\N	\N	\N
12515	\N	\N	\N	\N	\N	\N
12516	\N	\N	\N	\N	\N	\N
12517	\N	\N	\N	\N	\N	\N
12518	\N	\N	\N	\N	\N	\N
12519	\N	\N	\N	\N	\N	\N
12520	\N	\N	\N	\N	\N	\N
12521	\N	\N	\N	\N	\N	\N
12522	\N	\N	\N	\N	\N	\N
12523	\N	\N	\N	\N	\N	\N
12524	\N	\N	\N	\N	\N	\N
12525	\N	\N	\N	\N	\N	\N
12526	\N	\N	\N	\N	\N	\N
12527	\N	\N	\N	\N	\N	\N
12528	\N	\N	\N	\N	\N	\N
12529	\N	\N	\N	\N	\N	\N
12530	\N	\N	\N	\N	\N	\N
12531	\N	\N	\N	\N	\N	\N
12532	\N	\N	\N	\N	\N	\N
12533	\N	\N	\N	\N	\N	\N
12534	\N	\N	\N	\N	\N	\N
12535	\N	\N	\N	\N	\N	\N
12536	\N	\N	\N	\N	\N	\N
12537	\N	\N	\N	\N	\N	\N
12538	\N	\N	\N	\N	\N	\N
12539	\N	\N	\N	\N	\N	\N
12540	\N	\N	\N	\N	\N	\N
12541	\N	\N	\N	\N	\N	\N
12542	\N	\N	\N	\N	\N	\N
12543	\N	\N	\N	\N	\N	\N
12544	\N	\N	\N	\N	\N	\N
12545	\N	\N	\N	\N	\N	\N
12546	\N	\N	\N	\N	\N	\N
12547	\N	\N	\N	\N	\N	\N
12548	\N	\N	\N	\N	\N	\N
12549	\N	\N	\N	\N	\N	\N
12550	\N	\N	\N	\N	\N	\N
12551	\N	\N	\N	\N	\N	\N
12552	\N	\N	\N	\N	\N	\N
12553	\N	\N	\N	\N	\N	\N
12554	\N	\N	\N	\N	\N	\N
12555	\N	\N	\N	\N	\N	\N
12556	\N	\N	\N	\N	\N	\N
12557	\N	\N	\N	\N	\N	\N
12558	\N	\N	\N	\N	\N	\N
12559	\N	\N	\N	\N	\N	\N
12560	\N	\N	\N	\N	\N	\N
12561	\N	\N	\N	\N	\N	\N
12562	\N	\N	\N	\N	\N	\N
12563	\N	\N	\N	\N	\N	\N
12564	\N	\N	\N	\N	\N	\N
12565	\N	\N	\N	\N	\N	\N
12566	\N	\N	\N	\N	\N	\N
12567	\N	\N	\N	\N	\N	\N
12568	\N	\N	\N	\N	\N	\N
12569	\N	\N	\N	\N	\N	\N
12570	\N	\N	\N	\N	\N	\N
12571	\N	\N	\N	\N	\N	\N
12572	\N	\N	\N	\N	\N	\N
12573	\N	\N	\N	\N	\N	\N
12574	\N	\N	\N	\N	\N	\N
12575	\N	\N	\N	\N	\N	\N
12576	\N	\N	\N	\N	\N	\N
12577	\N	\N	\N	\N	\N	\N
12578	\N	\N	\N	\N	\N	\N
12579	\N	\N	\N	\N	\N	\N
12580	\N	\N	\N	\N	\N	\N
12581	\N	\N	\N	\N	\N	\N
12582	\N	\N	\N	\N	\N	\N
12583	\N	\N	\N	\N	\N	\N
12584	\N	\N	\N	\N	\N	\N
12585	\N	\N	\N	\N	\N	\N
12586	\N	\N	\N	\N	\N	\N
12587	\N	\N	\N	\N	\N	\N
12588	\N	\N	\N	\N	\N	\N
12589	\N	\N	\N	\N	\N	\N
12590	\N	\N	\N	\N	\N	\N
12591	\N	\N	\N	\N	\N	\N
12592	\N	\N	\N	\N	\N	\N
12593	\N	\N	\N	\N	\N	\N
12594	\N	\N	\N	\N	\N	\N
12595	\N	\N	\N	\N	\N	\N
12596	\N	\N	\N	\N	\N	\N
12597	\N	\N	\N	\N	\N	\N
12598	\N	\N	\N	\N	\N	\N
12599	\N	\N	\N	\N	\N	\N
12600	\N	\N	\N	\N	\N	\N
12601	\N	\N	\N	\N	\N	\N
12602	\N	\N	\N	\N	\N	\N
12603	\N	\N	\N	\N	\N	\N
12604	\N	\N	\N	\N	\N	\N
12605	\N	\N	\N	\N	\N	\N
12606	\N	\N	\N	\N	\N	\N
12607	\N	\N	\N	\N	\N	\N
12608	\N	\N	\N	\N	\N	\N
12609	\N	\N	\N	\N	\N	\N
12610	\N	\N	\N	\N	\N	\N
12611	\N	\N	\N	\N	\N	\N
12612	\N	\N	\N	\N	\N	\N
12613	\N	\N	\N	\N	\N	\N
12614	\N	\N	\N	\N	\N	\N
12615	\N	\N	\N	\N	\N	\N
12616	\N	\N	\N	\N	\N	\N
12617	\N	\N	\N	\N	\N	\N
12618	\N	\N	\N	\N	\N	\N
12619	\N	\N	\N	\N	\N	\N
12620	\N	\N	\N	\N	\N	\N
12621	\N	\N	\N	\N	\N	\N
12622	\N	\N	\N	\N	\N	\N
12623	\N	\N	\N	\N	\N	\N
12624	\N	\N	\N	\N	\N	\N
12625	\N	\N	\N	\N	\N	\N
12626	\N	\N	\N	\N	\N	\N
12627	\N	\N	\N	\N	\N	\N
12628	\N	\N	\N	\N	\N	\N
12629	\N	\N	\N	\N	\N	\N
12630	\N	\N	\N	\N	\N	\N
12631	\N	\N	\N	\N	\N	\N
12632	\N	\N	\N	\N	\N	\N
12633	\N	\N	\N	\N	\N	\N
12634	\N	\N	\N	\N	\N	\N
12635	\N	\N	\N	\N	\N	\N
12636	\N	\N	\N	\N	\N	\N
12637	\N	\N	\N	\N	\N	\N
12638	\N	\N	\N	\N	\N	\N
12639	\N	\N	\N	\N	\N	\N
12640	\N	\N	\N	\N	\N	\N
12641	\N	\N	\N	\N	\N	\N
12642	\N	\N	\N	\N	\N	\N
12643	\N	\N	\N	\N	\N	\N
12644	\N	\N	\N	\N	\N	\N
12645	\N	\N	\N	\N	\N	\N
12646	\N	\N	\N	\N	\N	\N
12647	\N	\N	\N	\N	\N	\N
12648	\N	\N	\N	\N	\N	\N
12649	\N	\N	\N	\N	\N	\N
12650	\N	\N	\N	\N	\N	\N
12651	\N	\N	\N	\N	\N	\N
12652	\N	\N	\N	\N	\N	\N
12653	\N	\N	\N	\N	\N	\N
12654	\N	\N	\N	\N	\N	\N
12655	\N	\N	\N	\N	\N	\N
12656	\N	\N	\N	\N	\N	\N
12657	\N	\N	\N	\N	\N	\N
12658	\N	\N	\N	\N	\N	\N
12659	\N	\N	\N	\N	\N	\N
12660	\N	\N	\N	\N	\N	\N
12661	\N	\N	\N	\N	\N	\N
12662	\N	\N	\N	\N	\N	\N
12663	\N	\N	\N	\N	\N	\N
12664	\N	\N	\N	\N	\N	\N
12665	\N	\N	\N	\N	\N	\N
12666	\N	\N	\N	\N	\N	\N
12667	\N	\N	\N	\N	\N	\N
12668	\N	\N	\N	\N	\N	\N
12669	\N	\N	\N	\N	\N	\N
12670	\N	\N	\N	\N	\N	\N
12671	\N	\N	\N	\N	\N	\N
12672	\N	\N	\N	\N	\N	\N
12673	\N	\N	\N	\N	\N	\N
12674	\N	\N	\N	\N	\N	\N
12675	\N	\N	\N	\N	\N	\N
12676	\N	\N	\N	\N	\N	\N
12677	\N	\N	\N	\N	\N	\N
12678	\N	\N	\N	\N	\N	\N
12679	\N	\N	\N	\N	\N	\N
12680	\N	\N	\N	\N	\N	\N
12681	\N	\N	\N	\N	\N	\N
12682	\N	\N	\N	\N	\N	\N
12683	\N	\N	\N	\N	\N	\N
12684	\N	\N	\N	\N	\N	\N
12685	\N	\N	\N	\N	\N	\N
12686	\N	\N	\N	\N	\N	\N
12687	\N	\N	\N	\N	\N	\N
12688	\N	\N	\N	\N	\N	\N
12689	\N	\N	\N	\N	\N	\N
12690	\N	\N	\N	\N	\N	\N
12691	\N	\N	\N	\N	\N	\N
12692	\N	\N	\N	\N	\N	\N
12693	\N	\N	\N	\N	\N	\N
12694	\N	\N	\N	\N	\N	\N
12695	\N	\N	\N	\N	\N	\N
12696	\N	\N	\N	\N	\N	\N
12697	\N	\N	\N	\N	\N	\N
12698	\N	\N	\N	\N	\N	\N
12699	\N	\N	\N	\N	\N	\N
12700	\N	\N	\N	\N	\N	\N
12701	\N	\N	\N	\N	\N	\N
12702	\N	\N	\N	\N	\N	\N
12703	\N	\N	\N	\N	\N	\N
12704	\N	\N	\N	\N	\N	\N
12705	\N	\N	\N	\N	\N	\N
12706	\N	\N	\N	\N	\N	\N
12707	\N	\N	\N	\N	\N	\N
12708	\N	\N	\N	\N	\N	\N
12709	\N	\N	\N	\N	\N	\N
12710	\N	\N	\N	\N	\N	\N
12711	\N	\N	\N	\N	\N	\N
12712	\N	\N	\N	\N	\N	\N
12713	\N	\N	\N	\N	\N	\N
12714	\N	\N	\N	\N	\N	\N
12715	\N	\N	\N	\N	\N	\N
12716	\N	\N	\N	\N	\N	\N
12717	\N	\N	\N	\N	\N	\N
12718	\N	\N	\N	\N	\N	\N
12719	\N	\N	\N	\N	\N	\N
12720	\N	\N	\N	\N	\N	\N
12721	\N	\N	\N	\N	\N	\N
12722	\N	\N	\N	\N	\N	\N
12723	\N	\N	\N	\N	\N	\N
12724	\N	\N	\N	\N	\N	\N
12725	\N	\N	\N	\N	\N	\N
12726	\N	\N	\N	\N	\N	\N
12727	\N	\N	\N	\N	\N	\N
12728	\N	\N	\N	\N	\N	\N
12729	\N	\N	\N	\N	\N	\N
12730	\N	\N	\N	\N	\N	\N
12731	\N	\N	\N	\N	\N	\N
12732	\N	\N	\N	\N	\N	\N
12733	\N	\N	\N	\N	\N	\N
12734	\N	\N	\N	\N	\N	\N
12735	\N	\N	\N	\N	\N	\N
12736	\N	\N	\N	\N	\N	\N
12737	\N	\N	\N	\N	\N	\N
12738	\N	\N	\N	\N	\N	\N
12739	\N	\N	\N	\N	\N	\N
12740	\N	\N	\N	\N	\N	\N
12741	\N	\N	\N	\N	\N	\N
12742	\N	\N	\N	\N	\N	\N
12743	\N	\N	\N	\N	\N	\N
12744	\N	\N	\N	\N	\N	\N
12745	\N	\N	\N	\N	\N	\N
12746	\N	\N	\N	\N	\N	\N
12747	\N	\N	\N	\N	\N	\N
12748	\N	\N	\N	\N	\N	\N
12749	\N	\N	\N	\N	\N	\N
12750	\N	\N	\N	\N	\N	\N
12751	\N	\N	\N	\N	\N	\N
12752	\N	\N	\N	\N	\N	\N
12753	\N	\N	\N	\N	\N	\N
12754	\N	\N	\N	\N	\N	\N
12755	\N	\N	\N	\N	\N	\N
12756	\N	\N	\N	\N	\N	\N
12757	\N	\N	\N	\N	\N	\N
12758	\N	\N	\N	\N	\N	\N
12759	\N	\N	\N	\N	\N	\N
12760	\N	\N	\N	\N	\N	\N
12761	\N	\N	\N	\N	\N	\N
12762	\N	\N	\N	\N	\N	\N
12763	\N	\N	\N	\N	\N	\N
12764	\N	\N	\N	\N	\N	\N
12765	\N	\N	\N	\N	\N	\N
12766	\N	\N	\N	\N	\N	\N
12767	\N	\N	\N	\N	\N	\N
12768	\N	\N	\N	\N	\N	\N
12769	\N	\N	\N	\N	\N	\N
12770	\N	\N	\N	\N	\N	\N
12771	\N	\N	\N	\N	\N	\N
12772	\N	\N	\N	\N	\N	\N
12773	\N	\N	\N	\N	\N	\N
12774	\N	\N	\N	\N	\N	\N
12775	\N	\N	\N	\N	\N	\N
12776	\N	\N	\N	\N	\N	\N
12777	\N	\N	\N	\N	\N	\N
12778	\N	\N	\N	\N	\N	\N
12779	\N	\N	\N	\N	\N	\N
12780	\N	\N	\N	\N	\N	\N
12781	\N	\N	\N	\N	\N	\N
12782	\N	\N	\N	\N	\N	\N
12783	\N	\N	\N	\N	\N	\N
12784	\N	\N	\N	\N	\N	\N
12785	\N	\N	\N	\N	\N	\N
12786	\N	\N	\N	\N	\N	\N
12787	\N	\N	\N	\N	\N	\N
12788	\N	\N	\N	\N	\N	\N
12789	\N	\N	\N	\N	\N	\N
12790	\N	\N	\N	\N	\N	\N
12791	\N	\N	\N	\N	\N	\N
12792	\N	\N	\N	\N	\N	\N
12793	\N	\N	\N	\N	\N	\N
12794	\N	\N	\N	\N	\N	\N
12795	\N	\N	\N	\N	\N	\N
12796	\N	\N	\N	\N	\N	\N
12797	\N	\N	\N	\N	\N	\N
12798	\N	\N	\N	\N	\N	\N
12799	\N	\N	\N	\N	\N	\N
12800	\N	\N	\N	\N	\N	\N
12801	\N	\N	\N	\N	\N	\N
12802	\N	\N	\N	\N	\N	\N
12803	\N	\N	\N	\N	\N	\N
12804	\N	\N	\N	\N	\N	\N
12805	\N	\N	\N	\N	\N	\N
12806	\N	\N	\N	\N	\N	\N
12807	\N	\N	\N	\N	\N	\N
12808	\N	\N	\N	\N	\N	\N
12809	\N	\N	\N	\N	\N	\N
12810	\N	\N	\N	\N	\N	\N
12811	\N	\N	\N	\N	\N	\N
12812	\N	\N	\N	\N	\N	\N
12813	\N	\N	\N	\N	\N	\N
12814	\N	\N	\N	\N	\N	\N
12815	\N	\N	\N	\N	\N	\N
12816	\N	\N	\N	\N	\N	\N
12817	\N	\N	\N	\N	\N	\N
12818	\N	\N	\N	\N	\N	\N
12819	\N	\N	\N	\N	\N	\N
12820	\N	\N	\N	\N	\N	\N
12821	\N	\N	\N	\N	\N	\N
12822	\N	\N	\N	\N	\N	\N
12823	\N	\N	\N	\N	\N	\N
12824	\N	\N	\N	\N	\N	\N
12825	\N	\N	\N	\N	\N	\N
12826	\N	\N	\N	\N	\N	\N
12827	\N	\N	\N	\N	\N	\N
12828	\N	\N	\N	\N	\N	\N
12829	\N	\N	\N	\N	\N	\N
12830	\N	\N	\N	\N	\N	\N
12831	\N	\N	\N	\N	\N	\N
12832	\N	\N	\N	\N	\N	\N
12833	\N	\N	\N	\N	\N	\N
12834	\N	\N	\N	\N	\N	\N
12835	\N	\N	\N	\N	\N	\N
12836	\N	\N	\N	\N	\N	\N
12837	\N	\N	\N	\N	\N	\N
12838	\N	\N	\N	\N	\N	\N
12839	\N	\N	\N	\N	\N	\N
12840	\N	\N	\N	\N	\N	\N
12841	\N	\N	\N	\N	\N	\N
12842	\N	\N	\N	\N	\N	\N
12843	\N	\N	\N	\N	\N	\N
12844	\N	\N	\N	\N	\N	\N
12845	\N	\N	\N	\N	\N	\N
12846	\N	\N	\N	\N	\N	\N
12847	\N	\N	\N	\N	\N	\N
12848	\N	\N	\N	\N	\N	\N
12849	\N	\N	\N	\N	\N	\N
12850	\N	\N	\N	\N	\N	\N
12851	\N	\N	\N	\N	\N	\N
12852	\N	\N	\N	\N	\N	\N
12853	\N	\N	\N	\N	\N	\N
12854	\N	\N	\N	\N	\N	\N
12855	\N	\N	\N	\N	\N	\N
12856	\N	\N	\N	\N	\N	\N
12857	\N	\N	\N	\N	\N	\N
12858	\N	\N	\N	\N	\N	\N
12859	\N	\N	\N	\N	\N	\N
12860	\N	\N	\N	\N	\N	\N
12861	\N	\N	\N	\N	\N	\N
12862	\N	\N	\N	\N	\N	\N
12863	\N	\N	\N	\N	\N	\N
12864	\N	\N	\N	\N	\N	\N
12865	\N	\N	\N	\N	\N	\N
12866	\N	\N	\N	\N	\N	\N
12867	\N	\N	\N	\N	\N	\N
12868	\N	\N	\N	\N	\N	\N
12869	\N	\N	\N	\N	\N	\N
12870	\N	\N	\N	\N	\N	\N
12871	\N	\N	\N	\N	\N	\N
12872	\N	\N	\N	\N	\N	\N
12873	\N	\N	\N	\N	\N	\N
12874	\N	\N	\N	\N	\N	\N
12875	\N	\N	\N	\N	\N	\N
12876	\N	\N	\N	\N	\N	\N
12877	\N	\N	\N	\N	\N	\N
12878	\N	\N	\N	\N	\N	\N
12879	\N	\N	\N	\N	\N	\N
12880	\N	\N	\N	\N	\N	\N
12881	\N	\N	\N	\N	\N	\N
12882	\N	\N	\N	\N	\N	\N
12883	\N	\N	\N	\N	\N	\N
12884	\N	\N	\N	\N	\N	\N
12885	\N	\N	\N	\N	\N	\N
12886	\N	\N	\N	\N	\N	\N
12887	\N	\N	\N	\N	\N	\N
12888	\N	\N	\N	\N	\N	\N
12889	\N	\N	\N	\N	\N	\N
12890	\N	\N	\N	\N	\N	\N
12891	\N	\N	\N	\N	\N	\N
12892	\N	\N	\N	\N	\N	\N
12893	\N	\N	\N	\N	\N	\N
12894	\N	\N	\N	\N	\N	\N
12895	\N	\N	\N	\N	\N	\N
12896	\N	\N	\N	\N	\N	\N
12897	\N	\N	\N	\N	\N	\N
12898	\N	\N	\N	\N	\N	\N
12899	\N	\N	\N	\N	\N	\N
12900	\N	\N	\N	\N	\N	\N
12901	\N	\N	\N	\N	\N	\N
12902	\N	\N	\N	\N	\N	\N
12903	\N	\N	\N	\N	\N	\N
12904	\N	\N	\N	\N	\N	\N
12905	\N	\N	\N	\N	\N	\N
12906	\N	\N	\N	\N	\N	\N
12907	\N	\N	\N	\N	\N	\N
12908	\N	\N	\N	\N	\N	\N
12909	\N	\N	\N	\N	\N	\N
12910	\N	\N	\N	\N	\N	\N
12911	\N	\N	\N	\N	\N	\N
12912	\N	\N	\N	\N	\N	\N
12913	\N	\N	\N	\N	\N	\N
12914	\N	\N	\N	\N	\N	\N
12915	\N	\N	\N	\N	\N	\N
12916	\N	\N	\N	\N	\N	\N
12917	\N	\N	\N	\N	\N	\N
12918	\N	\N	\N	\N	\N	\N
12919	\N	\N	\N	\N	\N	\N
12920	\N	\N	\N	\N	\N	\N
12921	\N	\N	\N	\N	\N	\N
12922	\N	\N	\N	\N	\N	\N
12923	\N	\N	\N	\N	\N	\N
12924	\N	\N	\N	\N	\N	\N
12925	\N	\N	\N	\N	\N	\N
12926	\N	\N	\N	\N	\N	\N
12927	\N	\N	\N	\N	\N	\N
12928	\N	\N	\N	\N	\N	\N
12929	\N	\N	\N	\N	\N	\N
12930	\N	\N	\N	\N	\N	\N
12931	\N	\N	\N	\N	\N	\N
12932	\N	\N	\N	\N	\N	\N
12933	\N	\N	\N	\N	\N	\N
12934	\N	\N	\N	\N	\N	\N
12935	\N	\N	\N	\N	\N	\N
12936	\N	\N	\N	\N	\N	\N
12937	\N	\N	\N	\N	\N	\N
12938	\N	\N	\N	\N	\N	\N
12939	\N	\N	\N	\N	\N	\N
12940	\N	\N	\N	\N	\N	\N
12941	\N	\N	\N	\N	\N	\N
12942	\N	\N	\N	\N	\N	\N
12943	\N	\N	\N	\N	\N	\N
12944	\N	\N	\N	\N	\N	\N
12945	\N	\N	\N	\N	\N	\N
12946	\N	\N	\N	\N	\N	\N
12947	\N	\N	\N	\N	\N	\N
12948	\N	\N	\N	\N	\N	\N
12949	\N	\N	\N	\N	\N	\N
12950	\N	\N	\N	\N	\N	\N
12951	\N	\N	\N	\N	\N	\N
12952	\N	\N	\N	\N	\N	\N
12953	\N	\N	\N	\N	\N	\N
12954	\N	\N	\N	\N	\N	\N
12955	\N	\N	\N	\N	\N	\N
12956	\N	\N	\N	\N	\N	\N
12957	\N	\N	\N	\N	\N	\N
12958	\N	\N	\N	\N	\N	\N
12959	\N	\N	\N	\N	\N	\N
12960	\N	\N	\N	\N	\N	\N
12961	\N	\N	\N	\N	\N	\N
12962	\N	\N	\N	\N	\N	\N
12963	\N	\N	\N	\N	\N	\N
12964	\N	\N	\N	\N	\N	\N
12965	\N	\N	\N	\N	\N	\N
12966	\N	\N	\N	\N	\N	\N
12967	\N	\N	\N	\N	\N	\N
12968	\N	\N	\N	\N	\N	\N
12969	\N	\N	\N	\N	\N	\N
12970	\N	\N	\N	\N	\N	\N
12971	\N	\N	\N	\N	\N	\N
12972	\N	\N	\N	\N	\N	\N
12973	\N	\N	\N	\N	\N	\N
12974	\N	\N	\N	\N	\N	\N
12975	\N	\N	\N	\N	\N	\N
12976	\N	\N	\N	\N	\N	\N
12977	\N	\N	\N	\N	\N	\N
12978	\N	\N	\N	\N	\N	\N
12979	\N	\N	\N	\N	\N	\N
12980	\N	\N	\N	\N	\N	\N
12981	\N	\N	\N	\N	\N	\N
12982	\N	\N	\N	\N	\N	\N
12983	\N	\N	\N	\N	\N	\N
12984	\N	\N	\N	\N	\N	\N
12985	\N	\N	\N	\N	\N	\N
12986	\N	\N	\N	\N	\N	\N
12987	\N	\N	\N	\N	\N	\N
12988	\N	\N	\N	\N	\N	\N
12989	\N	\N	\N	\N	\N	\N
12990	\N	\N	\N	\N	\N	\N
12991	\N	\N	\N	\N	\N	\N
12992	\N	\N	\N	\N	\N	\N
12993	\N	\N	\N	\N	\N	\N
12994	\N	\N	\N	\N	\N	\N
12995	\N	\N	\N	\N	\N	\N
12996	\N	\N	\N	\N	\N	\N
12997	\N	\N	\N	\N	\N	\N
12998	\N	\N	\N	\N	\N	\N
12999	\N	\N	\N	\N	\N	\N
13000	\N	\N	\N	\N	\N	\N
13001	\N	\N	\N	\N	\N	\N
13002	\N	\N	\N	\N	\N	\N
13003	\N	\N	\N	\N	\N	\N
13004	\N	\N	\N	\N	\N	\N
13005	\N	\N	\N	\N	\N	\N
13006	\N	\N	\N	\N	\N	\N
13007	\N	\N	\N	\N	\N	\N
13008	\N	\N	\N	\N	\N	\N
13009	\N	\N	\N	\N	\N	\N
13010	\N	\N	\N	\N	\N	\N
13011	\N	\N	\N	\N	\N	\N
13012	\N	\N	\N	\N	\N	\N
13013	\N	\N	\N	\N	\N	\N
13014	\N	\N	\N	\N	\N	\N
13015	\N	\N	\N	\N	\N	\N
13016	\N	\N	\N	\N	\N	\N
13017	\N	\N	\N	\N	\N	\N
13018	\N	\N	\N	\N	\N	\N
13019	\N	\N	\N	\N	\N	\N
13020	\N	\N	\N	\N	\N	\N
13021	\N	\N	\N	\N	\N	\N
13022	\N	\N	\N	\N	\N	\N
13023	\N	\N	\N	\N	\N	\N
13024	\N	\N	\N	\N	\N	\N
13025	\N	\N	\N	\N	\N	\N
13026	\N	\N	\N	\N	\N	\N
13027	\N	\N	\N	\N	\N	\N
13028	\N	\N	\N	\N	\N	\N
13029	\N	\N	\N	\N	\N	\N
13030	\N	\N	\N	\N	\N	\N
13031	\N	\N	\N	\N	\N	\N
13032	\N	\N	\N	\N	\N	\N
13033	\N	\N	\N	\N	\N	\N
13034	\N	\N	\N	\N	\N	\N
13035	\N	\N	\N	\N	\N	\N
13036	\N	\N	\N	\N	\N	\N
13037	\N	\N	\N	\N	\N	\N
13038	\N	\N	\N	\N	\N	\N
13039	\N	\N	\N	\N	\N	\N
13040	\N	\N	\N	\N	\N	\N
13041	\N	\N	\N	\N	\N	\N
13042	\N	\N	\N	\N	\N	\N
13043	\N	\N	\N	\N	\N	\N
13044	\N	\N	\N	\N	\N	\N
13045	\N	\N	\N	\N	\N	\N
13046	\N	\N	\N	\N	\N	\N
13047	\N	\N	\N	\N	\N	\N
13048	\N	\N	\N	\N	\N	\N
13049	\N	\N	\N	\N	\N	\N
13050	\N	\N	\N	\N	\N	\N
13051	\N	\N	\N	\N	\N	\N
13052	\N	\N	\N	\N	\N	\N
13053	\N	\N	\N	\N	\N	\N
13054	\N	\N	\N	\N	\N	\N
13055	\N	\N	\N	\N	\N	\N
13056	\N	\N	\N	\N	\N	\N
13057	\N	\N	\N	\N	\N	\N
13058	\N	\N	\N	\N	\N	\N
13059	\N	\N	\N	\N	\N	\N
13060	\N	\N	\N	\N	\N	\N
13061	\N	\N	\N	\N	\N	\N
13062	\N	\N	\N	\N	\N	\N
13063	\N	\N	\N	\N	\N	\N
13064	\N	\N	\N	\N	\N	\N
13065	\N	\N	\N	\N	\N	\N
13066	\N	\N	\N	\N	\N	\N
13067	\N	\N	\N	\N	\N	\N
13068	\N	\N	\N	\N	\N	\N
13069	\N	\N	\N	\N	\N	\N
13070	\N	\N	\N	\N	\N	\N
13071	\N	\N	\N	\N	\N	\N
13072	\N	\N	\N	\N	\N	\N
13073	\N	\N	\N	\N	\N	\N
13074	\N	\N	\N	\N	\N	\N
13075	\N	\N	\N	\N	\N	\N
13076	\N	\N	\N	\N	\N	\N
13077	\N	\N	\N	\N	\N	\N
13078	\N	\N	\N	\N	\N	\N
13079	\N	\N	\N	\N	\N	\N
13080	\N	\N	\N	\N	\N	\N
13081	\N	\N	\N	\N	\N	\N
13082	\N	\N	\N	\N	\N	\N
13083	\N	\N	\N	\N	\N	\N
13084	\N	\N	\N	\N	\N	\N
13085	\N	\N	\N	\N	\N	\N
13086	\N	\N	\N	\N	\N	\N
13087	\N	\N	\N	\N	\N	\N
13088	\N	\N	\N	\N	\N	\N
13089	\N	\N	\N	\N	\N	\N
13090	\N	\N	\N	\N	\N	\N
13091	\N	\N	\N	\N	\N	\N
13092	\N	\N	\N	\N	\N	\N
13093	\N	\N	\N	\N	\N	\N
13094	\N	\N	\N	\N	\N	\N
13095	\N	\N	\N	\N	\N	\N
13096	\N	\N	\N	\N	\N	\N
13097	\N	\N	\N	\N	\N	\N
13098	\N	\N	\N	\N	\N	\N
13099	\N	\N	\N	\N	\N	\N
13100	\N	\N	\N	\N	\N	\N
13101	\N	\N	\N	\N	\N	\N
13102	\N	\N	\N	\N	\N	\N
13103	\N	\N	\N	\N	\N	\N
13104	\N	\N	\N	\N	\N	\N
13105	\N	\N	\N	\N	\N	\N
13106	\N	\N	\N	\N	\N	\N
13107	\N	\N	\N	\N	\N	\N
13108	\N	\N	\N	\N	\N	\N
13109	\N	\N	\N	\N	\N	\N
13110	\N	\N	\N	\N	\N	\N
13111	\N	\N	\N	\N	\N	\N
13112	\N	\N	\N	\N	\N	\N
13113	\N	\N	\N	\N	\N	\N
13114	\N	\N	\N	\N	\N	\N
13115	\N	\N	\N	\N	\N	\N
13116	\N	\N	\N	\N	\N	\N
13117	\N	\N	\N	\N	\N	\N
13118	\N	\N	\N	\N	\N	\N
13119	\N	\N	\N	\N	\N	\N
13120	\N	\N	\N	\N	\N	\N
13121	\N	\N	\N	\N	\N	\N
13122	\N	\N	\N	\N	\N	\N
13123	\N	\N	\N	\N	\N	\N
13124	\N	\N	\N	\N	\N	\N
13125	\N	\N	\N	\N	\N	\N
13126	\N	\N	\N	\N	\N	\N
13127	\N	\N	\N	\N	\N	\N
13128	\N	\N	\N	\N	\N	\N
13129	\N	\N	\N	\N	\N	\N
13130	\N	\N	\N	\N	\N	\N
13131	\N	\N	\N	\N	\N	\N
13132	\N	\N	\N	\N	\N	\N
13133	\N	\N	\N	\N	\N	\N
13134	\N	\N	\N	\N	\N	\N
13135	\N	\N	\N	\N	\N	\N
13136	\N	\N	\N	\N	\N	\N
13137	\N	\N	\N	\N	\N	\N
13138	\N	\N	\N	\N	\N	\N
13139	\N	\N	\N	\N	\N	\N
13140	\N	\N	\N	\N	\N	\N
13141	\N	\N	\N	\N	\N	\N
13142	\N	\N	\N	\N	\N	\N
13143	\N	\N	\N	\N	\N	\N
13144	\N	\N	\N	\N	\N	\N
13145	\N	\N	\N	\N	\N	\N
13146	\N	\N	\N	\N	\N	\N
13147	\N	\N	\N	\N	\N	\N
13148	\N	\N	\N	\N	\N	\N
13149	\N	\N	\N	\N	\N	\N
13150	\N	\N	\N	\N	\N	\N
13151	\N	\N	\N	\N	\N	\N
13152	\N	\N	\N	\N	\N	\N
13153	\N	\N	\N	\N	\N	\N
13154	\N	\N	\N	\N	\N	\N
13155	\N	\N	\N	\N	\N	\N
13156	\N	\N	\N	\N	\N	\N
13157	\N	\N	\N	\N	\N	\N
13158	\N	\N	\N	\N	\N	\N
13159	\N	\N	\N	\N	\N	\N
13160	\N	\N	\N	\N	\N	\N
13161	\N	\N	\N	\N	\N	\N
13162	\N	\N	\N	\N	\N	\N
13163	\N	\N	\N	\N	\N	\N
13164	\N	\N	\N	\N	\N	\N
13165	\N	\N	\N	\N	\N	\N
13166	\N	\N	\N	\N	\N	\N
13167	\N	\N	\N	\N	\N	\N
13168	\N	\N	\N	\N	\N	\N
13169	\N	\N	\N	\N	\N	\N
13170	\N	\N	\N	\N	\N	\N
13171	\N	\N	\N	\N	\N	\N
13172	\N	\N	\N	\N	\N	\N
13173	\N	\N	\N	\N	\N	\N
13174	\N	\N	\N	\N	\N	\N
13175	\N	\N	\N	\N	\N	\N
13176	\N	\N	\N	\N	\N	\N
13177	\N	\N	\N	\N	\N	\N
13178	\N	\N	\N	\N	\N	\N
13179	\N	\N	\N	\N	\N	\N
13180	\N	\N	\N	\N	\N	\N
13181	\N	\N	\N	\N	\N	\N
13182	\N	\N	\N	\N	\N	\N
13183	\N	\N	\N	\N	\N	\N
13184	\N	\N	\N	\N	\N	\N
13185	\N	\N	\N	\N	\N	\N
13186	\N	\N	\N	\N	\N	\N
13187	\N	\N	\N	\N	\N	\N
13188	\N	\N	\N	\N	\N	\N
13189	\N	\N	\N	\N	\N	\N
13190	\N	\N	\N	\N	\N	\N
13191	\N	\N	\N	\N	\N	\N
13192	\N	\N	\N	\N	\N	\N
13193	\N	\N	\N	\N	\N	\N
13194	\N	\N	\N	\N	\N	\N
13195	\N	\N	\N	\N	\N	\N
13196	\N	\N	\N	\N	\N	\N
13197	\N	\N	\N	\N	\N	\N
13198	\N	\N	\N	\N	\N	\N
13199	\N	\N	\N	\N	\N	\N
13200	\N	\N	\N	\N	\N	\N
13201	\N	\N	\N	\N	\N	\N
13202	\N	\N	\N	\N	\N	\N
13203	\N	\N	\N	\N	\N	\N
13204	\N	\N	\N	\N	\N	\N
13205	\N	\N	\N	\N	\N	\N
13206	\N	\N	\N	\N	\N	\N
13207	\N	\N	\N	\N	\N	\N
13208	\N	\N	\N	\N	\N	\N
13209	\N	\N	\N	\N	\N	\N
13210	\N	\N	\N	\N	\N	\N
13211	\N	\N	\N	\N	\N	\N
13212	\N	\N	\N	\N	\N	\N
13213	\N	\N	\N	\N	\N	\N
13214	\N	\N	\N	\N	\N	\N
13215	\N	\N	\N	\N	\N	\N
13216	\N	\N	\N	\N	\N	\N
13217	\N	\N	\N	\N	\N	\N
13218	\N	\N	\N	\N	\N	\N
13219	\N	\N	\N	\N	\N	\N
13220	\N	\N	\N	\N	\N	\N
13221	\N	\N	\N	\N	\N	\N
13222	\N	\N	\N	\N	\N	\N
13223	\N	\N	\N	\N	\N	\N
13224	\N	\N	\N	\N	\N	\N
13225	\N	\N	\N	\N	\N	\N
13226	\N	\N	\N	\N	\N	\N
13227	\N	\N	\N	\N	\N	\N
13228	\N	\N	\N	\N	\N	\N
13229	\N	\N	\N	\N	\N	\N
13230	\N	\N	\N	\N	\N	\N
13231	\N	\N	\N	\N	\N	\N
13232	\N	\N	\N	\N	\N	\N
13233	\N	\N	\N	\N	\N	\N
13234	\N	\N	\N	\N	\N	\N
13235	\N	\N	\N	\N	\N	\N
13236	\N	\N	\N	\N	\N	\N
13237	\N	\N	\N	\N	\N	\N
13238	\N	\N	\N	\N	\N	\N
13239	\N	\N	\N	\N	\N	\N
13240	\N	\N	\N	\N	\N	\N
13241	\N	\N	\N	\N	\N	\N
13242	\N	\N	\N	\N	\N	\N
13243	\N	\N	\N	\N	\N	\N
13244	\N	\N	\N	\N	\N	\N
13245	\N	\N	\N	\N	\N	\N
13246	\N	\N	\N	\N	\N	\N
13247	\N	\N	\N	\N	\N	\N
13248	\N	\N	\N	\N	\N	\N
13249	\N	\N	\N	\N	\N	\N
13250	\N	\N	\N	\N	\N	\N
13251	\N	\N	\N	\N	\N	\N
13252	\N	\N	\N	\N	\N	\N
13253	\N	\N	\N	\N	\N	\N
13254	\N	\N	\N	\N	\N	\N
13255	\N	\N	\N	\N	\N	\N
13256	\N	\N	\N	\N	\N	\N
13257	\N	\N	\N	\N	\N	\N
13258	\N	\N	\N	\N	\N	\N
13259	\N	\N	\N	\N	\N	\N
13260	\N	\N	\N	\N	\N	\N
13261	\N	\N	\N	\N	\N	\N
13262	\N	\N	\N	\N	\N	\N
13263	\N	\N	\N	\N	\N	\N
13264	\N	\N	\N	\N	\N	\N
13265	\N	\N	\N	\N	\N	\N
13266	\N	\N	\N	\N	\N	\N
13267	\N	\N	\N	\N	\N	\N
13268	\N	\N	\N	\N	\N	\N
13269	\N	\N	\N	\N	\N	\N
13270	\N	\N	\N	\N	\N	\N
13271	\N	\N	\N	\N	\N	\N
13272	\N	\N	\N	\N	\N	\N
13273	\N	\N	\N	\N	\N	\N
13274	\N	\N	\N	\N	\N	\N
13275	\N	\N	\N	\N	\N	\N
13276	\N	\N	\N	\N	\N	\N
13277	\N	\N	\N	\N	\N	\N
13278	\N	\N	\N	\N	\N	\N
13279	\N	\N	\N	\N	\N	\N
13280	\N	\N	\N	\N	\N	\N
13281	\N	\N	\N	\N	\N	\N
13282	\N	\N	\N	\N	\N	\N
13283	\N	\N	\N	\N	\N	\N
13284	\N	\N	\N	\N	\N	\N
13285	\N	\N	\N	\N	\N	\N
13286	\N	\N	\N	\N	\N	\N
13287	\N	\N	\N	\N	\N	\N
13288	\N	\N	\N	\N	\N	\N
13289	\N	\N	\N	\N	\N	\N
13290	\N	\N	\N	\N	\N	\N
13291	\N	\N	\N	\N	\N	\N
13292	\N	\N	\N	\N	\N	\N
13293	\N	\N	\N	\N	\N	\N
13294	\N	\N	\N	\N	\N	\N
13295	\N	\N	\N	\N	\N	\N
13296	\N	\N	\N	\N	\N	\N
13297	\N	\N	\N	\N	\N	\N
13298	\N	\N	\N	\N	\N	\N
13299	\N	\N	\N	\N	\N	\N
13300	\N	\N	\N	\N	\N	\N
13301	\N	\N	\N	\N	\N	\N
13302	\N	\N	\N	\N	\N	\N
13303	\N	\N	\N	\N	\N	\N
13304	\N	\N	\N	\N	\N	\N
13305	\N	\N	\N	\N	\N	\N
13306	\N	\N	\N	\N	\N	\N
13307	\N	\N	\N	\N	\N	\N
13308	\N	\N	\N	\N	\N	\N
13309	\N	\N	\N	\N	\N	\N
13310	\N	\N	\N	\N	\N	\N
13311	\N	\N	\N	\N	\N	\N
13312	\N	\N	\N	\N	\N	\N
13313	\N	\N	\N	\N	\N	\N
13314	\N	\N	\N	\N	\N	\N
13315	\N	\N	\N	\N	\N	\N
13316	\N	\N	\N	\N	\N	\N
13317	\N	\N	\N	\N	\N	\N
13318	\N	\N	\N	\N	\N	\N
13319	\N	\N	\N	\N	\N	\N
13320	\N	\N	\N	\N	\N	\N
13321	\N	\N	\N	\N	\N	\N
13322	\N	\N	\N	\N	\N	\N
13323	\N	\N	\N	\N	\N	\N
13324	\N	\N	\N	\N	\N	\N
13325	\N	\N	\N	\N	\N	\N
13326	\N	\N	\N	\N	\N	\N
13327	\N	\N	\N	\N	\N	\N
13328	\N	\N	\N	\N	\N	\N
13329	\N	\N	\N	\N	\N	\N
13330	\N	\N	\N	\N	\N	\N
13331	\N	\N	\N	\N	\N	\N
13332	\N	\N	\N	\N	\N	\N
13333	\N	\N	\N	\N	\N	\N
13334	\N	\N	\N	\N	\N	\N
13335	\N	\N	\N	\N	\N	\N
13336	\N	\N	\N	\N	\N	\N
13337	\N	\N	\N	\N	\N	\N
13338	\N	\N	\N	\N	\N	\N
13339	\N	\N	\N	\N	\N	\N
13340	\N	\N	\N	\N	\N	\N
13341	\N	\N	\N	\N	\N	\N
13342	\N	\N	\N	\N	\N	\N
13343	\N	\N	\N	\N	\N	\N
13344	\N	\N	\N	\N	\N	\N
13345	\N	\N	\N	\N	\N	\N
13346	\N	\N	\N	\N	\N	\N
13347	\N	\N	\N	\N	\N	\N
13348	\N	\N	\N	\N	\N	\N
13349	\N	\N	\N	\N	\N	\N
13350	\N	\N	\N	\N	\N	\N
13351	\N	\N	\N	\N	\N	\N
13352	\N	\N	\N	\N	\N	\N
13353	\N	\N	\N	\N	\N	\N
13354	\N	\N	\N	\N	\N	\N
13355	\N	\N	\N	\N	\N	\N
13356	\N	\N	\N	\N	\N	\N
13357	\N	\N	\N	\N	\N	\N
13358	\N	\N	\N	\N	\N	\N
13359	\N	\N	\N	\N	\N	\N
13360	\N	\N	\N	\N	\N	\N
13361	\N	\N	\N	\N	\N	\N
13362	\N	\N	\N	\N	\N	\N
13363	\N	\N	\N	\N	\N	\N
13364	\N	\N	\N	\N	\N	\N
13365	\N	\N	\N	\N	\N	\N
13366	\N	\N	\N	\N	\N	\N
13367	\N	\N	\N	\N	\N	\N
13368	\N	\N	\N	\N	\N	\N
13369	\N	\N	\N	\N	\N	\N
13370	\N	\N	\N	\N	\N	\N
13371	\N	\N	\N	\N	\N	\N
13372	\N	\N	\N	\N	\N	\N
13373	\N	\N	\N	\N	\N	\N
13374	\N	\N	\N	\N	\N	\N
13375	\N	\N	\N	\N	\N	\N
13376	\N	\N	\N	\N	\N	\N
13377	\N	\N	\N	\N	\N	\N
13378	\N	\N	\N	\N	\N	\N
13379	\N	\N	\N	\N	\N	\N
13380	\N	\N	\N	\N	\N	\N
13381	\N	\N	\N	\N	\N	\N
13382	\N	\N	\N	\N	\N	\N
13383	\N	\N	\N	\N	\N	\N
13384	\N	\N	\N	\N	\N	\N
13385	\N	\N	\N	\N	\N	\N
13386	\N	\N	\N	\N	\N	\N
13387	\N	\N	\N	\N	\N	\N
13388	\N	\N	\N	\N	\N	\N
13389	\N	\N	\N	\N	\N	\N
13390	\N	\N	\N	\N	\N	\N
13391	\N	\N	\N	\N	\N	\N
13392	\N	\N	\N	\N	\N	\N
13393	\N	\N	\N	\N	\N	\N
13394	\N	\N	\N	\N	\N	\N
13395	\N	\N	\N	\N	\N	\N
13396	\N	\N	\N	\N	\N	\N
13397	\N	\N	\N	\N	\N	\N
13398	\N	\N	\N	\N	\N	\N
13399	\N	\N	\N	\N	\N	\N
13400	\N	\N	\N	\N	\N	\N
13401	\N	\N	\N	\N	\N	\N
13402	\N	\N	\N	\N	\N	\N
13403	\N	\N	\N	\N	\N	\N
13404	\N	\N	\N	\N	\N	\N
13405	\N	\N	\N	\N	\N	\N
13406	\N	\N	\N	\N	\N	\N
13407	\N	\N	\N	\N	\N	\N
13408	\N	\N	\N	\N	\N	\N
13409	\N	\N	\N	\N	\N	\N
13410	\N	\N	\N	\N	\N	\N
13411	\N	\N	\N	\N	\N	\N
13412	\N	\N	\N	\N	\N	\N
13413	\N	\N	\N	\N	\N	\N
13414	\N	\N	\N	\N	\N	\N
13415	\N	\N	\N	\N	\N	\N
13416	\N	\N	\N	\N	\N	\N
13417	\N	\N	\N	\N	\N	\N
13418	\N	\N	\N	\N	\N	\N
13419	\N	\N	\N	\N	\N	\N
13420	\N	\N	\N	\N	\N	\N
13421	\N	\N	\N	\N	\N	\N
13422	\N	\N	\N	\N	\N	\N
13423	\N	\N	\N	\N	\N	\N
13424	\N	\N	\N	\N	\N	\N
13425	\N	\N	\N	\N	\N	\N
13426	\N	\N	\N	\N	\N	\N
13427	\N	\N	\N	\N	\N	\N
13428	\N	\N	\N	\N	\N	\N
13429	\N	\N	\N	\N	\N	\N
13430	\N	\N	\N	\N	\N	\N
13431	\N	\N	\N	\N	\N	\N
13432	\N	\N	\N	\N	\N	\N
13433	\N	\N	\N	\N	\N	\N
13434	\N	\N	\N	\N	\N	\N
13435	\N	\N	\N	\N	\N	\N
13436	\N	\N	\N	\N	\N	\N
13437	\N	\N	\N	\N	\N	\N
13438	\N	\N	\N	\N	\N	\N
13439	\N	\N	\N	\N	\N	\N
13440	\N	\N	\N	\N	\N	\N
13441	\N	\N	\N	\N	\N	\N
13442	\N	\N	\N	\N	\N	\N
13443	\N	\N	\N	\N	\N	\N
13444	\N	\N	\N	\N	\N	\N
13445	\N	\N	\N	\N	\N	\N
13446	\N	\N	\N	\N	\N	\N
13447	\N	\N	\N	\N	\N	\N
13448	\N	\N	\N	\N	\N	\N
13449	\N	\N	\N	\N	\N	\N
13450	\N	\N	\N	\N	\N	\N
13451	\N	\N	\N	\N	\N	\N
13452	\N	\N	\N	\N	\N	\N
13453	\N	\N	\N	\N	\N	\N
13454	\N	\N	\N	\N	\N	\N
13455	\N	\N	\N	\N	\N	\N
13456	\N	\N	\N	\N	\N	\N
13457	\N	\N	\N	\N	\N	\N
13458	\N	\N	\N	\N	\N	\N
13459	\N	\N	\N	\N	\N	\N
13460	\N	\N	\N	\N	\N	\N
13461	\N	\N	\N	\N	\N	\N
13462	\N	\N	\N	\N	\N	\N
13463	\N	\N	\N	\N	\N	\N
13464	\N	\N	\N	\N	\N	\N
13465	\N	\N	\N	\N	\N	\N
13466	\N	\N	\N	\N	\N	\N
13467	\N	\N	\N	\N	\N	\N
13468	\N	\N	\N	\N	\N	\N
13469	\N	\N	\N	\N	\N	\N
13470	\N	\N	\N	\N	\N	\N
13471	\N	\N	\N	\N	\N	\N
13472	\N	\N	\N	\N	\N	\N
13473	\N	\N	\N	\N	\N	\N
13474	\N	\N	\N	\N	\N	\N
13475	\N	\N	\N	\N	\N	\N
13476	\N	\N	\N	\N	\N	\N
13477	\N	\N	\N	\N	\N	\N
13478	\N	\N	\N	\N	\N	\N
13479	\N	\N	\N	\N	\N	\N
13480	\N	\N	\N	\N	\N	\N
13481	\N	\N	\N	\N	\N	\N
13482	\N	\N	\N	\N	\N	\N
13483	\N	\N	\N	\N	\N	\N
13484	\N	\N	\N	\N	\N	\N
13485	\N	\N	\N	\N	\N	\N
13486	\N	\N	\N	\N	\N	\N
13487	\N	\N	\N	\N	\N	\N
13488	\N	\N	\N	\N	\N	\N
13489	\N	\N	\N	\N	\N	\N
13490	\N	\N	\N	\N	\N	\N
13491	\N	\N	\N	\N	\N	\N
13492	\N	\N	\N	\N	\N	\N
13493	\N	\N	\N	\N	\N	\N
13494	\N	\N	\N	\N	\N	\N
13495	\N	\N	\N	\N	\N	\N
13496	\N	\N	\N	\N	\N	\N
13497	\N	\N	\N	\N	\N	\N
13498	\N	\N	\N	\N	\N	\N
13499	\N	\N	\N	\N	\N	\N
13500	\N	\N	\N	\N	\N	\N
13501	\N	\N	\N	\N	\N	\N
13502	\N	\N	\N	\N	\N	\N
13503	\N	\N	\N	\N	\N	\N
13504	\N	\N	\N	\N	\N	\N
13505	\N	\N	\N	\N	\N	\N
13506	\N	\N	\N	\N	\N	\N
13507	\N	\N	\N	\N	\N	\N
13508	\N	\N	\N	\N	\N	\N
13509	\N	\N	\N	\N	\N	\N
13510	\N	\N	\N	\N	\N	\N
13511	\N	\N	\N	\N	\N	\N
13512	\N	\N	\N	\N	\N	\N
13513	\N	\N	\N	\N	\N	\N
13514	\N	\N	\N	\N	\N	\N
13515	\N	\N	\N	\N	\N	\N
13516	\N	\N	\N	\N	\N	\N
13517	\N	\N	\N	\N	\N	\N
13518	\N	\N	\N	\N	\N	\N
13519	\N	\N	\N	\N	\N	\N
13520	\N	\N	\N	\N	\N	\N
13521	\N	\N	\N	\N	\N	\N
13522	\N	\N	\N	\N	\N	\N
13523	\N	\N	\N	\N	\N	\N
13524	\N	\N	\N	\N	\N	\N
13525	\N	\N	\N	\N	\N	\N
13526	\N	\N	\N	\N	\N	\N
13527	\N	\N	\N	\N	\N	\N
13528	\N	\N	\N	\N	\N	\N
13529	\N	\N	\N	\N	\N	\N
13530	\N	\N	\N	\N	\N	\N
13531	\N	\N	\N	\N	\N	\N
13532	\N	\N	\N	\N	\N	\N
13533	\N	\N	\N	\N	\N	\N
13534	\N	\N	\N	\N	\N	\N
13535	\N	\N	\N	\N	\N	\N
13536	\N	\N	\N	\N	\N	\N
13537	\N	\N	\N	\N	\N	\N
13538	\N	\N	\N	\N	\N	\N
13539	\N	\N	\N	\N	\N	\N
13540	\N	\N	\N	\N	\N	\N
13541	\N	\N	\N	\N	\N	\N
13542	\N	\N	\N	\N	\N	\N
13543	\N	\N	\N	\N	\N	\N
13544	\N	\N	\N	\N	\N	\N
13545	\N	\N	\N	\N	\N	\N
13546	\N	\N	\N	\N	\N	\N
13547	\N	\N	\N	\N	\N	\N
13548	\N	\N	\N	\N	\N	\N
13549	\N	\N	\N	\N	\N	\N
13550	\N	\N	\N	\N	\N	\N
13551	\N	\N	\N	\N	\N	\N
13552	\N	\N	\N	\N	\N	\N
13553	\N	\N	\N	\N	\N	\N
13554	\N	\N	\N	\N	\N	\N
13555	\N	\N	\N	\N	\N	\N
13556	\N	\N	\N	\N	\N	\N
13557	\N	\N	\N	\N	\N	\N
13558	\N	\N	\N	\N	\N	\N
13559	\N	\N	\N	\N	\N	\N
13560	\N	\N	\N	\N	\N	\N
13561	\N	\N	\N	\N	\N	\N
13562	\N	\N	\N	\N	\N	\N
13563	\N	\N	\N	\N	\N	\N
13564	\N	\N	\N	\N	\N	\N
13565	\N	\N	\N	\N	\N	\N
13566	\N	\N	\N	\N	\N	\N
13567	\N	\N	\N	\N	\N	\N
13568	\N	\N	\N	\N	\N	\N
13569	\N	\N	\N	\N	\N	\N
13570	\N	\N	\N	\N	\N	\N
13571	\N	\N	\N	\N	\N	\N
13572	\N	\N	\N	\N	\N	\N
13573	\N	\N	\N	\N	\N	\N
13574	\N	\N	\N	\N	\N	\N
13575	\N	\N	\N	\N	\N	\N
13576	\N	\N	\N	\N	\N	\N
13577	\N	\N	\N	\N	\N	\N
13578	\N	\N	\N	\N	\N	\N
13579	\N	\N	\N	\N	\N	\N
13580	\N	\N	\N	\N	\N	\N
13581	\N	\N	\N	\N	\N	\N
13582	\N	\N	\N	\N	\N	\N
13583	\N	\N	\N	\N	\N	\N
13584	\N	\N	\N	\N	\N	\N
13585	\N	\N	\N	\N	\N	\N
13586	\N	\N	\N	\N	\N	\N
13587	\N	\N	\N	\N	\N	\N
13588	\N	\N	\N	\N	\N	\N
13589	\N	\N	\N	\N	\N	\N
13590	\N	\N	\N	\N	\N	\N
13591	\N	\N	\N	\N	\N	\N
13592	\N	\N	\N	\N	\N	\N
13593	\N	\N	\N	\N	\N	\N
13594	\N	\N	\N	\N	\N	\N
13595	\N	\N	\N	\N	\N	\N
13596	\N	\N	\N	\N	\N	\N
13597	\N	\N	\N	\N	\N	\N
13598	\N	\N	\N	\N	\N	\N
13599	\N	\N	\N	\N	\N	\N
13600	\N	\N	\N	\N	\N	\N
13601	\N	\N	\N	\N	\N	\N
13602	\N	\N	\N	\N	\N	\N
13603	\N	\N	\N	\N	\N	\N
13604	\N	\N	\N	\N	\N	\N
13605	\N	\N	\N	\N	\N	\N
13606	\N	\N	\N	\N	\N	\N
13607	\N	\N	\N	\N	\N	\N
13608	\N	\N	\N	\N	\N	\N
13609	\N	\N	\N	\N	\N	\N
13610	\N	\N	\N	\N	\N	\N
13611	\N	\N	\N	\N	\N	\N
13612	\N	\N	\N	\N	\N	\N
13613	\N	\N	\N	\N	\N	\N
13614	\N	\N	\N	\N	\N	\N
13615	\N	\N	\N	\N	\N	\N
13616	\N	\N	\N	\N	\N	\N
13617	\N	\N	\N	\N	\N	\N
13618	\N	\N	\N	\N	\N	\N
13619	\N	\N	\N	\N	\N	\N
13620	\N	\N	\N	\N	\N	\N
13621	\N	\N	\N	\N	\N	\N
13622	\N	\N	\N	\N	\N	\N
13623	\N	\N	\N	\N	\N	\N
13624	\N	\N	\N	\N	\N	\N
13625	\N	\N	\N	\N	\N	\N
13626	\N	\N	\N	\N	\N	\N
13627	\N	\N	\N	\N	\N	\N
13628	\N	\N	\N	\N	\N	\N
13629	\N	\N	\N	\N	\N	\N
13630	\N	\N	\N	\N	\N	\N
13631	\N	\N	\N	\N	\N	\N
13632	\N	\N	\N	\N	\N	\N
13633	\N	\N	\N	\N	\N	\N
13634	\N	\N	\N	\N	\N	\N
13635	\N	\N	\N	\N	\N	\N
13636	\N	\N	\N	\N	\N	\N
13637	\N	\N	\N	\N	\N	\N
13638	\N	\N	\N	\N	\N	\N
13639	\N	\N	\N	\N	\N	\N
13640	\N	\N	\N	\N	\N	\N
13641	\N	\N	\N	\N	\N	\N
13642	\N	\N	\N	\N	\N	\N
13643	\N	\N	\N	\N	\N	\N
13644	\N	\N	\N	\N	\N	\N
13645	\N	\N	\N	\N	\N	\N
13646	\N	\N	\N	\N	\N	\N
13647	\N	\N	\N	\N	\N	\N
13648	\N	\N	\N	\N	\N	\N
13649	\N	\N	\N	\N	\N	\N
13650	\N	\N	\N	\N	\N	\N
13651	\N	\N	\N	\N	\N	\N
13652	\N	\N	\N	\N	\N	\N
13653	\N	\N	\N	\N	\N	\N
13654	\N	\N	\N	\N	\N	\N
13655	\N	\N	\N	\N	\N	\N
13656	\N	\N	\N	\N	\N	\N
13657	\N	\N	\N	\N	\N	\N
13658	\N	\N	\N	\N	\N	\N
13659	\N	\N	\N	\N	\N	\N
13660	\N	\N	\N	\N	\N	\N
13661	\N	\N	\N	\N	\N	\N
13662	\N	\N	\N	\N	\N	\N
13663	\N	\N	\N	\N	\N	\N
13664	\N	\N	\N	\N	\N	\N
13665	\N	\N	\N	\N	\N	\N
13666	\N	\N	\N	\N	\N	\N
13667	\N	\N	\N	\N	\N	\N
13668	\N	\N	\N	\N	\N	\N
13669	\N	\N	\N	\N	\N	\N
13670	\N	\N	\N	\N	\N	\N
13671	\N	\N	\N	\N	\N	\N
13672	\N	\N	\N	\N	\N	\N
13673	\N	\N	\N	\N	\N	\N
13674	\N	\N	\N	\N	\N	\N
13675	\N	\N	\N	\N	\N	\N
13676	\N	\N	\N	\N	\N	\N
13677	\N	\N	\N	\N	\N	\N
13678	\N	\N	\N	\N	\N	\N
13679	\N	\N	\N	\N	\N	\N
13680	\N	\N	\N	\N	\N	\N
13681	\N	\N	\N	\N	\N	\N
13682	\N	\N	\N	\N	\N	\N
13683	\N	\N	\N	\N	\N	\N
13684	\N	\N	\N	\N	\N	\N
13685	\N	\N	\N	\N	\N	\N
13686	\N	\N	\N	\N	\N	\N
13687	\N	\N	\N	\N	\N	\N
13688	\N	\N	\N	\N	\N	\N
13689	\N	\N	\N	\N	\N	\N
13690	\N	\N	\N	\N	\N	\N
13691	\N	\N	\N	\N	\N	\N
13692	\N	\N	\N	\N	\N	\N
13693	\N	\N	\N	\N	\N	\N
13694	\N	\N	\N	\N	\N	\N
13695	\N	\N	\N	\N	\N	\N
13696	\N	\N	\N	\N	\N	\N
13697	\N	\N	\N	\N	\N	\N
13698	\N	\N	\N	\N	\N	\N
13699	\N	\N	\N	\N	\N	\N
13700	\N	\N	\N	\N	\N	\N
13701	\N	\N	\N	\N	\N	\N
13702	\N	\N	\N	\N	\N	\N
13703	\N	\N	\N	\N	\N	\N
13704	\N	\N	\N	\N	\N	\N
13705	\N	\N	\N	\N	\N	\N
13706	\N	\N	\N	\N	\N	\N
13707	\N	\N	\N	\N	\N	\N
13708	\N	\N	\N	\N	\N	\N
13709	\N	\N	\N	\N	\N	\N
13710	\N	\N	\N	\N	\N	\N
13711	\N	\N	\N	\N	\N	\N
13712	\N	\N	\N	\N	\N	\N
13713	\N	\N	\N	\N	\N	\N
13714	\N	\N	\N	\N	\N	\N
13715	\N	\N	\N	\N	\N	\N
13716	\N	\N	\N	\N	\N	\N
13717	\N	\N	\N	\N	\N	\N
13718	\N	\N	\N	\N	\N	\N
13719	\N	\N	\N	\N	\N	\N
13720	\N	\N	\N	\N	\N	\N
13721	\N	\N	\N	\N	\N	\N
13722	\N	\N	\N	\N	\N	\N
13723	\N	\N	\N	\N	\N	\N
13724	\N	\N	\N	\N	\N	\N
13725	\N	\N	\N	\N	\N	\N
13726	\N	\N	\N	\N	\N	\N
13727	\N	\N	\N	\N	\N	\N
13728	\N	\N	\N	\N	\N	\N
13729	\N	\N	\N	\N	\N	\N
13730	\N	\N	\N	\N	\N	\N
13731	\N	\N	\N	\N	\N	\N
13732	\N	\N	\N	\N	\N	\N
13733	\N	\N	\N	\N	\N	\N
13734	\N	\N	\N	\N	\N	\N
13735	\N	\N	\N	\N	\N	\N
13736	\N	\N	\N	\N	\N	\N
13737	\N	\N	\N	\N	\N	\N
13738	\N	\N	\N	\N	\N	\N
13739	\N	\N	\N	\N	\N	\N
13740	\N	\N	\N	\N	\N	\N
13741	\N	\N	\N	\N	\N	\N
13742	\N	\N	\N	\N	\N	\N
13743	\N	\N	\N	\N	\N	\N
13744	\N	\N	\N	\N	\N	\N
13745	\N	\N	\N	\N	\N	\N
13746	\N	\N	\N	\N	\N	\N
13747	\N	\N	\N	\N	\N	\N
13748	\N	\N	\N	\N	\N	\N
13749	\N	\N	\N	\N	\N	\N
13750	\N	\N	\N	\N	\N	\N
13751	\N	\N	\N	\N	\N	\N
13752	\N	\N	\N	\N	\N	\N
13753	\N	\N	\N	\N	\N	\N
13754	\N	\N	\N	\N	\N	\N
13755	\N	\N	\N	\N	\N	\N
13756	\N	\N	\N	\N	\N	\N
13757	\N	\N	\N	\N	\N	\N
13758	\N	\N	\N	\N	\N	\N
13759	\N	\N	\N	\N	\N	\N
13760	\N	\N	\N	\N	\N	\N
13761	\N	\N	\N	\N	\N	\N
13762	\N	\N	\N	\N	\N	\N
13763	\N	\N	\N	\N	\N	\N
13764	\N	\N	\N	\N	\N	\N
13765	\N	\N	\N	\N	\N	\N
13766	\N	\N	\N	\N	\N	\N
13767	\N	\N	\N	\N	\N	\N
13768	\N	\N	\N	\N	\N	\N
13769	\N	\N	\N	\N	\N	\N
13770	\N	\N	\N	\N	\N	\N
13771	\N	\N	\N	\N	\N	\N
13772	\N	\N	\N	\N	\N	\N
13773	\N	\N	\N	\N	\N	\N
13774	\N	\N	\N	\N	\N	\N
13775	\N	\N	\N	\N	\N	\N
13776	\N	\N	\N	\N	\N	\N
13777	\N	\N	\N	\N	\N	\N
13778	\N	\N	\N	\N	\N	\N
13779	\N	\N	\N	\N	\N	\N
13780	\N	\N	\N	\N	\N	\N
13781	\N	\N	\N	\N	\N	\N
13782	\N	\N	\N	\N	\N	\N
13783	\N	\N	\N	\N	\N	\N
13784	\N	\N	\N	\N	\N	\N
13785	\N	\N	\N	\N	\N	\N
13786	\N	\N	\N	\N	\N	\N
13787	\N	\N	\N	\N	\N	\N
13788	\N	\N	\N	\N	\N	\N
13789	\N	\N	\N	\N	\N	\N
13790	\N	\N	\N	\N	\N	\N
13791	\N	\N	\N	\N	\N	\N
13792	\N	\N	\N	\N	\N	\N
13793	\N	\N	\N	\N	\N	\N
13794	\N	\N	\N	\N	\N	\N
13795	\N	\N	\N	\N	\N	\N
13796	\N	\N	\N	\N	\N	\N
13797	\N	\N	\N	\N	\N	\N
13798	\N	\N	\N	\N	\N	\N
13799	\N	\N	\N	\N	\N	\N
13800	\N	\N	\N	\N	\N	\N
13801	\N	\N	\N	\N	\N	\N
13802	\N	\N	\N	\N	\N	\N
13803	\N	\N	\N	\N	\N	\N
13804	\N	\N	\N	\N	\N	\N
13805	\N	\N	\N	\N	\N	\N
13806	\N	\N	\N	\N	\N	\N
13807	\N	\N	\N	\N	\N	\N
13808	\N	\N	\N	\N	\N	\N
13809	\N	\N	\N	\N	\N	\N
13810	\N	\N	\N	\N	\N	\N
13811	\N	\N	\N	\N	\N	\N
13812	\N	\N	\N	\N	\N	\N
13813	\N	\N	\N	\N	\N	\N
13814	\N	\N	\N	\N	\N	\N
13815	\N	\N	\N	\N	\N	\N
13816	\N	\N	\N	\N	\N	\N
13817	\N	\N	\N	\N	\N	\N
13818	\N	\N	\N	\N	\N	\N
13819	\N	\N	\N	\N	\N	\N
13820	\N	\N	\N	\N	\N	\N
13821	\N	\N	\N	\N	\N	\N
13822	\N	\N	\N	\N	\N	\N
13823	\N	\N	\N	\N	\N	\N
13824	\N	\N	\N	\N	\N	\N
13825	\N	\N	\N	\N	\N	\N
13826	\N	\N	\N	\N	\N	\N
13827	\N	\N	\N	\N	\N	\N
13828	\N	\N	\N	\N	\N	\N
13829	\N	\N	\N	\N	\N	\N
13830	\N	\N	\N	\N	\N	\N
13831	\N	\N	\N	\N	\N	\N
13832	\N	\N	\N	\N	\N	\N
13833	\N	\N	\N	\N	\N	\N
13834	\N	\N	\N	\N	\N	\N
13835	\N	\N	\N	\N	\N	\N
13836	\N	\N	\N	\N	\N	\N
13837	\N	\N	\N	\N	\N	\N
13838	\N	\N	\N	\N	\N	\N
13839	\N	\N	\N	\N	\N	\N
13840	\N	\N	\N	\N	\N	\N
13841	\N	\N	\N	\N	\N	\N
13842	\N	\N	\N	\N	\N	\N
13843	\N	\N	\N	\N	\N	\N
13844	\N	\N	\N	\N	\N	\N
13845	\N	\N	\N	\N	\N	\N
13846	\N	\N	\N	\N	\N	\N
13847	\N	\N	\N	\N	\N	\N
13848	\N	\N	\N	\N	\N	\N
13849	\N	\N	\N	\N	\N	\N
13850	\N	\N	\N	\N	\N	\N
13851	\N	\N	\N	\N	\N	\N
13852	\N	\N	\N	\N	\N	\N
13853	\N	\N	\N	\N	\N	\N
13854	\N	\N	\N	\N	\N	\N
13855	\N	\N	\N	\N	\N	\N
13856	\N	\N	\N	\N	\N	\N
13857	\N	\N	\N	\N	\N	\N
13858	\N	\N	\N	\N	\N	\N
13859	\N	\N	\N	\N	\N	\N
13860	\N	\N	\N	\N	\N	\N
13861	\N	\N	\N	\N	\N	\N
13862	\N	\N	\N	\N	\N	\N
13863	\N	\N	\N	\N	\N	\N
13864	\N	\N	\N	\N	\N	\N
13865	\N	\N	\N	\N	\N	\N
13866	\N	\N	\N	\N	\N	\N
13867	\N	\N	\N	\N	\N	\N
13868	\N	\N	\N	\N	\N	\N
13869	\N	\N	\N	\N	\N	\N
13870	\N	\N	\N	\N	\N	\N
13871	\N	\N	\N	\N	\N	\N
13872	\N	\N	\N	\N	\N	\N
13873	\N	\N	\N	\N	\N	\N
13874	\N	\N	\N	\N	\N	\N
13875	\N	\N	\N	\N	\N	\N
13876	\N	\N	\N	\N	\N	\N
13877	\N	\N	\N	\N	\N	\N
13878	\N	\N	\N	\N	\N	\N
13879	\N	\N	\N	\N	\N	\N
13880	\N	\N	\N	\N	\N	\N
13881	\N	\N	\N	\N	\N	\N
13882	\N	\N	\N	\N	\N	\N
13883	\N	\N	\N	\N	\N	\N
13884	\N	\N	\N	\N	\N	\N
13885	\N	\N	\N	\N	\N	\N
13886	\N	\N	\N	\N	\N	\N
13887	\N	\N	\N	\N	\N	\N
13888	\N	\N	\N	\N	\N	\N
13889	\N	\N	\N	\N	\N	\N
13890	\N	\N	\N	\N	\N	\N
13891	\N	\N	\N	\N	\N	\N
13892	\N	\N	\N	\N	\N	\N
13893	\N	\N	\N	\N	\N	\N
13894	\N	\N	\N	\N	\N	\N
13895	\N	\N	\N	\N	\N	\N
13896	\N	\N	\N	\N	\N	\N
13897	\N	\N	\N	\N	\N	\N
13898	\N	\N	\N	\N	\N	\N
13899	\N	\N	\N	\N	\N	\N
13900	\N	\N	\N	\N	\N	\N
13901	\N	\N	\N	\N	\N	\N
13902	\N	\N	\N	\N	\N	\N
13903	\N	\N	\N	\N	\N	\N
13904	\N	\N	\N	\N	\N	\N
13905	\N	\N	\N	\N	\N	\N
13906	\N	\N	\N	\N	\N	\N
13907	\N	\N	\N	\N	\N	\N
13908	\N	\N	\N	\N	\N	\N
13909	\N	\N	\N	\N	\N	\N
13910	\N	\N	\N	\N	\N	\N
13911	\N	\N	\N	\N	\N	\N
13912	\N	\N	\N	\N	\N	\N
13913	\N	\N	\N	\N	\N	\N
13914	\N	\N	\N	\N	\N	\N
13915	\N	\N	\N	\N	\N	\N
13916	\N	\N	\N	\N	\N	\N
13917	\N	\N	\N	\N	\N	\N
13918	\N	\N	\N	\N	\N	\N
13919	\N	\N	\N	\N	\N	\N
13920	\N	\N	\N	\N	\N	\N
13921	\N	\N	\N	\N	\N	\N
13922	\N	\N	\N	\N	\N	\N
13923	\N	\N	\N	\N	\N	\N
13924	\N	\N	\N	\N	\N	\N
13925	\N	\N	\N	\N	\N	\N
13926	\N	\N	\N	\N	\N	\N
13927	\N	\N	\N	\N	\N	\N
13928	\N	\N	\N	\N	\N	\N
13929	\N	\N	\N	\N	\N	\N
13930	\N	\N	\N	\N	\N	\N
13931	\N	\N	\N	\N	\N	\N
13932	\N	\N	\N	\N	\N	\N
13933	\N	\N	\N	\N	\N	\N
13934	\N	\N	\N	\N	\N	\N
13935	\N	\N	\N	\N	\N	\N
13936	\N	\N	\N	\N	\N	\N
13937	\N	\N	\N	\N	\N	\N
13938	\N	\N	\N	\N	\N	\N
13939	\N	\N	\N	\N	\N	\N
13940	\N	\N	\N	\N	\N	\N
13941	\N	\N	\N	\N	\N	\N
13942	\N	\N	\N	\N	\N	\N
13943	\N	\N	\N	\N	\N	\N
13944	\N	\N	\N	\N	\N	\N
13945	\N	\N	\N	\N	\N	\N
13946	\N	\N	\N	\N	\N	\N
13947	\N	\N	\N	\N	\N	\N
13948	\N	\N	\N	\N	\N	\N
13949	\N	\N	\N	\N	\N	\N
13950	\N	\N	\N	\N	\N	\N
13951	\N	\N	\N	\N	\N	\N
13952	\N	\N	\N	\N	\N	\N
13953	\N	\N	\N	\N	\N	\N
13954	\N	\N	\N	\N	\N	\N
13955	\N	\N	\N	\N	\N	\N
13956	\N	\N	\N	\N	\N	\N
13957	\N	\N	\N	\N	\N	\N
13958	\N	\N	\N	\N	\N	\N
13959	\N	\N	\N	\N	\N	\N
13960	\N	\N	\N	\N	\N	\N
13961	\N	\N	\N	\N	\N	\N
13962	\N	\N	\N	\N	\N	\N
13963	\N	\N	\N	\N	\N	\N
13964	\N	\N	\N	\N	\N	\N
13965	\N	\N	\N	\N	\N	\N
13966	\N	\N	\N	\N	\N	\N
13967	\N	\N	\N	\N	\N	\N
13968	\N	\N	\N	\N	\N	\N
13969	\N	\N	\N	\N	\N	\N
13970	\N	\N	\N	\N	\N	\N
13971	\N	\N	\N	\N	\N	\N
13972	\N	\N	\N	\N	\N	\N
13973	\N	\N	\N	\N	\N	\N
13974	\N	\N	\N	\N	\N	\N
13975	\N	\N	\N	\N	\N	\N
13976	\N	\N	\N	\N	\N	\N
13977	\N	\N	\N	\N	\N	\N
13978	\N	\N	\N	\N	\N	\N
13979	\N	\N	\N	\N	\N	\N
13980	\N	\N	\N	\N	\N	\N
13981	\N	\N	\N	\N	\N	\N
13982	\N	\N	\N	\N	\N	\N
13983	\N	\N	\N	\N	\N	\N
13984	\N	\N	\N	\N	\N	\N
13985	\N	\N	\N	\N	\N	\N
13986	\N	\N	\N	\N	\N	\N
13987	\N	\N	\N	\N	\N	\N
13988	\N	\N	\N	\N	\N	\N
13989	\N	\N	\N	\N	\N	\N
13990	\N	\N	\N	\N	\N	\N
13991	\N	\N	\N	\N	\N	\N
13992	\N	\N	\N	\N	\N	\N
13993	\N	\N	\N	\N	\N	\N
13994	\N	\N	\N	\N	\N	\N
13995	\N	\N	\N	\N	\N	\N
13996	\N	\N	\N	\N	\N	\N
13997	\N	\N	\N	\N	\N	\N
13998	\N	\N	\N	\N	\N	\N
13999	\N	\N	\N	\N	\N	\N
14000	\N	\N	\N	\N	\N	\N
14001	\N	\N	\N	\N	\N	\N
14002	\N	\N	\N	\N	\N	\N
14003	\N	\N	\N	\N	\N	\N
14004	\N	\N	\N	\N	\N	\N
14005	\N	\N	\N	\N	\N	\N
14006	\N	\N	\N	\N	\N	\N
14007	\N	\N	\N	\N	\N	\N
14008	\N	\N	\N	\N	\N	\N
14009	\N	\N	\N	\N	\N	\N
14010	\N	\N	\N	\N	\N	\N
14011	\N	\N	\N	\N	\N	\N
14012	\N	\N	\N	\N	\N	\N
14013	\N	\N	\N	\N	\N	\N
14014	\N	\N	\N	\N	\N	\N
14015	\N	\N	\N	\N	\N	\N
14016	\N	\N	\N	\N	\N	\N
14017	\N	\N	\N	\N	\N	\N
14018	\N	\N	\N	\N	\N	\N
14019	\N	\N	\N	\N	\N	\N
14020	\N	\N	\N	\N	\N	\N
14021	\N	\N	\N	\N	\N	\N
14022	\N	\N	\N	\N	\N	\N
14023	\N	\N	\N	\N	\N	\N
14024	\N	\N	\N	\N	\N	\N
14025	\N	\N	\N	\N	\N	\N
14026	\N	\N	\N	\N	\N	\N
14027	\N	\N	\N	\N	\N	\N
14028	\N	\N	\N	\N	\N	\N
14029	\N	\N	\N	\N	\N	\N
14030	\N	\N	\N	\N	\N	\N
14031	\N	\N	\N	\N	\N	\N
14032	\N	\N	\N	\N	\N	\N
14033	\N	\N	\N	\N	\N	\N
14034	\N	\N	\N	\N	\N	\N
14035	\N	\N	\N	\N	\N	\N
14036	\N	\N	\N	\N	\N	\N
14037	\N	\N	\N	\N	\N	\N
14038	\N	\N	\N	\N	\N	\N
14039	\N	\N	\N	\N	\N	\N
14040	\N	\N	\N	\N	\N	\N
14041	\N	\N	\N	\N	\N	\N
14042	\N	\N	\N	\N	\N	\N
14043	\N	\N	\N	\N	\N	\N
14044	\N	\N	\N	\N	\N	\N
14045	\N	\N	\N	\N	\N	\N
14046	\N	\N	\N	\N	\N	\N
14047	\N	\N	\N	\N	\N	\N
14048	\N	\N	\N	\N	\N	\N
14049	\N	\N	\N	\N	\N	\N
14050	\N	\N	\N	\N	\N	\N
14051	\N	\N	\N	\N	\N	\N
14052	\N	\N	\N	\N	\N	\N
14053	\N	\N	\N	\N	\N	\N
14054	\N	\N	\N	\N	\N	\N
14055	\N	\N	\N	\N	\N	\N
14056	\N	\N	\N	\N	\N	\N
14057	\N	\N	\N	\N	\N	\N
14058	\N	\N	\N	\N	\N	\N
14059	\N	\N	\N	\N	\N	\N
14060	\N	\N	\N	\N	\N	\N
14061	\N	\N	\N	\N	\N	\N
14062	\N	\N	\N	\N	\N	\N
14063	\N	\N	\N	\N	\N	\N
14064	\N	\N	\N	\N	\N	\N
14065	\N	\N	\N	\N	\N	\N
14066	\N	\N	\N	\N	\N	\N
14067	\N	\N	\N	\N	\N	\N
14068	\N	\N	\N	\N	\N	\N
14069	\N	\N	\N	\N	\N	\N
14070	\N	\N	\N	\N	\N	\N
14071	\N	\N	\N	\N	\N	\N
14072	\N	\N	\N	\N	\N	\N
14073	\N	\N	\N	\N	\N	\N
14074	\N	\N	\N	\N	\N	\N
14075	\N	\N	\N	\N	\N	\N
14076	\N	\N	\N	\N	\N	\N
14077	\N	\N	\N	\N	\N	\N
14078	\N	\N	\N	\N	\N	\N
14079	\N	\N	\N	\N	\N	\N
14080	\N	\N	\N	\N	\N	\N
14081	\N	\N	\N	\N	\N	\N
14082	\N	\N	\N	\N	\N	\N
14083	\N	\N	\N	\N	\N	\N
14084	\N	\N	\N	\N	\N	\N
14085	\N	\N	\N	\N	\N	\N
14086	\N	\N	\N	\N	\N	\N
14087	\N	\N	\N	\N	\N	\N
14088	\N	\N	\N	\N	\N	\N
14089	\N	\N	\N	\N	\N	\N
14090	\N	\N	\N	\N	\N	\N
14091	\N	\N	\N	\N	\N	\N
14092	\N	\N	\N	\N	\N	\N
14093	\N	\N	\N	\N	\N	\N
14094	\N	\N	\N	\N	\N	\N
14095	\N	\N	\N	\N	\N	\N
14096	\N	\N	\N	\N	\N	\N
14097	\N	\N	\N	\N	\N	\N
14098	\N	\N	\N	\N	\N	\N
14099	\N	\N	\N	\N	\N	\N
14100	\N	\N	\N	\N	\N	\N
14101	\N	\N	\N	\N	\N	\N
14102	\N	\N	\N	\N	\N	\N
14103	\N	\N	\N	\N	\N	\N
14104	\N	\N	\N	\N	\N	\N
14105	\N	\N	\N	\N	\N	\N
14106	\N	\N	\N	\N	\N	\N
14107	\N	\N	\N	\N	\N	\N
14108	\N	\N	\N	\N	\N	\N
14109	\N	\N	\N	\N	\N	\N
14110	\N	\N	\N	\N	\N	\N
14111	\N	\N	\N	\N	\N	\N
14112	\N	\N	\N	\N	\N	\N
14113	\N	\N	\N	\N	\N	\N
14114	\N	\N	\N	\N	\N	\N
14115	\N	\N	\N	\N	\N	\N
14116	\N	\N	\N	\N	\N	\N
14117	\N	\N	\N	\N	\N	\N
14118	\N	\N	\N	\N	\N	\N
14119	\N	\N	\N	\N	\N	\N
14120	\N	\N	\N	\N	\N	\N
14121	\N	\N	\N	\N	\N	\N
14122	\N	\N	\N	\N	\N	\N
14123	\N	\N	\N	\N	\N	\N
14124	\N	\N	\N	\N	\N	\N
14125	\N	\N	\N	\N	\N	\N
14126	\N	\N	\N	\N	\N	\N
14127	\N	\N	\N	\N	\N	\N
14128	\N	\N	\N	\N	\N	\N
14129	\N	\N	\N	\N	\N	\N
14130	\N	\N	\N	\N	\N	\N
14131	\N	\N	\N	\N	\N	\N
14132	\N	\N	\N	\N	\N	\N
14133	\N	\N	\N	\N	\N	\N
14134	\N	\N	\N	\N	\N	\N
14135	\N	\N	\N	\N	\N	\N
14136	\N	\N	\N	\N	\N	\N
14137	\N	\N	\N	\N	\N	\N
14138	\N	\N	\N	\N	\N	\N
14139	\N	\N	\N	\N	\N	\N
14140	\N	\N	\N	\N	\N	\N
14141	\N	\N	\N	\N	\N	\N
14142	\N	\N	\N	\N	\N	\N
14143	\N	\N	\N	\N	\N	\N
14144	\N	\N	\N	\N	\N	\N
14145	\N	\N	\N	\N	\N	\N
14146	\N	\N	\N	\N	\N	\N
14147	\N	\N	\N	\N	\N	\N
14148	\N	\N	\N	\N	\N	\N
14149	\N	\N	\N	\N	\N	\N
14150	\N	\N	\N	\N	\N	\N
14151	\N	\N	\N	\N	\N	\N
14152	\N	\N	\N	\N	\N	\N
14153	\N	\N	\N	\N	\N	\N
14154	\N	\N	\N	\N	\N	\N
14155	\N	\N	\N	\N	\N	\N
14156	\N	\N	\N	\N	\N	\N
14157	\N	\N	\N	\N	\N	\N
14158	\N	\N	\N	\N	\N	\N
14159	\N	\N	\N	\N	\N	\N
14160	\N	\N	\N	\N	\N	\N
14161	\N	\N	\N	\N	\N	\N
14162	\N	\N	\N	\N	\N	\N
14163	\N	\N	\N	\N	\N	\N
14164	\N	\N	\N	\N	\N	\N
14165	\N	\N	\N	\N	\N	\N
14166	\N	\N	\N	\N	\N	\N
14167	\N	\N	\N	\N	\N	\N
14168	\N	\N	\N	\N	\N	\N
14169	\N	\N	\N	\N	\N	\N
14170	\N	\N	\N	\N	\N	\N
14171	\N	\N	\N	\N	\N	\N
14172	\N	\N	\N	\N	\N	\N
14173	\N	\N	\N	\N	\N	\N
14174	\N	\N	\N	\N	\N	\N
14175	\N	\N	\N	\N	\N	\N
14176	\N	\N	\N	\N	\N	\N
14177	\N	\N	\N	\N	\N	\N
14178	\N	\N	\N	\N	\N	\N
14179	\N	\N	\N	\N	\N	\N
14180	\N	\N	\N	\N	\N	\N
14181	\N	\N	\N	\N	\N	\N
14182	\N	\N	\N	\N	\N	\N
14183	\N	\N	\N	\N	\N	\N
14184	\N	\N	\N	\N	\N	\N
14185	\N	\N	\N	\N	\N	\N
14186	\N	\N	\N	\N	\N	\N
14187	\N	\N	\N	\N	\N	\N
14188	\N	\N	\N	\N	\N	\N
14189	\N	\N	\N	\N	\N	\N
14190	\N	\N	\N	\N	\N	\N
14191	\N	\N	\N	\N	\N	\N
14192	\N	\N	\N	\N	\N	\N
14193	\N	\N	\N	\N	\N	\N
14194	\N	\N	\N	\N	\N	\N
14195	\N	\N	\N	\N	\N	\N
14196	\N	\N	\N	\N	\N	\N
14197	\N	\N	\N	\N	\N	\N
14198	\N	\N	\N	\N	\N	\N
14199	\N	\N	\N	\N	\N	\N
14200	\N	\N	\N	\N	\N	\N
14201	\N	\N	\N	\N	\N	\N
14202	\N	\N	\N	\N	\N	\N
14203	\N	\N	\N	\N	\N	\N
14204	\N	\N	\N	\N	\N	\N
14205	\N	\N	\N	\N	\N	\N
14206	\N	\N	\N	\N	\N	\N
14207	\N	\N	\N	\N	\N	\N
14208	\N	\N	\N	\N	\N	\N
14209	\N	\N	\N	\N	\N	\N
14210	\N	\N	\N	\N	\N	\N
14211	\N	\N	\N	\N	\N	\N
14212	\N	\N	\N	\N	\N	\N
14213	\N	\N	\N	\N	\N	\N
14214	\N	\N	\N	\N	\N	\N
14215	\N	\N	\N	\N	\N	\N
14216	\N	\N	\N	\N	\N	\N
14217	\N	\N	\N	\N	\N	\N
14218	\N	\N	\N	\N	\N	\N
14219	\N	\N	\N	\N	\N	\N
14220	\N	\N	\N	\N	\N	\N
14221	\N	\N	\N	\N	\N	\N
14222	\N	\N	\N	\N	\N	\N
14223	\N	\N	\N	\N	\N	\N
14224	\N	\N	\N	\N	\N	\N
14225	\N	\N	\N	\N	\N	\N
14226	\N	\N	\N	\N	\N	\N
14227	\N	\N	\N	\N	\N	\N
14228	\N	\N	\N	\N	\N	\N
14229	\N	\N	\N	\N	\N	\N
14230	\N	\N	\N	\N	\N	\N
14231	\N	\N	\N	\N	\N	\N
14232	\N	\N	\N	\N	\N	\N
14233	\N	\N	\N	\N	\N	\N
14234	\N	\N	\N	\N	\N	\N
14235	\N	\N	\N	\N	\N	\N
14236	\N	\N	\N	\N	\N	\N
14237	\N	\N	\N	\N	\N	\N
14238	\N	\N	\N	\N	\N	\N
14239	\N	\N	\N	\N	\N	\N
14240	\N	\N	\N	\N	\N	\N
14241	\N	\N	\N	\N	\N	\N
14242	\N	\N	\N	\N	\N	\N
14243	\N	\N	\N	\N	\N	\N
14244	\N	\N	\N	\N	\N	\N
14245	\N	\N	\N	\N	\N	\N
14246	\N	\N	\N	\N	\N	\N
14247	\N	\N	\N	\N	\N	\N
14248	\N	\N	\N	\N	\N	\N
14249	\N	\N	\N	\N	\N	\N
14250	\N	\N	\N	\N	\N	\N
14251	\N	\N	\N	\N	\N	\N
14252	\N	\N	\N	\N	\N	\N
14253	\N	\N	\N	\N	\N	\N
14254	\N	\N	\N	\N	\N	\N
14255	\N	\N	\N	\N	\N	\N
14256	\N	\N	\N	\N	\N	\N
14257	\N	\N	\N	\N	\N	\N
14258	\N	\N	\N	\N	\N	\N
14259	\N	\N	\N	\N	\N	\N
14260	\N	\N	\N	\N	\N	\N
14261	\N	\N	\N	\N	\N	\N
14262	\N	\N	\N	\N	\N	\N
14263	\N	\N	\N	\N	\N	\N
14264	\N	\N	\N	\N	\N	\N
14265	\N	\N	\N	\N	\N	\N
14266	\N	\N	\N	\N	\N	\N
14267	\N	\N	\N	\N	\N	\N
14268	\N	\N	\N	\N	\N	\N
14269	\N	\N	\N	\N	\N	\N
14270	\N	\N	\N	\N	\N	\N
14271	\N	\N	\N	\N	\N	\N
14272	\N	\N	\N	\N	\N	\N
14273	\N	\N	\N	\N	\N	\N
14274	\N	\N	\N	\N	\N	\N
14275	\N	\N	\N	\N	\N	\N
14276	\N	\N	\N	\N	\N	\N
14277	\N	\N	\N	\N	\N	\N
14278	\N	\N	\N	\N	\N	\N
14279	\N	\N	\N	\N	\N	\N
14280	\N	\N	\N	\N	\N	\N
14281	\N	\N	\N	\N	\N	\N
14282	\N	\N	\N	\N	\N	\N
14283	\N	\N	\N	\N	\N	\N
14284	\N	\N	\N	\N	\N	\N
14285	\N	\N	\N	\N	\N	\N
14286	\N	\N	\N	\N	\N	\N
14287	\N	\N	\N	\N	\N	\N
14288	\N	\N	\N	\N	\N	\N
14289	\N	\N	\N	\N	\N	\N
14290	\N	\N	\N	\N	\N	\N
14291	\N	\N	\N	\N	\N	\N
14292	\N	\N	\N	\N	\N	\N
14293	\N	\N	\N	\N	\N	\N
14294	\N	\N	\N	\N	\N	\N
14295	\N	\N	\N	\N	\N	\N
14296	\N	\N	\N	\N	\N	\N
14297	\N	\N	\N	\N	\N	\N
14298	\N	\N	\N	\N	\N	\N
14299	\N	\N	\N	\N	\N	\N
14300	\N	\N	\N	\N	\N	\N
14301	\N	\N	\N	\N	\N	\N
14302	\N	\N	\N	\N	\N	\N
14303	\N	\N	\N	\N	\N	\N
14304	\N	\N	\N	\N	\N	\N
14305	\N	\N	\N	\N	\N	\N
14306	\N	\N	\N	\N	\N	\N
14307	\N	\N	\N	\N	\N	\N
14308	\N	\N	\N	\N	\N	\N
14309	\N	\N	\N	\N	\N	\N
14310	\N	\N	\N	\N	\N	\N
14311	\N	\N	\N	\N	\N	\N
14312	\N	\N	\N	\N	\N	\N
14313	\N	\N	\N	\N	\N	\N
14314	\N	\N	\N	\N	\N	\N
14315	\N	\N	\N	\N	\N	\N
14316	\N	\N	\N	\N	\N	\N
14317	\N	\N	\N	\N	\N	\N
14318	\N	\N	\N	\N	\N	\N
14319	\N	\N	\N	\N	\N	\N
14320	\N	\N	\N	\N	\N	\N
14321	\N	\N	\N	\N	\N	\N
14322	\N	\N	\N	\N	\N	\N
14323	\N	\N	\N	\N	\N	\N
14324	\N	\N	\N	\N	\N	\N
14325	\N	\N	\N	\N	\N	\N
14326	\N	\N	\N	\N	\N	\N
14327	\N	\N	\N	\N	\N	\N
14328	\N	\N	\N	\N	\N	\N
14329	\N	\N	\N	\N	\N	\N
14330	\N	\N	\N	\N	\N	\N
14331	\N	\N	\N	\N	\N	\N
14332	\N	\N	\N	\N	\N	\N
14333	\N	\N	\N	\N	\N	\N
14334	\N	\N	\N	\N	\N	\N
14335	\N	\N	\N	\N	\N	\N
14336	\N	\N	\N	\N	\N	\N
14337	\N	\N	\N	\N	\N	\N
14338	\N	\N	\N	\N	\N	\N
14339	\N	\N	\N	\N	\N	\N
14340	\N	\N	\N	\N	\N	\N
14341	\N	\N	\N	\N	\N	\N
14342	\N	\N	\N	\N	\N	\N
14343	\N	\N	\N	\N	\N	\N
14344	\N	\N	\N	\N	\N	\N
14345	\N	\N	\N	\N	\N	\N
14346	\N	\N	\N	\N	\N	\N
14347	\N	\N	\N	\N	\N	\N
14348	\N	\N	\N	\N	\N	\N
14349	\N	\N	\N	\N	\N	\N
14350	\N	\N	\N	\N	\N	\N
14351	\N	\N	\N	\N	\N	\N
14352	\N	\N	\N	\N	\N	\N
14353	\N	\N	\N	\N	\N	\N
14354	\N	\N	\N	\N	\N	\N
14355	\N	\N	\N	\N	\N	\N
14356	\N	\N	\N	\N	\N	\N
14357	\N	\N	\N	\N	\N	\N
14358	\N	\N	\N	\N	\N	\N
14359	\N	\N	\N	\N	\N	\N
14360	\N	\N	\N	\N	\N	\N
14361	\N	\N	\N	\N	\N	\N
14362	\N	\N	\N	\N	\N	\N
14363	\N	\N	\N	\N	\N	\N
14364	\N	\N	\N	\N	\N	\N
14365	\N	\N	\N	\N	\N	\N
14366	\N	\N	\N	\N	\N	\N
14367	\N	\N	\N	\N	\N	\N
14368	\N	\N	\N	\N	\N	\N
14369	\N	\N	\N	\N	\N	\N
14370	\N	\N	\N	\N	\N	\N
14371	\N	\N	\N	\N	\N	\N
14372	\N	\N	\N	\N	\N	\N
14373	\N	\N	\N	\N	\N	\N
14374	\N	\N	\N	\N	\N	\N
14375	\N	\N	\N	\N	\N	\N
14376	\N	\N	\N	\N	\N	\N
14377	\N	\N	\N	\N	\N	\N
14378	\N	\N	\N	\N	\N	\N
14379	\N	\N	\N	\N	\N	\N
14380	\N	\N	\N	\N	\N	\N
14381	\N	\N	\N	\N	\N	\N
14382	\N	\N	\N	\N	\N	\N
14383	\N	\N	\N	\N	\N	\N
14384	\N	\N	\N	\N	\N	\N
14385	\N	\N	\N	\N	\N	\N
14386	\N	\N	\N	\N	\N	\N
14387	\N	\N	\N	\N	\N	\N
14388	\N	\N	\N	\N	\N	\N
14389	\N	\N	\N	\N	\N	\N
14390	\N	\N	\N	\N	\N	\N
14391	\N	\N	\N	\N	\N	\N
14392	\N	\N	\N	\N	\N	\N
14393	\N	\N	\N	\N	\N	\N
14394	\N	\N	\N	\N	\N	\N
14395	\N	\N	\N	\N	\N	\N
14396	\N	\N	\N	\N	\N	\N
14397	\N	\N	\N	\N	\N	\N
14398	\N	\N	\N	\N	\N	\N
14399	\N	\N	\N	\N	\N	\N
14400	\N	\N	\N	\N	\N	\N
14401	\N	\N	\N	\N	\N	\N
14402	\N	\N	\N	\N	\N	\N
14403	\N	\N	\N	\N	\N	\N
14404	\N	\N	\N	\N	\N	\N
14405	\N	\N	\N	\N	\N	\N
14406	\N	\N	\N	\N	\N	\N
14407	\N	\N	\N	\N	\N	\N
14408	\N	\N	\N	\N	\N	\N
14409	\N	\N	\N	\N	\N	\N
14410	\N	\N	\N	\N	\N	\N
14411	\N	\N	\N	\N	\N	\N
14412	\N	\N	\N	\N	\N	\N
14413	\N	\N	\N	\N	\N	\N
14414	\N	\N	\N	\N	\N	\N
14415	\N	\N	\N	\N	\N	\N
14416	\N	\N	\N	\N	\N	\N
14417	\N	\N	\N	\N	\N	\N
14418	\N	\N	\N	\N	\N	\N
14419	\N	\N	\N	\N	\N	\N
14420	\N	\N	\N	\N	\N	\N
14421	\N	\N	\N	\N	\N	\N
14422	\N	\N	\N	\N	\N	\N
14423	\N	\N	\N	\N	\N	\N
14424	\N	\N	\N	\N	\N	\N
14425	\N	\N	\N	\N	\N	\N
14426	\N	\N	\N	\N	\N	\N
14427	\N	\N	\N	\N	\N	\N
14428	\N	\N	\N	\N	\N	\N
14429	\N	\N	\N	\N	\N	\N
14430	\N	\N	\N	\N	\N	\N
14431	\N	\N	\N	\N	\N	\N
14432	\N	\N	\N	\N	\N	\N
14433	\N	\N	\N	\N	\N	\N
14434	\N	\N	\N	\N	\N	\N
14435	\N	\N	\N	\N	\N	\N
14436	\N	\N	\N	\N	\N	\N
14437	\N	\N	\N	\N	\N	\N
14438	\N	\N	\N	\N	\N	\N
14439	\N	\N	\N	\N	\N	\N
14440	\N	\N	\N	\N	\N	\N
14441	\N	\N	\N	\N	\N	\N
14442	\N	\N	\N	\N	\N	\N
14443	\N	\N	\N	\N	\N	\N
14444	\N	\N	\N	\N	\N	\N
14445	\N	\N	\N	\N	\N	\N
14446	\N	\N	\N	\N	\N	\N
14447	\N	\N	\N	\N	\N	\N
14448	\N	\N	\N	\N	\N	\N
14449	\N	\N	\N	\N	\N	\N
14450	\N	\N	\N	\N	\N	\N
14451	\N	\N	\N	\N	\N	\N
14452	\N	\N	\N	\N	\N	\N
14453	\N	\N	\N	\N	\N	\N
14454	\N	\N	\N	\N	\N	\N
14455	\N	\N	\N	\N	\N	\N
14456	\N	\N	\N	\N	\N	\N
14457	\N	\N	\N	\N	\N	\N
14458	\N	\N	\N	\N	\N	\N
14459	\N	\N	\N	\N	\N	\N
14460	\N	\N	\N	\N	\N	\N
14461	\N	\N	\N	\N	\N	\N
14462	\N	\N	\N	\N	\N	\N
14463	\N	\N	\N	\N	\N	\N
14464	\N	\N	\N	\N	\N	\N
14465	\N	\N	\N	\N	\N	\N
14466	\N	\N	\N	\N	\N	\N
14467	\N	\N	\N	\N	\N	\N
14468	\N	\N	\N	\N	\N	\N
14469	\N	\N	\N	\N	\N	\N
14470	\N	\N	\N	\N	\N	\N
14471	\N	\N	\N	\N	\N	\N
14472	\N	\N	\N	\N	\N	\N
14473	\N	\N	\N	\N	\N	\N
14474	\N	\N	\N	\N	\N	\N
14475	\N	\N	\N	\N	\N	\N
14476	\N	\N	\N	\N	\N	\N
14477	\N	\N	\N	\N	\N	\N
14478	\N	\N	\N	\N	\N	\N
14479	\N	\N	\N	\N	\N	\N
14480	\N	\N	\N	\N	\N	\N
14481	\N	\N	\N	\N	\N	\N
14482	\N	\N	\N	\N	\N	\N
14483	\N	\N	\N	\N	\N	\N
14484	\N	\N	\N	\N	\N	\N
14485	\N	\N	\N	\N	\N	\N
14486	\N	\N	\N	\N	\N	\N
14487	\N	\N	\N	\N	\N	\N
14488	\N	\N	\N	\N	\N	\N
14489	\N	\N	\N	\N	\N	\N
14490	\N	\N	\N	\N	\N	\N
14491	\N	\N	\N	\N	\N	\N
14492	\N	\N	\N	\N	\N	\N
14493	\N	\N	\N	\N	\N	\N
14494	\N	\N	\N	\N	\N	\N
14495	\N	\N	\N	\N	\N	\N
14496	\N	\N	\N	\N	\N	\N
14497	\N	\N	\N	\N	\N	\N
14498	\N	\N	\N	\N	\N	\N
14499	\N	\N	\N	\N	\N	\N
14500	\N	\N	\N	\N	\N	\N
14501	\N	\N	\N	\N	\N	\N
14502	\N	\N	\N	\N	\N	\N
14503	\N	\N	\N	\N	\N	\N
14504	\N	\N	\N	\N	\N	\N
14505	\N	\N	\N	\N	\N	\N
14506	\N	\N	\N	\N	\N	\N
14507	\N	\N	\N	\N	\N	\N
14508	\N	\N	\N	\N	\N	\N
14509	\N	\N	\N	\N	\N	\N
14510	\N	\N	\N	\N	\N	\N
14511	\N	\N	\N	\N	\N	\N
14512	\N	\N	\N	\N	\N	\N
14513	\N	\N	\N	\N	\N	\N
14514	\N	\N	\N	\N	\N	\N
14515	\N	\N	\N	\N	\N	\N
14516	\N	\N	\N	\N	\N	\N
14517	\N	\N	\N	\N	\N	\N
14518	\N	\N	\N	\N	\N	\N
14519	\N	\N	\N	\N	\N	\N
14520	\N	\N	\N	\N	\N	\N
14521	\N	\N	\N	\N	\N	\N
14522	\N	\N	\N	\N	\N	\N
14523	\N	\N	\N	\N	\N	\N
14524	\N	\N	\N	\N	\N	\N
14525	\N	\N	\N	\N	\N	\N
14526	\N	\N	\N	\N	\N	\N
14527	\N	\N	\N	\N	\N	\N
14528	\N	\N	\N	\N	\N	\N
14529	\N	\N	\N	\N	\N	\N
14530	\N	\N	\N	\N	\N	\N
14531	\N	\N	\N	\N	\N	\N
14532	\N	\N	\N	\N	\N	\N
14533	\N	\N	\N	\N	\N	\N
14534	\N	\N	\N	\N	\N	\N
14535	\N	\N	\N	\N	\N	\N
14536	\N	\N	\N	\N	\N	\N
14537	\N	\N	\N	\N	\N	\N
14538	\N	\N	\N	\N	\N	\N
14539	\N	\N	\N	\N	\N	\N
14540	\N	\N	\N	\N	\N	\N
14541	\N	\N	\N	\N	\N	\N
14542	\N	\N	\N	\N	\N	\N
14543	\N	\N	\N	\N	\N	\N
14544	\N	\N	\N	\N	\N	\N
14545	\N	\N	\N	\N	\N	\N
14546	\N	\N	\N	\N	\N	\N
14547	\N	\N	\N	\N	\N	\N
14548	\N	\N	\N	\N	\N	\N
14549	\N	\N	\N	\N	\N	\N
14550	\N	\N	\N	\N	\N	\N
14551	\N	\N	\N	\N	\N	\N
14552	\N	\N	\N	\N	\N	\N
14553	\N	\N	\N	\N	\N	\N
14554	\N	\N	\N	\N	\N	\N
14555	\N	\N	\N	\N	\N	\N
14556	\N	\N	\N	\N	\N	\N
14557	\N	\N	\N	\N	\N	\N
14558	\N	\N	\N	\N	\N	\N
14559	\N	\N	\N	\N	\N	\N
14560	\N	\N	\N	\N	\N	\N
14561	\N	\N	\N	\N	\N	\N
14562	\N	\N	\N	\N	\N	\N
14563	\N	\N	\N	\N	\N	\N
14564	\N	\N	\N	\N	\N	\N
14565	\N	\N	\N	\N	\N	\N
14566	\N	\N	\N	\N	\N	\N
14567	\N	\N	\N	\N	\N	\N
14568	\N	\N	\N	\N	\N	\N
14569	\N	\N	\N	\N	\N	\N
14570	\N	\N	\N	\N	\N	\N
14571	\N	\N	\N	\N	\N	\N
14572	\N	\N	\N	\N	\N	\N
14573	\N	\N	\N	\N	\N	\N
14574	\N	\N	\N	\N	\N	\N
14575	\N	\N	\N	\N	\N	\N
14576	\N	\N	\N	\N	\N	\N
14577	\N	\N	\N	\N	\N	\N
14578	\N	\N	\N	\N	\N	\N
14579	\N	\N	\N	\N	\N	\N
14580	\N	\N	\N	\N	\N	\N
14581	\N	\N	\N	\N	\N	\N
14582	\N	\N	\N	\N	\N	\N
14583	\N	\N	\N	\N	\N	\N
14584	\N	\N	\N	\N	\N	\N
14585	\N	\N	\N	\N	\N	\N
14586	\N	\N	\N	\N	\N	\N
14587	\N	\N	\N	\N	\N	\N
14588	\N	\N	\N	\N	\N	\N
14589	\N	\N	\N	\N	\N	\N
14590	\N	\N	\N	\N	\N	\N
14591	\N	\N	\N	\N	\N	\N
14592	\N	\N	\N	\N	\N	\N
14593	\N	\N	\N	\N	\N	\N
14594	\N	\N	\N	\N	\N	\N
14595	\N	\N	\N	\N	\N	\N
14596	\N	\N	\N	\N	\N	\N
14597	\N	\N	\N	\N	\N	\N
14598	\N	\N	\N	\N	\N	\N
14599	\N	\N	\N	\N	\N	\N
14600	\N	\N	\N	\N	\N	\N
14601	\N	\N	\N	\N	\N	\N
14602	\N	\N	\N	\N	\N	\N
14603	\N	\N	\N	\N	\N	\N
14604	\N	\N	\N	\N	\N	\N
14605	\N	\N	\N	\N	\N	\N
14606	\N	\N	\N	\N	\N	\N
14607	\N	\N	\N	\N	\N	\N
14608	\N	\N	\N	\N	\N	\N
14609	\N	\N	\N	\N	\N	\N
14610	\N	\N	\N	\N	\N	\N
14611	\N	\N	\N	\N	\N	\N
14612	\N	\N	\N	\N	\N	\N
14613	\N	\N	\N	\N	\N	\N
14614	\N	\N	\N	\N	\N	\N
14615	\N	\N	\N	\N	\N	\N
14616	\N	\N	\N	\N	\N	\N
14617	\N	\N	\N	\N	\N	\N
14618	\N	\N	\N	\N	\N	\N
14619	\N	\N	\N	\N	\N	\N
14620	\N	\N	\N	\N	\N	\N
14621	\N	\N	\N	\N	\N	\N
14622	\N	\N	\N	\N	\N	\N
14623	\N	\N	\N	\N	\N	\N
14624	\N	\N	\N	\N	\N	\N
14625	\N	\N	\N	\N	\N	\N
14626	\N	\N	\N	\N	\N	\N
14627	\N	\N	\N	\N	\N	\N
14628	\N	\N	\N	\N	\N	\N
14629	\N	\N	\N	\N	\N	\N
14630	\N	\N	\N	\N	\N	\N
14631	\N	\N	\N	\N	\N	\N
14632	\N	\N	\N	\N	\N	\N
14633	\N	\N	\N	\N	\N	\N
14634	\N	\N	\N	\N	\N	\N
14635	\N	\N	\N	\N	\N	\N
14636	\N	\N	\N	\N	\N	\N
14637	\N	\N	\N	\N	\N	\N
14638	\N	\N	\N	\N	\N	\N
14639	\N	\N	\N	\N	\N	\N
14640	\N	\N	\N	\N	\N	\N
14641	\N	\N	\N	\N	\N	\N
14642	\N	\N	\N	\N	\N	\N
14643	\N	\N	\N	\N	\N	\N
14644	\N	\N	\N	\N	\N	\N
14645	\N	\N	\N	\N	\N	\N
14646	\N	\N	\N	\N	\N	\N
14647	\N	\N	\N	\N	\N	\N
14648	\N	\N	\N	\N	\N	\N
14649	\N	\N	\N	\N	\N	\N
14650	\N	\N	\N	\N	\N	\N
14651	\N	\N	\N	\N	\N	\N
14652	\N	\N	\N	\N	\N	\N
14653	\N	\N	\N	\N	\N	\N
14654	\N	\N	\N	\N	\N	\N
14655	\N	\N	\N	\N	\N	\N
14656	\N	\N	\N	\N	\N	\N
14657	\N	\N	\N	\N	\N	\N
14658	\N	\N	\N	\N	\N	\N
14659	\N	\N	\N	\N	\N	\N
14660	\N	\N	\N	\N	\N	\N
14661	\N	\N	\N	\N	\N	\N
14662	\N	\N	\N	\N	\N	\N
14663	\N	\N	\N	\N	\N	\N
14664	\N	\N	\N	\N	\N	\N
14665	\N	\N	\N	\N	\N	\N
14666	\N	\N	\N	\N	\N	\N
14667	\N	\N	\N	\N	\N	\N
14668	\N	\N	\N	\N	\N	\N
14669	\N	\N	\N	\N	\N	\N
14670	\N	\N	\N	\N	\N	\N
14671	\N	\N	\N	\N	\N	\N
14672	\N	\N	\N	\N	\N	\N
14673	\N	\N	\N	\N	\N	\N
14674	\N	\N	\N	\N	\N	\N
14675	\N	\N	\N	\N	\N	\N
14676	\N	\N	\N	\N	\N	\N
14677	\N	\N	\N	\N	\N	\N
14678	\N	\N	\N	\N	\N	\N
14679	\N	\N	\N	\N	\N	\N
14680	\N	\N	\N	\N	\N	\N
14681	\N	\N	\N	\N	\N	\N
14682	\N	\N	\N	\N	\N	\N
14683	\N	\N	\N	\N	\N	\N
14684	\N	\N	\N	\N	\N	\N
14685	\N	\N	\N	\N	\N	\N
14686	\N	\N	\N	\N	\N	\N
14687	\N	\N	\N	\N	\N	\N
14688	\N	\N	\N	\N	\N	\N
14689	\N	\N	\N	\N	\N	\N
14690	\N	\N	\N	\N	\N	\N
14691	\N	\N	\N	\N	\N	\N
14692	\N	\N	\N	\N	\N	\N
14693	\N	\N	\N	\N	\N	\N
14694	\N	\N	\N	\N	\N	\N
14695	\N	\N	\N	\N	\N	\N
14696	\N	\N	\N	\N	\N	\N
14697	\N	\N	\N	\N	\N	\N
14698	\N	\N	\N	\N	\N	\N
14699	\N	\N	\N	\N	\N	\N
14700	\N	\N	\N	\N	\N	\N
14701	\N	\N	\N	\N	\N	\N
14702	\N	\N	\N	\N	\N	\N
14703	\N	\N	\N	\N	\N	\N
14704	\N	\N	\N	\N	\N	\N
14705	\N	\N	\N	\N	\N	\N
14706	\N	\N	\N	\N	\N	\N
14707	\N	\N	\N	\N	\N	\N
14708	\N	\N	\N	\N	\N	\N
14709	\N	\N	\N	\N	\N	\N
14710	\N	\N	\N	\N	\N	\N
14711	\N	\N	\N	\N	\N	\N
14712	\N	\N	\N	\N	\N	\N
14713	\N	\N	\N	\N	\N	\N
14714	\N	\N	\N	\N	\N	\N
14715	\N	\N	\N	\N	\N	\N
14716	\N	\N	\N	\N	\N	\N
14717	\N	\N	\N	\N	\N	\N
14718	\N	\N	\N	\N	\N	\N
14719	\N	\N	\N	\N	\N	\N
14720	\N	\N	\N	\N	\N	\N
14721	\N	\N	\N	\N	\N	\N
14722	\N	\N	\N	\N	\N	\N
14723	\N	\N	\N	\N	\N	\N
14724	\N	\N	\N	\N	\N	\N
14725	\N	\N	\N	\N	\N	\N
14726	\N	\N	\N	\N	\N	\N
14727	\N	\N	\N	\N	\N	\N
14728	\N	\N	\N	\N	\N	\N
14729	\N	\N	\N	\N	\N	\N
14730	\N	\N	\N	\N	\N	\N
14731	\N	\N	\N	\N	\N	\N
14732	\N	\N	\N	\N	\N	\N
14733	\N	\N	\N	\N	\N	\N
14734	\N	\N	\N	\N	\N	\N
14735	\N	\N	\N	\N	\N	\N
14736	\N	\N	\N	\N	\N	\N
14737	\N	\N	\N	\N	\N	\N
14738	\N	\N	\N	\N	\N	\N
14739	\N	\N	\N	\N	\N	\N
14740	\N	\N	\N	\N	\N	\N
14741	\N	\N	\N	\N	\N	\N
14742	\N	\N	\N	\N	\N	\N
14743	\N	\N	\N	\N	\N	\N
14744	\N	\N	\N	\N	\N	\N
14745	\N	\N	\N	\N	\N	\N
14746	\N	\N	\N	\N	\N	\N
14747	\N	\N	\N	\N	\N	\N
14748	\N	\N	\N	\N	\N	\N
14749	\N	\N	\N	\N	\N	\N
14750	\N	\N	\N	\N	\N	\N
14751	\N	\N	\N	\N	\N	\N
14752	\N	\N	\N	\N	\N	\N
14753	\N	\N	\N	\N	\N	\N
14754	\N	\N	\N	\N	\N	\N
14755	\N	\N	\N	\N	\N	\N
14756	\N	\N	\N	\N	\N	\N
14757	\N	\N	\N	\N	\N	\N
14758	\N	\N	\N	\N	\N	\N
14759	\N	\N	\N	\N	\N	\N
14760	\N	\N	\N	\N	\N	\N
14761	\N	\N	\N	\N	\N	\N
14762	\N	\N	\N	\N	\N	\N
14763	\N	\N	\N	\N	\N	\N
14764	\N	\N	\N	\N	\N	\N
14765	\N	\N	\N	\N	\N	\N
14766	\N	\N	\N	\N	\N	\N
14767	\N	\N	\N	\N	\N	\N
14768	\N	\N	\N	\N	\N	\N
14769	\N	\N	\N	\N	\N	\N
14770	\N	\N	\N	\N	\N	\N
14771	\N	\N	\N	\N	\N	\N
14772	\N	\N	\N	\N	\N	\N
14773	\N	\N	\N	\N	\N	\N
14774	\N	\N	\N	\N	\N	\N
14775	\N	\N	\N	\N	\N	\N
14776	\N	\N	\N	\N	\N	\N
14777	\N	\N	\N	\N	\N	\N
14778	\N	\N	\N	\N	\N	\N
14779	\N	\N	\N	\N	\N	\N
14780	\N	\N	\N	\N	\N	\N
14781	\N	\N	\N	\N	\N	\N
14782	\N	\N	\N	\N	\N	\N
14783	\N	\N	\N	\N	\N	\N
14784	\N	\N	\N	\N	\N	\N
14785	\N	\N	\N	\N	\N	\N
14786	\N	\N	\N	\N	\N	\N
14787	\N	\N	\N	\N	\N	\N
14788	\N	\N	\N	\N	\N	\N
14789	\N	\N	\N	\N	\N	\N
14790	\N	\N	\N	\N	\N	\N
14791	\N	\N	\N	\N	\N	\N
14792	\N	\N	\N	\N	\N	\N
14793	\N	\N	\N	\N	\N	\N
14794	\N	\N	\N	\N	\N	\N
14795	\N	\N	\N	\N	\N	\N
14796	\N	\N	\N	\N	\N	\N
14797	\N	\N	\N	\N	\N	\N
14798	\N	\N	\N	\N	\N	\N
14799	\N	\N	\N	\N	\N	\N
14800	\N	\N	\N	\N	\N	\N
14801	\N	\N	\N	\N	\N	\N
14802	\N	\N	\N	\N	\N	\N
14803	\N	\N	\N	\N	\N	\N
14804	\N	\N	\N	\N	\N	\N
14805	\N	\N	\N	\N	\N	\N
14806	\N	\N	\N	\N	\N	\N
14807	\N	\N	\N	\N	\N	\N
14808	\N	\N	\N	\N	\N	\N
14809	\N	\N	\N	\N	\N	\N
14810	\N	\N	\N	\N	\N	\N
14811	\N	\N	\N	\N	\N	\N
14812	\N	\N	\N	\N	\N	\N
14813	\N	\N	\N	\N	\N	\N
14814	\N	\N	\N	\N	\N	\N
14815	\N	\N	\N	\N	\N	\N
14816	\N	\N	\N	\N	\N	\N
14817	\N	\N	\N	\N	\N	\N
14818	\N	\N	\N	\N	\N	\N
14819	\N	\N	\N	\N	\N	\N
14820	\N	\N	\N	\N	\N	\N
14821	\N	\N	\N	\N	\N	\N
14822	\N	\N	\N	\N	\N	\N
14823	\N	\N	\N	\N	\N	\N
14824	\N	\N	\N	\N	\N	\N
14825	\N	\N	\N	\N	\N	\N
14826	\N	\N	\N	\N	\N	\N
14827	\N	\N	\N	\N	\N	\N
14828	\N	\N	\N	\N	\N	\N
14829	\N	\N	\N	\N	\N	\N
14830	\N	\N	\N	\N	\N	\N
14831	\N	\N	\N	\N	\N	\N
14832	\N	\N	\N	\N	\N	\N
14833	\N	\N	\N	\N	\N	\N
14834	\N	\N	\N	\N	\N	\N
14835	\N	\N	\N	\N	\N	\N
14836	\N	\N	\N	\N	\N	\N
14837	\N	\N	\N	\N	\N	\N
14838	\N	\N	\N	\N	\N	\N
14839	\N	\N	\N	\N	\N	\N
14840	\N	\N	\N	\N	\N	\N
14841	\N	\N	\N	\N	\N	\N
14842	\N	\N	\N	\N	\N	\N
14843	\N	\N	\N	\N	\N	\N
14844	\N	\N	\N	\N	\N	\N
14845	\N	\N	\N	\N	\N	\N
14846	\N	\N	\N	\N	\N	\N
14847	\N	\N	\N	\N	\N	\N
14848	\N	\N	\N	\N	\N	\N
14849	\N	\N	\N	\N	\N	\N
14850	\N	\N	\N	\N	\N	\N
14851	\N	\N	\N	\N	\N	\N
14852	\N	\N	\N	\N	\N	\N
14853	\N	\N	\N	\N	\N	\N
14854	\N	\N	\N	\N	\N	\N
14855	\N	\N	\N	\N	\N	\N
14856	\N	\N	\N	\N	\N	\N
14857	\N	\N	\N	\N	\N	\N
14858	\N	\N	\N	\N	\N	\N
14859	\N	\N	\N	\N	\N	\N
14860	\N	\N	\N	\N	\N	\N
14861	\N	\N	\N	\N	\N	\N
14862	\N	\N	\N	\N	\N	\N
14863	\N	\N	\N	\N	\N	\N
14864	\N	\N	\N	\N	\N	\N
14865	\N	\N	\N	\N	\N	\N
14866	\N	\N	\N	\N	\N	\N
14867	\N	\N	\N	\N	\N	\N
14868	\N	\N	\N	\N	\N	\N
14869	\N	\N	\N	\N	\N	\N
14870	\N	\N	\N	\N	\N	\N
14871	\N	\N	\N	\N	\N	\N
14872	\N	\N	\N	\N	\N	\N
14873	\N	\N	\N	\N	\N	\N
14874	\N	\N	\N	\N	\N	\N
14875	\N	\N	\N	\N	\N	\N
14876	\N	\N	\N	\N	\N	\N
14877	\N	\N	\N	\N	\N	\N
14878	\N	\N	\N	\N	\N	\N
14879	\N	\N	\N	\N	\N	\N
14880	\N	\N	\N	\N	\N	\N
14881	\N	\N	\N	\N	\N	\N
14882	\N	\N	\N	\N	\N	\N
14883	\N	\N	\N	\N	\N	\N
14884	\N	\N	\N	\N	\N	\N
14885	\N	\N	\N	\N	\N	\N
14886	\N	\N	\N	\N	\N	\N
14887	\N	\N	\N	\N	\N	\N
14888	\N	\N	\N	\N	\N	\N
14889	\N	\N	\N	\N	\N	\N
14890	\N	\N	\N	\N	\N	\N
14891	\N	\N	\N	\N	\N	\N
14892	\N	\N	\N	\N	\N	\N
14893	\N	\N	\N	\N	\N	\N
14894	\N	\N	\N	\N	\N	\N
14895	\N	\N	\N	\N	\N	\N
14896	\N	\N	\N	\N	\N	\N
14897	\N	\N	\N	\N	\N	\N
14898	\N	\N	\N	\N	\N	\N
14899	\N	\N	\N	\N	\N	\N
14900	\N	\N	\N	\N	\N	\N
14901	\N	\N	\N	\N	\N	\N
14902	\N	\N	\N	\N	\N	\N
14903	\N	\N	\N	\N	\N	\N
14904	\N	\N	\N	\N	\N	\N
14905	\N	\N	\N	\N	\N	\N
14906	\N	\N	\N	\N	\N	\N
14907	\N	\N	\N	\N	\N	\N
14908	\N	\N	\N	\N	\N	\N
14909	\N	\N	\N	\N	\N	\N
14910	\N	\N	\N	\N	\N	\N
14911	\N	\N	\N	\N	\N	\N
14912	\N	\N	\N	\N	\N	\N
14913	\N	\N	\N	\N	\N	\N
14914	\N	\N	\N	\N	\N	\N
14915	\N	\N	\N	\N	\N	\N
14916	\N	\N	\N	\N	\N	\N
14917	\N	\N	\N	\N	\N	\N
14918	\N	\N	\N	\N	\N	\N
14919	\N	\N	\N	\N	\N	\N
14920	\N	\N	\N	\N	\N	\N
14921	\N	\N	\N	\N	\N	\N
14922	\N	\N	\N	\N	\N	\N
14923	\N	\N	\N	\N	\N	\N
14924	\N	\N	\N	\N	\N	\N
14925	\N	\N	\N	\N	\N	\N
14926	\N	\N	\N	\N	\N	\N
14927	\N	\N	\N	\N	\N	\N
14928	\N	\N	\N	\N	\N	\N
14929	\N	\N	\N	\N	\N	\N
14930	\N	\N	\N	\N	\N	\N
14931	\N	\N	\N	\N	\N	\N
14932	\N	\N	\N	\N	\N	\N
14933	\N	\N	\N	\N	\N	\N
14934	\N	\N	\N	\N	\N	\N
14935	\N	\N	\N	\N	\N	\N
14936	\N	\N	\N	\N	\N	\N
14937	\N	\N	\N	\N	\N	\N
14938	\N	\N	\N	\N	\N	\N
14939	\N	\N	\N	\N	\N	\N
14940	\N	\N	\N	\N	\N	\N
14941	\N	\N	\N	\N	\N	\N
14942	\N	\N	\N	\N	\N	\N
14943	\N	\N	\N	\N	\N	\N
14944	\N	\N	\N	\N	\N	\N
14945	\N	\N	\N	\N	\N	\N
14946	\N	\N	\N	\N	\N	\N
14947	\N	\N	\N	\N	\N	\N
14948	\N	\N	\N	\N	\N	\N
14949	\N	\N	\N	\N	\N	\N
14950	\N	\N	\N	\N	\N	\N
14951	\N	\N	\N	\N	\N	\N
14952	\N	\N	\N	\N	\N	\N
14953	\N	\N	\N	\N	\N	\N
14954	\N	\N	\N	\N	\N	\N
14955	\N	\N	\N	\N	\N	\N
14956	\N	\N	\N	\N	\N	\N
14957	\N	\N	\N	\N	\N	\N
14958	\N	\N	\N	\N	\N	\N
14959	\N	\N	\N	\N	\N	\N
14960	\N	\N	\N	\N	\N	\N
14961	\N	\N	\N	\N	\N	\N
14962	\N	\N	\N	\N	\N	\N
14963	\N	\N	\N	\N	\N	\N
14964	\N	\N	\N	\N	\N	\N
14965	\N	\N	\N	\N	\N	\N
14966	\N	\N	\N	\N	\N	\N
14967	\N	\N	\N	\N	\N	\N
14968	\N	\N	\N	\N	\N	\N
14969	\N	\N	\N	\N	\N	\N
14970	\N	\N	\N	\N	\N	\N
14971	\N	\N	\N	\N	\N	\N
14972	\N	\N	\N	\N	\N	\N
14973	\N	\N	\N	\N	\N	\N
14974	\N	\N	\N	\N	\N	\N
14975	\N	\N	\N	\N	\N	\N
14976	\N	\N	\N	\N	\N	\N
14977	\N	\N	\N	\N	\N	\N
14978	\N	\N	\N	\N	\N	\N
14979	\N	\N	\N	\N	\N	\N
14980	\N	\N	\N	\N	\N	\N
14981	\N	\N	\N	\N	\N	\N
14982	\N	\N	\N	\N	\N	\N
14983	\N	\N	\N	\N	\N	\N
14984	\N	\N	\N	\N	\N	\N
14985	\N	\N	\N	\N	\N	\N
14986	\N	\N	\N	\N	\N	\N
14987	\N	\N	\N	\N	\N	\N
14988	\N	\N	\N	\N	\N	\N
14989	\N	\N	\N	\N	\N	\N
14990	\N	\N	\N	\N	\N	\N
14991	\N	\N	\N	\N	\N	\N
14992	\N	\N	\N	\N	\N	\N
14993	\N	\N	\N	\N	\N	\N
14994	\N	\N	\N	\N	\N	\N
14995	\N	\N	\N	\N	\N	\N
14996	\N	\N	\N	\N	\N	\N
14997	\N	\N	\N	\N	\N	\N
14998	\N	\N	\N	\N	\N	\N
14999	\N	\N	\N	\N	\N	\N
15000	\N	\N	\N	\N	\N	\N
15001	\N	\N	\N	\N	\N	\N
15002	\N	\N	\N	\N	\N	\N
15003	\N	\N	\N	\N	\N	\N
15004	\N	\N	\N	\N	\N	\N
15005	\N	\N	\N	\N	\N	\N
15006	\N	\N	\N	\N	\N	\N
15007	\N	\N	\N	\N	\N	\N
15008	\N	\N	\N	\N	\N	\N
15009	\N	\N	\N	\N	\N	\N
15010	\N	\N	\N	\N	\N	\N
15011	\N	\N	\N	\N	\N	\N
15012	\N	\N	\N	\N	\N	\N
15013	\N	\N	\N	\N	\N	\N
15014	\N	\N	\N	\N	\N	\N
15015	\N	\N	\N	\N	\N	\N
15016	\N	\N	\N	\N	\N	\N
15017	\N	\N	\N	\N	\N	\N
15018	\N	\N	\N	\N	\N	\N
15019	\N	\N	\N	\N	\N	\N
15020	\N	\N	\N	\N	\N	\N
15021	\N	\N	\N	\N	\N	\N
15022	\N	\N	\N	\N	\N	\N
15023	\N	\N	\N	\N	\N	\N
15024	\N	\N	\N	\N	\N	\N
15025	\N	\N	\N	\N	\N	\N
15026	\N	\N	\N	\N	\N	\N
15027	\N	\N	\N	\N	\N	\N
15028	\N	\N	\N	\N	\N	\N
15029	\N	\N	\N	\N	\N	\N
15030	\N	\N	\N	\N	\N	\N
15031	\N	\N	\N	\N	\N	\N
15032	\N	\N	\N	\N	\N	\N
15033	\N	\N	\N	\N	\N	\N
15034	\N	\N	\N	\N	\N	\N
15035	\N	\N	\N	\N	\N	\N
15036	\N	\N	\N	\N	\N	\N
15037	\N	\N	\N	\N	\N	\N
15038	\N	\N	\N	\N	\N	\N
15039	\N	\N	\N	\N	\N	\N
15040	\N	\N	\N	\N	\N	\N
15041	\N	\N	\N	\N	\N	\N
15042	\N	\N	\N	\N	\N	\N
15043	\N	\N	\N	\N	\N	\N
15044	\N	\N	\N	\N	\N	\N
15045	\N	\N	\N	\N	\N	\N
15046	\N	\N	\N	\N	\N	\N
15047	\N	\N	\N	\N	\N	\N
15048	\N	\N	\N	\N	\N	\N
15049	\N	\N	\N	\N	\N	\N
15050	\N	\N	\N	\N	\N	\N
15051	\N	\N	\N	\N	\N	\N
15052	\N	\N	\N	\N	\N	\N
15053	\N	\N	\N	\N	\N	\N
15054	\N	\N	\N	\N	\N	\N
15055	\N	\N	\N	\N	\N	\N
15056	\N	\N	\N	\N	\N	\N
15057	\N	\N	\N	\N	\N	\N
15058	\N	\N	\N	\N	\N	\N
15059	\N	\N	\N	\N	\N	\N
15060	\N	\N	\N	\N	\N	\N
15061	\N	\N	\N	\N	\N	\N
15062	\N	\N	\N	\N	\N	\N
15063	\N	\N	\N	\N	\N	\N
15064	\N	\N	\N	\N	\N	\N
15065	\N	\N	\N	\N	\N	\N
15066	\N	\N	\N	\N	\N	\N
15067	\N	\N	\N	\N	\N	\N
15068	\N	\N	\N	\N	\N	\N
15069	\N	\N	\N	\N	\N	\N
15070	\N	\N	\N	\N	\N	\N
15071	\N	\N	\N	\N	\N	\N
15072	\N	\N	\N	\N	\N	\N
15073	\N	\N	\N	\N	\N	\N
15074	\N	\N	\N	\N	\N	\N
15075	\N	\N	\N	\N	\N	\N
15076	\N	\N	\N	\N	\N	\N
15077	\N	\N	\N	\N	\N	\N
15078	\N	\N	\N	\N	\N	\N
15079	\N	\N	\N	\N	\N	\N
15080	\N	\N	\N	\N	\N	\N
15081	\N	\N	\N	\N	\N	\N
15082	\N	\N	\N	\N	\N	\N
15083	\N	\N	\N	\N	\N	\N
15084	\N	\N	\N	\N	\N	\N
15085	\N	\N	\N	\N	\N	\N
15086	\N	\N	\N	\N	\N	\N
15087	\N	\N	\N	\N	\N	\N
15088	\N	\N	\N	\N	\N	\N
15089	\N	\N	\N	\N	\N	\N
15090	\N	\N	\N	\N	\N	\N
15091	\N	\N	\N	\N	\N	\N
15092	\N	\N	\N	\N	\N	\N
15093	\N	\N	\N	\N	\N	\N
15094	\N	\N	\N	\N	\N	\N
15095	\N	\N	\N	\N	\N	\N
15096	\N	\N	\N	\N	\N	\N
15097	\N	\N	\N	\N	\N	\N
15098	\N	\N	\N	\N	\N	\N
15099	\N	\N	\N	\N	\N	\N
15100	\N	\N	\N	\N	\N	\N
15101	\N	\N	\N	\N	\N	\N
15102	\N	\N	\N	\N	\N	\N
15103	\N	\N	\N	\N	\N	\N
15104	\N	\N	\N	\N	\N	\N
15105	\N	\N	\N	\N	\N	\N
15106	\N	\N	\N	\N	\N	\N
15107	\N	\N	\N	\N	\N	\N
15108	\N	\N	\N	\N	\N	\N
15109	\N	\N	\N	\N	\N	\N
15110	\N	\N	\N	\N	\N	\N
15111	\N	\N	\N	\N	\N	\N
15112	\N	\N	\N	\N	\N	\N
15113	\N	\N	\N	\N	\N	\N
15114	\N	\N	\N	\N	\N	\N
15115	\N	\N	\N	\N	\N	\N
15116	\N	\N	\N	\N	\N	\N
15117	\N	\N	\N	\N	\N	\N
15118	\N	\N	\N	\N	\N	\N
15119	\N	\N	\N	\N	\N	\N
15120	\N	\N	\N	\N	\N	\N
15121	\N	\N	\N	\N	\N	\N
15122	\N	\N	\N	\N	\N	\N
15123	\N	\N	\N	\N	\N	\N
15124	\N	\N	\N	\N	\N	\N
15125	\N	\N	\N	\N	\N	\N
15126	\N	\N	\N	\N	\N	\N
15127	\N	\N	\N	\N	\N	\N
15128	\N	\N	\N	\N	\N	\N
15129	\N	\N	\N	\N	\N	\N
15130	\N	\N	\N	\N	\N	\N
15131	\N	\N	\N	\N	\N	\N
15132	\N	\N	\N	\N	\N	\N
15133	\N	\N	\N	\N	\N	\N
15134	\N	\N	\N	\N	\N	\N
15135	\N	\N	\N	\N	\N	\N
15136	\N	\N	\N	\N	\N	\N
15137	\N	\N	\N	\N	\N	\N
15138	\N	\N	\N	\N	\N	\N
15139	\N	\N	\N	\N	\N	\N
15140	\N	\N	\N	\N	\N	\N
15141	\N	\N	\N	\N	\N	\N
15142	\N	\N	\N	\N	\N	\N
15143	\N	\N	\N	\N	\N	\N
15144	\N	\N	\N	\N	\N	\N
15145	\N	\N	\N	\N	\N	\N
15146	\N	\N	\N	\N	\N	\N
15147	\N	\N	\N	\N	\N	\N
15148	\N	\N	\N	\N	\N	\N
15149	\N	\N	\N	\N	\N	\N
15150	\N	\N	\N	\N	\N	\N
15151	\N	\N	\N	\N	\N	\N
15152	\N	\N	\N	\N	\N	\N
15153	\N	\N	\N	\N	\N	\N
15154	\N	\N	\N	\N	\N	\N
15155	\N	\N	\N	\N	\N	\N
15156	\N	\N	\N	\N	\N	\N
15157	\N	\N	\N	\N	\N	\N
15158	\N	\N	\N	\N	\N	\N
15159	\N	\N	\N	\N	\N	\N
15160	\N	\N	\N	\N	\N	\N
15161	\N	\N	\N	\N	\N	\N
15162	\N	\N	\N	\N	\N	\N
15163	\N	\N	\N	\N	\N	\N
15164	\N	\N	\N	\N	\N	\N
15165	\N	\N	\N	\N	\N	\N
15166	\N	\N	\N	\N	\N	\N
15167	\N	\N	\N	\N	\N	\N
15168	\N	\N	\N	\N	\N	\N
15169	\N	\N	\N	\N	\N	\N
15170	\N	\N	\N	\N	\N	\N
15171	\N	\N	\N	\N	\N	\N
15172	\N	\N	\N	\N	\N	\N
15173	\N	\N	\N	\N	\N	\N
15174	\N	\N	\N	\N	\N	\N
15175	\N	\N	\N	\N	\N	\N
15176	\N	\N	\N	\N	\N	\N
15177	\N	\N	\N	\N	\N	\N
15178	\N	\N	\N	\N	\N	\N
15179	\N	\N	\N	\N	\N	\N
15180	\N	\N	\N	\N	\N	\N
15181	\N	\N	\N	\N	\N	\N
15182	\N	\N	\N	\N	\N	\N
15183	\N	\N	\N	\N	\N	\N
15184	\N	\N	\N	\N	\N	\N
15185	\N	\N	\N	\N	\N	\N
15186	\N	\N	\N	\N	\N	\N
15187	\N	\N	\N	\N	\N	\N
15188	\N	\N	\N	\N	\N	\N
15189	\N	\N	\N	\N	\N	\N
15190	\N	\N	\N	\N	\N	\N
15191	\N	\N	\N	\N	\N	\N
15192	\N	\N	\N	\N	\N	\N
15193	\N	\N	\N	\N	\N	\N
15194	\N	\N	\N	\N	\N	\N
15195	\N	\N	\N	\N	\N	\N
15196	\N	\N	\N	\N	\N	\N
15197	\N	\N	\N	\N	\N	\N
15198	\N	\N	\N	\N	\N	\N
15199	\N	\N	\N	\N	\N	\N
15200	\N	\N	\N	\N	\N	\N
15201	\N	\N	\N	\N	\N	\N
15202	\N	\N	\N	\N	\N	\N
15203	\N	\N	\N	\N	\N	\N
15204	\N	\N	\N	\N	\N	\N
15205	\N	\N	\N	\N	\N	\N
15206	\N	\N	\N	\N	\N	\N
15207	\N	\N	\N	\N	\N	\N
15208	\N	\N	\N	\N	\N	\N
15209	\N	\N	\N	\N	\N	\N
15210	\N	\N	\N	\N	\N	\N
15211	\N	\N	\N	\N	\N	\N
15212	\N	\N	\N	\N	\N	\N
15213	\N	\N	\N	\N	\N	\N
15214	\N	\N	\N	\N	\N	\N
15215	\N	\N	\N	\N	\N	\N
15216	\N	\N	\N	\N	\N	\N
15217	\N	\N	\N	\N	\N	\N
15218	\N	\N	\N	\N	\N	\N
15219	\N	\N	\N	\N	\N	\N
15220	\N	\N	\N	\N	\N	\N
15221	\N	\N	\N	\N	\N	\N
15222	\N	\N	\N	\N	\N	\N
15223	\N	\N	\N	\N	\N	\N
15224	\N	\N	\N	\N	\N	\N
15225	\N	\N	\N	\N	\N	\N
15226	\N	\N	\N	\N	\N	\N
15227	\N	\N	\N	\N	\N	\N
15228	\N	\N	\N	\N	\N	\N
15229	\N	\N	\N	\N	\N	\N
15230	\N	\N	\N	\N	\N	\N
15231	\N	\N	\N	\N	\N	\N
15232	\N	\N	\N	\N	\N	\N
15233	\N	\N	\N	\N	\N	\N
15234	\N	\N	\N	\N	\N	\N
15235	\N	\N	\N	\N	\N	\N
15236	\N	\N	\N	\N	\N	\N
15237	\N	\N	\N	\N	\N	\N
15238	\N	\N	\N	\N	\N	\N
15239	\N	\N	\N	\N	\N	\N
15240	\N	\N	\N	\N	\N	\N
15241	\N	\N	\N	\N	\N	\N
15242	\N	\N	\N	\N	\N	\N
15243	\N	\N	\N	\N	\N	\N
15244	\N	\N	\N	\N	\N	\N
15245	\N	\N	\N	\N	\N	\N
15246	\N	\N	\N	\N	\N	\N
15247	\N	\N	\N	\N	\N	\N
15248	\N	\N	\N	\N	\N	\N
15249	\N	\N	\N	\N	\N	\N
15250	\N	\N	\N	\N	\N	\N
15251	\N	\N	\N	\N	\N	\N
15252	\N	\N	\N	\N	\N	\N
15253	\N	\N	\N	\N	\N	\N
15254	\N	\N	\N	\N	\N	\N
15255	\N	\N	\N	\N	\N	\N
15256	\N	\N	\N	\N	\N	\N
15257	\N	\N	\N	\N	\N	\N
15258	\N	\N	\N	\N	\N	\N
15259	\N	\N	\N	\N	\N	\N
15260	\N	\N	\N	\N	\N	\N
15261	\N	\N	\N	\N	\N	\N
15262	\N	\N	\N	\N	\N	\N
15263	\N	\N	\N	\N	\N	\N
15264	\N	\N	\N	\N	\N	\N
15265	\N	\N	\N	\N	\N	\N
15266	\N	\N	\N	\N	\N	\N
15267	\N	\N	\N	\N	\N	\N
15268	\N	\N	\N	\N	\N	\N
15269	\N	\N	\N	\N	\N	\N
15270	\N	\N	\N	\N	\N	\N
15271	\N	\N	\N	\N	\N	\N
15272	\N	\N	\N	\N	\N	\N
15273	\N	\N	\N	\N	\N	\N
15274	\N	\N	\N	\N	\N	\N
15275	\N	\N	\N	\N	\N	\N
15276	\N	\N	\N	\N	\N	\N
15277	\N	\N	\N	\N	\N	\N
15278	\N	\N	\N	\N	\N	\N
15279	\N	\N	\N	\N	\N	\N
15280	\N	\N	\N	\N	\N	\N
15281	\N	\N	\N	\N	\N	\N
15282	\N	\N	\N	\N	\N	\N
15283	\N	\N	\N	\N	\N	\N
15284	\N	\N	\N	\N	\N	\N
15285	\N	\N	\N	\N	\N	\N
15286	\N	\N	\N	\N	\N	\N
15287	\N	\N	\N	\N	\N	\N
15288	\N	\N	\N	\N	\N	\N
15289	\N	\N	\N	\N	\N	\N
15290	\N	\N	\N	\N	\N	\N
15291	\N	\N	\N	\N	\N	\N
15292	\N	\N	\N	\N	\N	\N
15293	\N	\N	\N	\N	\N	\N
15294	\N	\N	\N	\N	\N	\N
15295	\N	\N	\N	\N	\N	\N
15296	\N	\N	\N	\N	\N	\N
15297	\N	\N	\N	\N	\N	\N
15298	\N	\N	\N	\N	\N	\N
15299	\N	\N	\N	\N	\N	\N
15300	\N	\N	\N	\N	\N	\N
15301	\N	\N	\N	\N	\N	\N
15302	\N	\N	\N	\N	\N	\N
15303	\N	\N	\N	\N	\N	\N
15304	\N	\N	\N	\N	\N	\N
15305	\N	\N	\N	\N	\N	\N
15306	\N	\N	\N	\N	\N	\N
15307	\N	\N	\N	\N	\N	\N
15308	\N	\N	\N	\N	\N	\N
15309	\N	\N	\N	\N	\N	\N
15310	\N	\N	\N	\N	\N	\N
15311	\N	\N	\N	\N	\N	\N
15312	\N	\N	\N	\N	\N	\N
15313	\N	\N	\N	\N	\N	\N
15314	\N	\N	\N	\N	\N	\N
15315	\N	\N	\N	\N	\N	\N
15316	\N	\N	\N	\N	\N	\N
15317	\N	\N	\N	\N	\N	\N
15318	\N	\N	\N	\N	\N	\N
15319	\N	\N	\N	\N	\N	\N
15320	\N	\N	\N	\N	\N	\N
15321	\N	\N	\N	\N	\N	\N
15322	\N	\N	\N	\N	\N	\N
15323	\N	\N	\N	\N	\N	\N
15324	\N	\N	\N	\N	\N	\N
15325	\N	\N	\N	\N	\N	\N
15326	\N	\N	\N	\N	\N	\N
15327	\N	\N	\N	\N	\N	\N
15328	\N	\N	\N	\N	\N	\N
15329	\N	\N	\N	\N	\N	\N
15330	\N	\N	\N	\N	\N	\N
15331	\N	\N	\N	\N	\N	\N
15332	\N	\N	\N	\N	\N	\N
15333	\N	\N	\N	\N	\N	\N
15334	\N	\N	\N	\N	\N	\N
15335	\N	\N	\N	\N	\N	\N
15336	\N	\N	\N	\N	\N	\N
15337	\N	\N	\N	\N	\N	\N
15338	\N	\N	\N	\N	\N	\N
15339	\N	\N	\N	\N	\N	\N
15340	\N	\N	\N	\N	\N	\N
15341	\N	\N	\N	\N	\N	\N
15342	\N	\N	\N	\N	\N	\N
15343	\N	\N	\N	\N	\N	\N
15344	\N	\N	\N	\N	\N	\N
15345	\N	\N	\N	\N	\N	\N
15346	\N	\N	\N	\N	\N	\N
15347	\N	\N	\N	\N	\N	\N
15348	\N	\N	\N	\N	\N	\N
15349	\N	\N	\N	\N	\N	\N
15350	\N	\N	\N	\N	\N	\N
15351	\N	\N	\N	\N	\N	\N
15352	\N	\N	\N	\N	\N	\N
15353	\N	\N	\N	\N	\N	\N
15354	\N	\N	\N	\N	\N	\N
15355	\N	\N	\N	\N	\N	\N
15356	\N	\N	\N	\N	\N	\N
15357	\N	\N	\N	\N	\N	\N
15358	\N	\N	\N	\N	\N	\N
15359	\N	\N	\N	\N	\N	\N
15360	\N	\N	\N	\N	\N	\N
15361	\N	\N	\N	\N	\N	\N
15362	\N	\N	\N	\N	\N	\N
15363	\N	\N	\N	\N	\N	\N
15364	\N	\N	\N	\N	\N	\N
15365	\N	\N	\N	\N	\N	\N
15366	\N	\N	\N	\N	\N	\N
15367	\N	\N	\N	\N	\N	\N
15368	\N	\N	\N	\N	\N	\N
15369	\N	\N	\N	\N	\N	\N
15370	\N	\N	\N	\N	\N	\N
15371	\N	\N	\N	\N	\N	\N
15372	\N	\N	\N	\N	\N	\N
15373	\N	\N	\N	\N	\N	\N
15374	\N	\N	\N	\N	\N	\N
15375	\N	\N	\N	\N	\N	\N
15376	\N	\N	\N	\N	\N	\N
15377	\N	\N	\N	\N	\N	\N
15378	\N	\N	\N	\N	\N	\N
15379	\N	\N	\N	\N	\N	\N
15380	\N	\N	\N	\N	\N	\N
15381	\N	\N	\N	\N	\N	\N
15382	\N	\N	\N	\N	\N	\N
15383	\N	\N	\N	\N	\N	\N
15384	\N	\N	\N	\N	\N	\N
15385	\N	\N	\N	\N	\N	\N
15386	\N	\N	\N	\N	\N	\N
15387	\N	\N	\N	\N	\N	\N
15388	\N	\N	\N	\N	\N	\N
15389	\N	\N	\N	\N	\N	\N
15390	\N	\N	\N	\N	\N	\N
15391	\N	\N	\N	\N	\N	\N
15392	\N	\N	\N	\N	\N	\N
15393	\N	\N	\N	\N	\N	\N
15394	\N	\N	\N	\N	\N	\N
15395	\N	\N	\N	\N	\N	\N
15396	\N	\N	\N	\N	\N	\N
15397	\N	\N	\N	\N	\N	\N
15398	\N	\N	\N	\N	\N	\N
15399	\N	\N	\N	\N	\N	\N
15400	\N	\N	\N	\N	\N	\N
15401	\N	\N	\N	\N	\N	\N
15402	\N	\N	\N	\N	\N	\N
15403	\N	\N	\N	\N	\N	\N
15404	\N	\N	\N	\N	\N	\N
15405	\N	\N	\N	\N	\N	\N
15406	\N	\N	\N	\N	\N	\N
15407	\N	\N	\N	\N	\N	\N
15408	\N	\N	\N	\N	\N	\N
15409	\N	\N	\N	\N	\N	\N
15410	\N	\N	\N	\N	\N	\N
15411	\N	\N	\N	\N	\N	\N
15412	\N	\N	\N	\N	\N	\N
15413	\N	\N	\N	\N	\N	\N
15414	\N	\N	\N	\N	\N	\N
15415	\N	\N	\N	\N	\N	\N
15416	\N	\N	\N	\N	\N	\N
15417	\N	\N	\N	\N	\N	\N
15418	\N	\N	\N	\N	\N	\N
15419	\N	\N	\N	\N	\N	\N
15420	\N	\N	\N	\N	\N	\N
15421	\N	\N	\N	\N	\N	\N
15422	\N	\N	\N	\N	\N	\N
15423	\N	\N	\N	\N	\N	\N
15424	\N	\N	\N	\N	\N	\N
15425	\N	\N	\N	\N	\N	\N
15426	\N	\N	\N	\N	\N	\N
15427	\N	\N	\N	\N	\N	\N
15428	\N	\N	\N	\N	\N	\N
15429	\N	\N	\N	\N	\N	\N
\.

