function [centroides] = deteccion_de_objetos(im_entrada,umbrales)
%separar imagen en componentes R,G,B
imR = double(im_entrada(:,:,1));
imG = double(im_entrada(:,:,2));
imB = double(im_entrada(:,:,3));

%tamaño imagen
[N,M,Z] = size(im_entrada);

%fondo imagen blanco
Y = ones(N,M);

%umbrales con respecto al objeto a seguir (utilizar photoshop en la funcion
%color range->seleccion color en la imagen->OK->windows->histogram->con
%
%cada color hacer resta de media-desviacion estandar umbral inferior.
%umbral superior media+desviacion estandar
%
%Sintonizar umbrales segun el color (disminuir umbral inferior; subir
%umbral superior)

%asignacion del color en cada pixel de la imagen de entrada
%conforme al umbral T
for i=1:N;
    for j=1:M;
        if((imR(i,j)>umbrales(1) && imR(i,j)<umbrales(2)) && (imG(i,j)>umbrales(3) && imG(i,j)<umbrales(4)) && (imB(i,j)>umbrales(5) && imB(i,j)<umbrales(6)))
            Y(i,j) = 0;
        else
            Y(i,j) = 1;
        end
    end
end

%procedimiento cerradura (2 cosas ditalacion: relleno de superficie,
%erocion: remueve pixeles alrededor de una region)
%estructura morfologica
se = strel('disk',10);%dilatcion en forma de disco
imagen_cerrada = imopen(Y,se);%erocion

%elimina grupos de pixeles menores o iguales al segundo argumento
bw = bwareaopen(imagen_cerrada,35);

%obtencion de centroidez
s = regionprops(bw,'centroid');
centroides = cat(1,s.Centroid);

%escribir centroides en command window para checar centroides
end
