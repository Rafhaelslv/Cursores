USE master
DROP DATABASE CURSORES
go
CREATE DATABASE CURSORES
GO
USE CURSORES
GO
CREATE TABLE CURSO (
codigo			INT			NOT NULL,
nome			VARCHAR(100)NOT NULL,
duracao			INT			NOT NULL
PRIMARY KEY (codigo)
)
GO

INSERT INTO CURSO VALUES
('48', 'Análise e Desenvolvimento de Sistemas', '2880'),
('51', 'Logistica', '2880'),
('67', 'Polímeros', '2880'),
('73', 'Comércio Exterior', '2600'),
('94', 'Gestão Empresarial', '2600')
GO

CREATE TABLE DISCIPLINAS (
codigo			VARCHAR(50)	NOT NULL,
nome			VARCHAR(100)NOT NULL,
carga_horaria	INT			NOT NULL
PRIMARY KEY (codigo)
)
GO

INSERT INTO DISCIPLINAS VALUES
('ALG001', 'Algoritmos', '80'),
('ADM001' ,'Administração', '80'),
('LHW010' ,'Laboratório de Hardware', '40'),
('LPO001' ,'Pesquisa Operacional', '80'),
('FIS003' ,'Física I', '80'),
('FIS007' ,'Físico Química' ,'80'),
('CMX001' ,'Comércio Exterior' ,'80'),
('MKT002' ,'Fundamentos de Marketing' ,'80'),
('INF001' ,'Informática' ,'40'),
('ASI001' ,'Sistemas de Informação', '80')
GO

CREATE TABLE DISCIPLINA_CURSO (
codigo_Disciplina		VARCHAR(50)	NOT NULL,
codigo_Curso			INT			NOT NULL
PRIMARY KEY (codigo_Disciplina, codigo_Curso),
FOREIGN KEY (codigo_Curso) REFERENCES CURSO (codigo),
FOREIGN KEY (codigo_Disciplina) REFERENCES DISCIPLINAS (codigo)
)
GO

INSERT INTO DISCIPLINA_CURSO VALUES
('ALG001', '48'),
('ADM001', '48'),
('ADM001' ,'51'),
('ADM001', '73'),
('ADM001', '94'),
('LHW010', '48'),
('LPO001', '51'),
('FIS003', '67'),
('FIS007' ,'67'),
('CMX001' ,'51'),
('CMX001' ,'73'),
('MKT002' ,'51'),
('MKT002' ,'94'),
('INF001' ,'51'),
('INF001' ,'73'),
('ASI001' ,'48'),
('ASI001' ,'94')
GO

CREATE FUNCTION fn_curso()
RETURNS @tabela TABLE (
codigo_disciplina			INT			,
nome_disciplina				VARCHAR(100),
carga_horaria_disciplina	INT			,
nome_curso					VARCHAR(100)
)
AS
BEGIN
	DECLARE @cod_curso		INT,
	@codigo_disciplina			INT	,
	@nome_disciplina				VARCHAR(100),
	@carga_horaria_disciplina	INT	,
	@nome_curso					VARCHAR(100)
	DECLARE c CURSOR FOR
		SELECT d.codigo, d.nome, d.carga_horaria, c.nome
		FROM CURSO c
		INNER JOIN DISCIPLINA_CURSO dc on c.codigo = dc.codigo_Curso
		INNER JOIN DISCIPLINAS d on dc.codigo_Disciplina = d.codigo

	OPEN c
	FETCH NEXT FROM c
		INTO @codigo_disciplina,
		@nome_disciplina,
		@carga_horaria_disciplina,
		@nome_curso	

		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO @tabela (codigo_disciplina, nome_disciplina, carga_horaria_disciplina, nome_curso)
        VALUES (@codigo_disciplina, @nome_disciplina, @carga_horaria_disciplina, @nome_curso)

        FETCH NEXT FROM c INTO @codigo_disciplina, @nome_disciplina, @carga_horaria_disciplina, @nome_curso
    END

    CLOSE c
    DEALLOCATE c

    RETURN
END
	
	
SELECT codigo_disciplina, nome_disciplina, carga_horaria, nome_curso
FROM dbo.fn_curso


