import face_recognition
import os
from fastapi import FastAPI 


app = FastAPI()



def es_imagen_valida(nombre_archivo):
    extension = nombre_archivo.split('.')[-1].lower()
    print(extension)
    return extension not in ['png', 'jpg', 'JPG']

def es_rostro_suficientemente_grande(top, right, bottom, left, umbral_area):
    area = (bottom - top) * (right - left)
    print("area")
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
    global face_knows_globales
    global face_knows_name_globales 
    
    face_knows_globales = []
    face_knows_name_globales = []
    # ... (tu código para cargar imágenes y codificaciones)
    print("Cargando imágenes conocidas...")
    peopleList = os.listdir(dataPath)
    for nameDir in peopleList:
        print("Archivo: ", nameDir)
        print("Resultado: ",es_imagen_valida(nameDir))
        if es_imagen_valida(nameDir) :
            continue
        print("Procesando: ", nameDir)
        personPath = os.path.join(dataPath, nameDir)
        known_i = face_recognition.load_image_file(personPath)
        face_locations = face_recognition.face_locations(known_i)
        for face_location in face_locations:
            print("Procesando...", nameDir)
            img_encoding = face_recognition.face_encodings(known_i, [face_location])[0]
            print("Procesado...", nameDir)
            face_knows_globales.extend(img_encoding)
            face_knows_name_globales.extend(nameDir)
    return {"status": "ok"}

@app.get("/load/photos/{image_name}") 
def cargar_imagenes(image_name: str):
    global face_knows_globales
    global face_knows_name_globales 
    nameDir = f"{image_name}"
    print("Reconociendo..."+nameDir)
    print(len(face_knows_globales))
    if es_imagen_valida(nameDir) :
        print("No se reconoce como valida: "+nameDir)
        {"status": "ok"}
    file_to_scan = os.path.join(dataPath, f"{nameDir}")
    known_i = face_recognition.load_image_file(file_to_scan)
    face_locations = face_recognition.face_locations(known_i)
    for face_location in face_locations:
        img_encoding = face_recognition.face_encodings(known_i, [face_location])[0]
        face_knows_globales.extend(img_encoding)
        face_knows_name_globales.extend(nameDir) 
    print(len(face_knows_globales))
    return {"status": len(face_knows_globales)}


@app.get("/{user_code}") 
def reconocer(user_code: str):
    print("Reconociendo..."+f"{user_code}")
    file_to_scan = os.path.join(dataPathScan, f"{user_code}")
    if not os.path.isfile(file_to_scan):
        return {"persona": "no encontrada"}
    print(len(face_knows_globales))
    unknown_image = face_recognition.load_image_file(file_to_scan)
    unknown_encoding = face_recognition.face_encodings(unknown_image)[0]
    print("Comparando...")
    # Usar las variables globales
    results = face_recognition.compare_faces(face_knows_globales, unknown_encoding, 0.4)
    print("Resultados:")
    try:
        indice = results.index(True)
        return {"persona": face_knows_name_globales[indice]}
    except ValueError:
        return {"persona": "no encontrada"} 
    

# Carga inicial de las imágenes conocidas
cargar_imagenes_conocidas()
