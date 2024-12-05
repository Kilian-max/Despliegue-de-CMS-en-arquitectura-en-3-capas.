# Implementación de un CMS WordPress en Alta Disponibilidad y Escalabilidad en AWS

## Índice
1. [Introducción](#introducción)


---

## 1. Introducción
---
La clase de ASIR 2º nos han mandado hacer un CMS WordPress en Alta Disponibilidad en AWS con:

Capa 1: Capa pública. Balanceador de carga.
Capa 2: Capa privada. Servidores de Backend + NFS.
Capa 3: Capa privada. Servidor de BBDD.

Este es el manual que he preparado para poder ayudar a la gente explicando paso a paso.

## 2. Creacion de la VPC y las subredes
---
Necesitamos 2 subredes privadas y una pública.

<br>

![Texto alternativo](imagenes/Captura%20desde%202024-12-05%2018-59-01.png)

<br>


Se crean 3 tablas dee enrutamineto, pero solo necesitaremos 2, una para la pública y otra para la privada, pero eso lo veremos más adelante.
Cada subred con su rango de ips.

<br>

![Texto alternativo](imagenes/Captura%20desde%202024-12-05%2018-59-19.png)

<br>

## 3. Creacion de las instancias
---
Ahora nos vamos a la seccion de EC2 para empezar a crear las intancias de cada subred

<br>

![Texto alternativo](imagenes/Captura%20desde%202024-12-05%2019-00-45.png)

<br>

Tenemos que crear un par de claves para poder accceder mediante ssh.
Selecionamos la VPC que hemos creado y la subred a la que va a pertenecer la intancia.

<br>

![Texto alternativo](imagenes/Captura%20desde%202024-12-05%2019-01-08.png)

<br>

Los grupos de seguridad vamos a permitir todo para poder intalar todo correctamente y luego lo cambiaremos para tener mayor seguridad.

<br>

![Texto alternativo](imagenes/Captura%20desde%202024-12-05%2019-02-20.png)

<br>

La creamos al igual que todas las demas.

<br>

![Texto alternativo](imagenes/Captura%20desde%202024-12-05%2019-07-41.png)
![Texto alternativo](imagenes/Captura%20desde%202024-12-05%2019-10-44.png)

<br>

## 4. Creacion de la ip elastica y gateway NAT
---
Creamos una ip elastica y se la asignamos al balanceador.

<br>

![Texto alternativo](imagenes/Captura%20desde%202024-12-05%2019-08-01.png)

<br>

Creamos una gateway NAT, la vinculamos a subred publica para que las redes privadas tengan acceso a intenet para descargar lo necesario.

<br>

![Texto alternativo](imagenes/Captura%20desde%202024-12-05%2019-08-54.png)

<br>

## 5. Tablas de enrutamiento
---
Configuramos la tabla de enrutamineto de las redes publicas

<br>

![Texto alternativo](imagenes/Captura%20desde%202024-12-05%2019-11-55.png)

<br>

Y ahora la tabla de enrutamineto de las redes privadas añadiendo la NAT que hemos creado antes.

<br>

![Texto alternativo](imagenes/Captura%20desde%202024-12-05%2019-11-35.png)

<br>

Así quedaria la el mapa de recursos de la VPC.

<br>

![Texto alternativo](imagenes/Captura%20desde%202024-12-05%2019-12-18.png)

<br>

## 6. Conectarse con ssh
---
Ahora nos vamos a conectar con ssh cogiendo la clave ssh que hemos descargado antes y apuntado a la ip pública del balanceador.

```bash
ssh -i "ssh-wordpress.pem" ubuntu@ec2-54-197-239-192.compute-1.amazonaws.com
```

Y con el `scp` copiaremos la clave ssh para pasarselo al balanceador y desde allí nos podremos conectar a las demás instancias.

```bash
scp -i ssh-wordpress.pem ssh-wordpress.pem ubuntu@ec2-54-197-239-192.compute-1.amazonaws.com:/home/ubuntu
```

Dentro de cada máquina comprovaremos si tienen conexióna internet y se hacen `ping` entre ellas.

Una vez que lo comprovemos pasaremos todos los scripts de aprovisionamiento de las intancias a cada una la suya.

<br>

![Texto alternativo](imagenes/Captura%20desde%202024-12-05%2019-17-59.png)

<br>

## 7. Crear dominio
---
Antes de ejecutar los scripts nos iremos a una página que nos de un dominio gratis como ![MY NO-IP](https://www.noip.com/) y creamos un dominio y le asignamos la ip elástica del balanceador.

<br>

![Texto alternativo](imagenes/captura13.png)

<br>

## 8. Ejecutar los scripts
---
Ejecutaremos los scripts con `sudo sh`.
Y una vez terminen todas las intancias de ejecutar los scripts, nos vamos al navegador y ponemos el nombre del dominio. 

<br>

![Texto alternativo](imagenes/captura14.png)

<br>

## 8. Página Wordpress
---
Una vez terminemos con todos los pasos accederemos a nuestro blog de wordpress.

<br>

![Texto alternativo](imagenes/captura16.png)

<br>

## 9. Cambiar las reglas de seguridad
---
Una vez esté instalado todo tenemos que cambiar las reglas de seguridad evitar problemas.
Esta es las reglas del Balanceador.

<br>

![Texto alternativo](imagenes/captura17.png)

<br>

Esta es las reglas de los Backends + NFS

<br>

![Texto alternativo](imagenes/captura20.png)

<br>

Esta es las reglas de la Bade de Datos.

<br>

![Texto alternativo](imagenes/captura21.png)

<br>

Una vez cambiadas las reglas comprovamos que la página wordpress esté operativa sin fallos y significará que lo hemos hecho todo bien. :)











