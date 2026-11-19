CREATE DATABASE federacao;

USE federacao;

CREATE TABLE time (
    cnpj_time VARCHAR(14),
    nome_time VARCHAR(30) NOT NULL,
    CONSTRAINT pk_cnpj_time PRIMARY KEY (cnpj_time),
    CONSTRAINT ck_cnpj_time CHECK (REGEXP_LIKE(cnpj_time, '^[0-9]{14}$'))
);

CREATE TABLE patrocinador (
    cnpj_patrocinador VARCHAR(14),
    nome_patrocinador VARCHAR(30) NOT NULL,
    CONSTRAINT pk_cnpj_patrocinador PRIMARY KEY (cnpj_patrocinador),
    CONSTRAINT ck_cnpj_patrocinador CHECK (REGEXP_LIKE(cnpj_patrocinador, '^[0-9]{14}$'))
);

CREATE TABLE time_amador (
    cnpj_time_amador VARCHAR(14),
    nome_presidente VARCHAR(30) NOT NULL,
    cidade_sede VARCHAR(30) NOT NULL,
    ano_fundacao INT NOT NULL,
    CONSTRAINT pk_cnpj_time_amador PRIMARY KEY (cnpj_time_amador),
    CONSTRAINT fk_cnpj_time_amador FOREIGN KEY (cnpj_time_amador) REFERENCES time(cnpj_time)
);

CREATE TABLE time_profissional (
    cnpj_time_profissional VARCHAR(14),
    CONSTRAINT pk_cnpj_time_profissional PRIMARY KEY (cnpj_time_profissional),
    CONSTRAINT fk_cnpj_time_profissional FOREIGN KEY (cnpj_time_profissional) REFERENCES time(cnpj_time)
);

CREATE TABLE time_profissional_patrocinador (
    cnpj_time_profissional VARCHAR(14),
    cnpj_patrocinador VARCHAR(14),
    -- Tabela só pode ter uma PK mas, ela pode ser composta.
    CONSTRAINT pk_cnpj_time_profissional_patrocinador PRIMARY KEY (cnpj_time_profissional, cnpj_patrocinador),
    CONSTRAINT fk_patrocinador_cnpj_time_profissional FOREIGN KEY (cnpj_time_profissional) REFERENCES time_profissional(cnpj_time_profissional),
    CONSTRAINT fk_cnpj_patrocinador FOREIGN KEY (cnpj_patrocinador) REFERENCES patrocinador(cnpj_patrocinador)
);

CREATE TABLE diretor (
    cpf_diretor VARCHAR(11),
    nome_diretor VARCHAR(30) NOT NULL,
    sobrenome_diretor VARCHAR(30) NOT NULL,
    cnpj_time_profissional VARCHAR(14) NOT NULL,
    CONSTRAINT pk_cpf_diretor PRIMARY KEY (cpf_diretor),
    CONSTRAINT ck_cpf_diretor CHECK (REGEXP_LIKE(cpf_diretor, '^[0-9]{11}$')),
    CONSTRAINT fk_diretor_cnpj_time_profissional FOREIGN KEY (cnpj_time_profissional) 
    REFERENCES 
        time_profissional(cnpj_time_profissional)
);

CREATE TABLE uniforme (
    numero_uniforme INT,
    descricao VARCHAR(30) NOT NULL,
    cnpj_time VARCHAR(14) NOT NULL,
    CONSTRAINT pk_numero_uniforme PRIMARY KEY (numero_uniforme, cnpj_time),
    CONSTRAINT ck_numero_uniforme CHECK(numero_uniforme IN (1, 2, 3)),
    CONSTRAINT fk_uniforme_cnpj_time FOREIGN KEY (cnpj_time) REFERENCES time(cnpj_time)
);

CREATE TABLE cor (
    codigo_cor VARCHAR(7),
    nome VARCHAR(30) NOT NULL,
    descricaO VARCHAR (100),
    CONSTRAINT pk_codigo_cor PRIMARY KEY (codigo_cor),
    CONSTRAINT ck_codigo_cor CHECK (REGEXP_LIKE(codigo_cor, '^#[0-9A-Fa-f]{6}$'))
);

CREATE TABLE uniforme_cor (
    cnpj_time VARCHAR(14),
    numero_uniforme INT,
    codigo_cor VARCHAR(7),
    CONSTRAINT pk_uniforme_cor PRIMARY KEY (cnpj_time, numero_uniforme, codigo_cor),
    CONSTRAINT fk_uniforme_cor_time FOREIGN KEY (numero_uniforme, cnpj_time) REFERENCES uniforme(numero_uniforme, cnpj_time),
    CONSTRAINT fk_codigo_cor FOREIGN KEY (codigo_cor) REFERENCES cor(codigo_cor)
);

CREATE TABLE jogador (
    cpf_jogador VARCHAR(11),
    nome_jogador VARCHAR(30) NOT NULL,
    CONSTRAINT pk_cpf_jogador PRIMARY KEY (cpf_jogador),
    CONSTRAINT ck_cpf_jogador CHECK (REGEXP_LIKE(cpf_jogador, '^[0-9]{11}$'))
);

CREATE TABLE time_jogador (
    cnpj_time VARCHAR(14),
    cpf_jogador VARCHAR(11),
    CONSTRAINT pk_time_jogador PRIMARY KEY (cnpj_time, cpf_jogador),
    CONSTRAINT fk_cnpj_time_jogador FOREIGN KEY (cnpj_time) REFERENCES time(cnpj_time),
    CONSTRAINT fk_cpf_jogador_time FOREIGN KEY (cpf_jogador) REFERENCES jogador(cpf_jogador)
);

CREATE TABLE posicao (
    sigla_posicao VARCHAR(3),
    nome_posicao VARCHAR(14) NOT NULL,
    descricao_posicao VARCHAR(30) NOT NULL,
    CONSTRAINT pk_sigla_posicao PRIMARY KEY (sigla_posicao),
    CONSTRAINT ck_sigla_nome_posicao
    CHECK (
            (sigla_posicao = 'GL' AND nome_posicao = 'GOLEIRO') OR
            (sigla_posicao = 'ZAG' AND nome_posicao = 'ZAGUEIRO') OR
            (sigla_posicao = 'LAT' AND nome_posicao = 'LATERAL') OR
            (sigla_posicao = 'VOL' AND nome_posicao = 'VOLANTE') OR
            (sigla_posicao = 'MEI' AND nome_posicao = 'MEIO CAMPO') OR
            (sigla_posicao = 'ATA' AND nome_posicao = 'ATACANTE')
    )
);

CREATE TABLE jogador_posicao (
    cpf_jogador VARCHAR(11),
    sigla_posicao VARCHAR(3),
    CONSTRAINT pk_jogador_posicao PRIMARY KEY (cpf_jogador, sigla_posicao),
    CONSTRAINT fk_cpf_jogador FOREIGN KEY (cpf_jogador) REFERENCES jogador(cpf_jogador),
    CONSTRAINT fk_sigla_posicao FOREIGN KEY (sigla_posicao) REFERENCES posicao(sigla_posicao),
    CONSTRAINT uk_jogador_posicao UNIQUE (cpf_jogador)
);

CREATE TABLE federacao (
    cnpj_federacao VARCHAR(14),
    nome_federacao VARCHAR(30) NOT NULL,
    CONSTRAINT pk_cnpj_federacao PRIMARY KEY (cnpj_federacao),
    CONSTRAINT ck_cnpj_federacao CHECK(REGEXP_LIKE(cnpj_federacao, '^[0-9]{14}$'))
);

CREATE TABLE campeonato (
    sigla_campeonato VARCHAR(7),
    nome_campeonato VARCHAR(30) NOT NULL,
    cnpj_federacao VARCHAR(14),
    CONSTRAINT pk_sigla_campeonato PRIMARY KEY (sigla_campeonato),
    CONSTRAINT fk_cnpj_federacao FOREIGN KEY (cnpj_federacao) REFERENCES federacao(cnpj_federacao)
);

CREATE TABLE arbitro (
    rg_arbitro VARCHAR(11),
    nome_arbitro VARCHAR(30) NOT NULL,
    mae VARCHAR(30),
    CONSTRAINT pk_rg_arbitro PRIMARY KEY (rg_arbitro),
    CONSTRAINT ck_rg_arbitro CHECK(REGEXP_LIKE(rg_arbitro, '^[0-9]{11}$'))
);

CREATE TABLE tipo_habilitacao (
    codigo_habilitacao VARCHAR(10),
    nome VARCHAR(30) NOT NULL,
    descricao VARCHAR(50) NOT NULL,
    CONSTRAINT pk_codigo_habilitacao PRIMARY KEY (codigo_habilitacao)
);

CREATE TABLE arbitro_tipo_habilitacao (
    rg_arbitro VARCHAR(11),
    codigo_habilitacao VARCHAR(10),
    CONSTRAINT pk_arbitro_tipo_habilitacao PRIMARY KEY (rg_arbitro, codigo_habilitacao),
    CONSTRAINT fk_rg_arbitro FOREIGN KEY (rg_arbitro) REFERENCES arbitro(rg_arbitro),
    CONSTRAINT fk_codigo_habilitacao FOREIGN KEY (codigo_habilitacao) REFERENCES tipo_habilitacao(codigo_habilitacao)
);

CREATE TABLE partida (
    numero_partida INT,
    data_partida DATE NOT NULL, 
    local_partida VARCHAR(100) NOT NULL, 
    sigla_campeonato VARCHAR(7),
    edicao_campeonato INT,
    rg_arbitro VARCHAR(11),
    cnpj_time_mandante VARCHAR(14),
    cnpj_time_visitante VARCHAR(14),
    CONSTRAINT pk_partida 
        PRIMARY KEY (
            numero_partida,
            sigla_campeonato, 
            edicao_campeonato, 
            cnpj_time_mandante,
            cnpj_time_visitante
        ),
    CONSTRAINT fk_partida_sigla_campeonato FOREIGN KEY (sigla_campeonato) REFERENCES campeonato(sigla_campeonato),
    CONSTRAINT fk_partida_rg_arbitro FOREIGN KEY (rg_arbitro) REFERENCES arbitro(rg_arbitro),
    CONSTRAINT fk_partida_cnpj_time_mandante FOREIGN KEY (cnpj_time_mandante) REFERENCES time(cnpj_time),
    CONSTRAINT fk_partida_cnpj_time_visitante FOREIGN KEY (cnpj_time_visitante) REFERENCES time(cnpj_time),
    CONSTRAINT ck_times_diferentes CHECK (cnpj_time_mandante <> cnpj_time_visitante)
);

CREATE TABLE partida_jogador (
    numero_partida INT,
    sigla_campeonato VARCHAR(7),
    edicao_campeonato INT,
    cnpj_time_mandante VARCHAR(14),
    cnpj_time_visitante VARCHAR(14),
    cpf_jogador VARCHAR(11),
    gols_pro INT NOT NULL DEFAULT 0,
    gols_contra INT NOT NULL DEFAULT 0,
    
    CONSTRAINT pk_partida_jogador
        PRIMARY KEY (
            numero_partida,
            sigla_campeonato,
            edicao_campeonato,
            cnpj_time_mandante,
            cnpj_time_visitante,
            cpf_jogador
        ),
    CONSTRAINT fk_pj_partida
        FOREIGN KEY (
            numero_partida,
            sigla_campeonato,
            edicao_campeonato,
            cnpj_time_mandante,
            cnpj_time_visitante
        )
        REFERENCES partida (
            numero_partida,
            sigla_campeonato,
            edicao_campeonato,
            cnpj_time_mandante,
            cnpj_time_visitante
        ),
    CONSTRAINT fk_pj_jogador FOREIGN KEY (cpf_jogador) REFERENCES jogador(cpf_jogador),
    CONSTRAINT ck_pj_gols
        CHECK (gols_pro >= 0 AND gols_contra >= 0)
);