import os
import pandas as pd
from dotenv import load_dotenv
from googleapiclient.discovery import build

load_dotenv() 

API_KEY = os.getenv("YOUTUBE_API_KEY")
API_VERSION = 'v3'

youtube = build('youtube', API_VERSION, developerKey=API_KEY)

def get_channel_stats(youtube, channel_id):
    try:
        request = youtube.channels().list(
            part='snippet, statistics',
            id=channel_id
        )
        response = request.execute()

        if response['items']:
            data = dict(
                channel_name=response['items'][0]['snippet']['title'],
                total_subscribers=response['items'][0]['statistics'].get('subscriberCount', 0),
                total_views=response['items'][0]['statistics'].get('viewCount', 0),
                total_videos=response['items'][0]['statistics'].get('videoCount', 0),
            )
            return data
    except Exception as e:
        print(f"Error obteniendo datos para {channel_id}: {e}")
    return None 

# 1. Cargar el CSV de Perú usando el delimitador ';' 
df = pd.read_csv("youtube_data_peru.csv", sep=';', encoding='latin-1')

# 2. Extraer los IDs de la columna 'NAME' 
# El formato es "Nombre @ID", así que dividimos por '@' y tomamos el último elemento
channel_ids = df['NAME'].str.split('@').str[-1].unique()

# 3. Consultar la API de YouTube
channel_stats = []
print(f"Iniciando extracción de {len(channel_ids)} canales...")

for channel_id in channel_ids:
    stats = get_channel_stats(youtube, channel_id)
    if stats is not None:
        channel_stats.append(stats)

# 4. Crear DataFrame con los resultados de la API
stats_df = pd.DataFrame(channel_stats)

# 5. Concatenar y guardar
# Aseguramos que los índices coincidan si planeas unirlos 1 a 1
# Nota: Si algún ID falló en la API, la unión por índice podría desalinearse. 
# Es más seguro unir por el ID del canal si es posible.
combined_df = pd.concat([df.reset_index(drop=True), stats_df.reset_index(drop=True)], axis=1)

# 6. Guardar el resultado final
combined_df.to_csv('updated_youtube_data_peru.csv', index=False)

print("¡Proceso completado! Archivo guardado como 'updated_youtube_data_peru.csv'")
print(combined_df.head(10))