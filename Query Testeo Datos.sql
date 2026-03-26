use youtube_db;

/* 
# 1. Definir variables
# 2. Crear una CTE que redondee el promedio de vistas por video
# 3. Seleccionar la columna que necesitas y crear columnas calculadas a partir de las existentes
# 4. Filtrar resultados por canales de YouTube
# 5. Ordenar resultados por ganancias netas (de mayor a menor)
*/

-- 1. 
DECLARE @conversionRate FLOAT = 0.02;		-- The conversion rate @ 2%
DECLARE @productCost FLOAT = 5.0;			-- The product cost @ $5
DECLARE @campaignCost FLOAT = 50000.0;		-- The campaign cost @ $50,000	

-- 2.  
WITH ChannelData AS (
    SELECT 
        channel_name,
        total_views,
        total_videos,
        ROUND((CAST(total_views AS FLOAT) / total_videos), -4) AS rounded_avg_views_per_video
    FROM 
        youtube_db.dbo.view_pe_youtubers_2025
)

-- 3. 
SELECT 
    channel_name,
    rounded_avg_views_per_video,
    (rounded_avg_views_per_video * @conversionRate) AS potential_units_sold_per_video,
    (rounded_avg_views_per_video * @conversionRate * @productCost) AS potential_revenue_per_video,
    ((rounded_avg_views_per_video * @conversionRate * @productCost) - @campaignCost) AS net_profit
FROM 
    ChannelData

-- 4. 
WHERE 
    channel_name in ('RoxiCake Gamer', 'Drawblogs', 'Gravity Play', 'Golemcito Games')    


-- 5.  
ORDER BY
	net_profit DESC