create database youtube_db;
use youtube_db;

/*
# Pasos de limpieza de datos
1. Eliminar las columnas innecesarias seleccionando solo las que necesitamos.
2. Extraer los nombres de los canales de YouTube de las primeras columnas.
3. Renombrar los nombres de las columnas.
*/
select*from top_pe_youtubers_2025;

select 
	name,
	total_subscribers,
	total_views,
	total_videos
from
 top_pe_youtubers_2025


 --CHARINDEX

 select CHARINDEX('@',name),name from top_pe_youtubers_2025

 --SUBSTRING

 create view view_pe_youtubers_2025 as
 select 
	cast(SUBSTRING(name, 1,CHARINDEX('@',name)-1) as varchar(100)) as channel_name,
	total_subscribers,
	total_views,
	total_videos
from 
	top_pe_youtubers_2025

/*
Pruebas de calidad de datos

1. Conteo de filas: Los datos deben contener 100 registros de canales de YouTube.[aprobado]
2. Conteo de columnas: Los datos deben tener 4 campos (columnas).[aprobado]
3. Verificación de tipos de datos: La columna del nombre del canal debe tener formato de cadena de 
texto (string), y las demás columnas deben ser de tipos de datos numéricos.[aprobado]
4. Verificación de duplicados: Cada registro debe ser único en el conjunto de datos.[aprobado]

Cantidad de filas - 100
cantidad de columnas - 4

tipos de datos
channel_name = varchar
total_subscribers = integer
total_views = integer
total_videos = integer

filas duplicadas = 0
*/


/*
# 1. Verificación del conteo de filas
Cuenta el número total de registros (o filas) que hay en la vista de SQL.
*/
SELECT
    COUNT(*) AS no_of_rows
FROM
    view_pe_youtubers_2025;


/*
# 2. Verificación del conteo de columnas
Cuenta el número total de columnas (o campos) que hay en la vista de SQL.
*/
SELECT
    COUNT(*) AS column_count
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_NAME = 'view_pe_youtubers_2025'

/*
# 3. Verificación de tipos de datos
Verifica los tipos de datos de cada columna de la vista consultando la vista INFORMATION_SCHEMA.
*/
SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_NAME = 'view_pe_youtubers_2025';

/*
# 4. Verificación de registros duplicados
Busca filas duplicadas en la vista.
Agrupa por el nombre del canal (channel name).
Filtra aquellos grupos que tengan más de una fila.
*/

-- 1.
SELECT
    channel_name,
    COUNT(*) AS duplicate_count
FROM
    view_pe_youtubers_2025

-- 2.
GROUP BY
    channel_name

-- 3.
HAVING
    COUNT(*) > 1;
