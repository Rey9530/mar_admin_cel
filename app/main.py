import face_recognition
import os
from fastapi import FastAPI 


app = FastAPI()


def es_rostro_suficientemente_grande(top, right, bottom, left, umbral_area):
    area = (bottom - top) * (right - left)
    print(area)
    return area > umbral_area


dataPath = "./imgs"
dataPathScan = "./imgs_scan"


# Variables globales para almacenar las codificaciones y nombres de las caras conocidas
face_knows_globales = []
face_knows_name_globales = []

# Funciones para cargar imágenes y verificar tamaño del rostro
@app.get("/reload/photos") 
def cargar_imagenes_conocidas():
    face_knows_globales = []
    face_knows_name_globales = []
    # ... (tu código para cargar imágenes y codificaciones)
    
    peopleList = os.listdir(dataPath)
    for nameDir in peopleList:
        if ".png" not in nameDir :
            continue
        personPath = os.path.join(dataPath, nameDir)
        known_i = face_recognition.load_image_file(personPath)
        face_locations = face_recognition.face_locations(known_i)
        for face_location in face_locations:
            img_encoding = face_recognition.face_encodings(known_i, [face_location])[0]
            face_knows_globales.append(img_encoding)
            face_knows_name_globales.append(nameDir)
    return {"status": "ok"}

# Carga inicial de las imágenes conocidas
cargar_imagenes_conocidas()


@app.get("/{user_code}") 
def reconocer(user_code: str):
    file_to_scan = os.path.join(dataPathScan, f"{user_code}.png")
    if not os.path.isfile(file_to_scan):
        return {"persona": "no encontrada"}

    unknown_image = face_recognition.load_image_file(file_to_scan)
    unknown_encoding = face_recognition.face_encodings(unknown_image)[0]

    # Usar las variables globales
    results = face_recognition.compare_faces(face_knows_globales, unknown_encoding, 0.4)
    try:
        indice = results.index(True)
        return {"persona": face_knows_name_globales[indice]}
    except ValueError:
        return {"persona": "no encontrada"} 
    