USE federacao;

-- Ranking do time com mais gols 

(SELECT 
    cnpj_time_mandante AS cnpj_time, SUM(gols_pro) AS total_gols
FROM 
    partida_jogador
GROUP BY 
    cnpj_time_mandante
UNION
SELECT 
    cnpj_time_visitante AS cnpj_time, SUM(gols_pro) AS total_gols
FROM 
    partida_jogador
GROUP BY
    cnpj_time_visitante)
ORDER BY 
    total_gols DESC;

-- Calcular a pontuação de cada time em um partida

-- 1. Selecionar o placar de cada partida

    SELECT  
        pj.numero_partida,
        pj.sigla_campeonato,
        pj.edicao_campeonato,
        pj.cnpj_time_mandante,
        pj.cnpj_time_visitante,
        pj.cpf_jogador,
        tj.cnpj_time,
        pj.gols_pro,
        pj.gols_contra
    FROM partida_jogador pj
    INNER JOIN time_jogador tj
        ON pj.cpf_jogador = tj.cpf_jogador;



-- classificação dos clubes por pontos

-- jogadores que participaram de um campeonato 

-- clubes profissionais patrocinados por um determinado patrocinador

-- jogadores que nunca marcaram gols 

-- clubes profissionais que possuem pelo menos 1 patrocinador (EXISTS)

-- times profissionais que não possuem patrocinadores

SELECT t.nome_time
FROM time t
INNER JOIN time_profissional tp 
    ON t.cnpj_time LIKE tp.cnpj_time_profissional;

-- clubes que nunca participaram de partidas como mandante
--     tabelas envolvidas: time, partida

SELECT t.nome_time 
FROM time t LEFT JOIN partida p
    ON t.cnpj_time = p.cnpj_time_mandante
WHERE p.cnpj_time_mandante IS NULL;

-- jogadores que já atuaram como goleiros
--     tabelas envolvidas: jogador, partida_jogador, posicao, jogador_posicao

SELECT cpf_jogador, nome_jogador, tab.sigla_posicao
FROM 
(
     SELECT jp.cpf_jogador, jogador_pj.nome_jogador, jp.sigla_posicao
     FROM jogador_posicao jp INNER JOIN (
        SELECT j.nome_jogador, j.cpf_jogador
        FROM jogador j INNER JOIN partida_jogador pj
            ON j.cpf_jogador = pj.cpf_jogador
        GROUP BY j.cpf_jogador
    ) AS jogador_pj
         ON jp.cpf_jogador = jogador_pj.cpf_jogador
) AS tab WHERE tab.sigla_posicao LIKE 'GL';
    
-- clubes que nunca participaram de uma partida

SELECT times_ativos.nome_time, times_ativos.cnpj_t FROM (
    SELECT t.nome_time, p.cnpj_time_mandante AS cnpj_t
    FROM time t LEFT JOIN partida p
    ON t.cnpj_time = p.cnpj_time_mandante
    GROUP BY t.nome_time, cnpj_t 
    INTERSECT
    SELECT t.nome_time, p.cnpj_time_visitante AS cnpj_t
    FROM time t  LEFT JOIN partida p 
    ON t.cnpj_time = p.cnpj_time_visitante
    GROUP BY t.nome_time, cnpj_t) 
AS times_ativos
WHERE times_ativos.cnpj_t IS NULL;

-- sug. chat
SELECT
    t.nome_time
FROM time t
WHERE NOT EXISTS (
    SELECT 1
    FROM partida p
    WHERE p.cnpj_time_mandante = t.cnpj_time
       OR p.cnpj_time_visitante = t.cnpj_time
);

-- jogadores que já atuaram em pelo menos 2 clubes diferentes

SELECT tab.cpf_jogador, COUNT(t.nome_time) AS total_times
FROM time t INNER JOIN
    (SELECT j.cpf_jogador, j.nome_jogador, tj.cnpj_time
    FROM jogador j 
    INNER JOIN time_jogador tj
        ON j.cpf_jogador = tj.cpf_jogador
    ) AS tab
ON t.cnpj_time = tab.cnpj_time
GROUP BY tab.cpf_jogador
HAVING total_times > 1;

-- clubes que possuem jogadores que nunca participaram de partidas

SELECT t.nome_time
FROM time t INNER JOIN
    (
        SELECT tj.cnpj_time, tab.total_partidas
        FROM time_jogador tj INNER JOIN 
        (
        SELECT j.nome_jogador, j.cpf_jogador, COUNT(numero_partida) AS total_partidas
        FROM jogador j LEFT JOIN partida_jogador pj
            ON j.cpf_jogador = pj.cpf_jogador
        GROUP BY j.cpf_jogador
        ) AS tab 
        ON tj.cpf_jogador = tab.cpf_jogador
    ) AS tab_2
ON t.cnpj_time = tab_2.cnpj_time
WHERE tab_2.total_partidas = 0
GROUP BY t.cnpj_time, t.nome_time;
    




