#! /bin/bash

set -o xtrace


#Executa o cenario 1 - Unico Container
newman run upload-cen1_p.postman_collection.json -n 200000 --delay-request 5 &
newman run upload-cen1_m.postman_collection.json -n 200000 --delay-request 5 &
newman run upload-cen1_g.postman_collection.json -n 200000 --delay-request 5 &

#Executa o cenario 2 - Dois Containeres
newman run upload-cen2_p.postman_collection.json -n 200000 --delay-request 5 &
newman run upload-cen2_m.postman_collection.json -n 200000 --delay-request 5 &
newman run upload-cen2_g.postman_collection.json -n 200000 --delay-request 5 &
   
#Executa carga para processamento
#newman run upload-cen1_p.postman_collection.json --delay-request 5 &
#newman run upload-cen1_m.postman_collection.json --delay-request 5 &
#newman run upload-cen1_g.postman_collection.json --delay-request 5 &

#newman run upload-cen2_p.postman_collection.json --delay-request 5 &
#newman run upload-cen2_m.postman_collection.json --delay-request 5 &
#newman run upload-cen2_g.postman_collection.json --delay-request 5 &


